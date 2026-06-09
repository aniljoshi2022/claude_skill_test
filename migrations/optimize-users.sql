# Optimization Report: users

## 1. Initial Diagnosis
* **Slow Query:** `SELECT * FROM users WHERE name = 'user_10000';`
* **Initial EXPLAIN:**
```
[ { "id": "1", "select_type": "SIMPLE", "table": "users", "type": "ref", "possible_keys": "idx_users_name", "key": "idx_users_name", "key_len": "403", "ref": "const", "rows": "1", "filtered": 100, "Extra": null } ]
```

## 2. Table Structure
```
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `age` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_users_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1048561 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

## 3. Execution & Remediation
* **Applied SQL:** None required — an index on `name` already exists (`idx_users_name`).

## 4. Post-Optimization Verification
* **Post-EXPLAIN:** (same as initial) Query uses `idx_users_name` with `type = ref` and `rows = 1`, proving the query is already using an index efficiently.

## Notes
This query is already optimal for point lookups by `name`. No schema changes were applied.
