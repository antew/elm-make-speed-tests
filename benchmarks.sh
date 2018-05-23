#!/bin/bash
arr=(
  ''
)

repos=(
    'https://github.com/rtfeldman/elm-spa-example.git'
    'https://github.com/sporto/elm-tutorial-app.git'
    'https://github.com/stefankreitmayer/elm-joust.git'
    'https://github.com/w0rm/elm-flatris.git'
    'https://github.com/FidelisClayton/elm-spotify-mapper.git'
    'https://github.com/brenopanzolini/pokelmon'
    'https://github.com/huytd/kanelm'
    # 'https://github.com/robx/elm-unicode.git'
)

mkdir -p /repos && cd /repos
ELM_MAKE_BINARY=/elmbin/elm-make-rts
ORIGINAL_ELM_MAKE_BINARY=/elmbin/dist_binaries/elm-make
touch times.txt

for r in "${repos[@]}"
do
    git clone $r ./test
    cd test
    /elmbin/dist_binaries/elm-package install -y > /dev/null 2>&1
        
    echo "Starting run for repo: $r"
    echo "Original elm-make"
    time $ORIGINAL_ELM_MAKE_BINARY src/Main.elm

    for i in "${arr[@]}"
    do
        rm -rf elm-stuff/build-artifacts
        echo "elm-make with options: $i"
        time $ELM_MAKE_BINARY src/Main.elm
    done
    
    cd ..
    rm -rf ./test
done
