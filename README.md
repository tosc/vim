vim
===

My vim settings.


FRESH INSTALL
=============

#### ALL

1. Create a vimrc with the line:  
``source ~/git/vim/.vimrc``  
2. Create folders  
``.vim/tmp - put's all backup files here instead of cluttering normal folders ``  
``.vim/tags - saves my tagfiles here ``  
4. Download Vundle
`` git clone https://github.com/gmarik/Vundle.vim ~/.vim/bundle/Vundle.vim``  
`` :BundleInstall ``  
5. Link Ultisnips snippetfolder from ``~/git/vim/UltiSnips to ~/vimfiles/UltiSnips/``  
``Windows	: mklink /D ~/vimfiles/UltiSnips ~/git/vim/UltiSnips``  
6. Build clang_complete. Go into clang_complete folder and run make install.
7. Install Eclipse.
8. Install ECLIM.
9. Download LaTex.
10. Install ctags.

#### WINDOWS

1. Install mingw, make sure you select packages for msys. Add mingw/bin and mingw/msys/ * /bin to path.
2. Add ctags to path.

##### (Optional)

1. Add VIM as editor for files without extension (Optional).  
``[HKEY_CLASSES_ROOT.] @="No Extension"``  
``[HKEY_CLASSES_ROOT\No Extension]``  
``[HKEY_CLASSES_ROOT\No Extension\Shell]``  
``[HKEY_CLASSES_ROOT\No Extension\Shell\Open]``  
``[HKEY_CLASSES_ROOT\No Extension\Shell\Open\Command] @="C:\\pathtoexe\\yourexe.exe %1"``

#### LINUX

Current version
===============

Updated vundle to use the new system.

TODO
====

* CHECK IF ECLIM IS A BETTER OPTION FOR C/C++ completion.
* Look into if I should keep ctags stuff.
* Make statusline update when using push. Idea is to check autocmd focuslost and then in slowstatusupdate keep track using a global variable if currently running slowstatusupdate, if so don't run again. Should stop all annoying problems. Might still be slow though since this will run everytime you do an external program.
* Make vim create required directories by itself. (call mkdir)
* Add RUBY ECLIM completion.
* Add PHP ECLIM completion.
* Add SCALA ECLIM completion.
* Add a jump to next tag when using snippets.

TROUBLESHOOTING
===============

#### Code-Completion

* C - clang_complete might have been updated. Try running make install on it.
* C# - Check omnisharp github for installation. If it still doesn't work you may have to build the server component again. If you are on linux then you have to update your .slnfiles with correct paths. Make sure the omnisharp daemon is running and has initialized, it should start automatically.
* Snippets - If snippet completion doesn't work but :UltiSnipsEdit opens the correct file, check if there is another vimfiles folder and add a symlink to that one aswell. (Had to symlink UltiSnips to both vimfiles and vimfiles last time to get it to work.)
* Python or Java - Make sure you have the ECLIM deamon running. If it still doesn't work then you might not have created a eclipse project.  
``Run :ProjectCreate path -n language``  
``Ex :ProjectCreate ~\git\test -n java``  
``If still unclear then look at :EclimHelp gettingstarted``  
