#!/bin/bash

cp ~/.bashrc ~/.bashrc.backup


echo "alias ncc='/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg'" >> ~/.bashrc
echo "alias cc='chmod +x '" >> ~/.bashrc
echo "alias npr='systemctl restart nrpe'" >> ~/.bashrc
echo "alias nrr='systemctl restart nagios'" >> ~/.bashrc
echo "alias hosta='sudo nano /usr/local/nagios/etc/objects/linux.cfg'" >> ~/.bashrc
echo "alias bas='source ~/.bashrc'" >> ~/.bashrc
echo "alias eal='nano ~/.bashrc'" >> ~/.bashrc

# este alias se ejecuta con crp 192.122.141.0
echo "alias crp='/usr/local/nagios/libexec/./check_nrpe -H '" >> ~/.bashrc
echo "alias cps='ssh-copy-id '" >> ~/.bashrc

echo "alias alias aaa='~/ccdc/al.sh'" >> ~/.bashrc
echo "alias tk='tmux kill-server'" >> ~/.bashrc

echo "alias anp='ansible all -m ping'" >> ~/.bashrc
echo "alias apl='ansible-playbook '" >> ~/.bashrc

#echo "alias zips='echo ansible all -m copy -a "src=roles.zip dest=/home/admin/"'" >> ~/.bashrc





yum install  python3-devel python3 -y 



mkdir ~/ccdc
cd ~/ccdc

yum install git 
source ~/.bashrc


ssh-keygen

