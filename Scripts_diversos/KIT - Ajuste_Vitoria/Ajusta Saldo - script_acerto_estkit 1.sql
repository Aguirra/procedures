
--1) Estrutura das tabelas dos produtos que controlam e n�o controlam lote validade

SELECT cod_set, cod_prd, cod_barra_int, sum(quant) quant, 
       (select cod_prd from esprod_set_lote where cod_prd = p.cod_prd and cod_set = k.cod_set) CLV
  FROM ESESTOQUE_KIT k, ESESTOQUE_KIT_PRD p 
 WHERE usado = 'N' 
   AND k.cod_barra_kit = p.cod_barra_kit
GROUP BY 1,2,3,5
INTO TEMP tab_prod;

SELECT cod_set, cod_prd, sum(quant) quant
  FROM tab_prod
 WHERE clv is null
GROUP BY 1,2
ORDER BY 1,2
INTO TEMP tab_prod_nclv;

SELECT cod_set, cod_prd, COD_BARRA_INT, sum(quant) quant
  FROM tab_prod
 WHERE clv is NOT null
GROUP BY 1,2,3
ORDER BY 1,2,3
INTO TEMP tab_prod_clv;


--2) ATUALIZAR A TABELA DE SALDO DO ESTOQUE ATUAL.
--Obs: Os itens com quantidade maior que zero dever�o ser feito um cr�dito no estoque para estes itens. O cr�dito dever�
--     levar em considera��o, cod_prd (produto), cod_set (setor) e cod_barra_int (c�digo de barras interno).

SELECT t2.cod_set, t2.cod_prd, '' COD_BARRA_INT, (nvl(t2.quant,0) - nvl(e.est_atu,0)) quantidade
  FROM tab_prod_nclv t2, esestcad e 
 WHERE t2.cod_set = e.cod_set
   AND t2.cod_prd = e.cod_prd
   AND t2.quant > nvl(e.est_kit,0)
union
SELECT t3.cod_set, t3.cod_prd, t3.COD_BARRA_INT, (nvl(t3.quant,0) - nvl(e.est_atu,0)) quantidade
  FROM tab_prod_clv t3, esestcad e
 where t3.cod_set = e.cod_set
   AND t3.cod_prd = e.cod_prd
   AND t3.COD_BARRA_INT = e.COD_BARRA_INT
   AND t3.quant > nvl(e.est_atu,0);


--3) Drop das tabelas temporarias
--DROP TABLE tab_prod;
--DROP TABLE tab_prod_nclv;
--DROP TABLE tab_prod_clv;