#! /bin/bash

#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only --no-align -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi

if [[ "$1" =~ ^[0-9]+$ ]]; then
  result=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
                    FROM elements e
                    JOIN properties p ON e.atomic_number = p.atomic_number
                    JOIN types t ON p.type_id = t.type_id
                    WHERE e.atomic_number = $1")
else
    # Argument is not a number, so match symbol or name
  result=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
                    FROM elements e
                    JOIN properties p ON e.atomic_number = p.atomic_number
                    JOIN types t ON p.type_id = t.type_id
                    WHERE e.symbol='$1' OR e.name='$1'")
fi

# Check if the query returned a result
if [ -z "$result" ]; then
    echo "I could not find that element in the database."
else
    # Parse the result and display the information
    IFS="|" read atomic_number name symbol type atomic_mass melting_point boiling_point <<< "$result"
    echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
fi