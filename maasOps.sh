#!/bin/sh
#
# Devstack
#

if ! [ -f ./config ]; then
	echo "%% You Must write config!!"
	return
fi

source ./config

TOP=$PWD
OUTPUT=$TOP/output
MAAS_STORE=$OUTPUT/maas-node-list
API_KEY_FILE=$OUTPUT/apikey
PROFILE=admin
MAAS_URL=http://$API_SERVER/MAAS/api/2.0

if ! [ -d $OUTPUT ]; then
	echo "Make output directory"
	mkdir $OUTPUT
fi

# import library
source ./lib/maas-lib
source ./lib/utils-lib
source ./lib/infiniband-lib
source ./lib/kernel-lib

function maas-usage() {
	N=1
	echo ""
	echo " Usages:"
	echo ""
	echo "    MaaS REST APIs: "
	echo "      $N) maas-login"
	N=$(($N+1))
	echo "      $N) maas-ip"
	N=$(($N+1))
	echo "      $N) maas-list"
	N=$(($N+1))
	echo "      $N) maas-nodes"
	echo ""
	echo "    Kernel: "
	echo ""
	N=$(($N+1))
	echo "      $N) maas-kernel-install-old"
	N=$(($N+1))
	echo "      $N) maas-kernel-change-default-grub"
	N=$(($N+1))
	echo "      $N) maas-init-env"
	echo ""
	echo "    InfiniBand: "
	N=$(($N+1))
	echo "      $N) maas-ib-check-pci"
	N=$(($N+1))
	echo "      $N) maas-ib-prepare"
	N=$(($N+1))
	echo "      $N) maas-ib-copy-mlnx-ofed"
	N=$(($N+1))
	echo "      $N) maas-ib-install-mlnx-ofed"
	N=$(($N+1))
	echo "      $N) maas-ib-restart-openibd"
	N=$(($N+1))
	echo "      $N) maas-ib-devinfo"
	echo ""
	echo "    Utils: "
	N=$(($N+1))
	echo "      $N) maas-show"
	N=$(($N+1))
	echo "      $N) maas-show-refresh"
	N=$(($N+1))
	echo "      $N) maas-ip-vars"
	N=$(($N+1))
	echo "      $N) maas-show-hostname"
	N=$(($N+1))
	echo "      $N) maas-delete-proxy-apt"
	N=$(($N+1))
	echo "      $N) maas-ssh ARGS"
	N=$(($N+1))
	echo "      $N) maas-scp ARGS"
	N=$(($N+1))
	echo "      $N) maas-clear-ssh-keygen"
	N=$(($N+1))
	echo "      $N) maas-copy-ssh-authkey-into-root"
	echo ""
}

maas-usage
