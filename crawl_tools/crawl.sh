#!/bin/bash

# Script for controlling several heritrix crawlers together
# Can build, launch, unpase, pause, terminate and teardown
# using the heritrix api

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
    echo '    build - build job configuration'
    echo '    launch - launch job'
    echo '    pause - pause job'
    echo '    unpause | resume - resume job'
    echo '    terminate - '
    echo '    teardown - '
    echo '    status - get crawler status'
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
        echo "id: ${crawler_id[i]}, address: ${crawlers[i]}, port: $port,\
 job: $job"
    } done
}

function build {
    first_i="y"
    for crawler in ${crawlers[@]}; do {
        [ "$first_i" != "y" ] && sleep "$delay" || first_i="n"
        echo "------ Building job configuration for $crawler ------" |\
        tee -a "$log_file"
        curl --no-progress-meter -d "action=build" \
        -k -u "$username":"$password" \
        --anyauth --location -H "Accept: application/xml" \
        https://"$crawler":"$port"/engine/job/"$job" |\
        tee -a "$log_file" |\
        python3 ../xml_logs_to_csv.py '^<statusDescription>'
    } done
}

function launch {
    first_i="y"
    for crawler in ${crawlers[@]}; do {
        [ "$first_i" != "y" ] && sleep "$delay" || first_i="n"
        echo "------ Launching job for $crawler ------" |\
        tee -a "$log_file"
        curl --no-progress-meter -d "action=launch" \
        -k -u "$username":"$password" \
        --anyauth --location -H "Accept: application/xml" \
        https://"$crawler":"$port"/engine/job/"$job" |\
        tee -a "$log_file" |\
        python3 ../xml_logs_to_csv.py '^<statusDescription>'
    } done
}

function pause {
    first_i="y"
    for crawler in ${crawlers[@]}; do {
        [ "$first_i" != "y" ] && sleep "$delay" || first_i="n"
        echo "------ Puasing job for $crawler ------" |\
        tee -a "$log_file"
        curl --no-progress-meter -d "action=pause" \
        -k -u "$username":"$password" \
        --anyauth --location -H "Accept: application/xml" \
        https://"$crawler":"$port"/engine/job/"$job" |\
        tee -a "$log_file" |\
        python3 ../xml_logs_to_csv.py '^<statusDescription>'
    } done
}

function unpause {
    first_i="y"
    for crawler in ${crawlers[@]}; do {
        [ "$first_i" != "y" ] && sleep "$delay" || first_i="n"
        echo "------ Resuming job for $crawler ------" |\
        tee -a "$log_file"
        curl --no-progress-meter -d "action=unpause" \
        -k -u "$username":"$password" \
        --anyauth --location -H "Accept: application/xml" \
        https://"$crawler":"$port"/engine/job/"$job" |\
        tee -a "$log_file" |\
        python3 ../xml_logs_to_csv.py '^<statusDescription>'
    } done
}

function terminate {
    first_i="y"
    for crawler in ${crawlers[@]}; do {
        [ "$first_i" != "y" ] && sleep "$delay" || first_i="n"
        echo "------ Stoping job for $crawler ------" |\
        tee -a "$log_file"
        curl --no-progress-meter -d "action=terminate" \
        -k -u "$username":"$password" \
        --anyauth --location -H "Accept: application/xml" \
        https://"$crawler":"$port"/engine/job/"$job" |\
        tee -a "$log_file" |\
        python3 ../xml_logs_to_csv.py '^<statusDescription>'
    } done
}

function teardown {
    first_i="y"
    for crawler in ${crawlers[@]}; do {
        [ "$first_i" != "y" ] && sleep "$delay" || first_i="n"
        echo "------ Cleaning job configuration for $crawler ------" |\
        tee -a "$log_file"
        curl --no-progress-meter -d "action=teardown" \
        -k -u "$username":"$password" \
        --anyauth --location -H "Accept: application/xml" \
        https://"$crawler":"$port"/engine/job/"$job" |\
        tee -a "$log_file" |\
        python3 ../xml_logs_to_csv.py '^<statusDescription>'
    } done
}

function status {
    first_i="y"
    for crawler in ${crawlers[@]}; do {
        [ "$first_i" != "y" ] && sleep "$delay" || first_i="n"
        echo "------ Status for $crawler ------" |\
        tee -a "$log_file"
        curl --no-progress-meter -k -u "$username":"$password" \
        --anyauth --location -H "Accept: application/xml" \
        https://"$crawler":"$port"/engine/job/"$job" |\
        tee -a "$log_file" |\
        python3 ../xml_logs_to_csv.py \
        '^<statusDescription>' '^<novel>' '^<total>' '^<currentKiBPerSec>' \
        '^<averageKiBPerSec>' '^<elapsedPretty>'
    } done
}

case "$1" in
    ( "ls" ) ls;;
    ( "build") build;;
    ( "launch" ) launch;;
    ( "pause" ) pause;;
    ( "unpause" | "resume" ) unpause;;
    ( "terminate" ) terminate;;
    ( "teardown" ) teardown;;
    ( "status" ) status;;
    ( * ) usage_message;;
esac