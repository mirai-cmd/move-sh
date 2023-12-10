#!/bin/env bash

#string constants
readonly info_symbol="[+]"
readonly error_symbol="[-]"
function INFO(){
    echo $info_symbol $1
}
function ERROR(){
    echo $error_symbol $1
}
function create_dir(){
    dir=$(mkdir $1)
}

if [ -z $1 -o -z $2 ]; then
    ERROR "Folder names cannot be empty!!"
    exit -1
fi

if [ ! -d $1 ]; then
    ERROR "Source directory does not exist"
    INFO "Creating source directory $1"
    create_dir $1
fi
if [ ! -d $2 ]; then
    ERROR "Destination directory does not exist"
    INFO "Creating destination directory $2"
    create_dir $2
fi
file_paths=$(find $1 -type f -exec echo "{}" \;)

INFO "Copying files from $1 to $2"
#create extension-wise directories and copy into them
for file in $file_paths; do
    filename=$(basename "$file")
    extension_folder="${filename##*.}"
    if [ ! -d "$2/$extension_folder" ]; then
        create_dir "$2/$extension_folder"
    fi
    res=$(cp $file $2/$extension_folder)
done
INFO "Reorgnisation complete"
