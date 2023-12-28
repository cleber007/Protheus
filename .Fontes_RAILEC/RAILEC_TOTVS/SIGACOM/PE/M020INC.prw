#Include "RWMAKE.CH"
#Include "PROTHEUS.CH"

User Function M020INC()
//	If (PARAMIXB <> 3)  
		dbSelectarea("CTD")
		CTD->(dbSetorder(1))
		If !CTD->(dbSeek(xFilial("CTD") + SA2->A2_COD))
			While !RecLock("CTD",.T.);EndDo 		 
			CTD->CTD_FILIAL	:= xFilial("CTD")
			CTD->CTD_ITEM   	:= SA2->A2_COD
			CTD->CTD_DESC01	:= SA2->A2_NOME
			CTD->CTD_DESC02	:= SA2->A2_NREDUZ
			CTD->CTD_CLASSE	:= "2"
			CTD->CTD_BLOQ  	:= "2"
			CTD->(msUnlock())
			CTD->(dbCommitAll())
			Alert("FORNECEDOR incluido no Item Contabil!")
		Endif
//	Endif
Return(nil)