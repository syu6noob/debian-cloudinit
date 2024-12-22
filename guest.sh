#!/bin/bash
set -euxo pipefail

password="password"
user=`whoami`

sudo apt -y install qemu-guest-agent
sudo systemctl start qemu-guest-agent

sudo timedatectl set-timezone Asia/Tokyo

while (( $# > 0 ))
do
  case $1 in
    --code)
      # For code-server
      cd ~
      curl -fsSL https://code-server.dev/install.sh | sh
      
      cat <<EOF > "/home/$user/.config/code-server/config.yaml"
bind-addr: 0.0.0.0:8080
auth: password
password: $password
cert: true
EOF
      
      sudo systemctl enable --now "code-server@$user"
      sudo systemctl start --now "code-server@$user"
      ;;
      
    --docker)
      sudo apt install -y dbus-user-session
      sudo apt install -y slirp4netns
      sudo apt install -y uidmap

      curl -fsSL https://get.docker.com/rootless | sh

      systemctl --user start docker
      systemctl --user enable docker

      sudo loginctl enable-linger $(whoami)
      ;;
  esac
  shift
done
