#!/bin/bash

#################################################################
# Copyright (C) 2021 Senthu Siva
# GNU General Public License v3.0
# https://github.com/senthusiva/script-toolbox/blob/main/LICENSE
#################################################################

#Define colors and formats
color_default=$(tput sgr0)
color_red=$(tput setaf 1)
color_green=$(tput setaf 2)
color_yellow=$(tput setaf 3)


#Check if user is root
if [ "$EUID" -ne 0 ]; then 
    echo "${color_red}Please run as root!"
    exit
fi


#Define upgradable and removable
list_upgradable=$(apt-get --just-print upgrade 2>&1 | perl -ne 'if (/Inst\s([\w,\-,\d,\.,~,:,\+]+)\s\[([\w,\-,\d,\.,~,:,\+]+)\]\s\(([\w,\-,\d,\.,~,:,\+]+)\)? /i) {print "PROGRAM: $1 INSTALLED: $2 AVAILABLE: $3\n"}' | column -s " |" -t)
list_upgradable_done=$(apt-get --just-print upgrade 2>&1 | perl -ne 'if (/Inst\s([\w,\-,\d,\.,~,:,\+]+)\s\[([\w,\-,\d,\.,~,:,\+]+)\]\s\(([\w,\-,\d,\.,~,:,\+]+)\)? /i) {print "PROGRAM: $1\n"}' | column -s " |" -t)
list_removable=$(apt-get --dry-run autoremove | grep -Po '^Remv \K[^ ]+')


#Define status messages and questions
msg_upgrade_success="${color_green}Done. Following packages were successfully updated: ${color_default}"
msg_remove_success="${color_green}Done. Following packages were successfully removed: ${color_default}"
msg_question_upgrade="Do you want to update the packages now? [Y|n]:${color_default} "
msg_question_remove="Do you want to remove packages that are no longer needed? [Y|n]:${color_default} "
msg_invalid_input="${color_red}Invalid input. Please type Y(es) or n(o)!${color_default}"


#Update the package repository and clear the screen 
apt-get update
clear -x


#List upgradable and removable packages
bool_upgrade_is=false
bool_remove_is=false
#create txt files to temporarily store the lists and print it out later. 
tmp_update_file=$(mktemp --suffix "_upd.txt")
tmp_remove_file=$(mktemp --suffix "_rem.txt")

touch $tmp_update_file
touch $tmp_remove_file

echo -e "${color_green}++++ List of upgradable packages ++++${color_default}"
if [[ $list_upgradable ]]; then
    bool_upgrade_is=true
    echo "$list_upgradable"
    echo "$list_upgradable_done" >> $tmp_update_file
else
    echo -e "${color_green}Looks fine, nothing to upgrade...${color_default}"
fi
echo -e "\n"

echo -e "${color_red}---- List of removable packages ----${color_default}"
if [[ $list_removable ]]; then
    bool_remove_is=true
    echo "$list_removable"
    echo "$list_removable"  >> $tmp_remove_file
else
    echo -e "${color_red}Looks fine, nothing to remove...${color_default}"
fi
echo -e "\n"


#Get user-confirmation to upgrade and remove packages
if [ "$bool_upgrade_is" = true ]; then
    read -p "${msg_question_upgrade}" confm_upgrade
    if [ "$confm_upgrade" = "Y" ]; then
        bool_upgrade_is=true
    elif [ "$confm_upgrade" = "n" ]; then
        bool_upgrade_is=false
        echo -e "Packages will not be upgraded!\n" 
    else
        echo "${msg_invalid_input}"
        exit
    fi
fi

if [ "$bool_remove_is" = true ]; then
    read -p "${msg_question_remove}" confm_remove
    if [ "$confm_remove" = "Y" ]; then
        bool_remove_is=true
    elif [ "$confm_remove" = "n" ]; then
        bool_remove_is=false
        echo -e "Packages will not be removed!\n" 
    else
        echo "${msg_invalid_input}"
        exit      
    fi
fi
echo -e "\n"



#execute upgrade, remove command and clean up
if [ "$bool_upgrade_is" = true ]; then
    apt-get upgrade -y
fi

if [ "$bool_remove_is" = true ]; then
    apt-get autoremove -y
    apt-get clean -y
fi

clear -x
#print status message
echo -e "\n\n"
if [ "$bool_upgrade_is" = true ]; then
    echo "${msg_upgrade_success}"
    echo "$color_green"
    cat $tmp_update_file
    echo "$color_default"
fi

if [ "$bool_remove_is" = true ]; then
    echo "${msg_remove_success}"
    echo "$color_red"
    cat $tmp_remove_file
    echo "$color_default"
fi
echo -e "\n"
rm $tmp_update_file
rm $tmp_remove_file
