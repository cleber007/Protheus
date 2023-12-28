#include "rwmake.ch"

User Function Rgpe003()

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
nomeprog:= "RGPE003"
aLinha  := { }
nLastKey:= 0
Titulo  := "Resumo de Pessoal"

cCancel := "***** CANCELADO PELO OPERADOR *****"
cPerg   := "GPE002"
m_pag   := 1

wnrel   :="RGPE002"

//IF !(Pergunte(cPerg,.T.))
//   RETURN Nil
//ENDIF   


wnrel:= SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,tamanho)


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
cRelato := " Por CARGO"


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


//***************************************************** CARREGA TABELA GRAU DE INSTRUÇÃO 
_nREG:=0

DBSELECTAREA("SRA")

SET FILTER TO RA_CC >= cCustIni .and. RA_CC <= cCustFim .AND. RA_SITFOLH$" AF" .AND. RA_SALARIO > 0 .AND. SRA->RA_CATFUNC=="M"
dbGoTop()

dbGoTop()
      

cCabec1 := ' '
cCabec2 := ' '


cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
nLinha := 6
TREG   :=0
T1     :=0
_MAT   :=""
SetRegua(LastRec()) //Ajusta numero de elementos da regua de relatorios


@ nLinha,007 Psay   " Cargo                   Qtd   Matriculas"
nLinha := nLinha + 1

While !Eof()
	
	IncRegua() //Incrementa a posicao da regua de relatorios
	wCC:=RA_CARGO
	wLO:=RA_CARGO
	SQ3->(DBSEEK(xFILIAL("SQ3")+wCC))

	TREG := TREG + 1
	T1   := T1 + 1
	_MAT :=_MAT+RA_MAT+"/"
	
	dbSelectArea("SRA")
	dbSkip()
	
	IncRegua() //Incrementa a posicao da regua de relatorios
	
	
	IF RA_CARGO<>wCC .AND. T1 > 0
        _MAT1:=SUBSTR(_MAT,001,042)
        _MAT2:=ALLTRIM(SUBSTR(_MAT,043,042))
        
		@ nLinha,000 Psay LEFT((ALLTRIM(wCC)+"-"+SQ3->Q3_DESCSUM),30)
		@ nLinha,032 PSAY STRZERO(T1,3)
        @ nLinha,038 PSAY _MAT1
		nLinha:=nLinha+1 
		IF !EMPTY(_MAT2)
           @ nLinha,038 PSAY _MAT2
		   nLinha:=nLinha+1 
		ENDIF
        IF NLINHA>55
           cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
           nLinha := 6
        ENDIF   
        T1  :=0
        _MAT:=""
	ENDIF
	
End
@ nLinha,007 Psay "* TOTAL DE EMPREGADOS -> " + STRZERO(TREG,3)

nLinha:=nLinha+1
@ nLinha,000 PSAY __PrtThinLine()
nLinha:=nLinha+1



DBSELECTAREA("SRA")
dbClearFilter()

If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return
