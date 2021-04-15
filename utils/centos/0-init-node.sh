#!/bin/bash
###
### initial setup
###
### 1. install dnf-versionlock
### 2. upgrade (can skip, but recommend)
### 3. modify environment variables
### 4. shutdown
###
echo -e "\033[31;1m=== install dnf-command(vsersionlock) \033[0m"
dnf -y install 'dnf-command(versionlock)' vim

echo -e "\033[31;1m=== upgrade \033[0m"
dnf -y upgrade

echo -e "\033[31;1m=== modify selinux, grub \033[0m"
vi /etc/selinux/config
vi /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

echo -e "\033[31;1m=== shutdown -h now, do it! \033[0m"

