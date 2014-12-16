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
11. Download Vundle  
`` git clone https://github.com/gmarik/Vundle.vim ~/.vim/bundle/Vundle.vim``  
`` :BundleInstall ``  
12. Build clang_complete.  
`` make install ``

### WINDOWS

1. Install mingw, make sure you select packages for msys. 
2. Add mingw/bin and mingw/msys/ * /bin to path.
3. Add ctags to path.
4. Add eclimd to path.
5. Add clang to path.
6. Add python27 to path.
7. Add lua to path.
8: Add mono/bin to path.
8. Link Ultisnips snippetfolder  
``mklink /D "%HOME%/vimfiles/UltiSnips" "%HOME%/git/vim/UltiSnips"``  
9. Link my dictionary folder  
``mklink /D "%HOME%/.vim/dict" "%HOME%/git/vim/dict"`` 
10. Compile omnisharp.  
`` Run msbuild in folder ~/.vim/bundle/omnisharp-vim/server``  
11. Compile Vimproc (Different for 32/64bit, use same as your vim installation.)  
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

1. Link Ultisnips snippetfolder  
``ln -s ~/git/vim/UltiSnips ~/.vim/UltiSnips``  
2. Link my dictionary folder  
``ln -s ~/git/vim/dict ~/.vim/dict``  
3. Compile Vimproc.  
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

* BUG: All folds close on save sometimes. Fold stop working after save sometimes.
* Add button to show my names and the colors of my marks. mg? Mg? ?
* Move my infostuff to server repo.
* Shoud I highlight special marks?
* TagGenerator
	* helptags for vim
	* todo
* Create unite source for external commands. Switch to that unite buffer to 
get more output from program.
* Find more fitting sorter for file and dir sources.
* Add move file in unite. Press move on candidate and save that path. Move around
using unite and press m on where to put it. Prompt with new path and yes /no.
* BUG: US2 doesn't show in python files.
* Split big functions into own script files in vim-script.
	* DrawGit
	* Jumps
	* Tagcompletion
* BUG: Delimiter stops h abbrev from working. Currently disabled space delimiter.
* Move from using my filteromni to making an own complete longest common
 function. With this I can use fuzzy but still have my tabcompletion.
* BUG: When saving xml vim gives an error. Seems to be eclim who's doing it.
* Fix highlightcolors for marks in terminal.

* Add easy bind for / ? so I can use them more like f F.
* Look at neobundle to make installation easier.
* Look at syntastics spellchecker.
* Find way to disable default US source for neocomplete.
