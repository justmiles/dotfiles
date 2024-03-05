function truncateFile {
  LINES=$(wc -l $1 | awk '{print $1}')
  echo $LINES 
  TRUNC=$(expr $LINES - $2)
  sed -i "1,$TRUNC d" $1
}