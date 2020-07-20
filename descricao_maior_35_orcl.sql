-- ALTERA DESCRICAO DO PRODUTO PARA 34 CARACTERES 
-- *************INFORMAÇÕES
-- DEIXAR AS LINHAS (COMMIT | EXECUTE IMMEDIATE) COMENTADAS, SOMENTE RETIRAR SE FOR REALMENTE FAZER A ALTERAÇÃO.
-- POR PADRÃO ESTA TRAZENDO SOMENTE OS PRODUTOS DESBLOQEUADOS DA FAPRDCAD, CASO SEJA NECESSARIO ALTERAR O VALOR DE BLOQUEADO PARA 'S'
--
-- retorno exemplo
-- select codigo, length(descricao) qtd, descricao  from faprdcad where codigo in ('015653', '015744','715757', '715786')****

declare
   cursor r1 is 
          select length(descricao) qdt, codigo, descricao, 
          q'[update faprdcad set descricao = ']' || substr(descricao,0,34) || q'[' where codigo = ']' || codigo || q'[']' atualiza
          from faprdcad
          where bloqueado = 'N'
      and lower(tipo_prd) in (select tipo_prd from fatipcad where pre_class='MAT')
          group by codigo, descricao
          having length(descricao) > 35
          order by qdt, codigo;
   c1 r1%rowtype;
   
   v_produto varchar2(255):=0;
   v_ult_produto varchar2(255);
   v_update varchar2(255);
   
   linhas number:=0;
   
begin 
  open r1;
  loop
      fetch r1 into c1;
      if r1%found then 
        --v_update:= c1.atualiza;
        --v_ult_produto:=v_produto;
        --v_produto:= c1.codigo;
        
        --dbms_output.enable(null);
        --dbms_output.put_line(v_update);
        
        --execute immediate v_update;
        --commit;
        
        linhas:= linhas + 1;
  
      else
        exit;
      end if;
   end loop;
   dbms_output.put_line('Linhas Atualizadas: ' || linhas);
   close r1; 

   exception
     when too_many_rows then
        dbms_output.put_line('Ultimo produto atualizado: ' || v_ult_produto);
        dbms_output.put_line('Encontrado mais de dois registros para execução - PRD: ' || v_produto);
        dbms_output.put_line('ERRO ORA_: ' || sqlerrm); 
     when others then
        dbms_output.put_line('Ultimo produto atualizado - PRD: ' || v_ult_produto);
       dbms_output.put_line('Produto: ' || v_produto);
       dbms_output.put_line('ERRO ORA_: ' || sqlerrm); 

     linhas:=0;
   v_produto:=0;
end;
/


    
