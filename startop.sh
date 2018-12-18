#!/usr/bin/bash
echo "Setup script for Forwarders v0.1"
echo ""
echo "You need to run this against an Ubuntu server (tested on 18:04)"
echo ""
localip=$(ifconfig eth0 | grep 'inet ' |awk '{print $2}')
echo "The local IP is $localip. Iptables rules will be set to point back to this host"
echo "Enter the name of the target LP. This should match what you have put in /etc/hosts and /etc/ansible/config: "
read remotehost
remoteip=$(cat /etc/hosts | grep $remotehost |awk '{print $1}')
echo "The remote IP is $remoteip."
echo ""
echo "Creating clientconnect script"
echo "#!/bin/bash" > openvpn/clientconnect.sh
echo "/sbin/iptables -t nat -F POSTROUTING" >> openvpn/clientconnect.sh
echo "/sbin/iptables -t nat -A PREROUTING -d $remoteip -p tcp ! --dport 22 -j DNAT --to-destination $localip" >> openvpn/clientconnect.sh
echo "Calculating netmask"
subnet=$(awk -F"." '{print $1"."$2"."$3".0/24"}'<<<$localip) 2>&1
echo "Subnet is $subnet."
echo "/sbin/iptables -t nat -A POSTROUTING -s $subnet -j MASQUERADE" >> openvpn/clientconnect.sh
echo "" >> openvpn/clientconnect.sh
echo "Enter the name of your remote ubuntu user for ansible: "
read remoteuser
sed -i "s/remote_user.*/remote_user: $remoteuser/" deploy.yml
echo "Setting up remote server now"
ansible-playbook -K -e "USER=$remoteuser" deploy.yml
