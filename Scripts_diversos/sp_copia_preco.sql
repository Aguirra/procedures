CREATE PROCEDURE check_estrutura()
DEFINE ncount INTEGER;

  SELECT COUNT(*)
  INTO ncount
  FROM sysprocedures
  WHERE procname='sp_apoio_coppreco';

  IF ncount>0 THEN
    DROP PROCEDURE sp_apoio_coppreco;
  END IF;

END PROCEDURE;

EXECUTE PROCEDURE check_estrutura();
DROP PROCEDURE check_estrutura;

-----------------------------------------------------------------------------------------------------------------
--   INFORMIX
-----------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_apoio_coppreco(pcUniOrigem VARCHAR(6), pcUniDestino VARCHAR(6))
RETURNING SMALLINT,CHAR(255) ;
----------------------------------------------------------------------------------------
-- Nome.......: SP_COPIA_PRECO
-- Autor .....: Denilson Cartaxo
-- Finalidade.: Copiar os precos de uma uniade para outra
--
-- Parametros.: pcUniOrigem : unidade origem da copia
--              pcUniDestino : unidade destino da copia
--
-- Histórico
----------------------------------------------------------------------------------------
-- 28/11/2007 - Denilson Cartaxo - CRC47563 - Corrigir erro na inclusao da FAPRECAD
----------------------------------------------------------------------------------------

  DEFINE STATUS               SMALLINT;
  DEFINE nRetorno,esql, isam  SMALLINT;
  DEFINE mensret,mens         CHAR(255);
  DEFINE iCommit              INTEGER;
  DEFINE cCODIGO              LIKE FAPRECAD.CODIGO;
  DEFINE cTABELA              LIKE FAPRECAD.TABELA ;
  DEFINE dVALIDADE            LIKE FAPRECAD.VALIDADE ;
  DEFINE cCOEF_FILME          LIKE FAPRECAD.COEF_FILME;
  DEFINE cCOEF_HONOR          LIKE FAPRECAD.COEF_HONOR;
  DEFINE cCUSTO_OPER          LIKE FAPRECAD.CUSTO_OPER;
  DEFINE cQTD_INICIAL         LIKE FAPRECAD.QTD_INICIAL;
  DEFINE cQTD_SUBSEQ          LIKE FAPRECAD.QTD_SUBSEQ;
  DEFINE cVALOR               LIKE FAPRECAD.VALOR;
  DEFINE cVALOR_SUB           LIKE FAPRECAD.VALOR_SUB;
  DEFINE cINDICE_CBHPM        LIKE FAPRECAD.INDICE_CBHPM;
  DEFINE cUNIDESTINO          LIKE FAPRECAD.COD_UNI;
  DEFINE cCOD_PORTE           LIKE FAPRECAD.COD_PORTE;


--BEGIN

   ON EXCEPTION SET esql,isam,mens
     --RAISE EXCEPTION esql,0,"'Erro na copia dos precos.'";
     IF iCommit = 1 THEN
--        ROLLBACK;
     END IF;
      LET nRetorno = esql;
      LET mensret = mens;
      RETURN nRetorno,mens;
   END EXCEPTION;


  LET esql = 0;
  LET iCommit = 0;

  -- verificar validade dos parametros passados

  SELECT COUNT(*) INTO STATUS
    FROM AMUNICAD
   WHERE COD_UNI = pcUniOrigem;

  IF STATUS=0 THEN
     RAISE EXCEPTION -746, 0,'Unidade origem nao encontrada.';
  END IF;

  -- O trecho abaixo foi comentado por que a unidade TCARE está com preços, mas não é unidade de faturamento
  -- Não se sabe como, mas a base de dados foi implantada com esta inconsistência.
/*  SELECT COUNT(*) INTO STATUS
    FROM AMUNICAD
   WHERE COD_UNI = pcUniOrigem
     AND COD_UNI = COD_UNI_FATURA;

  IF STATUS=0 THEN
     RAISE EXCEPTION -746, 0,'Unidade origem nao eh de faturamento.';
  END IF;
*/
  SELECT COUNT(*) INTO STATUS
    FROM AMUNICAD
   WHERE COD_UNI = pcUniDestino;

  IF STATUS=0 THEN
     RAISE EXCEPTION -746, 0,'Unidade destino nao encontrada.';
  END IF;

  SELECT COUNT(*) INTO STATUS
    FROM AMUNICAD
   WHERE COD_UNI = pcUniDestino
     AND COD_UNI = COD_UNI_FATURA;

  IF STATUS=0 THEN
     RAISE EXCEPTION -746, 0,'Unidade destino nao eh de faturamento.';
  END IF;

  -- verificar se a unidade ja foi utilizada em alguma tabela

  -- O trecho abaixo foi comentado por que a unidade TCARE está com validades, o que em teoria não deveria ocorrer
/*  SELECT COUNT(*) INTO STATUS
    FROM FATIPPRE
   WHERE COD_UNI = pcUniDestino;

  IF STATUS>0 THEN
     RAISE EXCEPTION -746, 0,'Unidade destino ja possui validade cadastrada.';
  END IF;
*/
  -- fazer a atualizacao das tabelas de preco

  --BEGIN WORK;

 LET iCommit = 1;
    -- 1. validades (FATIPPRE)


    SELECT TIPO_PRD,
           VALIDADE,
           pcUniDestino UNIDESTINO
      FROM FATIPPRE
     WHERE COD_UNI = pcUniOrigem INTO TEMP T_FATIPPRE WITH NO LOG;

     INSERT INTO FATIPPRE(TIPO_PRD, VALIDADE, COD_UNI)
     SELECT TIPO_PRD,
           VALIDADE,
           UNIDESTINO
      FROM T_FATIPPRE 
	  WHERE NOT EXISTS (SELECT * FROM FATIPPRE
              WHERE FATIPPRE.COD_UNI = T_FATIPPRE.UNIDESTINO
                AND FATIPPRE.VALIDADE = T_FATIPPRE.VALIDADE
                AND FATIPPRE.TIPO_PRD = T_FATIPPRE.TIPO_PRD);

      DROP TABLE T_FATIPPRE ;

    -- 2. Valores de CH e Filme (FAFILHON)

    SELECT TIPO_PRD,
           TABELA,
           VALIDADE,
           VAL_FILME,
           VAL_HONOR,
           IND_CBHPM,
           VALOR_UCO,
           pcUniDestino UNIDESTINO
      FROM FAFILHON
     WHERE COD_UNI = pcUniOrigem INTO TEMP T_FAFILHON WITH NO LOG;

     INSERT INTO FAFILHON(TIPO_PRD, TABELA, VALIDADE, VAL_FILME, VAL_HONOR, IND_CBHPM, VALOR_UCO, COD_UNI)
     SELECT TIPO_PRD,
           TABELA,
           VALIDADE,
           VAL_FILME,
           VAL_HONOR,
           IND_CBHPM,
           VALOR_UCO,
           UNIDESTINO
      FROM T_FAFILHON ;

      DROP TABLE T_FAFILHON ;
    -- 3. Tabelas de preco (FAPRECAD)

    -- Antes de mais nada, garante que não há nenhum preço da tabela destino
    -- Na procedure original este DELETE não existe, pois se vai fazer cópia, então não faria sentido ter 
    -- dados da unidade destino
	DELETE FROM FAPRECAD
	WHERE COD_UNI = pcUniDestino;
	
    FOREACH
    SELECT FAPRECAD.CODIGO,
           FAPRECAD.TABELA,
           FAPRECAD.VALIDADE,
           FAPRECAD.COEF_FILME,
           FAPRECAD.COEF_HONOR,
           FAPRECAD.CUSTO_OPER,
           FAPRECAD.QTD_INICIAL,
           FAPRECAD.QTD_SUBSEQ,
           FAPRECAD.VALOR,
           FAPRECAD.VALOR_SUB,
           FAPRECAD.INDICE_CBHPM,
           pcUniDestino UNIDESTINO,
           FAPRECAD.COD_PORTE
      INTO cCODIGO,
           cTABELA,
           dVALIDADE,
           cCOEF_FILME,
           cCOEF_HONOR,
           cCUSTO_OPER,
           cQTD_INICIAL,
           cQTD_SUBSEQ,
           cVALOR,
           cVALOR_SUB,
           cINDICE_CBHPM,
           cUNIDESTINO,
           cCOD_PORTE
      FROM FAPRECAD, FAPRDCAD, FATIPPRE
     WHERE FAPRECAD.COD_UNI = pcUniOrigem
       AND FAPRECAD.CODIGO = FAPRDCAD.CODIGO
       AND FAPRDCAD.TIPO_PRD = FATIPPRE.TIPO_PRD
       AND FAPRECAD.VALIDADE = FATIPPRE.VALIDADE
       AND FAPRECAD.COD_UNI = FATIPPRE.COD_UNI

    INSERT INTO FAPRECAD(CODIGO, TABELA, VALIDADE, COEF_FILME, COEF_HONOR, CUSTO_OPER, QTD_INICIAL, QTD_SUBSEQ, VALOR, VALOR_SUB, INDICE_CBHPM, COD_UNI, COD_PORTE)
    VALUES (
           cCODIGO,
           cTABELA,
           dVALIDADE,
           cCOEF_FILME,
           cCOEF_HONOR,
           cCUSTO_OPER,
           cQTD_INICIAL,
           cQTD_SUBSEQ,
           cVALOR,
           cVALOR_SUB,
           cINDICE_CBHPM,
           cUNIDESTINO,
           cCOD_PORTE
          ) ;

     END FOREACH

    -- 4. PRECO_PORTE_PLANO


    SELECT pcUniDestino UNIDESTINO,
           COD_CON,
           COD_PLA,
           TIPO_PRD,
           VALIDADE,
           COD_PORTE,
           VALOR
      FROM PRECO_PORTE_PLANO
     WHERE COD_UNI = pcUniOrigem INTO TEMP T_PREC_PORT_PLAN WITH NO LOG;

    INSERT INTO PRECO_PORTE_PLANO(COD_UNI, COD_CON, COD_PLA, TIPO_PRD, VALIDADE, COD_PORTE, VALOR)
    SELECT UNIDESTINO,
           COD_CON,
           COD_PLA,
           TIPO_PRD,
           VALIDADE,
           COD_PORTE,
           VALOR
      FROM T_PREC_PORT_PLAN ;

      DROP TABLE T_PREC_PORT_PLAN ;



    -- 5. PRECO_FIL_HON_GER


    SELECT pcUniDestino UNIDESTINO,
           COD_CON,
           COD_PLA,
           TIPO_PRD,
           VALIDADE,
           VALOR_CH,
           VALOR_FILME,
           VALOR_UCO
      FROM PRECO_FIL_HON_GER
     WHERE COD_UNI = pcUniOrigem INTO TEMP T_PREC_FIL_H_GER WITH NO LOG;

    INSERT INTO PRECO_FIL_HON_GER(COD_UNI, COD_CON, COD_PLA, TIPO_PRD, VALIDADE, VALOR_CH, VALOR_FILME, VALOR_UCO)
    SELECT UNIDESTINO,
           COD_CON,
           COD_PLA,
           TIPO_PRD,
           VALIDADE,
           VALOR_CH,
           VALOR_FILME,
           VALOR_UCO
      FROM T_PREC_FIL_H_GER;

      DROP TABLE T_PREC_FIL_H_GER ;
    -- 6. PRECO_FIL_HON_IND

       SELECT pcUniDestino UNIDESTINO,
           COD_CON,
           COD_PLA,
           COD_PRD,
           VALIDADE,
           VALOR_CH,
           VALOR_FILME,
           TIPO_PRD,
           VALOR_UCO
      FROM PRECO_FIL_HON_IND
     WHERE COD_UNI = pcUniOrigem INTO TEMP T_PREC_FI_HO_IN WITH NO LOG;

     INSERT INTO PRECO_FIL_HON_IND(COD_UNI, COD_CON, COD_PLA, COD_PRD, VALIDADE, VALOR_CH, VALOR_FILME, TIPO_PRD, VALOR_UCO)
     SELECT UNIDESTINO,
           COD_CON,
           COD_PLA,
           COD_PRD,
           VALIDADE,
           VALOR_CH,
           VALOR_FILME,
           TIPO_PRD,
           VALOR_UCO
      FROM T_PREC_FI_HO_IN;

      DROP TABLE T_PREC_FI_HO_IN ;
    -- 7. PRECO_PORTE_GER

    SELECT pcUniDestino UNIDESTINO,
           TIPO_PRD,
           VALIDADE,
           FK_APETAB,
           COD_PORTE,
           VALOR, 
		   0 AS PK_PREPGER
      FROM PRECO_PORTE_GER
     WHERE COD_UNI = pcUniOrigem INTO TEMP T_PREC_PORT_GE WITH NO LOG;

     INSERT INTO PRECO_PORTE_GER(COD_UNI, TIPO_PRD, VALIDADE, FK_APETAB, COD_PORTE, VALOR, PK_PREPGER)
     SELECT UNIDESTINO,
           TIPO_PRD,
           VALIDADE,
           FK_APETAB,
           COD_PORTE,
           VALOR,
		   PK_PREPGER
      FROM T_PREC_PORT_GE;

      DROP TABLE T_PREC_PORT_GE ;

    --COMMIT;

END PROCEDURE ;

EXECUTE PROCEDURE SP_APOIO_COPPRECO('TCARE','ARESGT');

DROP PROCEDURE SP_APOIO_COPPRECO;

--UPDATE WPDTAB SET VALOR = 'ARESGT' where COD_PARAMETRO = 'unidade_padrao_preco';
UPDATE AMuniCad SET Co_Unid_PrecPadrao = 'ARESGT' WHERE Co_Unid_PrecPadrao = 'TCARE';
UPDATE FaApeTab SET Co_Unidade = 'ARESGT' WHERE Co_Unidade = 'TCARE';