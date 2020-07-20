--PROCEDURES
create or replace PROCEDURE p_INCLUI_SEGMENTO (
    p_DESCRICAO IN tb_cad_segmento.desc_segm%TYPE
    )
IS 
BEGIN 
    INSERT INTO TB_CAD_SEGMENTO (DESC_SEGM)
        VALUES (UPPER(p_DESCRICAO));
COMMIT;
END;
/

create or replace PROCEDURE p_INCLUI_EMPRESA(
    p_NOME_EMPRE IN tb_cad_empresa.nome_empre%TYPE,
    p_CNPJ IN tb_cad_empresa.cnpj%TYPE,
    p_ENDERECO IN tb_cad_empresa.endereco%TYPE,
    p_NUM_END IN tb_cad_empresa.num_end%TYPE,
    p_TEL IN tb_cad_empresa.telefone%TYPE,
    p_SEGMENTO IN tb_cad_empresa.fk_id_seg%TYPE,
    p_DATA IN tb_cad_empresa.data_cad%TYPE,
    p_OBS IN tb_cad_empresa.observa%TYPE
    )
IS 
    --EXCEÇÕES PREDEFINIDAS   
    e_null  EXCEPTION;
    PRAGMA EXCEPTION_INIT (e_null, -1400);
    e_segmer EXCEPTION;
    PRAGMA EXCEPTION_INIT (e_segmer, -2291);
    e_espaco EXCEPTION;
    PRAGMA EXCEPTION_INIT (e_espaco, -6502);

BEGIN
    INSERT INTO TB_CAD_EMPRESA (NOME_EMPRE, CNPJ, ENDERECO, NUM_END, TELEFONE, FK_ID_SEG, DATA_CAD, OBSERVA)
        VALUES (UPPER(p_NOME_EMPRE), p_CNPJ, UPPER(p_ENDERECO), p_NUM_END, p_TEL, p_segmento, p_DATA, UPPER(p_OBS));
  COMMIT;
    EXCEPTION 
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20010, 'CLIENTE JÁ CADASTRADO !!!');
        WHEN e_null THEN
            RAISE_APPLICATION_ERROR(-20015, 'CAMPO NÃO PODE RECEBER VALOR NULL OU VAZIO');
        WHEN e_segmer THEN
            RAISE_APPLICATION_ERROR(-20020, 'SEGMENTO DE MERCADO NÃO CADASTRADO NA TABELA PRINCIPAL');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20030, 'ERROR GENERICO: ' || sqlerrm());
END;
/

create or replace PROCEDURE p_INCLUI_CLIENTE(
    p_NOME      IN tb_cad_cliente.nome_cli%TYPE,
    p_EMAIL     IN tb_cad_cliente.email%TYPE,
    p_TEL       IN tb_cad_cliente.telefone%TYPE,
    p_USAWAPP   IN tb_cad_cliente.usa_wapp%TYPE,
    p_NASCI     IN tb_cad_cliente.nasc_clie%TYPE,
    p_EMPRESA   IN tb_cad_cliente.fk_id_emp%TYPE,
    p_OBS       IN tb_cad_cliente.observa%TYPE
    )
IS
    --excessões
    e_empresa EXCEPTION; 
    PRAGMA EXCEPTION_INIT (e_empresa, -2291);
    e_null  EXCEPTION;
    PRAGMA EXCEPTION_INIT (e_null, -1400);
    e_wapp  EXCEPTION;
    PRAGMA EXCEPTION_INIT (e_wapp, -2290);

BEGIN 
    INSERT INTO tb_cad_cliente (NOME_CLI, EMAIL, TELEFONE, USA_WAPP, NASC_CLIE, FK_ID_EMP, OBSERVA)
        VALUES (UPPER(p_NOME), UPPER(p_email), p_tel, upper(p_usawapp), p_nasci, p_empresa, UPPER(p_obs));
    COMMIT;

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20010, 'EMAIL JÁ CADASTRADO PARA OUTRO CLINTE.');
        WHEN e_empresa THEN
            RAISE_APPLICATION_ERROR(-20020, 'EMPRESA NÃO CADASTRADA NA TABELA PRINCIPAL.');
        WHEN e_null THEN
            RAISE_APPLICATION_ERROR(-20015, 'CAMPO NÃO PODE RECEBER VALOR NULL OU VAZIO');
        WHEN e_wapp THEN
            RAISE_APPLICATION_ERROR(-20002, 'Valor não suportado para a coluna usa - Whats APP. Utilizar - (S/N)');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20030, 'ERROR GENERICO: ' || sqlerrm());
END;
/

--inclusão de produtos
CREATE OR REPLACE PROCEDURE p_INCLUI_PRODUTO(
        p_NOME IN tb_produto.nome_prd%TYPE,
        p_DESCR IN tb_produto.descri_prd%TYPE,
        p_TIPO  IN tb_produto.tipo_prd%TYPE,
        p_CLASS IN tb_produto.classifica%TYPE,
        p_VALID IN tb_produto.validade%TYPE,
        p_VALOR IN tb_produto.valor_prd%TYPE,
        p_DIVIS IN  tb_produto.divisor%TYPE
        )
IS 
    --EXCEPTIONS 
    e_null  EXCEPTION;
    PRAGMA EXCEPTION_INIT (e_null, -1400);
BEGIN 
    INSERT INTO TB_PRODUTO (nome_prd, descri_prd, tipo_prd, classifica, validade, valor_prd, divisor)
        values (upper(p_nome), upper(p_descr), p_tipo, p_class, p_valid, p_valor, p_divis);
    commit;
    
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20010, 'EMAIL JÁ CADASTRADO PARA OUTRO CLINTE.');
        WHEN e_null THEN
            RAISE_APPLICATION_ERROR(-20015, 'CAMPO NÃO PODE RECEBER VALOR NULL OU VAZIO');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20030, 'ERROR GENERICO: ' || sqlerrm());
END;
/