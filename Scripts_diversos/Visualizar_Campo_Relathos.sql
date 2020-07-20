update rel_dic_campo 
   set selecionavel = 'T', 
       pesquisavel  = 'T', 
       ordenavel    = 'T', 
       mandatorio   = 'T', 
       auto_busca   = 'T' 
 where nome_tabela  = 'tl_log_elegib'