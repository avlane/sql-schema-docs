-- Run in the database you want to document.

-- Paste the output into a ```mermaid block to get an ER diagram of the FK graph.
SELECT line
FROM (
    SELECT 0 AS ord, CAST(N'erDiagram' AS NVARCHAR(400)) AS line
    UNION ALL
    SELECT 1 + ROW_NUMBER() OVER (ORDER BY pt.name, ct.name, fk.name),
           N'    ' + pt.name + N' ||--o{ ' + ct.name + N' : "' + fk.name + N'"'
    FROM sys.foreign_keys AS fk
    JOIN sys.tables AS ct ON ct.object_id = fk.parent_object_id
    JOIN sys.tables AS pt ON pt.object_id = fk.referenced_object_id
) AS x
ORDER BY ord;
