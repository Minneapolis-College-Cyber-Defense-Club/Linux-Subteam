#!/bin/bash

export PATH=/bin:/sbin:/usr/bin:/usr/sbin
# global vars
DNS="1.1.1.1"
HOSTNAME="$(uname -n)"
IP="127.0.0.1"
DEPOT="/depot"
OS="$(grep '^ID=' /etc/os-release | awk -F\" '{print $2}')"
OS_VER="$(grep '^VERISON_ID=' /etc/os-release | awk -F\" '{print $2}')"
GITHOLE="https://github.com/Minneapolis-College-Cyber-Defense-Club/Linux-Subteam.git"
URL_BASE="https://raw.githubusercontent.com/Minneapolis-College-Cyber-Defense-Club/Linux-Subteam/main"
SCR_BASE="${DEPOT}/scripts"
PB_BASE="${DEPOT}/ansible/playbooks"
COLLECTIONS="ansible.posix community.general"
NOLOGIN="$(which nologin)"

# initial checks
if [[ $(/bin/whoami) != 'root' ]]; then   
    printf "Must run as root.\n"
    exit 666
fi

# basic networking fixes
cp /etc/resolv.conf /etc/resolv.conf.orig
# critical we don't have a poisoned DNS 
printf "checking dns...\n"
grep "${DNS}" /etc/resolv.conf 
case $? in
    0) 
        printf "Looks correct.\n" 
        ;;
    *) 
        printf "nameserver ${DNS} \n">/etc/resolv.conf
        ;;
esac
printf "checking /etc/hosts...\n"
mv /etc/hosts /etc/hosts.orig
printf "127.0.0.1 localhost localhost.localdomain\n::1 localhost localhost.localdomain\n">/etc/hosts
# in case there is more than 1 interface
for i in $(ifconfig | cut -f1 -d: | grep '^[a-z]' | grep -v lo)
do
    printf "$(ifconfig ${i} |grep inet | grep -v inet6 | awk '{print $2}') $(uname -n | cut -f1 -d.) $(uname -n)\n">>/etc/hosts
done

# install pre-reqs
printf "installing requirements...\n"
# install required packages
# need EPEL
#sed -i.prev s/enabled=1/enabled=0/g /etc/yum/pluginconf.d/fastestmirror.conf
yum clean all
yum makecache
yum install -y epel-release libselinux-python
[[ -x /bin/python ]] || yum install -y python
[[ -x /bin/ansbile ]] || yum install -y ansible
[[ -x /bin/tmux ]] || yum install -y tmux
[[ -x /bin/wget ]] || yum install -y wget
[[ -x /bin/git ]] || yum install -y git

# create the depot
printf "generating depot structure..."
for d in vault keys files quarantine
do
    mkdir -p ${DEPOT}/${d}
done
chown -R root: ${DEPOT}
chmod 700 ${DEPOT}

printf "building quarantine..."
# build file quarantine
QUARANTINE="${DEPOT}/quarantine"
chmod 700 ${QUARANTINE}

printf "open the pod bay doors HAL...\n"
for u in hal9000 dave2001 root
do
    printf "enter password for ${u}: \n"
    h_password="$(python -c 'import crypt,getpass; print(crypt.crypt(getpass.getpass(),crypt.METHOD_SHA512))')"
    [[ -d ${DEPOT}/vault ]] || mkdir -p ${DEPOT}/vault
    USERVAULT="${DEPOT}/vault/${u}.yml"
    echo "h_password: ${h_password}" > ${USERVAULT}
    # add more to the vault
    case "${u}" in
        hal9000)
            USERID="111111"
            ;;
        dave2001)
            USERID="111112"
            ;;
        root)
            USERID="0"
            ;;
    esac
    printf "orcman: ${u}\norcman_id: ${USERID}\n" >> ${USERVAULT}
done

printf "populating the structure...\n"
# pull the things

git clone ${GITHOLE}
for t in ansible scripts
do
    cp -r ~/Linux-Subteam/${t} ${DEPOT}/
done

# pull the collections
ansible-galaxy collection install ${COLLECTIONS}

ansible-playbook -i ${DEPOT}/ansible/netlab -l discovery ${PB_BASE}/parking_orbit.yml

# pull the collections for hal
su -c "ansible-galaxy collection install ${COLLECTIONS}" hal9000
