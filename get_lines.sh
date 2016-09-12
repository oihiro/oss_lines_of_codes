#!/bin/sh
#
# get_lines.sh
#
# get lines of codes of the OSS and insert it into the DB oss_lines.
# 1. read the OSS list and download the OSS package from the specified URL.
#    OSS list format : CSV
#
if [ $# = 0 ]; then
    echo "error. specify the OSS list."
    exit 1
fi
oss_list=$1
for line in $(cat $oss_list) ; do
    arr=($(echo $line | tr -s ',' ' '))
    oss_name=${arr[0]}
    version=${arr[1]}
    url=${arr[2]}
    output_file=${arr[3]}

    found=$(psql -t -A -c "select id from t_oss_lines where oss_name = "\'"$oss_name"\'" and version = "\'"$version"\'" and download_url = "\'"$url"\'";" oss_lines)
    if [ -n $found ]; then
        echo "found. $oss_name $version"
        exit 0
    fi

    if [ -e $output_file ]; then
        echo "$output_file exists."
        continue	
    fi
    echo $url
    wget -t 2 -O $output_file $url
    if [ $? -ne 0 ]; then
        echo "wget error. ret=$?"
        exit 1
    fi
    if [ ${$output_file##*.} = 'zip' ]; then
        d=${$(basename $output_file)%.*}
        unzip -d $d $output_file
    fi
done
