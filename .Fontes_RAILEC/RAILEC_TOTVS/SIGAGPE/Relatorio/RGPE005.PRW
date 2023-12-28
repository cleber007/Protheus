#include "rwmake.ch"

User Function Rgpe005()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CAREA,NIND,CSTRING,CDESC1,CDESC2,CDESC3")
SetPrvt("TAMANHO,AORD,ARETURN,NOMEPROG,ALINHA,NLASTKEY")
SetPrvt("TITULO,CCANCEL,CPERG,M_PAG,WNREL,CFILDE")
SetPrvt("CFILATE,CCUSTINI,CCUSTFIM,CSALARIO")
SetPrvt("CRELATO,NREG,NTOT,NLIN,CABEC1,WCC")
SetPrvt("WLO,WFERIAS,TSALARIO,T2,TT2")
SetPrvt("WDSIT,TREG,WT_EXPA,WT_MENS,WT_EST,WT_COOR,wT_MASC,wT_FEM")
SetPrvt("T1,WRR,")


cArea   := Alias()
nInd    := IndexOrd()

cString := "SRA"
cDesc1  := OemToAnsi("Esta rotina ir  imprimir o Resumo de Pessoal, de")
cDesc2  := OemToAnsi("acordo com os parametros definidos p/ usuario.  ")
cDesc3  := ""
tamanho := "G"
limite  := 80
aOrd    := {}
aReturn := { "Zebrado", 1,"Financeiro", 2, 2, 1, "",1 }
nomeprog:= "RGPE005"
aLinha  := { }
nLastKey:= 0
Titulo  := "Resumo de Pessoal"

cCancel := "***** CANCELADO PELO OPERADOR *****"
cPerg   := "" //"GPE002"
m_pag   := 1

wnrel   :="RGPE005"


// INICIALIZA VARIAVEIS DE PARAMETROS (PERGUNTAS)

cFilDe  := "01"
cFilAte := "99"
cCustIni:= " "
cCustFim:= "ZZZZZZZZZ"
cSalario:= 2
cDocum  := 2
_percinss:=0.288
_percfgts:=0.080

_REM     :="B"
_ANOMES  :=LEFT(DTOS(DDATABASE),6)
_VERBAREM:=POSICIONE("SRV",2,XFILIAL("SRV")+"0017","RV_COD")
_ANASIN  :="S"

@ 1,1 to  200,400 DIALOG oDlg2 TITLE "PARAMETROS DE CALCULO"
@ 10, 05 SAY "Sal. Base ou Total ?"
@ 10, 55 GET _REM  PICTURE "!" VALID _REM$"BT"
@ 20, 05 SAY "Ano Mes ?"
@ 20, 55 GET _ANOMES  SIZE 25,12
@ 30, 05 SAY "Sint ou Analitico ?"
@ 30, 55 GET _ANASIN  PICTURE "!" VALID _ANASIN$"SA"

@ 70, 95 BmpButton Type 1 Action Close(oDlg2)
Activate Dialog oDlg2 Centered

// INICIALIZA VARIAVEIS DE PARAMETROS (PERGUNTAS) : END



wnrel:= SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif


dbSelectArea("SRA")
DBSETORDER(8)
cRelato := " Por CCusto / Alfabetica"

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



// Estrutura do Arquivo Temporario
aStru := {}
aadd(aStru , {'TMP_CCU' ,'C', 09,0} )
aadd(aStru , {'TMP_DESCCC' ,'C', 35,0} )
aadd(aStru , {'TMP_FUN' ,'C', 06,0} )
aadd(aStru , {'TMP_DES' ,'C', 30,0} )
aadd(aStru , {'TMP_NFU' ,'N', 06,0} )
aadd(aStru , {'TMP_SAL' ,'N', 14,2} )
aadd(aStru , {'TMP_MATR' ,'C', 06,0} )
IF _ANASIN="A"
   aadd(aStru , {'TMP_NOME' ,'C', 40,0} )
   aadd(aStru , {'TMP_ADM'  ,'C', 10,0} )
   aadd(aStru , {'TMP_SIT'  ,'C', 01,0} )
ENDIF

cArqTemp := CriaTrab(aStru , .t.)

dbUseArea(.T.,,cArqTemp,'TMP',.f.)

DBSELECTAREA("TMP")
INDEX ON TMP_CCU+TMP_FUN+TMP_MATR  TO &cArqTemp

//******************************************************************
DBSELECTAREA("SRD")
DBSETORDER(1)

DBSELECTAREA("SRA")
SET FILTER TO RA_CC >= cCustIni .and. RA_CC <= cCustFim .AND. RA_SITFOLH$" AF" .AND. RA_SALARIO > 0 .AND. SRA->RA_CATFUNC#"A"
dbGoTop()

_BASESEGVIDA:=0
_FATOR      :=0 //0.03389 //0.0144

_QTDFUNC    :=0
TVAL        :=0
WHILE !EOF()
    _SALARIO:=0	
    IF _REM="B"
       _SALARIO:=SRA->RA_SALARIO
      ELSE
       DBSELECTAREA("SRD")
       DBSEEK(xFilial("SRD")+SRA->RA_MAT+_ANOMES+_VERBAREM) // BASE FGTS ID 0017
       IF FOUND()
          _SALARIO:=RD_VALOR
       ENDIF         
	   DBSELECTAREA("TMP")
    ENDIF
	_QTDFUNC++
	TVAL := TVAL + SRA->RA_SALARIO
	DBSELECTAREA("TMP")
	DBSEEK(SRA->RA_CC+SRA->RA_CODFUNC)
	IF !FOUND()
		RECLOCK("TMP",.T.)
		TMP_CCU   :=SRA->RA_CC
		TMP_FUN   :=SRA->RA_CODFUNC
		TMP_DESCCC:=Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01")
		TMP_DES   :=POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")
	ELSE
		RECLOCK("TMP",.F.)
	ENDIF
	TMP_NFU:=TMP_NFU + 1
	TMP_SAL:=TMP_SAL + _SALARIO
	MSUNLOCK()
    IF _ANASIN="A"
		RECLOCK("TMP",.T.)
		TMP_CCU   :=SRA->RA_CC
		TMP_FUN   :=SRA->RA_CODFUNC
		TMP_MATR  :=SRA->RA_MAT
		TMP_DESCCC:=Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01")
		TMP_DES   :=POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")
		TMP_NOME  :=SRA->RA_NOME
	    TMP_NFU   := 1
	    TMP_SAL   := _SALARIO
		TMP_ADM   :=DTOC(SRA->RA_ADMISSA)
		TMP_SIT   :=SRA->RA_SITFOLH
	    MSUNLOCK()
    ENDIF
	DBSELECTAREA("SRA")
	DBSKIP()
ENDDO

dbGoTop()


cCabec1 := ' '
cCabec2 := ' '


cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
nLinha := 6

SetRegua(LastRec()) //Ajusta numero de elementos da regua de relatorios

Store 0 to  TSALARIO,T1,S1,T2,wT_EXPA,wT_MENS,wT_EST,wT_COOR,TT2,wT_Masc,wT_Fem

_TSVG:=0
aRESUMO := {}

//*************************************************************************************** I M P R I M E
IF _REM="B"
   @ nLinha,007 Psay " Centro de Custo         Qtd  Percent  Salario Base      Media"
  ELSE
   @ nLinha,007 Psay " Centro de Custo         Qtd  Percent  Remun. Total      Media"
ENDIF   
nLinha := nLinha + 1
_xTTREM:=0

DBSELECTAREA("CTT")
DBSETORDER(1)
DBGOTOP()

DBSELECTAREA("SRA")
DBGOTOP()
While !Eof()
	IncRegua() //Incrementa a posicao da regua de relatorios
	
	wCC:=RA_CC
	wLO:=RA_CC
	_DESCCC:=Posicione("CTT",1,xFilial("CTT")+wCC,"CTT_DESC01")
	T1   := T1   + 1                // TOTAL DO CENTRO DE CUSTO

    IF _REM="B"
	   S1   := S1   + SRA->RA_SALARIO
      ELSE
       DBSELECTAREA("SRD")
       DBSEEK(xFilial("SRD")+SRA->RA_MAT+_ANOMES+_VERBAREM) // BASE FGTS ID 0017
       IF FOUND()
	      S1   := S1   + RD_VALOR
       ENDIF         
    ENDIF

	dbSelectArea("SRA")
	dbSkip()
	
	IF RA_CC<>wCC .AND. T1 > 0
		@ nLinha,000 Psay LEFT((ALLTRIM(wCC)+"-"+_DESCCC),30)
		@ nLinha,032 PSAY T1 picture "999"
		@ Nlinha,036 PSAY (T1/_QTDFUNC)*100 PICTURE "@E 999.99"
		@ NLINHA,043 PSAY "%"
		@ nLinha,046 PSAY S1             PICTURE "@EZ 9,999,999.99"
		_TTREM:=S1 
		@ nLinha,059 PSAY (_TTREM/T1)    PICTURE "@EZ 999,999.99"
		
		_XX1:=wCC 
		_XX2:=_DESCCC

		aadd(aRESUMO , {  _xx1, _xx2, T1, _TTREM, (S1/TVAL)*100 } )
		
		_xTTREM:=_xTTREM + _TTREM
		nLinha:=nLinha+1
		IF NLINHA>55
			cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
			nLinha := 6
		ENDIF
		S1:=0
		T1:=0
		T2:=0
		@ nLINHA,004 PSAY "*--------Funcao---------*"
		@ nLinha,030 PSAY "QtFunc"
		@ nLinha,046 PSAY IIF(_REM="B","    Sal Base","   Rem TOTAL")
		nLINHA++
		DBSELECTAREA("TMP")
		DBSEEK(wCC)
		WHILE !EOF() .AND. TMP_CCU=wCC
            IF EMPTY(TMP_MATR)
               IF _ANASIN="A"
                  nLINHA++
               ENDIF
			   @ nLINHA,004 PSAY LEFT(TMP_DES,27)
			   @ nLINHA,032 PSAY TMP_NFU PICTURE "999"
			   IF _ANASIN="S" .OR. (_ANASIN="A" .AND. TMP_NFU>1)
			      @ nLinha,046 PSAY TMP_SAL PICTURE "@EZ 9,999,999.99"
			      @ nLinha,059 PSAY TMP_SAL/TMP_NFU  PICTURE "@EZ 999,999.99"
			   ENDIF   
			  ELSE
			   @ nLINHA,007 PSAY LEFT(TMP_NOME,38)
			   @ nLinha,046 PSAY TMP_SAL PICTURE "@EZ 9,999,999.99"
			   @ nLinha,061 PSAY TMP_ADM
			   @ nLinha,072 PSAY TMP_SIT
			ENDIF   
			DBSKIP()
			NLINHA++
			IF NLINHA>55
				cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
				nLinha := 6
			ENDIF
		ENDDO
		@ nLinha,000 PSAY __PrtThinLine()
		nLinha:=nLinha+1
		
		DBSELECTAREA("SRA")
	ENDIF
End

@ nLinha,000 Psay LEFT(sm0->m0_nome,6)
@ nLinha,007 Psay "* TOTAL DE EMPREGADOS -> " + STRZERO(_QTDFUNC,3)
@ nLinha,046 PSAY TVAL          PICTURE "@EZ 9,999,999.99"
@ nLinha,059 PSAY TVAL*_percinss    PICTURE "@EZ 999,999.99"
@ nLinha,070 PSAY TVAL*_percfgts    PICTURE "@EZ 999,999.99"
@ nLinha,081 PSAY _TSVG         PICTURE "@EZ 999,999.99"
@ nLinha,092 PSAY _xTTREM       PICTURE "@EZ 9,999,999.99"
@ Nlinha,105 PSAY 100 PICTURE "@E 999.99"
@ NLINHA,112 PSAY "%"
nLinha:=nLinha+1
@ nLinha,000 PSAY __PrtThinLine()
nLinha:=nLinha+1

IF (nLINHA+LEN(aRESUMO)) >33
	cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
	@ 07,007 Psay " Centro de Custo         Qtd                                                            T O T A L  Percent        Media"
	nLINHA:=09
ELSE
	@ nLinha,007 Psay " Centro de Custo         Qtd                                                            T O T A L  Percent        Media"
	nLinha++
ENDIF

Asort(aRESUMO,,,{|x,y| x[5] < y[5] })

FOR I:=LEN(aRESUMO) TO 1 STEP -1
	@ nLINHA,000 PSAY aRESUMO[I,1] + aRESUMO[I,2] 
	nLinha++
	@ nLINHA,032 PSAY aRESUMO[I,3] PICTURE "999"
	@ nLINHA,092 PSAY aRESUMO[I,4] PICTURE "@EZ 9,999,999.99"
	@ Nlinha,105 PSAY aRESUMO[I,5] PICTURE "@E 999.99"
	@ nLinha,114 PSAY aRESUMO[I,4]/aRESUMO[I,3] PICTURE "@EZ 9,999,999.99"
	nLinha++
	IF nLINHA>55
		cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
		@ 07,007 Psay " Centro de Custo         Qtd                                                            T O T A L  Percent        Media"
		nLINHA:=09
	ENDIF
NEXT I
nLinha++
@ nLinha,007 Psay "* TOTAL DE EMPREGADOS -> " + STRZERO(_QTDFUNC,3)
@ nLinha,092 PSAY _xTTREM       PICTURE "@EZ 9,999,999.99"
@ Nlinha,105 PSAY 100 PICTURE "@E 999.99"
@ NLINHA,112 PSAY "%"
nLinha++
@ nLinha,000 PSAY __PrtThinLine()
nLinha:=nLinha+1


If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool


//***************************************************************************************************************
_GeraXls:=1
@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Gera Planilha Excel ?"
@ 10, 49 SAY "1 - Nao"
@ 22, 49 SAY "2 - Sim"
@ 44, 49 GET _GeraXls PICTURE "99"
@ 60, 90 BmpButton Type 1 Action Close(oDlg2)
Activate Dialog oDlg2 Centered

If _GeraXls=2 //.AND. File(cArqTemp+".DBF")
	DbSelectArea("TMP")
	DBGOTOP()
	COPY TO QUADROFUN.CSV
	//Copiando Arquivo criado .DBF para o diretorio específico no Cliente
	IF CPYS2T("\SYSTEM\QUADROFUN.CSV","C:\Relato\",.F.)
		MSGINFO("Arquivo gerado com sucesso! C:\Relato\QUADROFUN.CSV")
	ELSE
		ALERT("ERRO NA COPIA")
	ENDIF
EndIf

dbSelectArea('TMP')
dbCloseArea()
cArqTemp2 := cArqTemp + '.DBF'
Delete File &cArqTemp2
cArqTemp3 := cArqTemp + '.CDX'
Delete File &cArqTemp3

DBSELECTAREA("SRA")
dbClearFilter()


Return
