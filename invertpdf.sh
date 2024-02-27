#!/bin/bash

# For when you need to print smth recto-verso that will
# flip upwards

if [ $# -lt 1 ]; then
    echo "Usage: $0 input_pdf [output_pdf]"
    exit 1
fi

# Assign the first argument as the input PDF file
input_pdf="$1"

# Check if the output file name is provided
if [ $# -eq 2 ]; then
    output_pdf="$2"
else
    # If not provided, create a name by appending "_reordered" before the extension
    filename=$(basename -- "$input_pdf")
    extension="${filename##*.}"
    filename="${filename%.*}"
    output_pdf="${filename}_reordered.${extension}"
fi


#ideally, you'd also want to be able to flip,
# but I couldn't get pdfjam to work
# Temporary files
# temp_pdf="temp_$input_pdf"
# rotated_pdf="rotated_$input_pdf"

# this fails, but try to rotate every other page
# pdfjam --angle 180 --outfile "$rotated_pdf" "$input_pdf" '{2,-}'

# # merge original and rotated files interleaving pages
# pdftk A="$input_pdf" B="$rotated_pdf" shuffle A B output "$temp_pdf"

# get num pages
num_pages=$(pdftk "$input_pdf" dump_data | grep NumberOfPages | awk '{print $2}')

# if num_pages uneven, increment by 1 for swapping loop
if [ $((num_pages % 2)) -ne 0 ]; then
    num_pages=$((num_pages + 1))
fi

#swap
page_order=""
for ((i=2; i<=num_pages; i+=2)); do
    next_page=$((i-1))
    if [ $i -eq $num_pages ] && [ $((num_pages % 2)) -ne 0 ]; then
        # Skip the last increment for odd total pages
        break
    fi
    page_order="${page_order} $i $next_page"
done

# if ood number of pages
if [ $((num_pages % 2)) -ne 0 ]; then
    page_order="${page_order} $num_pages"
fi

# Use pdftk to create the new reordered PDF
pdftk "$input_pdf" cat $page_order output "$output_pdf"

echo "Reordered PDF saved as $output_pdf"
