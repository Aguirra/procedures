select c.tipo_prd, b.codigo, b.cod_tabela from famovcad a, famovprd b, faprdcad c
where a.tipo_comanda = b.tipo_comanda
and a.comanda = b.comanda
and b.codigo = c.codigo
and a.cod_pac = 'R013338'


select c.tipo_prd, b.cod_tabela from famovcad a, famovprd b, faprdcad c --, fafatcad
where a.tipo_comanda = b.tipo_comanda
and a.comanda = b.comanda
and b.codigo = c.codigo
and a.cod_pac in (select distinct cod_pac from fafatprd where fatura in (select fatura from fafatcad where remessa = '005047')) order by 1
--and a.cod_pac = fafatcad.cod_pac
--and a.cod_pac = 'F806196'
--and fafatcad.remessa = '005047'

select * from tb_preco_conv_tiss where  fk_cod_con = '001' and fk_tipo_prd = 'HON' and fk_tabela = '44'

select * from tab_preco_tiss 