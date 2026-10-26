-- Сырые логи в исходном виде.
-- Поля разделены табуляцией, причём иногда не одной, поэтому вместо
-- FIELDS TERMINATED BY используется RegexSerDe: \t+ означает «одна или несколько табуляций».
-- RegexSerDe поддерживает только STRING, типы приводятся в таблице logs.
CREATE EXTERNAL TABLE IF NOT EXISTS logs_raw (
    ip          STRING,
    `datetime`  STRING,
    request     STRING,
    page_size   STRING,
    http_status STRING,
    user_agent  STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
    "input.regex" = "^([^\\t]+)\\t+([^\\t]+)\\t+([^\\t]+)\\t+([^\\t]+)\\t+([^\\t]+)\\t+(.*)$"
)
STORED AS TEXTFILE
LOCATION '/data/logs_raw';
