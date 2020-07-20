select b.* from famovprd b, famovcad a
where a.cod_pac = '0359254'
and b.comanda = a.comanda
and b.tipo_comanda = b.tipo_comanda
and b.codigo in ('056726','056948','057133','191204','194722')

select * from faguicad where cod_pac = '0359254'

select comanda,cod_guia, cod_sen from famovprd where comanda = '0513829' and tipo_comanda = 'CECI'


--update famovprd set cod_guia = '10236', cod_sen = '6145' where comanda = '0513829' and tipo_comanda = 'CECI'
update famovprd set cod_guia = null, cod_sen = null where comanda = '0513829' and tipo_comanda = 'CECI'

10236


select * from fafatprd where fatura in ('024725','025561')
select * from famovdestino where cod_fatura in (select fatura from fafatcad where cod_pac = '0359254') order by destino


------------------------------------------------------------------------------------

select * from pre_glosa_produto where cod_pac = '0368579' and cod_produto in ('191204','194722')

select famovdestino.destino,famovprd.* from famovprd, famovdestino
where famovprd.sequencial = famovdestino.sequencial
and comanda in('0513829','0526670')  and codigo in ('191204','194722')



select famovdestino.destino,famovprd.* from famovprd, famovdestino
where famovprd.sequencial = famovdestino.sequencial
and comanda in('0513829','0526670')  and codigo in (
'073722',
'073722',
'189412',
'072175',
'059019',
'020303',
'011304')


select * from pre_glosa_produto where cod_pac = '0368579' order by cod_produto

select * from fafatprd where fatura in ('025849')
and cod_prd in ('073722','073722','189412','072175','059019','011304')
order by cod_prd



select famovprd.* from famovprd, famovdestino where famovprd.sequencial = famovdestino.sequencial
and codigo in ('073722','073722','189412','072175','059019','011304')
and cod_fatura in (select fatura from fafatcad where cod_pac = '0368579') order by comanda, codigo




update famovprd set cod_guia = null, cod_sen = null where comanda = '0513829' and tipo_comanda = 'CECI' and codigo = '191204'


update famovprd set cod_guia = null, cod_sen = null where comanda = '0526619' and tipo_comanda = 'CECI' and codigo = '011304';
update famovprd set cod_guia = null, cod_sen = null where comanda = '0526619' and tipo_comanda = 'CECI' and codigo = '059019';
update famovprd set cod_guia = null, cod_sen = null where comanda = '0526619' and tipo_comanda = 'CECI' and codigo = '073722';
update famovprd set cod_guia = null, cod_sen = null where comanda = '0526635' and tipo_comanda = 'CECI' and codigo = '072175';
update famovprd set cod_guia = null, cod_sen = null where comanda = '0526635' and tipo_comanda = 'CECI' and codigo = '189412';
update famovprd set cod_guia = null, cod_sen = null where comanda = '0528530' and tipo_comanda = 'POST' and codigo = '073722';



update famovprd set cod_guia = '10570', cod_sen = '6313' where comanda = '0526619' and tipo_comanda = 'CECI' and codigo = '011304';
update famovprd set cod_guia = '10570', cod_sen = '6313' where comanda = '0526619' and tipo_comanda = 'CECI' and codigo = '059019';
update famovprd set cod_guia = '10570', cod_sen = '6313' where comanda = '0526619' and tipo_comanda = 'CECI' and codigo = '073722';
update famovprd set cod_guia = '10570', cod_sen = '6313' where comanda = '0526635' and tipo_comanda = 'CECI' and codigo = '072175';
update famovprd set cod_guia = '10570', cod_sen = '6313' where comanda = '0526635' and tipo_comanda = 'CECI' and codigo = '189412';
update famovprd set cod_guia = '10570', cod_sen = '6313' where comanda = '0528530' and tipo_comanda = 'POST' and codigo = '073722';