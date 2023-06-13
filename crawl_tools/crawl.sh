#!/bin/bash

# Script for controlling several heritrix crawlers together
# Can build, launch, unpase, pause, terminate and teardown using the heritrix api

function usage_message {
    echo 'usage: bash crawl.sh [command]'
    echo 'use "bash crawl.sh help" for description'
}

if [ "$#" != "1" ]; then {
    usage_message
    exit 1
} fi

# If help command is specified then print help and exit before anything else
if [ "$1" == "help" ]; then {
    echo '"crawl.sh" - Script for operating multiple heritrix crawlers'
    echo ''
    usage_message
    echo ''
    echo 'Commands:'
    echo '    build -'
    echo '    launch - '
    echo '    pause - '
    echo '    unpause - '
    echo '    terminate - '
    echo '    teardown - '
    echo '    status - '
    exit 0
} fi

# Test if settings file exists and load it if it does
if [ -e settings_crawl.sh ] ; then {
    . settings_crawl.sh
} else {
    echo 'You need to have "settings_crawlsh.sh" in this directory to proceed'
    echo 'You can create one by copying settings_crawl.template'
    echo '    cp settings_crawl.template settings_crawlsh.sh'
    echo 'Exiting...'
    exit 1
} fi
