#!/bin/bash

again='y'
while [[ $again == 'Y' ]] || [[ $again == 'y' ]];
do
clear
echo "=================================================================";
echo " 1. Update machine                                               ";
echo " 2. Upgrade machine                                              ";
echo " 3. Install DHCP-Server                                          ";
echo " 4. Install DHCP-Relay                                           ";
echo " 5. Configure Relay                                              ";
echo " 6. Configure DHCP-Server                                        ";
echo " 7. Remove DHCP-Relay                                            ";
echo " 8. Remove DHCP-Server                                           ";
echo " 0. Exit                                                         ";
echo "=================================================================";

read -p " Enter Your Choice [0 - 9] : " choice;
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

3)  read -p "You want install DHCP-server? y/n :" -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt-get install isc-dhcp-server -y
    echo "DHCP-Sserver is ready to use"
    fi
    ;;

4)  read -p "You want install DHCP-Relay? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt-get install isc-dhcp-relay -y
    echo "DHCP Relay is ready to use"
    fi
    ;;

5)  if [ -z "$(ls -A /etc/default/isc-dhcp-relay)" ]; then
    echo "DHCP is not installed before, Please install it!"
    else
    echo "Create new relay"
    service isc-dhcp-relay stop
    cat > /etc/default/isc-dhcp-relay <<- EOF
    # Defaults for isc-dhcp-relay initscript
# sourced by /etc/init.d/isc-dhcp-relay
# installed at /etc/default/isc-dhcp-relay by the maintainer scripts

#
# This is a POSIX shell fragment
#

# What servers should the DHCP relay forward requests to?
SERVERS="192.192.2.3" # IP Westalis

# On what interfaces should the DHCP relay (dhrelay) serve DHCP requests?
INTERFACES="eth1 eth2 eth3"

# Additional options that are passed to the DHCP relay daemon?
#OPTIONS="" /etc/default/isc-dhcp-relay

EOF
    cat /etc/default/isc-dhcp-relay
    service isc-dhcp-relay start
    service isc-dhcp-relay restart
    echo "Enable IP forward"
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    cat /proc/sys/net/ipv4/ip_forward
    echo "Done..."
    fi
    ;;

6)  if [ -z "$(ls -A /etc/dhcp/dhcpd.conf)" ]; then
    echo "DHCP is not installed before, Please install it!"
    else
    echo "Create new DHCP-Server"
    service isc-dhcp-server stop
    cat > /etc/dhcp/dhcpd.conf <<- EOF

subnet 192.192.1.0 netmask 255.255.255.0 {
    range 192.192.1.50 192.192.1.88;
    range 192.192.1.120 192.192.1.155;
    option routers 192.192.1.1;
    option broadcast-address 192.192.1.255;
    option domain-name-servers 192.192.2.2;
    default-lease-time 300;
    max-lease-time 6900;
}
subnet 192.192.2.0 netmask 255.255.255.0 {
}
subnet 192.192.3.0 netmask 255.255.255.0 {
    range 192.192.3.10 192.192.3.30;
    range 192.192.3.60 192.192.3.85;
    option routers 192.192.3.1;
    option broadcast-address 192.192.3.255;
    option domain-name-servers 192.192.2.2;
    default-lease-time 600;
    max-lease-time 6900;
}
host Eden {
    hardware ethernet 7a:55:19:97:68:d9 ;
    fixed-address 192.192.3.13;
}

EOF

    cat /etc/dhcp/dhcpd.conf
    echo "Replace new interface"
    cd /etc/default
    sed -i 's/INTERFACES=""/INTERFACES="eth0"/gI' isc-dhcp-server
    service isc-dhcp-server start
    service isc-dhcp-server restart
    echo "Enable IP forward"
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    cat /proc/sys/net/ipv4/ip_forward
    echo "Done..."
    fi
    ;;

7)  read -p "You want  to remove DHCP and all config files? y/n :" -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt-get remove --auto-remove isc-dhchp-relay -y
    echo "DHCP-Relay is already remove"
    fi
    ;;

8)  read -p "You want  to remove DHCP and all config files? y/n :" -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt-get remove --auto-remove isc-dhchp-server -y
    echo "DHCP-Server is already remove"
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
