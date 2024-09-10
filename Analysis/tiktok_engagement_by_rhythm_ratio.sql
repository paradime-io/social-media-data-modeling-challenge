WITH quartiles AS (
    -- Calculate Q1, Q3, and IQR for each metric
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_likes_count) AS q1_likes,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_likes_count) AS q3_likes,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_shares_count) AS q1_shares,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_shares_count) AS q3_shares,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_comment_count) AS q1_comments,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_comment_count) AS q3_comments,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_play_count) AS q1_plays,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_play_count) AS q3_plays
    FROM dbt_msc.fct_tiktok_music_joined_features
),
filtered_data AS (
    SELECT 
        CASE
            WHEN rhythm < 0.3 THEN '0.0 - 0.3'
            WHEN rhythm >= 0.3 AND rhythm < 0.4 THEN '0.3 - 0.4'
            WHEN rhythm >= 0.4 AND rhythm < 0.5 THEN '0.4 - 0.5'
            WHEN rhythm >= 0.5 AND rhythm < 0.6 THEN '0.5 - 0.6'
            WHEN rhythm >= 0.6 AND rhythm < 0.7 THEN '0.6 - 0.7'
            WHEN rhythm >= 0.7 AND rhythm < 0.8 THEN '0.7 - 0.8'
            WHEN rhythm >= 0.8 AND rhythm < 0.9 THEN '0.8 - 0.9'
            WHEN rhythm >= 0.9 THEN '0.9+'
        END AS rhythm_bin,
        SUM(number_of_videos) AS post_count,
        SUM(CASE 
            WHEN total_likes_count BETWEEN (q1_likes - 1.5 * (q3_likes - q1_likes)) AND (q3_likes + 1.5 * (q3_likes - q1_likes)) 
            THEN total_likes_count ELSE NULL END) AS filtered_likes_count,
        SUM(CASE 
            WHEN total_comment_count BETWEEN (q1_comments - 1.5 * (q3_comments - q1_comments)) AND (q3_comments + 1.5 * (q3_comments - q1_comments)) 
            THEN total_comment_count ELSE NULL END) AS filtered_comment_count,
        SUM(CASE 
            WHEN total_shares_count BETWEEN (q1_shares - 1.5 * (q3_shares - q1_shares)) AND (q3_shares + 1.5 * (q3_shares - q1_shares)) 
            THEN total_shares_count ELSE NULL END) AS filtered_shares_count,
        SUM(CASE 
            WHEN total_play_count BETWEEN (q1_plays - 1.5 * (q3_plays - q1_plays)) AND (q3_plays + 1.5 * (q3_plays - q1_plays)) 
            THEN total_play_count ELSE NULL END) AS filtered_play_count
    FROM dbt_msc.fct_tiktok_music_joined_features
    CROSS JOIN quartiles
    GROUP BY 1
),
total_count AS (
    SELECT SUM(filtered_likes_count) AS total_likes_count_,
           SUM(filtered_shares_count) AS total_shares_count_,
           SUM(filtered_comment_count) AS total_comment_count_,
           SUM(filtered_play_count) AS total_play_count_
    FROM filtered_data
)
SELECT 
    rhythm_bin AS rhythm,
    post_count,
    ROUND(SUM(filtered_likes_count) * 1.0 / (SELECT total_likes_count_ FROM total_count), 4) AS like_ratio,
    ROUND(SUM(filtered_comment_count) * 1.0 / (SELECT total_comment_count_ FROM total_count), 4) AS comment_ratio,
    ROUND(SUM(filtered_shares_count) * 1.0 / (SELECT total_shares_count_ FROM total_count), 4) AS share_ratio,
    ROUND(SUM(filtered_play_count) * 1.0 / (SELECT total_play_count_ FROM total_count), 4) AS play_ratio
FROM filtered_data
ORDER BY 1
