import os
import re
import time
import subprocess
import sys
import datetime
from threading import Thread

# Draw a nice progressbar for all my threads.
class Drawer(Thread):
    def __init__(self, workers):
        Thread.__init__(self)
        self.daemon = True
        self.workers = workers
        self.windowLen = 80
        self.msgs = []
        self.maxMsgs = 20
        self.consoleNamesLen = 14
        self.maxTextLen = self.windowLen - self.consoleNamesLen - 6
        for i in range(0,self.maxMsgs):
            self.add_msg("", " ")
        for worker in self.workers:
            worker.drawer = self
        self.add_msg("main", "Started vim-helper.")
        self.barLen = 50
        self.start()

    def run(self):
        while(True):
            os.system('cls')
            for worker in self.workers:
                self.drawProgressBar(worker)
            line = '-' * self.windowLen
            sys.stdout.write("\n")
            sys.stdout.write(line + "\n")
            self.drawConsole()
            sys.stdout.write(line + "\n")
            sys.stdout.flush()
            time.sleep(0.2)

    def add_msg(self, source, msg):
        msgList = msg.split("\n")
        for splitMsg in msgList:
            source = datetime.datetime.now().strftime("%H:%M:%S|") + source
            tmpMsg = splitMsg
            while len(tmpMsg) > self.maxTextLen:
                self.msgs.append((source,tmpMsg[0:self.maxTextLen]))
                tmpMsg = tmpMsg[self.maxTextLen:]
            if tmpMsg != "":
                self.msgs.append((source,tmpMsg))
        self.msgs = self.msgs[-self.maxMsgs:]

    def drawProgressBar(self, worker):
        count = time.time() - worker.timeStart
        sleepcount = time.time() - worker.timeDone
        if worker.idle or worker.lastTime == 0:
            status = "Idle..."
            percents = 0
            filled_len = 0
        elif worker.done:
            status = "Sleeping..."
            percents = round(100.0 * sleepcount / float(worker.sleep), 1)
            if percents > 99:
                percents = 99
                filled_len = 0
            elif percents < 0:
                percents = 0
                filled_len = self.barLen - 1
            else:
                filled_len = self.barLen - int(round(self.barLen * sleepcount / float(worker.sleep)))
        else:
            status = "Running..."
            percents = round(100.0 * count / float(worker.lastTime), 1)
            if percents > 99:
                percents = 99
                filled_len = self.barLen - 1
            elif percents < 0:
                percents = 0
                filled_len = 0
            else:
                filled_len = int(round(self.barLen * count / float(worker.lastTime)))
        bar = '#' * filled_len + '-' * (self.barLen - filled_len)
        percentText = str(percents) + '%'

        sys.stdout.write(worker.name + '\n')
        sys.stdout.write('[%s] %s - %s\n\n' % (bar, percentText, status))

    def drawConsole(self):
        for source,msg in self.msgs:
            consoleLine = "%-" + str(self.consoleNamesLen) + "." + str(self.consoleNamesLen) + "s| %s\n"
            sys.stdout.write(consoleLine % (source,msg))



# All external workers should inherit this.
class Worker(Thread):
    def __init__(self, name):
        Thread.__init__(self)

        self.name = name

        self.currentFolder = ""
        self.currentFile = ""
        self.currentPath = ""

        self.done = True
        self.idle = False
        self.timeStart = time.time()
        self.timeDone = time.time()
        self.lastTime = 1

        self.sleep = 1

        self.drawer = None

    def run(self):
        while(True):
            self.done = False
            self.timeStart = time.time()
            self.update()
            if not self.idle:
                self.timeDone = time.time()
                self.lastTime = self.timeDone - self.timeStart
                self.done = True
            time.sleep(self.sleep)

    def update(self):
        print "fix updateloop"

    def setPath(self, path):
        self.currentPath = path
        self.currentFolder,self.currentFile = os.path.split(currentPath)

# A thread that updates my git statusline
class UpdateGit(Worker):
    def __init__(self):
        Worker.__init__(self, "Git statusbar")
        self.daemon = True
        self.lastTime = 0.1
        self.sleep = 0.5
        self.start()

    def update(self):
        if self.currentPath != "":
            try:
                filesRaw = subprocess.check_output("git -C " + self.currentFolder + " status -b -s", stderr=subprocess.STDOUT)
                rowsRaw = subprocess.check_output("git -C " + self.currentFolder + " diff --numstat", stderr=subprocess.STDOUT)

                statusLine = ""

                filesRaw = filesRaw.replace("...", "->")
                filesRaw = filesRaw.replace("#", "")
                filesSplit = filesRaw.split("\n")
                # [master->origin/master]   Branch info
                if len(filesSplit) > 0:
                    branch = filesSplit[0][1:].split(" ")
                    statusLine += "[" + branch[0] + "]"
                    if len(branch[1:]) > 0:
                        statusLine += " "
                        branch = branch[1:]
                        while len(branch) > 1:
                            statusLine += branch[0].replace(",", "] [") + " " + branch[1].replace(",", "] [")
                            branch = branch[2:]

                # [m 3]                     Number of modified files
                if len(filesSplit) > 2:
                    statusLine += " [m " + str(len(filesSplit) - 2) + "]"

                # [+3 -2]                   Changed rows in current file
                for row in rowsRaw.split("\n"):
                    if self.currentFile in row:
                        changedRows = row.split("\t")
                        statusLine += " [+" + changedRows[0] + " -" + changedRows[1] + "]"

                statuslineFileName = self.currentPath.replace("\\", "-").replace(":", "-").replace("/", "")
                f = open(os.path.expanduser('~') + "/.vim/tmp/gitstatusline/" + statuslineFileName, 'w')
                f.write(statusLine)
                f.close()
            except Exception,e:
                #self.drawer.add_msg(self.name, str(e.output))
                pass


class TexBuilder(Worker):
    def __init__(self):
        Worker.__init__(self, "LaTex Builder")
        self.daemon = True
        self.lastTime = 3
        self.sleep = 0.5
        self.idle = True
        self.start()
        self.i = 0

    def update(self):
        if ".tex" in self.currentFile:
            self.idle = False
            tmpFolder = os.path.expanduser('~') + "/.vim/tmp/tmp/"
            try:
                self.drawer.add_msg(self.name, "Building pdf - " + self.currentFile)
                subprocess.check_output("cp " + self.currentPath + " " + tmpFolder + "temp.tex", stderr=subprocess.STDOUT)
                subprocess.check_output("rm -f " + tmpFolder + "*.aux", stderr=subprocess.STDOUT)
                output = subprocess.check_output("pdflatex -halt-on-error -output-directory=" + tmpFolder + " " + tmpFolder+ "temp.tex", stderr=subprocess.STDOUT, cwd=self.currentFolder)
                self.drawer.add_msg(self.name, "PDF Done")
            except Exception,e:
                self.drawer.add_msg(self.name, str(e.output))

        else:
            self.idle = True


workers = [
            UpdateGit(),
            TexBuilder()
            ]
drawer = Drawer(workers)
while(True):
    # Check how many vim clients are running, if 0 quit.
    f = open(os.path.expanduser('~') + "/.vim/tmp/current-vim-clients", 'r')
    currentVimClients = int(f.read())
    f.close()
    if currentVimClients == 0:
       sys.exit() 

    # Get the path to the file vim currently is editing.
    f = open(os.path.expanduser('~') + "/.vim/tmp/current-file", 'r')
    currentPath = f.read().replace("\n", "")
    f.close()
    currentFolder,currentFile = os.path.split(currentPath)

    for worker in workers:
        worker.setPath(currentPath)
    time.sleep(0.1)

