import os
import re
import time
import subprocess
import sys
import datetime
import socket
import curses
import curses.textpad as textpad
import inspect
from threading import Thread
from threading import Condition
from threading import Lock

# Main screen
screen = curses.initscr()

# Don't echo input
curses.noecho()
# Don't wait for CR before parsing input
curses.cbreak()
# Remove cursors
curses.curs_set(0)
# Enables keypad in screen
screen.keypad(1)

# Size of terminal
windowWidth = screen.getmaxyx()[1]
windowHeight = screen.getmaxyx()[0]

# Nr of progressbars avaliable.
maxWorkers = 10
# Nr of lines in console.
maxMsgs = 50

gutterWidth = 7
consoleWidth = windowWidth - (gutterWidth + 2) - 2
statusBarWidth = windowWidth - 2
progressBarsWidth = statusBarWidth

# Progressbar lenght
barLen = progressBarsWidth/2 - 2

statusBarOffsetY = maxWorkers + 2
consoleOffsetY = statusBarOffsetY + 3

# Threads
workers = []
server = None
drawer = None
console = None

# Console lines
msgs = []
cwd = ""
try:
    output = subprocess.check_output("pwd", stderr=subprocess.STDOUT, shell=True)
    if "\n" in output:
        output = output.split("\n")[0]
    cwd = output
except:
    pass

# All containers in gui
progressBars = screen.subwin(maxWorkers+2, progressBarsWidth+2, 0, 0)
statusBar = screen.subwin(1+2, statusBarWidth+2, statusBarOffsetY, 0)
consoleWindow = screen.subwin(maxMsgs+2, consoleWidth+2, consoleOffsetY , gutterWidth+2)
gutter = screen.subwin(maxMsgs+2, gutterWidth+2, consoleOffsetY , 0)
textbox = screen.subwin(1, windowWidth-1, consoleOffsetY + maxMsgs + 3, 1)
textboxborder = screen.subwin(3, windowWidth, consoleOffsetY + maxMsgs + 2, 0)

# Draw border around gui
progressBars.border(0)
statusBar.border(0)
consoleWindow.border(0)
gutter.border(0)
textboxborder.border(0)

msgLock = Lock()
# Write line to console.
def add_msg(client, msg):
    global msgs
    if "\n" in msg:
        newmsgs = msg.split("\n")
        if(newmsgs[-1]) == "":
            newmsgs = newmsgs[:-1]
        for newmsg in newmsgs:
            add_msg(client, newmsg)
    else:
        with msgLock:
            while len(msg) > consoleWidth:
                msgs.append((client, msg[:consoleWidth]))
                client = ""
                if not re.match('^\s*$', line):
                    msg = msg[consoleWidth:]
            msgs.append((client, msg))
            if len(msgs) > maxMsgs:
                msgs = msgs[len(msgs)-maxMsgs:]

# Default console lines
for i in range(0,maxMsgs):
    pass
    add_msg("client", str(i))
add_msg("client", "Started vim-helper.")

# Custom curses addstr that actually shows you what's wrong.
def caddstr(box, x, y, string, errorOutput=False):
    (maxY, maxX) = box.getmaxyx()
    if len(string) <= maxX and y <= maxY:
        box.addstr(y, x, string)
    else:
        errorOutput = True
    if errorOutput:
        frame = inspect.stack()[1][0]
        info = inspect.getframeinfo(frame)
        add_msg("Error", "caddstr - Wrong formatting")
        add_msg("Error", "x,y (maxX,maxY): {},{} ({},{})".format(x+len(string),y,maxX,maxY))
        add_msg("Error", info.function + " - " + str(info.lineno))

"""
Inputfield for console
"""
class Textbox(Thread):
    def __init__(self):
        Thread.__init__(self)
        self.daemon = True
        self.start()
        self.name = "TextBox"

    def run(self):
        while(True):
            output = textpad.Textbox(textbox).edit()
            console.process.stdin.write(output + "\n")
            textbox.clear()

"""
An external console that you can send commands to
"""
class Console(Thread):
    def __init__(self):
        Thread.__init__(self)
        self.daemon = True
        self.name = "Console"
        self.textbox = Textbox()
        self.process = subprocess.Popen("sh", stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        self.start()

    def run(self):
        while(True):
            msg = self.process.stdout.readline()
            add_msg(self.name, msg)

"""
Draws gui
"""
class Drawer(Thread):
    def __init__(self):
        Thread.__init__(self)
        self.draw = True
        self.daemon = True

        self.start()

    def run(self):
        while(self.draw):
            self.drawProgressBars()
            self.drawStatusBar()
            self.drawConsole()

            progressBars.refresh()
            statusBar.refresh()
            consoleWindow.refresh()
            gutter.refresh()
            screen.refresh()

    def drawStatusBar(self):
        first = True
        workerNames = ""
        for worker in workers:
            if not first:
                workerNames += " | "
            else:
                first = False
            workerNames += worker.name

        workerInfo = "Workers: " + str(len(workers)) + " | " + workerNames
        padding = (" " * statusBarWidth)[len(cwd):-len(workerInfo)]
        if len(padding) < 2:
            padding = " "*2
        statusBarInfo = '{0:.{1}}'.format(cwd + padding + workerInfo, statusBarWidth)
        caddstr(statusBar, 1, 1, statusBarInfo)

    def drawProgressBars(self):
        y = 1
        x = 1
        i = 0
        runningWorkers = []
        for worker in workers:
            if not worker.hide and not worker.idle:
                runningWorkers.append(worker)

        while i < maxWorkers:
            if i > len(runningWorkers) - 1:
                caddstr(progressBars, x, y, " "*(barLen+2))
                caddstr(progressBars, x, y+1, " "*(barLen+2))
            else:
                count = time.time() - runningWorkers[i].timeStart
                decimal = 0
                if runningWorkers[i].lastTime != 0: 
                    decimal = count / float(runningWorkers[i].lastTime)
                if decimal > 0.99: 
                    decimal = 0.99
                percents = round(100.0 * decimal, 1)
                filled_len = int(round(barLen * decimal))
                caddstr(progressBars, x, y, ('{:>10} {:>5}'.format("[" + runningWorkers[i].name + "]", str(percents) + '%')).center(barLen+2, " "))
                caddstr(progressBars, x, y+1, ("[" + '#' * filled_len + '-' * (barLen - filled_len) + "]"))
            i += 1
            if i == 5:
                x = barLen + 3
                y = 1
            else:
                y += 2

    def drawConsole(self):
        with msgLock:
            currentmsgs = []
            for msg in msgs:
                currentmsgs.append(msg)
        for i in range(0,len(currentmsgs)):
            (gutterInfo, msg) = currentmsgs[i]
            t = False
            caddstr(gutter, 1, i+1, '{0:{1}s}'.format(gutterInfo, gutterWidth))
            caddstr(consoleWindow, 1, i+1, '{0:{1}s}'.format(msg, consoleWidth))

"""
Baseclass for all workers.

Parameters:
    name - name of worker
"""
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
        pass

    def setPath(self, path):
        self.currentPath = path
        self.currentFolder,self.currentFile = os.path.split(path)


"""
Updates GIT statusline in VIM

Saves new statusline to ~/.vim/tmp/gitstatusline/FILENAME
Where FILENAME is the full path to the file vim is working on
where \:/ are replaced with -. when server recieves
("path", PATH)
"""
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

            statuslineFileName = self.currentPath.replace("\\", "-").replace(":", "-").replace("/", "-")

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
                    add_msg(self.name, "GIT StatusBar New - " + self.currentFile)
                    add_msg(self.name, after)
                else:
                    add_msg(self.name, "GIT StatusBar Update - " + self.currentFile)
                    add_msg(self.name, before + " ->")
                    add_msg(self.name, after)
        except Exception,e:
            statuslineFileName = self.currentPath.replace("\\", "-").replace(":", "-").replace("/", "")

            f = open(os.path.expanduser('~') + "/.vim/tmp/gitstatusline/" + statuslineFileName, 'w')
            f.write("")
            f.close()
        self.currentPath = ""

"""
Autobuilds texfiles.

Starts autobuilding texfile when server recieves ("tex", PATH_TO_TEXFILE)
Stops ("tex", "")
Output pdf is ~/.vim/tmp/tmp/temp.pdf
"""
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
                        add_msg(self.name, "PDF Done")
                    else:
                        self.idle = True
            except Exception,e:
                add_msg(self.name, str(e.output))

"""
Parses communication from VIM
"""
class Server(Thread):
    def __init__(self):
        Thread.__init__(self)
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
                for worker in workers:
                    if worker.name == "Git":
                        with worker.condition:
                            worker.setPath(server_msgs[1])
                            worker.condition.notify()
            elif server_msgs[0] == "client":
                if server_msgs[1] == "1":
                    self.clients += 1
                    add_msg(self.name, "Vim client started - Currently " + str(self.clients))
                elif server_msgs[1] == "-1":
                    self.clients -= 1
                    add_msg(self.name, "Vim client stopped - Currently " + str(self.clients))
                elif server_msgs[1] == "0":
                    self.clients = -1
            elif server_msgs[0] == "tex":
                for worker in workers:
                    if worker.name == "LaTex":
                        if server_msgs[1] == "":
                            add_msg(self.name, "Stopped listening for changes - " + worker.currentFile)
                        with worker.condition:
                            worker.setPath(server_msgs[1])
                            if server_msgs[1] != "":
                                add_msg(self.name, "Listening for changes - " + worker.currentFile)
                            worker.condition.notify()
            c.close()


workers = [UpdateGit(), TexBuilder()]
drawer = Drawer()
server = Server()
console = Console()

while(True):
    for worker in workers:
        if not worker.isAlive():
            workers.remove(worker)
    if server.clients == -1:
        sys.exit()
    if server.clients == 0:
        add_msg("Main", "No vim clients left")
        add_msg("Main", "Killing helper in 3sec")
        time.sleep(1)
        if server.clients == 0:
            add_msg("Main", "Killing helper in 2sec")
            time.sleep(1)
            if server.clients == 0:
                add_msg("Main", "Killing helper in 1sec")
                time.sleep(1)
                if server.clients == 0:
                    sys.exit()
    time.sleep(0.1)
