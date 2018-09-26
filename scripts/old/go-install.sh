#!/bin/bash
    VERSION="1.9"
    DFILE="go$VERSION.linux-amd64.tar.gz"
    echo "Downloading $DFILE ..."
    wget https://storage.googleapis.com/golang/$DFILE -O /tmp/go.tar.gz
    echo "Extracting ..."
    tar -C "$HOME" -xzf /tmp/go.tar.gz
    mv "$HOME/go" "$HOME/.go"
    touch "$HOME/.bashrc"
    {
        echo '# GoLang'
        echo 'export GOROOT=$HOME/.go'
        echo 'export PATH=$PATH:$GOROOT/bin'
        echo 'export GOPATH=$HOME/go'
        echo 'export PATH=$PATH:$GOPATH/bin'
    } >> "$HOME/.bashrc"
    mkdir -p $HOME/go/{src,pkg,bin}
    rm -f /tmp/go.tar.gz
    exec bash
