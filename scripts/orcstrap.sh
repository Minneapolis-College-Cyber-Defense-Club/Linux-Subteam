#!/bin/bash

export PATH=/bin:/sbin:/usr/bin:/usr/sbin
# global vars
DNS="1.1.1.1"
HOSTNAME="$(uname -n)"
DEPOT="/depot"
OS="$(grep '^ID=' /etc/os-release | awk -F\" '{print $2}')"
OS_VER="$(grep '^VERISON_ID=' /etc/os-release | awk -F\" '{print $2}')"
URL_BASE="https://raw.githubusercontent.com/Minneapolis-College-Cyber-Defense-Club/Linux-Subteam/main"
SCR_BASE="${DEPOT}/scripts"
PB_BASE="${DEPOT}/ansible/playbooks"
COLLECTIONS="ansible.posix community.mysql community.general"

# initial checks
if [[ $(/bin/whoami) != 'root' ]]; then   
    printf "Must run as root.\n"
    exit 666
fi
# make sure it is setup on the expected OS
[[ ${OS} != centos && ${OS_VER} != 7 ]] || (printf "wrong os detected...bye.\n" ; exit 667)

# create the depot
for d in vault keys files ansible quarantine scripts
do
    mkdir -p ${DEPOT}/${d}
done
chown -R root: ${DEPOT}
chmod 700 ${DEPOT}

# build file quarantine
QUARANTINE="${DEPOT}/quarantine"
chmod 700 ${QUARANTINE}

# basic security and functionality checks
# at this point /etc/resolv.conf should have been fixed via kill chain BUT VALIDATE
# backup and validate files
cp /etc/resolv.conf ${QUARANTINE}/
# critical we don't have a poisoned DNS 
grep "${DNS}" /etc/resolv.conf 
case $? in
    0) 
        printf "Looks correct.\n" 
        ;;
    *) 
        mv /etc/resolv.conf ~/${QUARANTINE}/
        printf "nameserver ${DNS} \n">/etc/resolv.conf
        ;;
esac
cp -p /etc/hosts ${QUARANTINE}/
mv /etc/hosts /etc/hosts.prev
printf "127.0.0.1 localhost localhost.localdomain\n::1 localhost localhost.localdomain\n">/etc/hosts
# in case there is more than 1 interface
for i in $(ifconfig | cut -f1 -d: | grep '^[a-z]' | grep -v lo)
do
    printf "$(ifconfig ${i} |grep inet | grep -v inet6 | awk '{print $2}') $(uname -n | cut -f1 -d.) $(uname -n)">>/etc/hosts
done

cp -p /root/.bash_history ${QUARANTINE}/root.bash_history
cp -p /etc/ssh/sshd_config ${QUARANTINE}/
cp -pr /etc/suoders* ${QUARANTINE}/

# clean out crontabs
mkdir ${QUARANTINE}/crons
for c in $(ls /var/spool/cron)
do
    mv /var/spool/${c}  ${QUARANTINE}/crons/
    [[ -f /var/spool/${c} ]] && rm -f /var/spool/${c}
done

# install required packages
# need EPEL
yum install -y epel-release libselinux-python
[[ -x /bin/python ]] || yum install -y python
[[ -x /bin/ansbile ]] || yum install -y ansible
[[ -x /bin/wget ]] || yum install -y wget
PULLER="/bin/wget"

# pull the things
${PULLER} -N -P ${DEPOT}/ansible ${URL_BASE}/ansible
${PULLER} -N -P ${DEPOT}/scripts ${URL_BASE}/scripts

# pull the collections
ansible-galaxy collection install ${COLLECTIONS}

# create things needed
for u in hal9000 dave2001
do
    h_password="$(python -c 'import crypt,getpass; print(crypt.crypt(getpass.getpass(),crypt.METHOD_SHA512))')"
    [[ -d ${DEPOT}/vault ]] || mkdir -p ${DEPOT}/vault
    USERVAULT="${DEPOT}/vault/${u}.yml"
    KEYFILE="${DEPOT}/keys/${u}"
    echo "${u}_password: ${h_password}" > ${USERVAULT}
    ${PULLER} -N -P ${DEPOT}/playbooks/ ${PB_BASE}/${u}_strap.yml
    # add more to the vault
    case "${u}" in
        hal9000)
            USERID="111111"
            ;;
        dave2001)
            USERID="111112"
            ;;
    esac
    printf "team_admin: ${u}\nteam_admin_id: ${USERID}\n" >> ${USERVAULT}
    #ssh-keygen -q -N "" -f ${KEYFILE} -t rsa -b 4096
    

done

# clean up and hand over
rm -fr ~/.ansible

# pull the collections
su -c "ansible-galaxy collection install ${COLLECTIONS}" hal9000

# open the pod bay doors
