--=================================
-- CONSULTA NOTAS
--=================================
select nota_fiscal, serie, cancelada, valor_tot, pk_notcad, cod_pac, nome_dest, ind_dest, tipo_nota, data_emiss, data_cancel from fanotcad
where nota_fiscal in
--('00048164','00009910','00028502','00048165','00047199','00009889','00009912','00009935','00009934')
(00017158 )
--and data_emiss >= '01/10/2019'
order by 1

--=================================
-- CONSULTA NOTAS CANCELADAS
--=================================
SELECT  distinct 'SISHOSP'              USERNAME,
                          'SISH'||FANOTCAD.NOTA_FISCAL Header_Txt,
                           FANOTCAD.PK_NOTCAD     CHAVE,
                           FANOTCAD.NOTA_FISCAL   NOTAFISCAL,
                           FANOTCAD.SERIE         SERIE,
                           FANOTCAD.DATA_EMISS    DATAEMISSAO,
                            NVL((SELECT DATA_VENCI FROM(SELECT FIRST 1 MAX(VALOR_TOT),DATA_VENCI FROM FAREMCAD WHERE NOTA_FIS = FANOTCAD.NOTA_FISCAL AND SERIE = FANOTCAD.SERIE  GROUP BY DATA_VENCI ORDER BY 1 DESC)
                           ), FANOTCAD.DATA_EMISS) AS  DATAVENCIMENTO,
                           NVL(FANOTCAD.VALOR_TOT,0)     VALORTOTAL,                                                      
                           FANOTCAD.COD_UNI       CODUNI,
                           FANOTCAD.CANCELADA     CANCELADA,
                           FANOTCAD.DATA_CANCEL   DATACANCELAMENTO,
                           nvl(faconcad.rsocial, fanotcad.NOME_DEST)     NOMEDESTINO,
                            nvl(faconcad.cgc, trim(fanotcad.CGC_DEST))     CGCDESTINO,
                           FANOTCAD.CODIFICACAO   CODIFICACAO ,
                           NVL(FANOTCAD.VALOR_ISS,0)     VALORISS,
                           AMUNICAD.CO_CORP_INTEGRACAO CODCORPORATIVO,
                           IMPOSTO.COD_IMP CodTributo,
                            NVL(FANOTCAD.VALOR_TOT,0) ValorBaseCalculo,
                            NVL(IMPOSTO.VALOR_IMP,0) ValorRetidoFonte,
                             (SELECT REMESSA FROM ( 
                          SELECT FIRST 1 MAX(VALOR_TOT),REMESSA FROM FAREMCAD WHERE NOTA_FIS = FANOTCAD.NOTA_FISCAL AND SERIE = FANOTCAD.SERIE  GROUP BY REMESSA ORDER BY 1 DESC)
                           ) REMESSA, 
                           FANOTCAD.COD_PAC CODPAC,
                           CASE WHEN FACONCAD.COD_CON IS NULL THEN 'P'
                                ELSE 'C' END INDICADESTINO,
                           'P' TIPONOTA --padrão
                      FROM FANOTCAD
                      INNER JOIN AMUNICAD ON FANOTCAD.COD_UNI = AMUNICAD.COD_UNI
                      LEFT JOIN IMPOSTO_NOTA IMPOSTO ON (IMPOSTO.NOTA_FISCAL = FANOTCAD.NOTA_FISCAL AND IMPOSTO.SERIE = FANOTCAD.SERIE)
                      LEFT JOIN FACONCAD ON ((FANOTCAD.COD_CON = FACONCAD.COD_CON or (FANOTCAD.COD_CON IS NULL AND FANOTCAD.CGC_DEST = FACONCAD.CGC )) AND FACONCAD.COD_CON_CORP <> '9999999' AND FANOTCAD.IND_DEST = 'C')
                      LEFT JOIN (SELECT MAX(A.VALOR_TOT), A.REMESSA, A.NOTA_FIS, A.SERIE, A.DATA_VENCI FROM FAREMCAD A  GROUP BY A.REMESSA, A.NOTA_FIS, A.SERIE, A.DATA_VENCI) FAREMCAD ON (FAREMCAD.NOTA_FIS = FANOTCAD.NOTA_FISCAL AND FAREMCAD.SERIE = FANOTCAD.SERIE)
                     WHERE AMUNICAD.CO_CORP_INTEGRACAO in (38458551,38578581) 
                     AND   (RTRIM(FANOTCAD.CODIFICACAO) IS NOT NULL AND FANOTCAD.CODIFICACAO <> ' ')  AND FANOTCAD.CANCELADA = 'S'  AND   FANOTCAD.DATA_CANCEL >= '01/10/2019' 
		     AND   FANOTCAD.NOTA_FISCAL in ('00048004','00048026','00048082','00048156','00048299','00048319','00048462')
			 
			 
			 
--=================================
-- CONSULTA COTACAO INTEGRADOR
--=================================			 
SELECT 
x1.PK_CONTROLE_PROC,
x3.Nu_Req_Sap, x3.Nu_Req_His,
CASE 
  WHEN x1.status = 'R' THEN 'Reprocessa' 
  WHEN x1.status = 'P' THEN 'Pendente' 
  WHEN x1.status = 'A' THEN 'Aguardando Retorno' 
  WHEN x1.status = 'E' THEN 'ERRO' 
  WHEN x1.status = 'I' THEN 'Inativo' 
  WHEN x1.status = 'C' THEN 'Cancelado' 
  WHEN x1.status = 'S' THEN 'SUCESSO' 
END AS status, x1.Ds_Mensagem, 
x3.Ds_Tprequisicao, x3.Sg_His, x4.ds_unidade, 
x1.Dh_Processamento

FROM SAP.TB_CONTROLE_PROCESSAMENTO x1, SAP.TB_TIPO_INTEGRACAO x2,
     SAP.TB_REQ_COMP x3, SAP.TB_UNIDADE x4
WHERE x2.Pk_Tp_Integra = x1.fk_tp_integra
AND x3.pk_reqcomp (+) = x1.fk_codigo
AND x4.co_corp_his = x3.co_corp_his (+)
AND x2.ds_tp_integra = 'REQUISIÇÃO DE COMPRA'
AND x1.DH_PROCESSAMENTO BETWEEN To_date('01/05/2020 00:00:00', 'DD/MM/YYYY HH24:MI:SS') AND To_date( '30/05/2020 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
AND x3.Nu_Req_His IN 
(
'081938' , '081939' , '081941'
)
ORDER BY x3.Nu_Req_His;

select * from SAP.TB_REQ_COMP where Nu_Req_His IN 
(
'019008'
)

select * from SAP.TB_CONTROLE_PROCESSAMENTO where fk_codigo in
(select pk_reqcomp from SAP.TB_REQ_COMP where Nu_Req_His IN 
(
'019008'
)) 
order by 3,6 desc

/*
SELECT * FROM SAP.TB_SAP_REQUEST_LOG
WHERE UPPER(CO_INTERFACE) = UPPER('RequisicaoCompra')
and DH_INCLUSAO BETWEEN To_date('01/10/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS') AND  To_date('30/10/2020 00:00:00', 'DD/MM/YYYY HH24:MI:SS') 
and fk_controle_proc = '140094517' order by 6 desc
*/

--select * from SAP.TB_CONTROLE_PROCESSAMENTO
--select * from SAP.TB_REQ_COMP where NU_REQ_HIS = '003334'
--select * from SAP.TB_REQ_COMP where pk_reqcomp = '2118'

--003334, 003315, 003311, 003301

--SOLICITACAO DE REPROCESSAMENTO
select * from SAP.TB_CONTROLE_PROCESSAMENTO where dh_processamento = '01/01/0001' and status = 'E'




select * from sap.TB_SAP_REQUEST_LOG
where resumo_post_data like '%5100000113%'

select * from sap.tb_fatura 
where 
--nr_documento_sap like '%4500005671%'
nr_nota_fiscal like '%21017%'

--SOLICITACAO DE REPROCESSAMENTO
select * from SAP.TB_CONTROLE_PROCESSAMENTO where dh_processamento = '01/01/0001' and status = 'E'

select * from sap.TB_SAP_REQUEST_LOG
where resumo_post_data like '%5100000113%'

select * from sap.tb_fatura 
where 
--nr_documento_sap like '%4500005671%'
nr_nota_fiscal like '%21017%'


-------------------------------
--CONSULTANDO COTACAO
-------------------------------
select 
esc.cod_cot                                             ,
esc.cod_uni                                             ,
esc.data_cadastro                                                 ,
esc.entrega                                                       ,
esc.sistema                                                       ,
case 
WHEN pro.cod_processo = 'ZETG' THEN 'ZETG - RC EST TRANS EMERG'
WHEN pro.cod_processo = 'ZETU' THEN 'ZETU - RC EST TRANS URG'
WHEN pro.cod_processo = 'ZOPX' THEN 'ZOPX - RC OPME EXTRA GRU'
WHEN pro.cod_processo = 'ZOPZ' THEN 'ZOPZ - RC OPME EXTRA GRU.UR'
WHEN pro.cod_processo = 'ZESZ' THEN 'ZESZ - RC ESTOQUE TRANSITOR'
WHEN pro.cod_processo = 'ZCSG' THEN 'ZCSG - RC CONSIGNAÇÃO'
WHEN pro.cod_processo = 'ZCST' THEN 'ZCST - RC CONSG TRANS'
WHEN pro.cod_processo = 'ZCSA' THEN 'ZCSA - RC CONSG TRANS AMIL'
WHEN pro.cod_processo = 'ZCSE' THEN 'ZCSE - RC CONSG TRANS EXTRA'
WHEN pro.cod_processo = 'ZETF' THEN 'ZETF - RC EST TRANS FORM'
WHEN pro.cod_processo = '0001' THEN '0001 - WPD'
WHEN pro.cod_processo = '0002' THEN '0002 - COMPLEMENTO'
WHEN pro.cod_processo = '1001' THEN '1001 - URGENTE'
WHEN pro.cod_processo = '1002' THEN '1002 - EMERGENCIA'
WHEN pro.cod_processo = '1003' THEN '1003 - COMPRA DIRETA'
ELSE NULL
END PROCESSO                                                      ,
esc.co_req_sap                                                    ,
esc.SN_INTEGRA                                                    ,
mot.pk_motcom                                      ,
mot.ds_motivo_compra                                              ,
mot.sn_ativo 
from escotcad esc
full join ti_ctr_requisicao
on ti_ctr_requisicao.cod_cot = esc.cod_cot
full join esprocad pro
on pro.cod_processo = esc.cod_processo
full join TB_MOTIVO_COMPRA mot
on esc.fk_motcom = mot.pk_motcom
where 
esc.cod_cot in
(
007352
)



--CONSULTANDO PRODUTO
select codigo, descricao, tipo_prd, bloqueado, cod_prd_corp, cod_corp_me  from faprdcad where codigo = '003301'

select * from escotcad where cod_cot = '003334'

select * from TB_MOTIVO_COMPRA

select * from rel_dic_campo where nome_campo like '%MOT%COM%'

select * from all_tab_columns where column_name like '%MOT%COM%'

select * from vw_cot_pedido 

select 'SISH' as CodigoSistema,
                        cot.cod_processo as TpRequisicao,
                        case when cot.cod_processo in ('ZETU','ZETG','ZOPZ','ZCSE','ZCSA') THEN ' ' else 'True' end AutoSuprimento,
                        ite.pk_cotite as NroItemHis,
                        ctrl.usuario as NomeRequisitante,
                        prod.cod_prd_corp as Material,
                        case when (cot.cod_uni is null) OR (cot.COD_UNI = '      ') then
                            (select amunicad.co_corp_integracao from amunicad where amunicad.co_corp_integracao is not null)
                        else
                (select amunicad.co_corp_integracao from amunicad where amunicad.cod_uni = cot.cod_uni) end Emp,
                        cot.cod_set Deposito,
                        cot.cod_cot as NroAcompanhamento,
                        CASE WHEN COT.COD_PROCESSO IN ('ZOPX', 'ZOPZ') THEN '1' ELSE 'K' END as ClassfContabil,
                        entregas.qt_produto as Quantidade,
                        entregas.DT_ENTRG_PROPOSTA as DtRemessa,
                        ite.preco_pra as Preco,
                        1 as Unidade,
                        'BR01' as OrgCompras,
                        (cot.fk_motcom-1000) as Urgente,
                        ' ' as Eliminado,
                        entregas.qt_produto as ClassifContabilQuantidade,
                        ' ' AS CentroCusto,
                        'B01' as Id_Texto_Header,
                        '*' as Form_Texto_Header,
                        CASE 
                                       WHEN opme.tp_apre_nota_sap = 'C' THEN 'Com Apresentação NF - ' 
                                       WHEN opme.tp_apre_nota_sap = 'S' THEN 'Sem Apresentação NF - '
                                       ELSE '' END
                                || cot.observacao as Line_Texto_Header,
                        'B03' as Id_Texto_Item,
                        '*' as Form_Texto_Item,
                        ite.observacao as Line_Texto_Item, 
                        rsv.data_inicial as DataCirurgia, 
                        rsv.hora_inicial as HoraCirurgia,
                        rsv.cod_rsv as CodigoReserva,
                        rsv.cod_rsv as CodigoPaciente, 
                        rsv.nome_pac as Paciente,
                        pront.cpf as CPF,
                        rsv.data_nasc as DtNasc,
                        trunc((months_between(sysdate, TRUNC(rsv.data_nasc)))/12) as Idade,
                        rsv.sexo as Sexo,
                        prof.nome_pro as  Medico,
                        prof.crm as CRM,
                        prof.uf_crm as UfCRM,
                        rsv.cod_rsv as CodInternacao, 
                        '' as CodProcedimento, 
                        '' as Procedimento,
                        opme.ds_forfab as Fabricante1,
                        opme.sn_liminar as Liminar,
                        opme.tp_processo as TipoProcesso,
                        (select fantasia from faconcad where faconcad.cod_con = rsv.cod_con) as NomeConvenio,
                        rsv.tp_cirurgia as TipoCirurgia,
                        opme.ds_tp_fat as TipoFaturamento, 
                        opme.ds_faturamento as Faturamento, 
                        opme.vl_opme as ValorPacote,
                        rsv.matricula as Matricula
                    from escotcad cot
                    inner join escotite ite on (cot.cod_cot = ite.cod_cot)
                    inner join ti_ctr_requisicao ctrl on (cot.cod_cot = ctrl.cod_cot)
                    inner join faprdcad prod on (prod.codigo = ite.cod_prd)
                    inner join tb_entr_planej_cot entregas on (ite.pk_cotite = entregas.fk_cotite)
                    left join rcrsvcad rsv on (rsv.cod_rsv = cot.fk_cod_rsv)                      
                    left join TB_RSV_OPME opme on (cot.fk_cod_rsv = opme.fk_cod_rsv)
                    left join faprocad prof on (prof.cod_pro = rsv.cod_pro)
                    left join faprtcad pront on (rsv.cod_prt = pront.cod_prt)
                    where cot.cod_cot = '003301'




select ite.cod_cot as cod_cot_processar
                    from escotcad cot
                    inner join escotite ite on (cot.cod_cot = ite.cod_cot)
                    inner join ti_ctr_requisicao ctrl on (cot.cod_cot = ctrl.cod_cot)
                    --inner join faprdcad prod on (prod.codigo = ite.cod_prd)
                    --inner join tb_entr_planej_cot entregas on (ite.pk_cotite = entregas.fk_cotite) 
                    order by 1
                    where (cot.sn_integra = 'S' or cot.cod_cot in ('0') )
                    
                            and ( cot.cod_uni is null 
                               or cot.cod_uni = '' 
                               or cot.cod_uni = (SELECT AMUNICAD.COD_UNI FROM AMUNICAD 
                                               WHERE AMUNICAD.co_corp_integracao = '1'))
                      
                    group by ite.cod_cot    
                    order by ite.cod_cot
                    

select * from escotcad where cod_cot in ('003301','003311','003315','003334') 
select * from escotite where cod_cot in ('003301','003311','003315','003334') 
select * from ti_ctr_requisicao where cod_cot in ('003301','003340') 
select * from TI_CTR_IT_REQUIS where fk_ticwmr = '29183'

select * from TI_CTR_PEDIDO     PED
inner join TI_CTR_IT_PEDIDO  ITPED
on PED.PK_TICPED = ITPED.FK_TICPED
where PED.DH_INCLUSAO BETWEEN To_date('01/08/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS') AND To_date( '30/10/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS')


select * from all_tab_columns where column_name like '%TICPED%'

select * from faprdcad where codigo in (712348,687907,712743,687716,688170,045802)

select cod_uni, sn_bloqueado from produto_unidade where codigo in (712348),001746,680273,001847,714627,001741)




SELECT cod_uni,nome_uni, co_corp_integracao FROM AMUNICAD

select * from escotite where cod_cot 

select * from tb_entr_planej_cot where fk_cotite in (select pk_cotite from escotite
where cod_cot in ('003301','003340'))

select * from faprdcad where codigo in (712348,001741) order by 1 desc

select * from ti_ctr_requisicao where  cod_cot in ('003301','003340')




SELECT 
x1.PK_CONTROLE_PROC,
x3.Nu_Req_Sap, x3.Nu_Req_His,
CASE 
  WHEN x1.status = 'R' THEN 'Reprocessa' 
  WHEN x1.status = 'P' THEN 'Pendente' 
  WHEN x1.status = 'A' THEN 'Aguardando Retorno' 
  WHEN x1.status = 'E' THEN 'ERRO' 
  WHEN x1.status = 'I' THEN 'Inativo' 
  WHEN x1.status = 'C' THEN 'Cancelado' 
  WHEN x1.status = 'S' THEN 'SUCESSO' 
END AS status, x1.Ds_Mensagem, 
x3.Ds_Tprequisicao, x3.Sg_His, x4.ds_unidade, 
x1.Dh_Processamento

FROM SAP.TB_CONTROLE_PROCESSAMENTO x1, SAP.TB_TIPO_INTEGRACAO x2,
     SAP.TB_REQ_COMP x3, SAP.TB_UNIDADE x4
WHERE x2.Pk_Tp_Integra = x1.fk_tp_integra
AND x3.pk_reqcomp (+) = x1.fk_codigo
AND x4.co_corp_his = x3.co_corp_his (+)
AND x2.ds_tp_integra = 'REQUISIÇÃO DE COMPRA'
AND x1.DH_PROCESSAMENTO BETWEEN To_date('01/08/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS') AND To_date( '30/10/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
AND x3.Nu_Req_His IN 
(
'007352'
)
ORDER BY x3.Nu_Req_His;

select * from SAP.TB_REQ_COMP where Nu_Req_His IN 
(
'007352'
)

select * from SAP.TB_CONTROLE_PROCESSAMENTO where fk_codigo in
(select pk_reqcomp from SAP.TB_REQ_COMP where Nu_Req_His IN 
(
007352
)) 
order by 3,6 desc

/*
SELECT * FROM SAP.TB_SAP_REQUEST_LOG
WHERE UPPER(CO_INTERFACE) = UPPER('RequisicaoCompra')
and DH_INCLUSAO BETWEEN To_date('01/10/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS') AND  To_date('30/10/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS') 
and fk_controle_proc = '250731360' order by 6 desc
*/

--select * from SAP.TB_CONTROLE_PROCESSAMENTO
--select * from SAP.TB_REQ_COMP where NU_REQ_HIS = '003334'
--select * from SAP.TB_REQ_COMP where pk_reqcomp = '2118'

--003334, 003315, 003311, 003301

--SOLICITACAO DE REPROCESSAMENTO
select * from SAP.TB_CONTROLE_PROCESSAMENTO where dh_processamento = '01/01/0001' and status = 'E'




select * from sap.TB_SAP_REQUEST_LOG
where resumo_post_data like '%5100000113%'

select * from sap.tb_fatura 
where 
--nr_documento_sap like '%4500005671%'
nr_nota_fiscal like '%21017%'










select * from SAP.TB_REQ_COMP
where nu_req_his 
in (
003891	,
003905	,
004818	,
006513	,
007734	,
007757	,
016898	,
037722	,
046264	,
056847	,
056853	,
076629	,
076712	,
076740	,
190800	,
291640	
) 

select * from SAP.TB_REQ_COMPRA_ITEM
where FK_REQCOMP IN
(select PK_REQCOMP from SAP.TB_REQ_COMP
where nu_req_his 
in (
003891	,
003905	,
004818	,
006513	,
007734	,
007757	,
016898	,
037722	,
046264	,
056847	,
056853	,
076629	,
076712	,
076740	,
190800	,
291640	
) 
)








--==============================
-- POR COD_CORP
--==============================
select pu.cod_uni, u.nome_uni, p.codigo cod_prd, p.descricao, p.tipo_prd, p.bloqueado bloqueado_prd, pu.sn_bloqueado sn_bloqueado_uni, p.prd_lib prd_lib_prd, pu.prd_lib prd_lib_uni, cod_prd_corp, co_tuss
from produto_unidade pu
left join amunicad u
on pu.cod_uni = u.cod_uni
right join faprdcad p
on pu.codigo = p.codigo
where p.cod_prd_corp in
(
1000001673
) 
order by 1,3;

--==============================
-- POR CODIDO DO PRODUTO
--==============================
select pu.cod_uni, u.nome_uni, p.codigo cod_prd, p.descricao, p.tipo_prd, p.bloqueado bloqueado_prd, pu.sn_bloqueado sn_bloqueado_uni, p.prd_lib prd_lib_prd, pu.prd_lib prd_lib_uni, cod_prd_corp, co_tuss
from produto_unidade pu
left join amunicad u
on pu.cod_uni = u.cod_uni
right join faprdcad p
on pu.codigo = p.codigo
where p.codigo in
(
'001355',
'000806') 
order by 1,3;

--update faprdcad set prd_lib = 'S' where codigo in('307447','307321','307511')

--==============================
-- PRODUTO UNIDADE POR PRODUTO
--==============================
select pu.cod_uni, u.nome_uni, pu.codigo, pu.sn_bloqueado, pu.prd_lib from produto_unidade pu
inner join amunicad u
on pu.cod_uni = u.cod_uni
where codigo in
(
'148203',
'705637',
'705732',
'055948',
'691994',
'163334',
'694087',
'136366',
'056358'
)
order by 1

--update produto_unidade set prd_lib = 'S' where codigo in('307447','307321','307511') and cod_uni = 'HCJ'

-------------------------------
--CONSULTANDO COTACAO
-------------------------------
select 
esc.cod_cot                                             ,
esc.cod_uni                                             ,
esc.data_cadastro                                                 ,
esc.entrega                                                       ,
esc.sistema                                                       ,
case 
WHEN pro.cod_processo = 'ZETG' THEN 'ZETG - RC EST TRANS EMERG'
WHEN pro.cod_processo = 'ZETU' THEN 'ZETU - RC EST TRANS URG'
WHEN pro.cod_processo = 'ZOPX' THEN 'ZOPX - RC OPME EXTRA GRU'
WHEN pro.cod_processo = 'ZOPZ' THEN 'ZOPZ - RC OPME EXTRA GRU.UR'
WHEN pro.cod_processo = 'ZESZ' THEN 'ZESZ - RC ESTOQUE TRANSITOR'
WHEN pro.cod_processo = 'ZCSG' THEN 'ZCSG - RC CONSIGNAÇÃO'
WHEN pro.cod_processo = 'ZCST' THEN 'ZCST - RC CONSG TRANS'
WHEN pro.cod_processo = 'ZCSA' THEN 'ZCSA - RC CONSG TRANS AMIL'
WHEN pro.cod_processo = 'ZCSE' THEN 'ZCSE - RC CONSG TRANS EXTRA'
WHEN pro.cod_processo = 'ZETF' THEN 'ZETF - RC EST TRANS FORM'
WHEN pro.cod_processo = '0001' THEN '0001 - WPD'
WHEN pro.cod_processo = '0002' THEN '0002 - COMPLEMENTO'
WHEN pro.cod_processo = '1001' THEN '1001 - URGENTE'
WHEN pro.cod_processo = '1002' THEN '1002 - EMERGENCIA'
WHEN pro.cod_processo = '1003' THEN '1003 - COMPRA DIRETA'
ELSE NULL
END PROCESSO                                                      ,
esc.co_req_sap                                                    ,
esc.SN_INTEGRA                                                    ,
mot.pk_motcom                                      ,
mot.ds_motivo_compra                                              ,
mot.sn_ativo 
from escotcad esc
full join ti_ctr_requisicao
on ti_ctr_requisicao.cod_cot = esc.cod_cot
full join esprocad pro
on pro.cod_processo = esc.cod_processo
full join TB_MOTIVO_COMPRA mot
on esc.fk_motcom = mot.pk_motcom
where 
esc.cod_cot in
(
'033369','033370'
)	

-------------------------------------------
--CONSULTANDO COTACAO QUERY INTEGRADOR
-------------------------------------------
select 'SISH' as CodigoSistema,
                        cot.cod_processo as TpRequisicao,
                        case when cot.cod_processo in ('ZETU','ZETG','ZOPZ','ZCSE','ZCSA') THEN ' ' else 'True' end AutoSuprimento,
                        ite.pk_cotite as NroItemHis,
                        ctrl.usuario as NomeRequisitante,
                        prod.cod_prd_corp as Material,
                        case when (cot.cod_uni is null or cot.cod_uni = '') then
                            (select co_corp_integracao from amunicad where cod_uni in (SELECT cod_unidade FROM FACELCAD  where cod_cel in (select cod_cel from fasetcad where cod_set = cot.cod_set)))
                        else
                (select amunicad.co_corp_integracao from amunicad where amunicad.cod_uni = cot.cod_uni) end Emp,
                        cot.cod_set Deposito,
                        cot.cod_cot as NroAcompanhamento,
                        CASE WHEN COT.COD_PROCESSO IN ('ZOPX', 'ZOPZ') THEN '1' ELSE 'K' END as ClassfContabil,
                        entregas.qt_produto as Quantidade,
                        entregas.DT_ENTRG_PROPOSTA as DtRemessa,
                        ite.preco_pra as Preco,
                        1 as Unidade,
                        'BR01' as OrgCompras,
                        (cot.fk_motcom-1000) as Urgente,
                        ' ' as Eliminado,
                        entregas.qt_produto as ClassifContabilQuantidade,
                        ' ' AS CentroCusto,
                        'B01' as Id_Texto_Header,
                        '*' as Form_Texto_Header,
                        CASE 
                                                                           WHEN opme.tp_apre_nota_sap = 'C' THEN 'Com ApresentaÃ§Ã£o NF - ' 
                                                                           WHEN opme.tp_apre_nota_sap = 'S' THEN 'Sem ApresentaÃ§Ã£o NF - '
                                                                           ELSE '' END
                                                           || cot.observacao as Line_Texto_Header,
                        'B03' as Id_Texto_Item,
                        '*' as Form_Texto_Item,
                        ite.observacao as Line_Texto_Item, 
                        rsv.data_inicial as DataCirurgia, 
                        rsv.hora_inicial as HoraCirurgia,
                        rsv.cod_rsv as CodigoReserva,
                        rsv.cod_rsv as CodigoPaciente, 
                        rsv.nome_pac as Paciente,
                        pront.cpf as CPF,
                        rsv.data_nasc as DtNasc,
                        (((DATE (current) - DATE (data_nasc)) UNITS YEAR)/365) as Idade,
                        rsv.sexo as Sexo,
                        prof.nome_pro as  Medico,
                        prof.crm as CRM,
                        prof.uf_crm as UfCRM,
                        rsv.cod_rsv as CodInternacao, 
                        '' as CodProcedimento, 
                        '' as Procedimento,
                        opme.ds_forfab as Fabricante1,
                        opme.sn_liminar as Liminar,
                        opme.tp_processo as TipoProcesso,
                        (select fantasia from faconcad where faconcad.cod_con = rsv.cod_con) as NomeConvenio,
                        rsv.tp_cirurgia as TipoCirurgia,
                        opme.ds_tp_fat as TipoFaturamento, 
                        opme.ds_faturamento as Faturamento, 
                        opme.vl_opme as ValorPacote,
                        rsv.matricula as Matricula                    
                    from escotcad cot
                    inner join escotite ite on (cot.cod_cot = ite.cod_cot)
                    inner join ti_ctr_requisicao ctrl on (cot.cod_cot = ctrl.cod_cot)
                    inner join faprdcad prod on (prod.codigo = ite.cod_prd)
                    inner join tb_entr_planej_cot entregas on (ite.pk_cotite = entregas.fk_cotite)
                    left join rcrsvcad rsv on (rsv.cod_rsv = cot.fk_cod_rsv)                      
                    left join TB_RSV_OPME opme on (cot.fk_cod_rsv = opme.fk_cod_rsv)
                    left join faprocad prof on (prof.cod_pro = rsv.cod_pro)
                    left join faprtcad pront on (rsv.cod_prt = pront.cod_prt)
                    where cot.cod_cot = '033369';
					
					
--==========================================
-- ITENS DA COTACAO
--==========================================
SELECT ESCOTITE.PK_COTITE, ESCOTITE.COD_PRD, FAPRDCAD.DESCRICAO, FAPRDCAD.TIPO_PRD, FAPRDCAD.PRD_LIB, FAPRDCAD.BLOQUEADO, FAPRDCAD.COD_PRD_CORP, ESCOTITE.FATOR, ESCOTITE.QUANT, ESCOTITE.PRECO_PRA,  ESCOTITE.COD_FABRICANTE,
ESFABRICANTE.NOME, ESCOTITE.VALOR, ESCOTITE.OBSERVACAO OBSERVACAO_ITEM,  ESCOTCAD.COD_COT, ESCOTCAD.COD_FOR, 
 ESCOTCAD.VALIDADE, ESCOTCAD.ENTREGA,  ESCOTCAD.OBSERVACAO, ESCOTCAD.COD_PAG, 
 ESCOTCAD.PRAZO_ENT, ESCOTCAD.TIPO_FRETE, ESCOTCAD.COD_UNI, FAPRDCAD.CUSTO_ATU,
(ESCOTITE.QUANT * FAPRDCAD.CUSTO_ATU) VALOR_TOT, ESCOTITE.FK_MOTCOM  
FROM ESCOTCAD , ESCOTITE, FAPRDCAD, OUTER(ESFABRICANTE) 
WHERE ESCOTCAD.COD_COT in 
('033369','033370')
AND (ESCOTCAD.IND_COTACAO_SAL = 0 OR ESCOTCAD.IND_COTACAO_SAL IS NULL)  AND (ESCOTCAD.COD_FOR = '' OR ESCOTCAD.COD_FOR = ' ') 
AND ESCOTITE.COD_COT = ESCOTCAD.COD_COT  AND ESCOTITE.COD_FOR = ESCOTCAD.COD_FOR  AND FAPRDCAD.CODIGO  = ESCOTITE.COD_PRD  AND ESCOTITE.COD_FABRICANTE = ESFABRICANTE.COD_FABRICANTE  
ORDER BY FAPRDCAD.DESCRICAO,ESCOTITE.COD_PRD,  
ESCOTITE.QUANT, ESCOTITE.PRECO_PRA,  ESCOTITE.COD_FABRICANTE, ESCOTITE.VALOR, 
ESCOTCAD.COD_COT, ESCOTCAD.COD_FOR,  ESCOTCAD.VALIDADE, ESCOTCAD.ENTREGA, 
ESCOTCAD.OBSERVACAO, ESCOTCAD.COD_PAG, 
ESCOTCAD.PRAZO_ENT, ESCOTCAD.TIPO_FRETE


--===================================
-- PRODUTOS NA COTACAO
--===================================
SELECT DISTINCT ESCOTCAD.COD_COT, ESCOTITE.PK_COTITE, ESCOTITE.COD_PRD, FAPRDCAD.DESCRICAO, FAPRDCAD.TIPO_PRD, FAPRDCAD.PRD_LIB, FAPRDCAD.BLOQUEADO, FAPRDCAD.COD_PRD_CORP, 
PRODUTO_UNIDADE.PRD_LIB as LIB_UNIDADE,PRODUTO_UNIDADE.SN_BLOQUEADO as BLOQ_UNIDADE,
ESCOTITE.FATOR, ESCOTITE.QUANT, ESCOTITE.PRECO_PRA,  ESCOTITE.COD_FABRICANTE,
ESFABRICANTE.NOME, ESCOTITE.VALOR, ESCOTITE.OBSERVACAO OBSERVACAO_ITEM,   ESCOTCAD.COD_FOR, 
 ESCOTCAD.VALIDADE, ESCOTCAD.ENTREGA,  ESCOTCAD.OBSERVACAO, ESCOTCAD.COD_PAG, 
 ESCOTCAD.PRAZO_ENT, ESCOTCAD.TIPO_FRETE, ESCOTCAD.COD_UNI, FAPRDCAD.CUSTO_ATU,
(ESCOTITE.QUANT * FAPRDCAD.CUSTO_ATU) VALOR_TOT, ESCOTITE.FK_MOTCOM  
FROM ESCOTCAD , ESCOTITE, FAPRDCAD, OUTER(ESFABRICANTE),OUTER(PRODUTO_UNIDADE)
WHERE ESCOTCAD.COD_COT = 

--== COTACAO
 '018980'  
--==

AND (ESCOTCAD.IND_COTACAO_SAL = 0 OR ESCOTCAD.IND_COTACAO_SAL IS NULL)  AND (ESCOTCAD.COD_FOR = '' OR ESCOTCAD.COD_FOR = ' ') 
AND ESCOTITE.COD_COT = ESCOTCAD.COD_COT  AND ESCOTITE.COD_FOR = ESCOTCAD.COD_FOR  AND FAPRDCAD.CODIGO  = ESCOTITE.COD_PRD  AND ESCOTITE.COD_FABRICANTE = ESFABRICANTE.COD_FABRICANTE  
AND PRODUTO_UNIDADE.CODIGO = FAPRDCAD.CODIGO
ORDER BY FAPRDCAD.DESCRICAO,ESCOTITE.COD_PRD,  
ESCOTITE.QUANT, ESCOTITE.PRECO_PRA,  ESCOTITE.COD_FABRICANTE, ESCOTITE.VALOR, 
ESCOTCAD.COD_COT, ESCOTCAD.COD_FOR,  ESCOTCAD.VALIDADE, ESCOTCAD.ENTREGA, 
ESCOTCAD.OBSERVACAO, ESCOTCAD.COD_PAG, 
ESCOTCAD.PRAZO_ENT, ESCOTCAD.TIPO_FRETE

--===================================
-- TIPO DE PRODUTOS NA COTACAO
--===================================
select distinct tipo_prd from faprdcad where codigo in
(select cod_prd from escotite
where 
cod_cot in
(
019036
)	
);

--==========================================
-- CONSULTANDO TIPO DE PRODUTO NO PARAMETRO
--==========================================
select * from wpdtab where descricao like '%Integração SAP: Tipo de Produtos%'


--==========================================
-- CONSULTANDO PEDIDO
--==========================================
SELECT ESMOVCAD.DOCUMENTO, ESMOVCAD.SISTEMA, ESMOVCAD.SET_EST,  ESMOVCAD.PEND_SIT_MOT,  TO_CHAR(ESMOVCAD.DATA_MOV) DATA_MOV, 
TO_CHAR(ESMOVCAD.DAT_ENT) DAT_ENT,  ESMOVCAD.COD_FOR,  ESFORCAD.FANTASIA,  ESFORCAD.RSOCIAL,  PEDIDO_M2M.PEDIDO_M2M,  ESMOVCAD.COD_PEDIDO_ME,  ESMOVCAD.FK_COD_ESPECIE,  
DECODE(ESMOVCAD.SN_PED_FAT_CONSIG,'S','Faturamento','N',DECODE(NVL(ESPECIE_NOTA.FK_ESNFCG,0), 0, 'N.o','Reposi..o')) SN_PED_FAT_CONSIG,
  ESPECIE_NOTA.DESC_ESPECIE,  ESMOVCAD.COD_AUX 
 FROM ESMOVCAD,  OUTER(ESPECIE_NOTA)  , OUTER(ESFORCAD) , OUTER(FASETCAD) ,  OUTER(PEDIDO_M2M) WHERE 1 = 1 
 AND ESMOVCAD.DOCUMENTO = PEDIDO_M2M.DOCUMENTO  AND ESMOVCAD.COD_FOR = ESFORCAD.COD_FOR  AND ESMOVCAD.SET_EST = FASETCAD.COD_SET 
 AND ESMOVCAD.TIPO_DOCUMENTO = 'PED'  AND ESMOVCAD.FK_COD_ESPECIE = ESPECIE_NOTA.COD_ESPECIE  
--AND ESMOVCAD.DOCUMENTO = '0019036'
 ORDER BY ESMOVCAD.DOCUMENTO DESC





--==========================================
-- CONSULTANDO REQUISICAO
--==========================================
select * from ti_ctr_requisicao
where 
cod_cot in
(
046264
)











--=============================
-- INTEGRADOR
--==============================
--================================
-- CONSULTAS NOTAS A RECEBER
--================================
select UN.DS_UNIDADE,TR.PK_TIT_RECEB,TR.SG_HIS,
TR.NOTA_FISCAL, TR.SERIE, TR.SN_CANCELADA,TR.VL_TOTAL,   TR.CHAVE_HIS, TR.CO_PAC, TR.NM_DESTINO, TR.IND_DESTINO, TR.TP_NOTA, TR.DT_EMISSAO, TR.DT_CANCELAMENTO,TR.NR_DOCUMENTO_SAP,TR.CO_CHAVE_ENVIO_SAP,TR.CO_CLIENTE_SAP   from sap.TB_TITULOS_RECEBER TR
inner join sap.TB_UNIDADE UN
on TR.CO_CORP_HIS = UN.CO_CORP_HIS
--where nota_fiscal in ('00048026','00048082','00048156','00048299','00048319','00048462','00048004','00048164','00009910','00028502','00048165','00047199','00009889','00009912','00009935','00009934')
where nota_fiscal in ('00048004','00048026','00048082','00048156','00048299','00048319','00048462')
and SERIE in ('HSSU','HVSU')
ORDER BY TR.NOTA_FISCAL;

select * from SAP.TB_TITULOS_RECEBER

--query que consulta as notas no his e popula no integrador


select * from SAP.TB_NOTA_FISCAL where nu_nota like '%48082%'


SELECT * 
FROM SAP.TB_SAP_REQUEST_LOG  
WHERE resumo_post_data like '%SISH00048156%'  
--WHERE response_data like '%SISH00048156%'  
order by dh_inclusao desc  

select * from sap.TB_CONTROLE_PROCESSAMENTO
where pk_controle_proc = '5602761'


Select t.nota_fiscal, t.cgc_destino, t.co_chave_envio_sap, t.nr_documento_sap, p.status,
p.ds_mensagem, p.dh_processamento, p.pk_controle_proc
from SAP.TB_TITULOS_RECEBER t
JOIN SAP.Tb_Controle_Processamento p
on p.fk_codigo = t.pk_tit_receb
where t.nota_fiscal like '%48004%' 
order by 7 desc
 
SELECT * FROM sap.tb_titulos_receber WHERE nota_fiscal like '%48082%' 

SELECT * FROM sap.tb_split_contabil WHERE ds_texto_header like '%48082%'  


SELECT * 
FROM SAP.TB_SAP_REQUEST_LOG 
WHERE resumo_post_data like '%SISH00048026%'  
--WHERE response_data like '%SISH00048026%'  
order by dh_inclusao desc   

select * from sap.TB_PEDIDO_COMPRAS where co_codigo_sap = '4500004544'

SELECT fat.PK_FATURA,FAT.CO_CORP_HIS,FAT.co_fornec_sap,FAT.nr_nota_fiscal,FAT.nr_ordem_compra,FAT.nr_documento_sap, FAT.nr_fatura_his, FAT.nr_devolucao_sap
                               ,CON.DS_MENSAGEM,CON.STATUS,CON.dh_processamento,CON.pk_controle_proc
                               FROM SAP.TB_FATURA FAT
                               INNER JOIN SAP.TB_CONTROLE_PROCESSAMENTO CON ON (CON.FK_CODIGO = FAT.PK_FATURA) 
                               WHERE 
                               CON.FK_TP_INTEGRA = 10 AND 
                               --FAT.NR_DOCUMENTO_SAP = '5000000799' AND 
                               FAT.nr_nota_fiscal like '%49094%'                                
                               ORDER BY CON.pk_controle_proc DESC      

select * from sap.tb_fatura where nr_nota_fiscal like '%49094%'

/*
SELECT * FROM SAP.TB_SAP_REQUEST_LOG
WHERE CO_INTERFACE in ('InterfaceCRCP','IntegracaoCRCP')
and DH_INCLUSAO BETWEEN To_date('01/10/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS') AND  To_date('31/12/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS') 
and fk_controle_proc = '5160913' order by 6 desc
*/

select * from SAP.TB_CLIENTE
where NO_CLIENTE Like '%JONATHAN LUGI%';
select * from SAP.TB_CLIENTE
where NO_CLIENTE Like '%ALEXANDRE LEAL GOMES%';



select * from all_tables where owner = 'SAP'
order by 2






SELECT 
x1.PK_CONTROLE_PROC,
x3.Nu_Req_Sap, x3.Nu_Req_His,
CASE 
  WHEN x1.status = 'R' THEN 'Reprocessa' 
  WHEN x1.status = 'P' THEN 'Pendente' 
  WHEN x1.status = 'A' THEN 'Aguardando Retorno' 
  WHEN x1.status = 'E' THEN 'ERRO' 
  WHEN x1.status = 'I' THEN 'Inativo' 
  WHEN x1.status = 'C' THEN 'Cancelado' 
  WHEN x1.status = 'S' THEN 'SUCESSO' 
END AS status, x1.Ds_Mensagem, 
x3.Ds_Tprequisicao, x3.Sg_His, x4.ds_unidade, 
x1.Dh_Processamento

FROM SAP.TB_CONTROLE_PROCESSAMENTO x1, SAP.TB_TIPO_INTEGRACAO x2,
     SAP.TB_REQ_COMP x3, SAP.TB_UNIDADE x4
WHERE x2.Pk_Tp_Integra = x1.fk_tp_integra
AND x3.pk_reqcomp (+) = x1.fk_codigo
AND x4.co_corp_his = x3.co_corp_his (+)
AND x2.ds_tp_integra = 'REQUISIÇÃO DE COMPRA'
AND x1.DH_PROCESSAMENTO BETWEEN To_date('01/08/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS') AND To_date( '30/10/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
AND x3.Nu_Req_His IN 
(
018980 
)
ORDER BY x3.Nu_Req_His;

select * from SAP.TB_REQ_COMP where Nu_Req_His IN 
(
018980
)

select * from SAP.TB_CONTROLE_PROCESSAMENTO where fk_codigo in
(select pk_reqcomp from SAP.TB_REQ_COMP where Nu_Req_His IN 
(
018980 
)) 
order by 3,6 desc

/*
SELECT * FROM SAP.TB_SAP_REQUEST_LOG
WHERE UPPER(CO_INTERFACE) = UPPER('RequisicaoCompra')
and DH_INCLUSAO BETWEEN To_date('01/10/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS') AND  To_date('30/10/2020 00:00:00', 'DD/MM/YYYY HH24:MI:SS') 
and fk_controle_proc = '121946426' order by 6 desc
*/

--select * from SAP.TB_CONTROLE_PROCESSAMENTO
--select * from SAP.TB_REQ_COMP where NU_REQ_HIS = '003334'
--select * from SAP.TB_REQ_COMP where pk_reqcomp = '2118'

--003334, 003315, 003311, 003301

--SOLICITACAO DE REPROCESSAMENTO
select * from SAP.TB_CONTROLE_PROCESSAMENTO where dh_processamento = '01/01/0001' and status = 'E'




select * from sap.TB_SAP_REQUEST_LOG
where resumo_post_data like '%5100000113%'

select * from sap.tb_fatura 
where 
--nr_documento_sap like '%4500005671%'
nr_nota_fiscal like '%21017%'










SELECT 
x1.PK_CONTROLE_PROC,
x3.Nu_Req_Sap, x3.Nu_Req_His, x2.ds_tp_integra,
CASE 
  WHEN x1.status = 'R' THEN 'Reprocessa' 
  WHEN x1.status = 'P' THEN 'Pendente' 
  WHEN x1.status = 'A' THEN 'Aguardando Retorno' 
  WHEN x1.status = 'E' THEN 'ERRO' 
  WHEN x1.status = 'I' THEN 'Inativo' 
  WHEN x1.status = 'C' THEN 'Cancelado' 
  WHEN x1.status = 'S' THEN 'SUCESSO' 
END AS status, x1.Ds_Mensagem, 
x3.Ds_Tprequisicao, x3.Sg_His, x4.ds_unidade, 
x1.Dh_Processamento
FROM SAP.TB_CONTROLE_PROCESSAMENTO x1, SAP.TB_TIPO_INTEGRACAO x2, SAP.TB_REQ_COMP x3, SAP.TB_UNIDADE x4
WHERE x2.Pk_Tp_Integra = x1.fk_tp_integra
AND x3.pk_reqcomp (+) = x1.fk_codigo
AND x4.co_corp_his = x3.co_corp_his (+)
AND x2.pk_tp_integra = '7'
AND x1.DH_PROCESSAMENTO BETWEEN To_date('01/08/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS') 
AND To_date( '30/10/2019 23:59:59', 'DD/MM/YYYY HH24:MI:SS')
AND x3.Nu_Req_His in
(
003891  ,
003905  ,
004818  ,
006513  ,
007734  ,
007757  ,
016898  ,
037722  ,
046264  ,
056847  ,
056853  ,
076629  ,
076712  ,
076740  ,
190800  ,
291640  
)
ORDER BY x4.ds_unidade, x3.Nu_Req_His


select * from SAP.TB_CONTROLE_PROCESSAMENTO

select 'update SAP.TB_REQ_COMP set NU_REQ_HIS' from SAP.TB_REQ_COMP
select * from SAP.TB_REQ_COMP

TABELA DE ITEM

where NU_REQ_HIS in
(
003891  ,
003905  ,
004818  ,
006513  ,
007734  ,
007757  ,
016898  ,
037722  ,
046264  ,
056847  ,
056853  ,
076629  ,
076712  ,
076740  ,
190800  ,
291640  
)


--========================================
-- FABRICANTE INATIVO
--========================================
--========================================
-- PESQUISA POR CODIGO DO PRODUTO
--========================================
select codigo, descricao, tipo_prd, prd_lib, bloqueado, cod_prd_corp, cod_corp_me  from faprdcad 
where codigo in
('647127'),'001121')

--=============================================
-- PESQUISA POR CODIGO CORPORATIVO DO PRODUTO
--=============================================
select codigo, descricao, tipo_prd, prd_lib, bloqueado, cod_prd_corp, cod_corp_me  from faprdcad 
where cod_prd_corp in
('1000009644'),'1000001101')


--=============================================
-- VERIFICA A TABELA DE PRODUTO FABRICANTE
--=============================================
select * from tb_prod_fabricante where uk_cod_prd_corp in
('1000001530','1000001101')

--=============================================
-- VERIFICA A TABELA DE FABRICANTE
--=============================================
select * from esfabricante where cod_fabricante in ('022692','013122') 

--=============================================
-- PROCURA VINCULO PRODUTO x FABRICANTE
--=============================================
select * from tb_prod_fabricante where uk_cod_prd_corp = '1000001530' and fuk_cod_fabricante = '012904'


--=============================================
-- REALIZAR O UPDATE SE O REGISTRO EXISTIR
--=============================================
--update tb_prod_fabricante set SN_INATIVO = 'N' where uk_cod_prd_corp = '1000001530' and fuk_cod_fabricante = '022692'

--=============================================
-- INSERIR UM NOVO REGISTRO, SE NAO EXISTIR
--=============================================
insert into tb_prod_fabricante (fuk_cod_fabricante, uk_cod_prd_corp, sn_inativo) 
values ('012904','1000001186', 'N')


--=============================================
-- DESBLOQUEIO ESLOTE VALIDADE
--=============================================
select cod_prd, lote, validade, sn_bloqueado 
from eslote_validade
where cod_prd in('000785')
and lote = '24384201'

update eslote_validade set SN_BLOQUEADO = 'N'
where cod_prd in('000785')
and lote = '24384201'




--===========
-- DECODE
--===========
update esestcad
set est_atu = 2,
CONTROLE = DECODE(CONTROLE,'0','1','0')
where cod_prd = '630126'
and cod_set = '0088'


--==============
-- DESBLOQUEIO
--==============
select pu.cod_uni, u.nome_uni, p.codigo codigo, cod_prd_corp, p.descricao, p.tipo_prd, p.cod_apresent, p.bloqueado bloqueado_prd, pu.sn_bloqueado sn_bloqueado_uni, p.prd_lib prd_lib_prd, pu.prd_lib prd_lib_uni,  co_tuss
from produto_unidade pu
left join amunicad u
on pu.cod_uni = u.cod_uni
right join faprdcad p
on pu.codigo = p.codigo
where p.codigo in
(
063544,
125226
) 
--and u.cod_uni = 'HSP'
order by 1,3;

update faprdcad set bloqueado = 'N'
where codigo in
(
063544,
125226
);


--==============
--REMESSA
--==============
select remessa, data_venci from faremcad
where remessa in
(
138396
);

update faremcad set data_venci = '15/07/2020'
where remessa in 
(
138396
);