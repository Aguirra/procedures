--Conta os usuarios que já alteram a senha a partir da data 06/02/2015--
SELECT 'Total Usuarios = '||(SELECT COUNT(*)FROM fausucad WHERE ind_usuario_ativo = 'S') || ' {}  Senhas Alteradas = '|| ROUND(COUNT(DISTINCT fk_matricula)) ||'  {}  '|| (SELECT ROUND((COUNT(DISTINCT fk_matricula) / (SELECT COUNT(*)FROM fausucad WHERE ind_usuario_ativo = 'S')) * 100) FROM tb_hist_senha WHERE DATE(dh_cadastro) >= '06/02/2015')||'%' AS RESULT  
FROM tb_hist_senha WHERE DATE(dh_cadastro) >= '06/02/2015'


--Forca a troca da Senha dos usuarios que ainda não trocaram a senha a partir da data de 06/02/2015--
UPDATE fausucad SET dh_validade = '2015-03-10 23:59:59' 
WHERE matricula NOT IN (SELECT fk_matricula FROM tb_hist_senha WHERE DATE(dh_cadastro) >= '06/02/2015')


--Usuario que estão usando Alt+F4 para não trocar a Senha--
select count(distinct faususis.matricula) as result
 from fausucad, faususis
where fausucad.matricula = faususis.matricula
  and fausucad.dh_validade = '2015-03-10 23:59:59'   
  and dt_hora_ult_acesso > '2015-03-10 23:59:59';
  

--Conta os usuarios que já alteram a senha a partir da data 06/02/2015 e que acessaram o sistema em 2015--  
select 'Senhas Alteradas = '|| round(COUNT(DISTINCT fk_matricula))||' {}  Total Usuarios  = '|| (select count(distinct a.matricula)as conta from fausucad a, faususis b where a.matricula = b.matricula and a.ind_usuario_ativo = 'S' and dt_hora_ult_acesso > '2014-12-31 23:59:59') ||'  {}  '|| round(((select COUNT(DISTINCT fk_matricula)as conta1 FROM tb_hist_senha WHERE DATE(dh_cadastro) >= '06/02/2015') / (select count(distinct a.matricula)as conta from fausucad a, faususis b where a.matricula = b.matricula and a.ind_usuario_ativo = 'S' and dt_hora_ult_acesso > '2014-12-31 23:59:59')*100))||'%' AS RESULT
FROM tb_hist_senha WHERE DATE(dh_cadastro) >= '06/02/2015'