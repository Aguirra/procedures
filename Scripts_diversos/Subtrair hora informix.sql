select current - dh_inclusao, * from ti_ctr_pedido where current - dh_inclusao > '0 00:20:00' order by dh_inclusao desc;

select * from ti_ctr_pedido Where dh_inclusao <= current - 30 units minute ;
