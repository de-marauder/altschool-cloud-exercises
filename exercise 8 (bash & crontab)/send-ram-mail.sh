#!/bin/bash

pathtofile='/home/de-marauder/Documents/ALTSCHOOL/altschool-cloud-exercises/exercise 8 (bash & crontab)/ram.logs.txt'
#echo $(pwd)
echo $pathtofile
if [[ -f ${pathtofile} ]]
then
	mutt -s "Here are the day's memory logs" -- chiezike16@gmail.com  < "${pathtofile}"
fi

echo "done"
