# Optimization Report: users (query for 'user_1000')

## 1. Initial Diagnosis
* **Slow Query:** `SELECT * FROM users WHERE name = 'user_1000';`
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
* **Post-EXPLAIN:** Query uses `idx_users_name` with `type = ref` and `rows = 1`, indicating the index is used and the query is efficient for this point lookup.

## Notes
No schema changes applied. The existing `idx_users_name` index provides efficient lookups for `WHERE name = ...` equality filters.
