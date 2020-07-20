-------------------------------------------------------------
-- Atualização produtos bloqueados na FAPRDCAD - ORALCE - ROLLBACK
-------------------------------------------------------------
--Assunto...: Pedidos bloqueados na FAPRDCAD
--Banco.....: ORACLE
--Analista..: Ricardo Aguirra
--Validado..:
--Data......: 06/2020
--Finalidade: Devido a quantiddade de registros identificados com diferença entre as tabelas FAPRDCAD E PRODUTO_UNIDADE
--			  foi criado o script abaixo para equalizar as informações de produtos a serem utilizados 
--			  deixando os itens que estão desbloqueados na PRODUTO_UNIDADE, desbloqueados na FAPRDCAD para as unidade conseguirem a utilização.
-------------------------------------------------------------
-- Atualização produtos bloqueados na FAPRDCAD - ORALCE - ROLLBACK
-------------------------------------------------------------

ALTER SESSION SET CURRENT_SCHEMA=SISHOSP
/

DECLARE 
vCODIGO NUMBER;
BEGIN 
  FOR R1 IN (SELECT CODIGO 
             FROM SISHOSP.BKP_INC0288648_20200616)
        LOOP
          SELECT CODIGO
          INTO vCODIGO
          FROM FAPRDCAD
          WHERE CODIGO = R1.CODIGO;
          
          IF (vCODIGO = R1.CODIGO) THEN 
            UPDATE FAPRDCAD 
            SET BLOQUEADO = 'S'
            WHERE CODIGO = R1.CODIGO;
          END IF;
         END LOOP;
COMMIT;
END;
/