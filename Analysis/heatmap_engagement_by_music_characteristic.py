# source dataframe_14 which uses
# SELECT * FROM dbt_msc.mrt_tiktok_music_correlation 

import warnings
import matplotlib.pyplot as plt
import seaborn as sns

warnings.filterwarnings("ignore", category=FutureWarning)  

# remove outliers using IQR 
def remove_outliers_iqr(df):
    for column in df.select_dtypes(include=['float', 'int']).columns:  
        Q1 = df[column].quantile(0.25)
        Q3 = df[column].quantile(0.75)
        IQR = Q3 - Q1
        lower_bound = Q1 - 1.5 * IQR
        upper_bound = Q3 + 1.5 * IQR
        df = df[(df[column] >= lower_bound) & (df[column] <= upper_bound)]
    return df

# Apply IQR-based outlier removal
dataframe_14 = remove_outliers_iqr(dataframe_14)

tiktok_metric_labels = {
    'total_shares_count': 'Total Shares',
    'total_likes_count': 'Total Likes',
    'total_play_count': 'Total Plays',
    'total_comment_count': 'Total Comments'
}

music_feature_labels = {
    'popularity_quartile_corr': 'Popularity Quartile',
    'genre_value_corr': 'Genre Value',
    'intensity_quartile_corr': 'Intensity Quartile',
    'rhythm_quartile_corr': 'Rhythm Quartile',
    'sound_type_quartile_corr': 'Sound Type Quartile',
    'liveness_quartile_corr': 'Liveness Quartile',
    'beats_per_bar_quartile_corr': 'Beats per Bar Quartile'
}

heatmap_data_binned = dataframe_14.set_index('tiktok_metric')

heatmap_data_binned = heatmap_data_binned.rename(index=tiktok_metric_labels, columns=music_feature_labels)

plt.figure(figsize=(14, 8), facecolor="white")

# Plot heatmap
ax = sns.heatmap(
    heatmap_data_binned,
    annot=True,  
    fmt=".2f",   
    cmap="Blues",  
    linewidths=0.8,  
    linecolor="gray",
    cbar_kws={"label": "Correlation Value"},  
    vmin=-0.2, vmax=0.2  

# Text and fonts
plt.title("Correlation Heatmap Between TikTok Metrics and Music Features", fontsize=16, color="black", pad=20)
plt.xlabel("Music Features", fontsize=12, color="black", labelpad=10)
plt.ylabel("TikTok Metrics", fontsize=12, color="black", labelpad=10)
plt.xticks(rotation=45, color="black", fontsize=11)
plt.yticks(rotation=0, color="black", fontsize=11)

# Ticks and labels
colorbar = ax.collections[0].colorbar
colorbar.ax.yaxis.set_tick_params(color='black')  
colorbar.set_label('Correlation Value', color='black') 
plt.setp(colorbar.ax.get_yticklabels(), color="black", fontsize=11)  

plt.tight_layout(pad=2.5)

plt.show()
