#!/usr/bin/env bash

# Simple script which creates a gzipped mysql dump
# Stores the file relative to its location under dumps/latest.sql.gz
# Warning: When the destination file is already in the folder it'll be overriden without asking, use a VCS.

# see: http://stackoverflow.com/questions/4332478/read-the-current-text-color-in-a-xterm/4332530#4332530
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
NORMAL=$(tput sgr0)

TARGET_FILE="dumps/latest.sql.gz"
CONTAINERS=$(docker ps --format "{{.Names}}")

printf "${YELLOW}Select one of the available containers (copy and paste the name)"
printf "\n\n"
printf "${GREEN}$CONTAINERS${NORMAL}"
printf "\n\nWhich docker container runs the database: "
read input_variable

while true; do
    printf "I'll try to dump the data from ${GREEN}$input_variable ${NORMAL}into ${GREEN}$PWD/$TARGET_FILE${NORMAL}.\n"
    printf "${RED}If the file already exists it'll be overridden${NORMAL}\n\n"

    read -p "Proceed ?" yn
    case $yn in
        [Yy]* ) docker exec -i $input_variable mysqldump -u application -papplication application | gzip > $TARGET_FILE; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done