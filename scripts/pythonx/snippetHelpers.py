import re
import vim

#imp_or_inc, name of packages in current langauge, ex import
#package, name of the package you want to include.
#fileBuffer, the buffer you want to add this package too.
#Returns 1 if you added the package. 0 if it already exists.
#Looks for a package "imp_or_inc package", doesn't add it if it exists.
#Else adds it after the last "imp_or_inc *" in the file.
def add_package(imp_or_inc, package, fileBuffer):
	line = -1
	found = False
	for i in range(0,len(fileBuffer) - 1):
		importMatch = re.match("^" + imp_or_inc + " (\S*)$", fileBuffer[i])
		if importMatch:
			line = i
			if importMatch.group(1) == package:
				found = True
				break
	if not found:
		fileBuffer.append(imp_or_inc + " " + package, line + 1)
		return 1
	return 0
