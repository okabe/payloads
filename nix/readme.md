provision.sh creates 2 files (Dropper.jar, stager.py), when dropper is executed (on GNU/Linux or OSX or any other nix) a web request is made to exec stager.py, which then installs a crontab to make another web request to pull down  python/meterpreter/reverse_tcp shellcode in base64 format to exec in memory. tested on OSX Yosemite victim and Kali Linux attacker. Since it installs a crontab, this is persistent in nature.