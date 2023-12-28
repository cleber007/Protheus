#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"
#Include "FWMVCDef.ch"

/*/{Protheus.doc} ITEM
	(PE do produto (MATA010) em MVC)

	@type function
	@author Vitor Ribeiro - vitor.ribeiro@wikitec.com.br (Consultoria Wikitec)
	@since 29/06/2020

	@param a_Param, array, contém as informações do MVC

	@obs Documentação da totvs
		https://centraldeatendimento.totvs.com/hc/pt-br/articles/360016405952-MP-ADVPL-Ponto-de-entrada-MVC-para-as-rotinas-MATA010-MATA020-e-MATA030
	/*/
User Function ITEM()

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
		// Se tiver a integração do produto com Flash Expense
		If WK_Generico():GetConteudo("EXON_PARAM_INTEGRACA","INCATE","") == "SB1"
			// Se tiver o campo
			If SB1->(FieldPos("B1_XSTEXO")) > 0
				RecLock("SB1",.F.)
					SB1->B1_XSTEXO := "2"
				SB1->(MsUnlock())
			EndIf

			// Se tiver o campo
			If SB1->(FieldPos("B1_XINEXO")) > 0
				// Se integra com Flash Expense
				If SB1->B1_XINEXO == "1"
					// Integra Flash Expense
					U_EXONP10(SB1->(Recno()))
				EndIf
			EndIf
		EndIf
	EndIf

Return _xReturn
