-- Run in the database you want to document.

SELECT OBJECT_SCHEMA_NAME(i.object_id) + '.' + OBJECT_NAME(i.object_id) AS table_name,
       i.name AS index_name,
       i.type_desc,
       i.is_primary_key,
       i.is_unique,
       i.filter_definition,
       (SELECT STRING_AGG(c.name + IIF(ic.is_descending_key = 1, ' DESC', ''), ', ') WITHIN GROUP (ORDER BY ic.key_ordinal)
        FROM sys.index_columns AS ic
        JOIN sys.columns AS c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
        WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id AND ic.is_included_column = 0 AND ic.key_ordinal > 0) AS key_columns,
       (SELECT STRING_AGG(c.name, ', ') WITHIN GROUP (ORDER BY c.name)
        FROM sys.index_columns AS ic
        JOIN sys.columns AS c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
        WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id AND ic.is_included_column = 1) AS included_columns
FROM sys.indexes AS i
JOIN sys.tables  AS t ON t.object_id = i.object_id
WHERE t.is_ms_shipped = 0 AND i.type > 0
ORDER BY table_name, i.index_id;
