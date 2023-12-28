#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} F090SE5
	(O ponto de entrada F090SE5 manipula movimentos banc�rios processados tendo como par�metro o Recno dos registros SE5 que foram utilizados na baixa autom�tica.)

	@type function
	@author Vitor Ribeiro - vitor.ribeiro@wikitec.com.br (Consultoria Wikitec)
	@since 07/06/2021

	@obs Documenta��o da totvs 
		https://tdn.totvs.com/pages/releaseview.action?pageId=145359875
	/*/
User Function F090SE5()

	// Fun��o para atualizar o status do Flash Expense de varios t�tulos de uma vez.
	// EXONP08V(c_Alias,a_Recnos,c_Status,c_Mensagem,l_LimpaCpo)
	U_EXONP08V("SE5",PARAMIXB[1],"5","Pagamento realizado.")

Return Nil
