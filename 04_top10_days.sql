-- TOP-10 самых «горячих» дней по числу посещений.
-- Посещения считаются независимо от HTTP-статуса (4xx и 5xx тоже посещения).
-- Формат вывода: день - число посещений.
SELECT
    `date`   AS day,
    COUNT(*) AS visits
FROM logs
GROUP BY `date`
ORDER BY visits DESC, day
LIMIT 10;
