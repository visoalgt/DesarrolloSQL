--Dependencias de otros objetos con el objeto que queremos borrar

Select o.name, o.object_id, o.type_desc from sys.objects as o 
inner join sys.sysdepends as d on o.object_id=d.id
where depid=757577737
