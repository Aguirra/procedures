-------------------------------------------------------------
-- Criar Procedure - Inicio
-------------------------------------------------------------
CREATE PROCEDURE check_estrutura()
   define   status integer;

   SELECT COUNT(*)
     INTO  status
     FROM sysprocedures
    WHERE procname='sp_est_atuestkit';

   IF  status>0 THEN
      DROP PROCEDURE sp_est_atuestkit;
   END IF;
END PROCEDURE;

EXECUTE PROCEDURE check_estrutura();
DROP PROCEDURE check_estrutura;

CREATE PROCEDURE sp_est_atuestkit(pcCodSet CHAR(4),
                                  pdDataMov DATE,
                                  pcHoraMov CHAR(8),
                                  pcCodPrd CHAR(6),
                                  pcCodBarraInt CHAR(9),
                                  pfQuant FLOAT,
                                  pcCodBarraKit CHAR(10),
                                  pcusado CHAR(1))
-----------------------------------------------------------------------------------
-- Nome.......: sp_est_atuestkit
-- Autor .....: Leila Guerra
-- Finalidade.: Controle de Estoque/Kit. Atualizar o estoque dos produtos reservados
--              para o kit
--
-- Parametros.: pcCodSet  - codigo do setor
--              pdDataMov - data de movimento
--              pcHoraMov - hora de movimento
--              pcCodPrd  - codigo do produto
--              pcCodBarraInt - codigo de barras interno
--              pfQuant   - quantidade
--              pcCodBarraKit - Codigo de barra do Kit
--              pcusado - Indica o status do KIT
--
-- Observacao.: a quantidade passada no parametro devera estar convertida para
--              positivo ou negativo em relacao a atualizacao que sera realizada
--
--              2.  quando pcusado vier preenchido nao precisa ir na esestoque_kit
--
-- Historico :
-- 12/09/2006 - Leila                 - CR 31902 - Criacao da procedure
-- 05/06/2008 - Dyego Valenca         - CR 62238 - Verificacao do Kit Cancelado.
-- 03/07/2008 - Denilson Cartaxo      - CR 63980 - Correcao da verificacao de estoque
-- 02/12/2009 - Diego Figueredo       - CR 1294  - verifica se nao esta bloqueado
-- 23/08/2010 - Karina Almeida - CR2014 - Verificacao de produto que nao atualiza estoque
-----------------------------------------------------------------------------------
   DEFINE cSetor          CHAR(4);
   DEFINE cVerCodPrd      CHAR(6);
   DEFINE fEstAtu         FLOAT;
   DEFINE iQuant          INTEGER;
   DEFINE cMesFec         CHAR(1);
   DEFINE cEmBalanco      CHAR(1);
   DEFINE fEstBloq        DECIMAL(13,3);
   DEFINE fEstBloqEstCad  DECIMAL(13,3);
   DEFINE fEstKit         FLOAT;
   DEFINE cUsado          CHAR(01);
   DEFINE cCodBarraKit    CHAR(10);
   DEFINE cBloqueado      CHAR(1);
   DEFINE cTipoCons       CHAR(1);
   DEFINE nControlaVal    INTEGER;

   -- se o codigo de barra do kit foi passado, valida-lo
   IF NVL(pcCodBarraKit,' ') <> ' ' THEN
      IF pcusado IS NULL THEN
         LET cSetor = Null;
         LET cUsado = Null;
         SELECT usado, cod_barra_kit, cod_set
           INTO cUsado, cCodBarraKit, cSetor
           FROM esestoque_kit
          WHERE esestoque_kit.cod_barra_kit = pcCodBarraKit;
      ELSE
         LET cSetor = pcCodSet;
         LET cUsado = pcUsado;
         LET cCodBarraKit = pcCodBarraKit;
      END IF;
    
      IF NVL(cCodBarraKit, '') = '' then
         RAISE EXCEPTION -746, 0, 'Estoque nao atualizado.|Codigo de barra do kit nao localizado.';
      END IF;

      IF NVL(pcCodSet, '') <> cSetor THEN
         RAISE EXCEPTION -746, 0, 'Estoque nao atualizado.|O codigo de barra do kit nao pertence ao Setor.';
      END IF;
   END IF;

   -- se o codigo de barras interno foi passado, valida-lo
   IF NVL(pcCodBarraInt,' ') <> ' ' THEN
      LET cVerCodPrd = NULL;
      LET iQuant     = NULL;
      LET cBloqueado = NULL;

      -- filtro por lote nao bloqueado
      SELECT cod_prd, quantidade, sn_bloqueado
        INTO cVerCodPrd, iQuant,cBloqueado
        FROM eslote_validade
       WHERE cod_barra_int = pcCodBarraInt;

      -- verificar se registro existe
      IF NVL(cVerCodPrd,' ') = ' ' THEN
         RAISE EXCEPTION -746, 0, '[0005];' || pcCodBarraInt || ';' || pcCodPrd;
      END IF;
    
      -- verificar se o lote esta bloqueado
      IF NVL(cBloqueado,' ') = 'S' THEN
         RAISE EXCEPTION -746, 0, ' O codigo de barra interno [' || pcCodBarraInt || '] encontra-se bloqueado no sistema.';
      END IF;
    
      -- verificar se registro existe
      IF NVL(cVerCodPrd,' ') = ' ' THEN
         RAISE EXCEPTION -746, 0, '[0005];' || pcCodBarraInt || ';' || pcCodPrd;
      END IF;

      -- verificar se ele corresponde ao produto informado
      IF NVL(cVerCodPrd,' ') <> pcCodPrd THEN
         RAISE EXCEPTION -746, 0, '[0006];' || pcCodBarraInt || ';' || pcCodPrd;
      END IF;

      -- nao e permitida movimentacao de cod_barra_int com quantidade diferente de 1
      IF NVL(iQuant,0) <> 1 THEN
         RAISE EXCEPTION -746, 0, '[0007];' || pcCodBarraInt;
      END IF;
   END IF;

   -- ajusta o COD_BARRA_INT nos casos em que o produto nao utiliza o controle de lote/validade
   LET cSetor = NULL;

   SELECT cod_set
     INTO cSetor
     FROM esprod_set_lote
    WHERE cod_prd = pcCodPrd
      AND cod_set = pcCodSet;

   -- se tiver configuracao, o cod_barra_int e obrigatorio
   IF NVL(cSetor, ' ') <> ' ' AND NVL(pcCodBarraInt,' ') = ' ' THEN
      RAISE EXCEPTION -746, 0, '[0008];' || pcCodPrd || ';' || pcCodSet;
   END IF;

   -- se nao tiver configuracao, o cod_barra_int e passado em branco
   IF NVL(cSetor, ' ') = ' ' THEN
      LET pcCodBarraInt = ' ';
   END IF;

   -- se o produto controla, verificar se a movimentacao estah dentro do periodo de controle
   IF pcCodBarraInt <> ' ' THEN
      IF FC_EST_HABLOTEVAL(pcCodPrd, pcCodSet, pdDataMov, pcHoraMov) <> 'S' THEN
         RAISE EXCEPTION -746, 0, '[0013];' || pcCodPrd || ';' || pcCodSet;
      END IF;
   END IF;

   -- verifica o registro na ESESTCAD
   -- No caso da montagem do Kit, esse registro deve existir para que
   -- se possa atualizar a reserva do item para utilizacao no kit

   LET cSetor = NULL;
   LET cEmBalanco = NULL;
   LET fEstAtu = NULL;
   LET fEstBloqEstCad = NULL;
   LET fEstKit = NULL;

   SELECT cod_set, est_atu, est_bloq, est_kit, em_balanco
     INTO cSetor, fEstAtu, fEstBloqEstCad, fEstKit, cEmBalanco
     FROM esestcad
    WHERE cod_prd = pcCodPrd
      AND cod_set = pcCodSet
      AND cod_barra_int = pcCodBarraInt;

   LET fEstAtu        = NVL(fEstAtu,0);
   LET fEstBloqEstCad = NVL(fEstBloqEstCad,0);
   LET fEstKit        = NVL(fEstKit,0);

   -- nao permitir atualizacao de produto em balanco

   IF NVL(cEmBalanco,'N') = 'S' THEN
      RAISE EXCEPTION -746, 0, '[0009];' || pcCodSet || ';' || pcCodPrd;
   END IF;

   IF (fEstAtu - pfQuant - fEstBloqEstCad - fEstKit) < 0 THEN
      RAISE EXCEPTION -746, 0, '[0010];' || pcCodSet || ';' || pcCodPrd || ';' || ROUND(fEstAtu - pfQuant - fEstBloqEstCad - fEstKit,3);
   END IF;

   SELECT tipo_cons
     INTO cTipoCons
     FROM faprdcad
    WHERE codigo = pcCodPrd;

   -- VERIFICA SE CONTROLA LOTE E VALIDADE
   SELECT count(*)
     INTO nControlaVal
     FROM ESPROD_SET_LOTE
    WHERE COD_PRD = pccodprd
      AND COD_SET = pccodset;

   -- atualizar o estoque reservado do item do kit
   IF cTipoCons = '0' THEN
     IF nControlaVal > 0 THEN
        --Grava log para analise do problema no saldo dos kits (Temporario)
        EXECUTE PROCEDURE sp_gera_log_kit(pccodset, pccodprd, pcCodBarraInt, pfQuant, pcCodBarraKit, pcusado, 'A');   
	    
            UPDATE ESESTCAD
		   SET EST_KIT = NVL(EST_KIT, 0) + pfQuant,
			   CONTROLE = DECODE(CONTROLE,'0','1','0')
         WHERE COD_PRD = pcCodPrd
	       AND COD_SET = pcCodSet
	       AND COD_BARRA_INT = pcCodBarraInt;
	       
        --Grava log para analise do problema no saldo dos kits (Temporario)
        EXECUTE PROCEDURE sp_gera_log_kit(pcCodSet, pcCodPrd, pcCodBarraInt, pfQuant, pcCodBarraKit, pcusado, 'D'); 
     ELSE
        --Grava log para analise do problema no saldo dos kits (Temporario)
        EXECUTE PROCEDURE sp_gera_log_kit(pcCodSet, pcCodPrd, '', pfQuant, pcCodBarraKit, pcusado, 'A');
        
		UPDATE ESESTCAD
		   SET EST_KIT = NVL(EST_KIT, 0) + pfQuant,
			   CONTROLE = DECODE(CONTROLE,'0','1','0')
	     WHERE COD_PRD = pcCodPrd
		   AND COD_SET = pcCodSet
           AND (cod_barra_int = '' OR cod_barra_int = ' ' OR cod_barra_int IS NULL);
           
        --Grava log para analise do problema no saldo dos kits (Temporario)
        EXECUTE PROCEDURE sp_gera_log_kit(pcCodSet, pcCodPrd, '', pfQuant, pcCodBarraKit, pcusado, 'D'); 
     END IF;
   END IF;
END PROCEDURE;
grant execute on procedure sp_est_atuestkit to public;