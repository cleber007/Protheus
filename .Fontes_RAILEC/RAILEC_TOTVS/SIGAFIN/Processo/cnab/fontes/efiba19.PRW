#Include "RwMake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EFIBA19     ºAutor  :  Marcio          º Data ³  07/10/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  ExecBlock utilizado para informar o campo de informacoes  º±±
±±º          ³  complementares no cnab a Pagar do Bradesco                º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EFIBA19()

_cRet := ""

If SEA->EA_MODELO =="01" 
	_cRet := SPACE(40)

Elseif SEA->EA_MODELO =="02"
	_cRet := SPACE(40)

Elseif SEA->EA_MODELO =="03"
	_cTipoDOC:=SE2->E2_TIPODOC
	_cFinDOC :=SE2->E2_FINDOC 
	_cRet :=_cTipoDOC+"000000"+_cFinDOC+SPACE(31)

Elseif SEA->EA_MODELO =="30"
	_cRet :=SPACE(40)

Elseif SEA->EA_MODELO =="31"
/*	IF !EMPTY(SE2->E2_CBARRA) 
		_cLivre :=Substr(SE2->E2_CBARRA,20,25)
		_cDigit :=Substr(SE2->E2_CBARRA,5,1)
		_cMoeda :=Substr(SE2->E2_CBARRA,4,1)
		_cRet :=_cLivre+_cDigit+_cMoeda+Space(13)
	ELSE */        
	IF !EMPTY(SE2->E2_DIGBARR)
		_cLivre :=Substr(SE2->E2_DIGBARR,20,25)
		_cDigit :=Substr(SE2->E2_DIGBARR,5,1)
		_cMoeda :=Substr(SE2->E2_DIGBARR,4,1)
		_cRet :=_cLivre+_cDigit+_cMoeda+Space(13)
    ELSEIF !EMPTY(SE2->E2_LINDIGI)
		_cLivre :=Substr(SE2->E2_LINDIGI,5,5)+Substr(SE2->E2_LINDIGI,11,10)+Substr(SE2->E2_LINDIGI,22,10)
		_cDigit :=Substr(SE2->E2_LINDIGI,33,1)
		_cMoeda :=Substr(SE2->E2_LINDIGI,4,1)
		_cRet :=_cLivre+_cDigit+_cMoeda+Space(13)
	ENDIF
Endif

Return(_cRet)
                                                                               