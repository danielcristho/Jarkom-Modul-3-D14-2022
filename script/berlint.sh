#!/bin/bash

again='y'
while [[ $again == 'Y' ]] || [[ $again == 'y' ]];
do
clear
echo "=================================================================";
echo " 1. Update machine                                               ";
echo " 2. Upgrade machine                                              ";
echo " 3. Install Proxy Server                                         ";
echo " 4. Config squid.conf                                            ";
echo " 5. Create new access list                                       ";
echo " 6. Add sites list                                               ";
echo " 0. Exit                                                         ";
echo "=================================================================";

read -p " Enter Your Choice [0 - 8] : " choice;
echo "";
case $choice in

1)  read -p "You will update and install many dependencies? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt update -y
    apt-get install net-tools -y
    apt-get install lynx dnsutils -y
    echo "Update success"
    fi
    ;;

2)  read -p "You will upgrade this machine? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt upgrade -y
    echo "Upgrade success"
    fi
    ;;

3)  read -p "You want install Squid ? y/n :" -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt-get install squid -y
    echo "Proxy Server is ready to use"
    fi
    ;;


4)  if [ -z "$(ls -A /etc/squid/squid.conf)" ]; then
    echo "Squid is not installed before, Please install it!"
    else
    service squid stop
    touch /etc/squid/acl.conf
    touch /etc/squid/sites.txt
    cat >> /etc/squid/squid.conf <<- EOF
    
include /etc/squid/acl.conf
acl SITES dstdomain "/etc/squid/sites.txt"
acl SSL_PORT port 443

http_port 6000
visible_hostname Berlint

#access list deny
http_access deny WORKDAYS
http_access allow all

http_access allow WORKDAYS SITES
#http_access allow SITES

http_access deny SSL_PORT
http_access deny all

EOF
    cat /etc/squid/squid.conf
    echo "Done..."
    fi
    ;;

5)  if [ -z "$(ls -A /etc/squid/acl.conf)" ]; then
    echo "Squid is not configure before!"
    else
    echo "Create new access list"
    service squid stop
    cd /etc/squid
    cat > /etc/squid/acl.conf <<- EOF
acl WORKDAYS time MTWHF 08:00-17:00
EOF
    cat /etc/squid/acl.conf
    echo "Done..."
    fi
    ;;

6)  if [ -z "$(ls -A /etc/squid/sites.conf)" ]; then
    echo "Squid is not configure before!"
    else
    echo "Create new sites list"
    service squid stop
    cd /etc/squid
    cat > /etc/squid/sites.txt <<- EOF
loid-work.com
franky-work.com
EOF
    cat /etc/squid/sites.txt
    service squid restart
    echo "Done..."
    fi
    ;;

0)  exit
    ;;
*)    echo "sorry, menu is not found"
esac
echo -n "Back again? [y/n]: ";
read again;
while [[ $again != 'Y' ]] && [[ $again != 'y' ]] && [[ $again != 'N' ]] && [[ $again != 'n' ]];
do
echo "Your input is not correct";
echo -n "back again? [y/n]: ";
read again;
done
done