-------------------------------------------------------------
-- Atualização produtos bloqueados na FAPRDCAD - INFORMIX - ROLLBACK
-------------------------------------------------------------
--Assunto...: Pedidos bloqueados na FAPRDCAD
--Banco.....: INFORMIX
--Analista..: Ricardo Aguirra
--Validado..:
--Data......: 06/2020
--Finalidade: Devido a quantiddade de registros identificados com diferença entre as tabelas FAPRDCAD E PRODUTO_UNIDADE
--			  foi criado o script abaixo para equalizar as informações de produtos a serem utilizados 
--			  deixando os itens que estão desbloqueados na PRODUTO_UNIDADE, desbloqueados na FAPRDCAD para as unidade conseguirem a utilização.
-------------------------------------------------------------
-- Atualização produtos bloqueados na FAPRDCAD - INFORMIX - ROLLBACK
-------------------------------------------------------------

DROP PROCEDURE IF EXISTS P_TAB_BKP_PRDBLOQ_rollback;
CREATE PROCEDURE P_TAB_BKP_PRDBLOQ_rollback();
   
	DEFINE	vCodigo		CHAR(6);
	DEFINE	vQtd		INT;
	DEFINE i INT;
    LET i = 1;
    
	FOREACH WITH HOLD 
        SELECT codigo INTO vCodigo from BKP_INC0288648_20200616 where 1 = 1 
        
		BEGIN WORK;
	
			SELECT count(*) qtd
			INTO vQtd
			FROM faprdcad 
			where codigo = vCodigo;
				
				IF vQtd = 1 THEN
					--UPDATE BKP_INC0288648_20200616 SET CODIGO = NULL; -- Linha para teste
					UPDATE FAPRDCAD SET BLOQUEADO = 'S' WHERE CODIGO = vCodigo;
				END IF;
        COMMIT WORK;
		
        LET i = i + 1;
    END FOREACH;
	
END PROCEDURE;

EXECUTE PROCEDURE P_TAB_BKP_PRDBLOQ_rollback();
DROP PROCEDURE P_TAB_BKP_PRDBLOQ_rollback;
