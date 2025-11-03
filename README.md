# 🧠 RFM Customer Segmentation (SQL Server)

## 📊 Overview
This project implements **RFM (Recency, Frequency, Monetary)** analysis using pure SQL Server syntax.  
It segments customers based on purchasing behavior to help identify **loyal, high-value, and inactive** customers.

---

## ⚙️ Features
- Calculates **Recency** (days since last order)
- Computes **Frequency** (number of unique invoices)
- Calculates **Monetary Value** (total spend)
- Uses SQL Server **window functions (`NTILE`)** to create RFM scores
- Assigns intuitive **customer segments**:
  - Champions
  - Loyal Customers
  - Potential Loyalists
  - Customers Needing Attention
  - Hibernating
  - Lost

---

## 🧱 SQL Logic Breakdown
1. **`rfm_base`** – aggregates order data per customer  
2. **`rfm`** – calculates recency in days  
3. **`customer_segment_score`** – assigns R, F, M scores using `NTILE()`  
4. **Final SELECT** – combines scores and segments customers

---

## 🧮 Example Output
| Customer_ID | Recency_Score | Frequency_Score | Monetary_Score | Total_Score | Segment |
|--------------|---------------|-----------------|----------------|--------------|----------|
| 17850 | 5 | 5 | 5 | 15 | Champions |
| 13047 | 5 | 4 | 5 | 14 | Loyal Customers |
| 12583 | 3 | 3 | 3 | 9 | Potential Loyalists |

---

## 🧰 Tech Stack
- **SQL Server 2019+**
- **SSMS / Azure Data Studio**

---

## 🚀 How to Use
1. Clone this repo  
   ```bash
   git clone https://github.com/Shivoo3/RFM_Customer_Segmentation_SQL.git
