--COTA플O--
select r.pk_ticwmr, r.cod_cot, r.dh_inclusao, r.dh_processamento, r.tipo_oper, r.status, r.mensagem, dh_envio_email,                                               
CASE WHEN r.STATUS = 0 THEN 'PENDENTE' WHEN r.STATUS = 1 THEN 'PROCESSADO' WHEN r.STATUS = 2 THEN 'ERRO TECNICO' WHEN r.STATUS = 3 THEN 'ERRO DE NEGOCIO' WHEN r.STATUS = 4 THEN 'CANCELADO' WHEN r.STATUS = 5 THEN 'COTA플O AUTOM햀ICA - INCOMPLETA ' END STATUS_PROCESSAMENTO,
CASE WHEN r.tipo_oper = 'I' THEN 'INCLUSAO' WHEN r.tipo_oper = 'A' THEN 'ALTERACAO' WHEN r.tipo_oper = 'D' THEN 'EXCLUSAO' END DESC_OPERACAO, '' as cod_pedido_me
from ti_ctr_requisicao r
where (1=1)
AND dh_inclusao >= TO_DATE('11/06/2012', '%d/%m/%Y')  
ORDER BY dh_inclusao DESC



--PEDIDO--
select p.pk_ticped,p.documento,p.cod_pedido_me,p.dh_inclusao,   p.dh_processamento,p.tipo_oper,p.status,p.mensagem,p.cod_pedido_me,dh_envio_email,
CASE WHEN p.STATUS = 0 THEN 'PENDENTE' WHEN p.STATUS = 1 THEN 'PROCESSADO' WHEN p.STATUS = 2 THEN 'ERRO TECNICO' WHEN p.STATUS = 3 THEN 'ERRO DE NEGOCIO'  WHEN p.STATUS = 4 THEN 'CANCELADO' END STATUS_PROCESSAMENTO,
CASE WHEN p.tipo_oper = 'I' THEN 'INCLUSAO' WHEN p.tipo_oper = 'C' THEN 'CANCELAMENTO' WHEN p.tipo_oper = 'A' THEN 'ALTERA플O' END DESC_OPERACAO
from ti_ctr_pedido p 
where (1=1)
AND dh_inclusao >= TO_DATE('11/06/2012', '%d/%m/%Y')  
ORDER BY dh_inclusao DESC



--RECEBIMENTO--
select r.pk_ticrec, r.documento, r.nota, r.dh_inclusao, r.dh_processamento, r.tipo_oper, r.status, r.mensagem, dh_envio_email,
CASE WHEN r.STATUS = 0 THEN 'PENDENTE' WHEN r.STATUS = 1 THEN 'PROCESSADO' WHEN r.STATUS = 2 THEN 'ERRO TECNICO' WHEN r.STATUS = 3 THEN 'ERRO DE NEGOCIO' WHEN r.STATUS = 4 THEN 'CANCELADO' WHEN r.STATUS = 5 THEN 'COTA플O AUTOM햀ICA - INCOMPLETA 'END STATUS_PROCESSAMENTO,
CASE WHEN r.tipo_oper = 'I' THEN 'INCLUSAO' WHEN r.tipo_oper = 'A' THEN 'ALTERACAO' WHEN r.tipo_oper = 'D' THEN 'EXCLUSAO' END DESC_OPERACAO, cod_pedido_me
from ti_ctr_recebimento r
where (1=1)
AND dh_inclusao >= TO_DATE('11/06/2012', '%d/%m/%Y')
ORDER BY dh_inclusao DESC
