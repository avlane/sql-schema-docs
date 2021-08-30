-- Run in the database you want to document.

SELECT OBJECT_SCHEMA_NAME(t.object_id) + '.' + t.name AS table_name,
       c.name AS column_name,
       'missing' AS status
FROM sys.tables AS t
JOIN sys.columns AS c ON c.object_id = t.object_id
WHERE t.is_ms_shipped = 0
  AND NOT EXISTS (SELECT 1 FROM sys.extended_properties AS ep
                  WHERE ep.class = 1 AND ep.major_id = t.object_id AND ep.minor_id = c.column_id
                    AND ep.name = N'MS_Description')
UNION ALL
SELECT OBJECT_SCHEMA_NAME(t.object_id) + '.' + t.name, NULL, 'missing'
FROM sys.tables AS t
WHERE t.is_ms_shipped = 0
  AND NOT EXISTS (SELECT 1 FROM sys.extended_properties AS ep
                  WHERE ep.class = 1 AND ep.major_id = t.object_id AND ep.minor_id = 0
                    AND ep.name = N'MS_Description')
ORDER BY table_name, column_name;

-- Coverage summary
SELECT COUNT(*) AS columns_total,
       SUM(CASE WHEN ep.value IS NOT NULL THEN 1 ELSE 0 END) AS columns_described,
       CAST(100.0 * SUM(CASE WHEN ep.value IS NOT NULL THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) AS DECIMAL(5,1)) AS pct_described
FROM sys.tables AS t
JOIN sys.columns AS c ON c.object_id = t.object_id
LEFT JOIN sys.extended_properties AS ep
       ON ep.class = 1 AND ep.major_id = t.object_id AND ep.minor_id = c.column_id AND ep.name = N'MS_Description'
WHERE t.is_ms_shipped = 0;
