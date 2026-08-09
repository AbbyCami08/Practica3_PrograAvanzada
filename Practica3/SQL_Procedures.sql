USE [master]
GO

CREATE DATABASE [PracticaS13]
GO

USE [PracticaS13]
GO

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
GO

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
GO

SET IDENTITY_INSERT [dbo].[Principal] ON 
GO
INSERT [dbo].[Principal] ([Id_Compra], [Precio], [Saldo], [Descripcion], [Estado]) VALUES (1, CAST(50000.00000 AS Decimal(18, 5)), CAST(50000.00000 AS Decimal(18, 5)), N'Producto 1', N'Pendiente')
GO
INSERT [dbo].[Principal] ([Id_Compra], [Precio], [Saldo], [Descripcion], [Estado]) VALUES (2, CAST(13500.00000 AS Decimal(18, 5)), CAST(13500.00000 AS Decimal(18, 5)), N'Producto 2', N'Pendiente')
GO
INSERT [dbo].[Principal] ([Id_Compra], [Precio], [Saldo], [Descripcion], [Estado]) VALUES (3, CAST(83600.00000 AS Decimal(18, 5)), CAST(83600.00000 AS Decimal(18, 5)), N'Producto 3', N'Pendiente')
GO
INSERT [dbo].[Principal] ([Id_Compra], [Precio], [Saldo], [Descripcion], [Estado]) VALUES (4, CAST(1220.00000 AS Decimal(18, 5)), CAST(1220.00000 AS Decimal(18, 5)), N'Producto 4', N'Pendiente')
GO
INSERT [dbo].[Principal] ([Id_Compra], [Precio], [Saldo], [Descripcion], [Estado]) VALUES (5, CAST(480.00000 AS Decimal(18, 5)), CAST(480.00000 AS Decimal(18, 5)), N'Producto 5', N'Pendiente')
GO
SET IDENTITY_INSERT [dbo].[Principal] OFF
GO

ALTER TABLE [dbo].[Abonos]  WITH CHECK ADD  CONSTRAINT [FK_Abonos_Principal] FOREIGN KEY([Id_Compra])
REFERENCES [dbo].[Principal] ([Id_Compra])
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

