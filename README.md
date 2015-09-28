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
6. Install lua.
7. Install clang.
8. Install ctags.
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

### Fugitive
* If fugitive doesn't do anything when you try to commit and just types "fugitive:" in red in the command line then try running git commit in terminal. You might not have initiated your git and that should fix it.
# Vimperator

Firefox pentadactyl settings.  

## INSTALL
Add a .vimperatorrc with the line:  
`` source ~/git/vim/.vimperatorrc `` 

# TODO

* Find a way to work on pdf on the server but view it on another computer.
	* Script that fetches a file constantly? Is there already a common
	practice for doing this?
	* Make it general if it works so you can do this for any project/file.
* TexBuilder creates a temp.tex in vim folder. Change it to use the folder
	where you are currently building.
* Create a remote repo for my info/notes.
* Create own session unite source. Currently use Shougos for no reason.
	* Create a unite source that shows files in my session folder.
		Show name of the session. This should be a list of the buffers
		in that session.
		Show timestamp of the last time that sessions was used.
		(Show working folder)?
	* Add default action to open that session.
	* (Delete session button)?
	* (Bookmark sessions)?
	* Remove shougos session plugin.
* Add a :et command. Creates a file in the tempfolder for quick testing and so on.
* Make it possible to reference pdfs and maybe firefox using my note-system.
* Add a bind in unite to change sorting method from time to name.
* Get more information from my jedi completion.
* Change my unite snippet source to non volatile.
* TagGenerator
	* helptags for vim
	* todo
* Move my infostuff to server repo.
* Echo result of rm mv add. Echomsg?
* Create unite source for external commands. Switch to that unite buffer to 
get more output from program.
* Make my draw into a real plugin.
* Download all external binaries for windows and put them at a convenient
	location to make installing vim easier.
* Better names in ö.
* cp in unite.
* Detect stuff that needs compiling and compile by itself.
