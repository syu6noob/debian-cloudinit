#!/bin/bash
set -euxo pipefail

echo -e "\e[1;42m syu6noob/docker-cloudinit \e[0m"

password="password"
user=`whoami`

while (( $# > 0 ))
do
  case $1 in
    --timezone)
      echo -e "\e[1;42m syu6noob/docker-cloudinit \e[0m setting timezone..."
      
      sudo timedatectl set-timezone Asia/Tokyo
      
      echo -e "\e[1;42m syu6noob/docker-cloudinit \e[0m timezone setting was completed."
      ;;
    --xtermjs)
      sudo tee "/etc/default/grub" > /dev/null << EOF
# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.
# For full documentation of the options in this file, see:
#    info -f grub -n 'Simple configuration'

GRUB_DEFAULT=0
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR='lsb_release -i -s 2> /dev/null | | echo Debian'
GRUB_CMDLINE_LINUX_DEFAULT=""
GRUB_CMDLINE_LINUX="console=tty0 console=ttyS0,115200 consoleblank=0"
GRUB_TERMINAL="serial"
GRUB_SERIAL_COMMAND="serial -- speed=115200"

EOF

      sudo update-grub
      ;;
    --qemu)
      echo -e "\e[1;42m syu6noob/docker-cloudinit \e[0m setting qemu..."
      
      sudo apt -y install qemu-guest-agent
      sudo systemctl start qemu-guest-agent
      
      echo -e "\e[1;42m syu6noob/docker-cloudinit \e[0m qemu setting was completed."
      ;;
    --code)
      echo -e "\e[1;42m syu6noob/docker-cloudinit \e[0m setting code-server..."

      cd ~
      curl -fsSL https://code-server.dev/install.sh | sh

      sudo mkdir -p "/home/$user/.config/code-server"
      sudo tee "/home/$user/.config/code-server/config.yaml" > /dev/null << EOF
bind-addr: 0.0.0.0:8080
auth: password
password: $password
cert: true
EOF
      
      sudo systemctl enable --now "code-server@$user"
      sudo systemctl start --now "code-server@$user"

      echo -e "\e[1;42m syu6noob/docker-cloudinit \e[0m code-server setting was completed."
      ;;
      
    --docker)
      echo -e "\e[1;42m syu6noob/docker-cloudinit \e[0m setting docker..."
      
      sudo apt install -y dbus-user-session
      sudo apt install -y slirp4netns
      sudo apt install -y uidmap

      curl -fsSL https://get.docker.com/rootless | sh

      systemctl --user start docker
      systemctl --user enable docker

      sudo loginctl enable-linger $(whoami)
      
      echo -e "\e[1;42m syu6noob/docker-cloudinit \e[0m docker setting was completed."
      ;;
  esac
  shift
done
