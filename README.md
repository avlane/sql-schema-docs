# sql-schema-docs

T-SQL scripts that turn a database's catalog views and extended properties into documentation: tables, columns, keys, indexes, routines and dependencies, with a Markdown generator at the end.

Needs SQL Server 2017 or later (uses `STRING_AGG` and `CREATE OR ALTER`).

## Files

- `01_columns.sql` lists every user table and its columns.
