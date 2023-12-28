#Include "RwMake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EFIBA10   ºAutor  ³Marcio              º Data ³  07/10/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Identificacao do digito da agencia para o Cnab a Pagar     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EFIBA10()

_cRet := ""

IF !EMPTY(SE2->E2_DIGBARR)
	If SEA->EA_MODELO == "31" .AND. alltrim(SE2->E2_DIGBARR) <> "" .AND. SUBSTR(SE2->E2_DIGBARR,1,3) <> "237"
		_cRet := "0"
		
	ELSEIf SEA->EA_MODELO == "31" .AND. SUBSTR(SE2->E2_DIGBARR,1,3) == "237"  // $ "001/237"
		_cRet := dIGvER()
	ELSEIf SEA->EA_MODELO <> "31" .AND. AllTrim(SE2->E2_DIGBARR) == ""
		_cRet := Sa2->a2_DIGAGEN
	Endif
ELSE
	If SEA->EA_MODELO == "31" .AND. alltrim(SE2->E2_LINDIGI) <> "" .AND. SUBSTR(SE2->E2_LINDIGI,1,3) <> "237"
		_cRet := "0"
		
	ELSEIf SEA->EA_MODELO == "31" .AND. SUBSTR(SE2->E2_LINDIGI,1,3) == "237"
		_cRet := dIGvER1()
	ELSEIf SEA->EA_MODELO <> "31" .AND. AllTrim(SE2->E2_LINDIGI) == ""
		_cRet := Sa2->a2_DIGAGEN
	Endif
	
ENDIF

Return(_cRet)


Static Function DIGVER()
Local _nSoma:= 0, _nLim := 0

_cMul := "5432" //Fator para achar DV
_nLim := 4
If alltrim(SE2->E2_DIGBARR) <> ""
	_cNum := SUBSTR(SE2->E2_DIGBARR,20,4)
Else
	_cNum := SUBSTR(SA2->A2_AGENCIA,1,4)
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
cDig := _cDigVer
Return(cDig)


Static Function DIGVER1()
Local _nSoma:= 0, _nLim := 0

_cMul := "5432" //Fator para achar DV
_nLim := 4
If alltrim(SE2->E2_LINDIGI) <> ""
	_cNum := SUBSTR(SE2->E2_LINDIGI,5,4)
Else
	_cNum := SUBSTR(SA2->A2_AGENCIA,1,4)
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
cDig := _cDigVer
Return(cDig)
