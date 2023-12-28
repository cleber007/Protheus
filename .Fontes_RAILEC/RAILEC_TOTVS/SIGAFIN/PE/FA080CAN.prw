#Include "Protheus.ch"
#Include "RwMake.ch"

/*/{Protheus.doc} FA080CAN
	(O ponto de entrada FA080CAN sera executado no cancelamento de baixas do contas a pagar, apos gravar os dados no SE2 e antes de grava-los no SE5.)

	@type function
	@author Vitor Ribeiro - vitor.ribeiro@wikitec.com.br (Consultoria Wikitec)
	@since 10/09/2020

	@obs Documentação da totvs 
		https://tdn.totvs.com/display/public/mp/FA080CAN+-+Cancela+baixas+a+receber+--+11886
	/*/
User Function FA080CAN()

	// Função para verificar se o título está vinculado ao sistema Flash Expense e atualiza o mesmo
	//U_EXONP08T(SE5->E5_FILIAL,SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_TIPO,SE5->E5_CLIFOR,SE5->E5_LOJA,"Pagamento cancelado.","2")

Return Nil
