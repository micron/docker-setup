#!/usr/bin/bash

CONTAINERS=$(docker ps --format "{{.Names}}")
AUTOCONTAINER=$(echo $CONTAINERS | tr ' ' '\n' | grep -m1 'php' --color=never)
AUTOUSER="admin"
SELECTED_CONTAINER=""

printf "$AUTOCONTAINER\n"
printf "Please select the database which contains the wordpress installation:\n"
printf "$CONTAINERS\n"

if [ -z "$AUTOCONTAINER" ]; then
  printf "Container []: "
else
  printf "Container [$AUTOCONTAINER]: "
fi

read USER_INPUT

while [ -z "$SELECTED_CONTAINER" ]; do
if [ -z "$USER_INPUT" ]; then
  # User Input is empty
  if [ -z "$AUTOCONTAINER" ]; then
    # Auto Container is empty
    printf "Sorry, but you need to choose a valid container."
  else
    # Auto Container got something
    SELECTED_CONTAINER="$AUTOCONTAINER"
  fi
else
  # User entered container name
  SELECTED_CONTAINER="$USER_INPUT"
fi
SELECTED_CONTAINER=$(echo $CONTAINERS | tr ' ' '\n' | grep $SELECTED_CONTAINER)
done

docker exec -i $SELECTED_CONTAINER wp user get 1 --field=login --path=/var/www/html/wp --allow-root
docker exec -i $SELECTED_CONTAINER wp user update $AUTOUSER --user_pass=asdf1234 --skip-email --path=/var/www/html/wp --allow-root
