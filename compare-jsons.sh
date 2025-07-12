#!/bin/bash

# Parse arguments
if [ $# -ne 2 ]; then
    echo "Number of CLI arguments is $#"
    echo -e "ERROR: Need to pass 2 arguments, e.g. file1.json file2.json\n" >&2
    exit 1
fi

file1=$1
file2=$2

# Check that files from required arguments exsists
if [[ ! -f $file1 || ! -f $file2 ]]; then
    echo -e "ERROR: File not exsist\n" >&2
    exit 1
fi

# Create normalized jsons
filename1=${file1%.*}
filename2=${file2%.*}

temp_file1=$filename1\_normed_sorted.json
temp_file2=$filename2\_normed_sorted.json

jq --sort-keys . $file1 > $temp_file1
jq --sort-keys . $file2 > $temp_file2


# Compare normalized jsons
diff $temp_file1 $temp_file2 > /dev/null
exit_code=$?

if [ ${exit_code} -ne 0 ]; then
    echo "WARNING: Files are not equal"

	delta $temp_file1 $temp_file2
    
    rm $temp_file1
    rm $temp_file2
    exit ${exit_code}
else
    echo "OK, files are equal"
    rm $temp_file1
    rm $temp_file2
fi
