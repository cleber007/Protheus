#Include "Protheus.ch"
#Include "RwMake.ch"

/*/{Protheus.doc} CT030GRA
	(PE executado apos a gravacao da alteração do Centro de Custo. Utilizado para disparar a integração com o Flash Expense)

	@type function
	@author Vitor Ribeiro - vitor.ribeiro@wikitec.com.br (Consultoria Wikitec)
	@since 29/06/2020

    @param a_Param, array, contém as informações da empresa e filial.

	@obs Documentação da totvs
		https://tdn.totvs.com/display/public/PROT/CT030GRA+-+Tabelas+SI3+e+CTT+--+10933
	/*/
User Function CT030GRA()

	// Se tiver o campo
	If CTT->(FieldPos("CTT_XSTEXO")) > 0
		RecLock("CTT",.F.)
			CTT->CTT_XSTEXO := "2"
		CTT->(MsUnlock())
	EndIf

	// Se tiver o campo
	If CTT->(FieldPos("CTT_XINEXO")) > 0
		// Se integra com Flash Expense
		If CTT->CTT_XINEXO == "1"
			// Integra Flash Expense
			U_EXONP02(CTT->(Recno()))
		EndIf
	EndIf

Return Nil
