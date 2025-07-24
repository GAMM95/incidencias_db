DECLARE @Respuesta TINYINT, @Mensaje NVARCHAR(500);
EXEC sp_login
    @Username = 'jhonathan.diaz',
    @Password = '123456',
    @Digitos2 = '43',
    @Respuesta = @Respuesta OUTPUT,
    @Mensaje = @Mensaje OUTPUT;
SELECT @Respuesta AS Resultado, @Mensaje AS Mensaje;

DECLARE @Respuesta TINYINT, @Mensaje NVARCHAR(500);
EXEC sp_login
    @Username = 'admin',
    @Password = 'admin123',
    @Digitos2 = null,
    @Respuesta = @Respuesta OUTPUT,
    @Mensaje = @Mensaje OUTPUT;
SELECT @Respuesta AS Resultado, @Mensaje AS Mensaje;