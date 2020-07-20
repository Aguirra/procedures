--SELECIONA OS PACIENTE COM ALTA E STATUS EM OBSERVAÇÃO NO PS--
select fapaccad.cod_prt,
       fapaccad.cod_pac,
       fapaccad.data_alta,
       fapaccad.hora_alta
 from fapaccad
where data_alta is not null
  and hora_alta is not null
  and data_alta_medica is not null
  and tipo_pac = 'U'
  and data_ent >= '25/12/2015'
  and cod_pac in ( select tb_sel_senha_fila.fk_cod_pac
                     from tb_sel_senha_fila, te_status_triag
                    where tb_sel_senha_fila.fk_striag = te_status_triag.pk_striag
                      and te_status_triag.pk_striag = '40');
					  

--LIMPA A ALTA DOS PACIENTES COM STATUS "EM OBSERVAÇÃO" NO PS--
UPDATE fapaccad SET data_alta = null, 
                    hora_alta = null, 
                    data_alta_medica = null
	          where data_alta is not null
     	        and hora_alta is not null
	            and data_alta_medica is not null
  	            and tipo_pac = 'U'
	            and data_ent >= '24/12/2015'
	            and cod_pac in ( select tb_sel_senha_fila.fk_cod_pac
			                       from tb_sel_senha_fila
		                          where tb_sel_senha_fila.fk_cod_pac = fapaccad
			                        and tb_sel_senha_fila.fk_striag = '40');
									
									
UPDATE fapaccad SET data_alta = '24/12/2015', 
					hora_alta = '22:48', 
					data_alta_medica = to_date('24/12/2015 22:48:00', '%d/%m/%Y %H:%M:%S') 
				where cod_pac = '4423280'