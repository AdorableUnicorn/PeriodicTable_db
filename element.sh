#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then

echo "Please provide an element as an argument."

else

COMPLETED_LOOP=true
ARGUMENT="$($PSQL "select * from elements;")"


while IFS="|"  read -r ATOMIC_NUMBER SYMBOL NAME
do

if [[ $ATOMIC_NUMBER = $1 ]] || [[ $SYMBOL = $1 ]] || [[ $NAME = $1 ]]
then

PROPERTIES="$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM properties LEFT JOIN types ON properties.type_id = types.type_id WHERE atomic_number=$ATOMIC_NUMBER;")"

IFS="|" read MASS MPC BPC TYPE <<< $PROPERTIES

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
COMPLETED_LOOP=false

break

fi

done < <(echo "$ARGUMENT") # Notes for future me: used process substitution istead od direct pipe, as pipe creates subshell scope 

if $COMPLETED_LOOP
then 
echo "I could not find that element in the database."
fi

fi
