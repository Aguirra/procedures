-------------------------------------------------------------
-- Inclusão de Mapa - ORCL - ROLLBACK
-------------------------------------------------------------
--Assunto...: Inclsuão de novos setores de atendimento para o Mapa
--Banco.....: Oracle
--Analista..: Audrey Akemi / Ricardo Aguirra 
--Validado..:
--Data......: 06/2020
--Finalidade: Devido a criação de novos setores de atendimento na unidade houve a necessidade de realizar o atendimento por mapa
--			  assim, para a inclisão dos novos horarios se faz necessario a correção da Sequencia existente para depois a inclusão dos 
--			  novos horarios para atendimento.			  
-------------------------------------------------------------
-- Inclusão de Mapa - ORCL - ROLLBACK
-------------------------------------------------------------
ALTER SESSION SET current_schema = SISHOSP

DELETE FROM TB_CONFIG_SETMAPA WHERE FUK_CO_SETOR_CON = '0334';
DELETE FROM TB_CONFIG_SETMAPA WHERE FUK_CO_SETOR_CON = '0335';
DELETE FROM TB_CONFIG_SETMAPA WHERE FUK_CO_SETOR_CON = '0342';