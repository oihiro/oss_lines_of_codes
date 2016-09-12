#!/usr/bin/ruby
#
# CLOC Result Analyzer
# count source code lines of the specified language.
# stdin : cloc stdout (cloc --csv format)
# cloc --csv format: filenum, language, blank, comment, codes
# 
$sum = 0
while s = STDIN.gets
	ar = s.split(',')
  next if ar.length != 5
  if ar[1] == 'C' then
    $sum = $sum + ar[4].to_i
  end
end
puts "#{$sum}"


