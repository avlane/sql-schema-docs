CREATE OR ALTER PROCEDURE dbo.usp_DocTable
    @Schema SYSNAME,
    @Table  SYSNAME
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @object_id INT = OBJECT_ID(QUOTENAME(@Schema) + N'.' + QUOTENAME(@Table));
    IF @object_id IS NULL
        THROW 50001, N'Table not found.', 1;

    DECLARE @desc NVARCHAR(4000) =
        (SELECT CAST(value AS NVARCHAR(4000)) FROM sys.extended_properties
         WHERE class = 1 AND major_id = @object_id AND minor_id = 0 AND name = N'MS_Description');

    SELECT line
    FROM (
        SELECT 0 AS ord, N'## ' + @Schema + N'.' + @Table AS line
        UNION ALL SELECT 1, ISNULL(@desc, N'_No description._')
        UNION ALL SELECT 2, N'| Column | Type | Null | Description |'
        UNION ALL SELECT 3, N'|---|---|---|---|'
        UNION ALL
        SELECT 10 + c.column_id,
               N'| ' + c.name
               + N' | ' + TYPE_NAME(c.user_type_id)
               + N' | ' + IIF(c.is_nullable = 1, N'yes', N'no')
               + N' | ' + ISNULL(CAST(ep.value AS NVARCHAR(4000)), N'')
               + N' |'
        FROM sys.columns AS c
        LEFT JOIN sys.extended_properties AS ep
               ON ep.class = 1 AND ep.major_id = c.object_id AND ep.minor_id = c.column_id AND ep.name = N'MS_Description'
        WHERE c.object_id = @object_id
    ) AS x
    ORDER BY ord;
END
GO
