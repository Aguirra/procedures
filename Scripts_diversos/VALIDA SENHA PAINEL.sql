select * from tb_painel_chamado order by 1 ;
delete from tb_painel_chamado where (tx_chamada like '%10.1.1.2%' OR tx_chamada like '%10.1.1.3%' OR tx_chamada like '%10.1.1.4%' OR tx_chamada like '%10.1.1.5%' OR tx_chamada like '%10.1.1.6%');


select 
c.no_estacao Estacao_Terminal, c.ds_termin, c.ds_texto_painel, d.no_estacao Estacao_Painel, d.ds_painel, d.nu_porta Porta, d.no_estacao_porta Relay, b.pk_paifil, e.ds_fila
from tb_terminal_painel a, tb_painel_fila b, tb_terminal c, tb_painel d, tb_triagem_fila e
where a.fk_paifil = b.pk_paifil
  and a.fk_termin = c.pk_termin
  and b.fk_painel = d.pk_painel
  and b.fk_trifil = e.pk_trifil
  --and c.no_estacao like '%171042'
  --and d.no_estacao = '10.1.8.158'
  --and b.fk_painel in (7,8,66)
order by 2,5;



select * from tm_histpac a, tb_sel_senha_fila b
where a.fk_selsen = b.pk_selsen
and date(dh_retirada) = '24/03/2016'
and b.nu_senha = '1246'
and B.FK_COD_UNI = 'MOEMA'






select * from tb_painel

select 
--count(*), 
c.no_estacao Estacao_Terminal, c.ds_termin, c.ds_texto_painel, d.no_estacao Estacao_Painel, d.ds_painel, d.nu_porta Porta, d.no_estacao_porta Relay
from tb_terminal_painel a, tb_painel_fila b, tb_terminal c, tb_painel d
where a.fk_paifil = b.pk_paifil
  and a.fk_termin = c.pk_termin
  and b.fk_painel = d.pk_painel
  and b.fk_painel in (7,8,66)
--group by 2
order by 2,5



select * from tm_histpac a, tb_sel_senha_fila b
where a.fk_selsen = b.pk_selsen
and date(dh_retirada) = '24/03/2016'
and b.nu_senha = '1243'
and B.FK_COD_UNI = 'MOEMA'
