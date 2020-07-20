-------------------------------------------------------------
-- Finalidade: Ajustar estoque bloqueado para que possa liberar
--             as transferencias pendentes
-------------------------------------------------------------

-------------------------------------------------------------
-- Inicio da procedure
-------------------------------------------------------------
CREATE PROCEDURE AJUSTA_SLD_BLOQ_TMP()
    define cCdSetor  char(4);
    define cCdPrd    char(6);
    define sCdBarraInt char(9);
    define nQtdBlq   numeric(16,4);
    define nQtdTrf   numeric(16,4);

    UPDATE esestcad
       SET est_bloq = 0,
           controle = decode(controle,'0','1','0') 
     WHERE 1 = 1;

    --seleciona todos os itens com problema de estoque bloqueado
    foreach 
           SELECT
                a.cod_prd,
                a.cod_barra_int,
                a.cod_set,
                a.est_bloq,
                SUM(i.quant) 
            INTO
                cCdPrd,
                sCdBarraInt,
                cCdSetor,
                nQtdBlq,
                nQtdTrf
            FROM
                esmovcad c,
                esmovite i,
                esestcad a 
            WHERE
                c.documento      = i.documento AND
                c.tipo_documento = i.tipo_documento AND
                c.tipo_documento = 'TRA' AND
                c.ind_cont_receb = 'S' AND
                c.set_con        = a.cod_set AND
                i.cod_prd        = a.cod_prd AND
				a.cod_barra_int  = DECODE((SELECT COUNT(*) FROM esprod_set_lote l 
                                           WHERE l.cod_prd = a.cod_prd 
                                             AND l.cod_set = a.cod_set),0,'',i.cod_barra_int) AND
                i.pendente       = 'S' 
            GROUP BY 1,	2, 3, 4
            HAVING sum(i.quant) > a.est_bloq


        --efetua a atualizacao da qtd bloqueado conforme 
	update esestcad 
           set est_bloq = nQtdTrf, 
               controle = decode(controle,'0','1','0') 
         where cod_set = cCdSetor and 
               cod_prd = cCdPrd and
               cod_barra_int = sCdBarraInt;
        
    end foreach

END PROCEDURE;
-------------------------------------------------------------
-- fim da procedure
-------------------------------------------------------------

-------------------------------------------------------------
-- Executa a procedure 
-------------------------------------------------------------
EXECUTE PROCEDURE AJUSTA_SLD_BLOQ_TMP();
