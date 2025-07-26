/*
--------------------------------------------------------------------------------
 Script        : 01_crear_base_datos.sql
 Descripción   : Crea la base de datos 'incidencias' desde cero.
                 Si ya existe, la elimina primero para asegurar una creación limpia.
 Tipo de Objeto: Script de creación de base de datos
 Versión       : 1.0.0

 Empresa       : Municipalidad Distrital de La Esperanza
 Área          : Subgerencia de Informática y Sistemas
 Autor         : Jhonatan Mantilla Miñano
 Fecha creación: 2025-07-22

 Observaciones:
    - Este script elimina la base de datos si ya existe. Úsalo con precaución en entornos productivos.
    - Requiere permisos de nivel administrador en SQL Server.
--------------------------------------------------------------------------------
*/

-- Selecciona la base de datos del sistema donde se gestionan todas las bases de datos
USE master;
GO

-- Verifica si ya existe una base de datos llamada 'incidencias'
IF EXISTS (
    SELECT name
    FROM sys.databases
    WHERE name = 'incidencias'
)
BEGIN
    -- Si existe, elimina la base de datos para poder crearla nuevamente
    DROP DATABASE incidencias;
END
GO

-- Crea una nueva base de datos llamada 'incidencias'
CREATE DATABASE incidencias;
GO

-- Cambia el contexto de ejecución a la nueva base de datos
USE incidencias;
GO
