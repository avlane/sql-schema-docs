USE SchemaDocsDemo;
GO
:r ../05_set_description.sql

EXEC dbo.usp_SetDescription N'dbo', N'Customers', NULL, N'One row per customer.';
EXEC dbo.usp_SetDescription N'dbo', N'Customers', N'Email', N'Primary contact address; optional.';
EXEC dbo.usp_SetDescription N'dbo', N'Orders', NULL, N'One row per customer order.';
EXEC dbo.usp_SetDescription N'dbo', N'Orders', N'Status', N'0 new, 1 paid, 2 shipped, 3 cancelled.';
GO
