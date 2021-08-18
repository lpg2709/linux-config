#!/usr/bin/env bash

# Print pretty color output
#  $1: The message to be printed with the color level
#  $2: The message level
#	s = success | w = warning | e = error | i = information | l = log
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
	sudo apt-get install build-essential net-tools vim git gcc make cmake curl wget jq -y
	printc "  Checking instalation" "l"
	check_execution "exit"

	printc "  Installing other programs ( htop | jq | clang | ksnip | psensor | vlc | gimp | peek | vim-gtk )\n" "i"
	sudo apt-get install htop jq clang ksnip psensor vlc gimp peek vim-gtk -y
	printc "  Checking instalation" "l"
	check_execution "exit"

	printc "  Installing NodeJS with NVM\n" "i"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
	source ~/.bashrc
	nvm install node
	printc "  Checking instalation" "l"
	check_execution "exit"

	printc "  Installing system themes\n" "i"
	printc "	arc-theme\n" "i"
	sudo apt-get install arc-theme

	printc "	Papirus Icon Theme\n" "i"
	printc "	  Cloning to /tmp/papirus-icon-theme\n" "i"
	git clone https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git /tmp/papirus-icon-theme
	printc "	  Copy file\n" "i"
	sudo cp -rf /tmp/papirus-icon-theme/Papirus /usr/share/icons
	sudo cp -rf /tmp/papirus-icon-theme/Papirus-Dark /usr/share/icons
	printc "	  Removing /tmp/papirus-icon-theme\n" "i"
	sudo rm -rf /tmp/papirus-icon-theme/
	printc "	  Updating gtk icons\n" "i"
	sudo gtk-update-icon-cache /usr/share/icons/Papirus
	sudo gtk-update-icon-cache /usr/share/icons/Papirus-Dark

	printc "	gruvbox-material-gtk\n" "i"
	printc "	  Cloning to /tmp/gruvbox-material-gtk\n" "i"
 	git clone https://github.com/sainnhe/gruvbox-material-gtk /tmp/gruvbox-material-gtk
	printc "	  Copy file\n" "i"
	sudo cp -rf /tmp/gruvbox-material-gtk/themes/* /usr/share/themes
	sudo cp -rf /tmp/gruvbox-material-gtk/icons/* /usr/share/icons
	printc "	  Removing /tmp/gruvbox-material-gtk\n" "i"
	sudo rm -rf /tmp/gruvbox-material-gtk/icons/
	printc "	  Updating gtk icons\n" "i"
	sudo gtk-update-icon-cache /usr/share/icons/Gruvbox-Material-Dark/

	printc "	Nordic\n" "i"
	printc "	  Cloning to /tmp/Nordic\n" "i"
	sudo git clone https://github.com/EliverLara/Nordic /tmp/Nordic
	printc "	  Copy file\n" "i"
	sudo cp -rf /tmp/Nordic/ /usr/share/themes
	printc "	  Removing /tmp/Nordic\n" "i"
	sudo rm -rf /tmp/Nordic/

	printc "	Juno\n" "i"
	printc "	  Cloning to /tmp/Juno\n" "i"
	git clone https://github.com/EliverLara/Juno /tmp/Juno
	printc "	  Copy file\n" "i"
	sudo cp -rf /tmp/Juno/ /usr/share/themes
	printc "	  Removing /tmp/Juno\n" "i"
	sudo rm -rf /tmp/Juno/

	printc "	Yaru-Colors\n" "i"
	printc "	  Cloning to /tmp/Yaru\n" "i"
	git clone https://github.com/Jannomag/Yaru-Colors.git /tmp/Yaru
	printc "	  Copy file\n" "i"
	sudo cp -rf /tmp/Yaru/Themes/Yaru-Blue-dark /usr/share/themes
	sudo cp -rf /tmp/Yaru/Themes/Yaru-MATE-dark /usr/share/themes
	sudo cp -rf /tmp/Yaru/Themes/Yaru-Teal-dark /usr/share/themes
	sudo cp -rf /tmp/Yaru/Icons/Yaru-Blue /usr/share/icons
	sudo cp -rf /tmp/Yaru/Icons/Yaru-MATE /usr/share/icons
	sudo cp -rf /tmp/Yaru/Icons/Yaru-Teal /usr/share/icons
	printc "	  Removing /tmp/Yaru\n" "i"
	sudo rm -rf /tmp/Yaru/
	printc "	  Updating gtk icons\n" "i"
	sudo gtk-update-icon-cache /usr/share/icons/Yaru-Blue
	sudo gtk-update-icon-cache /usr/share/icons/Yaru-MATE
	sudo gtk-update-icon-cache /usr/share/icons/Yaru-Teal


	printc "	Flatery Icons\n" "i"
	printc "	  Cloning to /tmp/Flatery\n" "i"
	git clone https://github.com/cbrnix/Flatery.git /tmp/Flatery
	printc "	  Copy file\n" "i"
	sudo cp -rf /tmp/Flatery/Flatery-Blue-Dark /usr/share/icons
	sudo cp -rf /tmp/Flatery/Flatery-Green-Dark /usr/share/icons
	sudo cp -rf /tmp/Flatery/Flatery-Mint-Dark /usr/share/icons
	sudo cp -rf /tmp/Flatery/Flatery-Teal-Dark /usr/share/icons
	printc "	  Removing /tmp/Flatery\n" "i"
	sudo rm -rf /tmp/Flatery/
	printc "	  Updating gtk icons\n" "i"
	sudo gtk-update-icon-cache /usr/share/icons/Flatery-Blue-Dark
	sudo gtk-update-icon-cache /usr/share/icons/Flatery-Mint-Dark
	sudo gtk-update-icon-cache /usr/share/icons/Flatery-Teal-Dark
	sudo gtk-update-icon-cache /usr/share/icons/Flatery-Green-Dark

	sudo apt autoremove -y
# printc "  Installing terminal themes\n" "i"
# printc "	gruvbox\n" "i"
# clone the repo into "$HOME/src/gogh"
# mkdir -p "$HOME/src"
# cd "$HOME/src"
# git clone https://github.com/Mayccoll/Gogh.git gogh
# cd gogh/themes

# necessary on ubuntu
# export TERMINAL=gnome-terminal

# install themes
#./gruvbox-dark.sh


fi

