#!/bin/bash

# Script for controlling several heritrix crawlers together
# Can build, launch, unpase, pause, terminate and teardown using the heritrix api

function usage_message {
    echo 'usage: bash crawl.sh [command]'
    echo 'use "bash crawl.sh help" for list of commands'
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
    echo '    ls - list crawlers and basic configuration'
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

# Define commands
function ls {
    for i in ${!crawlers[@]}; do {
        echo "id: ${crawler_id[i]}, address: ${crawlers[i]}, port: $port"
    } done
}

function build {
    echo "Building..."
    for crawler in ${crawlers[@]}; do {
        echo "$crawler"
    } done
}

function launch {
    echo "Launching..."
    for crawler in ${crawlers[@]}; do {
        echo "$crawler"
    } done
}

function pause {
    echo "Pausing..."
    for crawler in ${crawlers[@]}; do {
        echo "$crawler"
    } done
}

function unpause {
    echo "Resuming..."
    for crawler in ${crawlers[@]}; do {
        echo "$crawler"
    } done
}

function terminate {
    echo "Terminating..."
    for crawler in ${crawlers[@]}; do {
        echo "$crawler"
    } done
}

function teardown {
    echo "Cleaning..."
    for crawler in ${crawlers[@]}; do {
        echo "$crawler"
    } done
}

function status {
    first_i="y"
    for crawler in ${crawlers[@]}; do {
        [ "$first_i" != "y" ] && sleep "$delay" || first_i="n"
        echo "------ Status for $crawler ------"
        curl --no-progress-meter -k -u "$username":"$password" \
        --anyauth --location -H "Accept: application/xml" https://"$crawler":"$port"/engine/job/"$job" |\
        python3 ../xml_logs_to_csv.py '^<shortName>' '^<statusDescription>' '^<novel>' '^<total>'
        # echo ''
    } done
}

case "$1" in
    ( "ls" ) ls;;
    ( "build") build;;
    ( "launch" ) launch;;
    ( "pause" ) pause;;
    ( "unpause" ) unpause;;
    ( "terminate" ) terminate;;
    ( "teardown" ) teardown;;
    ( "status" ) status;;
    ( * ) usage_message;;
esac