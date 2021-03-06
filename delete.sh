#!/bin/bash

delete_file="delete.txt"
notes_dir="n"
temp="$(mktemp)"

cd $(dirname "$0")

current_datetime="$(date +%s)"

cat "$delete_file" | while IFS= read line
do
    file="$(echo $line | awk '{print $1}')"
    datetime="$(echo $line | awk '{print $2 " " $3}')"
    delete_time=$(date --date="$datetime" +%s)

    # calculate time difference
    let "time_diff=$delete_time-$current_datetime"

    if [ $time_diff -le 0 ]
    then
        rm -f "${notes_dir}/${file}"
        echo "$file" >> "$temp"
    fi
done

# clear delete file
cat "$temp" | while IFS= read line
do
    sed -i "/$line/d" "$delete_file"
done
rm -f "$temp"
