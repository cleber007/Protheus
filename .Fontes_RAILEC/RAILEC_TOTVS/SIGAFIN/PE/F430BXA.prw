#Include "Protheus.ch"
#Include "RwMake.ch"

/*/{Protheus.doc} F430BXA
	(O ponto de entrada F430BXA tem como finalidade permitir a grava��o de complemento das baixas CNAB a pagar do retorno banc�rio.)

	@type function
	@author Vitor Ribeiro - vitor.ribeiro@wikitec.com.br (Consultoria Wikitec)
	@since 27/05/2021

	@obs Documenta��o da totvs 
		https://tdn.engpro.totvs.com.br/display/public/PROT/F430BXA+-+Grava+complemento+de+baixa
	/*/
User Function F430BXA()

	// Fun��o para verificar se o t�tulo est� vinculado ao sistema Flash Expense para atualizar o mesmo
	U_EXONP08T(SE5->E5_FILIAL,SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_TIPO,SE5->E5_CLIFOR,SE5->E5_LOJA,"Pagamento realizado.","5")

Return Nil
