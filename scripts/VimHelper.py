import os
import json
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

if sys.platform.startswith("win"):
    import ctypes
    SEM_NOGPFAULTERRORBOX = 0x0002 # From MSDN
    ctypes.windll.kernel32.SetErrorMode(SEM_NOGPFAULTERRORBOX);
    CREATE_NO_WINDOW = 0x08000000    # From Windows API
    subprocess_flags = CREATE_NO_WINDOW
else:
    subprocess_flags = 0

home = os.path.expanduser('~') + "/"
scriptFolder = home + "git/vim/scripts/"
tmpFolder = home + ".vim/tmp/"
compileFolder = tmpFolder + "compilefiles/"
compileOutput = tmpFolder + "compile"
consoleOutput = tmpFolder + "console"
compileTimesFile = tmpFolder + "compileTimes"

compileTimes = {}
try:
    f = open(compileTimesFile, 'r')
    compileTimes = json.load(f)
    f.close()
except:
    pass

# Threads
workers = []
compiler = None
server = None
drawer = None
console = None
git = None

offsetY = 0
def add_screen(screen):
    global offsetY
    offsetY += screen.getmaxyx()[0]

# Create all windows
screen = curses.initscr()
(windowHeight, windowWidth) = screen.getmaxyx()
screen.keypad(1)

# Don't echo input
curses.noecho()
# Don't wait for CR before parsing input
curses.cbreak()
# Remove cursors
curses.curs_set(0)

cellHeight = int((windowHeight - 9)/6)
progressBarsHeight = cellHeight
if cellHeight%2 != 0:
    progressBarsHeight -= 1

progressBars = screen.subwin(progressBarsHeight, windowWidth, offsetY, 0)
add_screen(progressBars)
progressBars.border(0)
(progressBarsHeight, progressBarsWidth) = progressBars.getmaxyx()
maxWorkers = progressBarsHeight - 2
barLen = (progressBarsWidth - 2)/2 - 2

compileStatusBar = screen.subwin(3, windowWidth, offsetY, 0)
add_screen(compileStatusBar)
compileStatusBar.border(0)
(compileStatusBarHeight, compileStatusBarWidth) = compileStatusBar.getmaxyx()

compileWindow = screen.subwin(3*cellHeight, windowWidth, offsetY, 0)
add_screen(compileWindow)
compileWindow.border(0)
(compileHeight, compileWidth) = compileWindow.getmaxyx()

statusBar = screen.subwin(3, windowWidth, offsetY, 0)
add_screen(statusBar)
statusBar.border(0)
(statusBarHeight, statusBarWidth) = statusBar.getmaxyx()

gutter = screen.subwin(2*cellHeight, 17, offsetY, 0)
gutter.border(0)
(gutterHeight, gutterWidth) = gutter.getmaxyx()
consoleWindow = screen.subwin(gutterHeight, windowWidth - gutterWidth, offsetY, gutterWidth)
add_screen(consoleWindow)
consoleWindow.border(0)
(consoleHeight, consoleWidth) = consoleWindow.getmaxyx()

textboxborder = screen.subwin(3, windowWidth, offsetY, 0)
(textboxHeight, textboxWidth) = consoleWindow.getmaxyx()
textbox = screen.subwin(1, textboxWidth - 2, offsetY + 1, 1)
add_screen(textboxborder)
textboxborder.border(0)

class CSL:
    """
    Curses String List

    This class make sure that the strings added follow the correct formatting for the curses window.
    they will be drawn as.

    Parameters:
        box - The box these strings will be drawn too.
    """
    def __init__(self, box):
        self.lines = []
        self.lock = Lock()
        self.box = box
        (self.boxHeight, self.boxWidth) = box.getmaxyx()

    def addstr(self, string):
        nr_added = 0
        if "\n" in string:
            strings = string.split("\n")
            if(strings[-1]) == "":
                strings = strings[:-1]
            for newString in strings:
                nr_added += self.addstr(newString)
        else:
            if len(string) > self.boxWidth-2:
                nr_added += self.addstr(string[:self.boxWidth-2])
                nr_added += self.addstr(string[self.boxWidth-2:])
            else:
                with self.lock:
                    self.lines.append("{0:{1}}".format(string, self.boxWidth-2))
                    nr_added += 1
        return nr_added

    def clear(self):
        with self.lock:
            self.lines = []

    def draw(self):
        with self.lock:
            offset = len(self.lines) - (self.boxHeight - 2)
            for i in range(0,self.boxHeight - 2):
                string = ""
                lineNr = offset + i
                if lineNr >= 0:
                    string = self.lines[lineNr]
                caddstr(self.box, 1, i+1, '{0:{1}s}'.format(string, self.boxWidth-2))

    def getlast(self):
        with self.lock:
            return self.lines[len(self.lines)-1]

class ConsoleCSL:
    """
    Custom CSL that creates 2 CSLs where theirs strings syncs their y locations.

    Parameters:
        box - The first box where strings will be added
        box - The second box where strings will be added
    """
    def __init__(self, consoleBox, gutterBox):
        self.cMsgs = CSL(consoleBox)
        self.gMsgs = CSL(gutterBox)

    def addstr(self, gutterStr, consoleStr):
        nr_added = self.cMsgs.addstr(consoleStr)
        for i in range(0,nr_added):
            if i == 0:
                newGutterMsg = time.strftime("%H:%M:%S") + " " + gutterStr
                self.gMsgs.addstr('{0:.{1}}'.format(newGutterMsg, gutterWidth-2))
            else:
                self.gMsgs.addstr("")

    def draw(self):
        self.cMsgs.draw()
        self.gMsgs.draw()

compileMsgs = CSL(compileWindow)
consoleMsgs = ConsoleCSL(consoleWindow, gutter)
consoleMsgs.addstr("Client", "Started vim-helper.")

# Custom curses addstr that actually shows you what's wrong.
def caddstr(box, x, y, string, errorOutput=False):
    (maxY, maxX) = box.getmaxyx()
    if len(string) <= maxX-2 and y <= maxY-2:
        if not "\0" in string:
            box.addstr(y, x, string)
    else:
        errorOutput = True
    if errorOutput:
        frame = inspect.stack()[1][0]
        info = inspect.getframeinfo(frame)
        if box != console and box != gutter:
            consoleMsgs.addstr("Error", "caddstr - Wrong formatting in" +  info.function + " - line " + str(info.lineno))
            consoleMsgs.addstr("Error", "x/maxX,y/maxY): {},{} ({},{})".format(x+len(string),maxX,y,maxY))
            consoleMsgs.addstr("Error", "|String| : |{}|".format(string))
            consoleMsgs.addstr("Error", "CompileMsgLen = {}".format(len(compileMsgs.lines)))
        else:
            print "caddstr - Wrong formatting in" +  info.function + " - line " + str(info.lineno)
            print "x/maxX,y/maxY): {},{} ({},{})".format(x+len(string),maxX,y,maxY)
            print "|String| : |{}|".format(string)

class Textbox(Thread):
    """
    Inputfield for console
    """
    def __init__(self):
        Thread.__init__(self)
        self.daemon = True
        self.start()
        self.name = "TextBox"

    def run(self):
        while(True):
            output = textpad.Textbox(textbox).edit()
            if re.match("(quit)|(:q)|(exit)", output):
                server.clients = -1
            elif re.match("(compiletimes)|(ct)", output):
                for script,time in compileTimes.items():
                    consoleMsgs.addstr("CT", str(script) + " - " + str(time))
            elif re.match("killall", output):
                for worker in workers:
                    try:
                        worker.currentProcess.kill()
                    except:
                        pass
            elif re.match("cd", output):
                lastID = console.lineID
                newCwd = drawer.cwd
                console.process.stdin.write(output + "\n")
                console.process.stdin.write("pwd\n")
                while True:
                    if lastID != console.lineID:
                        lastMsg = consoleMsgs.cMsgs.getlast()
                        if not "No such file or directory" in lastMsg:
                            newCwd = lastMsg
                        break
                drawer.cwd = newCwd
            else:
                console.process.stdin.write(output + "\n")
            textbox.clear()

class Console(Thread):
    """
    An external console that you can send commands to
    """
    def __init__(self):
        Thread.__init__(self)
        self.daemon = True
        self.name = "Console"
        self.textbox = Textbox()
        cop = open(consoleOutput, 'w')
        self.process = subprocess.Popen("sh", stdin=subprocess.PIPE, stdout=cop, stderr=cop)
        self.start()
        self.lineID = 0

    def run(self):
        while(True):
            cop = open(consoleOutput, 'r')
            line = ""
            while True:
                line = cop.readline()
                if line:
                    self.lineID += 1
                    if self.lineID > 10000:
                        self.lineID = 0
                    consoleMsgs.addstr(self.name, line)

class Drawer(Thread):
    """
    Draws gui
    """
    def __init__(self):
        Thread.__init__(self)
        self.draw = True
        self.daemon = True
        self.start()
        self.lastCompileCall = "Never compiled."
        self.lastCompileLength = "0.000"
        self.lastCompileLength = "{:8.3f}".format(0)
        self.lastCompileTime = "00:00:00"
        self.cwd = ""

    def run(self):
        while(self.draw):
            self.drawProgressBars()
            self.drawCompileStatusBar()
            self.drawStatusBar()
            consoleMsgs.draw()
            compileMsgs.draw()

            progressBars.refresh()
            compileStatusBar.refresh()
            statusBar.refresh()
            consoleWindow.refresh()
            compileWindow.refresh()
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

        serverStatus = "+ "
        if server:
            if not server.isAlive():
                serverStatus = "- "

        workerInfo = "Workers: " + str(len(workers)) + " | " + workerNames
        padding = (" " * (statusBarWidth-2))[len(self.cwd)+2:-len(workerInfo)]
        if len(padding) < 2:
            padding = " "*2
        statusBarInfo = '{0:.{1}}'.format(serverStatus + self.cwd + padding + workerInfo, statusBarWidth-2)
        caddstr(statusBar, 1, 1, statusBarInfo)

    def drawCompileStatusBar(self):
        compilerStatus = "+ "
        if compiler:
            if not compiler.go:
                compilerStatus = "- "
        padding = (" " * (statusBarWidth-2))[len(self.lastCompileTime + self.lastCompileLength)+2:-len(self.lastCompileCall)]
        if len(padding) < 2:
            padding = " "*2
        statusBarInfo = '{0:.{1}}'.format(compilerStatus + self.lastCompileTime + self.lastCompileLength + padding + self.lastCompileCall, compileStatusBarWidth-2)
        caddstr(compileStatusBar, 1, 1, statusBarInfo)

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
                lastTime = runningWorkers[i].lastTime
                if lastTime != 0: 
                    decimal = count / float(lastTime)
                if decimal > 0.99: 
                    decimal = 0.99
                percents = round(100.0 * decimal, 1)
                filled_len = int(round(barLen * decimal))
                caddstr(progressBars, x, y, ('{:>10} {:>5}'.format("[" + runningWorkers[i].name + "]", str(percents) + '%')).center(barLen+2, " "))
                caddstr(progressBars, x, y+1, ("[" + '#' * filled_len + '-' * (barLen - filled_len) + "]"))
            i += 1
            if i == maxWorkers/2:
                x = barLen + 3
                y = 1
            else:
                y += 2


class RunScript(Thread):
    """
    Runs a script once and prints the output to the compiler window.

    Paramters:
        script - the script to call, ex "pdflatex test.tex --output-error"
        silent - disable output
    """
    def __init__(self, script, folder=scriptFolder, silent=False, args="", clear=True, scripts=[]):
        Thread.__init__(self)

        self.name = "Script"

        self.done = True
        self.idle = False
        self.hide = False
        self.running = True
        self.daemon = True
        self.pause = True

        self.timeStart = time.time()
        self.timeDone = time.time()
        self.lastTime = 1

        if compileTimes.has_key(script):
            self.lastTime = compileTimes[script]

        self.currentFolder = ""
        self.currentFile = ""
        self.currentPath = ""

        self.script = script
        self.scripts = [self.script + " " + args] 
        self.scripts = self.scripts + scripts
        self.args = args
        self.currentFolder = folder
        self.silent = silent
        self.clear = clear
        self.currentProcess = None
        self.start()

    def run(self):
        while(self.running):
            self.done = False
            self.timeStart = time.time()
            self.update()
            if not self.idle:
                self.timeDone = time.time()
                self.lastTime = self.timeDone - self.timeStart
                if not self.hide:
                    compileTimes[self.script] = self.lastTime
                if not self.silent:
                    drawer.lastCompileLength = "{:8.3f}".format(self.lastTime)
                    drawer.lastCompileTime = time.strftime("%H:%M:%S")
                self.done = True

    def update(self):
        try:
            first = True
            for script in self.scripts:
                cop = open(compileOutput, 'w')
                if not self.silent:
                    consoleMsgs.addstr("Script", "Calling: " + self.script)
                self.currentProcess = subprocess.Popen(script, stdout=cop, stderr=subprocess.STDOUT, cwd=self.currentFolder, creationflags=subprocess_flags)
                self.currentProcess.wait()
                cop.close()
                if not self.silent:
                    consoleMsgs.addstr("Script", "Done!")
                    cop = open(compileOutput, 'r')
                    if first:
                        compileMsgs.clear()
                    line = cop.readline()
                    while(line):
                        compileMsgs.addstr(line)
                        line = cop.readline()
                    drawer.lastCompileCall = script
                first = False
        except Exception,e:
            consoleMsgs.addstr("Script", "Failed")
            consoleMsgs.addstr("Script", str(e))
        self.running = False

class Compiler(Thread):
    """
    Autobuilds selected file. Runs when sucessful.
    """
    global compileMsgs
    def __init__(self):
        Thread.__init__(self)
        self.name = "Compile"
        self.daemon = True
        self.prevFileToCompile = ""
        self.msgs = []
        self.currentFile = ""
        self.currentFolder = ""
        self.currentPath = ""
        self.condition = Condition()
        self.args = ""
        self.prevArgs = ""
        self.go = False
        self.start()
        self.currentScript = None

    def run(self):
        while True:
            with self.condition:
                while not self.go:
                    self.condition.wait()
                    compileMsgs.clear()
                try:
                    fileToCompile = compileFolder + "_" + self.currentFile 
                    fileFromVim = compileFolder + self.currentFile
                    if os.path.isfile(fileFromVim):
                        before = ""
                        after = "_"
                        if os.path.isfile(fileToCompile):
                            f = open(fileFromVim, 'r')
                            before = f.read()
                            f.close()
                            f = open(fileToCompile, 'r')
                            after = f.read()
                            f.close()
                        if before != after or self.prevFileToCompile != fileToCompile or self.args != self.prevArgs:
                            call = self.call(fileToCompile)
                            if call != "":
                                subprocess.check_output("cp " + fileFromVim + " " +  fileToCompile, stderr=subprocess.STDOUT)
                                if not re.search("\.c$", fileToCompile):
                                    self.currentScript = RunScript(call, self.currentFolder)
                                else:
                                    self.currentScript = RunScript(call, self.currentFolder, scripts=[compileFolder + "./main"])
                                workers.append(self.currentScript)
                                self.currentScript.join()
                                self.prevFileToCompile = fileToCompile
                                self.prevArgs = self.args
                            else:
                                consoleMsgs.addstr(self.name, "Missing compiler for " + self.currentFile + "s filetype.")
                                consoleMsgs.addstr(self.name, "Add it in VimHelper.py - Compiler.call()")
                                self.go = False
                except Exception,e:
                    consoleMsgs.addstr(self.name, str(e))

    def call(self, fileToCompile):
        call = ""
        if re.search("\.py$", fileToCompile):
            call = "python " + fileToCompile
        elif re.search("\.tex$", fileToCompile):
            call = "pdflatex -halt-on-error -output-directory={} {}".format(compileFolder, fileToCompile)
        elif re.search("\.c$", fileToCompile):
            call = "gcc -Wall " + fileToCompile + " -o " +  compileFolder + "main"
        return call + " " + self.args

    def setPath(self, path):
        self.currentPath = path
        self.currentFolder,self.currentFile = os.path.split(path)

class Server(Thread):
    """
    Parses communication from VIM
    """
    def __init__(self):
        Thread.__init__(self)
        self.name = "Server"
        self.daemon = True
        self.clients = 1
        self.start()

    def run(self):
        running = True
        try:
            s = socket.socket()
            s.bind(("localhost", 51351))
            s.listen(5)
            consoleMsgs.addstr(self.name, "Started listening.")
        except:
            consoleMsgs.addstr(self.name, "Failed to start server.")
            self.clients = 0
            running = False
        while running:
            try:
                c, addr = s.accept()
                server_msgs = c.recv(1024).split("\t")
            except:
                consoleMsgs.addstr(self.name, "Failed listening to socket.")
                running = False
                break
            if server_msgs[0] == "path":
                workers.append(RunScript("python GitStatusbar.py", args=server_msgs[1], silent=True))
            elif server_msgs[0] == "client":
                if server_msgs[1] == "1":
                    self.clients += 1
                    consoleMsgs.addstr(self.name, "Vim client started - Currently " + str(self.clients))
                elif server_msgs[1] == "-1":
                    self.clients -= 1
                    consoleMsgs.addstr(self.name, "Vim client stopped - Currently " + str(self.clients))
                elif server_msgs[1] == "0":
                    self.clients = -1
            elif server_msgs[0] == "compile":
                if server_msgs[1] == "":
                    consoleMsgs.addstr(self.name, "Stopped listening for changes to " + compiler.currentFile)
                    compiler.setPath("")
                    compiler.go = False
                    try:
                        compiler.currentScript.currentProcess.kill()
                    except:
                        pass
                else:
                    compiler.setPath(server_msgs[1])
            elif server_msgs[0] == "compileargs":
                try:
                    compiler.currentScript.currentProcess.kill()
                except:
                    pass
                compiler.args = server_msgs[1]
                with compiler.condition:
                    compiler.go = False
                    compiler.go = True
                    compiler.condition.notify()
                    consoleMsgs.addstr(self.name, "Listening for changes - " + compiler.currentFile)
            elif server_msgs[0] == "tags":
                workers.append(RunScript("python TagGenerator.py"))
            c.close()

compiler = Compiler()
workers = []
drawer = Drawer()
server = Server()
console = Console()

while(True):
    kill = False
    for worker in workers:
        if not worker.isAlive():
            workers.remove(worker)
    if server.clients == -1:
        kill = True
    if server.clients == 0:
        consoleMsgs.addstr("Client", "No vim clients left")
        kill = True
        for i in range(0,3):
            consoleMsgs.addstr("Client", "Killing helper in {}sec".format(3-i))
            time.sleep(1)
            if server.clients > 0:
                kill = False
                break
    if kill:
        try:
            f = open(compileTimesFile, 'w')
            json.dump(compileTimes, f)
            f.close()
        except Exception,e:
            print str(e)
        sys.exit()
    time.sleep(0.1)
