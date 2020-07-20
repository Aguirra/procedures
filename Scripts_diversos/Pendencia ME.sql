--UPDATE ESMOVCAD--
update esmovcad 
  set pend_sit_mot = 'N', observacao = 'PENDENCIA RETIRADA A PEDIDO DA DIRETORIA'
  where data_mov <= '2012-03-31'
  and tipo_documento = 'PED'
  and pend_sit_mot = 'S' 


--UPDATE ESMOVITE--
update esmovite 
set esmovite.pendente = 'N', obs = 'PENDENCIA RETIRADA A PEDIDO DA DIRETORIA' 
where exists 
 (select esmovcad.documento from esmovcad
  where esmovcad.tipo_documento = esmovite.tipo_documento
  and esmovcad.documento = esmovite.documento
  and esmovcad.nota = esmovite.nota
  and esmovcad.data_mov <= '2012-03-31'
  and esmovite.pendente = 'S'
  and esmovite.tipo_documento = 'PED')