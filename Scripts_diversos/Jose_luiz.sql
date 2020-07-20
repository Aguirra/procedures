select 
        famovdestino.destino,           fapaccad.cod_pac,
        faprtcad.nome_pac,              faconcad.fantasia,
        faplacad.nome_plano,            fapaccad.num_guia,
        faprdcad.descricao,             famovprd.quant, 
        famovdestino.valor,             famovdestino.valor_tot, 
        fafatcad.valor_tot Total_Fatura
from 
     faprtcad, 
     fapaccad, 
     famovcad, 
     famovprd, 
     famovdestino, 
     faprdcad, 
     fafatcad,
     faconcad,
     faplacad
where 
      faprtcad.cod_prt        =     fapaccad.cod_prt
  and fapaccad.cod_pac        =     famovcad.cod_pac
  and famovcad.tipo_comanda   =     famovprd.tipo_comanda
  and famovcad.comanda        =     famovprd.comanda
  and famovprd.sequencial     =     famovdestino.sequencial
  and famovprd.codigo         =     faprdcad.codigo
  and fapaccad.cod_pac        =     fafatcad.cod_pac
  and fapaccad.cod_con        =     faconcad.cod_con
  and fapaccad.cod_pla        =     faplacad.cod_pla
  and faplacad.cod_con        =     faconcad.cod_con
  --and famovdestino.cod_fatura =     fafatcad.fatura
  and fapaccad.cod_pac = 'VQ75586'
order by famovdestino.destino



select count(*), cod_pac from famovcad where cod_pac in(
select P.cod_pac from fapaccad P 
where P.cod_uni = '0029'
and P.data_ent >= '2012-11-01' and tipo_Pac ='U')
group by cod_pac
having count(*) > 2
order by 1 desc