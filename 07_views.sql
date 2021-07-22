-- Run in the database you want to document.

SELECT OBJECT_SCHEMA_NAME(v.object_id) + '.' + v.name AS view_name,
       OBJECTPROPERTY(v.object_id, 'IsSchemaBound') AS is_schema_bound,
       OBJECTPROPERTY(v.object_id, 'IsIndexed')     AS is_indexed,
       (SELECT STRING_AGG(c.name, ', ') WITHIN GROUP (ORDER BY c.column_id)
        FROM sys.columns AS c WHERE c.object_id = v.object_id) AS columns_list,
       m.definition
FROM sys.views AS v
JOIN sys.sql_modules AS m ON m.object_id = v.object_id
WHERE v.is_ms_shipped = 0
ORDER BY view_name;
