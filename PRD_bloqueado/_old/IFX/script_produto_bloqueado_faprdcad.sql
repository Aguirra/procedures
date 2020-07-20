-------------------------------------------------------------
-- Atualização produtos bloqueados na FAPRDCAD - INFORMIX
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
-- Atualização produtos bloqueados na FAPRDCAD - INFORMIX
-------------------------------------------------------------

--CRIAÇÃO TABELA DE BACKUP PARA GUARDAR REGISTROS ATUALIZADOS
DROP PROCEDURE IF EXISTS P_TAB_BKP_PRDBLOQ;
CREATE PROCEDURE P_TAB_BKP_PRDBLOQ ()

	define vtable INT;

	SELECT COUNT(*)
	INTO vtable
	FROM systables
	WHERE UPPER(tabname) = 'BKP_INC0288648_20200616';

	IF  vtable = 0 THEN 

		CREATE TABLE BKP_INC0288648_20200616 (
		codigo	CHAR(6),
		ds_atualizacao VARCHAR(255));

	END IF;

END PROCEDURE;

EXECUTE PROCEDURE P_TAB_BKP_PRDBLOQ();


--PROC PARA REALIZAR A ATUALIZAÇÃO DOS PRODUTOS QUE ESTÃO BLOQUEADOS NA FAPRDCAD E DESBLOQUEADOS NA PRODUTO_UNIDADE
DROP PROCEDURE IF EXISTS P_ATUALIZA_BKP_PRDBLOQ;
CREATE PROCEDURE P_ATUALIZA_BKP_PRDBLOQ ()
	
DEFINE	vBloq			varchar(255);
DEFINE	vQtd, vCodigo	CHAR(6);
DEFINE	vPrcorp			INT;
DEFINE	i, x			INT;
DEFINE	vtransacao 		INT;

let i = 0;

BEGIN WORK;
let vtransacao = 1;
		foreach WITH hold

		SELECT CODIGO, COUNT(*) QTD
		INTO vCodigo, vQtd
        FROM produto_unidade
		WHERE 1 = 1
		AND	sn_bloqueado = 'N'
		GROUP BY codigo
		
	IF vQtd > 0 THEN
		
		SELECT bloqueado, LENGTH(cod_prd_corp)
        INTO vBloq, vPrcorp
        FROM faprdcad 
        WHERE codigo = vCodigo;
		
		IF vBloq = 'S' THEN 
			IF (vPrcorp = 10) THEN
				--VERIFICA SE O CODIGO DO PRODUTO JÁ FOI REALIZADO ALGUMA ALTERAÇÃO
				SELECT COUNT(*)
				INTO x
				FROM BKP_INC0288648_20200616
				WHERE CODIGO = vCodigo;
				
					IF x = 0 THEN
						--REALIZA O DESBLOQUEIO SE O PRODUTO ESTIVER DESBLOQUEADO DA PRODUTO_UNIDADE E BLOQUEADO NA FAPRDCAD 
						UPDATE FAPRDCAD 
						SET BLOQUEADO = 'N' 
						WHERE CODIGO = vCodigo;
						--GUARDA REGISTRO ALTERADO EM TABELA BACKUP
						INSERT INTO BKP_INC0288648_20200616 
							VALUES (vCodigo, 'PRODUTO DESBLOQUEADO - ' ||to_char(current, '%d/%m/%Y %H:%M'));
					END IF;
			END IF;
		END IF;
	END IF;
	
	IF i = 1000 THEN
		IF vtransacao = 1 THEN
			COMMIT work;

			let vtransacao = 0;
			let i = 0;
		END IF;
		if vtransacao = 0 THEN
			BEGIN work;
			let vtransacao = 1;
		END IF;
	END IF;
		let i = i+1;
 END foreach;
	if vtransacao = 1 THEN
			COMMIT work;
			let vtransacao = 0;
			let i = 0;
		END IF;
END PROCEDURE;

EXECUTE PROCEDURE P_ATUALIZA_BKP_PRDBLOQ();

DROP PROCEDURE P_ATUALIZA_BKP_PRDBLOQ;
DROP PROCEDURE P_TAB_BKP_PRDBLOQ;
