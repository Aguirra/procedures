SELECT LOTE.cod_prd, TRIM(LOTE.lote), LOTE.validade, LOTE.cod_fabricante, count(*)
FROM ESLOTE_VALIDADE LOTE
WHERE validade >= today
group by LOTE.cod_prd, LOTE.lote, LOTE.validade, LOTE.cod_fabricante
having count(*) > 1
ORDER BY LOTE.cod_prd;


SELECT LOTE.COD_BARRA_INT, LOTE.cod_prd, TRIM(LOTE.lote), LOTE.validade, LOTE.cod_fabricante
FROM ESLOTE_VALIDADE LOTE
WHERE LOTE.quantidade = 0
  and validade >= today
group by LOTE.COD_BARRA_INT, LOTE.cod_prd, LOTE.lote, LOTE.validade, LOTE.cod_fabricante
ORDER BY LOTE.cod_prd;


SELECT PRD.*
FROM ESLOTE_VALIDADE LOTE, ESESTCAD PRD
WHERE LOTE.COD_PRD = PRD.COD_PRD
  AND LOTE.COD_BARRA_INT = PRD.COD_BARRA_INT
  AND LOTE.quantidade = 0
  AND PRD.EST_ATU > 0
  AND LOTE.validade >= today;


SELECT PRD.*
FROM ESLOTE_VALIDADE LOTE, ESMOVITE PRD
WHERE LOTE.COD_PRD = PRD.COD_PRD
  AND LOTE.COD_BARRA_INT = PRD.COD_BARRA_INT
  AND LOTE.quantidade = 0
  AND LOTE.validade >= today;


  
---checa quant > 0 com estoque (Não pode bloquear lote via aplicação somente via banco)--
select  cod_prd, lote, validade, cod_fabricante from eslote_validade where quantidade = 0 AND validade >= today INTO temp marra with no log;
select * from esestcad where est_atu > 0
  and cod_barra_int in (select lote.cod_barra_int from marra, eslote_validade lote
where marra.cod_prd = lote.cod_prd and marra.lote = lote.lote and marra.validade = lote.validade
  and marra.cod_fabricante = lote.cod_fabricante and lote.quantidade >= 1);
---checa quant > 0 com estoque (Não pode bloquear lote via aplicação somente via banco)--