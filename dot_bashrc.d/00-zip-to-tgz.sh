# zip-to-tgz
# zip-to-tgz /path/to/zip
function zip-to-tgz {
  FILE=$(basename $1)
  DIR=$(cd $(dirname $1);pwd)
  NEWFILE=$(echo $FILE | sed 's/.zip/.tar.gz/g')
  echo Converting $FILE to $NEWFILE
  TMPFOLDER=/tmp/$FILE.FOLDER
  rm -rf $TMPFOLDER
  mkdir -p $TMPFOLDER
  unzip $FILE -d $TMPFOLDER > /dev/null
  GZIP=-9 tar czf $DIR/$NEWFILE -C $TMPFOLDER .
  rm -rf $TMPFOLDER
  echo Created $DIR/$NEWFILE
}
