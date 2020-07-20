update TRANSTISS set sit_transtiss = 5
        WHERE id_transtiss in ('58717', '58720') in (SELECT id_transtiss
                     FROM GUIATISS, LOTEGUIATISS
                     WHERE GUIATISS.id_loteguiatiss = LOTEGUIATISS.id_loteguiatiss 
                     AND   GUIATISS.id_transtiss = TRANSTISS.id_transtiss 
                     AND   LOTEGUIATISS.remessa = '016485'
                     AND TRANSTISS.sit_transtiss in (0,1,4)