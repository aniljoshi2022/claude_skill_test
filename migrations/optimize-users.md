# Optimization Report: `users` Table

## 1. Initial Diagnosis

**Slow Query:**
```sql
SELECT * FROM users WHERE name = 'user_1000';
```

**EXPLAIN Plan (Before Optimization):**

| id | select_type | table | type | possible_keys | key  | rows    | filtered | Extra       |
|----|-------------|-------|------|---------------|------|---------|----------|-------------|
| 1  | SIMPLE      | users | ALL  | NULL          | NULL | 996,763 | 10%      | Using where |

**Finding:** `type: ALL` — full table scan across ~997K rows. No index on `name` column.

---

## 2. Table Structure

```sql
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `age` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1048561
  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

Only a `PRIMARY KEY` on `id`. The `name` column used in the WHERE clause had **no index**.

---

## 3. Execution & Remediation

**Root Cause:** Missing index on `users.name` forced a full table scan on every lookup.

**Applied SQL:**
```sql
ALTER TABLE users ADD INDEX idx_users_name (name);
```

Executed successfully with no warnings.

---

## 4. Post-Optimization Verification

**EXPLAIN Plan (After Optimization):**

| id | select_type | table | type | possible_keys  | key            | rows | filtered | Extra |
|----|-------------|-------|------|----------------|----------------|------|----------|-------|
| 1  | SIMPLE      | users | ref  | idx_users_name | idx_users_name | 1    | 100%     | NULL  |

**Result:**
- `type` changed from `ALL` → `ref` ✅
- `key` now shows `idx_users_name` ✅
- Rows scanned dropped from **996,763 → 1** ✅
- `filtered` improved from **10% → 100%** ✅

**Performance improvement: ~996,762x fewer rows scanned.**
