-------------------------------------------------------------
-- Criar Procedure - Inicio
-------------------------------------------------------------
CREATE PROCEDURE check_estrutura()
   define  ncount integer;

   SELECT COUNT(*)
     INTO ncount
     FROM sysprocedures
    WHERE procname='exclui_kits';

   IF ncount>0 THEN
      DROP PROCEDURE exclui_kits;
   END IF;
END PROCEDURE;

EXECUTE PROCEDURE check_estrutura();
DROP PROCEDURE check_estrutura;

-- Cria procedure
CREATE PROCEDURE exclui_kits(pCodSet CHAR(6))
DEFINE cCodBarraKit CHAR(10);
DEFINE ncount       integer; 

SET TRIGGERS FOR esestoque_kit_prd DISABLED;
SET TRIGGERS FOR esestoque_kit DISABLED;

FOREACH

SELECT cod_barra_kit 
  INTO cCodBarraKit
  FROM esestoque_kit
 WHERE usado = 'N' 
   AND cod_set = pCodSet

  SELECT count(documento)
    INTO ncount
    FROM esmovite	
   WHERE tipo_documento = 'REQ'
     AND cod_barra_kit = cCodBarraKit;

  IF ncount > 0 THEN

    UPDATE esestoque_kit  
       SET usado = 'C' 
     WHERE cod_barra_kit = cCodBarraKit;
  
  ELSE
  
    DELETE 
      FROM esestoque_kit_prd
     WHERE cod_barra_kit = cCodBarraKit;
	
    DELETE 
      FROM esestoque_kit 
     WHERE cod_barra_kit = cCodBarraKit;
	
  END IF;
	
     
END FOREACH;

SET TRIGGERS FOR esestoque_kit_prd ENABLED;
SET TRIGGERS FOR esestoque_kit ENABLED;

UPDATE esestcad 
   SET est_kit = 0, 
       controle = decode(controle,0,1,0) 
 WHERE cod_set = pCodSet ;

END PROCEDURE;

-------------------------------------------------------------
-- Criar Procedure - Final
-------------------------------------------------------------


-- Executa a procedure exclui_kits
-- PASSAR O CODIGO DO SETOR O QUAL SERA EXCLUÍDO OS KITS COMO PARAMETRO
EXECUTE PROCEDURE exclui_kits('');

-- Remove a procedure exclui_kits
DROP PROCEDURE exclui_kits;