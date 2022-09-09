#! /bin/bash

input="$1" # Dir name
pwdHolder=$(pwd) # Current pwd
let data="512000" # 512MB
concat="${pwdHolder}/${input}"
# echo $pwdHolder

# Create archive file of input directory
#c - Create
#x - Extract
#t - List contents
#v - Output dir contents
#f - Use archive file
#z - Filter the archive through gzip
archivator() {
    tar -cf "$input.tgz" "$input" #c=create, f=Using archive file, gzip used for compressing
    echo "Directory $input archived as $input.tgz"
}

# Perform archiving of selected dir
checkDir() {
    size="$(du $input | awk '{print $1}')" # split input, choose to print size of input dir

    if [ -d "$concat" ]
    then
        if [ -w "$pwdHolder" ]
        then
            if [ "$size" -gt "$data" ]
            then 
                echo "Warning: the directory is 512 MB. Proceed? [y/n]"
                read userInput
                if [ "$userInput" == "y" ]
                then
                    archivator # archivate the dir
                else
                    echo "You have selected to not create an archive file"
                fi
            else    
                archivator # archivate the dir
            fi
        else 
            echo "No writing permission in parent dir"
        fi   
    else
        echo "Cannot find directory $input"
    fi
}

# Basic checks for the input arg provided by user
if [ "$#" -gt 1 ];
then
    echo 'ERROR! Only one argument allowed'
    exit 1
elif [ "$#" -eq 0 ];
then
    echo 'No arguments given! Give a directory as input'
    exit 1

fi

arr=(${input//"/"/ })
lenInput=`expr "$input" : '.*'` #Get the length of input string to determine iterations
lenArr=`expr "$arr" : '.*'` #Get the length of input string to determine iterations

if [ $lenArr -lt $lenInput ] 
then
    echo "You must specify a subdirectory"
else 
    checkDir
fi
