#!/bin/bash

printf "Trivia: "
curl -s "http://numbersapi.com/$1" 
printf "\n\n"

printf "Year: "
curl -s "http://numbersapi.com/$1/year" 
printf "\n\n"


printf "Date: "
curl -s "http://numbersapi.com/$1/$1/date" 
printf "\n\n"


printf "Math: "
curl -s "http://numbersapi.com/$1/math" 
printf "\n\n"
