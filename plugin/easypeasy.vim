"===============================================================================
"===============================  EasyPeasy  ===================================
"===============================================================================
" File:				easypeasy.vim
" Author:			Arvydas Sidorenko (asido4 at gmail dot com)
" Last Modified:	August 26, 2011
" Version:			0.1
"
" Overview
" --------
" 	This script parses the source code for included system headers and Generates
" 	an .lvimrc (or whatever you set g:lvimrc_filename) file with 'tags' variable
" 	concatinations.
"
" 	Example of generated .lvimrc:
"		set tags+=~/.vim/tags/getopt.tags
"		set tags+=~/.vim/tags/locale.tags
"		set tags+=~/.vim/tags/stdio.tags
"		set tags+=~/.vim/tags/unistd.tags
"		set tags+=~/.vim/tags/signal.tags
"		set tags+=~/.vim/tags/xcb.tags
"
" Requirements
" ------------
"  1. This program needs Exuberant Ctags to generate the tag files (uses 'ctags' cmd)
"  2. I use VIM v7.3 and haven't tried with other. The script requires at least 700 
"	You will thank me if you are using lower than that.
"
" Installation
" ------------
"	Copy this file to your ~/.vim/plugin and you are ready to go!
"
" Usage
" -----
"	To do the magic, use :EasyPeasy command. This is the only command
"	this script has.
"
" Configuration
" -------------
" NOTE: The provided values are the default ones
"
"	The directory where the script will look ctags generated tag files:
"		let g:tag_directory = "~/.vim/tags/"
"
"	The extension of tag file:
"		let g:tag_extension = ".tags"
"
"	Local vimrc file name:
"		let g:lvimrc_filename = ".lvimrc"
"
"	Paths to the dir of system library headers in case tags file not found
"		let g:include_paths = "/usr/include/,/usr/local/include/"
"
"	0 = show prompts on tags file creation
"	1 = generate the tags file without prompt (sames as answering 'Y' to the prompt)
"	2 = don't generate tag files - use the ones which exist under ~/.vim/tags only
"		let g:prompt_create_tags = 0
"	
" Details
" -------
"	This is how the script works:
"	It parses the files recursively starting from cwd and gets all included
"	files (skips local includes). It will use the first word as library name.
"
"	Example:
"
"	1.	#include <mylib.h>
"
"		Using the statement above, it will try to find mylib.tags file under
"		tags directory (~/.vim/tags). If not found, it will check if /usr/include/mylib.h
"		header exists. If so, it will prompt you if you want to generate
"		~/.vim/tags/mylib.tags file using this header. If no, it will skip it.
"		If yes, it will genearte the tags and include into .lvimrc
"
"	2.	#include <anotherlib/mylib.h>
"
"		In this case it will use the folder name as library name. So it will
"		check if ~/.vim/tags/anotherlib.tags exist. If no, it will check if
"		/usr/include/anotherlib folder exist. If so, it will ask for
"		ask for generating the tags of whole folder headers. The rest is the
"		same as in the first example.
"
"	3.	In case no tags and no headers found
"
"		In this case you'll get prompted to enter the path to the header or
"		folder to use to generate the tags. Empty input will result in
"		skipping this library.
"		NOTE: This sometimes can happen in example on #include <dbus/dbus.h>
"			  when the actual headers path is /usr/include/dbus-1.0/dbus/dbus.h
"
"
" TODO: perhaps in the end generating one big file from all the tag files would be
" more efficient than having a bunch of multiple files each for every lib?
"===============================================================================
"===============================================================================

"===============================================================================
" GUARD
"===============================================================================
if v:version < 700
	finish
endif

if exists('easypeasy')
	finish
endif

let g:easypeasy = 1
"===============================================================================
" END OF GUARD
"===============================================================================

"===============================================================================
" GLOBALS
"===============================================================================
let g:tag_directory = "~/.vim/tags/"
let g:tag_extension = ".tags"
let g:lvimrc_filename = ".lvimrc"
let g:include_paths = "/usr/include/,/usr/local/include/"

" 0 = show prompts
" 1 = generate tags w/o prompt
" 2 = don't generate tags and don't prompt (just use the ones provided under tag_directory)
let g:prompt_create_tags = 0
"===============================================================================
" END OF GLOBALS
"===============================================================================

"===============================================================================
" LOCALS
"===============================================================================
" pattern tables
let s:file_patterns =	{ "c" : '.c$' }
let s:search_patterns =	{ "c" : '\s*#include\s*<' }
let s:crop_patterns =	{ "c" : '.*<\(.*\)>.*' }

let s:cwd = getcwd() . "/"
let s:include_table = []
"===============================================================================
" END OF LOCALS
"===============================================================================

"=================================================
" MAIN function
function! GenerateIncludes()
	" put include paths to table for efficient looping when parsing
	let s:include_table = split(g:include_paths, ",")

	" do we have tags folder under .vim?
	if ! isdirectory(fnamemodify(g:tag_directory, ":p"))
		echo g:tag_directory . " not found. Creating one...\n"
		call mkdir(fnamemodify(g:tag_directory, ":p"))
	endif

	" initialize file manager
	" TODO: proper file filter. automatic detection? first need to extend pattern table though
	let file_mngr = s:FileMngr.New(s:file_patterns["c"])
	call file_mngr.gen_file_tree(s:cwd)
	" at this point file_mngr.files list has all the files in the cwd recursively
	

	" now lets put the Parser to work
	let parser = s:Parser.New(s:search_patterns["c"])
	for file in file_mngr.files
		call parser.parse(file)
	endfor

	" we have the all the included libs in generator.libs now
	let generator = s:Generator.New(s:crop_patterns["c"])
	for line in parser.matches
		call generator.parse(line)
	endfor

	" remove the .lvimrc file if it exists in cwd
	if filereadable(s:cwd . g:lvimrc_filename)
		if delete(s:cwd . g:lvimrc_filename) != 0
			echoerr "Can't overwrite existing " . g:lvimrc_filename . ". "
			echoerr "Check your permissions.\n"
			finish
		endif
	endif

	" and finally do what this script is all about - create .lvimrc with tags
	call writefile(generator.lib_tags, s:cwd . g:lvimrc_filename)

	" and finish with a message
	echo "EasyPeasy: DONE!"
endfunction

"===============================================================================
" CLASS: FileMngr - interacts with hard drive
"===============================================================================
let s:FileMngr = {}

"=================================================
" Constructor:
" Args:	filter - file extension filter
function! s:FileMngr.New(filter)
	let newFileMngr = copy(self)
	let newFileMngr.files = []
	let newFileMngr.filter = a:filter
	return newFileMngr
endfunction

"=================================================
" Function: Generates a file tree
" Args:	path - the root folder
function! s:FileMngr.gen_file_tree(path)
	" get directory files
	let s:files = self.get_folder_files(a:path)
	for file in s:files
		if isdirectory(file)
			" if we find a directory, call this function recursively
			call self.gen_file_tree(file)
		elseif match(file, self.filter) != -1
			" otherwise, just put it among other files in the list
			call add(self.files, file)
		endif
	endfor
endfunction

"=================================================
" Function: Gets the file list of the folder
" Args:	folder - folder to read from
function! s:FileMngr.get_folder_files(folder)
	return split(globpath(a:folder, "*"), "\n")
endfunction
"===============================================================================
" END OF CLASS: FileMngr
"===============================================================================


"===============================================================================
" CLASS: Parser - Parses file contents
"===============================================================================
let s:Parser = {}

"=================================================
" Constructor: 
" Args:	pattern	- include pattern in file
function! s:Parser.New(pattern)
	let newParser = copy(self)
	let newParser.pattern = a:pattern
	let newParser.matches = []	" parse results - matched lines
	return newParser
endfunction

"=================================================
" Function: start parse the files
" Args: file - path to the file parse
function! s:Parser.parse(file)
	let s:lines = readfile(a:file)
	for line in s:lines
		if match(line, self.pattern) != -1
			call add(self.matches, line)
		endif
	endfor
endfunction
"===============================================================================
" END OF CLASS: Parser
"===============================================================================


"===============================================================================
" CLASS: Generator - generates the .lvimrc
"===============================================================================
let s:Generator = {}

"=================================================
" Constructor: 
" Args:	pattern	- a pattern to crop the lib names with
function! s:Generator.New(pattern)
	let newGenerator = copy(self)
	let newGenerator.pattern = a:pattern
	let newGenerator.lib_names = []
	let newGenerator.lib_tags = []
	let newGenerator.ignore_tags = [] " this is where 'N' answers go to ignore same questions
	return newGenerator
endfunction

"=================================================
" Function: parse the include to crop the lib name
" Args: line - include line
function! s:Generator.parse(line)
	" here we get lib path inside include dirs
	let s:include = substitute(a:line, self.pattern, '\1', "")
	" and the actual lib name only
	let s:lib = substitute(s:include, '^\(\w\+\).*', '\1', "")
	" check if it's not already included or ignored in order not to prompt for the same lib
	if index(self.lib_names, s:lib) != -1 || index(self.ignore_tags, s:lib) != -1
		return
	endif

	" path to the tag file
	let s:lib_tag = g:tag_directory . s:lib . g:tag_extension
	" do we have it?
	if ! filereadable(fnamemodify(s:lib_tag, ":p"))
		if g:prompt_create_tags == 2
			return
		endif

		" lets check do we have installed packages
		let s:lib_exist = 0
		" depending on if file is directory or regular file
		if match(s:include, "/") > 0
			for dir in s:include_table
				if isdirectory(fnamemodify(dir . s:lib, ":p"))
					let s:lib_exist = 1
					let s:actual_lib_path = dir . s:lib
				endif
			endfor
		else
			for dir in s:include_table
				if filereadable(fnamemodify(dir . s:include, ":p"))
					let s:lib_exist = 1
					let s:actual_lib_path = dir . s:include
				endif
			endfor
		endif

		" package exist. generate tags?
		if s:lib_exist == 1
			if self.prompt_create_tag(s:lib_tag, s:actual_lib_path) == 1
				call self.generate_tags(s:actual_lib_path, s:lib_tag)
			else
				return
			endif
		" otherwise let the user give the path to the library
		else
			let s:answer = self.prompt_lib_path(s:lib)
			if ! empty(s:answer)
				call self.generate_tags(s:answer, s:lib_tag)
			else
				call add(self.ignore_tags, s:lib)
				return
			endif
		endif
	endif

	" save the lib name
	call add(self.lib_names, s:lib)
	" and this is what we will put into the .lvimrc
	call add(self.lib_tags, "set tags+=" . s:lib_tag)
endfunction

"=================================================
" Function: prompt create tags
" Args: lib_tag	 - the lib tag path which supposed to be
" 		lib_path - the path to lib headers
" Return: 0 - don't generate tags
" 		  1 - generate tags
function! s:Generator.prompt_create_tag(lib_tag, lib_path)
	" if prompt is enabled - ask the user
	if g:prompt_create_tags == 0
		let s:prompt = "[" . a:lib_tag . "] does not exist, but found library headers under [" . a:lib_path . "]. "
		let s:input = input(s:prompt . "Generate the tags? [y/Y/n/N]: ", "y")
		" if the input is for '-to all', edit globals, otherwise just return the action
		if s:input =~# "Y"
			let g:prompt_create_tags = 1
			return 1
		elseif s:input =~# "y"
			return 1
		elseif s:input =~# "N"
			let g:prompt_create_tags = 2
			return 0
		elseif s:input =~# "n"
			return 0
		endif
	" global is set to 'generate -to all'
	elseif g:prompt_create_tags == 1
		return 1
	" global is set to 'skip -to all'
	elseif g:prompt_create_tags == 2
		return 0
	endif

	return 0
endfunction

"=================================================
" Function: prompt the user to specify location to the library, which couldn't be detected
" Args: lib_name - name of the library (used to name tag file)
" Return: path	- location to the library
" 		  0		- null, skip this library
function! s:Generator.prompt_lib_path(lib_name)
	let s:prompt = "[" . a:lib_name . "] does not exist and NO library headers could be found. "
	let s:input = input(s:prompt . "Press enter to skip it or enter the path to the library: ", "", "file")
	if strlen(s:input) > 0
		return s:input
	else
		return 0
	endif
endfunction

"=================================================
" Function: generate the tag files from lib headers
" Args: path - path to the library
function! s:Generator.generate_tags(lib_path, tag_path)
	let s:cmd = "ctags -f ". fnamemodify(a:tag_path, ":p") ." -R --c++-kinds=+p --fields=+iaS --extra=+q " . fnamemodify(a:lib_path, ":p")
	echo s:cmd
	echo system(s:cmd)
endfunction
"===============================================================================
" END OF CLASS: Generator
"===============================================================================



"===============================================================================
" CONFIGS
"===============================================================================
" declare command :EasyPeasy to generate the file
command! -n=0 EasyPeasy call GenerateIncludes()
"===============================================================================
" END OF CONFIGS
"===============================================================================
