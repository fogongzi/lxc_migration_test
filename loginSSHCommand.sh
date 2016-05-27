#!/usr/bin/expect -f

set timeout 30
set host "192.168.3.132"
spawn ssh $host
expect_before "no)?" {
send "yes\r" }
sleep 1
expect "password:"
send "chenxiao\r"
expect "*#"
send "echo my name is fivetrees > /root/fivetrees.txt\r"
interact