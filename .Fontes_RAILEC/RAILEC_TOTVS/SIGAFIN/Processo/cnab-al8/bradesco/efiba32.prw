#include "rwmake.ch"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Execblock ³ EFIBA32  ³ Autor ³ Jaime Wikanski         ³ Data ³ 22.02.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Apura o valor do titulo a ser gravado no CNAB considerendo  ³±±
±±³          ³ o valor de titulos do tipo AB-.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CNAB A PAGAR.                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado  ³ Colocado o campo valor do boleto Aguiar 16/04/04            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function EFIBA32(_nOp)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva Integridade dos Dados             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cAlias  := Alias()
_nOrder  := IndexOrd()
_nReg    := Recno()

//_nVlPago := _nVlTit - SE2->E2_SALDO
_nVlOri  := SE2->E2_VALOR
_nVlTit  := Iif(SE2->E2_VALBOL = 0,SE2->E2_SALDO,SE2->E2_VALBOL)



IF !EMPTY(SE2->E2_DIGBARR)
	IF SE2->E2_ACRESC >0 .OR. SE2->E2_DECRESC > 0  .or. empty(SE2->E2_DIGBARR)
		_nValDoc := SE2->E2_SALDO * 100
	ELSE
		_nValDoc := Iif(Val(Substr(SE2->E2_DIGBARR,10,10))>=0,Val(Substr(SE2->E2_DIGBARR,10,10)),0)
		if _nValDoc == 0
			_nValDoc := SE2->E2_SALDO * 100
		endif
	ENDIF
ELSE
	IF SE2->E2_ACRESC >0 .OR. SE2->E2_DECRESC > 0  .or. ( empty(SE2->E2_DIGBARR) .AND. EMPTY(SE2->E2_LINDIGI) )
		_nValDoc := SE2->E2_SALDO * 100
	ELSE
		_nValDoc := Iif(Val(Substr(SE2->E2_LINDIGI,38,10))>=0,Val(Substr(SE2->E2_LINDIGI,38,10)),0)
		if _nValDoc == 0
			_nValDoc := SE2->E2_SALDO * 100
		endif
	ENDIF	
ENDIF    

_nReturn := 0.00
_nAbat   := SE2->E2_DECRESC
_nAcresc := SE2->E2_ACRESC

If _nOp == 1
	_nReturn := _nAbat * 100
ElseIf _nOp == 2
	_nReturn := _nVlTit * 100
ElseIf _nOp == 3
	_nReturn := _nAcresc * 100
ElseIf _nOp == 4
	_nReturn := _nAcresc * 100
ElseIf _nOp == 5
	_nReturn := _nValDoc
	
Endif

dbSelectArea(_cAlias)
dbSetOrder(_nOrder)
DbGoto(_nReg)

Return(_nReturn)
