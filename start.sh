#!/bin/bash
BASEDIR=$(dirname "$0")

while [ 1 ]; do

	echo "1: "
	echo "2: "
	echo "3: Clean and remove all build products"
	echo "4: Exit"
	read ans

	case ${ans} in
		1) 
		;;
		2)
		;;
		3)
			
		;;
		4)
			exit
		;;
	esac 
done