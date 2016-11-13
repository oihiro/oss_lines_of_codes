#!/usr/bin/ruby
#
# CLOC Result Analyzer
# count the lines of the source code which are running in a product or a service
# stdin : cloc stdout (cloc --csv format)
#         cloc --csv format: filenum, language, blank, comment, codes
# stdout : line count and language list 
$sum = 0
$lang = ''
while s = STDIN.gets
	ar = s.split(',')
  next if ar.length != 5
  if true
=begin
    ar[1] != 'Bourne Shell' &&
    ar[1] != 'make' &&
    ar[1] != 'HTML' &&
    ar[1] != 'C/C++ Header' &&
    ar[1] != 'XML' &&
    ar[1] != 'Velocity Template Language' &&
    ar[1] != 'XSD' &&
    ar[1] != 'JSP' &&
    ar[1] != 'Ant' &&
    ar[1] != 'JavaServer Faces' &&
    ar[1] != 'SQL' &&
    ar[1] != 'Maven' &&
    ar[1] != 'CSS' &&
    ar[1] != 'DTD' &&
    ar[1] != 'diff' &&
    ar[1] != 'DOS Batch' &&
    ar[1] != 'XSLT' &&
    ar[1] != 'JSON' &&
    ar[1] != 'NAnt' &&
    ar[1] != 'lex' &&
    ar[1] != 'Korn'
=end
  then
    $sum = $sum + ar[4].to_i
    $lang = $lang + ar[1] + ','
  end
end
if $lang.length > 0 then
  $lang.slice!($lang.length - 1, 1) # remove the last comma
end
puts "#{$sum};#{$lang}"
