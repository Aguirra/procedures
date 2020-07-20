-- CR........: 3666
-- CRC.......: 1886
-- banco.....: WPDHOSP - INFORMIX
-- versao....: 71.03.04_ESHO
-- analista..: Karina Arantes
-- data......: 09/01/2012
-- cliente...: AMIL
-- finalidade: Atualizacao do novo campo co_unid_precpadrao
--             nas Triggers da tabela amunicad  
-------------------------------------------------------------

-------------------------------------------------------------
-- Criar Procedure - Inicio
-------------------------------------------------------------
CREATE PROCEDURE check_estrutura()
   define  ncount integer;

   SELECT COUNT(*)
     INTO ncount
     FROM sysprocedures
    WHERE procname='ajusta_unidades_preco';

   IF ncount>0 THEN
      DROP PROCEDURE ajusta_unidades_preco;
   END IF;
END PROCEDURE;

EXECUTE PROCEDURE check_estrutura();
DROP PROCEDURE check_estrutura;

-------------------------------------------------------------
-- Criar Procedure - Inicio
-------------------------------------------------------------
CREATE PROCEDURE check_estrutura()
   define  ncount integer;

   SELECT COUNT(*)
     INTO ncount
     FROM sysprocedures
    WHERE procname='ajusta_unidades_preco';

   IF ncount>0 THEN
      DROP PROCEDURE ajusta_unidades_preco;
   END IF;
END PROCEDURE;

EXECUTE PROCEDURE check_estrutura();
DROP PROCEDURE check_estrutura;
-- Cria procedure 
CREATE PROCEDURE ajusta_unidades_preco(Unid_Padrao varchar(40))
-----------------------------------------------------------------------------------
-- Nome.......: Ajusta_Unidades_Preco
-- Autor .....: Helton Lizandro
-- Finalidade.: Preco por Unidade de Faturamento 
--
-- Retornos...:
--
-- Observacao.: Esta procedure visa ajustar o Preco dos Produtos por Unidade Padrao
-- Referencias:
--
-----------------------------------------------------------------------------------
DEFINE vEstoque_Por_Unid_Faturamento VARCHAR(1);
DEFINE vUnidade_padrao_preco         VARCHAR(40);
DEFINE iCount, iIdPorte, iCount2     INTEGER;
DEFINE scod_uni                      LIKE AMUNICAD.COD_UNI; 
DEFINE stabela                       LIKE FAAPETAB.TABELA;
DEFINE stipo_prd                     LIKE FATIPCAD.TIPO_PRD;
DEFINE sdescricao                    LIKE FAAPETAB.DESCRICAO;
DEFINE scod_tabpreco_tiss            LIKE FAAPETAB.COD_TABPRECO_TISS;
DEFINE susa_divisor_simpr            CHAR(1);
DEFINE ssn_divi_brasind              CHAR(1);
DEFINE spk_apetab, sfk_apetab        LIKE FAAPETAB.PK_APETAB;
DEFINE scod_poa                      LIKE FAPOACAD.COD_POA;
DEFINE sFatura                       LIKE FAFATCAD.FATURA;
DEFINE sCodPrd                       LIKE FAPRDCAD.CODIGO;
DEFINE sValidade                     LIKE PRECO_PORTE_GER.VALIDADE;
DEFINE scod_porte                    LIKE PRECO_PORTE_GER.COD_PORTE;
DEFINE svalor                        LIKE PRECO_PORTE_GER.VALOR;
DEFINE spk_prepger                   LIKE PRECO_PORTE_GER.PK_PREPGER;


    /*Controlar o estoque por unidade de faturamento?*/
    SELECT valor
      INTO vEstoque_Por_Unid_Faturamento
      FROM wpdtab
     WHERE cod_parametro = 'estoque_por_unid_faturamento';

    /*Codigo da unidade padrao para unificacao das tabelas de precos*/
    SELECT VALOR 
      INTO vUnidade_padrao_preco
      FROM wpdtab
     WHERE cod_parametro = 'unidade_padrao_preco';

    IF vUnidade_padrao_preco <> '' THEN
      UPDATE faapetab 
         SET co_unidade = vUnidade_padrao_preco
       WHERE (co_unidade is null) OR (co_unidade = '');

      UPDATE amunicad
         SET co_unid_precpadrao = vUnidade_padrao_preco
       WHERE (co_unidade is null) OR (co_unidade = '');
 
      -- Update para ajustar a base, pois o passo 232 saiu com erro. 
      -- Foi dado o update da FaCciCad para todos os registros.
      UPDATE faccicad
         SET co_unidade = ''
       WHERE (trim(cod_set) = '');

      UPDATE faccicad 
         SET co_unidade = vUnidade_padrao_preco
       WHERE (cod_set <> '')
         AND ((co_unidade is null) OR (co_unidade = ''));
 
      UPDATE cob_conv_setor
         SET co_unidade = vUnidade_padrao_preco
       WHERE (co_unidade is null) OR (co_unidade = '');
 
      UPDATE cob_conv_idade
         SET co_unidade = vUnidade_padrao_preco
       WHERE (co_unidade is null) OR (co_unidade = '');
    ELSE
      IF Unid_Padrao <> '' then
        /*Verificando se a Unidade Existe - Ini*/
        SELECT count(*) 
          INTO iCount
          FROM amunicad 
         WHERE cod_uni = Unid_Padrao;

        IF iCount <= 0 then
          RAISE EXCEPTION -746,0,"Unidade informada nao encontrada!";
        END IF;
        /*Verificando se a Unidade Existe - Fim*/

        /*Verificando se a Unidade e de Faturamento - Ini*/
        SELECT count(*) 
          INTO iCount
          FROM amunicad 
         WHERE cod_uni = cod_uni_fatura
           AND cod_uni_fatura = Unid_Padrao;

        IF iCount <= 0 then
          RAISE EXCEPTION -746,0,"Unidade informada deve ser de faturamento";
        END IF;
        /*Verificando se a Unidade e de Faturamento - Fim*/

	/*Verificando se a Unidade Possui Precos definidos - Ini*/
	SELECT count(*) 
	  INTO iCount
	  FROM fatippre
	 WHERE cod_uni = Unid_Padrao;

	IF iCount <= 0 then
	  RAISE EXCEPTION -746,0,"A unidade informada nao possui precos definidos.";
	END IF;
	/*Verificando se a Unidade Possui Precos definidos - Fim*/

	UPDATE faapetab 
	   SET co_unidade = Unid_Padrao
         WHERE (co_unidade is null) OR (co_unidade = '');

	UPDATE amunicad
     	   SET co_unid_precpadrao = Unid_Padrao
         WHERE (co_unid_precpadrao is null) OR (co_unid_precpadrao = '');
	 
        -- Update para ajustar a base, pois o passo 232 saiu com erro. 
        -- Foi dado o update da FaCciCad para todos os registros.
        UPDATE faccicad
           SET co_unidade = ''
         WHERE (trim(cod_set) = '');

	UPDATE faccicad 
	   SET co_unidade = Unid_Padrao
	 WHERE (cod_set <> '')
           AND ((co_unidade is null) OR (co_unidade = ''));
	 
	UPDATE cob_conv_setor
	   SET co_unidade = Unid_Padrao
         WHERE (co_unidade is null) OR (co_unidade = '');
	 
	UPDATE cob_conv_idade
	   SET co_unidade = Unid_Padrao
         WHERE (co_unidade is null) OR (co_unidade = '');


        -- Verificar se existem outras unidades cadastradas na tabela de preços 
	SELECT count(*) 
	  INTO iCount
	  FROM faprecad
	 WHERE cod_uni <> Unid_Padrao;

        IF iCount > 0 THEN
          -- Enquanto tiver unidade 
          FOREACH 
	    SELECT distinct cod_uni
              INTO scod_uni
              FROM faprecad
             WHERE cod_uni <> Unid_Padrao

            UPDATE amunicad
               SET co_unid_precpadrao = scod_uni
             WHERE cod_uni = scod_uni;
          END FOREACH;

          FOREACH 
            -- Selecionar na faprecad as unidade, o tipo_prd e a tabela 
            SELECT distinct faprecad.cod_uni, faprecad.tabela, faprdcad.tipo_prd
              INTO scod_uni, stabela, stipo_prd
              FROM faprecad, faprdcad
             WHERE faprecad.cod_uni <> Unid_Padrao
               AND faprecad.codigo = faprdcad.codigo
 
            SELECT count(*)
              INTO icount
              FROM faapetab
             WHERE co_unidade = scod_uni
               AND tabela = stabela
               AND tipo_prd = stipo_prd;
 
            IF icount = 0 THEN 
              -- Incluir na tabela de apelidos os registros para a unidade 
              -- que tambem eh padrao pela tabela de preco
              SELECT descricao, cod_tabpreco_tiss, usa_divisor_simpro, sn_divi_brasind
                INTO sdescricao, scod_tabpreco_tiss, susa_divisor_simpr, ssn_divi_brasind
                FROM faapetab
               WHERE co_unidade = Unid_Padrao
                 AND tabela = stabela
                 AND tipo_prd = stipo_prd;

              IF (scod_tabpreco_tiss = '') OR (scod_tabpreco_tiss is null) THEN
                INSERT INTO faapetab 
                  (tabela, tipo_prd, descricao, usa_divisor_simpro, sn_divi_brasind, co_unidade)
                VALUES 
                  (stabela, stipo_prd, sdescricao, susa_divisor_simpr, ssn_divi_brasind, scod_uni);
              ELSE
                INSERT INTO faapetab 
                  (tabela, tipo_prd, descricao, usa_divisor_simpro, cod_tabpreco_tiss, sn_divi_brasind, co_unidade)
                VALUES 
                  (stabela, stipo_prd, sdescricao, susa_divisor_simpr, scod_tabpreco_tiss, ssn_divi_brasind, scod_uni);
              END IF; 
            END IF; 
          END FOREACH;                            

          -- Verifica se tem coeficiente honorario cadastrado
          SELECT count(*)
            INTO icount
            FROM preco_porte_ger
           WHERE cod_uni <> Unid_Padrao;

          IF icount > 0 THEN
            FOREACH
              SELECT fk_apetab, cod_uni, validade, cod_porte
                INTO sfk_apetab, sCod_uni, sValidade, scod_porte 
                FROM preco_porte_ger
               WHERE cod_uni <> Unid_Padrao 

              SELECT tabela, tipo_prd
                INTO stabela, stipo_prd 
                FROM faapetab
               WHERE pk_apetab = sfk_apetab; 

              -- Verifica se existe 
              SELECT count(*)
                INTO icount
                FROM faapetab
               WHERE tabela = stabela
                 AND tipo_prd = stipo_prd
                 AND co_unidade = scod_uni; 

              IF icount > 0 THEN
                SELECT pk_apetab
                  INTO spk_apetab 
                  FROM faapetab
                 WHERE tabela = stabela
                   AND tipo_prd = stipo_prd
                   AND co_unidade = scod_uni; 

                SELECT count(*)
                  INTO iCount2 
                  FROM preco_porte_ger
                 WHERE cod_uni = scod_uni
                   AND validade = svalidade
                   AND cod_porte = scod_porte
                   AND fk_apetab = spk_apetab;

                IF iCount2 = 0 THEN
                  UPDATE preco_porte_ger
                     SET fk_apetab = spk_apetab
                   WHERE cod_uni = scod_uni
                     AND validade = svalidade
                     AND cod_porte = scod_porte 
                     AND tipo_prd = stipo_prd
                     AND fk_apetab = sfk_apetab;
                END IF;
              ELSE
                SELECT descricao, cod_tabpreco_tiss, usa_divisor_simpro, sn_divi_brasind
                  INTO sdescricao, scod_tabpreco_tiss, susa_divisor_simpr, ssn_divi_brasind
                  FROM faapetab
                 WHERE co_unidade = Unid_Padrao
                   AND tabela = stabela
                   AND tipo_prd = stipo_prd;

                IF (scod_tabpreco_tiss = '') OR (scod_tabpreco_tiss is null) THEN
                  INSERT INTO faapetab
                    (tabela, tipo_prd, descricao, usa_divisor_simpro, sn_divi_brasind, co_unidade)
                  VALUES
                    (stabela, stipo_prd, sdescricao, susa_divisor_simpr, ssn_divi_brasind, scod_uni);
                ELSE
                  INSERT INTO faapetab
                    (tabela, tipo_prd, descricao, usa_divisor_simpro, cod_tabpreco_tiss, sn_divi_brasind, co_unidade)
                  VALUES
                    (stabela, stipo_prd, sdescricao, susa_divisor_simpr, scod_tabpreco_tiss, ssn_divi_brasind, scod_uni);
                END IF;
                
                SELECT pk_apetab
                  INTO spk_apetab
                  FROM faapetab
                 WHERE tabela = stabela
                   AND tipo_prd = stipo_prd
                   AND co_unidade = scod_uni; 

                SELECT count(*)
                  INTO iCount2 
                  FROM preco_porte_ger
                 WHERE cod_uni = scod_uni
                   AND validade = svalidade
                   AND cod_porte = scod_porte
                   AND fk_apetab = spk_apetab;

                IF iCount2 = 0 THEN
                  UPDATE preco_porte_ger
                     SET fk_apetab = spk_apetab
                   WHERE cod_uni = scod_uni
                     AND validade = svalidade
                     AND cod_porte = scod_porte 
                     AND tipo_prd = stipo_prd
                     AND fk_apetab = sfk_apetab;
                END IF;
              END IF;
            END FOREACH;
							
            FOREACH
              SELECT pr.cod_uni, pr.tipo_prd, pr.validade, pr.cod_porte, pr.valor, pr.fk_apetab, pr.pk_prepger
		INTO scod_uni, stipo_prd, svalidade, scod_porte, svalor, sfk_apetab, spk_prepger
                FROM preco_porte_ger pr, faapetab ap
               WHERE ap.pk_apetab = pr.fk_apetab 
                 AND pr.cod_uni <> ap.co_unidade
								 
              SELECT count(*)
                INTO iCount2 
                FROM preco_porte_ger
               WHERE cod_uni   = scod_uni
                 AND validade  = svalidade
                 AND cod_porte = scod_porte
                 AND tipo_prd = stipo_prd
                 AND valor = svalor
                 AND fk_apetab <> sfk_apetab; 
								  
              IF iCount2 = 1 THEN
                DELETE 
		  FROM preco_porte_ger
		 WHERE pk_prepger = spk_prepger; 
              END IF;								 
            END FOREACH;
          END IF;

          -- Verifica se existem cadastrados pequenos portes anestesicos
          SELECT count(*) 
     	    INTO iCount
            FROM fatabelaporte;

          IF icount > 0 THEN
            FOREACH
              SELECT distinct fk_apetab, tipo_prd, tabela 
                INTO sfk_apetab, stipo_prd, stabela
                FROM fatabelaporte, faapetab
               WHERE pk_apetab = fk_apetab

              FOREACH
                SELECT pk_apetab 
                  INTO spk_apetab
                  FROM faapetab 
                 WHERE tabela = stabela 
                   AND tipo_prd = stipo_prd
                   AND co_unidade <> Unid_Padrao
                                
                FOREACH 
                  SELECT cod_poa
                    INTO scod_poa
                    FROM fatabelaporte
                   WHERE fk_apetab = sfk_apetab

                  --Verifica se ja tem o porte cadastrado
                  SELECT count(*)
                    INTO icount
                    FROM fatabelaporte
                   WHERE cod_poa = scod_poa
                     AND fk_apetab = spk_apetab;

                  IF icount = 0 THEN
                    SELECT MAX(id_fatabelaporte) + 1
                      INTO iIdPorte
                      FROM fatabelaporte;

                    INSERT INTO fatabelaporte
                      (id_fatabelaporte, cod_poa, fk_apetab)
                    VALUES 
                      (iIdPorte, scod_poa, spk_apetab);
                  END IF;
                END FOREACH;
              END FOREACH;
            END FOREACH;
          END IF;


          -- Verifica se existem cadastrados recursos de glosa
          SELECT count(*) 
            INTO iCount
            FROM tb_recglo_prd;

          IF icount > 0 THEN
            FOREACH 
              SELECT DISTINCT fk_fatura
                INTO sFatura
                FROM tb_recglo_prd

              SELECT mpr.cod_tabela, prd.tipo_prd, mca.cod_uni, fpr.cod_prd 
                INTO stabela, stipo_prd, scod_uni, sCodPrd
                FROM famovdestino mds, famovprd mpr, famovcad mca, fafatprd fpr, faprdcad prd
               WHERE mds.cod_fatura = sFatura
                 AND mds.destino = 'C'
                 AND fpr.tipo_pgto <> 'D'
                 AND mca.cod_uni <> Unid_Padrao
                 AND mds.sequencial = mpr.sequencial
                 AND fpr.fatura = mds.cod_fatura
                 AND mpr.comanda = mca.comanda
                 AND mpr.tipo_comanda = mca.tipo_comanda
                 AND fpr.cod_prd = mpr.codigo
                 AND DECODE(TRIM(fpr.cod_pro),NULL,'-','','-',fpr.cod_pro) = DECODE(TRIM(mpr.cod_pro),NULL,'-','','-',mpr.cod_pro)
                 AND fpr.tipo_pgto = mpr.tipo_pgto
                 AND mpr.codigo = prd.codigo;

              SELECT pk_apetab 
                INTO spk_apetab
                FROM faapetab 
               WHERE tabela = stabela 
                 AND tipo_prd = stipo_prd
                 AND co_unidade = scod_uni;

              UPDATE tb_recglo_prd 
                 SET fk_apetab = spk_apetab
               WHERE fk_fatura = sFatura
                 AND fk_codigo = sCodPrd;

            END FOREACH;
          END IF;
        END IF;
      ELSE
	RAISE EXCEPTION -746,0,
	  "Obrigatorio uma Unidade Padrao para atualizacao dos Precos por Unidade.";
      END IF;
    END IF;
	
    IF vEstoque_Por_Unid_Faturamento = 'S' THEN
      IF vUnidade_padrao_preco <> '' THEN
        UPDATE prod_distribuicao
           SET co_unidade = vUnidade_padrao_preco
         WHERE (co_unidade IS NULL) OR (co_unidade = '');
      ELSE
      IF Unid_Padrao <> '' then
        UPDATE prod_distribuicao
           SET co_unidade = Unid_Padrao
         WHERE (co_unidade IS NULL) OR (co_unidade = '');
      END IF;
    END IF;
  END IF;	
END PROCEDURE;

GRANT EXECUTE ON ajusta_unidades_preco TO PUBLIC;

-----------------------------------------------------------------------------------
-- Cria procedure - Final
-----------------------------------------------------------------------------------

--Caso nao tenha unidade padrao definida no parametro 'unidade_padrao_preco' da tabela 'wpdtab' 
--devera ser informado o CoDIGO da unidade padrao na execucao da procedure abaixo
EXECUTE PROCEDURE ajusta_unidades_preco('');
