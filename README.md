# About

This shell script allows to extract HTML documentation contained in .qch files.

# Installation

The `qchextractor.sh` script requires `sqlite3` package installed and `zpipe` executable.

1. Install `sqlite3`:

```bash
sudo apt install sqlite3
```

2. Compile `zpipe` executable:

```bash
make
```

# Usage

qchextractor can be run as:
```bash
qchextractor.sh <input-qch-file> <output-directory>
```

If the output directory does not exist, it will be created along with a subdirectory 
named 'html' where the files contained in the qch file will be extracted.

All credits for zpipe belong to the original author (Mark Adler) http://www.zlib.net/zpipe.c

# Aurora/Sailfish SDK Example

Example of batch extracting of Aurora/Sailfish SDK documentation files.

```bash
qchextractor="$(pwd)/qchextractor.sh"; \
documentation_dir="${HOME}/AuroraOS/documentation"; \
for qch_file in ${documentation_dir}/*.qch; do \
    out_dir="${documentation_dir}/html/$(basename ${qch_file%.qch})"; \
    mkdir -p "${out_dir}"; \
    $qchextractor "${qch_file}" "${out_dir}"; \
done
```