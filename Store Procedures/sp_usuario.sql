/*
--------------------------------------------------------------------------------
 Script        : sp_usuario.sql
 Descripción   : Procedimiento que gestiona el mantenimiento de usuarios del sistema.
 Tipo de Objeto: Procedimiento Almacenado (Stored Procedure)

 Empresa       : Municipalidad Distrital de La Esperanza
 Área          : Subgerencia de Informática y Sistemas
 Autor         : Jhonatan Mantilla Miñano
 Fecha creación: 2025-07-22

 Parámetros:
    @TipoOperacion : Tipo de operación (1: Inicial, 2: Crear, 3: Editar, 4: Habilitar)
    @CodUsuario    : Código del usuario (para editar/habilitar)
    @Username      : Nombre del usuario
    @Password      : Contraseña en texto plano
    @CodPersona    : Código de la persona asociada
    @CodRol        : Código del rol
    @CodArea       : Código del área
    @Usuario       : Usuario que realiza la operación
    @Mensaje       : Mensaje de salida
    @Respuesta     : Código de respuesta (0 = Error, 1 = Éxito)

 Observaciones:
    - Usa la función dbo.fn_hash_password para proteger contraseñas.
    - Llama a sp_auditoria para registrar cambios.
--------------------------------------------------------------------------------
*/
CREATE OR ALTER PROCEDURE sp_usuario
    -- Tipo de operacion
    @TipoOperacion TINYINT,
    -- Parámetros de entrada
    @CodUsuario SMALLINT = NULL,
    @Username NVARCHAR(50) = NULL,
    @Password NVARCHAR(100) = NULL,
    @CodPersona SMALLINT = NULL,
    @CodRol SMALLINT = NULL,
    @CodArea SMALLINT = NULL,

    -- Parámetros para cambio de contraseña
    @PasswordNuevo NVARCHAR(100) = NULL,
    @PasswordConfirm NVARCHAR(100) = NULL,

    -- Parámetro de busqueda de termino
    @TerminoBusqueda VARCHAR(MAX) = NULL,
    -- Usuario que ejecuta la acción
    @Usuario SMALLINT = NULL,
    -- Parámetros de salida
    @Mensaje NVARCHAR(500) = NULL OUTPUT,
    @Respuesta TINYINT = 0 OUTPUT AS
BEGIN
    SET NOCOUNT ON;

    SET @Mensaje = '';
    SET @Respuesta = 0;

    -- Variables para el hasheo
    DECLARE @salt UNIQUEIDENTIFIER, @hashed_password VARBINARY(20);

    -- Obtener la contraseña almacenada y el salt del usuario
    DECLARE @stored_password VARBINARY(20);
    SELECT @stored_password = USU_password, @salt = USU_salt FROM USUARIO WHERE USU_codigo = @CodUsuario;

    -- Parametros para usar
    DECLARE @EstadoInactivo SMALLINT, @EstadoActivo SMALLINT, @NuevoCod SMALLINT;
    SELECT @EstadoInactivo = EST_codigo FROM ESTADO WHERE EST_descripcion LIKE N'INACTIVO';
    SELECT @EstadoActivo = EST_codigo FROM ESTADO WHERE EST_descripcion LIKE N'ACTIVO';

    -- Variables de auditoría
    DECLARE @RegistroAuditoria NVARCHAR(MAX), @ValorAntes NVARCHAR(MAX), @ValorDespues NVARCHAR(MAX);

    /***** TIPO 1: REGISTRAR USUARIO INICIAL (SOLO SI NO EXISTEN USUARIOS) ******/
    IF @TipoOperacion = 1
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION;
                -- Validar que no existan usuarios
                IF EXISTS (SELECT 1 FROM USUARIO)
                    BEGIN
                        SET @Mensaje = N'Ya existen usuarios en el sistema. No se puede crear el usuario inicial.';
                        ROLLBACK;
                        RETURN;
                    END

                -- Parámetros por defecto
                SET @Username = 'admin';
                SET @Password = 'admin123';

                -- Crear rol "Administrador" si no existe
                IF NOT EXISTS (SELECT 1 FROM ROL WHERE ROL_nombre = N'Administrador')
                    BEGIN
                        INSERT INTO ROL (ROL_nombre) VALUES (N'Administrador');
                    END

                -- Crear área "General" si no existe
                IF NOT EXISTS (SELECT 1 FROM AREA WHERE ARE_nombre = N'General')
                    BEGIN
                        INSERT INTO AREA (ARE_codigo, ARE_nombre, EST_codigo) VALUES (0, N'General', 1);
                    END

                -- Obtener códigos recién creados
                SELECT @CodRol = ROL_codigo FROM ROL WHERE ROL_nombre = N'Administrador';
                SELECT @CodArea = ARE_codigo FROM AREA WHERE ARE_nombre = N'General';

                -- Generar salt y hash
                SET @salt = NEWID();
                SET @hashed_password = dbo.fn_hash_password(@Password, @salt);

                IF @hashed_password IS NULL
                    BEGIN
                        SET @Mensaje = N'Error al generar el hash de la contraseña.';
                        ROLLBACK;
                        RETURN;
                    END

                -- Generar nuevo código de usuario
                SELECT @NuevoCod = ISNULL(MAX(USU_codigo), 0) + 1 FROM USUARIO;

                -- Insertar usuario
                INSERT INTO USUARIO (USU_codigo, USU_nombre, USU_password, USU_salt, PER_codigo, ROL_codigo, ARE_codigo,
                                     EST_codigo)
                VALUES (@NuevoCod, @Username, @hashed_password, @salt, NULL, @CodRol, @CodArea, 1);

                -- Confirmar la transacción: todos los cambios han sido validados correctamente
                COMMIT;

                -- Mostrar mensaje de salida
                SET @Mensaje = N'Usuario inicial creado.';
                SET @Respuesta = 1;

            END TRY BEGIN CATCH
                IF @@TRANCOUNT > 0 ROLLBACK;
                SET @Mensaje = 'Error tipo 1 ' + CAST(ERROR_NUMBER() AS NVARCHAR) + ': ' + ERROR_MESSAGE();
                SET @Respuesta = 0;
            END CATCH
        END

    /***** TIPO 2: REGISTRAR USUARIO NUEVO ******/
    IF @TipoOperacion = 2
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION;

                -- Validar si la persona ya tiene un usuario registrado
                IF EXISTS (SELECT 1 FROM USUARIO WHERE PER_codigo = @CodPersona)
                    BEGIN
                        SET @Mensaje = N'La persona ya tiene un usuario registrado.';
                        ROLLBACK;
                        RETURN;
                    END

                -- Validar si el nombre de usuario ya está en uso
                IF EXISTS (SELECT 1 FROM USUARIO WHERE USU_nombre = @Username)
                    BEGIN
                        SET @Mensaje =
                                N'El nombre de usuario ya está registrado. Por favor elija otro nombre de usuario.';
                        ROLLBACK;
                        RETURN;
                    END

                -- Generar salt y hash
                SET @salt = NEWID();
                SET @hashed_password = dbo.fn_hash_password(@Password, @salt);

                IF @hashed_password IS NULL
                    BEGIN
                        SET @Mensaje = N'Error al generar el hash de la contraseña.';
                        ROLLBACK;
                        RETURN;
                    END

                -- Obtener nuevo código incremental
                SELECT @NuevoCod = ISNULL(MAX(USU_codigo), 0) + 1 FROM USUARIO;

                -- Insertar usuario
                INSERT INTO USUARIO (USU_codigo, USU_nombre, USU_password, USU_salt, PER_codigo, ROL_codigo, ARE_codigo,
                                     EST_codigo)
                VALUES (@NuevoCod, @Username, @hashed_password, @salt, @CodPersona, @CodRol, @CodArea, 1);

                -- Auditoría
                SET @RegistroAuditoria = 'Cod: ' + CAST(@NuevoCod AS VARCHAR);
                SET @ValorDespues = FORMATMESSAGE(N'Username = "%s", CodPersona = %d, CodRol = %d, CodArea = %d',
                                                  ISNULL(@Username, ''), ISNULL(@CodPersona, 0), ISNULL(@CodRol, 0),
                                                  ISNULL(@CodArea, 0));
                EXEC sp_auditoria 1, N'Usuario', NULL, @RegistroAuditoria, NULL, @ValorDespues, @Usuario;

                -- Confirmar la transacción: todos los cambios han sido validados correctamente
                COMMIT;
                -- Mostrar mensaje de salida
                SET @Mensaje = N'Usuario registrado.';
                SET @Respuesta = 1;

            END TRY BEGIN CATCH
                IF @@TRANCOUNT > 0 ROLLBACK;
                SET @Mensaje = 'Error Tipo 2: ' + ERROR_MESSAGE();
                SET @Respuesta = 0;
            END CATCH
        END

    /***** TIPO 3: EDITAR USUARIO ******/
    IF @TipoOperacion = 3
        BEGIN
            BEGIN TRANSACTION;

            -- Verificar si el nombre del usuario ya está en uso por otro
            IF EXISTS (SELECT 1 FROM USUARIO WHERE USU_nombre = @Username AND USU_codigo != @CodUsuario)
                BEGIN
                    SET @Mensaje = N'El nombre de usuario ya está en uso';
                    ROLLBACK;
                    RETURN;
                END

            -- Obtener valores actuales del usuario
            DECLARE @OldUsername NVARCHAR(50), @OldCodPersona SMALLINT, @OldCodRol SMALLINT, @OldCodArea SMALLINT;

            SELECT @OldUsername = USU_nombre,
                   @OldCodPersona = PER_codigo,
                   @OldCodRol = ROL_codigo,
                   @OldCodArea = ARE_codigo
            FROM USUARIO
            WHERE USU_codigo = @CodUsuario;

            -- Verificar si hubo algún cambio
            IF @OldUsername = @Username AND @OldCodPersona = @CodPersona AND @OldCodRol = @CodRol AND
               @OldCodArea = @CodArea
                BEGIN
                    SET @Mensaje = N'No se detectaron cambios en los datos del usuario.';
                    ROLLBACK;
                    RETURN;
                END

            -- Armar valores antes y después
            SET @ValorAntes = FORMATMESSAGE(N'Username = "%s", CodPersona = %d, CodRol = %d, CodArea = %d',
                                            ISNULL(@OldUsername, ''), ISNULL(@OldCodPersona, 0), ISNULL(@OldCodRol, 0),
                                            ISNULL(@OldCodArea, 0));

            SET @ValorDespues =
                    FORMATMESSAGE(N'Username = "%s", CodPersona = %d, CodRol = %d, CodArea = %d', ISNULL(@Username, ''),
                                  ISNULL(@CodPersona, 0), ISNULL(@CodRol, 0), ISNULL(@CodArea, 0));

            -- Actualizar usuario
            UPDATE USUARIO
            SET USU_nombre = @Username,
                PER_codigo = @CodPersona,
                ROL_codigo = @CodRol,
                ARE_codigo = @CodArea
            WHERE USU_codigo = @CodUsuario;

            -- Auditoría
            SET @RegistroAuditoria = 'Cod: ' + CAST(@CodUsuario AS VARCHAR);
            EXEC sp_auditoria 2, N'Usuario', NULL, @RegistroAuditoria, @ValorAntes, @ValorDespues, @Usuario;

            -- Confirmar la transacción: todos los cambios han sido validados correctamente
            COMMIT TRANSACTION;
            -- Mostrar mensaje de salida
            SET @Mensaje = N'Usuario actualizado.';
            SET @Respuesta = 1;
        END

    /***** TIPO 4: HABILITAR USUARIO *****/
    IF @TipoOperacion = 4
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION;
                -- Validar que esté deshabilitado
                IF NOT EXISTS (SELECT 1 FROM USUARIO WHERE USU_codigo = @codUsuario AND EST_codigo = @EstadoInactivo)
                    BEGIN
                        SET @Mensaje = N'El usuario ya está habilitado.';
                        ROLLBACK
                        RETURN;
                    END

                -- Obtener valor antes
                SELECT @ValorAntes = FORMATMESSAGE(N'EST_codigo = %d', EST_codigo)
                FROM USUARIO
                WHERE USU_codigo = @codUsuario;
                -- Actualizar el estado del usuario
                UPDATE USUARIO SET EST_codigo = 1 WHERE EST_codigo = 2 AND USU_codigo = @codUsuario;
                -- Obtener valor después
                SELECT @ValorDespues = FORMATMESSAGE(N'EST_codigo = %d', EST_codigo)
                FROM USUARIO
                WHERE USU_codigo = @codUsuario;

                -- Registrar auditoría
                EXEC sp_auditoria 4, N'Usuario', NULL, @codUsuario, @ValorAntes, @ValorDespues, @Usuario;
                -- Confirmar la transacción: todos los cambios han sido validados correctamente
                COMMIT;
                -- Mostrar mensaje de salida
                SET @Mensaje = N'Usuario habilitado.';
                SET @Respuesta = 1;

            END TRY BEGIN CATCH
                IF @@TRANCOUNT > 0 ROLLBACK;
                SET @Mensaje = 'Error Tipo 4: ' + ERROR_MESSAGE();
                SET @Respuesta = 0;
            END CATCH
        END

    /***** TIPO 5: INHABILITAR USUARIO *****/
    IF @TipoOperacion = 5
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION;
                -- Validar que esté habilitado
                IF NOT EXISTS (SELECT 1 FROM USUARIO WHERE USU_codigo = @codUsuario AND EST_codigo = @EstadoActivo)
                    BEGIN
                        SET @Mensaje = N'El usuario ya está deshabilitado.';
                        ROLLBACK
                        RETURN;
                    END

                -- Obtener valor antes
                SELECT @ValorAntes = FORMATMESSAGE(N'EST_codigo = %d', EST_codigo)
                FROM USUARIO
                WHERE USU_codigo = @codUsuario;

                -- Actualizar el estado del usuario
                UPDATE USUARIO SET EST_codigo = 2 WHERE EST_codigo = 1 AND USU_codigo = @codUsuario;
                -- Obtener valor después
                SELECT @ValorDespues = FORMATMESSAGE(N'EST_codigo = %d', EST_codigo)
                FROM USUARIO
                WHERE USU_codigo = @codUsuario;

                -- Registrar auditoría
                EXEC sp_auditoria 5, 'Usuario', NULL, @codUsuario, @ValorAntes, @ValorDespues, @Usuario;

                -- Confirmar la transacción: todos los cambios han sido validados correctamente
                COMMIT;
                -- Mostrar mensaje de salida
                SET @Mensaje = N'Usuario deshabilitado.';
                SET @Respuesta = 1;

            END TRY BEGIN CATCH
                IF @@TRANCOUNT > 0 ROLLBACK;
                SET @Mensaje = 'Error Tipo 5: ' + ERROR_MESSAGE();
                SET @Respuesta = 0;
            END CATCH
        END

    /***** TIPO 6: BUSCAR USUARIOS POR TÉRMINO DE BÚSQUEDA *****/
    IF @TipoOperacion = 6
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION ;
                -- Verificar si hay coincidencias
                IF NOT EXISTS (SELECT 1
                               FROM USUARIO u
                                        INNER JOIN PERSONA p ON p.PER_codigo = u.PER_codigo
                                        INNER JOIN AREA a ON a.ARE_codigo = u.ARE_codigo
                                        INNER JOIN ROL r ON r.ROL_codigo = u.ROL_codigo
                               WHERE @TerminoBusqueda IS NULL
                                  OR (u.USU_nombre LIKE '%' + LTRIM(RTRIM(@TerminoBusqueda)) + '%' OR
                                      p.PER_nombres LIKE '%' + LTRIM(RTRIM(@TerminoBusqueda)) + '%' OR
                                      p.PER_apellidoPaterno LIKE '%' + LTRIM(RTRIM(@TerminoBusqueda)) + '%' OR
                                      p.PER_apellidoMaterno LIKE '%' + LTRIM(RTRIM(@TerminoBusqueda)) + '%' OR
                                      p.PER_dni LIKE '%' + LTRIM(RTRIM(@TerminoBusqueda)) + '%' OR
                                      a.ARE_nombre LIKE '%' + LTRIM(RTRIM(@TerminoBusqueda)) + '%' OR
                                      r.ROL_nombre LIKE '%' + LTRIM(RTRIM(@TerminoBusqueda)) + '%'))
                    BEGIN
                        SET @Mensaje = N'No se encontraron coincidencias.';
                        ROLLBACK;
                        RETURN;
                    END

                -- Mostrar resultados
                SELECT p.PER_dni                                                                         AS dni,
                       TRIM(CONCAT_WS(' ', p.PER_nombres, p.PER_apellidoPaterno,
                                      p.PER_apellidoMaterno))                                            AS nombreContribuyente,
                       a.ARE_nombre                                                                      AS area,
                       r.ROL_nombre                                                                      AS rol
                FROM USUARIO u
                         INNER JOIN PERSONA p ON p.PER_codigo = u.PER_codigo
                         INNER JOIN AREA a ON a.ARE_codigo = u.ARE_codigo
                         INNER JOIN ROL r ON r.ROL_codigo = u.ROL_codigo
                WHERE @TerminoBusqueda IS NULL
                   OR (u.USU_nombre LIKE '%' + LTRIM(RTRIM(@TerminoBusqueda)) + '%' OR
                       p.PER_nombres LIKE '%' + LTRIM(RTRIM(@TerminoBusqueda)) + '%' OR
                       p.PER_apellidoPaterno LIKE '%' + LTRIM(RTRIM(@TerminoBusqueda)) + '%' OR
                       p.PER_apellidoMaterno LIKE '%' + LTRIM(RTRIM(@TerminoBusqueda)) + '%' OR
                       p.PER_dni LIKE '%' + LTRIM(RTRIM(@TerminoBusqueda)) + '%' OR
                       a.ARE_nombre LIKE '%' + LTRIM(RTRIM(@TerminoBusqueda)) + '%' OR
                       r.ROL_nombre LIKE '%' + LTRIM(RTRIM(@TerminoBusqueda)) + '%');

                COMMIT;
                SET @Mensaje = N'Búsqueda realizada correctamente.';
                SET @Respuesta = 1;
            END TRY BEGIN CATCH
                SET @Mensaje = 'Error Tipo 6: ' + ERROR_MESSAGE();
                SET @Respuesta = 0;
            END CATCH
        END

    /***** TIPO 7: CAMBIAR CONTRASEÑA *****/
    IF @TipoOperacion = 7
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION ;
                -- Verificar que la nueva contraseña y la confirmación coincidan
                IF @PasswordNuevo != @PasswordConfirm
                    BEGIN
                        SET @Mensaje = N'La nueva contraseña y la confirmación no coinciden.';
                        ROLLBACK;
                        RETURN;
                    END

                IF @stored_password IS NULL
                    BEGIN
                        SET @Mensaje = N'Usuario no encontrado.';
                        ROLLBACK;
                        RETURN;
                    END

                -- Verificar que la contraseña actual coincida
                DECLARE @hashed_actual VARBINARY(20) = dbo.fn_hash_password(@password, @salt);

                IF @hashed_actual != @stored_password
                    BEGIN
                        SET @Mensaje = N'Contraseña actual incorrecta.';
                        ROLLBACK
                        RETURN;
                    END

                -- Hashear la nueva contraseña
                DECLARE @hashed_nueva VARBINARY(20) = dbo.fn_hash_password(@PasswordNuevo, @salt);
                -- Verificar que la nueva contraseña no sea igual a la actual
                IF @hashed_nueva = @stored_password
                    BEGIN
                        SET @Mensaje = N'La nueva contraseña no puede ser igual a la anterior.';
                        ROLLBACK;
                        RETURN;
                    END
                -- Actualizar la nueva contraseña
                UPDATE USUARIO SET USU_password = @hashed_nueva WHERE USU_codigo = @CodUsuario;

                -- Registrar evento de auditoria

                -- Confirmar la transacción: todos los cambios han sido validados correctamente
                COMMIT;
                -- Mostrar mensaje de salida
                SET @Mensaje = N'Contraseña cambiada.';
                SET @Respuesta = 1;

            END TRY BEGIN CATCH
                IF @@TRANCOUNT > 0 ROLLBACK;
                SET @Mensaje = 'Error Tipo 7: ' + ERROR_MESSAGE();
                SET @Respuesta = 0;
            END CATCH
        END

    /***** TIPO 8: RESTABLECER CONTRASEÑA *****/
    IF @TipoOperacion = 8
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION -- Verificar que la nueva contraseña y la confirmación coincidan
                IF @PasswordNuevo != @PasswordConfirm
                    BEGIN
                        SET @Mensaje = N'La nueva contraseña y la confirmación no coinciden.';
                        ROLLBACK;
                        RETURN;
                    END

                -- Validar que la nueva contraseña no sea igual a la actual
                IF dbo.fn_hash_password(@PasswordNuevo, @salt) = @stored_password
                    BEGIN
                        SET @Mensaje = N'La nueva contraseña no puede ser igual a la anterior.';
                        ROLLBACK;
                        RETURN;
                    END

                -- Generar un nuevo salt
                SET @salt = NEWID();

                -- Hashear la nueva contraseña con el nuevo salt
                DECLARE @hashed_password_nueva VARBINARY(20) = dbo.fn_hash_password(@PasswordNuevo, @salt);

                -- Actualizar la contraseña y el nuevo salt
                UPDATE USUARIO
                SET USU_password = @hashed_password_nueva, USU_salt = @salt
                WHERE USU_codigo = @CodUsuario;

                -- Confirmar la transacción: todos los cambios han sido validados correctamente
                COMMIT;
                -- Mostrar mensaje de salida
                SET @Mensaje = N'Contraseña restablecida.';
                SET @Respuesta = 1;
            END TRY BEGIN CATCH
                IF @@TRANCOUNT > 0 ROLLBACK;
                SET @Mensaje = 'Error Tipo 8: ' + ERROR_MESSAGE();
                SET @Respuesta = 0;
            END CATCH
        END

    /***** OPERACIÓN INVÁLIDA ******/
    IF @TipoOperacion NOT IN (1, 2, 3, 4, 5, 6, 7, 8)
        BEGIN
            SET @Mensaje = N'Tipo de operación inválido.';
            SET @Respuesta = 0;
        END
END;
GO


