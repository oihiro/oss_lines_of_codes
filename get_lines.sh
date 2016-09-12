#!/bin/sh
#
oss_list=$1
for line in $(cat $oss_list) ; do
	arr=($(echo $line | tr -s ',' ' '))
	oss_name=${arr[0]}
	version=${arr[1]}
	url=${arr[2]}
	output_file=${arr[3]}

	if [ -e $output_file ]; then
		echo "$output_file exists."
		continue	
	fi
	echo $url
	wget -t 2 -O $output_file $url
	if [ $? -ne 0 ]; then
		echo "wget error. ret=$?"
	fi
done

