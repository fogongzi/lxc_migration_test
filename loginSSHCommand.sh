#!/usr/bin/expect -f

set remoteServerHost "192.168.3.132"
set sshName "root"
set sshPassWord "chenxiao"
set timeout 30

stopLXC(){
    set host "$1"
    spawn ssh $2@$host
    expect_before "no)?" {
    send "yes\r" }
    sleep 1
    expect "password:"
    send "$3\r"
    expect "*#"
    send "lxc-stop -n $4\r"
    send "lxc-info -n $4\r"
    send "exit\r"
}

stopLXC $remoteServerHost $sshName $sshPassWord u1


