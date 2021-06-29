-- Run in the database you want to document.

-- Convention: the description lives in an extended property named MS_Description,
-- the same one SSMS table designer uses.
SELECT OBJECT_SCHEMA_NAME(t.object_id) + '.' + t.name AS table_name,
       CAST(NULL AS SYSNAME)                          AS column_name,
       CAST(ep.value AS NVARCHAR(4000))               AS description
FROM sys.tables AS t
LEFT JOIN sys.extended_properties AS ep
       ON ep.class = 1 AND ep.major_id = t.object_id AND ep.minor_id = 0 AND ep.name = N'MS_Description'
WHERE t.is_ms_shipped = 0
UNION ALL
SELECT OBJECT_SCHEMA_NAME(t.object_id) + '.' + t.name,
       c.name,
       CAST(ep.value AS NVARCHAR(4000))
FROM sys.tables AS t
JOIN sys.columns AS c ON c.object_id = t.object_id
LEFT JOIN sys.extended_properties AS ep
       ON ep.class = 1 AND ep.major_id = t.object_id AND ep.minor_id = c.column_id AND ep.name = N'MS_Description'
WHERE t.is_ms_shipped = 0
ORDER BY table_name, column_name;
