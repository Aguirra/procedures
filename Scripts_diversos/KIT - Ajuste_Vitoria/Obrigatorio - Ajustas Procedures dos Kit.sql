--Criar Procedure -Inicio 
CREATE PROCEDURE check_estrutura()
define ncount integer; 

  SELECT COUNT(*)
    INTO ncount 
    FROM sysprocedures
   WHERE procname='sp_gera_log_kit'; 

  IF ncount>0 THEN 
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
   DEFINE cComp           VARCHAR(255);
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

      LET cComp = 'LOG KIT ' || Trim(pcCodBarraKit) || ' Setor:' || Trim(pcCodSet) || ' Prd:'|| Trim(pcCodPrd) ||' CodBarInt:' || Trim(pcCodBarraInt) ||  ' Usado:' || Trim(pcusado) || ' Qtd: ' || pfQuant || ' EstAtu:' || fEstAtu || ' EstKit:' || fEstKit || ' Bloq:' || fEstBloq  || ' Acao:' || pAcao ;
      INSERT INTO FALOGCAD ( SISTEMA, MODULO, FUNCAO, MATRICULA, DATA, COMPLEMENTO )
                  VALUES   ( 'EST', 'ESCON', 'INC', 0, CURRENT, cComp );
   ELSE         
      LET cComp = 'LOG KIT ' || Trim(pcCodBarraKit) || ' Setor:' || Trim(pcCodSet) || ' Prd:' || Trim(pcCodPrd) ||  ' Usado:' || Trim(pcusado) || ' Qtd: ' ||pfQuant || ' EstAtu:' || fEstAtu|| ' EstKit:' || fEstKit || ' Bloq:' || fEstBloq || ' Acao:' || pAcao;
      INSERT INTO FALOGCAD ( SISTEMA, MODULO, FUNCAO, MATRICULA, DATA, COMPLEMENTO )
                  VALUES   ( 'EST', 'ESCON', 'INC', 0, CURRENT, cComp );
   END IF;
END PROCEDURE;

GRANT EXECUTE ON sp_gera_log_kit TO PUBLIC;

--Criar Procedure -Inicio 
CREATE PROCEDURE check_estrutura()
define ncount integer; 

  SELECT COUNT(*)
    INTO ncount 
    FROM sysprocedures
   WHERE procname='sp_est_esmovite'; 

  IF ncount>0 THEN 
    DROP PROCEDURE sp_est_esmovite;
  END IF;
END PROCEDURE; 

EXECUTE PROCEDURE check_estrutura();
DROP PROCEDURE check_estrutura; 

CREATE PROCEDURE SP_EST_ESMOVITE(pcOperacao CHAR(1),
                                 pcTipoDoc CHAR(3),
                                 pcDocumento CHAR(7),
                                 pcNota CHAR(11),
                                 pcCodPrd CHAR(6),
                                 pcCodBarraInt CHAR(9),
                                 pfQuant FLOAT,
                                 pcCodBarraKit CHAR(10),
								 pcAtuEstKit CHAR(1))
-----------------------------------------------------------------------------------
-- Nome.......: SP_EST_ESMOVITE
-- Autor .....: Denilson Cartaxo
-- Finalidade.: atualizar o estoque a partir das triggers de ESMOVITE
--
-- Parametros : pcOperacao  - operacao (I  inclusao, A - Alteracao, E - Exclusao)
--              pcTipoDoc   - tipo do documento
--              pcDocumento - numero do documento
--              pcNota      - numero da nota fiscal
--              pcCodPrd    - codigo do produto
--              pcCodBarraInt - codigo de barras interno
--              pfQuant     - quantidade
--              pcCodBarraKit - codigo de barras kit
--
-- Retornos...:
--
-- Observacao.: para as transferências são feitas atualizações em relação ao
--              set_est => setor de saída (débito);
--              set_con => setor de entrada (crédito)
--
--              para os documentos de empréstimo e movimento de estoque, será
--              atualizada a pendência destes movimentos
--
-- Referencias: TI_ESMOVITE, TU_ESMOVITE, TD_ESMOVITE
--
-- Histórico :
--  16/11/2005 - Denilson - CR 33348 - Criacao da procedure
--  14/12/2005 - Denilson - CR 31909 - tratamento do controle de receb. de transf.
--               passar os indicadores de controle de recebimento e de pendencia da
--               transferencia
--  29/12/2005 - Denilson - CR 33929 - passar a hora de movimentacao
--  20/04/2006 - Wellington - CR 36204 - Verificação da quantidade de suprimento
--  13/09/2006 - Leila - CR 31902 - Controle de Estoque / Kit
--  12/01/2007 - Paulo Queiroga - CR39814 - Transferencias Externas
-----------------------------------------------------------------------------------
  DEFINE cSetEst    CHAR(4);
  DEFINE cSetCon    CHAR(4);
  DEFINE cCredDeb   CHAR(1);
  DEFINE cCodUni    CHAR(6);
  DEFINE dDataMov   DATE;
  DEFINE cContReceb CHAR(1);
  DEFINE cPendente  CHAR(1);
  DEFINE cHoraMov   CHAR(8);
  DEFINE cCodPac    CHAR(7);

  -- pesquisar os dados do cabeçalho do movimento

  LET cSetEst, cSetCon, cCredDeb, cCodUni, cContReceb, cPendente, dDataMov, cHoraMov, cCodPac= SP_EST_DADOSDOC(pcTipoDoc, pcDocumento, pcNota);

  IF pcTipoDoc IN ('TRA','TRE') THEN
     LET cCredDeb = 'D';
  END IF;

  -- inclusão / alteração de operações de saída do estoque => abater do estoque atual
  -- exclusões de operações de entrada do estoque  => abater do estoque atual

  IF (cCredDeb = 'D' AND pcOperacao <> 'E')  OR (cCredDeb = 'C' AND pcOperacao = 'E') THEN
     LET pfQuant = pfQuant * (-1);
  END IF;

  -- atualiza o estoque do setor do documento de estoque. Os indicadores de controle de recebimento
  -- de transferencia serao passados de forma que nao se atualize EST_BLOQ, pois esta atualizacao
  -- é feita apenas para o setor que receberá a transferencia.

  CALL SP_EST_ATUEST(pcTipoDoc,
                     cSetEst,
                     cCodUni,
                     dDataMov,
                     cHoraMov,
                     'N',
                     'S',
                     pcCodPrd,
                     pcCodBarraInt,
                     pfQuant,
                     cCodPac,
                     pcCodBarraKit,
					 pcAtuEstKit);

------------------------------------------------------------------------------------
-- atualiza as informações da entrada para as transferencias,
-- fQuant deve ser o inverso da operação
-- de saída feita pela chamada a SP_EST_ATUEST no trecho acima
------------------------------------------------------------------------------------

  IF pcTipoDoc IN ('TRA','TRE') THEN

     CALL SP_EST_ATUEST(pcTipoDoc,
                        cSetCon,
                        cCodUni,
                        dDataMov,
                        cHoraMov,
                        cContReceb,
                        cPendente,
                        pcCodPrd,
                        pcCodBarraInt,
                        pfQuant * (-1),
                        cCodPac,
                        pcCodBarraKit,
						pcAtuEstKit);

  END IF;

------------------------------------------------------------------------------------
-- para as rotinas de emprestimo e movimento de estoque, deve-se atualizar o saldo
------------------------------------------------------------------------------------

  IF pcTipoDoc IN ('EMP','MOV') THEN

     CALL SP_EST_ATUSALDOEMP(pcTipoDoc,
                             pcCodPrd,
                             cCodUni,
                             pfQuant);

  END IF;

END PROCEDURE;

GRANT EXECUTE ON sp_est_esmovite TO PUBLIC; 


--Criar Procedure -Inicio 
CREATE PROCEDURE check_estrutura()
define ncount integer; 

  SELECT COUNT(*)
    INTO ncount 
    FROM sysprocedures
   WHERE procname='sp_est_atuest'; 

  IF ncount>0 THEN 
    DROP PROCEDURE sp_est_atuest;
  END IF;
END PROCEDURE; 

EXECUTE PROCEDURE check_estrutura();
DROP PROCEDURE check_estrutura; 

CREATE PROCEDURE sp_est_atuest(pcTipoDoc CHAR(3),
                               pcCodSet CHAR(4),
                               pcCodUni CHAR(6),
                               pdDataMov DATE,
                               pcHoraMov CHAR(8),
                               pcContReceb CHAR(1),
                               pcPendente CHAR(1),
                               pcCodPrd CHAR(6),
                               pcCodBarraInt CHAR(9),
                               pfQuant DECIMAL(13,3),
                               pcCodPac CHAR(7),
                               pcCodBarraKit CHAR(10),
							   pcAtuEstKit CHAR(1))
-----------------------------------------------------------------------------------
-- Nome.......: SP_EST_ATUEST
-- Autor .....: Denilson Cartaxo
-- Finalidade.: atualizar o estoque dos produtos, se o produto nao tiver cadastro
--              na esestcad, sera inserido registro na tabela.
--
-- Parametros.: pcTipoDoc - tipo de documento
--              pcCodSet  - codigo do setor
--              pcCodUni  - codigo da unidade
--              pdDataMov - data de movimento
--              pcHoraMov - hora de movimento
--              pcContReceb - indica se a transf. controle recebimento
--              pcPendente - indica se a transf. esta pendente
--              pcCodPrd  - codigo do produto
--              pcCodBarraInt - codigo de barras interno
--              pfQuant   - quantidade
--              pcCodPac  - codigo do paciente
--              pcCodBarraKit - codigo de barra do kit
--              pcAtuEstKit - indica se atualiza estoque kit (agora so a inclusao do item altera o valor) 

-- Observacao.: a quantidade passada no parametro devera estar covnertida para
--              positivo ou negativo em relacao a atualizacao que sera realizada
--              antes de atualizar o sistema verifica se o codigo de barras interno
--              e obrigatorio.
--
-- Referencias: SP_EST_ESMOVITE, SP_EST_ESMOVCAD
--
-- Historico :
--  16/11/2005 - Denilson               - CR 33348 - Criacao da procedure
--  14/12/2005 - Denilson               - CR 31909 - tratamento do controle de receb. de transf.
--                                                   atualizar o estoque bloqueado
--  29/12/2005 - Denilson               - CR 33929 - verificacao se movimentacao dentro do
--                                                   periodo do lote/validade
--  20/04/2006 - Wellington             - CR 36204 - Verificacao da quantidade de suprimento
--  13/09/2006 - Leila                  - CR 31902 - Controle de Estoque / Kit
--  25/01/2007 - Paulo Queiroga         - CR 39814 - alteracoes para implementacao de Transferencias Externas
--  11/04/2007 - Fernando Cerqueira     - CR 43995 - alteracao do tipo da variavel 
--                                                   fEstAtu de FLOAT para DECIMAL.
--  20/08/2007 - Diego Lages            - CR 51712 - Realizar corretamente a critica de saldo de estoque quando o produto
--                                                   em questao for um item de kit montado para controle de estoque.
--  01/10/2007 - Tiago Moraes           - CR 49614 - Passa a data do movimento para a procedure SP_EST_VERSUPRI
--                                                   para verificar a existencia de excecoes de suprimento.
--  29/01/2008 - Bruno Rocha            - CR 58245 - Correcao de erro na montagem da instrucao SQL 
--                                                   quando pcCodBarraInt = ''
--  05/06/2008 - Dyego Valenca          - CR 62238 - Verificacao do Kit Cancelado.
--  02/12/2009 - Diego Figueredo        - CR 1294  - Verifica se o produto nao esta bloqueado.
-----------------------------------------------------------------------------------------------
   DEFINE cSetor          CHAR(4);
   DEFINE cVerCodPrd      CHAR(6);
   DEFINE fEstAtu         DECIMAL(13,3);
   DEFINE iQuant          INTEGER;
   DEFINE cMesFec         CHAR(1);
   DEFINE cEmBalanco      CHAR(1);
   DEFINE cBloqMovEstZero CHAR(1);
   DEFINE fEstBloq        DECIMAL(13,3);
   DEFINE fEstBloqEstCad  DECIMAL(13,3);
   DEFINE fEstKit         DECIMAL(13,3);
   DEFINE cContEstKit     CHAR(1);
   DEFINE cUsado          CHAR(1);
   DEFINE cCodBarraKit    CHAR(10);
   DEFINE cBloqueado      CHAR(1);
   DEFINE fQuantKit       DECIMAL(13,3);

   -- nao permitir alteracao das quantidades quando o item tiver sido confirmado
   IF pcTipoDoc IN ('TRA','TRE') AND pcContReceb = 'S' AND pcPendente = 'N' AND pfQuant <> 0 THEN
      RAISE EXCEPTION -746, 0, 'Operacao nao pode ser efetuada, pois a Transferencia ja foi confirmada.';
   END IF;

   -- nao permitir atualizacao de estoque se o mes estiver fechado
   LET cMesFec = fc_est_mesfechado(pcCodUni, pdDataMov);

   IF NVL(cMesFec,'N') = 'S' THEN
      RAISE EXCEPTION -746, 0, 'Estoque nao atualizado.|Movimento pertence a um mes fechado.';
   END IF;

   LET cUsado = NULL;
   LET cSetor = NULL;
   LET cVerCodPrd = NULL;
   LET cContEstKit = 'N';

   -- Se o codigo de barras do kit foi passado, valida-lo
   IF (pcAtuEstKit = 'S') AND NVL(pcCodBarraKit,' ') <> ' ' THEN
      SELECT cod_set, cod_prd, usado, esestoque_kit_prd.cod_barra_kit, esestoque_kit_prd.quant
        INTO cSetor, cVerCodPrd, cUsado, cCodBarraKit, fQuantKit
        FROM esestoque_kit, esestoque_kit_prd
       WHERE esestoque_kit.cod_barra_kit = esestoque_kit_prd.cod_barra_kit
         AND esestoque_kit_prd.cod_barra_kit = pcCodBarraKit
         AND esestoque_kit_prd.cod_barra_int = NVL(pcCodBarraInt,'')
         AND esestoque_kit_prd.cod_prd = pcCodPrd ;

      IF NVL(cCodBarraKit, '') = '' then
         RAISE EXCEPTION -746, 0, 'Estoque nao atualizado.|Codigo de barra do kit nao localizado.';
      END IF;

      IF NVL(cSetor, '') <> pcCodSet THEN
         RAISE EXCEPTION -746, 0, 'Estoque nao atualizado.|O codigo de barra do kit nao pertence ao Setor.';
      END IF;

      IF NVL(cVerCodPrd, '') <> pcCodPrd THEN
         RAISE EXCEPTION -746, 0, 'Estoque nao atualizado.|O codigo de barra do kit nao pertence ao produto.';
      END IF;

      IF (NVL(pfQuant, 0) > 0) AND (NVL(cUsado, '') <> 'S') THEN
         RAISE EXCEPTION -746, 0, 'Estoque nao atualizado.|O codigo de barra do kit nao pode ser devolvido sem ter sido utilizado.';
      END IF;

      IF (NVL(pfQuant, 0) < 0) AND (NVL(cUsado, '') <> 'N') THEN
         INSERT INTO passo_executado VALUES (pcCodSet, current);
         RAISE EXCEPTION -746, 0, 'Estoque nao atualizado.|Codigo de barra do kit ja utilizado.';
      END IF;
    
     IF NVL(fQuantKit,0) <> ABS(NVL(pfQuant,0)) THEN
        RAISE EXCEPTION -746,0, '[1010];' || cCodBarraKit || ';' || pcCodPrd || ';' || NVL(ABS(pfQuant),0) || ';' || NVL(fQuantKit,0);
     END IF;

	 IF (NVL(pfQuant,0) <> 0) AND (NVL(cUsado,' ')='C') THEN
         RAISE EXCEPTION -746,0, 'Estoque nao atualizado.| O KIT encontra-se cancelado.';
      END IF;

      LET cContEstKit = 'S';
   END IF;

   -- se o codigo de barras interno foi passado, valida-lo
   IF NVL(pcCodBarraInt,' ') <> ' ' THEN

      LET cVerCodPrd = NULL;
      LET iQuant     = NULL;
      LET cBloqueado = NULL;

      -- filtra por lote nao bloqueado
      SELECT cod_prd, quantidade, sn_bloqueado
        INTO cVerCodPrd, iQuant,cBloqueado
        FROM eslote_validade
       WHERE cod_barra_int = pcCodBarraInt; 

      -- verificar se registro existe
      IF NVL(cVerCodPrd,' ') = ' ' THEN
         RAISE EXCEPTION -746, 0, '[0005];' || pcCodBarraInt || ';' || pcCodPrd || '';
      END IF;
    
      IF NVL(cBloqueado,' ') = 'S' THEN
         RAISE EXCEPTION -746, 0, ' O código de barra interno [' || pcCodBarraInt || '] encontra-se bloqueado no sistema.';
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
      IF fc_est_habloteval(pcCodPrd, pcCodSet, pdDataMov, pcHoraMov) <> 'S' THEN
         RAISE EXCEPTION -746, 0, '[0013];' || pcCodPrd || ';' || pcCodSet;
      END IF;
   END IF;

   -- verifica se o registro ja existe na ESESTCAD para saber se serah UPDATE ou INSERT

   LET cSetor = NULL;
   LET cEmBalanco = NULL;
   LET fEstAtu = NULL;
   LET fEstBloqEstCad = NULL;
   LET fEstKit = NULL;

   SELECT cod_set, est_atu, est_bloq, em_balanco, est_kit
     INTO cSetor, fEstAtu, fEstBloqEstCad, cEmBalanco, fEstKit
     FROM esestcad
    WHERE cod_prd = pcCodPrd
      AND cod_set = pcCodSet
      AND cod_barra_int = pcCodBarraInt;

   LET fEstAtu = NVL(fEstAtu,0);
   LET fEstBloqEstCad = NVL(fEstBloqEstCad,0);
   LET fEstKit = NVL(fEstKit,0);

   -- nao permitir atualizacao de produto em balanco

   IF pcTipoDoc <> 'BAL' AND NVL(cEmBalanco,'N') = 'S' THEN
      RAISE EXCEPTION -746, 0, '[0009];' || pcCodSet || ';' || pcCodPrd;
   END IF;

   -- quando tiver verificando uma transferencia que controla o recebimento, o saldo de estoque deve ser verificado

   IF pcTipoDoc IN ('TRA','TRE') AND pcContReceb = 'S' THEN
      LET fEstBloqEstCad = 0;
   END IF;

   -- verifica se estoque ficara negativo

   LET cBloqMovEstZero = NULL;

   SET ISOLATION TO DIRTY READ;

   SELECT MAX(blo_mov_est_zero)
     INTO cBloqMovEstZero
     FROM fatab;

   SET ISOLATION TO COMMITTED READ;

   LET cBloqMovEstZero = NVL(cBloqMovEstZero,'N');

   IF (cContEstKit = 'S') THEN
      IF cBloqMovEstZero = 'S' AND (fEstKit + pfQuant) < 0 THEN
         RAISE EXCEPTION -746, 0, '[0010];' || pcCodSet || ';' || pcCodPrd || ' (KIT);' || ROUND(NVL(fEstKit,0) + NVL(pfQuant,0),3);
      END IF;
   ELSE
      IF cBloqMovEstZero = 'S' AND (fEstAtu + pfQuant - fEstBloqEstCad - fEstKit) < 0 THEN
         RAISE EXCEPTION -746, 0, '[0010];' || pcCodSet || ';' || pcCodPrd || ';' || ROUND(NVL(fEstAtu,0) + NVL(pfQuant,0),3);
      END IF;
   END IF;

   -- ajusta a quantidade bloqueada se a transferencia controla pendencia de recebimento

   IF pcTipoDoc IN ('TRA','TRE') AND pcContReceb = 'S' AND pcPendente <> 'N' AND pfQuant <> 0 THEN
      LET fEstBloq = pfQuant;
   ELSE
      LET fEstBloq = 0;
   END IF;

   -- ajusta a quantidade reservada para o kit, caso utilize cod. barra kit
   IF (cContEstKit = 'S') THEN
      LET fEstKit = NVL(pfQuant,0);
   ELSE
      LET fEstKit = 0;
   END IF;

   -- se nao encontrou, incluir registro, senao, atualizar

   IF NVL(cSetor, ' ') = ' ' THEN
      -- verifica se estoque ficara negativo
      IF NVL(pfQuant,0) < 0 THEN
         RAISE EXCEPTION -746, 0, '[0010];' || pcCodSet || ';' || pcCodPrd || ';' || ROUND(pfQuant,3);
      END IF;

      -- incluir registro na tabela de estoque
      INSERT INTO esestcad (cod_set, cod_prd, cod_barra_int, est_atu, 
                            localizacao, reservado, em_balanco, 
                            pct_ponto_repos, est_bloq, controle, est_kit)
      VALUES (pcCodSet, pcCodPrd, pcCodBarraInt, pfQuant, ' ', 0, 'N', 0, fEstBloq, '0', fEstKit);

      -- verificar se existe registro na esestmov para incluir se nao tiver
      LET cSetor = NULL;

      SELECT cod_set
        INTO cSetor
        FROM esestmov
       WHERE cod_prd = pcCodPrd
         AND cod_set = pcCodSet;

      IF NVL(cSetor, ' ') = ' ' THEN
         INSERT INTO esestmov (cod_set, cod_prd, localizacao, reservado, em_balanco, pct_ponto_repos)
         VALUES (pcCodSet, pcCodPrd, ' ', 0, 'N', 0);
      END IF;
   ELSE
      IF NVL(pcCodBarraKit,' ') <> ' ' THEN
	    --Grava log para analise do problema no saldo dos kits (Temporário)
        EXECUTE PROCEDURE sp_gera_log_kit(pcCodSet, pcCodPrd, Trim(pcCodBarraInt), pfQuant, pcCodBarraKit, 'S', 'A'); 
	  END IF; 
		
      -- atualizar o estoque do item
      UPDATE esestcad
         SET est_atu = est_atu + pfQuant,
             est_bloq = est_bloq + fEstBloq,
             est_kit  = est_kit  + fEstKit,
             controle = DECODE(controle,'0','1','0')
       WHERE cod_prd = pcCodPrd
         AND cod_set = pcCodSet
         AND cod_barra_int = pcCodBarraInt;
		 
      IF NVL(pcCodBarraKit,' ') <> ' ' THEN
	    --Grava log para analise do problema no saldo dos kits (Temporário)
        EXECUTE PROCEDURE sp_gera_log_kit(pcCodSet, pcCodPrd, Trim(pcCodBarraInt), pfQuant, pcCodBarraKit, 'S', 'D'); 
	  END IF; 		 
   END IF;

   -- depois de atualizar, verificar o suprimento quando se tratar de acrescimo em estoque
   IF pfQuant > 0 THEN
      CALL sp_est_versupri(pcTipoDoc, pcCodPrd, pcCodSet, pcCodPac, pdDataMov);
   END IF;

END PROCEDURE;

GRANT EXECUTE ON sp_est_atuest TO PUBLIC; 


--Criar Procedure -Inicio 
CREATE PROCEDURE check_estrutura()
define ncount integer; 

  SELECT COUNT(*)
    INTO ncount 
    FROM sysprocedures
   WHERE procname='sp_est_esmovcad'; 

  IF ncount>0 THEN 
    DROP PROCEDURE sp_est_esmovcad;
  END IF;
END PROCEDURE; 

EXECUTE PROCEDURE check_estrutura();
DROP PROCEDURE check_estrutura; 

CREATE PROCEDURE SP_EST_ESMOVCAD(pcOperacao CHAR(1),
                                 pcTipoDoc CHAR(3),
                                 pcCodUni CHAR(6),
                                 pdDataMov DATE,
                                 pcHoraMov CHAR(8),
                                 pcSetEst CHAR(4),
                                 pcCredDeb CHAR(1),
                                 pcContReceb CHAR(1),
                                 pcPendente CHAR(1),
                                 pcCodPrd CHAR(6),
                                 pcCodBarraInt CHAR(9),
                                 pfQuant FLOAT,
                                 pcCodPac CHAR(7))

-----------------------------------------------------------------------------------
-- Nome.......: SP_EST_ESMOVCAD
-- Autor .....: Denilson Cartaxo
-- Finalidade.: atualizar o estoque das alterações feitas pela troca de setor
--
-- Parametros.: pcOperacao - operação (I - inclusao, A - Alteração, E- Exclusão)
--              pcTipoDoc  - tipo do documento
--              pcCodUni   - codigo da unidade
--              pdDataMov  - data de movimento
--              pcHoraMov  - hora de movimento
--              pcSetEst   - setor de estoque
--              pcCredDeb  - credito ou debito (C - Credito, D - Debito)
--              pcContReceb - indica se a trans. controla recebimento
--              pcPendente  - indica se a trans. esta pendente
--              pcCodPrd   - codigo do produto
--              pcCodBarraInt - codigo de barra interno
--              pfQuant    - quantidade
--
-- Retornos...:
--
-- Observacao.:
--
-- Referencias: SP_EST_ATU_MOVCAD
--
-- Histórico :
--  16/11/2005 - Denilson - CR 33348 - Criacao da procedure
--  14/12/2005 - Denilson - CR 31909 - tratamento do controle de receb. de transf.
--               passar os indicadores de controle de recebimento e de pendencia da
--               transferencia
--  29/12/2005 - Denilson - CR 33929 - passar a hora de movimentacao
--  20/04/2006 - Wellington - CR 36204 - Verificação da quantidade de suprimento
--  14/09/2006 - Leila - CR 31902 - passagem de do codigo de barra do kit como nulo
--               na procedure SP_EST_ATUEST
--  13/03/2007 - Ricardo Ferro - CR 44286 - reexpedicao da procedure como UTI em conjunto
--               com a CR43895
-----------------------------------------------------------------------------------

  -- inclusão / alteração de operações de saída do estoque => abater do estoque atual
  -- exclusões de operações de entrada do estoque  => abater do estoque atual

  IF (pcCredDeb = 'D' AND pcOperacao <> 'E')  OR (pcCredDeb = 'C' AND pcOperacao = 'E') THEN
     LET pfQuant = pfQuant * (-1);
  END IF

  -- atualiza o estoque do setor do documento de estoque

  CALL SP_EST_ATUEST(pcTipoDoc,
                     pcSetEst,
                     pcCodUni,
                     pdDataMov,
                     pcHoraMov,
                     pcContReceb,
                     pcPendente,
                     pcCodPrd,
                     pcCodBarraInt,
                     pfQuant,
                     pcCodPac,
                     NULL,
                     'N');

END PROCEDURE;

GRANT EXECUTE ON sp_est_esmovcad TO PUBLIC; 


--Criar Procedure -Inicio 
CREATE PROCEDURE check_estrutura()
define ncount integer; 

  SELECT COUNT(*)
    INTO ncount 
    FROM sysprocedures
   WHERE procname='sp_est_atuestkit'; 

  IF ncount>0 THEN 
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
   DEFINE cBloqMovEstZero CHAR(1);
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
      END IF

      IF NVL(pcCodSet, '') <> cSetor THEN
         RAISE EXCEPTION -746, 0, 'Estoque nao atualizado.|O codigo de barra do kit nao pertence ao Setor.';
      END IF
   END IF

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
      END IF
    
      -- verificar se o lote esta bloqueado
      IF NVL(cBloqueado,' ') = 'S' THEN
         RAISE EXCEPTION -746, 0, ' O codigo de barra interno [' || pcCodBarraInt || '] encontra-se bloqueado no sistema.';
      END IF
    
      -- verificar se registro existe
      IF NVL(cVerCodPrd,' ') = ' ' THEN
         RAISE EXCEPTION -746, 0, '[0005];' || pcCodBarraInt || ';' || pcCodPrd;
      END IF

      -- verificar se ele corresponde ao produto informado
      IF NVL(cVerCodPrd,' ') <> pcCodPrd THEN
         RAISE EXCEPTION -746, 0, '[0006];' || pcCodBarraInt || ';' || pcCodPrd;
      END IF

      -- nao e permitida movimentacao de cod_barra_int com quantidade diferente de 1
      IF NVL(iQuant,0) <> 1 THEN
         RAISE EXCEPTION -746, 0, '[0007];' || pcCodBarraInt;
      END IF
   END IF

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
   END IF

   -- se nao tiver configuracao, o cod_barra_int e passado em branco
   IF NVL(cSetor, ' ') = ' ' THEN
      LET pcCodBarraInt = ' ';
   END IF

   -- se o produto controla, verificar se a movimentacao estah dentro do periodo de controle
   IF pcCodBarraInt <> ' ' THEN
      IF FC_EST_HABLOTEVAL(pcCodPrd, pcCodSet, pdDataMov, pcHoraMov) <> 'S' THEN
         RAISE EXCEPTION -746, 0, '[0013];' || pcCodPrd || ';' || pcCodSet;
      END IF
   END IF

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
   END IF

   -- verifica se estoque ficara negativo
   LET cBloqMovEstZero = NULL;

   SET ISOLATION TO DIRTY READ;

   SELECT MAX(blo_mov_est_zero)
     INTO cBloqMovEstZero
     FROM fatab;

   SET ISOLATION TO COMMITTED READ;

   LET cBloqMovEstZero = NVL(cBloqMovEstZero,'N');

   IF cBloqMovEstZero = 'S' AND (fEstAtu - pfQuant - fEstBloqEstCad - fEstKit) < 0 THEN
      RAISE EXCEPTION -746, 0, '[0010];' || pcCodSet || ';' || pcCodPrd || ';' || ROUND(fEstAtu - pfQuant - fEstBloqEstCad - fEstKit,3);
   END IF

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
        --Grava log para analise do problema no saldo dos kits (Temporário)
        EXECUTE PROCEDURE sp_gera_log_kit(pcCodSet, pcCodPrd, pcCodBarraInt, pfQuant, pcCodBarraKit, cUsado, 'A');        

	    UPDATE ESESTCAD
		   SET EST_KIT = NVL(EST_KIT, 0) + pfQuant,
			   CONTROLE = DECODE(CONTROLE,'0','1','0')
         WHERE COD_PRD = pcCodPrd
	       AND COD_SET = pcCodSet
	       AND COD_BARRA_INT = pcCodBarraInt;

        --Grava log para analise do problema no saldo dos kits (Temporário)
        EXECUTE PROCEDURE sp_gera_log_kit(pcCodSet, pcCodPrd, pcCodBarraInt, pfQuant, pcCodBarraKit, cUsado, 'D');  
     ELSE
        --Grava log para analise do problema no saldo dos kits (Temporário)
        EXECUTE PROCEDURE sp_gera_log_kit(pcCodSet, pcCodPrd, '', pfQuant, pcCodBarraKit, cUsado, 'A'); 

		UPDATE ESESTCAD
		   SET EST_KIT = NVL(EST_KIT, 0) + pfQuant,
			   CONTROLE = DECODE(CONTROLE,'0','1','0')
	     WHERE COD_PRD = pcCodPrd
		   AND COD_SET = pcCodSet
           AND (cod_barra_int = '' OR cod_barra_int = ' ' OR cod_barra_int IS NULL);

		--Grava log para analise do problema no saldo dos kits (Temporário)
        EXECUTE PROCEDURE sp_gera_log_kit(pcCodSet, pcCodPrd, '', pfQuant, pcCodBarraKit, cUsado, 'D'); 
     END IF;
   END IF;
END PROCEDURE;

GRANT EXECUTE ON sp_est_atuestkit TO PUBLIC; 


--Criar Trigger -Inicio
CREATE PROCEDURE check_estrutura()
define ncount integer; 

  SELECT COUNT(*)
    INTO ncount 
    FROM systriggers
   WHERE trigname='td_es_mov'; 

  IF ncount>0 THEN 
    DROP TRIGGER td_es_mov;
  END IF;
END PROCEDURE; 

EXECUTE PROCEDURE check_estrutura();
DROP PROCEDURE check_estrutura; 

create trigger td_es_mov
   delete on esmovite
   referencing    old as old
-----------------------------------------------------------------------------------
-- Nome.......: TD_ES_MOV
-- Historico :
-- 16/11/2005 - Denilson - CR 33348 - atualizar o estoque de acordo com as
--              movimentacoes lancadas
-- 13/09/2006 - Leila                     - CR 31902 - controle de estoque / kit
-- 28/08/2007 - Felipe                    - CR 43850 - Remocao da integracao com m2m
-- 30/07/2009 - Dyego Valenca             - CR   854 - Uso da procedure sp_PreencheDtUlMov para
--                                                     preencher a data da ultima movimentacao
-- 19/11/2009 - Karina Almeida            - CR  1321 - Retirada da chamada da procedure sp_PreencheDtUlMov
-----------------------------------------------------------------------------------
    for each row
       ------------------------------------------------------------
       -- Atualizacao do estoque: desfazer a operacao de estoque
       ------------------------------------------------------------
       when (old.tipo_documento <> 'PED')
            (
              EXECUTE PROCEDURE SP_EST_ESMOVITE('E',
                                                old.tipo_documento,
                                                old.documento,
                                                old.nota,
                                                old.cod_prd,
                                                old.cod_barra_int,
                                                old.quant,
                                                old.cod_barra_kit,
												'N')
            ),
       when (((sp_integra_sap_gfv() = 1 ) AND
               (old.tipo_documento  = 'REQ'  )))
            (
             execute procedure sp_exreqi_sap_gfv(old.cod_prd,
                old.quant, old.documento,
                old.tipo_documento,old.nota
                ));

--Criar Trigger -Final


--Criar Trigger -Inicio
CREATE PROCEDURE check_estrutura()
define ncount integer; 

  SELECT COUNT(*)
    INTO ncount 
    FROM systriggers
   WHERE trigname='ti_es_mov'; 

  IF ncount>0 THEN 
    DROP TRIGGER ti_es_mov;
  END IF;
END PROCEDURE; 

EXECUTE PROCEDURE check_estrutura();
DROP PROCEDURE check_estrutura; 

create trigger ti_es_mov
   insert on esmovite
   referencing new as new
-----------------------------------------------------------------------------------
-- Nome.......: TI_ES_MOV
-- Historico :
-- 16/11/2005 - Denilson          - CR 33348 - atualizar o estoque de acordo com as
--                                              movimentacoes lancadas
-- 13/09/2006 - Leila             - CR 31902 - controle de estoque / kit
-- 29/03/2007 - Saulo Egito       - CR 43832 - validacao de codigo coorporativo
-- 30/07/2009 - Dyego Valenca     - CR   854 - Uso da procedure sp_PreencheDtUlMov para
--                                             preencher a data da ultima movimentacao
-- 19/11/2009 - Karina Almeida    - CR  1321 - Retirada da chamada da procedure sp_PreencheDtUlMov
-----------------------------------------------------------------------------------
    for each row
       when (((0. = (select count(*) from faprdcad x0 where (new.cod_prd = x0.codigo)))))
            (
            execute procedure erwin_raise_except(-746 ,'Nao inseri "Item do Mov. de Estoque" porque nao existe "Produtos/Servicos".'
            )),
       when (new.tipo_documento IN ('REQ', 'ACE', 'BAL', 'COM', 'EMP', 'MOV') )
            (
              EXECUTE PROCEDURE SP_EST_PRD_CORP(new.tipo_documento,
                                                new.documento,
                                                new.nota,
                                                new.cod_prd)
            ),
       ---------------------------------------------------------------------------------------------------
       -- Atualizacao do estoque: na alteracao e feito o acerto em relacao a quantidade alterada
       ---------------------------------------------------------------------------------------------------
       when (new.tipo_documento <> 'PED')
            (
              EXECUTE PROCEDURE SP_EST_ESMOVITE('I',
                                                new.tipo_documento,
                                                new.documento,
                                                new.nota,
                                                new.cod_prd,
                                                new.cod_barra_int,
                                                new.quant,
                                                new.cod_barra_Kit,
												'S')
            ),
       when ((sp_se_usa_m2mwpd() = 1) AND (new.tipo_documento = 'COM'))
             (execute procedure m2m_atu_movspd('I',
                                                new.cod_prd,
                                                new.documento,
                                                new.quant,
                                                new.nota,
                                                '',
                                                'U')),
       when (((sp_integra_sap_gfv()= 1 ) AND ((new.tipo_documento = 'TRA' )
           ) ) )
            (
            -- Registra na tabela de movimentacao a ser enviada para o SAP
            -- movimentacao de transferencia entre depositos
            execute procedure sp_initra_sap_gfv(new.cod_prd,
                                                      new.quant,
                                                      new.documento,
                                                      new.tipo_documento,
                                                      new.nota)),
       when (((sp_integra_sap_gfv()= 1 ) AND (new.tipo_documento = 'REQ' ) ) )
            (
            -- Registra na tabela de movimentacao a ser enviada para o SAP
            -- movimentacao de transferencia entre depositos
            execute procedure sp_inreqp_sap_gfv(new.cod_prd,
                                                new.quant,
                                                new.documento,
                                                new.tipo_documento,
                                                new.nota)),
       when (((sp_integra_sap_gfv()= 1 ) AND
               (new.tipo_documento in ( 'EMP','MOV') )))
            (
            -- Registra na tabela de movimentacao a ser enviada para o SAP
            -- movimentacao deinclusao de emprestimos
            execute procedure sp_incempi_sap_gfv(new.cod_prd,
                new.quant, new.documento,
                new.tipo_documento,new.nota
                ));

--Criar Trigger -Final


--Criar Trigger -Inicio
CREATE PROCEDURE check_estrutura()
define ncount integer; 

  SELECT COUNT(*)
    INTO ncount 
    FROM systriggers
   WHERE trigname='tu_es_mov'; 

  IF ncount>0 THEN 
    DROP TRIGGER tu_es_mov;
  END IF;
END PROCEDURE; 

EXECUTE PROCEDURE check_estrutura();
DROP PROCEDURE check_estrutura; 

CREATE TRIGGER tu_es_mov
   update on esmovite
   referencing old as old new as new
for each row
-----------------------------------------------------------------------------------
-- Nome.......: TU_ES_MOV
-- Autor .....: Denilson Cartaxo
-- Finalidade.: Atualizar o estoque de acordo com as movimentacoes lancadas
-- Historico  :
-- 16/11/2005 - Denilson            - CR 33348 - atualizar o estoque de acordo com as movimentacoes lancadas
-- 14/12/2005 - Denilson            - CR 31909 - tratamento do controle de receb. de transf.
-- 13/09/2006 - Leila               - CR 31902 - controle de estoque / kit
-- 08/11/2006 - Leila               - CR 41168 - Tratamento na atualizacao do estoque
-- 12/01/2007 - Paulo Queiroga      - CR 39814 - Tratamento para Transferencias Externas
-- 29/03/2007 - Saulo Egito         - CR 43832 - validacao de codigo coorporativo
-- 08/09/2008 - Ricardo Gusmao      - CR 66764 - Validacao se produto alterado para chamada da
--                                               SP_EST_PRD_CORP (CR60829)
-- 30/07/2009 - Dyego Valenca       - CR   854 - Uso da procedure sp_PreencheDtUlMov para
--                                               preencher a data da ultima movimentacao
-- 19/11/2009 - Karina Almeida      - CR  1321 - Retirada da chamada da procedure sp_PreencheDtUlMov
-----------------------------------------------------------------------------------
      when (new.tipo_documento IN ('REQ', 'ACE', 'BAL', 'COM', 'EMP', 'MOV') AND
                (new.cod_prd != old.cod_prd)
             )
           (
             EXECUTE PROCEDURE SP_EST_PRD_CORP(new.tipo_documento,
                                               new.documento,
                                               new.nota,
                                               new.cod_prd)
           ),
      ----------------------------------------------------------------------------------------------------------------
      -- Atualizacao da quantidade bloqueada do estoque => confirmacao de transferencia
      ----------------------------------------------------------------------------------------------------------------
        when (((((new.tipo_documento = 'TRA')
              OR (new.tipo_documento = 'TRE'))
         AND (old.pendente = 'S' ) )
         AND (new.pendente = 'N' ) ) )
           (
            execute procedure sp_est_atubloq(new.tipo_documento ,
                                               new.documento,
                                               new.nota,
                                               new.cod_prd,
                                               new.cod_barra_int,
                                               new.quant,
                                               'C')
           ),
      ----------------------------------------------------------------------------------------------------------------
      -- Atualizacao da quantidade bloqueada do estoque => cancelamento da confirmacao de transferencia
      ----------------------------------------------------------------------------------------------------------------
        when (((((new.tipo_documento = 'TRA')
              OR (new.tipo_documento = 'TRE'))
          AND (old.pendente != 'S' ) )
          AND (new.pendente = 'S' ) ) )
           (
            execute procedure sp_est_atubloq(new.tipo_documento ,
                                               new.documento,
                                               new.nota,
                                               new.cod_prd,
                                               new.cod_barra_int,
                                               new.quant,
                                               'N')
           ),
      ---------------------------------------------------------------------------------------------------
      -- Atualizacao do estoque: na alteracao e feito o acerto em relacao a quantidade alterada
      ---------------------------------------------------------------------------------------------------
        when (((((new.tipo_documento != 'PED' )
             AND (NVL (new.quant ,0 )!= NVL (old.quant ,0 )) )
             AND (NVL (new.cod_prd ,' ' )= NVL (old.cod_prd ,' ' )) )
             AND (NVL (new.cod_barra_int ,' ' )= NVL (old.cod_barra_int ,' ' )) ) )
           (
            execute procedure sp_est_esmovite('A' ,
                                               new.tipo_documento,
                                               new.documento,
                                               new.nota,
                                               new.cod_prd,
                                               new.cod_barra_int,
                                              (NVL (new.quant ,0 )- NVL (old.quant ,0 ))
                                              ,new.cod_barra_kit, 'N' )),
      ----------------------------------------------------------------------------------------------------------------
      -- Atualizacao do estoque: quando e feita alteracao do produto, fazer exclusao do anterior e inclusao do novo
      ----------------------------------------------------------------------------------------------------------------
        when (((new.tipo_documento != 'PED' )
           AND ((NVL (new.cod_prd ,' ' )!= NVL (old.cod_prd ,' ' ))
            OR (NVL (new.cod_barra_int ,' ' )!= NVL (old.cod_barra_int ,' ' )) ) ) )
           (
            execute procedure sp_est_esmovite('E' ,
                                               new.tipo_documento,
                                               new.documento,
                                               new.nota,
                                               old.cod_prd,
                                               old.cod_barra_int,
                                               NVL(old.quant,0),
                                              old.cod_barra_kit, 'N'),
            execute procedure sp_est_esmovite('I' ,
                                               new.tipo_documento,
                                               new.documento,
                                               new.nota,
                                               new.cod_prd,
                                               new.cod_barra_int,
                                               NVL(new.quant,0),
                                              new.cod_barra_kit, 'N' )),
      ----------------------------------------------------------------------------------------------------------------
      -- Integracao M2M
      ----------------------------------------------------------------------------------------------------------------
        when (((sp_se_usa_m2mwpd()= 1 )
           AND (new.tipo_documento = 'COM' ) ) )
            (
             execute procedure m2m_atu_movspd('A',
                                              new.cod_prd,
                                              new.documento,
                                              new.quant,
                                              new.nota,
                                              '',
                                              'U'));

--Criar Trigger -Final
