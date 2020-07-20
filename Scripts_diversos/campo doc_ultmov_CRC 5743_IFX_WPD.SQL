-------------------------------------
-- CR........: 5743
-- CRC.......: 10682
-- Banco.....: banco a ser aplicado: WPDHOSP - Informix
-- Versao....: 71.08.01_Esho_PRODUCAO_16.05
-- Analista..: Ricardo Tavares Silva
-- Data......: 21/06/2016
-- Cliente...: Amil
-- Finalidade: Preenche o campo doc_ultmov da tabela faprdcad quando não informado
-------------------------------------------------------------
-------------------------------------------------------------
-- Criar Procedure - Inicio
-------------------------------------------------------------
CREATE PROCEDURE check_estrutura()
   define sCodigo char(6);
   define sDocUltMov char(7);
   define sEstoqueUnidade char(1); 
   define sCodUnidade char(6);
   
   set triggers tu_fa_prd disabled;
   
   SELECT VALOR
     INTO sEstoqueUnidade
     FROM WPDTAB
    WHERE cod_parametro = 'estoque_por_unid_faturamento';

   -- Retornando os registros da tabela faprdcad
	FOREACH
       SELECT FAPRDCAD.CODIGO
	     INTO sCodigo
         FROM FAPRDCAD -- Pegando todos os itens

      -- Pegando o documento na tabela de compras
       select max(i.documento)
	     into sDocUltMov
         from esmovite i
        where i.tipo_documento = 'COM'
          and i.cod_prd = sCodigo;
			
     -- Atualizando o campo doc_ultmov da tabela faprdcad
	   update faprdcad set doc_ultmov = sDocUltMov where codigo = sCodigo;
			
      IF sEstoqueUnidade = 'S' THEN
	   
         select distinct a.cod_unidade
           into sCodUnidade
           from esmovite i , esmovcad c, fasetcad s, facelcad a
          where i.tipo_documento = 'COM'
            and i.documento = sDocUltMov
            and i.cod_prd = sCodigo
            and c.tipo_documento = i.tipo_documento
            and c.documento = i.documento
			and c.nota = i.nota
            and s.cod_set = c.set_est 
            and a.cod_cel = s.cod_cel;			
	   	   
	     update produto_unidade set doc_ultmov = sDocUltMov where codigo = sCodigo and cod_uni = sCodUnidade;
       END IF;		
			
	END FOREACH;	
	
   set triggers tu_fa_prd enabled;
   
END PROCEDURE;

EXECUTE PROCEDURE check_estrutura();
DROP PROCEDURE check_estrutura;

--------------------------------------------------------------------