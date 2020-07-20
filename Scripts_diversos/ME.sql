update esmovcad set pend_sit_mot = 'N'
--select documento, cod_pedido_me, data_mov, dat_ent, pend_sit_mot, nota, num_nota
--from esmovcad 
where tipo_documento = 'PED'
and pend_sit_mot = 'S'
and documento in ('3190771','3191168','3190714','3184943','3187318','3190269','3190794','3189986','3193002','3192537','3192592',
                  '3192538','3192605','3191129','3193207','3192540','3191146','3192541','3192537','3192538','3192540')

update esmovite set pendente = 'N'
--select documento, quant,qtd_atendida,pendente
--from esmovite
where tipo_documento = 'PED'
and pendente = 'S'
and documento in ('3190771','3191168','3190714','3184943','3187318','3190269','3190794','3189986','3193002','3192537','3192592',
                  '3192538','3192605','3191129','3193207','3192540','3191146','3192541','3192537','3192538','3192540')





select * from ti_ctr_requisicao
select * from ti_ctr_it_requis
select * from ti_ctr_pedido where cod_pedido_me = '5049124'
select * from ti_ctr_it_pedido where fk_ticped = '7'
select * from ti_ctr_recebimento

select * from ti_ctr_pedido a, ti_ctr_it_pedido b
where a.pk_ticped = b.fk_ticped
and cod_pedido_me = '5049124'



select decode(a.tipo_oper,'I','INCLUSAO','C','CANCELADO','A','ALTERACAO')operacao,
       decode(a.status,'1','PROCESSADO','2','ERRO TECNICO','3','ERRO DE NEGOCIO','4','CANCELADO')status,
       mensagem,                dh_inclusao,        documento,      cod_pedido_me,
       c.descricao processo,    b.cod_prd_corp,     b.quant, dh_envio_email
from ti_ctr_pedido a, ti_ctr_it_pedido b, outer esprocad c
where a.pk_ticped = b.fk_ticped
and a.cod_processo = c.cod_processo
--and cod_pedido_me = '5361652'
and documento = '3192540'
order by a.dh_inclusao





___________________________________________________________________________________

AMBOS
	select p.pk_ticped,p.documento,p.cod_pedido_me,p.dh_inclusao,   
	p.dh_processamento,p.tipo_oper,p.status,p.mensagem,p.cod_pedido_me,    dh_envio_email,                                                          
	CASE WHEN p.STATUS = 0 THEN 'PENDENTE' WHEN p.STATUS = 1 THEN 'PROCESSADO' 
	WHEN p.STATUS = 2 THEN 'ERRO TECNICO' WHEN p.STATUS = 3 THEN 'ERRO DE NEGOCIO' 
	WHEN p.STATUS = 4 THEN 'CANCELADO' END STATUS_PROCESSAMENTO,  
	CASE WHEN p.tipo_oper = 'I' THEN 'INCLUSAO' WHEN p.tipo_oper = 'C' THEN 'CANCELAMENTO'  
	WHEN p.tipo_oper = 'A' THEN 'ALTERAÇÃO' END DESC_OPERACAO 
	from ti_ctr_pedido p                                                     
	where (1=1)                                                               
	AND dh_inclusao >= TO_DATE('16/03/2012', '%d/%m/%Y')  
	ORDER BY dh_inclusao DESC
	   
	   
email descarmado
select p.pk_ticped,p.documento,p.cod_pedido_me,p.dh_inclusao,   
       p.dh_processamento,p.tipo_oper,p.status,p.mensagem,p.cod_pedido_me,    
	   dh_envio_email,
	   CASE WHEN p.STATUS = 0 THEN 'PENDENTE' WHEN p.STATUS = 1 THEN 'PROCESSADO'
	   WHEN p.STATUS = 2 THEN 'ERRO TECNICO' WHEN p.STATUS = 3 THEN 'ERRO DE NEGOCIO'                               
	   WHEN p.STATUS = 4 THEN 'CANCELADO' END STATUS_PROCESSAMENTO,                                                
	   CASE WHEN p.tipo_oper = 'I' THEN 'INCLUSAO' WHEN p.tipo_oper = 'C' THEN 'CANCELAMENTO'                           
	   WHEN p.tipo_oper = 'A' THEN 'ALTERAÇÃO' END DESC_OPERACAO                                                        
	   from ti_ctr_pedido p 
	   where (1=1)  
	   AND dh_envio_email is null  
	   ORDER BY dh_inclusao DESC


********************************************************************************************************************
select decode(a.tipo_oper,'I','INCLUSAO','C','CANCELADO','A','ALTERACAO')operacao,
       decode(a.status,'1','PROCESSADO','2','ERRO TECNICO','3','ERRO DE NEGOCIO','4','CANCELADO')status,
       mensagem,                dh_inclusao,        documento,      cod_pedido_me,
       c.descricao processo,    b.cod_prd_corp,     b.quant, dh_envio_email
from ti_ctr_pedido a, ti_ctr_it_pedido b, outer esprocad c
where a.pk_ticped = b.fk_ticped
and a.cod_processo = c.cod_processo
--and cod_pedido_me = '5361652'
and documento = '0059601'
order by a.dh_inclusao



select distinct b.cod_prd_corp
from ti_ctr_pedido a, ti_ctr_it_pedido b, outer esprocad c
where a.pk_ticped = b.fk_ticped
and a.cod_processo = c.cod_processo
--and cod_pedido_me = '5361652'
and documento = '0059601'
and tipo_oper = 'C' and mensagem <> '' and cod_prd_corp in (select cod_prd_corp from faprdcad where 1=1)
order by 1



select esmovite.cod_prd, faprdcad.cod_prd_corp from esmovcad, esmovite, faprdcad
where esmovcad.tipo_documento = esmovite.tipo_documento
and esmovcad.documento = esmovite.documento
and faprdcad.codigo = esmovite.cod_prd
and esmovcad.tipo_documento = 'PED'
and esmovcad.documento = '0059601'
and esmovite.pendente = 'S'