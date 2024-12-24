#!/bin/bash

function error {
    echo "##[error] $1"
}

function section {
    echo "##[section] $1"
}

function check_rx_perm {
    if [ $# -eq 1 ]; then
        local file=$1
    else
        error "check_rx_perm requires an argument"
        exit 2
    fi

    if [ -w $file -o ! -r $file -o ! -x $file ]; then
        error "$file does not have r-x permissions"
        exit 12
    fi
}

function check_rwx_perm {
    if [ $# -eq 1 ]; then
        local file=$1
    else
        error "check_rwx_perm requires an argument"
        exit 2
    fi

    if [ ! -w $file -o ! -r $file -o ! -x $file ]; then
        error "$file does not have rwx permissions"
        exit 13
    fi
}

function check_command {
    if [ $# -eq 1 ]; then
        local cmd=$1
    else
        error "check_rwx_perm requires an argument"
        exit 2
    fi

    eval $cmd

    if [ $? -ne 0]; then
        error "$cmd failed to run"
        exit 14
    fi
}

workdir='/agent'
tarFile="$workdir/$AGENT_FILE"

section "Checking that $tarFile was removed"
if [[ -e $tarFile ]]
then
    error "$tarFile is present"
    exit 11
fi

section "Checking file permissions"

# check_rx_perm "$workdir/start.sh"
# check_rx_perm "$workdir/config.sh"
# check_rwx_perm $workdir

section "Checking dependencies"

check_command "java -version"

exit 0