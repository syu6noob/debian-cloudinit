#!/bin/bash
set -euo pipefail

password="password"
user="root"

sudo apt -y install qemu-guest-agent
sudo systemctl start qemu-guest-agent

sudo timedatectl set-timezone Asia/Tokyo

while (( $# > 0 ))
do
  case $1 in
    # ...
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
    # ...
  esac
  shift
done
