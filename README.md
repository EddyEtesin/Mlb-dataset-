# **MLB Payroll Analysis: Comprehensive SQL Window Functions Report**  

## **1. Overview**  
This document provides a detailed analysis of MLB team payrolls, performance metrics, and postseason outcomes using advanced SQL window functions. The dataset includes team payroll allocations, wins/losses, postseason results, and roster details.  

---

## **2. Key Objectives**  
- Analyze payroll distributions and rankings across teams.  
- Evaluate team performance (wins/losses) in relation to payroll.  
- Compare payroll and performance within postseason categories.  
- Identify trends using cumulative, lag/lead, and percentile-based metrics.  

---

## **3. Methodology**  
The analysis leverages **SQL window functions** to compute:  
- **Rankings** (`RANK()`, `ROW_NUMBER()`)  
- **Differences** (`LAG()`, `LEAD()`, absolute differences)  
- **Aggregations** (`SUM() OVER()`, `AVG() OVER()`)  
- **Groupings** (`NTILE()`, `PARTITION BY`)  
- **Percentile rankings** (`PERCENT_RANK()`)  

---

## **4. Detailed Query Analysis**  

### **4.1. Payroll Rankings**  
#### **Query 1: Rank Teams by Total Payroll (Descending)**  
```sql
SELECT `Team Name`, `Total Payroll Allocations`, 
       RANK() OVER(ORDER BY `Total Payroll Allocations` DESC) AS Payroll_Rank 
FROM dbms2.mlb_payrolls;
```
**Insight:**  
- Identifies the highest and lowest-spending teams.  
- Ties in payroll receive the same rank (unlike `ROW_NUMBER()`).  

#### **Query 8: Percentage Rank by Payroll**  
```sql
SELECT `Team Name`, `Total Payroll Allocations`, 
       PERCENT_RANK() OVER(ORDER BY `Total Payroll Allocations`) AS Payroll_Percentile 
FROM dbms2.mlb_payrolls;
```
**Insight:**  
- Shows where each team’s payroll falls within the league distribution (0 to 1 scale).  

---

### **4.2. Performance Metrics (Wins/Losses)**  
#### **Query 2: Rank Teams by Wins (Row Number)**  
```sql
SELECT `Team Name`, Wins, 
       ROW_NUMBER() OVER(ORDER BY Wins DESC) AS Win_Rank 
FROM dbms2.mlb_payrolls;
```
**Insight:**  
- Assigns a strict ordinal rank (no ties).  

#### **Query 11: Wins vs. League Average**  
```sql
SELECT `Team Name`, Wins, 
       Wins - AVG(Wins) OVER() AS Win_Avg_Difference 
FROM dbms2.mlb_payrolls;
```
**Insight:**  
- Highlights over/underperforming teams relative to the mean.  

#### **Query 12: Rank Teams by Losses (Grouped by Postseason)**  
```sql
SELECT `Team Name`, Postseason, Losses, 
       RANK() OVER(PARTITION BY Postseason ORDER BY Losses) AS Loss_Rank 
FROM dbms2.mlb_payrolls;
```
**Insight:**  
- Evaluates if postseason teams have fewer losses.  

---

### **4.3. Payroll Comparisons**  
#### **Query 3: Payroll Difference from Previous Team**  
```sql
SELECT `Team Name`, `Total Payroll Allocations`, 
       ABS(`Total Payroll Allocations` - LAG(`Total Payroll Allocations`) OVER(ORDER BY `Total Payroll Allocations` DESC)) AS Payroll_Difference 
FROM dbms2.mlb_payrolls;
```
**Insight:**  
- Measures gaps between consecutive teams in payroll ranking.  

#### **Query 4: Cumulative Payroll (Highest to Lowest)**  
```sql
SELECT `Team Name`, `Total Payroll Allocations`, 
       SUM(`Total Payroll Allocations`) OVER(ORDER BY `Total Payroll Allocations` DESC) AS Cumulative_Payroll 
FROM dbms2.mlb_payrolls;
```
**Insight:**  
- Shows how payroll spending accumulates across the league.  

#### **Query 13: Largest Active vs. Injured Payroll Gap**  
```sql
SELECT `Team Name`, `Active 26-Man`, Injured, 
       ABS(`Active 26-Man` - Injured) AS Payroll_Gap, 
       RANK() OVER(ORDER BY ABS(`Active 26-Man` - Injured) DESC) AS Gap_Rank 
FROM dbms2.mlb_payrolls;
```
**Insight:**  
- Identifies teams with the biggest disparity between active and injured player spending.  

---

### **4.4. Postseason Analysis**  
#### **Query 6: Payroll Rank Within Postseason Groups**  
```sql
SELECT `Team Name`, Postseason, `Total Payroll Allocations`, 
       RANK() OVER(PARTITION BY Postseason ORDER BY `Total Payroll Allocations` DESC) AS Payroll_Rank 
FROM dbms2.mlb_payrolls;
```
**Insight:**  
- Compares payrolls among teams with similar postseason results.  

#### **Query 10: Top 2 Teams by Active Payroll per Postseason**  
```sql
WITH Ranked AS (
    SELECT `Team Name`, `Active 26-Man`, Postseason, 
           ROW_NUMBER() OVER(PARTITION BY Postseason ORDER BY `Active 26-Man` DESC) AS Team_Rank 
    FROM dbms2.mlb_payrolls
)
SELECT * FROM Ranked WHERE Team_Rank <= 2;
```
**Insight:**  
- Highlights the highest-spending teams in each postseason category.  

---

### **4.5. Advanced Grouping & Trends**  
#### **Query 7: Wins Quartile Groups**  
```sql
SELECT `Team Name`, Wins, 
       NTILE(4) OVER(ORDER BY Wins DESC) AS Wins_Quartile 
FROM dbms2.mlb_payrolls;
```
**Insight:**  
- Divides teams into 4 equal groups based on wins (top 25%, mid-tier, etc.).  

#### **Query 15: Average Age Rank by Postseason**  
```sql
SELECT `Team Name`, Postseason, `Average Age`, 
       RANK() OVER(PARTITION BY Postseason ORDER BY `Average Age`) AS Age_Rank 
FROM dbms2.mlb_payrolls;
```
**Insight:**  
- Examines if younger/older teams perform differently in the postseason.  

---

## **5. Key Findings**  
1. **Payroll ≠ Performance:** Some high-spending teams underperform in wins (and vice versa).  
2. **Postseason Payroll Trends:** Teams that advance deeper in the postseason tend to have higher payrolls.  
3. **Injury Impact:** Teams with large gaps between active and injured payrolls may struggle with depth.  
4. **Age Factor:** Younger teams may have different postseason success rates than older ones.  

---

## **6. Recommendations**  
- **For Teams:**  
  - High-spending teams should assess ROI on player contracts.  
  - Low-payroll teams with high wins should study their success factors.  
- **For Analysts:**  
  - Investigate if injured payroll correlates with worse performance.  
  - Explore whether age affects postseason endurance.  

---

## **7. Conclusion**  
This analysis demonstrates the power of SQL window functions in sports analytics, revealing payroll efficiencies, performance trends, and postseason dynamics. Further regression analysis could quantify the relationship between payroll and wins.  

**Appendix:** Full SQL queries are provided in the original script.  
