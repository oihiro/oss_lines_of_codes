#!/usr/bin/bash
#
# get_lines.sh
#
# get lines of codes of the OSS and insert it into the DB oss_lines.
# 1. read the OSS list and download the OSS package from the specified URL.
#    OSS list format : CSV
#
if [ $# -eq 0 ]; then
    echo "error. specify the OSS list."
    exit 1
fi
oss_list=$1
logfile="log-`date +'%Y%m%d_%H%M%S'`.txt"
exec &> >(tee -a $logfile)
for line in $(cat $oss_list) ; do
    arr=($(echo $line | tr -s ',' ' '))
    oss_name=${arr[0]}
    version=${arr[1]}
    url=${arr[2]}

    echo "$oss_name,$version,$url:"
    #psql -t -A -c "select id from t_oss_lines where oss_name = "\'"$oss_name"\'" and version = "\'"$version"\'" and download_url = "\'"$url"\'";" oss_lines > a.txt
    found=$(psql -t -A -c "select id from t_oss_lines where oss_name = "\'"$oss_name"\'" and version = "\'"$version"\'" and download_url = "\'"$url"\'";" oss_lines)
    #echo "found=$found"
    if [ -n "$found" ]; then
        echo "found in DB."
        continue
    fi

    output_file=`wget -nv -t 2 --trust-server-names $url 2>&1 | sed -e 's/[^"]*"\([^"]*\)".*/\1/'`
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "wget error. ret=$ret"
        continue
    fi
    if [ ! -s $output_file ]; then
        echo "failed to download with wget."
        continue
    fi

    # cloc can analyze a compressed file. So uncompressing is not needed.
    #if [ ${$output_file##*.} = 'zip' ]; then
    #    d=${$(basename $output_file)%.*}
    #    unzip -d $d $output_file
    #fi

    # get the lines of codes
    arr2=(`cloc --csv $output_file | ./cloc_analyzer.rb`)
    size=${arr2[0]}
    lang=${arr2[1]}
    echo "code=$size, lang=$lang"

    # insert the lines of codes into the database
    timestamp=`date +'%Y-%m-%d %H:%M:%S'`
    psql -c "insert into t_oss_lines(oss_name, version, download_url, created_date, lines_of_codes, lang_list) values ("\'"$oss_name"\'","\'"$version"\'","\'"$url"\'","\'"$timestamp"\'","\'"$size"\'","\'"$lang"\'");" oss_lines

    # output_file is not already needed. remove it.
    rm $output_file
done
