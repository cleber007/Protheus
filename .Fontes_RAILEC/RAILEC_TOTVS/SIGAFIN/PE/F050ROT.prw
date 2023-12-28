#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} F050ROT
	(PE que permite modificar os itens de menu do browse de sele��o de t�tulos a pagar, por meio da edi��o da vari�vel aRotina (passada como par�metro no Ponto de Entrada).)

	@type function
	@author Vitor Ribeiro - vitor.ribeiro@wikitec.com.br (Consultoria Wikitec)
	@since 10/03/2021

	@obs Documenta��o da totvs
		 https://tdn.totvs.com/display/public/mp/F050ROT+-+Inclui+itens+de+menu+--+107531
	/*/
User Function F050ROT()

	Local _aRotina := PARAMIXB

	Aadd(_aRotina,{"Informe Pgto. do PA - Flash Expense","U_EXONA07(SE2->(Recno()))",0,8,0,.F.})

Return _aRotina
