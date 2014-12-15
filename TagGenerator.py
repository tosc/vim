# This program will generate tags for different subjects or programming languages. 
# A subject will have it's own directory.
# - subject
#   - documentation     If the language has a documentation then place it here and create a custom rule for how to get the tags for it.
#   - notes             Notes/stuff to remember about the subject. Generates a tag at location if line start with a character.
#                       Create a custom tag that link to stuff by having a line with 3 sections of text separated by tags. Ex: text \t location from info \t regex searchpattern in file
#   - (opt)compendium   Other stuff you can link to using custom-tags
import os
import re

infoloc = "C:/Users/opo/info/"
doc = "/documentation/"
notes= "/notes/"
tagloc = ""
def generateNoteTags(directory):
    noteloc = infoloc + directory + notes
    for file in os.listdir(noteloc):
        f = open(noteloc + "/" + file, 'r')
        line = f.readline()
        while line != '':
            # print line
            match = re.match('^(.*)\t(.*)\t(.*)$', line)
            match2 = re.match('^\w.*$', line)
            if match:
                r.write(match.group(1) + '\t' + infoloc + directory + match.group(2) + '\t' + match.group(3) + '\n')
            elif match2:
                line = line[:-1]
                r.write(line + '\t' + noteloc + "/" + file + '\t' + line + '\n')
            line = f.readline()
        f.close()

for directory in os.listdir(infoloc):
    tagloc = infoloc + directory + "/tags"
    r = open(tagloc, 'w')
    r.write('')
    r.close()
    r = open(tagloc, 'a')
    generateNoteTags(directory)
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
                tag = match.group(3)
                r.write(tag + '\t' + docloc + '\t' + line[:-1] + '\n')
            match = re.match('(^ -- Macro: ){1}(\w+ )?(\w+)', line)
            if match:
                tag = match.group(3)
                r.write(tag + '\t' + docloc + '\t' + line[:-1] + '\n')
            line = f.readline()
        r.close()

    if directory == "git":
        docloc = infoloc + directory + doc
        for stuff in os.listdir(docloc):
            match = re.match('^(' + directory + '-\w+).txt', stuff)
            if match:
                r.write(match.group(1) + '\t' + docloc + match.group(0) + '\t' + match.group(1) + '\n')
        r.close()
    if directory == "linux":
        docloc = infoloc + directory + doc
        for stuff in os.listdir(docloc):
            match = re.match('^(.+).txt', stuff)
            if match:
                r.write(match.group(1) + '\t' + docloc + match.group(0) + '\t' + match.group(1) + '\n')
        r.close()
