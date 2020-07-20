-- CR........: 2561
-- CRC.......: 1780
-- Banco.....: WPDHOSP - Informix
-- Versao....: 71.03.04.00_ESHO_UTI
-- Analista..: Karina Arantes
-- Data......: 08/04/2011
-- Cliente...: HOBRA
-- Finalidade: Ajuste na quantidade reservada dos itens 
-------------------------------------------------------

-- Cria tabela temporária
CREATE TEMP TABLE estoque( 
         set_est char(4), 
         cod_prd char(6),
         quant  decimal(11,3) ) with no log;                
            
CREATE INDEX ie ON estoque(set_est,cod_prd);
CREATE INDEX ie1 ON estoque(cod_prd,set_est);


-- Zera todas as quantidades reservadas
UPDATE esestmov 
   SET reservado = 0 
 WHERE 1=1;


-- Verifica os itens que estão pendentes com suas respectivas quantidades
INSERT INTO estoque
  SELECT popedcad.set_est, DECODE(Faprdcad.COD_SAL_MARCA, NULL, popedite.cod_prd, Faprdcad.COD_SAL_MARCA) COD_PRD, sum(quant) quant  
    FROM popedcad, popedite, faprdcad, fatipcad
   WHERE popedcad.documento = popedite.documento
     AND popedite.cod_prd = faprdcad.codigo
     AND faprdcad.tipo_prd = fatipcad.tipo_prd
     AND popedcad.pendente = 'S'    
     AND popedcad.req_dev = 'R'   
     AND fatipcad.pre_class = 'MAT'
     AND (((DECODE(faprdcad.COD_SAL_MARCA, NULL, NVL(faprdcad.TIPO_CONS,'0'),(SELECT NVL(TIPO_CONS,'0') FROM FAPRDCAD C WHERE C.CODIGO = faprdcad.COD_SAL_MARCA)) <> 1)) OR
         ((DECODE(faprdcad.COD_SAL_MARCA, NULL, faprdcad.TIPO_CONS,(SELECT TIPO_CONS FROM FAPRDCAD C WHERE C.CODIGO = faprdcad.COD_SAL_MARCA)) = 1) AND ((cod_pac is null) OR (cod_pac = '') )))
GROUP BY popedcad.set_est, 2, fatipcad.pre_class;


-- Atualiza as quantidades reservadas
UPDATE esestmov 
   SET reservado = (SELECT quant 
                      FROM estoque 
                     WHERE set_est=esestmov.cod_set
                       AND cod_prd=esestmov.cod_prd)
 WHERE cod_prd||cod_set in (SELECT cod_prd||set_est 
                              FROM estoque 
                             WHERE set_est=esestmov.cod_set
                               AND cod_prd=esestmov.cod_prd);