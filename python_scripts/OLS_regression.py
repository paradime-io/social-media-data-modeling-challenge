############## I wrote this in Hex, added here for reference ##############

import pandas as pd
import statsmodels.api as sm

# Filter DataFrame to include only rows where gender is Male or Female
filtered_responses = responses_by_platform[
    responses_by_platform['Gender'].isin(['Male', 'Female'])
]

# Create a mental health score by summing the relevant columns
filtered_responses["mental_health_score"] = (
    filtered_responses[
        [
            "worry_scale",
            "restlessness",
            "health_issues",
            "purposeless_use",
            "validation_seek",
            "comparison_scale",
            "distraction_scale",
            "comparison_feelings",
            "depression_frequency",
            "interest_fluctuation",
            "distraction_frequency",
            "concentration_difficulty",
        ]
    ]
    .sum(axis=1)
    .astype(int)
)

# Rename 'platform_count' to avoid conflicts
filtered_responses.rename(columns={"platform_count": "count_platform"}, inplace=True)

# Convert 'Gender', 'Relationship', and 'platform' to dummy/indicator variables
filtered_responses_dummies = pd.get_dummies(filtered_responses, columns=["Gender", "Relationship", "platform"], drop_first=True)

# Define the independent variables (X) and the dependent variable (y)
# Include the renamed 'platform_count_original' column and all dummy variables
X = filtered_responses_dummies[
    [
        "Age",
        "daily_time",
        "count_platform",  # Use the renamed column here
    ]
]

# Add the encoded categorical variables for gender, relationship, and platform
categorical_vars = [col for col in filtered_responses_dummies.columns if col.startswith("Gender_") or col.startswith("Relationship_") or col.startswith("platform_")]
X = pd.concat([X, filtered_responses_dummies[categorical_vars]], axis=1)

# Define the dependent variable (y)
y = filtered_responses_dummies["mental_health_score"]

# Add a constant to the independent variables matrix
X = sm.add_constant(X, has_constant="add")

# Fit the OLS model
model = sm.OLS(y, X).fit()

# Print the model summary to investigate the influences
print(model.summary())