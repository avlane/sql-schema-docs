-- Run in the database you want to document.

SELECT s.name  AS schema_name,
       t.name  AS table_name,
       c.column_id,
       c.name  AS column_name,
       CASE
           WHEN ty.name IN ('varchar', 'char', 'varbinary', 'binary')
               THEN ty.name + '(' + IIF(c.max_length = -1, 'max', CAST(c.max_length AS VARCHAR(10))) + ')'
           WHEN ty.name IN ('nvarchar', 'nchar')
               THEN ty.name + '(' + IIF(c.max_length = -1, 'max', CAST(c.max_length / 2 AS VARCHAR(10))) + ')'
           WHEN ty.name IN ('decimal', 'numeric')
               THEN ty.name + '(' + CAST(c.precision AS VARCHAR(10)) + ',' + CAST(c.scale AS VARCHAR(10)) + ')'
           WHEN ty.name IN ('datetime2', 'datetimeoffset', 'time')
               THEN ty.name + '(' + CAST(c.scale AS VARCHAR(10)) + ')'
           ELSE ty.name
       END AS type_name,
       c.is_nullable,
       c.is_identity,
       c.is_computed,
       dc.definition AS default_definition
FROM sys.tables  AS t
JOIN sys.schemas AS s  ON s.schema_id = t.schema_id
JOIN sys.columns AS c  ON c.object_id = t.object_id
JOIN sys.types   AS ty ON ty.user_type_id = c.user_type_id
LEFT JOIN sys.default_constraints AS dc ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
WHERE t.is_ms_shipped = 0
ORDER BY s.name, t.name, c.column_id;
