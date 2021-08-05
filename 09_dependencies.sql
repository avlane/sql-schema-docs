-- Run in the database you want to document.

-- What does each procedure, view and function reference?
-- Dependencies on objects in other databases show up with referenced_id = NULL.
SELECT OBJECT_SCHEMA_NAME(d.referencing_id) + '.' + OBJECT_NAME(d.referencing_id) AS referencing_object,
       o.type_desc AS referencing_type,
       COALESCE(d.referenced_database_name + '.', '') + COALESCE(d.referenced_schema_name + '.', '') + d.referenced_entity_name AS referenced_object,
       d.referenced_class_desc,
       d.is_ambiguous
FROM sys.sql_expression_dependencies AS d
JOIN sys.objects AS o ON o.object_id = d.referencing_id
WHERE o.is_ms_shipped = 0
ORDER BY referencing_object, referenced_object;

-- Caveat: references from dynamic SQL are not tracked, and a stale dependency list
-- can be refreshed with sys.sp_refreshsqlmodule.
