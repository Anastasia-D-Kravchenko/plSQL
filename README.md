# Project README: PL/SQL Database Programming (Basics, Cursors, and Triggers)

This project consists of a series of laboratory exercises focused on **PL/SQL (Procedural Language/Structured Query Language)** programming for Oracle databases. The project covers foundational procedural blocks, automated data manipulation using cursors, and the implementation of business logic via database triggers.

---

## 🛠 Project Components

The project is organized into three distinct modules based on laboratory requirements.

### 1. PL/SQL Basics & Procedures

* 
**Procedural Blocks**: Implementation of anonymous PL/SQL blocks to declare variables, perform counts, and output results using `DBMS_OUTPUT.PUT_LINE`.


* 
**Conditional Logic**: Use of `IF...THEN...ELSE` structures to perform conditional data insertion, such as adding a new person to the `T_Person` table only if the current record count is below a specific threshold.


* **Stored Procedures**:
* 
**Purchase Management**: Developed procedures to handle product purchases, featuring logic that either inserts a new record or updates the quantity of an existing one.


* 
**Employment Updates**: Created procedures to manage employee job changes with integrated checks for existence, redundancy (already assigned to the job), and frequency limits (once per day).





### 2. Cursor Operations

* 
**Dynamic Price Updates**: Implementation of cursors to iterate through the `T_Product` table and apply scaled price changes (10% discount for expensive items, 5% increase for cheap items).


* 
**Complex Data Analysis**: Used cursors to identify "favorite products" for individuals by calculating which product they purchased in the greatest quantity across all transactions.


* 
**Seniority & Bonuses**: Developed logic using the `MONTHS_BETWEEN()` function and cursors to calculate employee seniority and assign performance bonuses based on months of service.



### 3. Database Triggers

* 
**Data Protection**: Created triggers to prevent the deletion of critical records from the `T_ProductList` table using `raise_application_error`.


* 
**Consistency Triggers**: Implemented triggers to automatically maintain a summary table (`T_SoldProducts`) by updating a running total value whenever items are inserted, updated, or deleted in the product list.


* 
**Complex View Management**: Developed `INSTEAD OF` triggers for complex views to manage multi-table updates, ensuring that related records in `T_Person`, `T_Employee`, and `T_Employment` stay synchronized.



---

## 🚀 How to Use

### Database Preparation

1. 
**Generation**: Use the provided database generation links within the lab documents to create the required schema, including core tables like `T_Person`, `T_Product`, and `T_Employee`.


2. 
**Environment**: Ensure you are using an Oracle SQL environment (such as SQL Developer or Oracle Live SQL) with `SERVEROUTPUT` enabled to view script results.



### Executing Scripts

1. **Stored Procedures**: Compile the `CREATE OR REPLACE PROCEDURE` scripts. Test them using `EXEC` or an anonymous block with specific IDs (e.g., `v_EmployeeId`, `v_JobId`).


2. 
**Cursors**: Run the cursor blocks to perform batch updates on product pricing or to populate the `Favorite_product` column in the `T_Person` table.


3. **Triggers**: Deploy triggers to the database to enforce business rules. Verify them by attempting to delete records or by performing transactions that should trigger an automatic update in the `TotalValue` column of the `T_SoldProducts` table.



---

## 📂 File Manifest

* 
`SBD_Lab08_PLSQL_BASICS_ENG.pdf`: Foundational PL/SQL, variables, and procedures.


* 
`SBD_Lab9_PLSQL_CURSORS_ENG.pdf`: Iterative data processing and complex calculations.


* 
`SBD_Lab10_PLSQL_Triggers.docx.pdf`: Automated logic and data integrity enforcement.
