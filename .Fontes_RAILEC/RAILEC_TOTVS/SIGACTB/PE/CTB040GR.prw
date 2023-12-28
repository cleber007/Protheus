#Include "Protheus.ch"
#Include "RwMake.ch"

/*/{Protheus.doc} CTB040GR
	(O ponto de entrada CTB040GR é executado após a gravação do Item Contábil.)

	@type function
	@author Vitor Ribeiro - vitor.ribeiro@wikitec.com.br (Consultoria Wikitec)
	@since 16/02/2023

	@obs Documentação da totvs
		https://tdn.totvs.com/pages/releaseview.action?pageId=6068613
	/*/
User Function CTB040GR()

	// Se tiver o campo
	If CTD->(FieldPos("CTD_XSTEXO")) > 0
		RecLock("CTD",.F.)
			CTD->CTD_XSTEXO := "2"
		CTD->(MsUnlock())
	EndIf

	// Se tiver o campo
	If CTD->(FieldPos("CTD_XINEXO")) > 0
		// Se integra com Flash Expense
		If CTD->CTD_XINEXO == "1"
			// Integra Flash Expense
			U_EXONP09(CTD->(Recno()))
		EndIf
	EndIf

Return Nil
