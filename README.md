# SQL Exploratory Data Analysis (EDA) Project

A structured SQL-based Exploratory Data Analysis project built on a sales data warehouse. This project demonstrates how to systematically explore, understand, and extract business insights from relational data using pure SQL — without any external BI tools or scripting languages.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Dataset](#dataset)
- [Project Structure](#project-structure)
- [Skills Demonstrated](#skills-demonstrated)
- [Analysis Modules](#analysis-modules)
- [How to Run](#how-to-run)
- [Key Business Questions Answered](#key-business-questions-answered)
- [Sample Insights](#sample-insights)

---

## Project Overview

This project performs a full EDA on a sales dataset modeled as a **star schema** — a common pattern in enterprise data warehouses. The goal is to understand the data from multiple angles: its structure, dimensions, measures, time boundaries, magnitude, and rankings.

The project follows a systematic EDA framework:

```
Database Exploration → Dimension Exploration → Date Exploration
       ↓
Measures Exploration → Magnitude Analysis → Ranking Analysis
```

---

## Dataset

The dataset consists of three tables modeled in a star schema:

| Table | Type | Description |
|---|---|---|
| `fact_sales` | Fact | Order-level transactions with sales amount, quantity, and price |
| `dim_products` | Dimension | Product catalog with categories, sub-categories, cost, and product line |
| `dim_customers` | Dimension | Customer profiles including country, gender, age, and marital status |

### Schema

```
dim_customers          fact_sales              dim_products
─────────────         ─────────────           ─────────────
customer_key   ◄────  customer_key            product_key
customer_id          product_key   ────►      product_id
first_name           order_number             product_name
last_name            order_date               category
country              shipping_date            sub_category
gender               due_date                 product_cost
birth_date           sales_amount             product_line
marital_status       quantity
                     price
```

> The dataset is sourced from the SQL Data Warehouse End-to-End project and contains real-world style sales data spanning multiple years, countries, and product categories.

---

## Project Structure

```
SQL-EDA-Project/
│
├── dataset/
│   ├── fact_sales.csv          # Sales transactions
│   ├── dim_products.csv        # Product dimension
│   └── dim_customers.csv       # Customer dimension
│
├── scripts/
│   ├── database_exploration.sql    # Schema and column discovery
│   ├── dimension_exploration.sql   # Distinct values across dimensions
│   ├── date_exploration.sql        # Date boundaries and age analysis
│   ├── measures_exploration.sql    # Core KPI calculations
│   ├── magnitude_analysis.sql      # Aggregations and breakdowns
│   └── ranking_analysis.sql        # Top/bottom N analysis using window functions
│
├── docs/
│   ├── EDA_Concepts.png
│   ├── MagnitudeAnalysis.png
│   └── MeasureVsDimension.png
│
└── README.md
```

---

## Skills Demonstrated

### SQL Querying
- Writing complex `SELECT` statements with multiple joins (`LEFT JOIN`)
- Filtering with `WHERE`, grouping with `GROUP BY`, and sorting with `ORDER BY`
- Eliminating duplicates with `DISTINCT` and `COUNT(DISTINCT ...)`

### Aggregations & Metrics
- Computing business KPIs: total revenue, total quantity sold, average price, order count
- Using aggregate functions: `SUM()`, `COUNT()`, `AVG()`, `MIN()`, `MAX()`, `ROUND()`
- Combining multiple metrics into a single report using `UNION ALL`

### Window Functions
- `ROW_NUMBER() OVER (ORDER BY ...)` for dynamic ranking without hardcoded limits
- Wrapping window function queries in subqueries to filter by rank

### Date & Time Analysis
- Calculating date ranges using `MIN()` / `MAX()` on date columns
- Computing time differences with `TIMESTAMPDIFF(YEAR/MONTH, ...)` and `CURDATE()`
- Deriving customer age from birth date

### Data Exploration Techniques
- **Database Exploration** — querying `information_schema` to understand table and column structure
- **Dimension Exploration** — identifying unique categorical values across dimensions
- **Measures Exploration** — distinguishing quantitative measures from descriptive dimensions
- **Magnitude Analysis** — understanding scale and distribution of data across groups
- **Ranking Analysis** — identifying top and bottom performers using window functions

### Data Warehouse Concepts
- Star schema design: fact tables and dimension tables
- Foreign key relationships between fact and dimension tables
- Understanding the difference between measures and dimensions in analytical contexts

---

## Analysis Modules

### 1. Database Exploration — `database_exploration.sql`
Queries the `information_schema` to list all tables across the data warehouse layers (bronze, silver, gold) and inspect column definitions for a given table.

### 2. Dimension Exploration — `dimension_exploration.sql`
Extracts all distinct values from key dimension columns — countries from `dim_customers` and the full product hierarchy (product line → category → sub-category → product name) from `dim_products`.

### 3. Date Exploration — `date_exploration.sql`
- Finds the first and last order dates in `fact_sales`
- Calculates the total sales period in years and months
- Determines the oldest and youngest customer ages from `dim_customers`

### 4. Measures Exploration — `measures_exploration.sql`
Builds a consolidated KPI report covering:
- Total Sales Revenue
- Total Quantity Sold
- Average Selling Price
- Total Unique Orders
- Total Products
- Total Customers
- Total Converted Customers (customers who placed at least one order)

### 5. Magnitude Analysis — `magnitude_analysis.sql`
Breaks down key metrics by dimension:
- Total customers by country and by gender
- Total products by category
- Average product cost by category
- Total revenue by category
- Total revenue by customer
- Total items sold by country

### 6. Ranking Analysis — `ranking_analysis.sql`
Uses `ROW_NUMBER()` window functions to rank:
- Top 5 highest revenue-generating products
- Bottom 5 worst-performing products by revenue
- Top 5 customers by total revenue
- Bottom 3 customers by number of orders placed

---

## How to Run

### Prerequisites
- MySQL 8.0+ (or any SQL environment that supports `TIMESTAMPDIFF` and window functions)
- A SQL client such as MySQL Workbench, DBeaver, or TablePlus

### Setup

**Step 1 — Create a database and import the data**

```sql
CREATE DATABASE sales_eda;
USE sales_eda;
```

**Step 2 — Create the tables**

```sql
CREATE TABLE dim_customers (
    customer_key    INT PRIMARY KEY,
    customer_id     INT,
    customer_number VARCHAR(20),
    first_name      VARCHAR(50),
    last_name       VARCHAR(50),
    country         VARCHAR(50),
    marital_status  VARCHAR(20),
    gender          VARCHAR(10),
    birth_date      DATE,
    create_date     DATE
);

CREATE TABLE dim_products (
    product_key         INT PRIMARY KEY,
    product_id          INT,
    product_number      VARCHAR(20),
    product_name        VARCHAR(100),
    category_id         VARCHAR(20),
    category            VARCHAR(50),
    sub_category        VARCHAR(50),
    MAINTENANCE         VARCHAR(10),
    product_cost        DECIMAL(10,2),
    product_line        VARCHAR(50),
    product_start_date  DATE
);

CREATE TABLE fact_sales (
    order_number    VARCHAR(20),
    customer_key    INT,
    product_key     INT,
    order_date      DATE,
    shipping_date   DATE,
    due_date        DATE,
    sales_amount    DECIMAL(10,2),
    quantity        INT,
    price           DECIMAL(10,2)
);
```

**Step 3 — Load the CSV files**

```sql
LOAD DATA INFILE '/path/to/dataset/dim_customers.csv'
INTO TABLE dim_customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/path/to/dataset/dim_products.csv'
INTO TABLE dim_products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/path/to/dataset/fact_sales.csv'
INTO TABLE fact_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

> Replace `/path/to/dataset/` with the absolute path to the `dataset/` folder on your machine. On Windows, use forward slashes or escape backslashes.

**Step 4 — Run the analysis scripts**

Execute the scripts in the following order for a logical EDA flow:

```
1. database_exploration.sql
2. dimension_exploration.sql
3. date_exploration.sql
4. measures_exploration.sql
5. magnitude_analysis.sql
6. ranking_analysis.sql
```

Each script is self-contained and can be run independently once the tables are loaded.

---

## Key Business Questions Answered

| Question | Script |
|---|---|
| What is the full product hierarchy available? | `dimension_exploration.sql` |
| Which countries do our customers come from? | `dimension_exploration.sql` |
| What is the overall sales period covered by the data? | `date_exploration.sql` |
| How old are our youngest and oldest customers? | `date_exploration.sql` |
| What is the total revenue, orders, and quantity sold? | `measures_exploration.sql` |
| How many customers have actually made a purchase? | `measures_exploration.sql` |
| Which country has the most customers? | `magnitude_analysis.sql` |
| Which product category generates the most revenue? | `magnitude_analysis.sql` |
| Which product category has the highest average cost? | `magnitude_analysis.sql` |
| Who are the top 5 revenue-generating products? | `ranking_analysis.sql` |
| Who are the top 5 highest-value customers? | `ranking_analysis.sql` |
| Which customers place the fewest orders? | `ranking_analysis.sql` |

---

## Sample Insights

- Sales data spans multiple years, enabling trend and seasonality analysis as a next step.
- A subset of customers account for a disproportionate share of total revenue — a classic Pareto distribution pattern.
- Product categories vary significantly in average cost, indicating a broad product mix from budget to premium.
- Geographic distribution of customers highlights key markets for targeted business decisions.

---

## Tech Stack

| Tool | Purpose |
|---|---|
| MySQL 8.0 | Query engine |
| MySQL Workbench / DBeaver | SQL client |
| CSV | Raw data storage |

---

*This project is part of a broader SQL portfolio that includes a full Data Warehouse build (ETL pipeline, bronze/silver/gold layers) on the same dataset.*
