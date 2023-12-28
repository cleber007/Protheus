#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออหออออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ CXSoNumeros บ Autor ณ Cirilo Rocha     บ Data ณ 13/09/2011 บฑฑ
//ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออสออออออฯออออออออออออนฑฑ
//ฑฑบDescricao ณ Deixa apenas os caracteres numericos na string passada     บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบRetorno   ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุอออออออออออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบ   DATA   ณ Programador   ณ Manutencao Efetuada                        บฑฑ
//ฑฑฬออออออออออุอออออออออออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบ 18/04/12 ณ Cirilo Rocha  ณ Feito tratamento para aceitar tambem o ca- บฑฑ
//ฑฑบ          ณ               ณ ractere 'X' para os casos de agencia com X บฑฑ
//ฑฑบ          ณ               ณ                                            บฑฑ
//ฑฑบ          ณ               ณ                                            บฑฑ
//ฑฑบ          ณ               ณ                                            บฑฑ
//ฑฑบ          ณ               ณ                                            บฑฑ
//ฑฑศออออออออออฯอออออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function CXSoNumeros(cString,lDigitoX)

Local cChar := ""
Local nX    := 0
Local cRet	:= ''

Default lDigitoX	:= .F.

For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If IsDigit(cChar)
		cRet	+= cChar
	ElseIf lDigitoX .And. Upper(cChar) == 'X'
		cRet	+= 'X'
	Endif
Next nX

Return cRet
