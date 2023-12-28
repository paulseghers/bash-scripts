#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <path-to-directory> <output-file-path>"
    exit 1
fi

DIRECTORY=$1
OUTPUT_FILE=$2

if [ ! -d "$DIRECTORY" ]; then
    echo "Directory does not exist: $DIRECTORY"
    exit 1
fi

cd "$DIRECTORY"

#use pdftk tool
pdftk $(ls *.pdf | sort) cat output "$OUTPUT_FILE"

echo "All PDFs have been concatenated into '$OUTPUT_FILE'"


