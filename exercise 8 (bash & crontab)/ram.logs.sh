#!/bin/bash
filepath=${HOME}'/Documents/ALTSCHOOL/altschool-cloud-exercises/exercise 8 (bash & crontab)/ram.logs.txt'

echo "$(date)" 
echo "============================================" #>> "$filepath"
free -h #2>&1 >> "${filepath}"
echo "============================================" #>> "${filepath}"
