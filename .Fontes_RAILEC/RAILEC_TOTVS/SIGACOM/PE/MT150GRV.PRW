User Function MT150GRV()

//Local nSituacao := PARAMIXB[1]       // PARAMIXB[1] = 3 situação em inclusão de cotação ; PARAMIXB[1] = 4 situação em proposta de cotação 
Local lOk		:= .F.

lOk	:= .F.

If !Empty(AllTrim(cContato))
	lOk	:= .T.
EndIf

If !Empty(AllTrim(cA150Fmail))
	lOk	:= .T.
EndIf

If lOk
	dbSelectArea("SA2")
	dbSetOrder(1)
	If ( dbSeek(xFilial("SA2")+cA150Forn+cA150Loj) )
		RecLock("SA2",.F.)
		If !Empty(AllTrim(cContato))
			SA2->A2_CONTATO	:= cContato
		EndIf
		If !Empty(AllTrim(cA150Fmail))
			SA2->A2_EMAIL	:= cA150Fmail
		EndIf
		MsUnLock()
	EndIf
EndIf

Return 
