#!/bin/bash

RUNNING_CONTAINERS="$(lxc-ls)"

for container in $RUNNING_CONTAINERS; do
        echo "Destroying $container..."
        lxc-autostart --kill --all
        lxc-destroy --name $container
done
