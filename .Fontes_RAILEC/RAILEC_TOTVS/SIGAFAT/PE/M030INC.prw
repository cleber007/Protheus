#Include "RWMAKE.CH"
#Include "PROTHEUS.CH"

User Function M030INC()
If (PARAMIXB <> 3)
	dbSelectarea("CTD")
	CTD->(dbSetorder(1))
	If !CTD->(dbSeek(xFilial("CTD") + SA1->A1_COD + SA1->A1_LOJA))
		While !RecLock("CTD",.T.);EndDo
		CTD->CTD_FILIAL	:= xFilial("CTD")
		CTD->CTD_ITEM   	:= SA1->A1_COD + SA1->A1_LOJA
		CTD->CTD_DESC01	:= SA1->A1_NOME
		CTD->CTD_DESC02	:= SA1->A1_NREDUZ
		CTD->CTD_CLASSE	:= "2"
		CTD->CTD_BLOQ  	:= "2"
		CTD->(msUnlock())
		CTD->(dbCommitAll())
		Alert("CLIENTE incluido no Item Contabil!")
	Endif
	
	IF GETMV("AL_CREDBLQ") 					// Bloqueio por limite de credito (.T.)
		
		// Inclusão do Limite de Crédito Inicial R$1,00
		// Antonio Carlos 05/11/2016 - Sigacorp
		
		dbselectarea("ZPE")
		dbSetOrder(1)
		DBSeek(xFilial("ZPE")+'000001'+SA1->A1_COD+SA1->A1_LOJA)
		if !Found()
			if RecLock("ZPE",.T.)
				ZPE->ZPE_FILIAl 	:= xFilial("ZPE")
				ZPE_SEQ				:= '000001'
				ZPE_CODCLI			:= SA1->A1_COD
				ZPE_NOMCLI			:= SA1->A1_NOME
				ZPE_LOJA				:= SA1->A1_LOJA
				ZPE_LIMITE			:= 1
				ZPE_CODUSR			:= RetCodUsr()
				ZPE_NOMUSR			:= UsrRetName(RetCodUsr())
				ZPE_DTDGT	      := dDataBase
				ZPE_HRDGT			:= Transform(Time(),"99:99:99")
				ZPE_STATUS			:= "A"
				/////			ZPE_MOTIVO			:= "LIMITE INICIAL AUTOMATICO"
				MsUnLock()
				Alert("CLIENTE incluido no Limite de Credito!")
			Endif
		Endif
	Endif
Endif
Return(nil)
