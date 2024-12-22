#!/bin/bash
set -euo pipefail

password="password"

sudo apt -y install qemu-guest-agent
sudo systemctl start qemu-guest-agent
sudo systemctl enable qemu-guest-agent

sudo timedatectl set-timezone Asia/Tokyo

while (( $# > 0 ))
do
  case $1 in
    # ...
    --code)
      # For code-server
      sudo curl -fsSL https://code-server.dev/install.sh | sh
      
      cat <<EOF > "/root/.config/code-server/config.yaml"
bind-addr: 0.0.0.0:8080
auth: password
password: $password
cert: false
EOF
      
      sudo systemctl enable --now code-server@root
      sudo systemctl start --now code-server@root
      ;;
    # ...
  esac
  shift
done
