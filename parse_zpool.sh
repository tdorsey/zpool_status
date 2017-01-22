#!/bin/bash
#parse zpool output for eventual dump to prometheus metrics
#Column Order - NAME STATE READ WRITE CKSUM


#Each portion of the command is explained separately

#Get zpool status
#sudo zpool status

#Ignore lines with mirror or raidz so we know we're seeing drive info
#Use egrep instead of grep or the pattern won't work
#egrep -v 'mirror|raidz

#Remove the last line of the file, usually "no known errors, etc"
# sed '$d' | 
 


#If Row number > 4, print the column. This hides the status output at the top, usually like
#
#  pool: tank
# state: ONLINE
#  scan: scrub repaired 0 
#config:   
#awk 'NR >= 4

#NR > 8 Removes the column header and pool name from the output

#Print the column we want as needed. All awk params are passed in single quotes
# { print $x }'



#Print NAME, READ, WRITE, CKSUM
output=`sudo zpool status | egrep -v 'mirror|raidz' | sed '$d' | awk 'NR >= 8 { print $1 " " $3 " " $4 " " $5 }' | sed '$d' `

while read -r name r w c
do echo "$name - $r$w$c";
done <<< $output
