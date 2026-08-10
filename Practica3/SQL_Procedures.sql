USE [master]
GO


IF DB_ID('PracticaS13') IS NULL
BEGIN
    CREATE DATABASE [PracticaS13];
END
GO

USE [PracticaS13]
GO


IF OBJECT_ID('dbo.Abonos', 'U') IS NULL
BEGIN
CREATE TABLE [dbo].[Abonos](
	[Id_Compra] [bigint] NOT NULL,
	[Id_Abono] [bigint] IDENTITY(1,1) NOT NULL,
	[Monto] [decimal](18, 2) NOT NULL,
	[Fecha] [datetime] NOT NULL,
 CONSTRAINT [PK_Abonos] PRIMARY KEY CLUSTERED 
(
	[Id_Abono] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO


IF OBJECT_ID('dbo.Principal', 'U') IS NULL
BEGIN
CREATE TABLE [dbo].[Principal](
	[Id_Compra] [bigint] IDENTITY(1,1) NOT NULL,
	[Precio] [decimal](18, 5) NOT NULL,
	[Saldo] [decimal](18, 5) NOT NULL,
	[Descripcion] [varchar](500) NOT NULL,
	[Estado] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Principal] PRIMARY KEY CLUSTERED 
(
	[Id_Compra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO


IF NOT EXISTS (SELECT 1 FROM [dbo].[Principal])
BEGIN
SET IDENTITY_INSERT [dbo].[Principal] ON
INSERT [dbo].[Principal] ([Id_Compra], [Precio], [Saldo], [Descripcion], [Estado]) VALUES (1, CAST(50000.00000 AS Decimal(18, 5)), CAST(50000.00000 AS Decimal(18, 5)), N'Producto 1', N'Pendiente')
INSERT [dbo].[Principal] ([Id_Compra], [Precio], [Saldo], [Descripcion], [Estado]) VALUES (2, CAST(13500.00000 AS Decimal(18, 5)), CAST(13500.00000 AS Decimal(18, 5)), N'Producto 2', N'Pendiente')
INSERT [dbo].[Principal] ([Id_Compra], [Precio], [Saldo], [Descripcion], [Estado]) VALUES (3, CAST(83600.00000 AS Decimal(18, 5)), CAST(83600.00000 AS Decimal(18, 5)), N'Producto 3', N'Pendiente')
INSERT [dbo].[Principal] ([Id_Compra], [Precio], [Saldo], [Descripcion], [Estado]) VALUES (4, CAST(1220.00000 AS Decimal(18, 5)), CAST(1220.00000 AS Decimal(18, 5)), N'Producto 4', N'Pendiente')
INSERT [dbo].[Principal] ([Id_Compra], [Precio], [Saldo], [Descripcion], [Estado]) VALUES (5, CAST(480.00000 AS Decimal(18, 5)), CAST(480.00000 AS Decimal(18, 5)), N'Producto 5', N'Pendiente')
SET IDENTITY_INSERT [dbo].[Principal] OFF
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Abonos_Principal')
BEGIN
ALTER TABLE [dbo].[Abonos]  WITH CHECK ADD  CONSTRAINT [FK_Abonos_Principal] FOREIGN KEY([Id_Compra])
REFERENCES [dbo].[Principal] ([Id_Compra])
END
GO
ALTER TABLE [dbo].[Abonos] CHECK CONSTRAINT [FK_Abonos_Principal]
GO


---------------------------------------------
--PROCEDIMIENTOS ALMACENADOS
---------------------------------------------

CREATE OR ALTER PROCEDURE dbo.SP_ConsultarProductos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        Id_Compra,
        Descripcion,
        Precio,
        Saldo,
        Estado
    FROM dbo.Principal
    ORDER BY
        CASE 
            WHEN Estado = 'Pendiente' THEN 0
            ELSE 1
        END,
        Id_Compra;
END
GO

EXEC dbo.SP_ConsultarProductos;
GO


CREATE OR ALTER PROCEDURE dbo.SP_ConsultarComprasPendientes
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        Id_Compra,
        Descripcion,
        Saldo
    FROM dbo.Principal
    WHERE Estado = 'Pendiente'
    ORDER BY Id_Compra;
END
GO


CREATE OR ALTER PROCEDURE dbo.SP_ConsultarSaldo
    @Id_Compra bigint
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        Id_Compra,
        Saldo,
        Estado
    FROM dbo.Principal
    WHERE Id_Compra = @Id_Compra;
END
GO


CREATE OR ALTER PROCEDURE dbo.SP_RegistrarAbono
    @Id_Compra bigint,
    @Monto decimal(18,2)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Resultado int = 0;
    DECLARE @Mensaje varchar(200) = '';
    DECLARE @SaldoNuevo decimal(18,5) = NULL;
    DECLARE @SaldoActual decimal(18,5);
    DECLARE @Estado varchar(100);

    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT
            @SaldoActual = Saldo,
            @Estado = Estado
        FROM dbo.Principal WITH (UPDLOCK)
        WHERE Id_Compra = @Id_Compra;

        IF @SaldoActual IS NULL
        BEGIN
            SET @Resultado = -1;
            SET @Mensaje = 'La compra seleccionada no existe.';
        END
        ELSE IF @Estado <> 'Pendiente'
        BEGIN
            SET @Resultado = -2;
            SET @Mensaje = 'La compra seleccionada ya esta cancelada.';
        END
        ELSE IF @Monto IS NULL OR @Monto <= 0
        BEGIN
            SET @Resultado = -3;
            SET @Mensaje = 'El monto del abono debe ser mayor a cero.';
        END
        ELSE IF @Monto > @SaldoActual
        BEGIN
            SET @Resultado = -4;
            SET @Mensaje = 'El monto del abono no puede ser mayor al saldo anterior.';
        END
        ELSE
        BEGIN
            INSERT INTO dbo.Abonos (Id_Compra, Monto, Fecha)
            VALUES (@Id_Compra, @Monto, GETDATE());

            SET @SaldoNuevo = @SaldoActual - @Monto;

            UPDATE dbo.Principal
            SET Saldo = @SaldoNuevo,
                Estado = CASE WHEN @SaldoNuevo = 0 THEN 'Cancelado' ELSE 'Pendiente' END
            WHERE Id_Compra = @Id_Compra;

            SET @Resultado = 1;
            SET @Mensaje = 'Abono registrado correctamente.';
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @Resultado = -99;
        SET @Mensaje = 'Ocurrio un error al registrar el abono.';
        SET @SaldoNuevo = NULL;
    END CATCH

    SELECT
        @Resultado AS Resultado,
        @Mensaje AS Mensaje,
        @SaldoNuevo AS SaldoNuevo;
END
GO


SELECT name AS ProcedimientoCreado
FROM sys.procedures
ORDER BY name;
GO

