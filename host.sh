#!/bin/bash
set -euo pipefail

# run this script as a root

# variables
VM_ID=9000
VM_NAME="debian12-cloudinit"
HOST_DISK="local-zfs"

cd /root/

echo "Running script.sh..."

# download an image
sudo wget -P /root/ https://cdimage.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2

# create vm
sudo qm create ${VM_ID} --name ${VM_NAME} --net0 virtio,bridge=vmbr0
sudo qm importdisk ${VM_ID} ./debian-12-generic-amd64.qcow2 ${HOST_DISK}
sudo qm set ${VM_ID} --scsihw virtio-scsi-pci --scsi0 ${HOST_DISK}:vm-${VM_ID}-disk-0,discard=on
sudo qm set ${VM_ID} --ide2 ${HOST_DISK}:cloudinit
sudo qm set ${VM_ID} --serial0 socket
sudo qm set ${VM_ID} --ostype l26
sudo qm set ${VM_ID} --memory 2048
sudo qm set ${VM_ID} --boot c --bootdisk scsi0
sudo qm resize ${VM_ID} scsi0 16G
sudo qm set ${VM_ID} --agent enabled=1
sudo qm template ${VM_ID}

# remove the image
sudo rm ./debian-12-generic-amd64.qcow2
