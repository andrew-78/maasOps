#!/bin/bash
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_basic_vimrc.sh

if [ -f ./devstackrc ]; then
    cp ./devstackrc ~/.devstackrc
    if [ -f ~/.bashrc ]; then
        echo "if [ -f ~/.devstackrc ]; then . ~/.devstackrc; fi " >> ~/.bashrc
    fi
fi

