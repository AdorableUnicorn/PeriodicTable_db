#!/bin/bash

echo "Please provide an element as an argument."

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#atomic number #symbol #name

if [[ ! -z $1 ]]
then

ARGUMENT="$($PSQL "select * from elements;")"


echo "$ARGUMENT" | while IFS="|"  read -r ATOMIC_NUMBER SYMBOL NAME
do

if [[ $ATOMIC_NUMBER==$1 ]] || [[ $SYMBOL==$1 ]] || [[ $NAME==$1 ]]
then

PROPERTIES="$($PSQL "select atomic_mass, melting_point_celsius, boiling_point_celsius from properties where atomic_number=$ATOMIC_NUMBER;")"
IFC="|" read -r MASS MPC BPC <<< $PROPERTIES

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a nonmetal, with a mass of $MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
break
fi

echo "I could not find that element in the database."


done

fi
