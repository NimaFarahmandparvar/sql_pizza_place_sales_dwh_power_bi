# **Naming Conventions**

This document outlines the naming conventions used for schemas, tables, views, columns, and other objects in the data warehouse.

## **Table of Contents**

1. [General Principles](#general-principles)
2. [Table Naming Conventions](#table-naming-conventions)
   - [Bronze Rules](#bronze-rules)
   - [Silver Rules](#silver-rules)
   - [Gold Rules](#gold-rules)
3. [Column Naming Conventions](#column-naming-conventions)
   - [Surrogate Keys](#surrogate-keys)
   - [Technical Columns](#technical-columns)
4. [Stored Procedure](#stored-procedure)
---

## **General Principles**

- **Naming Conventions**: Use snake_case, with lowercase letters and underscores (`_`) to seperate words.
- **Language**: Use English for all names.

## **Table Naming Conventions**

### **Bronze Rules**: 
- All names must start with the source system name, and the table names must match their original names without renaming.
- **`<sourcesystem>_<entity>`**
  - `<sourcesysytem>`: The name of the source system (e.g., `sales`).
  - `<entity>`: The exact name of the tables in the source system (e.g., `sales_orders`)

### **Silver Rules**: 
- All names must start with the source system name, and the table names must match their original names without renaming.
- **`<sourcesystem>_<entity>`**
  - `<sourcesysytem>`: The name of the source system (e.g., `pizza_sales`).
  - `<entity>`: The exact name of the tables in the source system (e.g., `pizza_sales_orders`)

### **Gold Rules**:
- All names must be meaningful, business-aligned names for tables, starting with the category prefix.
- **`<category>_<entity>`**
  - `<category>`: Describes the role of the table, such as `dim` (dimension) or `fact` (fact table).  
  - `<entity>`: Descriptive name of the table, aligned with the business domain (e.g., `product`, `sales`).  
  - Examples:
    - `dim-product` → Dimension table for customer data.  
    - `fact-sales` → Fact table containing sales transactions.

## **Column Naming Conventions**

### **Surrogate Keys**  
- All primary keys in dimension tables must use the suffix `-key`.
- **`<table-name>-key`**  
  - `<table-name>`: Refers to the name of the table or entity the key belongs to.  
  - `-key`: A suffix indicating that this column is a surrogate key.  
  - Example: `pizza-key` → Surrogate key in the `dim-product` table.

  ### **Technical Columns**
- All technical columns must start with the prefix `dwh-`, followed by a descriptive name indicating the column's purpose.
- **`dwh-<column-name>`**  
  - `dwh`: Prefix exclusively for system-generated metadata.  
  - `<column-name>`: Descriptive name indicating the column's purpose.  
  - Example: `dwh-load-date` → System-generated column used to store the date when the record was loaded.
 
## **Stored Procedure**

- All stored procedures used for loading data must follow the naming pattern:
- **`load-<layer>`**.
  
  - `<layer>`: Represents the layer being loaded, such as `bronze`, `silver`, or `gold`.
  - Example: 
    - `load-bronze` → Stored procedure for loading data into the Bronze layer.
    - `load-silver` → Stored procedure for loading data into the Silver layer.
    - `load-gold` → Stored procedure for loading data into the Gold layer.