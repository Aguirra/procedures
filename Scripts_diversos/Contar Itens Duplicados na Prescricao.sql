select cod_pac, codigo, data_hora_pres
from item_distrib
where cod_mapa is null
and cod_pac = 'B080841'
and data_hora_pres >= date('2012-07-14')
group by data_hora_pres, cod_pac, codigo
having count(*)> 1
order by 3