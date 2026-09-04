drop database if exists inmobiliaria;
create database inmobiliaria;


-- ---------------------
-- DDL
-- ---------------------
use inmobiliaria;

-- ==============================================================================
-- FASE 1: TABLAS MAESTRAS Y CATÁLOGOS (Sin llaves foráneas)
-- ==============================================================================

CREATE TABLE CATALOGO_TIPO (
    id TINYINT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE CATALOGO_ESTADO_PROPIEDAD (
    id TINYINT AUTO_INCREMENT PRIMARY KEY,
    estado VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE CATALOGO_METODO_PAGO (
    id TINYINT AUTO_INCREMENT PRIMARY KEY,
    metodo_pago VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE CATALOGO_ESTADO_REPORTE (
    id TINYINT AUTO_INCREMENT PRIMARY KEY,
    estado VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE CATALOGO_TIPO_CONTRATO (
    id TINYINT AUTO_INCREMENT PRIMARY KEY,
    tipo_contrato VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE CATALOGO_ESTADO_CONTRATO (
    id TINYINT AUTO_INCREMENT PRIMARY KEY,
    estado VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE agente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    comision DECIMAL(5,3) NOT NULL CHECK (comision BETWEEN 0 AND 1)
);

-- ==============================================================================
-- FASE 2: TABLAS CON DEPENDENCIAS SIMPLES
-- ==============================================================================

CREATE TABLE propiedad (
    id INT AUTO_INCREMENT PRIMARY KEY,
    area INT UNSIGNED,
    id_estado TINYINT,
    id_tipo TINYINT,
    direccion VARCHAR(150),
    CONSTRAINT fk_propiedad_estado FOREIGN KEY (id_estado) REFERENCES CATALOGO_ESTADO_PROPIEDAD(id),
    CONSTRAINT fk_propiedad_tipo FOREIGN KEY (id_tipo) REFERENCES CATALOGO_TIPO(id)
);

-- ==============================================================================
-- FASE 3: TABLAS TRANSACCIONALES
-- ==============================================================================

CREATE TABLE contrato (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_prop INT NOT NULL,
    id_cli INT NOT NULL,
    id_agen INT NOT NULL,
    tipo TINYINT NOT NULL,
    monto DECIMAL(15,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    estado TINYINT NOT NULL,
    CONSTRAINT fk_contrato_propiedad FOREIGN KEY (id_prop) REFERENCES propiedad(id),
    CONSTRAINT fk_contrato_cliente FOREIGN KEY (id_cli) REFERENCES cliente(id),
    CONSTRAINT fk_contrato_agente FOREIGN KEY (id_agen) REFERENCES agente(id),
    CONSTRAINT fk_contrato_tipo FOREIGN KEY (tipo) REFERENCES CATALOGO_TIPO_CONTRATO(id),
    CONSTRAINT fk_contrato_estado FOREIGN KEY (estado) REFERENCES CATALOGO_ESTADO_CONTRATO(id)
);

CREATE TABLE pago (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_contra INT NOT NULL,
    fecha_pago DATE NOT NULL,
    monto DECIMAL(15,2) NOT NULL,
    metodo_pago TINYINT NOT NULL,
    CONSTRAINT fk_pago_contrato FOREIGN KEY (id_contra) REFERENCES contrato(id),
    CONSTRAINT fk_pago_metodo FOREIGN KEY (metodo_pago) REFERENCES CATALOGO_METODO_PAGO(id)
);

-- ==============================================================================
-- FASE 4: TABLAS DE AUDITORÍA Y REPORTES
-- ==============================================================================

CREATE TABLE HISTORICO_CAMBIOS (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    estado_anterior TINYINT NOT NULL,
    estado_nuevo TINYINT NOT NULL,
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario_responsable VARCHAR(100),
    CONSTRAINT fk_hist_propiedad FOREIGN KEY (id_propiedad) REFERENCES propiedad(id),
    CONSTRAINT fk_hist_estado_ant FOREIGN KEY (estado_anterior) REFERENCES CATALOGO_ESTADO_PROPIEDAD(id),
    CONSTRAINT fk_hist_estado_nuev FOREIGN KEY (estado_nuevo) REFERENCES CATALOGO_ESTADO_PROPIEDAD(id)
);

CREATE TABLE AUDITORIA_CONTRATOS (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_contrato INT NOT NULL,
    usuario VARCHAR(100),
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    operacion VARCHAR(20) DEFAULT 'INSERT',
    CONSTRAINT fk_audit_contrato FOREIGN KEY (id_contrato) REFERENCES contrato(id)
);

CREATE TABLE INFORME_ARRIENDO_PENDIENTE (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    fecha_generacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_propiedad INT NOT NULL,
    id_contrato INT NOT NULL,
    id_cliente INT NOT NULL,
    valor_pendiente DECIMAL(15,2) NOT NULL,
    id_estado_reporte TINYINT NOT NULL,
    CONSTRAINT fk_rep_propiedad FOREIGN KEY (id_propiedad) REFERENCES propiedad(id),
    CONSTRAINT fk_rep_contrato FOREIGN KEY (id_contrato) REFERENCES contrato(id),
    CONSTRAINT fk_rep_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id),
    CONSTRAINT fk_rep_estado FOREIGN KEY (id_estado_reporte) REFERENCES CATALOGO_ESTADO_REPORTE(id)
);



-- ---------------
-- funciones -----
-- ---------------

-- funcion1: calcular la comisión de un agente
DELIMITER //

CREATE FUNCTION calcular_comision_agente(p_id_contrato INT) 
RETURNS DECIMAL(15,2)
READS SQL DATA
BEGIN
    DECLARE v_monto DECIMAL(15,2);
    DECLARE v_comision DECIMAL(5,3);
    DECLARE v_total_comision DECIMAL(15,2);

    -- Consultar el valor del contrato y el factor de comisión del agente
    SELECT c.monto, a.comision 
    INTO v_monto, v_comision
    FROM contrato c
    INNER JOIN agente a ON c.id_agen = a.id
    WHERE c.id = p_id_contrato;

    -- Calcular la comisión final
    SET v_total_comision = v_monto * v_comision;

    RETURN IFNULL(v_total_comision, 0.00);
END //

DELIMITER ;

-- ----------
-- prueba
-- ----------

SELECT 
    id AS id_contrato, 
    monto AS valor_venta, 
    calcular_comision_agente(id) AS comision_a_pagar 
FROM contrato 
WHERE id = 4;

-- ------------
-- funcion 2: calcular la deuda pendiente de un contrato de arriendo
-- ------------

DELIMITER //

CREATE FUNCTION calcular_deuda_pendiente(p_id_contrato INT) 
RETURNS DECIMAL(15,2)
READS SQL DATA
BEGIN
    DECLARE v_monto_total DECIMAL(15,2);
    DECLARE v_total_pagado DECIMAL(15,2);
    DECLARE v_deuda DECIMAL(15,2);

    -- 1. Obtener el valor pactado en el contrato
    SELECT monto INTO v_monto_total 
    FROM contrato 
    WHERE id = p_id_contrato;

    -- 2. Sumar todos los abonos realizados al contrato
    SELECT COALESCE(SUM(monto), 0) INTO v_total_pagado 
    FROM pago 
    WHERE id_contra = p_id_contrato;

    -- 3. Calcular la diferencia
    SET v_deuda = v_monto_total - v_total_pagado;

    RETURN IFNULL(v_deuda, 0.00);
END //

DELIMITER ;

-- --------
-- prueba
-- -------

SELECT 
    id AS id_contrato, 
    monto AS total_esperado, 
    calcular_deuda_pendiente(id) AS saldo_pendiente 
FROM contrato;


-- -------------
-- funcion 3: Contar la cantidad de propiedades disponibles según su tipo
-- -------------

DELIMITER //

CREATE FUNCTION contar_propiedades_disponibles(p_id_tipo TINYINT) 
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_cantidad INT;

    SELECT COUNT(p.id) INTO v_cantidad
    FROM propiedad p
    INNER JOIN CATALOGO_ESTADO_PROPIEDAD e ON p.id_estado = e.id
    WHERE p.id_tipo = p_id_tipo 
      AND e.estado = 'Disponible';

    RETURN v_cantidad;
END //

DELIMITER ;

-- -------------
-- prueba
-- ------------

-- Cuántos apartamentos disponibles hay:
SELECT contar_propiedades_disponibles(1) AS apartamentos_disponibles;

-- Listar todos los tipos de propiedad y su cantidad disponible usando la función:
SELECT 
    id, 
    tipo, 
    contar_propiedades_disponibles(id) AS cantidad_disponible 
FROM CATALOGO_TIPO
order by id;


-- -----------------
-- trigger 1: Histórico de Cambios (Propiedad)
-- ----------------

DELIMITER //

CREATE TRIGGER trg_historico_estado_propiedad
AFTER UPDATE ON propiedad
FOR EACH ROW
BEGIN
    -- Validar que el estado realmente haya cambiado
    IF OLD.id_estado != NEW.id_estado THEN
        INSERT INTO HISTORICO_CAMBIOS (id_propiedad, estado_anterior, estado_nuevo, usuario_responsable)
        VALUES (NEW.id, OLD.id_estado, NEW.id_estado, USER());
    END IF;
END //

DELIMITER ;

-- ------------
-- prueba
-- -----------
-- Cambiamos el estado de la propiedad 1 (de 'Disponible' a 'Arrendada')
UPDATE propiedad SET id_estado = 2 WHERE id = 1;

-- Verificamos que el trigger hizo su trabajo
SELECT * FROM HISTORICO_CAMBIOS;

-- ---------------
-- trigger 2: Auditoría de Contratos
-- ---------------

DELIMITER //

CREATE TRIGGER trg_auditoria_nuevos_contratos
AFTER INSERT ON contrato
FOR EACH ROW
BEGIN
    INSERT INTO AUDITORIA_CONTRATOS (id_contrato, usuario, operacion)
    VALUES (NEW.id, USER(), 'INSERT');
END //

DELIMITER ;

-- --------------
-- prueba
-- --------------

-- Insertamos un contrato de prueba
INSERT INTO contrato (id_prop, id_cli, id_agen, tipo, monto, fecha_inicio, fecha_fin, estado) 
VALUES (10, 2, 3, 1, 15000000.00, '2026-10-01', '2027-10-01', 1);

-- Verificamos la tabla de auditoría
SELECT * FROM AUDITORIA_CONTRATOS;

-- -------------------------------
-- procedimiento para el evento programado
-- -------------------------------

DELIMITER //

CREATE PROCEDURE generar_informe_mensual_arriendos()
BEGIN
    -- Insertamos el resultado de una consulta masiva directamente en la tabla de reporte
    INSERT INTO INFORME_ARRIENDO_PENDIENTE (id_propiedad, id_contrato, id_cliente, valor_pendiente, id_estado_reporte)
    SELECT 
        c.id_prop, 
        c.id AS id_contrato, 
        c.id_cli, 
        calcular_deuda_pendiente(c.id) AS deuda_calculada,
        1 AS id_estado_reporte -- 1 corresponde a 'Generado' en el catálogo
    FROM contrato c
    INNER JOIN CATALOGO_ESTADO_CONTRATO cat_est ON c.estado = cat_est.id
    WHERE cat_est.estado = 'Vigente'; 
    -- Solo generamos reporte a quienes tengan un contrato activo
END //

DELIMITER ;

-- ----------------------------
-- prueba
-- ---------------------------

-- Ejecutamos el procedimiento manualmente
CALL generar_informe_mensual_arriendos();

-- Revisamos cómo quedó la tabla de informe
SELECT * FROM INFORME_ARRIENDO_PENDIENTE;


-- ----------------------------
-- evento programado
-- ----------------------------

-- Primero, nos aseguramos de que el motor de eventos de MySQL esté encendido
SET GLOBAL event_scheduler = ON;

-- Creamos el evento
CREATE EVENT evt_automatizar_reporte_arriendos
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
DO
    CALL generar_informe_mensual_arriendos();

ALTER EVENT evt_automatizar_reporte_arriendos DISABLE;
SET GLOBAL event_scheduler = OFF;

-- --------------------------
-- seguridad y usuarios
-- --------------------------

-- 1. Creación de los roles
CREATE ROLE 'admin', 'agente', 'contador';

-- 2. Asignación de privilegios al Administrador (Control total sobre la BD 'inmobiliaria')
GRANT ALL PRIVILEGES ON inmobiliaria.* TO 'admin';

-- 3. Asignación de privilegios al Agente (Enfoque comercial y operativo)
-- Puede ver propiedades, clientes, contratos y catálogos.
GRANT SELECT ON inmobiliaria.propiedad TO 'agente';
GRANT SELECT ON inmobiliaria.cliente TO 'agente';
GRANT SELECT, INSERT, UPDATE ON inmobiliaria.contrato TO 'agente';
GRANT SELECT ON inmobiliaria.CATALOGO_TIPO TO 'agente';
GRANT SELECT ON inmobiliaria.CATALOGO_ESTADO_PROPIEDAD TO 'agente';
GRANT SELECT ON inmobiliaria.CATALOGO_ESTADO_CONTRATO TO 'agente';

-- 4. Asignación de privilegios al Contador (Enfoque financiero)
-- Puede ver todo, pero solo modifica pagos y reportes. Puede ejecutar funciones matemáticas.
GRANT SELECT ON inmobiliaria.* TO 'contador';
GRANT INSERT, UPDATE ON inmobiliaria.pago TO 'contador';
GRANT INSERT, UPDATE ON inmobiliaria.INFORME_ARRIENDO_PENDIENTE TO 'contador';
GRANT EXECUTE ON FUNCTION inmobiliaria.calcular_comision_agente TO 'contador';
GRANT EXECUTE ON FUNCTION inmobiliaria.calcular_deuda_pendiente TO 'contador';
GRANT EXECUTE ON PROCEDURE inmobiliaria.generar_informe_mensual_arriendos TO 'contador';

-- 5. Creación de usuarios reales con sus contraseñas
CREATE USER 'jgonzalez_admin'@'localhost' IDENTIFIED BY 'Admin123$';
CREATE USER 'mruiz_agente'@'localhost' IDENTIFIED BY 'Agente123$';
CREATE USER 'cfinanzas'@'localhost' IDENTIFIED BY 'Contador123$';

-- 6. Asignación de los roles a los usuarios
GRANT 'admin' TO 'jgonzalez_admin'@'localhost';
GRANT 'agente' TO 'mruiz_agente'@'localhost';
GRANT 'contador' TO 'cfinanzas'@'localhost';

-- 7. Activar los roles por defecto para que apliquen al iniciar sesión
SET DEFAULT ROLE 'admin' TO 'jgonzalez_admin'@'localhost';
SET DEFAULT ROLE 'agente' TO 'mruiz_agente'@'localhost';
SET DEFAULT ROLE 'contador' TO 'cfinanzas'@'localhost';

-- 8. Aplicar los cambios en el motor de base de datos
FLUSH PRIVILEGES;