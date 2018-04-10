#!/bin/bash

#引数に容量分割zipしたいディレクトを指定

find $1 -type f -regex "[^\;\%\$\&\` ]*" -ls | awk '
	BEGIN{

	  COUNT = 0
	  FILENAMES = ""
	  total_file_size = 0

	}
    (NF == 11 && $11 !~ /\;\%\$\&\`/){
		COUNT++
		total_file_size += $7
  
	  if(total_file_size >= 1000000000){

		print FILENAMES
	  	total_file_size = $7
	  	FILENAMES = ""

  	}
	
		FILENAMES = FILENAMES$11"\\\\0"
	
    }
	END{

	  print FILENAMES

	 }' | while read LINE; do

		echo -en $LINE | sed 's/\\ / /g'| xargs -0 -s 131072 find | zip `date +%Y%m%d%H%M%S` -@
		sleep 1

	done
