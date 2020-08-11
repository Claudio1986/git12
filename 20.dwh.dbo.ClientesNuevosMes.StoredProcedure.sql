USE [DWH]
GO
/****** Object:  StoredProcedure [dbo].[ClientesNuevosMes]    Script Date: 09/04/2018 18:25:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[ClientesNuevosMes]') IS NOT NULL
BEGIN
	drop  PROCEDURE [dbo].[ClientesNuevosMes]
END
GO
CREATE PROCEDURE [dbo].[ClientesNuevosMes]
-- =============================================
-- Author:		<Carlos Toledo>
-- Create date: <2018-04-10>
-- Description:	<Clientes Nuevos del Mes>
-- =============================================
--exec  [dbo].[ClientesNuevosMes]
AS					
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	--declare @Ejecutivo decimal(10),@Visitado smallint, @Canal VARCHAR(10), @Plataforma VARCHAR(30)
	--set @Ejecutivo = 0 
	--SET @Visitado = 5
	--SET @Canal = ''

	SET NOCOUNT ON;

	SELECT
				MES.rut_cli
				,Mes.Cliente
				,Clie.fec_desde	fechaCreacion
	FROM		[DWH].[dbo].[VW_CliAct]	MES
	LEFT JOIN	[DWH].[dbo].[Clientes]	Clie
	ON			Clie.id = MES.id_cliente
	WHERE		MES.rut_cli IN (
							SELECT 
										MES.[rut_cli]
							FROM		[DWH].[dbo].[VW_CliAct]	MES
							LEFT JOIN 	[DWH].[dbo].[VW_CliAct]	ANTERIOR
							ON			MES.rut_cli			=	ANTERIOR.rut_cli	
							AND			MES.FECHA			=	convert(varchar(10),EOMONTH(dateadd(month,1,convert(varchar(10),ANTERIOR.FECHA,112))),112)
							WHERE		MES.FECHA			=	(SELECT MAX(FECHA) FROM [DWH].[dbo].[VW_CliAct])
							AND			ANTERIOR.rut_cli	IS  NULL
	);


END
