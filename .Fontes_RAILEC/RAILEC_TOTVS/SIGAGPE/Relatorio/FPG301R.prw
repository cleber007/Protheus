#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FPG301R  บ Autor ณ SANDRO ULISSES     บ Data ณ  25/08/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relacao de Funcionarios e Dependentes                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FPG301R()

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "RELACAO DE DEPENDENTES"
	Local cPict          := ""
	Local titulo       := "RELACAO DE DEPENDENTES"
	Local nLin         := 80

	Local Cabec1       := ""
	Local Cabec2       := ""
	Local imprime      := .T.
	Local aOrd := {}
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite           := 80
	Private tamanho          := "G"
	Private nomeprog         := "FPG301R" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo            := 18
	Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey        := 0
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "FPG301R" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cPerg      := "FPG301"

	Private cString := "SRA"
	DbSelectArea("SRB")
	DbSetOrder(1)
	dbSelectArea("SRA")
	dbSetOrder(1)


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

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  25/08/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem,xLin


	//+-----------------------------------------------------------+
	//ฆ CRIA ARQUIVO TEMPORARIO                                   ฆ
	//+-----------------------------------------------------------+
	// Estrutura do Arquivo Temporario

	aStru := {}
	aadd(aStru , {'T_CCUS'  ,'C', 09,0} )
	aadd(aStru , {'T_DESC'  ,'C', 30,0} )
	aadd(aStru , {'T_MATR'  ,'C', 06,0} )
	aadd(aStru , {'T_NOME'  ,'C', 50,0} )
	aadd(aStru , {'T_CPFFUN'   ,'C', 11,0} )
	aadd(aStru , {'T_NASCFU','C', 10,0} )
	aadd(aStru , {'T_DEPE'  ,'C', 40,0} )
	aadd(aStru , {'T_GRAU'  ,'C', 15,0} )
	aadd(aStru , {'T_NASCIM','C', 10,0} )
	aadd(aStru , {'T_IDAD'  ,'N', 03,0} )
	aadd(aStru , {'T_SEXO'  ,'C', 01,0} )
	aadd(aStru , {'T_CPF'   ,'C', 11,0} )
	aadd(aStru , {'T_OBS'     ,'C', 40,0} )
	aadd(aStru , {'T_SXRESP'  ,'C', 01,0} )
	aadd(aStru , {'T_PAIMAE'  ,'C', 50,0} )
	aadd(aStru , {'T_NUMDEP'  ,'C', 02,0} )

	cArqTemp := CriaTrab(aStru , .t.)

	dbUseArea(.T.,,cArqTemp,'TMP',.f.)

	DBSELECTAREA("TMP")



	dbSelectArea("SRA")
	IF MV_PAR03=1
		DBSETORDER(1)
	ELSEIF MV_PAR03=2
		DBSETORDER(3)
	ELSE
		dbSetOrder(8)     // RA_CC+RA_NOMECMP
	ENDIF

	SetRegua(RecCount())

	dbGoTop()

	While !EOF()

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		If nLin > 54 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		If SRA->RA_SITFOLH="D"
			SRA->(DBSKIP())
			Loop
		ENDIF

		_PRIMEIRO:=.F.
		If MV_PAR01 == 1
			@nLin,0 PSay SRA->RA_MAT + "-" + SUBSTR(SRA->RA_NOMECMP,1,50)+" Nasc: "+DtoC(SRA->RA_NASC)+" CC:"+ALLTRIM(SRA->RA_CC)+"-"+POSICIONE("CTT",1,XFILIAL("CTT")+SRA->RA_CC,"CTT_DESC01")+" - Sexo: "+SRA->RA_SEXO
			nLin += 1
			_PRIMEIRO:=.T.
		EndIf

		xLin := nLin
		_NUMDEP:=0
		DbSelectArea("SRB")
		DbSeek(xFilial("SRB")+SRA->RA_MAT,.T.)
		While !EoF() .And. RB_MAT == SRA->RA_MAT

			If MV_PAR02 == 2 .And. RB_GRAUPAR # "C"
				DbSkip()
				Loop
			ElseIf MV_PAR02 == 3 .And. RB_GRAUPAR # "F"
				DbSkip()
				Loop
			ElseIf MV_PAR02 == 4 .And. RB_GRAUPAR # "O"
				DbSkip()
				Loop
			EndIf
			_NUMDEP++   // SOMA NUMERO DE DEPENDENTES POR FUNCIONARIO
			DBSKIP()
		ENDDO

		// ********************************************* FAZ LOOP DE NOVO PARA A IMPRESSAO DOS DEPENDENTES
		DbSeek(xFilial("SRB")+SRA->RA_MAT,.T.)
		While !EoF() .And. RB_MAT == SRA->RA_MAT

			If MV_PAR02 == 2 .And. RB_GRAUPAR # "C"
				DbSkip()
				Loop
			ElseIf MV_PAR02 == 3 .And. RB_GRAUPAR # "F"
				DbSkip()
				Loop
			ElseIf MV_PAR02 == 4 .And. RB_GRAUPAR # "O"
				DbSkip()
				Loop
			EndIf

			_novofunc:=.f.
			If xLin == nLin
				If MV_PAR01 == 2
					@nLin,0 PSay SRA->RA_MAT + " - " + substr(SRA->RA_NOMECMP,1,50)+" - Sexo: "+SRA->RA_SEXO
					//				nLin += 1
					_novofunc:=.t.
				EndIf
				nLin += 1
			EndIf
			_IDADE:=INT((DDATABASE-RB_DTNASC) / 365)
			@nLin,9 PSay SUBSTR(RB_NOME,1,50)+" "+DtoC(RB_DTNASC)+"    "+STRZERO(_IDADE,2,0)+" anos    CPF: "+SRB->RB_CIC+"  "

			_Grau:=RB_GRAUPAR
			If RB_GRAUPAR=="F"
				_Grau:="Filho(a)"
			ElseIf RB_GRAUPAR == "C"
				_Grau:="Esposa(o)"
			ElseIf RB_GRAUPAR == "O"
				_Grau:="Outros"
			EndIf

			@nLin,Pcol() PSay _Grau
			IF !EMPTY(SRB->RB_OBS)
				nLin++
				@nLin, 015 PSAY "*("+SRB->RB_OBS+")"
			ENDIF


			DBSELECTAREA("TMP")
			RECLOCK("TMP",.T.)
			T_CCUS:=SRA->RA_CC
			T_DESC:=POSICIONE("CTT",1,XFILIAL("CTT")+SRA->RA_CC,"CTT_DESC01")
			T_MATR:=SRA->RA_MAT
			T_NOME:=SUBSTR(SRA->RA_NOMECMP,1,50)
			T_CPFFUN :=SRA->RA_CIC
			T_NASCFU:=DTOC(SRA->RA_NASC)
			T_DEPE:=SUBSTR(SRB->RB_NOME,1,50)
			T_GRAU:=_Grau
			T_IDAD:=_Idade
			T_SEXO:=SRB->RB_SEXO
			T_CPF :=SRB->RB_CIC
			T_SXRESP:=SRA->RA_SEXO
			T_OBS   :=SRB->RB_OBS
			T_NASCIM:=DTOC(SRB->RB_DTNASC)
			if _novofunc .OR. _PRIMEIRO
				T_PAIMAE:=SUBSTR(SRA->RA_NOME,1,50)
				T_NUMDEP:=STRZERO(_NUMDEP,2,0)
				_PRIMEIRO:=.F.
			endif
			MSUNLOCK()
			DBSELECTAREA("SRB")
			nLin += 1
			DbSkip()
		EndDo
		IF _NUMDEP>0
			@ nLin,07 PSay STRZERO(_NUMDEP,2,0)+" dependente(s)."
			nLin += 1
           ELSE
			DBSELECTAREA("TMP")
			RECLOCK("TMP",.T.)
			T_CCUS:=SRA->RA_CC
			T_DESC:=POSICIONE("CTT",1,XFILIAL("CTT")+SRA->RA_CC,"CTT_DESC01")
			T_MATR:=SRA->RA_MAT
			T_NOME:=SUBSTR(SRA->RA_NOMECMP,1,50)
			T_CPFFUN :=SRA->RA_CIC
			T_NASCFU:=DTOC(SRA->RA_NASC)
			MSUNLOCK()
           
		ENDIF
		DbSelectArea("SRA")
		dbSkip() // Avanca o ponteiro do registro no arquivo
	EndDo

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
	COPY TO RELDEP.CSV VIA "DBFCDXADS"
	//Copiando Arquivo criado .DBF para o diretorio especํfico no Cliente
	IF CPYS2T("\SYSTEM\RELDEP.CSV","C:\Relato\",.F.)
		MSGINFO("Arquivo gerado com sucesso! C:\Relato\RELDEP.CSV")
	ELSE
		ALERT("ERRO NA COPIA")
	ENDIF
	
ENDIF

dbSelectArea('TMP')
dbCloseArea()
cArqTemp2 := cArqTemp + '.DBF'
Delete File &cArqTemp2
cArqTemp3 := cArqTemp + '.CDX'
Delete File &cArqTemp3

	dbSelectArea('SRA')
	DBSETORDER(1)
	DBGOTOP()

Return

