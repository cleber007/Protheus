#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELDEP     º Autor ³ PROTHEUS12 IDE    º Data ³  28/06/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ RELACAO DE DEPENDENTES - By JMC - JOSE MACEDO              º±±
±±º          ³ RELACAO DE PENSOES                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALUBAR                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RELSRQ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relação de Pensoes"
Local cPict          := ""
Local titulo       := "Relação de Pensoes"
Local nLin         := 80

Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "RELPEN" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := ""
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RELSRQ" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SRQ"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunRep02(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  07/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunRep02(Cabec1,Cabec2,Titulo,nLin)



//*********************************************************** ARQUIVO TEMPORARIO PARA GERACAO DO XLS
aStru  := {}
aadd(aStru , {'TRB_MAT' ,'C', 06,0} )
aadd(aStru , {'TRB_NOM' ,'C', 40,0} )
aadd(aStru , {'TRB_BEN' ,'C', 40,0} )
aadd(aStru , {'TRB_CPF' ,'C', 11,0} )
aadd(aStru , {'TRB_PERCEN' ,'N', 05,2} )
aadd(aStru , {'TRB_VLFOLH' ,'N', 12,2} )
aadd(aStru , {'TRB_VLFERI' ,'N', 12,2} )
aadd(aStru , {'TRB_BASECA' ,'N', 12,2} )
aadd(aStru , {'TRB_FORN'   ,'C', 06,0} )


cArqTemp := CriaTrab(aStru , .t.)
dbUseArea(.T.,,cArqTEMP,"TRB",.F.,.F.)
dbSelectArea("TRB")




Titulo := " Relacao de Beneficiarios - Emissao: " + DTOC(dDataBase)
nLin :=99
_nSEQ:=0

DBSELECTAREA("SRC")
DBSETORDER(1)

DBSELECTAREA("SRA")
DBSETORDER(1)

DBSELECTAREA("SRQ")
DBSETORDER(1)
DBGOTOP()
_T1:=_T2:=0
While !EOF()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin :=6
		@nLin, 001 PSAY "Seq"
		@nLin, 005 PSAY "Mat."
		@nLin, 012 PSAY "Funcionario"
		@nLin, 054 PSAY "Beneficiario"
		@nLin, 095 PSAY "CPF"
		@nLin, 107 PSAY "Perc"
		@nLin, 114 PSAY " Valor Fol"
		@nLin, 125 PSAY " Valor Fer"
		@nLin, 136 PSAY " Base Calc"
		@nLin, 147 PSAY "Foneced"
		
		nLin++
		@nLin,  0 PSAY __PrtThinLine()
		nLin++
		
	Endif
	
    IF EMPTY(RQ_VERBFOL) .OR. (!EMPTY(RQ_DTFIM) .AND. RQ_DTFIM<DDATABASE)
       SRQ->(DBSKIP())
       Loop
    ENDIF
     	
	DBSELECTAREA("SRA")
	DBSETORDER(1)
	DBSEEK(xFilial("SRA")+SRQ->RQ_MAT)
	IF FOUND()
		IF RA_SITFOLH="D"
			DBSELECTAREA("SRQ")
			DBSKIP()
			Loop
		ENDIF

        _VLFOLHA:=_VLFERIAS:=0
        _BASE:=0
	    DBSELECTAREA("SRC")
	    DBSEEK(xFilial("SRC")+SRA->RA_MAT+SRQ->RQ_VERBFOL)
		IF FOUND()
		   _VLFOLHA:=RC_VALOR
		   _BASE   :=RC_VALORBA
		ENDIF
	    DBSEEK(xFilial("SRC")+SRA->RA_MAT+SRQ->RQ_VERBFER)
		IF FOUND()
		   _VLFERIAS:=RC_VALOR
		   _BASE   +=RC_VALORBA
		ENDIF
		
		_nSeq++
		@nLin, 001 PSAY STRZERO(_nSeq,3)
		@nLin, 005 PSAY SRA->RA_MAT
		@nLin, 012 PSAY SRA->RA_NOME
		@nLin, 054 PSAY SRQ->RQ_NOME
		@nLin, 095 PSAY SRQ->RQ_CIC
		@nLin, 107 PSAY SRQ->RQ_PERCENT PICTURE "@E 999.99"
		@nLin, 114 PSAY _VLFOLHA  PICTURE "@E 999,999.99"
		@nLin, 125 PSAY _VLFERIAS PICTURE "@E 999,999.99"
		@nLin, 136 PSAY _BASE     PICTURE "@E 999,999.99"
		@nLin, 147 PSAY SRQ->RQ_FORNEC
        _T1+=_VLFOLHA
        _T2+=_VLFERIAS		
		nLin++
		
		DBSELECTAREA("TRB")
		RECLOCK("TRB",.T.)
		TRB->TRB_MAT:=SRA->RA_MAT
		TRB->TRB_NOM:=SRA->RA_NOME
		TRB->TRB_BEN:=SRQ->RQ_NOME
		TRB->TRB_CPF:=SRQ->RQ_CIC
        TRB->TRB_PERCEN:=SRQ->RQ_PERCENT
        TRB->TRB_VLFOLH:=_VLFOLHA
        TRB->TRB_VLFERI:=_VLFERIAS
        TRB->TRB_BASECA:=_BASE
        TRB->TRB_FORN  :=SRQ->RQ_FORNEC

		MSUNLOCK()
	ENDIF
	DBSELECTAREA("SRQ")
	DBSKIP()
EndDo
@nLin,  0 PSAY __PrtThinLine()
nLin++

@nLin, 114 PSAY _T1  PICTURE "@E 999,999.99"
@nLin, 125 PSAY _T2  PICTURE "@E 999,999.99"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()



_GeraXls:=1
@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Gera Planilha Excel ?"
@ 10, 49 SAY "1 - Nao"
@ 22, 49 SAY "2 - Sim"
@ 44, 49 GET _GeraXls PICTURE "99"
@ 60, 90 BmpButton Type 1 Action Close(oDlg2)
Activate Dialog oDlg2 Centered


If _GeraXls=2 
	DbSelectArea("TRB")
	DBGOTOP()
	Copy to RELPEN.CSV VIA "DBFCDXADS" 
	//Copiando Arquivo criado .DBF para o diretorio específico no Cliente
	IF CPYS2T("\SYSTEM\RELPEN.CSV","C:\Relato\",.F.)
		MSGINFO("Arquivo gerado com sucesso! C:\Relato\RELPEN.CSV")
	ELSE
		ALERT("ERRO NA COPIA")
	ENDIF
EndIf

DBSELECTAREA("TRB")
DBCLOSEAREA("TRB")
Ferase(cArqTEMP)
Ferase(cArqTEMP+".DTC")

Return



User Function RELDEP


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relação de Funcionários "
Local cPict          := ""
Local titulo       := "Relação de Dependentes"
Local nLin         := 80

Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "RELDEP" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "RELDEP"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RELDEP" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SRB"


IF !(pergunte(cPerg,.T.))
	RETURN Nil
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  07/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)



//*********************************************************** ARQUIVO TEMPORARIO PARA GERACAO DO XLS
aStru  := {}
aadd(aStru , {'TRB_MAT' ,'C', 06,0} )
aadd(aStru , {'TRB_NOM' ,'C', 30,0} )
aadd(aStru , {'TRB_NAS' ,'C', 10,0} )
aadd(aStru , {'TRB_SEX' ,'C', 01,0} )
aadd(aStru , {'TRB_GRA' ,'C', 01,0} )
aadd(aStru , {'TRB_IDA' ,'N', 03,0} )
aadd(aStru , {'TRB_FUN' ,'C', 40,0} )
aadd(aStru , {'TRB_ADM' ,'C', 10,0} )
aadd(aStru , {'TRB_SXO' ,'C', 01,0} )
aadd(aStru , {'TRB_OBS' ,'C', 40,0} )


cArqTemp := CriaTrab(aStru , .t.)
dbUseArea(.T.,,cArqTEMP,"TRB",.F.,.F.)
dbSelectArea("TRB")




Titulo := " Relacao de Dependentes - Emissao: " + DTOC(dDataBase)
nLin :=99
_nSEQ:=0
_MAS:=_FEM:=0
DBSELECTAREA("SRA")
DBSETORDER(1)

DBSELECTAREA("SRB")
DBSETORDER(1)
DBGOTOP()
While !EOF()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin :=6
		@nLin, 001 PSAY "Seq"
		@nLin, 005 PSAY "Mat."
		@nLin, 012 PSAY "Dependente"
		@nLin, 043 PSAY "Nascimento Ida Sx Gr"
		@nLin, 065 PSAY "Funcionario"
		@nLin, 107 PSAY "Admissao"
		@nLin, 118 PSAY "Sexo"
		
		nLin++
		@nLin,  0 PSAY __PrtThinLine()
		nLin++
		
	Endif
	
	IF !EMPTY(MV_PAR03) .AND. MV_PAR03#SRB->RB_GRAUPAR
		DBSELECTAREA("SRB")
		DBSKIP()
		Loop
	ENDIF
	
	DBSELECTAREA("SRA")
	DBSETORDER(1)
	DBSEEK(xFilial("SRA")+SRB->RB_MAT)
	IF FOUND()
		IF RA_SITFOLH="D"
			DBSELECTAREA("SRB")
			DBSKIP()
			Loop
		ENDIF
		
		_Idade:=INT((DDATABASE-SRB->RB_DTNASC)/365)
		
		IF !(_IDADE>=MV_PAR01 .AND. _IDADE<=MV_PAR02)
			DBSELECTAREA("SRB")
			DBSKIP()
			Loop
		ENDIF
		
		
		_nSeq++
		@nLin, 001 PSAY STRZERO(_nSeq,3)
		@nLin, 005 PSAY SRA->RA_MAT
		@nLin, 012 PSAY SRB->RB_NOME
		@nLin, 043 PSAY DTOC(SRB->RB_DTNASC)
		@nLin, 054 PSAY _Idade PICTURE "999"
		@nLin, 058 PSAY SRB->RB_SEXO
		@nLin, 061 PSAY SRB->RB_GRAUPAR
		
		@nLin, 065 PSAY SUBSTR(SRA->RA_NOME,1,40)
		@nLin, 107 PSAY DTOC(SRA->RA_ADMISSA)
		@nLin, 118 PSAY SRA->RA_SEXO
      IF !EMPTY(SRB->RB_OBS)
    		nLin++
		   @nLin, 061 PSAY SRB->RB_OBS
		ENDIF   
      
		IF SRB->RB_SEXO="M"
			_MAS++
		ELSE
			_FEM++
		ENDIF
		nLin++
		
		DBSELECTAREA("TRB")
		RECLOCK("TRB",.T.)
		TRB->TRB_MAT:=SRA->RA_MAT
		TRB->TRB_NOM:=SRB->RB_NOME
		TRB->TRB_NAS:=DTOC(SRB->RB_DTNASC)
		TRB->TRB_IDA:=_IDADE
		TRB->TRB_FUN:=SRA->RA_NOME
		TRB->TRB_ADM:=DTOC(SRA->RA_ADMISSA)
		TRB->TRB_SEX:=SRB->RB_SEXO
		TRB->TRB_GRA:=SRB->RB_GRAUPAR
		TRB->TRB_SXO:=SRA->RA_SEXO
		TRB->TRB_OBS:=SRB->RB_OBS
		MSUNLOCK()
	ENDIF
	DBSELECTAREA("SRB")
	DBSKIP()
EndDo
@ nLIN,005 PSAY ".Masc: "+ALLTRIM(STR(_MAS,5,0))+" .Fem: "+ALLTRIM(STR(_FEM,5,0))
DBSELECTAREA("TRB")
RECLOCK("TRB",.T.)
TRB->TRB_FUN:=".Masc: "+ALLTRIM(STR(_MAS,5,0))+" .Fem: "+ALLTRIM(STR(_FEM,5,0))
MSUNLOCK()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()



_GeraXls:=1
@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Gera Planilha Excel ?"
@ 10, 49 SAY "1 - Nao"
@ 22, 49 SAY "2 - Sim"
@ 44, 49 GET _GeraXls PICTURE "99"
@ 60, 90 BmpButton Type 1 Action Close(oDlg2)
Activate Dialog oDlg2 Centered


If _GeraXls=2 .AND. File(cArqTemp+".DTC")
	DbSelectArea("TRB")
	DBGOTOP()
//	COPY TO RELDEP.CSV
	_cArqRen:="\SYSTEM\TEMPDBF\RELDEP.CSV"
	Copy to &_cArqRen VIA "DBFCDXADS" 
	//Copiando Arquivo criado .DBF para o diretorio específico no Cliente
	IF CPYS2T("\SYSTEM\TEMPDBF\RELDEP.CSV","C:\Relato\",.F.)
		MSGINFO("Arquivo gerado com sucesso! C:\Relato\RELDEP.CSV")
	ELSE
		ALERT("ERRO NA COPIA")
	ENDIF
EndIf

DBSELECTAREA("TRB")
DBCLOSEAREA("TRB")
Ferase(cArqTEMP)
Ferase(cArqTEMP+".DTC")

Return

