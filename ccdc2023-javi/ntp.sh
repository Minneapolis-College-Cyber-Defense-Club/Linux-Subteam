#!/bin/zsh
sudo apt-get update
sudo apt-get install -y ntp


# Verifica si el usuario es root
if [[ $EUID -ne 0 ]]; then
   echo "Este script debe ser ejecutado como root" 
   exit 1
fi

# Instala el paquete ntp si no está instalado
if ! dpkg -s ntp >/dev/null 2>&1; then
    apt-get update
    apt-get install -y ntp
fi

# Configura la lista de servidores NTP
cat <<EOT > /etc/ntp.conf
server 0.debian.pool.ntp.org
server 1.debian.pool.ntp.org
server 2.debian.pool.ntp.org
server 3.debian.pool.ntp.org
EOT

# Reinicia el servicio NTP
service ntp restart

echo "Servidor NTP configurado exitosamente."
