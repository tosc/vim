# vim

Vim settings.

## INSTALL
### BASE

A vimrc that doesn't require any additional addons.

1. Create a vimrc with the lines:
```VimL
source ~/git/vim/base.vim
source ~/git/vim/folding.vim
```

### HEAVY
A vimrc with addons, more taxing that the base installation.

1. Create a vimrc with the lines:
```VimL
source ~/git/vim/base.vim
source ~/git/vim/folding.vim
source ~/git/vim/heavy.vim
```
2. Go into the cloned vim-repo and run.  
``git submodule init``  
``git submodule update``
