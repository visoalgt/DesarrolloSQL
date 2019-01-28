USE NORTHWIND
GO
/*
CREATE TRIGGER [propietario.] nombreDesencadenador
ON [propietario.] nombreTabla
[WITH ENCRYPTION]
{FOR | AFTER | INSTEAD OF} {INSERT | UPDATE | DELETE}
AS
[IF UPDATE (nombreColumna)…]
[{AND | OR} UPDATE (nombreColumna)…]
instruccionesSQL}
Sintaxis
*/
---1.CREACION DE UN TRIGGER SOBRE LA TABLA ORDER DETAILS---
SELECT * FROM [ORDER DETAILS]
SELECT * FROM PRODUCTS

CREATE TRIGGER BUSCARPRECIO           ---CREA EL TRIGGER
ON [ORDER DETAILS]                    ---ON  ESPECIFICA LA TABLA
FOR INSERT                            ---FOR ESFECIFICA EL EVENTO INSERT, UPDATE, DELETE
AS                            ---AS ESPECIFICA EL CUERO
UPDATE [ORDER DETAILS] SET UNITPRICE=
(SELECT P.UNITPRICE FROM PRODUCTS AS P INNER JOIN INSERTED AS I
ON P.PRODUCTID=I.PRODUCTID)
---2.REVISION DEL TRIGGER---
INSERT [ORDER DETAILS](ORDERID,PRODUCTID,QUANTITY,DISCOUNT)
VALUES
(10248,47,6,0)
---3.BORRAR EL TRIGGER
DROP TRIGGER BUSCARPRECIO
---4.CREAR UN TRIGGER CON INSTEAD OF---
CREATE TRIGGER REVISARDETALLE
ON [ORDER DETAILS]
INSTEAD OF INSERT
AS
IF (SELECT ORDERID FROM INSERTED)=10248
BEGIN
RAISERROR('NO ES POSIBLE INGRESAR MAS DATOS A ESE PEDIDO',16,1)
ROLLBACK TRAN
END
ELSE
BEGIN
INSERT  [ORDER DETAILS] SELECT ORDERID,PRODUCTID,UNITPRICE,QUANTITY,DISCOUNT FROM INSERTED
END
---5.LOS TRIGGER SE PUEDEN ANIDAR HASTA 32 NIVELES PARA CAMBIAR EL NIVEL DE ANIDAMIENTO---
sp_configure 'nested triggers', 0
---6.PARA ACTIVAR LA RECURSIVADAD DE UN TRIGGER QUE ESTA DE FORMA PREDETERMINADA EN OFF-
ALTER DATABASE NORTHWIND
 SET RECURSIVE_TRIGGERS OFF
sp_dboption nombreBaseDatos, 'recursive triggers', True
---7.SI TIENE MAS DE UN TRIGGER EN LA MISMA TABLA PARA INDICAR EL ORDEN DE EJECUCION---
sp_settriggerorder @triggername= 'MyTrigger', @order='first', @stmttype = 'UPDATE'





   Create trigger Debitar_Stock
   on [order details]
   for Insert
   as
   Update P set P.UnitsInStock=P.UnitsInStock–D.Quantity
   from products as P inner join
   INSERTED as D on D.ProductID=P.ProductID


   Create trigger Regresar_Stock
   on [order  details]
   for Delete
   as
   Update P set P.UnitsInStock=P.UnitsInStock+D.Quantity
   from products as P inner join
   DELETED as D on D.ProductID=P.ProductID


   Create trigger Actualizar_Stock
   on [order  details]
   for Updete
   as
   Update P set P.UnitsInStock=P.UnitsInStock+D.Quantity
   from products as P inner join
   DELETED as D on D.ProductID=P.ProductID
    
   Update P set P.UnitsInStock=P.UnitsInStock–D.Quantity
   from products as P inner join
   INSERTED as D on D.ProductID=P.ProductID