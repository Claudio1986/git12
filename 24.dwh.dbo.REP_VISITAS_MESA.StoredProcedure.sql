USE [DWH]
GO

/****** Object:  StoredProcedure [dbo].[REP_VISITAS_MESA]    Script Date: 05/11/2018 16:06:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--exec REP_VISITAS_MESA '20180331'
CREATE PROCEDURE [dbo].[REP_VISITAS_MESA] 	@Mes varchar(10)
-- =============================================
-- Author:		<Carlos Toledo>
-- Create date: <2018-04-23>
-- Description:	<Rep Visitas Mesa>
-- =============================================
AS
BEGIN
	SET NOCOUNT ON;

	--declare @Mes	date = '20180131'
	declare @mesmin date-- = '20180228'
                    
	set @mesmin = (select max(mes) from bancaempresas.dbo.gc_maestro2)

	--select @mesmin
       
	IF OBJECT_ID('tempdb..#visitas') IS NOT NULL DROP TABLE #visitas
	IF OBJECT_ID('tempdb..#actividad') IS NOT NULL DROP TABLE #actividad
	IF OBJECT_ID('tempdb..#resultado') IS NOT NULL DROP TABLE #resultado
	
	create table #actividad(rut_cli int, mes date)
	CREATE TABLE #visitas(fec_realizacion int,rutCli int,Cliente VARCHAR(200), rutEjec int, mes int, tipo_cliente VARCHAR(30), plataforma VARCHAR(30), nomEjec VARCHAR(200), canal VARCHAR(30), NomJefe       VARCHAR(200))
	INSERT INTO  #visitas EXEC [dwh].[dbo].[REP_DET_Visitas_Por_Ejecutivo] NULL,NULL,NULL,NULL,NULL
                    
	--select convert(varchar(4),year(getdate()),112)+'0101'

	while	@mesmin >	convert(varchar(4),year(getdate()),112)+'0101'
			AND
			(@mesmin	>=	@Mes OR	@MES	IS NULL)
       
	begin               
                    
			insert into #actividad            
			select  rut_cli, mes--, activo          
			from   bancaempresas.dbo.gc_maestro2           
			where  mes = @mesmin              --mes actual 
			and          rut_cli in (
								select	distinct rut_cli 
								from	bancaempresas.dbo.gc_maestro2 
								where	mes between dateadd(year,-1,dateadd(m,-1,dateadd(d,1,@mesmin))) 
								and		dateadd(d,-1,@mesmin) 
								and		mov_mesa = 1 
								group by rut_cli
						);
			
			set @mesmin = dateadd(d,-1,dateadd(m,-1,dateadd(d,1,@mesmin)))
                    
	end                 
       
	--select * from #actividad            	   
	                
	select 
				eomonth(convert(varchar(10),visi.fec_realizacion,112)) fec_realizacion
				,CASE WHEN tabl.rut_cli IS NOT NULL THEN 'ANTIGUO' ELSE 'NUEVO' END CLASIFICACION
				,isnull(tabl.rut_cli,visi.rutCli)	rutCli
				,visi.Cliente
				,visi.rutEjec
				,tipo_cliente
				,plataforma
				,nomEjec
				,canal
				,NomJefe
				,CASE
				WHEN	eomonth(convert(varchar(10),fec_realizacion,112)) = tabl.mes
					THEN	1
				WHEN	dateadd(month,-1,eomonth(convert(varchar(10),fec_realizacion,112))) = tabl.mes	
						AND	eomonth(convert(varchar(10),fec_realizacion,112)) = (select max(mes) from bancaempresas.dbo.gc_maestro2)
					THEN	0
				END		VisitaMesCurso
				--,eomonth(convert(varchar(10),fec_realizacion,112))
				,tabl.mes
	into		 #resultado
	from         #visitas		visi
	LEFT JOIN   #actividad     tabl
	ON           visi.rutCli  =      tabl.rut_cli
	AND     (	eomonth(convert(varchar(10),fec_realizacion,112))     =      tabl.mes
			OR  (	tabl.mes = (select max(mes) from bancaempresas.dbo.gc_maestro2)
				and	
					eomonth(convert(varchar(10),fec_realizacion,112))     >      tabl.mes
				)
			)
	left join 	dwh.dbo.ejecutivos	ejec
	ON			rut_ejec	=	rutEjec
	AND			fec_hasta	=	29991231
	WHERE		especialista_prod	IS NULL

	--AND		rutCli IN	(5715251)--,
	--					--(85891400,96777810,96548020,96874030,77764730)--,
	--					(96561560,76498260,79848630)
	order by rutCli


	select	
			min(fec_realizacion)	fec_realizacion
			,CLASIFICACION
			,rutCli
			,Cliente
			,rutEjec
			,tipo_cliente
			,plataforma
			,nomEjec
			,canal
			,NomJefe
			--,VisitaMesCurso
	from	#resultado
	
	group by
			CLASIFICACION
			,rutCli
			,Cliente
			,rutEjec
			,tipo_cliente
			,plataforma
			,nomEjec
			,canal
			,NomJefe
	having	@Mes	<=	min(fec_realizacion)
END


--select		vis.* 
--from		#visitas			vis
--left join 	dwh.dbo.ejecutivos	ejec
--ON			rut_ejec	=	rutEjec
--AND			fec_hasta	=	29991231
--WHERE		especialista_prod	IS NULL
--
--
--
GO


