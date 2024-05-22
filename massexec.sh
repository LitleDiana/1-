#!/bin/bash

while [[ $# -gt 0 ]]; do
	case "$1" in
        	--path)
            		dirpath="$2"
            		shift 2
            		;;
        	--mask)
            		mask="$2"
            		shift 2
            		;;
        	--number)
            		number="$2"
            		shift 2
            		;;
        	*)
            		break
            		;;
    	esac
done

command="$1"

if [ -z "$dirpath" ]; then
    	dirpath=$(pwd)
fi

if [ ! -d "$dirpath" ]; then
	echo "Каталог '$dirpath' должен существоать."
    	exit 1
fi

if [ -z "$mask" ]; then
    	mask="*"
fi

if [ ${#mask} -eq 0 ]; then
    	echo "Длина строки mask должна быть больше нуля."
    	exit 1
fi

if [ -z "$number" ]; then
    	number=$(nproc)
fi

if [ -z "$command" ]; then
    	echo "Не указан исполняемый файл (скрипт)."
    	exit 1
fi

if [ ! -x "$command" ]; then
    	echo "Файл $1 не существует или не имеет права исполнения для текущего пользователя"
    	exit 1
fi

#echo $dirpath $mask $number $command

count_proc_run=0
handler() {
	local files=($dirpath/$mask)
#	echo $files
    	local all_files=${#files[@]}
#	echo $all_files
    	local ind=0
	local pids=()
	local count=0

    	while [ $ind -lt $all_files ] || [ $count_proc_run -gt 0 ]; do
#		echo "В начале итерации $count_proc_run ${pids[@]}"
		i=0
		count=${#pids[@]}
		while [ $i -lt $count ]; do
			pid="${pids[$i]}"
#			echo "$i : ${pids[$i]}"
    			if ! kill -0 "$pid" 2>/dev/null; then
#       			echo "Удаляем: $pid"
        			unset pids[$i]
        			((count_proc_run--))
				((i++))
			else
				((i++))
			fi
        	done
		pids=("${pids[@]}")
#		echo "После очистки завершения $count_proc_run ${pids[@]}"
		while [ $count_proc_run -lt $number ] && [ $ind -lt $all_files ]; do
	        	if [ -f "${files[$ind]}" ]; then
                		"$command" "${files[$ind]}" &
				pids+=($!)
				((count_proc_run++))
               			((ind++))
            		fi
        	done
#		echo "После запуска $count_proc_run ${pids[@]}"
        	wait -n
    	done
}

handler $command
