# zpool_status
Shell script to parse the output of ZoL zpool status 

#Requires
- [Prometheus](https://prometheus.io)
- [Prometheus Node Exporter] (https://github.com/prometheus/node_exporter). 

#Usage
Set $ZFS_PROMETHEUS_COLLECTOR_PATH to the filename used for data collection by Node exporter. 
This is the ```collector.textfile.directory``` flag in the exporter configuration. By default, will automatically collect files ending in ```*.prom```

Systemd service unit and timer are available as well
