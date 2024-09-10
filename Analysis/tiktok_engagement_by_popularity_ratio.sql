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
            WHEN popularity BETWEEN 0 AND 8 THEN '0-8'
            WHEN popularity BETWEEN 9 AND 17 THEN '09-17'
            WHEN popularity BETWEEN 18 AND 26 THEN '18-26'
            WHEN popularity BETWEEN 27 AND 34 THEN '27-34'
            WHEN popularity BETWEEN 35 AND 43 THEN '35-43'
            WHEN popularity BETWEEN 44 AND 52 THEN '44-52'
            WHEN popularity BETWEEN 53 AND 60 THEN '53-60'
            WHEN popularity BETWEEN 61 AND 69 THEN '61-69'
            WHEN popularity BETWEEN 70 AND 78 THEN '70-78'
            ELSE '79-87'
        END AS popularity_bin,
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
    popularity_bin,
    post_count,
    ROUND(SUM(filtered_likes_count) * 1.0 / (SELECT total_likes_count_ FROM total_count), 4) AS like_ratio,
    ROUND(SUM(filtered_comment_count) * 1.0 / (SELECT total_comment_count_ FROM total_count), 4) AS comment_ratio,
    ROUND(SUM(filtered_shares_count) * 1.0 / (SELECT total_shares_count_ FROM total_count), 4) AS share_ratio,
    ROUND(SUM(filtered_play_count) * 1.0 / (SELECT total_play_count_ FROM total_count), 4) AS play_ratio
FROM filtered_data
ORDER BY 1
