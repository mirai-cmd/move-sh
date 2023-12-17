#!/bin/env bash

#string constants
script_name="Sh-move.it"
readonly version="$script_name v1.0.0"
readonly info_symbol="[+]"
readonly error_symbol="[-]"

declare -A summary=([files_transferred]=0 [folders_created]=0)
declare -A files_per_folder
declare src_dir
declare dst_dir
declare excluded_extensions="-name '*.*'"
declare delete_source_dir=false
declare log_file

function show_help() {
    # Display Help
    printf "Copies files from a source directory to a destination directory and organises them based on their extensions\n"
    printf "\nUsage: ./organise.sh -s [SOURCE_DIR] -d [DST_DIR] [options]...\n"
    printf "\nOptions:\n"
    printf " -e \"extensions\"   Exclude file extensions. Enter a string of space-separated of extensions. Ex : \"txt sh\"\n"
    printf " -l [file_name]    Generate log file with name [file_name]\n"
    printf " -r%-15s Recursively delete source directory.\n"
    printf " -h%-15s Print this Help.\n"
    printf " -V%-15s Print software version and exit.\n"
}
function moo(){
    cowsay -e oO "$1"
}
function arg_err(){
    moo "Use $(basename $1) -h for help" >&2
    echo -e "\n\nNo files to munch on...."
    exit 1
}
while getopts 'Vhrs:d:e:l:' OPTION; do
    case "$OPTION" in
    s)
        src_dir="$OPTARG"
        ;;
    d)
        dst_dir="$OPTARG"
        ;;
    l)
        log_file="$OPTARG"
        log_needed=true
        ;;
    r)
        delete_source_dir=true
        ;;
    e)
        excluded_extensions="$OPTARG"
        ;;
    h)
        show_help "$0"
        exit 0
        ;;
    V)
        printf "$version"
        exit 0
        ;;
    ?)
        
        ;;
    esac
done
shift "$(($OPTIND - 1))"


if [ -z "$OPTION" ]; then
    arg_err "$0"
fi
figlet "$script_name" -k

printf "\n\n"
printf "
      ╔════════════════════════════════════════════════════════════╗
   <==|          By        : Prajwal Ghotage                       |==>
   <==|          Github    : https://github.com/mirai-cmd          |==>
      ╚════════════════════════════════════════════════════════════╝

           "
printf "\n"

function INFO() {
    echo "$info_symbol" "$1"
}
function ERROR() {
    echo "$error_symbol" "$1"
}
function create_dir() {
    dir=$(mkdir "$1")
}
function write_to_log_file(){
    printf "[ $(date) ][INFO] Copied %-60s\t--->\t%-60s\n" "$1" "$2" >>"$current_log_file"
}

if [ ! -d "$src_dir" ]; then
    ERROR "Source directory does not exist"
    INFO "Creating source directory $src_dir"
    create_dir "$src_dir"
fi
if [ ! -d "$dst_dir" ]; then
    ERROR "Destination directory does not exist"
    INFO "Creating destination directory $dst_dir"
    create_dir "$dst_dir"
fi
current_log_file="$log_file"
if [ "$log_needed" ]; then
    if [ -f "$current_log_file" ]; then
        ERROR "File $log_file already exists, generating log file as file_transfer.log in $PWD"
    fi
    current_log_file="file_transfer.log"
    $(touch "$current_log_file")
fi
extensions="$excluded_extensions"
if [ ! "$excluded_extensions" == "-name '*.*'" ]; then
    extension=(-not \()
    for ext in $excluded_extensions; do
        extension+=(-name \*."$ext" -o)
    done
    unset 'extension[-1]'
    extension+=(\))
fi

file_paths=$(find "$src_dir" -type f "${extension[@]}" -exec echo "{}" \;)

INFO "Copying files from $src_dir to $dst_dir"

#create extension-wise directories and copy into them and handle duplicates
for file_path in $file_paths; do
    filename=$(basename "$file_path")
    extension="${filename##*.}"
    destination_path="$dst_dir/$extension"
    if [ ! -d "$destination_path" ]; then
        create_dir "$destination_path"
        ((summary[folders_created]++))
    fi
    if [ -f "$destination_path/$filename" ]; then
        name="${filename%.*}"
        ((files_per_folder[$extension]++))
        res=$(cp "$file_path" "$destination_path/$name(${files_per_folder[$extension]}).$extension")
        ((summary[files_transferred]++))
        if [ "$log_needed" ]; then
            write_to_log_file "$file_path" "$destination_path"
        fi
        continue
    fi
    res=$(cp "$file_path" "$destination_path")
    ((files_per_folder[$extension]++))
    ((summary[files_transferred]++))
    if [ "$log_needed" ]; then
        write_to_log_file "$file_path" "$destination_path"
    fi
done
if [ "$delete_source_dir" == true ]; then
    INFO "Deleting files from $src_dir..."
    $(rm -rf "$src_dir")
fi
INFO "Reorgnisation complete"

if [ "$log_needed" ]; then
    INFO "Check $current_log_file for more details"
fi
echo -e "\n--------Summary--------\n"
INFO "Folders created : ${summary[folders_created]}"
INFO "Files transferred : ${summary[files_transferred]}"
INFO "Files per folder:"
echo -e "\n+----------------------------+"
printf "|%-1sFolder Name%-1s|%1sNo of files%-2s|\n"
echo "+----------------------------+"
for key in "${!files_per_folder[@]}"; do
    printf "| %-11s | %-12s |" "$key" "${files_per_folder[$key]}"
    printf "\n"
done
echo "+----------------------------+"
moo "I like to sh-move it sh-move it (pun intended)"