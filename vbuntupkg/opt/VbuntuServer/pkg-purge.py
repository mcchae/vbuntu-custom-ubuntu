#!/usr/bin/env python

import os
import sys
from subprocess import Popen,PIPE

###############################################################################
def exec_system(cmd_list):
	po = Popen(cmd_list, stdout=PIPE, stderr=PIPE)
	stdout = po.stdout.read()
	stderr = po.stderr.read()
	return stdout, stderr

###############################################################################
def pkg_purge(pkgname):
	out, err = exec_system(['dpkg', '-L', pkgname])
	if err:
		raise Exception(err)
	for line in out.split('\n'):
		if not line: continue
		if not os.path.isfile(line):
			continue
		#print "<<<%s>>>" % line
		os.remove(line)

###############################################################################
def usage(msg):
	if msg:
		sys.stderr.write("%s\n" % msg)
	sys.stderr.write("""usage %s pkg_name
   purge pkg from package pkg_name
""" % sys.argv[0])
	sys.exit(1)

###############################################################################
if __name__=='__main__':
	if len(sys.argv) < 2:
		usage('Invalid arguments')
	try:
		for pkg in sys.argv[1:]:
			pkg_purge(pkg)
	except Exception as e:
		usage(str(e))

