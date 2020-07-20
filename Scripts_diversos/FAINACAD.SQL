CREATE TEMP TABLE FAINA_TESTE (COD_INA CHAR(8), INST_REGISTRO VARCHAR (2));

INSERT INTO FAINA_TESTE
select distinct fainacad.cod_ina, 'AE'
from fainacad, tb_prcd_instreg where tb_prcd_instreg.co_proced = fainacad.cod_ina_unificado
and tb_prcd_instreg.nu_instreg in ('01','02','06','07') and fainacad.tp_procedimento = 'A'

UPDATE FAINACAD SET inst_registro = 'AE' WHERE FAINACAD.cod_ina in (select cod_ina from faina_teste where 1=1);

DROP TABLE FAINA_TESTE;

__________________________________________________


CREATE TEMP TABLE FAINA_TESTE (COD_INA CHAR(8), INST_REGISTRO VARCHAR (2));

INSERT INTO FAINA_TESTE
select distinct fainacad.cod_ina, 'AP'
from fainacad, tb_prcd_instreg where tb_prcd_instreg.co_proced = fainacad.cod_ina_unificado
and tb_prcd_instreg.nu_instreg in ('03') and fainacad.tp_procedimento = 'H'

UPDATE FAINACAD SET inst_registro = 'AP' WHERE FAINACAD.cod_ina in (select cod_ina from faina_teste where 1=1);

DROP TABLE FAINA_TESTE;

___________________________________________________

CREATE TEMP TABLE FAINA_TESTE (COD_INA CHAR(8), INST_REGISTRO VARCHAR (2));

INSERT INTO FAINA_TESTE
select distinct fainacad.cod_ina, 'AE'
from fainacad, tb_prcd_instreg where tb_prcd_instreg.co_proced = fainacad.cod_ina_unificado
and tb_prcd_instreg.nu_instreg in ('04') and fainacad.tp_procedimento = 'H'

UPDATE FAINACAD SET inst_registro = 'AE' WHERE FAINACAD.cod_ina in (select cod_ina from faina_teste where 1=1);

DROP TABLE FAINA_TESTE;

_____________________________________________________

CREATE TEMP TABLE FAINA_TESTE (COD_INA CHAR(8), INST_REGISTRO VARCHAR (2));

INSERT INTO FAINA_TESTE
select distinct fainacad.cod_ina, 'AS'
from fainacad, tb_prcd_instreg where tb_prcd_instreg.co_proced = fainacad.cod_ina_unificado
and tb_prcd_instreg.nu_instreg in ('05') and fainacad.tp_procedimento = 'H'

UPDATE FAINACAD SET inst_registro = 'AS' WHERE FAINACAD.cod_ina in (select cod_ina from faina_teste where 1=1);

DROP TABLE FAINA_TESTE;