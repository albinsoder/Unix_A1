#! /bin/bash

input="$1" # File name
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
    # Check size of archived files + input file in bytes
    sizeOG="$(stat -c%s "$input")"
    sizeGzip="$(stat -c%s "$input.gz")"
    sizeBzip="$(stat -c%s "$input.bz2")"
    sizeP7zip="$(stat -c%s "$input.7z")"
    sizeLzop="$(stat -c%s "$input.lzo")"
    # echo $sizeOG
    # echo $sizeGzip
    # echo $sizeBzip
    # echo $sizeP7zip
    # echo $sizeLzop

    # Select smallest file and remove the rest
    if [[ sizeOG -lt sizeGzip && sizeOG -lt sizeBzip && sizeOG -lt sizeP7zip && sizeOG -lt sizeLzop ]]
    then
        echo "Input file is smaller than compressed file alternatives"
        echo "Keeping input file and removing compressed files"
        rm $input.gz $input.bz2 $input.7z $input.lzo
    else
        if [[ sizeGzip -lt sizeBzip && sizeGzip -lt sizeP7zip && sizeGzip -lt sizeLzop ]]
        then
            rm $input $input.bz2 $input.7z $input.lzo
            echo "Most compression obtained with gzip. Compressed file is $input.gz"
        elif [[ sizeBzip -lt sizeGzip  && sizeBzip -lt sizeP7zip && sizeBzip -lt sizeLzop ]]
        then
            rm $input $input.gz $input.7z $input.lzo
            echo "Most compression obtained with bzip2. Compressed file is $input.bz2"
        elif [[ sizeP7zip -lt sizeGzip  && sizeP7zip -lt sizeBzip && sizeP7zip -lt sizeLzop ]]
        then
            rm $input $input.gz $input.bz2 $input.lzo
            echo "Most compression obtained with p7zip. Compressed file is $input.7z" 
        else
            rm $input $input.gz $input.bz2 $input.7z
            echo "Most compression obtained with lzop. Compressed file is $input.lzo"
        fi
    fi
}
if [ -f $concat ] # If file exists in current dir, call archivator
then
    archivator
    echo "Selection of smallest file is completed"
else
    echo "File not found in current directory"
fi
