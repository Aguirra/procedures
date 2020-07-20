set echo off        
set feedback off
set heading off  
set serveroutput on 

spool output.csv

declare 
    cursor c1 is 
           select 
                  x2.bloqueado, x2.codigo, x2.cod_prd_corp, 
                  x1.nu_reg_anvisa, x1.dh_validade_anvisa, x1.sq_profab
           from tb_prod_fabricante x1, faprdcad x2
           where x2.cod_prd_corp = x1.uk_cod_prd_corp
           and to_char(dh_validade_anvisa, 'dd/mm/yyyy') like '%9999'
           --and x2.bloqueado = 'N'
           and x1.sn_inativo = 'N';
		   
  r1 c1%rowtype;
  v_prd_corp varchar2(255);			--Produto
  v_ult_prd_corp varchar2(255):=0;	--Produto
  v_qtd number;
  
  v_um_item number:= 0;			--QTD Itens
  v_dois_itens number:= 0;		--QTD Itens
  v_dois_data_itens number:= 0;	--QTD Itens
  
  v_pupdate varchar2(255);    --Variavel para campo Anvisa = NULL
  v_supdate varchar2(255);    --Variavel para campo sn_inativo = S
  
  a number:= 0;
begin
  open c1;
  loop
    fetch c1 into r1;
    if c1%found then
      --dbms_output.put_line('Produto: ' || r1.cod_prd_corp);
      select count(uk_cod_prd_corp)
      into v_qtd
      from tb_prod_fabricante --where lower(sn_inativo) = 'n'
      where uk_cod_prd_corp = r1.cod_prd_corp;
      
    v_ult_prd_corp:= v_prd_corp;
    v_prd_corp:= r1.cod_prd_corp;
      if v_qtd = 1 then
        
         --Aplicar NULL para o campo Anvisa para utilzação do produto
         --dbms_output.put_line('Produto: ' || r1.cod_prd_corp);
         v_pupdate:= 'update tb_prod_fabricante set dh_validade_anvisa = null where uk_cod_prd_corp ='''|| r1.cod_prd_corp ||''' and sq_profab = ''' ||r1.sq_profab||'''';
         --dbms_output.enable(null);
         --dbms_output.put_line(v_pupdate);--Validando UPdate
         execute immediate v_pupdate;
         commit;
        
         a:= a + 1;
         v_um_item:= v_um_item + 1;
        continue;
        
        else
          --Existe mais de um item
          select count(*)
          into v_qtd
          from tb_prod_fabricante where lower(sn_inativo) = 'n'
          and uk_cod_prd_corp = v_prd_corp and dh_validade_anvisa is not null;
          
            if v_qtd = 1 then
                      --condição somente para alterar o item para S pois ele já existe, mantendo o que já esta correto.
                      --dbms_output.put_line('Produto duplicado: ' || r1.cod_prd_corp || 
                      --                                ' Repet: ' || v_qtd ||
                      --                                ' PK_PROFAB: ' || r1.sq_profab);
            
                      v_supdate:= 'update tb_prod_fabricante set sn_inativo = ''S'' where uk_cod_prd_corp ='''|| r1.cod_prd_corp ||''' and sq_profab = ''' ||r1.sq_profab||'''';
                      --dbms_output.put_line(v_supdate);--Validando UPdate
                      execute immediate v_supdate;
                      commit;
            
                      a:= a + 1;
                      v_dois_itens := v_dois_itens + 1;
               continue;
            else
				--não realiza alteração, somente quantifica itens que deverão ser analisados pela area
				--dbms_output.enable(null);
				--dbms_output.put_line(r1.cod_prd_corp);
       
				a:= a + 1;
				v_dois_data_itens:= v_dois_data_itens + 1;
              continue;
            end if;
       end if;
       a:= a + 1;
     else
       exit;
    end if; 
    end loop;
		dbms_output.put_line('*************** Registros *********************');
		dbms_output.put_line('Total Registros: ' || a);
		dbms_output.put_line('Total Alterados: ' || v_um_item);
		dbms_output.put_line('Total ALterados para Inativos: ' || v_dois_itens);
		dbms_output.put_line('Total P/ Analise: ' || v_dois_data_itens);
    close c1;
    
    exception
      when too_many_rows then
		dbms_output.put_line('Ultimo produto atualizado: ' || v_ult_prd_corp);
        dbms_output.put_line('Encontrado mais de dois registros para execução - PRD: ' || v_prd_corp);
        dbms_output.put_line('');
		dbms_output.put_line('ERRO ORA_: ' || sqlerrm); 
      when others then
        dbms_output.put_line('Ultimo produto atualizado: ' || v_ult_prd_corp);
        dbms_output.put_line('Produto que apresentou erro: ' || v_prd_corp);
        dbms_output.put_line('');
        dbms_output.put_line('ERRO ORA_: ' || sqlerrm); 
         
      a:= 0;
      v_ult_prd_corp:=0;
      v_um_item:= 0;
      v_dois_itens:= 0;
      v_dois_data_itens:= 0;
    
end;
/

spool off