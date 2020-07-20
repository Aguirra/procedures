-- CR........: 3619
-- CRC.......: 2317
-- Banco.....: MEDVIEW - Informix
-- Versao....: 
-- Analista..: Karina Arantes
-- Data......: 19/12/2011
-- Cliente...: 
-- Finalidade: Criar Sinonimo da tabela fapaccom do wpdhosp que será utilizado no medview
-----------------------------------------------------------------------------------------

-------------------------------------------------------------
-- Criar Sinonimo - Inicio
-------------------------------------------------------------
CREATE PROCEDURE check_estrutura()
   define ncount integer;

   SELECT COUNT(*)
     INTO ncount
     FROM systables
    WHERE tabname='fapaccom' ;

   IF ncount=0 THEN
      CREATE SYNONYM fapaccom FOR wpdhosp:fapaccom ;
   END IF;
END PROCEDURE;

EXECUTE PROCEDURE check_estrutura();
DROP PROCEDURE check_estrutura;
-------------------------------------------------------------
-- Criar Sinonimo - Final
-------------------------------------------------------------
