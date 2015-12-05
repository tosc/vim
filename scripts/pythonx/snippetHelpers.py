import re
import vim

def add_package(inc_or_imp, package):
    line = 0
    found = False
    for i in range(0,len(vim.current.buffer) - 1):
            impMatch = re.match("^" + inc_or_imp + " (.*)$", vim.current.buffer[i])
            if impMatch:
                    line = i
                    if impMatch.group(1) == package:
                            found = True
                            break
    if not found:
            vim.current.buffer.append(inc_or_imp + " " + package, line + 1)
