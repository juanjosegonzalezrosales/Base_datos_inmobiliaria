
-- 1. mostrar todos los clientes junto al total pagado en el mes actual.
/* SELECT p.fecha_pago, c2.id as identificacion, c2.nombre, SUM(p.monto) 
FROM pago p 
join contrato c on p.id_contra = c.id 
RIGHT JOIN cliente c2 on c.id_cli =c2.id 
WHERE YEAR (p.fecha_pago) = YEAR (CURDATE()) and MONTH (p.fecha_pago) = MONTH (CURDATE())
GROUP by c2.id, c2.nombre,p.fecha_pago;  */

SELECT c2.id as identificacion, c2.nombre, SUM(p.monto) 
FROM pago p 
join contrato c on p.id_contra = c.id 
RIGHT JOIN cliente c2 on c.id_cli =c2.id
WHERE YEAR (p.fecha_pago) = YEAR (CURDATE()) and MONTH (p.fecha_pago) = MONTH (CURDATE())
GROUP by c2.id, c2.nombre;  


-- 2. obtener los pagos con fecha de pago mayor al dia actual y estado pendiente

SELECT p.fecha_pago, c2.id as identificacion, c2.nombre, 
FROM pago p 
join contrato c on p.id_contra = c.id 
RIGHT JOIN cliente c2 on c.id_cli =c2.id 
GROUP by c2.id, c2.nombre,p.fecha_pago;

-- 4. crear un trigger llamado actualizar_estado_pago que cambie el estado de un pago a "Atrasado" si la
-- fecha de pago vence y no ha sido cancelado.

alter table pago add estado tinyint;
CREATE TABLE CATALOGO_ESTADO_PAGO (
    id TINYINT auto_increment PRIMARY KEY,
    estado_pago VARCHAR(50) NOT NULL UNIQUE default 1
);
alter table pago add CONSTRAINT foreign key (estado) references CATALOGO_ESTADO_PAGO(id);
INSERT INTO CATALOGO_ESTADO_PAGO (estado_pago) VALUES 
('Pendiente o atrasado'), ('al dia');

select *
from CATALOGO_ESTADO_PAGO;



-- 5. generar un reporte que muestre el nombre del cliente, su telefono y 
-- el numero total de propiedades arrendadas.

SELECT c2.id,c2.nombre, COUNT(c.id_prop) as cantidad_propiedades_en_arriendo
FROM contrato c 
join cliente c2 on c2.id =c.id_cli 
join CATALOGO_ESTADO_CONTRATO cec on cec.id = c.estado 
where c.estado = (SELECT cec2.id 
					FROM CATALOGO_ESTADO_CONTRATO cec2 
					WHERE cec2.estado = 'Vigente'
					)
	AND 
	c.tipo in (SELECT ctc.id
				from CATALOGO_TIPO_CONTRATO ctc 
				WHERE ctc.tipo_contrato like 'Arriendo%'
				)
group by c2.id,c2.nombre;
	
/* SELECT  *
from CATALOGO_TIPO_CONTRATO ctc 

SELECT *
FROM CATALOGO_ESTADO_CONTRATO cec 
*/