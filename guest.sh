#!/bin/bash
set -euo pipefail

sudo apt -y install qemu-guest-agent
sudo systemctl start qemu-guest-agent
sudo systemctl enable qemu-guest-agent

sudo timedatectl set-timezone Asia/Tokyo
