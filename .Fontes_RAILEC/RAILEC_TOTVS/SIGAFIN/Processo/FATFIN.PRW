#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 15/02/01

User Function FATFIN()        // incluido pelo assistente de conversao do AP5 IDE em 15/02/01

cArea := Alias()
nInd  := IndexOrd()

cString := "SF2"
cDesc1  := OemToAnsi(" ")
cDesc2  := OemToAnsi(" ")
cDesc3  := ""
tamanho := "M"
aOrd    := {}
aReturn := { "Zebrado", 1,"Financeiro", 2, 2, 1, "",1 }
nomeprog:= "FATFIN"
aLinha  := { }
nLastKey:= 0

cCancel := "***** CANCELADO PELO OPERADOR *****"
cPerg   := "FATFIN"
m_pag   := 1
wnrel   := "FATFIN"

IF !(Pergunte(cPerg,.T.))
	RETURN Nil
ENDIF


//tamanho := "G"


Titulo  := "Relat Faturamento -> Financeiro: "+DTOC(MV_PAR01)+" a "+DTOC(MV_PAR02)
wnrel:= SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,tamanho)

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

DBSELECTAREA("SF2")
SET FILTER TO F2_TIPO$"CN" .AND. F2_EMISSAO>=MV_PAR01 .AND. F2_EMISSAO<=MV_PAR02
DBSETORDER(2)

RptStatus({|| RptDetail() })

DBSELECTAREA("SF2")
SET FILTER TO
DBSETORDER(1)
DBGOTOP()

dbSelectArea( cArea )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡„o ³Impressao do corpo do relatorio                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 15/02/01 ==> Function RptDetail
Static Function RptDetail()

cabec1 :="  Ser  N.Fisc       Val.Dupli  Cliente                      Dt.Emissao        *--------------- F I N A N C E I R O -------------*"
cabec2 :="                                                                              Dt. Vencim   Saldo a Rece       Recebido Dt.da Baix"

//        0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
//                  1         2         3         4         5         6         7         8         9         0         1         2         3
nLin   :=60
_sTT    :=0
_sTT2   :=0
_sTT3   :=0

_TT    :=0
_TT2   :=0
_TT3   :=0

DBSELECTAREA("SE5")
DBSETORDER(7)

DBSELECTAREA("SE1")
DBSETORDER(2)

DBSELECTAREA("SF2")
DBSETORDER(2)
DBGOTOP()
SetRegua(LastRec()) //Ajusta numero de elementos da regua de relatorios
WHILE !EOF()
	INCREGUA()
	
	IF nLin>55
		ImpCabec()
	ENDIF
	IF EMPTY(ALLTRIM(F2_DUPL))
		DBSKIP()
		Loop
	ENDIF
	IF !(F2_CLIENTE>=MV_PAR03 .AND. F2_CLIENTE<=MV_PAR04)
		DBSKIP()
		Loop
	ENDIF
	
	@ nLin,000 PSAY "|"
	@ nLin,002 PSAY F2_SERIE
	@ nLin,005 PSAY "|"
	@ nLIN,007 PSAY STRZERO(VAL(F2_DOC),6,0)  //F2_DOC
	@ nLin,013 PSAY "|"
	@ nLIN,015 PSAY F2_VALFAT PICTURE "@E 999,999,999.99"
	@ nLin,030 PSAY "|"
	@ nLIN,032 PSAY LEFT(SF2->F2_CLIENTE+"-"+POSICIONE("SA1",1,XFILIAL("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_NREDUZ"),25)
	@ nLIN,058 PSAY "|"
	@ nLIN,060 PSAY F2_EMISSAO
	@ nLIN,070 PSAY "|"
	
	_Msg:=""
	DBSELECTAREA("SE1")
	DBSEEK(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC)
	IF FOUND()
		WHILE !EOF() .AND. SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC = E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM
			@ nLIN,072 PSAY E1_PARCELA
			@ nLIN,074 PSAY E1_TIPO
			@ nLIN,078 PSAY E1_VENCREA
			@ nLIN,089 PSAY E1_SALDO PICTURE "@EZ 999,999,999.99"
			_TT2 :=_TT2  + E1_SALDO
			_sTT2:=_sTT2 + E1_SALDO
			IF E1_VENCREA<DDATABASE .AND. E1_SALDO > 0
				_Msg:="VENCIDO"
			ENDIF
			DBSELECTAREA("SE5")   // BAIXAS
			DBSEEK(xFILIAL("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE)
			IF FOUND()
				WHILE !EOF() .AND. SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE = E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR
					@ nLIN,104 PSAY IIF(E5_RECPAG="R",E5_VALOR,0-E5_VALOR) PICTURE "@EZ 999,999,999.99"
					@ nLIN,119 PSAY E5_DATA
					@ nLIN,130 PSAY SE5->E5_MOTBX
					_TT3 :=_TT3  + IIF(E5_RECPAG="R",E5_VALOR,0-E5_VALOR)
					_sTT3:=_sTT3 + IIF(E5_RECPAG="R",E5_VALOR,0-E5_VALOR)
					nLIN++
					DBSKIP()
				ENDDO
				nLIN--
			ENDIF
			
			DBSELECTAREA("SE1")
			IF !EMPTY(_MSG)
				@ nLIN,130 PSAY _MSG
			ENDIF
			nLIN++
			SE1->(DBSKIP())
		ENDDO
	ELSE
		nLIN++
	ENDIF
	
	DBSELECTAREA("SF2")
	_TT :=_TT  + F2_VALFAT
	_sTT:=_sTT + F2_VALFAT
	
	_CLIANTER:=F2_CLIENTE
	SF2->(DBSKIP())
	IF F2_CLIENTE#_CLIANTER .OR. EOF()
		@ nLin,000 PSAY "| .Sub-Total:"
		@ nLIN,015 PSAY _sTT  PICTURE "@E 999,999,999.99"
		@ nLIN,089 PSAY _sTT2 PICTURE "@E 999,999,999.99"
		@ nLIN,104 PSAY _sTT3 PICTURE "@EZ 999,999,999.99"
		@ nLIN,135 PSAY "|"
		_sTT:=_sTT2:=_sTT3:=0
		nLIN++
		nLIN++
	ENDIF
ENDDO

IF _sTT > 0
	@ nLin,000 PSAY "| .Sub-Total:"
	@ nLIN,015 PSAY _sTT  PICTURE "@E 999,999,999.99"
	@ nLIN,089 PSAY _sTT2 PICTURE "@E 999,999,999.99"
	@ nLIN,104 PSAY _sTT3 PICTURE "@EZ 999,999,999.99"
	@ nLIN,135 PSAY "|"
	nLIN++
	nLIN++
ENDIF


@ nLin,000 PSAY "|"
@ nLin,005 PSAY "|"
@ nLin,013 PSAY "|"
@ nLin,030 PSAY "|"
@ nLIN,058 PSAY "|"
@ nLIN,070 PSAY "|"
@ nLIN,135 PSAY "|"
nLIN++
@ nLin,000 PSAY "|"
@ nLIN,015 PSAY _TT  PICTURE "@E 999,999,999.99"
@ nLIN,089 PSAY _TT2 PICTURE "@E 999,999,999.99"
@ nLIN,104 PSAY _TT3 PICTURE "@EZ 999,999,999.99"
@ nLIN,135 PSAY "|"
nLIN++
@ nLiN,000 PSAY REPLICATE("-",136)

dbClearFilter()

SetPgEject(.F.)
If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

DBSELECTAREA("SE5")
DBSETORDER(1)
DBGOTOP()

DBSELECTAREA("SE1")
DBSETORDER(1)
DBGOTOP()

Return

*****************************************************************************

// Substituido pelo assistente de conversao do AP5 IDE em 15/02/01 ==> Function ImpCabec
Static Function ImpCabec()

@ 00,00  psay repl("*" ,136)
@ 01,00  psay "* " +ALLTRIM(sm0->m0_nome)+"/"+SM0->M0_FILIAL
@ 01,117 psay "Folha..:   "+strzero(m_Pag,6)+" *"
@ 02,00 psay "* SIGA/ "+nomeprog
@ 02,(136-len(titulo))/2 psay titulo
@ 02,117 psay "Dt.Ref.: "+ dtoc(dDataBase)+" *"
@ 03,00 psay "* Hora...: " + time()
@ 03,117 psay "Emissao: " + dtoc(date())+" *"
@ 04,00 psay repl("*",136)
@ 05,00 psay cabec1
@ 06,00 psay cabec2
@ 07,00 psay repl("*",136)
nLin := 8
m_Pag := m_Pag + 1
Return

