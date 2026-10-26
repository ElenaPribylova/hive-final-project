-- Справочник гео-ip: ip -> регион.
-- Поля разделены одним символом табуляции.
CREATE EXTERNAL TABLE IF NOT EXISTS ip_regions (
    ip     STRING,
    region STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/data/ip_regions';
