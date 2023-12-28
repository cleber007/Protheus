#INCLUDE "rwmake.ch"

//*********************
User Function FP_ANUAL()     // FOLHA DE PAGAMENTO ANUAL EM EXCEL ... JOSE MACEDO / ARTHUR MACEDO
	//*********************

	_ANOMESINI:=SPACE(6)
	_ANOMESFIM:=SPACE(6)
	_VERBA    :=SPACE(120)
	_PORCC    :="S"
	_MATRIC   :=SPACE(6)
	Private _PORFU    :="N"

	@ 1,1 to  300,450 DIALOG oDlg2A TITLE "Lista ?"
	@ 10, 10 SAY "Ano Mes Ini?"
	@ 10, 59 GET _ANOMESINI PICTURE "999999" VALID NAOVAZIO()
	@ 20, 10 SAY "Ano Mes Fim?"
	@ 20, 59 GET _ANOMESFIM PICTURE "999999"
	@ 30, 05 SAY "Verba Sep Virgula:"
	@ 30, 59 GET _VERBA SIZE 150,15 PICTURE "@!"

	@ 40, 10 SAY "Det CCusto ?"
	@ 40, 59 GET _PORCC PICTURE "!" VALID _PORCC$"SN"
	@ 50, 10 SAY "Det Colab. ?"
	@ 50, 59 GET _PORFU PICTURE "!" VALID _PORFU$"SN"
	@ 60, 10 GET _MATRIC F3 "SRA"

	@ 60, 90 BmpButton Type 1 Action Close(oDlg2A)
	Activate Dialog oDlg2A Centered

	cPerg := MsgBox ("Confirma a Geracao ?","Escolha","YESNO")
	If !cPerg
		Return Nil
	endif

	_VERBA:=ALLTRIM(_VERBA)

	IF EMPTY(_ANOMESFIM)
		_ANOMESFIM:=_ANOMESINI
	ENDIF
	IF !EMPTY(_MATRIC) // SE SELECIONA MATRICULA ENTAO DETALHA CC E FUNCIONARIO
		_PORCC    :="S"
		_PORFU    :="S"
	ENDIF

	aStru := {}
	aadd(aStru , {'TMP_ANOMES' ,'C', 06,0} )
	aadd(aStru , {'TMP_VERBA'  ,'C', 03,0} )
	aadd(aStru , {'TMP_DESC'   ,'C', 35,0} )
	aadd(aStru , {'TMP_PROVEN' ,'N', 17,2} )
	aadd(aStru , {'TMP_DESCON' ,'N', 17,2} )
	aadd(aStru , {'TMP_BASE'   ,'N', 17,2} )
	aadd(aStru , {'TMP_QTD'    ,'N', 17,2} )
	aadd(aStru , {'TMP_SALARI' ,'N', 17,2} )
	aadd(aStru , {'TMP_OCORR'  ,'N', 10,0} )
	aadd(aStru , {'TMP_CC'     ,'C', 09,0} )
	aadd(aStru , {'TMP_DESCCC' ,'C', 40,0} )
	aadd(aStru , {'TMP_MATR'   ,'C', 06,0} )
	IF _PORFU="S"
		aadd(aStru , {'TMP_NOME'   ,'C', 40,0} )
		aadd(aStru , {'TMP_ADM'    ,'C', 10,0} )
		aadd(aStru , {'TMP_SIT'    ,'C', 01,0} )
		aadd(aStru , {'TMP_FUNCAO' ,'C', 06,0} )
		aadd(aStru , {'TMP_DESCFU' ,'C', 40,0} )
		aadd(aStru , {'TMP_SEXO'   ,'C', 01,0} )
	ENDIF
/*
	cArqTemp := CriaTrab(aStru , .t.)
	dbUseArea(.T.,,cArqTemp,'TMP',.f.)
	INDEX ON TMP_ANOMES+TMP_CC+TMP_MATR+TMP_VERBA TO &cArqTemp
*/
	oTable := FWTemporaryTable():New("TMP", aStru)
	oTable:addIndex("01", {"TMP_ANOMES","TMP_CC","TMP_MATR","TMP_VERBA"})
	oTable:create()
	TMP:= oTable:GetRealName()

	Processa( {|| GERADADOS() }, "Lendo Provisoes" )// Substituido pelo assistente de conversao do AP5 IDE em 07/03/02 ==>    Processa( {|| Execute(TransfSF2) }, "Notas Fiscais de Saida" )

	dbSelectArea('TMP')
	dbCloseArea()
	/*
	cArqTemp2 := cArqTemp + GetDBExtension()
	Delete File &cArqTemp2
	cArqTemp3 := cArqTemp + '.CDX'
	Delete File &cArqTemp3
*/
	DBSELECTAREA("SRD")    // VOLTA ORDEM ORIGINAL
	dbClearFilter()
	DBSETORDER(1)
	DBGOTOP()

RETURN Nil

//*********************
STATIC FUNCTION GERADADOS()
	//*********************
	Local _aItns := {}
	DBSELECTAREA("SRD")
	DBORDERNICKNAME("RDDATA")  // RD_DATARQ+RD_CC+RD_MAT+RD_PD
	DBGOTOP()
	DBSEEK(xFilial("SRD")+_ANOMESINI) //,.T.)
	IF !FOUND()
		ALERT("Periodo Inicial Nao encontrado!")
		RETURN Nil
	ENDIF
	WHILE !EOF() .AND. RD_FILIAL==xFilial("SRD") .AND. RD_DATARQ <=_ANOMESFIM
		INCPROC()

		IF !EMPTY(_VERBA) .AND. !RD_PD$_VERBA    // FILTRO DE VERBA
			DBSKIP()
			Loop
		ENDIF
		IF !EMPTY(_MATRIC) .AND. RD_MAT#_MATRIC    // FILTRO DE MATRICULA
			DBSKIP()
			Loop
		ENDIF

		IF POSICIONE("SRA",1,XFILIAL("SRA")+SRD->RD_MAT,"RA_CATFUNC")="A"    // NAO CONSIDERA AUTONOMOS
			DBSKIP()
			Loop
		ENDIF

		_SALARI:=_PROVEN:=_DESCON:=_BASE:=0
		_TIPOCOD:=POSICIONE("SRV",1,XFILIAL("SRV")+SRD->RD_PD,"RV_TIPOCOD")
		IF _TIPOCOD="1"   // PROVENTO
			_PROVEN:=RD_VALOR
		ELSEIF _TIPOCOD="2"   // DESCONTO
			_DESCON:=RD_VALOR
		ELSEIF _TIPOCOD="3"   // BASE
			_BASE  :=RD_VALOR
		ENDIF

		_CC  :=IIF(_PORCC="N",SPACE(09),RD_CC)
		_DCC :=IIF(_PORCC="N",SPACE(40),POSICIONE("CTT",1,XFILIAL("CTT")+SRD->RD_CC,"CTT_DESC01"))
		_MATR:=IIF(_PORFU="N",SPACE(06),SRA->RA_MAT)
		_NOME:=IIF(_PORFU="N",SPACE(40),SRA->RA_NOME)
		_ADM :=IIF(_PORFU="N",SPACE(10),DTOC(SRA->RA_ADMISSA))
		_SIT :=IIF(_PORFU="N",SPACE(01),SRA->RA_SITFOLH)

		SRJ->(DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC,.T.))

		DBSELECTAREA("TMP")
		DBSEEK(SRD->RD_DATARQ+_CC+_MATR+SRD->RD_PD)
		IF !FOUND()
			RECLOCK("TMP",.T.)
			TMP_ANOMES:=SRD->RD_DATARQ
			TMP_VERBA :=SRD->RD_PD
			TMP_DESC  :=SRV->RV_DESC
			TMP_CC    :=_CC
			TMP_DESCCC:=_DCC
			TMP_MATR  :=_MATR
			IF _PORFU="S"
				TMP_NOME  :=_NOME
				TMP_ADM   :=_ADM
				TMP_SIT   :=_SIT
				TMP_FUNCAO:=SRA->RA_CODFUNC
				TMP_DESCFU:=SRJ->RJ_DESC
				TMP_SEXO  :=SRA->RA_SEXO
			ENDIF   
		ELSE
			RECLOCK("TMP",.F.)
		ENDIF
		TMP_PROVEN+=_PROVEN
		TMP_DESCON+=_DESCON
		TMP_BASE  +=_BASE
		TMP_QTD   +=IIF(_TIPOCOD="1",SRD->RD_HORAS,0)
		TMP_OCORR +=1
		TMP_SALARI+=_SALARI
		MSUNLOCK()

		AAdd(_aItns,{SRD->RD_DATARQ,SRD->RD_PD,SRV->RV_DESC,_PROVEN,_DESCON,_BASE,TMP_QTD,_SALARI,TMP_OCORR,_CC,_DCC,_MATR,_NOME,_ADM,_SIT,SRA->RA_CODFUNC,SRJ->RJ_DESC,SRA->RA_SEXO})
		DBSELECTAREA("SRD")    // VOLTA TABELA DO LOOP	
		DBSKIP()
	ENDDO


	IF _PORFU="S"
		DbSelectArea("SRD")
		DBSETORDER(1)  // MAT + DATARQ + PD
		DBGOTOP()
		DbSelectArea("TMP")
		DBGOTOP()
		WHILE !EOF()
			DBSELECTAREA("SRD")
			DBSEEK(xFilial("SRD")+TMP->TMP_MATR+TMP->TMP_ANOMES+"866") // ALUBAR
			IF FOUND()
				RECLOCK("TMP",.F.)
				TMP_SALARI:=SRD->RD_VALOR
				MSUNLOCK()
			ENDIF
			DBSELECTAREA("TMP")
			DBSKIP()
		ENDDO
	ENDIF


	//********************************************
	_GeraXls:=1
	@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Gera Planilha Excel ?"
	@ 10, 49 SAY "1 - Nao" //PIXEL
	@ 20, 49 SAY "2 - Sim" //PIXEL
	@ 30, 49 SAY "3 - Imprime Recibo Pgto." //PIXEL
	@ 44, 49 GET _GeraXls PICTURE "99" //PIXEL
	@ 60, 90 BmpButton Type 1 Action Close(oDlg2)
	Activate Dialog oDlg2 Centered
	IF _GeraXls=2



		GrvExcel(_aItns,_PORFU)


		/*
		DbSelectArea("TMP")
		DBGOTOP()
		COPY TO FOLHA_ACU.CSV VIA "CTREECDX"
		//Copiando Arquivo criado .DBF para o diretorio específico no Cliente
		IF CPYS2T("\SYSTEM\FOLHA_ACU.CSV","C:\Relato\",.F.)
		MSGINFO("Arquivo gerado com sucesso! C:\Relato\FOLHA_ACU.CSV")
		ELSE
		ALERT("ERRO NA COPIA")
		ENDIF
		*/


	ENDIF

	IF _GeraXls=3
		URECIBO()
	ENDIF

RETURN Nil

//**********************
STATIC FUNCTION URECIBO()    // IMPRESSAO DE CONTRA-CHEQUES
	//**********************

	Local cString := "SRA"        // alias do arquivo principal (Base)
	Local aOrd    := {"C.Custo + Matricula ","C.Custo + Nome",OemtoAnsi("C.Custo + Fun‡„o"),"Nome","Matricula",OemtoAnsi("Fun‡„o")}    //###############
	Local cDesc1  := ("RECIBOS DE PAGAMENTO")
	Local cDesc2  := ("Ser  impresso de acordo com os parametros solicitados pelo")
	Local cDesc3  := ("usuario.")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis Private(Basicas)                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aReturn  := {"Zebrado",1,"Administra‡„o",2,2,1,"",1 }	//###
	Private NomeProg := "URECIBO"
	Private aLinha   := { }
	Private nLastKey := 0
	Private cPerg    := ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis Utilizadas na funcao IMPR                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private Titulo   := "RECIBOS DE PAGAMENTO"
	Private AT_PRG   := "GPE340R"
	Private Wcabec0  := 2
	Private cabec1   := ""
	Private cabec2   := ""
	Private CONTFL   := 1
	Private nLin     := 80
	Private nTipo    := 18
	Private nTamanho := "P"
	Private Limite   := 80
	Private cbcont     := 00
	Private Tamanho  := "P"
	Private m_pag      := 01


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	wnrel:="URECIBO"            //Nome Default do relatorio em Disco
	wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

	If nLastKey = 27
		Return
	EndIf

	SetDefault(aReturn,cString)

	If nLastKey = 27
		Return
	EndIf



	dbSelectArea( "SRA" )
	dbSetOrder(1)
	dbGoTop()

	dbSelectArea( "TMP" )
	dbGoTop()

	nLIN:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) -2 //-3

	While !Eof()
		IF nLin>30
			nLIN:= 4
		ELSE
			nLIN+= 4
		ENDIF
		DBSELECTAREA("SRA")
		DBSEEK(xFILIAL("SRA")+TMP->TMP_MATR)
		DBSELECTAREA("TMP")
		@nLin,000 PSAY "Competencia: "+SUBSTR(TMP_ANOMES,5,2)+"/"+SUBSTR(TMP_ANOMES,1,4)+" Mat. : "+SRA->RA_MAT+" Nome : "+SRA->RA_NOME
		nLin += 1
		@nLin,000 PSAY "Lotacao    : "+TMP_CC+"-"+TMP_DESCCC+"  Cpf: "+SRA->RA_CIC
		nLin += 1
		@nLin,000 PSAY "Admissao   : "+DTOC(SRA->RA_ADMISSA)+"    Funcao: "+SRA->RA_CODFUNC+"-"+DESCFUN(SRA->RA_CODFUNC,SRA->RA_FILIAL)

		nLin += 1
		@ nLin,000 PSAY __PrtThinLine()
		nLin += 1
		_P:=_D:=0
		_KEY:= TMP_ANOMES+TMP_CC+TMP_MATR
		WHILE !EOF() .AND. TMP_ANOMES+TMP_CC+TMP_MATR=_Key
			_lSEGUE:=.T.
			IF TMP_BASE>0
				_IDCALC:=POSICIONE("SRV",1,XFILIAL("SRV")+TMP-> TMP_VERBA,"RV_CODFOL")
				IF !(_IDCALC$"0013/0014/0015/0017/0018/0019/0020/0027")
					_lSEGUE:=.F.
				ENDIF
			ENDIF
			IF !_lSegue
				DBSKIP()
				LOOP
			ENDIF

			@ nLin,000 PSAY TMP_VERBA
			@ nLIN,004 PSAY LEFT(TMP_DESC,25)
			IF TMP_QTD>0
				@ nLIN,031 PSAY TMP_QTD PICTURE "@E 999.99"
			ENDIF
			@ nLin,037 PSAY "|"
			IF TMP_PROVEN>0
				@ nLIN,038 PSAY TMP_PROVEN PICTURE "@E 999,999,999.99"
				_P+=TMP_PROVEN
				@ nLin,052 PSAY "|"
				@ nLin,067 PSAY "|"
				@ nLin,083 PSAY "|"
			ELSEIF TMP_DESCON>0
				@ nLin,052 PSAY "|"
				@ nLIN,053 PSAY TMP_DESCON PICTURE "@E 999,999,999.99"
				@ nLin,067 PSAY "|"
				@ nLin,083 PSAY "|"
				_D+=TMP_DESCON
			ELSEIF TMP_BASE>0
				@ nLin,052 PSAY "|"
				@ nLin,067 PSAY "|"
				@ nLIN,068 PSAY TMP_BASE PICTURE "@E 999,999,999.99"
				@ nLin,083 PSAY "|"
			ENDIF
			nLin += 1

			dbSelectArea( "TMP" )
			dbSkip()
		ENDDO
		@ nLin,000 PSAY __PrtThinLine()
		nLin += 1
		@ nLIN,000 PSAY "Bco/Agencia : "+SRA->RA_BCDEPSA
		@ nLIN,038 PSAY _P PICTURE "@E 999,999,999.99"
		@ nLIN,053 PSAY _D PICTURE "@E 999,999,999.99"
		nLin += 1
		@ nLIN,000 PSAY "Conta       : "+SRA->RA_CTDEPSA
		@ nLin,035 PSAY "Liquido a Receber:"
		@ nLIN,053 PSAY (_P-_D) PICTURE "@E 999,999,999.99"

		nLin += 1
		@ nLin,000 PSAY __PrtThinLine()
		nLin += 1

	EndDo

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()


Return


/********************************************************************************************************************************/
Static Function GrvExcel(_aDados,_cParUsr)
	/********************************************************************************************************************************/

	Local oExcel 	 := FWMSEXCEL():New()
	Local cWorkSheet := "FOLHA DE PAGAMENTO ANUAL"
	Local cTable     := "Dados"
	Local cTipo   := "*.xml | *.xmls |"
	Local nt := 0

	//Nome da Worksheet
	oExcel:AddworkSheet(cWorkSheet)
	//Nome da Tabela
	oExcel:AddTable (cWorkSheet,cTable)	

	oExcel:AddColumn(cWorkSheet, cTable, "TMP_ANOMES"			,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_VERBA"			,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_DESC"			    ,1,1)	
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_PROVEN"			,2,3)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_DESCON"			,3,2)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_BASE"			    ,3,2)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_QTD"			    ,3,2)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_SALARI"			,3,2)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_OCORR"			,3,2)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_CC"			    ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_DESCCC"			,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "TMP_MATR"			    ,1,1)
	IF _cParUsr="S"	
		oExcel:AddColumn(cWorkSheet, cTable, "TMP_NOME"			,1,1)
		oExcel:AddColumn(cWorkSheet, cTable, "TMP_ADM"			,1,1)
		oExcel:AddColumn(cWorkSheet, cTable, "TMP_SIT"			,1,1)
		oExcel:AddColumn(cWorkSheet, cTable, "TMP_FUNCAO"		,1,1)
		oExcel:AddColumn(cWorkSheet, cTable, "TMP_DESCFU"		,1,1)
		oExcel:AddColumn(cWorkSheet, cTable, "TMP_SEXO"			,1,1)
	ENDIF	

	If _cParUsr="S"	
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
			_aDados[nt][14],;
			_aDados[nt][15],;
			_aDados[nt][16],;
			_aDados[nt][17],;
			_aDados[nt][18]})
		Next nt
	Else
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
			_aDados[nt][12]})
		Next nt
	ENDIF	


	Arquivo := cGetFile(cTipo,OemToAnsi("Selecione o Diretorio do arquivo de atualização"),,'C:\ABCDE',.T.)
	Arquivo := Alltrim(Arquivo)

	If RIGHT(Arquivo,4) <> ".xml" .Or. RIGHT(Arquivo,4) <> ".XML" .Or. RIGHT(Arquivo,4) <> ".Xml"
		Arquivo := Alltrim(Arquivo+".xml")
	EndIf


	oExcel:Activate()
	oExcel:GetXMLFile(Arquivo)
	MSGINFO("Planilha gravada Sucesso: "+Arquivo,)



Return(.T.)
/********************************************************************************************************************************/
