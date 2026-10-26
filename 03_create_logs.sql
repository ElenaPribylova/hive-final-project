-- Таблица logs: типизированные данные с партиционированием по дню.
-- LOCATION не указывается, используется путь по умолчанию (warehouse).

SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
-- В данных 731 день: поднимаем лимиты динамических партиций (по умолчанию 1000 всего и 100 на узел).
SET hive.exec.max.dynamic.partitions=2000;
SET hive.exec.max.dynamic.partitions.pernode=2000;
-- Сортировка по ключу партиции: при записи открыт один файл за раз, а не сотни.
SET hive.optimize.sort.dynamic.partition=true;

CREATE TABLE IF NOT EXISTS logs (
    ip          STRING,
    `datetime`  TIMESTAMP,
    request     STRING,
    page_size   INT,
    http_status INT,
    user_agent  STRING
)
PARTITIONED BY (`date` STRING);

INSERT OVERWRITE TABLE logs PARTITION (`date`)
SELECT
    ip,
    CAST(from_unixtime(unix_timestamp(`datetime`, 'yyyyMMddHHmmss')) AS TIMESTAMP) AS `datetime`,
    request,
    CAST(page_size AS INT)   AS page_size,
    CAST(http_status AS INT) AS http_status,
    user_agent,
    SUBSTR(`datetime`, 1, 8) AS `date`   -- день в формате YYYYMMDD
FROM logs_raw;
