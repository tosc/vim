# vim

My vim settings.

## FRESH INSTALL
#### ALL

1. Create a vimrc with the line:  
``source ~/git/vim/.vimrc``  
2. Create folders  
``.vim/tmp``  
``.vim/tags``  
``.cache/unite/session``  
3. Download Vundle  
`` git clone https://github.com/gmarik/Vundle.vim ~/.vim/bundle/Vundle.vim``  
`` :BundleInstall ``  
5. Build clang_complete. Go into clang_complete folder and run make install.
6. Install Eclipse.
7. Install ECLIM.
8. Download LaTex.
9. Install ctags.

#### WINDOWS

1. Install mingw, make sure you select packages for msys. Add mingw/bin and mingw/msys/ * /bin to path.
2. Add ctags to path.
3. Link Ultisnips snippetfolder  
``mklink /D ~/vimfiles/UltiSnips ~/git/vim/UltiSnips``  
4. Build omnisharp.  
`` Run msbuild in folder ~/.vim/bundle/omnisharp-vim/server``  

##### (Optional)

1. Add VIM as editor for files without extension (Optional).  
``[HKEY_CLASSES_ROOT.] @="No Extension"``  
``[HKEY_CLASSES_ROOT\No Extension]``  
``[HKEY_CLASSES_ROOT\No Extension\Shell]``  
``[HKEY_CLASSES_ROOT\No Extension\Shell\Open]``  
``[HKEY_CLASSES_ROOT\No Extension\Shell\Open\Command] @="C:\\pathtoexe\\yourexe.exe %1"``

#### LINUX

1. Link Ultisnips snippetfolder  
``ln -s ~/git/vim/UltiSnips ~/.vim/UltiSnips``  

## TROUBLESHOOTING
#### Code-Completion

* C - clang_complete might have been updated. Try running make install on it.
* CS - Check omnisharp github for installation. If it still doesn't work you may have to build the server component again. If you are on linux then you have to update your .slnfiles with the correct paths. Make sure the omnisharp daemon is running and has initialized, it should start automatically.
* Python or Java - Make sure you have the ECLIM deamon running. If it still doesn't work then make sure that you are in an eclipse project. To create a new one run:  
``:ProjectCreate path -n language``  
``Ex :ProjectCreate ~\git\test -n java``  
``If still unclear then look at :EclimHelp gettingstarted``  

#### SSH

* If Unite binding doesn't work then check that you are using the right encoding for ssh.

## Pentadactyl

Firefox pentadactyl settings.  
Add a pentadactylrc with the line:  
`` source ~/git/vim/.pentadactylrc `` 

## TODO

* Look at replacing NERDTREE with VIMFILER
* BUGG - Pressing tab when you are at the beginning of a line sometimes paste some jibberish completion.
* BUGG - Eclim syntax checker complains on a correct import in vim but not in Eclipse.
* Make eclim start by itself.
* Look into vim-org
* Check if ECLIM is a viable option for C and C++ code-completion.
* Add RUBY ECLIM completion.
* Add PHP ECLIM completion.
* Add SCALA ECLIM completion.
* Make vim create required directories by itself.

