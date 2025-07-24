/*
--------------------------------------------------------------------------------
 Script        : fn_hash_password.sql
 Descripción   : Función escalar que genera el hash seguro de una contraseña
                 usando el algoritmo SHA1 combinando la contraseña con un valor
                 aleatorio (salt) para mayor seguridad.
 Tipo de Objeto: Función Escalar (Scalar Function)

 Empresa       : Municipalidad Distrital de La Esperanza
 Área          : Subgerencia de Informática y Sistemas
 Autor         : Jhonatan Mantilla Miñano
 Fecha         : 2025-07-22
 Base de Datos : [Nombre de la Base de Datos]

 Parámetros:
    @password  : NVARCHAR(100) - Contraseña en texto plano a ser hasheada.
    @salt      : UNIQUEIDENTIFIER - Valor aleatorio único que se combina con
                  la contraseña para prevenir ataques por diccionario.

 Retorna:
    VARBINARY(20) - Hash resultante de aplicar SHA1 a la combinación
                    de contraseña y salt.

 Observaciones:
    - Esta función debe usarse junto a un procedimiento de generación
      y almacenamiento de salt por cada usuario.
    - SHA1 está deprecado para nuevas implementaciones en favor de SHA2.
      Se recomienda migrar a HASHBYTES('SHA2_256', ...) si es posible.

--------------------------------------------------------------------------------
*/

CREATE OR ALTER FUNCTION fn_hash_password(
    @password NVARCHAR(100),
    @salt UNIQUEIDENTIFIER
)
RETURNS VARBINARY(20)
AS
BEGIN
    RETURN HASHBYTES(
        'SHA1',
        CONVERT(VARBINARY(100), @password) + CAST(@salt AS VARBINARY(16))
    );
END;
GO
