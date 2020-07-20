--select count(*), tipo_oper from ti_ctr_atendimento where status = 'P' group by tipo_oper
--select count (*) from ti_ctr_comanda where status = 'P'
--update ti_ctr_atendimento set status = 'C' where tipo_oper = 'E' and status = 'P'

--select count(*), tipo_oper from ti_ctr_atendimento where status = 'R' and date(datahora_proc) = '2012-11-08' 
--group by tipo_oper

602393
597666
SELECT COUNT (*), B.CODIGO, A.COD_PAC
FROM FAMOVCAD A, FAMOVPRD B, FAMOVDESTINO C
WHERE A.TIPO_COMANDA = B.TIPO_COMANDA
AND A.COMANDA = B.COMANDA
AND B.sequencial  = C.sequencial
--AND C.cod_fatura IS NULL
AND A.data_mov >= '2012-09-01'
AND A.COD_UNI NOT IN ('001','002','003','107','108','109','120','133','137','138','184')
--AND A.COD_PAC = 'FB75697'
AND B.CODIGO = '530135'
GROUP BY B.CODIGO, a.COD_PAC
HAVING COUNT (*) > '1'
ORDER BY COUNT(*)