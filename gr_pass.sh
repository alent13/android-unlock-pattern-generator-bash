#!/bin/bash

declare -A available=( [00]=1 [01]=2 [02]=3 [10]=4 [11]=5 [12]=6 [20]=7 [21]=8 [22]=9 )
declare -A pass

code=""

keyByNumber () {
	if [[ $next < 4 ]]; then
		calc=$(($next-1))
		code="0$calc"
		curr_x=0
		curr_y=$calc
		elif [[ $next < 7 ]]; then
			calc=$(($next-4))
			code="1$calc"
			curr_x=1
			curr_y=$calc
		else
			calc=$(($next-7))
			code="2$calc"
			curr_x=2
			curr_y=$calc
	fi
}

calculateAvailable () {
	for (( i = -1; i <= 1; i++ )); do
		for (( j = -1; j <= 1; j++ )); do
			local c_x=$(($curr_x - $i))
			local c_y=$(($curr_y - $j))
			if ([ $c_x -ge 0 ] && [ $c_x -le 2 ] && [ $c_y -ge 0 ] && [ $c_y -le 2 ]); then
				n=$(($c_y + 1 + $c_x * 3))
				available["$c_x$c_y"]=$n
			fi
		done
	done
	for key in "${!pass[@]}"; do
		next=${pass[$key]}
		keyByNumber
		unset available[$code]
	done
}

#start
length="$1"

curr_x=$(($RANDOM % 2))
curr_y=$(($RANDOM % 2))

pass[0]="${available[$curr_x$curr_y]}"

unset available
declare -A available

calculateAvailable

for (( d = 1; d < $length; d++ )); do
	next=$(($RANDOM % ${#available[*]}))
	keys=(${!available[@]})
	pass[${#pass[@]}]=${available[${keys[$next]}]}
	calculateAvailable
done

res_pass=""
for (( i = 0; i < ${#pass[@]}; i++ )); do
	res_pass="$res_pass${pass[$i]}"
done

echo $res_pass