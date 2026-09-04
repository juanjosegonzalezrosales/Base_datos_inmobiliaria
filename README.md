# 🏢 Sistema de Base de Datos - Inmobiliaria

Este documento detalla el diseño, la estructura y las instrucciones de despliegue para el sistema de base de datos relacional de la agencia inmobiliaria. El sistema está diseñado bajo los principios de la Tercera Forma Normal (3NF), garantizando la integridad referencial, la automatización de reportes y la seguridad a través de roles.

## 📋 Explicación del Modelo de Datos

La arquitectura de la base de datos está segmentada en cuatro bloques lógicos secuenciales para optimizar el rendimiento y evitar redundancias:

1. **Catálogos (Tablas de Dominio):** Entidades estáticas que almacenan los tipos y estados permitidos dentro del sistema (tipos de propiedad, estados de contratos, métodos de pago, etc.). Sirven como listas desplegables restrictivas para asegurar la calidad de los datos.
2. **Tablas Maestras y Dependientes:** Contienen la información núcleo del negocio, como los clientes, los agentes inmobiliarios y el inventario de propiedades. Se relacionan directamente con los catálogos.
3. **Tablas Transaccionales:** Representan la operación del día a día. Incluyen la gestión de los contratos de arrendamiento/venta y el registro del flujo de caja (pagos). 
4. **Auditoría y Automatización:** Un conjunto de tablas diseñadas para ser alimentadas de forma automática en segundo plano mediante Triggers (para guardar el historial de cambios de las propiedades y auditar nuevos contratos) y Eventos Programados (para los reportes mensuales de cartera).

## ⚙️ Instrucciones de Instalación

El despliegue de la base de datos se realiza ejecutando los dos archivos proporcionados en tu cliente SQL (como MySQL Workbench, DBeaver o terminal). Sigue este orden estricto para evitar errores de llaves foráneas:

1. **Creación del Entorno:**
   Crea una base de datos llamada `inmobiliaria` y selecciónala como tu esquema activo.

2. **Ejecución del Archivo de Estructura (DDL):**
   Abre y ejecuta el primer archivo. Este script construirá todas las tablas, establecerá los tipos de datos correctos (como decimales para dinero) y creará todas las relaciones y restricciones.

3. **Ejecución del Archivo de Datos y Lógica (DML y Rutinas):**
   Abre y ejecuta el segundo archivo. Este documento se encargará de:
   * Poblar los catálogos, maestros y transacciones con datos de prueba coherentes.
   * Compilar las funciones matemáticas para el cálculo de comisiones y deudas.
   * Activar los disparadores (Triggers) de auditoría.
   * Crear el procedimiento almacenado para los reportes mensuales.
   * Configurar los índices de optimización y los roles de seguridad (Admin, Agente y Contador).

4. **Activación del Programador de Eventos:**
   Para que el reporte de arriendos pendientes se genere automáticamente cada mes, asegúrate de activar el Event Scheduler global en la configuración de tu servidor MySQL.

## 🔍 Ejemplos de Consultas y Uso

La estructura de la base de datos está optimizada para responder a preguntas clave del negocio cruzando diferentes tablas mediante uniones relacionales. Al operar el sistema, podrás realizar las siguientes acciones:

* **Seguimiento de Contratos:** Consultar el detalle completo de los acuerdos cruzando la tabla de contratos con los nombres de los clientes, los agentes responsables, la dirección de la propiedad y filtrando por los estados vigentes del catálogo.
* **Cálculo de Cartera en Tiempo Real:** Utilizar la función matemática integrada para consultar un contrato específico y obtener su saldo pendiente, calculando automáticamente la diferencia entre el canon total pactado y el historial de pagos registrados.
* **Trazabilidad de Inmuebles:** Revisar la tabla de historial de cambios para auditar qué usuario modificó el estado de una propiedad, cuándo lo hizo, y cuál era el estado anterior versus el nuevo.
* **Cierre Contable:** Visualizar el informe consolidado de los arriendos pendientes que el sistema genera automáticamente cada mes, el cual cruza clientes, contratos, propiedades y saldos en una sola vista lista para revisión financiera.