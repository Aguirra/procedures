select 'UPDATE TB_VERSION_EXEC SET SN_ATIVO = ''N'' WHERE DS_SISTEMA ='''|| ds_sistema ||''' AND DS_VERSAO_EXE <> '''|| max(ds_versao_exec)||''';' from tb_version_exec
where length(ds_versao_exec) = 10
group by ds_sistema