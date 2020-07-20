--BPFornecedor NÃO EXPANDIDO NO SAP

select * from sap.tb_sap_request_log 
where dh_inclusao > to_date(sysdate, 'dd/mm/yy')
and co_interface = 'BPFornecedor'
and lower(post_data) like '%17890222000120%' order by dh_inclusao desc 