select count(*), nu_senha 
from TB_SEL_SENHA_FILA 
where date(dh_retirada) = '07-10-2014' 
group by nu_senha 
having count(*) > 1 