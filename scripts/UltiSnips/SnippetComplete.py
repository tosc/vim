import os
import re

for fileName in os.listdir("."):
    if ".snippets" in fileName:

        suggestions = []
        fileSplit = fileName.split('.')

        #Empty all tagfiles
        r = open(fileSplit[0] + ".tags", 'w')
        r.write('')
        r.close()

        #Read and retrieve snippets and their descriptions
        f = open(fileName, 'r')
        line = f.readline()
        while line != '':
            match = re.match('(^snippet ){1}(\S+) "(.*)"{1} (\S+)', line)
            if match:
                if "r" in match.group(4):
                    match = re.match('(^snippet ){1}"(.*)" "(.*)"{1} (\S+)', line)
            if match:
                if ":" in match.group(3):
                    suggSplitColon = match.group(3).split(':')
                    suggTags = []
                    if "|" in suggSplitColon[1]:
                        suggSplitBar = suggSplitColon[1].split('|')
                        for suggTag in suggSplitBar:
                            suggTags.append(suggTag)
                    else:
                        suggTags.append(suggSplitColon[1])
                    for suggTag in suggTags:
                        suggestions.append((suggTag, suggSplitColon[0]))
                else:
                    suggestions.append((match.group(2), match.group(3)))
            line = f.readline()


        #Save all snippets to the tagsfile.

        newTags = 0
        r = open(fileSplit[0] + ".tags", 'a')
        for (snippet, description) in suggestions:
            r.write(snippet + "\t" + description + '\n')
            newTags += 1
        r.close()
        print fileSplit[0]
        print "\t" + str(newTags) + " new tags."
