-- Finalidade: Corrigir estoque reservado de kit do legado
-------------------------------------------------------------
-------------------------------------------------------------
-- Criar Procedure - Inicio
-------------------------------------------------------------
CREATE PROCEDURE check_estrutura()
   define  ncount integer;

   SELECT COUNT(*)
     INTO ncount
     FROM sysprocedures
    WHERE procname='ajusta_estoque_kit';

   IF ncount>0 THEN
      DROP PROCEDURE ajusta_estoque_kit;
   END IF;
END PROCEDURE;

EXECUTE PROCEDURE check_estrutura();
DROP PROCEDURE check_estrutura;

-- Cria procedure
CREATE PROCEDURE ajusta_estoque_kit()

DEFINE cCodSet           CHAR(4);
DEFINE cCodPrd           CHAR(6);
DEFINE cCodBarraInt      CHAR(9);
DEFINE nQuant            DECIMAL(11,3);
DEFINE nEstAtu           DECIMAL(11,3);
DEFINE nEstKit           DECIMAL(11,3);


-- produtos que est�o em kit nao usado
SELECT cod_set, cod_prd, cod_barra_int, sum(quant) quant, 
       (select cod_prd from esprod_set_lote where cod_prd = p.cod_prd and cod_set = k.cod_set) CLV
  FROM ESESTOQUE_KIT k, ESESTOQUE_KIT_PRD p 
 WHERE usado = 'N' 
   AND k.cod_barra_kit = p.cod_barra_kit
GROUP BY 1,2,3,5
INTO TEMP tab_prod;

-- produtos que est�o em kit nao usado e n�o CLV
SELECT cod_set, cod_prd, sum(quant) quant
  FROM tab_prod
 WHERE clv is null
GROUP BY 1,2
ORDER BY 1,2
INTO TEMP tab_prod_nclv;

-- produtos que est�o em kit nao usado e n�o CLV e a reserva do kit n�o condiz com a quantidade montada
FOREACH

SELECT t2.cod_set, t2.cod_prd, nvl(t2.quant,0), nvl(e.est_atu,0), nvl(e.est_kit,0) 
  INTO cCodSet, cCodPrd, nQuant, nEstAtu, nEstKit
  FROM tab_prod_nclv t2, esestcad e 
 WHERE t2.cod_set = e.cod_set
   AND t2.cod_prd = e.cod_prd
   AND t2.quant <> nvl(e.est_kit,0)

  IF nEstAtu >= nQuant AND nEstKit <> nQuant Then
    UPDATE esestcad 
       SET est_kit = nQuant ,
           controle = DECODE (controle, '0', '1', '0')
     WHERE cod_prd = cCodPrd
       AND cod_set = cCodSet;
  END IF;

END FOREACH;

-- produtos que est�o em kit nao usado e CLV
SELECT cod_set, cod_prd, COD_BARRA_INT, sum(quant) quant
  FROM tab_prod
 WHERE clv is NOT null
GROUP BY 1,2,3
ORDER BY 1,2,3
INTO TEMP tab_prod_clv;

-- produtos que est�o em kit nao usado e CLV e a reserva do kit n�o condiz com a quantidade montada
FOREACH

SELECT t3.cod_set, t3.cod_prd, T3.COD_BARRA_INT, nvl(t3.quant,0), nvl(e.est_atu,0), nvl(e.est_kit,0)  
  INTO cCodSet, cCodPrd, cCodBarraInt, nQuant, nEstAtu, nEstKit
  FROM tab_prod_clv T3, esestcad e
 where t3.cod_set = e.cod_set
   AND t3.cod_prd = e.cod_prd
   AND t3.COD_BARRA_INT = e.COD_BARRA_INT
   AND t3.quant <> nvl(e.est_kit,0)

  IF nEstAtu >= nQuant AND nEstKit <> nQuant   Then
    UPDATE Esestcad 
       SET est_kit = nQuant ,
           controle = DECODE (controle, '0', '1', '0')
     WHERE cod_prd = cCodPrd
       AND cod_set = cCodSet
       AND cod_barra_int = cCodBarraInt;
  END IF;

END FOREACH;

-- verifica se existe algum produto que n�o CLV e tem estoque reservado para o kit e n�o est� montado
UPDATE esestcad 
   SET est_kit = 0, 
       controle = DECODE (controle, '0', '1', '0')
 WHERE nvl(est_kit,0) > 0 
   AND cod_barra_int = '         ' 
   AND not exists (SELECT cod_prd 
                     FROM TAB_PROD_NCLV 
                    WHERE cod_set = esestcad.cod_set 
                      AND cod_prd = esestcad.cod_prd);

-- verifica se existe algum produto com estoque reservado para o kit e n�o est� montado
UPDATE esestcad 
   SET est_kit = 0, 
       controle = DECODE (controle, '0', '1', '0')
 WHERE nvl(est_kit,0) > 0 
   AND cod_barra_int <> ''
   AND not exists (SELECT cod_prd 
                     FROM tab_prod_clv t3 
                    WHERE t3.cod_set = esestcad.cod_set 
                      AND t3.cod_prd = esestcad.cod_prd
                      AND t3.cod_barra_int = esestcad.cod_barra_int);

-- verifica se existe algum produto com estoque reservado para o kit e n�o atualiza estoque
UPDATE esestcad
   SET est_kit = 0,
       controle = DECODE (controle, '0', '1', '0')
 WHERE est_kit > 0
   AND '1' = (SELECT tipo_cons 
                FROM faprdcad 
               WHERE faprdcad.codigo = esestcad.cod_prd);

--drop das tabelas temporarias
DROP TABLE tab_prod;
DROP TABLE tab_prod_nclv;
DROP TABLE tab_prod_clv;

END PROCEDURE;

-------------------------------------------------------------
-- Criar Procedure - Final
-------------------------------------------------------------

-- Executa a procedure ajusta_estoque_kit

EXECUTE PROCEDURE ajusta_estoque_kit();