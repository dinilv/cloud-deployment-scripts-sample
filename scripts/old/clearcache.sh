#!/bin/sh
BACKUPS_DIR="/home/adcamie/scripts/cache-log"
LOGFILE="$BACKUPS_DIR/"memory_log_"$(date +'%Y_%m_%d_%H_%M')".txt
FREE_DATA=`free -m`
echo "Cache clearing operation started at $(date +'%d-%m-%Y %H:%M:%S')" >> "$LOGFILE"
echo "Memory usage at the time of cache clearing" >> "$LOGFILE"
echo Usage: $FREE_DATA >> "$LOGFILE"
sudo sysctl -w vm.drop_caches=3
FREE_DATA=`free -m`
echo Usage: $FREE_DATA >> "$LOGFILE"
chown adcamie "$LOGFILE"
echo "Started removing old files at $(date +'%d-%m-%Y %H:%M:%S')" >> "$LOGFILE"
find "$BACKUPS_DIR" -name memory_log_* -mtime +15 -exec rm {} \;
echo "Finished removing old files at $(date +'%d-%m-%Y %H:%M:%S')" >> "$LOGFILE"
echo "Finished cache clearing at $(date +'%d-%m-%Y %H:%M:%S')" >> "$LOGFILE"
