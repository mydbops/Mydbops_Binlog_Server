#!/bin/bash
###loop###
s3_upload()
{
for ((i=1;i<="$binlog_count";i++));do trans_binlog=$(echo "$binlog_details" | awk '{print $1}' | head -n $i | tail -n 1) echo "aws s3 cp \"$log_bin_dir\"/\"$trans_binlog\" \"$s3_bucket\" " if [[ $i -eq $binlog_count ]];then echo "$trans_binlog" > $last_binlog_file
fi
done
}
mysql_remote()
{
for ((i=1;i<="$binlog_count";i++));do trans_binlog=$(echo "$binlog_details" | awk '{print $1}' | head -n $i | tail -n 1) /bin/mysqlbinlog --read-from-remote-server --host=$mysql_host --user=$mysql_user --password=$mysql_pass $trans_binlog > $local_dir/$trans_binlog
if [[ $i -eq $binlog_count ]];then
echo "$trans_binlog" > $last_binlog_file
fi
done
}
log_bin_dir="/var/lib/mysql"
local_dir="/home/vagrant/binlog"
mysql_user="binlog_server"
mysql_pass='3!nl0g@321'
mysql_host='192.168.33.11'
#s3_bucket=""
last_binlog_file="/tmp/last_binlog_file"
last_binlog=$(cat "$last_binlog_file")
binlog_details=$(mysql -sN --user="$mysql_user" --password="$mysql_pass" --host=$mysql_host -e "show binary logs" | sed '$ d')
binlog_count=$(echo "$binlog_details" | awk '{print $1}' | wc -l)
if [[ -z "$last_binlog" ]];then
mysql_remote
else
binlog_details=$(echo "$binlog_details" | awk '{print $1}' | awk "f;/$last_binlog/{f=1}")
binlog_count=$(echo "$binlog_details" | awk '{print $1}' | wc -l)
if [[ -z "$binlog_details" ]];then
echo "$last_binlog" > $last_binlog_file
else
mysql_remote
fi
fi