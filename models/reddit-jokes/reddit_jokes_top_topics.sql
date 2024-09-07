SELECT
    LOWER(value) AS normalized_value,
    type,
    COUNT(*) AS occurrence
FROM
    jokes_features
GROUP BY
    LOWER(value) ,type
ORDER BY
    occurrence DESC