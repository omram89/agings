#!/bin/bash

#WORK_DIR=$2
BLK_SZ=4096
#INODE_CNTR=$1

exit_fnc(){
sync
echo
echo
echo "Inode usage: $INODE_CNTR/$TOT_INODE_CNT"
echo "FS Usage   : $FS_USED_SZ/$TOT_SPACE_CNT"
echo
echo

exit 0
}


FS_USE_SIZE=`echo "$TOT_SPACE_CNT * $SPACE_USAGE" | bc`
INODE_USE=`echo "$TOT_INODE_CNT * $INODE_USAGE" | bc`
LOST_FND=$MNT_PNT/lost+found


echo
echo "FS_USE_SIZE: $FS_USE_SIZE"
echo "INODE_USE: $INODE_USE"
echo "INODE_CNTR: $INODE_CNTR"
echo "MOUNT POINT: $MNT_PNT"
echo "############ Increase FS Size to $FS_USE_SIZE - $MNT_PNT"
echo

sleep 5
#cd $WORK_DIR
DEV_DIR=/dev/zero
DELETE_CNTR=0
CREATE_CNTR=0
NUM_THREE=3        ## Number of cycles to create a file
NUM_FIVE=500       ## Number of cycles to delete a file
while true
do
    for dir in $MNT_PNT/*/
    do
        dir=${dir%*/}

        #if [ $dir == "$MNT_PNT/lost+found" ]
        #then
        #    continue
        #fi
        if [ "$dir" = "$LOST_FND" ] 
        then
            continue
        fi
        #echo ${dir}
        cd $dir
        file1=`ls | shuf -n 1`
        rand_file=$dir/$file1

        #echo "$rand_file"
        #echo
        #file_sz=`stat --printf="%s" $rand_file`
        #blk_cnt=`shuf -i 1-100 -n 1`
        #inc_size=`echo "$BLK_SZ * $blk_cnt" | bc`
        #truncate $rand_file --size $inc_size
        #sudo fallocate -l $inc_size $rand_file

        #echo $rand_file

        if [ "$DELETE_CNTR" -eq $NUM_FIVE ]
        then
            echo "Deleting: $rand_file"
            rm $rand_file
            DELETE_CNTR=0
            INODE_CNTR=$((INODE_CNTR-1))
            continue
        fi

        if [ "$INODE_CNTR" -le "$INODE_USE" ]
        then
#        echo "Inside first if: $CREATE_CNTR"
            if [ "$CREATE_CNTR" -eq "$NUM_THREE" ]
            then
 #               echo "Inside 2nd if"
               THISDATE=`date +"%y%m%d"`
                THISTIME=`date +%s%N`
                THIS=$THISDATE$THISTIME
                RAND=`head -c 500 /dev/urandom | tr -dc 'a-zA-Z0-9~_-' | fold -w 10 | head -n 1`
                UNDER_STR="_"
                OUT_FILE=$dir/$RAND$UNDER_STR$THIS
                #FILE_SZ=`echo "$BLK_SZ * $blk_cnt" | bc`

               echo "Creating: $OUT_FILE"
                sudo dd if=$DEV_DIR of=$OUT_FILE  bs=$STRIPE_SZ count=1 status=none
                sync
                sleep 0.25
                CREATE_CNTR=0

                INODE_CNTR=$((INODE_CNTR+1))
                continue

            fi


        fi

        echo "Modifying: $rand_file"
        blk_cnt=`shuf -i 1-100 -n 1`
        sudo dd if=$DEV_DIR of=$rand_file bs=$STRIPE_SZ count=$blk_cnt status=none
        sync
        sleep 0.25


        DELETE_CNTR=$((DELETE_CNTR+1))
        CREATE_CNTR=$((CREATE_CNTR+1))
        #new_sz=`stat --printf="%s" $rand_file`
        #echo "$rand_file: $file_sz --- $new_sz"
    done

    FS_USED_SZ=`echo $(($(stat -f --format="%a*%S" $MNT_PNT)))`
 
    if [ "$FS_USED_SZ" -ge "$FS_USE_SIZE" ]
    then
        sync
        exit_fnc

    fi
    
    #echo
#done
#sync
#exit 0
<<COMMENT1
    for dir in $WORK_DIR/*/
    do

        dir=${dir%*/}

        if [ $dir == "$WORK_DIR/lost+found" ]
        then
            continue
        fi

        blk_cnt=`shuf -i 1-512 -n 1`
        THISDATE=`date +"%y%m%d"`
        THISTIME=`date +%s%N`
        THIS=$THISDATE$THISTIME
        RAND=`head -c 500 /dev/urandom | tr -dc 'a-zA-Z0-9~_-' | fold -w 10 | head -n 1`
        UNDER_STR="_"
        OUT_FILE=$dir/$RAND$UNDER_STR$THIS
        FILE_SZ=`echo "$BLK_SZ * $blk_cnt" | bc`

        sudo dd if=$DEV_DIR of=$OUT_FILE  bs=$BLK_SZ count=$blk_cnt status=none
        sleep 0.25
        #sudo fallocate -l $FILE_SZ $OUT_FILE

    done 
COMMENT1
done

