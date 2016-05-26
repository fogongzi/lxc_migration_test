#!/usr/bin/env bash

function LoopPrint()
{
    count=0;
    while [ $count -lt $1 ];
    do
        echo $count;
        let ++count;
        sleep 1;
    done
    return 0;
}

read -p "Please input the times of print you want: " n;
LoopPrint $n;