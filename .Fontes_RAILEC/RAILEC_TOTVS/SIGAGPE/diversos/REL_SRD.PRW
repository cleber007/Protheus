#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ REL_SRD  บ Autor ณ JOSE MACEDO        บ Data ณ  19/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ RELATORIO LANCAMENTOS ACUMULADOS                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Grupo Alubar S/A                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function REL_SRD()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "LANCAMENTOS ACUMULADOS"
//Local cPict          := ""
Local titulo       := "LANCAMENTOS ACUMULADOS"
Local nLin         := 80

//Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "REL_SRD" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
//Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "FPG303R" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := ""
Private aSituac    := {"ATIVOS","FERIAS","DEMITIDOS","AFASTADOS","TODOS"}
Private cKey       := ""
Private nIndex     := 0
Private cIndex     := ""
Private cString    := "SRA"

//Pergunte(cPerg,.t.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)
Cabec1       := ""
Cabec2       := ""



_PAR06 :=STRZERO(year(DDATABASE),4,0)+STRZERO(MONTH(DDATABASE),2,0)
_PAR07 :=_PAR06

_CCUSTO:=SPACE(9)
_VERBAS:=SPACE(42)   // MAXIMO DE 14 VERBAS

@ 1,1 to  300,450 DIALOG oDlg2A TITLE "Compara ?"
@ 10, 10 SAY "Ano Mes BASE ?"
@ 10, 59 GET _PAR06 PICTURE "999999" VALID NAOVAZIO()
@ 20, 59 GET _PAR07 PICTURE "999999" VALID NAOVAZIO()
@ 30, 10 SAY "CCusto ?"
@ 30, 59 GET _CCUSTO SIZE 20,12 F3 "CTT"
@ 40, 10 SAY "Verbas sem separar (maximo de 14):"
@ 50, 10 GET _VERBAS SIZE 100,12

@ 70, 90 BmpButton Type 1 Action Close(oDlg2A)
Activate Dialog oDlg2A Centered


_CCUSTO:=ALLTRIM(_CCUSTO)
_VERBAS:=ALLTRIM(_VERBAS)
IF !(_PAR06<Getmv("MV_FOLMES"))
	ALERT("SOMENTE FOLHAS JA FECHADAS")
	RETURN Nil
ENDIF

cX3TAMANHO := "X3_TAMANHO"
DbSelectArea("SX3")
DbSetOrder(2)
// Busca Arquivo
DbSeek("RA_CC")
IF FOUND()
	nSizeCC  := &(cX3TAMANHO)
ELSE
	ALERT("FALTA RA_CC NO SX3")
	RETURN Nil
ENDIF

aStru := {}
aadd(aStru , {'TMP_MATR'   ,'C', 06,0} )
aadd(aStru , {'TMP_NOME'   ,'C', 40,0} )
aadd(aStru , {'TMP_CCUS'   ,'C', nSizeCC,0} )
aadd(aStru , {'TMP_DESC'   ,'C', 40,0} )
aadd(aStru , {'TMP_DESFU'  ,'C', 20,0} )
aadd(aStru , {'TMP_SITUA'  ,'C', 03,0} )
aadd(aStru , {'TMP_VAL01'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL02'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL03'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL04'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL05'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL06'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL07'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL08'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL09'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL10'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL11'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL12'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL13'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL14'   ,'N', 12,2} )

/*
cArqTemp := CriaTrab(aStru , .t.)
dbUseArea(.T.,,cArqTemp,'TMP',.f.)
INDEX ON TMP_MATR TO &cArqTemp
*/
oTable := FWTemporaryTable():New("TMP", aStru)
oTable:addIndex("01", {"TMP_MATR"})
oTable:create()
TMP:= oTable:GetRealName()


RptStatus({|| RunDetRep(Cabec1,Cabec2,Titulo,nLin) },Titulo)

DbSelectArea("SRA")
DbSetOrder(1)
DBGOTOP()

Return



//**********************************
Static Function RunDetRep(Cabec1,Cabec2,Titulo,nLin)
//**********************************
DbSelectArea("CTT")
DbSetOrder(1)

DbSelectArea("SRC")
DbSetorder(1)
DbSelectArea("SRD")
DbSetorder(1)

dbSelectArea("SRA")
dbSetOrder(2)     // CENTRO DE CUSTO
SetRegua(RecCount())
_FIL:=xFilial("SRA")
DBSEEK(_Fil)
_V01:=SUBSTR(_VERBAS,01,3)
_V02:=SUBSTR(_VERBAS,04,3)
_V03:=SUBSTR(_VERBAS,07,3)
_V04:=SUBSTR(_VERBAS,10,3)
_V05:=SUBSTR(_VERBAS,13,3)
_V06:=SUBSTR(_VERBAS,16,3)

_V07:=SUBSTR(_VERBAS,19,3)
_V08:=SUBSTR(_VERBAS,22,3)
_V09:=SUBSTR(_VERBAS,25,3)
_V10:=SUBSTR(_VERBAS,28,3)
_V11:=SUBSTR(_VERBAS,31,3)
_V12:=SUBSTR(_VERBAS,34,3)
_V13:=SUBSTR(_VERBAS,37,3)
_V14:=SUBSTR(_VERBAS,40,3)

WHILE !EOF() .AND. xFilial("SRA")==_Fil
	INCREGUA()
	_VAL01:=_VAL02:=_VAL03:=_VAL04:=_VAL05:=_VAL06:=0
	_VAL07:=_VAL08:=_VAL09:=_VAL10:=_VAL11:=_VAL12:=0
	_VAL13:=_VAL14:=0
	
	IF !EMPTY(_CCUSTO) .AND. RA_CC#_CCUSTO    // FILTRO DE CENTRO DE CUSTOS
		DBSKIP()
		Loop
	ENDIF
	
	//*************************************************************** BUSCA VALORES ACUMULADOS NOS MESES EM QUESTAO
	DBSELECTAREA("SRD")
	DBSEEK(xFilial("SRD")+SRA->RA_MAT+_PAR06,.T.)
	WHILE !EOF() .AND. RD_MAT=SRA->RA_MAT .AND. RD_DATARQ <= _PAR07
		
		IF !(RD_PD$(_V01+"-"+_V02+"-"+_V03+"-"+_V04+"-"+_V05+"-"+_V06+"-"+_V07+"-"+_V08+"-"+_V09+"-"+_V10+"-"+_V11+"-"+_V12+"-"+_V13+"-"+_V14))
			DBSKIP()
			Loop
		ENDIF
		DO CASE
			CASE RD_PD=_V01
				_VAL01+=RD_VALOR
			CASE RD_PD=_V02
				_VAL02+=RD_VALOR
			CASE RD_PD=_V03
				_VAL03+=RD_VALOR
			CASE RD_PD=_V04
				_VAL04+=RD_VALOR
			CASE RD_PD=_V05
				_VAL05+=RD_VALOR
			CASE RD_PD=_V06
				_VAL06+=RD_VALOR
				
			CASE RD_PD=_V07
				_VAL07+=RD_VALOR
			CASE RD_PD=_V08
				_VAL08+=RD_VALOR
			CASE RD_PD=_V09
				_VAL09+=RD_VALOR
			CASE RD_PD=_V10
				_VAL10+=RD_VALOR
			CASE RD_PD=_V11
				_VAL11+=RD_VALOR
			CASE RD_PD=_V12
				_VAL12+=RD_VALOR
				
			CASE RD_PD=_V13
				_VAL13+=RD_VALOR
			CASE RD_PD=_V14
				_VAL14+=RD_VALOR
				
		ENDCASE
		
		DBSELECTAREA("SRD")
		DBSKIP()
	ENDDO
	//**************************** GRAVA NO ARQ TEMPORARIO
	IF (_VAL01+_VAL02+_VAL03+_VAL04+_VAL05+_VAL06+_VAL07+_VAL08+_VAL09+_VAL10+_VAL11+_VAL12+_VAL13+_VAL14) >0
		DBSELECTAREA("TMP")
		DBSEEK(SRA->RA_MAT)
		IF !FOUND()
			RECLOCK("TMP",.T.)
			TMP_MATR :=SRA->RA_MAT
			TMP_NOME :=SRA->RA_NOME
			TMP_CCUS :=SRA->RA_CC
			TMP_DESC :=Posicione("CTT", 1 ,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01")
			TMP_DESFU:=Posicione("SRJ", 1 ,xFilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")
			TMP_SITUA :=IIF(SRA->RA_SITFOLH="D","DEM","   ")
		ELSE
			RECLOCK("TMP",.F.)
		ENDIF
		TMP_VAL01:=_VAL01
		TMP_VAL02:=_VAL02
		TMP_VAL03:=_VAL03
		TMP_VAL04:=_VAL04
		TMP_VAL05:=_VAL05
		TMP_VAL06:=_VAL06
		
		TMP_VAL07:=_VAL07
		TMP_VAL08:=_VAL08
		TMP_VAL09:=_VAL09
		TMP_VAL10:=_VAL10
		TMP_VAL11:=_VAL11
		TMP_VAL12:=_VAL12
		TMP_VAL13:=_VAL13
		TMP_VAL14:=_VAL14
		
		MSUNLOCK()
	ENDIF
	DBSELECTAREA("SRA")
	DBSKIP()
ENDDO

_DVER01:=IIF(!EMPTY(_V01),POSICIONE("SRV",1,XFILIAL("SRV")+_V01,"RV_DESC")," ")
_DVER02:=IIF(!EMPTY(_V02),POSICIONE("SRV",1,XFILIAL("SRV")+_V02,"RV_DESC")," ")
_DVER03:=IIF(!EMPTY(_V03),POSICIONE("SRV",1,XFILIAL("SRV")+_V03,"RV_DESC")," ")
_DVER04:=IIF(!EMPTY(_V04),POSICIONE("SRV",1,XFILIAL("SRV")+_V04,"RV_DESC")," ")
_DVER05:=IIF(!EMPTY(_V05),POSICIONE("SRV",1,XFILIAL("SRV")+_V05,"RV_DESC")," ")
_DVER06:=IIF(!EMPTY(_V06),POSICIONE("SRV",1,XFILIAL("SRV")+_V06,"RV_DESC")," ")

_DVER07:=IIF(!EMPTY(_V07),POSICIONE("SRV",1,XFILIAL("SRV")+_V01,"RV_DESC")," ")
_DVER08:=IIF(!EMPTY(_V08),POSICIONE("SRV",1,XFILIAL("SRV")+_V02,"RV_DESC")," ")
_DVER09:=IIF(!EMPTY(_V09),POSICIONE("SRV",1,XFILIAL("SRV")+_V03,"RV_DESC")," ")
_DVER10:=IIF(!EMPTY(_V10),POSICIONE("SRV",1,XFILIAL("SRV")+_V04,"RV_DESC")," ")
_DVER11:=IIF(!EMPTY(_V11),POSICIONE("SRV",1,XFILIAL("SRV")+_V05,"RV_DESC")," ")
_DVER12:=IIF(!EMPTY(_V12),POSICIONE("SRV",1,XFILIAL("SRV")+_V06,"RV_DESC")," ")
_DVER13:=IIF(!EMPTY(_V13),POSICIONE("SRV",1,XFILIAL("SRV")+_V05,"RV_DESC")," ")
_DVER14:=IIF(!EMPTY(_V14),POSICIONE("SRV",1,XFILIAL("SRV")+_V06,"RV_DESC")," ")


Cabec1  :=SPACE(50)+LEFT(_DVER01,11)+SPACE(01)+LEFT(_DVER02,10)+SPACE(01)+LEFT(_DVER03,10)+SPACE(01)+LEFT(_DVER04,10)+SPACE(01)+LEFT(_DVER05,10)+SPACE(01)+LEFT(_DVER06,11)
Cabec2  :=SPACE(50)+LEFT(_DVER07,11)+SPACE(01)+LEFT(_DVER08,10)+SPACE(01)+LEFT(_DVER09,10)+SPACE(01)+LEFT(_DVER10,10)+SPACE(01)+LEFT(_DVER11,10)+SPACE(01)+LEFT(_DVER12,11)

nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin += 1
_TT01:=_TT02:=0
_TT03:=_TT04:=0
_TT05:=_TT06:=0

_TT07:=_TT08:=0
_TT09:=_TT10:=0
_TT11:=_TT12:=0

DBSELECTAREA("TMP")
DBGOTOP()
WHILE !EOF()
	IF EMPTY(TMP_MATR)
		DBSKIP()
		Loop
	ENDIF
	@ nLIN,003 PSAY TMP_MATR
	@ nLIN,010 PSAY LEFT(TMP_NOME,40)
	@ nLIN,051 PSAY TMP_VAL01 PICTURE "@E 999,999.99"
	@ nLIN,062 PSAY TMP_VAL02 PICTURE "@E 999,999.99"
	@ nLIN,073 PSAY TMP_VAL03 PICTURE "@E 999,999.99"
	@ nLIN,084 PSAY TMP_VAL04 PICTURE "@E 999,999.99"
	@ nLIN,095 PSAY TMP_VAL05 PICTURE "@E 999,999.99"
	@ nLIN,106 PSAY TMP_VAL06 PICTURE "@E 999,999.99"
	@ nLIN,117 PSAY TMP_DESFU
	IF TMP_VAL07+TMP_VAL08+TMP_VAL09+TMP_VAL10+TMP_VAL11+TMP_VAL12 >0
		nLin++
		@ nLIN,051 PSAY TMP_VAL07 PICTURE "@E 999,999.99"
		@ nLIN,062 PSAY TMP_VAL08 PICTURE "@E 999,999.99"
		@ nLIN,073 PSAY TMP_VAL09 PICTURE "@E 999,999.99"
		@ nLIN,084 PSAY TMP_VAL10 PICTURE "@E 999,999.99"
		@ nLIN,095 PSAY TMP_VAL11 PICTURE "@E 999,999.99"
		@ nLIN,106 PSAY TMP_VAL12 PICTURE "@E 999,999.99"
	ENDIF
	_TT01+=TMP_VAL01
	_TT02+=TMP_VAL02
	_TT03+=TMP_VAL03
	_TT04+=TMP_VAL04
	_TT05+=TMP_VAL05
	_TT06+=TMP_VAL06
	
	_TT07+=TMP_VAL07
	_TT08+=TMP_VAL08
	_TT09+=TMP_VAL09
	_TT10+=TMP_VAL10
	_TT11+=TMP_VAL11
	_TT12+=TMP_VAL12
	
	nLin++
	If nLin > 55
		nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin += 1
	Endif
	
	DBSKIP()
ENDDO
@nLin,  0 PSAY __PrtThinLine()
nLin++
@ nLIN,010 PSAY ".Total G E R A L:"
@ nLIN,051 PSAY _TT01 PICTURE "@E 999,999.99"
@ nLIN,062 PSAY _TT02 PICTURE "@E 999,999.99"
@ nLIN,073 PSAY _TT03 PICTURE "@E 999,999.99"
@ nLIN,084 PSAY _TT04 PICTURE "@E 999,999.99"
@ nLIN,095 PSAY _TT05 PICTURE "@E 999,999.99"
@ nLIN,106 PSAY _TT06 PICTURE "@E 999,999.99"
nLin++
@ nLIN,051 PSAY _TT07 PICTURE "@E 999,999.99"
@ nLIN,062 PSAY _TT08 PICTURE "@E 999,999.99"
@ nLIN,073 PSAY _TT09 PICTURE "@E 999,999.99"
@ nLIN,084 PSAY _TT10 PICTURE "@E 999,999.99"
@ nLIN,095 PSAY _TT11 PICTURE "@E 999,999.99"
@ nLIN,106 PSAY _TT12 PICTURE "@E 999,999.99"

nLin++
@nLin,  0 PSAY __PrtThinLine()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

DbSelectArea("SRD")
DBSETORDER(1)
DBGOTOP()
DbSelectArea("SRA")
DBSETORDER(1)
DBGOTOP()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()


//***************************************************************************************************************
_GeraXls:=1
@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Gera Planilha Excel ?"
@ 10, 49 SAY "1 - Nao"
@ 22, 49 SAY "2 - Sim"
@ 44, 49 GET _GeraXls PICTURE "99"
@ 60, 90 BmpButton Type 1 Action Close(oDlg2)
Activate Dialog oDlg2 Centered
IF _GeraXls=2
	
	DbSelectArea("TMP")
	DBGOTOP()
	aadd(aStru , {'TMP_MATR'   ,'C', 06,0} )
aadd(aStru , {'TMP_NOME'   ,'C', 40,0} )
aadd(aStru , {'TMP_CCUS'   ,'C', nSizeCC,0} )
aadd(aStru , {'TMP_DESC'   ,'C', 40,0} )
aadd(aStru , {'TMP_DESFU'  ,'C', 20,0} )
aadd(aStru , {'TMP_SITUA'  ,'C', 03,0} )
aadd(aStru , {'TMP_VAL01'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL02'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL03'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL04'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL05'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL06'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL07'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL08'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL09'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL10'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL11'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL12'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL13'   ,'N', 12,2} )
aadd(aStru , {'TMP_VAL14'   ,'N', 12,2} )

		oFWMsExcel := FWMSExcel():New()
		oFWMsExcel:AddworkSheet("MED")
		oFWMsExcel:AddTable("MED",cTabela)
		oFWMsExcel:AddColumn("MED",cTabela,"TMP_MATR",1,1)
		oFWMsExcel:AddColumn("MED",cTabela,"TMP_NOME",1,1)
		oFWMsExcel:AddColumn("MED",cTabela,"TMP_CCUS",1,1)
		oFWMsExcel:AddColumn("MED",cTabela,"TMP_DESC",1,1)
		oFWMsExcel:AddColumn("MED",cTabela,"TMP_DESFU",1,1)
		oFWMsExcel:AddColumn("MED",cTabela,"TMP_SITUA",1,1)
		oFWMsExcel:AddColumn("MED",cTabela,"TMP_VAL01",1,1)
		oFWMsExcel:AddColumn("MED",cTabela,"TMP_VAL02",1,1)
		oFWMsExcel:AddColumn("MED",cTabela,"TMP_VAL03",1,1)
		oFWMsExcel:AddColumn("MED",cTabela,"TMP_VAL04",1,1)
		oFWMsExcel:AddColumn("MED",cTabela,"TMP_VAL05",1,1)		
		oFWMsExcel:AddColumn("MED",cTabela,"TMP_VAL06",1,1)
		oFWMsExcel:AddColumn("MED",cTabela,"TMP_VAL07",1,1)
		oFWMsExcel:AddColumn("MED",cTabela,"TMP_VAL08",1,1)
		oFWMsExcel:AddColumn("MED",cTabela,"TMP_VAL09",1,1)
		oFWMsExcel:AddColumn("MED",cTabela,"TMP_VAL10",1,1)										
		oFWMsExcel:AddColumn("MED",cTabela,"TMP_VAL11",1,1)
		oFWMsExcel:AddColumn("MED",cTabela,"TMP_VAL12",1,1)
		oFWMsExcel:AddColumn("MED",cTabela,"TMP_VAL13",1,1)
		oFWMsExcel:AddColumn("MED",cTabela,"TMP_VAL14",1,1)
		
		While TMP->(!EOF())
			oFWMsExcel:AddRow("MED",cTabela,{TMP->TMP_MATR,TMP->TMP_NOME,TMP->TMP_CCUS,TMP->TMP_DESC,TMP->TMP_DESFU,;
			TMP->TMP_SITUA,;
			TMP->TMP_VAL01,;
			TMP->TMP_VAL02,;
			TMP->TMP_VAL03,;
			TMP->TMP_VAL04,;
			TMP->TMP_VAL05,;
			TMP->TMP_VAL06,;
			TMP->TMP_VAL07,;
			TMP->TMP_VAL08,;
			TMP->TMP_VAL09,;
			TMP->TMP_VAL10,;
			TMP->TMP_VAL11,;
			TMP->TMP_VAL12,;
			TMP->TMP_VAL13,;
			TMP->TMP_VAL14,})
			TMP->(dbSkip())
		EndDo
		oFWMsExcel:Activate()
		oFWMsExcel:GetXMLFile(cArquivo)

		//Abrindo o excel e abrindo o arquivo xml
		oExcel := MsExcel():New()             //Abre uma nova conexใo com Excel
		oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
		oExcel:SetVisible(.T.)                 //Visualiza a planilha
		oExcel:Destroy()
	/*
//	COPY TO RELACUM.CSV
	_cArqRen:="\SYSTEM\TEMPDBF\RELACUM.CSV"
	Copy to &_cArqRen VIA "DBFCDXADS" 
	//Copiando Arquivo criado .DBF para o diretorio especํfico no Cliente
	IF CPYS2T("\SYSTEM\TEMPDBF\RELACUM.CSV","C:\Relato\",.F.)
		MSGINFO("Arquivo gerado com sucesso! C:\Relato\RELACUM.CSV",)
	ELSE
		ALERT("ERRO NA COPIA")
	ENDIF
	*/
ENDIF

dbSelectArea('TMP')
dbCloseArea()

Return





