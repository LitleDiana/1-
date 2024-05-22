#!/bin/bash

moves=0
declare -A board

generate_data() {
	numbers=( $(shuf -i 1-16) )
	ind=0
    	for ((i=0; i<4; i++)); do
        	for ((j=0; j<4; j++)); do
            		board[$i,$j]=${numbers[$ind]}
            		((ind++))
#			echo ${board[$i,$j]}
        	done
    	done
}

display_board(){
	echo "Ход № $moves"
	echo
	echo "+-------------------+"
	for ((i=0; i<4; i++)); do
	        echo -n "|"
		for ((j=0; j<4; j++)); do
        	    #echo -n "${board[$i,$j]} "
			if [ "${board[$i,$j]}" -eq 16 ]; then
                               echo -n "    |"
			else
                               printf " %2d |" "${board[$i,$j]}"
                      	fi

        	done
        	echo
		if [ "$i" != 3 ]; then
			echo "|-------------------|"
		else
			echo "+-------------------+"
		fi
	echo
    	done
}

is_win(){
	cond_win="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 ."
	now=""
    	for ((i=0; i<4; i++)); do
        	for ((j=0; j<4; j++)); do
            		now+="${board[$i,$j]} "
        	done
    	done
	now+="."
#	echo $now
#	echo $cond_win
#	echo "Результат сравнения: $( [[ "$now" == "$cond_win" ]] && echo "Строка 'now' равна строке 'cond_win'" || echo "Строка 'now' не равна строке 'cond_win'")"
    	if [[ "$now" == "$cond_win" ]]; then
        	echo "Вы собрали головоломку за $moves ходов."
		exit 0
    	fi
}

move(){
	local empty_col
	local empty_row
	local select_num
	local select_col
	local select_row
	while true; do
        	read -p "Ваш ход (q - выход): " select_num
		if [ "$select_num" == "q" ]; then
			echo "Выход."
			exit 0
		fi
		if ! [[ "$select_num" =~ ^[1-9]$|^1[0-5]$ ]]; then
    			echo "Некорректный ввод. Введите число от 1 до 15 или 'q' для выхода."
    			continue
		fi

		for ((i=0; i<4; i++)); do
            		for ((j=0; j<4; j++)); do
                		if [ "${board[$i,$j]}" -eq "$select_num" ]; then
                    			select_row=$i
                    			select_col=$j
                		fi
			done
		done

#		echo $select_row $select_col
		for ((i=0; i<4; i++)); do
            		for ((j=0; j<4; j++)); do
                		if [ "${board[$i,$j]}" -eq 16 ]; then
                    			empty_row=$i
                    			empty_col=$j
                		fi
            		done
        	done
#           	echo $empty_row $empty_col
		if [ \
			\( "$select_row" -eq "$empty_row" -a \
			\( "$select_col" -eq "$((empty_col-1))" -o "$select_col" -eq "$((empty_col+1))" \) \) \
			-o \
             		\( "$select_col" -eq "$empty_col" -a \
			\( "$select_row" -eq "$((empty_row-1))" -o \ "$select_row" -eq "$((empty_row+1))" \) \) ]; then
			board[$empty_row,$empty_col]=${board[$select_row,$select_col]}
            		board[$select_row,$select_col]=16
            		break
        	else
            		echo "Неверный ход!"
			echo "Невозможно костяшку $select_num передвинуть на пустую ячейку."
			possible_moves=()
			if [ "$empty_row" -gt 0 ]; then
    				possible_moves+=(${board[$((empty_row-1)),$empty_col]})
			fi
			if [ "$empty_row" -lt 3 ]; then
    				possible_moves+=(${board[$((empty_row+1)),$empty_col]})
			fi
			if [ "$empty_col" -gt 0 ]; then
    				possible_moves+=(${board[$empty_row,$((empty_col-1))]})
			fi
			if [ "$empty_col" -lt 3 ]; then
    				possible_moves+=(${board[$empty_row,$((empty_col+1))]})
			fi
			str_pos_move=$(printf '%s, ' "${possible_moves[@]}")
			echo "Можно выбрать: ${str_pos_move%, }"
		fi
	done
}

all_game(){
	generate_data
	while true; do
		((moves++))
		display_board
		move
		is_win
	done
}

all_game

