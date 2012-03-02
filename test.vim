

let str = "use base qw(App::CLI\nMoose);"
let str = "extends 'Orz';"
echo matchstr( str , '\(^\(use\s\+\(base\|parent\)\|extends\)\s\+\(qw\)\=[''"(\[]\)\@<=\_.*\([\)\]''"]\s*;\)\@=' )
finish
