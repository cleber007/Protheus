#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"
#Include "FWMVCDef.ch"

/*/{Protheus.doc} ITEM
	(PE do fornecedor (MATA010) em MVC)

	@type function
	@author Vitor Ribeiro - vitor.ribeiro@wikitec.com.br (Consultoria Wikitec)
	@since 29/06/2020

	@param a_Param, array, contém as informações do MVC

	@obs Documentação da totvs
		https://centraldeatendimento.totvs.com/hc/pt-br/articles/360016405952-MP-ADVPL-Ponto-de-entrada-MVC-para-as-rotinas-MATA010-MATA020-e-MATA030
	/*/
User Function CUSTOMERVENDOR()

	Local _aParam := PARAMIXB

	Local _lIsGrid := .F.

	Local _oObjeto := Nil

	Local _cIdPonto := ""
	Local _cIdModel := ""

	Local _xReturn := .T.

	// Se tiver os parâmetros
	If _aParam <> NIL
		_oObjeto := _aParam[1]

		_cIdPonto := _aParam[2]
		_cIdModel := _aParam[3]

		_lIsGrid := Len(_aParam) > 3
	EndIf

	// Após a gravação total do modelo e dentro da transação.
	If _cIdPonto == "MODELCOMMITTTS"
		// Se tiver a integração do fornecedor com Flash Expense
		If WK_Generico():GetConteudo("EXON_PARAM_INTEGRACA","INPROJ","") == "SA2"
			// Se tiver o campo
			If SA2->(FieldPos("A2_XSTEXO")) > 0
				RecLock("SA2",.F.)
					SA2->A2_XSTEXO := "2"
				SA2->(MsUnlock())
			EndIf

			// Se tiver o campo
			If SA2->(FieldPos("A2_XINEXO")) > 0
				// Se integra com Flash Expense
				If SA2->A2_XINEXO == "1"
					// Integra Flash Expense
					U_EXONP09(SA2->(Recno()))
				EndIf
			EndIf
		EndIf
	EndIf

Return _xReturn
