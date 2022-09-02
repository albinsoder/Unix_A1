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
size="$(du $input | awk '{print $1}')"
echo "$size"
if [ -d "$concat" ]
then
    if [ -w "$pwdHolder" ]
    then
        if [ "$size" -gt 512 ]
        then 
            echo "BIG BOY, wanna proceed? y/n"
            read userInput
            if [ "$userInput" == "y" ]
            then
                echo "Grattis kalle"
            else
                echo "We done here"
            fi
        else    
            echo "COMMON L"
        fi
    else 
        echo "Always L"
    fi   
else 
    echo "common L(also known as depression)"
fi
