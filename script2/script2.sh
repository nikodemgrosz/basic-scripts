#!/bin/bash
clear

RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
END='\e[0m'
CYAN='\e[36m'

SEARCH_PATH=".";
MIN_SIZE="";
MAX_DAYS="";
EXTENSION="";
PERMISSIONS="";



while getopts "p:s:d:e:P:h" option; do
	case "$option" in
	p)
		SEARCH_PATH=$OPTARG;;
	s)
		MIN_SIZE=$OPTARG;;
	d)
		MAX_DAYS=$OPTARG;;
	e)
		EXTENSION=$OPTARG;;
	P)
		PERMISSIONS=$OPTARG;;
	h)
            echo -e $CYAN"<><><><><> CHECKING SCRIPT <><><><><>"$END
			echo -e $YELLOW"Script $0 has some options to use: "$END
			echo "-p which means path (default is set on current dir)"
			echo "-s which is size (e.g. 52M, 8G)"
			echo "-d which search files older than N days (e.g. 10)"
			echo "-e to find files with concrete extension (e.g.\"*log\")"
			echo "-P to find files with concrete permission (e.g. 777)"
			echo -e  $GREEN"-h which u can show this help message"
			echo -e $CYAN"<><><><><><><><><><><><><><><><><><><>"$END
			exit 0;;
		*)
			echo -e $RED"U used unknown option. Try again or use -h for description"$END
			exit 1;;
	esac
done
    toilet "Checking"
    toilet "file"
    echo -e $GREEN"RESULTS OF THE SCRIPT: "$END
    echo -e $YELLOW"Path u used: $SEARCH_PATH"

        COMMANDS=("$SEARCH_PATH" "-type" "f")

if [ -n "$MIN_SIZE" ]; then
	COMMANDS+=("-size" "+$MIN_SIZE")
	echo "Min size: $MIN_SIZE"
fi

if [ -n "$MAX_DAYS" ]; then
	COMMANDS+=("-mtime" "+$MAX_DAYS")
	echo "Searching for older than: $MAX_DAYS days"
fi

if [ -n "$EXTENSION" ]; then

	COMMANDS+=("-iname" "$EXTENSION")
	echo "Extension used: $EXTENSION"
fi

if [ -n "$PERMISSIONS" ]; then
	COMMANDS+=("-perm" "$PERMISSIONS")
	echo "Permission used: $PERMISSIONS"
fi

    echo -e $CYAN"Successful found files: "$END
	find "${COMMANDS[@]}"


echo "-----------------------------------"
count=1;
for i in "${COMMANDS[@]}"; do
    echo "Element $count: $i"
   ((count+=1))
done

echo "-----------------------------------"
