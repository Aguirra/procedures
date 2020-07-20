--Limpa famovprd
CREATE TEMP TABLE temp_senha (senha INTEGER);
insert into temp_senha 
select distinct famovprd.cod_sen from famovprd, famovcad, fasencad
    where famovprd.comanda = famovcad.comanda 
    and famovprd.tipo_comanda = famovcad.tipo_comanda 
    and famovprd.cod_sen = fasencad.cod_sen
    and famovcad.cod_pac in (
        select cod_pac from fafatprd where fatura in (
            select fatura from fafatcad where remessa in (<nº remessa 1>, <nº remessa 2>, <nº remessa 3>))) -- Informar o nº das remessas
                    and length (fasencad.senha) = '13';
update famovprd set cod_sen = '' where cod_sen in (select senha from temp_senha);



-- Limpa o campo de senha das remessas informadas abaixo
delete from fasencad where cod_guia in (
	select cod_guia from faguicad where cod_pac in (
		select cod_pac from fapaccad where cod_pac in (
			select cod_pac from fafatprd where fatura in (
				select fatura from fafatcad where remessa in (<nº remessa 1>, <nº remessa 2>, <nº remessa 3>)))))  -- Informar o nº das remessas
                    and length (fasencad.senha) = '13'