#!/bin/bash

for i in "$@"
do
case $i in
    -h|--help)
        echo "Extract HTML documentation contained in .qch file"
        echo "Usage:"
        echo "    qchextractor.sh <input-qch-file> <output-directory>"
        echo "Options:"
        echo "  -h, --help                  print this help"
        exit 0
    ;;
esac
done

if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters"
    exit 1
fi
if [ ! -f $1 ]; then
    echo "Invalid input file: $1"
    exit 1
fi

output_dir="$2/html"
mkdir -p ${output_dir} || { echo "Unable to create output dir $2"; exit 1; }

# Remove 1st zero record for actual files count in .qch file
files_count=$(( $(sqlite3 "$1" "SELECT Count(*) FROM FileNameTable;") - 1))
echo -e "\nFiles inside '$(basename ${1})': ${files_count}"

for row in $(seq 1 ${files_count})
do
    echo -n -e "\rExtracting files: ${row}/${files_count}"
    file_id=$(sqlite3 "$1" "SELECT FileId FROM FileNameTable LIMIT 1 OFFSET ${row};")
    file_name=$(sqlite3 "$1" "SELECT Name FROM FileNameTable WHERE FileId==${file_id};")
    dir_name=$(dirname "${file_name}")
    mkdir -p "${output_dir}/${dir_name}"
    sqlite3 "$1" "SELECT quote(Data) FROM FileDataTable WHERE Id==${file_id};" \
    | cut -d\' -f2 \
    | sed 's/^........//' \
    | xxd -r -p \
    | ./zpipe -d \
    > "${output_dir}/${file_name}"
#    | zlib-flate -uncompress \
done
echo -n -e "\n"
