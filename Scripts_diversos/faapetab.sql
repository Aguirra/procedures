select * from faapetab where tipo_prd = 'REM'

create temp table apelido_tab
(tabela              char(2),        tipo_prd             char(3),
descricao            char(20),       cod_tabpreco_tiss    char(2),
usa_divisor_simpro   char(1),        pk_apetab            serial,
sn_divi_brasind      char(1),        co_unidade           varchar(6));


insert into apelido_tab
select tabela,tipo_prd,descricao,cod_tabpreco_tiss,usa_divisor_simpro,(select max(pk_apetab)+1 from faapetab),sn_divi_brasind,'HAT' 
from faapetab 
where tipo_prd = 'REM';

insert into apelido_tab
select tabela,tipo_prd,descricao,cod_tabpreco_tiss,usa_divisor_simpro,0,sn_divi_brasind,'HAT' 
from faapetab 
where tipo_prd <> 'REM';

insert into faapetab select * from apelido_tab; drop table apelido_tab;