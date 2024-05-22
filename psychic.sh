#!/bin/bash

RED='\e[31m'
GREEN='\e[32m'
RESET='\e[0m'

count=0
count_correct=0
declare -a numbers

while true;
do
    ((count++))
    random_number=$((RANDOM % 10))

    echo -e "Step: $count"
    read -p "Please enter a number from 0 to 9 (q - quit): " user_input

    case "${user_input}" in
        [0-9])
#            echo "Valid input"
#            echo "Input processing started..."
            user_number=$user_input

            if [[ $user_number == $random_number ]]
		then
                	((count_correct++))
                	echo "Hit! My number: $random_number"
			number_string="${GREEN}${random_number}${RESET}"
            	else
                	echo "Miss! My number: $random_number"
			number_string="${RED}${random_number}${RESET}" 
            fi

            numbers+=(${number_string})
	    ;;
        q)
            echo "Bye"
            echo "Exit..."
            break
        ;;
        *)
            echo "Not valid input"
            echo "Please repeat"
        ;;
    esac

    correct_percent=$((count_correct*100/count))
    incorrect_percent=$((100-correct_percent))

    echo -e "Hit: ${GREEN}${correct_percent}%${RESET} Miss: ${RED}${incorrect_percent}%${RESET}"
    
    if [ ${#numbers[@]} -gt 10 ]; then
        echo -e "Numbers: ${numbers[@]: -10}"
    else
        echo -e "Numbers: ${numbers[@]}"
    fi


done
