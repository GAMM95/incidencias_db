CREATE OR ALTER PROCEDURE sp_login
    @Username NVARCHAR(50),
    @Password NVARCHAR(100),
    @Digitos2 NCHAR(2),
    @Mensaje NVARCHAR(500) = NULL OUTPUT,
    @Respuesta TINYINT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Variables
    DECLARE @codUsuario INT,
            @EST_codigo SMALLINT,
            @stored_password VARBINARY(20),
            @salt UNIQUEIDENTIFIER,
            @PER_dni CHAR(8),
            @Nombre NVARCHAR(100),
            @ApellidoPaterno NVARCHAR(100);

    -- Inicializar salida
    SET @Respuesta = 0;
    SET @Mensaje = '';

    -- Buscar usuario y asignar valores
    SELECT TOP 1
        @codUsuario = u.USU_codigo,
        @EST_codigo = u.EST_codigo,
        @stored_password = u.USU_password,
        @salt = u.USU_salt,
        @PER_dni = ISNULL(p.PER_dni, ''),
        @Nombre = ISNULL(p.PER_nombres, ''),
        @ApellidoPaterno = ISNULL(p.PER_apellidoPaterno, '')
    FROM USUARIO u
    LEFT JOIN PERSONA p ON p.PER_codigo = u.PER_codigo
    WHERE u.USU_nombre = @Username;

    -- Validación de existencia
    IF @codUsuario IS NULL
    BEGIN
        SET @Mensaje = N'Usuario no encontrado.';
        RETURN;
    END

    -- Validar estado activo
    IF @EST_codigo <> 1
    BEGIN
        SET @Mensaje = N'Usuario inactivo. Contacte al administrador.';
        RETURN;
    END

    -- Validar contraseña
    DECLARE @hashed_password VARBINARY(20) = dbo.fn_hash_password(@Password, @salt);

    IF @hashed_password <> @stored_password
    BEGIN
        SET @Mensaje = N'Contraseña incorrecta.';
        RETURN;
    END

    -- Validar últimos dígitos del DNI
    IF LOWER(@Username) <> 'admin' AND RIGHT(@PER_dni, 2) <> @Digitos2
    BEGIN
        SET @Mensaje = N'Los dos últimos dígitos del DNI no coinciden.';
        RETURN;
    END

    -- Auditoría
    EXEC sp_auditoria 6, N'Usuario', NULL, @Username, NULL, NULL, @codUsuario;

    -- Devolver datos del usuario
    SELECT
        u.USU_codigo,
        u.USU_nombre,
        ISNULL(p.PER_nombres, 'Nombres') AS nombre,
        ISNULL(p.PER_apellidoPaterno, 'Apellido') AS apellidoPaterno,
        r.ROL_codigo,
        r.ROL_nombre,
        a.ARE_codigo,
        a.ARE_nombre,
        u.EST_codigo
    FROM USUARIO u
    LEFT JOIN PERSONA p ON p.PER_codigo = u.PER_codigo
    INNER JOIN ROL r ON r.ROL_codigo = u.ROL_codigo
    INNER JOIN AREA a ON a.ARE_codigo = u.ARE_codigo
    WHERE u.USU_codigo = @codUsuario;

    -- Mensaje de salida
    SET @Mensaje = N'Bienvenido ' + LTRIM(RTRIM(@Nombre + ' ' + @ApellidoPaterno));
    SET @Respuesta = 1;
END;
GO


