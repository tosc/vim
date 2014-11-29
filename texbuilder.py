import os
import time
import sys
import subprocess
import time

while 1:
	timeStart = time.time()
	os.system("cd " + sys.argv[1])
	os.system("cp " + sys.argv[2] + " temp.tex")
	os.system("rm -f *.aux")
	cmd = subprocess.Popen("pdflatex -halt-on-error -output-directory=" + sys.argv[1] + " temp.tex", stdout=subprocess.PIPE)	
	nextRow = 0
	for row in cmd.stdout:
		if "!" in row:
			print(row)
			nextRow = 1
		elif nextRow:
			print(row)
			nextRow = 0
	timeEnd = time.time() - timeStart
	print("Done! %.2fs" % timeEnd)
	time.sleep(1)
