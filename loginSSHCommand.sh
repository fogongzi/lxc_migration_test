#!/usr/bin/expect

spawn /usr/bin/ssh root@192.168.3.132
expect "*password:"
send "chenxiao\r"
expect "*]#"
send "cd /root"
expect "*]#"
send "exit\r"
expect eof