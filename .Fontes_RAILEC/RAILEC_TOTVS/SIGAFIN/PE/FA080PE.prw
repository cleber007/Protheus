#Include "Protheus.ch"
#Include "RwMake.ch"

/*/{Protheus.doc} FA080PE
	(O ponto de entrada FA080PE sera executado na saida da funcao de baixa, apos gravar todos os dados e ap�s a contabiliza��o.)

	@type function
	@author Vitor Ribeiro - vitor.ribeiro@wikitec.com.br (Consultoria Wikitec)
	@since 10/09/2020

	@obs Documenta��o da totvs 
		https://tdn.totvs.com/pages/releaseview.action?pageId=6071145
	/*/
User Function FA080PE()

	// Fun��o para verificar se o t�tulo est� vinculado ao sistema Flash Expense e atualiza o mesmo
	U_EXONP08T(SE5->E5_FILIAL,SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_TIPO,SE5->E5_CLIFOR,SE5->E5_LOJA,"Pagamento realizado.","5")

Return Nil
