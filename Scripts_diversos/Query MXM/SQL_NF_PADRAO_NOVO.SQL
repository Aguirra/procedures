SELECT     fanotcad.nota_fiscal,
           fanotcad.serie,
           fanotcad.data_emiss,
           fanotcad.valor_tot,
           fafatpag.cod_admin_cartcred,
           fanotcad.cgc_dest id_paciente,
           fanotcad.cod_uni,
           fanotcad.cod_pac,
           fanotcad.end_dest ,
           fanotcad.bai_dest,
           fanotcad.cid_dest,
           fanotcad.est_dest,
           fanotcad.cep_dest,
           fanotcad.fone_dest,
           fanotcad.insc_est_dest,
           fanotcad.nome_dest,
           fanotcad.cgc_dest,
           fanotcad.compl_dest,
           fanotcad.tipo_nota,
           fanotcad.ind_dest,
           fanotcad.cod_con,
           fanotcad.codificacao,
           tb_integracao_mxm.tp_tipo AS tipo_integracao
FROM       fanotcad
INNER JOIN fafatcad
ON         (
                      fafatcad.nota_fiscal = fanotcad.nota_fiscal
           AND        fafatcad.cod_pac = fanotcad.cod_pac)
LEFT JOIN  fafatpag
ON         (
                      fafatcad.fatura = fafatpag.fatura)
LEFT JOIN  tb_integracao_mxm
ON         (
                      tb_integracao_mxm.co_chave1 = fanotcad.nota_fiscal
           AND        tb_integracao_mxm.co_chave2 = fanotcad.serie
           AND        tb_integracao_mxm.co_chave3 = fanotcad.cod_uni)
WHERE      fanotcad.cod_pac IS NOT NULL
AND        fanotcad.cod_pac <> ''
AND        fanotcad.cancelada <> 'S'
AND        ( (
                                 fanotcad.data_emiss >= (CURRENT - 48 units hour))
           OR         (
                                 fanotcad.data_emiss >= '23/07/2014'
                      AND        fanotcad.data_emiss <= '23/07/2014') )
AND        tb_integracao_mxm.pk_intmxm IS NULL
AND        fanotcad.cod_uni = '0001'
UNION
SELECT     fanotcad.nota_fiscal,
           fanotcad.serie,
           fanotcad.data_emiss,
           fanotcad.valor_tot,
           fafatpag.cod_admin_cartcred,
           fanotcad.nome_dest id_paciente,
           fanotcad.cod_uni,
           fanotcad.cod_pac,
           fanotcad.end_dest ,
           fanotcad.bai_dest,
           fanotcad.cid_dest,
           fanotcad.est_dest,
           fanotcad.cep_dest,
           fanotcad.fone_dest,
           fanotcad.insc_est_dest,
           fanotcad.nome_dest,
           fanotcad.cgc_dest,
           fanotcad.compl_dest,
           fanotcad.tipo_nota,
           fanotcad.ind_dest,
           fanotcad.cod_con,
           fanotcad.codificacao,
           tb_integracao_mxm.tp_tipo AS tipo_integracao
FROM       fanotcad
INNER JOIN fafatcad
ON         (
                      fafatcad.nota_fiscal = fanotcad.nota_fiscal)
LEFT JOIN  fafatpag
ON         (
                      fafatcad.fatura = fafatpag.fatura)
LEFT JOIN  tb_integracao_mxm
ON         (
                      tb_integracao_mxm.co_chave1 = fanotcad.nota_fiscal
           AND        tb_integracao_mxm.co_chave2 = fanotcad.serie
           AND        tb_integracao_mxm.co_chave3 = fanotcad.cod_uni)
WHERE      (
                      fanotcad.cod_pac IS NULL
           OR         fanotcad.cod_pac = '')
AND        fanotcad.cancelada <> 'S'
AND        ( (
                                 fanotcad.data_emiss >= (CURRENT - 48 units hour))
           OR         (
                                 fanotcad.data_emiss >= '23/07/2014'
                      AND        fanotcad.data_emiss <= '23/07/2014') )
AND        tb_integracao_mxm.pk_intmxm IS NULL
AND        fanotcad.cod_uni = '0001'
ORDER BY   fanotcad.nota_fiscal,
           fanotcad.serie,
           fafatpag.cod_admin_cartcred DESC

