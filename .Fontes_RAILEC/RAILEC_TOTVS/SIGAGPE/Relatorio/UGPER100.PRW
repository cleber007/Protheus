#INCLUDE "rwmake.ch"

User Function UGPER100()

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "COMPARA CENTRO DE CUSTO"
	Local cPict          := ""
	Local titulo       := "RELACAO DE VERBAS"
	Local nLin         := 80


	Local imprime      := .T.
	Local aOrd := {}
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite           := 132
	Private tamanho          := "M"
	Private nomeprog         := "UGPER100" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo            := 18
	Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey        := 0
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "UGPER100" // Coloque aqui o nome do arquivo usado para impressao em disco
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
	_PAR07 :=STRZERO(year(DDATABASE-32),4,0)+STRZERO(MONTH(DDATABASE-32),2,0)
	_CCUSTO:=SPACE(9)
	_VERBAS:=SPACE(23)
	_ORDEM :="C"

	@ 1,1 to  300,450 DIALOG oDlg2A TITLE "Compara ?"
	@ 10, 10 SAY "Ano Mes BASE ?"
	@ 10, 59 GET _PAR06 PICTURE "999999" VALID NAOVAZIO()
	@ 20, 10 SAY "Por CC ou Nome ?"
	@ 20, 59 GET _ORDEM PICTURE "!" VALID _ORDEM$"CN"
	//@ 30, 10 SAY "CCusto ?"
	//@ 30, 59 GET _CCUSTO SIZE 20,12 F3 "CTT"
	@ 40, 10 SAY "Verbas ? (Sep por Virgulas)"
	@ 50, 10 GET _VERBAS SIZE 100,12 F3 "SRV"

	@ 60, 90 BmpButton Type 1 Action Close(oDlg2A)
	Activate Dialog oDlg2A Centered


	_V01:=SUBSTR(_VERBAS,01,3)
	_V02:=SUBSTR(_VERBAS,05,3)
	_V03:=SUBSTR(_VERBAS,09,3)
	_V04:=SUBSTR(_VERBAS,13,3)
	_V05:=SUBSTR(_VERBAS,17,3)
	_V06:=SUBSTR(_VERBAS,21,3)

	_CCUSTO:=ALLTRIM(_CCUSTO)
	_VERBAS:=ALLTRIM(_VERBAS)
	IF !EMPTY(_Verbas)
		Cabec1       := "Verbas: "+_Verbas
	ENDIF


	DbSelectArea("SX3")
	DbSetOrder(2)
	// Busca Arquivo
	DbSeek("RA_CC")
	IF FOUND()
		nSizeCC  := X3_TAMANHO
	ELSE
		ALERT("FALTA RA_CC NO SX3")
		RETURN Nil
	ENDIF

	aStru := {}
	aadd(aStru , {'TMP_CCUS'   ,'C', nSizeCC,0} )
	aadd(aStru , {'TMP_DESC'   ,'C', 40,0} )
	aadd(aStru , {'TMP_MATR'   ,'C', 06,0} )
	aadd(aStru , {'TMP_NOME'   ,'C', 50,0} ) //40
	aadd(aStru , {'TMP_CODFU'  ,'C', 06,0} )
	aadd(aStru , {'TMP_CVER'   ,'C', 03,0} )
	aadd(aStru , {'TMP_DVER'   ,'C', 25,0} )
	aadd(aStru , {'TMP_REFE'   ,'N', 06,2} )
	aadd(aStru , {'TMP_MES1'   ,'N', 12,2} )
	aadd(aStru , {'TMP_MES2'   ,'N', 12,2} )
	aadd(aStru , {'TMP_MES3'   ,'N', 12,2} )
	aadd(aStru , {'TMP_MES4'   ,'N', 12,2} )
	aadd(aStru , {'TMP_MES5'   ,'N', 12,2} )
	aadd(aStru , {'TMP_MES6'   ,'N', 12,2} )


	cArqTemp := CriaTrab(aStru , .t.)
	dbUseArea(.T.,,cArqTemp,'TMP',.f.)
	IF _ORDEM="C"
		INDEX ON TMP_CCUS+TMP_MATR+TMP_CVER TO &cArqTemp
	ELSE
		INDEX ON TMP_NOME TO &cArqTemp
	ENDIF

	RptStatus({|| RunDetRep(Cabec1,Cabec2,Titulo,nLin) },Titulo)

	DbSelectArea("SRA")
	DbSetOrder(1)
	DBGOTOP()

Return



//**********************************
Static Function RunDetRep(Cabec1,Cabec2,Titulo,nLin)
//**********************************
Local _aItns := {}
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

	WHILE !EOF() .AND. xFilial("SRA")==_Fil
		INCREGUA()
		IF !EMPTY(_CCUSTO) .AND. RA_CC#_CCUSTO    // FILTRO DE CENTRO DE CUSTOS
			DBSKIP()
			Loop
		ENDIF
		DBSELECTAREA("SRC")
		DBSEEK(xFilial("SRC")+SRA->RA_MAT)
		WHILE !EOF() .AND. RC_MAT=SRA->RA_MAT
			IF !RC_PD$_VERBAS
				DBSKIP()
				Loop
			ENDIF
			DBSELECTAREA("TMP")
			DBSEEK(SRA->RA_CC+SRA->RA_MAT+SRC->RC_PD)
			IF !FOUND()
				RECLOCK("TMP",.T.)
				TMP_CCUS:=SRA->RA_CC
				TMP_DESC:=Posicione("CTT", 1 ,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01")
				TMP_MATR:=SRA->RA_MAT
				TMP_NOME:=SUBSTR(SRA->RA_NOMECMP,1,50) // NOME
				TMP_CODFU:=SRA->RA_CODFUNC
				TMP_CVER:=SRC->RC_PD
				TMP_DVER:=POSICIONE("SRV",1,XFILIAL("SRV")+SRC->RC_PD,"RV_DESC")
				TMP_REFE:=SRC->RC_HORAS
			ELSE
				RECLOCK("TMP",.F.)
			ENDIF

			TMP_MES1:=IIF(_V01=SRC->RC_PD,TMP_MES1+SRC->RC_VALOR,TMP_MES1)
			TMP_MES2:=IIF(_V02=SRC->RC_PD,TMP_MES2+SRC->RC_VALOR,TMP_MES2)
			TMP_MES3:=IIF(_V03=SRC->RC_PD,TMP_MES3+SRC->RC_VALOR,TMP_MES3)
			TMP_MES4:=IIF(_V04=SRC->RC_PD,TMP_MES4+SRC->RC_VALOR,TMP_MES4)
			TMP_MES5:=IIF(_V05=SRC->RC_PD,TMP_MES5+SRC->RC_VALOR,TMP_MES5)
			TMP_MES6:=IIF(_V06=SRC->RC_PD,TMP_MES6+SRC->RC_VALOR,TMP_MES6)

			MSUNLOCK()
			DBSELECTAREA("SRC")
			DBSKIP()
		ENDDO

		DBSELECTAREA("SRA")
		DBSKIP()
	ENDDO

	nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin += 1
	_TT1:=_TT2:=0
	_TT3:=_TT4:=0
	_TT5:=_TT6:=0

	_TTG1:=_TTG2:=0
	_TTG3:=_TTG4:=0
	_TTG5:=_TTG6:=0
	DBSELECTAREA("TMP")
	DBGOTOP()

	IF _ORDEM="C"
		WHILE !EOF()
			_CC:=TMP_CCUS
			@ nLIN,001 PSAY TMP_CCUS+" - "+Posicione("CTT", 1 ,xFilial("CTT")+_CC,"CTT_DESC01")
			nLin++
			_TT1:=_TT2:=0
			_TT3:=_TT4:=0
			_TT5:=_TT6:=0
			WHILE !EOF() .AND. TMP_CCUS=_CC
				_MATR:=TMP_MATR
				@ nLIN,003 PSAY TMP_MATR      // ALTERADO 18-07-2018 MARINALDO SA
				@ nLIN,010 PSAY SUBSTR(TMP_NOME,1,50) // 40
				_FUNCAO:=Posicione("SRJ", 1 ,xFilial("SRJ")+TMP->TMP_CODFU,"RJ_DESC")
				WHILE !EOF() .AND. TMP_CCUS=_CC .AND. TMP_MATR=_MATR
					@ nLIN,063 PSAY TMP_CVER  //53
					@ nLIN,067 PSAY TMP_DVER  //57
					@ nLIN,103 PSAY TMP_REFE PICTURE "@EZ 999.99" //93
					@ nLIN,110 PSAY TMP_MES1 PICTURE "@EZ 99,999.99" //100
					@ nLIN,120 PSAY TMP_MES2 PICTURE "@EZ 99,999.99" //110
					@ nLIN,130 PSAY TMP_MES3 PICTURE "@EZ 99,999.99" //120
					@ nLIN,140 PSAY TMP_MES4 PICTURE "@EZ 99,999.99" //130
					@ nLIN,150 PSAY TMP_MES5 PICTURE "@EZ 99,999.99" //140
					@ nLIN,160 PSAY TMP_MES6 PICTURE "@EZ 99,999.99" //150
					IF !EMPTY(_FUNCAO)
						@ nLIN,172 PSAY _FUNCAO //162
						_Funcao:=""
					ENDIF
					_TT1+=TMP_MES1
					_TT2+=TMP_MES2
					_TT3+=TMP_MES3
					_TT4+=TMP_MES4
					_TT5+=TMP_MES5
					_TT6+=TMP_MES6
					nLin++
					If nLin > 55
						nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin += 1
					Endif
					Aadd(_aItns,{TMP_CCUS,Posicione("CTT", 1 ,xFilial("CTT")+_CC,"CTT_DESC01"),TMP_MATR,TMP_NOME,_FUNCAO,TMP_CVER,TMP_DVER,TMP_REFE,TMP_MES1,TMP_MES2,TMP_MES3,TMP_MES4,TMP_MES5,TMP_MES6})
					DBSKIP()
				ENDDO
			ENDDO
			@ nLIN,053 PSAY ". Total do CCusto:"
			@ nLIN,099 PSAY _TT1 PICTURE "@Ez 999,999.99"
			@ nLIN,110 PSAY _TT2 PICTURE "@Ez 999,999.99"
			@ nLIN,121 PSAY _TT3 PICTURE "@Ez 999,999.99"
			@ nLIN,132 PSAY _TT4 PICTURE "@Ez 999,999.99"
			@ nLIN,143 PSAY _TT5 PICTURE "@Ez 999,999.99"
			@ nLIN,154 PSAY _TT6 PICTURE "@Ez 999,999.99"
			nLin++
			@nLin,  0 PSAY __PrtThinLine()

			_TTG1+=_TT1
			_TTG2+=_TT2
			_TTG3+=_TT3
			_TTG4+=_TT4
			_TTG5+=_TT5
			_TTG6+=_TT6
			nLIN++
		ENDDO
		@ nLIN,050 PSAY ". Total G E R A L:"
		@ nLIN,097 PSAY _TTG1 PICTURE "@E 9,999,999.99"
		@ nLIN,110 PSAY _TTG2 PICTURE "@EZ 999,999.99"
		@ nLIN,121 PSAY _TTG3 PICTURE "@EZ 999,999.99"
		@ nLIN,132 PSAY _TTG4 PICTURE "@EZ 999,999.99"
		@ nLIN,143 PSAY _TTG5 PICTURE "@EZ 999,999.99"
		@ nLIN,154 PSAY _TTG6 PICTURE "@EZ 999,999.99"
	ELSE
		WHILE !EOF()
			@ nLIN,003 PSAY TMP_MATR
			@ nLIN,010 PSAY LEFT(TMP_NOME,40)
			_FUNCAO:=Posicione("SRJ", 1 ,xFilial("SRJ")+TMP->TMP_CODFU,"RJ_DESC")
			@ nLIN,053 PSAY TMP_CVER
			@ nLIN,057 PSAY TMP_DVER
			@ nLIN,093 PSAY TMP_REFE PICTURE "@E 999.99"

			@ nLIN,100 PSAY TMP_MES1 PICTURE "@EZ 99,999.99"
			@ nLIN,110 PSAY TMP_MES2 PICTURE "@EZ 99,999.99"
			@ nLIN,110 PSAY TMP_MES2 PICTURE "@EZ 99,999.99"
			@ nLIN,120 PSAY TMP_MES3 PICTURE "@EZ 99,999.99"
			@ nLIN,130 PSAY TMP_MES4 PICTURE "@EZ 99,999.99"
			@ nLIN,140 PSAY TMP_MES5 PICTURE "@EZ 99,999.99"
			@ nLIN,150 PSAY TMP_MES6 PICTURE "@EZ 99,999.99"

			@ nLIN,162 PSAY _FUNCAO+"  "+TMP_CCUS+" - "+Posicione("CTT", 1 ,xFilial("CTT")+TMP->TMP_CCUS,"CTT_DESC01")

			_TT1+=TMP_MES1
			_TT2+=TMP_MES2
			_TT3+=TMP_MES3
			_TT4+=TMP_MES4
			_TT5+=TMP_MES5
			_TT6+=TMP_MES6
			nLin++
			If nLin > 55
				nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin += 1
			Endif
			Aadd(_aItns,{TMP_CCUS,Posicione("CTT", 1 ,xFilial("CTT")+TMP->TMP_CCUS,"CTT_DESC01"),TMP_MATR,TMP_NOME,_FUNCAO,TMP_CVER,TMP_DVER,TMP_REFE,TMP_MES1,TMP_MES2,TMP_MES3,TMP_MES4,TMP_MES5,TMP_MES6})
			DBSKIP()
		ENDDO
		@ nLIN,050 PSAY ". Total G E R A L:"
		@ nLIN,097 PSAY _TT1 PICTURE "@E 9,999,999.99"
		@ nLIN,110 PSAY _TT2 PICTURE "@EZ 999,999.99"
		@ nLIN,121 PSAY _TT3 PICTURE "@EZ 999,999.99"
		@ nLIN,132 PSAY _TT4 PICTURE "@EZ 999,999.99"
		@ nLIN,143 PSAY _TT5 PICTURE "@EZ 999,999.99"
		@ nLIN,154 PSAY _TT6 PICTURE "@EZ 999,999.99"
	ENDIF

	nLin++
	@nLin,  0 PSAY __PrtThinLine()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SET DEVICE TO SCREEN

	DbSelectArea("SRC")
	DBSETORDER(1)
	DBGOTOP()
	DbSelectArea("SRA")
	DBSETORDER(1)
	DBGOTOP()


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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

		GrvExcel(_aItns)
		/*
		DbSelectArea("TMP")
		DBGOTOP()
		COPY TO RELFUN.CSV VIA "CTREECDX"
		//Copiando Arquivo criado .DBF para o diretorio específico no Cliente
		IF CPYS2T("\SYSTEM\RELFUN.CSV","C:\Relato\",.F.)
		MSGINFO("Arquivo gerado com sucesso! C:\Relato\RELFUN.CSV")
		ELSE
		ALERT("ERRO NA COPIA")
		ENDIF
		*/



	ENDIF

	dbSelectArea('TMP')
	dbCloseArea()
	cArqTemp2 := cArqTemp  + GetDBExtension()
	Delete File &cArqTemp2
	cArqTemp3 := cArqTemp + '.CDX'
	Delete File &cArqTemp3

Return



/********************************************************************************************************************************/
Static Function GrvExcel(_aDados)
/********************************************************************************************************************************/
	
	Local oExcel 	:= FWMSEXCEL():New()
	Local cWorkSheet := "RELACAO DE VERBAS"
	Local cTable := "Dados"
	Local cTipo   := "*.xml | *.xmls |"
	Local nt := 0

	//Nome da Worksheet
	oExcel:AddworkSheet(cWorkSheet)
	//Nome da Tabela
	oExcel:AddTable (cWorkSheet,cTable)


	oExcel:AddColumn(cWorkSheet, cTable, "TMP_CCUS"				,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_DESC"			    ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_MATR"			    ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_NOME"			    ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_CODFU"			,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_CVER"			    ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_DVER"			    ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_REFE"			    ,3,2)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_MES1"			    ,3,2)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_MES2"			    ,3,2)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_MES3"			    ,3,2)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_MES4"			    ,3,2)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_MES5"			    ,3,2)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_MES6"			    ,3,2)


	For nt := 1 to Len(_aDados)
		oExcel:AddRow(cWorkSheet,cTable,{	_aDados[nt][01],;
		_aDados[nt][02],;
		_aDados[nt][03],;
		_aDados[nt][04],;
		_aDados[nt][05],;
		_aDados[nt][06],;
		_aDados[nt][07],;
		_aDados[nt][08],;
		_aDados[nt][09],;
		_aDados[nt][10],;
		_aDados[nt][11],;
		_aDados[nt][12],;
		_aDados[nt][13],;								
		_aDados[nt][14]})
	Next nt


	Arquivo := cGetFile(cTipo,OemToAnsi("Selecione o Diretorio do arquivo de atualização"),,'C:\',.T.)
	Arquivo := Alltrim(Arquivo)

	If RIGHT(Arquivo,4) <> ".xml" .Or. RIGHT(Arquivo,4) <> ".XML" .Or. RIGHT(Arquivo,4) <> ".Xml"
		Arquivo := Alltrim(Arquivo+".xml")
	EndIf


	oExcel:Activate()
	oExcel:GetXMLFile(Arquivo)
	MSGINFO("Planilha gravada Sucesso: "+Arquivo)



Return(.T.)
/********************************************************************************************************************************/
