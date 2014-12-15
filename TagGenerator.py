# This program will generate tags for different subjects or programming languages. 
# A subject will have it's own directory.
# - subject
#   - documentation     If the language has a documentation then place it here and create a custom rule for how to get the tags for it.
#   - notes             Notes/stuff to remember about the subject. They should be in the style of a vim help file.
#   - custom-tags       Custom tags that link to stuff that isn't notes or documentation. Ex a link to a website and so on.
import os
import re

infoloc = "C:/Users/opo/info/"
doc = "/documentation/"
tagloc = ""
for directory in os.listdir(infoloc):
    if directory == "python":
        docloc = infoloc + directory + doc + "library"
        tagloc = infoloc + directory + "/tags"
        r = open(tagloc, 'w')
        r.write('')
        r.close()
        r = open(tagloc, 'a')
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
        tagloc = infoloc + directory + "/tags"
        r = open(tagloc, 'w')
        r.write('')
        r.close()
        r = open(tagloc, 'a')
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
        f.close()
        r.close()
