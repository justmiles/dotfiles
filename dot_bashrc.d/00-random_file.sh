function random_file {  
  FILE=random_file_$(date +%s).txt
  for i in `seq 1 $RANDOM`;
  do
    echo "$i There's so many records in this file!" >> $FILE
  done
  echo $FILE
}