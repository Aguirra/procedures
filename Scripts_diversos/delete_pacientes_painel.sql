select 'delete from tb_sel_senha_fila where pk_selsen = '||pk_selsen|| ';'
from tb_sel_senha_fila, te_status_triag
where tb_sel_senha_fila.fk_striag = te_status_triag.pk_striag
and te_status_triag.pk_striag = '13'
and date(dh_retirada) between '2013-11-30' and '2015-12-21'
and pk_selsen not in( select fk_selsen from tm_histpac)