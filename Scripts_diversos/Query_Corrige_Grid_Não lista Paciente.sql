SELECT COUNT(FK_SELSEN),FK_SELSEN 
                           FROM TM_HISTPAC 
                           WHERE DH_HIST_FIM IS NULL 
                           AND FK_COD_UNI ='BUTANT' 
                           AND DH_HIST_INI >= (TO_DATE('07/11/2014 00:00:00','%d/%m/%Y %H:%M:%S')) 
                           GROUP BY FK_SELSEN HAVING COUNT(FK_SELSEN) > 1 
-------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM TM_HISTPAC
WHERE FK_SELSEN = 575918

select * from te_status_triag

DELETE FROM TM_HISTPAC
WHERE PK_HISTPAC = 6587124