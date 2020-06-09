#!/bin/bash

#README: get CVPR2020.py via "wget" and run extract.sh

PAPER_DIR="papers"
if [ ! -d $PAPER_DIR ]; then
    mkdir $PAPER_DIR
fi

URL_ROOT="http://openaccess.thecvf.com"

cat CVPR2020.py | grep "href" | grep "html" | while read line;
do
    LINK_HTML=`echo $line | cut -d '"' -f 4`
    NAME=`echo $LINK_HTML | cut -d "/" -f 3`
    wget -O $DIR/$NAME -nc $URL_ROOT/$LINK_HTML
done

DIR="processed"
if [ ! -d $DIR ]; then
    mkdir $DIR
fi
ls $PAPER_DIR | while read line;
do
    sed -e 's///g' $PAPER_DIR/$line |
    sed -e 's/<\/div>//g' |
    sed -e 's/<\/font>//g' |
    sed -e 's/<br>//g' | 
    sed -e 's/<font size="5">//g' > $DIR/$line
done

echo -e "title\tabstract\tpaper link" >> cvpr2020.csv

ls $DIR | while read line;
do
    TITLE_LINE=$(expr `cat $DIR/$line | grep -n "papertitle" | cut -d ":" -f 1` + 1)
    TITLE=`head -n $TITLE_LINE $DIR/$line | tail -n 1`
    ABSTRACT_LINE=$(expr `cat $DIR/$line | grep -n '<div id="abstract" >' | cut -d ":" -f 1` + 1)
    ABSTRACT=`head -n $ABSTRACT_LINE $DIR/$line | tail -n 1`
    echo $TITLE, $ABSTRACT
    echo -e "$TITLE\t$ABSTRACT\t$URL_ROOT/content_CVPR_2020/html/$line" >> cvpr2020.csv 
done
