#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# prompt for username
echo "Enter your username:"
read USERNAME

# generate random game_name
# GAME_NAME=$(echo $RANDOM | md5sum | head -c 5; echo)
GAME_NAME="$USERNAME-$(date +'%Y-%m-%d-%H-%M-%S')"
# echo $GAME_NAME

# query username
VALIDATE_USER=$($PSQL "select user_id from users where username = '$USERNAME';")

# username validation
if [[ -z $VALIDATE_USER ]]; then
  # first time user
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  
  # insert new username
  INSERT_INTO_USERS=$($PSQL "insert into users(username) values('$USERNAME');")
  
  # get user_id based on username
  GET_USER_ID=$($PSQL "select user_id from users where username = '$USERNAME';")  

  # insert game_name and user_id to register game
  INSERT_GAME_NAME=$($PSQL "insert into games(username, user_id) values('$GAME_NAME', $GET_USER_ID);")

  # query game_id
  GET_GAME_ID=$($PSQL "select game_id from games where user_id = '$GET_USER_ID';")

  # update guess_count based on game_id
  UPDATE_GUESS_COUNT_IN_GAMES=$($PSQL "update games set guesses = 1000 where game_id = $GET_GAME_ID;")
else
  # existing user
  GAMES_PLAYED=$($PSQL "select count(game_id) from games where user_id = $VALIDATE_USER;")
  BEST_GAME=$($PSQL "select min(guess_count) from games where user_id = $VALIDATE_USER;")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."

  # get user_id based on username
  GET_USER_ID=$($PSQL "select user_id from users where username = '$USERNAME';")  

  # insert game_name and user_id to register game
  INSERT_GAME_NAME=$($PSQL "insert into games(username, user_id) values('$GAME_NAME', $GET_USER_ID);")
fi

# generate random number up to 1000
CORRECT_RANDOM_GUESS=$(( $RANDOM % 1000 + 1 ))
# echo "CORRECT_RANDOM_GUESS: $CORRECT_RANDOM_GUESS"
GUESS_COUNT=0

echo "Guess the secret number between 1 and 1000:"

# loop until number_guessed is equal to correct_random_guess
until [[ $NUMBER_GUESSED -eq $CORRECT_RANDOM_GUESS ]]; do
  read NUMBER_GUESSED
  #(( GUESS_COUNT++ ))

  # integer validation
  if [[ ! $NUMBER_GUESSED =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
  else
    # if [[ ! ( $NUMBER_GUESSED -gt 0 && $NUMBER_GUESSED -le 1000 ) ]]; then
      # echo "It's lower than that, guess again:"
    # else
      if [[ $NUMBER_GUESSED -gt $CORRECT_RANDOM_GUESS ]]; then
        echo "It's lower than that, guess again:"
      elif [[ $NUMBER_GUESSED -lt $CORRECT_RANDOM_GUESS ]]; then
        echo "It's higher than that, guess again:"
      fi
    # fi
  fi
done

# when guessed, increment guess_count
#(( GUESS_COUNT++ ))

# query game_id
GET_GAME_ID=$($PSQL "select game_id from games where username = '$GAME_NAME';")

# update guess_count based on game_id
UPDATE_GUESS_COUNT_IN_GAMES=$($PSQL "update games set guesses = $GUESS_COUNT where game_id = $GET_GAME_ID;")

# print result
echo "You guessed it in $GUESS_COUNT tries. The secret number was $CORRECT_RANDOM_GUESS. Nice job!"

# alter table users
# alter column name type varchar(23)
# using name::varchar(23);
# NEW COMMENT





