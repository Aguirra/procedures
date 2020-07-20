--// Horarios principais que existe horario extra que inicia dentro do periodo do principal
--// mas termina depois do fim do principal
select  * --mp.pk_confmp, cf.pk_setmap, mp.uk_hr_ini, mp.uk_hr_fim
from tb_config_mapa mp ,tb_config_setmapa cf
where pk_confmp = fuk_confmp
  and sn_exec_extra = 'N'
  and exists (   select 1
                   from tb_config_mapa mp2 ,tb_config_setmapa cf2
                  where pk_confmp = fuk_confmp
                   and cf2.fuk_co_setor_con = cf.fuk_co_setor_con 
                   and sn_exec_extra = 'S'
                   and mp2.uk_hr_ini between mp.uk_hr_ini and mp.uk_hr_fim
                   and mp2.uk_hr_fim > mp.uk_hr_fim
                   and mp2.pk_confmp <> mp.pk_confmp )

--// Horarios principais que existe outro horario principal em que os periodos se conflitam
select * --mp.pk_confmp, cf.pk_setmap, mp.uk_hr_ini, mp.uk_hr_fim
from tb_config_mapa mp ,tb_config_setmapa cf
where pk_confmp = fuk_confmp
  and sn_exec_extra = 'N'
  and exists (   select 1
                   from tb_config_mapa mp2 ,tb_config_setmapa cf2
                  where pk_confmp = fuk_confmp
                   and cf2.fuk_co_setor_con = cf.fuk_co_setor_con 
                   and sn_exec_extra = 'N'
                   and mp2.uk_hr_ini between  mp.uk_hr_ini and mp.uk_hr_fim
                   and mp2.pk_confmp <> mp.pk_confmp )