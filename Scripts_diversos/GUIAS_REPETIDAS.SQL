--select count(cod_pac), date(data_ent) from wpdtab_amil group by data_ent order by 2
--into temp wpdtab_amil with no log


SELECT A.cod_pac, A.data_ent
FROM ti_log_integracao L, ti_ctr_atendimento A
WHERE L.seq_controle = A.sequencial
AND A.status = 'E' 
AND A.tipo_oper NOT IN ('E')
AND DATE(A.data_ent) >= '2012-06-01' 
AND DATE(A.data_ent) <= '2012-12-31' 
AND L.MENSAGEM = 'Existe outro paciente com o mesmo número da guia' 
INTO TEMP wpdtab_amil WITH NO LOG





--select count(cod_pac), date(data_ent) from wpdtab_amil group by data_ent order by 2
--into temp wpdtab_amil with no log

--Deletar os registros que tem guias duplicadas na tabela de integração WPD x SISMED
DELETE FROM ti_ctr_atendimento WHERE COD_PAC IN(
    SELECT ti_ctr_atendimento.cod_pac
    FROM ti_log_integracao L
    WHERE L.seq_controle = ti_ctr_atendimento.sequencial
    AND ti_ctr_atendimento.status = 'E'
    AND ti_ctr_atendimento.tipo_oper NOT IN ('E')
    AND DATE(ti_ctr_atendimento.data_ent) >= '2012-06-01'
    AND DATE(ti_ctr_atendimento.data_ent) <= '2012-12-31'
    AND L.MENSAGEM = 'Existe outro paciente com o mesmo número da guia')


SELECT COD_PAC, NUM_GUIA,DATE(data_ent),nome_rsp, cod_uni, cod_con, cod_pla,senha,MATRICULA
FROM ti_ctr_atendimento WHERE NUM_GUIA = '0152050944465'
UNION 
SELECT COD_PAC, NUM_GUIA,DATE(data_ent),nome_rsp, cod_uni, cod_con, cod_pla,senha,MATRICULA
FROM FAPACCAD WHERE num_guia = '0152050944465'