++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Atendimentos--
select faprtcad.nu_doc_est, 
       faprtcad.no_doc_est_ps, 
	   faprtcad.profissao, 
	   fapaccad.cod_prt, 
	   decode(fapaccad.tipo_pac,'I','Interno','U','Urgencia','E','Externo','A','Ambulatorial') Tipo_Paciente,
	   faconcad.fantasia, 
	   faplacad.nome_plano, 
	   trim(amunicad.nome_uni) || ' - ' || trim(amunicad.bairro)
from faprtcad, fapaccad, faconcad, faplacad, amunicad 
 where faprtcad.cod_prt = fapaccad.cod_prt
   and fapaccad.cod_con = faconcad.cod_con
   and fapaccad.cod_con = faplacad.cod_con
   and fapaccad.cod_pla = faplacad.cod_pla
   and fapaccad.cod_uni = amunicad.cod_uni
   and faprtcad.sn_doc_est = 'S'
   and data_ent between '01/09/2016' and '30/09/2016' 
   --and fapaccad.cod_uni = '0003'
group by fapaccad.cod_prt, 
         fapaccad.tipo_pac, 
		 faconcad.fantasia, 
		 faplacad.nome_plano, 5
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		 

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		 
--Conta do Paciente--
select amunicad.nome_uni Unidade,
       f.cod_prt Prontuario,
       a.cod_pac Num_Atendimento,
       prt.nu_doc_est Num_Passaporte, 
       prt.no_doc_est_ps Passaporte_Pais, 
       prt.profissao,
       decode(f.tipo_pac,'I','Interno','U','Urgencia','E','Externo','A','Ambulatorial') Tipo_Paciente,
       g.fantasia,
       h.nome_plano,
       decode(c.destino,'H','Hospital','P','Particular','C','Conveio') Destio_Pagamento,
       sum(c.valor_tot) Vl_Consumo, 
       d.valor Taxa_ADM,
       e.tot_desc Vl_Desconto, 
       ((sum(c.valor_tot)) + (NVL(d.valor,0))) + NVL(e.tot_desc,0) Vl_Consumido,
       ((sum(c.valor_tot)) + (NVL(d.valor,0))) - NVL(e.tot_desc,0) Vl_Guia,
       case when diagnostico_pac.ind_status_diag = '1' then 'Definitivo' when diagnostico_pac.ind_status_diag = '2' then 'Provisorio' else 'Desprezado' end Status_Cid,
       case when diagnostico_pac.principal = 'S' then 'Sim' else 'Nao' end Cid_Principal,
       urcidcad.cod_cid, 
       urcidcad.diagnostico,
       date(f.data_alta_medica) - f.data_ent Permanencia,
       'Entrada: '||f.data_ent ||' '||f.hora_ent Entrada,
       'Saida: '  ||to_char(f.data_alta_medica, '%d/%m/%Y %H:%M') Alta_Medica, 
       'Saida: '  ||f.data_alta||' '||hora_alta Alta_Adm
from faprtcad prt, fapaccad f, famovcad a, famovprd b, famovdestino c, faconcad g, faplacad h, diagnostico_pac , urcidcad, amunicad, outer(fafattax d, fafatcad e)
where a.tipo_comanda = b.tipo_comanda
  and a.comanda = b.comanda
  and b.sequencial = c.sequencial
  and a.cod_pac = d.cod_pac
  and d.fatura = c.cod_fatura
  and a.cod_pac = e.cod_pac
  and c.cod_fatura = e.fatura
  and d.cod_pac = e.cod_pac
  and d.fatura = e.fatura
  and f.cod_pac = a.cod_pac
  and f.cod_pac = d.cod_pac
  and f.cod_pac = e.cod_pac
  and f.cod_con = g.cod_con
  and f.cod_con = h.cod_con
  and f.cod_pla = h.cod_pla
  and f.cod_pac = diagnostico_pac.cod_pac
  and diagnostico_pac.fk_ur_cid = urcidcad.pk_ur_cid
  and f.cod_uni = amunicad.cod_uni
  and prt.cod_prt = f.cod_prt
  and a.cod_pac in (select fapaccad.cod_pac
		      from faprtcad, fapaccad, faconcad, faplacad, amunicad 
		     where faprtcad.cod_prt = fapaccad.cod_prt
   		       and fapaccad.cod_con = faconcad.cod_con
		       and fapaccad.cod_con = faplacad.cod_con
		       and fapaccad.cod_pla = faplacad.cod_pla
		       and fapaccad.cod_uni = amunicad.cod_uni
		       and faprtcad.sn_doc_est = 'S'
		       and data_ent between '01/09/2016' and '30/09/2016'  
		       --and fapaccad.cod_uni = '0003'
		       )
group by a.cod_pac, f.tipo_pac, g.fantasia, h.nome_plano, c.destino, 12, e.tot_desc, f.data_ent, f.hora_ent, f.data_alta, f.hora_alta,
         urcidcad.cod_cid, urcidcad.diagnostico, diagnostico_pac.principal, diagnostico_pac.ind_status_diag, f.data_alta_medica, amunicad.nome_uni, f.cod_prt,
 	 prt.nu_doc_est, prt.no_doc_est_ps, prt.profissao
order by 2,3