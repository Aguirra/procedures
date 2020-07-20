--update ti_ctr_requisicao set dh_inclusao = '2014-02-13 15:37:00', status = '0' where pk_ticwmr = '1145'

SELECT  CASE WHEN count(*) > 0 THEN '1' --Erro 
             WHEN count(*) = 0 THEN '0' --Ok 
			 END AS wpd 
 FROM ti_ctr_requisicao
WHERE (1=1)
  AND status = '0' --Pendente
  AND dh_inclusao <= current - 60 units minute;

SELECT  CASE WHEN count(*) > 0 THEN '1' --Erro 
             WHEN count(*) = 0 THEN '0' --Ok 
			 END AS wpd 
 FROM ti_ctr_pedido
WHERE (1=1)
  AND status = '0' --Pendente
  AND dh_inclusao <= current - 60 units minute;
 
SELECT  CASE WHEN count(*) > 0 THEN '1' --Erro 
             WHEN count(*) = 0 THEN '0' --Ok 
			 END AS wpd 
 FROM ti_ctr_recebimento
WHERE (1=1)
  AND status = '0' --Pendente
  AND dh_inclusao <= current - 60 units minute;
