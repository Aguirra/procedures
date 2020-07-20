SELECT * 
    FROM Prescricao_Pac 
        WHERE Sn_Uso_Particular IS NULL 
            AND Cod_Set = '3008' 
                AND Hora_Ini >= '2012-01-22 00:00'

UPDATE Prescricao_Pac
    SET Sn_Uso_Particular = 'N'
        WHERE Sn_Uso_Particular IS NULL 
            AND Cod_Set = '3015' 
                AND Hora_Ini >= '2012-01-22 00:00'