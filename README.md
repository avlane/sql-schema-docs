# sql-schema-docs

T-SQL scripts that turn a database's catalog views and extended properties into documentation: tables, columns, keys, indexes, routines and dependencies, with a Markdown generator at the end.

Needs SQL Server 2017 or later (uses `STRING_AGG`, `IIF` and `CREATE OR ALTER`).

## Files

| Script | What it reports |
|---|---|
| `01_columns.sql` | every user table's columns with DDL-style types, identity, computed, defaults |
| `02_foreign_keys.sql` | foreign keys, with columns and actions |
| `03_indexes.sql` | key and included columns, filters |
| `04_descriptions.sql` | `MS_Description` extended properties |
| `05_set_description.sql` | `dbo.usp_SetDescription` to add or update one |
| `06_constraints.sql` | check, default and key constraints |
| `07_views.sql` | views and their columns |
| `08_routines.sql` | procedures and functions with parameters |
| `09_dependencies.sql` | `sys.sql_expression_dependencies` |
| `10_markdown_table.sql` | `dbo.usp_DocTable`: one table as Markdown |
| `11_markdown_schema.sql` | `dbo.usp_DocSchema`: a whole schema as one Markdown value |
| `12_missing_descriptions.sql` | undocumented tables and columns, coverage percentage |
| `13_table_sizes.sql` | rows and MB per table |
| `14_mermaid_er.sql` | FK graph as a Mermaid `erDiagram` |
| `15_naming_checks.sql` | naming and design convention findings |
| `16_table_features.sql` | temporal, partitioned, compressed, computed |
| `demo/` | a small database to try everything on |

## Try it

```
sqlcmd -S localhost -i demo/demo_database.sql
sqlcmd -S localhost -d SchemaDocsDemo -i demo/demo_descriptions.sql
sqlcmd -S localhost -d SchemaDocsDemo -i 10_markdown_table.sql
```

`EXEC dbo.usp_DocTable N'dbo', N'Orders';` returns:

```
## dbo.Orders
One row per customer order.
| Column | Type | Null | Description |
|---|---|---|---|
| OrderId | int | no |  |
| CustomerId | int | no |  |
| Status | tinyint | no | 0 new, 1 paid, 2 shipped, 3 cancelled. |
| Total | decimal | no |  |
```

`14_mermaid_er.sql` on the demo database:

```
erDiagram
    Customers ||--o{ Orders : "FK_Orders_Customers"
```

Coverage query from `12_missing_descriptions.sql`:

```
columns_total  columns_described  pct_described
-------------  -----------------  -------------
8              2                  25.0
```
