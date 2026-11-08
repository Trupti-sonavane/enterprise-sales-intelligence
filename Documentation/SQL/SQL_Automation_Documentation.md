

\# SQL Server Automation



\## 1. Overview



This module implements an automated data-loading process using Microsoft SQL Server and SQL Server Agent for the \*\*Enterprise Sales Intelligence\*\* project.



The automation loads the latest CSV data into the `EnterpriseSalesDB` database through a stored procedure and a scheduled SQL Server Agent Job.



\## 2. Technology Stack



| Technology | Purpose |

|---|---|

| Microsoft SQL Server | Database management |

| SQL Server Management Studio (SSMS) | SQL script development and execution |

| SQL Server Agent | Scheduled job execution |

| T-SQL | Stored procedure and automation logic |

| CSV | Source data files |

| Power BI Desktop | Data visualization and reporting |



\## 3. Database Configuration



\- \*\*Database Name:\*\* `EnterpriseSalesDB`

\- \*\*CSV Source Folder:\*\* `C:\\SQLData\\EnterpriseCSV`

\- \*\*Main Tables:\*\* 7

\- \*\*Staging Tables:\*\* 2

\- \*\*Total Tables:\*\* 9



\### Main Tables



1\. Customer data

2\. Date data

3\. Product data

4\. Reseller data

5\. Sales data

6\. Sales\_order data

7\. Sales\_territory data



\### Staging Tables



\- `stg\_Customer data`

\- `stg\_Date data`



\## 4. Stored Procedure



\*\*Procedure Name:\*\* `dbo.usp\_Automate\_EnterpriseSales\_Load`



The stored procedure automates the CSV data-loading process.



\### Key Operations



\- Reads CSV files from the configured source folder.

\- Uses `BULK INSERT` to load records into staging tables.

\- Performs data validation and processing.

\- Transfers processed records into the main database tables.

\- Uses SQL transactions to manage the loading operation.



\## 5. SQL Server Agent Job



\*\*Job Name:\*\* `EnterpriseSales\_Automated\_Data\_Load`



The SQL Server Agent Job is configured to execute the stored procedure automatically.



\### Job Configuration



| Configuration | Value |

|---|---|

| Job Name | `EnterpriseSales\_Automated\_Data\_Load` |

| Execution Procedure | `dbo.usp\_Automate\_EnterpriseSales\_Load` |

| Frequency | Daily |

| Scheduled Time | 3:00 AM |

| Execution Service | SQL Server Agent |



\## 6. Automation Workflow



```text

Updated CSV Files

&#x20;      |

&#x20;      v

CSV Source Folder

&#x20;      |

&#x20;      v

SQL Server Agent Job

&#x20;      |

&#x20;      v

Stored Procedure

&#x20;      |

&#x20;      v

BULK INSERT

&#x20;      |

&#x20;      v

Staging Tables

&#x20;      |

&#x20;      v

Data Validation

&#x20;      |

&#x20;      v

Main SQL Tables

&#x20;      |

&#x20;      v

EnterpriseSalesDB

&#x20;      |

&#x20;      v

Manual Power BI Refresh

&#x20;      |

&#x20;      v

Updated Dashboard

```



\## 7. Power BI Refresh Integration



After the scheduled SQL Server Job loads the latest CSV data:



1\. The updated data is stored in `EnterpriseSalesDB`.

2\. Power BI Desktop connects to the SQL Server database.

3\. The user manually selects \*\*Refresh\*\* in Power BI Desktop.

4\. The dashboard retrieves the latest available database data.



> \*\*Note:\*\* Power BI Service publishing and scheduled refresh are not configured in this project. Power BI Desktop refresh is performed manually.



\## 8. SQL Scripts



The following scripts are maintained in the `SQL/Scripts/` directory.



| Script File | Description |

|---|---|

| `02\_Data\_Verification.sql` | Verifies database tables and row counts |

| `03\_Automate\_EnterpriseSales\_Load.sql` | Stored procedure for automated CSV loading |

| `04\_EnterpriseSales\_Agent\_Job.sql` | SQL Server Agent Job creation script |



\## 9. Screenshots and Evidence



The `SQL/Screenshots/` directory contains evidence of:



\- Database table verification

\- Stored procedure configuration

\- SQL Server Agent Job configuration



\## 10. Benefits of Automation



\- Reduces repetitive manual CSV data-loading activities.

\- Provides scheduled database loading.

\- Organizes incoming data through staging tables.

\- Supports data validation before loading into main tables.

\- Maintains an updated SQL Server data source for Power BI reporting.



\## 11. Conclusion



SQL Server Stored Procedures and SQL Server Agent provide a scheduled data-loading mechanism for the Enterprise Sales Intelligence project.



The automation process updates the SQL Server database daily at the configured schedule. Power BI Desktop manual refresh is then used to retrieve the latest data and update the dashboard.



