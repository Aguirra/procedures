--Executar sempre após a execução do robô
--Verifica se o robo foi executado com exceto
select count(*) from ti_ctr_requisicao where dh_inclusao <= current - 30 units minute and status = 0;
select count(*) from ti_ctr_pedido where dh_inclusao <= current - 30 units minute and status = 0;
select count(*) from ti_ctr_recebimento where dh_inclusao <= current - 30 units minute and status = 0;

--Executar sempre após a execução do robô
--Verifica se houve algum erro tecnico
select count(*) from ti_ctr_requisicao where dh_inclusao >= current - 20 units minute and status = 2;
select count(*) from ti_ctr_pedido where dh_inclusao >= current - 20 units minute and status = 2;
select count(*) from ti_ctr_recebimento where dh_inclusao >= current - 20 units minute and status = 2;






--Verifica se a cotação esta pendente a mais de um dia--
SELECT r.pk_ticwmr, r.cod_cot, r.dh_inclusao, r.dh_processamento, r.tipo_oper, r.status, r.mensagem, dh_envio_email,                                               
CASE WHEN r.STATUS = 0 THEN 'PENDENTE' 
     WHEN r.STATUS = 1 THEN 'PROCESSADO'
     WHEN r.STATUS = 2 THEN 'ERRO TECNICO' 
     WHEN r.STATUS = 3 THEN 'ERRO DE NEGOCIO' 
     WHEN r.STATUS = 4 THEN 'CANCELADO' 
     WHEN r.STATUS = 5 THEN 'COTAÇÃO AUTOMÁTICA - INCOMPLETA ' 
      END STATUS_PROCESSAMENTO,
CASE WHEN r.tipo_oper = 'I' THEN 'INCLUSAO' 
     WHEN r.tipo_oper = 'A' THEN 'ALTERACAO' 
     WHEN r.tipo_oper = 'D' THEN 'EXCLUSAO' 
      END DESC_OPERACAO, '' as cod_pedido_me
 FROM ti_ctr_requisicao r
WHERE (1=1)
  AND status = '0'
  AND dh_inclusao < today
ORDER BY dh_inclusao DESC

--Verifica se o pedido esta pendente a mais de um dia--
SELECT p.pk_ticped, p.documento, p.cod_pedido_me, p.dh_inclusao, p.dh_processamento, p.tipo_oper, p.status,p.mensagem,p.cod_pedido_me, dh_envio_email, 
CASE WHEN p.STATUS = 0 THEN 'PENDENTE' 
     WHEN p.STATUS = 1 THEN 'PROCESSADO' 
     WHEN p.STATUS = 2 THEN 'ERRO TECNICO' 
     WHEN p.STATUS = 3 THEN 'ERRO DE NEGOCIO'                               
     WHEN p.STATUS = 4 THEN 'CANCELADO'                                
      END STATUS_PROCESSAMENTO, 
CASE WHEN p.tipo_oper = 'I' THEN 'INCLUSAO'
     WHEN p.tipo_oper = 'C' THEN 'CANCELAMENTO'
     WHEN p.tipo_oper = 'A' THEN 'ALTERAÇÃO' 
      END DESC_OPERACAO
 FROM ti_ctr_pedido p
WHERE (1=1)
  AND status = '0'
  AND dh_inclusao < today
ORDER BY dh_inclusao DESC

--Verifica se a confirmação do pedido esta pendente a mais de um dia--
SELECT r.pk_ticrec, r.documento, r.nota, r.dh_inclusao, r.dh_processamento, r.tipo_oper, r.status, r.mensagem, dh_envio_email,
CASE WHEN r.STATUS = 0 THEN 'PENDENTE' 
     WHEN r.STATUS = 1 THEN 'PROCESSADO'
     WHEN r.STATUS = 2 THEN 'ERRO TECNICO' 
     WHEN r.STATUS = 3 THEN 'ERRO DE NEGOCIO' 
     WHEN r.STATUS = 4 THEN 'CANCELADO' 
     WHEN r.STATUS = 5 THEN 'COTAÇÃO AUTOMÁTICA - INCOMPLETA'
      END STATUS_PROCESSAMENTO,
CASE WHEN r.tipo_oper = 'I' THEN 'INCLUSAO' 
     WHEN r.tipo_oper = 'A' THEN 'ALTERACAO' 
     WHEN r.tipo_oper = 'D' THEN 'EXCLUSAO' 
      END DESC_OPERACAO, cod_pedido_me
 FROM ti_ctr_recebimento r
WHERE (1=1)
  AND status = '0'
  AND dh_inclusao < today
ORDER BY dh_inclusao DESC