# Script Toolbox

## About
In the Script Toolbox you will find a collection of scripts that I have created and will create in the future. I am using this opportunity to learn more about scripting. The scripts were made with the help of Linux man pages and the StackOverflow community. If you find a bug or have a feature request, you're welcome to create an issue.

Thank you and have fun with the scripts.

## Installation and Usage
### Get a single script
e.g. updater.sh:

* `wget -L https://github.com/senthusiva/script-toolbox/blob/main/src/updater.sh`
* `chmod +x updater.sh`
* `./updater.sh`

### Get all the scripts
* `git clone https://github.com/senthusiva/script-toolbox.git`
* `cd script-toolbox`
* `chmod +x *.sh`

## Scripts
1. [updater.sh](#updater.sh)
2. [randfacts.sh](#randfacts.sh)

<a name="updater.sh"></a>
### updater.sh
* About: beginner friendly way to upgrade your linux applications.
* Usage:
  ```
  $ sudo ./updater.sh
    ++++ List of upgradable packages ++++
    (...)
    PROGRAM: package 1 (...)
    PROGRAM: package 2 (...)
    (...)
    
    ---- List of removable packages ----
    PROGRAM: package A (...)
    PROGRAM: package B (...)
    (...)
  ```
* Download: `wget -L https://github.com/senthusiva/script-toolbox/blob/main/src/updater.sh`

<a name="randfacts.sh"></a>
### randfacts.sh
* About: get useful and fun facts about certain numbers.
* Usage:
  ```
  $ ./randfacts.sh 24
  Trivia: 24 is the number of accepted runners in the Melbourne Cup.
  Year: 24 is the year that Philo declares that the Old Testament is the eternal law of God.
  Date: December 24th is the day in 1294 that Pope Boniface VIII is elected Pope, replacing St. Celestine V, who had resigned.
  Math: 24 is a highly composite number, having more divisors than any smaller number.
  ```
* Download: `wget -L https://github.com/senthusiva/script-toolbox/blob/main/src/randfacts.sh`
