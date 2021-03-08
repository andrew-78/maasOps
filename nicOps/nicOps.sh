#!/bin/bash

RUSER=root
RHOME="/root"
NODES_PATH=./etc/nodes-name
NODES_IP_PATH=./etc/nodes-ip
VM_LIST=`cat $NODES_PATH`
VM_IP_LIST=`cat $NODES_IP_PATH`

source config
source ./lib/lib-ssh

VLAN_MGMT=vlan101
VLAN_REPLICA=vlan102
VLAN_VXLAN=vlan103
VLAN_STORAGE=vlan104
MTU_STORAGE=4900

source ./lib/lib-network-controller
source ./lib/lib-network-compute
source ./lib/lib-network-ironic
source ./lib/lib-network-storage

REMOTE_NET_CONF_PATH="/etc/netplan/50-cloud-init.yaml"

function usage() {
    echo "make_controller_net public_addr public_gw_addr mgmt_addr storage_addr vxlan_addr replica_addr vlan_addr"
    echo ""
    echo "  1) public_addr"
    echo "          : e.g. 180.1.1.11/24"
    echo "  2) public_gw_addr"
    echo "          : e.g. 180.1.1.1"
    echo "  3) mgmt_addr"
    echo "          : e.g. 172.10.2.11/24"
    echo "  4) storage_addr"
    echo "          : e.g. 172.10.3.11/24"
    echo "  5) vxlan_addr"
    echo "          : e.g. 172.10.4.11/24"
    echo "  6) replica_addr"
    echo "          : e.g. 172.10.5.11/24"
    echo "  7) vlan_addr"
    echo "          : e.g. 172.10.6.11/24"
}

function write_file()
{
    FILE_NAME=$1
    CONF_STR=$2
    cat << EOF > $FILE_NAME
$CONF_STR
EOF
}

function check-node()
{
    NODE=$1
    if [ -z ${NODE##*"controller"*} ] ;then
        # controller node
        echo "controller ==> $NODE"
    elif [ -z ${NODE##*"compute"*} ] ;then
        # compute node
        echo "compute ==> $NODE"
    elif [ -z ${NODE##*"storage"*} ] ;then
        # storage node
        echo "storage ==> $NODE"
    elif [ -z ${NODE##*"ceph"*} ] ;then
        # storage node
        echo "storage ==> $NODE"
    else
        echo "unknown ==> $NODE"
        # unknown server
    fi
}

function nic-make-network-config()
{
    EX=$EX_NUM
    MGMT=$MGMT_NUM
    STORAGE=$STORAGE_NUM
    VXLAN=$VXLAN_NUM
    REPLICA=$REPLICA_NUM
    VLAN=$VLAN_NUM

    if [ ! -d "output" ] ;then
	    echo "mkdir output"
	    mkdir output
    fi
    for NODE in $VM_LIST
    do
        EX_ADDR="$EX_PREFIX.$EX/$EX_PREFIX_LEN"
        MGMT_ADDR="$MGMT_PREFIX.$MGMT/$MGMT_PREFIX_LEN"
        STORAGE_ADDR="$STORAGE_PREFIX.$STORAGE/$STORAGE_PREFIX_LEN"
        VXLAN_ADDR="$VXLAN_PREFIX.$VXLAN/$VXLAN_PREFIX_LEN"
        REPLICA_ADDR="$REPLICA_PREFIX.$REPLICA/$REPLICA_PREFIX_LEN"
        VLAN_ADDR="$VLAN_PREFIX.$VLAN/$VLAN_PREFIX_LEN"

        EX=$(($EX+1))
        MGMT=$(($MGMT+1))
        STORAGE=$(($STORAGE+1))
        VXLAN=$(($VXLAN+1))
        REPLICA=$(($REPLICA+1))
        VLAN=$(($VLAN+1))

        echo "#--------------------------------------------------------------------------------"
        echo "# $NODE"
        if [ -z ${NODE##*"controller1"*} ] ;then
            make_network_controller1 $EX_ADDR $EX_GW_ADDR $MGMT_ADDR $STORAGE_ADDR $VXLAN_ADDR $REPLICA_ADDR $VLAN_ADDR $NODE
        elif [ -z ${NODE##*"controller2"*} ] ;then
            make_network_controller2 $EX_ADDR $EX_GW_ADDR $MGMT_ADDR $STORAGE_ADDR $VXLAN_ADDR $REPLICA_ADDR $VLAN_ADDR $NODE
        elif [ -z ${NODE##*"controller3"*} ] ;then
            make_network_controller3 $EX_ADDR $EX_GW_ADDR $MGMT_ADDR $STORAGE_ADDR $VXLAN_ADDR $REPLICA_ADDR $VLAN_ADDR $NODE
        elif [ -z ${NODE##*"ironic1"*} ] ;then
            make_network_ironic1 $EX_ADDR $EX_GW_ADDR $MGMT_ADDR $STORAGE_ADDR $VXLAN_ADDR $REPLICA_ADDR $VLAN_ADDR $NODE
        elif [ -z ${NODE##*"ironic2"*} ] ;then
            make_network_ironic2 $EX_ADDR $EX_GW_ADDR $MGMT_ADDR $STORAGE_ADDR $VXLAN_ADDR $REPLICA_ADDR $VLAN_ADDR $NODE
        elif [ -z ${NODE##*"compute1"*} ] ;then
            make_network_compute1 $EX_ADDR $EX_GW_ADDR $MGMT_ADDR $STORAGE_ADDR $VXLAN_ADDR $REPLICA_ADDR $VLAN_ADDR $NODE
        elif [ -z ${NODE##*"compute2"*} ] ;then
            make_network_compute2 $EX_ADDR $EX_GW_ADDR $MGMT_ADDR $STORAGE_ADDR $VXLAN_ADDR $REPLICA_ADDR $VLAN_ADDR $NODE
        elif [ -z ${NODE##*"storage1"*} ] ;then
            make_network_storage1 $EX_ADDR $EX_GW_ADDR $MGMT_ADDR $STORAGE_ADDR $VXLAN_ADDR $REPLICA_ADDR $VLAN_ADDR $NODE
        elif [ -z ${NODE##*"storage2"*} ] ;then
            make_network_storage2 $EX_ADDR $EX_GW_ADDR $MGMT_ADDR $STORAGE_ADDR $VXLAN_ADDR $REPLICA_ADDR $VLAN_ADDR $NODE
        else
            # unknown server
            echo "#--------------------------------------------------------------------------------"
            echo "# UNKNOWN : $NODE  --> skip XXXX "
        fi
    done
}

function nic-scp-network-config()
{
    EX=$EX_NUM
    MGMT=$MGMT_NUM
    STORAGE=$STORAGE_NUM
    VXLAN=$VXLAN_NUM
    REPLICA=$REPLICA_NUM

    for NODE in $VM_LIST
    do
        EX_ADDR="$EX_PREFIX.$EX/$EX_PREFIX_LEN"
        MGMT_ADDR="$MGMT_PREFIX.$MGMT/$MGMT_PREFIX_LEN"
        STORAGE_ADDR="$STORAGE_PREFIX.$STORAGE/$STORAGE_PREFIX_LEN"
        VXLAN_ADDR="$VXLAN_PREFIX.$VXLAN/$VXLAN_PREFIX_LEN"
        REPLICA_ADDR="$REPLICA_PREFIX.$REPLICA/$REPLICA_PREFIX_LEN"

        EX=$(($EX+1))
        MGMT=$(($MGMT+1))
        STORAGE=$(($STORAGE+1))
        VXLAN=$(($VXLAN+1))
        REPLICA=$(($REPLICA+1))

        echo "#--------------------------------------------------------------------------------"
        if [ -f output/$NODE.net.conf ] ; then
            echo "# sshpass scp -o StrictHostKeyChecking=no $NODE.net.conf $RUSER@$NODE:$RHOME"
            sshpass scp -o StrictHostKeyChecking=no output/$NODE.net.conf $RUSER@$NODE:$RHOME
            echo "# sshpass scp -o StrictHostKeyChecking=no etc/br-dummy0.cfg $RUSER@$NODE:$RHOME"
            sshpass scp -o StrictHostKeyChecking=no etc/br-dummy0.cfg $RUSER@$NODE:$RHOME
            echo "# sshpass scp -o StrictHostKeyChecking=no etc/br-dummy1.cfg $RUSER@$NODE:$RHOME"
            sshpass scp -o StrictHostKeyChecking=no etc/br-dummy1.cfg $RUSER@$NODE:$RHOME
        else
            echo "WARN: output/$Node.net.conf dosen't exist!"
        fi
    done

}

function nic-mv-network-config()
{
    for NODE in $VM_LIST
    do
        echo "#--------------------------------------------------------------------------------"
        echo "# sshpass ssh -o StrictHostKeyChecking=no $RUSER@$NODE mv $NODE.net.conf $REMOTE_NET_CONF_PATH"
        sshpass ssh -o StrictHostKeyChecking=no $RUSER@$NODE mv $NODE.net.conf $REMOTE_NET_CONF_PATH
        echo "# sshpass ssh -o StrictHostKeyChecking=no $RUSER@$NODE mkdir -p /etc/network/interfaces.d/"
        sshpass ssh -o StrictHostKeyChecking=no $RUSER@$NODE mkdir -p /etc/network/interfaces.d/
        echo "# sshpass ssh -o StrictHostKeyChecking=no $RUSER@$NODE cp br-dummy0.cfg /etc/network/interfaces.d/"
        sshpass ssh -o StrictHostKeyChecking=no $RUSER@$NODE cp br-dummy0.cfg /etc/network/interfaces.d/
        echo "# sshpass ssh -o StrictHostKeyChecking=no $RUSER@$NODE cp br-dummy1.cfg /etc/network/interfaces.d/"
        sshpass ssh -o StrictHostKeyChecking=no $RUSER@$NODE cp br-dummy1.cfg /etc/network/interfaces.d/
    done
}

function nic-apply-network-config()
{
    for NODE in $VM_LIST
    do
        echo "#--------------------------------------------------------------------------------"
        echo "# sshpass ssh -o StrictHostKeyChecking=no $RUSER@$NODE reboot"
        sshpass ssh -o StrictHostKeyChecking=no $RUSER@$NODE reboot
    done
}

function nic-get-ip-address()
{
    EX=$EX_NUM
    MGMT=$MGMT_NUM
    STORAGE=$STORAGE_NUM
    VXLAN=$VXLAN_NUM
    REPLICA=$REPLICA_NUM

    for NODE in $VM_LIST
    do
        EX_ADDR="$EX_PREFIX.$EX/$EX_PREFIX_LEN"
        MGMT_ADDR="$MGMT_PREFIX.$MGMT/$MGMT_PREFIX_LEN"
        STORAGE_ADDR="$STORAGE_PREFIX.$STORAGE/$STORAGE_PREFIX_LEN"
        VXLAN_ADDR="$VXLAN_PREFIX.$VXLAN/$VXLAN_PREFIX_LEN"
        REPLICA_ADDR="$REPLICA_PREFIX.$REPLICA/$REPLICA_PREFIX_LEN"

        ADDR=$MGMT_ADDR
        echo "$ADDR $NODE"

        EX=$(($EX+1))
        MGMT=$(($MGMT+1))
        STORAGE=$(($STORAGE+1))
        VXLAN=$(($VXLAN+1))
        REPLICA=$(($REPLICA+1))
    done
}

function nic-help()
{
    N=0
    echo ''
    echo '  Usage: '
    echo ''
    echo '   To configure Server Network'
    N=$(($N+1))
    echo "      $N) nic-make-network-config"
    N=$(($N+1))
    echo "      $N) nic-scp-network-config"
    N=$(($N+1))
    echo "      $N) nic-mv-network-config"
    N=$(($N+1))
    echo "      $N) nic-apply-network-config"
    N=$(($N+1))
    echo "      $N) nic-get-ip-address"
    echo ''
    echo '   etc.'
    N=$(($N+1))
    echo "      $N) nic-ssh ARGS"
    N=$(($N+1))
    echo "      $N) nic-scp ARGS"
    echo ''

}

nic-help

