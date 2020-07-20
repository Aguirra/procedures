select TABNAME 
  from SYSTABLES 
 where TABID IN (select TABID 
				   from sysconstraints 
                  where CONSTRID IN (select CONSTRID 
									   from sysreferences 
									  where PTABID IN (select TABID 
														 from sysconstraints 
														where CONSTRNAME= 'pk_es_moc' )));