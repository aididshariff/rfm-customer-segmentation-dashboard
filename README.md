# Customer Segmentation using RFM Analysis

This project applies **RFM (Recency, Frequency, Monetary)** analysis to segment customers based on their purchasing behavior.

---

# Objective

To help businesses identify high-value customer groups and personalize marketing strategies accordingly.

---

# Tools Used

**R** - Data cleaning, transformation, and RFM scoring
**Tableau** - Dashboard development and visualization
**csv dataset** -Online Retail transactional data

---

# Dataset

The dataset used is a publicly available online retail transaction dataset containing:
- Invoice details
- Customer IDs
- Product quantities and prices
- Invoice dates

  *Source:* [UCI Online Retail Data Set](https://archive.ics.uci.edu/ml/datasets/online+retail)

---

   # Data Preparation (in R)

  Key data cleaning and preparation steps:
  - Removed canceled transactions
  - Filtered out missing `CustomerID` and non-positive `Quantity`
  - Converted `StockCode` to uppercase for consistency
  - Removed non-product entries
  - Created a `TotalAmount` column (`UnitPrice x Quantity`)
  - Converted `InvoiceDate` to date format
  - Aggregated transactions at the customer level
  - Generated RFM scores (1-5) and segmented customers into groups

---

### File: `rfm_analysis.R`

This file contains all R code for:
- Loading the dataset
- Cleaning and transforming the data
- Calculating Recency, Frequency, and Monetary values
- Scoring customers and assigning segments
- Exporting cleaned data for Tableau

---

## Dashboard

Built in Tableau with:
- KPI summary tiles
- Segment distribution chart
- Revenue by segment chart
- RFM heatmap (Recency vs Frequency)
- Interactive filters and tooltips

## [View Interactive Tableau Dashboard](https://public.tableau.com/views/CustomerSegmentationDashboardusingRFMAnalysis/RFMAnalysis?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)**

---

## Key Insights
- Champions (top RFM scores) contribute the highest revenue
- "At Risk" and "Others" segments present opportunities for re-engagement
- Segment-based marketing can improve retention and ROI

 ---
 
# Contact

**Aidid Shariff Alwi**
sharifaidid4@gmail.com
[LinkedIn](https://linkedin.com/in/aidid-alwi-6828a22a3)
[Tableau](https://public.tableau.com/app/profile/aidid.alwi)

---
