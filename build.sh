#!/bin/bash
BO=-x
BO=

COUNTER=1
for sh in `ls [0-9]*.sh`;do
    echo -n "starting $sh..."
    bash $BO $sh
    if [ $? -ne 0 ];then
        echo "$? error!"
        exit $COUNTER
    fi
    COUNTER=$[$COUNTER + 1]
    echo " done!"
done
exit 0
