-------------------------------------------------------------
-- Correção DH Validade Anvisa - ORCL
-------------------------------------------------------------
--Assunto...: Alteração Validade Anvisa = NULL
--Banco.....: Oracle
--Analista..: Ricardo Aguirra
--Validado..:
--Data......: 05/2020
--Finalidade: Padronizar itens que estão com a data_validade_anvisa de '9999' para NULL 
--            e itens iguais que já existirem como null deixar inativos para não apresentar erro na aplicação HIS.
-------------------------------------------------------------
-- Correção DH Validade Anvisa - ORCL
-------------------------------------------------------------

ALTER SESSION SET CURRENT_SCHEMA=SISHOSP
/

SET SERVEROUTPUT ON;

DECLARE 
  CURSOR C1 IS 
       SELECT count(*)
       FROM all_tables
       WHERE UPPER(table_name) = 'BKP_INC0247648_20200526';

BEGIN 
  FOR C2 IN C1 LOOP 
       IF C1%FOUND then
         EXECUTE IMMEDIATE ('CREATE TABLE SISHOSP.BKP_INC0247648_20200526(
								FUK_COD_FABRICANTE	VARCHAR2(6),
								UK_COD_PRD_CORP		VARCHAR2(18),
								NU_REG_ANVISA		VARCHAR2(30),
								CO_REF_PRODUTO		VARCHAR2(30),
								STATUS				VARCHAR2(1),
								MSG					VARCHAR2(255))');
		EXECUTE IMMEDIATE('GRANT SELECT, INSERT, UPDATE ON SISHOSP.BKP_INC0247648_20200526 TO SH_ROLE_ALL_OBJECTS');
		ELSE
			exit;
       END IF; 
     END LOOP;
    EXCEPTION 
      WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE(sqlerrm);
END;
/

DECLARE 
    CURSOR c1 IS 
        SELECT count(*) qtd, x1.fuk_cod_fabricante, x1.uk_cod_prd_corp, x1.nu_reg_anvisa, x1.co_ref_produto
          FROM tb_prod_fabricante x1, faprdcad x2
         WHERE x2.cod_prd_corp = x1.uk_cod_prd_corp
           AND TO_CHAR(dh_validade_anvisa, 'dd/mm/yyyy') LIKE '%9999'
           AND x1.sn_inativo = 'N'
        GROUP BY x1.fuk_cod_fabricante, x1.uk_cod_prd_corp, x1.nu_reg_anvisa, x1.co_ref_produto;

    nCount number;
      
BEGIN
    FOR c2 IN c1 LOOP
        IF (c2.qtd > 1) THEN
            --GRAVAR REGISTRO NA TABELA;
            UPDATE tb_prod_fabricante
              SET sn_inativo = 'S'
            WHERE uk_cod_prd_corp        = c2.uk_cod_prd_corp
              AND fuk_cod_fabricante     = c2.fuk_cod_fabricante
              AND (nu_reg_anvisa = c2.nu_reg_anvisa OR nu_reg_anvisa IS NULL)
              AND (co_ref_produto = c2.co_ref_produto OR co_ref_produto IS NULL);
              
              INSERT INTO BKP_INC0247648_20200526 (FUK_COD_FABRICANTE, UK_COD_PRD_CORP, NU_REG_ANVISA, CO_REF_PRODUTO, STATUS, MSG)
                     VALUES(c2.fuk_cod_fabricante, c2.uk_cod_prd_corp, c2.nu_reg_anvisa, c2.co_ref_produto, 'R','PRODUTO|FABRICANTE INATIVO - REPROCESSAR');
        ELSE
            SELECT count(*)
              INTO nCount
              FROM tb_prod_fabricante
             WHERE uk_cod_prd_corp       = c2.uk_cod_prd_corp
               AND fuk_cod_fabricante    = c2.fuk_cod_fabricante
               AND (nu_reg_anvisa = c2.nu_reg_anvisa OR nu_reg_anvisa IS NULL)
               AND (co_ref_produto = c2.co_ref_produto OR co_ref_produto IS NULL)
               AND dh_validade_anvisa    IS NULL;
           
         IF (nCount = 0) THEN
              --GRAVAR REGISTRO NA TABELA;
              --ALTERANDO DATA_ANVISA PARA NULL
                UPDATE tb_prod_fabricante
                   SET dh_validade_anvisa = NULL
                 WHERE uk_cod_prd_corp        = c2.uk_cod_prd_corp
                   AND fuk_cod_fabricante     = c2.fuk_cod_fabricante
                   AND (nu_reg_anvisa = c2.nu_reg_anvisa OR nu_reg_anvisa IS NULL)
                   AND (co_ref_produto = c2.co_ref_produto OR co_ref_produto IS NULL)
				   AND sn_inativo			  = 'N'
                   AND TO_CHAR(dh_validade_anvisa, 'dd/mm/yyyy') LIKE '%9999';				  
                   
                 INSERT INTO BKP_INC0247648_20200526 (FUK_COD_FABRICANTE, UK_COD_PRD_CORP, NU_REG_ANVISA, CO_REF_PRODUTO, STATUS, MSG)
                     VALUES(c2.fuk_cod_fabricante, c2.uk_cod_prd_corp, c2.nu_reg_anvisa, c2.co_ref_produto, 'N', 'PRODUTO|FABRICANTE ATIVO - VALIDADE NULL');
            ELSE
                --GRAVAR REGISTRO NA TABELA;
                --ALTERA PRODUTO PARA INATIVO = S
                UPDATE tb_prod_fabricante
                   SET sn_inativo = 'S'
                 WHERE uk_cod_prd_corp        = c2.uk_cod_prd_corp
                   AND fuk_cod_fabricante     = c2.fuk_cod_fabricante
                   AND (nu_reg_anvisa = c2.nu_reg_anvisa OR nu_reg_anvisa IS NULL)
                   AND (co_ref_produto = c2.co_ref_produto OR co_ref_produto IS NULL)
                   AND TO_CHAR(dh_validade_anvisa, 'dd/mm/yyyy') LIKE '%9999';
                   
                 INSERT INTO BKP_INC0247648_20200526 (FUK_COD_FABRICANTE, UK_COD_PRD_CORP, NU_REG_ANVISA, CO_REF_PRODUTO, STATUS, MSG)
                     VALUES(c2.fuk_cod_fabricante, c2.uk_cod_prd_corp, c2.nu_reg_anvisa, c2.co_ref_produto, 'S', 'PRODUTO|FABRICANTE INATIVADO');
            END IF;
        END IF;
    END LOOP;
	COMMIT;
EXCEPTION 
	WHEN OTHERS THEN 
		dbms_output.put_line(sqlerrm);
END;
/
