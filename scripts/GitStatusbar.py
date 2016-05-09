"""
Updates GIT statusline in VIM

Saves new statusline to ~/.vim/tmp/gitstatusline/FILENAME
"""

import os
import sys
import subprocess

try:
    args = sys.argv
    if len(args) > 1:
        currentPath = args[1]
        currentFolder,currentFile = os.path.split(currentPath)

        filesRaw = subprocess.check_output("git -C " + currentFolder + " status -b -s", stderr=subprocess.STDOUT)
        rowsRaw = subprocess.check_output("git -C " + currentFolder + " diff --numstat", stderr=subprocess.STDOUT)

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
            if currentFile in row:
                changedRows = row.split("\t")
                statusLine += " [+" + changedRows[0] + " -" + changedRows[1] + "]"

        statuslineFileName = currentPath.replace("\\", "-").replace(":", "-").replace("/", "-")

        f = open(os.path.expanduser('~') + "/.vim/tmp/gitstatusline/" + statuslineFileName, 'w')
        f.write(statusLine)
        f.close()
except:
    print "Failed to update Statusbar"
