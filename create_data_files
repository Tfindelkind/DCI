#!/bin/bash
#
# Copyright (c) 2016 Thomas Findelkind
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.
#
# MORE ABOUT THIS SCRIPT AVAILABLE IN THE README AND AT:
#
# http://tfindelkind.com
#
# ---------------------------------------------------------------------------- #

# AMAZON S3 INFORMATION
export AWS_ACCESS_KEY_ID="foobar_aws_key_id"
export AWS_SECRET_ACCESS_KEY="foobar_aws_access_key"

# If you aren't running this from a cron, comment this line out
# and duplicity should prompt you for your password.
export PASSPHRASE="foobar_gpg_passphrase"

# Specify which GPG key you would like to use (even if you have only one).
GPG_KEY="foobar_gpg_key"

# The ROOT of your backup (where you want the backup to start);
# This can be / or somwhere else -- I use /home/ because all the
# directories start with /home/ that I want to backup.
ROOT="/home/"

# BACKUP DESTINATION INFORMATION
# In my case, I use Amazon S3 use this - so I made up a unique
# bucket name (you don't have to have one created, it will do it
# for you).  If you don't want to use Amazon S3, you can backup
# to a file or any of duplicity's supported outputs.
#
# NOTE: You do need to keep the "s3+http://<your location>/" format
# even though duplicity supports "s3://<your location>/".
#DEST="s3+http://backup-bucket/backup-folder/"
DEST="file:///home/foobar_user_name/new-backup-test/"

# INCLUDE LIST OF DIRECTORIES
# Here is a list of directories to include; if you want to include
# everything that is in root, you could leave this list empty (I think).
#
# Here is an example with multiple locations:
#INCLIST=(  "/home/*/Documents" \
#           "/home/*/Projects" \
#           "/home/*/logs" \
#           "/home/www/mysql-backups" \
#        )
#
# Simpler example with one location:
INCLIST=( "/home/foobar_user_name/Documents/Prose/" ) 

# EXCLUDE LIST OF DIRECTORIES
# Even though I am being specific about what I want to include,
# there is still a lot of stuff I don't need.
EXCLIST=(   "/home/*/Trash" \
            "/home/*/Projects/Completed" \
            "/**.DS_Store" "/**Icon?" "/**.AppleDouble" \
        )

# STATIC BACKUP OPTIONS
# Here you can define the static backup options that you want to run with
# duplicity.  I use both the `--full-if-older-than` option plus the
# `--s3-use-new-style` option (for European buckets).  Be sure to separate your
# options with appropriate spacing.
STATIC_OPTIONS="--full-if-older-than 14D --s3-use-new-style"

# FULL BACKUP & REMOVE OLDER THAN SETTINGS
# Because duplicity will continue to add to each backup as you go,
# it will eventually create a very large set of files.  Also, incremental
# backups leave room for problems in the chain, so doing a "full"
# backup every so often isn't not a bad idea.
#
# You can either remove older than a specific time period:
#CLEAN_UP_TYPE="remove-older-than"
#CLEAN_UP_VARIABLE="31D"

# Or, If you would rather keep a certain (n) number of full backups (rather
# than removing the files based on their age), you can use what I use:
CLEAN_UP_TYPE="remove-all-but-n-full"
CLEAN_UP_VARIABLE="2"

# LOGFILE INFORMATION DIRECTORY
# Provide directory for logfile, ownership of logfile, and verbosity level.
# I run this script as root, but save the log files under my user name --
# just makes it easier for me to read them and delete them as needed.

LOGDIR="/home/foobar_user_name/logs/test2/"
LOG_FILE="duplicity-`date +%Y-%m-%d_%H-%M`.txt"
LOG_FILE_OWNER="foobar_user_name:foobar_user_name"
VERBOSITY="-v3"

# EMAIL ALERT (*thanks: rmarescu*)
# Provide an email address to receive the logfile by email. If no email
# address is provided, no alert will be sent.
# You can set a custom from email address and a custom subject (both optionally)
# If no value is provided for the subject, the following value will be
# used by default: "DT-S3 Alert ${LOG_FILE}"
# MTA used: mailx
#EMAIL="admin@example.com"
EMAIL_TO=
EMAIL_FROM=
EMAIL_SUBJECT=

# TROUBLESHOOTING: If you are having any problems running this script it is
# helpful to see the command output that is being generated to determine if the
# script is causing a problem or if it is an issue with duplicity (or your
# setup).  Simply  uncomment the ECHO line below and the commands will be
# printed to the logfile.  This way, you can see if the problem is with the
# script or with duplicity.
#ECHO=$(which echo)






## create user-data and meta-data files that will be used
## to modify image on first boot
cat << EOF > meta-data
instance-id: iid-NutanixCE-backup
network-interfaces: |
 auto eth0
 iface eth0 inet static 
 address 192.168.178.201  
 network 192.168.178.0 
 netmask 255.255.255.0  
 broadcast 192.168.178.255  
 gateway 192.168.178.1
local-hostname: NTNXCE-BACKUP  
EOF

cat << EOF > user-data
#cloud-config
output: {all: '| tee -a /var/log/cloud-init-output.log'}
package_upgrade: true
password: nutanix/4u
chpasswd: { expire: False }
ssh_pwauth: True
bootcmd: 
- echo "nameserver 192.168.178.1" | sudo tee -a /etc/resolvconf/resolv.conf.d/head 
- sudo resolvconf -u 
runcmd:
- sudo ifup eth0
- sudo apt-get install apt-transport-https ca-certificates
- sudo sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
- echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list
- sudo apt-get update
- sudo apt-get install -y linux-image-extra-$(uname -r)
- sudo apt-get install -y docker-engine
- sudo service docker start
final_message: "The system is finally up, after $UPTIME seconds"
EOF

## create a disk to attach with some user-data and meta-data
genisoimage -output seed.iso -volid cidata -joliet -rock user-data meta-data
