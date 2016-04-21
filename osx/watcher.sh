#!/bin/bash
while true ; do 
    echo -e "[+] Active slaves\n-----------------" 
    netstat -plantu | grep slave | grep 127.0.0.1 
    sleep 1 
    clear
done
