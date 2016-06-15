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
send "cd iozone3_434/src/current\r"
expect "$*"
send "sudo ./iozone -a -n 512m -g 8g -i 0 -i 1 -i 5 -f /mnt/iozone -Rb ./iozone.xls\r"
expect ":*"
send "$sshPassWord\r"
sleep 30
expect eof