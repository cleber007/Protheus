#Include "Protheus.ch"
#Include "RwMake.ch"

/*/{Protheus.doc} CT030GRI
	(PE executado apos a gravacao da inclus�o do Centro de Custo. Utilizado para disparar a integra��o com o Flash Expense.)

	@type function
	@author Vitor Ribeiro - vitor.ribeiro@wikitec.com.br (Consultoria Wikitec)
	@since 29/06/2020

	@param a_Param, array, cont�m as informa��es da empresa e filial.

	@obs Documenta��o da totvs
		https://tdn.totvs.com/pages/releaseview.action?pageId=6068587
	/*/
User Function CT030GRI()

	// Se tiver o campo
	If CTT->(FieldPos("CTT_XINEXO")) > 0
		// Se integra com Flash Expense
		If CTT->CTT_XINEXO == "1"
			// Integra Flash Expense
			U_EXONP02(CTT->(Recno()))
		EndIf
	EndIf

Return Nil
