#!/bin/sh
##################################
# SYNC Folder in cloud script    #
# 2016 Giovanni Metitieri        #
##################################
#Setup settings
###
USER="giovanni" #User, useful to find path
SYNC="CLOUD" #The Sync Folder name
CRYFS="CryFSFolder" #The CryFS Folder Name
PASSWORD="password" #Password of CryFS File
FOLDER="folderlist" #File with folder and file, one per line
IGNORE="ignorelist" #File with folder and file, one per line
#Create Directory if not created
###
mkdir -p /home/$USER/$SYNC/$CRYFS
mkdir -p /home/$USER/$CRYFS
#Mount and create config if first time setup
###
export CRYFS_FRONTEND=noninteractive
echo "$PASSWORD" | cryfs /home/$USER/$SYNC/$CRYFS /home/$USER/$CRYFS
#Do Rsync from CLOUD 
###
while read folder; do
        rsync -rtlPu /home/$USER/$CRYFS/$folder /home/$USER/
done < $FOLDER
#Do Rsync to CLOUD
###
while read folder; do
        rsync -rtlPu --exclude-from=$IGNORE /home/$USER/$folder /home/$USER/$CRYFS
done < $FOLDER
#Unmount Filesystem
###
fusermount -u "/home/$USER/$CRYFS"
#Enjoy
###
# Make Backup first of run, you can loose all your data if CryFS fail.
###
