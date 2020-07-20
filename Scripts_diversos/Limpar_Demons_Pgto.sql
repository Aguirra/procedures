delete FROM tm_demonst_pgto where fk_tratis in (select fk_tratis from tm_equrettiss where fk_fa_fat in (select fatura from fafatcad where remessa = '048497'));
delete from tm_equrettiss where fk_fa_fat in (select fatura from fafatcad where remessa = '048497');
delete FROM TB_RET_PRD_XML where nr_guia in (select num_guia from faguicad where cod_pac in (select cod_pac from fafatcad where remessa = '048497'));
delete from XMLTISS where id_xmltiss in (select id_xmltiss from guiatiss where id_loteguiatiss in (select id_loteguiatiss from loteguiatiss where remessa = '048349'));
delete from guiatiss where id_loteguiatiss in (select id_loteguiatiss from loteguiatiss where remessa = '048349');
delete from loteguiatiss where remessa = '048349';