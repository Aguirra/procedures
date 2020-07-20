SELECT t1. * ,t8.txt       
FROM sysmaster:'informix'.syslcktab t1, sysmaster:'informix'.flags_text t8       
WHERE t8.tabname = 'syslcktab'                           
AND t8.flags = t1.type
INTO temp ss_lcktab1;

SELECT t2.dbsname,        t2.tabname, t3.owner t3owner, t1. *       
FROM sysmaster:'informix'.systabnames t2, OUTER(sysmaster:'informix'.systxptab t3),
ss_lcktab1 t1       
WHERE t2.tabname NOT IN('systables','syscolumns','sysindices','systabauth','syscolauth',
'sysviews','sysusers','sysdepend','syssynonyms',
'syssyntable','sysconstraints','sysreferences','syschecks',
'sysdefaults','syscoldepend','sysprocedures','sysprocbody',
'sysprocplan','sysprocauth','sysblobs','sysopclstr','systriggers',
'systrigbody','sysdistrib','sysfragments','sysobjstate','sysviolations',
'sysfragauth','sysroleauth','sysxtdtypes','sysattrtypes','sysxtddesc',
'sysinherits','syscolattribs','syslogmap','syscasts','sysxtdtypeauth',
'sysroutinelangs','syslangauth','sysams','systabamdata','sysopclasses',
'syserrors','systraceclasses','systracemsgs','sysaggregates','syssequences',
'sysdomains','sysindexes',' GL_COLLATE',' GL_CTYPE',' VERSION','TBLSpace', 'sysdatabases','sbspace_desc','chunk_adjunc','LO_ud_free',
'LO_hdr_partn','HASHTEMP','SORTTEMP', 'ss_lcktab1')       
AND t1.owner = t3.address                      
AND t1.partnum = t2.partnum
INTO temp ss_lcktab2 WITH NO LOG ;

SELECT t4.sid,        t5.username,        t1. *, t5.ttyin
FROM sysmaster:'informix'.sysrstcb t4, OUTER(sysmaster:'informix'.sysscblst t5),ss_lcktab2 t1       
WHERE t3owner = t4.address                       
AND t4.sid = t5.sid
INTO temp ss_lcktab3 WITH NO LOG ;

SELECT DISTINCT t1. * ,        t6.sid t6sid,        t7.username t7username
FROM ss_lcktab3 t1,sysmaster:'informix'.sysrstcb t6, sysmaster:'informix'.sysscblst t7       
WHERE t1.wtlist = t6.address
INTO temp ss_lcktab4 WITH NO LOG;

SELECT dbsname database, txt type, tabname table, 
sid lock_sess, username lock_user, t6sid wait_sess,
t7username wait_user, rowidr row_id, keynum, ttyin
FROM ss_lcktab4;

/*
drop table ss_lcktab4;
drop table ss_lcktab3;
drop table ss_lcktab2;
drop table ss_lcktab1;
*/