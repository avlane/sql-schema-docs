-- Run in the database you want to document.

-- Per-table flags worth knowing about when documenting: temporal, memory-optimized,
-- partitioned, compressed, computed columns.
SELECT OBJECT_SCHEMA_NAME(t.object_id) + '.' + t.name AS table_name,
       t.temporal_type_desc,
       t.is_memory_optimized,
       t.lock_escalation_desc,
       (SELECT COUNT(*) FROM sys.columns AS c WHERE c.object_id = t.object_id AND c.is_computed = 1) AS computed_columns,
       (SELECT COUNT(DISTINCT p.partition_number) FROM sys.partitions AS p WHERE p.object_id = t.object_id AND p.index_id IN (0, 1)) AS partitions,
       (SELECT MAX(p.data_compression_desc) FROM sys.partitions AS p WHERE p.object_id = t.object_id AND p.index_id IN (0, 1)) AS data_compression
FROM sys.tables AS t
WHERE t.is_ms_shipped = 0
ORDER BY table_name;

-- For system-versioned tables, which table holds the history?
SELECT OBJECT_SCHEMA_NAME(t.object_id) + '.' + t.name AS table_name,
       OBJECT_SCHEMA_NAME(h.object_id) + '.' + h.name AS history_table
FROM sys.tables AS t
JOIN sys.tables AS h ON h.object_id = t.history_table_id
WHERE t.temporal_type = 2;
