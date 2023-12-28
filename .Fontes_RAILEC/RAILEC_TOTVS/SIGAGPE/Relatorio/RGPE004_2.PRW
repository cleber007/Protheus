#include "rwmake.ch"

User Function Rgpe004_2()

cArea   := Alias()
nInd    := IndexOrd()

cString := "SRA"
cDesc1  := OemToAnsi("Esta rotina ir  imprimir o Resumo de Pessoal, de")
cDesc2  := OemToAnsi("acordo com os parametros definidos p/ usuario.  ")
cDesc3  := ""
tamanho := "M"
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





//+-----------------------------------------------------------+
//¦ CRIA ARQUIVO TEMPORARIO                                   ¦
//+-----------------------------------------------------------+
// Estrutura do Arquivo Temporario

aStru := {}
aadd(aStru , {'T_CODIG' ,'C', 10,0} )
aadd(aStru , {'T_DESCR' ,'C', 35,0} )
aadd(aStru , {'T_TOTFU' ,'N', 06,0} )
aadd(aStru , {'T_SALAR' ,'N', 12,2} )
aadd(aStru , {'T_ENCAR' ,'N', 12,2} )
aadd(aStru , {'T_TOTAL' ,'N', 12,2} )
aadd(aStru , {'T_MEDIA' ,'N', 12,2} )

cArqTemp := CriaTrab(aStru , .t.)

dbUseArea(.T.,,cArqTemp,'TMP',.f.)

DBSELECTAREA("TMP")

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



dbSelectArea("SRA")
DBSETORDER(12)
cRelato := " Por FUNCAO"

RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 15/02/01 ==> RptStatus({|| Execute(RptDetail) })

dbSelectArea( cArea )

dbSelectArea("SRA")
DBSETORDER(1)
DBGOTOP()

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

DBSELECTAREA("SRJ")
DBSETORDER(1)

DBSELECTAREA("SRA")
SET FILTER TO RA_SITFOLH$" AF" .AND. RA_SALARIO > 0
DBSETORDER(12)
dbGoTop()


cCabec1 := ' '
cCabec2 := ' '


cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
nLinha := 6
TREG   :=0
T1     :=0
_SAL   :=0

SetRegua(LastRec()) //Ajusta numero de elementos da regua de relatorios

@ nLinha,007 Psay   "Funcao"
@ nLinha,041 Psay   "Quanti"
@ nLinha,048 Psay   "    Salarios"
@ nLinha,061 Psay   "  Encargos"
@ nLinha,072 Psay   "       Total"
@ nLinha,085 Psay   "     Media                  ADMINISTRATIVOS"

DBSELECTAREA("TMP")
RECLOCK("TMP",.T.)
T_DESCR:="ADMINISTRATIVOS"
MSUNLOCK()
DBSELECTAREA("SRA")

nLinha := nLinha + 1
While !Eof()
	IncRegua() //Incrementa a posicao da regua de relatorios
	
	wCODFUNC :=RA_CODFUNC
	DBSELECTAREA("SRJ")
	DBSEEK(xFilial("SRJ")+wCODFUNC)
	DBSELECTAREA("SRA")
	
	IF !ALLTRIM(SRJ->RJ_TIPO)$"01/03/05"
		dbskip()
		LOOP
	ENDIF
	DBSELECTAREA("SRA")
	WHILE !EOF() .AND. SRA->RA_CODFUNC = wCODFUNC
		TREG := TREG + 1
		T1   := T1 + 1
		_SAL :=_SAL+RA_SALARIO
		DBSKIP()
	ENDDO
	
	IF  T1 > 0
		@ nLinha,000 Psay wCODFUNC
		@ nLINHA,005 PSAY LEFT(SRJ->RJ_DESC,35)
		@ nLinha,041 PSAY T1   PICTURE "999999"
		@ nLinha,048 PSAY _SAL                   PICTURE "@E 9,999,999.99"
		@ nLinha,061 PSAY _SAL*0.368             PICTURE "@E 999,999.99"
		@ nLinha,072 PSAY _SAL+(_SAL*0.368)      PICTURE "@E 9,999,999.99"
		@ nLinha,085 PSAY (_SAL+(_SAL*0.368))/T1 PICTURE "@E 999,999.99"
		
        DBSELECTAREA("TMP")
        RECLOCK("TMP",.T.)
        T_CODIG:=wCODFUNC
        T_DESCR:=LEFT(SRJ->RJ_DESC,35)
        T_TOTFU:=T1
        T_SALAR:=_SAL
        T_ENCAR:=_SAL*0.368
        T_TOTAL:=_SAL+(_SAL*0.368)
        T_MEDIA:=(_SAL+(_SAL*0.368))/T1
        MSUNLOCK()

		nLINHA++
		T1  :=0
		_SAL:=0

	ENDIF
	IF NLINHA>55
		cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
		nLinha := 6
	ENDIF
	DBSELECTAREA("SRA")
EndDO

nLinha:=nLinha+1
@ nLinha,000 PSAY __PrtThinLine()
nLinha:=nLinha+1

@ nLinha,007 Psay "* TOTAL DE EMPREGADOS -> " + STRZERO(TREG,3)
TREG :=0
//**************************************************************************************************
DBSELECTAREA("SRA")
DBGOTOP()

cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
nLinha := 6
T1     :=0
_SAL   :=0

SetRegua(LastRec()) //Ajusta numero de elementos da regua de relatorios

@ nLinha,007 Psay   "Funcao"
@ nLinha,041 Psay   "Quanti"
@ nLinha,048 Psay   "    Salarios"
@ nLinha,061 Psay   "  Encargos"
@ nLinha,072 Psay   "       Total"
@ nLinha,085 Psay   "     Media                  OPERACIONAIS  < 10 ANOS"

DBSELECTAREA("TMP")
RECLOCK("TMP",.T.)
T_DESCR:="OPERACIONAIS  < 10 ANOS"
MSUNLOCK()
DBSELECTAREA("SRA")

nLinha := nLinha + 1
While !Eof()
	IncRegua() //Incrementa a posicao da regua de relatorios
	
	wCODFUNC :=RA_CODFUNC
	DBSELECTAREA("SRJ")
	DBSEEK(xFilial("SRJ")+wCODFUNC)
	DBSELECTAREA("SRA")
	
	IF !ALLTRIM(SRJ->RJ_TIPO)$"02/04"
		DBSKIP()
		Loop
	ENDIF
	IF !(DDATABASE-SRA->RA_ADMISSA < (365*10))
		DBSKIP()
		Loop
	ENDIF
	
	WHILE !EOF() .AND. SRA->RA_CODFUNC = wCODFUNC
		TREG := TREG + 1
		T1   := T1 + 1
		_SAL :=_SAL+RA_SALARIO
		DBSKIP()
	ENDDO
	
	IF  T1 > 0
		@ nLinha,000 Psay wCODFUNC
		@ nLINHA,005 PSAY LEFT(SRJ->RJ_DESC,35)
		@ nLinha,041 PSAY T1   PICTURE "999999"
		@ nLinha,048 PSAY _SAL                   PICTURE "@E 9,999,999.99"
		@ nLinha,061 PSAY _SAL*0.368             PICTURE "@E 999,999.99"
		@ nLinha,072 PSAY _SAL+(_SAL*0.368)      PICTURE "@E 9,999,999.99"
		@ nLinha,085 PSAY (_SAL+(_SAL*0.368))/T1 PICTURE "@E 999,999.99"

        DBSELECTAREA("TMP")
        RECLOCK("TMP",.T.)
        T_CODIG:=wCODFUNC
        T_DESCR:=LEFT(SRJ->RJ_DESC,35)
        T_TOTFU:=T1
        T_SALAR:=_SAL
        T_ENCAR:=_SAL*0.368
        T_TOTAL:=_SAL+(_SAL*0.368)
        T_MEDIA:=(_SAL+(_SAL*0.368))/T1
        MSUNLOCK()
		
		nLINHA++
		T1  :=0
		_SAL:=0
	ENDIF
	IF NLINHA>55
		cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
		nLinha := 6
	ENDIF
	DBSELECTAREA("SRA")
EndDO

nLinha:=nLinha+1
@ nLinha,000 PSAY __PrtThinLine()
nLinha:=nLinha+1

@ nLinha,007 Psay "* TOTAL DE EMPREGADOS -> " + STRZERO(TREG,3)
TREG :=0


DBSELECTAREA("SRA")
DBGOTOP()

cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
nLinha := 6
T1     :=0
_SAL   :=0

SetRegua(LastRec()) //Ajusta numero de elementos da regua de relatorios

@ nLinha,007 Psay   "Funcao"
@ nLinha,041 Psay   "Quanti"
@ nLinha,048 Psay   "    Salarios"
@ nLinha,061 Psay   "  Encargos"
@ nLinha,072 Psay   "       Total"
@ nLinha,085 Psay   "     Media                  OPERACIONAIS  >= 10 ANOS"

DBSELECTAREA("TMP")
RECLOCK("TMP",.T.)
T_DESCR:="OPERACIONAIS  >= 10 ANOS"
MSUNLOCK()
DBSELECTAREA("SRA")

nLinha := nLinha + 1
While !Eof()
	IncRegua() //Incrementa a posicao da regua de relatorios
	
	wCODFUNC :=RA_CODFUNC
	DBSELECTAREA("SRJ")
	DBSEEK(xFilial("SRJ")+wCODFUNC)
	DBSELECTAREA("SRA")
	
	IF !ALLTRIM(SRJ->RJ_TIPO)$"02/04"
		DBSKIP()
		Loop
	ENDIF
	IF !(DDATABASE-SRA->RA_ADMISSA >= (365*10))
		DBSKIP()
		Loop
	ENDIF
	
	WHILE !EOF() .AND. SRA->RA_CODFUNC = wCODFUNC
		TREG := TREG + 1
		T1   := T1 + 1
		_SAL :=_SAL+RA_SALARIO
		DBSKIP()
	ENDDO
	
	IF  T1 > 0
		@ nLinha,000 Psay wCODFUNC
		@ nLINHA,005 PSAY LEFT(SRJ->RJ_DESC,35)
		@ nLinha,041 PSAY T1   PICTURE "999999"
		@ nLinha,048 PSAY _SAL                   PICTURE "@E 9,999,999.99"
		@ nLinha,061 PSAY _SAL*0.368             PICTURE "@E 999,999.99"
		@ nLinha,072 PSAY _SAL+(_SAL*0.368)      PICTURE "@E 9,999,999.99"
		@ nLinha,085 PSAY (_SAL+(_SAL*0.368))/T1 PICTURE "@E 999,999.99"

        DBSELECTAREA("TMP")
        RECLOCK("TMP",.T.)
        T_CODIG:=wCODFUNC
        T_DESCR:=LEFT(SRJ->RJ_DESC,35)
        T_TOTFU:=T1
        T_SALAR:=_SAL
        T_ENCAR:=_SAL*0.368
        T_TOTAL:=_SAL+(_SAL*0.368)
        T_MEDIA:=(_SAL+(_SAL*0.368))/T1
        MSUNLOCK()
		
		nLINHA++
		T1  :=0
		_SAL:=0
	ENDIF
	IF NLINHA>55
		cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
		nLinha := 6
	ENDIF
	DBSELECTAREA("SRA")
EndDO

nLinha:=nLinha+1
@ nLinha,000 PSAY __PrtThinLine()
nLinha:=nLinha+1

@ nLinha,007 Psay "* TOTAL DE EMPREGADOS -> " + STRZERO(TREG,3)
TREG :=0

If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

//*********************************************************************************
_GeraXls:=1
@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Gera Planilha Excel ?"
@ 10, 49 SAY "1 - Nao"
@ 22, 49 SAY "2 - Sim"
@ 44, 49 GET _GeraXls PICTURE "99"
@ 60, 90 BmpButton Type 1 Action Close(oDlg2)
Activate Dialog oDlg2 Centered
IF _GeraXls=2
	DBSELECTAREA("TMP")
	DBGOTOP()
//	COPY TO RANKFT.DBF
	_cArqRen:="\SYSTEM\TEMPDBF\RANKFT.DBF"
	Copy to &_cArqRen VIA "DBFCDXADS" 
	_arquivo:="G:\SYSTEM\TEMPDBF\RANKFT.DBF"
	If !File(_arquivo)
		_arquivo:="F:\SYSTEM\TEMPDBF\RANKFT.DBF"
	EndIf
	
	If ! ApOleClient( 'MsExcel' )
		MsgStop( 'Excel não instalado' )
	ELSE
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( _arquivo )
		oExcelApp:SetVisible(.T.)
	ENDIF
	
ENDIF

dbSelectArea('TMP')
dbCloseArea()
cArqTemp2 := cArqTemp + '.DTC'
Delete File &cArqTemp2
//cArqTemp3 := cArqTemp + '.CDX'
//Delete File &cArqTemp3

DBSELECTAREA("SRA")
dbClearFilter()
DBSETORDER(1)
DBGOTOP()


Return
