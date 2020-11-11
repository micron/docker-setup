#!/usr/bin/env bash

# Simple script which creates a gzipped mysql dump
# Stores the file relative to its location under dumps/latest.sql.gz
# Warning: When the destination file is already in the folder it'll be overriden without asking, use a VCS.

# see: http://stackoverflow.com/questions/4332478/read-the-current-text-color-in-a-xterm/4332530#4332530
#!/usr/bin/bash

CONTAINERS=$(docker ps --format "{{.Names}}")
AUTOCONTAINER=$(echo $CONTAINERS | tr ' ' '\n' | grep -m1 'db' --color=never)

GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
NORMAL=$(tput sgr0)

TARGET_FILE="dumps/latest.sql.gz"

printf '%sSelect one of the available containers (copy and paste the name)' "${YELLOW}"
printf "\n\n"
printf '%s%s%s' "${GREEN}" "$CONTAINERS" "${NORMAL}"
printf "\n\nWhich docker container runs the database:\n"

while [ -z "$SELECTED_CONTAINER" ]; do
  if [ -z "$AUTOCONTAINER" ]; then
    printf "Container []: "
  else
    printf 'Container [%s]: ' "$AUTOCONTAINER"
  fi

  read USER_INPUT
  if [ -z "$USER_INPUT" ]; then
    # User Input is empty
    if [ -z "$AUTOCONTAINER" ]; then
      # Auto Container is empty
      printf "Sorry, but you need to enter a container name."
    else
    # Auto Container got something
    SELECTED_CONTAINER="$AUTOCONTAINER"
    fi
  else
  # User entered container name
  SELECTED_CONTAINER="$USER_INPUT"
  fi
  SELECTED_CONTAINER=$(echo $CONTAINERS | tr ' ' '\n' | grep $SELECTED_CONTAINER)
  clear
done

while true; do
    printf "I'll try to dump the data from ${GREEN}$SELECTED_CONTAINER ${NORMAL}into ${GREEN}$PWD/$TARGET_FILE${NORMAL}.\n"
    printf "${RED}If the file already exists it'll be overridden${NORMAL}\n\n"

    read -p "Proceed ?" yn
    case $yn in
        [Yy]* ) docker exec -i $SELECTED_CONTAINER mysqldump -u application -papplication application | gzip > $TARGET_FILE; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
