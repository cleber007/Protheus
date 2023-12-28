#Include "RwMake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EFIBA15   ºAutor  ³Marcio              º Data ³  07/10/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Identificacao do fator de vencimento, extraido do codigo   º±±
±±º          ³ de barras ou da linha digitavel quando a modalidade for"31"º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EFIBA15()

_cRet := ""
_cCodBarr:= SE2->E2_DIGBARR //SE2->E2_CBARRA
_cDigBarr:= SE2->E2_DIGBARR
_cFatVenc:=""

//If SEA->EA_MODELO =="31"  .AND. SA2->A2_BANCO !="237"
IF !EMPTY(SE2->E2_DIGBARR)
	If !Empty(_cCodBarr)
		_cFatVenc := Substr(_cDigBarr,6,4)
	Else
		_cFatVenc := strzero(0,4)
    Endif
	_cRet := _cFatVenc
ELSE
	If !Empty(SE2->E2_LINDIGI)
		_cFatVenc := Substr(SE2->E2_LINDIGI,34,4)
	Else
		_cFatVenc := strzero(0,4)
    Endif
	_cRet := _cFatVenc
ENDIF 
Return(_cRet)