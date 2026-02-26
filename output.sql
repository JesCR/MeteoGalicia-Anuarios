USE [MeteoDatos]
GO
/****** Object:  Table [dbo].[AuxConcellos]    Script Date: 25/02/2026 12:13:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuxConcellos](
	[idConcello] [int] NOT NULL,
	[CDCOM] [int] NOT NULL,
	[NOME] [nvarchar](255) NOT NULL,
	[lnPROV] [int] NOT NULL,
	[CDORD] [int] NOT NULL,
	[SUP] [float] NULL,
	[NOME_MAPA] [nvarchar](255) NULL,
	[geom] [geometry] NULL,
	[NOME_WEB] [nvarchar](255) NULL,
	[Nome_panel] [nvarchar](255) NULL,
	[geomC] [geometry] NULL,
	[Activo] [bit] NULL,
 CONSTRAINT [PK_AuxConcellos] PRIMARY KEY CLUSTERED 
(
	[idConcello] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuxParroquias]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuxParroquias](
	[idParr] [int] NOT NULL,
	[lnProv] [int] NOT NULL,
	[lnCom] [int] NULL,
	[lnConc] [int] NULL,
	[Nome] [varchar](max) NULL,
	[Superficie] [float] NULL,
	[geom] [geometry] NULL,
	[geomC] [geometry] NULL,
 CONSTRAINT [PK_AuxParroquias] PRIMARY KEY CLUSTERED 
(
	[idParr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuxProvincias]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuxProvincias](
	[IdPROV] [int] NOT NULL,
	[NOME] [nvarchar](255) NOT NULL,
	[SUP] [real] NULL,
	[ID1] [bigint] NULL,
	[value] [int] NULL,
	[geom] [geometry] NULL,
	[Abreviatura] [char](4) NULL,
 CONSTRAINT [PK_AuxProvincias] PRIMARY KEY CLUSTERED 
(
	[IdPROV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConcelloEstacion]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConcelloEstacion](
	[idConcEst] [int] NOT NULL,
	[lnConcello] [int] NOT NULL,
	[lnEstacion] [int] NOT NULL,
	[Orden] [smallint] NULL,
 CONSTRAINT [PK_ConcelloEstacion] PRIMARY KEY CLUSTERED 
(
	[idConcEst] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CruceEstacionesImagen]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CruceEstacionesImagen](
	[id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[lnEstacion] [int] NOT NULL,
	[lnImagen] [int] NOT NULL,
 CONSTRAINT [PK_new_CruceEstacionesTipoImagen] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CruceEstacionesListaEstacionesClientes]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CruceEstacionesListaEstacionesClientes](
	[lnEstacion] [int] NOT NULL,
	[lnCliente] [int] NOT NULL,
 CONSTRAINT [PK_new_CruceEstacionesClientes] PRIMARY KEY CLUSTERED 
(
	[lnEstacion] ASC,
	[lnCliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CruceEstacionesListaEstacionesCoordenadas]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CruceEstacionesListaEstacionesCoordenadas](
	[id] [int] NOT NULL,
	[lnEstacion] [int] NOT NULL,
	[lnTipoCoordenadas] [int] NOT NULL,
	[geom] [geometry] NULL,
	[FechaInicio] [smalldatetime] NULL,
	[FechaFin] [smalldatetime] NULL,
 CONSTRAINT [PK_CruceEstacionesListaEstacionesCoordenadas] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CruceEstacionesListaEstacionesFechasUltimosDatos]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CruceEstacionesListaEstacionesFechasUltimosDatos](
	[lnEstacion] [int] NOT NULL,
	[lnTipoFechaUltimoDato] [int] NOT NULL,
	[Fecha] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_new _CruceListaEstacionesFechasUltimosDatos] PRIMARY KEY CLUSTERED 
(
	[lnEstacion] ASC,
	[lnTipoFechaUltimoDato] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CruceEstacionesTipoUbicacion]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CruceEstacionesTipoUbicacion](
	[lnEstacion] [int] NOT NULL,
	[lnTipoUbicacion] [int] NOT NULL,
 CONSTRAINT [PK_new_CruceEstacionesListaUbicaciones] PRIMARY KEY CLUSTERED 
(
	[lnEstacion] ASC,
	[lnTipoUbicacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DatosDiarios]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DatosDiarios](
	[FechaHora] [smalldatetime] NOT NULL,
	[lnMedida] [int] NOT NULL,
	[Valor] [real] NOT NULL,
	[lnCodigoValidacion] [tinyint] NOT NULL,
	[lnNivelValidacion] [int] NOT NULL,
	[Visual] [bit] NOT NULL,
 CONSTRAINT [PK_DatosDiarios] PRIMARY KEY CLUSTERED 
(
	[FechaHora] ASC,
	[lnMedida] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DatosFechasCalculadas]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DatosFechasCalculadas](
	[FechaHora] [smalldatetime] NOT NULL,
	[lnMedidaOrigen] [int] NOT NULL,
	[lnFuncionDestino] [smallint] NOT NULL,
	[lnTipoIntervaloDestino] [smallint] NOT NULL,
	[Valor] [smalldatetime] NOT NULL,
	[lnCodigoValidacion] [tinyint] NOT NULL,
	[lnMedidaDestino] [int] NULL,
 CONSTRAINT [PK_new_DatosFechasCalculadas] PRIMARY KEY CLUSTERED 
(
	[FechaHora] ASC,
	[lnMedidaOrigen] ASC,
	[lnFuncionDestino] ASC,
	[lnTipoIntervaloDestino] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DatosHorarios]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DatosHorarios](
	[FechaHora] [smalldatetime] NOT NULL,
	[lnMedida] [int] NOT NULL,
	[Valor] [real] NOT NULL,
	[lnCodigoValidacion] [tinyint] NOT NULL,
	[lnNivelValidacion] [int] NOT NULL,
	[Visual] [bit] NOT NULL,
 CONSTRAINT [PK_DatosHorarios_new] PRIMARY KEY CLUSTERED 
(
	[FechaHora] ASC,
	[lnMedida] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DatosMensuales]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DatosMensuales](
	[FechaHora] [smalldatetime] NOT NULL,
	[lnMedida] [int] NOT NULL,
	[Valor] [real] NOT NULL,
	[lnCodigoValidacion] [tinyint] NOT NULL,
	[lnNivelValidacion] [int] NOT NULL,
	[Visual] [bit] NOT NULL,
 CONSTRAINT [PK_DatosMensuales] PRIMARY KEY CLUSTERED 
(
	[FechaHora] ASC,
	[lnMedida] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Iconos]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Iconos](
	[idIcono] [int] NOT NULL,
	[NomeIcono] [varchar](50) NULL,
	[Clave] [nchar](5) NULL,
	[Descricion] [nchar](18) NULL,
	[Comentario_es] [varchar](max) NULL,
	[Comentario_gl] [varchar](max) NULL,
 CONSTRAINT [PK_Iconos] PRIMARY KEY CLUSTERED 
(
	[idIcono] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Imagenes]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Imagenes](
	[idImagen] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[lnTipoImagen] [int] NOT NULL,
	[Imagen] [image] NOT NULL,
	[Link] [varchar](150) NULL,
	[DescripcionGl] [varchar](150) NULL,
	[DescripcionEs] [varchar](150) NULL,
 CONSTRAINT [PK_Imagenes] PRIMARY KEY CLUSTERED 
(
	[idImagen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ListaDatosCodigoValidacion]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ListaDatosCodigoValidacion](
	[idCodigoValidacion] [tinyint] NOT NULL,
	[DescripcionGl] [varchar](150) NOT NULL,
	[DescripcionEs] [varchar](150) NOT NULL,
 CONSTRAINT [PK_new_ListaDatosCodigoValidacion] PRIMARY KEY CLUSTERED 
(
	[idCodigoValidacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ListaDatosNivelValidacion]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ListaDatosNivelValidacion](
	[idNivelValidacion] [int] NOT NULL,
	[lnTipoIntervalo] [smallint] NOT NULL,
	[DescripcionGl] [varchar](150) NOT NULL,
	[DescripcionEs] [varchar](150) NOT NULL,
 CONSTRAINT [PK_new_ListaDatosNivelValidacion] PRIMARY KEY CLUSTERED 
(
	[idNivelValidacion] ASC,
	[lnTipoIntervalo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ListaEstacionesClientes]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ListaEstacionesClientes](
	[idCliente] [int] NOT NULL,
	[Cliente] [varchar](50) NOT NULL,
	[DescripcionGl] [varchar](150) NULL,
	[DescripcionEs] [varchar](150) NULL,
	[CodCliente] [varchar](50) NULL,
	[DataAlta] [smalldatetime] NULL,
	[DataBaixa] [smalldatetime] NULL,
	[Mail] [nvarchar](max) NULL,
	[PersonaContacto] [nvarchar](max) NULL,
	[Activo] [tinyint] NULL,
 CONSTRAINT [PK_new_ListaClientes] PRIMARY KEY CLUSTERED 
(
	[idCliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ListaEstacionesCoordenadas]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ListaEstacionesCoordenadas](
	[idTipoCoordenadas] [int] NOT NULL,
	[TipoCoordenadas] [varchar](150) NOT NULL,
	[DescripcionGl] [varchar](150) NULL,
	[DescripcionEs] [varchar](150) NULL,
 CONSTRAINT [PK_new_ListaEstacionesCoordenadas] PRIMARY KEY CLUSTERED 
(
	[idTipoCoordenadas] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ListaEstacionesFechasUltimosDatos]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ListaEstacionesFechasUltimosDatos](
	[idTipoFechaUltimoDato] [int] NOT NULL,
	[TipoFechaUltimoDato] [varchar](50) NOT NULL,
	[DescripcionGl] [varchar](150) NULL,
	[DescripcionEs] [varchar](150) NULL,
 CONSTRAINT [PK_new_ListaEstacionesFechasUltimosDatos] PRIMARY KEY CLUSTERED 
(
	[idTipoFechaUltimoDato] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ListaEstacionesPropietarios]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ListaEstacionesPropietarios](
	[idPropietario] [int] NOT NULL,
	[Propietario] [varchar](50) NOT NULL,
	[DescripcionGl] [varchar](150) NULL,
	[DescripcionEs] [varchar](150) NULL,
 CONSTRAINT [PK_new_ListaPropietarios] PRIMARY KEY CLUSTERED 
(
	[idPropietario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ListaEstacionesSubredes]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ListaEstacionesSubredes](
	[idSubred] [int] NOT NULL,
	[Subred] [varchar](150) NOT NULL,
	[NombreCorto] [varchar](50) NULL,
	[DescripcionGl] [varchar](150) NULL,
	[DescripcionES] [varchar](150) NULL,
 CONSTRAINT [PK_new_ListaSubredes2] PRIMARY KEY CLUSTERED 
(
	[idSubred] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ListaMedidasAlturas]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ListaMedidasAlturas](
	[idAltura] [int] NOT NULL,
	[lnTipoUnidad] [smallint] NOT NULL,
	[Altura] [real] NOT NULL,
	[DescripcionGl] [varchar](150) NULL,
	[DescripcionEs] [varchar](150) NULL,
 CONSTRAINT [PK_new_ListaMedidasAlturas] PRIMARY KEY CLUSTERED 
(
	[idAltura] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ListaMedidasFunciones]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ListaMedidasFunciones](
	[idFuncion] [smallint] NOT NULL,
	[Funcion] [varchar](15) NOT NULL,
	[DescripcionGl] [varchar](150) NULL,
	[DescripcionEs] [varchar](150) NULL,
 CONSTRAINT [PK_new_ListaMedidasFunciones] PRIMARY KEY CLUSTERED 
(
	[idFuncion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ListaMedidasTipo]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ListaMedidasTipo](
	[idTipo] [int] NOT NULL,
	[lnParametro] [int] NOT NULL,
	[lnFuncion] [smallint] NOT NULL,
	[lnAltura] [int] NOT NULL,
	[lnTipointervalo] [smallint] NOT NULL,
	[ValorMax] [real] NULL,
	[ValorMin] [real] NULL,
	[ValorUmbral] [real] NULL,
	[Derivada] [bit] NULL,
	[Comentario] [varchar](150) NULL,
	[ComentarioWebEs] [varchar](150) NULL,
	[ComentarioWebGl] [varchar](150) NULL,
	[TituloWebEs] [varchar](150) NULL,
	[TituloWebGl] [varchar](150) NULL,
 CONSTRAINT [PK_new_ListaMedidasTipo] PRIMARY KEY CLUSTERED 
(
	[idTipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ListaMedidasUsos]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ListaMedidasUsos](
	[idUso] [smallint] NOT NULL,
	[Uso] [varchar](50) NOT NULL,
	[DescripcionGl] [varchar](150) NULL,
	[DescripcionEs] [varchar](150) NULL,
 CONSTRAINT [PK_new_ListaMedidasUsos] PRIMARY KEY CLUSTERED 
(
	[idUso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ListaMedidasVisibilidad]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ListaMedidasVisibilidad](
	[idVisibilidad] [int] NOT NULL,
	[Visibilidad] [varchar](50) NOT NULL,
	[Activa] [bit] NOT NULL,
	[DescripcionGl] [varchar](150) NULL,
	[DescripcionEs] [varchar](150) NULL,
 CONSTRAINT [PK_new_ListaMedidasVisibilidad] PRIMARY KEY CLUSTERED 
(
	[idVisibilidad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ListaParametrosGranParametro]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ListaParametrosGranParametro](
	[idGranParametro] [int] NOT NULL,
	[GranParametro] [varchar](50) NOT NULL,
	[DescripcionGl] [varchar](150) NOT NULL,
	[DescripcionEs] [varchar](150) NOT NULL,
	[Orden] [int] NULL,
 CONSTRAINT [PK_new_tCfgGranParametro] PRIMARY KEY CLUSTERED 
(
	[idGranParametro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SysEstaciones]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SysEstaciones](
	[idEstacion] [int] NOT NULL,
	[lnSubred] [int] NOT NULL,
	[lnPropietario] [int] NOT NULL,
	[lnConcello] [int] NULL,
	[EnServicio] [bit] NOT NULL,
	[Estacion] [varchar](150) NOT NULL,
	[NombreCorto] [varchar](50) NOT NULL,
	[NotaHTMLEs] [varchar](5000) NULL,
	[NotaHTMLGl] [varchar](5000) NULL,
 CONSTRAINT [PK_Estaciones] PRIMARY KEY CLUSTERED 
(
	[idEstacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SysMedidas]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SysMedidas](
	[idMedida] [int] NOT NULL,
	[lnSensor] [int] NOT NULL,
	[lnTipo] [int] NOT NULL,
	[lnUso] [smallint] NOT NULL,
	[Activa] [bit] NOT NULL,
	[Medida] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SysMedidas] PRIMARY KEY CLUSTERED 
(
	[idMedida] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SysParametros]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SysParametros](
	[idParametro] [int] NOT NULL,
	[lnGranParametro] [int] NOT NULL,
	[lnTipounidad] [smallint] NOT NULL,
	[Parametro] [varchar](50) NOT NULL,
	[DescripcionGl] [varchar](200) NOT NULL,
	[DescripcionEs] [varchar](200) NULL,
	[Precision] [tinyint] NOT NULL,
	[InfoGa] [varchar](max) NULL,
	[InfoEs] [varchar](max) NULL,
 CONSTRAINT [PK_Parametros] PRIMARY KEY CLUSTERED 
(
	[idParametro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SysSensores]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SysSensores](
	[idSensor] [int] NOT NULL,
	[lnEstacion] [int] NOT NULL,
	[lnTipoSensor] [int] NOT NULL,
	[Activo] [bit] NOT NULL,
	[Publico] [bit] NOT NULL,
	[Sensor] [varchar](50) NOT NULL,
	[AlturaInstalacion] [decimal](6, 3) NOT NULL,
 CONSTRAINT [PK_Sensores] PRIMARY KEY CLUSTERED 
(
	[idSensor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoAlimentacion]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoAlimentacion](
	[idTipoAlimentacion] [int] NOT NULL,
	[TipoAlimentacion] [varchar](50) NOT NULL,
	[DescripcionGl] [varchar](50) NULL,
	[DescripcionEs] [varchar](50) NULL,
 CONSTRAINT [PK_new_TipoAlimentacion] PRIMARY KEY CLUSTERED 
(
	[idTipoAlimentacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoComunicacion]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoComunicacion](
	[idTipoComunicacion] [int] NOT NULL,
	[TipoComunicacion] [varchar](50) NOT NULL,
	[DescripcionGl] [varchar](150) NULL,
	[DescripcionEs] [varchar](150) NULL,
 CONSTRAINT [PK_new_ListaComunicaciones] PRIMARY KEY CLUSTERED 
(
	[idTipoComunicacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoDatalogger]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoDatalogger](
	[idTipoDatalogger] [int] NOT NULL,
	[Fabricante] [varchar](50) NULL,
	[Modelo] [varchar](50) NULL,
	[DescripcionGl] [varchar](150) NULL,
	[DescripcionEs] [varchar](150) NULL,
 CONSTRAINT [PK_new_TipoDatalogger] PRIMARY KEY CLUSTERED 
(
	[idTipoDatalogger] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoImagen]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoImagen](
	[idTipoImagen] [int] NOT NULL,
	[TipoImagen] [varchar](150) NOT NULL,
	[DescripcionGl] [varchar](150) NULL,
	[DescripcionEs] [varchar](150) NULL,
 CONSTRAINT [PK_new_TipoImagen] PRIMARY KEY CLUSTERED 
(
	[idTipoImagen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoIncidencia]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoIncidencia](
	[idTipoIncidencia] [int] NOT NULL,
	[TipoIncidencia] [varchar](100) NOT NULL,
	[DescipcionGl] [varchar](50) NULL,
	[DescripcionEs] [varchar](50) NULL,
 CONSTRAINT [PK_new_TipoIncidencia] PRIMARY KEY CLUSTERED 
(
	[idTipoIncidencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoIntervalo]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoIntervalo](
	[idTipoIntervalo] [smallint] NOT NULL,
	[TipoIntervalo] [varchar](50) NOT NULL,
	[DescripcionGl] [varchar](150) NULL,
	[DescripcionEs] [varchar](150) NULL,
 CONSTRAINT [PK_new_ListaMedidasIntervalos] PRIMARY KEY CLUSTERED 
(
	[idTipoIntervalo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMeteoVisor]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMeteoVisor](
	[idTipoMeteoVisor] [int] NOT NULL,
	[Descripcion] [varchar](max) NULL,
 CONSTRAINT [PK_TipoMeteoVisor] PRIMARY KEY CLUSTERED 
(
	[idTipoMeteoVisor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoModelo]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoModelo](
	[idTipoModelo] [smallint] NOT NULL,
	[Descripcion] [nvarchar](100) NULL,
 CONSTRAINT [PK_tCfgTipoModelo] PRIMARY KEY CLUSTERED 
(
	[idTipoModelo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoOrden]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoOrden](
	[idTipoOrden] [int] NOT NULL,
	[TipoOrden] [varchar](50) NOT NULL,
	[DescripcionGl] [varchar](150) NULL,
	[DescripcionEs] [varchar](150) NULL,
 CONSTRAINT [PK_new_ListaOrden] PRIMARY KEY CLUSTERED 
(
	[idTipoOrden] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoSensor]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoSensor](
	[idTipoSensor] [int] NOT NULL,
	[TipoSensor] [varchar](50) NOT NULL,
	[DescripcionGl] [varchar](150) NULL,
	[DescripcionEs] [varchar](150) NULL,
 CONSTRAINT [PK_new_TipoSensor] PRIMARY KEY CLUSTERED 
(
	[idTipoSensor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoTerreno]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoTerreno](
	[idTipoTerreno] [smallint] NOT NULL,
	[Valor] [decimal](8, 5) NOT NULL,
	[DescripcionEn] [varchar](150) NULL,
	[DescripcionGl] [varchar](150) NULL,
	[DescripcionEs] [varchar](150) NULL,
 CONSTRAINT [PK_new_AuxClasesTerreno] PRIMARY KEY CLUSTERED 
(
	[idTipoTerreno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoUbicaciones]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoUbicaciones](
	[idTipoUbicacion] [int] NOT NULL,
	[TipoUbicacion] [varchar](50) NOT NULL,
	[DescripcionGl] [varchar](150) NULL,
	[DescripcionEs] [varchar](150) NULL,
 CONSTRAINT [PK_new_ListaUbicaciones] PRIMARY KEY CLUSTERED 
(
	[idTipoUbicacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoUnidades]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoUnidades](
	[idTipoUnidad] [smallint] NOT NULL,
	[Unidad] [varchar](50) NOT NULL,
	[DescripcionGl] [varchar](150) NULL,
	[DescripcionEs] [varchar](150) NULL,
 CONSTRAINT [PK_new_CfgUnidades] PRIMARY KEY CLUSTERED 
(
	[idTipoUnidad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoValidacion]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoValidacion](
	[idTipoValidacion] [int] NOT NULL,
	[TipoValidacion] [varchar](50) NOT NULL,
	[DescripcionGl] [varchar](150) NULL,
	[DescripcionEs] [varchar](150) NULL,
 CONSTRAINT [PK_new_ListaValidacion] PRIMARY KEY CLUSTERED 
(
	[idTipoValidacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[VIDX_AyudaMedidas]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VIDX_AyudaMedidas]
  WITH SCHEMABINDING 
AS
SELECT     dbo.SysMedidas.idMedida, dbo.SysMedidas.Medida, dbo.SysSensores.idSensor, dbo.SysSensores.Sensor, dbo.SysEstaciones.lnSubred, 
                      dbo.SysEstaciones.lnPropietario, dbo.SysEstaciones.idEstacion, dbo.SysEstaciones.Estacion, dbo.ListaMedidasUsos.idUso, dbo.ListaMedidasUsos.Uso, 
                      dbo.SysMedidas.Activa, dbo.ListaMedidasTipo.idTipo, dbo.ListaMedidasTipo.lnTipointervalo, dbo.ListaMedidasTipo.ValorMax, dbo.ListaMedidasTipo.ValorMin, 
                      dbo.ListaMedidasTipo.ValorUmbral, dbo.ListaMedidasTipo.Derivada, dbo.ListaMedidasTipo.Comentario, dbo.SysParametros.idParametro, 
                      dbo.SysParametros.Parametro, dbo.SysParametros.Precision, dbo.ListaMedidasFunciones.idFuncion, dbo.ListaMedidasFunciones.Funcion, 
                      dbo.ListaMedidasAlturas.idAltura, dbo.ListaMedidasAlturas.Altura, dbo.TipoUnidades.Unidad, dbo.SysParametros.DescripcionGl, 
                      dbo.ListaMedidasTipo.TituloWebEs AS TituloWEs, dbo.ListaMedidasTipo.TituloWebGl AS TituloWGl, dbo.ListaMedidasTipo.ComentarioWebEs, 
                      dbo.ListaMedidasTipo.ComentarioWebGl
FROM         dbo.ListaMedidasAlturas INNER JOIN
                      dbo.ListaMedidasTipo ON dbo.ListaMedidasAlturas.idAltura = dbo.ListaMedidasTipo.lnAltura INNER JOIN
                      dbo.ListaMedidasFunciones ON dbo.ListaMedidasTipo.lnFuncion = dbo.ListaMedidasFunciones.idFuncion INNER JOIN
                      dbo.SysMedidas ON dbo.ListaMedidasTipo.idTipo = dbo.SysMedidas.lnTipo INNER JOIN
                      dbo.ListaMedidasUsos ON dbo.SysMedidas.lnUso = dbo.ListaMedidasUsos.idUso INNER JOIN
                      dbo.SysParametros ON dbo.ListaMedidasTipo.lnParametro = dbo.SysParametros.idParametro INNER JOIN
                      dbo.SysSensores ON dbo.SysMedidas.lnSensor = dbo.SysSensores.idSensor INNER JOIN
                      dbo.SysEstaciones ON dbo.SysSensores.lnEstacion = dbo.SysEstaciones.idEstacion INNER JOIN
                      dbo.TipoUnidades ON dbo.SysParametros.lnTipounidad = dbo.TipoUnidades.idTipoUnidad

GO
/****** Object:  View [dbo].[VIDX_AyudaMedidas_NOEXPAND]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIDX_AyudaMedidas_NOEXPAND]
AS
SELECT     idEstacion, Estacion, lnSubred AS idSubred, lnPropietario AS idPropietario, idSensor, Sensor, idMedida, Medida, idUso, Uso, Activa, idTipo, ValorMax, ValorMin, 
                      ValorUmbral, Derivada, Comentario, idParametro, Parametro, Precision, DescripcionGl, idFuncion, Funcion, lnTipointervalo AS idTipoIntervalo, idAltura, Altura, Unidad, 
                      TituloWEs, TituloWGl, ComentarioWebEs, ComentarioWebGl
FROM         dbo.VIDX_AyudaMedidas WITH (NOEXPAND)
GO
/****** Object:  View [dbo].[VIDX_AMC_ConNulls]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIDX_AMC_ConNulls]
AS
SELECT     idEstacion, Estacion, idSubred, idPropietario, idSensor, Sensor, idMedida, canal, Medida, idUso, Uso, Activa, idTipo, ValorMax, ValorMin, 
                      ValorUmbral, Derivada, Comentario, idParametro, Parametro, Precision, DescripcionGl, idFuncion, Funcion, idTipoIntervalo, idAltura, Altura, Unidad, 
                      TituloWEs, TituloWGl, ComentarioWebEs, ComentarioWebGl
FROM         dbo.VIDX_AyudaMedidas_NOEXPAND left outer join AuxMedidasCanales on AuxMedidasCanales.lnMedida=VIDX_AyudaMedidas_NOEXPAND.idMedida
GO
/****** Object:  View [dbo].[Vista_AuxConcellos]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE View [dbo].[Vista_AuxConcellos]
AS
--NOS PERMITEN ACCEDER A LOS CAMPOS DESDE EL VS_ESTUDIO, QUE NO DEJA METER CAMPOS GEOM EN EL DATACONTEXT
Select 
[idConcello],[CDCOM],[NOME],[lnPROV],[CDORD],[SUP],[NOME_MAPA],Convert(VARBINARY(MAX),[geom]) as geom

From AuxConcellos


GO
/****** Object:  View [dbo].[Vista_AuxProvincias]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE View [dbo].[Vista_AuxProvincias]
AS

Select 
[IdPROV],[NOME],[SUP],[ID1],[value],Convert(VARBINARY(MAX),[geom]) as geom
From AuxProvincias

GO
/****** Object:  View [dbo].[Vista_Estaciones_Provincia_Concello]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Vista_Estaciones_Provincia_Concello]
AS
SELECT     e.Estacion, e.idEstacion, e.lnSubred, e.lnPropietario, p.IdPROV AS lnProvincia, p.NOME AS Provincia, c.idConcello AS lnConcello, c.NOME AS Concello, 
                      c.NOME_MAPA AS ConcelloWeb
FROM         dbo.SysEstaciones AS e INNER JOIN
                      dbo.Vista_AuxConcellos AS c ON c.idConcello = e.lnConcello INNER JOIN
                      dbo.Vista_AuxProvincias AS p ON p.IdPROV = c.lnPROV
WHERE     (e.lnSubred IN (102, 202, 104))
--WHERE     (e.EnServicio = 1) AND (e.lnSubred IN (102, 104)) Lo ponemos para las de baja también
GO
/****** Object:  View [dbo].[Vista_CruceEstacionesListaEstacionesCoordenadas_UTM_ETRS89]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Vista_CruceEstacionesListaEstacionesCoordenadas_UTM_ETRS89]
AS
SELECT     lnEstacion, geom.STX AS UTMX, geom.STY AS UTMY, geom.Z AS Alt, geom AS geomUTM
FROM         dbo.CruceEstacionesListaEstacionesCoordenadas
WHERE     (lnTipoCoordenadas = 1) AND (FechaFin IS NULL)
GO
/****** Object:  View [dbo].[Vista_CruceEstacionesAuxConcellosCoordenadas_UTM_ETRS89]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 Create View [dbo].[Vista_CruceEstacionesAuxConcellosCoordenadas_UTM_ETRS89] as
 select idEstacion, Estacion, lnSubred, lnPropietario, idConcello, NOME_MAPA as Concello, IdPROV,
  P.Nome as Provincia, U.UTMX, U.UTMY
  from SysEstaciones S, AuxConcellos C, AuxProvincias P,Vista_CruceEstacionesListaEstacionesCoordenadas_UTM_ETRS89 U
 where S.lnConcello=C.idConcello
 and C.lnPROV=P.IdPROV and U.lnEstacion=S.idEstacion
GO
/****** Object:  View [dbo].[AuxConcellosMeteovisor]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[AuxConcellosMeteovisor] as 
SELECT [idConcello]
      ,[CDCOM]
      ,[NOME]
      ,[lnPROV]
      ,[CDORD]
      ,[SUP]
      ,[NOME_MAPA]
      ,[geom]
      ,[NOME_WEB]
      ,[Nome_panel]
       ,[Activo]
  FROM [dbo].[AuxConcellos]
  where idConcello<>36023
GO
/****** Object:  View [dbo].[Datos10minutales]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE VIEW [dbo].[Datos10minutales]
WITH SCHEMABINDING 
AS
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2000
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2001
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2002
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2003
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2004
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2005
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2006
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2007
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2008
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2009
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2010
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2011
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2012
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2013
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2014
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2015
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2016
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2017
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2018
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2019
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2020
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2021
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2022
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2023
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2024
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2025
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2026
UNION ALL
SELECT     InstanteLectura, LnMedida, Valor, LnCodigoValidacion, LnNivelValidacion, Visual
FROM         dbo.Datos10minutales2027
GO
/****** Object:  View [dbo].[VIDX_AyudaEstaciones]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[VIDX_AyudaEstaciones]
AS

select e.idEstacion, e.Estacion, e.NombreCorto, e.EnServicio, e.lnSubred, e.lnPropietario, 
p.IdPROV as lnProvincia, e.lnConcello,
cd.lnTipoDatalogger, 
cudb.Fecha as UDB,
cudp.Fecha as UDP,
e.NotaHTMLEs,
e.NotaHTMLGl,
case when cmi.lnTipoMeteoVisor=1 then 1 else -1 end as MVInterno,
case when cme.lnTipoMeteoVisor=2 then 1 else -1 end as MVExterno,
cc_utm_etrs89.geom.Z as Z,
cc_utm_etrs89.geom.STX as UTM_ETRS89_X,
cc_utm_etrs89.geom.STY as UTM_ETRS89_Y,
cc_utm_etrs89_mdt250.geom.STX as UTM_ETRS89_MDT250_X,
cc_utm_etrs89_mdt250.geom.STY as UTM_ETRS89_MDT250_Y,
cc_geog_etrs89.geom.STY as GEOG_ETRS89_LAT,
cc_geog_etrs89.geom.STX as GEOG_ETRS89_LON,
cc_geog_wgs84.geom.STY as GEOG_WGS84_LAT,
cc_geog_wgs84.geom.STX as GEOG_WGS84_LON
from SysEstaciones e
left outer join AuxConcellos c on c.idConcello=e.lnConcello
left outer join AuxProvincias p on p.IdPROV=c.lnPROV
left outer join CruceEstacionesTipoDatalogger cd on cd.lnEstacion=e.idEstacion
left outer join CruceEstacionesListaEstacionesFechasUltimosDatos cudb on (cudb.lnEstacion=e.idEstacion and cudb.lnTipoFechaUltimoDato=1)
left outer join CruceEstacionesListaEstacionesFechasUltimosDatos cudp on (cudp.lnEstacion=e.idEstacion and cudp.lnTipoFechaUltimoDato=2)
left outer join CruceEstacionesTipoMeteovisor cmi on (cmi.lnEstacion=e.idEstacion and cmi.lnTipoMeteoVisor=1)
left outer join CruceEstacionesTipoMeteovisor cme on (cme.lnEstacion=e.idEstacion and cme.lnTipoMeteoVisor=2)
left outer join CruceEstacionesListaEstacionesCoordenadas cc_utm_etrs89 on (cc_utm_etrs89.lnEstacion=e.idEstacion and cc_utm_etrs89.lnTipoCoordenadas=1)
left outer join CruceEstacionesListaEstacionesCoordenadas cc_geog_etrs89 on (cc_geog_etrs89.lnEstacion=e.idEstacion and cc_geog_etrs89.lnTipoCoordenadas=2)
left outer join CruceEstacionesListaEstacionesCoordenadas cc_geog_wgs84 on (cc_geog_wgs84.lnEstacion=e.idEstacion and cc_geog_wgs84.lnTipoCoordenadas=3)
left outer join CruceEstacionesListaEstacionesCoordenadas cc_utm_etrs89_mdt250 on (cc_utm_etrs89_mdt250.lnEstacion=e.idEstacion and cc_utm_etrs89_mdt250.lnTipoCoordenadas=4)
GO
/****** Object:  View [dbo].[VIDX_AyudaMedidas_NOEXPAND_LnGranParametro_EnServicio]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VIDX_AyudaMedidas_NOEXPAND_LnGranParametro_EnServicio]
AS
SELECT     idEstacion, Estacion, EnServicio,lnSubred AS idSubred, lnPropietario AS idPropietario, idSensor, Sensor, idMedida, Medida, idUso, Uso, Activa, idTipo, ValorMax, ValorMin, 
                      ValorUmbral, Derivada, Comentario, lnGranParametro,idParametro, Parametro, Precision, DescripcionGl, idFuncion, Funcion, lnTipointervalo AS idTipoIntervalo, idAltura, Altura, Unidad, 
                      TituloWEs, TituloWGl, ComentarioWebEs, ComentarioWebGl
FROM         dbo.VIDX_AyudaMedidas_LnGranParametro_EnServicio WITH (NOEXPAND)

GO
/****** Object:  View [dbo].[VIDX_ClavesMedidas_NOEXPAND]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIDX_ClavesMedidas_NOEXPAND]
AS
SELECT     lnEstacion AS idEstacion, idSensor, idMedida, lnParametro AS idParametro, lnFuncion AS idFuncion, lnAltura AS idAltura, lnTipointervalo AS idTipoIntervalo, 
                      lnUso
FROM         dbo.VIDX_ClavesMedidas WITH (NOEXPAND)
GO
/****** Object:  View [dbo].[Vista_AyudaMedidas]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Vista_AyudaMedidas]
AS
SELECT     dbo.SysMedidas.idMedida, dbo.SysMedidas.Medida, dbo.SysSensores.idSensor, dbo.SysSensores.Sensor, dbo.SysEstaciones.lnSubred, 
                      dbo.SysEstaciones.lnPropietario, dbo.SysEstaciones.idEstacion, dbo.SysEstaciones.Estacion, dbo.ListaMedidasUsos.idUso, dbo.ListaMedidasUsos.Uso, 
                      dbo.SysMedidas.Activa, dbo.ListaMedidasTipo.idTipo, dbo.ListaMedidasTipo.lnTipointervalo, dbo.ListaMedidasTipo.ValorMax, dbo.ListaMedidasTipo.ValorMin, 
                      dbo.ListaMedidasTipo.ValorUmbral, dbo.ListaMedidasTipo.Derivada, dbo.ListaMedidasTipo.Comentario, dbo.SysParametros.idParametro, 
                      dbo.SysParametros.Precision, dbo.ListaMedidasFunciones.idFuncion, dbo.ListaMedidasFunciones.Funcion, dbo.ListaMedidasAlturas.idAltura, 
                      dbo.ListaMedidasAlturas.Altura, dbo.TipoUnidades.Unidad, dbo.SysParametros.DescripcionGl
FROM         dbo.ListaMedidasAlturas INNER JOIN
                      dbo.ListaMedidasTipo ON dbo.ListaMedidasAlturas.idAltura = dbo.ListaMedidasTipo.lnAltura INNER JOIN
                      dbo.ListaMedidasFunciones ON dbo.ListaMedidasTipo.lnFuncion = dbo.ListaMedidasFunciones.idFuncion INNER JOIN
                      dbo.SysMedidas ON dbo.ListaMedidasTipo.idTipo = dbo.SysMedidas.lnTipo INNER JOIN
                      dbo.ListaMedidasUsos ON dbo.SysMedidas.lnUso = dbo.ListaMedidasUsos.idUso INNER JOIN
                      dbo.SysParametros ON dbo.ListaMedidasTipo.lnParametro = dbo.SysParametros.idParametro INNER JOIN
                      dbo.SysSensores ON dbo.SysMedidas.lnSensor = dbo.SysSensores.idSensor INNER JOIN
                      dbo.SysEstaciones ON dbo.SysSensores.lnEstacion = dbo.SysEstaciones.idEstacion INNER JOIN
                      dbo.TipoUnidades ON dbo.SysParametros.lnTipounidad = dbo.TipoUnidades.idTipoUnidad
GO
/****** Object:  View [dbo].[Vista_CruceEstacionesListaEstacionesCoordenadas_LatLonAlt]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Vista_CruceEstacionesListaEstacionesCoordenadas_LatLonAlt]
AS
SELECT     lnEstacion, geom.STY AS Lat, geom.STX AS Lon, geom.Z AS Alt
FROM         dbo.CruceEstacionesListaEstacionesCoordenadas
WHERE     (lnTipoCoordenadas = 2) AND (FechaFin IS NULL)
GO
/****** Object:  View [dbo].[Vista_CruceEstacionesListaEstacionesCoordenadas_LatLonAlt_WGS84]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Vista_CruceEstacionesListaEstacionesCoordenadas_LatLonAlt_WGS84]
AS
SELECT     c.lnEstacion, c.geom.STY AS Lat, c.geom.STX AS Lon, c.geom.Z AS Alt, c.FechaInicio, c.FechaFin, e.NotaHTMLEs, e.NotaHTMLGl
FROM         dbo.CruceEstacionesListaEstacionesCoordenadas AS c INNER JOIN
                      dbo.SysEstaciones AS e ON e.idEstacion = c.lnEstacion
WHERE     (c.lnTipoCoordenadas = 3) AND (c.FechaFin IS NULL)
GO
/****** Object:  View [dbo].[Vista_CruceEstacionesListaEstacionesCoordenadas_Orto_Ocaso_MDT200]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Vista_CruceEstacionesListaEstacionesCoordenadas_Orto_Ocaso_MDT200]
AS
SELECT     lnEstacion, geom.STX AS Orto200, geom.STY AS Ocaso200
FROM         dbo.CruceEstacionesListaEstacionesCoordenadas
WHERE     (lnTipoCoordenadas = 8) AND (FechaFin IS NULL)
GO
/****** Object:  View [dbo].[Vista_CruceEstacionesListaEstacionesCoordenadas_Orto_Ocaso_MDT250]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Vista_CruceEstacionesListaEstacionesCoordenadas_Orto_Ocaso_MDT250]
AS
SELECT     lnEstacion, geom.STX AS Orto250, geom.STY AS Ocaso250
FROM         dbo.CruceEstacionesListaEstacionesCoordenadas
WHERE     (lnTipoCoordenadas = 5) AND (FechaFin IS NULL)
GO
/****** Object:  View [dbo].[Vista_CruceEstacionesListaEstacionesCoordenadas_sinGeom]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Vista_CruceEstacionesListaEstacionesCoordenadas_sinGeom]
AS
SELECT     id,lnEstacion,lnTipoCoordenadas,FechaInicio,FechaFin
FROM         dbo.CruceEstacionesListaEstacionesCoordenadas


GO
/****** Object:  View [dbo].[Vista_CruceEstacionesListaEstacionesCoordenadas_UTM_ETRS89_MDT200]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Vista_CruceEstacionesListaEstacionesCoordenadas_UTM_ETRS89_MDT200]
AS
SELECT     lnEstacion, geom.STY AS UTMY200, geom.STX AS UTMX200, geom.Z AS ALT200, FechaInicio, FechaFin
FROM         dbo.CruceEstacionesListaEstacionesCoordenadas
WHERE     (lnTipoCoordenadas = 7) AND (FechaFin IS NULL)



GO
/****** Object:  View [dbo].[Vista_CruceEstacionesListaEstacionesCoordenadas_UTM_ETRS89_MDT250]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Vista_CruceEstacionesListaEstacionesCoordenadas_UTM_ETRS89_MDT250]
AS
SELECT     lnEstacion, geom.STY AS UTMY250, geom.STX AS UTMX250, geom.Z AS ALT250, FechaInicio, FechaFin
FROM         dbo.CruceEstacionesListaEstacionesCoordenadas
WHERE     (lnTipoCoordenadas = 4) AND (FechaFin IS NULL)
GO
/****** Object:  View [dbo].[Vista_Estaciones_Imagenes]    Script Date: 25/02/2026 12:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Ejemplos:
Imagenes del recinto de una estación: lntipoimagen=1
select e.Estacion, e.idEstacion, i.DescripcionES, t.TipoImagen, i.imagen 
from SysEstaciones e 
inner join CruceEstacionesImagen c on c.lnEstacion=e.idEstacion
inner join Imagenes i on i.idImagen=c.lnImagen
inner join TipoImagen t on t.idTipoImagen=i.lnTipoImagen
where idEstacion=10124 and lnTipoImagen=1
Imagenes de los logos asociados a una estación: lntipoimagen=3
select e.Estacion, e.idEstacion, i.DescripcionES, t.TipoImagen, i.imagen 
from SysEstaciones e 
inner join CruceEstacionesImagen c on c.lnEstacion=e.idEstacion
inner join Imagenes i on i.idImagen=c.lnImagen
inner join TipoImagen t on t.idTipoImagen=i.lnTipoImagen
where idEstacion=10124 and lnTipoImagen=3*/
CREATE VIEW [dbo].[Vista_Estaciones_Imagenes]
AS
SELECT     e.idEstacion, i.Imagen, i.lnTipoImagen, i.Link, c.id
FROM         dbo.SysEstaciones AS e INNER JOIN
                      dbo.CruceEstacionesImagen AS c ON c.lnEstacion = e.idEstacion INNER JOIN
                      dbo.Imagenes AS i ON i.idImagen = c.lnImagen
GO
ALTER TABLE [dbo].[AuxConcellos] ADD  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[DatosDiarios] ADD  CONSTRAINT [DF_DatosDiarios_new_temp_Valor]  DEFAULT ((-9999)) FOR [Valor]
GO
ALTER TABLE [dbo].[DatosDiarios] ADD  CONSTRAINT [DF_DatosDiarios_new_temp_LnCodigoValidacion]  DEFAULT ((1)) FOR [lnCodigoValidacion]
GO
ALTER TABLE [dbo].[DatosDiarios] ADD  CONSTRAINT [DF_DatosDiarios_new_temp_LnNivelValidacion]  DEFAULT ((0)) FOR [lnNivelValidacion]
GO
ALTER TABLE [dbo].[DatosHorarios] ADD  CONSTRAINT [DF_DatosHorarios_new_temp_Valor]  DEFAULT ((-9999)) FOR [Valor]
GO
ALTER TABLE [dbo].[DatosHorarios] ADD  CONSTRAINT [DF_DatosHorarios_new_temp_LnCodigoValidacion]  DEFAULT ((1)) FOR [lnCodigoValidacion]
GO
ALTER TABLE [dbo].[DatosHorarios] ADD  CONSTRAINT [DF_DatosHorarios_new_temp_LnNivelValidacion]  DEFAULT ((0)) FOR [lnNivelValidacion]
GO
ALTER TABLE [dbo].[DatosMensuales] ADD  CONSTRAINT [DF_DatosMensuales_new_temp_Valor]  DEFAULT ((-9999)) FOR [Valor]
GO
ALTER TABLE [dbo].[DatosMensuales] ADD  CONSTRAINT [DF_DatosMensuales_new_temp_LnCodigoValidacion]  DEFAULT ((1)) FOR [lnCodigoValidacion]
GO
ALTER TABLE [dbo].[DatosMensuales] ADD  CONSTRAINT [DF_DatosMensuales_new_temp_LnNivelValidacion]  DEFAULT ((0)) FOR [lnNivelValidacion]
GO
ALTER TABLE [dbo].[ListaMedidasTipo] ADD  CONSTRAINT [DF_ListaMedidasTipo_Derivada]  DEFAULT ((0)) FOR [Derivada]
GO
ALTER TABLE [dbo].[ListaMedidasVisibilidad] ADD  CONSTRAINT [DF_new_ListaMedidasVisibilidad_Activa]  DEFAULT ((1)) FOR [Activa]
GO
ALTER TABLE [dbo].[AuxConcellos]  WITH CHECK ADD  CONSTRAINT [FK_AuxConcellos_AuxProvincias] FOREIGN KEY([lnPROV])
REFERENCES [dbo].[AuxProvincias] ([IdPROV])
GO
ALTER TABLE [dbo].[AuxConcellos] CHECK CONSTRAINT [FK_AuxConcellos_AuxProvincias]
GO
ALTER TABLE [dbo].[ConcelloEstacion]  WITH CHECK ADD  CONSTRAINT [FK_ConcelloEstacion_SysEstaciones] FOREIGN KEY([lnEstacion])
REFERENCES [dbo].[SysEstaciones] ([idEstacion])
GO
ALTER TABLE [dbo].[ConcelloEstacion] CHECK CONSTRAINT [FK_ConcelloEstacion_SysEstaciones]
GO
ALTER TABLE [dbo].[CruceEstacionesImagen]  WITH CHECK ADD  CONSTRAINT [FK_CruceEstacionesImagen_Imagenes] FOREIGN KEY([lnImagen])
REFERENCES [dbo].[Imagenes] ([idImagen])
GO
ALTER TABLE [dbo].[CruceEstacionesImagen] CHECK CONSTRAINT [FK_CruceEstacionesImagen_Imagenes]
GO
ALTER TABLE [dbo].[CruceEstacionesImagen]  WITH CHECK ADD  CONSTRAINT [FK_new_CruceEstacionesTipoImagen_new_SysEstaciones] FOREIGN KEY([lnEstacion])
REFERENCES [dbo].[SysEstaciones] ([idEstacion])
GO
ALTER TABLE [dbo].[CruceEstacionesImagen] CHECK CONSTRAINT [FK_new_CruceEstacionesTipoImagen_new_SysEstaciones]
GO
ALTER TABLE [dbo].[CruceEstacionesListaEstacionesClientes]  WITH CHECK ADD  CONSTRAINT [FK_new_CruceEstacionesListaEstacionesClientes_new_ListaEstacionesClientes] FOREIGN KEY([lnCliente])
REFERENCES [dbo].[ListaEstacionesClientes] ([idCliente])
GO
ALTER TABLE [dbo].[CruceEstacionesListaEstacionesClientes] CHECK CONSTRAINT [FK_new_CruceEstacionesListaEstacionesClientes_new_ListaEstacionesClientes]
GO
ALTER TABLE [dbo].[CruceEstacionesListaEstacionesClientes]  WITH CHECK ADD  CONSTRAINT [FK_new_CruceEstacionesListaEstacionesClientes_new_SysEstaciones] FOREIGN KEY([lnEstacion])
REFERENCES [dbo].[SysEstaciones] ([idEstacion])
GO
ALTER TABLE [dbo].[CruceEstacionesListaEstacionesClientes] CHECK CONSTRAINT [FK_new_CruceEstacionesListaEstacionesClientes_new_SysEstaciones]
GO
ALTER TABLE [dbo].[CruceEstacionesListaEstacionesFechasUltimosDatos]  WITH CHECK ADD  CONSTRAINT [FK_new_CruceEstacionesListaFechasUltimosDatos_new_ListaEstacionesCoordenadas] FOREIGN KEY([lnTipoFechaUltimoDato])
REFERENCES [dbo].[ListaEstacionesFechasUltimosDatos] ([idTipoFechaUltimoDato])
GO
ALTER TABLE [dbo].[CruceEstacionesListaEstacionesFechasUltimosDatos] CHECK CONSTRAINT [FK_new_CruceEstacionesListaFechasUltimosDatos_new_ListaEstacionesCoordenadas]
GO
ALTER TABLE [dbo].[CruceEstacionesListaEstacionesFechasUltimosDatos]  WITH CHECK ADD  CONSTRAINT [FK_new_CruceListaEstacionesFechasUltimosDatos_new_SysEstaciones] FOREIGN KEY([lnEstacion])
REFERENCES [dbo].[SysEstaciones] ([idEstacion])
GO
ALTER TABLE [dbo].[CruceEstacionesListaEstacionesFechasUltimosDatos] CHECK CONSTRAINT [FK_new_CruceListaEstacionesFechasUltimosDatos_new_SysEstaciones]
GO
ALTER TABLE [dbo].[CruceEstacionesTipoUbicacion]  WITH CHECK ADD  CONSTRAINT [FK_new_CruceEstacionesTipoUbicacion_new_SysEstaciones] FOREIGN KEY([lnEstacion])
REFERENCES [dbo].[SysEstaciones] ([idEstacion])
GO
ALTER TABLE [dbo].[CruceEstacionesTipoUbicacion] CHECK CONSTRAINT [FK_new_CruceEstacionesTipoUbicacion_new_SysEstaciones]
GO
ALTER TABLE [dbo].[CruceEstacionesTipoUbicacion]  WITH CHECK ADD  CONSTRAINT [FK_new_CruceEstacionesTipoUbicacion_new_TipoUbicaciones] FOREIGN KEY([lnTipoUbicacion])
REFERENCES [dbo].[TipoUbicaciones] ([idTipoUbicacion])
GO
ALTER TABLE [dbo].[CruceEstacionesTipoUbicacion] CHECK CONSTRAINT [FK_new_CruceEstacionesTipoUbicacion_new_TipoUbicaciones]
GO
ALTER TABLE [dbo].[DatosDiarios]  WITH CHECK ADD  CONSTRAINT [FK_DatosDiarios_SysMedidas] FOREIGN KEY([lnMedida])
REFERENCES [dbo].[SysMedidas] ([idMedida])
GO
ALTER TABLE [dbo].[DatosDiarios] CHECK CONSTRAINT [FK_DatosDiarios_SysMedidas]
GO
ALTER TABLE [dbo].[DatosFechasCalculadas]  WITH CHECK ADD  CONSTRAINT [FK_new_DatosFechasCalculadas_new_ListaMedidasFunciones] FOREIGN KEY([lnFuncionDestino])
REFERENCES [dbo].[ListaMedidasFunciones] ([idFuncion])
GO
ALTER TABLE [dbo].[DatosFechasCalculadas] CHECK CONSTRAINT [FK_new_DatosFechasCalculadas_new_ListaMedidasFunciones]
GO
ALTER TABLE [dbo].[DatosFechasCalculadas]  WITH NOCHECK ADD  CONSTRAINT [FK_new_DatosFechasCalculadas_new_SysMedidas] FOREIGN KEY([lnMedidaOrigen])
REFERENCES [dbo].[SysMedidas] ([idMedida])
GO
ALTER TABLE [dbo].[DatosFechasCalculadas] CHECK CONSTRAINT [FK_new_DatosFechasCalculadas_new_SysMedidas]
GO
ALTER TABLE [dbo].[DatosFechasCalculadas]  WITH CHECK ADD  CONSTRAINT [FK_new_DatosFechasCalculadas_new_TipoIntervalo] FOREIGN KEY([lnTipoIntervaloDestino])
REFERENCES [dbo].[TipoIntervalo] ([idTipoIntervalo])
GO
ALTER TABLE [dbo].[DatosFechasCalculadas] CHECK CONSTRAINT [FK_new_DatosFechasCalculadas_new_TipoIntervalo]
GO
ALTER TABLE [dbo].[DatosHorarios]  WITH NOCHECK ADD  CONSTRAINT [FK_DatosHorarios_SysMedidas] FOREIGN KEY([lnMedida])
REFERENCES [dbo].[SysMedidas] ([idMedida])
GO
ALTER TABLE [dbo].[DatosHorarios] CHECK CONSTRAINT [FK_DatosHorarios_SysMedidas]
GO
ALTER TABLE [dbo].[DatosHorarios]  WITH CHECK ADD  CONSTRAINT [FK_new_DatosHorarios_new_ListaDatosCodigoValidacion] FOREIGN KEY([lnCodigoValidacion])
REFERENCES [dbo].[ListaDatosCodigoValidacion] ([idCodigoValidacion])
GO
ALTER TABLE [dbo].[DatosHorarios] CHECK CONSTRAINT [FK_new_DatosHorarios_new_ListaDatosCodigoValidacion]
GO
ALTER TABLE [dbo].[DatosHorarios]  WITH NOCHECK ADD  CONSTRAINT [FK_new_DatosHorarios_new_SysMedidas1] FOREIGN KEY([lnMedida])
REFERENCES [dbo].[SysMedidas] ([idMedida])
GO
ALTER TABLE [dbo].[DatosHorarios] CHECK CONSTRAINT [FK_new_DatosHorarios_new_SysMedidas1]
GO
ALTER TABLE [dbo].[DatosMensuales]  WITH CHECK ADD  CONSTRAINT [FK_new_DatosMensuales_new_SysMedidas1] FOREIGN KEY([lnMedida])
REFERENCES [dbo].[SysMedidas] ([idMedida])
GO
ALTER TABLE [dbo].[DatosMensuales] CHECK CONSTRAINT [FK_new_DatosMensuales_new_SysMedidas1]
GO
ALTER TABLE [dbo].[Imagenes]  WITH CHECK ADD  CONSTRAINT [FK_Imagenes_TipoImagen] FOREIGN KEY([lnTipoImagen])
REFERENCES [dbo].[TipoImagen] ([idTipoImagen])
GO
ALTER TABLE [dbo].[Imagenes] CHECK CONSTRAINT [FK_Imagenes_TipoImagen]
GO
ALTER TABLE [dbo].[ListaDatosNivelValidacion]  WITH CHECK ADD  CONSTRAINT [FK_new_ListaDatosNivelValidacion_new_TipoIntervalo] FOREIGN KEY([lnTipoIntervalo])
REFERENCES [dbo].[TipoIntervalo] ([idTipoIntervalo])
GO
ALTER TABLE [dbo].[ListaDatosNivelValidacion] CHECK CONSTRAINT [FK_new_ListaDatosNivelValidacion_new_TipoIntervalo]
GO
ALTER TABLE [dbo].[ListaMedidasAlturas]  WITH CHECK ADD  CONSTRAINT [FK_new_ListaMedidasAlturas_new_TipoUnidades] FOREIGN KEY([lnTipoUnidad])
REFERENCES [dbo].[TipoUnidades] ([idTipoUnidad])
GO
ALTER TABLE [dbo].[ListaMedidasAlturas] CHECK CONSTRAINT [FK_new_ListaMedidasAlturas_new_TipoUnidades]
GO
ALTER TABLE [dbo].[ListaMedidasTipo]  WITH CHECK ADD  CONSTRAINT [FK_new_ListaMedidasTipo_new_ListaMedidasAlturas] FOREIGN KEY([lnAltura])
REFERENCES [dbo].[ListaMedidasAlturas] ([idAltura])
GO
ALTER TABLE [dbo].[ListaMedidasTipo] CHECK CONSTRAINT [FK_new_ListaMedidasTipo_new_ListaMedidasAlturas]
GO
ALTER TABLE [dbo].[ListaMedidasTipo]  WITH CHECK ADD  CONSTRAINT [FK_new_ListaMedidasTipo_new_ListaMedidasFunciones] FOREIGN KEY([lnFuncion])
REFERENCES [dbo].[ListaMedidasFunciones] ([idFuncion])
GO
ALTER TABLE [dbo].[ListaMedidasTipo] CHECK CONSTRAINT [FK_new_ListaMedidasTipo_new_ListaMedidasFunciones]
GO
ALTER TABLE [dbo].[ListaMedidasTipo]  WITH CHECK ADD  CONSTRAINT [FK_new_ListaMedidasTipo_new_SysParametros] FOREIGN KEY([lnParametro])
REFERENCES [dbo].[SysParametros] ([idParametro])
GO
ALTER TABLE [dbo].[ListaMedidasTipo] CHECK CONSTRAINT [FK_new_ListaMedidasTipo_new_SysParametros]
GO
ALTER TABLE [dbo].[ListaMedidasTipo]  WITH CHECK ADD  CONSTRAINT [FK_new_ListaMedidasTipo_new_TipoIntervalo] FOREIGN KEY([lnTipointervalo])
REFERENCES [dbo].[TipoIntervalo] ([idTipoIntervalo])
GO
ALTER TABLE [dbo].[ListaMedidasTipo] CHECK CONSTRAINT [FK_new_ListaMedidasTipo_new_TipoIntervalo]
GO
ALTER TABLE [dbo].[SysEstaciones]  WITH CHECK ADD  CONSTRAINT [FK_new_SysEstaciones_new_ListaEstacionesPropietarios] FOREIGN KEY([lnPropietario])
REFERENCES [dbo].[ListaEstacionesPropietarios] ([idPropietario])
GO
ALTER TABLE [dbo].[SysEstaciones] CHECK CONSTRAINT [FK_new_SysEstaciones_new_ListaEstacionesPropietarios]
GO
ALTER TABLE [dbo].[SysEstaciones]  WITH CHECK ADD  CONSTRAINT [FK_new_SysEstaciones_new_ListaEstacionesSubredes] FOREIGN KEY([lnSubred])
REFERENCES [dbo].[ListaEstacionesSubredes] ([idSubred])
GO
ALTER TABLE [dbo].[SysEstaciones] CHECK CONSTRAINT [FK_new_SysEstaciones_new_ListaEstacionesSubredes]
GO
ALTER TABLE [dbo].[SysEstaciones]  WITH CHECK ADD  CONSTRAINT [FK_SysEstaciones_AuxConcellos] FOREIGN KEY([lnConcello])
REFERENCES [dbo].[AuxConcellos] ([idConcello])
GO
ALTER TABLE [dbo].[SysEstaciones] CHECK CONSTRAINT [FK_SysEstaciones_AuxConcellos]
GO
ALTER TABLE [dbo].[SysMedidas]  WITH CHECK ADD  CONSTRAINT [FK_new_SysMedidas_new_ListaMedidasUsos1] FOREIGN KEY([lnUso])
REFERENCES [dbo].[ListaMedidasUsos] ([idUso])
GO
ALTER TABLE [dbo].[SysMedidas] CHECK CONSTRAINT [FK_new_SysMedidas_new_ListaMedidasUsos1]
GO
ALTER TABLE [dbo].[SysMedidas]  WITH CHECK ADD  CONSTRAINT [FK_new_SysMedidas_new_SysSensores1] FOREIGN KEY([lnSensor])
REFERENCES [dbo].[SysSensores] ([idSensor])
GO
ALTER TABLE [dbo].[SysMedidas] CHECK CONSTRAINT [FK_new_SysMedidas_new_SysSensores1]
GO
ALTER TABLE [dbo].[SysMedidas]  WITH CHECK ADD  CONSTRAINT [FK_new_SysMedidas2_new_ListaMedidasTipo] FOREIGN KEY([lnTipo])
REFERENCES [dbo].[ListaMedidasTipo] ([idTipo])
GO
ALTER TABLE [dbo].[SysMedidas] CHECK CONSTRAINT [FK_new_SysMedidas2_new_ListaMedidasTipo]
GO
ALTER TABLE [dbo].[SysParametros]  WITH CHECK ADD  CONSTRAINT [FK_new_SysParametros_new_ListaParametrosGranParametro] FOREIGN KEY([lnGranParametro])
REFERENCES [dbo].[ListaParametrosGranParametro] ([idGranParametro])
GO
ALTER TABLE [dbo].[SysParametros] CHECK CONSTRAINT [FK_new_SysParametros_new_ListaParametrosGranParametro]
GO
ALTER TABLE [dbo].[SysParametros]  WITH CHECK ADD  CONSTRAINT [FK_new_SysParametros_new_ListaParametrosUnidades] FOREIGN KEY([lnTipounidad])
REFERENCES [dbo].[TipoUnidades] ([idTipoUnidad])
GO
ALTER TABLE [dbo].[SysParametros] CHECK CONSTRAINT [FK_new_SysParametros_new_ListaParametrosUnidades]
GO
ALTER TABLE [dbo].[SysSensores]  WITH CHECK ADD  CONSTRAINT [FK_new_SysSensores_new_SysEstaciones] FOREIGN KEY([lnEstacion])
REFERENCES [dbo].[SysEstaciones] ([idEstacion])
GO
ALTER TABLE [dbo].[SysSensores] CHECK CONSTRAINT [FK_new_SysSensores_new_SysEstaciones]
GO
ALTER TABLE [dbo].[SysSensores]  WITH CHECK ADD  CONSTRAINT [FK_new_SysSensores_new_TipoSensor] FOREIGN KEY([lnTipoSensor])
REFERENCES [dbo].[TipoSensor] ([idTipoSensor])
GO
ALTER TABLE [dbo].[SysSensores] CHECK CONSTRAINT [FK_new_SysSensores_new_TipoSensor]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del registro' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CruceEstacionesImagen', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave de la estación' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CruceEstacionesImagen', @level2type=N'COLUMN',@level2name=N'lnEstacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del tipo de Imagen' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CruceEstacionesImagen', @level2type=N'COLUMN',@level2name=N'lnImagen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave de la estación' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CruceEstacionesListaEstacionesClientes', @level2type=N'COLUMN',@level2name=N'lnEstacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del cliente' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CruceEstacionesListaEstacionesClientes', @level2type=N'COLUMN',@level2name=N'lnCliente'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave Estacion' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CruceEstacionesListaEstacionesFechasUltimosDatos', @level2type=N'COLUMN',@level2name=N'lnEstacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave TipoFechaUltimoDato' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CruceEstacionesListaEstacionesFechasUltimosDatos', @level2type=N'COLUMN',@level2name=N'lnTipoFechaUltimoDato'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valor (fecha) del tipo/estación correspondiente.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CruceEstacionesListaEstacionesFechasUltimosDatos', @level2type=N'COLUMN',@level2name=N'Fecha'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave de la estación' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CruceEstacionesTipoUbicacion', @level2type=N'COLUMN',@level2name=N'lnEstacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del tipo de ubicación' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CruceEstacionesTipoUbicacion', @level2type=N'COLUMN',@level2name=N'lnTipoUbicacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'InstanteLectura' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosDiarios', @level2type=N'COLUMN',@level2name=N'FechaHora'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave de la medida' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosDiarios', @level2type=N'COLUMN',@level2name=N'lnMedida'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valor del dato' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosDiarios', @level2type=N'COLUMN',@level2name=N'Valor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del Código de validación' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosDiarios', @level2type=N'COLUMN',@level2name=N'lnCodigoValidacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del Nivel de validación' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosDiarios', @level2type=N'COLUMN',@level2name=N'lnNivelValidacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Visual, booleano que indica si el dato se puede modificar.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosDiarios', @level2type=N'COLUMN',@level2name=N'Visual'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'día o mes del dato' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosFechasCalculadas', @level2type=N'COLUMN',@level2name=N'FechaHora'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ej: Temperatura' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosFechasCalculadas', @level2type=N'COLUMN',@level2name=N'lnMedidaOrigen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ej: Máxima' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosFechasCalculadas', @level2type=N'COLUMN',@level2name=N'lnFuncionDestino'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ej: Mensual (Agosto)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosFechasCalculadas', @level2type=N'COLUMN',@level2name=N'lnTipoIntervaloDestino'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ej: 18/08/2013 16:10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosFechasCalculadas', @level2type=N'COLUMN',@level2name=N'Valor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del CodValidacion' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosFechasCalculadas', @level2type=N'COLUMN',@level2name=N'lnCodigoValidacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'InstanteLectura' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosHorarios', @level2type=N'COLUMN',@level2name=N'FechaHora'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave de la medida' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosHorarios', @level2type=N'COLUMN',@level2name=N'lnMedida'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valor del dato' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosHorarios', @level2type=N'COLUMN',@level2name=N'Valor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del Código de validación' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosHorarios', @level2type=N'COLUMN',@level2name=N'lnCodigoValidacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del Nivel de validación' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosHorarios', @level2type=N'COLUMN',@level2name=N'lnNivelValidacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Visual, booleano que indica si el dato se puede modificar.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosHorarios', @level2type=N'COLUMN',@level2name=N'Visual'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'InstanteLectura' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosMensuales', @level2type=N'COLUMN',@level2name=N'FechaHora'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave de la medida' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosMensuales', @level2type=N'COLUMN',@level2name=N'lnMedida'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valor del dato' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosMensuales', @level2type=N'COLUMN',@level2name=N'Valor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del Código de validación' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosMensuales', @level2type=N'COLUMN',@level2name=N'lnCodigoValidacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del Nivel de validación' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosMensuales', @level2type=N'COLUMN',@level2name=N'lnNivelValidacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Visual, booleano que indica si el dato se puede modificar.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DatosMensuales', @level2type=N'COLUMN',@level2name=N'Visual'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identificativo autonumérico de la imagen, clave privada' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Imagenes', @level2type=N'COLUMN',@level2name=N'idImagen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave externa para relacionar con el tipo de imagen' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Imagenes', @level2type=N'COLUMN',@level2name=N'lnTipoImagen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Imagen' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Imagenes', @level2type=N'COLUMN',@level2name=N'Imagen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Enlace externo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Imagenes', @level2type=N'COLUMN',@level2name=N'Link'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Galego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Imagenes', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Imagenes', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del código de validación' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaDatosCodigoValidacion', @level2type=N'COLUMN',@level2name=N'idCodigoValidacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaDatosCodigoValidacion', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaDatosCodigoValidacion', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del código de validación' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaDatosNivelValidacion', @level2type=N'COLUMN',@level2name=N'idNivelValidacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del tipo de intervalo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaDatosNivelValidacion', @level2type=N'COLUMN',@level2name=N'lnTipoIntervalo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaDatosNivelValidacion', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaDatosNivelValidacion', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave privada del cliente' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaEstacionesClientes', @level2type=N'COLUMN',@level2name=N'idCliente'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nombre del cliente, por ejemplo AEMET, MAPFRE, TVG...' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaEstacionesClientes', @level2type=N'COLUMN',@level2name=N'Cliente'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaEstacionesClientes', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaEstacionesClientes', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave privada del tipo de coordenadas' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaEstacionesCoordenadas', @level2type=N'COLUMN',@level2name=N'idTipoCoordenadas'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo de coordenadas' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaEstacionesCoordenadas', @level2type=N'COLUMN',@level2name=N'TipoCoordenadas'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaEstacionesCoordenadas', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaEstacionesCoordenadas', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave principal' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaEstacionesFechasUltimosDatos', @level2type=N'COLUMN',@level2name=N'idTipoFechaUltimoDato'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bruto, Validado, Oleaje, RSondeo...' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaEstacionesFechasUltimosDatos', @level2type=N'COLUMN',@level2name=N'TipoFechaUltimoDato'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaEstacionesFechasUltimosDatos', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaEstacionesFechasUltimosDatos', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nombre del propietario' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaEstacionesPropietarios', @level2type=N'COLUMN',@level2name=N'Propietario'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaEstacionesPropietarios', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaEstacionesPropietarios', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave privada de la subred' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaEstacionesSubredes', @level2type=N'COLUMN',@level2name=N'idSubred'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nombre de la subred' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaEstacionesSubredes', @level2type=N'COLUMN',@level2name=N'Subred'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Abreviatura de la subred' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaEstacionesSubredes', @level2type=N'COLUMN',@level2name=N'NombreCorto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaEstacionesSubredes', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaEstacionesSubredes', @level2type=N'COLUMN',@level2name=N'DescripcionES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave privada, autonumérica' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasAlturas', @level2type=N'COLUMN',@level2name=N'idAltura'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Distintas Alturas' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasAlturas', @level2type=N'COLUMN',@level2name=N'Altura'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descripción en Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasAlturas', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descripción en Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasAlturas', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave privada, autonumérica' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasFunciones', @level2type=N'COLUMN',@level2name=N'idFuncion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Distintas Funciones (Max, Min, Sum...)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasFunciones', @level2type=N'COLUMN',@level2name=N'Funcion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descripción en Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasFunciones', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descripción en Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasFunciones', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del tipo de medida' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasTipo', @level2type=N'COLUMN',@level2name=N'idTipo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave externa del tipo de parámetro' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasTipo', @level2type=N'COLUMN',@level2name=N'lnParametro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave externa del tipo de función' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasTipo', @level2type=N'COLUMN',@level2name=N'lnFuncion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave externa del tip ode altura' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasTipo', @level2type=N'COLUMN',@level2name=N'lnAltura'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave externa del tipo de intervalo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasTipo', @level2type=N'COLUMN',@level2name=N'lnTipointervalo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valor máximo (límite sensor)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasTipo', @level2type=N'COLUMN',@level2name=N'ValorMax'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valor mínimo (límite sensor)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasTipo', @level2type=N'COLUMN',@level2name=N'ValorMin'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1,10,30 litros para NDPP o 7ºC para HFRIO' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasTipo', @level2type=N'COLUMN',@level2name=N'ValorUmbral'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Explicación de este tipo de medida' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasTipo', @level2type=N'COLUMN',@level2name=N'Comentario'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave privada del tipo de uso' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasUsos', @level2type=N'COLUMN',@level2name=N'idUso'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo de uso (explot, calib, control, vbat)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasUsos', @level2type=N'COLUMN',@level2name=N'Uso'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasUsos', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasUsos', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave privada' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasVisibilidad', @level2type=N'COLUMN',@level2name=N'idVisibilidad'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo de visibilidad (ultDatos, hist, xeo, estActual...)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasVisibilidad', @level2type=N'COLUMN',@level2name=N'Visibilidad'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Activar o desactivar esa visibilidad' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasVisibilidad', @level2type=N'COLUMN',@level2name=N'Activa'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasVisibilidad', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaMedidasVisibilidad', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave privada' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaParametrosGranParametro', @level2type=N'COLUMN',@level2name=N'idGranParametro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Abreviatura' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaParametrosGranParametro', @level2type=N'COLUMN',@level2name=N'GranParametro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descripción en Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaParametrosGranParametro', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descripción en Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ListaParametrosGranParametro', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave privada de la estación' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysEstaciones', @level2type=N'COLUMN',@level2name=N'idEstacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave de la subred' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysEstaciones', @level2type=N'COLUMN',@level2name=N'lnSubred'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del propietario' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysEstaciones', @level2type=N'COLUMN',@level2name=N'lnPropietario'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del concello (para cruzar con BD Galicia)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysEstaciones', @level2type=N'COLUMN',@level2name=N'lnConcello'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Boleeano que indica si está en funcionamiento o no.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysEstaciones', @level2type=N'COLUMN',@level2name=N'EnServicio'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nombre de la estación' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysEstaciones', @level2type=N'COLUMN',@level2name=N'Estacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Abreviatura de la estación' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysEstaciones', @level2type=N'COLUMN',@level2name=N'NombreCorto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave privada' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysMedidas', @level2type=N'COLUMN',@level2name=N'idMedida'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del sensor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysMedidas', @level2type=N'COLUMN',@level2name=N'lnSensor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del tipo de medida' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysMedidas', @level2type=N'COLUMN',@level2name=N'lnTipo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del uso' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysMedidas', @level2type=N'COLUMN',@level2name=N'lnUso'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indica si está metiendo datos o no' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysMedidas', @level2type=N'COLUMN',@level2name=N'Activa'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nombre de la medida' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysMedidas', @level2type=N'COLUMN',@level2name=N'Medida'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave privada, autonumérica' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysParametros', @level2type=N'COLUMN',@level2name=N'idParametro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave a la tabla cfgGranParametro' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysParametros', @level2type=N'COLUMN',@level2name=N'lnGranParametro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave a la tabla cfgUnidades' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysParametros', @level2type=N'COLUMN',@level2name=N'lnTipounidad'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Abreviatura del parámetro' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysParametros', @level2type=N'COLUMN',@level2name=N'Parametro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descripción en Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysParametros', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descripción en Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysParametros', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Antiguo formato, nº de posiciones decimales' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysParametros', @level2type=N'COLUMN',@level2name=N'Precision'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Información adicional para web o informes en Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysParametros', @level2type=N'COLUMN',@level2name=N'InfoGa'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Información adicional para web o informes en Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysParametros', @level2type=N'COLUMN',@level2name=N'InfoEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave privada del sensor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysSensores', @level2type=N'COLUMN',@level2name=N'idSensor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave de la estación donde está el sensor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysSensores', @level2type=N'COLUMN',@level2name=N'lnEstacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del tipo de sensor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysSensores', @level2type=N'COLUMN',@level2name=N'lnTipoSensor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Booleano que indica si está en funcionamiento' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysSensores', @level2type=N'COLUMN',@level2name=N'Activo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Booleano que indica si se muestra públicamente' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysSensores', @level2type=N'COLUMN',@level2name=N'Publico'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Altura sobre el suelo en metros' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysSensores', @level2type=N'COLUMN',@level2name=N'AlturaInstalacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del tipo de alimentación' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoAlimentacion', @level2type=N'COLUMN',@level2name=N'idTipoAlimentacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo de alimentación' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoAlimentacion', @level2type=N'COLUMN',@level2name=N'TipoAlimentacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descripción en Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoAlimentacion', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descripción en Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoAlimentacion', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave privada' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoComunicacion', @level2type=N'COLUMN',@level2name=N'idTipoComunicacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo de comunicación (GRPS, LAN, WIFI...)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoComunicacion', @level2type=N'COLUMN',@level2name=N'TipoComunicacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoComunicacion', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoComunicacion', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del tipo de datalogger' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoDatalogger', @level2type=N'COLUMN',@level2name=N'idTipoDatalogger'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fabricante del datalogger' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoDatalogger', @level2type=N'COLUMN',@level2name=N'Fabricante'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Modelo del datalogger' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoDatalogger', @level2type=N'COLUMN',@level2name=N'Modelo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoDatalogger', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoDatalogger', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del tipo de imagen' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoImagen', @level2type=N'COLUMN',@level2name=N'idTipoImagen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Web, anuario, informe, datos...' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoImagen', @level2type=N'COLUMN',@level2name=N'TipoImagen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoImagen', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoImagen', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del tipo de incidencia' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoIncidencia', @level2type=N'COLUMN',@level2name=N'idTipoIncidencia'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo y alcance' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoIncidencia', @level2type=N'COLUMN',@level2name=N'TipoIncidencia'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoIncidencia', @level2type=N'COLUMN',@level2name=N'DescipcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoIncidencia', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave privada del tipo de ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoIntervalo', @level2type=N'COLUMN',@level2name=N'idTipoIntervalo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Intervalo de tiempo entre dos valores' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoIntervalo', @level2type=N'COLUMN',@level2name=N'TipoIntervalo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoIntervalo', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoIntervalo', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del t ipo de orden' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoOrden', @level2type=N'COLUMN',@level2name=N'idTipoOrden'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Distintas maneras de ordenar los parámetros' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoOrden', @level2type=N'COLUMN',@level2name=N'TipoOrden'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoOrden', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoOrden', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave privada del tipo de sensor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoSensor', @level2type=N'COLUMN',@level2name=N'idTipoSensor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo de sensor (meteorológico, oceanográfico...)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoSensor', @level2type=N'COLUMN',@level2name=N'TipoSensor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentarios en Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoSensor', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentarios en Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoSensor', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave privada' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoTerreno', @level2type=N'COLUMN',@level2name=N'idTipoTerreno'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoTerreno', @level2type=N'COLUMN',@level2name=N'Valor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario inglés' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoTerreno', @level2type=N'COLUMN',@level2name=N'DescripcionEn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoTerreno', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoTerreno', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del tipo de ubicación' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoUbicaciones', @level2type=N'COLUMN',@level2name=N'idTipoUbicacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo de ubicación (carreteras, Costera, Urbana, Fluviar, Montaña...)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoUbicaciones', @level2type=N'COLUMN',@level2name=N'TipoUbicacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoUbicaciones', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario en Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoUbicaciones', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave privada, autonumérica' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoUnidades', @level2type=N'COLUMN',@level2name=N'idTipoUnidad'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nombre de las unidades' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoUnidades', @level2type=N'COLUMN',@level2name=N'Unidad'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descripción en Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoUnidades', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descripción en Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoUnidades', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clave del tipo de validacion' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoValidacion', @level2type=N'COLUMN',@level2name=N'idTipoValidacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parametro de validación' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoValidacion', @level2type=N'COLUMN',@level2name=N'TipoValidacion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario Gallego' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoValidacion', @level2type=N'COLUMN',@level2name=N'DescripcionGl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comentario Castellano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TipoValidacion', @level2type=N'COLUMN',@level2name=N'DescripcionEs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Datos10minutales'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Datos10minutales'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ListaMedidasAlturas"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ListaMedidasTipo"
            Begin Extent = 
               Top = 6
               Left = 265
               Bottom = 114
               Right = 454
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "ListaMedidasFunciones"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SysMedidas"
            Begin Extent = 
               Top = 114
               Left = 265
               Bottom = 222
               Right = 454
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ListaMedidasUsos"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SysParametros"
            Begin Extent = 
               Top = 222
               Left = 265
               Bottom = 330
               Right = 454
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SysSensores"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 438
               Right' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIDX_AyudaMedidas'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SysEstaciones"
            Begin Extent = 
               Top = 330
               Left = 265
               Bottom = 438
               Right = 454
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TipoUnidades"
            Begin Extent = 
               Top = 438
               Left = 38
               Bottom = 546
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 9
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIDX_AyudaMedidas'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIDX_AyudaMedidas'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "VIDX_AyudaMedidas"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 314
               Right = 562
            End
            DisplayFlags = 280
            TopColumn = 14
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIDX_AyudaMedidas_NOEXPAND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIDX_AyudaMedidas_NOEXPAND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "VIDX_ClavesMedidas"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 236
               Right = 285
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIDX_ClavesMedidas_NOEXPAND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIDX_ClavesMedidas_NOEXPAND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[59] 4[2] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = -384
      End
      Begin Tables = 
         Begin Table = "ListaMedidasAlturas"
            Begin Extent = 
               Top = 207
               Left = 523
               Bottom = 398
               Right = 712
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ListaMedidasTipo"
            Begin Extent = 
               Top = 2
               Left = 762
               Bottom = 280
               Right = 951
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ListaMedidasFunciones"
            Begin Extent = 
               Top = 215
               Left = 1076
               Bottom = 323
               Right = 1265
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SysMedidas"
            Begin Extent = 
               Top = 8
               Left = 519
               Bottom = 175
               Right = 708
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ListaMedidasUsos"
            Begin Extent = 
               Top = 205
               Left = 245
               Bottom = 313
               Right = 434
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SysParametros"
            Begin Extent = 
               Top = 8
               Left = 1074
               Bottom = 192
               Right = 1263
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SysSensores"
            Begin Extent = 
               Top = 8
               Left = 242
               Bottom = 179
              ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vista_AyudaMedidas'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' Right = 431
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SysEstaciones"
            Begin Extent = 
               Top = 11
               Left = 21
               Bottom = 203
               Right = 210
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TipoUnidades"
            Begin Extent = 
               Top = 323
               Left = 863
               Bottom = 431
               Right = 1052
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vista_AyudaMedidas'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vista_AyudaMedidas'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CruceEstacionesListaEstacionesCoordenadas"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vista_CruceEstacionesListaEstacionesCoordenadas_LatLonAlt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vista_CruceEstacionesListaEstacionesCoordenadas_LatLonAlt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 6
               Left = 265
               Bottom = 114
               Right = 454
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vista_CruceEstacionesListaEstacionesCoordenadas_LatLonAlt_WGS84'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vista_CruceEstacionesListaEstacionesCoordenadas_LatLonAlt_WGS84'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CruceEstacionesListaEstacionesCoordenadas"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 210
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vista_CruceEstacionesListaEstacionesCoordenadas_Orto_Ocaso_MDT200'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vista_CruceEstacionesListaEstacionesCoordenadas_Orto_Ocaso_MDT200'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CruceEstacionesListaEstacionesCoordenadas"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vista_CruceEstacionesListaEstacionesCoordenadas_Orto_Ocaso_MDT250'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vista_CruceEstacionesListaEstacionesCoordenadas_Orto_Ocaso_MDT250'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CruceEstacionesListaEstacionesCoordenadas"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vista_CruceEstacionesListaEstacionesCoordenadas_UTM_ETRS89'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vista_CruceEstacionesListaEstacionesCoordenadas_UTM_ETRS89'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CruceEstacionesListaEstacionesCoordenadas"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vista_CruceEstacionesListaEstacionesCoordenadas_UTM_ETRS89_MDT250'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vista_CruceEstacionesListaEstacionesCoordenadas_UTM_ETRS89_MDT250'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "e"
            Begin Extent = 
               Top = 14
               Left = 15
               Bottom = 122
               Right = 204
            End
            DisplayFlags = 280
            TopColumn = 5
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 16
               Left = 241
               Bottom = 145
               Right = 430
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "i"
            Begin Extent = 
               Top = 19
               Left = 465
               Bottom = 127
               Right = 654
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 2625
         Width = 1500
         Width = 1500
         Width = 2115
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vista_Estaciones_Imagenes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vista_Estaciones_Imagenes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "e"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 265
               Bottom = 114
               Right = 454
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vista_Estaciones_Provincia_Concello'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vista_Estaciones_Provincia_Concello'
GO
