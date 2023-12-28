#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} F50PERGUNT
	(O ponto de entrada: F50PERGUNT permite alterar a configura��o dos perguntes via rotina autom�tica - ExecAuto.)

	@type function
	@author Vitor Ribeiro - vitor.ribeiro@wikitec.com.br (Consultoria Wikitec)
	@since 10/03/2021

	@obs Documenta��o da totvs
		https://tdn.totvs.com/pages/releaseview.action?pageId=203752262
	/*/
User Function F50PERGUNT()

	// Se existe a fun��o FINA050_CLASS
	If FindFunction("U_FINA050_CLASS")
		// Fun��o para ajustar o pergunte se for executado pelo objeto FINA050_CLASS
		U_FINA050_CLASS("F50PERGUNT")
	EndIf

Return Nil
