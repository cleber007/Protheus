#INCLUDE "PROTHEUS.CH"
#Include "rwmake.ch"

User Function Imp_SRC()

	_cArea := Alias()
	_nOrd  := IndexOrd()
	nReg   :=RecNo()

	#IFNDEF  WINDOWS
		#Translate PSAY => SAY
	#Endif

	cString     :="SRA"
	cDesc1      :=OemToAnsi("Este programa tem como objetivo, emitir um RELATORIO")
	cDesc2      :=OemToAnsi("DO ARQUIVO CNAB, ANTES DE SER ENVIADO AO BANCO.")
	cDesc3      :=""
	titulo      :=""
	tamanho     :="M"
	cPerg       :="IMPSRC"
	aReturn     := { "Zebrado", 1, "Administracao" ,1,1,1,"",1 }
	nomeprog    :="IMP_SRC"
	aLinha      := {}
	nLastKey    := 0
	nLin        := 1
	cCancel     :="**** CANCELADO PELO OPERADOR ****"
	m_pag       :=  1            // Variavel que acumula numero da pagina.
	n_col       :=  130
	wnrel       := "IMP_SRC"    // Nome Default deste Relatorio em disco.
	cfilteruser :=areturn[7]

	IF !PERGUNTE(cPERG,.T.)
		RETURN Nil
	ENDIF
	cArq:=ALLTRIM(MV_PAR01)
	_IMPORTA:=.T.

	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,"M","",.T.)

	If nLastkey == 27
		Set Filter to
		Return
	EndIf

	SetDefault(aReturn,cString)

	If nLastkey == 27
		Set Filter to
		Return
	Endif

	Processa({||RptDetail()})

	If aReturn[5] == 1
		Set Printer To
		Commit
		ourspool( wnrel )
	EndIf

	MS_FLUSH()      // Libera fila de relatorios em spool.

	DBSELECTAREA("SRA")
	DBSETORDER(1)

	dbSelectArea(_cArea)
	DbSetOrder(_nOrd)
	DbGoTo(nReg)

return(nil)

STATIC Function RptDetail()
	Local aFileLines:={}
	Local i:={}

	_nlinha := 1
	_nREG :=0
	// CRIANDO ARQUIVO TEMPORARIO PARA A IMPORTACAO
	DBSELECTAREA("SRV")
	DBSETORDER(1)

	DBSELECTAREA("SRA")
	DBSETORDER(1)

	DBSELECTAREA("SRC")
	DBSETORDER(1)

	aTemp:={}
	aadd(aTemp,{'LINHA', 'C',MV_PAR02+9,0})
	aadd(aTemp,{'CC', 'C',9,0})

	//cTemp:=CriaTrab(aTemp,.t.)
	//Use &cTemp shared alias TRB  new

	oGetTab := FWTemporaryTable():New("TRB",)
	oGetTab:SetFields(aTemp)
	oGetTab:AddIndex("01", {"CC"} )
	oGetTab:Create()

	oFile := FWFileReader():New(cArq)
	If !oFile:Open()
		MsgStop( "Problema em abrir o arquivo: " + cArq, '' )
	Endif
	aFileLines := oFile:getAllLines()
	aSort(aFileLines,)
	//Append from &cArq SDF

	For i:=1 to len(aFileLines)

		_MAT :=STRZERO(VAL(SUBSTR(aFileLines[i],MV_PAR03,(MV_PAR04+1)-MV_PAR03)),6,0)
		_CCUSTO:= POSICIONE("SRA",1,XFILIAL("SRA")+_MAT,"RA_CC")

		RECLOCK("TRB",.t.)
		TRB->LINHA := LEFT(aFileLines[i],MV_PAR02) + _CCUSTO
		TRB->CC := _CCUSTO
		MSUNLOCK()

	Next i

	_TT    :=0
	_TTCC  :=0
	_PAGINA:=1
	DBSELECTAREA("TRB")
//	INDEX ON SUBSTR(LINHA,MV_PAR02+1,9)+SUBSTR(LINHA,MV_PAR03,(MV_PAR04+1)-MV_PAR03) TO &cTemp
	dbsetorder(1)
	TRB->(DbGotop())
	PROCREGUA(RECCOUNT())
	IMPCAB()

	DBSELECTAREA("TRB")
	TRB->(dbsetorder(1))
	TRB->(DbGotop())
	do while !TRB->(Eof())
		INCPROC()
		_MAT :=STRZERO(VAL(SUBSTR(TRB->LINHA,MV_PAR03,(MV_PAR04+1)-MV_PAR03)),6,0)
		_VAL :=VAL(SUBSTR(TRB->LINHA,MV_PAR05,(MV_PAR06+1)-MV_PAR05))/100
		_CC  :=POSICIONE("SRA",1,XFILIAL("SRA")+_MAT,"RA_CC")
		DBSELECTAREA("SRA")
		DBSEEK(xFilial("SRA")+_MAT)
		IF FOUND()
			_NOME  :=RA_NOME
			_IMFUNC:=.T.
		ELSE
			_NOME:="nao encontrado "
			_IMFUNC:=.F.
		ENDIF
		DBSELECTAREA("TRB")
		@ _nLINHA,001 PSAY LEFT(_NOME,40)
		@ _nLINHA,043 PSAY _MAT
		@ _nLINHA,063 PSAY _VAL PICTURE "@EZ 999,999,999.99"
		IF SRA->RA_SITFOLH="D"
			@ _nLINHA,078 PSAY "<-- DEMITIDO !!"
			_IMFUNC:=.F.
		ENDIF
		@ _nLINHA,094 PSAY _CC

		_TT  :=_TT   + _VAL
		_TTCC:=_TTCC + _VAL
		_nLinha++
		IF _nLINHA>55
			_nLINHA:=1
			_PAGINA++
			IMPCAB()
		ENDIF
		IF _IMPORTA .AND. _IMFUNC .AND. MV_PAR08=2
			DBSELECTAREA("RGB")
			dbSetOrder(1)
			_ANOMES:=strzero(Year(ddatabase),4)+strzero(month(ddatabase),2)
			DBSEEK(xFilial("RGB")+SRA->RA_MAT+MV_PAR07+_ANOMES)      // ENTRA NA FORMA DE BASE NA FOLHA DO MES
			IF !FOUND()
				RECLOCK("RGB",.T.)
				RGB_FILIAL	:= XFILIAL("RGB")
				RGB_PERIOD 	:= _ANOMES
				RGB_SEMANA	:= "01"
				RGB_ROTEIR	:= "FOL"
				RGB_PROCES	:= SRA->RA_PROCES
				RGB_MAT   	:= SRA->RA_MAT
				RGB_PD    	:= MV_PAR07
				RGB_TIPO1 	:= "V"
				RGB_TIPO2 	:= "I"
				RGB_DTREF	:= LASTDAY(DDATABASE)
			ELSE
				RECLOCK("RGB",.F.)
			ENDIF
			RGB_CC   		:= SRA->RA_CC
			RGB_VALOR		:= _VAL
			RGB->(MSUNLOCK())
			DBSELECTAREA("TRB")
		ENDIF

		TRB->(DbSkip())

		IF EOF() .OR. _CC # TRB->CC
			@ _nLinha,063 PSAY "--------------"
			_nLinha++
			@ _nLINHA,030 PSAY ".Total CCusto : "+_CC
			@ _nLINHA,063 PSAY _TTCC PICTURE "@EZ 999,999,999.99"
			_nLinha++
			_nLinha++
			_TTCC:=0
		ENDIF

	enddo


	_nLinha++
	@ _nLINHA,001 PSAY ".Total Geral : "
	@ _nLINHA,063 PSAY _TT PICTURE "@EZ 999,999,999.99"
	_nLinha++
	_nLinha++
	@ _nLinha,001 PSAY "Dep Pessoal                            Gerencia                   Diretoria           "
	_nLinha++
	_nLinha++
	@ _nLinha,001 PSAY "________________________________       _______________________    ____________________"

	TRB->(dbCloseArea())

Return

//***************************
STATIC FUNCTION IMPCAB()
	//***************************
	DBSELECTAREA("SRV")
	DBSEEK(xFilial("SRV")+MV_PAR07)
	IF FOUND()
		_VERBA:=RV_DESC
	ELSE
		_VERBA:="nao encontrada !!! "
		_IMPORTA:=.F.
	ENDIF
	DBSELECTAREA("TRB")

	@ _nLinha,001 PSAY "Arquivo : "+cArq+"     Emissao : "+DTOC(DDATABASE)+"    Usuario : "+SUBSTR(cUsuario,7,15)+" Pag: "+STRZERO(_PAGINA,3,0)
	_nLinha++
	@ _nLinha,001 PSAY "VERBA : "+MV_PAR07 +"-" +_VERBA
	_nLinha++
	@ _nLinha,001 PSAY "Nome do Empregado"
	@ _nLinha,063 PSAY "Valor_Verba"
	@ _nLinha,094 PSAY "CCusto"
	_nLinha++
	@ _nLinha,001 PSAY REPLICATE(".",99)
	_nLinha++

RETURN

//*********************************************************************************
User Function CadZZT()
//*********************************************************************************

	_cArea := Alias()
	_nOrd  := IndexOrd()
	nReg   :=RecNo()

	DbSelectArea("ZZT")
	DbGotop()

	cCadastro:="ZZT - TARIFAS"
	aRotina := { { "Pesquisa ",  'AxPesqui'            , 0, 1 },;
		{ "Visualizar" ,"AxVisual"            , 0, 2},;
		{ "Inclui    " ,"AxInclui"            , 0, 3},;
		{ "Altera    " ,"AxAltera"            , 0, 4},;
		{ "Exclui    " ,"AxDeleta"            , 0, 5},;
		{ "Relatorio " ,"U_POSTAR"            , 0, 6}}

	mBrowse(16,00,280,350,"ZZT")

	DbSelectArea("ZZT")
	SET FILTER TO

	dbSelectArea(_cArea)
	DbSetOrder(_nOrd)
	DbGoTo(nReg)

return(nil)


//***********
User Function POSTAR()
	//***********

	ALERT("ROTINA EM DESENVOLVIMENTO !!")

RETURN Nil

User Function CadZZS()
	//*********************************************************************************

	_cArea := Alias()
	_nOrd  := IndexOrd()
	nReg   :=RecNo()

	PRIVATE aCores    := {{ 'ZZS->ZZS_DTFIM>=DDATABASE'	, 'ENABLE' },;
		{ 'ZZS->ZZS_DTFIM<DDATABASE'	, 'DISABLE'}}


	DbSelectArea("ZZS")
	DbGotop()

	cCadastro:="ZZS - GERENCIA DE CONTRATOS"
	aRotina := { { "Pesquisa ",  'AxPesqui'            , 0, 1 },;
		{ "Visualizar" ,"AxVisual"            , 0, 2},;
		{ "Inclui    " ,"AxInclui"            , 0, 3},;
		{ "Altera    " ,"AxAltera"            , 0, 4},;
		{ "Exclui    " ,"AxDeleta"            , 0, 5},;
		{ "Pos Financ" ,"U_POSFIN"            , 0, 6},;
		{ "&Legenda  " ,"U_BRLegZZS"          , 0, 7 }}

	mBrowse(16,00,280,350,"ZZS",,,,,,aCores)

	DbSelectArea("ZZS")
	SET FILTER TO

	dbSelectArea(_cArea)
	DbSetOrder(_nOrd)
	DbGoTo(nReg)

return(nil)


//***********
User Function POSFIN()
	//***********
	PRIVATE nTotal1    := nTotal2 := nTotal3 := 0
	PRIVATE nTitulos1  := nTitulos2 := nTitulos3 := nTitulos4 := nTitulos5 := nTitulos6 := 0
	PRIVATE aTotal5    := {0.00,0,0.00,0}
	PRIVATE dBaixa     := dDataBase
	PRIVATE nVlGeralNf := 0

	If !(Pergunte("FIC030",.T.))
		Return
	Endif

	DBSELECTAREA("SA2")
	DBSETORDER(1)
	DBSEEK(xFilial("SA2")+ZZS->ZZS_CODIGO)
	IF FOUND()
		FC030CON()
	ELSE
		ALERT("Impossivel buscar posiÇâo financeira do Contratado !!!")
	ENDIF


	DBSELECTAREA("ZZS")
RETURN

//***********
User Function BRLegZZS()
	//***********
	Local aLegenda := { {"ENABLE" ,"Ativo"}    ,;
		{"DISABLE"   ,"Expirado"}}


	BrwLegenda(cCadastro,"Legenda" ,aLegenda)

Return .T.

//*******************************************************************************************
User Function UQUADROF()
//*******************************************************************************************
	_cArea := Alias()
	_nOrd  := IndexOrd()
	nReg   :=RecNo()


	PRIVATE aCores    := {{ 'TRB->TRB_TIP$"01"' 	, 'ENABLE' },;
		{ 'TRB->TRB_TIP=="2"'	, 'DISABLE'},;
		{ 'TRB->TRB_TIP=="3"'	, 'BR_AZUL' },;
		{ 'TRB->TRB_TIP=="4"'	, 'BR_AMARELO' }}

	//+-----------------------------------------------------------+
	//¦ CRIA ARQUIVO TEMPORARIO                                   ¦
	//+-----------------------------------------------------------+
	// Estrutura do Arquivo Temporario
	aCposBrw :=  {	{ "Tipo", {|| TRB->TRB_TIP }, 'C',  1 , 0, '@! ' },;
		{ "Cod" ,{|| TRB->TRB_COD }, 'C', 09 , 0, '@! '   },;
		{ "Nome",{|| TRB->TRB_NOM }, 'C', 30 , 0, '   '   },;
		{ "Jan" ,{|| TRB->TRB_Q01 }, 'N', 05 , 0, '99999' },;
		{ "Fev" ,{|| TRB->TRB_Q02 }, 'N', 05 , 0, '99999' },;
		{ "Mar" ,{|| TRB->TRB_Q03 }, 'N', 05 , 0, '99999' },;
		{ "Abr" ,{|| TRB->TRB_Q04 }, 'N', 05 , 0, '99999' },;
		{ "Mai" ,{|| TRB->TRB_Q05 }, 'N', 05 , 0, '99999' },;
		{ "Jun" ,{|| TRB->TRB_Q06 }, 'N', 05 , 0, '99999' },;
		{ "Jul" ,{|| TRB->TRB_Q07 }, 'N', 05 , 0, '99999' },;
		{ "Ago" ,{|| TRB->TRB_Q08 }, 'N', 05 , 0, '99999' },;
		{ "Set" ,{|| TRB->TRB_Q09 }, 'N', 05 , 0, '99999' },;
		{ "Out" ,{|| TRB->TRB_Q10 }, 'N', 05 , 0, '99999' },;
		{ "Nov" ,{|| TRB->TRB_Q11 }, 'N', 05 , 0, '99999' },;
		{ "Dez" ,{|| TRB->TRB_Q12 }, 'N', 05 , 0, '99999' },;
		{ "Sal Base" ,{|| TRB->TRB_VAL }, 'N', 14 , 2, '@E 99,999,999.99' }}

	aStru  := {}
	aadd(aStru , {'TRB_TIP' ,'C', 01,0} )
	aadd(aStru , {'TRB_COD' ,'C', 09,0} )
	aadd(aStru , {'TRB_NOM' ,'C', 30,0} )
	aadd(aStru , {'TRB_Q01' ,'N', 05,0} )
	aadd(aStru , {'TRB_Q02' ,'N', 05,0} )
	aadd(aStru , {'TRB_Q03' ,'N', 05,0} )
	aadd(aStru , {'TRB_Q04' ,'N', 05,0} )
	aadd(aStru , {'TRB_Q05' ,'N', 05,0} )
	aadd(aStru , {'TRB_Q06' ,'N', 05,0} )
	aadd(aStru , {'TRB_Q07' ,'N', 05,0} )
	aadd(aStru , {'TRB_Q08' ,'N', 05,0} )
	aadd(aStru , {'TRB_Q09' ,'N', 05,0} )
	aadd(aStru , {'TRB_Q10' ,'N', 05,0} )
	aadd(aStru , {'TRB_Q11' ,'N', 05,0} )
	aadd(aStru , {'TRB_Q12' ,'N', 05,0} )
	aadd(aStru , {'TRB_VAL' ,'N', 14,2} )

	//cArqTemp := CriaTrab(aStru , .t.)
	//dbUseArea(.T.,,cArqTEMP,"TRB",.F.,.F.)
	//IndRegua( "TRB", cArqTEMP, "TRB_COD+TRB_TIP" )
	//dbSelectArea("TRB")

	oGetTab := FWTemporaryTable():New("TRB",)
	oGetTab:SetFields(aStru)
	oGetTab:AddIndex("01", {"TRB_COD","TRB_TIP"} )
	oGetTab:Create()

	dbSelectArea("TRB")

	Processa({ || BUSCADA1() } )

RETURN

STATIC FUNCTION BUSCADA1()

	//************************************************************************** BUSCA DADOS
	DBSELECTAREA("RB8")
	DBSETORDER(2)
	PROCREGUA(RECCOUNT())
	_ANOMESINI:=STRZERO(YEAR(DDATABASE),4,0)+"01"
	_ANOMESFIM:=STRZERO(YEAR(DDATABASE),4,0)+"12"
	DBSEEK(xFilial("RB8")+_ANOMESINI)
	WHILE !EOF() .AND. RB8_ANOMES<=_ANOMESFIM
		INCPROC()
		DBSELECTAREA("TRB")
		DBSEEK(LEFT(RB8->RB8_CC,9)+"1")
		IF !FOUND()
			RECLOCK("TRB",.T.)
			TRB->TRB_TIP:="2"
			TRB->TRB_COD:=RB8->RB8_CC
			TRB->TRB_NOM:=SPACE(12)+".Demitidos"
			MSUNLOCK()
			RECLOCK("TRB",.T.)
			TRB->TRB_TIP:="3"
			TRB->TRB_COD:=RB8->RB8_CC
			TRB->TRB_NOM:=SPACE(12)+".Admitidos"
			MSUNLOCK()
			RECLOCK("TRB",.T.)
			TRB->TRB_TIP:="1"
			TRB->TRB_COD:=RB8->RB8_CC
			TRB->TRB_NOM:=Posicione("CTT",1,xFilial("CTT")+RB8->RB8_CC,"CTT_DESC01")
		ELSE
			RECLOCK("TRB",.F.)
		ENDIF
		_VAR:="TRB->TRB_Q"+SUBSTR(RB8->RB8_ANOMES,5,2)
		&_VAR := RB8->RB8_NRATUA
		TRB->TRB_VAL:=RB8->RB8_VLATUA
		MSUNLOCK()
		DBSELECTAREA("RB8")
		DBSKIP()
	ENDDO

	DBSELECTAREA("RB8")   // RETORNA INDICE PADRAO
	DBSETORDER(1)
	DBGOTOP()



	//*********************************************************
	DBSELECTAREA("SRA")            // PEGA ADMITIDOS E DEMITIDOS
	DBSETORDER(1)
	SET FILTER TO LEFT(DTOS(RA_DEMISSA),6)>=_ANOMESINI .AND. LEFT(DTOS(RA_DEMISSA),6)<=_ANOMESFIM
	DBGOTOP()
	PROCREGUA(RECCOUNT())
	WHILE !EOF()
		INCPROC()
		DBSELECTAREA("TRB")
		DBSEEK(LEFT(SRA->RA_CC,9)+"2")      // DEMITIDOS
		IF FOUND()
			RECLOCK("TRB",.F.)
			_VAR:="TRB->TRB_Q"+SUBSTR(DTOS(SRA->RA_DEMISSA),5,2)
			&_VAR := &_Var + 1
			TRB->TRB_VAL:=TRB->TRB_VAL + SRA->RA_SALARIO
			MSUNLOCK()
		ENDIF
		DBSELECTAREA("SRA")
		DBSKIP()
	ENDDO
	DBSELECTAREA("SRA")
	SET FILTER TO

	DBSELECTAREA("SRA")            // PEGA ADMITIDOS E DEMITIDOS
	DBSETORDER(1)
	SET FILTER TO LEFT(DTOS(RA_ADMISSA),6)>=_ANOMESINI .AND. LEFT(DTOS(RA_ADMISSA),6)<=_ANOMESFIM
	DBGOTOP()
	PROCREGUA(RECCOUNT())
	WHILE !EOF()
		INCPROC()
		DBSELECTAREA("TRB")
		DBSEEK(LEFT(SRA->RA_CC,9)+"3")     // ADMITIDOS
		IF FOUND()
			RECLOCK("TRB",.F.)
			_VAR:="TRB->TRB_Q"+SUBSTR(DTOS(SRA->RA_ADMISSA),5,2)
			&_VAR := &_Var + 1
			TRB->TRB_VAL:=TRB->TRB_VAL + SRA->RA_SALARIO
			MSUNLOCK()
		ENDIF
		DBSELECTAREA("SRA")
		DBSKIP()
	ENDDO
	DBSELECTAREA("SRA")
	SET FILTER TO

	_TVL:=_T01:=_T02:=_T03:=_T04:=_T05:=_T06:=_T07:=_T08:=_T09:=_T10:=_T11:=_T12:=0
	DBSELECTAREA("TRB")    // TOTALIZA
	DBGOTOP()
	WHILE !EOF()
		IF TRB_TIP="1"
			_T01:=_T01 + TRB_Q01
			_T02:=_T02 + TRB_Q02
			_T03:=_T03 + TRB_Q03
			_T04:=_T04 + TRB_Q04
			_T05:=_T05 + TRB_Q05
			_T06:=_T06 + TRB_Q06
			_T07:=_T07 + TRB_Q07
			_T08:=_T08 + TRB_Q08
			_T09:=_T09 + TRB_Q09
			_T10:=_T10 + TRB_Q10
			_T11:=_T11 + TRB_Q11
			_T12:=_T12 + TRB_Q12
			_TVL:=_TVL + TRB_VAL
		ENDIF
		DBSKIP()
	ENDDO
	RECLOCK("TRB",.T.)
	TRB->TRB_TIP:="0"
	TRB->TRB_COD:=" "
	TRB->TRB_NOM:=SM0->M0_NOME
	TRB->TRB_Q01:=_T01
	TRB->TRB_Q02:=_T02
	TRB->TRB_Q03:=_T03
	TRB->TRB_Q04:=_T04
	TRB->TRB_Q05:=_T05
	TRB->TRB_Q06:=_T06
	TRB->TRB_Q07:=_T07
	TRB->TRB_Q08:=_T08
	TRB->TRB_Q09:=_T09
	TRB->TRB_Q10:=_T10
	TRB->TRB_Q11:=_T11
	TRB->TRB_Q12:=_T12
	TRB->TRB_VAL:=_TVL
	MSUNLOCK()




	DBSELECTAREA("TRB")
	DBGOTOP()
	cCadastro:="QUADRO DE PESSOAL - REFERENCIA ANO : "+_ANOMESINI+" ate "+_ANOMESFIM
	aRotina := { { "Planilha", 'ExecBlock("uQUAXLS")' , 0, 1 },;
		{ "Visualiza", 'ExecBlock("uVISUQUA")'   , 0, 2 },;
		{ "Gera Dad.", "Cs090Gera"	             , 0, 3},;
		{ "Imprime  ", 'ExecBlock("uIMPRQUA")'   , 0, 4 },;
		{ "&Legenda ","U_QUAD_BRLeg"             , 0 ,5 }}

	mBrowse(16,00,280,350,"TRB",aCposBrw,,,,,aCores)

	DbSelectArea("TRB")
	DbCloseArea()
	//Ferase(cArqTEMP)

	dbSelectArea(_cArea)
	DbSetOrder(_nOrd)
	DbGoTo(nReg)

return(nil)

//****************
User Function QUAD_BRLeg()
	//****************
	Local aLegenda := { {"ENABLE" ,"Ativos"}    ,;
		{"DISABLE","Demitidos no mes"},;
		{"BR_AZUL"   ,"Admitidos no mes"},;
		{"BR_AMARELO","Transferidos no mes"}}

	BrwLegenda(cCadastro,"Legenda" ,aLegenda)

Return .T.

//****************
User Function uQUAXLS()
	//****************

	DBSELECTAREA("TRB")
	DBGOTOP()
	//COPY TO TRB + GetDBExtension()
	cArqRen:='\SYSTEM\TEMPDBF\TRB" + GetDBExtension()
	//Copy to &cArqRen VIA "CTREECDX"

	_arquivo:="G:\SYSTEM\TEMPDBF\TRB" + GetDBExtension()
	If !File(_arquivo)
		_arquivo:="F:\SYSTEM\TEMPDBF\TRB" + GetDBExtension()
		If !File(_arquivo)
			_arquivo:="G:\SIGAADV\TEMPDBF\TRB" + GetDBExtension()
			If !File(_arquivo)
				_arquivo:="F:\SIGAADV\TEMPDBF\TRB" + GetDBExtension()
				If !File(_arquivo)
					_arquivo:="C:\PROTHEUS_DATA\SIGAADV\TRB" + GetDBExtension()
					If !File(_arquivo)
						_arquivo:="D:\PROTHEUS_DATA\SIGAADV\TRB" + GetDBExtension()
					endif
				endif
			EndIf
		EndIf
	EndIf

	If ! ApOleClient( 'MsExcel' )
		MsgStop( 'Excel não instalado' )
	ELSE
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( _arquivo )
		oExcelApp:SetVisible(.T.)
	ENDIF



RETURN

//****************
User Function uVISUQUA()
	//****************

	DBSELECTAREA("SI3")
	DBSETORDER(1)
	DBSEEK(xFilial("SI3")+TRB->TRB_COD)
	IF FOUND()
		//Cs090Rot(cAlias,nReg,nOpc)
		Cs090Rot("SI3",SI3->(RECNO()),1)
	ELSEIF !EMPTY(TRB->TRB_COD)
		ALERT("CADASTRE NO SI3 O CCUSTO .. " + TRB->TRB_COD)
	ENDIF

	DBSELECTAREA("TRB")
RETURN


//****************
User Function uIMPRQUA()
	//****************
	ALERT("EM DESENVOLVIMENTO...")

RETURN








//*********************************************************************************
User Function CadZZ0()
	//*********************************************************************************

	_cArea := Alias()
	_nOrd  := IndexOrd()
	nReg   :=RecNo()


	DbSelectArea("ZZ0")
	DbGotop()

	cCadastro:="ZZ0 - PR ANUAL"
	aRotina := { { "Pesquisa ",  'AxPesqui'            , 0, 1 },;
		{ "Visualizar" ,"AxVisual"            , 0, 2},;
		{ "Inclui    " ,"AxInclui"            , 0, 3},;
		{ "Altera    " ,"AxAltera"            , 0, 4},;
		{ "Exclui    " ,"AxDeleta"            , 0, 5},;
		{ "Calcula   " ,"U_CALCPR"            , 0, 6},;
		{ "Relac Adto" ,"U_RELADT"            , 0, 7},;
		{ "Relac 2aPR" ,"U_REL2PR"            , 0, 8}}

	mBrowse(16,00,280,350,"ZZ0")

	DbSelectArea("ZZ0")
	DBGOTOP()

	dbSelectArea(_cArea)
	DbSetOrder(_nOrd)
	DbGoTo(nReg)

return(nil)


//***********
User Function CALCPR()
	//***********

	_DATA :=DDATABASE
	_FATOR:=1.75       // FATOR DEZEMBRO 2015
	_Tipo:=99
	_MATDE :=SPACE(6)
	_MATATE:="999999"
	@ 1,1 to  200,400 DIALOG oDlg2 TITLE "PARAMETROS DE CALCULO"
	@ 10, 22 SAY "DataBase"
	@ 10, 49 GET _DATA    SIZE 37,12
	@ 22, 22 SAY "Fator"
	@ 22, 49 GET _FATOR   SIZE 20,12 PICTURE "@E 99.999"
	@ 34, 39 SAY "0-Antecip 1-Adiantam 2-Segunda Parc."
	@ 46, 49 GET _TIPO  PICTURE "99"
	@ 58, 22 SAY "Matr"
	@ 58, 49 GET _MATDE    SIZE 37,12
	@ 58, 99 GET _MATATE   SIZE 37,12

	@ 70, 95 BmpButton Type 1 Action Close(oDlg2)
	Activate Dialog oDlg2 Centered

	IF !(_TIPO<=2)
		RETURN Nil
	ENDIF

	nOpFatInf := Aviso("Atencao !" ,"Durante o Cálculo, ZERA o Fator Informado manualmente, caso exista ?" , {"Sim:usar apenas o fator "+alltrim(str(_FATOR,6,3)),"Não Zerar"})
	If nOpFatInf == 0 .or. nOpFatInf > 2
		nOpFatInf := 1
	Endif

	IF _TIPO=2
		DBSELECTAREA("SRD")
		DBSETORDER(13)
		_AnoBase:=STRZERO(YEAR(_DATA),4,0)+"12"
		_TT:=0
		ALERT("vou carregar adiantamento dos acumulados ...")
		DBSELECTAREA("ZZ0")
		DBSETORDER(1)
		DBGOTOP()
		WHILE !EOF()
			DBSELECTAREA("SRD")
			DBSEEK(xFilial("SRD")+ZZ0->ZZ0_MAT+"216"+_AnoBase)
			_V216:=0
			WHILE !EOF() .AND. RD_MAT=ZZ0->ZZ0_MAT .AND. RD_PD="216"
				_V216:=_V216 + RD_VALOR
				DBSKIP()
			ENDDO

			DBSELECTAREA("ZZ0")
			IF _V216>0
				RECLOCK("ZZ0",.F.)
				ZZ0->ZZ0_ADTO:=_V216    // AGLUTINADO ANTECIPACAO + ADIANTAMENTO
				MSUNLOCK()
				_TT++
			ENDIF
			DBSKIP()
		ENDDO
		ALERT(ALLTRIM(STR(_TT))+" GRAVADOS .. vou iniciar os calculos da 2a Parcela PR ...")
	ENDIF


	// CARREGA TABELA IR
	/*
	cAnoMES:=LEFT(DTOS(_DATA),6)
	cChaveIR:="09"
	aTabIr  :=ARRAY(5,3)
	For N =1 to 5
	For P =1 to 3
	aTabIr[N,P] := 0.00
	Next
	Next
	If FpHist82(SRA->RA_FILIAL , "09" , cAnoMes + "1")
	cChaveIR := SRX->RX_TIP
	aTabIr[1,1] := 6270 //VAL(SubStr(SRX->RX_TXT,1,12))
	aTabIr[1,2] := 0.00
	aTabIr[1,3] := 0.00

	aTabIr[2,1] := 9405 //VAL(SubStr(SRX->RX_TXT,13,12))
	aTabIr[2,2] := 7.50 //VAL(SubStr(SRX->RX_TXT,25,6))
	aTabIr[2,3] := 470.25  //VAL(SubStr(SRX->RX_TXT,31,12))    // PARC2

	aTabIr[3,1] := 12540//VAL(SubStr(SRX->RX_TXT,43,12))    // REND3
	aTabIr[3,2] := 15.00 //VAL(SubStr(SRX->RX_TXT,1,6))      // ALIQ3
	aTabIr[3,3] := 1175.63  //VAL(SubStr(SRX->RX_TXT,7,12))     // PARC3

	aTabIr[4,1] := 15675 //VAL(SubStr(SRX->RX_TXT,19,12))    // REND4
	aTabIr[4,2] := 22.50 //VAL(SubStr(SRX->RX_TXT,31,6))     // ALIQ4
	aTabIr[4,3] := 2116.13 //VAL(SubStr(SRX->RX_TXT,37,12))    // PARC4

	aTabIr[5,1] := 99999999999 //VAL(SubStr(SRX->RX_TXT,1,12))     // DESC
	aTabIr[5,2] := 27.5 //VAL(SubStr(SRX->RX_TXT,13,2))     // LIMI
	aTabIr[5,3] := 2899.88 //VAL(SubStr(SRX->RX_TXT,15,11))    // RETE
	Else
	Help(" ",1,"GPENTABIR")
	Return(.F.)
	EndIf
	*/

	DbSelectArea("SR8")    // BUSCA AFASTAMENTOS
	DBSETORDER(1)
	//************************************************** INICIA OS CALCULOS
	DBSELECTAREA("SRA")
	DBGOTOP()
	WHILE !EOF()
		_Avos:=0

		IF !(RA_MAT>=_MATDE .AND. RA_MAT<=_MATATE)   // FILTRO DA MATRICULA
			DBSKIP()
			Loop
		ENDIF

		IF RA_SITFOLH$" FA" .OR. (RA_SITFOLH="D" .AND. YEAR(RA_DEMISSA)>YEAR(_DATA))   // AVOS ATIVOS
			_ANO:=INT((_DATA-SRA->RA_ADMISSA)/365)                  // CONSIDERAR A DATA DO PARAMETRO
			_MES:=12-month(sra->ra_admissa) //INT(((_DATA-SRA->RA_ADMISSA)-(_ANO*365))/30)
			IF DAY(RA_ADMISSA)<=15 .AND. _MES<12
				_MES++
			ENDIF
			IF _ANO>=1
				_AVOS:=12
			ELSE
				_AVOS:=_MES
			ENDIF
		ENDIF


		IF _AVOS=0 .AND. RA_SITFOLH="D" .AND. YEAR(RA_DEMISSA)=YEAR(_DATA)    // AVOS DEMITIDOS
			_AVOS:=MONTH(RA_DEMISSA)-1
			IF DAY(RA_DEMISSA) > 15
				_AVOS++
			ENDIF
			IF YEAR(RA_ADMISSA)=YEAR(RA_DEMISSA)    // ADM E DEM NO MESMO ANO
				_AVOS:=MONTH(RA_DEMISSA) - MONTH(RA_ADMISSA)
			ENDIF
		ENDIF
		IF _TIPO=0 .AND. RA_SITFOLH="D"
			_Avos:=0                                // NAO CONSIDERAR DEMITIDOS NA ANTECIPACAO
		ENDIF

		//Elmo, em jan-20: Não incluir ADMITIDOS depois do AnoBase: .or. SRA->RA_ADMISSA>_DATA
		IF RA_CATFUNC#"M" .OR. RA_HRSMES<180 .or. SRA->RA_ADMISSA>_DATA
			_Avos:=0          // SÓ CONSIDERAR MENSALISTAS
		ENDIF

		cObs := ""

		IF _AVOS > 0
			_AvosAfa:=0
			nxSalario := BuscaSal(_DATA)
			DbSelectArea("SR8")    // BUSCA AFASTAMENTOS POR DOENÇA
			DbSeek(xFilial("SR8")+SRA->RA_MAT,.T.)
			While !Eof() .And. R8_MAT == SRA->RA_MAT
				dDbIniAfas := ctod("01/01/" + strzero(year(_DATA),4))
				dDbIniAfas := iif(YEAR(R8_DATAINI)<YEAR(_DATA), dDbIniAfas, R8_DATAINI)

				_DIASAFA:=IIF(!EMPTY(R8_DATAFIM),R8_DATAFIM,_DATA) - dDbIniAfas +1
				IF (( YEAR(R8_DATAINI)=YEAR(_DATA) .or. (YEAR(R8_DATAINI)<YEAR(_DATA) .and. (R8_DATAFIM>_DATA .or. EMPTY(R8_DATAFIM)))) ;
						.or. (YEAR(R8_DATAINI)<YEAR(_DATA) .and. R8_DATAFIM<=_DATA .and. !EMPTY(R8_DATAFIM)) )  ;
						.AND. R8_TIPOAFA="004" .AND. _DIASAFA>=15
					_AVOSAFA:=INT(_DIASAFA/30)
					IF ((_DIASAFA/30) - _AVOSAFA) > 0.5
						_AvosAfa++
						cOBS := "Mot.Afa.: "+ "Afastamento Temp. por doença"
					ENDIF
				ENDIF
				DbSkip()
			EndDo

			_Avos:=_Avos - _AvosAfa    // SUBTRAI OS AFASTAMENTOS ....

			//INÍCIO: Elmo, em jan-20: ajuste para não gravar avos negativos na PR...
			If _Avos < 0
				DBSELECTAREA("ZZ0")
				DBSEEK(xFilial("ZZ0")+SRA->RA_MAT)
				IF FOUND()
					RECLOCK("ZZ0",.F.)
					DELETE
					MSUNLOCK()
				ENDIF

				DBSELECTAREA("SRA")
				DBSKIP()
				loop
			Endif
			//FIM: Elmo, em jan-20: ajuste para não gravar avos negativos na PR...

			_AnoBase:=STRZERO(YEAR(_DATA),4,0)
			_CargaDD:=(SRA->RA_HRSMES/30)
			_FALT   :=0
			DBSELECTAREA("SRD")
			DBSETORDER(13)
			DBSEEK(xFilial("SRD")+SRA->RA_MAT+"409"+_AnoBase)
			WHILE !EOF() .AND. RD_MAT+RD_PD = SRA->RA_MAT+"409"
				IF RD_TIPO1="H"
					_FALT:=_FALT + RD_HORAS
				ELSEIF RD_TIPO1="D"
					_FALT:=_FALT + (RD_HORAS*_CargaDD)  // TRANSFORMA DIAS PARA HORAS O TOTALIZADOR
				ENDIF
				SRD->(DBSKIP())
			ENDDO
			_FALT     :=_FALT/_CARGADD   // TRANSFORMA DE VOLTA HORAS PARA DIAS
			_VLRFALTA :=0
			_PERFALT  :=0
			_PERDEU   :=0
			_ORIGFATOR:=_Fator       // GUARDA O FATOR ORIGINAL PARA RETORNO NO FINAL DA ROTINA
			IF _FALT>0 .AND. _TIPO=2 // SO CONSIDERA ABATIMENTO DE FALTAS NA SEGUNDA PARCELA ...
				IF _FALT=1
					_PERFALT:=0.30
				ELSEIF _FALT=2
					_PERFALT:=0.30
				ELSEIF _FALT>=3
					_PERFALT:=0.30
				ENDIF
				_Perdeu:= 0.30   // SE HOUVER FALTA NO PERIODO, O FATOR SERÁ SUBTRAIDO DE 0.30 (Meta Individual) EM 06/01/2012
			ENDIF


			_ADTO    := 0
			_IRAD    := 0
			_ANTECIP := 0
			_IRANTEC := 0

			DBSELECTAREA("ZZ0")
			DBSEEK(xFilial("ZZ0")+SRA->RA_MAT)
			IF FOUND() .AND. ZZ0_FATINF>0 .and. nOpFatInf==2     // SE O FATOR INFORMADO FOR MAIOR QUE ZERO, ELE SERVIRA COMO BASE PARA CALCULO DA PR
				_Fator :=ZZ0_FATINF
				_Perdeu:=0
			ENDIF
			IF _TIPO=0
				_ANTECIP := (((nxSalario*_FATOR)/12)*_Avos) * 0.25      // ANTECIPACAO OU PRIMEIRA PARCELA
				nBaseIni := _ANTECIP
				//_IRANTEC := iif(nBaseIni>6000,Calc_Ir(),0)
				DO CASE                                                  // TABELA DE 2014
				CASE nBASEINI>6677.55 .AND. nBASEINI<=9922.28
					_IRANTEC:=(nBASEINI*0.075)-500.82
				CASE nBASEINI>9922.28 .AND. nBASEINI<=13167.00
					_IRANTEC:=(nBASEINI*0.150)-1244.99
				CASE nBASEINI>13167.00 .AND. nBASEINI<=16380.38
					_IRANTEC:=(nBASEINI*0.225)-2232.51
				CASE nBASEINI>16380.38
					_IRANTEC:=(nBASEINI*0.275)-3051.53
				ENDCASE

			ELSEIF _TIPO=1                           // SÓ calcula ADIANTAMENTO SE FOR CALCULO TIPO 1 - 1A PARCELA
				_ADTO    := (((nxSalario*_FATOR)/12)*_Avos) * 0.50      // ANTECIPACAO OU PRIMEIRA PARCELA
				nBaseIni := _Adto
				_IRAD    := 0
				DO CASE                                                  // TABELA DE 2014
				CASE nBASEINI>6677.55 .AND. nBASEINI<=9922.28
					_IRAD:=(nBASEINI*0.075)-500.82
				CASE nBASEINI>9922.28 .AND. nBASEINI<=13167.00
					_IRAD:=(nBASEINI*0.150)-1244.99
				CASE nBASEINI>13167.00 .AND. nBASEINI<=16380.38
					_IRAD:=(nBASEINI*0.225)-2232.51
				CASE nBASEINI>16380.38
					_IRAD:=(nBASEINI*0.275)-3051.53
				ENDCASE


			ELSE
				_ADTO    := ZZ0->ZZ0_ADTO + ZZ0->ZZ0_ANTECI      // PR FINAL .. CONSIDERA ADTO + ANTECIP
				_IRAD    := ZZ0->ZZ0_IRAD + ZZ0->ZZ0_IRANTE
			ENDIF



			_PRTOT   := (ROUND((nxSalario*(_FATOR-_Perdeu)),2)/12)*_Avos   // PR TOTAL
			nBaseIni := _PrTot //- _Adto
			IF nBaseIni>6677.55                                            // CALCULA IR SOBRE IR TOTAL EM JANEIRO
				DO CASE                                                  // TABELA DE 2014
				CASE nBASEINI>6677.55 .AND. nBASEINI<=9922.28
					_IRPR:=(nBASEINI*0.075)-500.82
				CASE nBASEINI>9922.28 .AND. nBASEINI<=13167.00
					_IRPR:=(nBASEINI*0.150)-1244.99
				CASE nBASEINI>13167.00 .AND. nBASEINI<=16380.38
					_IRPR:=(nBASEINI*0.225)-2232.51
				CASE nBASEINI>16380.38
					_IRPR:=(nBASEINI*0.275)-3051.53
				ENDCASE
				_IRPR:=(_IRPR-_IRAD)                                      // CALCULA O DESCONTO CHEIO E ABATE O DESCONTO DOS ADTOS
			ELSE
				_IRPR :=0
			ENDIF

			DBSELECTAREA("ZZ0")
			DBSEEK(xFilial("ZZ0")+SRA->RA_MAT)
			IF FOUND()
				RECLOCK("ZZ0",.F.)
			ELSE
				RECLOCK("ZZ0",.T.)
				ZZ0->ZZ0_FILIAL:=xFilial("ZZ0")
				ZZ0->ZZ0_MAT   :=SRA->RA_MAT
			ENDIF
			ZZ0->ZZ0_SAL      :=nxSalario  //SRA->RA_SALARIO
			ZZ0->ZZ0_AVOS     :=_AVOS
			ZZ0->ZZ0_FATOR    :=(_FATOR-_Perdeu)
			ZZ0->ZZ0_PRTOT    :=_PrTot
			ZZ0->ZZ0_FALT     :=_FALT
			ZZ0->ZZ0_IRPR     :=_IRPR
			ZZ0->ZZ0_LQPR     :=_VLRFALTA
			IF _TIPO=0                           // GRAVA ANTECIPACAO
				ZZ0->ZZ0_ANTECI   :=_ANTECIP
				ZZ0->ZZ0_IRANTE   :=_IRANTEC
			ENDIF
			IF _TIPO=1                           // SÓ GRAVA ADIANTAMENTO SE FOR CALCULO TIPO 1 - 1A PARCELA
				ZZ0->ZZ0_ADTO     :=_Adto
				ZZ0->ZZ0_IRAD     :=_IRAD
				ZZ0->ZZ0_LQAD     :=(_Adto  - _IRAD)
			ENDIF
			If nOpFatInf == 1
				ZZ0->ZZ0_FATINF   := 0
			Endif

			If !empty(cObs)
				//ZZ0->ZZ0_OBS:= cObs
			Endif


			MSUNLOCK()
			_FATOR:=_ORIGFATOR   // RETORNA O FATOR ORIGINAL
		ELSE                     // DELETA FUNCIONARIO DA PR PARA AVOS = 0
			DBSELECTAREA("ZZ0")
			DBSEEK(xFilial("ZZ0")+SRA->RA_MAT)
			IF FOUND()
				RECLOCK("ZZ0",.F.)
				DELETE
				MSUNLOCK()
			ENDIF
		ENDIF
		DBSELECTAREA("SRA")
		DBSKIP()
	ENDDO

	ALERT("Concluido  ....")
	DbSelectArea("ZZ0")
	DBGOTOP()

RETURN



//****************************************************************************************************************
//****************************************************************************************************************
//****************************************************************************************************************
//****************************************************************************************************************

//***********
User Function RELADT()
	//***********
	cArea := Alias()
	nInd  := IndexOrd()

	cString := "ZZ0"
	cDesc1  := OemToAnsi("Esta rotina ir  imprimir a Rela‡ao de Funcion rios de")
	cDesc2  := OemToAnsi("acordo com os parametros definidiso p/ usuario.")
	cDesc3  := ""
	tamanho := "M"
	aOrd    := {}
	aReturn := { "Zebrado", 1,"Financeiro", 2, 2, 1, "",1 }
	nomeprog:= "RELADT"
	aLinha  := { }
	nLastKey:= 0
	Titulo  := "Relacao de Funcionarios - "

	cCancel := "***** CANCELADO PELO OPERADOR *****"
	cPerg   := "RELADT"
	m_pag   := 1

	wnrel   :="RELADT"
	CTipo   := 18


	_OPC  :=1
	@ 1,1 to  150,300 DIALOG oDlg2B TITLE "TIPO DE RELATORIO"
	@ 10, 22 SAY "1-CONFERENCIA "
	@ 20, 22 SAY "2-REL LIQUIDOS"
	@ 30, 22 SAY "3-REL CONTABIL"
	@ 40, 22 SAY "4-GERA 1a PARC"
	@ 50, 22 SAY "5-GERA ANTECIP"

	@ 60, 49 GET _OPC   SIZE 20,12 PICTURE "99"

	@ 60, 95 BmpButton Type 1 Action Close(oDlg2B)
	Activate Dialog oDlg2B Centered



	wnrel:= SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.f.,tamanho)


	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif


	aStru  := {}
	aadd(aStru , {'TRB_MAT' ,'C', 06,0} )
	aadd(aStru , {'TRB_BAN' ,'C', 08,0} ) // BANCO E AGENCIA
	aadd(aStru , {'TRB_CTA' ,'C', 15,0} ) // CONTA
	aadd(aStru , {'TRB_NOM' ,'C', 40,0} ) // NOME
	aadd(aStru , {'TRB_SAL' ,'N', 12,2} )
	aadd(aStru , {'TRB_CC'  ,'C', 09,0} )
	aadd(aStru , {'TRB_ADT' ,'N', 12,2} )
	aadd(aStru , {'TRB_IRA' ,'N', 12,2} )
	aadd(aStru , {'TRB_AVO' ,'N', 02,0} )
	aadd(aStru , {'TRB_SIT' ,'C', 01,0} )
	aadd(aStru , {'TRB_OBS' ,'C', 20,0} )
	aadd(aStru , {'TRB_FAL' ,'N', 03,0} )
	aadd(aStru , {'TRB_ANTEC' ,'N', 12,2} ) // ANTECIPACAO
	aadd(aStru , {'TRB_IRANT' ,'N', 12,2} )
	aadd(aStru , {'TRB_PROCE' ,'C', 05,0} )

	//cArqTemp := CriaTrab(aStru , .t.)

	//dbUseArea(.T.,,cArqTEMP,"TRB",.F.,.F.)
	oGetTab := FWTemporaryTable():New("TRB",)
	oGetTab:SetFields(aStru)
	IF _OPC=2
		//IndRegua( "TRB", cArqTEMP, "TRB_BAN+TRB_NOM" )
		oGetTab:AddIndex("01", {"TRB_BAN","TRB_NOM"} )
	ELSEIF _OPC=1
		//IndRegua( "TRB", cArqTEMP, "TRB_NOM" )
		oGetTab:AddIndex("01", {"TRB_NOM"} )
	ELSE
		//IndRegua( "TRB", cArqTEMP, "TRB_CC+TRB_NOM" )
		oGetTab:AddIndex("01", {"TRB_CC","TRB_NOM"} )
	ENDIF
	//dbSelectArea("TRB")

	oGetTab:Create()

	dbSelectArea("TRB")


	DBSELECTAREA("ZZ0")
	dbGoTop()
	_FATOR := ZZ0_FATOR
	WHILE !EOF()
		DBSELECTAREA("SRA")
		DBSETORDER(1)
		DBSEEK(xFilial("SRA")+ZZ0->ZZ0_MAT)
		IF FOUND()

			DBSELECTAREA("TRB")
			RECLOCK("TRB",.T.)
			TRB_MAT:=ZZ0->ZZ0_MAT
			TRB_BAN:=SRA->RA_BCDEPSA
			TRB_CTA:=SRA->RA_CTDEPSA
			TRB_NOM:=SRA->RA_NOME
			TRB_CC :=SRA->RA_CC
			TRB_SAL:=ZZ0->ZZ0_SAL  //SRA->RA_SALARIO
			TRB_ADT:=ZZ0->ZZ0_ADTO
			TRB_IRA:=ZZ0->ZZ0_IRAD
			TRB_AVO:=ZZ0->ZZ0_AVOS
			TRB_FAL:=ZZ0->ZZ0_FALT
			TRB_SIT:=SRA->RA_SITFOLH
			IF SRA->RA_SITFOLH="D"
				TRB_OBS:="Dem em "+DTOC(SRA->RA_DEMISSA)
			ENDIF
			IF YEAR(SRA->RA_ADMISSA)=YEAR(dDatabase)
				TRB_OBS:="Adm em "+DTOC(SRA->RA_ADMISSA)
			ENDIF
			TRB_ANTEC:=ZZ0->ZZ0_ANTECI
			TRB_IRANT:=ZZ0->ZZ0_IRANTE
			TRB_PROCE:=SRA->RA_PROCES

			MSUNLOCK()
		ENDIF
		DBSELECTAREA("ZZ0")
		DBSKIP()
	ENDDO

	IF _OPC<=3
		RptStatus({|| RptDet02() })// Substituido pelo assistente de conversao do AP5 IDE em 22/03/01 ==> RptStatus({|| Execute(RptDetail) })

	ELSEIF _OPC=4   // GERA 1a PARCELA DA PR
		_TT:=0
		// dbUseArea(.t.,"TOPCONN","RC061412","SRC_2",.t.)
		DBSELECTAREA("SRC")
		DBSETORDER(1)
		DBSELECTAREA("TRB")
		dbGoTop()
		While !Eof()
			IF TRB->TRB_ADT > 0 .AND. TRB->TRB_SIT#"D"
				DBSELECTAREA("RGB")
				dbSetOrder(1)
				_ANOMES:=strzero(Year(ddatabase),4)+strzero(month(ddatabase),2)
				DBSEEK(xFilial("RGB")+TRB->TRB_MAT+"216"+_ANOMES)      // ENTRA NA FORMA DE BASE NA FOLHA DO MES
				IF !FOUND()
					RECLOCK("RGB",.T.)
					RGB_FILIAL	:= XFILIAL("RGB")
					RGB_PERIOD 	:= _ANOMES
					RGB_SEMANA	:= "01"
					RGB_ROTEIR	:= "FOL"
					RGB_PROCES	:= TRB->TRB_PROCE
					RGB_MAT   	:= TRB->TRB_MAT
					RGB_PD    	:= '216'
					RGB_TIPO1 	:= "V"
					RGB_TIPO2 	:= "I"
					RGB_DTREF	:= LASTDAY(DDATABASE)
				ELSE
					RECLOCK("RGB",.F.)
				ENDIF
				RGB_CC   		:= TRB->TRB_CC
				RGB_VALOR		:= TRB->TRB_ADT
				RGB->(MSUNLOCK())
				_TT++

				//				DBSELECTAREA("SRC")
				//				DBSEEK(xFilial("SRC")+TRB->TRB_MAT+"501")      // SAI NA FORMA DE DESCONTO PARA NAO INTERFERIR NO LIQUIDO
				DBSELECTAREA("RGB")
				dbSetOrder(1)
				_ANOMES:=strzero(Year(ddatabase),4)+strzero(month(ddatabase),2)
				DBSEEK(xFilial("RGB")+TRB->TRB_MAT+"501"+_ANOMES)      // ENTRA NA FORMA DE BASE NA FOLHA DO MES
				IF !FOUND()
					RECLOCK("RGB",.T.)
					RGB_FILIAL	:= XFILIAL("RGB")
					RGB_PERIOD 	:= _ANOMES
					RGB_SEMANA	:= "01"
					RGB_ROTEIR	:= "FOL"
					RGB_PROCES	:= TRB->TRB_PROCE
					RGB_MAT   	:= TRB->TRB_MAT
					RGB_PD    	:= '501'
					RGB_TIPO1 	:= "V"
					RGB_TIPO2 	:= "I"
					RGB_DTREF	:= LASTDAY(DDATABASE)
				ELSE
					RECLOCK("RGB",.F.)
				ENDIF
				RGB_CC   		:= TRB->TRB_CC
				RGB_VALOR		:= (TRB->TRB_ADT-TRB->TRB_IRA)
				RGB->(MSUNLOCK())

				IF TRB->TRB_IRA > 0 .AND. !(YEAR(DDATABASE)=2010)  // DESCONTA IR SE NAO FOR 2010.. ESSE ANO NAO HOUVE DESCONTO
					DBSELECTAREA("RGB")
					dbSetOrder(1)
					_ANOMES:=strzero(Year(ddatabase),4)+strzero(month(ddatabase),2)
					DBSEEK(xFilial("RGB")+TRB->TRB_MAT+"500"+_ANOMES)      // ENTRA NA FORMA DE BASE NA FOLHA DO MES
					IF !FOUND()
						RECLOCK("RGB",.T.)
						RGB_FILIAL	:= XFILIAL("RGB")
						RGB_PERIOD 	:= _ANOMES
						RGB_SEMANA	:= "01"
						RGB_ROTEIR	:= "FOL"
						RGB_PROCES	:= TRB->TRB_PROCE
						RGB_MAT   	:= TRB->TRB_MAT
						RGB_PD    	:= '500'
						RGB_TIPO1 	:= "V"
						RGB_TIPO2 	:= "I"
						RGB_DTREF	:= LASTDAY(DDATABASE)
					ELSE
						RECLOCK("RGB",.F.)
					ENDIF
					RGB_CC   :=TRB->TRB_CC
					RGB_VALOR:=TRB->TRB_IRA
					MSUnLock()
				ENDIF

			ENDIF

			DBSELECTAREA("TRB")
			DBSKIP()
		ENDDO
		ALERT(STR(_TT,10,0)+" lancamentos gerados.")
	ELSEIF _OPC=5   // GERA ANTECIPACAO
		_TT:=0
		DBSELECTAREA("SRC")
		DBSETORDER(1)
		DBSELECTAREA("TRB")
		dbGoTop()
		While !Eof()
			IF TRB->TRB_ANTEC > 0 .AND. TRB->TRB_SIT#"D"
				DBSELECTAREA("RGB")
				dbSetOrder(1)
				_ANOMES:=strzero(Year(ddatabase),4)+strzero(month(ddatabase),2)
				DBSEEK(xFilial("RGB")+TRB->TRB_MAT+"216"+_ANOMES)      // ENTRA NA FORMA DE BASE NA FOLHA DO MES
				IF !FOUND()
					RECLOCK("RGB",.T.)
					RGB_FILIAL	:= XFILIAL("RGB")
					RGB_PERIOD 	:= _ANOMES
					RGB_SEMANA	:= "01"
					RGB_ROTEIR	:= "FOL"
					RGB_PROCES	:= TRB->TRB_PROCE
					RGB_MAT   	:= TRB->TRB_MAT
					RGB_PD    	:= '216'
					RGB_TIPO1 	:= "V"
					RGB_TIPO2 	:= "I"
					RGB_DTREF	:= LASTDAY(DDATABASE)
				ELSE
					RECLOCK("RGB",.F.)
				ENDIF
				RGB_CC   		:= TRB->TRB_CC
				RGB_VALOR		:= TRB->TRB_ANTEC
				RGB->(MSUNLOCK())
				_TT++

				DBSELECTAREA("RGB")
				dbSetOrder(1)
				_ANOMES:=strzero(Year(ddatabase),4)+strzero(month(ddatabase),2)
				DBSEEK(xFilial("RGB")+TRB->TRB_MAT+"501"+_ANOMES)      // ENTRA NA FORMA DE BASE NA FOLHA DO MES
				IF !FOUND()
					RECLOCK("RGB",.T.)
					RGB_FILIAL	:= XFILIAL("RGB")
					RGB_PERIOD 	:= _ANOMES
					RGB_SEMANA	:= "01"
					RGB_ROTEIR	:= "FOL"
					RGB_PROCES	:= TRB->TRB_PROCE
					RGB_MAT   	:= TRB->TRB_MAT
					RGB_PD    	:= '501'
					RGB_TIPO1 	:= "V"
					RGB_TIPO2 	:= "I"
					RGB_DTREF	:= LASTDAY(DDATABASE)
				ELSE
					RECLOCK("RGB",.F.)
				ENDIF
				RGB_CC   		:= TRB->TRB_CC
				RGB_VALOR		:= (TRB->TRB_ANTEC-TRB->TRB_IRANT)
				RGB->(MSUNLOCK())

				IF TRB->TRB_IRANT > 0  // DESCONTA IR ANTECIPACAO
					DBSELECTAREA("RGB")
					dbSetOrder(1)
					_ANOMES:=strzero(Year(ddatabase),4)+strzero(month(ddatabase),2)
					DBSEEK(xFilial("RGB")+TRB->TRB_MAT+"500"+_ANOMES)      // ENTRA NA FORMA DE BASE NA FOLHA DO MES
					IF !FOUND()
						RECLOCK("RGB",.T.)
						RGB_FILIAL	:= XFILIAL("RGB")
						RGB_PERIOD 	:= _ANOMES
						RGB_SEMANA	:= "01"
						RGB_ROTEIR	:= "FOL"
						RGB_PROCES	:= TRB->TRB_PROCE
						RGB_MAT   	:= TRB->TRB_MAT
						RGB_PD    	:= '500'
						RGB_TIPO1 	:= "V"
						RGB_TIPO2 	:= "I"
						RGB_DTREF	:= LASTDAY(DDATABASE)
					ELSE
						RECLOCK("RGB",.F.)
					ENDIF
					RGB_CC   		:= TRB->TRB_CC
					RGB_VALOR		:= TRB->TRB_IRANT
					RGB->(MSUNLOCK())

				ENDIF

			ENDIF

			DBSELECTAREA("TRB")
			DBSKIP()
		ENDDO
		ALERT(STR(_TT,10,0)+" lancamentos gerados.")

	ELSEIF _OPC=99 .AND. YEAR(DDATABASE)=2015   // GERA 1a PARCELA DA PR NO MES DE DEZEMBRO ANTERIOR QUANDO FECHADO E NAO TRANSITADO

		/*
		DBSELECTAREA("SRD")
		DBSEEK(xFilial("SRD")+TRB->TRB_MAT+"501"+"201412")
		IF !FOUND()
		RECLOCK("SRD",.T.)                         // GRAVA NOVO NO SRD
		RD_FILIAL:=XFILIAL("SRD")
		RD_MAT   :=TRB->TRB_MAT
		RD_PD    :="500"
		RD_DATARQ:="201412"
		RD_DATPGT:=CTOD("20/12/2014")
		RD_MES   :="12"
		RD_TIPO1 :="V"
		RD_TIPO2 :="C"
		RD_VALOR :=TRB->TRB_IRA
		RD_STATUS:="A"
		RD_CC   :=TRB->TRB_CC
		SRD->(MSUNLOCK())
		ELSE
		RECLOCK("SRD",.F.)
		RD_VALOR :=TRB->TRB_ADT-TRB->TRB_IRA
		SRD->(MSUNLOCK())
		ENDIF   
		*/

	ENDIF

	dbSelectArea( cArea )

Return

//***********************
Static Function RptDet02()
	//**********************

	cTitulo:= "Relacao de Adiantamento PR Anual * Fator : "+STR(_FATOR,5,2)+" %"
	nReg   := 1
	nTot   := 0
	nLin   := 0
	m_pag  := 1

	IF _OPC=1
		cabec1 :="Matric Nome                             SalarioBase AdiantamenPR         IR        Liquido Avos St Observacao          CCusto    Fal"
	ELSEIF _OPC=2
		cabec1 :="Bco Agenc Conta          Matric Nome                                               Liquido  CCusto"
	ELSE
		cabec1 :="Codigo   Centro de Custo                          AdiantamentoPR         IR        Liquido"
	ENDIF
	cabec2 :=" "
	nLin:= Cabec(CTitulo,Cabec1,Cabec2,NomeProg,Tamanho,cTipo) + 1



	IF _OPC=1                // RELATORIO PARA CONFERENCIA

		TREG:=0
		_TTSAL:=0
		_A  :=0
		_B  :=0
		DBSELECTAREA("TRB")
		dbGoTop()
		SetRegua(LastRec()) //Ajusta numero de elementos da regua de relatorios

		While !Eof()
			IncRegua() //Incrementa a posicao da regua de relatorios
			_AFAST:=""
			DbSelectArea("SR8")
			DbSeek(xFilial("SR8")+TRB->TRB_MAT,.T.)
			While !Eof() .And. R8_MAT == TRB->TRB_MAT
				_DIASAFA:=IIF(!EMPTY(R8_DATAFIM),R8_DATAFIM,dDataBase) - R8_DATAINI
				IF YEAR(R8_DATAINI)=YEAR(dDataBase) .AND. !LEFT(R8_TIPO,1)$"FQO" .AND. _DIASAFA>=15
					//SX5->(DbSeek(xFilial("SX5")+"30"+SR8->R8_TIPO,.T.)) //aMotivo[Val(R8_AFARAIS)/10]
					//cTipo := SX5->X5_DESCRI

					aGetSX5 := FWGetSX5("30")
					nPosChv := Ascan(aGetSX5, {|x| Alltrim(x[3]) == SR8->R8_TIPO})
					cDesSX5 := ""
					If !Empty(nPosChv)
						cDesSX5 := aGetSX5[nPosChv,04]
					EndIf
					cTipo := cDesSX5
					_AFAST:=_AFAST + STRZERO(_DIASAFA,3,0)+" Dd afast mot: "+R8_TIPO+"-"+ALLTRIM(cDesSX5)+" / "
				ENDIF
				DbSkip()
			EndDo
			DbSelectArea("TRB")


			@ nLin,000 Psay TRB->TRB_MAT
			@ nLin,007 PSay LEFT(TRB->TRB_NOM,31)
			@ nLin,039 Psay TRB->TRB_SAL                PICTURE "@E 9,999,999.99"
			@ nLin,052 Psay TRB->TRB_ADT                PICTURE "@E 9,999,999.99"
			@ nLin,065 Psay TRB->TRB_IRA                PICTURE "@E 999,999.99"
			@ nLin,076 Psay TRB->TRB_ADT-TRB->TRB_IRA   PICTURE "@E 999,999,999.99"
			@ nLin,091 PSay TRB->TRB_AVO                PICTURE "99"
			@ nLin,093 PSAY "/12"
			@ nLin,097 PSay TRB->TRB_SIT
			@ nLin,099 PSAY LEFT(TRB_OBS,20)
			@ nLIN,120 PSAY TRB_CC
			@ nLIN,129 PSAY TRB_FAL PICTURE "@Z 999"
			_TTSAL:=_TTSAL + TRB->TRB_SAL

			IF MONTH(DDATABASE)#12 .AND. TRB->TRB_ANTEC>0  // ANTECIPACAO
				nLin++
				@nLin,007  PSAY "Antecipacao 25%"
				@ nLin,052 Psay TRB->TRB_ANTEC                PICTURE "@E 9,999,999.99"
				@ nLin,065 Psay TRB->TRB_IRANT                PICTURE "@E 999,999.99"
			ENDIF

			IF !EMPTY(_Afast)
				nLin++
				@ nLin,007 PSAY "*Hist Afast : "+_Afast
			ENDIF
			nLin++
			TREG++
			_A:=_A + TRB->TRB_ADT
			_B:=_B + TRB->TRB_IRA
			If nLin>40
				nLin:= Cabec(CTitulo,Cabec1,Cabec2,NomeProg,Tamanho,cTipo)
			Endif
			DBSELECTAREA("TRB")
			TRB->(dbSkip())
		EndDO

		@ nLin,000 psay repl("==",66)
		nLin := nLin + 1
		@ nLin,000 Psay Alltrim(Str(TREG))+" Funcionarios..."
		@ nLin,039 Psay _TTSAL  PICTURE "@E 9,999,999.99"
		@ nLin,052 Psay _A      PICTURE "@E 9,999,999.99"
		@ nLin,065 Psay _B      PICTURE "@E 999,999.99"
		@ nLin,076 Psay _A-_B   PICTURE "@E 999,999,999.99"
		nLin := nLin + 1
		@ nLin,000 psay repl("==",66)
		nLin := nLin + 2
		@ nLin,052 Psay "* Liquido a pagar ...:"
		@ nLin,076 Psay _A-_B   PICTURE "@E 999,999,999.99"
		@ nLin,092 PSAY "Fator ....:"
		@ nLin,105 PSAY _FATOR PICTURE "@E 9.99"
		@ nLin,110 PSAY "%"

	ELSEIF _OPC=2      //  RELACAO DE LIQUIDOS

		TREG:=0
		_A  :=0
		_AA :=0
		DBSELECTAREA("TRB")
		dbGoTop()
		SetRegua(LastRec()) //Ajusta numero de elementos da regua de relatorios

		_KEY:=TRB_BAN
		While !Eof()
			IncRegua() //Incrementa a posicao da regua de relatorios
			IF TRB->TRB_SIT="D"
				TRB->(DBSKIP())
				Loop
			ENDIF
			If nLin>42
				nLin:= Cabec(CTitulo,Cabec1,Cabec2,NomeProg,Tamanho,cTipo)
			Endif
			IF (EOF() .OR. TRB_BAN#_KEY) .AND. _AA#0
				nLin++
				@ nLin,000 PSAY "Total do Banco/Agencia : "+LEFT(_Key,3)+" / "+SUBSTR(_Key,4,5)
				@ nLin,076 Psay _AA  PICTURE "@E 999,999,999.99"
				_AA:=0
				nLin++
				@ nLin,000 PSAY __PrtThinLine()
				nLin++
			ENDIF

			@ nLin,000 Psay LEFT(TRB->TRB_BAN,3)
			@ nLin,004 PSay SUBSTR(TRB->TRB_BAN,4,5)
			@ nLin,010 PSay LEFT(TRB_CTA,11)+"-"+SUBSTR(TRB_CTA,12,1)
			@ nLin,025 PSay TRB_MAT
			@ nLin,032 PSay LEFT(TRB_NOM,43)
			@ nLin,076 Psay TRB->TRB_ADT-TRB->TRB_IRA   PICTURE "@E 999,999,999.99"
			@ nLIN,092 PSAY TRB_CC

			nLin++
			TREG++
			_AA:=_AA + (TRB->TRB_ADT-TRB->TRB_IRA)
			_A:=_A   + (TRB->TRB_ADT-TRB->TRB_IRA)

			_KEY:=TRB_BAN
			DBSELECTAREA("TRB")
			TRB->(dbSkip())
		EndDO
		IF  _AA#0
			nLin++
			@ nLin,000 PSAY "Total do Banco/Agencia : "+LEFT(_Key,3)+" / "+SUBSTR(_Key,4,5)
			@ nLin,076 Psay _AA  PICTURE "@E 999,999,999.99"
			_AA:=0
			nLin++
			@ nLin,000 PSAY __PrtThinLine()
			nLin++
		ENDIF

		@ nLin,000 psay repl("==",66)
		nLin := nLin + 1
		@ nLin,000 Psay Alltrim(Str(TREG))+" Funcionarios..."
		@ nLin,076 Psay _A  PICTURE "@E 999,999,999.99"
		nLin := nLin + 1
		@ nLin,000 psay repl("==",66)

	ELSE

		TREG:=0
		_A  :=0
		_B  :=0
		_AA :=0
		_BB :=0
		DBSELECTAREA("TRB")
		dbGoTop()
		SetRegua(LastRec()) //Ajusta numero de elementos da regua de relatorios

		While !Eof()
			IncRegua() //Incrementa a posicao da regua de relatorios
			TREG++
			_AA:=_AA + TRB->TRB_ADT
			_A:=_A   + TRB->TRB_ADT
			_BB:=_BB + TRB->TRB_IRA
			_B:=_B   + TRB->TRB_IRA


			If nLin>42
				nLin:= Cabec(CTitulo,Cabec1,Cabec2,NomeProg,Tamanho,cTipo)
			Endif
			_KEY:=TRB_CC
			DBSELECTAREA("TRB")
			TRB->(dbSkip())

			IF EOF() .OR. TRB_CC#_KEY
				nLin++
				_DESCCC:=ALLTRIM(Posicione("CTT",1,xFilial("CTT")+_Key,"CTT_DESC01"))

				@ nLin,000 PSAY _KEY+_DESCCC

				@ nLin,050 Psay _AA      PICTURE "@E 999,999,999.99"
				@ nLin,065 Psay _BB      PICTURE "@E 999,999.99"
				@ nLin,076 Psay _AA-_BB  PICTURE "@E 999,999,999.99"
				_AA:=_BB:=0
				nLin++
				@ nLin,000 PSAY __PrtThinLine()
				nLin++
			ENDIF
		EndDO

		@ nLin,000 psay repl("==",66)
		nLin := nLin + 1
		@ nLin,000 Psay Alltrim(Str(TREG))+" Funcionarios..."
		@ nLin,050 Psay _A      PICTURE "@E 999,999,999.99"
		@ nLin,065 Psay _B      PICTURE "@E 999,999.99"
		@ nLin,076 Psay _A-_B  PICTURE "@E 999,999,999.99"
		nLin := nLin + 1
		@ nLin,000 psay repl("==",66)

	ENDIF




	dbClearFilter()

	If aReturn[5] == 1
		Set Printer To
		Commit
		ourspool(wnrel) //Chamada do Spool de Impressao
	Endif
	MS_FLUSH() //Libera fila de relatorios em spool


	_GeraXls:=1
	@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Gera Planilha Excel ?"
	@ 10, 49 SAY "1 - Nao"
	@ 22, 49 SAY "2 - Sim"
	@ 44, 49 GET _GeraXls PICTURE "99"
	@ 60, 90 BmpButton Type 1 Action Close(oDlg2)
	Activate Dialog oDlg2 Centered
	IF _GeraXls=2
		DBSELECTAREA("TRB")
		DBGOTOP()
		//	COPY TO PR.DBF
		cArqRen:='\SYSTEM\TEMPDBF\PR" + GetDBExtension()
		//Copy to &cArqRen VIA "CTREECDX"

		_arquivo:="G:\system\TEMPDBF\PR" + GetDBExtension()
		If !File(_arquivo)
			_arquivo:="F:\system\TEMPDBF\PR" + GetDBExtension()
			If !File(_arquivo)
				_arquivo:="C:\PROTHEUS10\PROTHEUS_DATA\system\PR" + GetDBExtension()
			endif
		EndIf

		If ! ApOleClient( 'MsExcel' )
			MsgStop( 'Excel não instalado' )
		ELSE
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( _arquivo )
			oExcelApp:SetVisible(.T.)
		ENDIF

	ENDIF



	DbSelectArea("TRB")
	DbCloseArea()
	//(cArqTEMP)

	dbSelectArea("ZZ0")
	DBGOTOP()

Return

//***********
User Function REL2PR()
	Local i:= 0
	Local ni:= 0
	Private aGeraXLS   := {}

	//***********
	cArea := Alias()
	nInd  := IndexOrd()

	cString := "ZZ0"
	cDesc1  := OemToAnsi("Esta rotina ir  imprimir a Rela‡ao de Funcion rios de")
	cDesc2  := OemToAnsi("acordo com os parametros definidiso p/ usuario.")
	cDesc3  := ""
	tamanho := "M"
	aOrd    := {}
	aReturn := { "Zebrado", 1,"Financeiro", 2, 2, 1, "",1 }
	nomeprog:= "REL2PR"
	aLinha  := { }
	nLastKey:= 0
	Titulo  := "Relacao de Funcionarios - "
	cCancel := "***** CANCELADO PELO OPERADOR *****"
	cPerg   := "REL2PR"
	m_pag   := 1
	wnrel   :="REL2PR"
	CTipo   := 18

	_OPC  :=1
	_MATDE :="000000"
	_MATATE:="999999"
	@ 1,1 to  150,300 DIALOG oDlg2C TITLE "TIPO DE RELATORIO"
	@ 10, 22 SAY "1-CONFERENCIA "
	@ 20, 22 SAY "2-REL LIQUIDOS"
	@ 30, 22 SAY "3-REL CONTABIL"
	@ 40, 10 SAY "4-Gera Lct Folha-SRC"
	@ 50, 10 SAY "5-Gera Lct Demit-SR1"
	@ 10, 95 SAY "Matric DE"
	@ 20, 95 GET _MATDE   SIZE 35,12 F3 "SRA"
	@ 30, 95 SAY "Matric Ate"
	@ 40, 95 GET _MATATE  SIZE 35,12 F3 "SRA"
	@ 60, 49 GET _OPC   SIZE 20,12 PICTURE "99"
	@ 60, 95 BmpButton Type 1 Action Close(oDlg2C)
	Activate Dialog oDlg2C Centered

	IF _OPC=0 .OR. _OPC>5
		RETURN Nil
	ENDIF

	wnrel:= SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.f.,tamanho)

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif


	aStru  := {}
	aadd(aStru , {'TRB_MAT' ,'C', 06,0} )
	aadd(aStru , {'TRB_BAN' ,'C', 08,0} ) // BANCO E AGENCIA
	aadd(aStru , {'TRB_CTA' ,'C', 15,0} ) // CONTA
	aadd(aStru , {'TRB_NOM' ,'C', 40,0} ) // NOME
	aadd(aStru , {'TRB_SAL' ,'N', 12,2} )
	aadd(aStru , {'TRB_CC'  ,'C', 09,0} )
	aadd(aStru , {'TRB_PRT' ,'N', 12,2} )
	aadd(aStru , {'TRB_ADT' ,'N', 12,2} )
	aadd(aStru , {'TRB_IR2' ,'N', 12,2} )
	aadd(aStru , {'TRB_DFA' ,'N', 12,2} )
	aadd(aStru , {'TRB_LIQ' ,'N', 12,2} )
	aadd(aStru , {'TRB_AVO' ,'N', 02,0} )
	aadd(aStru , {'TRB_SIT' ,'C', 01,0} )
	aadd(aStru , {'TRB_OBS' ,'C', 20,0} )
	aadd(aStru , {'TRB_FAL' ,'N', 03,0} )
	aadd(aStru , {'TRB_FAT' ,'N', 04,2} )
	aadd(aStru , {'TRB_PRC' ,'C', 05,0} )

	//cArqTemp := CriaTrab(aStru , .t.)
	//dbUseArea(.T.,,cArqTEMP,"TRB",.F.,.F.)

	oGetTab := FWTemporaryTable():New("TRB",)
	oGetTab:SetFields(aStru)
	//oGetTab:AddIndex("01", {"T_NUM"} )
	oGetTab:Create()

	dbSelectArea("TRB")

	cLin := ""
	For i:=1 to fCount()
		cLin += fieldName(i) + ";"
	Next
	aadd(aGeraXLS , cLin)

	IF _OPC=2
		IndRegua( "TRB", cArqTEMP, "TRB_BAN","TRB_NOM" )
	ELSEIF _OPC=1 .OR. _OPC>=4
		IndRegua( "TRB", cArqTEMP, "TRB_NOM" )
	ELSE
		IndRegua( "TRB", cArqTEMP, "TRB_CC","TRB_NOM" )
	ENDIF
	dbSelectArea("TRB")

	DBSELECTAREA("ZZ0")
	dbGoTop()
	_FATOR := ZZ0_FATOR
	WHILE !EOF()
		IF !(ZZ0->ZZ0_MAT>=_MATDE .AND.ZZ0->ZZ0_MAT<=_MATATE)  // FILTRA MATRIC
			ZZ0->(DBSKIP())
			Loop
		ENDIF
		DBSELECTAREA("SRA")
		DBSETORDER(1)
		DBSEEK(xFilial("SRA")+ZZ0->ZZ0_MAT)
		IF FOUND()
			DBSELECTAREA("TRB")
			RECLOCK("TRB",.T.)
			TRB_MAT:=ZZ0->ZZ0_MAT
			TRB_BAN:=SRA->RA_BCDEPSA
			TRB_CTA:=SRA->RA_CTDEPSA
			TRB_NOM:=SRA->RA_NOME
			TRB_CC :=SRA->RA_CC
			TRB_SAL:=ZZ0->ZZ0_SAL  //SRA->RA_SALARIO
			TRB_PRC:=SRA->RA_PROCES
			TRB_PRT:=ZZ0->ZZ0_PRTOT
			TRB_ADT:=ZZ0->ZZ0_ADTO+ZZ0->ZZ0_ANTECI  // ADIANTAMENTO MAIS A ANTECIPACAO BUSCADO DO SRD (INICIO DESTA ROTINA)
			TRB_IR2:=ZZ0->ZZ0_IRPR
			TRB_DFA:=ZZ0->ZZ0_LQPR
			TRB_AVO:=ZZ0->ZZ0_AVOS
			TRB_FAL:=ZZ0->ZZ0_FALT
			TRB_SIT:=SRA->RA_SITFOLH
			TRB_FAT:=ZZ0->ZZ0_FATOR
			IF SRA->RA_SITFOLH="D"
				TRB_OBS:="Dem em "+DTOC(SRA->RA_DEMISSA)
			ENDIF
			IF YEAR(SRA->RA_ADMISSA)=YEAR(dDatabase)
				TRB_OBS:="Adm em "+DTOC(SRA->RA_ADMISSA)
			ENDIF

			MSUNLOCK()

			_LIQUIDO:=(TRB->TRB_PRT-TRB->TRB_ADT-TRB->TRB_IR2-TRB->TRB_DFA)
			IF _LIQUIDO<0 // NAO IMPRIME VALORES NEGATIVOS
				RECLOCK("TRB",.F.)
				DELETE
				MSUNLOCK()
			ELSE
				RECLOCK("TRB",.F.)
				TRB_LIQ:=_LIQUIDO    // GRAVA LIQUIDO NO ARQ DE TRABALHO
				MSUNLOCK()
			ENDIF

			//aquix
			cLin := ""
			For ni:=1 to fCount()
				cField := FieldName(ni)
				cConteudo = FieldGet(ni)
				If  U_fVldTyp('Type(cField) =="N"')
					nTam   := max(17, len(alltrim(str(cConteudo))))
					cPict := "@e 99,999,999,999.99"
					If len(alltrim(str(cConteudo))) <= 2
						nTam   := max(len(cField), len(alltrim(str(cConteudo))))
						cPict := ""
					Endif
					cConteudo := transform(cConteudo , cPict)
				ElseIf  U_fVldTyp('Type(cField) =="D"')
					nTam   := 12
					cPict := ""
					cConteudo := dtoc(cConteudo)
				ElseIf  U_fVldTyp('Type(cField) =="C"')
					nTam   := max(len(cField),len(alltrim(cConteudo))) + 1
					cPict := ""
				Else
					nTam   := max(len(cField),len(cConteudo))
					cPict := ""
				Endif
				If  U_fVldTyp('Type(cField) =="C"') .and. val(cConteudo) > 0 .and. len(alltrim(cConteudo)) == 8
					cPict := "@e 99/99/9999"
					cConteudo := dtoc(cConteudo)
					nTam  := 13
				Endif

				cLin += cConteudo + ";"
			Next

			aadd(aGeraXLS , cLin)  //a ser usado para gerar arquivo CSV

			//aquix

		ENDIF
		DBSELECTAREA("ZZ0")
		DBSKIP()
	ENDDO

	RptStatus({|| RptDet03() })// Substituido pelo assistente de conversao do AP5 IDE em 22/03/01 ==> RptStatus({|| Execute(RptDetail) })

	dbSelectArea( cArea )

Return

//***********************
Static Function RptDet03()
	//**********************
	Local i:=0

	cTitulo:= "Relacao de 2a PARCELA -  PR Anual * Fator : "+STR(_FATOR,5,2)+" %"
	nReg   := 1
	nTot   := 0
	nLin   := 0
	m_pag  := 1

	IF _OPC=1 .OR. _OPC>=4
		cabec1 :="Matric Nome                                PR.Total Adiantamento         IR     Faltas     Avos St Observacao          CCusto    Fal Fator"
	ELSEIF _OPC=2
		cabec1 :="Bco Agenc Conta          Matric Nome                                               Liquido  CCusto"
	ELSE
		cabec1 :="Codigo   Centro de Custo                             Total da PR Adiantamen    I.Renda    Faltas    Liquido"
	ENDIF
	cabec2 :=" "
	nLin:= Cabec(CTitulo,Cabec1,Cabec2,NomeProg,Tamanho,cTipo) + 1



	IF _OPC=1 .OR. _OPC>=4                // RELATORIO PARA CONFERENCIA OU GERANDO LANCAMENTO PARA FOLHA

		TREG:=0
		_TTSAL:=0
		_A  :=0
		_B  :=0
		_C  :=0
		DBSELECTAREA("TRB")
		dbGoTop()
		SetRegua(LastRec()) //Ajusta numero de elementos da regua de relatorios

		While !Eof()
			IncRegua() //Incrementa a posicao da regua de relatorios


			IF _OPC=5 .AND. TRB->TRB_SIT#"D"   // SOMENTE DEMITIDOS
				TRB->(dbSkip())
				Loop
			ENDIF


			_AFAST:=""
			DbSelectArea("SR8")
			DbSeek(xFilial("SR8")+TRB->TRB_MAT,.T.)
			While !Eof() .And. R8_MAT == TRB->TRB_MAT
				_DIASAFA:=IIF(!EMPTY(R8_DATAFIM),R8_DATAFIM,dDataBase) - R8_DATAINI
				IF YEAR(R8_DATAINI)=YEAR(dDataBase) .AND. !LEFT(R8_TIPO,1)$"FQO" .AND. _DIASAFA>=15
					//SX5->(DbSeek(xFilial("SX5")+"30"+SR8->R8_TIPO,.T.)) //aMotivo[Val(R8_AFARAIS)/10]
					//cTipo := SX5->X5_DESCRI
					aGetSX5 := FWGetSX5("30")
					nPosChv := Ascan(aGetSX5, {|x| Alltrim(x[3]) == SR8->R8_TIPO})
					cDesSX5 := ""
					If !Empty(nPosChv)
						cDesSX5 := aGetSX5[nPosChv,04]
					EndIf
					cTipo := cDesSX5
					_AFAST:=_AFAST + STRZERO(_DIASAFA,3,0)+" Dd afast mot: "+R8_TIPO+"-"+ALLTRIM(cDesSX5)+" / "
				ENDIF
				DbSkip()
			EndDo

			DbSelectArea("TRB")

			_LIQUIDO:=(TRB->TRB_PRT-TRB->TRB_ADT-TRB->TRB_IR2-TRB->TRB_DFA)
			IF _LIQUIDO<0 // NAO IMPRIME VALORES NEGATIVOS
				RECLOCK("TRB",.F.)
				DELETE
				MSUNLOCK()
				DBSKIP()
				Loop
			ELSE
				RECLOCK("TRB",.F.)
				TRB_LIQ:=_LIQUIDO    // GRAVA LIQUIDO NO ARQ DE TRABALHO
				MSUNLOCK()
			ENDIF

			@ nLin,000 Psay TRB->TRB_MAT
			@ nLin,007 PSay LEFT(TRB->TRB_NOM,31)
			@ nLin,039 Psay TRB->TRB_PRT                PICTURE "@E 9,999,999.99"
			@ nLin,052 Psay TRB->TRB_ADT                PICTURE "@E 9,999,999.99"
			@ nLin,065 Psay TRB->TRB_IR2                PICTURE "@E 999,999.99"
			@ nLin,076 Psay TRB->TRB_DFA                PICTURE "@EZ 999,999.99" // FALTAS
			@ nLin,091 PSay TRB->TRB_AVO                PICTURE "99"
			@ nLin,093 PSAY "/12"
			@ nLin,097 PSay TRB->TRB_SIT
			@ nLin,099 PSAY LEFT(TRB_OBS,20)
			@ nLIN,120 PSAY TRB_CC
			@ nLIN,129 PSAY TRB_FAL PICTURE "@Z 999"
			@ nLIN,134 PSAY TRB_FAT PICTURE "@E 9.99"

			nLin++
			@ nLin,007 Psay TRB->TRB_SAL                PICTURE "@E 9,999,999.99"
			@ nLin,066 Psay "* Liquido ...:"
			@ nLin,082 Psay TRB->TRB_PRT-TRB->TRB_ADT-TRB->TRB_IR2-TRB->TRB_DFA   PICTURE "@E 999,999,999.99"
			nLin++

			IF _OPC=4    // GERA LANCAMENTOS NO MES
				IF TRB->TRB_LIQ > 0 .AND. TRB->TRB_SIT#"D"
					DBSELECTAREA("RGB")
					dbSetOrder(1)
					_ANOMES:=strzero(Year(ddatabase),4)+strzero(month(ddatabase),2)
					DBSEEK(xFilial("RGB")+TRB->TRB_MAT+"216"+_ANOMES)      // ENTRA NA FORMA DE BASE NA FOLHA DO MES
					IF !FOUND()
						RECLOCK("RGB",.T.)
						RGB_FILIAL	:= XFILIAL("RGB")
						RGB_PERIOD 	:= _ANOMES
						RGB_SEMANA	:= "01"
						RGB_ROTEIR	:= "FOL"
						RGB_PROCES	:= TRB->TRB_PRC
						RGB_MAT   	:= TRB->TRB_MAT
						RGB_PD    	:= '216'
						RGB_TIPO1 	:= "V"
						RGB_TIPO2 	:= "I"
						RGB_DTREF	:= LASTDAY(DDATABASE)
					ELSE
						RECLOCK("RGB",.F.)
					ENDIF
					RGB_CC   		:= TRB->TRB_CC
					RGB_VALOR		:= (TRB->TRB_LIQ + TRB->TRB_IR2)  // TRB->TRB_PRT
					RGB->(MSUNLOCK())

					IF TRB->TRB_IR2 > 0
						DBSELECTAREA("RGB")
						dbSetOrder(1)
						_ANOMES:=strzero(Year(ddatabase),4)+strzero(month(ddatabase),2)
						DBSEEK(xFilial("RGB")+TRB->TRB_MAT+"500"+_ANOMES)      // ENTRA NA FORMA DE BASE NA FOLHA DO MES
						IF !FOUND()
							RECLOCK("RGB",.T.)
							RGB_FILIAL	:= XFILIAL("RGB")
							RGB_PERIOD 	:= _ANOMES
							RGB_SEMANA	:= "01"
							RGB_ROTEIR	:= "FOL"
							RGB_PROCES	:= TRB->TRB_PRC
							RGB_MAT   	:= TRB->TRB_MAT
							RGB_PD    	:= '500'
							RGB_TIPO1 	:= "V"
							RGB_TIPO2 	:= "I"
							RGB_DTREF	:= LASTDAY(DDATABASE)
						ELSE
							RECLOCK("RGB",.F.)
						ENDIF
						RGB_CC   		:= TRB->TRB_CC
						RGB_VALOR		:= TRB->TRB_IR2
						RGB->(MSUNLOCK())
					ENDIF

					DBSELECTAREA("SRC")
					dbSetOrder(1)
					DBSELECTAREA("RGB")
					dbSetOrder(1)
					_ANOMES:=strzero(Year(ddatabase),4)+strzero(month(ddatabase),2)
					DBSEEK(xFilial("RGB")+TRB->TRB_MAT+"501"+_ANOMES)      // ENTRA NA FORMA DE BASE NA FOLHA DO MES
					IF !FOUND()
						RECLOCK("RGB",.T.)
						RGB_FILIAL	:= XFILIAL("RGB")
						RGB_PERIOD 	:= _ANOMES
						RGB_SEMANA	:= "01"
						RGB_ROTEIR	:= "FOL"
						RGB_PROCES	:= TRB->TRB_PRC
						RGB_MAT   	:= TRB->TRB_MAT
						RGB_PD    	:= '501'
						RGB_TIPO1 	:= "V"
						RGB_TIPO2 	:= "I"
						RGB_DTREF	:= LASTDAY(DDATABASE)
					ELSE
						RECLOCK("RGB",.F.)
					ENDIF
					RGB_CC   		:= TRB->TRB_CC
					RGB_VALOR		:= TRB->TRB_LIQ
					RGB->(MSUNLOCK())

					DBSELECTAREA("SRC")   // GERA NO SRC PARA POSTERIOR GERACAO DE CNAB
					DBSEEK(xFilial("SRC")+SRA->RA_MAT+"501")
					IF !FOUND()
						RECLOCK("SRC",.T.)
						RC_FILIAL:=XFILIAL("SRC")
						RC_MAT   :=TRB->TRB_MAT
						RC_PD    :="501"
						RC_DATA  :=LASTDAY(DDATABASE)
						RC_TIPO1 :="V"
						RC_TIPO2 :="I"
						RC_CC    :=TRB->TRB_CC
						RC_VALOR :=TRB->TRB_LIQ
						RC_SEMANA    :="01"
						RC_PERIODO	:= _ANOMES
						RC_ROTEIR	:= "FOL"
						RC_PROCES	:= TRB->TRB_PRC
						MSUNLOCK()
					ELSE
						RECLOCK("SRC",.F.)
						RC_CC    :=TRB->TRB_CC
						RC_VALOR :=TRB->TRB_LIQ
						MSUNLOCK()
					ENDIF

				ENDIF

				DBSELECTAREA("TRB")
			ENDIF

			IF _OPC=5    // GERA LANCAMENTOS NOS VALORES EXTRAS PARA GERAÇÃO DE INTEGRAÇÃO COM FINANCEIRO-DEMITIDOS
				IF TRB->TRB_LIQ > 0 .AND. TRB->TRB_SIT="D"
					_SEMAN:=SPACE(2)
					DBSELECTAREA("SR1")
					DBSETORDER(1)
					DBSEEK(xFilial("SR1")+TRB->TRB_MAT+_SEMAN+"501")
					IF !FOUND()
						RECLOCK("SR1",.T.)
						R1_FILIAL:=XFILIAL("SR1")
						R1_MAT   :=TRB->TRB_MAT
						R1_PD    :="501"
						R1_TIPO1 :="V"
						R1_TIPO2 :="I"
					ELSE
						RECLOCK("SR1",.F.)
					ENDIF
					R1_CC   :=TRB->TRB_CC
					R1_VALOR:=TRB->TRB_LIQ
					R1_DATA :=DDATABASE
					SR1->(MSUNLOCK())
				ENDIF
				DBSELECTAREA("TRB")
			ENDIF


			IF !EMPTY(_Afast)
				@ nLin,007 PSAY "*Hist Afast : "+_Afast
				nLin++
			ENDIF
			TREG++
			_TTSAL:=_TTSAL + TRB->TRB_PRT
			_A:=_A + TRB->TRB_ADT
			_B:=_B + TRB->TRB_IR2
			_C:=_C + TRB->TRB_DFA

			TRB->(dbSkip())

			If nLin>42
				nLin:= Cabec(CTitulo,Cabec1,Cabec2,NomeProg,Tamanho,cTipo) +1
			Endif
		EndDO

		@ nLin,000 psay repl("==",66)
		nLin := nLin + 1
		@ nLin,000 Psay Alltrim(Str(TREG))+" Funcionarios..."
		@ nLin,039 Psay _TTSAL  PICTURE "@E 9,999,999.99"
		@ nLin,052 Psay _A      PICTURE "@E 9,999,999.99"
		@ nLin,065 Psay _B      PICTURE "@E 999,999.99"
		@ nLin,076 Psay _C      PICTURE "@E 999,999.99"
		nLin := nLin + 1
		@ nLin,000 psay repl("==",66)
		nLin := nLin + 2
		@ nLin,052 Psay "* Liquido a pagar ...:"
		@ nLin,076 Psay _TTSAL - _A-_B-_C   PICTURE "@E 999,999,999.99"
		@ nLin,092 PSAY "Fator ....:"
		@ nLin,105 PSAY _FATOR PICTURE "@E 9.99"
		@ nLin,110 PSAY "%"

	ELSEIF _OPC=2      //  RELACAO DE LIQUIDOS

		TREG:=0
		_A  :=0
		_AA :=0
		DBSELECTAREA("TRB")
		dbGoTop()
		SetRegua(LastRec()) //Ajusta numero de elementos da regua de relatorios

		_KEY:=TRB_BAN
		While !Eof()
			IncRegua() //Incrementa a posicao da regua de relatorios
			IF TRB->TRB_SIT="D"
				TRB->(DBSKIP())
				Loop
			ENDIF
			If nLin>42
				nLin:= Cabec(CTitulo,Cabec1,Cabec2,NomeProg,Tamanho,cTipo)
			Endif
			IF (EOF() .OR. TRB_BAN#_KEY) .AND. _AA#0
				nLin++
				@ nLin,000 PSAY "Total do Banco/Agencia : "+LEFT(_Key,3)+" / "+SUBSTR(_Key,4,5)
				@ nLin,076 Psay _AA  PICTURE "@E 999,999,999.99"
				_AA:=0
				nLin++
				@ nLin,000 PSAY __PrtThinLine()
				nLin++
			ENDIF

			@ nLin,000 Psay LEFT(TRB->TRB_BAN,3)
			@ nLin,004 PSay SUBSTR(TRB->TRB_BAN,4,5)
			@ nLin,010 PSay LEFT(TRB_CTA,11)+"-"+SUBSTR(TRB_CTA,12,1)
			@ nLin,025 PSay TRB_MAT
			@ nLin,032 PSay LEFT(TRB_NOM,43)
			@ nLin,076 Psay TRB->TRB_PRT-TRB->TRB_ADT-TRB->TRB_IR2-TRB->TRB_DFA   PICTURE "@E 999,999,999.99"
			@ nLIN,092 PSAY TRB_CC

			nLin++
			TREG++
			_AA:=_AA + (TRB->TRB_PRT-TRB->TRB_ADT-TRB->TRB_IR2-TRB->TRB_DFA)
			_A:=_A   + (TRB->TRB_PRT-TRB->TRB_ADT-TRB->TRB_IR2-TRB->TRB_DFA)

			_KEY:=TRB_BAN
			DBSELECTAREA("TRB")
			TRB->(dbSkip())
		EndDO
		IF  _AA#0
			nLin++
			@ nLin,000 PSAY "Total do Banco/Agencia : "+LEFT(_Key,3)+" / "+SUBSTR(_Key,4,5)
			@ nLin,076 Psay _AA  PICTURE "@E 999,999,999.99"
			_AA:=0
			nLin++
			@ nLin,000 PSAY __PrtThinLine()
			nLin++
		ENDIF

		@ nLin,000 psay repl("==",66)
		nLin := nLin + 1
		@ nLin,000 Psay Alltrim(Str(TREG))+" Funcionarios..."
		@ nLin,076 Psay _A  PICTURE "@E 999,999,999.99"
		nLin := nLin + 1
		@ nLin,000 psay repl("==",66)

	ELSE

		TREG:=0
		_A  :=0
		_B  :=0
		_AA :=0
		_BB :=0
		_C  :=0
		_CC :=0
		_D  :=0
		_DD :=0
		DBSELECTAREA("TRB")
		dbGoTop()
		SetRegua(LastRec()) //Ajusta numero de elementos da regua de relatorios

		While !Eof()
			IncRegua() //Incrementa a posicao da regua de relatorios
			TREG++
			_AA:=_AA + TRB->TRB_PRT
			_A:=_A   + TRB->TRB_PRT
			_BB:=_BB + TRB->TRB_ADT
			_B:=_B   + TRB->TRB_ADT
			_CC:=_CC + TRB->TRB_IR2
			_C:=_C   + TRB->TRB_IR2
			_DD:=_DD + TRB->TRB_DFA
			_D:=_D   + TRB->TRB_DFA

			If nLin>42
				nLin:= Cabec(CTitulo,Cabec1,Cabec2,NomeProg,Tamanho,cTipo)
			Endif
			_KEY:=TRB_CC

			TRB->(dbSkip())

			IF EOF() .OR. TRB_CC#_KEY
				nLin++
				_DESCCC:=ALLTRIM(Posicione("CTT",1,xFilial("CTT")+_Key,"CTT_DESC01"))

				@ nLin,000 PSAY _KEY+_DESCCC
				@ nLin,050 Psay _AA      PICTURE "@E 999,999,999.99"
				@ nLin,065 Psay _BB      PICTURE "@E 999,999.99"
				@ nLin,076 Psay _CC      PICTURE "@E 999,999.99"
				@ nLin,088 Psay _DD      PICTURE "@E 999,999.99"
				@ nLin,100 Psay _AA-_BB-_CC-_DD      PICTURE "@E 999,999.99"

				_AA:=_BB:=0
				_CC:=_DD:=0
				nLin++
				@ nLin,000 PSAY __PrtThinLine()
				nLin++
			ENDIF
		EndDO

		@ nLin,000 psay repl("==",66)
		nLin := nLin + 1
		@ nLin,000 Psay Alltrim(Str(TREG))+" Funcionarios..."
		@ nLin,050 Psay _A      PICTURE "@E 999,999,999.99"
		@ nLin,065 Psay _B      PICTURE "@E 999,999.99"
		@ nLin,076 Psay _C      PICTURE "@E 999,999.99"
		@ nLin,088 Psay _D      PICTURE "@E 999,999.99"
		@ nLin,100 Psay _A-_B-_C-_D      PICTURE "@E 999,999.99"
		nLin := nLin + 1
		@ nLin,000 psay repl("==",66)

	ENDIF

	dbClearFilter()

	If aReturn[5] == 1
		Set Printer To
		Commit
		ourspool(wnrel) //Chamada do Spool de Impressao
	Endif
	MS_FLUSH() //Libera fila de relatorios em spool

	_GeraXls:=1
	@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Gera Planilha Excel ?"
	@ 10, 49 SAY "1 - Nao"
	@ 22, 49 SAY "2 - Sim"
	@ 44, 49 GET _GeraXls PICTURE "99"
	@ 60, 90 BmpButton Type 1 Action Close(oDlg2)
	Activate Dialog oDlg2 Centered
	IF _GeraXls=2
		DbSelectArea("TRB")
		DBGOTOP()

		cPath := "C:\RELATO\"
		//cPath := Alltrim(mv_par01)
		cPath := If(Right(cPath,1) == "\",cPath,cPath+"\")

		cEol:=chr(13)+chr(10)

		cArq := "PR.CSV"
		nArqTxt := MsFCreate(UPPER(cPath+Alltrim(cArq)))

		If nArqTxt == -1
			MsgStop("Erro na criação do arquivo "+UPPER(cPath+Alltrim(cArq))+" : " + Alltrim(Str(fError())))
			Return
		EndIF

		For i:=1 to len(aGeraXLS)
			cLinTXT := ""
			cLinTXT := aGeraXLS[i] + cEol
			fWrite(nArqTxt,cLinTXT)
		Next
		FClose(nArqTxt)

		//COPY TO ESCOLA.CSV VIA "DBFCDXADS"
		//Copiando Arquivo criado .DBF para o diretorio específico no Cliente
		//IF CPYS2T("\SYSTEM\ESCOLA.CSV","C:\Relato\",.F.)
		MSGINFO("Arquivo gerado com sucesso! C:\Relato\" + cArq,"")
		//ELSE
		//ALERT("ERRO NA COPIA")
		//ENDIF

		//AQUIX

		//	   COPY TO ATESTADOS.CSV
		/*
		_cArqRen:="\SYSTEM\TEMPDBF\PR.CSV"
		Copy to &_cArqRen VIA "CTREECDX" 
		//Copiando Arquivo criado .DBF para o diretorio específico no Cliente 
		IF CPYS2T("\SYSTEM\TEMPDBF\PR.CSV","C:\Relato\",.F.)
		MSGINFO("Arquivo gerado com sucesso! C:\Relato\PR.CSV")
		ELSE
		ALERT("ERRO NA COPIA")
		ENDIF   
		*/

	ENDIF

	DbSelectArea("TRB")
	DbCloseArea()
	//Ferase(cArqTEMP)

	dbSelectArea("ZZ0")
	DBGOTOP()

Return


//*********************************************************************************
User Function CadSQ3()
	//*********************************************************************************

	_cArea := Alias()
	_nOrd  := IndexOrd()
	nReg   :=RecNo()


	DbSelectArea("SQ3")
	DbGotop()

	cCadastro:="SQ3 - CARGOS"
	aRotina := { { "Pesquisa ",  'AxPesqui'            , 0, 1 },;
		{ "Conhecim. " ,"MsDocument"          , 0, 6}}

	mBrowse(16,00,280,350,"SQ3")

	DbSelectArea("SQ3")
	SET FILTER TO

	dbSelectArea(_cArea)
	DbSetOrder(_nOrd)
	DbGoTo(nReg)

return(nil)


Static Function BuscaSal(dData)
	Local nSal:=0
	cQuery := ""

	If SELECT('TMPSRC') > 0
		TMPSRC->(DbCloseArea())
	Endif
	cQuery := cQuery + " select TOP 1 * from " + RetSqlName("SR3")
	cQuery := cQuery + " WHERE D_E_L_E_T_ <>'*' AND R3_DATA <= '" + dtos(dData) + "'"
	cQuery := cQuery + " AND R3_MAT = '" + sra->ra_mat + "'"
	cQuery := cQuery + " order BY R3_DATA DESC"

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),'TMPSRC', .F., .T.)
	dbSelectArea('TMPSRC')
	dbGotop()
	If eof()
		nSal := sra->ra_salario
	Else
		nSal := R3_VALOR
	Endif

	TMPSRC->(DbCloseArea())

Return(nSal)
