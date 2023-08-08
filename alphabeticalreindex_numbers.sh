#!/bin/bash

# usage : `./alphabeticalreindex_numbers.sh <directory> <n>`
# N=2 is 00, 01, ..., 99
# N=3 is 00, 001, ..., 999,
# N=... etc etc

# dir argument
if [[ -z "$1" || -z "$2" ]]; then
  echo "Usage: $0 <directory> <n>"
  exit 1
fi

DIR="$1"
N="$2"

# validate N
if ! [[ $N =~ ^[0-9]+$ ]]; then
  echo "Error: N should be a positive integer."
  exit 2
fi

# Loop through the files in the directory
for FILE in "$DIR"/*; do
  # Extract the filename without path
  FILENAME=$(basename "$FILE")

  # regex to match and capture the index number and the rest of the filename
  if [[ $FILENAME =~ ^([0-9]+)-(.*)$ ]]; then
    INDEX=${BASH_REMATCH[1]}
    REST=${BASH_REMATCH[2]}

    # reindex if index length is less than N
    if (( ${#INDEX} < $N )); then
      NEW_INDEX=$(printf "%0${N}d" "$INDEX")
      NEW_FILENAME="${NEW_INDEX}-${REST}"
      mv "$FILE" "$DIR/$NEW_FILENAME"
      echo "Renamed $FILENAME -> $NEW_FILENAME"
    fi
  fi
done
