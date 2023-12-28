#include "rwmake.ch"

User Function Rgpe004()

cArea   := Alias()
nInd    := IndexOrd()

cString := "SRA"
cDesc1  := OemToAnsi("Esta rotina ir  imprimir o Resumo de Pessoal, de")
cDesc2  := OemToAnsi("acordo com os parametros definidos p/ usuario.  ")
cDesc3  := ""
tamanho := "P"
limite  := 80
aOrd    := {}
aReturn := { "Zebrado", 1,"Financeiro", 2, 2, 1, "",1 }
nomeprog:= "RGPE004"
aLinha  := { }
nLastKey:= 0
Titulo  := "Resumo de Pessoal"

cCancel := "***** CANCELADO PELO OPERADOR *****"
cPerg   := ""
m_pag   := 1

wnrel   :="RGPE004"

//***************************************************** CARREGA TABELA TIPO DE FUNCOES
_n2REG:=0
DBSELECTAREA("SX5")
DBSEEK("  "+"RH")
WHILE !EOF() .AND. LEFT(X5_TABELA,2)="RH"
	_n2REG++
	DBSKIP()
ENDDO
_2CHAVE:=ARRAY(_n2REG)
_2DESCR:=ARRAY(_n2REG)
_2QTFUN:=ARRAY(_n2REG)

I:=1
DBSEEK("  "+"RH")
WHILE !EOF() .AND. LEFT(X5_TABELA,2)="RH"
	_2CHAVE[I]:=X5_CHAVE
	_2DESCR[I]:=X5_DESCRI
	_2QTFUN[I]:=0
	I++
	DBSKIP()
ENDDO
//**************************************************************************************

wnrel:= SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,tamanho)


If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

// INICIALIZA VARIAVEIS DE PARAMETROS (PERGUNTAS)

cFilDe  := "01"
cFilAte := "99"
cCustIni:= " "
cCustFim:= "ZZZZZZZZZ"
cSalario:= 2
cDocum  := 2


dbSelectArea("SRA")
DBSETORDER(12)
cRelato := " Por FUNCAO"


RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 15/02/01 ==> RptStatus({|| Execute(RptDetail) })

dbSelectArea( cArea )


dbSelectArea("SRA")
Retindex("SRA")

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

//Titulo := Titulo + cRelato
nReg   := 1
nTot   := 0
nLin   := 0
m_pag  := 1
_CAMPO:="Lotacao   "


//***************************************************** INICIA RELATORIO

DBSELECTAREA("Z0D")
DBSETORDER(2)      // TABELA DE FAIXAS SALARIAIS 

_nREG:=0
DBSELECTAREA("SRA")
SET FILTER TO RA_CC >= cCustIni .and. RA_CC <= cCustFim .AND. RA_SITFOLH$" AF" .AND. RA_SALARIO > 0 .AND. SRA->RA_CATFUNC=="M"
dbGoTop()


cCabec1 := ' '
cCabec2 := ' '


cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
nLinha := 6
TREG   :=0
T1     :=0
_MAT   :=""
_SAL   :="R$"

SetRegua(LastRec()) //Ajusta numero de elementos da regua de relatorios


@ nLinha,007 Psay   " Funcao               Tp Qtd   Matriculas"
nLinha := nLinha + 1
_FUNCOES:=""
While !Eof()
	
	IncRegua() //Incrementa a posicao da regua de relatorios
	wCC   :=RA_CODFUNC
	SRJ->(DBSEEK(xFILIAL("SRJ")+wCC))
	_CARGO:=SRJ->RJ_CARGO
	
	TREG := TREG + 1
	T1   := T1 + 1
	_MAT :=_MAT+RA_MAT+"/"
	IF !(STR(RA_SALARIO,08,2)$_SAL)
		_SAL :=_SAL+STR(RA_SALARIO,08,2)+"/"
	ENDIF
	dbSelectArea("SRA")
	dbSkip()
	
	IncRegua() //Incrementa a posicao da regua de relatorios
	
	
	IF RA_CODFUNC<>wCC .AND. T1 > 0
        DBSELECTAREA("Z0D")      // INCLUI A FUNCAO NA TABELA SALARIAL, CASO AINDA NAO EXISTA
        DBSEEK(xFilial("Z0D")+wCC)
        IF !FOUND()
           RECLOCK("Z0D",.T.)
           Z0D->Z0D_FILIAL:=xFilial("Z0D")
           Z0D->Z0D_CODFUN:=wCC
           Z0D->Z0D_DESC  :=SRJ->RJ_DESC
           MSUNLOCK()
        ENDIF
        DBSELECTAREA("SRA")
		_MAT1:=SUBSTR(_MAT,001,042)
		_MAT2:=ALLTRIM(SUBSTR(_MAT,043,042))
		_FUNCOES:=_FUNCOES+RA_CODFUNC+"/"
		
		@ nLinha,000 Psay LEFT((ALLTRIM(wCC)+"-"+SRJ->RJ_DESC),30)+"    "+SRJ->RJ_TIPO
		@ nLinha,032 PSAY STRZERO(T1,3)
		@ nLinha,038 PSAY _MAT1
		FOR I:=1 TO _n2REG
			IF _2CHAVE[I]=SRJ->RJ_TIPO
				_2QTFUN[I]:=_2QTFUN[I] + T1
				EXIT
			ENDIF
		NEXT I
		
		nLinha:=nLinha+1
		IF !EMPTY(_MAT2)
			@ nLinha,038 PSAY _MAT2
			nLinha:=nLinha+1
		ENDIF
		@ nLinha,007 PSAY "Carg:"+_CARGO
		@ nLinha,038 PSAY _SAL
		nLinha:=nLinha+1
		IF NLINHA>55
			cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
			nLinha := 6
		ENDIF
		T1  :=0
		_MAT:=""
		_SAL:="R$"
	ENDIF
	
End
@ nLinha,007 Psay "* TOTAL DE EMPREGADOS -> " + STRZERO(TREG,3)



nLinha:=nLinha+1
IF NLINHA>50
	cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
	nLinha := 6
ENDIF

FOR I:=1 TO _n2REG
	IF _2QTFUN[I] > 0
		@ nLinha,001 PSAY LEFT(_2CHAVE[I],2)
		@ nLinha,004 PSAY LEFT(_2DESCR[I],15)
		@ nLinha,021 PSAY _2QTFUN[I] PICTURE "9999"
        nLinha:=nLinha+1
		IF NLINHA>55
			cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
			nLinha := 6
		ENDIF
	ENDIF
NEXT I



nLinha:=nLinha+1
@ nLinha,000 PSAY __PrtThinLine()

cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
nLinha := 6
DBSELECTAREA("SRJ")
DBSETORDER(1)
DBGOTOP()
WHILE !EOF()
	IF !(RJ_FUNCAO$_FUNCOES)
		@ nLinha,000 PSAY RJ_FUNCAO
		@ nLinha,005 PSAY RJ_DESC
		@ nLINHA,032 PSAY "<== sem ocupante ..."
		nLinha:=nLinha+1
		IF NLINHA>55
			cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
			nLinha := 6
		ENDIF
	ENDIF
	DBSKIP()
ENDDO

DBSELECTAREA("Z0D")
DBSETORDER(1)      // TABELA DE FAIXAS SALARIAIS 
DBGOTOP()

DBSELECTAREA("SRA")
dbClearFilter()

If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return
