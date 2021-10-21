-- Run in the database you want to document.

-- Convention checks. Edit the patterns to suit your shop.
SELECT 'Primary key not named PK_<table>' AS finding, kc.name AS object_name
FROM sys.key_constraints AS kc
WHERE kc.type = 'PK' AND kc.name <> 'PK_' + OBJECT_NAME(kc.parent_object_id)
UNION ALL
SELECT 'Foreign key not named FK_<child>_<parent>', fk.name
FROM sys.foreign_keys AS fk
WHERE fk.name <> 'FK_' + OBJECT_NAME(fk.parent_object_id) + '_' + OBJECT_NAME(fk.referenced_object_id)
UNION ALL
SELECT 'Index not named IX_/UX_ prefix', i.name
FROM sys.indexes AS i
JOIN sys.tables AS t ON t.object_id = i.object_id
WHERE i.type > 0 AND i.is_primary_key = 0 AND i.is_unique_constraint = 0
  AND i.name NOT LIKE 'IX[_]%' AND i.name NOT LIKE 'UX[_]%'
UNION ALL
SELECT 'Table without a primary key', OBJECT_SCHEMA_NAME(t.object_id) + '.' + t.name
FROM sys.tables AS t
WHERE t.is_ms_shipped = 0
  AND NOT EXISTS (SELECT 1 FROM sys.indexes AS i WHERE i.object_id = t.object_id AND i.is_primary_key = 1)
UNION ALL
SELECT 'Foreign key column without a supporting index', fk.name
FROM sys.foreign_keys AS fk
JOIN sys.foreign_key_columns AS fkc ON fkc.constraint_object_id = fk.object_id AND fkc.constraint_column_id = 1
WHERE NOT EXISTS (SELECT 1 FROM sys.index_columns AS ic
                  WHERE ic.object_id = fk.parent_object_id AND ic.column_id = fkc.parent_column_id AND ic.key_ordinal = 1);
