#!/bin/bash

#引数に容量分割zipしたいディレクトを指定

find $1 -type f -print -ls | awk '
  BEGIN{

    COUNT = 0
    FILENAMES = ""
    total_file_size = 0

  }
  (NF >= 9){
    COUNT++
    total_file_size += $7

    if(total_file_size >= 2000000000){

    print FILENAMES
      total_file_size = $7
      FILENAMES = ""

    }

    FILENAMES = FILENAMES$11

    for(i = 12; i <= NF; i++){

      FILENAMES = FILENAMES"\\ "$i

    }

    FILENAMES = FILENAMES"\\\\0"

  }
  END{

    print FILENAMES

   }' | while read LINE; do
    COUNT=$(( COUNT + 1 ))
    echo -en $LINE | sed 's/\\ / /g'| xargs -0 -s 131072 find | zip $COUNT -@
  done
