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
8. Add eclim to path.
8. Download LaTex.
9. Install ctags.

#### WINDOWS

1. Install mingw, make sure you select packages for msys. Add mingw/bin and mingw/msys/ * /bin to path.
2. Add ctags to path.
3. Link Ultisnips snippetfolder  
``mklink /D ~/vimfiles/UltiSnips ~/git/vim/UltiSnips``  
4. Compile omnisharp.  
`` Run msbuild in folder ~/.vim/bundle/omnisharp-vim/server``  
5. Compile Vimproc.   
`` make -f make_mingw32.mak`` 

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
2. Compile Vimproc.   
`` make -f make_unix.mak `` 

#### MAC

1. Compile Vimproc.   
`` mac : make -f make_mac.mak``

## OPTIONS

Add any of these lines to your vimrc to disable certain parts of the vimrc.  
These lines must be above ``source ~/git/vim/.vimrc``  
`` let g:minimalMode = 1 ``  - If you are on a slow computer but still want most of the functionality.  
`` let g:disablePlugins = 1 ``  - Don't use any plugins.

## TROUBLESHOOTING
### Code-Completion
#### C
* clang_complete might have been updated. Try running make install on it.

#### CS
* Check omnisharp github for installation. If it still doesn't work you may have to build the server component again. If you are on linux then you have to update your .slnfiles with the correct paths. Make sure the omnisharp daemon is running and has initialized, it should start automatically.

#### Java and Python
* Make sure you have the ECLIM deamon running. If it still doesn't work then make sure that you are in an eclipse project. To create a new one run:  
``:ProjectCreate path -n language``  
``Ex :ProjectCreate ~\git\test -n java``  
``If still unclear then look at :EclimHelp gettingstarted``  
* If vim complains about imports then add the location of that import in Eclipse to your project.

### SSH

* If Unite binding doesn't work then check that you are using the right encoding for ssh.

## PENTADACTYL

Firefox pentadactyl settings.  
Add a pentadactylrc with the line:  
`` source ~/git/vim/.pentadactylrc `` 

## TODO

* BUG: Writing () and then now pressing a letter should put you at the end of the ()
* Make tags project specific. Currently language specific.
* Add async compiling of tex using vimproc.
* Find a good bind for $.
* Do I use unite tag?
* Look into vim-org
* Check if ECLIM is a viable option for C and C++ code-completion.
* Add RUBY ECLIM completion.
* Add PHP ECLIM completion.
* Add SCALA ECLIM completion.
* Make vim create required directories by itself.
* Eclim - find way of adding source directories using vim instead of having to open eclipse.
* Check if plugin is loaded instead of checking if disablePlugin.
* Make eclimd start in background instead of taking focus from window.

