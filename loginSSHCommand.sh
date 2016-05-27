#!/usr/bin/expect -f

set remoteServerHost "192.168.3.132"
set sshName "root"
set sshPassWord "chenxiao"
set timeout 30

set host "$remoteServerHost"
spawn ssh $sshName@$host
expect_before "no)?" {
send "yes\r" }
sleep 1
expect "password:"
send "$sshPassWord\r"
expect "*#"
send "lxc-start -n u1\r"
sleep 1
send "lxc-stop -n u1\r"
sleep 1
send "lxc-info -n u1\r"
sleep 1
send "exit\r"