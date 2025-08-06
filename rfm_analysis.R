#--------------------
# Online Retail Customer Segmentation Project
# 1. Load libraries
#-------------------

library(readxl)
library(dplyr)
library(lubridate)

#-----------------
# 2. Load Data
#-----------------

retail_data <- read_excel("Online Retail.xlsx")

#-----------------
# 3. Data Cleaning
#-----------------


#------------------
# View the structure 
#------------------

str(retail_data)

#------------------
# Summary statistics
#------------------

summary(retail_data)

#---------------------
# Removing missing data
#---------------------

retail_data_clean <- retail_data %>% filter(!is.na(CustomerID))

#------------------------------
# Remove cancelled transactions
#------------------------------

retail_data_clean <- retail_data_clean %>% filter(!grepl("^C", InvoiceNo))

#--------------------------------
# Remove rows with Quantity <= 0
#--------------------------------

retail_data_clean <- retail_data_clean %>% filter(Quantity > 0)

#-------------------------------
# Convert StockCode to uppercase (for consistency)
#-------------------------------

retail_data_clean <- retail_data_clean %>% mutate(StockCode = toupper(StockCode))

#------------------------------
# Remove non-product entries
# Viewing the non_product entries
#------------------------------

retail_data_summary <- retail_data_clean %>% 
  select(StockCode, Description) %>% 
  distinct() %>% 
  arrange(StockCode)

write.csv(retail_data_summary, "stockcodes_summary.csv", row.names = FALSE)

non_products <- c("AMAZONFEE", "B", "BANK CHARGE", "C2", "CRUK", "D", "POST", "PADS", "S", "M")
retail_data_clean <- retail_data_clean %>% 
  filter(!StockCode %in% non_products)

#-------------------------------
# Remove rows where StockCode is too short
retail_data_clean <- retail_data_clean %>% filter(nchar(StockCode) > 2)

#-------------------------------
# Create TotalAmount column = Quantity * UnitPrice
#------------------------------

retail_data_clean <- retail_data_clean %>% 
  mutate(TotalAmount = Quantity * UnitPrice)

#-------------------------------
# Convert InvoiceDate to Date format
#------------------------------

retail_data_clean <- retail_data_clean %>% 
  mutate(InvoiceDate = as.Date(InvoiceDate))

#-----------------------------
# Confirm cleaning is done
#----------------------------
nrow(retail_data)
nrow(retail_data_clean)

head(retail_data_clean)

View(retail_data_clean)

#------------------------
# 4: Analysis
#------------------------

#------------------------
# RFM Analysis(Recency, Frequency, and Monetary)
# Reference date (last invoice date)
#-----------------------

reference_date <- max(retail_data_clean$InvoiceDate)

#----------------------
# Creating RFM table
#----------------------

rfm <- retail_data_clean %>% 
  group_by(CustomerID) %>%
  summarise(Recency = as.numeric(reference_date - max(InvoiceDate)),
            Frequency = n_distinct(InvoiceNo),
            Monetary = sum(TotalAmount)
           ) %>% ungroup()

#--------------------
# View your RFM table
#--------------------

head(rfm)
str(rfm)

library(readxl)
View(rfm)

#------------------
# Metrics score
#------------------

rfm_scores <- rfm %>% 
  mutate(
    R_Score = ntile(-Recency, 5),
    F_Score = ntile(Frequency, 5),
    M_Score = ntile(Monetary, 5),
    RFM_Segment = paste0(R_Score, F_Score, M_Score),
    RFM_score = R_Score + F_Score + M_Score
  )

#------------------
# Segment customers based on RFM score
#------------------

rfm_scores <- rfm_scores %>% 
  mutate(
    Segment = case_when(
      R_Score >= 4 & F_Score >= 4 & M_Score >= 4 ~ "Champions",
      R_Score >= 4 & F_Score >= 3 ~ "Loyal Customers",
      R_Score >= 3 & F_Score >= 3 ~ "Potential Loyalists",
      R_Score >= 2 & F_Score >= 4 ~ "At Risk",
      R_Score >= 2 & F_Score >= 2 ~ "Hibernating",
      TRUE ~ "Others"
    )
  )

#-----------------
# View Segment distributions
#-----------------

table(rfm_scores$Segment)

#------------------
# Customer Count by RFM Segment
#------------------

rfm_segment_count <- rfm_scores %>% 
  group_by(Segment) %>% 
  summarise(Count = n()) %>% 
  arrange(desc(Count))
print(rfm_segment_count)

#------------------
# Total Revenue per Segment
#-----------------

revenue_by_segment <- retail_data_clean %>% 
  left_join(rfm_scores, by = "CustomerID") %>% 
  group_by(Segment) %>% 
  summarise(TotalRevenue = sum(TotalAmount, na.rm = TRUE)) %>% 
  arrange(desc(TotalRevenue))
print(revenue_by_segment) 

#-----------------
# 5. Visualization
#-----------------

#-----------------
# RFM visualization
#-----------------

library(ggplot2)
ggplot(rfm_segment_count, aes(x = reorder(Segment, -Count), y = Count)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Customer Count by Segment", x = "Customer Segment", y = "Number of Customers")+
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#------------------
# Revenue per Segment visualization
#------------------
ggplot(revenue_by_segment, aes(x = reorder(Segment, -TotalRevenue), y = TotalRevenue)) +
  geom_bar(stat = "identity", fill = "darkgreen") +
  labs(title = "Total Revenue by Customer Segment", x = "Customer Segment", y = "Total Revenue") +
  theme_minimal()+
  theme(axis.text = element_text(angle = 45, hjust = 1))

# Exporting cleaned RFM dataset
write.csv(rfm_scores,"rfm_scores.csv", row.names = FALSE)
