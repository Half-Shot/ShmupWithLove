#!/bin/bash
lovefile="game.love"
loveexe=$(which love)
if [[ $? -ne "0" ]]
then
    echo "No Love :("
    loveexe="./love"
else
    loveversion=$($loveexe --version)
    loveversion=$(echo "$loveversion"|cut -c 6-10)
    echo "Love Version:" $loveversion
    if [[ "$loveversion" != "0.9.2" ]]
    then
        echo "Wrong Love Version."
        loveexe="./love"
    fi
fi
$loveexe $lovefile
