USE master;
GO

IF EXISTS(SELECT name
          FROM sys.databases
          WHERE name = 'incidencias')
    BEGIN
        DROP DATABASE incidencias;
    END
GO

CREATE DATABASE incidencias;
GO

USE incidencias;
GO


-- CREACION DE LA TABLA ROL
CREATE TABLE ROL
(
    ROL_codigo SMALLINT IDENTITY (1,1) NOT NULL,
    ROL_nombre NVARCHAR(20)            NOT NULL,
    CONSTRAINT PK_rol PRIMARY KEY (ROL_codigo)
);
GO

-- CREACION DE LA TABLA ESTADO
CREATE TABLE ESTADO
(
    EST_codigo      SMALLINT IDENTITY (1,1),
    EST_descripcion NVARCHAR(20) NOT NULL,
    CONSTRAINT PK_estado PRIMARY KEY (EST_codigo)
);
GO

-- CREACION DE LA TABLA PERSONA
CREATE TABLE PERSONA
(
    PER_codigo          SMALLINT IDENTITY (1,1) NOT NULL,
    PER_dni             NCHAR(8)                NOT NULL,
    PER_nombres         NVARCHAR(20)            NOT NULL,
    PER_apellidoPaterno NVARCHAR(15)            NOT NULL,
    PER_apellidoMaterno NVARCHAR(15)            NOT NULL,
    PER_celular         NCHAR(9)                NULL,
    PER_email           NVARCHAR(45)            NULL,
    CONSTRAINT PK_persona PRIMARY KEY (PER_codigo),
    CONSTRAINT UQ_dniPersona UNIQUE (PER_dni)
);
GO

-- CREACION DE LA TABLA AREA
CREATE TABLE AREA
(
    ARE_codigo SMALLINT      NOT NULL,
    ARE_nombre NVARCHAR(100) NOT NULL,
    EST_codigo SMALLINT      NOT NULL,
    CONSTRAINT PK_area PRIMARY KEY (ARE_codigo)
);
GO

-- CREACION DE LA TABLA USUARIO
CREATE TABLE USUARIO
(
    USU_codigo   SMALLINT         NOT NULL,
    USU_nombre   NVARCHAR(50)     NOT NULL,
    USU_password VARBINARY(20)    NOT NULL,
    USU_salt     UNIQUEIDENTIFIER NULL,
    PER_codigo   SMALLINT         NULL,
    ROL_codigo   SMALLINT         NOT NULL,
    ARE_codigo   SMALLINT         NOT NULL,
    EST_codigo   SMALLINT         NOT NULL,
    CONSTRAINT PK_usuario PRIMARY KEY (USU_codigo),
    CONSTRAINT UQ_nombreUsuario UNIQUE (USU_nombre),
    CONSTRAINT FK_persona_usuario FOREIGN KEY (PER_codigo) REFERENCES PERSONA (PER_codigo),
    CONSTRAINT FK_rol_usuario FOREIGN KEY (ROL_codigo) REFERENCES ROL (ROL_codigo),
    CONSTRAINT FK_area_usuario FOREIGN KEY (ARE_codigo) REFERENCES AREA (ARE_codigo)
);


-- CREACION DE LA TABLA PRIORIDAD
CREATE TABLE PRIORIDAD
(
    PRI_codigo SMALLINT IDENTITY (1, 1),
    PRI_nombre NVARCHAR(15) NOT NULL,
    CONSTRAINT PK_prioridad PRIMARY KEY (PRI_codigo),
    CONSTRAINT UQ_nombrePrioridad UNIQUE (PRI_nombre)
);
GO

-- CREACION DE LA TABLA CATEGORIA
CREATE TABLE CATEGORIA
(
    CAT_codigo SMALLINT     NOT NULL,
    CAT_nombre NVARCHAR(60) NOT NULL,
    EST_codigo SMALLINT     NOT NULL,
    CONSTRAINT  PRIMARY KEY (CAT_codigo),
    CONSTRAINT UQ_nombreCategoria UNIQUE (CAT_nombre)
);
GO


-- CREACION DE TABLA IMPACTO
CREATE TABLE IMPACTO
(
    IMP_codigo      SMALLINT IDENTITY (1, 1),
    IMP_descripcion NVARCHAR(20) NOT NULL,
    CONSTRAINT PK_impacto PRIMARY KEY (IMP_codigo)
);
GO

-- CREACIÓN DE LA TABLA BIEN
CREATE TABLE BIEN
(
    BIE_codigo              SMALLINT      NOT NULL,
    BIE_codigoIdentificador NVARCHAR(12)  NULL,
    BIE_nombre              NVARCHAR(100) NULL,
    EST_codigo              SMALLINT      NOT NULL,
    CONSTRAINT PK_bien PRIMARY KEY (BIE_codigo),
    CONSTRAINT UQ_codigoIdentificador UNIQUE (BIE_codigoIdentificador)
);
GO

-- CREACIÓN DE LA TABLA INCIDENCIA
CREATE TABLE INCIDENCIA
(
    INC_numero            SMALLINT      NOT NULL,
    INC_numero_formato    NVARCHAR(20)  NULL,
    INC_fecha             DATE          NOT NULL,
    INC_hora              TIME          NOT NULL,
    INC_asunto            NVARCHAR(500) NOT NULL,
    INC_descripcion       NVARCHAR(800) NULL,
    INC_documento         NVARCHAR(500) NOT NULL,
    INC_codigoPatrimonial NCHAR(12)     NULL,
    EST_codigo            SMALLINT      NOT NULL,
    CAT_codigo            SMALLINT      NOT NULL,
    ARE_codigo            SMALLINT      NOT NULL,
    USU_codigo            SMALLINT      NOT NULL,
    CONSTRAINT PK_incidencia PRIMARY KEY (INC_numero),
    CONSTRAINT FK_categoria_incidencia FOREIGN KEY (CAT_codigo) REFERENCES CATEGORIA (CAT_codigo),
    CONSTRAINT FK_area_incidencia FOREIGN KEY (ARE_codigo) REFERENCES AREA (ARE_codigo),
    CONSTRAINT FK_usuario_incidencia FOREIGN KEY (USU_codigo) REFERENCES USUARIO (USU_codigo)
);
GO

-- CREACION DE TABLA RECEPCION
CREATE TABLE RECEPCION
(
    REC_numero SMALLINT NOT NULL,
    REC_fecha  DATE     NOT NULL,
    REC_hora   TIME     NOT NULL,
    INC_numero SMALLINT NOT NULL,
    PRI_codigo SMALLINT NOT NULL,
    IMP_codigo SMALLINT NOT NULL,
    USU_codigo SMALLINT NOT NULL,
    EST_codigo SMALLINT NOT NULL,
    CONSTRAINT PK_recepcion PRIMARY KEY (REC_numero),
    CONSTRAINT FK_incidencia_recepcion FOREIGN KEY (INC_numero) REFERENCES INCIDENCIA (INC_numero),
    CONSTRAINT FK_prioridad_recepcion FOREIGN KEY (PRI_codigo) REFERENCES PRIORIDAD (PRI_codigo),
    CONSTRAINT FK_impacto_recepcion FOREIGN KEY (IMP_codigo) REFERENCES IMPACTO (IMP_codigo),
    CONSTRAINT FK_usuario_recepcion FOREIGN KEY (USU_codigo) REFERENCES USUARIO (USU_codigo)
);
GO

--CREACION DE LA TABLA ASIGNACION
CREATE TABLE ASIGNACION
(
    ASI_codigo SMALLINT NOT NULL,
    ASI_fecha  DATE     NOT NULL,
    ASI_hora   TIME     NOT NULL,
    EST_codigo SMALLINT NOT NULL,
    USU_codigo SMALLINT NOT NULL,
    REC_numero SMALLINT NOT NULL,
    CONSTRAINT PK_asignacion PRIMARY KEY (ASI_codigo),
    CONSTRAINT FK_usuario_asignacion FOREIGN KEY (USU_codigo) REFERENCES USUARIO (USU_codigo),
    CONSTRAINT FK_recepcion_asignacion FOREIGN KEY (REC_numero) REFERENCES RECEPCION (REC_numero)
);
GO

--CREACION DE LA TABLA EJECUCION DE MANTENIMIENTO
CREATE TABLE MANTENIMIENTO
(
    MAN_codigo SMALLINT NOT NULL,
    MAN_fecha  DATE     NULL,
    MAN_hora   TIME     NULL,
    EST_codigo SMALLINT NOT NULL,
    ASI_codigo SMALLINT NOT NULL,
    CONSTRAINT PK_mantenimiento PRIMARY KEY (MAN_codigo),
    CONSTRAINT FK_asignacion_mantenimiento FOREIGN KEY (ASI_codigo) REFERENCES ASIGNACION (ASI_codigo)
);
GO

-- CREACION DE LA TABLA CONDICION
CREATE TABLE CONDICION
(
    CON_codigo      SMALLINT IDENTITY (1,1) NOT NULL,
    CON_descripcion NVARCHAR(20)            NOT NULL,
    CONSTRAINT PK_operatividad PRIMARY KEY (CON_codigo)
);
GO

--CREACION DE LA TABLA SOLUCION
CREATE TABLE SOLUCION
(
    SOL_codigo      SMALLINT      NOT NULL,
    SOL_descripcion NVARCHAR(100) NOT NULL,
    EST_codigo      SMALLINT      NOT NULL,
    CONSTRAINT PK_solucion PRIMARY KEY (SOL_codigo)
);
GO

-- CREACION DE LA TABLA CIERRE
CREATE TABLE CIERRE
(
    CIE_numero          SMALLINT       NOT NULL,
    CIE_fecha           DATE           NOT NULL,
    CIE_hora            TIME           NOT NULL,
    CIE_diagnostico     NVARCHAR(1000) NULL,
    CIE_documento       NVARCHAR(500)  NOT NULL,
    CIE_recomendaciones NVARCHAR(1000) NULL,
    CON_codigo          SMALLINT       NOT NULL,
    EST_codigo          SMALLINT       NOT NULL,
    MAN_codigo          SMALLINT       NOT NULL,
    USU_codigo          SMALLINT       NOT NULL,
    SOL_codigo          SMALLINT       NOT NULL,
    CONSTRAINT PK_cierre PRIMARY KEY (CIE_numero),
    CONSTRAINT FK_condicion_cierre FOREIGN KEY (CON_codigo) REFERENCES CONDICION (CON_codigo),
    CONSTRAINT FK_mantenimiento_cierre FOREIGN KEY (MAN_codigo) REFERENCES MANTENIMIENTO (MAN_codigo),
    CONSTRAINT FK_usuario_cierre FOREIGN KEY (USU_codigo) REFERENCES USUARIO (USU_codigo),
    CONSTRAINT FK_solucion_cierre FOREIGN KEY (SOL_codigo) REFERENCES SOLUCION (SOL_codigo)
);
GO

--CREACION DE LA TABLA AUDITORIA
CREATE TABLE AUDITORIA
(
    AUD_codigo       INT IDENTITY (1,1) NOT NULL,
    AUD_tabla        NVARCHAR(255)      NULL,
    AUD_operacion    NVARCHAR(100)      NULL,
    AUD_fecha        DATETIME           NULL,
    AUD_valorAntes   NVARCHAR(MAX)      NULL,
    AUD_valorDespues NVARCHAR(MAX)      NULL,
    AUD_ipEquipo     NVARCHAR(50)       NULL,
    AUD_nombreEquipo NVARCHAR(200)      NULL,
    AUD_registro     NVARCHAR(MAX)      NULL,
    AUD_usuario      SMALLINT           NULL,
    CONSTRAINT PK_auditoria PRIMARY KEY (AUD_codigo)
);
GO