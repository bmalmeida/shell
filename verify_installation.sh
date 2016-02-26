#!/bin/bash

function verify_installation(){
INSTALLED=`which $1`
    if [ -n "$INSTALLED" ]; then
        echo 0; #true
    else
        echo 1; #false
    fi
    return
}


verify_installation 'zss'
