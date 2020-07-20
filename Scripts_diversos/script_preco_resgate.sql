-- Alterar Unidade Padrão de Preço no Cadastro de Unidade
UPDATE AMuniCad SET Co_Unid_PrecPadrao = 'Unidade Padrao de Preco' WHERE Co_Unid_PrecPadrao = 'TCARE';

-- Alterar Unidade Padrão de Preço no Cadastro de Valides
UPDATE FaTipPre SET Cod_Uni = 'ACADEM' WHERE Cod_Uni = 'Unidade Padrao de Preco';
UPDATE FaTipPre SET Cod_Uni = 'Unidade Padrao de Preco' WHERE Cod_Uni = 'TCARE';

-- Alterar Unidade Padrão de Preço no Cadastro de Apelidos de Tabelas
UPDATE FaApeTab SET Co_Unidade = 'Unidade Padrao de Preco' WHERE Co_Unidade = 'TCARE';

-- Alterar Unidade Padrão de Preço no Cadastro de Valores de Filmes e Honorarios
UPDATE FaFilHon SET Cod_Uni = 'Unidade Padrao de Preco' WHERE Cod_Uni = 'TCARE';

-- Alterar Unidade Padrão de Preço no Cadastro de Preços
UPDATE FaPreCad SET Cod_Uni = 'Unidade Padrao de Preco' WHERE Cod_Uni = 'TCARE';

-- Alterar Unidade Padrão de Preço no Cadastro 
UPDATE Preco_Fil_Hon_Ger SET Cod_Uni = 'Unidade Padrao de Preco' WHERE Cod_Uni = 'TCARE';

-- Alterar Unidade Padrão de Preço no Cadastro 
UPDATE BrasWPD_PreCad SET Cod_Uni = 'Unidade Padrao de Preco' WHERE Cod_Uni = 'TCARE';