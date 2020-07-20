-- status interfaces 

select * from (
select x2.ds_tp_integra desc_integra, x1.status status
from sap.tb_controle_processamento x1, sap.tb_tipo_integracao x2
where x1.fk_tp_integra = x2.pk_tp_integra
and dh_processamento >= to_date(sysdate, 'dd/mm/yy')
order by ds_tp_integra, dh_processamento desc )
pivot (
      count(status)
         for status in ('S' as sucesso,
                        'E' as erro,
                        'R' as reprocessado,
                        'P' as pendente)
)

select 
   sum (decode (status, 'E', 1, 'S', 1)) totalgeral_s_e,
   sum (decode (status, 'S', 1)) Totalsucesso,
   sum (decode (status, 'E', 1)) Totalerro
from sap.tb_controle_processamento
where dh_processamento >= to_date(sysdate, 'dd/mm/yy') -1