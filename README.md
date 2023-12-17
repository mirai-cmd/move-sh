# Sh-move-it

Author : Prajwal Ghotage

Sh-move-it is a bash script that simplifies file organisation for Linux.

# Usage
```
./organsise.sh -s src_dir -d dst_dir [-l log_file] [-e "exclude extensions"] [-r]
```
# Requirements

These packages are required to generate the ASCII art : cowsay, figlet
<br>
Install with :
```
sudo apt install cowsay
sudo apt install figlet
```
# Options

|  Option         	|  Description                                                                                	|
|-----------------	|---------------------------------------------------------------------------------------------	|
| -e "extensions" 	|  Exclude file extensions. Enter a string of space-separated extension names. Ex : "txt doc" 	|
| -l [file_name]  	|  Generate log with file name [file_name]                                                    	|
| -r              	| Recursively delete the source directory                                                     	|
| -h              	| Print help menu                                                                             	|
| -V              	| Print script version and exit                                                               	|