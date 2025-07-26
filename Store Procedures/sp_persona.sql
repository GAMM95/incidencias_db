CREATE OR ALTER PROCEDURE sp_persona
    -- Tipo de operacion
    @TipoOperacion TINYINT,
    -- Parámetros de entrada
    @CodPersona SMALLINT = NULL,
    @Dni NCHAR(8) = NULL,
    @Nombres NVARCHAR(20) = NULL,
    @ApellidoPaterno NVARCHAR(15) = NULL,
    @ApellidoMaterno NVARCHAR(15) = NULL,
    @Celular NCHAR(9) = NULL,
    @Email NVARCHAR(45) = NULL,
    -- Usuario que ejecuta la acción
    @Usuario SMALLINT = NULL,
    -- Parámetros de salida
    @Mensaje NVARCHAR(500) = NULL OUTPUT,
    @Respuesta TINYINT = NULL OUTPUT AS
BEGIN

    SET NOCOUNT ON;

    -- Inicializar salida
    SET @Respuesta = 0;
    SET @Mensaje = '';

    -- Variables de auditoria
    DECLARE @RegistroAuditoria NVARCHAR(MAX), @ValorAntes NVARCHAR(MAX), @ValorDespues NVARCHAR(MAX);

    /***** TIPO 1: REGISTRAR PERSONA *****/
    IF @TipoOperacion = 1
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION;
                -- Validar DNI duplicado
                IF EXISTS(SELECT 1 FROM PERSONA WHERE PER_dni = @Dni)
                    BEGIN
                        SET @Mensaje = N'El DNI ya se encuentra registrado.';
                        ROLLBACK
                        RETURN;
                    END

                -- Insertar nueva persona
                INSERT INTO PERSONA(PER_dni, PER_nombres, PER_apellidoPaterno, PER_apellidoMaterno, PER_celular,
                                    PER_email)
                VALUES (@Dni, @Nombres, @ApellidoPaterno, @ApellidoMaterno, @Celular, @Email);
                -- Obtener el codigo de la persona creada por ser identity
                DECLARE @NewCodPersona SMALLINT = SCOPE_IDENTITY();

                -- TODO: Agregar más detalles de auditoría si es necesario
                -- Valores de auditoria
                SET @RegistroAuditoria = N'Código: ' + CAST(@NewCodPersona AS NVARCHAR);

                SET SET @ValorDespues = FORMATMESSAGE('');
                EXEC sp_auditoria 1, N'Persona', NULL, @Dni, NULL, NULL, @Usuario;

                -- Confirmar la transacción: todos los cambios han sido validados correctamente
                COMMIT;
                -- Mostrar mensaje de salida
                SET @Mensaje = N'Registro exitoso.';
                SET @Respuesta = 1;

            END TRY BEGIN CATCH
                IF @@TRANCOUNT > 0 ROLLBACK;
                SET @Mensaje = 'Error Tipo 1: ' + ERROR_MESSAGE();
                SET @Respuesta = 0;
            END CATCH
        END

    /***** TIPO 2: EDITAR PERSONA *****/
    IF @TipoOperacion = 2
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION;

                -- Actualizar datos de persona
                UPDATE PERSONA
                SET PER_nombres         = @Nombres,
                    PER_apellidoPaterno = @ApellidoPaterno,
                    PER_apellidoMaterno = @ApellidoMaterno,
                    PER_celular         = @Celular,
                    PER_email           = @Email
                WHERE PER_codigo = @CodPersona

                EXEC sp_auditoria 2, N'Persona', @CodPersona, @Dni, NULL, NULL, @Usuario; COMMIT;
                -- Confirmar la transacción: todos los cambios han sido validados correctamente
                COMMIT;
                -- Mostrar mensaje de salida
                SET @Mensaje = N'Datos actualizados.';
                SET @Respuesta = 1;

            END TRY BEGIN CATCH
                IF @@TRANCOUNT > 0 ROLLBACK;
                SET @Mensaje = 'Error Tipo 2: ' + ERROR_MESSAGE();
                SET @Respuesta = 0;
            END CATCH
        END

    /***** TIPO 7: EDITAR PERFIL *****/
    IF @TipoOperacion = 7
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION;

                DECLARE @CodUsuario SMALLINT;
                SELECT @CodUsuario = USU_codigo FROM USUARIO;

                -- Actualizar los datos de la persona vinculada al usuario
                UPDATE PERSONA
                SET PER_nombres         = @Nombres,
                    PER_apellidoPaterno = @ApellidoPaterno,
                    PER_apellidoMaterno = @ApellidoMaterno,
                    PER_celular         = @Celular,
                    PER_email           = @Email
                WHERE PER_codigo = (SELECT PER_codigo FROM USUARIO WHERE USU_codigo = @CodUsuario);

                -- Confirmar la transacción: todos los cambios han sido validados correctamente
                COMMIT;
                -- Mostrar mensaje de salida
                SET @Mensaje = N'Datos de perfil actualizados.';
                SET @Respuesta = 1;

            END TRY BEGIN CATCH
                IF @@TRANCOUNT > 0 ROLLBACK;
                SET @Mensaje = 'Error Tipo 7: ' + ERROR_MESSAGE();
                SET @Respuesta = 0;
            END CATCH
        END

    /***** OPERACIÓN INVÁLIDA ******/
    IF @TipoOperacion NOT IN (1, 2, 3, 4, 5)
        BEGIN
            SET @Mensaje = N'Tipo de operación inválido.';
            SET @Respuesta = 0;
        END
END;
GO