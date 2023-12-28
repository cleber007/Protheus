#Include "RwMake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EFIBA14   ºAutor  ³Marcio              º Data ³  07/10/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Identificacao do codigo do nosso numero, extraido do codigoº±±
±±º          ³ de barras ou da linha digitavel quando o banco for "237"   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EFIBA14()

_cRet := ""
_cDigBarr:= SE2->E2_DIGBARR
_cNossoNum:=""
IF !EMPTY(SE2->E2_DIGBARR)
	If SEA->EA_MODELO =="31" .AND. SA2->A2_BANCO =="237"
		if !Empty(_cDigBarr)
			_cNossoNum := Substr(SE2->E2_DIGBARR,26,11) //Substr(SE2->E2_DIGBARR,12,09)+Substr(SE2->E2_DIGBARR,22,02)
		Endif
		_cRet := Strzero(Val(_cNossoNum),12)
	Else
		_cRet := Replicate("0",12)
		
	Endif
ELSE
	If SEA->EA_MODELO =="31" .AND. SA2->A2_BANCO =="237"
		if !Empty(SE2->E2_LINDIGI)
			_cNossoNum := Substr(SE2->E2_LINDIGI,12,11) //Substr(SE2->E2_DIGBARR,12,09)+Substr(SE2->E2_DIGBARR,22,02)
		Endif
		_cRet := Strzero(Val(_cNossoNum),12)
	Else
		_cRet := Replicate("0",12)
		
	Endif
	
ENDIF

Return(_cRet)
