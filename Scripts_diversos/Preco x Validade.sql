SELECT * FROM FATIPPRE WHERE COD_UNI = '0012' AND TIPO_PRD = 'MED' AND VALIDADE NOT IN 
(SELECT VALIDADE FROM FAPRECAD, FAPRDCAD WHERE COD_UNI = '0012' AND FAPRECAD.codigo = FAPRDCAD.CODIGO AND FAPRDCAD.TIPO_PRD = 'MED')