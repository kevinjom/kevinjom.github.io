#!/bin/bash

set -e

cleaver *.md

layout_disabled(){
  file=$1;
  sed -n '1p' $file | grep 'layout: false'  || return 1
  sed -n '1p' $file | grep -E '^[-]+' || return 1
}

apply(){
  file=$1
  bak_file="${file}.bak"
  echo "layout: false" > $bak_file
  echo "--------" >> $bak_file
  cat $file >> $bak_file
  mv $bak_file $file
}

disable_layout(){
  file=$1;
  layout_disabled $file || apply $file
}

for file in $(ls *.html); do
  disable_layout $file
done

