---1. Crea un procedimiento en la base de datos Activa
USE NORTHWIND
GO
CREATE PROC DBO.ORDENESNOENTREGADAS
AS
SELECT * FROM ORDERS WHERE ORDERDATE
BETWEEN '1996-01-01' AND '1996-31-12'
---2.Información de Procedimientos
EXEC SP_HELP ORDENESNOENTREGADAS
EXEC SP_DEPENDS ORDENESNOENTREGADAS
EXEC SP_HELPTEXT ORDENESNOENTREGADAS
EXEC SP_STORED_PROCEDURES
SELECT * FROM SYSOBJECTS
SELECT * FROM SYSCOMMENTS
SELECT * FROM SYSDEPENDS
---3.Ejecucion de un procedimiento
EXEC ORDENESNOENTREGADAS
sp_executesql ORDENESNOENTREGADAS ---USAR SP_EXECUTESQL ES MAS OPTIMO PORQUE GENERA PLANES DE EJECUCION DINAMICAMENTE
EXEC ORDENESNOENTREGADAS WITH RECOMPILE ---EXIGE QUE SE RECOMPILE UN NUEVO PLAN
---4.Agregar datos con Insert Into partiendo del resultado del procedimiento
CREATE TABLE [PEDIDOS96]
(
      [OrderID] [int]  NOT NULL ,
      [CustomerID] [nchar](5)  ,
      [EmployeeID] [int] NULL ,
      [OrderDate] [datetime] NULL ,
      [RequiredDate] [datetime] NULL ,
      [ShippedDate] [datetime] NULL ,
      [ShipVia] [int] NULL ,
      [Freight] [money] NULL  DEFAULT (0),
      [ShipName] [nvarchar](40)  NULL ,
      [ShipAddress] [nvarchar](60)  NULL ,
      [ShipCity] [nvarchar](15) NULL ,
      [ShipRegion] [nvarchar](15)  NULL ,
      [ShipPostalCode] [nvarchar](10)  NULL ,
      [ShipCountry] [nvarchar](15)  NULL ,
)
ON [PRIMARY]
GO
INSERT INTO PEDIDOS96
EXEC ORDENESNOENTREGADAS
Select into
---5. Modificar el procedimiento almacenado
ALTER PROC DBO.ORDENESNOENTREGADAS
AS
SELECT * FROM ORDERS WHERE ORDERDATE
BETWEEN '1998-01-01' AND '1998-31-12'
---6.Para eliminar el procedimiento almacenado en la base de datos activa
DROP PROC DBO.ORDENESNOENTREGADAS
---7. Parametros de Entrada
CREATE Proc Insercion
@Tabla1 bit,@compañia varchar(50),@contacto varchar(50)
,@titulo varchar(50),@direccion varchar(50)
as
DECLARE @codigo varchar(50)
SET @codigo=substring(convert(varchar(10),rand()),3,5)
if @Tabla1=1
begin
insert suppliers(companyname,contactname,contacttitle,address)
values
(@compañia,@contacto,@titulo,@direccion)
end
else
begin
insert customers(customerid,companyname,contactname,contacttitle,address)
values
(@codigo,@compañia,@contacto,@titulo,@direccion)
end
---8. Ejecucion con Parametros de entrada
exec insercion
      @compañia='cardenas inc',@contacto='Luis',@titulo='Ing',@direccion='18calle 1-6 Z.1′
exec Insercion0,'cardenas inc9','Victor Cardenas','Ing.','30av 23-56 Z.5′
---9.Recompilar un procedimiento Y ESTABLECER ERRORES
ALTER PROC TESTRECOMPILACION
@VALOR  INT
WITH RECOMPILE
AS
DECLARE @STRING VARCHAR(200)
SET @STRING='SELECT TOP '+ CONVERT(CHAR(1),@VALOR) + ' * FROM ORDERS ORDER BY ORDERID'
EXECUTE (@STRING)
IF @@ERROR<>0
BEGIN
PRINT 'EQUIVOCACION AL INGRESAR MAS DE UN PARAMETRO EN PARAMETRO DE ENTRADA'
END
---10.RECOMPILAR EL PROCEDIMIENTO
EXEC TESTRECOMPILACION8 WITH RECOMPILE
---11.PROCEDIMIENTO SP_RECOMPILE
SP_RECOMPILE TESTRECOMPILACION
DBCC FREEPROCCACHE ---Borra de la cache todos los planes de ejecucion
---12. Parametros de Salida
create Proc Salida
@pais varchar(50),
@valor1 int OUTPUT
as
Select * from customers where country=@pais
set @valor1=@@rowcount
DECLARE @TEST1 INT
exec salida'Argentina',@TEST1
SELECT @TEST1

---13. Procedimientos extendidos
-- To allow advanced options to be changed.  
EXEC sp_configure 'show advanced options', 1;  
GO  
-- To update the currently configured value for advanced options.  
RECONFIGURE;  
GO  
-- To enable the feature.  
EXEC sp_configure 'xp_cmdshell', 1;  
GO  
-- To update the currently configured value for this feature.  
RECONFIGURE;  
GO  

Use Master
go
EXEC master.dbo.xp_cmdshell'dir c:\ '
EXEC master.dbo.sp_helptext xp_cmdshell ---buscar el dll que realiza la funcion
---14. Escribir un mensaje de error
EXEC sp_addmessage
@msgnum = 50010,
@severity = 10,
@lang= 'us_english',
@msgtext = 'Solo se permite un digito',
@with_log = 'true'
exec sp_dropmessage50010,'us_english'
use master
select * from sysmessages
sp_helptext sp_dropmessage
---15. Usar @@Error
ALTER PROC TESTRECOMPILACION
@VALOR  INT
WITH RECOMPILE
AS
DECLARE @STRING VARCHAR(200)
SET @STRING='SELECT TOP '+ CONVERT(CHAR(1),@VALOR) + ' * FROM ORDERS ORDER BY ORDERID'
EXECUTE (@STRING)
IF @@ERROR<>0
BEGIN
PRINT 'EQUIVOCACION AL INGRESAR MAS DE UN PARAMETRO EN PARAMETRO DE ENTRADA'
END
---16. usar el error con raiseeror
ALTER PROC TESTRECOMPILACION
@VALOR  INT
WITH RECOMPILE
AS
DECLARE @STRING VARCHAR(200)
SET @STRING='SELECT TOP '+ CONVERT(CHAR(1),@VALOR) + ' * FROM ORDERS ORDER BY ORDERID'
EXECUTE (@STRING)
IF @@ERROR<>0
BEGIN
RAISERROR(50010, 16, 1)
END
exec testrecompilacion88
---17. borrar de caché todos lo planes de ejecucion
DBCC FREEPROCCACHE
--uso del Return
use pubs
go
CREATE PROCEDURE checkstate @param varchar(11)
AS
IF (SELECT state FROM authors WHERE au_id = @param) = 'CA'
   RETURN 1
ELSE
   RETURN 2
---revision del resultado
declare @rev int
exec @rev=checkstate'238-95-7766'
if @rev=1
begin
print 'bien'
end
else
begin
print 'mal'
end