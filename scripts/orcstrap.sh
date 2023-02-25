#!/bin/bash

export PATH=/bin:/sbin:/usr/bin:/usr/sbin
# global vars
DNS="1.1.1.1"
HOSTNAME="$(uname -n)"
DEPOT="/depot"
OS="$(grep '^ID=' /etc/os-release | awk -F\" '{print $2}')"
OS_VER="$(grep '^VERISON_ID=' /etc/os-release | awk -F\" '{print $2}')"
URL_BASE="https://raw.githubusercontent.com/Minneapolis-College-Cyber-Defense-Club/Linux-Subteam/main"
SCR_BASE="${URL_BASE}/scripts"
PB_BASE="${URL_BASE}/ansible/playbooks"

# initial checks
if [[ $(/bin/whoami) != 'root' ]]; then   
    printf "Must run as root.\n"
    exit 666
fi
# make sure it is setup on the expected OS
[[ ${OS} != centos && ${OS_VER} != 7 ]] || (printf "wrong os detected...bye.\n" ; exit 667)

# create the depot
for d in vault keys files ansible quarantine
do
    mkdir -p ${DEPOT}/${d}
done
chown -R root: ${DEPOT}

# build file quarantine
QUARANTINE="${DEPOT}/quarantine"
chmod 700 ${QUARANTINE}

# basic security and functionality checks
# at this point /etc/resolv.conf should have been fixed via kill chain BUT VALIDATE
# backup /etc/resolv.conf
cp /etc/resolv.conf ${QUARANTINE}/
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

# backup important files
cp -p /etc/hosts ${QUARANTINE}/
cp -p /root/.bash_history ${QUARANTINE}/root.bash_history
cp -p /etc/ssh/sshd_config ${QUARANTINE}/

# clean out crontabs
mkdir ${QUARANTINE}/crons
for c in $(ls /var/spool/cron)
do
    mv /var/spool/${c}  ${QUARANTINE}/crons/
    [[ -f /var/spool/${c} ]] && rm -f /var/spool/${c}
done


# install required packages
# need EPEL
yum install -y epel-release
[[ -x /bin/python ]] || yum install -y python
[[ -x /bin/ansbile ]] || yum install -y ansible
[[ -x /bin/wget ]] || yum install -y wget
PULLER="/bin/wget"


# create things needed
for u in hal9000 dave2001
do
    h_password="$(python -c 'import crypt,getpass; print(crypt.crypt(getpass.getpass(),crypt.METHOD_SHA512))')"
    [[ -d ${DEPOT}/vault ]] || mkdir -p ${DEPOT}/vault
    echo "${u}_password: ${h_password}" > ${DEPOT}/vault/${u}.yml

    case "${u}" in
        hal9000)
            uid="111111"
            gid="111111"
            ;;
        dave2001)
            uid="111112"
            gid="111112"
            ;;
    esac
# group creation
#    grep "${u}" /etc/group
#    groupadd -g "${gid}" "${u}"
#    case $? in
#        0) 
#            printf "groupadd successful...\n"
#            grep "${u}" /etc/group
#            ;;
#        *)
#            printf "groupadd failed, fix issue and re-run.\n"
#            exit 1
#            ;;
#    esac
# user creation
#    useradd -m -u "${uid}" -g "${gid}" -s/bin/bash -c"${u}" ${u}
#    case $? in
#        0) printf "${u} added, generating ssh keys...\n"
#            ssh-keygen -q -N "" -f ${DEPOT}/keys/${u} -t rsa -b 4096 -m pem
#            chown ${u}: ${DEPOT}/keys/${u}*
#            chmod 

done

# open the pod bay doors
