-------------------------------------------------------------
-- Atualização produtos bloqueados na FAPRDCAD - ORALCE
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
-- Atualização produtos bloqueados na FAPRDCAD - ORALCE
-------------------------------------------------------------

ALTER SESSION SET CURRENT_SCHEMA=SISHOSP
/

--CRIAÇÃO TABELA DE BACKUP PARA GUARDAR REGISTROS ATUALIZADOS
DECLARE 
  CURSOR C1 IS 
       SELECT count(*)
       FROM all_tables
       WHERE UPPER(table_name) = 'BKP_INC0288648_20200616';

BEGIN 
  FOR C2 IN C1 LOOP 
       IF C1%FOUND then
         EXECUTE IMMEDIATE ('CREATE TABLE SISHOSP.BKP_INC0288648_20200616(
								CODIGO				VARCHAR2(6),
								DS_ATUALIZACAO		VARCHAR2(255))');
								
		EXECUTE IMMEDIATE('GRANT SELECT, INSERT, UPDATE ON SISHOSP.BKP_INC0288648_20200616 TO SH_ROLE_ALL_OBJECTS');
		ELSE
			exit;
       END IF; 
     END LOOP;
    EXCEPTION 
      WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE(sqlerrm);
END;
/

--ATUALIZAÇÃO DOS PRODUTOS QUE ESTÃO BLOQUEADOS NA FAPRDCAD E DESBLOQUEADOS NA PRODUTO_UNIDADE
DECLARE 
vBloq    CHAR(1);
vPrcorp  NUMBER;
x        INT;
v_prd    varchar2(255);
BEGIN
  FOR r1 IN
    (SELECT COUNT(*) qtd, codigo
         FROM produto_unidade
         WHERE 1 = 1 
     AND sn_bloqueado = 'N' 
     GROUP BY codigo)
  LOOP
    IF r1.qtd > 0 THEN
      v_prd:= r1.codigo;
      SELECT bloqueado, LENGTH(cod_prd_corp)
      INTO vBloq, vPrcorp
      FROM faprdcad 
      WHERE codigo = r1.codigo;
		
		IF vBloq = 'S' THEN
			IF (vPrcorp = 10) THEN
				--VERIFICA SE O CODIGO DO PRODUTO JÁ FOI REALIZADO ALGUMA ALTERAÇÃO
				SELECT COUNT(*)
				INTO x
				FROM SISHOSP.BKP_INC0288648_20200616
				WHERE CODIGO = r1.codigo;
				
					IF x = 0 THEN
						--REALIZA O DESBLOQUEIO SE O PRODUTO ESTIVER DESBLOQUEADO DA PRODUTO_UNIDADE E BLOQUEADO NA FAPRDCAD 
						UPDATE faprdcad 
						SET bloqueado = 'N' 
						WHERE codigo = r1.codigo;
						--GUARDA REGISTRO ALTERADO EM TABELA BACKUP
						INSERT INTO SISHOSP.BKP_INC0288648_20200616 
							VALUES (r1.codigo, 'PRODUTO DESBLOQUEADO - ' ||to_char(CURRENT_DATE, 'DD/MM/YYYY HH24:MI'));
					END IF;
					COMMIT;
			END IF;
		END IF;
	END IF;
END LOOP;
    EXCEPTION
      WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('PRODUTO: ' || V_PRD);
END;
/