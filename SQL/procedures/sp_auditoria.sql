CREATE OR ALTER PROCEDURE sp_auditoria
    -- Parámetro del tipo de operacion
    @Tipo TINYINT, -- 1: Insertar, 2: Actualizar, 3: Eliminar, 4: Habilitar, 5: Deshabilitar, 6: Iniciar sesión
    -- Parámetros de entrada
    @AUD_tabla NVARCHAR(255),
    @AUD_operacion NVARCHAR(100) = NULL, -- Se genera automáticamente si no se proporciona
    @AUD_registro NVARCHAR(MAX),
    @AUD_valorAntes NVARCHAR(MAX) = NULL,
    @AUD_valorDespues NVARCHAR(MAX) = NULL,
    @AUD_usuario SMALLINT = NULL AS
BEGIN
    SET NOCOUNT ON;

    -- Validar tipo
    IF @Tipo NOT IN (1, 2, 3, 4, 5, 6)
        BEGIN
            RAISERROR (N'Tipo de auditoría inválido. Debe ser 1 (Insertar), 2 (Actualizar), 3 (Eliminar), 4 (Habilitar), 5 (Deshabilitar) o 6 (Iniciar sesión).', 16, 1);
            RETURN;
        END

    -- Validar usuario
    IF @AUD_usuario IS NULL
        BEGIN
            RAISERROR (N'Debe proporcionar el código del usuario que ejecuta la auditoría.', 16, 1);
            RETURN;
        END

    IF NOT EXISTS (SELECT 1 FROM USUARIO WHERE USU_codigo = @AUD_usuario)
        BEGIN
            RAISERROR (N'El usuario especificado no existe en la tabla USUARIO.', 16, 1);
            RETURN;
        END

    -- Asignar operación automática si no se especificó
    IF @AUD_operacion IS NULL
        BEGIN
            SET @AUD_operacion = CASE @Tipo
                                     WHEN 1 THEN N'Insertar'
                                     WHEN 2 THEN N'Actualizar'
                                     WHEN 3 THEN N'Eliminar'
                                     WHEN 4 THEN N'Habilitar'
                                     WHEN 5 THEN N'Deshabilitar'
                                     WHEN 6 THEN N'Iniciar sesión' END;
        END

    -- Insertar auditoría
    INSERT INTO AUDITORIA (AUD_tabla,
                           AUD_operacion,
                           AUD_fecha,
                           AUD_valorAntes,
                           AUD_valorDespues,
                           AUD_ipEquipo,
                           AUD_nombreEquipo,
                           AUD_registro,
                           AUD_usuario)
    VALUES (@AUD_tabla,
            @AUD_operacion,
            GETDATE(),
            @AUD_valorAntes,
            @AUD_valorDespues,
            CONVERT(NVARCHAR(50), CONNECTIONPROPERTY('client_net_address')),
            HOST_NAME(),
            @AUD_registro,
            @AUD_usuario);
END;
GO
