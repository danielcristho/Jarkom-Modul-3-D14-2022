#!/bin/bash

#CONSTANT
SERVER_ADDR="192.192.2.2"
DOMAIN_NAME="loid-work.com"
DOMAIN_NAME1="franky-work.com"
FORWARD_FILE=$DOMAIN_NAME
FORWARD_FILE1=$DOMAIN_NAME1

again='y'
while [[ $again == 'Y' ]] || [[ $again == 'y' ]];
do
clear
echo "=================================================================";
echo " 1. Update machine                                               ";
echo " 2. Upgrade machine                                              ";
echo " 3. Install bind9                                                ";
echo " 4. Create new zone (loid&franky)                                ";
echo " 5. Configure loid zone                                          ";
echo " 6. Configure franky zone                                        ";
echo " 7. Configure named.conf.options                                 ";
echo " 8. Configure resolv.conf                                        ";
echo " 9. Remove bind9                                                 ";
echo " 0. Exit                                                         ";
echo "=================================================================";

read -p " Enter Your Choice [0 - 9] : " choice;
echo "";
case $choice in

1)  read -p "You will update and install many dependencies? y/n :" -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt update -y
    apt-get install net-tools -y
    apt-get install lynx dnsutils -y
    echo "Update success"
    fi
    ;;

2)  read -p "You will upgrade this machine? y/n :" -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt upgrade -y
    echo "Upgrade success"
    fi
    ;;

3)  read -p "You want install bind9? y/n :" -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt-get install bind9 -y
    echo "Bind9 is ready to use"
    fi
    ;;

4)  if [ -z "$(ls -A /etc/bind/named.conf.local)" ]; then
    echo "Bind9 is not installed before, Please install it!"
    else
    echo "Created forward zone and reverse zone"
    # sudo su
    cat >> /etc/bind/named.conf.local <<- EOF

zone "${DOMAIN_NAME}" {
        type master;
        file "/etc/bind/wise/${FORWARD_FILE}";
};
zone "${DOMAIN_NAME1}" {
        type master;
        file "/etc/bind/wise/${FORWARD_FILE1}";
};
EOF
    cat /etc/bind/named.conf.local

    echo "Create new forward and reverse file"
    cd /etc/bind && mkdir wise
    cp db.local wise/${FORWARD_FILE}
    cp db.local wise/${FORWARD_FILE1}
    # cp db.local wise/${REVERSE_FILE}
    echo "Done..."
    fi
    ;;

5)  if [ -z "$(ls -A /etc/bind/wise/${FORWARD_FILE})" ]; then
    echo "File not found!!"
    else
    cd /etc/bind/wise
    echo "Replace all localhost string with domain name..."
    sed -i "s/localhost/${DOMAIN_NAME}/gI" ${FORWARD_FILE}
    echo "Replace 127.0.0.1 with server address..."
    sed -i "s/127.0.0.1/${SERVER_ADDR}/gI" ${FORWARD_FILE}
    echo "Adding new record..."
    cat >> /etc/bind/wise/${FORWARD_FILE} <<- EOF
www     IN      CNAME   $DOMAIN_NAME

EOF
    cat /etc/bind/wise/${FORWARD_FILE}
    service bind9 restart
    echo "Done..."
    fi
    ;;

6) if [ -z "$(ls -A /etc/bind/wise/${FORWARD_FILE1})" ]; then
    echo "File not found!!"
    else
    cd /etc/bind/wise
    echo "Replace all localhost string with domain name..."
    sed -i "s/localhost/${DOMAIN_NAME1}/gI" ${FORWARD_FILE1}
    echo "Replace 127.0.0.1 with server address..."
    sed -i "s/127.0.0.1/${SERVER_ADDR}/gI" ${FORWARD_FILE1}
    echo "Adding new record..."
    cat >> /etc/bind/wise/${FORWARD_FILE1} <<- EOF
www     IN      CNAME   $DOMAIN_NAME1

EOF
    cat /etc/bind/wise/${FORWARD_FILE1}
    service bind9 restart
    echo "Done..."
    fi
    ;;

7)  if [ -z "$(ls -A /etc/bind/named.conf.options)" ]; then
    echo "File not found"
    else
    echo "Configure..."
    # sudo su
    cat > /etc/bind/named.conf.options <<- EOF
options {
        directory "/var/cache/bind";
        forwarders {
            192.168.122.1; // IP NAT
        };
        // dnssec-validation auto;
        allow-query{any;};
        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};
EOF
    cat /etc/bind/named.conf.options
    service bind9 restart
    echo "Done..."
    fi
    ;;

8)  read -p "You want set up resolv.conf? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    echo "Edit resolv.conf"
    # sudo su
    echo "nameserver 192.168.122.1" > /etc/resolv.conf
    #Comment IP Nat
    echo "DONE..."
    fi
    ;;

9)  read -p "You want  to remove bind9 and all config files? y/n :" -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt-get remove bind9 -y
    apt-get remove --auto-remove bind9 -y
    echo "Bind9 is already remove"
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
