Transformar data em idade
(CASE WHEN NASCIMENTO IS NULL THEN 0 WHEN TO_CHAR(NASCIMENTO,'MM') < TO_CHAR(SYSDATE,'MM') THEN TO_CHAR(SYSDATE,'YYYY') - TO_CHAR(NASCIMENTO,'YYYY') WHEN TO_CHAR(NASCIMENTO,'MM') = TO_CHAR(SYSDATE,'MM') AND TO_CHAR(NASCIMENTO,'DD') <= TO_CHAR (SYSDATE,'MM') THEN TO_CHAR(SYSDATE,'YYYY') - TO_CHAR(NASCIMENTO,'YYYY') ELSE TO_CHAR(SYSDATE,'YYYY') - TO_CHAR(NASCIMENTO,'YYYY') - 1 END)

AND  fapaccad.data_ent BETWEEN TO_DATE('2011/04/04','YYYY/MM/DD') AND TO_DATE('2012/04/04','YYYY/MM/DD')
AND  blstat_ciru_rezd.dt_stat_ciru_rezd <= TO_DATE('2012/01/31 23:59:00','YYYY/MM/DD HH24:MI:SS')
AND  TO_CHAR(FAPACCAD.hora_ent,'HH24:MI') = '10:00'
AND  rcrsvcad.data_inicial = TO_DATE('2012/04/17','YYYY/MM/DD')

substr(esmovcad.data_mov,3,10) - Mostrar Mes e Ano


insert into table_name (date_field) values (to_date('2003/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));


