#!/usr/bin/env bash

# stop on error
set -eu

# mount the drive
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 $EFS_ID.efs.$AWS_DEFAULT_REGION.amazonaws.com:/ /efs

# create a compressed version
cd /var/tmp
tar -zcvf $EFS_NAME.tar.gz /efs

# unmount just to be on the safe side
umount /efs

# copy everything to s3
aws s3 cp $EFS_NAME.tar.gz s3://$S3_BUCKET/efs/$EFS_NAME.`date +"%Y%m%d"`.tar.gz