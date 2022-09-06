#! /bin/bash

input="$1" # Dir name
pwdHolder=$(pwd) # Current pwd
let data="512000" # 512MB
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

exitAll() {
    grep -o . <<< "$input" | while read letter;  
    do
        if [ "$letter" == "/" ]
        then 
            echo 1
            exit 0
        fi
    done
    echo 2
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
concat="${pwdHolder}/${input}"
echo "$concat"
dirCheck=0
grep -o . <<< "$input" | while read letter;  
do
    if [ "$letter" == "/" ]
    then 
        dirCheck=1
    fi
done <<<$(find tmp -type f)

echo "$dirCheck"
if [ "$dirCheck" == "1" ]
then    
    size="$(du $input | awk '{print $1}')" # split input, choose to print size of input dir
    echo "$size"
fi

if [ -d "$concat" ]
then
    if [ -w "$pwdHolder" ]
    then
        if [ "$size" -gt "$data" ]
        then 
            echo "Warning: the directory is 512 MB. Proceed? [y/n]"
            read userInput
            if [ "$userInput" == "y" | "$userInput" == "Y" ]
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