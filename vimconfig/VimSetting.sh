#!/bin/bash
OS=`uname`
cp ./.vimrc ~/
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
if [ $? -ne 0 ]
then
    echo "Install VundleVim Failed. Pleasure check and retry"
    exit -1
fi
vim -c 'BundleInstall' -c 'qa!'
if [ $? -ne 0 ]
then
    echo "Install Bundle Failed. Please check and retry"
    exit -2
fi
cd ~/.vim/bundle/YouCompleteMe
python3 install.py
cd -
