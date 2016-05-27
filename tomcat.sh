#!/usr/bin/expect -f

set remoteServerHost "10.0.3.37"
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
send "cd apache-tomcat-8.0.35/bin\r"
expect "$*"
send "./startup.sh\r"
expect "$*"
sleep 8
expect eof