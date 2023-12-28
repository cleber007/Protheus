#Include "Protheus.ch"
#Include "RwMake.ch"

/*/{Protheus.doc} CTA040TOK
	(O ponto de entrada valida pr�via exist�ncia do Item Cont�bil.)

	@type function
	@author Vitor Ribeiro - vitor.ribeiro@wikitec.com.br (Consultoria Wikitec)
	@since 16/02/2023

	@param PARAMIXB, numerico, numero da op��o

	@obs Documenta��o da totvs
		https://tdn.totvs.com/pages/releaseview.action?pageId=6068710
	/*/
User Function CTA040TOK()

	Local _lContinua := .F.

	// Se for inclus�o ou altera��o
	If AllTrim(Str(PARAMIXB)) $ "34"
		// verifica se pode continuar
		_lContinua := !U_EXONP09A("CTD_XINEXO")
	EndIf

Return _lContinua
