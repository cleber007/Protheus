#Include "RwMake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EFIBA12   ºAutor  ³Marcio              º Data ³  07/10/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Identificacao do digito da conta corrente do fornecedor    º±±
±±º          ³ a ser utilizado no Cnab a Pagar                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EFIBA12()

_cRet := ""
IF !EMPTY(SE2->E2_DIGBARR)
	If SEA->EA_MODELO == "31".AND. SUBSTR(SE2->E2_DIGBARR,1,3) == "237"
		//	_cRet := SA2->A2_DIGCONT
		_cRet := digver()
		
	ELSEIf SEA->EA_MODELO == "31".AND. SUBSTR(SE2->E2_DIGBARR,1,3) <> "237"
		_cRet := "  "
	ElseIf SEA->EA_MODELO <> "31".AND. AllTrim(SE2->E2_DIGBARR) == ""
		//	_cRet := SA2->A2_DIGCONT
		_cRet := SA2->A2_DIGCONT
	Endif
ELSE
	If SEA->EA_MODELO == "31".AND. SUBSTR(SE2->E2_LINDIGI,1,3) == "237"
		//	_cRet := SA2->A2_DIGCONT
		_cRet := digver()
		
	ELSEIf SEA->EA_MODELO == "31".AND. SUBSTR(SE2->E2_LINDIGI,1,3) <> "237"
		_cRet := "  "
	ElseIf SEA->EA_MODELO <> "31".AND. AllTrim(SE2->E2_LINDIGI) == ""
		//	_cRet := SA2->A2_DIGCONT
		_cRet := SA2->A2_DIGCONT
	Endif
	
ENDIF
Return(_cRet)


Static Function DIGVER()
Local _nSoma:= 0, _nLim := 0
_cMul := "65432" //Fator para achar DV
_nLim := 5
If alltrim(SE2->E2_DIGBARR) <> ""
	_cNum :=SUBSTR(SE2->E2_DIGBARR,39,5)
Else
	_cNum :=SUBSTR(SA2->A2_NUMCON,1,5)
Endif
_c10  := "0"
_c11  := "0"
//Rotina para calculo do digito verificador
for i:= 1 to _nLim
	_nSoma :=  _nSoma + round(Val(Subs(_cNum,i,1))*Val(Subs(_cMul,i,1)),0)
Next
_nDigVer := int(round(_nSoma / 11,1))
_cDigVer := _nDigVer * 11
_nDigVer := _nSoma - _cDigVer
//IF AllTrim(BANCO) == "237"
_nDigVer := 11 - _nDigVer
//EndIf

If _nDigVer == 10
	_cDigVer := _c10
EndIF
If _nDigVer == 0 .Or. _nDigVer == 11
	_cDigVer := _c11
EndIF
If _nDigVer > 0 .and. _nDigVer < 10
	_cDigVer := alltrim(str(_nDigver))
Endif
cDig := _cDigVer //Modulo11(_NossoNum,2,9)
/*	CASE AllTrim(BANCO) == "237"
_cNum := "19"+_NossoNum
_nInd := 2
_nSoma:= 0
"1915580800022"
for i := 1 To Len(_cNum)
_nSoma += _nInd * Val(SubStr(_cNum, i, 1))
IF _nInd == 2
_nInd := 7
Else
_nInd--
EndIf
next i
cDig := IF((11 - Mod(_nSoma, 11)) == 10, "P", IF((11 - Mod(_nSoma, 11)) == 11,;
"0", Str(11 - Mod(_nSoma, 11),1)))
ENDCASE
*/
Return(cDig)
