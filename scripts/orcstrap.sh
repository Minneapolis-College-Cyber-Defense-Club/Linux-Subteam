#!/bin/bash

export PATH=/bin:/sbin:/usr/bin:/usr/sbin

# initial checks
if [[ $(whomai) != "root" ]]; then   
    printf "Must run as root.\n"
    exit 666
fi
# make sure it is setup on the expected OS
if [[ $(grep '^ID=' /etc/os-release | awk -F\" '{print $2}') = "centos" ]] && [[ $(grep '^VERISON_ID=' /etc/os-release | awk -F\" '{print $2}') = "7" ]]; then
    printf "correct OS detected...\n"
else
    printf "wrong OS detected...bye.\b"
    exit 667
fi

# build file quarantine
QUARANTINE=/root/quarantine
mkdir ${QUARANTINE}
chown root:${QUARANTINE}
chmod 700 ${QUARANTINE}

# global vars
DNS="1.1.1.1"
HOSTNAME="$(uname -n)"
DEPOT="/depot"

# basic security and functionality checks
# at this point /etc/resolv.conf should have been fixed via kill chain BUT VALIDATE
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
# clean out crontabs
mkdir ${QUARANTINE}/crons
for c in $(ls /var/spool/cron)
do
    mv /var/spool/${c}  ${QUARANTINE}/crons/
    [[ -f /var/spool/${c} ]] && rm -f /var/spool/${c}
done


# install required packages
yum install -y epel-release
[[ -x /bin/python ]] || yum install -y python
[[ -x /bin/ansbile ]] || yum install -y ansible
[[ -x /bin/wget ]] || yum install -y wget
[[ -x /bin/git ]] || yum install -y git

# you should probably already have wget installed by this point, but validate
if [[ -x /bin/wget ]]; then
    PULLER="/bin/wget"
elif [[ -x /bin/curl ]]; then
    PULLER="/bin/curl"
else
    printf "Unable to determine URL pull tool, install wget.\n"
fi

# create the depot
for d in vault keys files ansible
do
    mkdir -p ${DEPOT}/${d}
done
chown -R root: ${DEPOT}

# create things needed
for u in hal9000 dave2001
do
    #read -p "enter password for ${u}: " u_password
    h_password="$(python -c 'import crypt,getpass; print(crypt.crypt(getpass.getpass(),crypt.mksalt(METHOD_SHA512)))')"
    [[ -d ${DEPOT}/vault ]] || mkdir -p ${DEPOT}/vault
    echo "${u}_password: ${h_password}" > ${DEPOT}/vault/${u}.yml

    case "${u}" in
        hal9000)
            uid=111111
            gid=111111
            ;;
        dave2001)
            uid=111112
            gid=111112
            ;;
    esac
# group creation
    grep "${u}" /etc/group
    groupadd -g "${gid}" "${u}"
    case $? in
        0) 
            printf "groupadd successful...\n"
            grep "${u}" /etc/group
            ;;
        *)
            printf "groupadd failed, fix issue and re-run.\n"
            exit 1
            ;;
    esac
# user creation
#    useradd -m -u "${uid}" -g "${gid}" -s/bin/bash -c"${u}" ${u}
#    case $? in
#        0) printf "${u} added, generating ssh keys...\n"
#            ssh-keygen -q -N "" -f ${DEPOT}/keys/${u} -t rsa -b 4096 -m pem
#            chown ${u}: ${DEPOT}/keys/${u}*
#            chmod 

done

# open the pod bay doors
