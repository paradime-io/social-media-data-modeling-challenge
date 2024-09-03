
# Social Media Data Analysis - dbt™ Modeling Challenge

## Table of Contents
1. [Introduction](#introduction)
2. [Data Sources](#data-sources)
3. [Methodology](#methodology)
4. [Insights](#insights)
5. [Conclusions](#conclusions)

## Introduction
Goal: Combining Stack Overflow Salary Data with the Big Mac Index to Estimate Purchasing Power

In this analysis, the aim is to estimate the purchasing power of software developers by combining two distinct datasets: salary data from Stack Overflow’s developer survey and the Big Mac Index published by The Economist. The Stack Overflow survey provides detailed salary information for developers across various countries, while the Big Mac Index offers a measure of the relative cost of a Big Mac burger in different countries, serving as a proxy for purchasing power parity (PPP).

By integrating these datasets, one can calculate how many Big Macs a developer’s salary can buy in different countries. This approach allows to compare the real value of salaries globally, adjusting approximately for local cost of living. The resulting insights can help developers understand their relative earning potential and inform decisions about job opportunities and relocations.


## Data Sources
- Dataset 1: Stack Overflow Developer Survey 2024 - A comprehensive survey that gathers insights from developers worldwide on various topics such as technology usage, work habits, salary and community trends.
- Dataset 2: Big Mac Index July 2024 -  An informal measure of purchasing power parity (PPP) between different currencies, created by The Economist in 1986, which compares the price of a Big Mac burger in various countries to determine the relative value of currencies.

### Data Lineage
![alt text](lineage.png "Lineage")

## Methodology
### Tools Used
- Paradime: SQL and dbt™ development
- MotherDuck: Data storage and computing
- Hex: Data visualization
- [Other tools]

### Applied Techniques
- [List key techniques and practices used]

## Insights

### Insight 1
- Title
- Visualization
- Analysis

[Repeat for additional insights]

## Conclusions
[Summarize key findings and their implications]
To compare salaries across countries wh

While accounting for differences in the cost of living, you can use the Big Mac Index as a proxy to adjust salaries, effectively translating them into a "real" salary that reflects purchasing power. Here’s how you can approach this:

### 1. **Calculate the Purchasing Power Parity (PPP) Adjusted Salary**

The basic idea is to adjust the nominal salary in each country by the Big Mac Index to get a sense of what that salary is really worth in terms of purchasing power.

#### Steps:

1. **Nominal Salary**: Start with the nominal (unadjusted) average salary for each country from the Stack Overflow survey.

2. **Big Mac Index**: Use the Big Mac Index as a measure of how expensive it is to live in each country. The Big Mac Index typically provides the cost of a Big Mac in local currency and/or in USD.

3. **Adjustment Formula**:
   - Convert the Big Mac price in each country to a common currency, typically USD (if it’s not already).
   - Calculate the **"Salary to Big Mac Ratio"**: This ratio tells you how many Big Macs a person can buy with their salary, giving a direct measure of purchasing power.
   
   $$
   \text{Adjusted Salary} = \frac{\text{Nominal Salary in USD}}{\text{Big Mac Price in USD}}
   $$

   This gives you the number of Big Macs that the nominal salary can buy. The higher this number, the more purchasing power the salary has.

4. **Comparison Across Countries**:
   - **Adjusted Salary Comparison**: Compare the adjusted salaries across different countries. A higher adjusted salary means that the nominal salary, when adjusted for cost of living, has more purchasing power.
   - **Rank Countries**: Rank the countries based on the adjusted salary to determine where the salary gives the highest purchasing power.

### 2. **Example Calculation**

Let’s consider a simplified example to illustrate the process:

- **Country A (Switzerland):**
  - Nominal Salary: $120,000 USD/year
  - Big Mac Price: $6.50 USD
  - Adjusted Salary: $\frac{120,000}{6.5} \approx 18,462$ Big Macs/year

- **Country B (India):**
  - Nominal Salary: $30,000 USD/year
  - Big Mac Price: $2.50 USD
  - Adjusted Salary: $\frac{30,000}{2.5} = 12,000$ Big Macs/year

In this example, even though Switzerland has a higher nominal salary, the adjusted salary indicates that in terms of purchasing power (using the Big Mac as a proxy), Switzerland is not as advantageous as it might seem compared to India. This reflects the higher cost of living in Switzerland.

### 3. **Combine Work and Living Considerations**

To determine the best combination of working in one country and living in another:

- **Work Country Selection**: Identify the country where the **nominal salary** is highest.
- **Live Country Selection**: Identify the country where the **Big Mac Index** (cost of living) is lowest.

#### Create a Composite Score:

- For each pair of work and live countries, calculate the potential purchasing power by considering how much of the work country’s salary could be spent in the living country:
  
  $$
  \text{Composite Score} = \frac{\text{Nominal Salary in Work Country}}{\text{Big Mac Price in Live Country}}
  $$

- This score indicates how many Big Macs you could buy if you earned a salary in one country and lived in another, giving you a measure of the best work-live combination.

### 4. **Visualization and Interpretation**

- **Heatmap**: Create a heatmap that visualizes the composite scores for each combination of work and live countries, making it easy to identify the best options.
  
- **Bar Charts**: Display adjusted salaries side-by-side for different countries to show the effect of the cost of living.

### 5. **Discussion of Insights**

- **Purchasing Power vs. Nominal Salary**: Explain how nominal salary can be misleading without considering purchasing power. For example, even though salaries in Switzerland are high, the high cost of living reduces the actual value of that salary.
  
- **Best Combinations**: Discuss the optimal combinations of countries for working and living based on the composite score, and the potential trade-offs involved.

By using this method, you can better understand the real value of salaries across different countries and how to maximize your standard of living by considering both where you work and where you live.
