-------------------------------------------------------------
-- Criar Tabela - Inicio - TAB_PROD
-------------------------------------------------------------

DECLARE
	STATUS   NUMBER (5);
BEGIN

	SELECT COUNT (*)
	INTO STATUS
	FROM ALL_TABLES
	WHERE UPPER(TABLE_NAME) = 'TAB_PROD';

	IF STATUS = 0
	THEN
		-- PRODUTOS QUE ESTAO EM KIT NAO USADO
		EXECUTE IMMEDIATE 'CREATE TABLE TAB_PROD AS
							 SELECT COD_SET, COD_PRD, COD_BARRA_INT, SUM(QUANT) QUANT, 
								   (SELECT COD_PRD FROM ESPROD_SET_LOTE WHERE COD_PRD = P.COD_PRD AND COD_SET = K.COD_SET) CLV
							  FROM ESESTOQUE_KIT K, ESESTOQUE_KIT_PRD P 
							 WHERE USADO = ''N'' 
							   AND K.COD_BARRA_KIT = P.COD_BARRA_KIT
							GROUP BY COD_SET, COD_PRD, COD_BARRA_INT,5'; 
	END IF;					

END;
/
-------------------------------------------------------------
-- Criar Tabela - Fim - TAB_PROD
-------------------------------------------------------------


-------------------------------------------------------------
-- Criar Tabela - Inicio - TAB_PROD_NCLV
-------------------------------------------------------------

DECLARE
	STATUS   NUMBER (5);
BEGIN
	SELECT COUNT (*)
	INTO STATUS
	FROM ALL_TABLES
	WHERE UPPER(TABLE_NAME) = 'TAB_PROD_NCLV';
    
	IF STATUS = 0
	THEN	
		-- produtos que estao em kit nao usado e nao CLV
		EXECUTE IMMEDIATE 'CREATE TABLE TAB_PROD_NCLV AS
							SELECT COD_SET, COD_PRD, SUM(QUANT) QUANT
							  FROM TAB_PROD
							 WHERE CLV IS NULL
							GROUP BY COD_SET, COD_PRD
							ORDER BY COD_SET, COD_PRD';	
	
	END IF;	

END; 
/
-------------------------------------------------------------
-- Criar Tabela - Fim - TAB_PROD_NCLV
-------------------------------------------------------------


-------------------------------------------------------------
-- Criar Tabela - Inicio - TAB_PROD_CLV
-------------------------------------------------------------

DECLARE
	STATUS   NUMBER (5);
BEGIN
	SELECT COUNT (*)
	INTO STATUS
	FROM ALL_TABLES
	WHERE UPPER(TABLE_NAME) = 'TAB_PROD_CLV';
    
	IF STATUS = 0
	THEN	
		-- produtos que estao em kit nao usado e CLV
		EXECUTE IMMEDIATE 'CREATE TABLE TAB_PROD_CLV AS
							SELECT COD_SET, COD_PRD, COD_BARRA_INT, SUM(QUANT) QUANT
							  FROM TAB_PROD
							 WHERE CLV IS NOT NULL
							GROUP BY COD_SET, COD_PRD, COD_BARRA_INT
							ORDER BY COD_SET, COD_PRD, COD_BARRA_INT';
	
	END IF;	

END; 
/
-------------------------------------------------------------
-- Criar Tabela - Fim - TAB_PROD_CLV
-------------------------------------------------------------



-------------------------------------------------------------
-- CRIAR PROCEDURE - INICIO
-------------------------------------------------------------
CREATE OR REPLACE PROCEDURE AJUSTA_ESTOQUE_KIT 
IS
 CCODSET           CHAR(4);
 CCODPRD           CHAR(6);
 CCODBARRAINT      CHAR(9);
 NQUANT            NUMBER(11,3);
 NESTATU           NUMBER(11,3);
 NESTKIT           NUMBER(11,3);

BEGIN
	-- PRODUTOS QUE ESTAO EM KIT NAO USADO E NAO CLV E A RESERVA DO KIT NAO CONDIZ COM A QUANTIDADE MONTADA
	FOR REG_1 IN (SELECT T2.COD_SET CCODSET, T2.COD_PRD CCODPRD, NVL(T2.QUANT,0) NQUANT, 
						 NVL(E.EST_ATU,0) NESTATU, NVL(E.EST_KIT,0) NESTKIT
					FROM TAB_PROD_NCLV T2, ESESTCAD E 
				   WHERE T2.COD_SET = E.COD_SET
					 AND T2.COD_PRD = E.COD_PRD
					 AND T2.QUANT <> NVL(E.EST_KIT,0)) 
	LOOP

	  IF REG_1.NESTATU >= REG_1.NQUANT AND REG_1.NESTKIT <> REG_1.NQUANT THEN
		UPDATE ESESTCAD 
		   SET EST_KIT = REG_1.NQUANT ,
			   CONTROLE = DECODE (CONTROLE, '0', '1', '0')
		 WHERE COD_PRD = REG_1.CCODPRD
		   AND COD_SET = REG_1.CCODSET;
	  END IF;
	  
	END LOOP;

	-- PRODUTOS QUE ESTAO EM KIT NAO USADO E CLV E A RESERVA DO KIT NAO CONDIZ COM A QUANTIDADE MONTADA
	FOR REG_2 IN (SELECT T3.COD_SET CCODSET, T3.COD_PRD CCODPRD, T3.COD_BARRA_INT CCODBARRAINT, 
						 NVL(T3.QUANT,0) NQUANT, NVL(E.EST_ATU,0) NESTATU, NVL(E.EST_KIT,0) NESTKIT  
					FROM TAB_PROD_CLV T3, ESESTCAD E
				   WHERE T3.COD_SET = E.COD_SET
					 AND T3.COD_PRD = E.COD_PRD
					 AND T3.COD_BARRA_INT = E.COD_BARRA_INT
					 AND T3.QUANT <> NVL(E.EST_KIT,0))
	LOOP 

	  IF REG_2.NESTATU >= REG_2.NQUANT AND REG_2.NESTKIT <> REG_2.NQUANT   THEN
		UPDATE ESESTCAD 
		   SET EST_KIT = REG_2.NQUANT,
			   CONTROLE = DECODE (CONTROLE, '0', '1', '0')
		 WHERE COD_PRD = REG_2.CCODPRD
		   AND COD_SET = REG_2.CCODSET
		   AND COD_BARRA_INT = REG_2.CCODBARRAINT;
	  END IF;

	END LOOP;

	-- VERIFICA SE EXISTE ALGUM PRODUTO QUE NAO CLV E TEM ESTOQUE RESERVADO PARA O KIT E NAO ESTA MONTADO
	UPDATE ESESTCAD 
	   SET EST_KIT = 0, 
		   CONTROLE = DECODE (CONTROLE, '0', '1', '0')
	 WHERE NVL(EST_KIT,0) > 0 
	   AND COD_BARRA_INT = ' ' 
	   AND NOT EXISTS (SELECT COD_PRD 
						 FROM TAB_PROD_NCLV 
						WHERE COD_SET = ESESTCAD.COD_SET 
						  AND COD_PRD = ESESTCAD.COD_PRD);

	-- VERIFICA SE EXISTE ALGUM PRODUTO COM ESTOQUE RESERVADO PARA O KIT E NAO ESTA MONTADO
	UPDATE ESESTCAD 
	   SET EST_KIT = 0, 
		   CONTROLE = DECODE (CONTROLE, '0', '1', '0')
	 WHERE NVL(EST_KIT,0) > 0 
	   AND COD_BARRA_INT <> ' '
	   AND NOT EXISTS (SELECT COD_PRD 
						 FROM TAB_PROD_CLV T3 
						WHERE T3.COD_SET = ESESTCAD.COD_SET 
						  AND T3.COD_PRD = ESESTCAD.COD_PRD
						  AND T3.COD_BARRA_INT = ESESTCAD.COD_BARRA_INT);

	-- VERIFICA SE EXISTE ALGUM PRODUTO COM ESTOQUE RESERVADO PARA O KIT E NAO ATUALIZA ESTOQUE
	UPDATE ESESTCAD
	   SET EST_KIT = 0,
		   CONTROLE = DECODE (CONTROLE, '0', '1', '0')
	 WHERE EST_KIT > 0
	   AND (SELECT TIPO_CONS 
			  FROM FAPRDCAD 
			 WHERE FAPRDCAD.CODIGO = ESESTCAD.COD_PRD) <> '0';

	--DROP DAS TABELAS TEMPORARIAS
	--EXECUTE IMMEDIATE('DROP TABLE TAB_PROD');
	--EXECUTE IMMEDIATE('DROP TABLE TAB_PROD_NCLV');
	--EXECUTE IMMEDIATE('DROP TABLE TAB_PROD_CLV');

END;
/
-------------------------------------------------------------
-- CRIAR PROCEDURE - FINAL
-------------------------------------------------------------

-- EXECUTA A PROCEDURE AJUSTA_ESTOQUE_KIT
EXECUTE AJUSTA_ESTOQUE_KIT
/

-- REMOVE A PROCEDURE AJUSTA_ESTOQUE_KIT
DROP PROCEDURE AJUSTA_ESTOQUE_KIT
/


-------------------------------------------------------------
-- SELECT - INICIO 
-------------------------------------------------------------
--ATUALIZAR A TABELA DE SALDO DO ESTOQUE ATUAL.
--Obs: Os itens com quantidade maior que zero deverao ser feito um credito no estoque para estes itens. O credito devera
--     levar em consideracao, cod_prd (produto), cod_set (setor) e cod_barra_int (codigo de barras interno).

SELECT t2.cod_set, t2.cod_prd, '' COD_BARRA_INT, (nvl(t2.quant,0) - nvl(e.est_atu,0)) quantidade
  FROM tab_prod_nclv t2, esestcad e 
 WHERE t2.cod_set = e.cod_set
   AND t2.cod_prd = e.cod_prd
   AND t2.quant > nvl(e.est_kit,0)
union
SELECT t3.cod_set, t3.cod_prd, t3.COD_BARRA_INT, (nvl(t3.quant,0) - nvl(e.est_atu,0)) quantidade
  FROM tab_prod_clv t3, esestcad e
 where t3.cod_set = e.cod_set
   AND t3.cod_prd = e.cod_prd
   AND t3.COD_BARRA_INT = e.COD_BARRA_INT
   AND t3.quant > nvl(e.est_atu,0)
/

-------------------------------------------------------------
-- SELECT - FIM 
-------------------------------------------------------------



-------------------------------------------------------------
-- DROP - INICIO 
-------------------------------------------------------------

--Drop das tabelas temporarias
DROP TABLE tab_prod
/
DROP TABLE tab_prod_nclv
/
DROP TABLE tab_prod_clv
/
-------------------------------------------------------------
-- DROP - FIM 
-------------------------------------------------------------




   




















