#! /bin/bash

input="$1" # Input arg: XXXXYY -> Ex 4096KB
let KB=1024 # Variable used in the unit switching calculations
#test
convertUnit() {
    unit="$1" # Which unit B/KB etc
    let arr="$2" # Data unit to be converted
    # Cases based on the prefix unit entered
    case $unit in
        B)
            let convert=${arr[0]}
            echo "Bytes = ${arr[0]}" # Entered unit will not need to be converted
            echo -n "Kilobytes = " ; bc -l <<<  "scale=4; $convert/$KB" # Calculations is carried out by bc with 4 decimals of accuracy
            echo -n "Megabytes = " ; bc -l <<<  "scale=4; $convert/$KB/$KB"
            echo -n "Gigabytes = " ; bc -l <<<  "scale=4; $convert/$KB/$KB/$KB"
        ;;
        KB)
            let convert=${arr[0]}
            echo -n "Bytes = " ; bc -l <<< "scale=4; $convert*$KB"
            echo "Kilobytes = ${arr[0]}"
            echo -n "Megabytes = " ; bc -l <<< "scale=4; $convert/$KB"
            echo -n "Gigabytes = " ; bc -l <<< "scale=4; $convert/$KB/$KB"
        ;;
        MB)
            let convert=${arr[0]}
            echo -n "Bytes = " ; bc -l <<<  "scale=4; $convert*$KB*$KB"
            echo -n "Kilobytes = " ; bc -l <<<  "scale=4; $convert*$KB"
            echo "Megabytes = ${arr[0]}"
            echo -n "Gigabytes = " ; bc -l <<<  "scale=4; $convert/$KB"
        ;;
        GB)
            let convert=${arr[0]}
            echo -n "Bytes = " ; bc -l <<<  "scale=4; $convert*$KB*$KB*$KB"
            echo -n "Kilobytes = " ; bc -l <<<  "scale=4; $convert*$KB*$KB"
            echo -n "Megabytes = " ; bc -l <<<  "scale=4; $convert*$KB"
            echo "Gigabytes = ${arr[0]}"
        ;;
    esac
}
# While loop checking the input and splitting 
# when finding any of the letters indicating unit
grep -o . <<< "$input" | while read letter;  
do
    if [ "$letter" == "B" ] 
    then
        arr=(${input//"B"/ })
        unit="B"
        convertUnit "$unit" arr
        break
    elif [ "$letter" == "K" ]
    then
        arr=(${input//"KB"/ })
        unit="KB"
        convertUnit "$unit" arr
        break
    elif [ "$letter" == "M" ]
    then
        arr=(${input//"MB"/ })
        unit="MB"
        convertUnit "$unit" arr
        break
    elif [ "$letter" == "G" ]
    then
        arr=(${input//"GB"/ })
        unit="GB"
        convertUnit "$unit" arr
        break
    fi

done
