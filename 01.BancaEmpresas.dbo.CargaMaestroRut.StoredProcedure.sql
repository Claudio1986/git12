USE [BancaEmpresas]
GO

/****** Object:  StoredProcedure [dbo].[CargaMaestroRut]    Script Date: 07/11/2018 15:57:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Carlos Toledo>
-- Create date: <2017-11-09>
-- Description:	<Carga de Maestro>
-- =============================================
--[dbo].[CargaMaestroRut] '201804', NULL
CREATE PROCEDURE [dbo].[CargaMaestroRut] @Mes varchar(6), @rut int
AS
BEGIN
	
	--declare @Mes varchar(6) = '201801'
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @fecha datetime;
	DECLARE @diasdesfaserevision int = 40;

	SET @fecha = DATEADD (dd,-1,DATEADD (mm , 1 , cast(@Mes+'01' as DATETIME) ) ) ;

	SELECT convert(varchar(8),@fecha,112),@fecha

	DELETE 
	FROM	dbo.gc_maestro2
	WHERE	mes = @fecha
	AND		(rut_cli	=	@rut	OR	@rut	IS NULL);

	--Carga tabla maestro a una fecha particular
	insert into dbo.gc_maestro2
	select @fecha, rut_cli, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	from 
	(
		select		rut_cli
		from		dwh.dbo.clientes			clie
		WHERE		convert(varchar(10),@fecha,112)	between dateadd(day,-@diasdesfaserevision,convert(varchar(10),clie.fec_desde,112)) and	clie.fec_hasta
		AND			tipo_cliente = 1
		AND			(rut_cli	=	@rut	OR	@rut	IS NULL)
		group by	rut_cli

	)as A

	;

	-----------------------------------------------
	---REALIZA CALCULO DE INDICADORES EN MAESTRO---
	-----------------------------------------------
	--declare @fecha date

	--set @fecha = '20171031'

	--select @fecha

	-------------------------------------------------------------------------------------------------------------
	--Actualiza Movimiento Comercial
	update dbo.gc_maestro2
	set Mov_com = (case when b.stock>0 then 1 else 0 end), movimiento = 1
	from dbo.gc_maestro2 a
	left join 
	(	select 
		fecha, rut_cli, 'Comercial' as Tipo
		,sum(isnull(capital_vigente_ml,0)+isnull(capital_vencido_ml,0)+isnull(interes_vigente_ml,0)+isnull(interes_vencido_ml,0)+isnull(reajuste_vigente,0)+isnull(reajuste_vencido,0)) as Stock
	from dbo.cre_cartera
	where fecha = @fecha
		and nro_operacion not between (select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=1 )
								and   (select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=1 )
		and nro_operacion not between (select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=2 )
								and   (select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=2 )
		and nro_operacion not between (select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=3 )
								and   (select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=3 )
		and nro_operacion not between (select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=4 )
								and   (select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=4 )
		and nro_operacion not between (select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=5 )
								and   (select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=5 )
		and nro_operacion not between (select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=6 )
								and   (select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=6 )
		and nro_operacion not between (select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=7 )
								and   (select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=7 )
		and nro_operacion not between (select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=8 )
								and   (select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=8 )
		and nro_operacion not between (select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=9 )
								and   (select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=9 )
		and nro_operacion not between (select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=10 )
								and   (select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=10 )
		and nro_operacion not between (select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=11 )
								and   (select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=11 )
		and nro_operacion not between (select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=12 )
								and   (select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=12 )
		and nro_operacion not between (select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=13 )
								and   (select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=13 )
		and nro_operacion not between (select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=14 )
								and   (select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=14 )
		and nro_operacion not between (select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=15 )
								and   (select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=15 )
		and nro_operacion not between (select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=16 )
								and   (select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=16 )
		and nro_operacion not between (select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=17 )
								and   (select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=17 )
		and nro_operacion not between (select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=18 )
								and   (select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=18 )
		and nro_operacion not between (select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=19 )
								and   (select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=19 )
		and nro_operacion not between (select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=20 )
								and   (select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMERCIAL' AND ACTIVO=1 AND NIVEL=20 )
		and nro_operacion not in (SELECT DISTINCT nro_operacion
								FROM bancaempresas.dbo.op_financ_ctdo)
	group by fecha, rut_cli) as b
	on a.rut_cli = b.rut_cli
	and a.mes = b.fecha
	where a.mes = @fecha;

	--Actualiza Activo Comercial
	update	dbo.gc_maestro2
	set		act_com = (Case when b.movimiento >0 then 1 else 0 end)
	from	dbo.gc_maestro2 a 
	left join
	(
		select	
					maes.rut_cli
					,sum(mov_com) as Movimiento
		from		bancaempresas.dbo.gc_maestro2					maes
		left join	bancaempresas.[dbo].[gc_clientes_plazogestion]	plge
		ON			maes.Rut_cli	=	plge.rut_cli	
		--where		mes in (@fecha, dateadd(d,-1,dateadd(m,-1,dateadd(d,1,@fecha))), dateadd(d,-1,dateadd(m,-2,dateadd(d,1,@fecha)))
		--			, dateadd(d,-1,dateadd(m,-3,dateadd(d,1,@fecha))), dateadd(d,-1,dateadd(m,-4,dateadd(d,1,@fecha))))
		where		mes between	dateadd(d,-1,dateadd(m,-isnull(plazo_com,4),dateadd(d,1,@fecha))) and @fecha
		group by	maes.rut_cli
	) as B
	on a.rut_cli = b.rut_cli 
	where a.mes = @fecha 

	--Actualiza Movimiento Comex
	update dbo.gc_maestro2
	set mov_comex = (case when b.stock>0 then 1 else 0 end)
	from dbo.gc_maestro2 a
	left join 
	(select fecha, rut_cli, 'Comex' as Tipo, sum(isnull(capital_vigente_ml,0)+isnull(capital_vencido_ml,0)+isnull(interes_vigente_ml,0)+isnull(interes_vencido_ml,0)+isnull(reajuste_vigente,0)+isnull(reajuste_vencido,0)) as Stock
	from dbo.cre_cartera
	where fecha = @fecha
		and (nro_operacion	between	(select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=1 )
								and	(select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=1 )
		or nro_operacion	between (select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=2 )
								and	(select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=2 )
		or nro_operacion  between	(select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=3 )
								and	(select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=3 )
		or nro_operacion  between	(select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=4 )
								and	(select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=4 )
		or nro_operacion  between	(select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=5 )
								and	(select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=5 )
		or nro_operacion  between	(select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=6 )
								and	(select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=6 )
		or nro_operacion  between	(select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=7 )
								and	(select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=7 )
		or nro_operacion  between	(select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=8 )
								and	(select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=8 )
		or nro_operacion  between	(select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=9 )
								and	(select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=9 )
		or nro_operacion  between	(select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=10 )
								and	(select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=10 )
		or nro_operacion  between	(select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=11 )
								and	(select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=11 )
		or nro_operacion  between	(select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=12 )
								and	(select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=12 )
		or nro_operacion  between	(select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=13 )
								and	(select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=13 )
		or nro_operacion  between	(select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=14 )
								and	(select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=14 )
		or nro_operacion  between	(select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=15 )
								and	(select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=15 )
		or nro_operacion  between	(select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=16 )
								and	(select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=16 )
		or nro_operacion  between	(select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=17 )
								and	(select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=17 )
		or nro_operacion  between	(select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=18 )
								and	(select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=18 )
		or nro_operacion  between	(select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=19 )
								and	(select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=19 )
		or nro_operacion  between	(select val_min from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=20 )
								and	(select val_max from [dbo].[par_tipo_op_maestro] where tipo_prod='COMEX' AND ACTIVO=1 AND NIVEL=20 )
		or nro_operacion IN (SELECT DISTINCT nro_operacion
                           FROM   bancaempresas.dbo.op_financ_ctdo))
	group by fecha, rut_cli) as b
	on a.rut_cli = b.rut_cli
	and a.mes = b.fecha
	where a.mes = @fecha 

	--Actualiza Activo Comex
	update dbo.gc_maestro2
	set act_comex = (case when b.movimiento >0 then 1 else 0 end)
	from dbo.gc_maestro2 a 
	left join
	(
		select 
					maes.rut_cli, sum(mov_comex) as Movimiento
		from		bancaempresas.dbo.gc_maestro2					maes
		left join	bancaempresas.[dbo].[gc_clientes_plazogestion]	plge
		ON			maes.Rut_cli	=	plge.rut_cli	
		--where		mes in (@fecha, dateadd(d,-1,dateadd(m,-1,dateadd(d,1,@fecha))), dateadd(d,-1,dateadd(m,-2,dateadd(d,1,@fecha)))
		--			, dateadd(d,-1,dateadd(m,-3,dateadd(d,1,@fecha))), dateadd(d,-1,dateadd(m,-4,dateadd(d,1,@fecha))))
		where		mes between	dateadd(d,-1,dateadd(m,-isnull(plazo_comex,4),dateadd(d,1,@fecha))) and @fecha
		group by	maes.rut_cli
	) as B
	on a.rut_cli = b.rut_cli 
	where a.mes = @fecha 

	--Actualiza Movimiento BG
	update dbo.gc_maestro2
	set mov_bg = (case when b.stock>0 then 1 else 0 end)
	from dbo.gc_maestro2 a
	left join 
	(select fecha, rut_cli, 'BG' as Tipo, sum(capital_vigente_ml) as Stock 
	from dbo.bg_cartera
	group by fecha, rut_cli) as b
	on a.rut_cli = b.rut_cli
	and a.mes = b.fecha
	where a.mes = @fecha 

	--Actualiza Activo BG
	update dbo.gc_maestro2
	set act_bg = (case when b.movimiento >0 then 1 else 0 end)
	from dbo.gc_maestro2 a 
	left join
	(
		select		maes.rut_cli, sum(mov_bg) as Movimiento
		from		bancaempresas.dbo.gc_maestro2					maes
		left join	bancaempresas.[dbo].[gc_clientes_plazogestion]	plge
		ON			maes.Rut_cli	=	plge.rut_cli	
		--where		mes in (@fecha, dateadd(d,-1,dateadd(m,-1,dateadd(d,1,@fecha))), dateadd(d,-1,dateadd(m,-2,dateadd(d,1,@fecha)))
		--			, dateadd(d,-1,dateadd(m,-3,dateadd(d,1,@fecha))), dateadd(d,-1,dateadd(m,-4,dateadd(d,1,@fecha))))
		where		mes between	dateadd(d,-1,dateadd(m,-isnull(plazo_bg,4),dateadd(d,1,@fecha))) and @fecha
		group by	maes.rut_cli
	) as B
	on a.rut_cli = b.rut_cli 
	where a.mes = @fecha 

	--Actualiza Movimiento Factoring
	update dbo.gc_maestro2
	set mov_fact = (case when b.stock>0 then 1 else 0 end)
	from dbo.gc_maestro2 a
	left join 
	(
		select fecha, rut_cli, 'Factoring' as Tipo, sum(valor_actual_neto) as Stock  
		from dbo.fact_cartera
		group by fecha, rut_cli
	) as b
	on a.rut_cli = b.rut_cli
	and a.mes = b.fecha
	where a.mes = @fecha 

	--Actualiza Activo Factoring
	update dbo.gc_maestro2
	set act_fact = (case when b.movimiento >0 then 1 else 0 end)
	from dbo.gc_maestro2 a 
	left join
	(
		select		maes.rut_cli, sum(mov_fact) as Movimiento
		from		bancaempresas.dbo.gc_maestro2					maes
		left join	bancaempresas.[dbo].[gc_clientes_plazogestion]	plge
		ON			maes.Rut_cli	=	plge.rut_cli	
		--where		mes in (@fecha, dateadd(d,-1,dateadd(m,-1,dateadd(d,1,@fecha))), dateadd(d,-1,dateadd(m,-2,dateadd(d,1,@fecha)))
		--			, dateadd(d,-1,dateadd(m,-3,dateadd(d,1,@fecha))), dateadd(d,-1,dateadd(m,-4,dateadd(d,1,@fecha))))
		where		mes between	dateadd(d,-1,dateadd(m,-isnull(plazo_fact,4),dateadd(d,1,@fecha))) and @fecha
		group by	maes.rut_cli
	) as B
	on a.rut_cli = b.rut_cli 
	where a.mes = @fecha 

	--Actualiza Movimiento Leasing
	update dbo.gc_maestro2
	set mov_leas = (case when b.stock>0 then 1 else 0 end)
	from dbo.gc_maestro2 a
	left join 
	(
	select fecha, rut_cli, 'Leasing' as Tipo, sum(capital_vigente_ml) as Stock  
	from dbo.leasing_cartera
	group by fecha, rut_cli
	) as b
	on a.rut_cli = b.rut_cli
	and a.mes = b.fecha
	where a.mes = @fecha 

	--Actualiza Activo Leasing
	update dbo.gc_maestro2
	set act_leas = (case when b.movimiento >0 then 1 else 0 end)
	from dbo.gc_maestro2 a 
	left join
	(
		select		maes.rut_cli
					, sum(mov_leas) as Movimiento
		from		bancaempresas.dbo.gc_maestro2					maes
		left join	bancaempresas.[dbo].[gc_clientes_plazogestion]	plge
		ON			maes.Rut_cli	=	plge.rut_cli	
		--where		mes in (@fecha, dateadd(d,-1,dateadd(m,-1,dateadd(d,1,@fecha))), dateadd(d,-1,dateadd(m,-2,dateadd(d,1,@fecha)))
		--			, dateadd(d,-1,dateadd(m,-3,dateadd(d,1,@fecha))), dateadd(d,-1,dateadd(m,-4,dateadd(d,1,@fecha))))
		where		mes between	dateadd(d,-1,dateadd(m,-isnull(plazo_leas,4),dateadd(d,1,@fecha))) and @fecha
		group by	maes.rut_cli
	) as B
	on a.rut_cli = b.rut_cli 
	where a.mes = @fecha 

	--Actualiza Movimiento Mesa
	update dbo.gc_maestro2
	set mov_mesa = (case when b.stock>0 then 1 else 0 end)
	from dbo.gc_maestro2 a
	left join 
	(
		--select	dateadd(d,-day(dateadd(m,1,fecha)),dateadd(m,1,fecha)) as fecha
		--		, rut_cli, 'SPOT_FWD' as Tipo, sum(utilidad) as Stock
		--from	dbo.op_spotfwd
		--group by dateadd(d,-day(dateadd(m,1,fecha)),dateadd(m,1,fecha)), rut_cli
		select		@fecha	fecha
					,rut_cli, 'SPOT_FWD' as Tipo, sum(utilidad) as Stock
		from		dbo.op_spotfwd
		WHERE		@fecha	BETWEEN
					dateadd(d,-day(dateadd(m,1,fecha)),dateadd(m,1,fecha))	AND
					ISNULL(dateadd(d,-day(dateadd(m,1,fec_vencimiento)),dateadd(m,1,fec_vencimiento)),dateadd(d,-day(dateadd(m,1,fecha)),dateadd(m,1,fecha)))
		AND			@fecha	>=	'20180331'
		group by	rut_cli
		UNION
		select		dateadd(d,-day(dateadd(m,1,fecha)),dateadd(m,1,fecha)) as fecha
					, rut_cli, 'SPOT_FWD' as Tipo, sum(utilidad) as Stock
		from		dbo.op_spotfwd
		WHERE		@fecha 	<	'20180331'
		group by	dateadd(d,-day(dateadd(m,1,fecha)),dateadd(m,1,fecha)), rut_cli
	) as b
	on a.rut_cli = b.rut_cli
	and a.mes = b.fecha
	where a.mes = @fecha --'20161231' --

	--Actualiza Activo Mesa
	update dbo.gc_maestro2
	set act_mesa = (case when b.movimiento >0 then 1 else 0 end)
	from dbo.gc_maestro2 a 
	left join
	(
		select		maes.rut_cli, sum(mov_mesa) as Movimiento
		from		bancaempresas.dbo.gc_maestro2					maes
		left join	bancaempresas.[dbo].[gc_clientes_plazogestion]	plge
		ON			maes.Rut_cli	=	plge.rut_cli	
		--where		mes in (@fecha, dateadd(d,-1,dateadd(m,-1,dateadd(d,1,@fecha))), dateadd(d,-1,dateadd(m,-2,dateadd(d,1,@fecha)))
		--			, dateadd(d,-1,dateadd(m,-3,dateadd(d,1,@fecha))), dateadd(d,-1,dateadd(m,-4,dateadd(d,1,@fecha))))
		where		mes between	dateadd(d,-1,dateadd(m,-isnull(plazo_mesa,4),dateadd(d,1,@fecha))) and @fecha
		group by	maes.rut_cli
	) as B
	on a.rut_cli = b.rut_cli 
	where a.mes = @fecha 

	--Actualiza Movimiento DAP
	update dbo.gc_maestro2
	set mov_dap = (case when b.stock>0 then 1 else 0 end)
	from dbo.gc_maestro2 a
	left join 
	(
		select 
				dateadd(d,-day(dateadd(m,1,fecha_operacion)),dateadd(m,1,fecha_operacion)) as fecha
				,dateadd(d,-day(dateadd(m,1,fecha_vencimiento)),dateadd(m,1,fecha_vencimiento)) as fechav
				, rut_cliente as rut_cli
				, 'DAP' as Tipo
				, sum(interes_acumulado) as Stock 
		from	dbo.BSG_CARGA_DAP
		group by 
				dateadd(d,-day(dateadd(m,1,fecha_operacion)),dateadd(m,1,fecha_operacion))
				,dateadd(d,-day(dateadd(m,1,fecha_vencimiento)),dateadd(m,1,fecha_vencimiento))
				, rut_cliente
	) as b
	on a.rut_cli = b.rut_cli
	and	(
			(	a.mes = b.fecha AND a.mes < '20180228')
		OR
			(	a.mes  BETWEEN b.fecha AND fechav  AND a.mes >=	'20180228')
	)	/*where a.mes = 	(
					select max(fecha_operacion) 
					from dbo.BSG_CARGA_DAP
					where fecha_operacion in (@fecha, dateadd(d,-1,@fecha), dateadd(d,-2,@fecha), dateadd(d,-3,@fecha), dateadd(d,-4,@fecha)) 
					)*/



	--Actualiza Activo DAP
	update	dbo.gc_maestro2
	set		act_dap = (case when b.movimiento >	0 then 1 else 0 end)
	from	dbo.gc_maestro2 a 
	left join
	(
		select		maes.rut_cli, sum(mov_dap) as Movimiento
		from		bancaempresas.dbo.gc_maestro2					maes
		left join	bancaempresas.[dbo].[gc_clientes_plazogestion]	plge
		ON			maes.Rut_cli	=	plge.rut_cli	
		--where		mes in (@fecha, dateadd(d,-1,dateadd(m,-1,dateadd(d,1,@fecha))), dateadd(d,-1,dateadd(m,-2,dateadd(d,1,@fecha)))
		--			, dateadd(d,-1,dateadd(m,-3,dateadd(d,1,@fecha))), dateadd(d,-1,dateadd(m,-4,dateadd(d,1,@fecha))))
		where		mes between	dateadd(d,-1,dateadd(m,-isnull(plazo_dap,4),dateadd(d,1,@fecha))) and @fecha
		group by	maes.rut_cli
	) as B
	on a.rut_cli = b.rut_cli 
	where a.mes = @fecha 

	--Actualiza Cuenta Corriente
	update dbo.gc_maestro2
	set cta_cte = 1
	from dbo.gc_maestro2 a 
	inner join
	(select distinct cta_rut from dbo.SGH_CTACTE 
	where cta_estado in ('2', 'V')
	and cta_fechapro = convert(varchar(8),@fecha,112)
	) as B
	on a.rut_cli = b.cta_rut 
	where a.mes = @fecha 

	--Actualiza Columna Activo
	update dbo.gc_maestro2
	set Activo = (case when act_com+act_bg+act_fact+act_leas+act_comex+act_dap+act_mesa >= 1 then 1 else 0 end)
	where mes = @fecha
	--and act_com+act_bg+act_fact+act_leas+act_comex+act_dap+act_mesa >=1

	--Actualiza Columna Movimiento, Mono Producto MP y Número de Productos.
	update dbo.gc_maestro2
	set Movimiento = (case when mov_com+mov_bg+mov_fact+mov_leas+mov_comex+mov_dap+mov_mesa >= 1 then 1 else 0 end), 
	n_productos = mov_com+mov_bg+mov_fact+mov_leas+mov_comex+mov_dap+mov_mesa,
	mp = (case when mov_com+mov_bg+mov_fact+mov_leas+mov_comex+mov_dap+mov_mesa = 1 then 1 else 0 end)
	where mes = @fecha
	--and mov_com+mov_bg+mov_fact+mov_leas+mov_comex+mov_dap+mov_mesa >=1


	--Actualiza Columna Visitado
	--Visitas Directas
	UPDATE DBO.gc_maestro2
	SET VISITADO = 1
	where rut_cli in 
	(
		select		distinct rut_cli 
		from		dwh.dbo.visitas		vis
		LEFT JOIN	dwh.dbo.clientes	clie
		ON			clie.id	=	vis.id_cliente
		where	dateadd(d,-day(dateadd(m,1,convert(varchar(10),fec_realizacion,112))),dateadd(m,1,convert(varchar(10),fec_realizacion,112))) = @fecha
	)
	and mes = @fecha

	--Visitas Indirectas
	UPDATE DBO.gc_maestro2
	SET VISITADO = 1
	WHERE RUT_CLI IN (
		SELECT DISTINCT RUT_CLI 
		--FROM DBO.GC_CLIENTES
		FROM DBO.GC_CLIENTES
		WHERE CENTRO_DECISION IN (
			select	distinct centro_decision 
			--from dbo.gc_clientes
			FROM	DBO.GC_CLIENTES
			where	rut_cli in 
			(
				select		distinct rut_cli 
				from		dwh.dbo.visitas		vis
				LEFT JOIN	dwh.dbo.clientes	clie
				ON			clie.id	=	vis.id_cliente
				where	dateadd(d,-day(dateadd(m,1,convert(varchar(10),fec_realizacion,112))),dateadd(m,1,convert(varchar(10),fec_realizacion,112))) = @fecha
			)
			and centro_decision is not null
			)
		)
	AND MES  = @fecha 



	-------------------------------------------------------------------------------------------------------------
	/*
	declare @fecha date

	set @fecha = '20170731'

	select @fecha, dateadd(d,-1,dateadd(m,-1,dateadd(d,1,@fecha))), dateadd(d,-1,dateadd(m,-2,dateadd(d,1,@fecha))),dateadd(d,-1,dateadd(m,-3,dateadd(d,1,@fecha)))

	select *--distinct rut_cli, sum(visitado) as visitasU4M
	from dbo.gc_maestro2
	where mes in (@fecha, dateadd(d,-1,dateadd(m,-1,dateadd(d,1,@fecha))), dateadd(d,-1,dateadd(m,-2,dateadd(d,1,@fecha))),dateadd(d,-1,dateadd(m,-3,dateadd(d,1,@fecha))))
	and rut_cli in (76080944,76219381,76240074,76267416,76267423,76413914)
	group by rut_cli
	*/
	--Actualiza Columna Visitado U4M
	update dbo.gc_maestro2
	set Visitado_u4m = (case when visitasU4M >=1 then 1 else 0 end)
	from dbo.gc_maestro2 as a
	left join  
	(
	select rut_cli, sum(visitasU4M) as visitasU4M
	from 	(
		select distinct rut_cli, sum(visitado) as visitasU4M
		from dbo.gc_maestro2
		where mes in (@fecha, dateadd(d,-1,dateadd(m,-1,dateadd(d,1,@fecha))),dateadd(d,-1,dateadd(m,-2,dateadd(d,1,@fecha))),dateadd(d,-1,dateadd(m,-3,dateadd(d,1,@fecha))))
		group by rut_cli
	
		union all
	
		select		rut_cli, count(rut_cli) as  visitasU4M
		from		dwh.dbo.visitas		vis
		LEFT JOIN	dwh.dbo.clientes	clie
		ON			clie.id	=	vis.id_cliente
		where		dateadd(d,-day(dateadd(m,1,convert(varchar(10),fec_realizacion,112))),dateadd(m,1,convert(varchar(10),fec_realizacion,112))) in (@fecha, dateadd(d,-1,dateadd(m,-1,dateadd(d,1,@fecha))),dateadd(d,-1,dateadd(m,-2,dateadd(d,1,@fecha))),dateadd(d,-1,dateadd(m,-3,dateadd(d,1,@fecha))))
		group by	rut_cli
		) as A
	group by rut_cli
	) as B
	on a.rut_cli = b.rut_cli 
	where a.mes = @fecha
	--and a.rut_cli in (76080944,76219381,76240074,76267416,76267423,76413914)


	--Actualiza Recuperable
	update dbo.gc_maestro2
	set Recuperable = (case when b.rut_cli is not null then 1 else 0 end)
	from dbo.gc_maestro2 a 
	left join
	(select rut_cli
	from dbo.gc_maestro2 
	where mes in (dateadd(d,-1,dateadd(m,-1,dateadd(d,1,@fecha))), dateadd(d,-1,dateadd(m,-2,dateadd(d,1,@fecha)))
	, dateadd(d,-1,dateadd(m,-3,dateadd(d,1,@fecha))), dateadd(d,-1,dateadd(m,-4,dateadd(d,1,@fecha))))
	and activo >0
	group by rut_cli
	) as B
	on a.rut_cli = b.rut_cli 
	where a.mes = @fecha 
	--and a.activo = 0


	--Actualiza Fugado
	update dbo.gc_maestro2
	set fugado = (case when ACTIVO + RECUPERABLE = 0 then 1 else 0 end)
	WHERE MES = @fecha


	--Actualiza Recuperado
	update dbo.gc_maestro2
	set Recuperado = 1
	from dbo.gc_maestro2 a 
	inner join
	(select rut_cli
	from dbo.gc_maestro2 
	where mes in (dateadd(d,-1,dateadd(m,-1,dateadd(d,1,@fecha))))
	and activo = 0
	group by rut_cli
	) as B
	on a.rut_cli = b.rut_cli 
	where a.mes = @fecha 
	and a.activo = 1

	--Actualiza Nuevo
	update dbo.gc_maestro2
	set Nuevo = (case when isnull(b.activo,0)>=1 then 0 else 1 end)
	from dbo.gc_maestro2 a 
	inner join
	(select rut_cli, sum(activo) as activo
	from dbo.gc_maestro2 
	where mes < @fecha
	and activo = 1
	group by rut_cli
	) as B
	on a.rut_cli = b.rut_cli 
	where a.mes = @fecha 
	and a.activo = 1

	--Actualiza Recuperado
	update dbo.gc_maestro2
	set recuperado = (case when isnull(b.rut_cli,0)>0 then 1 else 0 end) 
	from dbo.gc_maestro2 a 
	inner join
	(
		select c.rut_cli
		from 
		(select rut_cli, sum(activo) as activoMesant
		from dbo.gc_maestro2 
		where mes = dateadd(d,-1,dateadd(m,-1,(dateadd(d,1,@fecha)))) 
		and activo = 0
		group by rut_cli
		) as C
		inner join 
		(select rut_cli as rutcli, sum(activo) as activomesesant
		from dbo.gc_maestro2 
		where mes < dateadd(d,-1,dateadd(m,-1,(dateadd(d,1,@fecha)))) 
		and activo = 1
		group by rut_cli
		) as D
		on c.rut_cli = d.rutcli
	) as B
	on a.rut_cli = b.rut_cli 
	where a.mes = @fecha 
	and a.activo = 1
	
END

GO


