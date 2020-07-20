--3.1) CRIA AS TABELAS TEMPORARIAS

SET ISOLATION TO DIRTY READ; 

create temp table saldo_movimento(cod_prd CHAR(6) NOT NULL,
                                  cod_set char(4),
                                  cod_barra_int char(9),
                                  est_atu       decimal(21,3)) with no log;

create temp table saldo1(cod_prd CHAR(6) NOT NULL,
                         cod_set CHAR(4),
                         cod_barra_int CHAR(9),
                         est_atu       decimal(21,3)) with no log;

create temp table saldo2(cod_prd CHAR(6) NOT NULL,
                         cod_set CHAR(4),
                         cod_barra_int CHAR(9),
                         est_atu       decimal(21,3)) with no log;

create temp table dif(cod_prd CHAR(6) NOT NULL,
                      cod_set CHAR(4),
                      cod_barra_int CHAR(9),
                      est_atu       decimal(21,3) not null,
                      dif           decimal(21,3),
                      new_estoq     decimal(21,3),
                      data_hora_inc datetime year to second) with no log;


--3.2) INSERIR AS MOVIMENTACOES NA TABELA SALDO_MOVIMENTO, EXCETO AS TRANSFERENCIAS QUE TERAO TRATAMENTO ESPECIAL. 
--     OS DOIS INSERTS EXISTEM POIS UM É PARA OS DOCUMENTOS DE CRÉDITO E OUTRO DE DÉBITO

INSERT INTO SALDO_MOVIMENTO
SELECT COD_PRD,
       SET_EST,
       NVL((SELECT I.COD_BARRA_INT 
              FROM ESPROD_SET_LOTE E 
             WHERE E.COD_PRD = I.COD_PRD 
               AND TO_DATE(TO_CHAR(DATA_MOV,'%d/%m/%Y')||' '
                  ||FC_INTERVLHRSGTCHR(HRA_MOVIMENTACAO),'%d/%m/%Y %H:%M:%S') 
                  >= E.DATA_HORA_INC
               AND M.SET_EST = E.COD_SET), ' ') COD_BARRA_INT,
       SUM(QUANT)
  FROM ESMOVCAD M,ESMOVITE I
 WHERE M.TIPO_DOCUMENTO = I.TIPO_DOCUMENTO
   AND M.DOCUMENTO      = I.DOCUMENTO
   AND M.NOTA=I.NOTA
   AND M.TIPO_DOCUMENTO <> 'PED'
   AND M.TIPO_DOCUMENTO <> 'TRA'
   AND DATA_MOV >= '01/11/2015'
   AND CRED_DEB = 'D'
 GROUP BY 1,2,3;


--3.3) INSERE O ESTOQUE ATUAL DA ESESTCAD, POIS SAIDAS + ESTOQUE_ATUAL - ENTRADAS = 0

INSERT INTO SALDO_MOVIMENTO
SELECT COD_PRD,COD_SET,COD_BARRA_INT,SUM(EST_ATU)
  FROM ESESTCAD
 GROUP BY COD_PRD,COD_SET,COD_BARRA_INT;


INSERT INTO SALDO_MOVIMENTO
SELECT COD_PRD,
       SET_EST,
       NVL((SELECT I.COD_BARRA_INT 
              FROM ESPROD_SET_LOTE E 
             WHERE E.COD_PRD = I.COD_PRD 
               AND TO_DATE(TO_CHAR(DATA_MOV,'%d/%m/%Y')||' '
                  ||FC_INTERVLHRSGTCHR(HRA_MOVIMENTACAO),'%d/%m/%Y %H:%M:%S') 
                  >= E.DATA_HORA_INC
               AND M.SET_EST = E.COD_SET), ' ') COD_BARRA_INT,
       SUM(QUANT*(-1))
  FROM ESMOVCAD M,ESMOVITE I
 WHERE M.TIPO_DOCUMENTO=I.TIPO_DOCUMENTO
   AND M.DOCUMENTO     =I.DOCUMENTO
   AND M.NOTA=I.NOTA
   AND M.TIPO_DOCUMENTO <> 'PED'
   AND M.TIPO_DOCUMENTO <> 'TRA'
   AND DATA_MOV >= '01/11/2015'
   AND CRED_DEB = 'C'
 GROUP BY 1,2,3;
 

--3.4) TRATAMENTO DAS TRANSFERENCIAS. DEVE SER DOBRADO POR CONTA DA SAÍDA DO ORIGEM E DA ENTRADA NO DESTINO.

INSERT INTO SALDO_MOVIMENTO
SELECT COD_PRD,
       SET_CON,
       NVL((SELECT I.COD_BARRA_INT 
              FROM ESPROD_SET_LOTE E 
             WHERE E.COD_PRD = I.COD_PRD 
               AND TO_DATE(TO_CHAR(DATA_MOV,'%d/%m/%Y')||' '
                  ||FC_INTERVLHRSGTCHR(HRA_MOVIMENTACAO),'%d/%m/%Y %H:%M:%S') 
                  >= E.DATA_HORA_INC
               AND M.SET_CON = E.COD_SET), ' ') COD_BARRA_INT,
       SUM(QUANT * (-1))
  FROM ESMOVCAD M,ESMOVITE I
 WHERE M.TIPO_DOCUMENTO = I.TIPO_DOCUMENTO
   AND M.DOCUMENTO      = I.DOCUMENTO
   AND M.NOTA=I.NOTA
   AND M.TIPO_DOCUMENTO = 'TRA'
   AND DATA_MOV >= '01/11/2015'
 GROUP BY 1,2,3;

INSERT INTO SALDO_MOVIMENTO
SELECT COD_PRD,
       SET_EST,
       NVL((SELECT I.COD_BARRA_INT 
              FROM ESPROD_SET_LOTE E 
             WHERE E.COD_PRD = I.COD_PRD 
               AND TO_DATE(TO_CHAR(DATA_MOV,'%d/%m/%Y')||' '
                  ||FC_INTERVLHRSGTCHR(HRA_MOVIMENTACAO),'%d/%m/%Y %H:%M:%S') 
                  >= E.DATA_HORA_INC
               AND M.SET_EST = E.COD_SET), ' ') COD_BARRA_INT,
       SUM(QUANT)
  FROM ESMOVCAD M,ESMOVITE I
 WHERE M.TIPO_DOCUMENTO = I.TIPO_DOCUMENTO
   AND M.DOCUMENTO      = I.DOCUMENTO
   AND M.NOTA=I.NOTA
   AND M.TIPO_DOCUMENTO = 'TRA'
   AND DATA_MOV >= '01/11/2015'
 GROUP BY 1,2,3;


--3.5) INSERE OS ITENS TOTALIZADOS DE SALDO_MOVIMENTO EM SALDO1

create index saldo_movimento on saldo_movimento (cod_prd,cod_set,cod_barra_int);

insert into saldo1 (cod_prd,cod_set,cod_barra_int,est_atu)
select cod_prd,cod_set,cod_barra_int,sum(est_atu) est_atu 
from saldo_movimento
group by cod_prd,cod_set,cod_barra_int;


--3.6) INSERE OS ITENS DO ESTOQUE INICIAL DE REFERENCIA. 

INSERT INTO saldo2 (cod_prd,cod_set,cod_barra_int,est_atu)
SELECT ESHISCAD.COD_PRD,
       ESHISCAD.COD_SET,
       CASE 
         WHEN ESPROD_SET_LOTE.COD_SET IS NULL THEN ' '
         WHEN ESPROD_SET_LOTE.DATA_HORA_INC < TO_DATE('01/11/2015 00:00:00', '%d/%m/%Y %H:%M:%S') THEN COD_BARRA_INT
         ELSE ' '
       END COD_BARRA_INT,
       SUM(EST_ATU_MES) EST_ATU 
  FROM ESHISCAD, outer(ESPROD_SET_LOTE)
 WHERE ESHISCAD.ANO_MES='201510' 
   AND ESHISCAD.EST_ATU_MES IS NOT NULL
   AND ESHISCAD.COD_SET = ESPROD_SET_LOTE.COD_SET  
   AND ESHISCAD.COD_PRD = ESPROD_SET_LOTE.COD_PRD  
GROUP BY ESHISCAD.COD_PRD,
         ESHISCAD.COD_SET,3;


--3.7) INSERIR NA TABELA DIF, OS REGISTROS QUE SERÃO ATUALIZADOS.

INSERT INTO DIF (cod_prd, cod_set, cod_barra_int, est_atu, dif, new_estoq, data_hora_inc)
select s1.cod_prd,
       s1.cod_set,
       s1.cod_barra_int,
       nvl(e.est_atu,0),
       (nvl(s2.est_atu,0) - s1.est_atu),
       (nvl(e.est_atu,0) + nvl(s2.est_atu,0) - s1.est_atu),
       (SELECT DATA_HORA_INC FROM ESPROD_SET_LOTE W
         WHERE COD_PRD = e.cod_prd
           AND COD_SET = e.cod_set)
from   saldo2 s2,
       saldo1 s1,
       outer(esestcad e)
where  s1.cod_prd = s2.cod_prd
  and  s1.cod_set = s2.cod_set
  and  s1.cod_barra_int = s2.cod_barra_int
  and  e.cod_prd  = s2.cod_prd
  and  e.cod_set  = s2.cod_set
  and  e.cod_barra_int = s2.cod_barra_int
  and  s1.est_atu <> nvl(s2.est_atu,0);


--3.8) ATUALIZAR A TABELA DE SALDO DO ESTOQUE ATUAL.

create index dif on dif (cod_prd,cod_set,cod_barra_int);

------------------------------------------------------------
-- SE TIVER NEW_ESTOQ < 0. DEVE-SE INSERIR ACERTO DE ENTRADA 
------------------------------------------------------------
select * from dif ;

/*update esestcad set est_atu = est_atu + (select dif from dif
   where esestcad.cod_prd = dif.cod_prd
     and esestcad.cod_set = dif.cod_set
     and esestcad.cod_barra_int = dif.cod_barra_int),
   CONTROLE = DECODE(CONTROLE,'0','1','0')
where exists (select dif from dif
   where esestcad.cod_prd = dif.cod_prd
     and esestcad.cod_set = dif.cod_set
     and esestcad.cod_barra_int = dif.cod_barra_int
     and dif.new_estoq >= 0 );*/
