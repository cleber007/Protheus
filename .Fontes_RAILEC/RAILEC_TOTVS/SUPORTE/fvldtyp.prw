#include 'TOTVS.ch'
User Function fVldTyp(cGetP01)
	lRetVld := .F.
	If &(cGetP01)
		lRetVld := .T.
	EndIf

Return(lRetVld)
