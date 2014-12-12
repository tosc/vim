import os
import time
import sys
import subprocess

firstRun = 1
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
	os.system("rm temp.tex")
	print("Done! %.2fs" % timeEnd)
        if firstRun:
                os.system("start" + sys.argv[1] +  "/temp.pdf")
                firstRun = 0
	time.sleep(1)
