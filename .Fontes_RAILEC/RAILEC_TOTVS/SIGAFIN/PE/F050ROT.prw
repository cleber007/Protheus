#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} F050ROT
	(PE que permite modificar os itens de menu do browse de seleção de títulos a pagar, por meio da edição da variável aRotina (passada como parâmetro no Ponto de Entrada).)

	@type function
	@author Vitor Ribeiro - vitor.ribeiro@wikitec.com.br (Consultoria Wikitec)
	@since 10/03/2021

	@obs Documentação da totvs
		 https://tdn.totvs.com/display/public/mp/F050ROT+-+Inclui+itens+de+menu+--+107531
	/*/
User Function F050ROT()

	Local _aRotina := PARAMIXB

	Aadd(_aRotina,{"Informe Pgto. do PA - Flash Expense","U_EXONA07(SE2->(Recno()))",0,8,0,.F.})

Return _aRotina
