🏠 Airbnb End-to-End Data Engineering Project
📋 Overview

This project implements a complete end-to-end data engineering pipeline for Airbnb data using modern cloud technologies. It demonstrates best practices in data warehousing, transformation, and analytics using Snowflake, dbt (Data Build Tool), and AWS.

The pipeline processes Airbnb listings, bookings, and hosts data through a medallion architecture (Bronze → Silver → Gold), implementing:

Incremental loading
Slowly Changing Dimensions (SCD Type 2)
Analytics-ready datasets
🏗️ Architecture
🔄 Data Flow
Source Data (CSV) → AWS S3 → Snowflake (Staging)
                                  ↓
                              Bronze Layer
                                  ↓
                              Silver Layer
                                  ↓
                              Gold Layer
                                  ↓
                             Analytics
🧰 Technology Stack
Cloud Data Warehouse: Snowflake
Transformation Layer: dbt
Cloud Storage: AWS S3
Version Control: Git
Language: Python (3.12+)
Key dbt Features
Incremental models
Snapshots (SCD Type 2)
Custom macros
Jinja templating
Testing & documentation
📊 Data Model
🥉 Bronze Layer (Raw Data)

Minimal transformation, raw ingestion:

bronze_bookings – booking transactions
bronze_hosts – host information
bronze_listings – property listings
🥈 Silver Layer (Cleaned Data)

Data cleaning and standardization:

silver_bookings – validated bookings
silver_hosts – enriched host profiles
silver_listings – standardized listings
🥇 Gold Layer (Analytics-Ready)

Business-level datasets:

obt – One Big Table (denormalized)
fact – fact table for analytics
Ephemeral models for intermediate logic
🕒 Snapshots (SCD Type 2)

Tracks historical changes:

dim_bookings
dim_hosts
dim_listings
📁 Project Structure
AWS_DBT_Snowflake/
│
├── README.md
├── pyproject.toml
├── main.py
│
├── SourceData/
│   ├── bookings.csv
│   ├── hosts.csv
│   └── listings.csv
│
├── DDL/
│   ├── ddl.sql
│   └── resources.sql
│
└── aws_dbt_snowflake_project/
    ├── dbt_project.yml
    ├── ExampleProfiles.yml
    │
    ├── models/
    │   ├── sources/
    │   │   └── sources.yml
    │   ├── bronze/
    │   ├── silver/
    │   └── gold/
    │       └── ephemeral/
    │
    ├── macros/
    ├── analyses/
    ├── snapshots/
    ├── tests/
    └── seeds/
🚀 Getting Started
Prerequisites
Snowflake account
Python 3.12+
AWS account (for S3 storage)
⚙️ Installation
1. Clone the repository
git clone <repository-url>
cd AWS_DBT_Snowflake
2. Create virtual environment
python -m venv .venv
.venv\Scripts\Activate.ps1   # Windows
# or
source .venv/bin/activate    # Mac/Linux
3. Install dependencies
pip install -r requirements.txt
🔐 Configure Snowflake

Create ~/.dbt/profiles.yml:

aws_dbt_snowflake_project:
  outputs:
    dev:
      account: <your-account>
      database: AIRBNB
      user: <your-username>
      password: <your-password>
      role: ACCOUNTADMIN
      schema: dbt_schema
      warehouse: COMPUTE_WH
      threads: 4
      type: snowflake
  target: dev
🗄️ Load Data

Upload CSV files to Snowflake:

bookings.csv → AIRBNB.STAGING.BOOKINGS
hosts.csv → AIRBNB.STAGING.HOSTS
listings.csv → AIRBNB.STAGING.LISTINGS
🔧 Usage
Run dbt commands
dbt debug
dbt run
dbt test
dbt snapshot
dbt build
Run specific layers
dbt run --select bronze.*
dbt run --select silver.*
dbt run --select gold.*
Generate docs
dbt docs generate
dbt docs serve
🎯 Key Features
1. Incremental Loading
{{ config(materialized='incremental') }}

{% if is_incremental() %}
WHERE CREATED_AT > (
    SELECT COALESCE(MAX(CREATED_AT), '1900-01-01') FROM {{ this }}
)
{% endif %}
2. Custom Macros
{{ tag('CAST(PRICE_PER_NIGHT AS INT)') }} AS PRICE_TAG
3. Dynamic SQL (Jinja)
{% for config in configs %}
...
{% endfor %}
4. SCD Type 2 Snapshots
Tracks historical changes
Maintains valid_from / valid_to
Enables point-in-time analysis
5. Schema Organization
Layer	Schema
Bronze	AIRBNB.BRONZE
Silver	AIRBNB.SILVER
Gold	AIRBNB.GOLD
📈 Data Quality
Not null tests
Unique key tests
Referential integrity
Business rule validations
🔐 Best Practices
Never commit profiles.yml
Use environment variables
Implement RBAC in Snowflake
Use incremental models for performance
🐛 Troubleshooting
Connection Issues
Check credentials
Ensure warehouse is running
Compilation Errors
dbt debug
Incremental Issues
dbt run --full-refresh
