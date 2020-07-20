set serveroutput on 
/

define gjwhere = where data_ent between '01/01/2019' and '31/01/2019' order by tipo_pac;
/

declare 
  cursor c1 is --(mes varchar2) is 
         select cod_pac, cod_prt, tipo_pac, nome_segu, data_ent 
         from fapaccad  &gjwhere;
         --where mes
         --order by tipo_pac;
         
  r1 c1%rowtype;
  i number:=0;
  pacA number:=0;
  pacE number:=0;
  pacI number:=0;
  pacU number:=0;
  
  --v_where varchar2(200):= gjwhere;
  
begin
  dbms_output.put_line('----------- Hospital Samaritano Paulista PS -----------');
  open c1;-- (mes => v_where);
       loop
         fetch c1 into r1;
         if c1%found then
            if r1.tipo_pac = 'A' then
              pacA:= pacA + 1;
            elsif r1.tipo_pac = 'E' then
              pacE:= pacE + 1;
            elsif r1.tipo_pac = 'I' then
              pacI:= pacI + 1;
            else 
              pacU:= pacU + 1;
            end if;
           i:= i + 1;
         else
           exit;
         end if;
       end loop;
   close c1;
   dbms_output.put_line('Tivemos ' || i || ' passagens no Mês 01/2019.');
   dbms_output.put_line('Atendimentos Ambulatoriais ---> ' || pacA);
   dbms_output.put_line('Atendimentos Externos      ---> ' || pacE);
   dbms_output.put_line('Atendimentos Internos      ---> ' || pacI);
   dbms_output.put_line('Atendimentos Urgencia      ---> ' || pacU);

   
end;
/