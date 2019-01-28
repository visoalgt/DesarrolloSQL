------Activar Filestream --------------------------
EXEC sp_configure filestream_access_level, 2  
RECONFIGURE  
go
Alter Database Northwind
add Filegroup fileStreamGroup contains filestream
go
Alter Database Northwind
add file 
(name='FileStreamFile1',
filename='C:\Data\TextFileStream1.ndf'
) to filegroup fileStreamGroup
go
Create table NuevoCliente
( codigo uniqueidentifier rowguidcol not null unique
, nombre varchar(150),
archivoadjunto varbinary(max) filestream null
)
go
Insert into NuevoCliente (codigo, nombre, archivoadjunto)
values (newid(), 'Carlos Garcia', Cast('Esta es una Prueba' as varbinary(max))
go

Select nombre, archivoadjunto.PathName() as Ubicacion
 from dbo.NuevoCliente
go

