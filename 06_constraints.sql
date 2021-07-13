-- Run in the database you want to document.

SELECT OBJECT_SCHEMA_NAME(cc.parent_object_id) + '.' + OBJECT_NAME(cc.parent_object_id) AS table_name,
       cc.name AS constraint_name,
       'CHECK' AS kind,
       COALESCE(c.name, '(table level)') AS column_name,
       cc.definition,
       cc.is_disabled,
       cc.is_not_trusted
FROM sys.check_constraints AS cc
LEFT JOIN sys.columns AS c ON c.object_id = cc.parent_object_id AND c.column_id = cc.parent_column_id
UNION ALL
SELECT OBJECT_SCHEMA_NAME(dc.parent_object_id) + '.' + OBJECT_NAME(dc.parent_object_id),
       dc.name,
       'DEFAULT',
       c.name,
       dc.definition,
       0,
       0
FROM sys.default_constraints AS dc
JOIN sys.columns AS c ON c.object_id = dc.parent_object_id AND c.column_id = dc.parent_column_id
UNION ALL
SELECT OBJECT_SCHEMA_NAME(kc.parent_object_id) + '.' + OBJECT_NAME(kc.parent_object_id),
       kc.name,
       kc.type_desc,
       NULL,
       NULL,
       0,
       0
FROM sys.key_constraints AS kc
ORDER BY table_name, kind, constraint_name;
