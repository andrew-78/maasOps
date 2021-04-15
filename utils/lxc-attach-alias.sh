touch ~/.bash_aliases

lxc_full=$(lxc-ls)
lxc_short=$(echo $lxc_full | sed -r 's:controller[1-3]_::g' | sed -r 's:_container*::g' | sed 's:[^-]* ::g' | sed 's:-: :g' | sed 's:ceph::g' | sed 's:ceilometer_central:ceilo:g' | sed 's:cinder_api:cinder:g' | sed 's:heat_api:heat:g' | sed 's:neutron_server:neutron:g' | sed 's:nova_api:nova:g' | sed 's:rabbit_mq:rabbit:g')

lxc_full_list=($(echo $lxc_full | tr ' ' "\n"))
lxc_short_list=($(echo $lxc_short | tr ' ' "\n"))
unset lxc_short_list[-1]
lxc_num=$(echo "$lxc_full" | wc -w)
lxc_num=$((lxc_num-=1))

for i in $(seq 0 $lxc_num);	do
	alias ${lxc_short_list[i]}="lxc-attach -n ${lxc_full_list[i]}"
done

alias >> ~/.bash_aliases
