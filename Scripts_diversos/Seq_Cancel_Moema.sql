select DISTINCT falogcad.sistema, famodcad.descricao, falogcad.funcao, falogcad.matricula,
       fausucad.nome, fausucad.apelido, falogcad.data, falogcad.complemento
from falogcad , fausucad , famodcad, faususis, fausguni
  where falogcad.sistema = 'EST'
    and falogcad.data >= '2012-05-11 09:00:00'
    and falogcad.data <= '2012-05-11 14:59:00'
   -- and falogcad.complemento  like '%9284980%'
   --and falogcad.complemento matches '*518755*'
   AND FAMODCAD.cod_mod = 'POCAN'
   and falogcad.matricula = fausucad.matricula
   and famodcad.cod_mod = falogcad.modulo
   and fausucad.matricula = faususis.matricula
   and faususis.sistema = fausguni.sistema
   and faususis.cod_grupo = fausguni.cod_grupo
   and fausguni.cod_uni = 'MOEMA'
order by falogcad.data