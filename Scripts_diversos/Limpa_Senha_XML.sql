select senha from fasencad where cod_guia in (
	select cod_guia from faguicad where cod_pac in (
		select cod_pac from fapaccad where cod_pac in (
			select cod_pac from fafatprd where fatura in (
				select fatura from fafatcad where remessa in('025914','025915','025916')))))