WITH quartiles AS (
    -- Calculate Q1, Q3, and IQR for each metric
    SELECT 
        rhythm,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_play_count) AS q1_play_count,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_play_count) AS q3_play_count,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_shares_count) AS q1_shares_count,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_shares_count) AS q3_shares_count,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_comment_count) AS q1_comment_count,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_comment_count) AS q3_comment_count,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_likes_count) AS q1_likes_count,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_likes_count) AS q3_likes_count
    FROM dbt_msc.fct_tiktok_music_joined_features
    GROUP BY 1
),
filtered_median_values AS (
    SELECT 
        rhythm,
        median(CASE 
            WHEN total_play_count BETWEEN (q1_play_count - 1.5 * (q3_play_count - q1_play_count)) 
                                     AND (q3_play_count + 1.5 * (q3_play_count - q1_play_count)) 
            THEN total_play_count ELSE NULL END) AS median_play_count,
        median(CASE 
            WHEN total_shares_count BETWEEN (q1_shares_count - 1.5 * (q3_shares_count - q1_shares_count)) 
                                       AND (q3_shares_count + 1.5 * (q3_shares_count - q1_shares_count)) 
            THEN total_shares_count ELSE NULL END) AS median_shares_count,
        median(CASE 
            WHEN total_comment_count BETWEEN (q1_comment_count - 1.5 * (q3_comment_count - q1_comment_count)) 
                                       AND (q3_comment_count + 1.5 * (q3_comment_count - q1_comment_count)) 
            THEN total_comment_count ELSE NULL END) AS median_comment_count,
        median(CASE 
            WHEN total_likes_count BETWEEN (q1_likes_count - 1.5 * (q3_likes_count - q1_likes_count)) 
                                     AND (q3_likes_count + 1.5 * (q3_likes_count - q1_likes_count)) 
            THEN total_likes_count ELSE NULL END) AS median_likes_count
    FROM dbt_msc.fct_tiktok_music_joined_features tiktok
    INNER JOIN quartiles ON tiktok.rhythm = quartiles.rhythm
    GROUP BY 1
)
SELECT 
    rhythm, 
    'median_play_count' AS metric, 
    median_play_count AS metric_value
FROM filtered_median_values
UNION ALL
SELECT 
    rhythm, 
    'median_shares_count' AS metric, 
    median_shares_count AS metric_value
FROM filtered_median_values
UNION ALL
SELECT 
    rhythm, 
    'median_comment_count' AS metric, 
    median_comment_count AS metric_value
FROM filtered_median_values
UNION ALL
SELECT 
    rhythm, 
    'median_likes_count' AS metric, 
    median_likes_count AS metric_value
FROM filtered_median_values
ORDER BY 1,2
