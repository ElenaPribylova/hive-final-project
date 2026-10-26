-- Посещения в разрезе регионов, дней и платформ.
-- Для каждого региона берётся комбинация (день, платформа) с максимумом посещений,
-- затем выводятся TOP-10 регионов по этому максимуму.
WITH with_platform AS (
    SELECT
        r.region,
        l.`date`,
        CASE
            WHEN l.user_agent LIKE '%iPhone%' OR l.user_agent LIKE '%iPad%' THEN 'iOS'
            WHEN l.user_agent LIKE '%Android%'   THEN 'Android'
            WHEN l.user_agent LIKE '%Macintosh%' THEN 'MacOS'
            WHEN l.user_agent LIKE '%Windows%'   THEN 'Windows'
            WHEN l.user_agent LIKE '%Linux%'     THEN 'Linux'
            ELSE 'Other'
        END AS platform
    FROM logs l
    JOIN ip_regions r ON l.ip = r.ip
),
visits AS (
    SELECT region, `date`, platform, COUNT(*) AS cnt
    FROM with_platform
    GROUP BY region, `date`, platform
),
ranked AS (
    SELECT
        region, `date`, platform, cnt,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY cnt DESC, `date`, platform) AS rn
    FROM visits
)
SELECT
    region,
    platform,
    cnt    AS visits,
    `date` AS day
FROM ranked
WHERE rn = 1
ORDER BY visits DESC, region
LIMIT 10;
