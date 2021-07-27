-- Run in the database you want to document.

SELECT OBJECT_SCHEMA_NAME(o.object_id) + '.' + o.name AS routine_name,
       o.type_desc,
       o.create_date,
       o.modify_date,
       (SELECT STRING_AGG(p.name + ' ' + TYPE_NAME(p.user_type_id)
                          + IIF(p.is_output = 1, ' OUTPUT', '')
                          + IIF(p.has_default_value = 1, ' = ...', ''), ', ')
               WITHIN GROUP (ORDER BY p.parameter_id)
        FROM sys.parameters AS p
        WHERE p.object_id = o.object_id AND p.parameter_id > 0) AS parameters
FROM sys.objects AS o
WHERE o.type IN ('P', 'FN', 'IF', 'TF') AND o.is_ms_shipped = 0
ORDER BY o.type_desc, routine_name;
