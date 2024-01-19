#!/bin/bash

#eliminamos los actuales y hacemos copia en /respaldo



# Copiar ~/.bashrc a /respaldos/bashrc
sudo cp ~/.bashrc .bashrc._backup



# Eliminar las líneas que comienzan con "alias" en ~/.bashrc
sed -i.bak '/^alias/d' ~/.bashrc

echo "Se ha realizado el respaldo y se han eliminado las líneas con 'alias' de ~/.bashrc"


echo ""
echo 'alias cat="/bin/batcat --paging=never"' >> ~/.bashrc
echo 'alias catn="cat"' >> ~/.bashrc00
echo 'alias catnl="batcat"' >> ~/.bashrc


#ufw alias
echo "alias ufws='sudo ufw status'"  >> ~/.bashrc
echo "alias ufwe='sudo ufw enable'"  >> ~/.bashrc
echo "alias ufwr='sudo ufw reload'"  >> ~/.bashrc

#instalar zsh solamente
echo "alias c1='git clone https://github.com/romkatv/powerlevel10k.git \$ZSH_CUSTOM/themes/powerlevel10k'" >> ~/.bashrc
echo "alias c2='sed -i \"s/ZSH_THEME=\\\"robbyrussell\\\"/ZSH_THEME=\\\"powerlevel10k\/powerlevel10k\\\"/\" ~/.bashrc'" >> ~/.bashrc
echo "alias c3='sed -i \"s/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting sudo)/\" ~/.bashrc'" >> ~/.bashrc
echo "alias c4='git clone https://github.com/zsh-users/zsh-autosuggestions \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions'" >> ~/.bashrc
echo "alias c5='git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting'" >> ~/.bashrc


#f2ban
echo "alias rs2='sudo nano /etc/rsyslog.conf'" >> ~/.bashrc 
echo "alias f2mod='sudo nano /etc/fail2ban/jail.local'" >> ~/.bashrc
echo "alias f2r='sudo systemctl restart fail2ban'" >> ~/.bashrc
echo "alias f2s='sudo systemctl status fail2ban'" >> ~/.bashrc

# Agregar alias a .bashrc
echo "alias smbserver='impacket-smbserver smbFolder \$(pwd) -smb2support'" >> ~/.bashrc
echo "alias kalideb='sudo cp /etc/apt/sources.list.kali /etc/apt/sources.list'" >> ~/.bashrc
echo "alias nokali='sudo cp /etc/apt/sources.list.debian /etc/apt/sources.list'" >> ~/.bashrc
echo "alias rmk='() { scrub -p dod \$1; shred -zun 10 -v \$1; }'" >> ~/.bashrc
echo "alias inst='sudo apt install'" >> ~/.bashrc
echo "alias bas='nano ~/.bashrc'" >> ~/.bashrc
echo "alias basrc='source ~/.bashrc'" >> ~/.bashrc
echo "alias mkt='mkdir content exploits nmap'" >> ~/.bashrc
echo "alias folder='cd /home/natasha/MaquinasHTB/'" >> ~/.bashrc
echo "alias apu='sudo apt update && sudo apt upgrade'" >> ~/.bashrc
echo "alias pg='ping 8.8.8.8 -c4'" >> ~/.bashrc
echo "alias kittyconf='nano ~/.config/kitty/kitty.conf'" >> ~/.bashrc
echo "alias acceder='echo "marca de la lavadora mayusculas y segundo renglon la letra c mas mi numero"'" >> ~/.bashrc

## de el archivo primera
echo "alias f2r='sudo systemctl restart fail2ban'" >> ~/.bashrc
echo "alias f2s='sudo systemctl status fail2ban'" >> ~/.bashrc
echo "alias expo2='extractPorts allPorts'" >> ~/.bashrc
echo "alias ippp='curl ifconfig.me'" >> ~/.bashrc
echo "alias surfeando='sudo anonsurf start'" >> ~/.bashrc
echo "alias servidor='python3 -m http.server 8000'"  >> ~/.bashrc
echo "alias shortc='nano ~/.config/sxhkd/sxhkdrc'"  >> ~/.bashrc

echo "alias tailscaleinst='curl -fsSL https://tailscale.com/install.sh | sh'"  >> ~/.bashrc
echo "alias vm-to='sudo apt install -y --reinstall open-vm-tools-desktop'" >> ~/.bashrc

echo "alias pantalla='nano ~/.config/bspwm/bspwmrc'"  >> ~/.bashrc
echo "alias notas='ranger $HOME/notas'"  >> ~/.bashrc
#nuevos
#echo "alias cx1='chmod +x '" >> ~/.bashrc
#echo "pgg" | cat - ~/.bashrc > temp && mv temp ~/.bashrc
echo "alias apagar='sudo shutdown -h now'"  >> ~/.bashrc
echo "alias fixsc='cd $HOME/4rji/fixed'" >> ~/.bashrc
#echo "alias bateria='acpi -b'" >> ~/.bashrc
#echo "alias bateria-f='upower -i /org/freedesktop/UPower/devices/battery_BAT0'" >> ~/.bashrc
echo "alias fixsssarch='sudo mv /usr/bin/ssa_arch /usr/bin/ssa'" >> ~/.bashrc
echo "alias bateria='acpi -b'" >> ~/.bashrc
echo "alias bateria-f='upower -i /org/freedesktop/UPower/devices/battery_BAT0'" >> ~/.bashrc


echo "alias mkdirr='function _mkdirr(){ mkdir "$1" && cd "$1" };_mkdirr'"  >> ~/.bashrc
echo "alias g4rji='f(){ git clone https://github.com/4rji/4rji.git && cd 4rji/; unset -f f; }; f'"  >> ~/.bashrc

echo "alias redr='sudo systemctl restart NetworkManager'"  >> ~/.bashrc
echo "alias dormir='sudo systemctl suspend'"  >> ~/.bashrc
echo "alias redr='sudo systemctl restart networking'"  >> ~/.bashrc
#echo 'alias mygpu="DRI_PRIME=1 glxinfo | grep \"OpenGL renderer\"" ' >> ~/.bashrc
echo 'alias pantallin="xrandr --output DP-1 --rotate left --auto --left-of eDP-1" ' >> ~/.bashrc

echo "alias vmware-tools='sudo apt install -y --reinstall open-vm-tools-desktop fuse3'"  >> ~/.bashrc
echo "alias fixwifi='sudo wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf && sudo dhclient wlan0'"  >> ~/.bashrc
echo "alias wse='wormhole send '"  >> ~/.bashrc
echo "alias wre='wormhole receive '"  >> ~/.bashrc

echo "alias target1.1='cp ~/.config/bin/bateria_backup.sh ~/.config/bin/bateria.sh '"  >> ~/.bashrc

#newbin script with new alias
echo "alias jfirefox='firejail firefox '"  >> ~/.bashrc
echo "alias proxyc='ssh -D 1080 '"  >> ~/.bashrc
echo "alias sse='sudo nano /etc/ssh/sshd_config'"  >> ~/.bashrc
echo "alias ssr='sudo systemctl restart ssh'"  >> ~/.bashrc
echo "alias sst='sudo systemctl stop ssh'"  >> ~/.bashrc
echo "alias sss='sudo systemctl status ssh'"  >> ~/.bashrc

echo "alias blue='sudo systemctl start bluetooth.service'"  >> ~/.bashrc

echo "alias pwndoc='cat $HOME/Downloads/.pwndoc-main.md/pwndoc.md'"  >> ~/.bashrc
echo "alias scanporty='python3 /usr/bin/scanporty.py'"  >> ~/.bashrc
echo "alias itec='sudo openvpn ~/Downloads/.vpnitos/itec.ovpn'"  >> ~/.bashrc
echo "alias 4rj='cd $HOME/Documents/GitHub/4rji'"  >> ~/.bashrc

echo "alias 4rjic='python3 /usr/bin/4rjic'"  >> ~/.bashrc
echo "alias apag='sudo poweroff'"  >> ~/.bashrc
echo 'alias clipo='"'"'history -r | head -n 1 | awk "{\$1=\"\"; print \$0}" | xclip -selection clipboard'"'" >> ~/.bashrc
echo "alias dormir='systemctl suspend'" >> ~/.bashrc

#echo "alias busme='4rjic | grep '" >> ~/.bashrc
echo "alias matavpn='sudo killall openvpn'" >> ~/.bashrc
echo "alias wm='whoami'" >> ~/.bashrc
echo "alias dockercp='echo "ejecutar lo siguiente: docker cp ruta/del/archivo.txt nombre_o_id_del_contenedor:/ruta/del/contenedor/"'" >> ~/.bashrc
echo "alias osr='cat /etc/os-release'" >> ~/.bashrc
echo "alias chator='onionshare-cli --chat --public -v'" >> ~/.bashrc
echo "alias catr='batcat -l rb '" >> ~/.bashrc
echo "alias ddtest='dd if=/dev/zero of=testfile bs=10M count=1000 conv=fdatasync'" >> ~/.bashrc





