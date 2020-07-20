insert into esestmov
select 
cod_set,cod_prd,em_balanco,localizacao,reservado,pct_ponto_repos,data_ult_bal,hora_ult_bal,sn_migrado
from esestcad
where cod_prd = '450326'