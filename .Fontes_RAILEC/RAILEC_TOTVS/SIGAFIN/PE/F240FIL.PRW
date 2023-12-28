#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  F240FIL     ºAutor  Denis Tsuchiya      º Data ³  06/13/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtros para o browser dos borderos                        º±±
±±º          ³ Filtrando registros de acordo com Tipo e Forma de pagamento º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
///////////////////////                              
User Function F240FIL()
	///////////////////////

	//Local _cModPgto := cModPgto
	//Local _cTipoPag := cTipoPag   
	//Local _cBanco := cPort240
	Local _cFiltro := ""

	/*
	_cFiltro:=""
	If cModPgto == "30"
		If cPort240 == "001"                                        
			_cFiltro := " SUBSTR((cAliasSE2)->E2_CODBAR,1,3)=="+"'"+cPort240+"'"

		Else   
			_cFiltro := " !EMPTY((cAliasSE2)->E2_CODBAR)"
		EndIf
	ElseIf cModPgto == "31"
		_cFiltro := " !EMPTY((cAliasSE2)->E2_CODBAR)"
		If cPort240 == "001"                                         
			_cFiltro := " .AND. SUBSTR((cAliasSE2)->E2_CODBAR,1,3)<>"+"'"+cPort240+"'"
		EndIf
	ElseIf cModPgto == "01"
		_cFiltro := " Empty((cAliasSE2)->E2_CODBAR)  .and. " 
		_cFiltro += " (     GetAdvFval('SA2','A2_XTIPCTA',xFilial('SA2')+(cAliasSE2)->E2_FORNECE+(cAliasSE2)->E2_LOJA,1) <> '2'"
		_cFiltro += " .and. GetAdvFval('SA2','A2_BANCO',xFilial('SA2')+(cAliasSE2)->E2_FORNECE+(cAliasSE2)->E2_LOJA,1)  =="+"'"+cPort240+"' )"

	ElseIf cModPgto == "05" // Conta Poupanca
		_cFiltro := " Empty((cAliasSE2)->E2_CODBAR)  .and. " 
		_cFiltro += " (     GetAdvFval('SA2','A2_XTIPCTA',xFilial('SA2')+(cAliasSE2)->E2_FORNECE+(cAliasSE2)->E2_LOJA,1) == '2'"
		_cFiltro += " .and. GetAdvFval('SA2','A2_BANCO',xFilial('SA2')+(cAliasSE2)->E2_FORNECE+(cAliasSE2)->E2_LOJA,1)  =="+"'"+cPort240+"' )"

	ElseIf cModPgto == "03" 
		_cFiltro := " Empty((cAliasSE2)->E2_CODBAR) .and. "// .and. "
		_cFiltro += " (cAliasSE2)->E2_SALDO < 5000 .and. "   
		_cFiltro += " (  !Empty(GetAdvFval('SA2','A2_BANCO',xFilial('SA2')+(cAliasSE2)->E2_FORNECE+(cAliasSE2)->E2_LOJA,1))  "
		_cFiltro += "  .and. GetAdvFval('SA2','A2_XTIPCTA',xFilial('SA2')+(cAliasSE2)->E2_FORNECE+(cAliasSE2)->E2_LOJA,1) <> '2'"
		_cFiltro += "  .and. GetAdvFval('SA2','A2_BANCO'  ,xFilial('SA2')+(cAliasSE2)->E2_FORNECE+(cAliasSE2)->E2_LOJA,1)  <>"+"'"+cPort240+"'  )"

	ElseIf cModPgto == "41" .or. cModPgto == "43"
		_cFiltro := " Empty((cAliasSE2)->E2_CODBAR) .and. " 
		_cFiltro += " (  !Empty(GetAdvFval('SA2','A2_BANCO',xFilial('SA2')+(cAliasSE2)->E2_FORNECE+(cAliasSE2)->E2_LOJA,1))  "
		_cFiltro += "  .and. GetAdvFval('SA2','A2_BANCO'  ,xFilial('SA2')+(cAliasSE2)->E2_FORNECE+(cAliasSE2)->E2_LOJA,1)  <>"+"'"+cPort240+"'  )"

	ElseIf cModPgto $ "13_18_21_25_27_19"
		_cFiltro := " !EMPTY((cAliasSE2)->E2_CODBAR) .AND. SUBSTR((cAliasSE2)->E2_CODBAR,1,1)=='8' .AND. Empty((cAliasSE2)->E2_XINSS) .AND. (cAliasSE2)->E2_TIPO <> 'FGT'"

	ElseIf cModPgto == "16"  //--- Darf Normal - Selecionar com codigo de retencao e tipo TX              
		_cFiltro := " !EMPTY((cAliasSE2)->E2_CODBAR) .AND. SUBSTR((cAliasSE2)->E2_CODBAR,1,1)=='8' .AND. !Empty((cAliasSE2)->E2_XINSS) .AND. (cAliasSE2)->E2_TIPO == 'TX '"

	ElseIf cModPgto == "11"  //--- FGTS - Selecionar com tipo FGT              
		_cFiltro := " !EMPTY((cAliasSE2)->E2_CODBAR) .AND. SUBSTR((cAliasSE2)->E2_CODBAR,1,1)=='8' .AND. (cAliasSE2)->E2_TIPO == 'FGT'"

	ElseIf cModPgto == "17"  //--- GPS 
		_cFiltro := " !EMPTY((cAliasSE2)->E2_CODBAR) .AND. SUBSTR((cAliasSE2)->E2_CODBAR,1,1)=='8' .AND. !Empty((cAliasSE2)->E2_XINSS) .AND. (cAliasSE2)->E2_TIPO == 'INS'"

	EndIf
	*/

Return(_cFiltro)
