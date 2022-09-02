#! /bin/bash

input="$1"
pwdHolder=$(pwd)
echo $pwdHolder

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
if [ -d "$concat" ]
then
    if [ -w "$pwdHolder" ] && W="Write = yes" || W="Write = No"
    then
        echo "common W"
    fi   
else 
    echo "common L"
fi
