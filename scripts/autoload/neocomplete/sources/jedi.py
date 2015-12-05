import jedi
import re
import vim

source = '\n'.join(vim.current.buffer)
row = vim.current.window.cursor[0]
column = vim.current.window.cursor[1]
buf_path = vim.current.buffer.name
encoding = vim.eval('&encoding') or 'latin1'
script =  jedi.Script(source, row, column, buf_path, encoding)
completions = script.complete()
completion_string = ""
for completion in completions:
    params = completion.params if completion.type == 'function' else ""
    vim.command("call add( l:completion, {'word' : '" + completion.word +
                    "', 'menu' : s:jedi_source.mark . ' " + completion.type + "'})")
#                    "', 'description' : '" + re.sub("'", '`', completion.description) +
#                    "', 'type' : '" + completion.type + 
#                    "', 'param' : '" + params +
#                    "', 'name' : '" + completion.name + "'})")
