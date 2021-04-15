#!/bin/bash
echo -e "\033[31;1m=== copy ssh-key -> controller1\033[0m"
ssh-copy-id controller1
echo -e "\033[31;1m=== copy ssh-key -> controller2\033[0m"
ssh-copy-id controller2
echo -e "\033[31;1m=== copy ssh-key -> controller3\033[0m"
ssh-copy-id controller3
echo -e "\033[31;1m=== copy ssh-key -> compute1\033[0m"
ssh-copy-id compute1
echo -e "\033[31;1m=== copy ssh-key -> ceph1\033[0m"
ssh-copy-id ceph1
echo -e "\033[31;1m=== copy ssh-key -> ceph2\033[0m"
ssh-copy-id ceph2
echo -e "\033[31;1m=== copy ssh-key -> ceph3\033[0m"
ssh-copy-id ceph3

