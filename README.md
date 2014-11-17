vim
===

My vim settings.


# FRESH INSTALL

#### ALL

1. Create a ./_vimrc with the line:  
``source ~/git/vim/.vimrc``  
2. Create a tmp folder, .vim/tmp for backup files.
3. Link this vimrc to your homedir.
4. Run :BundleInstall.
5. Link Ultisnips snippetfolder from Dropbox.
6. Build clang. Go into clang folder and run make install.
7. Eclim. Download the appropriate eclim version for your version of eclipse. Run jar.
8. Vimproc. Compile  
``Windows : make -f make_mingw32.mak``  
``mac 	: make -f make_mac.mak``  
``unix 	: make -f make_unix.mak``  
9. Download LaTex.
10. Install ctags.
11. Create folder ~/.vim/tags
12. Install JEDI by running git submodule update --init in jedi-vim.

#### WINDOWS

1. Install mingw, make sure you select packages for msys. Add mingw/bin and mingw/msys/*/bin to path.
2. Add VIM as editor for files without extension.  
``[HKEY_CLASSES_ROOT.] @="No Extension"``  
``[HKEY_CLASSES_ROOT\No Extension]``  
``[HKEY_CLASSES_ROOT\No Extension\Shell]``  
``[HKEY_CLASSES_ROOT\No Extension\Shell\Open]``  
``[HKEY_CLASSES_ROOT\No Extension\Shell\Open\Command] @="C:\\pathtoexe\\yourexe.exe %1"``
3. Add ctags to path.

#### LINUX
