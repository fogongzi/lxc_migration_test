#!/bin/bash
#test idle benchemark
phaul_root_dir=/software/criu_software/p.haul
phaul_cp_dir=/software/criu_software/p.haul/phaul
stop_and_copy_file=iters.py.bak
pre_copy_file=iters.py.pre_bak
pre_copy_ratio_file=iters.py.pre_ratio_bak
sel_pre_copy_file=iters.py.sel_pre_bak
iter_copy_file=iters.py

#stop and copy SCLXCLM
function SCLXCLM() {
    #do some installation
    cd $phaul_cp_dir;
    cp $stop_and_copy_file $iter_copy_file;
    cd $phaul_root_dir
    python setup.py install;

    #
}