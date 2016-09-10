# vim

Vim settings.

## INSTALL
### ALL

1. Clone this repository.
2. Go into the cloned repo and run  
``git submodule init``  
``git submodule update``
3. Create a vimrc with the line:  
```VimL
source ~/git/vim/.vimrc
```  

### WINDOWS

### LINUX

### MAC

## TROUBLESHOOTING
### ERROR

### Code-Completion

#### CS

#### Java

#### Snippets
* If snippets don't complete then my tagfile for that filetype is wrong. Look into SnippetComplete.py script and try to figure out what the language: value has to be. (Case matters.) Run ctags --fields=+l filename and look what that returns.

### SSH

### Fugitive
* If fugitive doesn't do anything when you try to commit and just types "fugitive:" in red in the command line then try running git commit in terminal. You might not have initiated your git and that should fix it.
