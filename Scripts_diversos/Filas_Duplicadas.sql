select count (*), no_estacao, ds_painel, ds_fila 
  from tb_painel_fila a, tb_painel b, tb_triagem_fila c
 where a.fk_painel = b.pk_painel
   and c.pk_trifil = a.fk_trifil
   and no_estacao = '10.51.50.39'
group by no_estacao, ds_painel, ds_fila
   having count(*) > 1 