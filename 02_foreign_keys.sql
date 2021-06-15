-- Run in the database you want to document.

SELECT fk.name AS fk_name,
       OBJECT_SCHEMA_NAME(fk.parent_object_id) + '.' + OBJECT_NAME(fk.parent_object_id)         AS child_table,
       STRING_AGG(pc.name, ', ') WITHIN GROUP (ORDER BY fkc.constraint_column_id)               AS child_columns,
       OBJECT_SCHEMA_NAME(fk.referenced_object_id) + '.' + OBJECT_NAME(fk.referenced_object_id) AS parent_table,
       STRING_AGG(rc.name, ', ') WITHIN GROUP (ORDER BY fkc.constraint_column_id)               AS parent_columns,
       fk.delete_referential_action_desc AS on_delete,
       fk.update_referential_action_desc AS on_update,
       fk.is_disabled,
       fk.is_not_trusted
FROM sys.foreign_keys AS fk
JOIN sys.foreign_key_columns AS fkc ON fkc.constraint_object_id = fk.object_id
JOIN sys.columns AS pc ON pc.object_id = fkc.parent_object_id     AND pc.column_id = fkc.parent_column_id
JOIN sys.columns AS rc ON rc.object_id = fkc.referenced_object_id AND rc.column_id = fkc.referenced_column_id
GROUP BY fk.name, fk.parent_object_id, fk.referenced_object_id,
         fk.delete_referential_action_desc, fk.update_referential_action_desc, fk.is_disabled, fk.is_not_trusted
ORDER BY child_table, fk_name;
