SELECT
--Qtd de atendimento por tipo de paciente em 2015
(select count(*) from fapaccad where data_ent between '01/01/2015' and '31/12/2015' and tipo_pac = 'I')as pac_INT,
(select count(*) from fapaccad where data_ent between '01/01/2015' and '31/12/2015' and tipo_pac = 'U')as pac_URG,
(select count(*) from fapaccad where data_ent between '01/01/2015' and '31/12/2015' and tipo_pac = 'E')as pac_EXT,
(select count(*) from fapaccad where data_ent between '01/01/2015' and '31/12/2015' and tipo_pac = 'A')as pac_AMB,
--Pacientes com declaração de nascido vivo
(select count(*)
  from fapaccad pac, fapaccom com
 where pac.cod_pac = com.cod_pac
   and pac.data_ent between '01/01/2015' and '31/12/2015'
   and com.num_atestado_nasc is not null 
   and com.num_atestado_nasc <> '')as nascido_vivo,
--INICIO CIRURGIAS
--Qtd de cirurgias agendadas em 2015
(select count(*) 
  from rcrsvcad
 where data_inicial between '01/01/2015' and '31/12/2015')as cirur_agendadas,
--Qtd de procedimentos cirurgicos agendados em 2015 
(select count(*)
  from rcrsvcad cad ,rccirrsv prod
 where cad.cod_rsv = prod.cod_rsv
   and cad.data_inicial between '01/01/2015' and '31/12/2015')as proced_agendados,
--Qtd de cirurgias realizadas em 2015
(select count(*)
  from blciru_realizada cad
 where cad.cd_ciru_realizada in (select cd_ciru_realizada 
								   from blstat_ciru_rezd status
								  where date(status.dt_stat_ciru_rezd) between '01/01/2015' and '31/12/2015'
									and status.cd_ciru_status = 'E'))as cirur_realizadas,
--Qtd de procedimentos cirurgicos realizados em 2015  
(select count(*)
  from blproc_cirurgico proc
 where proc.cd_ciru_realizada in (select cd_ciru_realizada 
                                    from blstat_ciru_rezd status
								   where date(status.dt_stat_ciru_rezd) between '01/01/2015' and '31/12/2015'
									 and status.cd_ciru_status = 'E'))as proced_realizados
FROM WPDDUAL;
--FIM CIRURGIAS