#!/bin/bash
clear

GREEN='\e[32m';
RED='\e[31m';
CYAN='\e[36m';
END='\e[0m';

trap 'clear; echo -e "\nScript has been closed :("; exit 0' SIGINT


printf "%s" "Network
checker
" | toilet
FNAME=$(zenity --entry --title="NETWORK CHECKER" --text="Enter name properly:" 2>/dev/null)
if [ $? -eq 1 ]; then
    clear
    toilet "CANCELED"
    exit 1;
fi
echo -e $GREEN"Name: $FNAME"$END
LNAME=$(zenity --entry --title="NETWORK CHECKER" --text="Enter surname properly:" 2>/dev/null)

if [ $? -eq 1 ]; then
    clear
    toilet "CANCELED"
    exit 1;
fi


echo -e $GREEN"Surname: $LNAME"$END
sleep 1

if [ "$FNAME" != "Nikodem" ] || [ "$LNAME" != "Grosz" ]; then
	zenity --error --title "U typed wrong name/surname $FNAME $LNAME" 2>/dev/null
	exit 1
fi

echo -e $GREEN"Well done. Welcome :)"$END

(
for i in {1..100}; do
    if [ $i -gt 97 ]; then
        sleep 1
    fi
	sleep 0.01
	echo $i
done
) | dialog --title "LOADING" --gauge "Network Checker..." 6 50 10


while true; do
	clear 
	OPTION=$(dialog --clear --stdout \
		--title " U can choose some option: $FNAME $LNAME " \
		--menu "Choice 1-5" 15 60 5 \
		"1" "IP configuration" \
		"2" "Ping test" \
		"3" "Domain to IP translation" \
		"4" "Routing stats" \
		"5" "Exit")

    if [ $? -ne 0 ]; then
        clear
        echo "U used CANCEL"
        exit 1;
    fi

case $OPTION in
	1)
		IP_CONF=$(ip addr)
		dialog --title "IP CONFIG" --msgbox "$IP_CONF" 15 70 ;;
	2)
		ADDR=$(zenity --entry --title="Ping Test" --text="Pls enter IP or Domain like google.com" 2>/dev/null)
		if [ -n  "$ADDR" ]; then
			dialog --title "Ping test" --infobox "Pinging $ADDR... Wait please." 5 50
			PING_RESULT=$(ping -c 4 "$ADDR")
			dialog --title "Ping result" --msgbox "$PING_RESULT" 18 75
		fi ;;
	3)
		DOMAIN=$(zenity --entry --title="Translator" --text="Pls enter IP or domain to translate" 2>/dev/null)
        if [ -n "$DOMAIN" ]; then
            RESULT=$(nslookup "$DOMAIN")
            dialog --title "Translating..." --infobox "U have to wait..." 5 30
            sleep 2
            dialog --title "Results" --msgbox "$RESULT" 20 90
        fi;;
	4)
		ROUTE_DATA=$(ip route)
		dialog --title "Routing Table" --msgbox "$ROUTE_DATA" 15 70 ;;
	5)
		clear
		echo -e $CYAN"U exit the script"
		exit 0 ;;
	esac
done
