#!/bin/bash

#case program passed to function
#found on system them return 0 else 1
function verify_installation(){
which $1 > /dev/null 2>&1
    echo $?
}

verify_installation $1
