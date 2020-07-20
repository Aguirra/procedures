/*

ENCAMINHAMENTO POR SAÍDA DE PROTOCOLO

	Resultado da Saída do Protocolo com Encaminhamento
		documento_emitido

	Criação do Documento 
		modelo_documento

	Identificação do documento como encaminhamento
		tb_clas_modelo_doc

SELECT * 
  FROM documento_emitido DE, modelo_documento MD, tb_clas_modelo_doc TCMD
 WHERE DE.COD_MDL_DOC = MD.COD_MDL_DOC
   AND MD.FK_CLMODO = TCMD.PK_CLMODO
   AND DE.cod_prt = '002648440' 
   AND date(DE.dat_emissao_doc) = today -1;
   
*/
-------------------------------------------------------------------------------
/*

SOLICITAÇÃO DE ENCAMINHAMENTO
	TB_ENCAMINHAMENTO

*/