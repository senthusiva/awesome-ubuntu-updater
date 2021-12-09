#!/bin/bash


#Define colors and formats
color_default=$(tput sgr0)
color_red=$(tput setaf 1)
color_green=$(tput setaf 2)
color_yellow=$(tput setaf 3)


#Check if user is root
if [ "$EUID" -ne 0 ]
  then echo "${color_red}Please run as root"
  exit
fi


#Define commands that will be used in this script
clear_screen=$(clear)
list_upgradable=$(apt-get --just-print upgrade 2>&1 | perl -ne 'if (/Inst\s([\w,\-,\d,\.,~,:,\+]+)\s\[([\w,\-,\d,\.,~,:,\+]+)\]\s\(([\w,\-,\d,\.,~,:,\+]+)\)? /i) {print "PROGRAM: $1 INSTALLED: $2 AVAILABLE: $3\n"}' | column -s " |" -t)
list_removable=$(apt-get --dry-run autoremove | grep -Po '^Remv \K[^ ]+')
update=$(apt-get update)
upgrade=$(apt-get upgrade)
remove=$(apt-get autoremove)
clean=$(apt-get clean)


#Define status messages and questions
msg_upgrade_success="${color_green}Done. Packages successfully updated :)${color_default}"
msg_remove_success="${color_green}Done. Packages successfully removed :)${color_default}"
msg_abort="${color_red}Aborted${color_default}"
msg_question_upgrade="Do you want to update the packages now? [Y|n]:${color_default} "
msg_question_remove="Do you want to remove packages that are no longer needed? [Y|n]:${color_default} "
msg_invalid_input="${color_red}Invalid input. Please type Y(es) or n(o)!${color_default}"


#Update the package repository and clear the screen 
echo "$update && $clear_screen"


#List upgradable and removable packages
printf "${color_green}++++ List of upgradable packages ++++${color_default}\n"
if [[ $list_upgradable ]]; then
    echo "$list_upgradable"
else
    printf "${color_green}Looks fine, nothing to upgrade...${color_default}\n"
fi
printf "\n"

printf "${color_red}---- List of removable packages ----${color_default}\n"
if [[ $list_removable ]]; then
    echo "$list_removable"
else
    printf "${color_green}Looks fine, nothing to remove...${color_default}\n"
fi
printf "\n"


#Get user-confirmation to upgrade and remove packages
bool_upgrade_is=false
bool_remove_is=false

read -p "${msg_question_upgrade}" confm_upgrade
if [ "$confm_upgrade" = "Y" ]; then
    bool_upgrade_is=true
elif [ "$confm_upgrade" = "n" ]; then
    bool_upgrade_is=false
    echo "Packages will not be updated!"
else
    echo "${msg_invalid_input}"
    exit
fi

read -p "${msg_question_remove}" confm_remove
if [ "$confm_remove" = "Y" ]; then
    bool_remove_is=true
elif [ "$confm_remove" = "n" ]; then
    bool_remove_is=false
    echo "Packages will not be removed!" 
else
    echo "${msg_invalid_input}"
    exit      
fi

   
#execute upgrade, remove command and clean up
if [ "$bool_upgrade_is" = true ]; then
    echo "$upgrade"
fi

if [ "$bool_remove_is" = true ]; then
    echo "$remove && $clean"
fi


#print status message
printf "\n\n"
if [ "$bool_upgrade_is" = true ]; then
    echo "${msg_upgrade_success}"
fi

if [ "$bool_remove_is" = true ]; then
    echo "${msg_remove_success}"
fi
