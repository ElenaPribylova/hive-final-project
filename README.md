# Итоговое задание: Apache Hive

Анализ логов посещений маркетплейсов (`logsM.txt`) с гео-привязкой IP (`ipDataM.txt`).

## Структура

| Файл | Что делает |
|---|---|
| `00_load_to_hdfs.sh` | Загружает исходные файлы в HDFS (`/data/ip_regions`, `/data/logs_raw`) |
| `01_create_ip_regions.sql` | External-таблица `ip_regions` |
| `02_create_logs_raw.sql` | External-таблица `logs_raw` (RegexSerDe: поля разделены одной или несколькими табуляциями) |
| `03_create_logs.sql` | Таблица `logs` с типами и партиционированием по `date` (YYYYMMDD), заполнение из `logs_raw` |
| `04_top10_days.sql` | TOP-10 дней по числу посещений |
| `05_top10_regions_platforms.sql` | TOP-10 регионов с платформой и числом посещений |

## Запуск

Внутри контейнера `hive-server` (исходные файлы предварительно скопированы в `/tmp`):

```bash
bash 00_load_to_hdfs.sh
for f in 01_create_ip_regions.sql 02_create_logs_raw.sql 03_create_logs.sql \
         04_top10_days.sql 05_top10_regions_platforms.sql; do
    hive -e "$(cat $f)"
done
```

## Решения

- **Платформа** определяется по `user_agent`. `iPhone`/`iPad` проверяются раньше `Macintosh`, так как user agent iPhone содержит строку `like Mac OS X`.
- **Посещения** считаются по всем строкам лога, без фильтра по `http_status`.
- **При равенстве** числа посещений сортировка дополнительно идёт по дню или названию региона, чтобы результат был детерминированным.
