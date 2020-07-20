/*

Produtos bloqueados somente consulta CONCAT

*/


select 
	'HIS - ' || codigo || ' | ' ||  
	'SAP - ' || COD_PRD_CORP || 
	'  -- >' || ' Produto: ' ||  
	DECODE(BLOQUEADO, 'N', 'desbloqueado no HIS', 'S', 'Bloqueado no HIS')
PRODUTO 
from faprdcad where cod_prd_corp in
('3000005724','3000049331','3000138149')