#!/bin/sh

absme=`readlink -f $0`
abshere=`dirname $absme`
. $abshere/config.sh

INODE_USE=`echo "$TOT_INODE_CNT * 0.2" | bc`
DEV_DIR=/dev/zero
INODE_USED=$1
cnt=$INODE_USED

IS_DONE=0

#while [ "$cnt" -le "$INODE_USE" ]
while true
do
    for dir in $MNT_PNT/*/
    do
	if [ "$cnt" = "$INODE_USE" ]; then
           IS_DONE=1
	   break   
	fi

	THISDATE=`date +"%y%m%d"`
        THISTIME=`date +%s%N`
        THIS=$THISDATE$THISTIME
        RAND=`head -c 500 /dev/urandom | tr -dc 'a-zA-Z0-9~_-' | fold -w 10 | head -n 1`
        UNDER_STR="_"
        OUT_FILE=$dir/$RAND$UNDER_STR$THIS
                #FILE_SZ=`echo "$BLK_SZ * $blk_cnt" | bc`

               #echo "Creating: $OUT_FILE"
        sudo dd if=$DEV_DIR of=$OUT_FILE  bs=$STRIPE_SZ count=1 status=none
        echo "$cnt"
        cnt=$(($cnt+1))
    done

    if [ $IS_DONE -gt 0 ]; then
        break
    fi 


    #cnt=$(($cnt+1))
done	
