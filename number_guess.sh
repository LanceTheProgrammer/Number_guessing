#!/bin/bash

PSQL ="psql -X --username=freecodecamp --dbname=number_guess --no-align --tuples-only -c"
echo "Enter your username:"
SECRET_NUMBER=$(( $RANDOM % 1000 + 1 ))
read USERNAME

RETURNING_USER=$($PSQL "SELECT username FROM users WHERE username = $USERNAME")

if [[ -z $RETURNING_USER ]]
then
  INSERTED_USER=$(PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
  echo Welcome, $USERNAME! It looks like this is your first time here.

else
GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games INNER JOIN USING(user_id) WHERE username = $USERNAME")
BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games INNER JOIN USING(user_id) WHERE username = $USERNAME")
echo GAMES_PLAYED
echo Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.

fi

echo "Guess the secret number between 1 and 1000:"
read GUESS

if [[ ! $GUESS =~ ^[0-9]+$ ]]
then

else


  if [[ $GUESS -gt $SECRET_NUMBER]]

  then
  elif [[ $GUESS -lt $SECRET_NUMBER ]]
  then

  else

  fi

  
fi


