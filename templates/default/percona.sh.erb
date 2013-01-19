#!/usr/bin/bash

PATH="/mysql/bin:/opt/local/bin:/opt/local/sbin:/usr/bin:/usr/sbin";

SQL_STATS_RAW=`mysql -u root -e "select 'variables', queries, cache_hits, cache_free_blocks, cache_free_memory, cache_inserts, cache_lowmem_prunes, cache_not_cached, cache_queries_in_cache, cache_total_blocks, tmp_tables, tmp_disk_tables, tmp_files, max_connections, (total_used - active_connections) as idle_connections, active_connections, current_lock_waits, lock_time, total_lock_waits, spin_waits, spin_rounds, os_waits, selects, inserts, updates, deletes from (select variable_value as total_used from information_schema.global_status where variable_name='THREADS_CONNECTED') total_used, (select variable_value as max_connections from information_schema.global_variables where variable_name='MAX_CONNECTIONS') max_connections, (select variable_value as active_connections from information_schema.global_status where variable_name='THREADS_RUNNING') active_connections, (select variable_value as queries from information_schema.global_status where variable_name='QUERIES') queries, (select variable_value as cache_hits from information_schema.global_status where variable_name='QCACHE_HITS') cache_hits, (select variable_value as current_lock_waits from information_schema.global_status where variable_name='INNODB_ROW_LOCK_CURRENT_WAITS') current_lock_waits, (select variable_value as lock_time from information_schema.global_status where variable_name='INNODB_ROW_LOCK_TIME') lock_time, (select variable_value as total_lock_waits from information_schema.global_status where variable_name='INNODB_ROW_LOCK_WAITS') lock_waits, (select variable_value as spin_waits from information_schema.global_status where variable_name='INNODB_MUTEX_SPIN_WAITS') spin_waits, (select variable_value as spin_rounds from information_schema.global_status where variable_name='INNODB_MUTEX_SPIN_ROUNDS') spin_rounds, (select variable_value as os_waits from information_schema.global_status where variable_name='INNODB_MUTEX_OS_WAITS') os_waits, (select variable_value as selects from information_schema.global_status where variable_name='COM_SELECT') selects, (select variable_value as inserts from information_schema.global_status where variable_name='COM_INSERT') inserts, (select variable_value as updates from information_schema.global_status where variable_name='COM_UPDATE') updates, (select variable_value as deletes from information_schema.global_status where variable_name='COM_DELETE') deletes, (select variable_value as cache_free_blocks from information_schema.global_status where variable_name='QCACHE_FREE_BLOCKS') cache_free_blocks, (select variable_value as cache_free_memory from information_schema.global_status where variable_name='QCACHE_FREE_MEMORY') cache_free_memory, (select variable_value as cache_inserts from information_schema.global_status where variable_name='QCACHE_INSERTS') cache_inserts, (select variable_value as cache_lowmem_prunes from information_schema.global_status where variable_name='QCACHE_LOWMEM_PRUNES') cache_lowmem_prunes, (select variable_value as cache_not_cached from information_schema.global_status where variable_name='QCACHE_NOT_CACHED') cache_not_cached, (select variable_value as cache_queries_in_cache from information_schema.global_status where variable_name='QCACHE_QUERIES_IN_CACHE') cache_queries_in_cache, (select variable_value as cache_total_blocks from information_schema.global_status where variable_name='QCACHE_TOTAL_BLOCKS') cache_total_blocks, (select variable_value as tmp_tables from information_schema.global_status where variable_name='CREATED_TMP_TABLES') tmp_tables, (select variable_value as tmp_disk_tables from information_schema.global_status where variable_name='CREATED_TMP_DISK_TABLES') tmp_disk_tables, (select variable_value as tmp_files from information_schema.global_status where variable_name='CREATED_TMP_FILES') tmp_files;" | head -4 | tail -1`
SLAVE_IO_RAW=`mysql -u root -e "show slave status\G;" | grep "Slave_IO_Running" | awk '{print $2}'`
SLAVE_SQL_RAW=`mysql -u root -e "show slave status\G;" | grep "Slave_SQL_Running" | awk '{print $2}'`
SECONDS_BEHIND_MASTER=`mysql -u root -e "show slave status\G;" | grep "Seconds_Behind_Master" | awk '{print $2}'`

QUERIES=`echo "${SQL_STATS_RAW}" | awk '{print $2}'`
CACHE_HITS=`echo "${SQL_STATS_RAW}" | awk '{print $3}'`
CACHE_FREE_BLOCKS=`echo "${SQL_STATS_RAW}" | awk '{print $4}'`
CACHE_FREE_MEMORY=`echo "${SQL_STATS_RAW}" | awk '{print $5}'`
CACHE_INSERTS=`echo "${SQL_STATS_RAW}" | awk '{print $6}'`
CACHE_LOWMEM_PRUNES=`echo "${SQL_STATS_RAW}" | awk '{print $7}'`
CACHE_NOT_CACHED=`echo "${SQL_STATS_RAW}" | awk '{print $8}'`
CACHE_QUERIES_IN_CACHE=`echo "${SQL_STATS_RAW}" | awk '{print $9}'`
CACHE_TOTAL_BLOCKS=`echo "${SQL_STATS_RAW}" | awk '{print $10}'`
TMP_TABLES=`echo "${SQL_STATS_RAW}" | awk '{print $11}'`
TMP_DISK_TABLES=`echo "${SQL_STATS_RAW}" | awk '{print $12}'`
TMP_FILES=`echo "${SQL_STATS_RAW}" | awk '{print $13}'`
MAX_CONNECTIONS=`echo "${SQL_STATS_RAW}" | awk '{print $14}'`
IDLE_CONNECTIONS=`echo "${SQL_STATS_RAW}" | awk '{print $15}'`
ACTIVE_CONNECTIONS=`echo "${SQL_STATS_RAW}" | awk '{print $16}'`
CURRENT_LOCK_WAITS=`echo "${SQL_STATS_RAW}" | awk '{print $17}'`
LOCK_TIME=`echo "${SQL_STATS_RAW}" | awk '{print $18}'`
TOTAL_LOCK_WAITS=`echo "${SQL_STATS_RAW}" | awk '{print $19}'`
SPIN_WAITS=`echo "${SQL_STATS_RAW}" | awk '{print $20}'`
SPIN_ROUNDS=`echo "${SQL_STATS_RAW}" | awk '{print $21}'`
OS_WAITS=`echo "${SQL_STATS_RAW}" | awk '{print $22}'`
SELECTS=`echo "${SQL_STATS_RAW}" | awk '{print $23}'`
INSERTS=`echo "${SQL_STATS_RAW}" | awk '{print $24}'`
UPDATES=`echo "${SQL_STATS_RAW}" | awk '{print $25}'`
DELETES=`echo "${SQL_STATS_RAW}" | awk '{print $26}'`

if [ "${SLAVE_IO_RAW}" =  "Yes" ]; then
  SLAVE_IO="1"
else
  SLAVE_IO="0"
fi

if [ "${SLAVE_SQL_RAW}" =  "Yes" ]; then
  SLAVE_SQL="1"
else
  SLAVE_SQL="0"
fi

PREFIX="percona:0:status:"

echo -e "${PREFIX}queries\ti\t${QUERIES}"
echo -e "${PREFIX}cache_hits\ti\t${CACHE_HITS}"
echo -e "${PREFIX}cache_free_blocks\ti\t${CACHE_FREE_BLOCKS}"
echo -e "${PREFIX}cache_free_memory\tL\t${CACHE_FREE_MEMORY}"
echo -e "${PREFIX}cache_inserts\ti\t${CACHE_INSERTS}"
echo -e "${PREFIX}cache_lowmem_prunes\ti\t${CACHE_LOWMEM_PRUNES}"
echo -e "${PREFIX}cache_not_cached\ti\t${CACHE_NOT_CACHED}"
echo -e "${PREFIX}cache_queries_in_cache\ti\t${CACHE_QUERIES_IN_CACHE}"
echo -e "${PREFIX}cache_total_blocks\ti\t${CACHE_TOTAL_BLOCKS}"
echo -e "${PREFIX}tmp_tables\ti\t${TMP_TABLES}"
echo -e "${PREFIX}tmp_disk_tables\ti\t${TMP_DISK_TABLES}"
echo -e "${PREFIX}tmp_files\ti\t${TMP_FILES}"
echo -e "${PREFIX}max_connections\ti\t${MAX_CONNECTIONS}"
echo -e "${PREFIX}idle_connections\ti\t${IDLE_CONNECTIONS}"
echo -e "${PREFIX}active_connections\ti\t${ACTIVE_CONNECTIONS}"
echo -e "${PREFIX}current_lock_waits\ti\t${CURRENT_LOCK_WAITS}"
echo -e "${PREFIX}lock_time\tn\t${LOCK_TIME}"
echo -e "${PREFIX}total_lock_waits\ti\t${TOTAL_LOCK_WAITS}"
echo -e "${PREFIX}spin_waits\ti\t${SPIN_WAITS}"
echo -e "${PREFIX}spin_rounds\ti\t${SPIN_ROUNDS}"
echo -e "${PREFIX}os_waits\ti\t${OS_WAITS}"
echo -e "${PREFIX}selects\ti\t${SELECTS}"
echo -e "${PREFIX}inserts\ti\t${INSERTS}"
echo -e "${PREFIX}updates\ti\t${UPDATES}"
echo -e "${PREFIX}deletes\ti\t${DELETES}"
echo -e "${PREFIX}slave_io\ti\t${SLAVE_IO}"
echo -e "${PREFIX}slave_sql\ti\t${SLAVE_SQL}"
echo -e "${PREFIX}seconds_behind_master\ti\t${SECONDS_BEHIND_MASTER}"
