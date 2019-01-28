/*
** Create In-Memory OLTP Database 
**
** Database Name is CiudadanoInMemory; modify if needed
** Path for the memory_optimized_data filegroup is 'c:\data\'; modify if needed
*/

SET NOCOUNT ON
GO

USE master
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name='CiudadanoInMemory')
DROP DATABASE [CiudadanoInMemory]
GO

CREATE DATABASE [CiudadanoInMemory] 
	COLLATE Latin1_General_100_CI_AS
GO

ALTER DATABASE [CiudadanoInMemory] 
	ADD FILEGROUP [CiudadanoInMemory_mod] 
	CONTAINS MEMORY_OPTIMIZED_DATA
GO

ALTER DATABASE [CiudadanoInMemory] 
	ADD FILE(
		NAME = 'CiudadanoInMemory_mod_dir', 
		FILENAME='c:\data\CiudadanoInMemory_mod') 
	TO FILEGROUP [CiudadanoInMemory_mod]
GO

/*
** Creating memory-optimized tables
*/

SET QUOTED_IDENTIFIER ON
GO

USE [CiudadanoInMemory]
GO


-- ===============================================================================================================
-- Drop tables if they exist
-- ===============================================================================================================

IF EXISTS (SELECT name FROM sysobjects WHERE name = 'DiskBasedCiudadanoTable')
   DROP TABLE [DiskBasedCiudadanoTable]
GO

IF EXISTS (SELECT name FROM sysobjects WHERE name = 'MemoryOptimizedCiudadanoTable')
   DROP TABLE [MemoryOptimizedCiudadanoTable]
GO

-- ===============================================================================================================
-- Create disk-based table 
-- ===============================================================================================================

CREATE TABLE [DiskBasedCiudadanoTable]
(
[CODIGO] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
NOM1 NCHAR(150) NULL,
NOM2 NCHAR(150) NULL,
APE1 NCHAR(200) NULL,
APE2 NCHAR(200) NULL
)
GO

-- ===============================================================================================================
-- Create memory-optimized tables 
-- ===============================================================================================================
CREATE TABLE [MemoryOptimizedCiudadanoTable]
(
[CODIGO] INT IDENTITY(1,1) NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT=1000000),
NOM1 NCHAR(150)  NULL,
NOM2 NCHAR(150)  NULL,
APE1 NCHAR(200)  NULL,
APE2 NCHAR(200)  NULL
) WITH (MEMORY_OPTIMIZED=ON, DURABILITY = SCHEMA_AND_DATA)
GO

Insert into DiskBasedCiudadanoTable (Nom1, Nom2, Ape1, Ape2)
Select NOM1, NOM2, APE1, APE2 from ciudadano.dbo.ciudadano
go

Insert into MemoryOptimizedCiudadanoTable (Nom1, Nom2, Ape1, Ape2)
Select NOM1, NOM2, APE1, APE2 from DiskBasedCiudadanoTable
go


Select nom1, nom2, ape1 from 
MemoryOptimizedCiudadanoTable where nom1='Victor' and nom2='Hugo'
and ape1='Cardenas'