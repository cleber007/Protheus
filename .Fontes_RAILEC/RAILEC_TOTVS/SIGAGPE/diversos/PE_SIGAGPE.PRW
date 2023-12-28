#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'

User Function SIGAGPE()
	U_AjustFolMes()
Return


User Function AjustFolMes()

	Local cQuery := ""

	cQuery := " SELECT RCH_PER FROM " + RetSqlName("RCH")
	cQuery += " WHERE RCH_ROTEIR = 'FOL' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	cQuery += " AND RCH_STATUS = '0' "
	cQuery += " AND RCH_PERSEL = '1' "
	TCQUERY cQuery NEW ALIAS "QRCH"
	dbSelectArea("QRCH")
	dbGotop()
	If !eof()
		PutMV("MV_FOLMES",QRCH->RCH_PER)
	Endif
	QRCH->(DbCloseArea())

Return

