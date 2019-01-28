--Creación de una base de Datos
Create Database Videos
on Primary
( Name=VideosData, filename='C:\data\VideosData.mdf'
,size=50MB         --el Mínimo es 512Kb, el predeterminado es 1MB,
,Filegrowth=25%      --default es 10%, minimo es 64KB
)
log on
( Name=VideosLog, filename='C:\data\VideosLog.ldf'
,size=25MB          --el Mínimo es 512Kb, el predeterminado es 1MB,
, Filegrowth=25%
)

Use Videos
go


/* opciones de bd -- son propiedades que tiene toda base de datos
auto_close, auto_create_statistics, auto_shrink
auto_update_statistics --cursores-- Cursor_close_on_commit
*/
--OPCION DE LA BD QUE CIERRA CUALQUIER CURSOR AUTOMATICAMENTE
Alter database Ejemplo
SET Cursor_close_on_commit ON
GO 
--PARA REVISAR ESTADO DE LAS OPCIONES
SELECT DATABASEPROPERTYEX('VENTAS','ISAUTOSHRINK')
--CONSULTAR INFORMACION DE GRUPOS
SP_HELPFILEGROUP GRUPOVENTAS
SP_HELPFILE VENTASDATA
USE MASTER
go
SP_HELP EJEMPLO
--CREACION DE GRUPOS 3 GRUPOS
ALTER DATABASE Lista
ADD FILEGROUP PARTICION1
GO
ALTER DATABASE Lista
ADD FILEGROUP PARTICION2
GO
ALTER DATABASE Lista
ADD FILEGROUP PARTICION3
GO
--CREACIÓN DE 3 ARCHIVOS PARA LOS FILEGROUP
ALTER DATABASE Lista
ADD FILE ( NAME = 'Parte1',
FILENAME = 'c:\Data\Particion1.ndf',SIZE = 5MB)
TO FILEGROUP PARTICION1
GO

ALTER DATABASE Lista
ADD FILE ( NAME = 'Parte2',
FILENAME = 'c:\Data\Particion2.ndf',SIZE = 5MB)
TO FILEGROUP PARTICION2
GO

ALTER DATABASE Lista
ADD FILE ( NAME = 'Parte3',
FILENAME = 'c:\Data\Particion3.ndf',SIZE = 5MB)
TO FILEGROUP PARTICION3
GO

--modificar el grupo primario
USE master
GO
ALTER DATABASE MyDatabase
MODIFY FILEGROUP [PRIMARY] DEFAULT
GO

--modificar un archivo
USE master
GO
ALTER DATABASE Ejemplo
MODIFY FILE    (NAME = 'Parte3',    SIZE = 20MB)
GO
USE NORTHWIND
GO
SP_HELPdb northwind
dbcc shrinkdatabase (northwind,10) --10 es el porcentaje de espacio libre que quedara
dbcc shrinkfile(northwind,2) --Reduce a 2MB el archivo de datos
---Romper el vínculo entre los archivos de la bd
use master
go
sp_detach_db 'northwind','true'
--vincular un archivo de base de datos
exec sp_attach_db 'Northwind'
,'C:\Archivos de programa\Microsoft SQL Server\MSSQL\Data\northwnd.mdf'
,'C:\Archivos de programa\Microsoft SQL Server\MSSQL\Data\northwnd.ldf'
--Creacion de Instantaneas------------
CREATE DATABASE AdventureWorks_dbss1800 ON
( NAME = AdventureWorks_Data, FILENAME =
'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\Data\AdventureWorks_data_1800.ss' )
AS SNAPSHOT OF AdventureWorks;
GO

---Funcion de partición--------------
--Left incluirá a los datos hasta la I y luego despues de la I hasta la P y luego todos despues de la p
--Right inluirá antes de la I, luego de la I hasta antes de la P  y luego de la p en adelante
CREATE PARTITION FUNCTION FuncionDeParticion (varchar(500)) 
AS RANGE RIGHT 
FOR VALUES ('I', 'P');
GO
---Crear esquema de particion--------
CREATE PARTITION SCHEME SchemaParticion AS PARTITION FuncionDeParticion 
TO (PARTICION1, PARTICION2, PARTICION3);
GO
---Crear tabla particionada----------
CREATE TABLE dbo.personas
(
	NumeroOrden varchar(10),
	NumeroRegistro bigint,
	Nombre1 varchar(150),
	Nombre2 varchar(150),
	Apellido1 varchar(500),
	Apellido2 varchar(150)
)
ON SchemaParticion(Apellido1);
GO
Insert into personas (	NumeroOrden,NumeroRegistro,
	Nombre1, Nombre2, Apellido1, Apellido2)
Select ORDEN_CED, NUMREG_CED, NOM1,NOM2, APE1,APE2 
from Ciudadano.dbo.Ciudadano
GO

Select Apellido1, $partition.FuncionDeParticion(Apellido1) as particion
from personas
GO
---Crear un indice particionado
Create nonclustered index idx_Apellido
on personas (Apellido1)
include (NumeroOrden,NumeroRegistro)
on SchemaParticion(Apellido1)

