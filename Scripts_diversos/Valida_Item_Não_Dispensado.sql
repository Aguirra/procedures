select a.descricao, sn_disp_horario, b.cod_prd, status_disp
  from escarcad a, escarprd b, item_distrib c
 where a.cod_car = b.cod_car
   and b.cod_prd = c.codigo
   and status_disp = 'N'
   and data_hora_ini >= to_date('XX/XX/XX 00:00:01','%d/%m/%Y %H:%M:%S') --Hora da Prescrição
   and c.codigo = 'XXXXXX' --Código do Produto
   and c.cod_pac = 'XXXXX' --Código do Paciente