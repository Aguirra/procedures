select 
      ('SELECT COUNT(FUK_CONFMP) INTO vCOUNT FROM TB_CONFIG_SETMAPA WHERE FUK_CONFMP = '|| ''''|| FUK_CONFMP || ''''|| ' AND FUK_CO_SETOR_CON = ''0334'';' ) selects,
      ('IF vCOUNT = 0 THEN ') condicao_IF,
      /*
       x2.fuk_confmp,
       x2.fuk_co_setor, ('0334') novo,
       --x2.fuk_co_setor_con,
       x2.sn_prd_natuestoq,
       x2.sn_exec_extra,*/
       ('INSERT INTO TB_CONFIG_SETMAPA (FUK_CONFMP, FUK_CO_SETOR, FUK_CO_SETOR_CON, SN_PRD_NATUESTOQ, SN_EXEC_EXTRA) VALUES 
       ('|| x2.fuk_confmp || ','''|| FUK_CO_SETOR || ''',' || q'['0334']' || ',''' || SN_PRD_NATUESTOQ || ''',''' || SN_EXEC_EXTRA || ''');') inserts,
       ('END IF;') CONDICAO_ELSE
from TB_CONFIG_MAPA x1, TB_CONFIG_SETMAPA x2
     where x1.pk_confmp = x2.fuk_confmp
     and x2.fuk_co_setor = '0067' 
     and x2.fuk_co_setor_con = '0079'
union all
select 
       ('SELECT COUNT(FUK_CONFMP) INTO vCOUNT FROM TB_CONFIG_SETMAPA WHERE FUK_CONFMP = '|| ''''|| FUK_CONFMP || ''''|| ' AND FUK_CO_SETOR_CON = ''0335'';' ) selects,
       ('IF vCOUNT = 0 THEN ') condicao_IF,
       ('INSERT INTO TB_CONFIG_SETMAPA (FUK_CONFMP, FUK_CO_SETOR, FUK_CO_SETOR_CON, SN_PRD_NATUESTOQ, SN_EXEC_EXTRA) VALUES 
       ('|| x2.fuk_confmp || ','''|| FUK_CO_SETOR || ''',' || q'['0335']' || ',''' || SN_PRD_NATUESTOQ || ''',''' || SN_EXEC_EXTRA || ''');') inserts,
       ('END IF;') CONDICAO_ELSE
from TB_CONFIG_MAPA x1, TB_CONFIG_SETMAPA x2
     where x1.pk_confmp = x2.fuk_confmp
     and x2.fuk_co_setor = '0067' 
     and x2.fuk_co_setor_con = '0079'
union all
select 
       ('SELECT COUNT(FUK_CONFMP) INTO vCOUNT FROM TB_CONFIG_SETMAPA WHERE FUK_CONFMP = '|| ''''|| FUK_CONFMP || ''''|| ' AND FUK_CO_SETOR_CON = ''0342'';' ) selects,
       ('IF vCOUNT = 0 THEN ') condicao_IF,
       ('INSERT INTO TB_CONFIG_SETMAPA (FUK_CONFMP, FUK_CO_SETOR, FUK_CO_SETOR_CON, SN_PRD_NATUESTOQ, SN_EXEC_EXTRA) VALUES 
       ('|| x2.fuk_confmp || ','''|| FUK_CO_SETOR || ''',' || q'['0342']' || ',''' || SN_PRD_NATUESTOQ || ''',''' || SN_EXEC_EXTRA || ''');') inserts,
       ('END IF;') CONDICAO_ELSE
from TB_CONFIG_MAPA x1, TB_CONFIG_SETMAPA x2
     where x1.pk_confmp = x2.fuk_confmp
     and x2.fuk_co_setor = '0067' 
     and x2.fuk_co_setor_con = '0079'

