#!/bin/bash
UBUNTU_VERSION=`cat /etc/issue | awk '{print $2;}'`

contains() {
    string="$1"
    substring="$2"
    if test "${string#*$substring}" != "$string"
    then
        return 0    # $substring is in $string
    else
        return 1    # $substring is not in $string
    fi
}

if contains $UBUNTU_VERSION "12.04";then
    echo "Making Vubuntu Server <$UBUNTU_VERSION>"
elif contains $UBUNTU_VERSION "14.04";then
    echo "Making Vubuntu Server <$UBUNTU_VERSION>"
elif contains $UBUNTU_VERSION "16.04";then
    echo "Making Vubuntu Server <$UBUNTU_VERSION>"
else
    echo "Such Version is not allowed!"
    exit 1
fi
