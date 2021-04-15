#!/bin/bash
###
### 1. system service
### 2. environment variables
### 3. repo check
###
echo -e "\033[31;1m=== system service status check \033[0m"
systemctl status NetworkManager
systemctl status firewalld
systemctl status chronyd

echo -e "\033[31;1m=== environment variables check \033[0m"
cat /etc/selinux/config
cat /etc/modules-load.d/openstack-ansible.conf
rpm -qa | grep systemd

echo -e "\033[31;1m=== repository check \033[0m"
dnf repolist all
dnf -y install fmt

echo -e "\033[31;1m=== kernel version check \033[0m"
unanme -r

echo -e "\033[31;1m=== setup Network and VM clone(if you need), do it! \033[0m"

