/*
============================================================
TCS FY2026 | Business Performance Analysis
SQL Portfolio File
Database: PostgreSQL
Table: tcs_fy2026_master

Purpose:
- Validate the imported dataset
- Explore business domains and metrics
- Analyse revenue, margins and year-on-year changes
- Create recruiter-ready SQL examples

Columns used:
analysis_domain
data_table
dimension
metric
fy2026_value
unit
fy2025_value
yoy_or_change
source
============================================================
*/

-- ============================================================
-- SECTION 1: DATA VALIDATION
-- ============================================================

-- 1. Total number of records
SELECT COUNT(*) AS total_rows
FROM tcs_fy2026_master;

-- 2. Preview the first 10 records
SELECT *
FROM tcs_fy2026_master
LIMIT 10;

-- 3. Check for missing important fields
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (
        WHERE analysis_domain IS NULL OR TRIM(analysis_domain) = ''
    ) AS missing_analysis_domain,
    COUNT(*) FILTER (
        WHERE data_table IS NULL OR TRIM(data_table) = ''
    ) AS missing_data_table,
    COUNT(*) FILTER (
        WHERE dimension IS NULL OR TRIM(dimension) = ''
    ) AS missing_dimension,
    COUNT(*) FILTER (
        WHERE metric IS NULL OR TRIM(metric) = ''
    ) AS missing_metric
FROM tcs_fy2026_master;

-- 4. Check duplicate metric records
SELECT
    analysis_domain,
    data_table,
    dimension,
    metric,
    COUNT(*) AS duplicate_count
FROM tcs_fy2026_master
GROUP BY analysis_domain, data_table, dimension, metric
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- ============================================================
-- SECTION 2: DATASET EXPLORATION
-- ============================================================

-- 5. List business analysis domains
SELECT DISTINCT analysis_domain
FROM tcs_fy2026_master
ORDER BY analysis_domain;

-- 6. List data categories
SELECT DISTINCT data_table
FROM tcs_fy2026_master
ORDER BY data_table;

-- 7. List all dimensions and metrics
SELECT
    dimension,
    metric,
    unit
FROM tcs_fy2026_master
ORDER BY dimension, metric;

-- 8. Count records by business domain
SELECT
    analysis_domain,
    COUNT(*) AS metric_count
FROM tcs_fy2026_master
GROUP BY analysis_domain
ORDER BY metric_count DESC;


-- ============================================================
-- SECTION 3: FINANCIAL PERFORMANCE
-- ============================================================

-- 9. Show financial performance metrics
SELECT
    dimension,
    metric,
    fy2026_value,
    unit,
    fy2025_value,
    yoy_or_change
FROM tcs_fy2026_master
WHERE LOWER(dimension) LIKE '%financial%'
   OR LOWER(data_table) LIKE '%financial%'
ORDER BY metric;

-- 10. Revenue-related metrics
SELECT
    dimension,
    metric,
    fy2026_value,
    unit,
    fy2025_value,
    yoy_or_change
FROM tcs_fy2026_master
WHERE LOWER(metric) LIKE '%revenue%'
   OR LOWER(dimension) LIKE '%revenue%'
ORDER BY metric;

-- 11. Profit-related metrics
SELECT
    dimension,
    metric,
    fy2026_value,
    unit,
    fy2025_value,
    yoy_or_change
FROM tcs_fy2026_master
WHERE LOWER(metric) LIKE '%profit%'
   OR LOWER(metric) LIKE '%pat%'
ORDER BY metric;

-- 12. Margin-related metrics
SELECT
    dimension,
    metric,
    fy2026_value,
    unit,
    fy2025_value,
    yoy_or_change
FROM tcs_fy2026_master
WHERE LOWER(metric) LIKE '%margin%'
ORDER BY metric;


-- ============================================================
-- SECTION 4: YEAR-ON-YEAR ANALYSIS
-- ============================================================

-- 13. Metrics with year-on-year/change information
SELECT
    dimension,
    metric,
    fy2025_value,
    fy2026_value,
    yoy_or_change,
    unit
FROM tcs_fy2026_master
WHERE yoy_or_change IS NOT NULL
ORDER BY dimension, metric;

-- 14. Largest positive changes
SELECT
    dimension,
    metric,
    fy2025_value,
    fy2026_value,
    yoy_or_change,
    unit
FROM tcs_fy2026_master
WHERE yoy_or_change IS NOT NULL
ORDER BY yoy_or_change DESC
LIMIT 10;

-- 15. Largest negative changes
SELECT
    dimension,
    metric,
    fy2025_value,
    fy2026_value,
    yoy_or_change,
    unit
FROM tcs_fy2026_master
WHERE yoy_or_change IS NOT NULL
ORDER BY yoy_or_change ASC
LIMIT 10;


-- ============================================================
-- SECTION 5: INDUSTRY / BUSINESS ANALYSIS
-- ============================================================

-- 16. Find industry-related records
SELECT
    analysis_domain,
    data_table,
    dimension,
    metric,
    fy2026_value,
    unit,
    yoy_or_change
FROM tcs_fy2026_master
WHERE LOWER(dimension) LIKE '%industry%'
   OR LOWER(data_table) LIKE '%industry%'
   OR LOWER(metric) LIKE '%industry%'
ORDER BY fy2026_value DESC NULLS LAST;

-- 17. Revenue by industry/business segment
SELECT
    dimension,
    metric,
    fy2026_value,
    unit
FROM tcs_fy2026_master
WHERE LOWER(metric) LIKE '%revenue%'
  AND (
       LOWER(dimension) LIKE '%industry%'
       OR LOWER(dimension) LIKE '%segment%'
       OR LOWER(data_table) LIKE '%industry%'
      )
ORDER BY fy2026_value DESC NULLS LAST;


-- ============================================================
-- SECTION 6: GEOGRAPHY ANALYSIS
-- ============================================================

-- 18. Find geography-related records
SELECT
    analysis_domain,
    data_table,
    dimension,
    metric,
    fy2026_value,
    unit,
    yoy_or_change
FROM tcs_fy2026_master
WHERE LOWER(dimension) LIKE '%geograph%'
   OR LOWER(data_table) LIKE '%geograph%'
   OR LOWER(metric) LIKE '%geograph%'
ORDER BY fy2026_value DESC NULLS LAST;


-- ============================================================
-- SECTION 7: EXECUTIVE SUMMARY QUERIES
-- ============================================================

-- 19. Metric count by category
SELECT
    analysis_domain,
    data_table,
    COUNT(*) AS metric_count
FROM tcs_fy2026_master
GROUP BY analysis_domain, data_table
ORDER BY metric_count DESC;

-- 20. Source coverage
SELECT
    source,
    COUNT(*) AS record_count
FROM tcs_fy2026_master
GROUP BY source
ORDER BY record_count DESC;

-- 21. Units used in the dataset
SELECT
    unit,
    COUNT(*) AS metric_count
FROM tcs_fy2026_master
GROUP BY unit
ORDER BY metric_count DESC;


-- ============================================================
-- SECTION 8: RECRUITER-READY BUSINESS QUESTIONS
-- ============================================================

-- Q1. What are the key FY2026 financial metrics?
SELECT
    metric,
    fy2026_value,
    unit
FROM tcs_fy2026_master
WHERE LOWER(data_table) LIKE '%financial%'
ORDER BY metric;

-- Q2. Which metrics have the highest FY2026 values?
SELECT
    dimension,
    metric,
    fy2026_value,
    unit
FROM tcs_fy2026_master
WHERE fy2026_value IS NOT NULL
ORDER BY fy2026_value DESC
LIMIT 10;

-- Q3. Which metrics show the strongest year-on-year movement?
SELECT
    dimension,
    metric,
    yoy_or_change,
    unit
FROM tcs_fy2026_master
WHERE yoy_or_change IS NOT NULL
ORDER BY ABS(yoy_or_change) DESC
LIMIT 10;

-- Q4. How many metrics are available for each analysis area?
SELECT
    analysis_domain,
    COUNT(*) AS total_metrics
FROM tcs_fy2026_master
GROUP BY analysis_domain
ORDER BY total_metrics DESC;

-- Q5. Which records have no FY2026 value?
SELECT
    dimension,
    metric,
    unit
FROM tcs_fy2026_master
WHERE fy2026_value IS NULL;


-- ============================================================
-- END OF TCS FY2026 SQL PORTFOLIO FILE
-- ============================================================
