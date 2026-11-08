\# Data Movement Documentation

\## Enterprise Sales Intelligence



\### 1. Introduction

This document explains the data movement process implemented in the Enterprise Sales Intelligence project. Data was transferred from the AdventureWorks dataset into SQL Server and then imported into Power BI for analysis and dashboard development.



\### 2. Source Dataset

\- \*\*Dataset:\*\* Microsoft AdventureWorks Sales Dataset

\- \*\*Source Format:\*\* Excel Workbook

\- \*\*Source Tables:\*\* 7 tables



The original dataset was downloaded and its seven tables were exported into separate CSV files.



\### 3. CSV File Preparation



The seven tables were converted into individual CSV files:



1\. Customer data.csv

2\. Date data.csv

3\. Product data.csv

4\. Reseller data.csv

5\. Sales data.csv

6\. Sales\_order data.csv

7\. Sales\_territory data.csv



\*\*Purpose:\*\* Preparing individual CSV files made it easier to import the data into SQL Server.

## 4. Data Movement Process

1. Downloaded the AdventureWorks Sales Excel workbook.
2. Converted the seven source tables into seven individual CSV files.
3. Opened SQL Server Management Studio (SSMS).
4. Used the SSMS Import Data Wizard to import the seven CSV files into the EnterpriseSalesDB database.
5. Created and verified the seven main SQL tables.
6. Connected Power BI Desktop to the EnterpriseSalesDB database using the SQL Server connector.

## 5. Main SQL Tables

1. Customer data
2. Date data
3. Product data
4. Reseller data
5. Sales data
6. Sales_order data
7. Sales_territory data

## 6. Staging Tables

Two staging tables are also present:
- stg_Customer data
- stg_Date data

These tables are used during the automated CSV data-loading process.

## 7. Database Summary

- Main Tables: 7
- Staging Tables: 2
- Total Tables: 9

## 8. Data Loading and Automation

A stored procedure named `dbo.usp_Automate_EnterpriseSales_Load` was created to automate CSV data loading.

A SQL Server Agent Job named `EnterpriseSales_Automated_Data_Load` was configured with a daily 3:00 AM schedule.

## 9. Power BI Data Refresh

After the SQL Server Agent Job loads the latest CSV data into SQL Server, the Power BI Desktop report must be refreshed manually to reflect the updated data.

Power BI Service scheduled refresh has not been configured.

## 10. Tools Used

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- SQL Server Agent
- Power BI Desktop
- CSV files


\### 11. CSV to SQL Server Data Movement



\*\*Destination Database:\*\* `EnterpriseSalesDB`



\*\*Tool Used:\*\* SQL Server Management Studio (SSMS)



\*\*Process:\*\*

1\. Created the `EnterpriseSalesDB` database in SQL Server.

2\. Imported all seven CSV files into the database.

3\. Created corresponding SQL tables for each dataset.

4\. Verified that the imported tables contained the expected records.



\*\*Imported Record Counts:\*\*



| SQL Table | Rows |

|---|---:|

| Customer data | 18,485 |

| Date data | 1,461 |

| Product data | 397 |

| Reseller data | 702 |

| Sales data | 121,253 |

| Sales\_order data | 121,253 |

| Sales\_territory data | 11 |



\### 12. SQL Server to Power BI Data Movement



\*\*Tool Used:\*\* Power BI Desktop



\*\*Process:\*\*

1\. Opened Power BI Desktop.

2\. Selected Get Data → SQL Server.

3\. Connected to the SQL Server database.

4\. Selected the `EnterpriseSalesDB` database.

5\. Imported the required seven SQL tables into Power BI.

6\. Verified that the data was available for further processing.



\### 13. Data Transformation and Modeling



After importing the SQL data into Power BI:



\- Performed data cleaning and transformation using Power Query.

\- Applied appropriate data types and column naming.

\- Created relationships between the tables.

\- Developed the data model using a Star Schema approach.

\- Applied formatting and prepared the data for visualization.



\### 14. Data Movement Automation



SQL Server automation was implemented to load the latest CSV data into the database.



\*\*Automation Components:\*\*

\- SQL Server Agent

\- SQL Server Job: `EnterpriseSales\_Automated\_Data\_Load`

\- Stored Procedure: `dbo.usp\_Automate\_EnterpriseSales\_Load`

\- Schedule: Daily at 3:00 AM



The SQL Agent Job executes the stored procedure, which processes the CSV files and loads their data into the corresponding SQL Server tables.



\### 15. Power BI Data Refresh



After the automated SQL data load:



1\. Open Power BI Desktop.

2\. Open the Enterprise Sales Intelligence PBIX file.

3\. Select Home → Refresh.

4\. Power BI retrieves the latest available data from SQL Server.

5\. Save the refreshed PBIX file.



\*\*Note:\*\* SQL Server data loading is automated. Power BI Desktop refresh is currently performed manually. Power BI Service scheduled refresh has not been configured.



\### 16. End-to-End Data Flow



AdventureWorks Dataset  

↓  

7 CSV Files  

↓  

SQL Server – EnterpriseSalesDB  

↓  

Power BI SQL Server Connection  

↓  

Data Transformation and Modeling  

↓  

Dashboard Development  

↓  

SQL Server Agent Automation – Daily 3:00 AM  

↓  

Manual Power BI Refresh  

↓  

Updated Dashboard



\### 17. Conclusion



The project implements an end-to-end data movement process using CSV files, SQL Server, and Power BI. SQL Server Agent automates the daily data loading process, while Power BI Desktop retrieves the latest database data through manual refresh. This workflow supports consistent data management and updated business reporting.

