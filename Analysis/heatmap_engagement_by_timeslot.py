# source dataframe_9 which uses
# tiktok_engagement_by_timeslot.sql

import warnings
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

warnings.filterwarnings("ignore", category=FutureWarning) 

# Creating engagement ratio
dataframe_9["engagement_ratio"] = (
    dataframe_9["like_ratio"] + dataframe_9["share_ratio"] + dataframe_9["play_ratio"] + dataframe_9["comment_ratio"]
) / 4  

# Pivot the data for the heatmap (with engagement_ratio on the y-axis and timeslot on the x-axis)
heatmap_data = dataframe_9.pivot(
    index="engagement_ratio", columns="timeslot", values="post_count"
).fillna(0)

# Plot the heatmap
plt.figure(figsize=(14, 8))
ax = sns.heatmap(
    heatmap_data,
    annot=True,  
    fmt=".0f",   
    cmap="Blues", 
    linewidths=0.8,  
    linecolor="gray",
    cbar_kws={"label": "Number of Posts"},  
)

# text and fonts
plt.title("Heatmap of Posts by Engagement Ratio and Timeslot", fontsize=16, color="#4F4F4F", pad=20)
plt.xlabel("Timeslot", fontsize=12, color="#4F4F4F", labelpad=10)
plt.ylabel("Engagement Ratio", fontsize=12, color="#4F4F4F", labelpad=10)
plt.xticks(rotation=45, color="#4F4F4F", fontsize=11)
plt.yticks(rotation=0, color="#4F4F4F", fontsize=11)

# ticks and labels
colorbar = ax.collections[0].colorbar
colorbar.ax.yaxis.set_tick_params(color='#4F4F4F')  
colorbar.set_label('Number of Posts', color='#4F4F4F')  
plt.setp(colorbar.ax.get_yticklabels(), color="#4F4F4F", fontsize=11)  

plt.tight_layout(pad=2.5)

plt.show()
