#!/bin/bash
# Загрузка исходных файлов в HDFS.
# Каждый файл кладётся в отдельную папку: LOCATION external-таблицы указывает на папку.
hdfs dfs -mkdir -p /data/ip_regions /data/logs_raw
hdfs dfs -put -f /tmp/ipDataM.txt /data/ip_regions/
hdfs dfs -put -f /tmp/logsM.txt /data/logs_raw/
hdfs dfs -ls /data/ip_regions /data/logs_raw
