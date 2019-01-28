---xml
---For XML  Raw , Auto, Explicit, Path

--consulta de las tablas customers y orders
--1.Ejemplo 1------------------------------
Select Customers.CustomerID, Customers.CompanyName,
Orders.OrderID, Orders.OrderDate from Customers
inner join orders on
Customers.CustomerID=Orders.customerid
For xml Explicit

--2.Ejemplo 2------------------------------
Select Customers.CustomerID, Customers.CompanyName,
Orders.OrderID, Orders.OrderDate from Customers
inner join orders on
Customers.CustomerID=Orders.customerid
for xml auto

----------For XML Explicit
--Informacion de customers y orders del customerid='ALFKI'

Select 1 as Tag,  null as parent,
customerid as [Cliente!1!customerid], contactname as [Cliente!1],
null as  [Orden!2!orderid],
null as [Orden!2]
from customers as C where customerid='ALFKI'
union
Select 2 as Tag, 1 as Parent, C.customerid,
C.contactName, o.orderid, o.shipaddress from
Customers as C inner join orders as o
on C.CustomerID=o.CustomerID
where C.CustomerID='ALFKI'
For xml Explicit

--resultado xml Anterior
<C customerid="ALFKI">Maria Anders
    <O orderid="10643">Obere Str. 57</O>
    <O orderid="10692">Obere Str. 57</O>
    <O orderid="10702">Obere Str. 57</O>
    <O orderid="10835">Obere Str. 57</O>
    <O orderid="10952">Obere Str. 57</O>
    <O orderid="11011">Obere Str. 57</O>
</C>

---uso de for xml path

Select Customers.CustomerID, Customers.CompanyName,
Orders.OrderID, Orders.OrderDate from Customers
inner join orders on
Customers.CustomerID=Orders.customerid
for xml path ('venta')

-----------uso de xml.query------------------------

declare @mydoc xml
set @mydoc='<root>
<productdescription productid="1" productname="rood bike">
<Features>
<warranty>1 año de garantia para partes</warranty>
<maintenance>3 años de mantenimiento</maintenance>
</Features>
</productdescription>
</root>'

Select @mydoc.query
('/root/productdescription/Features/maintenance')

-----------uso de xml.Value
declare @bicicleta varchar(100)
declare @mydoc xml
set @mydoc='<root>
<productdescription productid="1" productname="rood bike">
<Features>
<warranty>1 año de garantia para partes</warranty>
<maintenance>3 años de mantenimiento</maintenance>
</Features>
</productdescription>
</root>'

Set @bicicleta= @mydoc.value(
'(/root/productdescription/@productname)[1]', 'varchar(100)')

Select @bicicleta
---------------------------------------------------
declare @mydoc xml
set @mydoc='<Orders> 
<Order OrderID="13000" CustomerID="ALFKI" OrderDate="2006-09-20Z"
EmployeeID="2">
</Order> 
<Order OrderID="13001" CustomerID="VINET" OrderDate="2006-09-20Z"
EmployeeID="1">
</Order>
</Orders>'

SELECT OrderID    = T.Item.value('@OrderID', 'int'),      
CustomerID = T.Item.value('@CustomerID', 'nchar(5)'),      
OrderDate  = T.Item.value('@OrderDate',  'datetime'),      
EmployeeId = T.Item.value('@EmployeeID', 'smallint')
FROM   @mydoc.nodes('Orders/Order') AS T(Item)

---Convierte un XMl a una Tabla---------------------

DECLARE @xml_text VARCHAR(4000), @i INT

SELECT @xml_text = '<root><person LastName="White" FirstName="Johnson"/>
<person LastName="Green" FirstName="Marjorie"/>
<person LastName="Carson" FirstName="Cheryl"/></root>'

EXEC sp_xml_preparedocument @i OUTPUT, @xml_text

SELECT * FROM
    OPENXML(@i, '/root/person') WITH (LastName nvarchar(50),
                        FirstName nvarchar(50))


-------------------INDICES----------------------------------
CREATE PRIMARY XML INDEX idx_details on orders (details)  

-- Create secondary indexes (PATH, VALUE, PROPERTY).  
CREATE XML INDEX PIdx_T_XmlCol_PATH ON orders(details)  
USING XML INDEX idx_details  
FOR PATH;  
GO  
CREATE XML INDEX PIdx_T_details_VALUE ON orders(details)  
USING XML INDEX idx_details  
FOR VALUE;  
GO  
CREATE XML INDEX PIdx_T_details_PROPERTY ON orders(details)  
USING XML INDEX idx_details  
FOR PROPERTY;  
GO  
----------------------------------------------
Alter table orders 
add details xml
go

Update orders set details= (
Select * from [Order Details]
where orders.orderid=[Order Details].orderid
for xml auto)
from orders 

Select * from orders
