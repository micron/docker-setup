#!/usr/bin/bash

CONTAINERS=$(docker ps --format "{{.Names}}")
AUTOCONTAINER=$(echo $CONTAINERS | tr ' ' '\n' | grep -m1 'php' --color=never)
AUTOUSER="admin"
SELECTED_CONTAINER=""
SELECTED_USER=""
PASS="asdf1234"
WP_PATH="/var/www/html/wp"

printf 'Please select the php container which contains the wordpress installation:\n\n'
printf '%s\n\n' "$CONTAINERS"

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

printf 'Getting users...\n\n'
docker exec -i $SELECTED_CONTAINER wp user list --field=user_login --allow-root --path=$WP_PATH
#printf '\nUser with ID 1 is: %s\n' "$(docker exec -i $SELECTED_CONTAINER wp user get 1 --allow-root --field=login --path=/var/www/html/wp)"

while [ -z "$SELECTED_USER" ]; do
  printf '\nUser [%s]:' "$AUTOUSER"
  read USER_INPUT
  if [ -z "$USER_INPUT" ]; then
    # User Input is empty
    if [ -z "$AUTOUSER" ]; then
      # Auto Container is empty
      printf "Sorry, but you need to enter an username."
    else
    # Auto user got something
    SELECTED_USER="$AUTOUSER"
    fi
  else
  # User entered username
  SELECTED_USER="$USER_INPUT"
  fi
  clear
done

printf "Resetting password...\n"
docker exec -i $SELECTED_CONTAINER wp user update $SELECTED_USER --allow-root --user_pass=$PASS --skip-email --path=$WP_PATH

