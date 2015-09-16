import os
import time
import sys
import subprocess
from threading import Thread


class builder(Thread):
    def __init__(self):
        Thread.__init__(self)
        self.daemon = True
        self.start()
        self.done = 0
        self.error = ""
    def run(self):
        timeStart = time.time()
        os.system("cd " + sys.argv[1])
        os.system("cp " + sys.argv[2] + " temp.tex")
        os.system("rm -f *.aux")
        cmd = subprocess.Popen("pdflatex -halt-on-error -output-directory=" + sys.argv[1] + " temp.tex", stdout=subprocess.PIPE)	
        nextRow = 0
        for row in cmd.stdout:
                if "!" in row:
                        self.error += row
                        nextRow = 1
                elif nextRow:
                        self.error += row
                        nextRow = 0
        os.system("rm temp.tex")
        self.done = time.time() - timeStart

bar_len = 60
timeStart = time.time()
currentBuilder = builder()
lastTime = 0
lastError = ""
count = 0
while True:
    if currentBuilder.done != 0:
        lastTime = currentBuilder.done
        lastError = currentBuilder.error
        currentBuilder = builder()
        timeStart = time.time()

    if lastTime != 0:
        count = time.time() - timeStart
        percents = round(100.0 * count / float(lastTime), 1)
        if percents > 99:
            percents = 99
            filled_len = 59
        elif percents < 0:
            percent = 0
            filled_len = 0
        else:
            filled_len = int(round(bar_len * count / float(lastTime)))
        bar = '#' * filled_len + '-' * (bar_len - filled_len)
        os.system('cls')
        sys.stdout.write('[%s] %s%s\n\n' % (bar, percents, '%'))
        sys.stdout.write('Last run:\n')
        sys.stdout.write('%.2f seconds.\n\n' % (lastTime))
        if lastError == "":
            sys.stdout.write('Done!')
        else:
            sys.stdout.write('ERROR!\n\n')
            print lastError
        sys.stdout.flush()

    time.sleep(0.2)

    #print time.time() - timeStart
    #print currentBuilder.done
