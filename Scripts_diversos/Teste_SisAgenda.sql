--Atualizar Codigo Corporativo Especialidade
update faespcad set cod_esp_corp = '1560' where cod_esp = 'RESS';

--Atualizar Codigo Corporativo Produto
update faprdcad set cod_prd_corp = '3601502', bloqueado = 'N' where codigo = '031789';

--Inserir Profissional para Teste
insert into faprocad (cod_pro, crm, uf_crm, cpf, nome_pro,staff,funcionario, docente, inativo, cod_profissao, ind_perm_intern, ind_perm_ass_laudo, tipo_pac_autoriz, cod_tp_conselho, ind_status, cod_categ,cod_pro_corp)
              values ('082948', '082948' , 'SP','11111111111', 'TESTE AGENDA', 'S' ,'S','S','N','MEDC','S','S','IAUE','052','A','MED','082948');

--Atualizar Codigo Corporativo da Unidade
UPDATE AMUNICAD SET CO_CORP_INTEGRACAO = '405' WHERE COD_UNI = 'HVM';

--Inserir Sala para Teste
insert into imsalcad (cod_uni,cod_sala,descricao,setor_comanda,tipo_comanda,bloqueia_max) values ('HVM','WPD','TESTE AGENDA','0228','011','N');

--Inserir Produto x Sala
insert into imsalprd values('HVM','WPD','031789','0');



--delete registros das agendas--
--delete from imagncad where cod_agenda = 00062367
--delete from imagnpac where cod_prt_prov = 000048549
--delete from imagnexa where cod_agenda = 00062367