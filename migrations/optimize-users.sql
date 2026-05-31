-- Slow Query Optimization Report
-- Query: SELECT * FROM users WHERE city = 'city_60';
-- Date: 2026-05-31
--
-- Diagnosis:
-- Table has 1,000,000 rows across 100 unique cities (10,000 rows per city = 1% selectivity).
-- NO index existed on `city` — full table scan on every query.
-- Fix: covering index `idx_city_covering` applied directly to production.
--
-- Before fix: full scan of 1,000,000 rows
-- After fix:  index scan of ~10,000 rows (~100x improvement)

-- Step 1: Refresh index statistics
ANALYZE TABLE users;

-- Step 2: Add covering index (APPLIED)
ALTER TABLE users ADD INDEX idx_city_covering (city, name, age, created_at);

-- Step 3: Use explicit columns instead of SELECT *
-- Avoid: SELECT * FROM users WHERE city = 'city_60';
-- Use:
SELECT id, name, city, age, created_at FROM users WHERE city = 'city_60';
