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
9. Install ctags.
10. Install LaTex.
11. Install Eclipse.
12. Install ECLIM.
13. Install Mono-develop. (http://www.mono-project.com/)
14. Build clang_complete.  
`` make install ``
15. Create a vimrc with the lines:  
```VimL
"let g:minimalMode = 1
"let g:disablePlugins = 1
"let g:disableExternal = 1
source ~/git/vim/.vimrc
```  

### WINDOWS

1. Install mingw, make sure you select packages for msys. 
2. Add mingw/bin and mingw/msys/ * /bin to path.
3. Add ctags to path.
4. Add eclimd to path.
5. Add clang to path.
6. Add python27 to path.
7. Add lua to path.
8. Add mono/bin to path.
9. Compile omnisharp.  
`` Run msbuild in folder ~/.vim/bundle/omnisharp-vim/server``  
10. Compile Vimproc (Different for 32/64bit, use same as your vim installation.)  
`` make -f make_mingw32.mak``  
`` make -f make_mingw64.mak``  
11. Install curses-package for python. Download it here: http://www.lfd.uci.edu/~gohlke/pythonlibs/#curses
`` python -m pip downloaded-filename.whl ``
12. Resize cmd globally. (Rightclick title of cmd and select defaults.)

##### (Optional)

1. Add VIM as editor for files without extension (Optional).  
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
#### C
* clang_complete might have been updated. Try running make install on it.
* Make sure clang is installed and if on windows make sure clang is in path.

#### CS
* You may have to build the server component. 
* If you are on linux then you have to update your .slnfiles with the correct paths.
* Make sure the omnisharp daemon is running and has initialized.

#### Java
* Make sure you have the ECLIM deamon running. If it still doesn't work then make sure that you are in an eclipse project. To create a new one run:  
``:ProjectCreate path -n language``  
``Ex :ProjectCreate ~\git\test -n java``  
``If still unclear then look at :EclimHelp gettingstarted``  
* If vim complains about imports then add the location of that import in Eclipse to your project.

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
* Delete shougos addon for sessoins and remove anything that has to do
	with sessions. Never use them.
* Remove addons for tags. Never use tags.
* Remove addons for unite make, use my own external helper.
* Look into fastfold, remove?

### Mid
* VimHelper
	Check if you can make python focus other vim instance. If so,
	add other vims buffers to ö and make them switchable with ö.
* Find better way of calling help, make it so that I can use autocompletetion.
* Fix bug with unite and buffers (seems to happen when you have an empty
	buffer)
* Fix my pythonsnippets for method and function. Don't use the same
	helpfunction, use different ones and jump depending on that.
	In other words, if completing method then add that to a class.
	If completing function then add that outside class.
* Look into vim-operator-flashy.
* Look into SwagKingTenK/VimSearch.
* Add mapping to fix p removing the yank register.
	Try this mapping:
	xnoremap p pgvy
	Does this break any actions that use operators with p?
* Use alt bindings for jumping between tabtops? Alt+H Alt-L
	Look to make sure those are safe to bind.
* Fix weird formatting in ö

### Low
* VimHelper
	Move my autocomplete to vimhelper.
* Add a bind in unite to change sorting method from time to name.
* TagGenerator
	* helptags for vim
	* todo
* Change my unite snippet source to non volatile.
* Echo result of rm mv add. Echomsg?
* Make my draw into a real plugin.
* Download all external binaries for windows and put them at a convenient
	location to make installing vim easier.
* Better names in Ã¶.
* cp in unite.
* Split vimrc into smaller files. Especially want to move foldingmethods to separate.
