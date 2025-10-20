# Data-Integrity-Auditing-of-Maji-Ndogo-Water-Project
This project assesses the integrity and accuracy of the Maji Ndogo water project database by comparing internal survey data against an independent auditor's report CSV file.
The goal is to identify inconsistencies, evaluate employee performance, and detect potential misconduct.

## Database Used
**Database:** `md_water_services`  
**Tables Involved:**  
- `auditor_report` (CSV import)  
- `visits`  
- `water_quality`  
- `water_source`  
- `employee`  

---

## Project Structure

| File | Description |
|------|--------------|
| `sql/01-auditor-report-setup.sql` | Creates the `auditor_report` table, imports CSV data, and previews contents. |
| `sql/02-compare-audit-survey.sql` | Compares auditor vs surveyor water quality scores to identify mismatches and link them to employees. |
| `sql/03-error-analysis-and-suspect-identification.sql` | Analyzes errors, finds employees with above-average mistakes, and investigates possible corruption indicators. |

---

## How to Use
1. Clone this repository or copy scripts individually.  
2. Open MySQL Workbench (or equivalent SQL IDE).  
3. Set the working database:
   ```sql
   USE md_water_services;
4. Run each .sql file in sequence (01 → 03).
5. Review query results and derived insights in your SQL console.

INSIGHTS AND OUTCOMES:
-The audit uncovered mismatched water quality scores across 102 records.
-Some employees made above-average errors, potentially indicating training issues or deliberate falsification.
-Several auditor statements raised suspicions of misconduct, prompting further HR and data process review.

AUTHOR
Metrine Bwisa
SQL & Data Analytics Enthusiast
🔗 Check out my [LinkedIn profile](https://www.linkedin.com/in/yourusername/](https://www.linkedin.com/in/metrine-bwisa-883123376/)).
    [Project Portfolio](datascienceportfol.io/metrinebwisa4)
