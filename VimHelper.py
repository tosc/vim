import os
import re
import time
import subprocess
import sys
import datetime
import socket
from threading import Thread
from threading import Condition

# Draw a nice progressbar for all my threads.
class Drawer(Thread):
    def __init__(self, workers):
        Thread.__init__(self)
        self.draw = True
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
        while(self.draw):
            os.system('cls')
            self.drawProgressBars()
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

    def drawProgressBars(self):
        for worker in self.workers:
            worker.drawProgressBar()

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

        self.hide = False

        self.condition = Condition()
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
            if self.sleep != 0:
                time.sleep(self.sleep)

    def update(self):
        print "fix updateloop"

    def setPath(self, path):
        self.currentPath = path
        self.currentFolder,self.currentFile = os.path.split(path)

    def drawProgressBar(self):
        if not self.hide:
            count = time.time() - self.timeStart
            sleepcount = time.time() - self.timeDone
            if self.idle or self.lastTime == 0:
                status = "Idle..."
                percents = 0
                filled_len = 0
            elif self.done:
                status = "Sleeping..."
                percents = round(100.0 * sleepcount / float(self.sleep), 1)
                if percents > 99:
                    percents = 99
                    filled_len = 0
                elif percents < 0:
                    percents = 0
                    filled_len = drawer.barLen - 1
                else:
                    filled_len = drawer.barLen - int(round(drawer.barLen * sleepcount / float(self.sleep)))
            else:
                status = "Running..."
                percents = round(100.0 * count / float(self.lastTime), 1)
                if percents > 99:
                    percents = 99
                    filled_len = drawer.barLen - 1
                elif percents < 0:
                    percents = 0
                    filled_len = 0
                else:
                    filled_len = int(round(drawer.barLen * count / float(self.lastTime)))
            bar = '#' * filled_len + '-' * (drawer.barLen - filled_len)
            percentText = str(percents) + '%'

            sys.stdout.write(self.name + '\n')
            sys.stdout.write('[%s] %s - %s\n\n' % (bar, percentText, status))

    def add_msg(self, msg):
        drawer.add_msg(self.name, msg)

# A thread that updates my git statusline
class UpdateGit(Worker):
    def __init__(self):
        Worker.__init__(self, "Git")
        self.daemon = True
        self.lastTime = 0.1
        self.sleep = 0
        self.pause = True
        self.hide = True
        self.start()

    def update(self):
        with self.condition:
            while self.currentPath == "":
                self.condition.wait()
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
                    if len(branch) > 3:
                        statusLine += branch[0] + " " + branch[1][:-1] + "] ["
                        branch = branch[2:]
                    if len(branch) > 1:
                        statusLine += branch[0] + " " + branch[1]
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

            before = ""
            if os.path.isfile(os.path.expanduser('~') + "/.vim/tmp/gitstatusline/" + statuslineFileName):
                f = open(os.path.expanduser('~') + "/.vim/tmp/gitstatusline/" + statuslineFileName, 'r')
                before = f.read()
                f.close()

            f = open(os.path.expanduser('~') + "/.vim/tmp/gitstatusline/" + statuslineFileName, 'w')
            f.write(statusLine)
            f.close()

            f = open(os.path.expanduser('~') + "/.vim/tmp/gitstatusline/" + statuslineFileName, 'r')
            after = f.read()
            f.close()

            if before != after:
                if before == "":
                    self.add_msg("GIT StatusBar New - " + self.currentFile)
                    self.add_msg(after)
                else:
                    self.add_msg("GIT StatusBar Update - " + self.currentFile)
                    self.add_msg(before + " ->")
                    self.add_msg(after)
        except Exception,e:
            statuslineFileName = self.currentPath.replace("\\", "-").replace(":", "-").replace("/", "")

            f = open(os.path.expanduser('~') + "/.vim/tmp/gitstatusline/" + statuslineFileName, 'w')
            f.write("")
            f.close()
        self.currentPath = ""


class TexBuilder(Worker):
    def __init__(self):
        Worker.__init__(self, "LaTex")
        self.daemon = True
        self.lastTime = 3
        self.sleep = 0
        self.idle = True
        self.start()

    def update(self):
        with self.condition:
            while self.currentPath == "":
                self.idle = True
                self.condition.wait()
            self.idle = False
            tmpFolder = os.path.expanduser('~') + "/.vim/tmp/tmp/"
            try:
                if os.path.isfile(tmpFolder + "temp.tex"):
                    subprocess.check_output("cp " + tmpFolder + "temp.tex " +  tmpFolder + "main.tex", stderr=subprocess.STDOUT)
                    subprocess.check_output("rm -f " + tmpFolder + "*.aux", stderr=subprocess.STDOUT)
                    subprocess.check_output("pdflatex -halt-on-error -output-directory=" + tmpFolder + " " + tmpFolder + "main.tex", stderr=subprocess.STDOUT, cwd=self.currentFolder)
            except Exception,e:
                self.drawer.add_msg(self.name, str(e.output))

class Server(Thread):
    def __init__(self, drawer, workers):
        Thread.__init__(self)
        self.drawer = drawer
        self.workers = workers
        self.daemon = True
        self.clients = 1
        self.start()

    def run(self):
        s = socket.socket()

        s.bind(("localhost", 51351))

        s.listen(5)
        while True:
            c, addr = s.accept()
            server_msgs = c.recv(1024).split("\t")
            if server_msgs[0] == "path":
                for worker in self.workers:
                    if worker.name == "Git":
                        with worker.condition:
                            worker.setPath(server_msgs[1])
                            worker.condition.notify()
            elif server_msgs[0] == "client":
                if server_msgs[1] == "1":
                    self.clients += 1
                    self.add_msg("Vim client started - Currently " + str(self.clients))
                elif server_msgs[1] == "-1":
                    self.clients -= 1
                    self.add_msg("Vim client stopped - Currently " + str(self.clients))
                elif server_msgs[1] == "0":
                    self.clients = -1
            elif server_msgs[0] == "tex":
                if server_msgs[1] == "":
                    self.add_msg("Stopping PDF")
                for worker in self.workers:
                    if worker.name == "LaTex":
                        with worker.condition:
                            worker.setPath(server_msgs[1])
                            if server_msgs[1] != "":
                                self.add_msg("Building PDF - " + worker.currentFile)
                            worker.condition.notify()
            c.close()

    def add_msg(self, msg):
        self.drawer.add_msg("Server", msg)

drawer = None

workers = [
            UpdateGit(),
            TexBuilder()
            ]
drawer = Drawer(workers)
server = Server(drawer, workers)
while(True):
    if server.clients == -1:
        sys.exit()
    if server.clients == 0:
        drawer.add_msg("Main", "No vim clients left")
        drawer.add_msg("Main", "Killing helper in 3sec")
        time.sleep(1)
        if server.clients == 0:
            drawer.add_msg("Main", "Killing helper in 2sec")
            time.sleep(1)
            if server.clients == 0:
                drawer.add_msg("Main", "Killing helper in 1sec")
                time.sleep(1)
                if server.clients == 0:
                    sys.exit()

    time.sleep(0.1)
