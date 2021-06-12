#!/usr/bin/env bash

# Print pretty color output
#  $1: The message to be printed with the color level
#  $2: The message level
#    s = success | w = warning | e = error | i = information | l = log
function printc(){
	CLEAR_COLOR="\033[0m"
	l=$2
	msg=$1
	if [ "$l" = "s" ];then # success
		PRIMARY_COLOR="\033[36;01m"
	fi
	if [ "$l" = "w" ];then # warning
		PRIMARY_COLOR="\033[33;01m"
	fi
	if [ "$l" = "e" ];then # error
		PRIMARY_COLOR="\033[31;01m"
	fi
	if [ "$l" = "i" ];then # info
		PRIMARY_COLOR="\033[34;01m"
	fi
	if [ "$l" = "l" ];then # log
		PRIMARY_COLOR="\033[0;01m"
	fi
	if [ "$l" = "d" ];then # default log
		PRIMARY_COLOR="\033[0m"
	fi

	printf "$PRIMARY_COLOR$msg$CLEAR_COLOR"
}

function check_execution(){
	if [ ! "$?" -eq "0" ];then
		printc "Execution error!\n" "e"
		if [ "$1" = "exit" ];then
			printc "Exiting ...\n" "l"
			exit 1
		fi
	else
		printc " ... OK\n" "l"
	fi

}

if [ ! "$(id -u)" -eq "0" ];then
	printc "\nError: Root user is required!\n\n" "e"
	exit 1
fi

#printc "Sucesso\n" "s"
#printc "Aviso\n" "w"
#printc "Erro\n" "e"
#printc "Informação\n" "i"
#printc "Log\n" "l"

# Get OS info
# os_info=$(cat /etc/[A-Za-z]*[-][rv]e[lr]*)

printc "\nStarting system configuration...\n" "i"
printc "Checking system base\n" "l"

if [ "ubuntu" = "ubuntu" ]; then
	printc "Current system use debian as base\n" "i"
	printc "  Checking package maneger (apt-get)" "l"
	apt-get -v > /dev/null
	check_execution "exit"
	printc "  Updating the system\n" "i"
	#sudo apt update && sudo apt upgrade -y
	printc "  Installing major programs ( build-essential | net-tools | vim | git | gcc | make | cmake | curl | wget )\n" "i"
	sudo apt-get install build-essential net-tools vim git gcc make cmake curl wget -y
	printc "  Checking instalation" "l"
	check_execution "exit"

	printc "  Installing other programs ( htop | jq | clang | ksnip | psensor | vlc | gimp | peek )\n" "i"
	sudo apt-get install htop jq clang ksnip psensor vlc gimp peek -y
	printc "  Checking instalation" "l"
	check_execution "exit"

	printc "  Installing system themes\n" "i"
	printc "    gruvbox-material-gtk\n" "i"
 	git clone https://github.com/sainnhe/gruvbox-material-gtk /tmp/gruvbox-material-gtk
	cp /tmp/tmp/gruvbox-material-gtk/themes/* /usr/share/themes
	cp /tmp/tmp/gruvbox-material-gtk/icons/* /usr/share/icons
	printc "    Nordic\n" "i"
	git clone https://github.com/EliverLara/Nordic /tmp/Nordic
	cp /tmp/tmp/Nordic/ /usr/share/themes
	printc "    arc-theme\n" "i"
# sudo apt-get install arc-theme

	printc "  Installing terminal themes\n" "i"
	printc "    gruvbox\n" "i"
# clone the repo into "$HOME/src/gogh"
#mkdir -p "$HOME/src"
#cd "$HOME/src"
#git clone https://github.com/Mayccoll/Gogh.git gogh
#cd gogh/themes

# necessary on ubuntu
#export TERMINAL=gnome-terminal

# install themes
#./gruvbox-dark.sh


fi

