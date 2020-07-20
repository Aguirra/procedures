select c.fantasia Convenio, d.nome_plano Plano, a.mat_pac Matricula, a.cod_prt Prontuario, a.nome_pac Paciente, a.data_hora_eleg, b.descricao_neleg Motivo_nao_elegibilidade
from fapacele a, outer(motivos_nao_elegib b), faconcad c, faplacad d
where a.cod_mot_neleg = b.cod_mot_neleg
  and a.cod_con = c.cod_con
  and a.cod_pla = d.cod_pla
  and a.cod_con = d.cod_con
  and a.cod_prt = '002611002' and date(a.data_hora_eleg) = '25/02/2015'