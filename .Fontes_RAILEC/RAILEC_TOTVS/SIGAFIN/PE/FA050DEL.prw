#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} FA050DEL
	(O ponto de entrada FA050DEL será executado logo após a confirmação da exclusão do título.)

	@type function
	@author Vitor Ribeiro - vitor.ribeiro@wikitec.com.br (Consultoria Wikitec)
	@since 03/03/2021

	@obs Documentação da totvs 
		https://tdn.totvs.com/pages/releaseview.action?pageId=6071105
	/*/
User Function FA050DEL()

	Local _lContinua := .T.
	
	If !Empty(SE2->E2_XDATINT)
		WK():MsgAlerta("O título já possui informe de pagamento! Por isso o mesmo não poderá ser deletado." + CRLF + CRLF + "Verifique.")
		_lContinua := .F.
	Else
		// Função para verificar se o título está vinculado ao sistema Flash Expense e atualiza o mesmo
		//U_EXONP08T(SE2->E2_FILIAL,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,"Título excluido.","9",.T.)
	EndIf

Return _lContinua
