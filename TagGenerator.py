# This program will generate tags for different subjects or programming languages. 
# A subject will have it's own directory.
# - subject
#   - documentation     If the language has a documentation then place it here and create a custom rule for how to get the tags for it.
#   - notes             Notes/stuff to remember about the subject. Generates a tag at location if line start with a character.
#                       Create a custom tag that link to stuff by having a line with 3 sections of text separated by tags. 
#                       name-of-tag \t location of file from info \t what part of the file to show using regex searchpattern
#                       Example of a c-note for how print works. Links to the documentation for libc where the line starts with 12.12.
#                       print \t /documentation/libc.txt \t ^12.12
#   - (opt)compendium   Other stuff you can link to using custom-tags
import os
import re

infoloc = "C:/Users/opo/git/info/"
doc = "/documentation/"
notes= "/notes/"
tagloc = ""
totaltags = 0
def generateNoteTags(directory):
    global totaltags
    noteloc = infoloc + directory + notes
    nrcreated = 0
    for file in os.listdir(noteloc):
        f = open(noteloc + "/" + file, 'r')
        line = f.readline()
        while line != '':
            # print line
            match = re.match('^(.*)\t(.*)\t(.*)$', line)
            match2 = re.match('^\w.*$', line)
            if match:
                nrcreated += 1
                r.write(match.group(1) + ' ????\t' + infoloc + directory + match.group(2) + '\t' + match.group(3) + '\n')
            elif match2:
                nrcreated += 1
                line = line[:-1]
                r.write(line + ' ????\t' + noteloc + "/" + file + '\t' + line + '\n')
            line = f.readline()
        f.close()
    totaltags += nrcreated
    print "Notes:              " + str(nrcreated) + " tags created."

for directory in os.listdir(infoloc):
    if directory == "todo.txt" or directory == ".git":
        continue
    print directory
    tagloc = infoloc + directory + "/tags"
    r = open(tagloc, 'w')
    r.write('')
    r.close()
    r = open(tagloc, 'a')
    generateNoteTags(directory)
    nrcreated = 0
    if directory == "python":
        docloc = infoloc + directory + doc + "library"
        for stuff in os.listdir(docloc):
            name = stuff[:-4]
            f = open(docloc + "/" + stuff, 'r')
            line = f.readline()
            while line != '':
                # print line
                match = re.match('^\w\S+(\(.*\))?$', line)
                if match:
                    nrcreated += 1
                    line = line[:-1]
                    r.write(line + '\t' + docloc + "/" + stuff + '\t' + line + '\n')
                line = f.readline()
            f.close()
        r.close()

    if directory == "c":
        docloc = infoloc + directory + doc + "libc.txt"
        f = open(docloc, 'r')
        line = f.readline()
        while line != '':
            # print line
            match = re.match('(^ -- Function: ){1}(\w+ ?\*? ?)(\w+)', line)
            if match:
                nrcreated += 1
                tag = match.group(3)
                r.write(tag + '\t' + docloc + '\t' + line[:-1] + '\n')
            match = re.match('(^ -- Macro: ){1}(\w+ )?(\w+)', line)
            if match:
                nrcreated += 1
                tag = match.group(3)
                r.write(tag + '\t' + docloc + '\t' + line[:-1] + '\n')
            line = f.readline()
        r.close()

    if directory == "git":
        docloc = infoloc + directory + doc
        for stuff in os.listdir(docloc):
            match = re.match('^(' + directory + '-\w+).txt', stuff)
            if match:
                nrcreated += 1
                r.write(match.group(1) + '\t' + docloc + match.group(0) + '\t' + match.group(1) + '\n')
        r.close()
    if directory == "linux":
        docloc = infoloc + directory + doc
        for stuff in os.listdir(docloc):
            match = re.match('^(.+).txt', stuff)
            if match:
                nrcreated += 1
                r.write("man-" + match.group(1) + '\t' + docloc + match.group(0) + '\t' + match.group(1) + '\n')
        r.close()
    totaltags += nrcreated
    print "Documentation:      " + str(nrcreated) + " tags created."
    print ""
print "Total:              " + str(totaltags) + " tags created."
