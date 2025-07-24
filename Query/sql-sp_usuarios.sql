/*

 */
-- TIPO 2: REGISTRAR USUARIO
DECLARE @Mensaje NVARCHAR(500), @Respuesta INT;
EXEC sp_usuario @TipoOperacion = 2, @Username = N'usuario1', @Password = N'clave123', @CodPersona = 1, @CodRol = 1,
     @CodArea = 0, -- Por ejemplo, código del área 'General'
     @Usuario = 1, -- Usuario que realiza la operación
     @Mensaje = @Mensaje OUTPUT, @Respuesta = @Respuesta OUTPUT;
SELECT @Mensaje AS Mensaje, @Respuesta AS Respuesta;

-- TIPO 3: EDITAR USUARIO
DECLARE @Mensaje NVARCHAR(500), @Respuesta INT;
EXEC sp_usuario @TipoOperacion = 3, @CodUsuario = 2, -- Código del usuario a editar
     @Username = 'GAMM', @CodPersona = 1, @CodRol = 2, @CodArea = 1,
     @Usuario = 1, -- Usuario que realiza la edición
     @Mensaje = @Mensaje OUTPUT, @Respuesta = @Respuesta OUTPUT;
SELECT @Mensaje AS Mensaje, @Respuesta AS Respuesta;

-- TIPO 4: HABILITAR USUARIO
DECLARE @Mensaje NVARCHAR(500), @Respuesta INT;
EXEC sp_usuario @TipoOperacion = 4, -- Tipo 4: Habilitar
     @CodUsuario = 2, -- Código del usuario a habilitar
     @Usuario = 1, -- Código del usuario que ejecuta la acción
     @Mensaje = @Mensaje OUTPUT, @Respuesta = @Respuesta OUTPUT;
SELECT @Mensaje AS Mensaje, @Respuesta AS Respuesta;

-- TIPO 5: DESHABILITAR USUARIO
DECLARE @Mensaje NVARCHAR(500), @Respuesta INT;
EXEC sp_usuario @TipoOperacion = 5, -- Tipo 5: Inhabilitar
     @CodUsuario = 2, -- Código del usuario a inhabilitar
     @Usuario = 1, -- Código del usuario que ejecuta la acción
     @Mensaje = @Mensaje OUTPUT, @Respuesta = @Respuesta OUTPUT;
SELECT @Mensaje AS Mensaje, @Respuesta AS Respuesta;

-- TIPO 6: FILTRAR POR TERMINO
DECLARE @Mensaje NVARCHAR(500), @Respuesta TINYINT;
EXEC sp_usuario @TipoOperacion = 6, @TerminoBusqueda = '70555743', @Mensaje = @Mensaje OUTPUT,
     @Respuesta = @Respuesta OUTPUT;
SELECT @Respuesta AS Respuesta, @Mensaje AS Mensaje;

-- TIPO 7: CAMBIAR CONTRASEÑA
DECLARE @Mensaje NVARCHAR(500), @Respuesta TINYINT;
EXEC sp_usuario @TipoOperacion = 7, @CodUsuario = 2, @Password = N'12345', @PasswordNuevo = N'123456',
     @PasswordConfirm = N'123456', @Mensaje = @Mensaje OUTPUT, @Respuesta = @Respuesta OUTPUT;
SELECT @Respuesta AS Respuesta, @Mensaje AS Mensaje;

-- TIPO 8: RESTABLECER CONTRASEÑA
DECLARE @Mensaje NVARCHAR(500), @Respuesta TINYINT;
EXEC sp_usuario @TipoOperacion = 8, @CodUsuario = 2, @PasswordNuevo = N'12345', @PasswordConfirm = N'12345',
     @Respuesta = @Respuesta OUTPUT, @Mensaje = @Mensaje OUTPUT;
SELECT @Respuesta AS Respuesta, @Mensaje AS Mensaje;
