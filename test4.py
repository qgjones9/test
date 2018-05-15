#!/usr/bin/python2.7

import urllib2
import subprocess
import sys

data = urllib2.urlopen('url')

COMMAND= "uname -a"



for line in data:
	line = line.rstrip()
        ssh = subprocess.Popen(["ssh", "%s" % line, COMMAND],
                       shell=False,
                       stdout=subprocess.PIPE,
                       stderr=subprocess.PIPE)
        result = ssh.stdout.readlines()
        if result == []:
            error = ssh.stderr.readlines()
            print >>sys.stderr, "ERROR: %s" % error
        else:
            print result

