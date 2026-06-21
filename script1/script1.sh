#!/bin/bash

FTP_LOG="cdlinux.ftp.log"
WWW_LOG="cdlinux.www.log"
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
END='\e[0m'

trap 'echo -e "\nScript has been closed :("; exit 0' SIGINT


if [ ! -f "$FTP_LOG" ]; then 
	echo -e $RED"Could not find $FTP_LOG in the current directory!"$END
	exit 1
fi

if [ ! -f "$WWW_LOG" ]; then
	echo -e $RED"Could not find $WWW_LOG in the current directory!"$END
	exit 1
fi
        figlet "Welcome in"
        toilet -F border "log checker"
ftp_errors() {
    clear
	echo "<><><><><><><><><><>"
	echo -e $RED"TOP 5 IP ADDRESSES WITH ERRORS IN FTP LOG: "$END
	grep "FAIL DOWNLOAD" "$FTP_LOG" | sed 's?.*Client "??' | sed 's?".*??' | sort | uniq -c | sort -nr |head -n 5
}
www_downloads(){
    clear
	echo "<><><><><><><><><><>"
	echo -e $GREEN"TOP 3 DOWNLOADES FILES: "$END
	grep " 200 " "$WWW_LOG" | sed 's?^[^:]*:??' | sed 's?^.*GET ??' | sed 's? HTTP.*??' | sort | uniq -c | sort -nr | head -n 3 | sed 's?[0-9 ]*?---------->  ?'
}
search_by_address(){
    clear
	echo "<><><><><><><><><><>"
	echo "Type some address IP: "
	read ip_address
	if [[ ! "$ip_address" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
		echo -e $RED"WRONG IP FORMAT"$END
		return
	fi
	echo ">>>>>>>>>>"
	echo -e $GREEN"Result for IP: $ip_address"$END
	echo -e $YELLOW"Last 3 successful FTP logs: "$END
	grep "$ip_address" "$FTP_LOG" | grep "OK DOWNLOAD" | tail -n 3 | sed 's?.*Client "??'
	echo -e $YELLOW"Last 3 WWW entries logs: "$END" "
	grep "$ip_address" "$WWW_LOG" | tail -n 3 | sed 's?^[^:]*:??'
}
ftpwww_stats(){
    clear
	echo "<><><><><><><><><><>"
	echo -e $YELLOW"Here's some general data: "$END
	echo -n -e $GREEN"FTP OK DOWNLOADS: "$END
	grep -c "OK DOWNLOAD" "$FTP_LOG"
	echo -n -e $RED"FTP FAIL DOWNLOADS: "$END
	grep -c "FAIL DOWNLOAD" "$FTP_LOG"
	echo -n -e $GREEN"WWW SUCCESSFUL ACTIONS: "$END
	grep -c " 200 " "$WWW_LOG"
}
while true; do
	echo  ""
	echo "<><><><><><><><><><><><><><><><><><><><><><><><><><>"
	echo -e $YELLOW"STATISTICS: "$END
	echo -e $GREEN"1. TOP 5 IP addresses with FTP errors"$END
	echo -e $GREEN"2. TOP 3 Downloaded WWW files"$END
	echo -e $GREEN"3. Search by address IP"$END
	echo -e $GREEN"4. Show stats"$END
	echo -e $RED"5. EXIT"$END
	read -p "Choose option from 1 to 5: " option
	case $option in
	1)ftp_errors;;
	2)www_downloads;;
	3)search_by_address;;
	4)ftpwww_stats;;
	5)echo "SCRIPT CLOSED"
	exit 0;;
	*) 
		echo "This option is not available, try again pls";;
esac
done
