#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} F340FCAN
	(Ponto de entrada permite grava��o de informa��o complementares no momento do estorno da compensa��o.)

	@type function
	@author Vitor Ribeiro - vitor.ribeiro@wikitec.com.br (Consultoria Wikitec)
	@since 03/03/2021

	@obs Documenta��o da totvs 
		https://tdn.totvs.com/display/public/PROT/DT_F340FCAN_Ponto_para_gravacoes_complementares
	/*/
User Function F340FCAN()

	// Fun��o para verificar se o t�tulo est� vinculado ao sistema Flash Expense e atualiza o mesmo
	//U_EXONP08T(SE5->E5_FILIAL,SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_TIPO,SE5->E5_CLIFOR,SE5->E5_LOJA,"Pagamento cancelado.","2")

Return Nil
