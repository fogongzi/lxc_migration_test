#!/usr/bin/expect -f

set remoteServerHost "10.0.3.13"
set sshName "ubuntu"
set sshPassWord "ubuntu"
set timeout 100

set host "$remoteServerHost"
spawn ssh $sshName@$host
expect_before "no)?" {
send "yes\r" }
sleep 1
expect "password:"
send "$sshPassWord\r"
expect "$*"
send "cd linux-3.13.0\r"
expect "$*"
send "make clean\r"
expect "$*"
send "make -j4\r"
