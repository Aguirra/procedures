--Quantidade de Prescrições
SELECT '05-2014', COUNT(DISTINCT FK_PRESCC) FROM TM_PRESCRICAO_ITE B, FAPRDCAD D, FATIPCAD E WHERE B.FK_CODIGO = D.CODIGO AND D.TIPO_PRD = E.TIPO_PRD AND E.TIPO_PRD_CORP IN ('MED','MQT','MMP') AND FK_PRESCC IN (SELECT PK_PRESCC FROM TM_PRESCRICAO_CAD A, FAPACCAD C WHERE A.FK_COD_PAC = C.COD_PAC AND C.TIPO_PAC IN ('U') AND C.DATA_ENT BETWEEN '01/05/2014' AND '31/05/2014')
UNION ALL
SELECT '06-2014', COUNT(DISTINCT FK_PRESCC) FROM TM_PRESCRICAO_ITE B, FAPRDCAD D, FATIPCAD E WHERE B.FK_CODIGO = D.CODIGO AND D.TIPO_PRD = E.TIPO_PRD AND E.TIPO_PRD_CORP IN ('MED','MQT','MMP') AND FK_PRESCC IN (SELECT PK_PRESCC FROM TM_PRESCRICAO_CAD A, FAPACCAD C WHERE A.FK_COD_PAC = C.COD_PAC AND C.TIPO_PAC IN ('U') AND C.DATA_ENT BETWEEN '01/06/2014' AND '30/06/2014')
UNION ALL
SELECT '07-2014', COUNT(DISTINCT FK_PRESCC) FROM TM_PRESCRICAO_ITE B, FAPRDCAD D, FATIPCAD E WHERE B.FK_CODIGO = D.CODIGO AND D.TIPO_PRD = E.TIPO_PRD AND E.TIPO_PRD_CORP IN ('MED','MQT','MMP') AND FK_PRESCC IN (SELECT PK_PRESCC FROM TM_PRESCRICAO_CAD A, FAPACCAD C WHERE A.FK_COD_PAC = C.COD_PAC AND C.TIPO_PAC IN ('U') AND C.DATA_ENT BETWEEN '01/07/2014' AND '31/07/2014')
UNION ALL
SELECT '08-2014', COUNT(DISTINCT FK_PRESCC) FROM TM_PRESCRICAO_ITE B, FAPRDCAD D, FATIPCAD E WHERE B.FK_CODIGO = D.CODIGO AND D.TIPO_PRD = E.TIPO_PRD AND E.TIPO_PRD_CORP IN ('MED','MQT','MMP') AND FK_PRESCC IN (SELECT PK_PRESCC FROM TM_PRESCRICAO_CAD A, FAPACCAD C WHERE A.FK_COD_PAC = C.COD_PAC AND C.TIPO_PAC IN ('U') AND C.DATA_ENT BETWEEN '01/08/2014' AND '31/08/2014')
UNION ALL
SELECT '09-2014', COUNT(DISTINCT FK_PRESCC) FROM TM_PRESCRICAO_ITE B, FAPRDCAD D, FATIPCAD E WHERE B.FK_CODIGO = D.CODIGO AND D.TIPO_PRD = E.TIPO_PRD AND E.TIPO_PRD_CORP IN ('MED','MQT','MMP') AND FK_PRESCC IN (SELECT PK_PRESCC FROM TM_PRESCRICAO_CAD A, FAPACCAD C WHERE A.FK_COD_PAC = C.COD_PAC AND C.TIPO_PAC IN ('U') AND C.DATA_ENT BETWEEN '01/09/2014' AND '30/09/2014')
UNION ALL
SELECT '10-2014', COUNT(DISTINCT FK_PRESCC) FROM TM_PRESCRICAO_ITE B, FAPRDCAD D, FATIPCAD E WHERE B.FK_CODIGO = D.CODIGO AND D.TIPO_PRD = E.TIPO_PRD AND E.TIPO_PRD_CORP IN ('MED','MQT','MMP') AND FK_PRESCC IN (SELECT PK_PRESCC FROM TM_PRESCRICAO_CAD A, FAPACCAD C WHERE A.FK_COD_PAC = C.COD_PAC AND C.TIPO_PAC IN ('U') AND C.DATA_ENT BETWEEN '01/10/2014' AND '31/10/2014')
UNION ALL
SELECT '11-2014', COUNT(DISTINCT FK_PRESCC) FROM TM_PRESCRICAO_ITE B, FAPRDCAD D, FATIPCAD E WHERE B.FK_CODIGO = D.CODIGO AND D.TIPO_PRD = E.TIPO_PRD AND E.TIPO_PRD_CORP IN ('MED','MQT','MMP') AND FK_PRESCC IN (SELECT PK_PRESCC FROM TM_PRESCRICAO_CAD A, FAPACCAD C WHERE A.FK_COD_PAC = C.COD_PAC AND C.TIPO_PAC IN ('U') AND C.DATA_ENT BETWEEN '01/11/2014' AND '30/11/2014')
UNION ALL
SELECT '12-2014', COUNT(DISTINCT FK_PRESCC) FROM TM_PRESCRICAO_ITE B, FAPRDCAD D, FATIPCAD E WHERE B.FK_CODIGO = D.CODIGO AND D.TIPO_PRD = E.TIPO_PRD AND E.TIPO_PRD_CORP IN ('MED','MQT','MMP') AND FK_PRESCC IN (SELECT PK_PRESCC FROM TM_PRESCRICAO_CAD A, FAPACCAD C WHERE A.FK_COD_PAC = C.COD_PAC AND C.TIPO_PAC IN ('U') AND C.DATA_ENT BETWEEN '01/12/2014' AND '31/12/2014')
UNION ALL
SELECT '01-2015', COUNT(DISTINCT FK_PRESCC) FROM TM_PRESCRICAO_ITE B, FAPRDCAD D, FATIPCAD E WHERE B.FK_CODIGO = D.CODIGO AND D.TIPO_PRD = E.TIPO_PRD AND E.TIPO_PRD_CORP IN ('MED','MQT','MMP') AND FK_PRESCC IN (SELECT PK_PRESCC FROM TM_PRESCRICAO_CAD A, FAPACCAD C WHERE A.FK_COD_PAC = C.COD_PAC AND C.TIPO_PAC IN ('U') AND C.DATA_ENT BETWEEN '01/01/2015' AND '31/01/2015')
UNION ALL
SELECT '02-2015', COUNT(DISTINCT FK_PRESCC) FROM TM_PRESCRICAO_ITE B, FAPRDCAD D, FATIPCAD E WHERE B.FK_CODIGO = D.CODIGO AND D.TIPO_PRD = E.TIPO_PRD AND E.TIPO_PRD_CORP IN ('MED','MQT','MMP') AND FK_PRESCC IN (SELECT PK_PRESCC FROM TM_PRESCRICAO_CAD A, FAPACCAD C WHERE A.FK_COD_PAC = C.COD_PAC AND C.TIPO_PAC IN ('U') AND C.DATA_ENT BETWEEN '01/02/2015' AND '28/02/2015')
UNION ALL
SELECT '03-2015', COUNT(DISTINCT FK_PRESCC) FROM TM_PRESCRICAO_ITE B, FAPRDCAD D, FATIPCAD E WHERE B.FK_CODIGO = D.CODIGO AND D.TIPO_PRD = E.TIPO_PRD AND E.TIPO_PRD_CORP IN ('MED','MQT','MMP') AND FK_PRESCC IN (SELECT PK_PRESCC FROM TM_PRESCRICAO_CAD A, FAPACCAD C WHERE A.FK_COD_PAC = C.COD_PAC AND C.TIPO_PAC IN ('U') AND C.DATA_ENT BETWEEN '01/03/2015' AND '31/03/2015')
UNION ALL
SELECT '04-2015', COUNT(DISTINCT FK_PRESCC) FROM TM_PRESCRICAO_ITE B, FAPRDCAD D, FATIPCAD E WHERE B.FK_CODIGO = D.CODIGO AND D.TIPO_PRD = E.TIPO_PRD AND E.TIPO_PRD_CORP IN ('MED','MQT','MMP') AND FK_PRESCC IN (SELECT PK_PRESCC FROM TM_PRESCRICAO_CAD A, FAPACCAD C WHERE A.FK_COD_PAC = C.COD_PAC AND C.TIPO_PAC IN ('U') AND C.DATA_ENT BETWEEN '01/04/2015' AND '30/04/2015')
UNION ALL
SELECT '05-2015', COUNT(DISTINCT FK_PRESCC) FROM TM_PRESCRICAO_ITE B, FAPRDCAD D, FATIPCAD E WHERE B.FK_CODIGO = D.CODIGO AND D.TIPO_PRD = E.TIPO_PRD AND E.TIPO_PRD_CORP IN ('MED','MQT','MMP') AND FK_PRESCC IN (SELECT PK_PRESCC FROM TM_PRESCRICAO_CAD A, FAPACCAD C WHERE A.FK_COD_PAC = C.COD_PAC AND C.TIPO_PAC IN ('U') AND C.DATA_ENT BETWEEN '01/05/2015' AND '31/05/2015');


--Quantidade de Itens Prescritos
select '05-2014', count(*) from tm_prescricao_cad a, tm_prescricao_ite b, fapaccad c, faprdcad d, fatipcad e where a.pk_prescc = b.fk_prescc and a.fk_cod_pac = c.cod_pac and b.fk_codigo = d.codigo and d.tipo_prd = e.tipo_prd and c.tipo_pac in ('U') and c.data_ent between '01/05/2014' and '31/05/2014' and e.tipo_prd_corp IN ('MED','MQT','MMP')
union all
select '06-2014', count(*) from tm_prescricao_cad a, tm_prescricao_ite b, fapaccad c, faprdcad d, fatipcad e where a.pk_prescc = b.fk_prescc and a.fk_cod_pac = c.cod_pac and b.fk_codigo = d.codigo and d.tipo_prd = e.tipo_prd and c.tipo_pac in ('U') and c.data_ent between '01/06/2014' and '30/06/2014' and e.tipo_prd_corp IN ('MED','MQT','MMP')
union all
select '07-2014', count(*) from tm_prescricao_cad a, tm_prescricao_ite b, fapaccad c, faprdcad d, fatipcad e where a.pk_prescc = b.fk_prescc and a.fk_cod_pac = c.cod_pac and b.fk_codigo = d.codigo and d.tipo_prd = e.tipo_prd and c.tipo_pac in ('U') and c.data_ent between '01/07/2014' and '31/07/2014' and e.tipo_prd_corp IN ('MED','MQT','MMP')
union all
select '08-2014', count(*) from tm_prescricao_cad a, tm_prescricao_ite b, fapaccad c, faprdcad d, fatipcad e where a.pk_prescc = b.fk_prescc and a.fk_cod_pac = c.cod_pac and b.fk_codigo = d.codigo and d.tipo_prd = e.tipo_prd and c.tipo_pac in ('U') and c.data_ent between '01/08/2014' and '31/08/2014' and e.tipo_prd_corp IN ('MED','MQT','MMP')
union all
select '09-2014', count(*) from tm_prescricao_cad a, tm_prescricao_ite b, fapaccad c, faprdcad d, fatipcad e where a.pk_prescc = b.fk_prescc and a.fk_cod_pac = c.cod_pac and b.fk_codigo = d.codigo and d.tipo_prd = e.tipo_prd and c.tipo_pac in ('U') and c.data_ent between '01/09/2014' and '30/09/2014' and e.tipo_prd_corp IN ('MED','MQT','MMP')
union all
select '10-2014', count(*) from tm_prescricao_cad a, tm_prescricao_ite b, fapaccad c, faprdcad d, fatipcad e where a.pk_prescc = b.fk_prescc and a.fk_cod_pac = c.cod_pac and b.fk_codigo = d.codigo and d.tipo_prd = e.tipo_prd and c.tipo_pac in ('U') and c.data_ent between '01/10/2014' and '31/10/2014' and e.tipo_prd_corp IN ('MED','MQT','MMP')
union all
select '11-2014', count(*) from tm_prescricao_cad a, tm_prescricao_ite b, fapaccad c, faprdcad d, fatipcad e where a.pk_prescc = b.fk_prescc and a.fk_cod_pac = c.cod_pac and b.fk_codigo = d.codigo and d.tipo_prd = e.tipo_prd and c.tipo_pac in ('U') and c.data_ent between '01/11/2014' and '30/11/2014' and e.tipo_prd_corp IN ('MED','MQT','MMP')
union all
select '12-2014', count(*) from tm_prescricao_cad a, tm_prescricao_ite b, fapaccad c, faprdcad d, fatipcad e where a.pk_prescc = b.fk_prescc and a.fk_cod_pac = c.cod_pac and b.fk_codigo = d.codigo and d.tipo_prd = e.tipo_prd and c.tipo_pac in ('U') and c.data_ent between '01/12/2014' and '31/12/2014' and e.tipo_prd_corp IN ('MED','MQT','MMP')
union all
select '01-2015', count(*) from tm_prescricao_cad a, tm_prescricao_ite b, fapaccad c, faprdcad d, fatipcad e where a.pk_prescc = b.fk_prescc and a.fk_cod_pac = c.cod_pac and b.fk_codigo = d.codigo and d.tipo_prd = e.tipo_prd and c.tipo_pac in ('U') and c.data_ent between '01/01/2015' and '31/01/2015' and e.tipo_prd_corp IN ('MED','MQT','MMP')
union all
select '02-2015', count(*) from tm_prescricao_cad a, tm_prescricao_ite b, fapaccad c, faprdcad d, fatipcad e where a.pk_prescc = b.fk_prescc and a.fk_cod_pac = c.cod_pac and b.fk_codigo = d.codigo and d.tipo_prd = e.tipo_prd and c.tipo_pac in ('U') and c.data_ent between '01/02/2015' and '28/02/2015' and e.tipo_prd_corp IN ('MED','MQT','MMP')
union all
select '03-2015', count(*) from tm_prescricao_cad a, tm_prescricao_ite b, fapaccad c, faprdcad d, fatipcad e where a.pk_prescc = b.fk_prescc and a.fk_cod_pac = c.cod_pac and b.fk_codigo = d.codigo and d.tipo_prd = e.tipo_prd and c.tipo_pac in ('U') and c.data_ent between '01/03/2015' and '31/03/2015' and e.tipo_prd_corp IN ('MED','MQT','MMP')
union all
select '04-2015', count(*) from tm_prescricao_cad a, tm_prescricao_ite b, fapaccad c, faprdcad d, fatipcad e where a.pk_prescc = b.fk_prescc and a.fk_cod_pac = c.cod_pac and b.fk_codigo = d.codigo and d.tipo_prd = e.tipo_prd and c.tipo_pac in ('U') and c.data_ent between '01/04/2015' and '30/04/2015' and e.tipo_prd_corp IN ('MED','MQT','MMP')
union all
select '05-2015', count(*) from tm_prescricao_cad a, tm_prescricao_ite b, fapaccad c, faprdcad d, fatipcad e where a.pk_prescc = b.fk_prescc and a.fk_cod_pac = c.cod_pac and b.fk_codigo = d.codigo and d.tipo_prd = e.tipo_prd and c.tipo_pac in ('U') and c.data_ent between '01/05/2015' and '31/05/2015' and e.tipo_prd_corp IN ('MED','MQT','MMP');


--Quantidade de receitas 
select '05-2014', count(*) from receita a, fapaccad b where a.cod_pac = b.cod_pac and b.tipo_pac in ('U') and b.data_ent between '01/05/2014' and '31/05/2014'
union all
select '06-2014', count(*) from receita a, fapaccad b where a.cod_pac = b.cod_pac and b.tipo_pac in ('U') and b.data_ent between '01/06/2014' and '30/06/2014'
union all
select '07-2014', count(*) from receita a, fapaccad b where a.cod_pac = b.cod_pac and b.tipo_pac in ('U') and b.data_ent between '01/07/2014' and '31/07/2014'
union all
select '08-2014', count(*) from receita a, fapaccad b where a.cod_pac = b.cod_pac and b.tipo_pac in ('U') and b.data_ent between '01/08/2014' and '31/08/2014'
union all
select '09-2014', count(*) from receita a, fapaccad b where a.cod_pac = b.cod_pac and b.tipo_pac in ('U') and b.data_ent between '01/09/2014' and '30/09/2014'
union all
select '10-2014', count(*) from receita a, fapaccad b where a.cod_pac = b.cod_pac and b.tipo_pac in ('U') and b.data_ent between '01/10/2014' and '31/10/2014'
union all
select '11-2014', count(*) from receita a, fapaccad b where a.cod_pac = b.cod_pac and b.tipo_pac in ('U') and b.data_ent between '01/11/2014' and '30/11/2014'
union all
select '12-2014', count(*) from receita a, fapaccad b where a.cod_pac = b.cod_pac and b.tipo_pac in ('U') and b.data_ent between '01/12/2014' and '31/12/2014'
union all
select '01-2015', count(*) from receita a, fapaccad b where a.cod_pac = b.cod_pac and b.tipo_pac in ('U') and b.data_ent between '01/01/2015' and '31/01/2015'
union all
select '02-2015', count(*) from receita a, fapaccad b where a.cod_pac = b.cod_pac and b.tipo_pac in ('U') and b.data_ent between '01/02/2015' and '28/02/2015'
union all
select '03-2015', count(*) from receita a, fapaccad b where a.cod_pac = b.cod_pac and b.tipo_pac in ('U') and b.data_ent between '01/03/2015' and '31/03/2015'
union all
select '04-2015', count(*) from receita a, fapaccad b where a.cod_pac = b.cod_pac and b.tipo_pac in ('U') and b.data_ent between '01/04/2015' and '30/04/2015'
union all
select '05-2015', count(*) from receita a, fapaccad b where a.cod_pac = b.cod_pac and b.tipo_pac in ('U') and b.data_ent between '01/05/2015' and '31/05/2015';


--Quantidade de Itens da Receita
select '05-2014', count(*) from receita a, tb_it_med_receita b, fapaccad c where a.cod_pac = b.cod_pac and a.cod_pro = b.cod_pro and a.dat_receita = b.dat_receita and a.cod_pac = c.cod_pac and c.tipo_pac in ('U') and c.data_ent between '01/05/2014' and '31/05/2014'
union all
select '06-2014', count(*) from receita a, tb_it_med_receita b, fapaccad c where a.cod_pac = b.cod_pac and a.cod_pro = b.cod_pro and a.dat_receita = b.dat_receita and a.cod_pac = c.cod_pac and c.tipo_pac in ('U') and c.data_ent between '01/06/2014' and '30/06/2014'
union all
select '07-2014', count(*) from receita a, tb_it_med_receita b, fapaccad c where a.cod_pac = b.cod_pac and a.cod_pro = b.cod_pro and a.dat_receita = b.dat_receita and a.cod_pac = c.cod_pac and c.tipo_pac in ('U') and c.data_ent between '01/07/2014' and '31/07/2014'
union all
select '08-2014', count(*) from receita a, tb_it_med_receita b, fapaccad c where a.cod_pac = b.cod_pac and a.cod_pro = b.cod_pro and a.dat_receita = b.dat_receita and a.cod_pac = c.cod_pac and c.tipo_pac in ('U') and c.data_ent between '01/08/2014' and '31/08/2014'
union all
select '09-2014', count(*) from receita a, tb_it_med_receita b, fapaccad c where a.cod_pac = b.cod_pac and a.cod_pro = b.cod_pro and a.dat_receita = b.dat_receita and a.cod_pac = c.cod_pac and c.tipo_pac in ('U') and c.data_ent between '01/09/2014' and '30/09/2014'
union all
select '10-2014', count(*) from receita a, tb_it_med_receita b, fapaccad c where a.cod_pac = b.cod_pac and a.cod_pro = b.cod_pro and a.dat_receita = b.dat_receita and a.cod_pac = c.cod_pac and c.tipo_pac in ('U') and c.data_ent between '01/10/2014' and '31/10/2014'
union all
select '11-2014', count(*) from receita a, tb_it_med_receita b, fapaccad c where a.cod_pac = b.cod_pac and a.cod_pro = b.cod_pro and a.dat_receita = b.dat_receita and a.cod_pac = c.cod_pac and c.tipo_pac in ('U') and c.data_ent between '01/11/2014' and '30/11/2014'
union all
select '12-2014', count(*) from receita a, tb_it_med_receita b, fapaccad c where a.cod_pac = b.cod_pac and a.cod_pro = b.cod_pro and a.dat_receita = b.dat_receita and a.cod_pac = c.cod_pac and c.tipo_pac in ('U') and c.data_ent between '01/12/2014' and '31/12/2014'
union all
select '01-2015', count(*) from receita a, tb_it_med_receita b, fapaccad c where a.cod_pac = b.cod_pac and a.cod_pro = b.cod_pro and a.dat_receita = b.dat_receita and a.cod_pac = c.cod_pac and c.tipo_pac in ('U') and c.data_ent between '01/01/2015' and '31/01/2015'
union all
select '02-2015', count(*) from receita a, tb_it_med_receita b, fapaccad c where a.cod_pac = b.cod_pac and a.cod_pro = b.cod_pro and a.dat_receita = b.dat_receita and a.cod_pac = c.cod_pac and c.tipo_pac in ('U') and c.data_ent between '01/02/2015' and '28/02/2015'
union all
select '03-2015', count(*) from receita a, tb_it_med_receita b, fapaccad c where a.cod_pac = b.cod_pac and a.cod_pro = b.cod_pro and a.dat_receita = b.dat_receita and a.cod_pac = c.cod_pac and c.tipo_pac in ('U') and c.data_ent between '01/03/2015' and '31/03/2015'
union all
select '04-2015', count(*) from receita a, tb_it_med_receita b, fapaccad c where a.cod_pac = b.cod_pac and a.cod_pro = b.cod_pro and a.dat_receita = b.dat_receita and a.cod_pac = c.cod_pac and c.tipo_pac in ('U') and c.data_ent between '01/04/2015' and '30/04/2015'
union all
select '05-2015', count(*) from receita a, tb_it_med_receita b, fapaccad c where a.cod_pac = b.cod_pac and a.cod_pro = b.cod_pro and a.dat_receita = b.dat_receita and a.cod_pac = c.cod_pac and c.tipo_pac in ('U') and c.data_ent between '01/05/2015' and '31/05/2015';



--Quantidade de Atendimentos
select '05-2014', count(*) from fapaccad where tipo_pac in ('U') and data_ent between '01/05/2014' and '31/05/2014'
union all
select '06-2014', count(*) from fapaccad where tipo_pac in ('U') and data_ent between '01/06/2014' and '30/06/2014'
union all
select '07-2014', count(*) from fapaccad where tipo_pac in ('U') and data_ent between '01/07/2014' and '31/07/2014'
union all
select '08-2014', count(*) from fapaccad where tipo_pac in ('U') and data_ent between '01/08/2014' and '31/08/2014'
union all
select '09-2014', count(*) from fapaccad where tipo_pac in ('U') and data_ent between '01/09/2014' and '30/09/2014'
union all
select '10-2014', count(*) from fapaccad where tipo_pac in ('U') and data_ent between '01/10/2014' and '31/10/2014'
union all
select '11-2014', count(*) from fapaccad where tipo_pac in ('U') and data_ent between '01/11/2014' and '30/11/2014'
union all
select '12-2014', count(*) from fapaccad where tipo_pac in ('U') and data_ent between '01/12/2014' and '31/12/2014'
union all
select '01-2015', count(*) from fapaccad where tipo_pac in ('U') and data_ent between '01/01/2015' and '31/01/2015'
union all
select '02-2015', count(*) from fapaccad where tipo_pac in ('U') and data_ent between '01/02/2015' and '28/02/2015'
union all
select '03-2015', count(*) from fapaccad where tipo_pac in ('U') and data_ent between '01/03/2015' and '31/03/2015'
union all
select '04-2015', count(*) from fapaccad where tipo_pac in ('U') and data_ent between '01/04/2015' and '30/04/2015'
union all
select '05-2015', count(*) from fapaccad where tipo_pac in ('U') and data_ent between '01/05/2015' and '31/05/2015';




--select count(*), d.ds_descricao 
select 'insert into tel values('||round(count(*))||','''||d.pk_medeph||''','''||trim(d.ds_descricao)||''');'
from receita a, tb_it_med_receita b, fapaccad c , tb_med_epharma d
where a.cod_pac = b.cod_pac and a.cod_pro = b.cod_pro 
and a.dat_receita = b.dat_receita 
and a.cod_pac = c.cod_pac 
and b.fk_medeph = d.pk_medeph
and c.tipo_pac in ('U') 
and c.data_ent between '01/05/2014' and '31/05/2015'
group by d.pk_medeph,d.ds_descricao 
order by 1 desc;


--select count(*), d.descricao
select 'insert into tel1 values('||round(count(*))||','''||d.cod_prd_corp||''','''||trim(d.descricao)||''');'
from tm_prescricao_cad a, tm_prescricao_ite b, fapaccad c, faprdcad d, fatipcad e
where a.pk_prescc = b.fk_prescc
  and a.fk_cod_pac = c.cod_pac
  and b.fk_codigo = d.codigo
  and d.tipo_prd = e.tipo_prd
  and c.tipo_pac in ('U')
  and c.data_ent between '01/05/2014' and '31/05/2015'
  and e.tipo_prd_corp IN ('MED','MQT','MMP')
group by d.cod_prd_corp,d.descricao
order by 1 desc;


create temp table tel (quant integer, cod char(13), desc varchar(100)) with no log
create temp table tel1 (quant integer, cod char(15), desc varchar(100)) with no log