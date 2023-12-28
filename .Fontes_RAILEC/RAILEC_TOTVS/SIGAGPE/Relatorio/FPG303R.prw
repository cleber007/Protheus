#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FPG303R  บ Autor ณ JOSE MACEDO        บ Data ณ  30/07/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ CUSTOS POR FUNCIONARIO                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Grupo Alubar S/A                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FPG303R()  

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "RELACAO DE FUNCIONARIOS"
Local cPict          := ""
Local titulo       := "RELACAO DE FUNCIONARIOS"
Local nLin         := 80

Local Cabec1       := "Codigo Nome Funcionario(a)                           Nascimto Admissao Funcao"
//                     XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX/XX/XX XX/XX/XX XXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX
//                     0         1         2         3         4         5         6         7         8         9         1         1         2         3
//                     0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
Local Cabec2       := ""

Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "FPG303R" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "FPG303R" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := "FPG303"
Private aSituac    := {"ATIVOS","FERIAS","DEMITIDOS","AFASTADOS","TODOS"}
Private cKey       := ""
Private nIndex     := 0
Private cIndex     := ""
Private cString    := "SRA"


aStru := {}
aadd(aStru , {'TMP_CCUS'   ,'C', 09,0} )
aadd(aStru , {'TMP_DESC'   ,'C', 25,0} )
aadd(aStru , {'TMP_MATR'   ,'C', 06,0} )
aadd(aStru , {'TMP_NOME'   ,'C', 40,0} )
aadd(aStru , {'TMP_NASC'   ,'C', 10,0} )
aadd(aStru , {'TMP_ADMI'   ,'C', 10,0} )
aadd(aStru , {'TMP_FUNC'   ,'C', 09,0} )
aadd(aStru , {'TMP_DFUN'   ,'C', 30,0} )
aadd(aStru , {'TMP_CARGO'  ,'C', 30,0} )
aadd(aStru , {'TMP_RG'     ,'C', 10,0} )
aadd(aStru , {'TMP_PIS'    ,'C', 15,0} )
aadd(aStru , {'TMP_CPF'    ,'C', 15,0} )
aadd(aStru , {'TMP_TIPOST'   ,'C', 10,0} )
aadd(aStru , {'TMP_DATAST'   ,'C', 10,0} )
aadd(aStru , {'TMP_DATRET'   ,'C', 10,0} )

aadd(aStru , {'TMP_SALARI' ,'N', 15,2} )
aadd(aStru , {'TMP_UNIMED' ,'N', 15,2} )
aadd(aStru , {'TMP_UNIODO' ,'N', 15,2} )
aadd(aStru , {'TMP_VISAVA' ,'N', 15,2} )
aadd(aStru , {'TMP_SEGURO' ,'N', 15,2} )
aadd(aStru , {'TMP_PROV13' ,'N', 15,2} )
aadd(aStru , {'TMP_PROVFE' ,'N', 15,2} )
aadd(aStru , {'TMP_PROV1F' ,'N', 15,2} )

aadd(aStru , {'TMP_FGTS'   ,'N', 15,2} )
aadd(aStru , {'TMP_PRVFGT' ,'N', 15,2} )
aadd(aStru , {'TMP_INSS'   ,'N', 15,2} )
aadd(aStru , {'TMP_PRVINS' ,'N', 15,2} )

cArqTemp := CriaTrab(aStru , .t.)
dbUseArea(.T.,,cArqTemp,'TMP',.f.)

dbSelectArea("SRA")
dbSetOrder(8) // FILIAL + CC + NOME


Pergunte(cPerg,.t.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)
Titulo := Trim(Titulo)+" "+aSituac[MV_PAR01] //+If(MV_PAR01<>4," - "+DtoC(MV_PAR02)+" A "+DtoC(MV_PAR03),"")
DbSelectArea("SRA")
DbSetOrder(8)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

//*************************************************
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
//*************************************************

aMotivo := {"Acidente (Trabalho)","Acidente (Trajeto)","Doenca (Trabalho)","Doenca (Outros)","Licenca Maternidade","Servico Militar","Outros"}
cCond   := "A"
cCond   += If(MV_PAR04==1,"|D","")
cCond   += If(MV_PAR05==1,"|F","")

_QUALSALARIO:=1
@ 1,1 to  150,300 DIALOG oDlg2X TITLE "Qual Remuneracao deseja compor ?"
@ 10, 49 SAY "1 - Total Remuneracao da Folha Calculada"
@ 22, 49 SAY "2 - Salaro Base do Cadastro"
@ 44, 49 GET _QUALSALARIO PICTURE "99"
@ 60, 90 BmpButton Type 1 Action Close(oDlg2X)
Activate Dialog oDlg2X Centered


DbSelectArea("CTT")
DbSetOrder(1)
DbSelectArea("SRJ")
DbSetOrder(1)
DbSelectArea("SRH")
DbSetOrder(2)
DbSelectArea("SR8")
DbSetorder(1)
dbSelectArea("SRA")
dbSetOrder(8)

SetRegua(RecCount())

dbGoTop()
cCusto := RA_CC
_TTFUN:=0
While !EOF()
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	lOk := .T.
	
	Do Case
		Case MV_PAR01 == 1 // Normais
			//           lOk := If(Empty(RA_SITFOLH),.T.,.F.)
		Case MV_PAR01 == 2 // Ferias
		   lOk := If(!RA_SITFOLH$"AD",.T.,.F.)
		Case MV_PAR01 == 3 // Demitidos
			lOk := If(RA_SITFOLH=="D",.T.,.F.)
		Case MV_PAR01 == 4 // Afastados
			lOk := If(RA_SITFOLH$cCond,.T.,.F.)
	EndCase
	
	cDataSit := SPACE(10)
	cDataRET := SPACE(10)
	cTipo    := ""
	
	If MV_PAR01==1 // Normais
		lOK := If(SRA->RA_SITFOLH$" FA",lOk,.F.)
	   cDataSit := DtoC(RA_ADMISSA)
	ENDIF
	If (MV_PAR01==1 .AND. SRA->RA_SITFOLH="F") .OR. MV_PAR01 == 2 // Ferias
		DbSelectArea("SRH")
		DbSeek(xFilial("SRH")+SRA->RA_MAT,.T.)
		While !Eof() .And. RH_FILIAL == SRA->RA_FILIAL .And. RH_MAT == SRA->RA_MAT
         IF SRH->RH_DATAINI >= MV_PAR02 .AND. SRH->RH_DATAINI <= MV_PAR03
			   lOk := .T.
			   cDataSit := DtoC(SRH->RH_DATAINI)
			   cDataRET := DtoC(SRH->RH_DATAFIM)
			   cTipo := "FERIAS"
			   EXIT
         ENDIF
			DbSkip()
		EndDo
		DbSelectArea("SRA")
	ElseIf (MV_PAR01==1 .AND. SRA->RA_SITFOLH="D") .OR. MV_PAR01 == 3 // Demitidos
		lOk := IF(RA_DEMISSA < MV_PAR02 .Or. RA_DEMISSA > MV_PAR03,.F.,lOk)
		cDataSit := DtoC(RA_DEMISSA)
		cTipo := "DEMITIDO"
	ElseIf (MV_PAR01==1 .AND. SRA->RA_SITFOLH="A") .OR. MV_PAR01 == 4 // Afastados
		If SRA->RA_SITFOLH == "A"
			DbSelectArea("SR8")
			DbSeek(xFilial("SR8")+SRA->RA_MAT,.T.)
			While !Eof() .And. R8_FILIAL == SRA->RA_FILIAL .And. R8_MAT == SRA->RA_MAT
				DbSkip()
			EndDo
			DbSkip(-1)
			If R8_MAT == SRA->RA_MAT
				lOk := If(R8_DATAINI < MV_PAR02 .Or. R8_DATAINI > MV_PAR03,.F.,lOk)
				cDataSit := DtoC(R8_DATAINI)
				SX5->(DbSeek(xFilial("SX5")+"30"+SR8->R8_TIPO,.T.)) //aMotivo[Val(R8_AFARAIS)/10]
				cTipo := SX5->X5_DESCRI
			Else
				lOk := .F.
			EndIf
		EndIf

		If SRA->RA_SITFOLH == "F" .And. MV_PAR05 == 1
			DbSelectArea("SRH")
			DbSeek(xFilial("SRH")+SRA->RA_MAT,.T.)
			While !Eof() .And. RH_FILIAL == SRA->RA_FILIAL .And. RH_MAT == SRA->RA_MAT
				DbSkip()
			EndDo
			DbSkip(-1)
			If RH_MAT == SRA->RA_MAT
				lOk := If(SRH->RH_DATAINI < MV_PAR02 .Or. SRH->RH_DATAFIM > MV_PAR03,.F.,lOk)
				cDataSit := DtoC(SRH->RH_DATAINI)
			   cDataRET := DtoC(SRH->RH_DATAFIM)
				cTipo := ".FERIAS."
			Else
				lOk := .F.
			EndIf
		EndIf
		If SRA->RA_SITFOLH == "D" .And. MV_PAR04 == 1
			cTipo := ".DEMITIDO."
			cDataSit := DtoC(SRA->RA_DEMISSA)
		EndIf
		DbSelectArea("SRA")
	EndIf

   IF MV_PAR01 == 2 .AND. cTIPO # "FERIAS"   // NO RELATORIO DE FERIAS NAO IMPRIMIR DEMITIDOS E AFASTADOS
      lOK:=.F.
   ENDIF   
	If !lOk
		DbSkip()
		Loop
	EndIf
	
	IF _QUALSALARIO=1
		_SALARIO:=0                          // COMPOR PELA BASE DE INSS NA FOLHA DO MES
	ELSE
		_SALARIO:=SRA->RA_SALARIO            // PEGA SALARIO BASE DO CADASTRO
	ENDIF
	_SEGURO :=(IIF(SRA->RA_SALARIO<=26028,SRA->RA_SALARIO,26028)*0.30)*0.02245         // SEGURO DE VIDA
	_VISAVA :=583.52                                                                   // VALOR OUT /16
	_UNIMED :=0
	_UNIODON:=0
	DBSELECTAREA("SRC")
	DBSETORDER(1)
	DBSEEK(xFilial("SRC")+SRA->RA_MAT)
	WHILE !EOF() .AND. RC_MAT=SRA->RA_MAT
		DO CASE
			CASE _QUALSALARIO=1 .AND. RC_PD$"721/722/723/724"  // REMUNERACAO (BASE DE INSS)
				_SALARIO+=RC_VALOR
			CASE RC_PD$"850/852"
				_UNIMED +=RC_VALOR
			CASE RC_PD$"861"
				_UNIODON+=RC_VALOR
		ENDCASE
		DBSKIP()
	ENDDO
	
	
	DbSelectArea("SRA")               // INICIA IMPRESSAO DO RELATORIO
	If nLin > 55
		nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin += 1
		CTT->(DbSeek(xFilial("CTT")+SRA->RA_CC,.T.))
		@nLin,000 PSAY "C.Custo : "+Trim(SRA->RA_CC)+" - "+CTT->CTT_DESC01
		nLin += 2
		cCusto := SRA->RA_CC
	Endif
	
	If SRA->RA_CC <> cCusto
		@nLin,00 PSAY Replicate("-",Limite)
		nLin += 1
		CTT->(DbSeek(xFilial("CTT")+SRA->RA_CC,.T.))
		@nLin,000 PSAY "C.Custo : "+Trim(SRA->RA_CC)+" - "+CTT->CTT_DESC01
		nLin += 2
		cCusto := SRA->RA_CC
	EndIf
	
	SRJ->(DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC,.T.))
	
   _Sit :=cTipo
	If EMPTY(RA_SITFOLH) .AND. MV_PAR01#2
		_Sit:= " "
		cDataSit:=" "
	EndIf
	If MV_PAR01 == 4
		_Sit:= cTipo // Motivo do afastamento
	EndIf
	
	@nLin,0 PSay SRA->RA_MAT+" "+SUBSTR(SRA->RA_NOME,1,50)+" "+DtoC(SRA->RA_NASC)+" "+DtoC(SRA->RA_ADMISSA)+" "+SRJ->RJ_DESC+" "+_Sit+":"+cDataSit
	
	_TTFUN++
	nLin += 1

   GRAVA_TMP()    // GRAVA REGISTRO NO ARQUIVO TEMPORARIO
	
	DbSelectArea("SRA")
	dbSkip()
	
EndDo
nLin += 1
@nLin,0 PSay STR(_TTFUN,6,0)+" funcionarios listados"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

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

If _GeraXls=2 .AND. File(cArqTemp+".DTC")
	DbSelectArea("TMP")
	DBGOTOP()
//	COPY TO RELFUN.CSV
	_cArqRen:="\SYSTEM\TEMPDBF\RELFUN.CSV"
	Copy to &_cArqRen VIA "DBFCDXADS" 
	//Copiando Arquivo criado .DBF para o diretorio especํfico no Cliente
	IF CPYS2T("\SYSTEM\TEMPDBF\RELFUN.CSV","C:\Relato\",.F.)
		MSGINFO("Arquivo gerado com sucesso! C:\Relato\RELFUN.CSV")
	ELSE
		ALERT("ERRO NA COPIA")
	ENDIF
EndIf

dbSelectArea('TMP')
dbCloseArea()
cArqTemp2 := cArqTemp + '.DTC'
Delete File &cArqTemp2
cArqTemp3 := cArqTemp + '.CDX'
Delete File &cArqTemp3


Return

//************************
STATIC FUNCTION GRAVA_TMP()
//***********************
	DBSELECTAREA("TMP")
	RECLOCK("TMP",.T.)
	TMP_CCUS:=SRA->RA_CC
	TMP_DESC:=POSICIONE("CTT",1,XFILIAL("CTT")+SRA->RA_CC,"CTT_DESC01")
	TMP_MATR:=SRA->RA_MAT
	TMP_NOME:=SUBSTR(SRA->RA_NOMECMP,1,50)
	TMP_ADMI:=DTOC(SRA->RA_ADMISSA)
	TMP_FUNC:=SRA->RA_CODFUNC
	TMP_DFUN:=SRJ->RJ_DESC
	TMP_CARGO :=Substr(fDesc("SQ3",SRA->RA_CARGO,"SQ3->Q3_DESCSUM"),1,30)
	TMP_NASC  :=DTOC(SRA->RA_NASC)
	TMP_RG    :=SRA->RA_RG
	TMP_PIS   :=SRA->RA_PIS
	TMP_CPF   :=SRA->RA_CIC
	TMP_DATAST:=cDataSit
	TMP_DATRET:=cDataRET
	TMP_TIPOST:=cTipo
	
	TMP_SALARI:=_SALARIO
	TMP_UNIMED:=_UNIMED
	TMP_UNIODO:=_UNIODON
	TMP_SEGURO:=_SEGURO
	TMP_VISAVA:=_VISAVA
	
	TMP_FGTS  :=_SALARIO*0.08
	TMP_PROV13:=_SALARIO/12
	TMP_PROVFE:=_SALARIO/12    
	TMP_PROV1F:=(_SALARIO/12)/3
	TMP_INSS  :=_SALARIO*0.20
	TMP_PRVFGT:=((_SALARIO/12)+(_SALARIO/12)+((_SALARIO/12)/3)) * 0.08    // PROVISAO DE FGTS 13+FERIAS+1/3 FERIAS
	TMP_PRVINS:=((_SALARIO/12)+(_SALARIO/12)+((_SALARIO/12)/3)) * 0.20    // PROVISAO DE FGTS 13+FERIAS+1/3 FERIAS
	
	MSUNLOCK()
RETURN 

