CREATE OR ALTER PROCEDURE dbo.usp_DocSchema
    @Schema SYSNAME = N'dbo'
AS
BEGIN
    SET NOCOUNT ON;

    -- One result row holding the whole document, built with STRING_AGG
    SELECT STRING_AGG(CAST(page AS NVARCHAR(MAX)), CHAR(10) + CHAR(10)) WITHIN GROUP (ORDER BY table_name) AS markdown
    FROM (
        SELECT t.name AS table_name,
               N'## ' + @Schema + N'.' + t.name + CHAR(10)
               + ISNULL(CAST(tp.value AS NVARCHAR(4000)), N'_No description._') + CHAR(10) + CHAR(10)
               + N'| Column | Type | Null |' + CHAR(10) + N'|---|---|---|' + CHAR(10)
               + (SELECT STRING_AGG(N'| ' + c.name + N' | ' + TYPE_NAME(c.user_type_id) + N' | ' + IIF(c.is_nullable = 1, N'yes', N'no') + N' |', CHAR(10))
                         WITHIN GROUP (ORDER BY c.column_id)
                  FROM sys.columns AS c WHERE c.object_id = t.object_id) AS page
        FROM sys.tables AS t
        LEFT JOIN sys.extended_properties AS tp
               ON tp.class = 1 AND tp.major_id = t.object_id AND tp.minor_id = 0 AND tp.name = N'MS_Description'
        WHERE t.schema_id = SCHEMA_ID(@Schema) AND t.is_ms_shipped = 0
    ) AS pages;
END
GO
