import os
import re
import time
import subprocess
import sys
import datetime
import socket
import curses
from threading import Thread
from threading import Condition

# Draw a nice progressbar for all my threads.
class Drawer(Thread):
    def __init__(self, workers):
        Thread.__init__(self)
        self.draw = True
        self.daemon = True
        self.workers = workers

        self.screen = curses.initscr()
        self.uiOffsetX = 0
        self.consoleOffsetY = 10

        self.windowWidth = self.screen.getmaxyx()[1]
        self.windowHeight = self.screen.getmaxyx()[0]
        self.windowLen = self.windowWidth
        self.msgs = []
        self.maxMsgs = self.windowHeight - self.consoleOffsetY - 2
        self.consoleNamesLen = 16
        self.maxTextLen = self.windowLen - self.consoleNamesLen - 4
        self.barLen = self.windowLen/2 - 2
        self.maxWorkers = 10
        curses.noecho()
        curses.cbreak()
        self.screen.keypad(1)

        for i in range(0,self.maxMsgs):
            self.add_msg("", " ")
        self.add_msg("main", "Started vim-helper.")
        self.start()

    def run(self):
        while(self.draw):
            for worker in self.workers:
                if not worker.isAlive():
                    self.workers.remove(worker)
            self.drawProgressBars()
            line = '-' * self.windowLen
            self.screen.addstr(self.consoleOffsetY-1, 0, line)
            self.drawConsole()
            self.screen.addstr(self.windowHeight-2, 0, line)
            self.screen.refresh()

    def add_msg(self, source, msg):
        msgList = msg.split("\n")
        for splitMsg in msgList:
            source = datetime.datetime.now().strftime(" %H:%M:%S | ") + source
            tmpMsg = splitMsg
            while len(tmpMsg) > self.maxTextLen:
                self.msgs.append((source,tmpMsg[0:self.maxTextLen]))
                tmpMsg = tmpMsg[self.maxTextLen:]
            if tmpMsg != "":
                self.msgs.append((source,tmpMsg))
        self.msgs = self.msgs[-self.maxMsgs:]

    def drawProgressBars(self):
        y = 0
        x = 0
        for worker in self.workers:
            if not worker.hide and not worker.idle and y < 10:
                count = time.time() - worker.timeStart
                sleepcount = time.time() - worker.timeDone
                if worker.idle or worker.lastTime == 0:
                    status = "Idle..."
                    percents = 0
                    filled_len = 0
                else:
                    status = "Running"
                    percents = round(100.0 * count / float(worker.lastTime), 1)
                    if percents > 99:
                        percents = 99
                        filled_len = self.barLen - 1
                    else:
                        filled_len = int(round(self.barLen * count / float(worker.lastTime)))
                bar = ("[" + '#' * filled_len + '-' * (self.barLen - filled_len) + "]")

                self.screen.addstr(y, x*self.barLen, ('{:>10} {} {:>5}'.format("[" + worker.name + "]", status, str(percents) + '%')).center(self.barLen, " "))
                self.screen.addstr(y + 1, x*(self.barLen + 2), bar)
                if x == 0:
                    x += 1
                else:
                    x = 0
                    y += 2

        while y < 10:
            self.screen.addstr(y, x*self.barLen, "".center(self.barLen, " "))
            self.screen.addstr(y + 1, x*(self.barLen + 2), "".center(self.barLen + 2, " "))
            if x == 0:
                x += 1
            else:
                x = 0
                y += 2

    def drawConsole(self):
        for worker in self.workers:
            while len(worker.msgs) > 0:
                self.add_msg(worker.name, worker.msgs.pop(0))
        i = 0
        for source,msg in self.msgs:
            consoleLine = "%-" + str(self.consoleNamesLen) + "." + str(self.consoleNamesLen) + "s | %s\n"
            self.screen.addstr(i + self.consoleOffsetY, 0, consoleLine % (source,msg))
            i += 1

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

        self.msgs = []

        self.running = True

    def run(self):
        while(self.running):
            self.done = False
            self.timeStart = time.time()
            self.update()
            if not self.idle:
                self.timeDone = time.time()
                self.lastTime = self.timeDone - self.timeStart
                self.done = True

    def update(self):
        print "fix updateloop"

    def setPath(self, path):
        self.currentPath = path
        self.currentFolder,self.currentFile = os.path.split(path)

    def add_msg(self, msg):
        self.msgs.append(msg)

# A thread that updates my git statusline
class UpdateGit(Worker):
    def __init__(self):
        Worker.__init__(self, "Git")
        self.daemon = True
        self.lastTime = 0.1
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
                    if os.path.isfile(tmpFolder + "main.tex"):
                        f = open(tmpFolder + "temp.tex", 'r')
                        before = f.read()
                        f.close()
                        f = open(tmpFolder + "main.tex", 'r')
                        after = f.read()
                        f.close()
                    if before != after:
                        self.idle = False
                        subprocess.check_output("cp " + tmpFolder + "temp.tex " +  tmpFolder + "main.tex", stderr=subprocess.STDOUT)
                        subprocess.check_output("rm -f " + tmpFolder + "*.aux", stderr=subprocess.STDOUT)
                        subprocess.check_output("pdflatex -halt-on-error -output-directory=" + tmpFolder + " " + tmpFolder + "main.tex", stderr=subprocess.STDOUT, cwd=self.currentFolder)
                        self.add_msg("PDF Done")
                    else:
                        self.idle = True
            except Exception,e:
                self.add_msg(str(e.output))


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
                for worker in self.workers:
                    if worker.name == "LaTex":
                        if server_msgs[1] == "":
                            worker.add_msg("Stopped listening for changes - " + worker.currentFile)
                        with worker.condition:
                            worker.setPath(server_msgs[1])
                            if server_msgs[1] != "":
                                worker.add_msg("Listening for changes - " + worker.currentFile)
                            worker.condition.notify()
            elif server_msgs[0] == "run":
                self.workers.append(TempBar())
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
