select * from ti_ctr_pedido where cod_pedido_me = '4598682'
select * from ti_ctr_it_pedido where fk_ticped = '1'
select * from ti_ctr_dtentrg_ped where fk_tiitpd = '1'


select * from ti_ctr_pedido where cod_pedido_me = '9999999';
select * from ti_ctr_it_pedido where fk_ticped = '99999';
select * from ti_ctr_dtentrg_ped where fk_tiitpd = '99999';


update ti_ctr_pedido set status = '0', documento = '0', mensagem = '' where cod_pedido_me = '9999999';
--update ti_ctr_pedido set data_mov = '2015-03-18', dh_inclusao = '2015-03-18 00:00:01' where cod_pedido_me = '9999999';
--update ti_ctr_it_pedido set valor = valor_normal where fk_ticped = '99999';
--update ti_ctr_dtentrg_ped set qt_produto = '0.200000002980232'  where fk_tiitpd = '99999';
--update ti_ctr_it_pedido set quant = '0.200000000000000', valor = '3.500000000000000', cod_prd_corp = '000000000002991' where fk_ticped = '99999';
--update ti_ctr_pedido set status = '0' where cod_pedido_me = '9999999';

/*
insert into ti_ctr_pedido
select
'99999', tipo_oper, dh_inclusao , dh_processamento, status, mensagem, id_url, id_base, cod_empresa, filial, data_mov, hra_movimentacao, cod_for, cod_set, dat_ent, cod_pag, '0', '9999999', ds_obs_geral, frete, tipo_frete, cod_processo, dh_envio_email
from ti_ctr_pedido where cod_pedido_me = '4598682'

insert into ti_ctr_it_pedido
select
'99999','99999',quant,valor,desconto,ipi,valor_normal,uni_compra,ds_obs_item,cod_prd_corp,cod_fabricante,encerrado
from ti_ctr_it_pedido where fk_ticped = '1'

insert into ti_ctr_dtentrg_ped
select 
'99999', '99999', qt_produto, dt_entrg_prevista
from ti_ctr_dtentrg_ped where fk_tiitpd = '1'
*/


--select * from tb_entr_planej_mov where fk_es_mov = (select pk_es_mov from esmovite where tipo_documento = 'PED' and documento = '0054366')