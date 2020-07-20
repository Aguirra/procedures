select 
b.codigo, b.tabela, max(b.validade), b.coef_filme, b.coef_honor, b.custo_oper, 
b.qtd_inicial, b.qtd_subseq, b.valor, b.valor_sub, b.cod_uni, b.indice_cbhpm, b.cod_porte
from
FAPRECAD b, faprdcad a
where a.codigo = b.codigo
and a.tipo_prd = 'MED'
group by 
b.codigo, b.tabela, b.coef_filme, b.coef_honor, b.custo_oper, 
b.qtd_inicial, b.qtd_subseq, b.valor, b.valor_sub, b.cod_uni, b.indice_cbhpm, b.cod_porte
order by
b.tabela, b.validade