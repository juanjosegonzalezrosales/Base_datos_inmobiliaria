-- ----------------
-- DML
-- ----------------

-- ==============================================================================
-- FASE 2.2: SCRIPT DML (Población de Datos)
-- ==============================================================================

-- ==============================================================================
-- LLENADO DE CATÁLOGOS Y MAESTRAS (Mínimo 10 registros, excepto los de Estado)
-- ==============================================================================

INSERT INTO CATALOGO_TIPO (tipo) VALUES 
('Apartamento'), ('Casa'), ('Local Comercial'), ('Oficina'), ('Bodega'), 
('Lote'), ('Finca'), ('Edificio'), ('Parqueadero'), ('Consultorio');

-- Reducido a 4 estados
INSERT INTO CATALOGO_ESTADO_PROPIEDAD (estado) VALUES 
('Disponible'), ('Arrendada'), ('Vendida'), ('En Mantenimiento');

INSERT INTO CATALOGO_METODO_PAGO (metodo_pago) VALUES 
('Efectivo'), ('PSE'), ('Transferencia Bancaria'), ('Tarjeta de Crédito'), ('Tarjeta de Débito'), 
('Lulo Bank'), ('Nequi'), ('Cheque'), ('Daviplata'), ('Paypal');

-- Reducido a 4 estados
INSERT INTO CATALOGO_ESTADO_REPORTE (estado) VALUES 
('Generado'), ('Pendiente'), ('En Revisión'), ('Aprobado');

INSERT INTO CATALOGO_TIPO_CONTRATO (tipo_contrato) VALUES 
('Arriendo Vivienda Urbana'), ('Arriendo Comercial'), ('Venta de Contado'), ('Venta Hipotecada'), ('Comodato'), 
('Subarriendo'), ('Permuta'), ('Arriendo Rural'), ('Leasing Habitacional'), ('Anticresis');

-- Reducido a 4 estados
INSERT INTO CATALOGO_ESTADO_CONTRATO (estado) VALUES 
('Vigente'), ('Finalizado'), ('Suspendido'), ('Cancelado');

INSERT INTO cliente (nombre) VALUES 
('Juan José González'), ('Elizabeth Rosales Moreno'), ('Carlos Rodríguez'), ('Andrés Felipe Soto'), ('María Fernanda Pérez'), 
('Diana Lucía Castro'), ('Luis Miguel Vargas'), ('Ana Paula Rincón'), ('Jorge Eliécer Gómez'), ('Valentina Torres');

INSERT INTO agente (nombre, comision) VALUES 
('Laura Martínez', 0.050), ('Pedro Sánchez', 0.035), ('Sofía Vergara', 0.040), ('Miguel Ángel Ruiz', 0.060), ('Carmen López', 0.025), 
('Ricardo Silva', 0.050), ('Daniela Medina', 0.045), ('Esteban Quintero', 0.030), ('Juliana Ospina', 0.055), ('Héctor Salamanca', 0.070);

-- ==============================================================================
-- LLENADO DE TABLAS CON DEPENDENCIAS SIMPLES (Mínimo 10 registros)
-- ==============================================================================

INSERT INTO propiedad (area, id_estado, id_tipo, direccion) VALUES 
(65, 1, 1, 'Conjunto Residencial Bosque Central, Floridablanca'),
(120, 2, 2, 'Carrera 33 # 45-12, Cabecera, Bucaramanga'),
(45, 1, 4, 'Edificio Torre B, Centro Empresarial'),
(200, 3, 3, 'Calle 100 con 15, Bogotá'),
(80, 4, 1, 'Calle 45 # 20-10, Provenza'),
(500, 1, 5, 'Zona Industrial Chimitá'),
(3000, 1, 7, 'Vía Piedecuesta Km 5'),
(90, 2, 1, 'Carrera 27 # 36-14, Bucaramanga'),
(15, 1, 9, 'Parqueadero Subterráneo Nivel 2'),
(55, 1, 10, 'Centro Médico Carlos Ardila Lülle'); -- id_estado cambiado a 1 para respetar límite

-- ==============================================================================
-- LLENADO DE TABLAS TRANSACCIONALES (Mínimo 20 registros)
-- ==============================================================================

INSERT INTO contrato (id_prop, id_cli, id_agen, tipo, monto, fecha_inicio, fecha_fin, estado) VALUES 
(1, 1, 1, 1, 18000000.00, '2025-01-10', '2026-01-10', 1),
(2, 2, 2, 2, 42000000.00, '2025-02-15', '2026-02-15', 1),
(3, 3, 3, 2, 33600000.00, '2024-06-01', '2025-06-01', 2),
(4, 4, 4, 3, 450000000.00, '2025-04-12', NULL, 2),
(5, 5, 5, 1, 21600000.00, '2026-01-05', '2027-01-05', 1),
(6, 6, 6, 2, 306000000.00, '2023-11-20', '2026-11-20', 1),
(7, 7, 7, 8, 50400000.00, '2025-09-15', '2026-09-15', 1),
(8, 8, 8, 1, 19200000.00, '2025-12-01', '2026-12-01', 1),
(9, 9, 9, 2, 1800000.00, '2026-02-01', '2026-08-01', 1),
(10, 10, 10, 2, 25200000.00, '2024-03-10', '2025-03-10', 2),
(1, 2, 2, 1, 18600000.00, '2026-01-15', '2027-01-15', 1),
(2, 3, 3, 2, 43200000.00, '2026-02-20', '2027-02-20', 1),
(3, 4, 4, 2, 34800000.00, '2025-06-05', '2026-06-05', 1),
(4, 5, 5, 3, 460000000.00, '2026-04-15', NULL, 1),
(5, 6, 6, 1, 22200000.00, '2025-01-10', '2026-01-10', 2),
(6, 7, 7, 2, 103200000.00, '2026-12-01', '2027-12-01', 1),
(7, 8, 8, 8, 51600000.00, '2024-09-20', '2025-09-20', 2),
(8, 9, 9, 1, 19800000.00, '2026-12-05', '2027-12-05', 1),
(9, 10, 10, 2, 1920000.00, '2026-08-05', '2027-02-05', 1),
(10, 1, 1, 2, 26400000.00, '2025-03-15', '2026-03-15', 1);


INSERT INTO pago (id_contra, fecha_pago, monto, metodo_pago) VALUES 
(1, '2025-02-10', 1500000.00, 2), (1, '2025-03-10', 1500000.00, 2), (2, '2025-03-15', 3500000.00, 3), (2, '2025-04-15', 3500000.00, 3),
(3, '2024-07-01', 2800000.00, 1), (3, '2024-08-01', 2800000.00, 1), (4, '2025-04-12', 450000000.00, 3), (5, '2026-02-05', 1800000.00, 2),
(5, '2026-03-05', 1800000.00, 6), (6, '2023-12-20', 8500000.00, 3), (6, '2024-01-20', 8500000.00, 3), (7, '2025-10-15', 4200000.00, 3),
(8, '2026-01-01', 1600000.00, 2), (8, '2026-02-01', 1600000.00, 2), (9, '2026-03-01', 300000.00, 1), (10, '2024-04-10', 2100000.00, 3),
(12, '2026-03-20', 3600000.00, 3), (13, '2025-07-05', 2900000.00, 1), (15, '2025-02-10', 1850000.00, 2), (20, '2025-04-15', 2200000.00, 2);

-- -------------------
-- consultas de prueba
-- -------------------

-- 1. INNER JOIN BÁSICO: Validar la conexión entre una tabla transaccional y un catálogo.
-- Consulta: ¿Qué métodos de pago se usaron y por qué monto?
SELECT p.id, p.monto, c.metodo_pago 
FROM pago p
INNER JOIN CATALOGO_METODO_PAGO c ON p.metodo_pago = c.id;

-- 2. MÚLTIPLES JOINS: Validar la integridad referencial completa de un contrato.
-- Consulta: Detalle legible del contrato mostrando nombres en lugar de IDs.
SELECT c.id AS id_contrato, cli.nombre AS cliente, ag.nombre AS agente, prop.direccion AS propiedad 
FROM contrato c
INNER JOIN cliente cli ON c.id_cli = cli.id
INNER JOIN agente ag ON c.id_agen = ag.id
INNER JOIN propiedad prop ON c.id_prop = prop.id;

-- 3. FILTRO POR VALORES NULOS (IS NULL): Validar que el diseño permite ventas sin fecha de fin.
-- Consulta: Listar los contratos que son de venta (no tienen fecha de finalización).
SELECT id AS id_contrato, monto, fecha_inicio 
FROM contrato 
WHERE fecha_fin IS NULL;

-- 4. AGRUPACIÓN Y CONTEO (GROUP BY + COUNT): Validar cardinalidad.
-- Consulta: ¿Cuántas propiedades hay registradas por cada estado?
SELECT cat.estado, COUNT(p.id) AS total_propiedades
FROM propiedad p
INNER JOIN CATALOGO_ESTADO_PROPIEDAD cat ON p.id_estado = cat.id
GROUP BY cat.estado;

-- 5. FUNCIONES MATEMÁTICAS EN SELECT: Validar el uso del tipo DECIMAL y multiplicaciones.
-- Consulta: Calcular cuánto ganaría el agente de comisión por cada contrato firmado.
SELECT c.id AS id_contrato, a.nombre AS agente, c.monto AS valor_contrato, a.comision AS factor_comision, 
       (c.monto * a.comision) AS ganancia_calculada
FROM contrato c
INNER JOIN agente a ON c.id_agen = a.id;

-- 6. FILTROS DE TEXTO Y PATRONES (LIKE): Validar búsquedas en campos VARCHAR.
-- Consulta: Encontrar todas las propiedades que están ubicadas en "Bucaramanga".
SELECT id, direccion, area 
FROM propiedad 
WHERE direccion LIKE '%Bucaramanga%';

-- 7. FUNCIONES DE AGREGACIÓN (SUM): Validar la sumatoria total de transacciones financieras.
-- Consulta: ¿Cuánto dinero ha ingresado en total agrupado por cada método de pago?
SELECT cat.metodo_pago, SUM(p.monto) AS total_recaudado
FROM pago p
INNER JOIN CATALOGO_METODO_PAGO cat ON p.metodo_pago = cat.id
GROUP BY cat.metodo_pago;

-- 8. ORDENAMIENTO Y LÍMITE (ORDER BY + LIMIT): Validar obtención de "Top N" registros.
-- Consulta: Mostrar los 3 pagos más altos registrados en el sistema.
SELECT id_contra, fecha_pago, monto 
FROM pago 
ORDER BY monto DESC 
LIMIT 3;

-- 9. FILTROS DE FECHA (YEAR / Funciones de Tiempo): Validar el manejo del tipo DATE.
-- Consulta: Mostrar todos los contratos que iniciaron en el año 2025.
SELECT id, monto, fecha_inicio, fecha_fin 
FROM contrato 
WHERE YEAR(fecha_inicio) = 2025;

-- 10. RESTRICCIONES DE AGRUPACIÓN (HAVING): Validar filtros sobre datos agregados.
-- Consulta: ¿Qué agentes han gestionado más de 1 contrato?
SELECT a.nombre, COUNT(c.id) AS contratos_gestionados
FROM agente a
INNER JOIN contrato c ON a.id = c.id_agen
GROUP BY a.nombre
HAVING COUNT(c.id) > 1;

-- 11. LEFT JOIN: Validar cruces donde puede no haber correspondencia.
-- Consulta: Mostrar todos los métodos de pago del catálogo y si tienen pagos asociados (incluso los métodos sin uso).
SELECT cat.metodo_pago, p.id AS id_pago, p.monto
FROM CATALOGO_METODO_PAGO cat
LEFT JOIN pago p ON cat.id = p.metodo_pago;

-- 12. SUBCONSULTAS (SUBQUERIES) EN EL WHERE: Validar anidamiento de consultas lógicas.
-- Consulta: ¿Quién es el cliente que tiene el contrato de mayor valor?
SELECT cli.nombre, c.monto 
FROM contrato c
INNER JOIN cliente cli ON c.id_cli = cli.id
WHERE c.monto = (SELECT MAX(monto) FROM contrato);

-- 13. PROMEDIOS (AVG): Validar análisis estadístico básico sobre los datos transaccionales.
-- Consulta: ¿Cuál es el valor promedio de los contratos agrupado por tipo de contrato?
SELECT cat.tipo_contrato, ROUND(AVG(c.monto), 2) AS promedio_monto
FROM contrato c
INNER JOIN CATALOGO_TIPO_CONTRATO cat ON c.tipo = cat.id
GROUP BY cat.tipo_contrato;

-- 14. OPERADORES LÓGICOS (AND / OR): Validar filtros combinados complejos.
-- Consulta: Contratos vigentes que sean por un monto superior a 2,000,000 o que iniciaron después de julio 2025.
SELECT c.id, c.monto, c.fecha_inicio, cat.estado
FROM contrato c
INNER JOIN CATALOGO_ESTADO_CONTRATO cat ON c.estado = cat.id
WHERE cat.estado = 'Vigente' AND (c.monto > 2000000 OR c.fecha_inicio > '2025-07-01');

-- 15. CÁLCULO RELACIONAL COMPLEJO (COALESCE + JOIN + GROUP BY): Preparación para el reporte mensual.
-- Consulta: Calcular el total pagado hasta la fecha por cada contrato cruzando ambas tablas transaccionales.
SELECT c.id AS id_contrato, c.monto AS valor_contrato, COALESCE(SUM(p.monto), 0) AS total_abonado
FROM contrato c
LEFT JOIN pago p ON c.id = p.id_contra
GROUP BY c.id, c.monto;
