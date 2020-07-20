delete from CONFIGPARAMTISS where id_conconfig in (select id_conconfig from CONCONFIG where cod_con = '059');

delete from configobgtiss where id_configtiss in (select id_configtiss from configtiss where id_conconfig in (select id_conconfig from CONCONFIG where cod_con = '059'))

delete from configtiss where id_conconfig in (select id_conconfig from CONCONFIG where cod_con = '059');

delete from CONCONFIG where cod_con = '059';

EXECUTE PROCEDURE sp_copy_conftiss('003','059');

EXECUTE PROCEDURE sp_configtiss_conv('059');