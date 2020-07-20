select b.cod_barra_kit, c.cod_prd, c.cod_barra_int, c.quant, (a.est_atu - (a.reservado + a.est_bloq + a.est_kit))Est_Disp, a.est_kit
from esestoque_kit b, esestoque_kit_prd c, esestcad a
where b.cod_barra_kit = c.cod_barra_kit
and a.cod_prd = c.cod_prd
and a.cod_barra_int = c.cod_barra_int
and a.cod_set = b.cod_set
and b.cod_barra_kit in ('0000032242','0000032289','0000031889')
and b.cod_set = '0019'
and b.usado  = 'N'
and a.est_kit < c.quant


select c.cod_barra_kit, b.cod_set, a.cod_prd, a.est_atu, a.est_kit, c.quant  from esestcad a, esestoque_kit b, esestoque_kit_prd c
where b.cod_barra_kit = c.cod_barra_kit
  and a.cod_set = b.cod_set
  and a.cod_prd = c.cod_prd
  and a.cod_barra_int = c.cod_barra_int
  and b.cod_set = '2002' 
--and b.usado  = 'S'
  and b.cod_barra_kit = '0000158051';
  
  
  
 select count(c.cod_barra_kit), b.cod_set, a.cod_prd, 
(select est_atu from esestcad where cod_set = '0006' and cod_prd = '091444') atu,
(select est_kit from esestcad where cod_set = '0006' and cod_prd = '091444') kit,
sum(c.quant)
from esestcad a, esestoque_kit b, esestoque_kit_prd c
where b.cod_barra_kit = c.cod_barra_kit
  and a.cod_set = b.cod_set
  and a.cod_prd = c.cod_prd
  and a.cod_barra_int = c.cod_barra_int
  and b.cod_set = '0006' 
  and b.usado  = 'N'
  and a.cod_prd = '091444'
  --and b.cod_barra_kit = '0000133297'
group by 2,3,4,5;



select *
from esestcad 
where est_kit > 0 
and cod_barra_int not in (select cod_barra_int from esestoque_kit b, esestoque_kit_prd c
											  where b.cod_barra_kit = c.cod_barra_kit
											    and b.usado  = 'N'
												and b.cod_barra_kit = )