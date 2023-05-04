#!/bin/bash

# compress large pdf file to smaller size almost without quality degradation
# GNU Affero GPL 3.0 (ɔ) 2020 almaceleste
# https://github.com/almaceleste/compress-pdf

# some part of this code was taken from the Alfred Klomp script:
# http://www.alfredklomp.com/programming/shrinkpdf/

# dependencies:
#   zenity
#   gs

# get input file
inputfile=$1

# check if the input file is a pdf file
extension="${inputfile##*.}"
if [ $extension != "pdf" ]; then
    message="the following file is not a pdf file:\n-------\n$inputfile"
    if (( SHLVL > 1 )); then 
        echo -e "$message"
    else
        zenity --info --width=300 --modal --icon-name=application-pdf --text="$message"
    fi
    exit 1
fi

# get output file if exists
if [ $2 ]; then
    outputfile=$2
else
    outputfile="$inputfile"
fi

# get resolution (900dpi by default)
if [ $3 ]; then
    resolution=$3
else
    resolution=900
fi

# set an interim temporary file
tmpfile=$(basename "$inputfile")
tmpfile="/tmp/$tmpfile"
# check if the input file is located in the /tmp directory
if [ "$inputfile" == "$tmpfile" ]; then
    tmpfile=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13)
    tmpfile="/tmp/$tmpfile"
fi

function compress(){
	gs -q -dNOPAUSE -dBATCH -dSAFER			\
	  -sDEVICE=pdfwrite						\
	  -dCompatibilityLevel=1.7				\
	  -dPDFSETTINGS=/screen					\
	  -dEmbedAllFonts=true					\
	  -dSubsetFonts=true					\
	  -dAutoRotatePages=/None				\
	  -dColorImageDownsampleType=/Bicubic	\
	  -dColorImageResolution=$3				\
	  -dGrayImageDownsampleType=/Bicubic	\
	  -dGrayImageResolution=$3				\
	  -dMonoImageDownsampleType=/Subsample	\
	  -dMonoImageResolution=$3				\
	  -sOutputFile="$2"						\
	  "$1"
}

compress "$inputfile" "$tmpfile" $resolution
mv "$tmpfile" "$outputfile"

message="the following file have been compressed:\n-------\n$inputfile"
if [ "$inputfile" != "$outputfile" ]; then
    message+="\nto\n$outputfile"
fi

if (( SHLVL > 1 )); then 
    echo -e "$message"
else
    zenity --info --width=300 --modal --icon-name=application-pdf --text="$message"
fi