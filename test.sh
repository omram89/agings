#!/bin/sh


get_file_name(){

    #$IN_DIR_NM=$1

    THISDATE=`date +"%y%m%d"`
    THISTIME=`date +%s%N`
    THIS=$THISDATE$THISTIME
    RAND=`head -c 500 /dev/urandom | tr -dc 'a-zA-Z0-9~_-' | fold -w 10 | head -n 1`
    UNDER_STR="_"

    FILE_NM=$1/$RAND$UNDER_STR$THIS

    echo $FILE_NM
}

FL_NM=`get_file_name test`
echo $FL_NM
