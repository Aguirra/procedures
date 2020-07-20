create temp table teste1 (unidade varchar(10), sistema char(3), cod_mod varchar(6), descricao varchar(30)) with no log;
create temp table teste2 (unidade varchar(10), sistema char(3), cod_mod varchar(6), descricao varchar(30)) with no log;

select 'insert into teste1 values (''DESENV'','''||sistema||''','''||COD_MOD||''','''||trim(DESCRICAO)||''');' from famodcad  WHERE SISTEMA = 'BLO';
select 'insert into teste2 values (''IPIRANGA'','''||sistema||''','''||COD_MOD||''','''||trim(DESCRICAO)||''');' from famodcad WHERE SISTEMA = 'BLO';

SELECT 'insert into FAMODCAD values ('''||sistema||''','''||COD_MOD||''','''||trim(DESCRICAO)||''');' FROM TESTE1 WHERE COD_MOD NOT IN (SELECT COD_MOD FROM TESTE2);
SELECT 'insert into FAMODCAD values ('''||sistema||''','''||COD_MOD||''','''||trim(DESCRICAO)||''');' FROM TESTE2 WHERE COD_MOD NOT IN (SELECT COD_MOD FROM TESTE1);


update fapricad set privilegio = '5' where sistema = 'BLO' and cod_grupo = 'WPD' and cod_mod = 'PAASS';
update fapricad set privilegio = '5' where sistema = 'BLO' and cod_grupo = 'WPD' and cod_mod = 'PACON';
update fapricad set privilegio = '5' where sistema = 'BLO' and cod_grupo = 'WPD' and cod_mod = 'PADIS';
update fapricad set privilegio = '1' where sistema = 'BLO' and cod_grupo = 'WPD' and cod_mod = 'PAWEB';
update fapricad set privilegio = '5' where sistema = 'BLO' and cod_grupo = 'WPD' and cod_mod = 'PALIS';
update fapricad set privilegio = '5' where sistema = 'BLO' and cod_grupo = 'WPD' and cod_mod = 'BLPCC';