CREATE PROCEDURE fat_cobertura(pcCodPrd CHAR(6), pcTipoPrd CHAR(3),
                               pcCodPac CHAR(7), pcTipoPac CHAR(1),
                               pcTipoApt CHAR(2), pcCodCon CHAR(3),
                               pcCodPla CHAR(2), pcCodSet CHAR(4),
                               piIdadePac SMALLINT, pcCodKit CHAR(6),
                               pcTipoAto CHAR(2),pcCodUni CHAR(6))
                               RETURNING SMALLINT,CHAR(2), CHAR(1), FLOAT;

--  Sequencia da cobertura:
--      -- > cob. paciente item
--      -- > cob. paciente geral
--      -- > cob. convenio/plano/idade do paciente
--      -- > cob. convenio/idade do paciente
--      -- > cob. convenio/tipo apart. item/unidade de faturamento
--      -- > cob. convenio item setor
--      -- > cob. convenio item / unidade de faturamento
--      -- > cob. convenio/tipo apart./ unidade de faturamento
--      -- > cob. convenio geral / unidade de faturamento
--      -- > cob. convenio item
--      -- > cob. convenio/setor
--      -- > cob. convenio geral


-- Adicionado o parametro piCodUni: Unidade de Faturamento - SAT 0024756

-- Adicionado o parametro piIdadePac: Idade do Paciente - SAT 0020299

-- Adicionados os parametros pcCodKit e pcTipoAto, respectivamente C¥digo do Kit e
-- Tipo do Ato, utilizados para recuperar coberturas por Kit, convenio, plano e
-- tipo do ato  - SAT 0021222

   DEFINE cTabela                                 CHAR(2);
   DEFINE cDestino                                CHAR(1);
   DEFINE nFator                                  FLOAT;
   DEFINE cTabInt,cTabExt,cTabUrg,cTabAmb         LIKE faccgcad.tab_int;
   DEFINE nAcresInt,nAcresExt,nAcresUrg,nAcresAmb LIKE faccgcad.acres_int;
   DEFINE nCont                                   SMALLINT;
   DEFINE esql                                    SMALLINT;

   ON EXCEPTION
      SET esql
      RETURN esql,cTabela,cDestino,nFator;
   END EXCEPTION

   -- Comandos de depuracao da SP
   -- set debug file to '/tmp/tabela.erro';
   -- trace on;

   LET esql     = 0;
   LET nFator   = 1;
   LET cTabela  = NULL;
   LET cDestino = NULL;
   LET cTabInt  = NULL;
   LET cTabExt  = NULL;
   LET cTabUrg  = NULL;

   FOR nCont = 1 TO 1

      -- > cob. paciente item

      SELECT tab_int,tab_ext,tab_urg,tab_amb,acres_int,
             acres_ext,acres_urg,acres_amb
         INTO cTabInt,cTabExt,cTabUrg,cTabAmb,
              nAcresInt,nAcresExt,nAcresUrg,nAcresAmb
         FROM facpicad
         WHERE cod_pac = pcCodPac AND codigo = pcCodPrd;

      IF cTabInt IS NOT NULL OR
         cTabExt IS NOT NULL OR
         cTabAmb IS NOT NULL OR
         cTabUrg IS NOT NULL THEN
         IF pcTipoPac = 'I' THEN
            IF nAcresInt IS NULL THEN
               LET nAcresInt = 0;
            END IF
            LET cTabela  = cTabInt[2,3];
            LET cDestino = cTabInt[1,1];
            LET nFator = 1 + (nAcresInt/100);
         ELIF pcTipoPac = 'E' THEN
            IF nAcresExt IS NULL THEN
               LET nAcresExt = 0;
            END IF
            LET cTabela  = cTabExt[2,3];
            LET cDestino = cTabExt[1,1];
            LET nFator = 1 + (nAcresExt/100);
         ELIF pcTipoPac = 'A' THEN
            IF nAcresAmb IS NULL THEN
               LET nAcresAmb = 0;
            END IF
            LET cTabela  = cTabAmb[2,3];
            LET cDestino = cTabAmb[1,1];
            LET nFator = 1 + (nAcresAmb/100);
         ELSE
            IF nAcresUrg IS NULL THEN
               LET nAcresUrg = 0;
            END IF
            LET cTabela  = cTabUrg[2,3];
            LET cDestino = cTabUrg[1,1];
            LET nFator = 1 + (nAcresUrg/100);
         END IF
         EXIT FOR;
      END IF

      -- > cob. paciente geral

      SELECT tab_int,tab_ext,tab_urg,tab_amb,acres_int,
             acres_ext,acres_urg,acres_amb
         INTO cTabInt,cTabExt,cTabUrg,cTabAmb,
              nAcresInt,nAcresExt,nAcresUrg,nAcresAmb
         FROM facpgcad
         WHERE cod_pac = pcCodPac AND tipo_prd = pcTipoPrd;

      IF cTabInt IS NOT NULL OR
         cTabExt IS NOT NULL OR
         cTabAmb IS NOT NULL OR
         cTabUrg IS NOT NULL THEN
         IF pcTipoPac = 'I' THEN
            IF nAcresInt IS NULL THEN
               LET nAcresInt = 0;
            END IF
            LET cTabela  = cTabInt[2,3];
            LET cDestino = cTabInt[1,1];
            LET nFator = 1 + (nAcresInt/100);
         ELIF pcTipoPac = 'E' THEN
            IF nAcresExt IS NULL THEN
               LET nAcresExt = 0;
            END IF
            LET cTabela  = cTabExt[2,3];
            LET cDestino = cTabExt[1,1];
            LET nFator = 1 + (nAcresExt/100);
         ELIF pcTipoPac = 'A' THEN
            IF nAcresAmb IS NULL THEN
               LET nAcresAmb = 0;
            END IF
            LET cTabela  = cTabAmb[2,3];
            LET cDestino = cTabAmb[1,1];
            LET nFator = 1 + (nAcresAmb/100);
         ELSE
            IF nAcresUrg IS NULL THEN
               LET nAcresUrg = 0;
            END IF
            LET cTabela  = cTabUrg[2,3];
            LET cDestino = cTabUrg[1,1];
            LET nFator = 1 + (nAcresUrg/100);
         END IF
         EXIT FOR;
      END IF

      -- cob. convenio/plano/idade do paciente - SAT 0020299

      SELECT tab_int,tab_ext,tab_urg,tab_amb,acres_int,
             acres_ext,acres_urg,acres_amb
         INTO cTabInt,cTabExt,cTabUrg,cTabAmb,
              nAcresInt,nAcresExt,nAcresUrg,nAcresAmb
         FROM cob_conv_idade
         WHERE cod_con = pcCodCon
         AND cod_pla = pcCodPla
         AND codigo = pcCodPrd
         AND idade_ini <= piIdadePac
         AND idade_fin >= piIdadePac
		 AND co_unidade = pcCodUni;

      IF cTabInt IS NOT NULL OR
         cTabExt IS NOT NULL OR
         cTabAmb IS NOT NULL OR
         cTabUrg IS NOT NULL THEN
         IF pcTipoPac = 'I' THEN
            IF nAcresInt IS NULL THEN
               LET nAcresInt = 0;
            END IF
            LET cTabela  = cTabInt[2,3];
            LET cDestino = cTabInt[1,1];
            LET nFator = 1 + (nAcresInt/100);
         ELIF pcTipoPac = 'E' THEN
            IF nAcresExt IS NULL THEN
               LET nAcresExt = 0;
            END IF
            LET cTabela  = cTabExt[2,3];
            LET cDestino = cTabExt[1,1];
            LET nFator = 1 + (nAcresExt/100);
         ELIF pcTipoPac = 'A' THEN
            IF nAcresAmb IS NULL THEN
               LET nAcresAmb = 0;
            END IF
            LET cTabela  = cTabAmb[2,3];
            LET cDestino = cTabAmb[1,1];
            LET nFator = 1 + (nAcresAmb/100);
         ELSE
            IF nAcresUrg IS NULL THEN
               LET nAcresUrg = 0;
            END IF
            LET cTabela  = cTabUrg[2,3];
            LET cDestino = cTabUrg[1,1];
            LET nFator = 1 + (nAcresUrg/100);
         END IF
         EXIT FOR;
      END IF

      -- cob. convenio/idade do paciente - SAT 0020299

      SELECT tab_int,tab_ext,tab_urg,tab_amb,acres_int,
             acres_ext,acres_urg,acres_amb
         INTO cTabInt,cTabExt,cTabUrg,cTabAmb,
              nAcresInt,nAcresExt,nAcresUrg,nAcresAmb
         FROM cob_conv_idade
         WHERE cod_con = pcCodCon
         AND (cod_pla IS NULL OR cod_pla = ' ')
         AND codigo = pcCodPrd
         AND idade_ini <= piIdadePac
         AND idade_fin >= piIdadePac
		 AND co_unidade = pcCodUni;		 

      IF cTabInt IS NOT NULL OR
         cTabExt IS NOT NULL OR
         cTabAmb IS NOT NULL OR
         cTabUrg IS NOT NULL THEN
         IF pcTipoPac = 'I' THEN
            IF nAcresInt IS NULL THEN
               LET nAcresInt = 0;
            END IF
            LET cTabela  = cTabInt[2,3];
            LET cDestino = cTabInt[1,1];
            LET nFator = 1 + (nAcresInt/100);
         ELIF pcTipoPac = 'E' THEN
            IF nAcresExt IS NULL THEN
               LET nAcresExt = 0;
            END IF
            LET cTabela  = cTabExt[2,3];
            LET cDestino = cTabExt[1,1];
            LET nFator = 1 + (nAcresExt/100);
         ELIF pcTipoPac = 'A' THEN
            IF nAcresAmb IS NULL THEN
               LET nAcresAmb = 0;
            END IF
            LET cTabela  = cTabAmb[2,3];
            LET cDestino = cTabAmb[1,1];
            LET nFator = 1 + (nAcresAmb/100);
         ELSE
            IF nAcresUrg IS NULL THEN
               LET nAcresUrg = 0;
            END IF
            LET cTabela  = cTabUrg[2,3];
            LET cDestino = cTabUrg[1,1];
            LET nFator = 1 + (nAcresUrg/100);
         END IF
         EXIT FOR;
      END IF

      -- > Cob. Kit/Convenio/Plano/Tipo Ato Item do Kit

      SELECT tab_int,tab_ext,tab_urg,tab_amb,acres_int,
             acres_ext,acres_urg,acres_amb
         INTO cTabInt,cTabExt,cTabUrg,cTabAmb,
              nAcresInt,nAcresExt,nAcresUrg,nAcresAmb
         FROM comp_kit_convenio
         WHERE cod_kit  = pcCodKit  AND
               cod_con  = pcCodCon  AND
               cod_pla  = pcCodPla  AND
               codigo   = pcCodPrd  AND
               tipo_ato = pcTipoAto AND
               cod_via = ' ';

      IF cTabInt IS NOT NULL OR
         cTabExt IS NOT NULL OR
         cTabAmb IS NOT NULL OR
         cTabUrg IS NOT NULL THEN
         IF pcTipoPac = 'I' THEN
            IF nAcresInt IS NULL THEN
               LET nAcresInt = 0;
            END IF
            LET cTabela  = cTabInt[2,3];
            LET cDestino = cTabInt[1,1];
            LET nFator = 1 + (nAcresInt/100);
         ELIF pcTipoPac = 'E' THEN
            IF nAcresExt IS NULL THEN
               LET nAcresExt = 0;
            END IF
            LET cTabela  = cTabExt[2,3];
            LET cDestino = cTabExt[1,1];
            LET nFator = 1 + (nAcresExt/100);
         ELIF pcTipoPac = 'A' THEN
            IF nAcresAmb IS NULL THEN
               LET nAcresAmb = 0;
            END IF
            LET cTabela  = cTabAmb[2,3];
            LET cDestino = cTabAmb[1,1];
            LET nFator = 1 + (nAcresAmb/100);
         ELSE
            IF nAcresUrg IS NULL THEN
               LET nAcresUrg = 0;
            END IF
            LET cTabela  = cTabUrg[2,3];
            LET cDestino = cTabUrg[1,1];
            LET nFator = 1 + (nAcresUrg/100);
         END IF
         EXIT FOR;
      END IF

      -- > cob. convenio/tipo apart./item/unidade de faturamento

      IF pcTipoPac = 'I' THEN

        SELECT tab_int, acres_int
              INTO cTabInt, nAcresInt
              FROM facciuni
              WHERE cod_uni = pcCodUni AND
                    cod_con = pcCodCon AND cod_pla = pcCodPla AND
                    cod_prd = pcCodPrd AND fk_cod_tipo = pcTipoApt;

         IF cTabInt IS NOT NULL THEN
            IF nAcresInt IS NULL THEN
               LET nAcresInt = 0;
            END IF
            LET cTabela  = cTabInt[2,3];
            LET cDestino = cTabInt[1,1];
            LET nFator = 1 + (nAcresInt/100);
            EXIT FOR;
         END IF
      END IF

      -- > cob. convenio item setor

      SELECT tab_int,tab_ext,tab_urg,tab_amb,acres_int,
             acres_ext,acres_urg,acres_amb
         INTO cTabInt,cTabExt,cTabUrg,cTabAmb,
              nAcresInt,nAcresExt,nAcresUrg,nAcresAmb
         FROM faccicad
         WHERE cod_con  = pcCodCon 
		   AND cod_pla  = pcCodPla 
		   AND codigo   = pcCodPrd 
		   AND cod_tipo = " " 
		   AND cod_set  = pcCodSet
		   AND co_unidade = pcCodUni;

      IF cTabInt IS NOT NULL OR
         cTabExt IS NOT NULL OR
         cTabAmb IS NOT NULL OR
         cTabUrg IS NOT NULL THEN
         IF pcTipoPac = 'I' THEN
            IF nAcresInt IS NULL THEN
               LET nAcresInt = 0;
            END IF
            LET cTabela  = cTabInt[2,3];
            LET cDestino = cTabInt[1,1];
            LET nFator = 1 + (nAcresInt/100);
         ELIF pcTipoPac = 'E' THEN
            IF nAcresExt IS NULL THEN
               LET nAcresExt = 0;
            END IF
            LET cTabela  = cTabExt[2,3];
            LET cDestino = cTabExt[1,1];
            LET nFator = 1 + (nAcresExt/100);
         ELIF pcTipoPac = 'A' THEN
            IF nAcresAmb IS NULL THEN
               LET nAcresAmb = 0;
            END IF
            LET cTabela  = cTabAmb[2,3];
            LET cDestino = cTabAmb[1,1];
            LET nFator = 1 + (nAcresAmb/100);
         ELSE
            IF nAcresUrg IS NULL THEN
               LET nAcresUrg = 0;
            END IF
            LET cTabela  = cTabUrg[2,3];
            LET cDestino = cTabUrg[1,1];
            LET nFator = 1 + (nAcresUrg/100);
         END IF
         EXIT FOR;
      END IF

      -- > cob. convenio item / unidade de faturamento SAT 24756

      SELECT tab_int,tab_ext,tab_urg,tab_amb,acres_int,
             acres_ext,acres_urg,acres_amb
         INTO cTabInt,cTabExt,cTabUrg,cTabAmb,
              nAcresInt,nAcresExt,nAcresUrg,nAcresAmb
         FROM facciuni
         WHERE cod_con = pcCodCon AND cod_pla = pcCodPla AND
               cod_prd = pcCodPrd AND cod_uni = pcCodUni and
			   fk_cod_tipo IS NULL;

      IF cTabInt IS NOT NULL OR
         cTabExt IS NOT NULL OR
         cTabAmb IS NOT NULL OR
         cTabUrg IS NOT NULL THEN
         IF pcTipoPac = 'I' THEN
            IF nAcresInt IS NULL THEN
               LET nAcresInt = 0;
            END IF
            LET cTabela  = cTabInt[2,3];
            LET cDestino = cTabInt[1,1];
            LET nFator = 1 + (nAcresInt/100);
         ELIF pcTipoPac = 'E' THEN
            IF nAcresExt IS NULL THEN
               LET nAcresExt = 0;
            END IF
            LET cTabela  = cTabExt[2,3];
            LET cDestino = cTabExt[1,1];
            LET nFator = 1 + (nAcresExt/100);
         ELIF pcTipoPac = 'A' THEN
            IF nAcresAmb IS NULL THEN
               LET nAcresAmb = 0;
            END IF
            LET cTabela  = cTabAmb[2,3];
            LET cDestino = cTabAmb[1,1];
            LET nFator = 1 + (nAcresAmb/100);
         ELSE
            IF nAcresUrg IS NULL THEN
               LET nAcresUrg = 0;
            END IF
            LET cTabela  = cTabUrg[2,3];
            LET cDestino = cTabUrg[1,1];
            LET nFator = 1 + (nAcresUrg/100);
         END IF
         EXIT FOR;
      END IF

      -- > cob. convenio/tipo apart./ unidade de faturamento

      IF pcTipoPac = 'I' THEN

         SELECT tab_int, acres_int
              INTO cTabInt, nAcresInt
              FROM faccguni
              WHERE cod_uni = pcCodUni AND
                    cod_con  = pcCodCon AND cod_pla = pcCodPla AND
                    tipo_prd = pcTipoPrd AND fk_cod_tipo = pcTipoApt;

         IF cTabInt IS NOT NULL THEN
            IF nAcresInt IS NULL THEN
               LET nAcresInt = 0;
            END IF
            LET cTabela  = cTabInt[2,3];
            LET cDestino = cTabInt[1,1];
            LET nFator = 1 + (nAcresInt/100);
            EXIT FOR;
         END IF
      END IF

      -- > cob. convenio geral / unidade de faturamento SAT 24756

      SELECT tab_int,tab_ext,tab_urg,tab_amb,acres_int,
             acres_ext,acres_urg,acres_amb
         INTO cTabInt,cTabExt,cTabUrg,cTabAmb,
              nAcresInt,nAcresExt,nAcresUrg,nAcresAmb
         FROM faccguni
         WHERE cod_con  = pcCodCon AND cod_pla = pcCodPla AND
               tipo_prd = pcTipoPrd AND cod_uni = pcCodUni AND
			   fk_cod_tipo IS NULL;

      IF cTabInt IS NOT NULL OR
         cTabExt IS NOT NULL OR
         cTabAmb IS NOT NULL OR
         cTabUrg IS NOT NULL THEN
         IF pcTipoPac = 'I' THEN
            IF nAcresInt IS NULL THEN
               LET nAcresInt = 0;
            END IF
            LET cTabela  = cTabInt[2,3];
            LET cDestino = cTabInt[1,1];
            LET nFator = 1 + (nAcresInt/100);
         ELIF pcTipoPac = 'E' THEN
            IF nAcresExt IS NULL THEN
               LET nAcresExt = 0;
            END IF
            LET cTabela  = cTabExt[2,3];
            LET cDestino = cTabExt[1,1];
            LET nFator = 1 + (nAcresExt/100);
         ELIF pcTipoPac = 'A' THEN
            IF nAcresAmb IS NULL THEN
               LET nAcresAmb = 0;
            END IF
            LET cTabela  = cTabAmb[2,3];
            LET cDestino = cTabAmb[1,1];
            LET nFator = 1 + (nAcresAmb/100);
         ELSE
            IF nAcresUrg IS NULL THEN
               LET nAcresUrg = 0;
            END IF
            LET cTabela  = cTabUrg[2,3];
            LET cDestino = cTabUrg[1,1];
            LET nFator = 1 + (nAcresUrg/100);
         END IF
         EXIT FOR;
      END IF

      -- > cob. convenio item

      SELECT tab_int,tab_ext,tab_urg,tab_amb,acres_int,
             acres_ext,acres_urg,acres_amb
         INTO cTabInt,cTabExt,cTabUrg,cTabAmb,
              nAcresInt,nAcresExt,nAcresUrg,nAcresAmb
         FROM faccicad
         WHERE cod_con  = pcCodCon 
		   AND cod_pla  = pcCodPla 
		   AND codigo   = pcCodPrd 
		   AND cod_tipo = " " 
		   AND cod_set  = " "
		   AND co_unidade = " ";

      IF cTabInt IS NOT NULL OR
         cTabExt IS NOT NULL OR
         cTabAmb IS NOT NULL OR
         cTabUrg IS NOT NULL THEN
         IF pcTipoPac = 'I' THEN
            IF nAcresInt IS NULL THEN
               LET nAcresInt = 0;
            END IF
            LET cTabela  = cTabInt[2,3];
            LET cDestino = cTabInt[1,1];
            LET nFator = 1 + (nAcresInt/100);
         ELIF pcTipoPac = 'E' THEN
            IF nAcresExt IS NULL THEN
               LET nAcresExt = 0;
            END IF
            LET cTabela  = cTabExt[2,3];
            LET cDestino = cTabExt[1,1];
            LET nFator = 1 + (nAcresExt/100);
         ELIF pcTipoPac = 'A' THEN
            IF nAcresAmb IS NULL THEN
               LET nAcresAmb = 0;
            END IF
            LET cTabela  = cTabAmb[2,3];
            LET cDestino = cTabAmb[1,1];
            LET nFator = 1 + (nAcresAmb/100);
         ELSE
            IF nAcresUrg IS NULL THEN
               LET nAcresUrg = 0;
            END IF
            LET cTabela  = cTabUrg[2,3];
            LET cDestino = cTabUrg[1,1];
            LET nFator = 1 + (nAcresUrg/100);
         END IF
         EXIT FOR;
      END IF

       -- > cob. convenio/setor

      SELECT tab_int,tab_ext,tab_urg,tab_amb,acres_int,
             acres_ext,acres_urg,acres_amb
         INTO cTabInt,cTabExt,cTabUrg,cTabAmb,
              nAcresInt,nAcresExt,nAcresUrg,nAcresAmb
         FROM cob_conv_setor
         WHERE cod_con    = pcCodCon 
		   AND cod_pla    = pcCodPla 
		   AND tipo_prd   = pcTipoPrd 
		   AND cod_set    = pcCodSet
		   AND co_unidade = pcCodUni;

      IF cTabInt IS NOT NULL OR
         cTabExt IS NOT NULL OR
         cTabAmb IS NOT NULL OR
         cTabUrg IS NOT NULL THEN
         IF pcTipoPac = 'I' THEN
            IF nAcresInt IS NULL THEN
               LET nAcresInt = 0;
            END IF
            LET cTabela  = cTabInt[2,3];
            LET cDestino = cTabInt[1,1];
            LET nFator = 1 + (nAcresInt/100);
         ELIF pcTipoPac = 'E' THEN
            IF nAcresExt IS NULL THEN
               LET nAcresExt = 0;
            END IF
            LET cTabela  = cTabExt[2,3];
            LET cDestino = cTabExt[1,1];
            LET nFator = 1 + (nAcresExt/100);
         ELIF pcTipoPac = 'A' THEN
            IF nAcresAmb IS NULL THEN
               LET nAcresAmb = 0;
            END IF
            LET cTabela  = cTabAmb[2,3];
            LET cDestino = cTabAmb[1,1];
            LET nFator = 1 + (nAcresAmb/100);
         ELSE
            IF nAcresUrg IS NULL THEN
               LET nAcresUrg = 0;
            END IF
            LET cTabela  = cTabUrg[2,3];
            LET cDestino = cTabUrg[1,1];
            LET nFator = 1 + (nAcresUrg/100);
         END IF
         EXIT FOR;
      END IF

      -- > cob. convenio geral

      SELECT tab_int,tab_ext,tab_urg,tab_amb,acres_int,
             acres_ext,acres_urg,acres_amb
         INTO cTabInt,cTabExt,cTabUrg,cTabAmb,
              nAcresInt,nAcresExt,nAcresUrg,nAcresAmb
         FROM faccgcad
         WHERE cod_con  = pcCodCon AND cod_pla = pcCodPla AND
               tipo_prd = pcTipoPrd AND cod_tipo = " ";

      IF cTabInt IS NOT NULL OR
         cTabExt IS NOT NULL OR
         cTabAmb IS NOT NULL OR
         cTabUrg IS NOT NULL THEN
         IF pcTipoPac = 'I' THEN
            IF nAcresInt IS NULL THEN
               LET nAcresInt = 0;
            END IF
            LET cTabela  = cTabInt[2,3];
            LET cDestino = cTabInt[1,1];
            LET nFator = 1 + (nAcresInt/100);
         ELIF pcTipoPac = 'E' THEN
            IF nAcresExt IS NULL THEN
               LET nAcresExt = 0;
            END IF
            LET cTabela  = cTabExt[2,3];
            LET cDestino = cTabExt[1,1];
            LET nFator = 1 + (nAcresExt/100);
         ELIF pcTipoPac = 'A' THEN
            IF nAcresAmb IS NULL THEN
               LET nAcresAmb = 0;
            END IF
            LET cTabela  = cTabAmb[2,3];
            LET cDestino = cTabAmb[1,1];
            LET nFator = 1 + (nAcresAmb/100);
         ELSE
            IF nAcresUrg IS NULL THEN
               LET nAcresUrg = 0;
            END IF
            LET cTabela  = cTabUrg[2,3];
            LET cDestino = cTabUrg[1,1];
            LET nFator = 1 + (nAcresUrg/100);
         END IF
         EXIT FOR;
      END IF

      EXIT FOR;

   END FOR

   RETURN esql,cTabela,cDestino,nFator;

END PROCEDURE;

-- Permissions for routine "fat_cobertura"
grant execute on function fat_cobertura(char,char,char,char,char,char,char,char,smallint,char,char,char) to 'public';
