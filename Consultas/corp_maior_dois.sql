--Consulta Corporativo maior que dois na mesma Base

declare
begin 
  for i in (select 
            trim(cod_prd_corp)codigo, 
            count(cod_prd_corp)qtd
            from faprdcad 
            where length(cod_prd_corp) = 10
            group by cod_prd_corp
            having count(cod_prd_corp) > 2)
            loop
              FOR x IN (select NOME_UNI from amunicad)
                loop
                     dbms_output.put_line('Unidade: ' || x.nome_uni);
                end loop;
                dbms_output.put_line('----------------------------------------');
                dbms_output.put_line('Coorp: ' || i.codigo || ' Qtd: ' || i.qtd);
            end loop;
end;   


