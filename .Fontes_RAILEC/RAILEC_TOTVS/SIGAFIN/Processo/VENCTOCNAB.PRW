#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"


User Function VENCTOCNAB() 

Local _cRetVencto := ""


If Empty(SE1->E1_VENCALT)
	_cRetVencto  := GravaData(SE1->E1_VENCTO,.F.)
Else
	_cRetVencto  := GravaData(SE1->E1_VENCALT,.F.)
EndIf


Return(_cRetVencto)
