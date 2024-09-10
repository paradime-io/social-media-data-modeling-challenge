WITH quartiles AS (
    -- Calculate Q1, Q3, and IQR for each metric
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY likes_count) AS q1_likes,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY likes_count) AS q3_likes,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY shares_count) AS q1_shares,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY shares_count) AS q3_shares,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY comment_count) AS q1_comments,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY comment_count) AS q3_comments,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY play_count) AS q1_plays,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY play_count) AS q3_plays
    FROM dbt_msc.dim_tiktok_videos
),
filtered_data AS (
    SELECT 
        CASE 
            WHEN EXTRACT(HOUR FROM created_at) BETWEEN 0 AND 1 THEN '00:00 - 01:59'
            WHEN EXTRACT(HOUR FROM created_at) BETWEEN 2 AND 3 THEN '02:00 - 03:59'
            WHEN EXTRACT(HOUR FROM created_at) BETWEEN 4 AND 5 THEN '04:00 - 05:59'
            WHEN EXTRACT(HOUR FROM created_at) BETWEEN 6 AND 7 THEN '06:00 - 07:59'
            WHEN EXTRACT(HOUR FROM created_at) BETWEEN 8 AND 9 THEN '08:00 - 09:59'
            WHEN EXTRACT(HOUR FROM created_at) BETWEEN 10 AND 11 THEN '10:00 - 11:59'
            WHEN EXTRACT(HOUR FROM created_at) BETWEEN 12 AND 13 THEN '12:00 - 13:59'
            WHEN EXTRACT(HOUR FROM created_at) BETWEEN 14 AND 15 THEN '14:00 - 15:59'
            WHEN EXTRACT(HOUR FROM created_at) BETWEEN 16 AND 17 THEN '16:00 - 17:59'
            WHEN EXTRACT(HOUR FROM created_at) BETWEEN 18 AND 19 THEN '18:00 - 19:59'
            WHEN EXTRACT(HOUR FROM created_at) BETWEEN 20 AND 21 THEN '20:00 - 21:59'
            ELSE '22:00 - 23:59'
        END AS timeslot,
        SUM(CASE 
            WHEN likes_count BETWEEN (q1_likes - 1.5 * (q3_likes - q1_likes)) AND (q3_likes + 1.5 * (q3_likes - q1_likes)) 
            THEN likes_count ELSE NULL END) AS filtered_likes_count,
        SUM(CASE 
            WHEN shares_count BETWEEN (q1_shares - 1.5 * (q3_shares - q1_shares)) AND (q3_shares + 1.5 * (q3_shares - q1_shares)) 
            THEN shares_count ELSE NULL END) AS filtered_shares_count,
        SUM(CASE 
            WHEN comment_count BETWEEN (q1_comments - 1.5 * (q3_comments - q1_comments)) AND (q3_comments + 1.5 * (q3_comments - q1_comments)) 
            THEN comment_count ELSE NULL END) AS filtered_comment_count,
        SUM(CASE 
            WHEN play_count BETWEEN (q1_plays - 1.5 * (q3_plays - q1_plays)) AND (q3_plays + 1.5 * (q3_plays - q1_plays)) 
            THEN play_count ELSE NULL END) AS filtered_play_count
    FROM dbt_msc.dim_tiktok_videos
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
    timeslot,
    ROUND(SUM(filtered_likes_count) * 1.0 / (SELECT total_likes_count_ FROM total_count), 4) AS like_ratio,
    ROUND(SUM(filtered_comment_count) * 1.0 / (SELECT total_comment_count_ FROM total_count), 4) AS comment_ratio,
    ROUND(SUM(filtered_shares_count) * 1.0 / (SELECT total_shares_count_ FROM total_count), 4) AS share_ratio,
    ROUND(SUM(filtered_play_count) * 1.0 / (SELECT total_play_count_ FROM total_count), 4) AS play_ratio
FROM filtered_data
ORDER BY 1
