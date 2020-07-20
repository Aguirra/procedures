-------------------------------------------------------------
-- Criar Procedure - Inicio
-------------------------------------------------------------
CREATE PROCEDURE check_estrutura()
   define   status integer;

   SELECT COUNT(*)
     INTO  status
     FROM sysprocedures
    WHERE procname='sp_gera_log_kit';

   IF  status>0 THEN
      DROP PROCEDURE sp_gera_log_kit;
   END IF;
END PROCEDURE;

EXECUTE PROCEDURE check_estrutura();
DROP PROCEDURE check_estrutura;

CREATE PROCEDURE sp_gera_log_kit ( pcCodSet CHAR(4),
                                   pcCodPrd CHAR(6),
                                   pcCodBarraInt CHAR(9),
                                   pfQuant FLOAT,
                                   pcCodBarraKit CHAR(10),
                                   pcusado CHAR(1),
                                   pAcao   CHAR(1))
                                   
-----------------------------------------------------------------------------------
-- Nome.......: sp_gera_log_kit
-- Autor .....: Leon Wagner
-- Finalidade.: Devido aos problemas apresentados no saldo dos kits das unidades, estou criando esta procedure para realizar log das informações persistidas na
--              tabela ESESTCAD com relação ao saldo.
-- Parametros.: pcCodSet  - codigo do setor
--              pdDataMov - data de movimento
--              pcHoraMov - hora de movimento
--              pcCodPrd  - codigo do produto
--              pcCodBarraInt - codigo de barras interno
--              pfQuant   - quantidade
--              pcCodBarraKit - Codigo de barra do Kit
--              pcusado - Indica o status do KIT

   DEFINE fQuant          FLOAT;
   DEFINE fEstAtu         FLOAT;
   DEFINE fEstBloq        FLOAT;
   DEFINE fEstKit         FLOAT;
   DEFINE cCodPrd         CHAR(6);
   DEFINE cSetor          CHAR(4);
   DEFINE cUsado          CHAR(1);
   DEFINE cCodBarraKit    CHAR(10);

   LET cCodPrd = pcCodPrd;
   LET cSetor  = pcCodSet;
   
   IF TRIM(pcCodBarraInt) <> '' THEN
      SELECT NVL(EST_ATU,  0) AS EST_ATU, Nvl(EST_KIT,  0) AS EST_KIT, NVL(EST_BLOQ, 0) AS EST_BLOQ 
      INTO fEstAtu, fEstKit, fEstBloq
      FROM ESESTCAD
      WHERE COD_PRD = pcCodPrd
        AND COD_SET = pcCodSet
        AND COD_BARRA_INT = pcCodBarraInt; 
   ELSE
      SELECT NVL(EST_ATU,  0) AS EST_ATU, 
             Nvl(EST_KIT,  0) AS EST_KIT,
             NVL(EST_BLOQ, 0) AS EST_BLOQ
      INTO   fEstAtu, fEstKit, fEstBloq
      FROM ESESTCAD
      WHERE COD_PRD = pcCodPrd
        AND COD_SET = pcCodSet;
   END IF;
   
   IF TRIM(pcCodBarraInt) <> '' THEN
      INSERT INTO TL_KIT_FANTASMA ( TIPO_LOG, STATUS_KIT, ANTES_DEPOIS, COD_SET, CODIGO, COD_BARRA_INT, QUANT, COD_BARRA_KIT, DH_LOG, MATRICULA, EST_ATU, EST_KIT, EST_BLOQ, UNIT )
                  VALUES   ( 'K', pcusado, pAcao, pcCodSet, pcCodPrd, pcCodBarraInt, pfQuant, pcCodBarraKit, CURRENT, 0, fEstAtu, fEstKit, fEstBloq, 'Trigger' );
   ELSE         
	  INSERT INTO TL_KIT_FANTASMA ( TIPO_LOG, STATUS_KIT, ANTES_DEPOIS, COD_SET, CODIGO, QUANT, COD_BARRA_KIT, DH_LOG, MATRICULA, EST_ATU, EST_KIT, EST_BLOQ, UNIT )
                  VALUES   ( 'K', pcusado, pAcao, pcCodSet, pcCodPrd, pfQuant, pcCodBarraKit, CURRENT, 0, fEstAtu, fEstKit, fEstBloq, 'Trigger' );
   END IF;
END PROCEDURE;                                                                                                                                                                                                               
grant execute on procedure sp_gera_log_kit(char,char,char,float,char,char,char) to public;
                                                                                                     