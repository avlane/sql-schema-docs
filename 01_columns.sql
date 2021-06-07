-- Run in the database you want to document.

SELECT s.name  AS schema_name,
       t.name  AS table_name,
       c.column_id,
       c.name  AS column_name,
       ty.name AS type_name,
       c.max_length,
       c.precision,
       c.scale,
       c.is_nullable
FROM sys.tables  AS t
JOIN sys.schemas AS s  ON s.schema_id = t.schema_id
JOIN sys.columns AS c  ON c.object_id = t.object_id
JOIN sys.types   AS ty ON ty.user_type_id = c.user_type_id
WHERE t.is_ms_shipped = 0
ORDER BY s.name, t.name, c.column_id;
