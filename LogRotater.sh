#!/bin/bash

#path to logfile that needs to be rotated#
log=/var/log/php-mail.log

#Set your ownership variable#
owner=mailnull:mail

#Set permissions for created logfile#
perm=666

#find log files older than two days and force gzip to compress
for file in `find $log -atime +2`; do echo $file is older than 2 days and is being compressed; gzip -f9 $file; done

#If the logfile does not exist, create one!
if ! [ -f $log ]; then echo "The specified logfile $log does not exist, creating one now! ";
touch $log
chown $owner $log
chmod $perm $log
chattr +A $log
fi

#Append date to compressed logfile
if [ -s $log.gz ];
then
mv $log.gz $log`date +%Y%m%d`.gz
fi

###Remove $log.gz older than 30 days###
for old in `find $log* -mtime +30`; do echo $old is older than 30 days... removing; rm -f $old; done
