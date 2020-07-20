-------------------------------------
-- CR........: 10251
-- CRC.......: 5273
-- Banco.....: WPDHOSP
-- Versao....: 71.08.01_Esho_Sustentacao
-- Analista..: Leon Wagner
-- Data......: 07/03/2016
-- Cliente...: Amil
-- Finalidade: Criação da Tabela de log para monitoramento do problema de kit fantasma
-- Tabelas...: 
-- Sistemas..: Esthos
-------------------------------------------------------------
-- Colunas : TIPO_LOG     : Valores 'K' = Log Oriundo do Problema do Kit Fantasma (LEON); 'R' = Problema com estoque reservado (Ricardo) 
--           ANTES_DEPOIS : Valores 'A' = Visão do estoque antes da movimentação; 'D' = Visão do estoque depois da movimentação
--           STATUS_KIT   : Valores 
-------------------------------------------------------------
-- Criar tabela - Inicio
-------------------------------------------------------------
CREATE PROCEDURE check_estrutura()
   define  status integer;

   SELECT COUNT(*)
     INTO  status
     FROM systables
    WHERE UPPER(tabname)='TL_KIT_FANTASMA' ;

   IF  status=0 THEN
      -- Criacao de tabelas
      CREATE TABLE TL_KIT_FANTASMA (
      PK_KITFAN SERIAL NOT NULL,
	  TIPO_DOCUMENTO CHAR(4),
	  TIPO_LOG CHAR(1) NOT NULL,
      DOCUMENTO CHAR(7),
	  STATUS_KIT CHAR(1),
	  ANTES_DEPOIS CHAR(1),
	  COD_SET CHAR(4),
	  CODIGO CHAR(6) NOT NULL,
	  COD_BARRA_INT CHAR (9),
	  QUANT DECIMAL (13,3) NOT NULL,
	  COD_BARRA_KIT CHAR(10) NOT NULL,
	  DH_LOG DATETIME YEAR TO SECOND NOT NULL,
	  MATRICULA INTEGER NOT NULL,
	  EST_ATU DECIMAL(13,3) NOT NULL,
	  EST_KIT DECIMAL(13,3) NOT NULL,
	  EST_RESERVADO DECIMAL(13,3),
	  EST_BLOQ DECIMAL(13,3) NOT NULL,
	  UNIT VARCHAR(50) NOT NULL );
   END IF;
END PROCEDURE;

EXECUTE PROCEDURE check_estrutura();
DROP PROCEDURE check_estrutura;

-- Define permissoes para tabela
GRANT SELECT,INSERT, REFERENCES ON TL_KIT_FANTASMA TO PUBLIC;

-- Define o lock mode para registro
ALTER TABLE TL_KIT_FANTASMA LOCK MODE(ROW);

-------------------------------------------------------------
-- Criar tabela - Final
-------------------------------------------------------------
-------------------------------------------------------------
-- Criar Chave Primaria - Inicio
-------------------------------------------------------------
CREATE PROCEDURE check_estrutura()
   define    status integer;

   SELECT COUNT(*)
     INTO  status
     FROM sysconstraints
    WHERE constrname='pk_kitfan'
      AND constrtype='P'
      AND tabid in (SELECT tabid
                      FROM systables
                     WHERE UPPER(tabname)='TL_KIT_FANTASMA') ;

   IF  status=0 THEN
      -- Chave Primaria
      SELECT COUNT(*) INTO  status
        FROM sysindexes
       WHERE idxname = 'TL_KIT_FANTASMA' 
         AND tabid IN (SELECT tabid FROM systables
                       WHERE  UPPER(tabname) = 'TL_KIT_FANTASMA') ;
      IF  status = 0 THEN
         CREATE UNIQUE INDEX pk_kitfan ON TL_KIT_FANTASMA ( PK_KITFAN );
      END IF;
      ALTER TABLE TL_KIT_FANTASMA ADD CONSTRAINT
         PRIMARY KEY( PK_KITFAN )
         CONSTRAINT pk_kitfan;
   END IF;
END PROCEDURE;

EXECUTE PROCEDURE check_estrutura();
DROP PROCEDURE check_estrutura;
-------------------------------------------------------------
-- Criar Chave Primaria - Final
-------------------------------------------------------------
-------------------------------------------------------------
-- Criar Indice - Inicio
-------------------------------------------------------------
CREATE PROCEDURE check_estrutura()
   define   status integer;

   SELECT COUNT(*)
     INTO  status
     FROM sysindexes
    WHERE idxname='ie_kitfan_1' 
      AND tabid IN (SELECT tabid
                      FROM systables
                     WHERE UPPER(tabname)='TL_KIT_FANTASMA') ;
   IF  status=0 THEN
      CREATE INDEX ie_kitfan_1   ON TL_KIT_FANTASMA ( TIPO_DOCUMENTO, DOCUMENTO );
   END IF;

   SELECT COUNT(*)
     INTO  status
     FROM sysindexes
    WHERE idxname='ie_kitfan_2'
      AND tabid IN (SELECT tabid
                      FROM systables
                     WHERE UPPER(tabname)='TL_KIT_FANTASMA') ;
   IF  status=0 THEN
      CREATE INDEX ie_kitfan_2 ON TL_KIT_FANTASMA ( codigo );
   END IF;

   SELECT COUNT(*)
     INTO  status
     FROM sysindexes
    WHERE idxname='ie_kitfan_3'
      AND tabid IN (SELECT tabid
                      FROM systables
                     WHERE UPPER(tabname)='TL_KIT_FANTASMA');
   IF  status=0 THEN
      CREATE INDEX ie_kitfan_3 ON TL_KIT_FANTASMA ( cod_barra_int );
   END IF;
   
   SELECT COUNT(*)
     INTO  status
     FROM sysindexes
    WHERE idxname='ie_kitfan_4'
      AND tabid IN (SELECT tabid
                      FROM systables
                     WHERE UPPER(tabname)='TL_KIT_FANTASMA');
   IF  status=0 THEN
      CREATE INDEX ie_kitfan_4 ON TL_KIT_FANTASMA ( cod_set );
   END IF;
   
   SELECT COUNT(*)
     INTO  status
     FROM sysindexes
    WHERE idxname='ie_kitfan_5'
      AND tabid IN (SELECT tabid
                      FROM systables
                     WHERE UPPER(tabname)='TL_KIT_FANTASMA');
   IF  status=0 THEN
      CREATE INDEX ie_kitfan_5 ON TL_KIT_FANTASMA ( cod_barra_kit );
   END IF;
   
   SELECT COUNT(*)
     INTO  status
     FROM sysindexes
    WHERE idxname='ie_kitfan_6'
      AND tabid IN (SELECT tabid
                      FROM systables
                     WHERE UPPER(tabname)='TL_KIT_FANTASMA');
   IF  status=0 THEN
      CREATE INDEX ie_kitfan_6 ON TL_KIT_FANTASMA ( matricula );
   END IF;
   
   SELECT COUNT(*)
     INTO  status
     FROM sysindexes
    WHERE idxname='ie_kitfan_7'
      AND tabid IN (SELECT tabid
                      FROM systables
                     WHERE UPPER(tabname)='TL_KIT_FANTASMA');
   IF  status=0 THEN
      CREATE INDEX ie_kitfan_7 ON TL_KIT_FANTASMA ( status_kit );
   END IF;
  
END PROCEDURE;

EXECUTE PROCEDURE check_estrutura();
DROP PROCEDURE check_estrutura;
-------------------------------------------------------------
-- Criar Indice - Final
-------------------------------------------------------------

