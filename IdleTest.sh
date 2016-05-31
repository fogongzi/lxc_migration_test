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

result_file_path=/opt/result_migration
#test threshold
threshold=20
#definite test lxc memory size array
lxc_mem_array=(512 1024 1536 2048 2560 3072 3584)
length=${#lxc_mem_array[@]}
#definite precision
precision_length=6

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
    sleep 20
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

    result_tmp=$result
}

#test SCLXCLM according to the threshold
function test_SCLXCLM() {
    #definite real test iterations
    for i in $lxc_mem_array
    do
        num_real_iters=0
        iters_sum=0
        frozen_time_sum=0
        syn_time_sum=0
        restore_time_sum=0
        total_time_sum=0
        echo "test memory size="${lxc_mem_array[$i]}
        for j in {1..$threshold}
        do
            result_tmp=""
            echo "i="$i" "${lxc_mem_array[$i]}"M"
            SCLXCLM ${lxc_mem_array[$i]}"M"
            echo "******iter"$j":result="$result_tmp
            if [ ${#result_tmp} -gt 8 ]; then
                iter_tmp=`echo $result_tmp | cut -d" " -f1`
                iters_sum=`expr $iters_sum + $iter_tmp`
                frozen_time_tmp=`echo $result_tmp | cut -d" " -f2`
                frozen_time_sum=`expr $frozen_time_sum + $frozen_time_tmp`
                syn_time_tmp=`echo $result_tmp | cut -d" " -f3`
                syn_time_sum=`expr $syn_time_sum + $syn_time_tmp`
                restore_time_tmp=`echo $result_tmp | cut -d" " -f4`
                restore_time_sum=`expr $restore_time_sum + $restore_time_tmp`
                total_time_tmp=`echo $result_tmp | cut -d" " -f5`
                total_time_sum=`expr $total_time_sum + $total_time_tmp`
                #update iters
                num_real_iters=`expr $num_real_iters+1`
            else
                continue
            fi
            sleep 10
        done
        #caluate the result
        real_result=$(awk 'BEGIN{printf "%.0f\n",'$iters_sum'/'$num_real_iters'}')
        real_result=$real_result" "$(awk 'BEGIN{printf "%.'$precision_length'f\n",'$frozen_time_sum'/'$num_real_iters'}')
        real_result=$real_result" "$(awk 'BEGIN{printf "%.'$precision_length'f\n",'$syn_time_sum'/'$num_real_iters'}')
        real_result=$real_result" "$(awk 'BEGIN{printf "%.'$precision_length'f\n",'$restore_time_sum'/'$num_real_iters'}')
        real_result=$real_result" "$(awk 'BEGIN{printf "%.'$precision_length'f\n",'$total_time_sum'/'$num_real_iters'}')
        echo "*******lxc_mem_size="${lxc_mem_array[$i]}"M,result is:"$real_result
        echo ${lxc_mem_array[$i]}"M "$real_result >> $result_file_path
        sleep 30
    done

}

test_SCLXCLM
#result_1024M=""
#SCLXCLM 1024M
#echo "******"$result_1024M
