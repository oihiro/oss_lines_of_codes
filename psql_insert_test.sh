#!/bin/sh
oss_name="a"
version="1.0"
url="http://a.org/"
timestamp=`date +'%Y-%m-%d %H:%M:%S'`
size="1000"
lang="C,Java"
psql -c "insert into t_oss_lines(oss_name, version, download_url, created_date, lines_of_codes, lang_list) values ("\'"$oss_name"\'","\'"$version"\'","\'"$url"\'","\'"$timestamp"\'","\'"$size"\'","\'"$lang"\'");" oss_lines
