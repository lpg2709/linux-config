#!/usr/bin/env bash

#printc "Sucesso\n" "s"
#printc "Aviso\n" "w"
#printc "Erro\n" "e"
#printc "Informação\n" "i"
#printc "Log\n" "l"
#Get OS info
#os_info=$(cat /etc/[A-Za-z]*[-][rv]e[lr]*)

# --- Constants configuration ---
ICONS_FOLDER="/usr/share/icons"
THEMES_FOLDER="/usr/share/themes"

TMP_PAPIRUS="/tmp/papirus-icon-theme"
TMP_GRUVBOX="/tmp/gruvbox-material-gtke"
TMP_NORDIC="/tmp/Nordic"
TMP_JUNO="/tmp/Juno"
TMP_YARU="/tmp/Yaru"

PAPIRUS_ICONS_FOLDERS=("Papirus" "Papirus-Dark")

REQUIRED_APPS=("net-tools" "vim" "git" "gcc" "make" "cmake" "python3" "curl" "htop" "tmux")
OTHER_APPS=("jq" "clang" "ksnip" "psensor" "vlc" "gimp" "peek")

# --- Configurations options variables ---
OS_DEBIAN=0
OS_ARCH=0
DOT_FILES=0
MY_SCRIPTS=0
UPDATE_UPGRADE=0
REQUIRED=0
OTHER=0
THEMES_ALL=0
ICONS_ALL=0
THEME_ARC=0
THEME_GRUVBOX=0
THEME_NORDIC=0
THEME_JUNU=0
THEME_YARU=0
ICONS_PAPIRUS=0
ICONS_GRUVBOX=0
ICONS_YARU=0
ICONS_FLATERY=0

# --- FUNCTIONS ---
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


read -r -d "" USAGE <<- EOM
Usage: sudo ./install.sh [OPTIONS]

OPTIONS:
  -h,  --help            This help screen.
  -u,  --update-upgarde  Update and upgrade the system.
  -d,  --debian          Configuration for Debian based linux.
  -a,  --arch            Configuration for Arch based linux.
  -r,  --required        Install the required programs.
  -o,  --other           Install the other programs.
  -df, --dot-files       Install my dot-files configurations.
  -ms, --my-scripts      Install my scripts.
       --all             Install all configuration.
       --theme-all       Install all themes.
       --icons-all       Install all icons.
       --theme-arc       Install arc-theme.
       --theme-gruvbox   Install Gruvbox meterial theme.
       --theme-nordic    Install Nordic theme.
       --theme-junu      Install Juno theme.
       --theme-yaru      Install Yaru Colors  theme.
       --icons-papirus   Install Papirus Icons.
       --icons-gruvbox   Install Papirus Icons.
       --icons-yaru      Install Papirus Icons.
       --icons-flatery   Install Flatery Icons.
EOM


while (( "$#" )); do
	if [[ "$1" == "--help" || "$1" == "-h" ]]; then
		echo "$USAGE"
		exit 0
	fi
	if [[ "$1" == "--update-upgrade" || "$1" == "-u" ]]; then
		UPDATE_UPGRADE=1
	fi
	if [[ "$1" == "--debian" || "$1" == "-d" ]]; then
		OS_DEBIAN=1
	fi
	if [[ "$1" == "--arch" || "$1" == "-a" ]]; then
		OS_ARCH=1
	fi
	if [[ "$1" == "--required" || "$1" == "-r" ]]; then
		REQUIRED=1
	fi
	if [[ "$1" == "--other" || "$1" == "-o" ]]; then
		OTHER=1
	fi
	if [[ "$1" == "--dot-files" || "$1" == "-df" ]]; then
		DOT_FILES=1
	fi
	if [[ "$1" == "--my-scripts" || "$1" == "-ms" ]]; then
		MY_SCRIPTS=1
	fi
	if [[ "$1" == "--all" ]]; then
		REQUIRED=1
		OTHER=1
		THEMES_ALL=1
		ICONS_ALL=1
	fi
	if [[ "$1" == "--theme-all" ]]; then
		THEMES_ALL=1
	fi
	if [[ "$1" == "--icons-all" ]]; then
		ICONS_ALL=1
	fi
	if [[ "$1" == "--theme-arc" ]]; then
		THEME_ARC=1
	fi
	if [[ "$1" == "--theme-gruvbox" ]]; then
		THEME_GRUVBOX=1
	fi
	if [[ "$1" == "--theme-nordic" ]]; then
		THEME_NORDIC=1
	fi
	if [[ "$1" == "--theme-juno" ]]; then
		THEME_JUNU=1
	fi
	if [[ "$1" == "--theme-yaru" ]]; then
		THEME_YARU=1
	fi
	if [[ "$1" == "--icons-papirus" ]]; then
		ICONS_PAPIRUS=1
	fi
	if [[ "$1" == "--icons-gruvbox" ]]; then
		ICONS_GRUVBOX=1
	fi
	if [[ "$1" == "--icons-yaru" ]]; then
		ICONS_YARU=1
	fi
	if [[ "$1" == "--icons-flatery" ]]; then
		ICONS_FLATERY=1
	fi

	shift
done

# Check if is root user
if [[ ! "$(id -u)" -eq "0" ]];then
	printc "\nError: Root user is required!\n\n" "e"
	exit 1
fi

if [[ THEMES_ALL -eq 1 ]]; then
	THEME_ARC=1
	THEME_GRUVBOX=1
	THEME_NORDIC=1
	THEME_JUNU=1
	THEME_YARU=1
fi

if [[ ICONS_ALL -eq 1 ]]; then
	ICONS_PAPIRUS=1
	ICONS_GRUVBOX=1
	ICONS_YARU=1
	ICONS_FLATERY=1
fi

function install_themes(){
	if [[ $THEME_ARC -eq 1 || $THEME_GRUVBOX -eq 1 || $THEME_NORDIC -eq 1 || $THEME_JUNU -eq 1 || $THEME_YARU -eq 1 ]];then
		printc "  Installing system themes\n" "i"
	fi

	if [[ $THEME_ARC -eq 1 ]]; then
		printc "	arc-theme\n" "i"
		sudo apt-get install arc-theme
	fi

	if [[ $ICONS_PAPIRUS -eq 1 ]]; then
		printc "	Papirus Icon Theme\n" "i"
		printc "	  Cloning to $TMP_PAPIRUS\n" "i"
		git clone https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git $TMP_PAPIRUS
		printc "	  Copy file\n" "i"
		sudo cp -rf $TMP_PAPIRUS/Papirus $ICONS_FOLDER
		sudo cp -rf $TMP_PAPIRUS/Papirus-Dark $ICONS_FOLDER
		printc "	  Removing $TMP_PAPIRUS\n" "i"
		sudo rm -rf $TMP_PAPIRUS
		printc "	  Updating gtk icons\n" "i"
		sudo gtk-update-icon-cache $ICONS_FOLDER/Papirus
		sudo gtk-update-icon-cache $ICONS_FOLDER/Papirus-Dark
	fi

	if [[ $THEME_GRUVBOX -eq 1  || $ICONS_GRUVBOX -eq 1 ]]; then
		printc "	gruvbox-material-gtk\n" "i"
		printc "	  Cloning to $TMP_GRUVBOX\n" "i"
		git clone https://github.com/sainnhe/gruvbox-material-gtk $TMP_GRUVBOX
		if [[ $THEME_GRUVBOX -eq 1 ]]; then
			printc "	  Copy theme file\n" "i"
			sudo cp -rf $TMP_GRUVBOX/themes/* $THEMES_FOLDER
		fi
		if [[ $ICONS_GRUVBOX -eq 1 ]]; then
			GRUVBOX_ICONS_FOLDERS=("/themes/*")
			printc "	  Copy icons file\n" "i"
			sudo cp -rf $TMP_GRUVBOX/icons/* $ICONS_FOLDER
			printc "	  Updating gtk icons\n" "i"
			sudo gtk-update-icon-cache $ICONS_FOLDER/Gruvbox-Material-Dark/
		fi
		printc "	  Removing $TMP_GRUVBOX\n" "i"
		sudo rm -rf $TMP_GRUVBOX
	fi

	if [[ $THEME_NORDIC -eq 1 ]]; then
		printc "	Nordic\n" "i"
		printc "	  Cloning to $TMP_NORDIC\n" "i"
		sudo git clone https://github.com/EliverLara/Nordic $TMP_NORDIC
		printc "	  Copy file\n" "i"
		sudo cp -rf $TMP_NORDIC $THEMES_FOLDER
		printc "	  Removing /tmp/Nordic\n" "i"
		sudo rm -rf $TMP_NORDIC
	fi

	if [[ $THEME_JUNU -eq 1 ]]; then
		printc "	Juno\n" "i"
		printc "	  Cloning to $TMP_JUNO\n" "i"
		git clone https://github.com/EliverLara/Juno $TMP_JUNO
		printc "	  Copy file\n" "i"
		sudo cp -rf $TMP_JUNO/ $THEMES_FOLDER
		printc "	  Removing $TMP_JUNO\n" "i"
		sudo rm -rf $TMP_JUNO/
	fi

	if [[ $THEME_YARU -eq 1  || $ICONS_YARU -eq 1 ]]; then
		printc "	Yaru-Colors\n" "i"
		printc "	  Cloning to $TMP_YARU\n" "i"
		git clone https://github.com/Jannomag/Yaru-Colors.git $TMP_YARU
		if [[ $THEME_YARU -eq 1 ]]; then
			printc "	  Copy theme file\n" "i"
			sudo cp -rf $TMP_YARU/Themes/Yaru-Blue-dark $THEMES_FOLDER
			sudo cp -rf $TMP_YARU/Themes/Yaru-MATE-dark $THEMES_FOLDER
			sudo cp -rf $TMP_YARU/Themes/Yaru-Teal-dark $THEMES_FOLDER
		fi

		if [[ $ICONS_YARU -eq 1 ]]; then
			printc "	  Copy icons file\n" "i"
			sudo cp -rf $TMP_YARU/Icons/Yaru-Blue $ICONS_FOLDER
			sudo cp -rf $TMP_YARU/Icons/Yaru-MATE $ICONS_FOLDER
			sudo cp -rf $TMP_YARU/Icons/Yaru-Teal $ICONS_FOLDER
			printc "	  Updating gtk icons\n" "i"
			sudo gtk-update-icon-cache $ICONS_FOLDER/Yaru-Blue
			sudo gtk-update-icon-cache $ICONS_FOLDER/Yaru-MATE
			sudo gtk-update-icon-cache $ICONS_FOLDER/Yaru-Teal
		fi

		printc "	  Removing $TMP_YARU\n" "i"
		sudo rm -rf $TMP_YARU/
	fi

	if [[ $ICONS_FLATERY -eq 1 ]]; then
		TMP_FLATERY="/tmp/Flatery"
		printc "	Flatery Icons\n" "i"
		printc "	  Cloning to $TMP_FLATERY\n" "i"
		git clone https://github.com/cbrnix/Flatery.git $TMP_FLATERY
		printc "	  Copy file\n" "i"
		sudo cp -rf $TMP_FLATERY/Flatery-Blue-Dark $ICONS_FOLDER
		sudo cp -rf $TMP_FLATERY/Flatery-Green-Dark $ICONS_FOLDER
		sudo cp -rf $TMP_FLATERY/Flatery-Mint-Dark $ICONS_FOLDER
		sudo cp -rf $TMP_FLATERY/Flatery-Teal-Dark $ICONS_FOLDER
		printc "	  Removing $TMP_FLATERY\n" "i"
		sudo rm -rf $TMP_FLATERY/
		printc "	  Updating gtk icons\n" "i"
		sudo gtk-update-icon-cache $ICONS_FOLDER/Flatery-Blue-Dark
		sudo gtk-update-icon-cache $ICONS_FOLDER/Flatery-Mint-Dark
		sudo gtk-update-icon-cache $ICONS_FOLDER/Flatery-Teal-Dark
		sudo gtk-update-icon-cache $ICONS_FOLDER/Flatery-Green-Dark
	fi
}

if [[ $OS_DEBIAN -eq 1 ]]; then
	printc "\nStarting system configuration...\n" "i"
	printc "Current system use DEBIAN as base\n" "i"
	printc "  Checking package maneger (apt-get)" "l"
	apt-get -v > /dev/null
	check_execution "exit"
	if [[ $UPDATE_UPGRADE -eq 1 ]]; then
		printc "  Updating the system\n" "i"
		sudo apt update && sudo apt upgrade -y
	fi
	if [[ $REQUIRED -eq 1 ]]; then
		printc "  Installing major programs ( ${REQUIRED_APPS[*]} )\n" "i"
		sudo apt-get install build-essential ${REQUIRED_APPS[@]} -y
		printc "  Checking instalation" "l"
		check_execution "exit"
	fi

	if [[ $OTHER -eq 1 ]]; then
		printc "  Installing other programs ( ${OTHER_APPS[*]} )\n" "i"
		sudo apt-get install ${OTHER_APPS[@]} y
		printc "  Checking instalation" "l"
		check_execution "exit"

		# Instal node
		#printc "  Installing NodeJS with NVM\n" "i"
		#curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
		#source ~/.bashrc
		#nvm install node
		#printc "  Checking instalation" "l"
		#check_execution "exit"
	fi

	install_themes

	sudo apt autoremove -y

	printc "\n  Instalation finished" "s"

elif [[ $OS_ARCH -eq 1 ]]; then
	printc "\nStarting system configuration...\n" "i"
	printc "Current system use ARCH as base\n" "i"
	printc "  Checking package maneger (pacman)" "l"
	pacman -V > /dev/null
	check_execution "exit"
	if [[ $UPDATE_UPGRADE -eq 1 ]]; then
		printc "  Updating the system\n" "i"
		sudo pacman -Syu --noconfirm
	fi
	if [[ $REQUIRED -eq 1 ]]; then
		printc "  Installing major programs ( ${REQUIRED_APPS[*]} )\n" "i"
		sudo pacman -S base-devel ${REQUIRED_APPS[@]} --noconfirm
		printc "  Checking instalation" "l"
		check_execution "exit"
	fi

	if [[ $OTHER -eq 1 ]]; then
		printc "  Installing other programs ( ${OTHER_APPS[*]} )\n" "i"
		sudo pacman -S ${OTHER_APPS[@]} --noconfirm
		printc "  Checking instalation" "l"
		check_execution "exit"
	fi

	install_themes

	printc "\n  Instalation finished" "s"

else
	printc "\n  Base distro not informed! Use -h or --help to see the options.\n\n" "i"
fi

if [[ $MY_SCRIPTS -eq 1 ]]; then
	printc "\Installing My scripts...\n" "i"
	curl -o- https://raw.githubusercontent.com/lpg2709/my-shellscritps/master/install.sh --silent | sudo bash
	printc "  Checking instalation" "l"
	check_execution "exit"
fi

if [[ $DOT_FILES -eq 1 ]]; then
	printc "\Installing tmux configuration...\n" "i"
	curl -o- https://raw.githubusercontent.com/lpg2709/tmux-config/master/install.sh --silent | sudo bash
	printc "  Checking instalation" "l"
	check_execution

	printc "\Installing vim configuration...\n" "i"
	# curl -o- https://raw.githubusercontent.com/lpg2709/vim-config/master/install.sh --silent | sudo bash
	printc "  Checking instalation" "l"
	check_execution
fi
