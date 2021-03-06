-- CR........: 7749
-- CRC.......: 4127
-- Banco.....: WPDHOSP - Informix
-- Versao....: 71.08.01_Esho
-- Analista..: André Fonseca
-- Data......: 30/05/2014
-- Cliente...: Todos Amil
-- Finalidade: Criação da procedure para baixar pacientes de urgência
--============================================================================
CREATE PROCEDURE check_estrutura()
   define  ncount integer;

   SELECT COUNT(*)
     INTO ncount
     FROM sysprocedures
    WHERE upper(procname) = 'SP_BAIXAPACOBS';

   IF ncount>0 THEN
      DROP PROCEDURE SP_BAIXAPACOBS(char,char,char,char,char,char,integer);
   END IF;
END PROCEDURE;

EXECUTE PROCEDURE check_estrutura();
DROP PROCEDURE check_estrutura;

CREATE PROCEDURE SP_BAIXAPACOBS(cCodUni     char(6),
                             cDataIni    char(10),
                             cDataFin    char(10),
							 cQtdHr      char(5),
							 cCodMotAlta char(2),
							 cMotAlta    char(1),
							 cStatus     integer)

  ------------------------------------------------------------------------------
  -- Nome.......: BaixaPacObs
  --
  -- Finalidade: Baixar todos os paciente que estao com status em observacao(40)
  --             sem refistro de alta com mais de X horas.
  --
  -- Parametros.: cCodUni     -> Codigo da Unidade
  --              cDataIni     -> Periodo inicial para selecao dos registros
  --              cDataFin    -> Periodo final para selecao dos registros
  --              cQtdHr      -> Quantidade de horas para realizar a alta
  --              cCodMotAlta -> Codigo do motivo da alta
  --              cMotAlta    -> Motivo da alta
  --              cStatus     -> Codigo do Status a ser trabalhado
  -- Exemplo: 
  -- EXECUTE PROCEDURE SP_BAIXAPACOBS('LIFE','01/01/2014','31/03/2014','36:00','12','M',40);
  ------------------------------------------------------------------------------
  
define   dNovaData, dDataAltaAdm, dDataAltaMed,dDataAlta datetime year to second;
define   nCodPac, cAltaPrevista varchar(7);
define   nFormulario,nProtocolo, nSenha, nStatus, nStatusAtu integer; 
define   dDataIni, dDataFim date;

Let dDataIni = to_date(cDataIni,'%d/%m/%Y');
Let dDataFim = to_date(cDataFin,'%d/%m/%Y');

  
  FOREACH select (select count(*) 
                    from modelo_aferido
                    where cod_pac = f.cod_pac 
                      and st_protocolo = 'P') qtd_protocolo,
			     (select count(*) qtde                          
                    from modelo_aferido t1, 
					     modelo_frm_clinico t2 
                   where t1.cod_frm_cln = t2.cod_frm_cln         
                     and t2.sn_protocolo = 'N'
                     and t1.cod_pac = f.cod_pac) qtd_formulario,
			     f.cod_pac, 
                 s.pk_selsen, 
                 s.fk_striag,
				 f.data_alta,
				 f.data_alta_medica,                  				                  
				 nvl((select max(dh_hist_ini) + cast(substr(cQtdHr,1,(instr(cQtdHr,':')-1)) as int) units hour
                   from tm_histpac h
                  where h.fk_selsen = s.pk_selsen), (s.dh_retirada + cast(substr(cQtdHr,1,(instr(cQtdHr,':')-1)) as int) units hour)) dt_hist,
				 f.sn_altaprevista
          into nProtocolo, nFormulario, nCodPac, nSenha, nStatus, dDataAltaAdm, dDataAltaMed, dDataAlta, cAltaPrevista
          from outer fapaccad f, tb_sel_senha_fila s 
          where f.cod_pac = s.fk_cod_pac            
            and f.tipo_pac = 'U'
            and f.data_ent is not null
            and f.hora_ent is not null
            and f.cod_uni = cCodUni			
            and s.fk_striag = cStatus			
            and to_date(to_char(s.dh_retirada,'%d/%m/%Y'),'%d/%m/%Y') between dDataIni and dDataFim      
    
    if nStatus in (1,2,3,4,8,9,11,13,14,15,16,17,18,32) then
	  let nStatusAtu = 10;
	  
	  if nCodPac <> '' then	
        let dNovaData = dDataAlta;
		
	    update tm_histpac
         set dh_hist_fim = dNovaData
       where fk_selsen = nSenha
         and dh_hist_fim is null;
		 
		if ((nStatus = 4) and (nFormulario > 0)) then
	      let nStatusAtu = 5;
	    end if;
        
		if (nProtocolo > 0) then
		  update modelo_aferido
		     set st_protocolo = 'F'
           where cod_pac = nCodPac
             and st_protocolo = 'P';	     
        end if;
	  else	  	    
		let dNovaData = dDataAlta;		
		update tm_histpac
           set dh_hist_fim = dNovaData
         where fk_selsen = nSenha
           and dh_hist_fim is null;
	  end if;

      INSERT INTO TM_HISTPAC (FK_SELSEN, FK_STRIAG, DH_HIST_INI, FK_MATRICULA,  DS_LOCALIDADE)
      VALUES (nSenha, nStatusAtu, dNovaData, '0',  'SCRIPT');

	  update tb_sel_senha_fila
         set fk_striag = nStatusAtu, ds_justificativa = 'SCRIPT', qt_chamado = 0
       where pk_selsen = nSenha;
	  
	  if nStatusAtu in (5) then	   
	    update fapaccad 
           set data_alta        = to_char(dNovaData,'%d/%m/%Y'),
               hora_alta        = to_char(dNovaData,'%H:%M'),
               data_alta_medica = dNovaData,
               cod_mot_alta     = cCodMotAlta,
               moti_alta        = cMotAlta
         where cod_pac = nCodPac; 
	  end if;
	  
	elif nStatus in (12,19,20,31,41,42) then	  
	  let nStatusAtu = 5;
	  
	  update tm_histpac
         set dh_hist_fim = dDataAlta
       where fk_selsen = nSenha
         and dh_hist_fim is null;		 
	  
	  if (nProtocolo > 0) then
	    update modelo_aferido
		   set st_protocolo = 'F'
         where cod_pac = nCodPac
           and st_protocolo = 'P';
	  end if;
	  
	  update fapaccad 
         set data_alta        = to_char(dDataAlta,'%d/%m/%Y'),
             hora_alta        = to_char(dDataAlta,'%H:%M'),
             data_alta_medica = dDataAlta,
             cod_mot_alta     = cCodMotAlta,
             moti_alta        = cMotAlta
       where cod_pac = nCodPac; 
	  
      INSERT INTO TM_HISTPAC (FK_SELSEN, FK_STRIAG, DH_HIST_INI, FK_MATRICULA,  DS_LOCALIDADE)
      VALUES (nSenha, nStatusAtu, dDataAlta, '0',  'SCRIPT');

	  update tb_sel_senha_fila
         set fk_striag = nStatusAtu, ds_justificativa = 'SCRIPT', qt_chamado = 0
       where pk_selsen = nSenha;	  
	 elif nStatus in (21,23,24,25,26,27,28,29,30,33,34,35,36,37,38,39) then	  
	  let nStatusAtu = 22;
	  
	  update tm_histpac
         set dh_hist_fim = dDataAlta
       where fk_selsen = nSenha
         and dh_hist_fim is null;		 
	  
	  if (nProtocolo > 0) then
	    update modelo_aferido
		   set st_protocolo = 'F'
         where cod_pac = nCodPac
           and st_protocolo = 'P';
	  end if;
	  
	  update fapaccad 
         set data_alta        = to_char(dDataAlta,'%d/%m/%Y'),
             hora_alta        = to_char(dDataAlta,'%H:%M'),
             data_alta_medica = dDataAlta,
             cod_mot_alta     = cCodMotAlta,
             moti_alta        = cMotAlta
       where cod_pac = nCodPac; 
	  
      INSERT INTO TM_HISTPAC (FK_SELSEN, FK_STRIAG, DH_HIST_INI, FK_MATRICULA,  DS_LOCALIDADE)
      VALUES (nSenha, nStatusAtu, dDataAlta, '0',  'SCRIPT');

	  update tb_sel_senha_fila
         set fk_striag = nStatusAtu, ds_justificativa = 'SCRIPT', qt_chamado = 0
       where pk_selsen = nSenha;
	   
	 elif nStatus in (5,22) then
	   if ((dDataAltaAdm = '') and (dDataAltaMed = '')) then
	     update fapaccad 
         set data_alta        = to_char(dDataAlta,'%d/%m/%Y'),
             hora_alta        = to_char(dDataAlta,'%H:%M'),
             data_alta_medica = dDataAlta,
             cod_mot_alta     = cCodMotAlta,
             moti_alta        = cMotAlta
         where cod_pac = nCodPac;
	   elif ((dDataAltaAdm <> '') and (dDataAltaMed = '')) then
	     update fapaccad 
         set data_alta_medica = to_date((data_alta ||hora_alta),'%d/%m/%Y %H:%M'),
             cod_mot_alta     = cCodMotAlta,
             moti_alta        = cMotAlta
         where cod_pac = nCodPac;
	   elif ((dDataAltaAdm = '') and (dDataAltaMed <> '')) then
	     update fapaccad 
         set data_alta        = to_char(data_alta_medica,'%d/%m/%Y'),
             hora_alta        = to_char(data_alta_medica,'%H:%M'),             
             cod_mot_alta     = cCodMotAlta,
             moti_alta        = cMotAlta
         where cod_pac = nCodPac;
	   end if;   
	 
	 elif nStatus in (40) then
	   update fapaccad 
         set data_alta        = to_char(dDataAlta,'%d/%m/%Y'),
             hora_alta        = to_char(dDataAlta,'%H:%M'),
             data_alta_medica = dDataAlta,
             cod_mot_alta     = cCodMotAlta,
             moti_alta        = cMotAlta
       where cod_pac = nCodPac;  
       
      if nStatus not in (5,22) then
	    if cAltaPrevista = 'S' then
	      let nStatusAtu = 22;
	    else
	      let nStatusAtu = 5;
	    end if;	
	
	    update tm_histpac
           set dh_hist_fim = dDataAlta
         where fk_selsen = nSenha
           and dh_hist_fim is null;

        INSERT INTO TM_HISTPAC (FK_SELSEN, FK_STRIAG, DH_HIST_INI, FK_MATRICULA,  DS_LOCALIDADE)
        VALUES (nSenha, nStatusAtu, dDataAlta, '0',  'SCRIPT');

	    update tb_sel_senha_fila
           set fk_striag = nStatusAtu, ds_justificativa = 'SCRIPT', qt_chamado = 0
         where pk_selsen = nSenha;
	  end if;    
	end if;
     
  END FOREACH;
END PROCEDURE;

GRANT EXECUTE ON PROCEDURE SP_BAIXAPACOBS(char,char,char,char,char,char,integer) TO PUBLIC;