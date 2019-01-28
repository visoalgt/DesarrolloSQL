---Tablas Particionadas
----Crear la base de datos
Create database Empresa
on Primary
(name=EmpresaData, Filename='C:\Data\Empresa.mdf'
, size=50MB, Filegrowth=25%)
log on
(name=EmpresaLog, Filename='C:\Data\EmpresaLog.mdf'
, size=25MB, Filegrowth=25%)
go
--Ademas del del filegroup primary, puedo crear grupos adicionales
Alter Database Empresa
add Filegroup GrupoParti1
go
Alter Database Empresa
add Filegroup GrupoParti2
go
Alter Database Empresa
add Filegroup GrupoParti3
go
---Asociar archivos a los filegroups
Alter Database Empresa
add file (name=EmpresaParte1, Filename='C:\Data\EmpresaParte1.ndf'
, size=15MB, Filegrowth=25%) to filegroup  GrupoParti1
go
Alter Database Empresa
add file (name=EmpresaParte2, Filename='C:\Data\EmpresaParte2.ndf'
, size=15MB, Filegrowth=25%) to filegroup  GrupoParti2
go
Alter Database Empresa
add file (name=EmpresaParte3, Filename='C:\Data\EmpresaParte3.ndf'
, size=15MB, Filegrowth=25%) to filegroup  GrupoParti3
go
-----Crear la Funcion para la division en tablas particionadas
Use Empresa
go
sp_helpdb Empresa
go
use Empresa
go
Create partition function FuncionDeParticion(varchar(150))
as Range right
for values ('I','P')
go
------Crear el esquema que indica los rangos a que particiones van
Create partition scheme SchemaParticion as Partition FuncionDeParticion
to (GrupoParti1, GrupoParti2,GrupoParti3)
go
---crear tabla particionada
Create Table Personas
(numeroOrden varchar(10),
numeroRegistro bigint,
nombre1 varchar(150),
nombre2 varchar(150),
apellido1 varchar(150),
apellido2 varchar(150)
)
on SchemaParticion(Apellido1)
go

Restore Database Ciudadano
from disk='C:\Backups\Ciudadano2.bak'
with recovery

Insert into personas (
numeroOrden ,numeroRegistro,nombre1 ,nombre2 ,apellido1,apellido2 )
Select orden_ced, numreg_ced, nom1, nom2, ape1, ape2 
from Ciudadano.dbo.ciudadano

---Verificar los datos en que particion estan
Select Apellido1, $partition.FuncionDeParticion(Apellido1) as particion
from personas
go

---Indices particionados
Create nonclustered index idx_apellido
on personas (Apellido1)
on SchemaParticion(Apellido1)
go
---Dividir con split en otra particion los datos
Alter Database Empresa
add Filegroup GrupoParti4
go
Alter Database Empresa
add file (name=ListaParte4, Filename='C:\Data\ListaParte4.ndf'
, size=15MB, Filegrowth=25%) to filegroup  GrupoParti4
go
Alter partition scheme SchemaParticion next used GrupoParti4
go
Alter partition function FuncionDeParticion() split range ('L')
go

---Volver a unir las particiones
Alter partition function FuncionDeParticion() merge range ('L')
go


-----Compresion de una tabla
ALTER TABLE Personas REBUILD WITH (DATA_COMPRESSION=PAGE)

ALTER TABLE Personas REBUILD PARTITION = ALL
WITH
(DATA_COMPRESSION = PAGE)

----Tablas Versionadas
Create Table individuos
(
numeroRegistro bigint identity(1,1) primary key,
nombre1 varchar(150),
nombre2 varchar(150),
apellido1 varchar(150),
apellido2 varchar(150),
SysStartTime datetime2 GENERATED ALWAYS AS ROW START NOT NULL,
SysEndTime datetime2 GENERATED ALWAYS AS ROW END NOT NULL,  
PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)  
) 
WITH (SYSTEM_VERSIONING = ON)
---Insertar datos a la tabla versionada
SELECT [numeroRegistro]      ,[nombre1]
      ,[nombre2]      ,[apellido1]
      ,[apellido2]      ,[SysStartTime]
      ,[SysEndTime]
  FROM [dbo].[MSSQL_TemporalHistoryFor_1074102867]

Insert into individuos (
nombre1 ,nombre2 ,apellido1,apellido2 )
Select  nom1, nom2, ape1, ape2 
from Ciudadano.dbo.ciudadano
where edad=50
go
Update individuos set nombre1='ARNOLDO'
where nombre1='AROLDO'
