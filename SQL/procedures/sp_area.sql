CREATE OR ALTER PROCEDURE sp_area
    -- Tipo de operacion
    @TipoOperacion TINYINT,
    -- Parámetros de entrada
    @CodArea SMALLINT = NULL,
    @Nombre NVARCHAR(50) = NULL,
    @Descripcion NVARCHAR(200) = NULL,
    -- Usuario que ejecuta la acción
    @Usuario SMALLINT = NULL,
    -- Parámetros de salida
    @Mensaje NVARCHAR(500) = NULL OUTPUT,
    @Respuesta TINYINT = NULL OUTPUT AS
BEGIN


end