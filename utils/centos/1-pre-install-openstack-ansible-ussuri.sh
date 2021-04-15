#!/bin/bash
###
### pre-install openstack-ansible
###
### 1. install repo
### 2. install pkg
### 3. setup environment variables
### 4. downgrade systemd (need versionlock)
###
echo -e "\033[31;1m=== install repo \033[0m"
dnf -y install https://repos.fedorapeople.org/repos/openstack/openstack-ussuri/rdo-release-ussuri.el8.rpm
dnf config-manager --set-enabled powertools
dnf -y install epel-release

echo -e "\033[31;1m=== install pkg \033[0m"
dnf -y group install "Development Tools"
dnf -y install git chrony openssh-server python3-devel sudo iputils lsof lvm2 chrony openssh-server sudo tcpdump python3 python3-openstackclient openstack-selinux

echo -e "\033[31;1m=== setup environment variables \033[0m"
touch /etc/modules-load.d/openstack-ansible.conf
echo 'bonding' >> /etc/modules-load.d/openstack-ansible.conf
echo '8021q' >> /etc/modules-load.d/openstack-ansible.conf
systemctl stop firewalld
systemctl mask firewalld
systemctl enable chronyd
systemctl start chronyd

echo -e "\033[31;1m=== downgrade systemd \033[0m"
rpm -Uvh --force https://www.rpmfind.net/linux/centos/8.2.2004/BaseOS/x86_64/os/Packages/systemd-239-29.el8.x86_64.rpm https://www.rpmfind.net/linux/centos/8.2.2004/BaseOS/x86_64/os/Packages/systemd-libs-239-29.el8.x86_64.rpm https://www.rpmfind.net/linux/centos/8.2.2004/BaseOS/x86_64/os/Packages/systemd-pam-239-29.el8.x86_64.rpm https://www.rpmfind.net/linux/centos/8.2.2004/BaseOS/x86_64/os/Packages/systemd-devel-239-29.el8.x86_64.rpm https://www.rpmfind.net/linux/centos/8.2.2004/BaseOS/x86_64/os/Packages/systemd-udev-239-29.el8.x86_64.rpm https://www.rpmfind.net/linux/centos/8.2.2004/BaseOS/x86_64/os/Packages/systemd-container-239-29.el8.x86_64.rpm
dnf versionlock systemd-239-29.el8.x86_64

