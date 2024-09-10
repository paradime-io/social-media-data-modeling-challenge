############## I wrote this in Hex, added here for reference ##############

# Select only integer columns
int_columns = reponses.select_dtypes(include=["int64", "int32"])

# Calculate the correlation matrix
correlation_matrix = int_columns.corr()

import seaborn as sns
import matplotlib.pyplot as plt

params = {
    "ytick.color": "w",
    "xtick.color": "w",
    "axes.labelcolor": "w",
    "axes.edgecolor": "w",
}
plt.rcParams.update(params)


# Create a heatmap using Seaborn
plt.figure(figsize=(10, 8))
sns.heatmap(
    correlation_matrix,
    annot=True,
    cmap=sns.cubehelix_palette(as_cmap=True),
    center=0,
    vmin=-1,
    vmax=1,
)
plt.title("Correlation Heatmap of Integer Variables in Responses")
plt.show()