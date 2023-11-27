#/bin/bash

save_file="tictactoe_save.txt"

# Inicjalizacja planszy
board=(1 2 3 4 5 6 7 8 9)
current_player="X"

# Funkcja do rysowania planszy
draw_board() {
	clear
	echo " ${board[0]} | ${board[1]} | ${board[2]} "
	echo "-----------"
	echo " ${board[3]} | ${board[4]} | ${board[5]} "
	echo "-----------"
	echo " ${board[6]} | ${board[7]} | ${board[8]} "
}

# Funkcja sprawdzająca wygraną
check_win() {
	local player="$1"
	#echo "$player player "
       	#echo "${board[0]} == $player"	
	#echo "${board[1]} == $player"
	#echo "${board[2]} == $player"		
	# Sprawdź poziome i pionowe linie oraz obie przekątne
	if [[ ( "${board[0]}" = "$player" && "${board[1]}" = "$player" && "${board[2]}" = "$player" ) ||
		( "${board[3]}" = "$player" && "${board[4]}" = "$player" && "${board[5]}" = "$player" ) ||
		( "${board[6]}" = "$player" && "${board[7]}" = "$player" && "${board[8]}" = "$player" ) ||
		( "${board[0]}" = "$player" && "${board[3]}" = "$player" && "${board[6]}" = "$player" ) ||
		( "${board[1]}" = "$player" && "${board[4]}" = "$player" && "${board[7]}" = "$player" ) ||
		( "${board[2]}" = "$player" && "${board[5]}" = "$player" && "${board[8]}" = "$player" ) ||
		( "${board[0]}" = "$player" && "${board[4]}" = "$player" && "${board[8]}" = "$player" ) ||
		( "${board[2]}" = "$player" && "${board[4]}" = "$player" &&  "${board[6]}" = "$player") ]]
	then
		echo "Gracz $player wygrywa!"
		exit 0
	fi
}

# Funkcja sprawdzająca remis
check_draw() {
	for cell in "${board[@]}"; do
		if [ "$cell" != "X" ] && [ "$cell" != "O" ]; then
			return
		fi
	done
	echo "Remis!"
	exit 0
}

# Funkcja wykonująca ruch gracza
make_move() {
	local position="$1"
	if [ "${board[$position-1]}" != "X" ] && [ "${board[$position-1]}" != "O" ]; then
		board[$position-1]=$current_player
	else
		echo "To pole jest już zajęte. Wybierz inne."
	fi
}

# Funkcja zmieniająca gracza
switch_player() {
	if [ "$current_player" == "X" ]; then
		current_player="O"
	else
		current_player="X"
	fi
}

# Funkcja zapisująca stan gry
save_game() {
	echo "${board[@]}" > "$save_file"
	echo "$current_player" >> "$save_file"
}


# Funkcja wczytująca stan gry
load_game() {
	if [ -f "$save_file" ]; then
		read -a board < "$save_file"
		current_player=$(sed -n '2p' "$save_file")
	else
		echo "Nie znaleziono pliku zapisu. Rozpocznij nową grę."
		exit 1
	fi
}

ai_move() {
	while true; do
		rnd=$((1 + RANDOM % 9))
		echo "$rnd ranadom number"
		
		if [ "${board[$rnd-1]}" != "X" ] && [ "${board[$rnd-1]}" != "O" ]; then
			board[$rnd-1]=$current_player
			break
		fi
	done
}	

#Menu
echo "Wybierz tryb gry (1) - gra z graczem, (2) - gra z komputerem"
read mode
clear

# Główna pętla gry
while true; do
	draw_board

	if [[ "$mode" = "2" && "$current_player" == "O" ]]; then
		echo "Ruch komputera"
	else
		echo "Gracz $current_player, podaj numer pola (1-9), zapisz grę (s) lub wczytaj grę (l): "
		read move
	fi	

	if [ "$move" == "s" ]; then	
		save_game
		echo "Gra została zapisana."
		elif [ "$move" == "l" ]; then
		load_game
		echo "Gra została wczytana."
	elif [ "$move" -ge 1 ] && [ "$move" -le 9 ]; then

		if [[ "$mode" = "2" && "$current_player" == "O" ]]; then
			ai_move
			echo "ruch ai"
		else
			make_move "$move"
		fi 
		
		check_win "$current_player"
		check_draw
		switch_player
	else
		echo "Niepoprawny ruch. Podaj numer pola od 1 do 9, zapisz grę (s) lub wczytaj grę (l)."
	fi
done
