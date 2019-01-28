--Script para creacion de primer figura geométrica 
DECLARE @FiguraGeometrica GEOMETRY; 
SET @FiguraGeometrica = GEOMETRY::STGeomFromText('POLYGON ((20 20, 20 80, 80 80, 80 20, 20 
20))',0); 
SELECT @FiguraGeometrica AS Square; 
GO

-- Script para la creación de una figura geométrica más compleja 
DECLARE @FiguraGeometrica GEOMETRY; 
SET @FiguraGeometrica = GEOMETRY::STGeomFromText('POLYGON ((10 10, 15 15,20 60, 40 40, 55 55,40 10, 
10 10))',0); 
SELECT @FiguraGeometrica AS ColoredArea; 
GO

-- Script para la creación de varias figuras geométricas 
DECLARE @FiguraGeometrica1 GEOMETRY, @FiguraGeometrica2 GEOMETRY; 
SET @FiguraGeometrica1 = GEOMETRY::STGeomFromText('POLYGON ((10 10, 15 15,20 60, 40 40, 55 55,40 10, 
10 10))',0); 
SET @FiguraGeometrica2 = GEOMETRY::STGeomFromText('POLYGON ((20 20, 20 80, 80 80, 80 20, 20 
20))',0); 
SELECT @FiguraGeometrica1 AS Multishapes 
UNION ALL 
SELECT @FiguraGeometrica2; 
GO
------------Punto
DECLARE @g geometry;
SET @g = geometry::STGeomFromText('POINT (3 4)', 0);

--El ejemplo siguiente crea una instancia de geometryPoint que representa el punto (3, 4) con un valor (elevación) Z de 7, un valor M (medida) de 2,5 y el SRID predeterminado de 0.
DECLARE @g geometry;
SET @g = geometry::Parse('POINT(3 4 7 2.5)');

SELECT @g.STX;
SELECT @g.STY;
SELECT @g.Z;
SELECT @g.M;
-----------------Multipunto
--El ejemplo siguiente crea una instancia de geometry MultiPoint con SRID 23 y dos puntos: un punto con las coordenadas (2, 3), un punto con las coordenadas (7, 8) y un valor de Z de 9,5.
DECLARE @g geometry;
SET @g = geometry::STGeomFromText('MULTIPOINT((2 3), (7 8 9.5))', 23);
--Esta instancia de MultiPoint también se puede expresar usando STMPointFromText() como se muestra a continuación.
DECLARE @g geometry;
SET @g = geometry::STMPointFromText('MULTIPOINT((2 3), (7 8 9.5))', 23);
--El ejemplo siguiente usa el método STGeometryN() para recuperar una descripción del primer punto de la recopilación.
SELECT @g.STGeometryN(2).STAsText();

----Line String
DECLARE @g1 geometry= 'LINESTRING EMPTY';
DECLARE @g2 geometry= 'LINESTRING(1 1, 3 3)';
DECLARE @g3 geometry= 'LINESTRING(1 1, 3 3, 2 4, 2 0)';
DECLARE @g4 geometry= 'LINESTRING(1 1, 3 3, 2 4, 2 0, 1 1)';
SELECT @g1.STIsValid(), @g2.STIsValid(), @g3.STIsValid(), @g4.STIsValid();

--En el ejemplo siguiente se muestra cómo crear una instancia de geometry de tipo LineString con tres puntos y un SRID de 0:
DECLARE @g geometry;
SET @g = geometry::STGeomFromText('LINESTRING(1 1, 2 4, 3 9)', 0);
--Cada punto de la instancia de LineString puede contener valores Z (elevación) y M (medida). Este ejemplo agrega valores M a la instancia de LineString creada en el ejemplo anterior. M y Z pueden ser valores nulos.
DECLARE @g geometry;
SET @g = geometry::STGeomFromText('LINESTRING(1 1 NULL 0, 2 4 NULL 12.3, 3 9 NULL 24.5)', 0);4

----Datos de Geometria
Create TABLE SpatialTable 
    ( id int IDENTITY (1,1),
    GeomCol1 geometry, 
    GeomCol2 AS GeomCol1.STAsText() );
GO

INSERT INTO SpatialTable (GeomCol1)
VALUES (geometry::STGeomFromText('LINESTRING (100 100, 20 180, 180 180)', 0));

INSERT INTO SpatialTable (GeomCol1)
VALUES (geometry::STGeomFromText('POLYGON ((0 0, 150 0, 150 150, 0 150, 0 0))', 0));
GO
INSERT INTO SpatialTable (GeomCol1)
VALUES (geometry::
STGeomFromText('POLYGON ((10 10, 15 15,20 60, 40 40, 55 55,40 10, 
10 10))',0)); 

Select GeomCol1 from spatialtable