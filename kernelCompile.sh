#!/usr/bin/expect -f

set remoteServerHost "10.0.3.37"
set sshName "ubuntu"
set sshPassWord "ubuntu"
set timeout 30

set host "$remoteServerHost"
spawn ssh $sshName@$host
expect_before "no)?" {
send "yes\r" }
sleep 1
expect "password:"
send "$sshPassWord\r"
expect "*#"
send "cd linux-3.13.0\r"
echo "cd linux-3.13.0"
send "make clean\r"
sleep 5
echo "make -j4"
send "make -j4\r"
sleep 30
send "exit\r"