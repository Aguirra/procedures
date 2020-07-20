EXECUTE PROCEDURE SP_IMP_PORTE_ANES();
EXECUTE PROCEDURE SP_IMP_PORTE_PROCD(); 
EXECUTE PROCEDURE SP_IMPDADPRD_CBHPM(); 

EXECUTE PROCEDURE SP_VAL_REG_GERPORT("DD/MM/YYYY");
--Para cada unidade de faturamento criar um nova validade para todos os tipos de produto da pré-classe EXA e HON.

EXECUTE PROCEDURE SP_PRECO_POR_PORTE ("XX","DD/MM/YYYY");

EXECUTE PROCEDURE SP_CONF_FILME_UCO ("XX","HON",VF,UCO,"DD/MM/YYYY");

EXECUTE PROCEDURE SP_CONF_FILME_UCO ("XX","EXA",VF,UCO,"DD/MM/YYYY");

EXECUTE PROCEDURE SP_CONF_FILME_UCO ("XX","RAX",VF,UCO,"DD/MM/YYYY");

EXECUTE PROCEDURE SP_CONF_FILME_UCO ("XX","LAB",VF,UCO,"DD/MM/YYYY");
-- DD/MM/YYYY - Nova validade de preço
-- "XX" – Tabela de preço para carga.
-- Substituri os valores zero na seguinte ordem:

-- VF =  Valor do filme 
-- UCO = Valor da unidade de custo operacional (UCO).
--Há a necessidade de executar a procedure para cada tipo produto da pré-classe EXA e HON que for trabalhar com a CBHPM.


EXECUTE PROCEDURE SP_ATU_PRECO_CBHPM ("XX","DD/MM/YYYY");

EXECUTE PROCEDURE SP_ATU_PRC_NOVAVAL ("DD/MM/YYYY");
 




 
inserir valor do UCO e do FILME = onde devem ser informados?
R- Substituir os zeros conforme necessário na procedure SP_CONF_FILME_UCO. 
Uma última questão seria quanto a utilização dos scripts em base com os scripts de tabela de preço por unidade aplicados, há algum impacto??
R- Em relação ao preço o script irá apenas incluir na tabela de preço FAPRECAD para os produtos que tem o código AMB encontrado no arquivo cbhpm_4_edicao_2.txt, onde todos os tipos de produtos são pré-classe EXA e HON e que tenham apelido de tabela na FAAPETAB
