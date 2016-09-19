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
  if ar[1] != 'Bourne Shell' &&
    ar[1] != 'make' &&
    ar[1] != 'HTML' &&
    ar[1] != 'C/C++ Header' then
    $sum = $sum + ar[4].to_i
    $lang = $lang + ar[1] + ','
  end
end
if $lang.length > 0 then
  $lang.slice!($lang.length - 1, 1) # remove the last comma
end
puts "#{$sum} #{$lang}"
