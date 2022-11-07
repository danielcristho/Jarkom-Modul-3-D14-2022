#!/bin/bash

again='y'
while [[ $again == 'Y' ]] || [[ $again == 'y' ]];
do
clear
echo "=================================================================";
echo " 1.  Update machine                                              ";
echo " 2.  Upgrade machine                                             ";
echo " 3.  Install Bind9                                               ";
echo " 4.  Install dependencies                                        ";
echo " 5.  Install DHCP-Server                                         ";
echo " 6.  Install DHCP-Relay                                          ";
echo " 7.  Install Apache2                                             ";
echo " 8.  Install PHP                                                 ";
echo " 9.  Set up iptables                                             ";
echo " 10. Restart machine                                             ";
echo " 11. Set resolv.conf                                             ";
echo " 0.  Exit                                                        ";
echo "=================================================================";

read -p " Enter Your Choice [0 - 1] : " choice;
echo "";
case $choice in

1)  read -p "You will update this machine? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt-get update -y
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

3)  read -p "You want install bind9? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt-get install bind9 -y
    echo "Install success"
    fi
    ;;

4)  read -p "You want install many dependecies? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt-get install nano net-tools dnsutils iputils-ping openssh-server vim iproute2 iptables git curl lynx -y
    echo "Install success"
    fi
    ;;

5)  read -p "You want install DHCP-Server? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt-get install isc-dhchp-server -y
    echo "DHCP is ready to use"
    fi
    ;;

6)  read -p "You want install DHCP-Relay? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt-get install isc-dhcp-relay -y
    echo "DHCP Relay is ready to use"
    fi
    ;; 

7)  read -p "You want install Apache? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt-get install apache2 -y
    echo "Apache is ready to use"
    fi
    ;; 


8)  read -p "You want install PHP? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then
    apt install php libapache2-mod-php7.0  -y    
    apt update -y
    echo "PHP is ready to use"
    fi
    ;;


9)  read -p "You want set up iptables? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    iptables -t nat -A POSTROUTING -j MASQUERADE -o eth0 -s 192.192.0.0/16
    echo "iptables -t nat -A POSTROUTING -j MASQUERADE -o eth0 -s 192.192.0.0/16" >> /root/.bashrc
    fi
    ;;

10) read -p "You want restart this machine? y/n :" -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    reboot
    fi
    ;;

11) read -p "You want resolv.conf? y/n :" -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    #echo "nameserver 192.168.122.1" >> /etc/resolv.conf
    echo "namserver 192.192.3.2
nameserver 192.192.2.2" >> /etc/resolv.conf
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