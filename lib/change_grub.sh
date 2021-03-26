#!/bin/bash
GRUB_FILE=/etc/default/grub
DUMP_FILE=grub.cfg
sudo sed 's/GRUB_DEFAULT=0/GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux 5.4.0-26-generic"/g' $GRUB_FILE > $DUMP_FILE
if [ -f $GRUB_FILE ]; then
    echo "sudo mv $DUMP_FILE $GRUB_FILE"
    sudo mv $DUMP_FILE $GRUB_FILE
fi

SSH_ORG=/etc/ssh/sshd_config
SSH_MOD=sshd.cfg
sudo sed 's/PasswordAuthentication no/PasswordAuthentication yes/g' $SSH_ORG> $SSH_MOD
if [ -f $SSH_ORG ]; then
    echo "sudo mv $SSH_MOD $SSH_ORG"
    sudo mv $SSH_MOD $SSH_ORG
    echo "sudo systemctl restart sshd"
    sudo systemctl restart sshd
fi

