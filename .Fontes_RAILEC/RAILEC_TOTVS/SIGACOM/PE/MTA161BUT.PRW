#Include 'Protheus.ch'

User Function MTA161BUT()

Local aRotina:= PARAMIXB[1]

//Local aAcoes:= { }

AAdd( aRotina, { "Imprime Cotação ", "U_ImpCot(SC8->C8_NUM)", 0, 3, 0, Nil } )	//--> Adicionando opcao no menu 

Return (aRotina)
