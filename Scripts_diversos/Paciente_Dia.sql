((Pac_dia/diascorridosrelatorio)*100)/leitos-extras


select distinct tab_a.cod_pac from
table(multiset(
SELECT p.cod_pac,
       p.cod_con,
       c.fantasia,
       c.cod_gru,
       g.descricao AS desc_gru,
       p.cod_pla,
       l.nome_plano,
       p.cod_ala,
       a.descricao AS desc_ala,
       p.nome_segu,
  (select cod_set 
from
table(multiset(SELECT first 1 FALETCAD.COD_TIPO,FALETCAD.DESCRICAO AS DESC_TIPO,FASETCAD.COD_SET, 
FASETCAD.DESCRICAO AS DESC_SET,  FACELCAD.COD_CEL,  FACELCAD.DESCRICAO AS DESC_CEL,  FALEHCAD.DATA,FALEHCAD.HORA 
FROM  FALETCAD,FAAPTCAD,FASETCAD,FALEICAD,FALEHCAD, FACELCAD 
WHERE FALEHCAD.DATA <= to_date('01/10/2015','%d/%m/%Y')
AND   FALEHCAD.LEITO = FALEICAD.LEITO 
AND   FALEICAD.COD_APT = FAAPTCAD.COD_APT 
AND   FAAPTCAD.TIPO = FALETCAD.COD_TIPO 
AND   FAAPTCAD.COD_SET = FASETCAD.COD_SET 
AND   FASETCAD.COD_CEL = FACELCAD.COD_CEL
AND FALEHCAD.COD_PAC = p.cod_pac  
ORDER BY FALEHCAD.DATA DESC, FALEHCAD.HORA DESC))) cod_set
FROM   faconcad C,
       faplacad L,
       faalacad A,
       fapaccad P,
       outer FACOGCAD g,
       falehcad h,
       faleicad j
WHERE  c.cod_gru = g.cod_cog
AND    p.data_ent <= to_date('01/10/2015','%d/%m/%Y')
AND    p.tipo_pac = 'I'
AND    ( p.data_alta IS NULL  OR
         p.data_alta = ' '    OR     
         p.data_alta > to_date('01/10/2015','%d/%m/%Y') OR
         (p.data_ent = to_date('01/10/2015','%d/%m/%Y') AND    
          p.data_alta = p.data_ent))
AND    p.cod_pac = h.cod_pac
AND    j.leito = h.leito
AND    h.data <= to_date('01/10/2015','%d/%m/%Y')
AND    (h.data|| h.hora = (SELECT max(y.data|| y.hora)
                             FROM   falehcad y
                            WHERE  y.cod_pac = p.cod_pac
                              AND    y.data <= to_date('01/10/2015','%d/%m/%Y')))
AND    p.cod_uni  IN ( '0025')
AND    p.tipo_pac IN ('I','X','X','X')
AND    (( j.leito_obs = 'N') OR     
          EXISTS ( SELECT 1
                     FROM   fapaccad paccad
                     WHERE  j.cod_pac = paccad.cod_pac
                     AND    paccad.tipo_pac = 'I'
                     AND    j.leito_obs = 'S'
                     AND    (trim(j.cod_pac) <> '' OR
                             j.cod_pac IS NOT NULL)))
AND    p.cod_con = c.cod_con
AND    p.cod_con = l.cod_con
AND    p.cod_pla = l.cod_pla
AND    p.cod_ala = a.cod_ala)) TAB_A
where tab_a.cod_Set = '0380'




************************************************************************************

SELECT distinct FALEHCAD.COD_PAC
/*SELECT FALEHCAD.COD_PAC, FALETCAD.COD_TIPO,FALETCAD.DESCRICAO AS DESC_TIPO,FASETCAD.COD_SET,
       FASETCAD.DESCRICAO AS DESC_SET,
       FACELCAD.COD_CEL, 
       FACELCAD.DESCRICAO AS DESC_CEL,
       FALEHCAD.DATA,FALEHCAD.HORA*/ 
FROM  FALETCAD,FAAPTCAD,FASETCAD,FALEICAD,FALEHCAD, FACELCAD

WHERE FALEHCAD.COD_PAC in (SELECT p.cod_pac/*,
       p.cod_con,
       c.fantasia,
       c.cod_gru,
       g.descricao AS desc_gru,
       p.cod_pla,
       l.nome_plano,
       p.cod_ala,
       a.descricao AS desc_ala,
       p.nome_segu*/
FROM   faconcad C,
       faplacad L,
       faalacad A,
       fapaccad P,
       outer FACOGCAD g,
       falehcad h,
       faleicad j
WHERE  c.cod_gru = g.cod_cog
AND    p.data_ent <= to_date('04/10/2015','%d/%m/%Y')
AND    p.tipo_pac = 'I'
AND    ( p.data_alta IS NULL  OR
         p.data_alta = ' '    OR     
         p.data_alta > to_date('04/10/2015','%d/%m/%Y') OR
         (p.data_ent = to_date('04/10/2015','%d/%m/%Y') AND    
          p.data_alta = p.data_ent))
AND    p.cod_pac = h.cod_pac
AND    j.leito = h.leito
AND    h.data <= to_date('04/10/2015','%d/%m/%Y')
AND    (h.data|| h.hora = (SELECT max(y.data|| y.hora)
                             FROM   falehcad y
                            WHERE  y.cod_pac = p.cod_pac
                              AND    y.data <= to_date('04/10/2015','%d/%m/%Y')))
AND    p.cod_uni  IN ( '0001')
AND    p.tipo_pac IN ('I','X','X','X')
AND    (( j.leito_obs = 'N') OR     
          EXISTS ( SELECT 1
                     FROM   fapaccad paccad
                     WHERE  j.cod_pac = paccad.cod_pac
                     AND    paccad.tipo_pac = 'I'
                     AND    j.leito_obs = 'S'
                     AND    (trim(j.cod_pac) <> '' OR
                             j.cod_pac IS NOT NULL)))
AND    p.cod_con = c.cod_con
AND    p.cod_con = l.cod_con
AND    p.cod_pla = l.cod_pla
AND    p.cod_ala = a.cod_ala)




AND   FALEHCAD.DATA <= to_date('04/10/2015','%d/%m/%Y')
AND   FALEHCAD.LEITO = FALEICAD.LEITO 
AND   FALEICAD.COD_APT = FAAPTCAD.COD_APT 
AND   FAAPTCAD.TIPO = FALETCAD.COD_TIPO 
AND   FAAPTCAD.COD_SET = FASETCAD.COD_SET
AND   FAAPTCAD.COD_SET = '0009'
AND   FASETCAD.COD_CEL = FACELCAD.COD_CEL
--ORDER BY FALEHCAD.DATA DESC, FALEHCAD.HORA DESC