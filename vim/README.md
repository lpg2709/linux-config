# My personal vim configuration

Require:
- [git](https://git-scm.com/download/linux)
- [vim-plug](https://github.com/junegunn/vim-plug)

## Install

Just copy and paste this command:

```sh
bash -c  "$(wget -qO- https://git.io/JCbTi)"
```
and press ENTER.

Into vim:

> :PlugInstall

## ~Using YouCompleteMe~

~Install the plugin YouCompleteMe.~

```sh
cd ~/.vim/plugged/YouCompleteMe

sudo apt install build-essential cmake vim python3-dev

python3 install.py  --all
```

## Using COC

Needed NodeJS. [Install](https://github.com/nvm-sh/nvm)

For C/C++ needed install clangd, and make a alternative link to clangd-10.

```sh
sudo apt-get install clangd-10 llvm
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-10 100
```

Into vim:
> :CocInstall coc-tsserver coc-python coc-json coc-css coc-clangd coc-markdownlint coc-vetur coc-rls

