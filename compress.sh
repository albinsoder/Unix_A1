#! /bin/bash

input="$1" # Dir name
pwdHolder=$(pwd) # Current pwd
concat="${pwdHolder}/${input}" #get the location+input

# Create archived file of entered directory/file
# gzip --> -k = keep original file
# bzip2 --> -k = keep original file
# p7zip --> -a = create new archive, -y > NUL = send all output to file NUL
# lzop --> -k = keep original file
archivator() {
    gzip -k $input & bzip2 -k $input & 7z a $input.7z $input -y > NUL & lzop -k $input
    rm NUL # Remove output file from P7zip
    sizeOG="$(stat -c%s "$input")"
    sizeGzip="$(stat -c%s "$input.gz")"
    sizeBzip="$(stat -c%s "$input.bz2")"
    sizeP7zip="$(stat -c%s "$input.7z")"
    sizeLzop="$(stat -c%s "$input.lzo")"
    echo $sizeOG
    echo $sizeGzip
    echo $sizeBzip
    echo $sizeP7zip
    echo $sizeLzop
    if [[ sizeOG -st sizeGzip && sizeOG -st sizeBzip && sizeOG -st sizeP7zip && sizeOG -st sizeLzop ]]
    then
        echo "Input file is smaller than compressed file alternatives"
        echo "Keeping input file and removing compressed files"
        rm $input.gz $input.bz2 $input.7z $input.lzo
    else
        if [ sizeGzip -st sizeBzip]
    fi
}

if [ -f $concat ]
then
    archivator
    echo "Selection of smallest file is completed"
    
else
    echo "File not found in current directory"
fi
