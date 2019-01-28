sp_configure 'show advanced options', 1;
GO
reconfigure;
Go
sp_configure 'clr enabled', 1;
GO
reconfigure;
GO
CREATE assembly DemoSQLCLR from 'C:\Users\vh_ca_000\Documents\Visual Studio 2015\Projects\SQLProyect\SQLProyect\bin\Debug\SQLProyect.dll' with permission_set = safe
GO
Create procedure InsertarCliente
	@customerid nvarchar(5),
	@companyname nvarchar(150),
	@contactname nvarchar(150)
as external name [DemoSQLCLR].[StoredProcedures].[InsertarCliente]
GO

execute InsertarCliente 'AMERI','German Garcia','German Garcia'
GO

Select * from customers
GO

Create procedure ClrSplit
@Text nvarchar(50),	@Separator nvarchar(150)
as external name DemoSQLCLR.StoredProcedures.ClrSplit
GO

execute ClrSplit 'Esta, es, una, prueba, de, funcionamiento',','
go