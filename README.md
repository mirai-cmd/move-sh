# Sh-move-it

Author : Prajwal Ghotage

Sh-move-it is a bash script that simplifies file organisation for Linux.

# Usage
```
./organsise.sh -s src_dir -d dst_dir [-l log_file] [-e "exclude extensions"] [-r]
```
# Requirements

These packages are required to generate the ASCII art : cowsay, figlet
Install with :
```
sudo apt install cowsay
sudo apt install figlet
```
# Options

```
| -e "extensions" |  Exclude file extensions. Enter a string of space-separated of extensions. Ex : "txt sh"|
| -l [file_name] | Generate log file with name [file_name]"
| -r | Recursively delete source directory."
| -h | Print this Help."
| -V | Print software version and exit."
```