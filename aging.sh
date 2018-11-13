#!/bin/sh


./config.sh

#it=0

## Required inputs: <path>

mk_dir() {
#while [ $it -le $AVG_SUBDIR_CNT ]
#do
    THISDATE=`date +"%y%m%d"`
    THISTIME=`date +%s%N`
    THIS=$THISDATE$THISTIME

    DIR_NM=$1/$THIS
     
    mkdir $DIR_NM

#    let "it += 1"
#done

}


## Required inputs: <dir_path> <file_sz>

mk_file() {


    THISDATE=`date +"%y%m%d"`
    THISTIME=`date +%s%N`
    THIS=$THISDATE$THISTIME

    RAND=`head -c 500 /dev/urandom | tr -dc 'a-zA-Z0-9~_-' | fold -w 10 | head -n 1`
    UNDER_STR="_"

    FILE_NM=$1/$RAND$UNDER_STR$THIS

    dd if=/dev/zero of=$FILE_NM bs=$2 count=1
}

dir_cnt=0
WRK_MK_DIR=$WORK_DIR

if [ $AVG_DIR_LVL -eq 0 ]; then

    ## Just Create files in WORK_DIR

else

    while [ $dir_cnt -le $AVG_SUBDIR_CNT ]
    do

        mk_dir $WRK_MK_DIR
    

    done

fi
