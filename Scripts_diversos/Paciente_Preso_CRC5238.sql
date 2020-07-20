Segue os passos para ajustar os pacientes.

1º) Executar um UPDATE para retirar as altas do paciente
2º) Finalizar o atendimento via sistema
3º) Executar um UPDATE para mantar as altas com as datas corretas

******************************************************************************************
OBSERVAÇÃO: O resultado da query abaixo gera os UPDATEs (Utilizar o Relathos)
			Gera o UPDATE para "Limpar a Alta" e o UPDATE para "Preservar a Alta Correta"
			
select 'UPDATE fapaccad SET data_alta = null, hora_alta = null, data_alta_medica = null where cod_pac = '''|| cod_pac||''';' as Limpar_Alta,
       'UPDATE fapaccad SET data_alta = '''|| data_alta || ''', hora_alta = '''|| hora_alta || ''', data_alta_medica = to_date('''||  to_char(data_alta_medica,'%d/%m/%Y %H:%M:%S') ||''', ''%d/%m/%Y %H:%M:%S'') where cod_pac = '''|| cod_pac||''';' as Alta_Correta
from fapaccad 
where cod_pac in ('4420429')

******************************************************************************************