::SISHOSP

::COORP_HIS
SELECT 
CAST(TRIM(COD_PRD_CORP) AS VARCHAR(20)) CODIGO, 
CAST (COUNT(COD_PRD_CORP) AS VARCHAR(10)) QTD
FROM FAPRDCAD 
WHERE LENGTH(COD_PRD_CORP) = 10
GROUP BY COD_PRD_CORP
HAVING COUNT(COD_PRD_CORP) > 2

::UNIDADE
SELECT
nome_uni nome_unidade
FROM AMUNICAD

::PL
DECLARE

BEGIN 
  FOR I IN (SELECT
				CODIGO,
				QTD
			FROM COORP_HIS)
            LOOP
				for x in (select 
							nome_unidade
						  from unidade)
				  loop
					dbms_output.put_line('| Unidade: ' || x.nome_unidade);
				  end loop;
			  DBMS_OUTPUT.PUT_LINE('|------------------------------------------------');	  
			  DBMS_OUTPUT.PUT_LINE('| Corp: ' || i.codigo || ' Repetições: ' || i.qtd);
            END LOOP;
END;