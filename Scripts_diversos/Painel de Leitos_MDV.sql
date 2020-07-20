SELECT DS_LEITO_PS,
       CASE
           WHEN (FK_RLEIPS IS NULL)OR(FK_RLEIPS = '') THEN (CASE
                                                                WHEN TB_SEL_SENHA_FILA.SN_PREFERENCIAL = 'S' THEN 'P'||SUBSTR(DESCRICAO,1,1)||TB_SEL_SENHA_FILA.NU_SENHA
                                                                WHEN TB_SEL_SENHA_FILA.SN_PREFERENCIAL = 'N' THEN 'N'||SUBSTR(DESCRICAO,1,1)||TB_SEL_SENHA_FILA.NU_SENHA
                                                            END)
           WHEN FK_RLEIPS IS NOT NULL THEN (CASE
                                                WHEN SN2.SN_PREFERENCIAL = 'S' THEN 'P'||SUBSTR(
                                                                                                  (SELECT DESCRICAO
                                                                                                   FROM FAESPCAD
                                                                                                   WHERE COD_ESP = SN2.FK_COD_ESP),1,1)||SN2.NU_SENHA
                                                WHEN SN2.SN_PREFERENCIAL = 'N' THEN 'N'||SUBSTR(
                                                                                                  (SELECT DESCRICAO
                                                                                                   FROM FAESPCAD
                                                                                                   WHERE COD_ESP = SN2.FK_COD_ESP),1,1)||SN2.NU_SENHA
                                            END)
       END NU_SENHA,
       CASE
           WHEN (FK_RLEIPS IS NULL)
                OR (FK_RLEIPS = '') THEN(NOME_SEGU)
           WHEN FK_RLEIPS IS NOT NULL THEN (TB_PAC_TRIAGEM.NO_PACIENTE)
       END NOME_SEGU,
       TB_LEITOS_PS.FK_COD_PAC,
       TB_SEL_SENHA_FILA.DH_RETIRADA,
       CASE
           WHEN (SUBSTR((CURRENT YEAR TO SECOND)-(TB_SEL_SENHA_FILA.DH_RETIRADA), 1, 10)*24) +(SUBSTR ((CURRENT YEAR TO SECOND)-(TB_SEL_SENHA_FILA.DH_RETIRADA), 11, 2)) < 99 THEN CAST((SUBSTR((CURRENT YEAR TO SECOND)-(TB_SEL_SENHA_FILA.DH_RETIRADA), 1, 10)*24) +(SUBSTR((CURRENT YEAR TO SECOND)-(TB_SEL_SENHA_FILA.DH_RETIRADA), 11, 2))AS VARCHAR(2))
           ELSE CAST((SUBSTR((CURRENT YEAR TO SECOND)-(TB_SEL_SENHA_FILA.DH_RETIRADA), 1, 10)*24) +(SUBSTR((CURRENT YEAR TO SECOND)-(TB_SEL_SENHA_FILA.DH_RETIRADA), 11, 2))AS VARCHAR(4))
       END ||':'||(SUBSTR ((CURRENT YEAR TO SECOND)-(TB_SEL_SENHA_FILA.DH_RETIRADA), 14, 5)) PERMANENCIA,
                  DESCRICAO,
                  FK_RLEIPS,
                  TB_LEITOS_PS.DT_DESATIVADO
FROM TB_LEITOS_PS
JOIN TE_TP_LEITO_PS ON TE_TP_LEITO_PS.PK_TLEIPS = FK_TLEIPS
JOIN AMUNICAD ON AMUNICAD.COD_UNI = FK_COD_UNI
LEFT JOIN FAPACCAD ON FAPACCAD.COD_PAC = FK_COD_PAC
LEFT JOIN TB_SEL_SENHA_FILA ON (TB_SEL_SENHA_FILA.FK_COD_PAC = TB_LEITOS_PS.FK_COD_PAC
                                AND TB_SEL_SENHA_FILA.FK_COD_UNI = TB_LEITOS_PS.FK_COD_UNI)
LEFT JOIN FAESPCAD ON FAESPCAD.COD_ESP = FAPACCAD.COD_ESP
LEFT JOIN TM_RSVLEIPS ON (TM_RSVLEIPS.PK_RLEIPS = TB_LEITOS_PS.FK_RLEIPS)
LEFT JOIN TB_SEL_SENHA_FILA SN2 ON (SN2.PK_SELSEN = TM_RSVLEIPS.FK_SELSEN)
LEFT JOIN TB_PAC_TRIAGEM ON (FK_COD_SENHA = SN2.PK_SELSEN)
WHERE 1 = 1
  AND TE_TP_LEITO_PS.DS_TP_LEITO_PS = 'POLTRONA'
ORDER BY 1