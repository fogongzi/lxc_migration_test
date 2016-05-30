#!/bin/bash
#test idle benchemark
phaul_root_dir=/software/criu_software/p.haul
phaul_cp_dir=/software/criu_software/p.haul/phaul
stop_and_copy_file=iters.py.bak
pre_copy_file=iters.py.pre_bak
pre_copy_ratio_file=iters.py.pre_ratio_bak
sel_pre_copy_file=iters.py.sel_pre_bak
iter_copy_file=iters.py
migration_logs_file_path=/opt/lxc_mifration_log
lxc_name=u1
lxc_config_path=/var/lib/lxc/$lxc_name/config
remote_server_IP=192.168.3.132
phaul_execute_file_path=/software/criu_software/p.haul/p.haul-wrap
login_SSH_command_path=/software/criu_software/shell_test/lxc_migration_test/loginSSHCommand.sh

#stop and copy SCLXCLM
function SCLXCLM() {
    lxc_mem_size=$1;
    #do some installation
    cd $phaul_cp_dir;
    cp $stop_and_copy_file $iter_copy_file;
    cd $phaul_root_dir;
    python setup.py install;

    #modify lxc memory size
    sed -i "s#^lxc.cgroup.memory.limit_in_bytes = .*#lxc.cgroup.memory.limit_in_bytes = $lxc_mem_size#g"  $lxc_config_path
    #launch lxc
    lxc-start -n $lxc_name
    #do migration
    if [ -d "$migration_logs_file_path" ]; then
        rm -rf "$migration_logs_file_path"
    fi
    $phaul_execute_file_path client $remote_server_IP lxc $lxc_name > $migration_logs_file_path 2>&1
    sleep 30
    #get number of iterations
    result=`cat $migration_logs_file_path | grep iterations= | cut -d"=" -f2`
    #get downtime(frozen time)
    frozen_time=`cat $migration_logs_file_path | grep 'frozen time is' | cut -d"~" -f2 | cut -d" " -f1`
    result=$result" "$frozen_time
    #get syn time
    syn_time=`cat $migration_logs_file_path | grep 'img sync time is' | cut -d"~" -f2 | cut -d" " -f1`
    result=$result" "$syn_time
    #get restore time
    restore_time=`cat $migration_logs_file_path | grep 'restore time is' | cut -d"~" -f2 | cut -d" " -f1`
    result=$result" "$restore_time
    #get total time
    total_time=`cat $migration_logs_file_path | grep 'total time is' | cut -d"~" -f2 | cut -d" " -f1`
    result=$result" "$total_time

    #stop remote lxc
    $login_SSH_command_path

    return $result
}

result_1024=`SCLXCLM 1024M`
echo "**********"$result_1024