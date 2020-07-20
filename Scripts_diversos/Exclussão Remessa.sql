update transtiss set transtiss.sit_transtiss = 5 
where (id_transtiss in (select x0.id_transtiss from guiatiss x0 ,loteguiatiss x1 
where ((x0.id_loteguiatiss = x1.id_loteguiatiss ) AND (x1.remessa = '055890') ) ) )

update loteguiatiss set loteguiatiss.remessa = NULL where (remessa = '055890')