-- Small sample schema used for the output shown in the README.
USE master;
GO
IF DB_ID(N'SchemaDocsDemo') IS NOT NULL
BEGIN
    ALTER DATABASE SchemaDocsDemo SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SchemaDocsDemo;
END
GO
CREATE DATABASE SchemaDocsDemo;
GO
USE SchemaDocsDemo;
GO

CREATE TABLE dbo.Customers
(
    CustomerId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Customers PRIMARY KEY,
    Name       NVARCHAR(100) NOT NULL,
    Email      NVARCHAR(200) NULL,
    CreatedAt  DATETIME2(0)  NOT NULL CONSTRAINT DF_Customers_Created DEFAULT (SYSDATETIME())
);

CREATE TABLE dbo.Orders
(
    OrderId    INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Orders PRIMARY KEY,
    CustomerId INT NOT NULL CONSTRAINT FK_Orders_Customers REFERENCES dbo.Customers (CustomerId),
    Status     TINYINT NOT NULL CONSTRAINT DF_Orders_Status DEFAULT (0) CONSTRAINT CK_Orders_Status CHECK (Status BETWEEN 0 AND 3),
    Total      DECIMAL(12,2) NOT NULL
);
CREATE NONCLUSTERED INDEX IX_Orders_CustomerId ON dbo.Orders (CustomerId) INCLUDE (Total);
GO
