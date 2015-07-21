#!/bin/bash
 
echo "/home/*/node/*.log {
  daily         # how often to rotate
  rotate 10     # max num of log files to keep
  missingok     # don't panic if the log file doesn't exist
  notifempty    # ignore empty files
  compress      # compress rotated log file with gzip
  sharedscripts # postrotate script (if any) will be run only once at the end, not once for each rotated log
  copytruncate  # needed for forever to work properly
  dateext       # adds date to filename 
  dateformat %Y-%m-%d.
}" > /etc/logrotate.d/node