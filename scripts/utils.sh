#!/bin/bash

OK=0
ERROR_FILE_NOT_FOUND=1
ERROR_ROOT_USER_DETECTED=2
ERROR_UNSUPPORTED_GPU_DETECTED=3
ERROR_COMMAND_FILES=4

error=false

assert_file() {
    if [[ ! -z ${1+x} ]] && [[ $1 ]] && [[ ! -f $1 ]]; then
        echo "File $1 not found."
        return $ERROR_FILE_NOT_FOUND
    fi

    return $OK
}

start_section() {
    section=$1
    print_s "**** Start: $section ****"
    shift
    for cmd in "$@"; do
        execute "$cmd"
    done

    print_s "***** End: $section *****"
}

print_s() {
    bar=$(printf '%*s' ${#1} "" | tr ' ' '*')
    echo ''
    echo "$bar"
    echo "$1"
    echo "$bar"
    echo ''
}

compare_versions() {
    printf '%s\n%s' "$1" "$2" | sort -C -V
}

execute() {
    echo "$ $1"
    eval $1 || error=true
}

download_latest() {
    repo=$1
    out=$2
    filter=$3

    execute "lastversion --assets --filter $filter download $repo --output $out"
}

download_latest_rpm() {
    repo=$1
    out=$2
    filter=$3

    execute "lastversion --assets --filter $filter download $repo --output $out && sudo rpm -i $out --force && rm $out"
}
