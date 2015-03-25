# vim

Vim settings.

## INSTALL
### ALL

1. Install vim with if_lua. (On windows http://solar-blogg.blogspot.ca/p/vim-build.html is a good place for prebuilt binaries.)
2. Install python.
3. Install lua.
4. Install clang.
5. Install ctags.
6. Install LaTex.
7. Install Eclipse.
8. Install ECLIM.
9. Install Mono-develop. (http://www.mono-project.com/)
10. Create a vimrc with the lines:  
```VimL
"let g:minimalMode = 1
"let g:disablePlugins = 1
"let g:disableExternal = 1
source ~/git/vim/.vimrc
```  
11. Build clang_complete.  
`` make install ``

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

# PENTADACTYL

Firefox pentadactyl settings.  

## INSTALL
Add a pentadactylrc with the line:  
`` source ~/git/vim/.pentadactylrc `` 

# TODO

* Make it possible to reference pdfs and maybe firefox using my note-system.
* Change pentadactyl to vimperator.
* Add a bind in unite to change sorting method from time to name.
* Get more information from my jedi completion.
* Change my unite snippet source to non volatile.
* TagGenerator
	* helptags for vim
	* todo
* Move my infostuff to server repo.
* Move my sources to vim-scripts.
* Echo result of rm mv add. Echomsg?
* Create unite source for external commands. Switch to that unite buffer to 
get more output from program.
* Make my draw into a real plugin.
* Find way to disable default US source for neocomplete.
* Download all external binaries for windows and put them at a convenient
	location to make installing vim easier.
* Better names in ö.
* cp in unite.
* Detect stuff that needs compiling and compile by itself.
* Add easy bind for / ? so I can use them more like f F.
