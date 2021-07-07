CREATE OR ALTER PROCEDURE dbo.usp_SetDescription
    @Schema NVARCHAR(128),
    @Table  NVARCHAR(128),
    @Column NVARCHAR(128) = NULL,
    @Text   NVARCHAR(3750)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @exists BIT = 0;

    IF @Column IS NULL
    BEGIN
        IF EXISTS (SELECT 1 FROM sys.fn_listextendedproperty(N'MS_Description', N'SCHEMA', @Schema, N'TABLE', @Table, NULL, NULL))
            EXEC sys.sp_updateextendedproperty N'MS_Description', @Text,
                 N'SCHEMA', @Schema, N'TABLE', @Table;
        ELSE
            EXEC sys.sp_addextendedproperty N'MS_Description', @Text,
                 N'SCHEMA', @Schema, N'TABLE', @Table;
    END
    ELSE
    BEGIN
        IF EXISTS (SELECT 1 FROM sys.fn_listextendedproperty(N'MS_Description', N'SCHEMA', @Schema, N'TABLE', @Table, N'COLUMN', @Column))
            EXEC sys.sp_updateextendedproperty N'MS_Description', @Text,
                 N'SCHEMA', @Schema, N'TABLE', @Table, N'COLUMN', @Column;
        ELSE
            EXEC sys.sp_addextendedproperty N'MS_Description', @Text,
                 N'SCHEMA', @Schema, N'TABLE', @Table, N'COLUMN', @Column;
    END
END
GO

-- EXEC dbo.usp_SetDescription @Schema = N'dbo', @Table = N'Orders', @Text = N'One row per customer order.';
-- EXEC dbo.usp_SetDescription @Schema = N'dbo', @Table = N'Orders', @Column = N'Status', @Text = N'0 new, 1 paid, 2 shipped.';
