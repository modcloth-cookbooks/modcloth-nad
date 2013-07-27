default[:nad][:interface][:private] = `ifconfig -a | egrep '192.168\|10.[0-9]\|172.16' | grep inet | awk '{print $2}'`.strip.to_s
default[:nad][:autofs][:shares] = ["/net/filer/export/share0", "/net/filer/export/share1"]

default[:nad][:percona][:slow_query_threshold] = 1800
default[:nad][:percona][:ignored_slow_users] = ["root", "replicant", "system user", "pentaho"]
