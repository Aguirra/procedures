-------------------------------------------------------------
-- Correção Custo Medio - Informix
-------------------------------------------------------------
--Assunto...: Alteração Valor de Custo para o produto - 616710
--Banco.....: IFX
--Analista..: Ricardo Aguirra
--Validado..:
--Data......: 05/2020
--Finalidade: Alteração do valor de custo do produto para contabilizar valor medio de forma correta.
--			  Foram solicitadas as confirmações e autorizações necessarias para execução no script
-------------------------------------------------------------
-- Correção Custo Medio - Informix ROLLBACK
-------------------------------------------------------------
--script 
--delete
delete eshisfec where ult_data_fec >= '29/02/20';
--update
update eshiscus set custo_atu = '250899.259259', custo_med = '250899.259259' where cod_prd = '616710' and ano_mes >= '202002';

--INSERT
insert into eshisfec values ('','29/02/20', null);
insert into eshisfec values ('','31/03/20', null);
insert into eshisfec values ('','30/04/20', null);
insert into eshisfec values ('','31/05/20', null);