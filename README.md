vim
===

My vim settings.


FRESH INSTALL
=============

#### ALL

1. Create a vimrc with the line:  
``source ~/git/vim/.vimrc``  
2. Create folder  ``.vim/tmp`` , it's used for backup files.
4. Run :BundleInstall.
5. Link Ultisnips snippetfolder from ``~/git/vim/UltiSnips``  
``Windows	: mklink /D ~/vimfiles/UltiSnips ~/git/vim/UltiSnips``  
6. Build clang_complete. Go into clang_complete folder and run make install.
7. Eclim. Download the appropriate eclim version for your version of eclipse. Run jar.
8. Vimproc. Compile  
``Windows : make -f make_mingw32.mak``  
``mac 	: make -f make_mac.mak``  
``unix 	: make -f make_unix.mak``  
9. Download LaTex.
10. Install ctags.
11. Create folder ~/.vim/tags

#### WINDOWS

1. Install mingw, make sure you select packages for msys. Add mingw/bin and mingw/msys/ * /bin to path.
2. Add VIM as editor for files without extension (Optional).  
``[HKEY_CLASSES_ROOT.] @="No Extension"``  
``[HKEY_CLASSES_ROOT\No Extension]``  
``[HKEY_CLASSES_ROOT\No Extension\Shell]``  
``[HKEY_CLASSES_ROOT\No Extension\Shell\Open]``  
``[HKEY_CLASSES_ROOT\No Extension\Shell\Open\Command] @="C:\\pathtoexe\\yourexe.exe %1"``
3. Add ctags to path.

#### LINUX

Current version
===============

* Commented vimproc and vimshell, remove on next update if I don't have any issues.
* Moved TODO and TROUBLESHOOTING from vimrc to README.

TODO
====

* Use eclim for python completion.
* Look at syntastic. (scrooloose/syntastic)
* Make vim create required directories by itself. (call mkdir)

TROUBLESHOOTING
===============
* Omnisharp. Check omnisharp github for installation. (It may work without any special installation, if not, you may have to build the server component again. If you are on linux then you have to update your .slnfiles with correct paths.)
* Ultisnips - If completion doesn't work but :UltiSnipsEdit opens the correct file, check if there is another vimfiles folder and add a symlink to that one aswell. (Had to symlink UltiSnips to both vimfiles and vimfiles last time to get it to work.)
* Clang_complete - If the completion engine returns nothing then clang_complete might have been updated. Run make install and it should work.
