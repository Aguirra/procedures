EXECUTE PROCEDURE SP_IMP_PORTE_ANES();
EXECUTE PROCEDURE SP_IMP_PORTE_PROCD(); 
EXECUTE PROCEDURE SP_IMPDADPRD_CBHPM(); 

EXECUTE PROCEDURE SP_VAL_REG_GERPORT("DD/MM/YYYY");
--Para cada unidade de faturamento criar um nova validade para todos os tipos de produto da pr�-classe EXA e HON.

EXECUTE PROCEDURE SP_PRECO_POR_PORTE ("XX","DD/MM/YYYY");

EXECUTE PROCEDURE SP_CONF_FILME_UCO ("XX","HON",VF,UCO,"DD/MM/YYYY");

EXECUTE PROCEDURE SP_CONF_FILME_UCO ("XX","EXA",VF,UCO,"DD/MM/YYYY");

EXECUTE PROCEDURE SP_CONF_FILME_UCO ("XX","RAX",VF,UCO,"DD/MM/YYYY");

EXECUTE PROCEDURE SP_CONF_FILME_UCO ("XX","LAB",VF,UCO,"DD/MM/YYYY");
-- DD/MM/YYYY - Nova validade de pre�o
-- "XX" � Tabela de pre�o para carga.
-- Substituri os valores zero na seguinte ordem:

-- VF =  Valor do filme 
-- UCO = Valor da unidade de custo operacional (UCO).
--H� a necessidade de executar a procedure para cada tipo produto da pr�-classe EXA e HON que for trabalhar com a CBHPM.


EXECUTE PROCEDURE SP_ATU_PRECO_CBHPM ("XX","DD/MM/YYYY");

EXECUTE PROCEDURE SP_ATU_PRC_NOVAVAL ("DD/MM/YYYY");
 




 
inserir valor do UCO e do FILME = onde devem ser informados?
R- Substituir os zeros conforme necess�rio na procedure SP_CONF_FILME_UCO. 
Uma �ltima quest�o seria quanto a utiliza��o dos scripts em base com os scripts de tabela de pre�o por unidade aplicados, h� algum impacto??
R- Em rela��o ao pre�o o script ir� apenas incluir na tabela de pre�o FAPRECAD para os produtos que tem o c�digo AMB encontrado no arquivo cbhpm_4_edicao_2.txt, onde todos os tipos de produtos s�o pr�-classe EXA e HON e que tenham apelido de tabela na FAAPETAB
