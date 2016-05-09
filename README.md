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
7. Install lua.
8. Install clang.
9. Install LaTex.
10. Install Eclipse.
11. Install ECLIM.
12. Install Mono-develop. (http://www.mono-project.com/)
13. Build clang_complete.  
`` make install ``
14. Create a vimrc with the lines:  
```VimL
"let g:minimalMode = 1
"let g:disablePlugins = 1
"let g:disableExternal = 1
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
9. Compile Vimproc (Different for 32/64bit, use same as your vim installation.)  
`` make -f make_mingw32.mak``  
`` make -f make_mingw64.mak``  
10. Install curses-package for python. Download it here: http://www.lfd.uci.edu/~gohlke/pythonlibs/#curses
`` python -m pip downloaded-filename.whl ``

##### (Optional)

1. Resize cmd globally. (Rightclick title of cmd and select defaults.)
2. Add VIM as editor for files without extension (Optional).  
``[HKEY_CLASSES_ROOT.] @="No Extension"``  
``[HKEY_CLASSES_ROOT\No Extension]``  
``[HKEY_CLASSES_ROOT\No Extension\Shell]``  
``[HKEY_CLASSES_ROOT\No Extension\Shell\Open]``  
``[HKEY_CLASSES_ROOT\No Extension\Shell\Open\Command] @="C:\\pathtoexe\\yourexe.exe %1"``

### LINUX

1. Compile Vimproc.  
`` make -f make_unix.mak ``  
2. Install curses-package for python.  
`` pip install curses ``  

### MAC

1. Compile Vimproc.   
`` mac : make -f make_mac.mak``

## OPTIONS

Uncomment any of these lines from your vimrc to disable certain parts of the vimrc.  
`` let g:minimalMode = 1 ``  - If you are on a slow computer but still want most of the functionality.  
`` let g:disablePlugins = 1 ``  - Don't use any plugins.  
`` let g:disableExternal = 1 ``  - Don't autostart external scripts. (Eclimd and texcompiler)  

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

# Vimperator

Firefox vimperator settings.  

## INSTALL
Add a .vimperatorrc with the line:  
`` source ~/git/vim/.vimperatorrc `` 

## TROUBLESHOOTING

### Bindings not working

Firefox probably updated. Revert to a previous update. (45.0 worked great)

# Blank your Monitor + Easy reading
1. Text Color: #FFFFFF
2. Background Color: #303030
3. Link Color: #87FF87
4. VLink Color: #D78787


# TODO

### Important
* Make repositories
	- Dotfiles
* Code-completion.
	- Add custom completer using YCM Completer API for snippets.

### Mid
* VH
	- Add git draw to this.
	- Add compilestatusbar
		- Show last time compiled.
		- Show how long it took.
		- Show script name.
	- Add time column to console window.
* Change delim to ultisnips ones.
* Only do the auto-save temp file when execute mode is running.
* Add readline for the statusbar to slowgit update like before.

### Low
* Go through all snippets files and update them to new way of doing things.
* VimHelper
	Check if you can make python focus other vim instance. If so,
		add other vims buffers to � and make them switchable with �.
* Installing vim:
	- Download all external binaries for windows and put them at a convenient
		location to make installing vim easier.
	- Add bat and sh script for installing my vim.
