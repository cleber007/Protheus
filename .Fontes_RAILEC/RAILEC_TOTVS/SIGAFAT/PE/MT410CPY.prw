#include 'protheus.ch'
#include 'parmtype.ch'
#include "tbiconn.ch"
/*
*
*/
USER FUNCTION MT410CPY()

Local aArea := GetArea()
Local lRet := .T.
//Local nPosNUM    := GDFIELDPOS("C6_NUM")
Local nPosITEM   := GDFIELDPOS("C6_ITEM")
Local nPosPROD   := GDFIELDPOS("C6_PRODUTO")
Local nPosCONTRT := GDFIELDPOS("C6_CONTRT")
//Local nPosNUMORC := GDFIELDPOS("C6_NUMORC")

Local nx := 0

If nPosCONTRT <> 0  // .AND. nPosNUMORC <> 0  // Evandro Lima (Inovativa) - 01/02/20189 - Tirar essa inibição qdo o campo C6_NUMORC passar a constar no browser
	For nx := 1 To Len(aCols)
		
		aCols[nx][nPosCONTRT] := AllTrim(POSICIONE("SC6",1,xFilial("SC6")+SC5->C5_NUM+aCols[nx][nPosITEM]+aCols[nx][nPosPROD],"C6_CONTRT"))
//		aCols[nx][nPosNUMORC] := AllTrim(POSICIONE("SC6",1,xFilial("SC6")+SC5->C5_NUM+aCols[nx][nPosITEM]+aCols[nx][nPosPROD],"C6_NUMORC"))

	Next nx
EndIf

RestArea(aArea)

RETURN lRet
