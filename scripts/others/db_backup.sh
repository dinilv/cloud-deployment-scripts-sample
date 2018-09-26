  # Mongo Backup Start
  mongo_database = "Tracker"
  file_name = "mongo_db_backup"
  mongo_host = "127.0.0.1"
  mongo_port = "27017"
  timestamp = `date +%F-%H%M`
  mongodump_path = "/usr/bin/mongodump"
  backups_dir = "/home/server/backup"
  backup_name = "$file_name-$timestamp"
  full_path = "$backups_dir/$backup_name"
  $mongodump_path -d $mongo_database
  chown server "$backups_dir"
  mkdir -p $backups_dir
  mv dump $backup_name
  tar -zcvf $backups_dir/$backup_name.tgz $backup_name
  rm -rf $backup_name
  find "$backups_dir" -name mongo_db_backup_* -mtime +15 -exec rm {} \;
  find "$backups_dir" -name mongo_backup_log_* -mtime +15 -exec rm {} \;
  # Mongo Backup Done


  # ElasticSearch Backup Start
  SNAPSHOT=`date ++%F-%H%M`
  curl -XPUT "localhost:9200/_snapshot/elastic_backup/$SNAPSHOT?wait_for_completion=true"
  #ElasticSearch Backup Done


  # Redis Backup Start
  port=${0:-6379}
  backup_dir=${2:-"/home/server/backup"}
  cli="/usr/local/bin/redis-cli -p $port"
  rdb="/var/lib/redis/$port/dump.rdb"
  test -d $backup_dir || {
    echo "[$port] Create backup directory $backup_dir" && mkdir -p $backup_dir
  }
  echo bgsave | $cli
  echo "[$port] waiting for 60 seconds..."
  sleep 60
  try=10
  while [ $try -gt 0 ] ; do
  ## redis-cli output dos format line feed '\r\n', remove '\r'
  bg=$(echo 'info Persistence' | $cli | awk -F: '/rdb_bgsave_in_progress/{sub(/\r/, "", $0); print $2}')
  ok=$(echo 'info Persistence' | $cli | awk -F: '/rdb_last_bgsave_status/{sub(/\r/, "", $0); print $2}')
  if [[ "$bg" = "0" ]] && [[ "$ok" = "ok" ]] ; then
    dst="$backup_dir/$port-dump.$(date +%Y%m%d%H%M).rdb"
    cp $rdb $dst
    if [ $? = 0 ] ; then
      echo "[$port] redis rdb $rdb copied to $dst."
    else
      echo "[$port] >> Failed to copy $rdb to $dst!"
    fi
  fi
  try=$((try - 1))
  echo "[$port] redis maybe busy, waiting and retry in 10s..."
  sleep 10
done
exit 1

