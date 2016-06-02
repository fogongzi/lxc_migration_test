#!/usr/bin/expect -f

set remoteServerHost "192.168.3.132"
set sshName "root"
set sshPassWord "chenxiao"
set timeout 100

set host "$remoteServerHost"
spawn ssh $sshName@$host
expect_before "no)?" {
send "yes\r" }
sleep 1
expect "password:"
send "$sshPassWord\r"
expect "#*"
send "kill -9 `ps -elf | grep p.haul-service | awk '{print \$4}'`\r"
expect "#*"
send "mount -t nfs 192.168.3.129:/var/lib/lxc /var/lib/lxc\r"
expect "#*"
send "exit\r"