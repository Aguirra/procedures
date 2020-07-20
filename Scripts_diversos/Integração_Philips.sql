--Log de erro
select *
from INTP_LOGPROCESSO, INTP_CTR_PROC 
where INTP_CTR_PROC.SEQUENCIAL = INTP_LOGPROCESSO.SEQ_CONTROLE
and status <> 'E'
order by 3 desc



--Consulta View
SELECT * FROM vw_intp_adt_mon

SELECT * FROM ti_ctr_adt_mon WHERE fk_triage = 40966
SELECT * FROM intp_ctr_proc WHERE seq_ti IN (3055) AND seq_eil = 1


--checa sequencial duplicado
SELECT ctr.sequencial
   FROM intp_ctr_proc ctr
   WHERE ctr.seq_eil = 1 -- Sequencial do layout
     AND EXISTS (
       SELECT ctr2.sequencial
       FROM intp_ctr_proc ctr2
       WHERE ctr2.seq_eil = ctr.seq_eil
         AND ctr2.seq_ti = ctr.seq_ti
         AND ctr2.sequencial <> ctr.sequencial)
     AND ctr.data_proc IS NULL

	 
--Atualiza sequencial duplicado
UPDATE intp_ctr_proc SET
     data_proc = current, 
     hora_proc = TO_CHAR(current, '%H:%M:%S'), 
     exportado = 'S', 
     id_reg_repositorio = 'S', 
     num_tenta_reproc = 0
   WHERE intp_ctr_proc.sequencial IN ('5085','5311','5321','5402','5515','5654','5742','5940','6253');