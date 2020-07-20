CREATE PROCEDURE check_estrutura()
-----------
-- Nome.......: sp_rem_itepresc_dp
-- Autor .....: Diego Nascimento
-- Finalidade.: Remover o item duplicado da tabela 
tm_prescricao_ite
-- Historico :
-- 11/06/2012 - Diego Nascimento - CR 4526 -  Criacao da procedure
-------------------------------------------------------------------

   DEFINE iPk_presci_dp         INTEGER;
   DEFINE cFk_codigo            VARCHAR(6);   
   DEFINE ifk_prescc            INTEGER;
   DEFINE dDh_cadastro          DATE TIME year to second;   
 
       SELECT  fk_codigo,fk_prescc, dh_cadastro,count(dh_cadastro) 
  as contador  
        FROM tm_prescricao_ite  
  where fk_codigo is not null
         group by 1,2,3 
  having count(dh_cadastro) > 1  
         into temp tmp_rem_itepresc_dp with no log;
          
  foreach SELECT  fk_codigo, fk_prescc, dh_cadastro
     into  cFk_codigo, ifk_prescc, dDh_cadastro
   FROM tmp_rem_itepresc_dp   
      begin           
   
     -- Pega um item duplicado
     select first 1 ite2.pk_presci
      into iPk_presci_dp  
     from tm_prescricao_ite ite2
     where (ite2.fk_codigo = cFk_codigo) 
      and (ite2.fk_prescc = ifk_prescc) 
      and (ite2.dh_cadastro = dDh_cadastro);
     
     --Deletar o registro
     delete from tm_prescricao_ite where pk_presci = iPk_presci_dp;
    end;    
  END foreach;   
  DROP TABLE tmp_rem_itepresc_dp;    
END PROCEDURE;     
EXECUTE PROCEDURE check_estrutura();
DROP PROCEDURE check_estrutura;
