import os
import re

for fileName in os.listdir("./UltiSnips/"):
    if ".snippets" in fileName:

        suggestions = []
        fileSplit = fileName.split('.')

        #Empty all tagfiles
        r = open("UltiSnips/tags/" + fileSplit[0] + ".tags", 'w')
        r.write('')
        r.close()

        #Read and retrieve snippets and their descriptions
        f = open("UltiSnips/" + fileName, 'r')
        line = f.readline()
        while line != '':
            brokenSnippet = True
            isSnippet = re.match('^snippet(.*)$', line)
            if isSnippet:
                match = re.match('(^snippet ){1}(\S+)$', line)
                if match:
                    suggestions.append((match.group(2), match.group(2)))
                    brokenSnippet = False
                match = re.match('(^snippet ){1}(\S+) "(.*)"(| \S+)', line)
                regdescmatch = re.match('(^snippet ){1}"(.*)" "(.*)"( \S+)', line)
                if regdescmatch:
                    match = regdescmatch
                if match:
                    if ":" in match.group(3):
                        suggSplitColon = match.group(3).split(':')
                        suggTags = []
                        if "|" in suggSplitColon[1]:
                            suggSplitBar = suggSplitColon[1].split('|')
                            for suggTag in suggSplitBar:
                                suggTags.append(suggTag)
                                brokenSnippet = False
                        else:
                            suggTags.append(suggSplitColon[1])
                            brokenSnippet = False
                        for suggTag in suggTags:
                            suggestions.append((suggTag, suggSplitColon[0]))
                            brokenSnippet = False
                    else:
                        suggestions.append((match.group(2), match.group(3)))
                        brokenSnippet = False
            else:
                brokenSnippet = False
            if brokenSnippet:
                print "BROKEN SNIPPET" + ": " + line
            line = f.readline()


        #Save all snippets to the tagsfile.

        newTags = 0
        r = open("UltiSnips/tags/" + fileSplit[0] + ".tags", 'a')
        for (snippet, description) in suggestions:
            r.write(snippet + "\t" + description + '\n')
            newTags += 1
        r.close()
        print "{0:10} {1} new tags.".format(fileSplit[0], str(newTags))
