#!/bin/bash

#################################################################
# Copyright (C) 2021 Senthu Siva
# GNU General Public License v3.0
# https://github.com/senthusiva/script-toolbox/blob/main/LICENSE
#################################################################

if [ $# -ne 1 ]; then
  echo "Usage: $0 <username>"
  exit 1
fi

tmp_json=tmp_githubinfo.json;
if [ -f "$tmp_json" ]; then
    rm $tmp_json
fi

curl -s "https://api.github.com/users/$1" >> $tmp_json

function getInfo() {
    cat $tmp_json | jq -r "$1"
}

echo -e "Name: " $(getInfo ".name")
echo -e "URL: " $(getInfo ".html_url")
echo -e "Company: " $(getInfo ".company")
echo -e "Website: " $(getInfo ".blog")
echo -e "E-Mail: " $(getInfo ".email")
echo -e "Followers: " $(getInfo ".followers")
echo -e "Following: " $(getInfo ".following")
echo -e "Created at: " $(getInfo ".created_at")
echo -e "Last updated: " $(getInfo ".updated_at")
<<<<<<< HEAD

rm $tmp_json
