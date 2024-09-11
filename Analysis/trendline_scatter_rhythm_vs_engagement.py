#Source dataframe_22 which uses
# median_enagegement_by_rhythm.sql 

import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

metric_label_mapping = {
    "median_likes_count": "Median Likes Count",
    "median_play_count": "Median Play Count",
    "median_comment_count": "Median Comment Count",
    "median_shares_count": "Median Shares Count"
}

dataframe_22['metric'] = dataframe_22['metric'].map(metric_label_mapping)
dataframe_22 = dataframe_22.dropna(subset=['metric'])  

sns.set_style("whitegrid")

g = sns.FacetGrid(dataframe_22, col="metric", height=6, aspect=1.2, col_wrap=2)
g.map(sns.scatterplot, "rhythm", "metric_value", color="#1f77b4", s=70)  

# Adding trendlines to each subplot
for ax in g.axes.flat:
    metric = ax.get_title().split('=')[1].strip()  
    sns.regplot(
        x='rhythm', y='metric_value',
        data=dataframe_22[dataframe_22['metric'] == metric],
        ax=ax, scatter=False, color='#2f4f4f', ci=None, line_kws={'linewidth': 1.5} 
    )

# Set the x-axis and y-axis to log scale
for ax in g.axes.flat:
    ax.set_xscale('log')
    ax.set_yscale('log')
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.spines['left'].set_color('#333333')  
    ax.spines['bottom'].set_color('#333333')
    ax.tick_params(colors='#333333')  

#Titles and label 
g.set_axis_labels("rhythm", "Metric Value", fontsize=13, color="#333333")
g.fig.subplots_adjust(top=0.85, hspace=0.3)  
g.fig.suptitle("rhythm vs. Engagement Metrics (Log Scale)", fontsize=18, color="#333333", weight='bold')

for ax in g.axes.flat:
    ax.grid(True, which="both", color="#D3D3D3", linewidth=0.6)

# fonts
plt.xticks(fontsize=11, color="#333333")
plt.yticks(fontsize=11, color="#333333")

plt.show()
