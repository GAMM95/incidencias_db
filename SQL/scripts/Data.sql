/****** VOLCADO DE DATOS *******/
--VOLCADO DE DATOS PARA LA TABLA ROL
INSERT INTO ROL (ROL_nombre)
VALUES ('Administrador');
INSERT INTO ROL (ROL_nombre)
VALUES ('Soporte');
INSERT INTO ROL (ROL_nombre)
VALUES ('Usuario');
GO

-- VOLCADO DE DATOS PARA LA TABLA PERSONA
INSERT INTO PERSONA (PER_dni, PER_nombres, PER_apellidoPaterno, PER_apellidoMaterno, PER_email, PER_celular)
VALUES ('70555743', N'Jhonatan', N'Mantilla', N'Miñano', N'jhonatanmm.1995@gmail.com', '950212909');
GO

-- VOLCADO DE DATOS PARA LA TABLA ESTADO
INSERT INTO ESTADO (EST_descripcion)
VALUES (N'ACTIVO');
INSERT INTO ESTADO (EST_descripcion)
VALUES (N'INACTIVO');
INSERT INTO ESTADO (EST_descripcion)
VALUES (N'ABIERTO');
INSERT INTO ESTADO (EST_descripcion)
VALUES (N'RECEPCIONADO');
INSERT INTO ESTADO (EST_descripcion)
VALUES (N'EN ESPERA');
INSERT INTO ESTADO (EST_descripcion)
VALUES (N'RESUELTO');
INSERT INTO ESTADO (EST_descripcion)
VALUES (N'CERRADO');
GO

-- VOLCADO DE DATOS PARA LA TABLA PRIORIDAD
INSERT INTO PRIORIDAD (PRI_nombre)
VALUES (N'BAJA');
INSERT INTO PRIORIDAD (PRI_nombre)
VALUES (N'MEDIA');
INSERT INTO PRIORIDAD (PRI_nombre)
VALUES (N'ALTA');
GO

-- VOLCADO DE DATOS PARA LA TABLA CATEGORIA
INSERT INTO CATEGORIA (CAT_codigo, CAT_nombre, EST_codigo)
VALUES (1, N'Red inaccesible', 1);
INSERT INTO CATEGORIA (CAT_codigo, CAT_nombre, EST_codigo)
VALUES (2, N'Asistencia técnica', 1);
INSERT INTO CATEGORIA (CAT_codigo, CAT_nombre, EST_codigo)
VALUES (3, N'Generación de usuario', 1);
INSERT INTO CATEGORIA (CAT_codigo, CAT_nombre, EST_codigo)
VALUES (4, N'Fallo de equipo de computo', 1);
INSERT INTO CATEGORIA (CAT_codigo, CAT_nombre, EST_codigo)
VALUES (5, N'Inaccesibilidad a impresora', 1);
INSERT INTO CATEGORIA (CAT_codigo, CAT_nombre, EST_codigo)
VALUES (6, N'Cableado de red', 1);
INSERT INTO CATEGORIA (CAT_codigo, CAT_nombre, EST_codigo)
VALUES (7, N'Correo corporativo', 1);
INSERT INTO CATEGORIA (CAT_codigo, CAT_nombre, EST_codigo)
VALUES (8, N'Reporte de sistemas informáticos', 1);
INSERT INTO CATEGORIA (CAT_codigo, CAT_nombre, EST_codigo)
VALUES (9, N'Otros', 1);
INSERT INTO CATEGORIA (CAT_codigo, CAT_nombre, EST_codigo)
VALUES (10, N'Inaccesibilidad a sistemas informáticos', 1);
GO

-- VOLCADO DE DATOS PARA LA TABLA IMPACTO
INSERT INTO IMPACTO (IMP_descripcion)
VALUES (N'BAJO');
INSERT INTO IMPACTO (IMP_descripcion)
VALUES (N'MEDIO');
INSERT INTO IMPACTO (IMP_descripcion)
VALUES (N'ALTO');
GO

-- VOLCADO DE DATOS PARA LA TABLA BIEN
INSERT INTO BIEN (BIE_codigo, BIE_codigoIdentificador, BIE_nombre, EST_codigo)
VALUES (1, '', '', 1);
INSERT INTO BIEN (BIE_codigo, BIE_codigoIdentificador, BIE_nombre, EST_codigo)
VALUES (2, '74089950', 'CPU', 1);
INSERT INTO BIEN (BIE_codigo, BIE_codigoIdentificador, BIE_nombre, EST_codigo)
VALUES (3, '74080500', 'LAPTOP', 1);
INSERT INTO BIEN (BIE_codigo, BIE_codigoIdentificador, BIE_nombre, EST_codigo)
VALUES (4, '74088187', 'MONITOR PLANO', 1);
INSERT INTO BIEN (BIE_codigo, BIE_codigoIdentificador, BIE_nombre, EST_codigo)
VALUES (5, '74087700', 'MONITOR A COLOR', 1);
INSERT INTO BIEN (BIE_codigo, BIE_codigoIdentificador, BIE_nombre, EST_codigo)
VALUES (6, '74089500', 'TECLADO', 1);
INSERT INTO BIEN (BIE_codigo, BIE_codigoIdentificador, BIE_nombre, EST_codigo)
VALUES (7, '74088600', 'MOUSE', 1);
INSERT INTO BIEN (BIE_codigo, BIE_codigoIdentificador, BIE_nombre, EST_codigo)
VALUES (8, '46225215', 'ESTABILIZADOR', 1);
INSERT INTO BIEN (BIE_codigo, BIE_codigoIdentificador, BIE_nombre, EST_codigo)
VALUES (9, '74083650', 'IMPRESORA A INYECCION DE TINTA', 1);
INSERT INTO BIEN (BIE_codigo, BIE_codigoIdentificador, BIE_nombre, EST_codigo)
VALUES (10, '74083875', 'IMPRESORA DE CODIGO DE BARRAS', 1);
INSERT INTO BIEN (BIE_codigo, BIE_codigoIdentificador, BIE_nombre, EST_codigo)
VALUES (11, '74084550', 'IMPRESORA MATRIZ DE PUNTO', 1);
INSERT INTO BIEN (BIE_codigo, BIE_codigoIdentificador, BIE_nombre, EST_codigo)
VALUES (12, '74085000', 'IMPRESORA PARA PLANOS - PLOTTERS', 1);
INSERT INTO BIEN (BIE_codigo, BIE_codigoIdentificador, BIE_nombre, EST_codigo)
VALUES (13, '74084100', 'IMPRESORA LASER', 1);
INSERT INTO BIEN (BIE_codigo, BIE_codigoIdentificador, BIE_nombre, EST_codigo)
VALUES (14, '74222358', 'EQUIPO MULTIFUNCIONAL COPIADORA IMPRESORA SCANNER', 1);
INSERT INTO BIEN (BIE_codigo, BIE_codigoIdentificador, BIE_nombre, EST_codigo)
VALUES (15, '95228117', 'SWITCH PARA RED', 1);
INSERT INTO BIEN (BIE_codigo, BIE_codigoIdentificador, BIE_nombre, EST_codigo)
VALUES (16, '74087250', 'MODEM EXTERNO', 1);
GO

-- VOLCADO DE DATOS PARA LA TABLA CONDICION
INSERT INTO CONDICION (CON_descripcion)
VALUES (N'OPERATIVO');
INSERT INTO CONDICION (CON_descripcion)
VALUES (N'INOPERATIVO');
INSERT INTO CONDICION (CON_descripcion)
VALUES (N'SOLUCIONADO');
INSERT INTO CONDICION (CON_descripcion)
VALUES (N'NO SOLUCIONADO');
GO

--VOLCADO DE DATOS PARA LA TABLA SOLUCION
INSERT INTO SOLUCION (SOL_codigo, SOL_descripcion, EST_codigo)
VALUES (1, N'Formateo de disco duro e instalación de programas', 1);
INSERT INTO SOLUCION (SOL_codigo, SOL_descripcion, EST_codigo)
VALUES (2, N'Mantenimiento correctivo de hardware', 1);
INSERT INTO SOLUCION (SOL_codigo, SOL_descripcion, EST_codigo)
VALUES (3, N'Restauración de sistema operativo', 1);
INSERT INTO SOLUCION (SOL_codigo, SOL_descripcion, EST_codigo)
VALUES (4, N'Restablecimiento de contraseñas de usuario', 1);
INSERT INTO SOLUCION (SOL_codigo, SOL_descripcion, EST_codigo)
VALUES (5, N'Recuperación de archivos', 1);
INSERT INTO SOLUCION (SOL_codigo, SOL_descripcion, EST_codigo)
VALUES (6, N'Actualizaciones de software', 1);
INSERT INTO SOLUCION (SOL_codigo, SOL_descripcion, EST_codigo)
VALUES (7, N'Restablecimiento de configuración de fábrica', 1);
INSERT INTO SOLUCION (SOL_codigo, SOL_descripcion, EST_codigo)
VALUES (8, N'Mantenimiento de infraestructura de red', 1);
GO


-- VOLCADO DE DATOS PARA LA TABLA AREA
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (1, N'Subgerencia de Informática y Sistemas',1)
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (2, N'Gerencia Municipal',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (3, N'Subgerencia de Contabilidad',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (4, N'Alcaldía',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (5, N'Subgerencia de Tesorería', 1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (6, N'Sección de Almacén',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (7, N'Subgerencia de Abastecimiento y Control Patrimonial',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (8, N'Unidad de Control Patrimonial',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (9, N'Caja General',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (10, N'Gerencia de Recursos Humanos',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (11, N'Gerencia de Desarrollo Económico Local',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (12, N'Área de Liquidación de Obras',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (13, N'Subgerencia de Habilitación Urbana y Catastro',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (14, N'Subgerencia de Escalafón',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (15, N'Secretaría General',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (16, N'Unidad de Programa de Vaso de Leche',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (17, N'DEMUNA',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (18, N'OMAPED',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (19, N'Subgerencia de Salud',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (20, N'Gerencia de Administración Tributaria',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (21, N'Servicio Social',2);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (22, N'Unidad de Relaciones Públicas y Comunicaciones',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (23, N'Gerencia de Gestión Ambiental',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (24, N'Gerencia de Asesoría Jurídica',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (25, N'Subgerencia de Planificación y Modernización Institucional',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (26, N'Subgerencia de Gestión y Desarrollo de RR.HH.',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (27, N'Gerencia de Desarrollo Social y Promoción de la Familia',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (28, N'Subgerencia de Educación',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (29, N'Subgerencia de Programas Sociales e Inclusión',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (30, N'Subgerencia de Licencias',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (31, N'Unidad de Policía Municipal',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (32, N'Unidad de Registro Civil',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (33, N'Subgerencia de Mantenimiento de Obras Públicas',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (34, N'Gerencia de Desarrollo Urbano y Planeamiento Territorial',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (35, N'Unidad de Ejecución Coactiva',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (36, N'Subgerencia de Estudios y Proyectos',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (37, N'Subgerencia de Obras',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (38, N'Procuradoría Pública Municipal',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (39, N'Gerencia de Administración y Finanzas',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (40, N'Subgerencia de Defensa Civil',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (41, N'Subgerencia de Juventud, Deporte y Cultura',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (42, N'Subgerencia de Áreas Verdes',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (43, N'Subgerencia de Seguridad Ciudadana',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (44, N'Órgano de Control Institucional',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (45, N'Unidad Local de Empadronamiento - ULE',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (46, N'Unidad de Atención al Usuario y Trámite Documentario',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (47, N'Gerencia de Seguridad Ciudadana, Defensa Civil y Tránsito',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (48, N'Subgerencia de Abastecimiento',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (49, N'Unidad de Participación Vecinal',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (50, N'Gerencia de Planeamiento, Presupuesto y Modernización',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (51, N'Subgerencia de Transporte, Tránsito y Seguridad Vial',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (52, N'Archivo Central',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (53, N'Equipo Mecánico y Maestranza',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (54, N'Subgerencia de Limpieza Pública',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (55, N'Subgerencia de Bienestar Social',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (56, N'Orientación Tributaria',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (57, N'Servicios Generales',1);
INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (58, N'Secretaría Técnica de Procesos Administrativos Disciplinarios',1);
GO
