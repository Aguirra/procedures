--Excluir os itens da comanda
delete from famovprd where comanda in (select comanda from famovcad where cod_pac in (
select cod_pac from fapaccad where data_ent between '2012-09-01' and '2012-09-30' and tipo_pac = 'E' and cod_ala = 'ECOC' and cod_uni = 'TBARR'))

--Excluir as comandas
delete from famovcad where cod_pac in (
select cod_pac from fapaccad where data_ent between '2012-09-01' and '2012-09-30' and tipo_pac = 'E' and cod_ala = 'ECOC' and cod_uni = 'TBARR')

--Alterar o status dos exames para serem reprocessados pelo WintMedial
update ti_ctr_comanda set status = 'P', datahora_proc = '' where cod_pac in (
select cod_pac from ti_ctr_atendimento where tipo_pac = 'E' and data_ent between '2012-09-01' and '2012-09-30' and cod_ala = 'ECOC' and cod_uni = 'TBARR' and status = 'R')