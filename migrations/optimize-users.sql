-- Slow Query Optimization Report
-- Query: SELECT * FROM users WHERE city = 'city_60';
-- Date: 2026-05-31
--
-- Diagnosis:
-- The `city` column has a MUL (non-unique) index, but the optimizer may skip it
-- due to low selectivity or SELECT * forcing full row lookups.
-- ANALYZE TABLE was run to refresh index statistics.

-- Step 1: Refresh index statistics
ANALYZE TABLE users;

-- Step 2 (if still slow): Add a covering index to avoid key lookups
ALTER TABLE users ADD INDEX idx_city_covering (city, name, age, created_at);

-- Step 3: Prefer explicit column selection over SELECT *
-- Instead of: SELECT * FROM users WHERE city = 'city_60';
-- Use:
SELECT id, name, city, age, created_at FROM users WHERE city = 'city_60';
