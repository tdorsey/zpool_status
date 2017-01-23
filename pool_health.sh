#!/bin/bash

filepath=$ZFS_COLLECTOR_PATH
rm $filepath
#parse zpool output for eventual dump to prometheus metrics
#Column Order - NAME STATE READ WRITE CKSUM

#Getting the raw output
#Get zpool status
#sudo zpool status

#Ignore lines with mirror or raidz so we know we're seeing drive info
#Use egrep instead of grep or the pattern won't work
#egrep -v 'mirror|raidz

#Remove the last line of the file, usually "no known errors, etc"
# sed '$d' | 
 


#If Row number > 8, print the column. This hides the status output at the top, usually like
#
#  pool: tank
# state: ONLINE
#  scan: scrub repaired 0 
#config:   
#awk 'NR >= 8

#NR > 8 Removes the column header and pool name from the output

#Print the column we want as needed. All awk params are passed in single quotes
# { print $x }'

#Output should be space delimited, one metric per line
#Print NAME, READ, WRITE, CKSUM
output=`sudo zpool status | egrep -v 'mirror|raidz' | sed '$d' | awk 'NR >= 8 { print $1 " " $3 " " $4 " " $5 }' | sed '$d'`  

#Write a property as key:value pairs. 
#error data holds the label data for the metric
function write_property() {
     
if test "$#" -eq 2; then
    kvp=`printf '%s=\"%s\",' $1 $2`
else #Last label in the metric, don't print trailing comma
    kvp=`printf '%s=\"%s\"' $1 $2`
fi
    object_data=$object_data$kvp
}

function output_metric() {
    #output a metric for each line in the output file using the object data
     object_data=''
     metric_name="zpool_error_count"
     write_property "device" $1
     write_property "read_error_count" $2
     write_property "write_error_count" $3
     write_property "checksum_error_count" $4 0 #send a third argument so we don't print a trailing comma on the last label
     
     total_errors=$(( a+b+c ))
     time_since_epoch_ms=`date +%s` 
     printf '%s{ %s } %f %i\n' $metric_name $object_data $total_errors $time_since_epoch_ms
}

#Output metric info
echo "# HELP zpool_error_count zpool status error counts" >> $filepath
echo "# TYPE zpool_error_count gauge" >> $filepath

#Read each line of the output variable and turn it into a metric
while read -r n r w c
do output_metric $n $r $w $c >> $filepath
done <<< $output


