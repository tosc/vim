# vim

Vim settings.

## INSTALL
### ALL

1. Install GIT.
2. Clone this repository.
3. Go into the cloned repo and run  
``git submodule init``  
``git submodule update``
4. Install vim with if_lua. (On windows http://solar-blogg.blogspot.ca/p/vim-build.html is a good place for prebuilt binaries.)
5. Install python.
6. Create a vimrc with the line:  
```VimL
source ~/git/vim/.vimrc
```  

### WINDOWS

1. Install mingw, make sure you select packages for msys. 
2. Add mingw/bin and mingw/msys/ * /bin to path.
3. Add eclimd to path.
4. Add clang to path.
5. Add python27 to path.
6. Add lua to path.
7. Add mono/bin to path.
8. Compile omnisharp.  
`` Run msbuild in folder ~/.vim/bundle/omnisharp-vim/server``  

### LINUX

### MAC

## TROUBLESHOOTING
### ERROR
* If vim complains about the statusline then you might be using an old git version. I use the -C flag and older version don't have it.
* Missing python27.dll. You might be using a 64bit vim with 32bit python or the other way around. Install the same version of python as your vim installation.

### Code-Completion
#### CS
* Make sure the omnisharp daemon is running and has initialized.

#### Java
* Make sure you have the ECLIM deamon running. If it still doesn't work then make sure that you are in an eclipse project. To create a new one run:  
``:ProjectCreate path -n language``  
``Ex :ProjectCreate ~\git\test -n java``  
``If still unclear then look at :EclimHelp gettingstarted``  
* If vim complains about imports then add the location of that import in Eclipse to your project.

#### Snippets
* If snippets don't complete then my tagfile for that filetype is wrong. Look into SnippetComplete.py script and try to figure out what the language: value has to be. (Case matters.) Run ctags --fields=+l filename and look what that returns.

### SSH
* If Unite binding doesn't work then check that you are using the right encoding for ssh.

### Fugitive
* If fugitive doesn't do anything when you try to commit and just types "fugitive:" in red in the command line then try running git commit in terminal. You might not have initiated your git and that should fix it.

### Unite
* If unite complains, try compiling vimproc.
