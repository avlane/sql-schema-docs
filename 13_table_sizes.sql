-- Run in the database you want to document.

SELECT OBJECT_SCHEMA_NAME(ps.object_id) + '.' + OBJECT_NAME(ps.object_id) AS table_name,
       SUM(CASE WHEN ps.index_id IN (0, 1) THEN ps.row_count ELSE 0 END) AS row_count,
       CAST(SUM(ps.reserved_page_count) * 8 / 1024.0 AS DECIMAL(12,2))    AS reserved_mb,
       CAST(SUM(ps.used_page_count) * 8 / 1024.0 AS DECIMAL(12,2))        AS used_mb
FROM sys.dm_db_partition_stats AS ps
JOIN sys.tables AS t ON t.object_id = ps.object_id
WHERE t.is_ms_shipped = 0
GROUP BY ps.object_id
ORDER BY reserved_mb DESC;
