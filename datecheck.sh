#! /bin/bash
mon=$1 # Month arg
day=$2 # Day arg
year=$3 # Year arg

let res=$(($year % 4)) # step 1 logic
if [ $res -eq 0 ]; #0: not found
then
    let res=$(($year % 100)) # step 2 logic
    if [ $res -eq 0 ]
    then
        let res=$(($year % 400)) # step 3 logic
        if [ $res -eq 0 ]
        then
            let leap=1 # leap year flag
        else
            let leap=0 # leap year flag
        fi
    else
        let leap=1 # leap year flag
    fi
else
    let leap=0 # leap year flag
fi
# Checks if the number of days matches with a correct date to the corresponding month
let monName
checkDate(){
        let maxDay=$1
        if [[ $day -lt $maxDay+1 ]]; 
        then 
            echo "EXISTS! "$monName" "$day" "$year" is someone's birthday" 
        elif [[ "$monName" == "Feb" && $leap -eq 0 ]];
        then
            echo "BAD INPUT: "$monName" does not have ${day} days: not a leap year"
        else
            echo "BAD INPUT: "$monName" does not have ${day} days"
        fi
}
# Filter input month
case ${mon^^} in 
    JAN|1|01) monName="Jan"
        checkDate 31;; # Allowed number of days for selected month
    FEB|2|02) monName="Feb" # Feb is special case if leap year
        if [ "$leap" -eq 1 ]
        then 
            checkDate 29
        else
            checkDate 28
        fi;;
    MAR|3|03) monName="Mar"
        checkDate 31;;
    APR|4|04) monName="Apr" 
        checkDate 30;;
    MAY|5|05) monName="May" 
        checkDate 31;;
    JUN|6|06) monName="Jun" 
        checkDate 30;;
    JUL|7|07) monName="Jul" 
        checkDate 31;;
    AUG|8|08) monName="Aug" 
        checkDate 31;;
    SEP|9|09) monName="Sep" 
        checkDate 30;;
    OCT|10) monName="Oct" 
        checkDate 31;;
    NOV|11) monName="Nov" 
        checkDate 30;;
    DEC|12) monName="Dec" 
        checkDate 31;;
esac
