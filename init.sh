#!/bin/sh


absme=`readlink -f $0`
abshere=`dirname $absme`
. $abshere/config.sh

### Directories
#export DEV_NM=/dev/loop0
#export MNT_PNT=/mnt1
#export SCRIPT_DIR=/home/dsl/project/flfsck/agings/

### Requirements

#export INODES_USED=11205
#export SPACE_USE=50


#export TOT_INODE_CNT=65525
#export TOT_SPACE_CNT=1073741824

## Usage in Percentage
#export INODE_USAGE=80
#export SPACE_USAGE=80

#export STRIPE_SZ=4096   
#export DIR_LVL=2
#export SUBDIR_CNT=10
#export FILE_CNT=100

## Generate file name -- Input parent dir name
get_file_name(){

#    $IN_DIR_NM=$1

    THISDATE=`date +"%y%m%d"`
    THISTIME=`date +%s%N`
    THIS=$THISDATE$THISTIME
    RAND=`head -c 500 /dev/urandom | tr -dc 'a-zA-Z0-9~_-' | fold -w 10 | head -n 1`
    UNDER_STR="_"

    FILE_NM=$1/$RAND$UNDER_STR$THIS

    echo $FILE_NM
}


## Counters for each parameter

DIR_CNTR=0
SUB_DIR_CNTR=0
INODE_CNTR=0
DIR_FILE_CNTR=0
DIR_LVL_CNTR=0
INODE_CNTR=0
#WORK_DIR=$MNT_PNT

echo "MNT_PNT: $MNT_PNT"
echo
echo "Stripe size: $STRIPE_SZ"
echo "SUBDIR_CNT: $SUBDIR_CNT"
echo "DIR_LVL: $DIR_LVL"
echo "FILE_CNT: $FILE_CNT"

sleep 5

echo
echo "Creating initial folders in $MNT_PNT"
echo
while [ "$SUB_DIR_CNTR" -lt "$SUBDIR_CNT" ]
do

    mkdir $MNT_PNT/$SUB_DIR_CNTR
#    while [ $DIR_FILE_CNTR - lt $FILE_CNT ]
#    do
#        $FL_NM=`get_file_name $MNT_PNT`
#        dd if=/dev/zero of=$FL_NM bs=$STRIPE_SZ count=1
#        let "DIR_FILE_CNTR += 1"
#    done

    #DIR_FILE_CNTR=0
    #let "SUB_DIR_CNTR+=1"
    #let "INODE_CNTR+=1"
    SUB_DIR_CNTR=$((SUB_DIR_CNTR+1))
    INODE_CNTR=$((INODE_CNTR+1))

    #sleep 1

done

sync

sleep 1

SUB_DIR_CNTR=0
DIR_LVL_CNTR=1
LOST_FND=$MNT_PNT/lost+found
echo $LOST_FND
sleep 5

while [ "$DIR_LVL_CNTR" -le "$DIR_LVL" ]
do

    echo "Creating init folders and files at level $DIR_LVL_CNTR in $MNT_PNT"
    echo

    for WORK_DIR in `find $MNT_PNT -mindepth $DIR_LVL_CNTR -maxdepth $DIR_LVL_CNTR -type d`
    do
 
        if [ "$WORK_DIR" = "$LOST_FND" ]; then
            continue
        fi


        while [ "$SUB_DIR_CNTR" -lt "$SUBDIR_CNT" ]
        do

            mkdir $WORK_DIR/$SUB_DIR_CNTR
            #let "SUB_DIR_CNTR += 1"
            #let "INODE_CNTR += 1"
            SUB_DIR_CNTR=$((SUB_DIR_CNTR+1))
            INODE_CNTR=$((INODE_CNTR+1))
        done 

        SUB_DIR_CNTR=0

        while [ "$DIR_FILE_CNTR" -lt "$FILE_CNT" ]
        do
            FL_NM=`get_file_name $WORK_DIR`
            dd if=/dev/zero of=$FL_NM bs=$STRIPE_SZ count=1 status=none
            #let "DIR_FILE_CNTR += 1"
            #let "INODE_CNTR += 1"
            DIR_FILE_CNTR=$((DIR_FILE_CNTR+1))
            INODE_CNTR=$((INODE_CNTR+1))
        done

        DIR_FILE_CNTR=0

    done

    sync

    #let "DIR_LVL_CNTR += 1"
    DIR_LVL_CNTR=$((DIR_LVL_CNTR+1))

done

sync

echo
echo
echo "Inodes Used: $INODE_CNTR"
echo
sleep 2
## TODO Call to second phase -- Pass INODE_CNTR as input
echo "Executing: $abshere/inc_size.sh "
echo
. $abshere/inc_size.sh
