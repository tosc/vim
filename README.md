# vim

Vim settings.

## INSTALL
### ALL

1. Install vim with if_lua. (On windows http://solar-blogg.blogspot.ca/p/vim-build.html is a good place for prebuilt binaries.)
2. Install python27.
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

* BUG: Missing space in statusline. ahead, behind
* BUG: My gitdiff doesn't disable when opening unite.
* BUG: ö works in insert but not normal when using juicyssh.
* BUG: When saving xml vim gives an error. Seems to be eclim who's doing it.

* Find way to disable default US source for neocmplete.
* Use vimproc for gitcommands so vim doesn't freeze.
* Move from using my filteromni to making an own complete longest common function. With this I can use fuzzy but still have my tabcompletion.
* Find way of getting my delimiters to show right away and not when the entire keycommand is pressed. I might have to change my approach.
* Look at neobundle to make installation easier.
* Add definition jedi usages and stuff like that.
* Look at async syntax checker.
* Look at syntastics spellchecker.
* Make tags project specific. Currently language specific.
* Add option to disable git draw. Already exists?

* Change my buildcommands to use vimproc and output all the information to a buffer. Add a leader binding to kill the process and also make sure to kill it when you run something new. (Doesn't unite make basically do this?)
* Try autosave for everything. (How will stuff like statusline,syntastic and git get updated?)
* Really slow when using syntastic and editing my vimrc. Split my vimrc into smaller parts?
* Change my keyboard layout using <leader>se and <leader>so.
* Find way to send texcompiling error to vim and hide the texcompiling window.
* Kill autotexcompiling when closing tex buffer.
