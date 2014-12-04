# vim

Vim settings.

## INSTALL
### ALL

1. Install vim with if_lua. (On windows http://solar-blogg.blogspot.ca/p/vim-build.html is a good place for prebuilt binaries.)
2. Install python27.
3. Create a vimrc with the lines:  
```VimL
"let g:minimalMode = 1
"let g:disablePlugins = 1
"let g:disableExternal = 1
source ~/git/vim/.vimrc
```  
4. Download Vundle  
`` git clone https://github.com/gmarik/Vundle.vim ~/.vim/bundle/Vundle.vim``  
`` :BundleInstall ``  
5. Build clang_complete. Go into clang_complete folder and run make install.
6. Install Eclipse.
7. Install ECLIM.
8. Add eclimd to path.
9. Download LaTex.
10. Install ctags.

### WINDOWS

1. Install mingw, make sure you select packages for msys. Add mingw/bin and mingw/msys/ * /bin to path.
2. Add ctags to path.
3. Link Ultisnips snippetfolder  
``mklink /D ~/vimfiles/UltiSnips ~/git/vim/UltiSnips``  
4. Compile omnisharp.  
`` Run msbuild in folder ~/.vim/bundle/omnisharp-vim/server``  
5. Compile Vimproc (Different for 32/64bit).   
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
2. Compile Vimproc.   
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
* Missing python27.dll. You might be using a 64bit vim with 32bit python. Install 64bit python and it should work.

### Code-Completion
#### C
* clang_complete might have been updated. Try running make install on it.

#### CS
* You may have to build the server component. 
* If you are on linux then you have to update your .slnfiles with the correct paths.
* Make sure the omnisharp daemon is running and has initialized.

#### Java and Python
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

* BUG: When saving xml vim gives an error. Seems to be eclim who's doing it.
* BUG: g:disableExternal doesn't disable omnisharp.

* Change how I use my snippets. Make things that require a lot of computing power, like finding variables and so on and make those into a global python snippet. In the snippets we pick out the things we want to complete it to.
* Look into setting if_lua in vim so I can use neocomplete instead of neocomplcache. (Download remade binaries?)
* Check if ECLIM is a viable option for C and C++ code-completion.
* Eclim - find way of adding source directories using vim instead of having to open eclipse.
* Make tags project specific. Currently language specific.
* Rename repo to something more fitting, ex dotfiles.
* Look at neobundle to make installation easier.

* Improve my gitstatusline. Use vimproc or dispatch to refresh it more often.
* Turn all my external helpers into one big one with easy ways to increase functionality.
	Have my helper in a terminal. Keybinding in vim builds and runs in that terminal and shows all output there.
	Have my git status stuff update in there.
	Have my texstuff building in there.
* Change my keyboard layout using <leader>se and <leader>so.
* Find way to send texcompiling error to vim and hide the texcompiling window.
* Find way to kill autotexcompiling when closing tex buffer.
* Open pdfviewer with vim / texcompiler.
