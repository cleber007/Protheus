#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 08/06/00
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function IMP_SRE()        // IMPRIME TRANSFERENCIAS

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define Variaveis                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	cDesc1 := ""
	cDesc2 := ""
	cDesc3 :=""
	cString:="TM5"
	nChar:=18

	aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 4, 2, 1, "",1 }
	nPAGINA := 1
	nLastKey:= 0
	cPerg    :=""
	li       :=1
	_PODE     :=""


	_DATADE :=DDATABASE-DAY(DDATABASE)+1
	_DATAATE:=DDATABASE
	@ 1,1 to  150,300 DIALOG oDlg2X TITLE "Parametro:"
	@ 22, 05 SAY "Periodo:"
	@ 22, 49 GET _DATADE  SIZE 45,10
	@ 32, 49 GET _DATAATE SIZE 45,10

	@ 60, 90 BmpButton Type 1 Action Close(oDlg2X)
	Activate Dialog oDlg2X Centered

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica as perguntas selecionadas                                                            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

	titulo  :="Transferencias entre "+DTOC(_DATADE)+" e "+DTOC(_DATAATE)
	CABEC1  :=space(43)+"CENTRO DE CUSTO DE              CENTRO DE CUSTO PARA"
	CABEC2  :=""
	nomeprog:="IMPSRE"
	tamanho :="G"
	m_pag := 1




//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Envia controle para a funcao SETPRINT                                                         �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	wnrel := "IMP_SRE"            //Nome Default do relatorio em Disco
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

	If nLastKey==27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey==27
		#IFNDEF WINDOWS
			SetColor(cSavCor)
		#ENDIF
		Return
	Endif

	RptStatus({|| FA003Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 08/06/00 ==>        RptStatus({|| Execute(FA003Imp)})

Return

	**************************
Static Function FA003Imp()
	**************************

	nTipo   :=IIF(aReturn[4]==1,15,18)


//*********************************************************** ARQUIVO TEMPORARIO PARA GERACAO DO XLS
	aStru  := {}
	aadd(aStru , {'TRB_DATA'  ,'C', 10,0} )
	aadd(aStru , {'TRB_MATR'  ,'C', 06,0} )
	aadd(aStru , {'TRB_NOME'  ,'C', 30,0} )
	aadd(aStru , {'TRB_CCDE'  ,'C', 32,0} )
	aadd(aStru , {'TRB_CCPARA','C', 32,0} )

//cArqTemp := CriaTrab(aStru , .t.)
//dbUseArea(.T.,,cArqTEMP,"TRB",.F.,.F.)
//dbSelectArea("TRB")

	oGetTab := FWTemporaryTable():New("TRB",)
	oGetTab:SetFields(aStru)
//oGetTab:AddIndex("01", {"T_NUM"} )
	oGetTab:Create()

	dbSelectArea("TRB")

//************************************
	DBSELECTAREA("SRA")
	DBSETORDER(1)

	dbSelectArea("SRE")
	DBSETORDER(3)
	DBSEEK(xFilial("SRE")+DTOS(_DATADE),.T.)

	SetRegua(RecCount())

	FA003Cabec()

	_TT:=0
	LI:=56
	_TTT:=0
	While !Eof() .AND. RE_DATA<=_DATAATE
		IF li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			li--
		EndIF
		IF RE_EMPP#SM0->M0_CODIGO .AND. RE_EMPD=RE_EMPP             // MESMO CENTRO DE CUSTO NAO CONSIDERA
			SRE->(DBSKIP())
			Loop
		ENDIF

		IF RE_CCD=RE_CCP             // MESMO CENTRO DE CUSTO NAO CONSIDERA
			SRE->(DBSKIP())
			Loop
		ENDIF

		_NOME  :=POSICIONE("SRA",1,XFILIAL("SRA")+SRE->RE_MATP,"RA_NOME")
		_CCD   :=POSICIONE("CTT",1,XFILIAL("CTT")+SRE->RE_CCD ,"CTT_DESC01")
		_CCP   :=POSICIONE("CTT",1,XFILIAL("CTT")+SRE->RE_CCP ,"CTT_DESC01")
		@ LI, 00 PSAY RE_DATA
		@ LI, 11 PSAY LEFT(_NOME,30)
		@ LI, 43 PSAY LEFT(RE_CCD,5)+"-"+LEFT(_CCD,25)
		@ LI, 75 PSAY LEFT(RE_CCP,5)+"-"+LEFT(_CCP,25)
		IF RE_EMPD#RE_EMPP
			@ LI,107 PSAY �"Empresa: De "+RE_EMPD+" para "+RE_EMPP
		ENDIF
		LI++

		DBSELECTAREA("TRB")
		RECLOCK("TRB",.T.)
		TRB_DATA  :=DTOC(SRE->RE_DATA)
		TRB_MATR  :=SRE->RE_MATP
		TRB_NOME  :=_NOME
		TRB_CCDE  :=LEFT(SRE->RE_CCD,5)+"-"+LEFT(_CCD,25)
		TRB_CCPARA:=LEFT(SRE->RE_CCP,5)+"-"+LEFT(_CCP,25)
		MSUNLOCK()
		DBSELECTAREA("SRE")


		_TT++
		_MESANTER:=MONTH(RE_DATA)
		SRE->(DBSKIP())
		IF MONTH(RE_DATA)>_MESANTER .OR. EOF()
			@ LI, 11 PSAY ". Total no Mes : "+STR(_TT,6,0)
			_TTT+=_TT
			_TT :=0
			LI+=2
		ENDIF
	ENDDO
	LI++
	@ LI, 11 PSAY ". Total de Transferencias : "+STR(_TTT,6,0)



	Set Device To Screen
	Set Filter To


	If aReturn[5]==1
		Set Printer To
		dbCommit()
		ourspool(wnrel)
	Endif

	MS_FLUSH()

	_GeraXls:=1
	@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Gera Planilha Excel ?"
	@ 10, 49 SAY "1 - Nao"
	@ 22, 49 SAY "2 - Sim"
	@ 44, 49 GET _GeraXls PICTURE "99"
	@ 60, 90 BmpButton Type 1 Action Close(oDlg2)
	Activate Dialog oDlg2 Centered

	cArquivo:="C:\Relato\RELTRA.XML" //Corre豫o na impress�o em planilha. Wagno Sousa em 24/07/2020. Chamado: 34239
	If _GeraXls=2 .AND. File(cArqTemp+".DTC")
		DbSelectArea("TRB")
		DBGOTOP()
		oFWMsExcel := FWMSExcel():New()
		oFWMsExcel:AddworkSheet("SRE")
		oFWMsExcel:AddTable("SRE","Transferencia")
		oFWMsExcel:AddColumn("SRE","Transferencia","Data",1,1)
		oFWMsExcel:AddColumn("SRE","Transferencia","Matricula",1,1)
		oFWMsExcel:AddColumn("SRE","Transferencia","Nome",1,1)
		oFWMsExcel:AddColumn("SRE","Transferencia","De Centro de Custo",1,1)
		oFWMsExcel:AddColumn("SRE","Transferencia","Para Centro de Custo",1,1)

		TRB->(dbGoTop())

		While TRB->(!EOF())
			oFWMsExcel:AddRow("SRE","Transferencia",{TRB->TRB_DATA,TRB->TRB_MATR,TRB->TRB_NOME,TRB->TRB_CCDE,TRB->TRB_CCPARA})
			TRB->(dbSkip())
		Enddo

		TRB->(dbCloseArea())

		oFWMsExcel:Activate()
		oFWMsExcel:GetXMLFile(cArquivo)

		oExcel:=MsExcel():New()
		oExcel:WorkBooks:Open(cArquivo)
		oExcel:SetVisible(.T.)
		oExcel:Destroy()
	EndIf

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIF
//Ferase(cArqTEMP)
//Ferase(cArqTEMP+".DTC")

	DBSELECTAREA("SRE")
	DBSETORDER(1)
	DBGOTOP()


RETURN

	****************************
Static Function FA003cabec()
	****************************
	cTamanho := "G"
	aDriver := ReadDriver()

	If !( "DEFAULT" $ Upper( __DRIVER ) )
		SetPrc(000,000)
	Endif
	if nChar == NIL
		@ pRow(),pCol() PSAY &(if(cTamanho=="P",aDriver[1],if(cTamanho=="G",aDriver[5],aDriver[3])))
	else
		if nChar == 15
			@ pRow(),pCol() PSAY &(if(cTamanho=="P",aDriver[1],if(cTamanho=="G",aDriver[5],aDriver[3])))
		else
			AA:=(if(cTamanho=="P",aDriver[2],if(cTamanho=="G",aDriver[6],aDriver[4])))
			@ pRow(),pCol() PSAY &AA
		endif
	endif
Return(.T.)
