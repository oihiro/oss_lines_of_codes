#!/usr/bin/bash
#
# cloc_wrapper.sh
#
# count source code lines of source package files
#
# input: list of source package files (result of ls directory)
# output: list of 'package file, sum of code lines, language extensions'
#
# usage: cd dir_with_source_packages; ls | ../cloc_wrapper.sh
#        (need to change to the directory in order for cloc to access the package file.)
#
while read package; do
    IFS=\; eval 'arr=(`cloc --csv $package | ../cloc_analyzer.rb`)'
    size=${arr[0]}
    lang=${arr[1]}
    echo "$package;$size;$lang"
done
