select 'update fanotcad set nome_dest = ''' ||trim(REPLACE(nome_dest, '/', ''))||''' where nota_fiscal =''' ||nota_fiscal ||''';'
from fanotcad 
where nota_fiscal in (select co_chave1 from tb_integracao_mxm where st_nota = 'E')
and nome_dest matches '*[/]*'
UNION ALL
select 'update fanotcad set nome_dest = ''' ||trim(REPLACE(nome_dest, '.', ''))||''' where nota_fiscal =''' ||nota_fiscal ||''';'
from fanotcad 
where nota_fiscal in (select co_chave1 from tb_integracao_mxm where st_nota = 'E')
and nome_dest matches '*[.]*'
UNION ALL
--******end_dest********--
select 'update fanotcad set end_dest = ''' ||trim(REPLACE(end_dest, 'Ê', 'E'))||''' where nota_fiscal =''' ||nota_fiscal ||''';'
from fanotcad 
where nota_fiscal in (select co_chave1 from tb_integracao_mxm where st_nota = 'E')
and end_dest matches '*[Ê]*'
UNION ALL
select 'update fanotcad set end_dest = ''' ||trim(REPLACE(end_dest, 'Á', 'A'))||''' where nota_fiscal =''' ||nota_fiscal ||''';'
from fanotcad 
where nota_fiscal in (select co_chave1 from tb_integracao_mxm where st_nota = 'E')
and end_dest matches '*[Á]*'
UNION ALL
select 'update fanotcad set end_dest = ''' ||trim(REPLACE(end_dest, 'Ó', 'O'))||''' where nota_fiscal =''' ||nota_fiscal ||''';'
from fanotcad 
where nota_fiscal in (select co_chave1 from tb_integracao_mxm where st_nota = 'E')
and end_dest matches '*[Ó]*'
UNION ALL
select 'update fanotcad set nome_dest = ''' ||trim(REPLACE(end_dest, 'Í', 'I'))||''' where nota_fiscal =''' ||nota_fiscal ||''';'
from fanotcad 
where nota_fiscal in (select co_chave1 from tb_integracao_mxm where st_nota = 'E')
and end_dest matches '*[Í]*'
UNION ALL
select 'update fanotcad set end_dest = ''' ||trim(REPLACE(end_dest, '-', ' '))||''' where nota_fiscal =''' ||nota_fiscal ||''';'
from fanotcad 
where nota_fiscal in (select co_chave1 from tb_integracao_mxm where st_nota = 'E')
and end_dest matches '*[-]*'
UNION ALL
--******bai_dest********--
select 'update fanotcad set bai_dest = ''' ||trim(REPLACE(bai_dest, 'Ó', 'O'))||''' where nota_fiscal =''' ||nota_fiscal ||''';'
from fanotcad 
where nota_fiscal in (select co_chave1 from tb_integracao_mxm where st_nota = 'E')
and bai_dest matches '*[Ó]*'
UNION ALL
select 'update fanotcad set bai_dest = ''' ||trim(REPLACE(bai_dest, 'Í', 'I'))||''' where nota_fiscal =''' ||nota_fiscal ||''';'
from fanotcad 
where nota_fiscal in (select co_chave1 from tb_integracao_mxm where st_nota = 'E')
and bai_dest matches '*[Í]*'
UNION ALL
select 'update fanotcad set bai_dest = ''' ||trim(REPLACE(bai_dest, 'Ã', 'A'))||''' where nota_fiscal =''' ||nota_fiscal ||''';'
from fanotcad 
where nota_fiscal in (select co_chave1 from tb_integracao_mxm where st_nota = 'E')
and bai_dest matches '*[Ã]*'
UNION ALL
select 'update fanotcad set bai_dest = ''' ||trim(REPLACE(bai_dest, 'Á', 'A'))||''' where nota_fiscal =''' ||nota_fiscal ||''';'
from fanotcad 
where nota_fiscal in (select co_chave1 from tb_integracao_mxm where st_nota = 'E')
and bai_dest matches '*[Á]*'
UNION ALL
--******Cid_dest********--
select 'update fanotcad set cid_dest = ''' ||trim(REPLACE(cid_dest, 'Ã', 'A'))||''' where nota_fiscal =''' ||nota_fiscal ||''' and  serie = '''||trim(serie)||''';'
from fanotcad 
where nota_fiscal in (select co_chave1 from tb_integracao_mxm where st_nota = 'E')
and cid_dest matches '*[Ã]*'
UNION ALL
select 'update fanotcad set cid_dest = ''' ||trim(REPLACE(cid_dest, 'Í', 'I'))||''' where nota_fiscal =''' ||nota_fiscal ||''';'
from fanotcad 
where nota_fiscal in (select co_chave1 from tb_integracao_mxm where st_nota = 'E')
and cid_dest matches '*[Í]*'