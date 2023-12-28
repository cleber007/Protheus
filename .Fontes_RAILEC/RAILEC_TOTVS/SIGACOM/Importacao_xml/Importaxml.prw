#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"
#Include "AP5MAIL.CH"

// Antonio Carlos 15/12/2017 - SIGACORP
// Incluir a classe de valor que consta no Pedido de Compra
// Modificação para atender o processo de Investimento

Static __cCRLF := CRLF

// teste de alteracao-TSF Ewerton

User Function importNFE()
	Local aCores := U_nfeCor()  
	Local _lRotEntrg:=.f. //20/03/17 - Fabio Yoshioka
	Private cCaminho
	Private cProcess
	Private cErro
	Private cStatNFE
	Private cArquivo
	//	Private nCPC
	//	Private cCPC
	Private cCadastro	:= "Importacao de XML de Entrada"
	Private aRotina 	:=	{	{"Pesquisar"	,"AXPESQUI",0,1}	,;
	{"Visualizar"	,"U_manXML",0,2}	}
	//{"Incluir"		,"U_manXML",0,3}	,;
	//{"Legenda"		,"U_nfeLEGx",0,6}	}   

	Private _cCodusr := Posicione("XA5",1,xFilial("XA5") + __cUSERID,"XA5_USU")
	Private _cRecAlm := Posicione("XA5",1,xFilial("XA5") + __cUSERID,"XA5_RECALM")
	Private _cPC 	  := Posicione("XA5",1,xFilial("XA5") + __cUSERID,"XA5_PC")  
	Private _cDept	  := Posicione("XA5",1,xFilial("XA5") + __cUSERID,"XA5_COD")	
	Private _cXA2_NF := iif(ALLTRIM(UPPER(FunName())) == 'ENTREGALM',XA2->XA2_NFISCA,"") //20/03/17 - FABIO YOSHIOKA   
	Private _cXA2_SER:= iif(ALLTRIM(UPPER(FunName())) == 'ENTREGALM',XA2->XA2_SERIE,"") //20/03/17 - FABIO YOSHIOKA   	
	Private _cXA2_FOR:= iif(ALLTRIM(UPPER(FunName())) == 'ENTREGALM',XA2->XA2_CLIFOR,"") //20/03/17 - FABIO YOSHIOKA   		
	Private _cXA2_LOJ:= iif(ALLTRIM(UPPER(FunName())) == 'ENTREGALM',XA2->XA2_LOJA,"") //20/03/17 - FABIO YOSHIOKA   			

	Public _axItXML:={} //RAFAEL ALMEIDA - SIGACORP (30/11/2016)  

	if alltrim(funname())='ENTREGALM' //20/03/17 - Fabio Yoshioka
		_lRotEntrg:=.T.			    
	endif


	//	If Alltrim(_cCodusr) <> "" .AND. ( Alltrim(_cDept) == "000001" .OR. Alltrim(_cDept) == "000002")
	If Alltrim(_cCodusr) <> "" .AND. ( Alltrim(_cDept) == "000001" .OR. Alltrim(_cDept) == "000002") .AND. !_lRotEntrg //20/03/17 - Fabio Yoshioka 	
		Aadd(aRotina, {"Incluir"		,"U_manXML",0,3})
		Aadd(aRotina, {"Legenda"		,"U_nfeLEGx",0,6})  
		Aadd(aRotina, {"Manut OD" ,"U_manutOD",0,5}) // - 23/02/17 - Fabio Yoshioka  
		Aadd(aRotina, {"Conhecimento" ,"MSDOCUMENT",0,4}) //conhecimento - 17/03/17 - Fabio Yoshioka 												
		//		Aadd(aRotina, {"Entrega Almx" ,"U_EntregALM",0,5}) // - 08/03/17 - Fabio Yoshioka 			

		//Aadd(aRotina, {"Conhecimento" ,"MSDOCUMENT",0,7}) //conhecimento - 23/02/17 - Fabio Yoshioka 			
	Else
		Aadd(aRotina, {"Legenda"		,"U_nfeLEGx",0,6})	

		if _lRotEntrg		//23/03/17
			Aadd(aRotina, {"Manut OD" ,"U_manutOD",0,5}) // - 23/02/17 - Fabio Yoshioka  
			Aadd(aRotina, {"Conhecimento" ,"MSDOCUMENT",0,4}) //conhecimento - 17/03/17 - Fabio Yoshioka 												
		endif

	Endif

	If Alltrim(_cCodusr) <> "" .AND. ( Alltrim(_cDept) == "000001" .OR. Alltrim(_cDept) == "000002") //RAFAEL ALMEIDA  - SIGACORP (19/10/2015)
		SetKey(VK_F12,{|| U_altPAR()})
	Endif	

	If ALLTRIM(UPPER(FunName())) == 'ENTREGALM' //20/03/17    - FABIO YOSHIOKA 
		_aIndXA1:={}
		_condXA1    := "XA1->XA1_NFISCA ='"+_cXA2_NF+"' .AND.  XA1->XA1_SERIE ='"+_cXA2_SER+"' .AND. XA1->XA1_CLIFOR ='"+_cXA2_FOR+"' .AND. XA1->XA1_LOJA ='"+_cXA2_LOJ+"'"  

		bFiltraBrw := {|| FilBrowse("XA1",@_aIndXA1,@_condXA1) }
		Eval(bFiltraBrw)

		mBrowse( 6,1,22,75,"XA1",,,,,,aCores)
		aEval(_aIndXA1,{|x| Ferase(x[1]+OrdBagExt())})
		ENDFILBRW('XA1',_aIndXA1)
	ELSE               

		Pergunte("IMPORTNFE",.F.)
		U_ajuPAR()
		dbSelectArea("XA1")
		dbSetOrder(1)
		mBrowse(006,001,022,075,"XA1",,,,,,aCores,,,,,,,,,,,,)
	ENDIF              

Return(nil)

User Function nfeCOR()
	Local aCores	:=	{	{"Alltrim(XA1_ORIGEM)=='IMPXML'"	,"BR_VERDE"		}	,; 
							{"Alltrim(XA1_ORIGEM)=='PRENOT'"	,"BR_AMARELO"	}	} 
Return(aCores)

User Function nfeLEGx(aCores)
	Local aLegenda := {}

	aAdd(aLegenda	,{"BR_VERDE"	 	,"Nota Fiscal de Entrada-Com XML"	})
	aAdd(aLegenda	,{"BR_AMARELO"	    ,"Nota Fiscal de Entrada-Sem XML"	})

	BrwLegenda(cCadastro,"Legenda",aLegenda)
Return(nil)

User function altPAR()
	If Pergunte("IMPORTNFE",.T.)
		U_ajuPAR()
	Endif
Return(nil)

User function ajuPAR()
	cCaminho 	:= MV_PAR01
	cProcess	:= MV_PAR02
	cErro		:= MV_PAR03
	cStatNFE	:= MV_PAR04
	//	nCPC 		:= MV_PAR05

	//	If nCPC == 1
	//		cCPC = "1"
	//	Else
	//		cCPC = "2"
	//	Endif
Return()

User Function visNFEx()
	Local cArea		:= GetArea()
	Local _cNota  	:= XA1->XA1_NFISCA
	Local _cSerie 	:= XA1->XA1_SERIE
	Local _cFornec	:= XA1->XA1_CLIFOR
	Local _cLoja  	:= XA1->XA1_LOJA

	dbSelectArea("SF1")
	SF1->(dbSetOrder(1))

	If SF1->(dbSeek(xFilial("SF1") + _cNota + _cSerie + _cFornec + _cLoja))
		dbSelectArea("SD1")
		SD1->(dbSetOrder(1))

		If SD1->(dbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
			dbSelectArea("SF1")
			MATA103(,,2)
		Endif
	Endif 

	RestArea(cArea)
Return(nil)

User Function manXML(cAlias,nReg,nOpc)
	Local oDlg
	Local nOpca 		:= 0
	Local aButtons		:= {}
	Local aHeaderEx 	:= {}
	Local aSize    	:= {}
	Local aObjects 	:= {}
	Local aInfo    	:= {}
	Local aPosGet		:= {}
	Local aPosObj  	:= {}
	Local cSuperDel	:= ""
	Local cLinhaOk		:= "AllwaysTrue"
	Local cTudoOk		:= "AllwaysTrue"
	Local cFieldOk		:= "AllwaysTrue"
	Local cDelOk		:= "AllwaysTrue"             
	Local nLinha		:= 1 
	Local nR				:= 0	   
	Local nY				:= 0 //RAFAEL ALMEIDA - SIGACORP (17/03/2017) 
	Local _nCountE		:= 0
	Local _nCountD		:= 0		

	Private cNomArq
	Private oGetEnd
	Private oGetEst
	Private oGetTel
	Private oGetCGC
	Private oGetInsc
	Private oGetChv 	
	Private oGetPrt
	Private oGetVer
	Private oGetDte
	Private oGetHre
	Private oGetDti
	Private oGetHri
	Private oGetSta
	Private oGetMot
	Private oNfe
	Private oFolder
	Private oGetNom 
	Private oNF
	Private oEmitente
	Private oIdent
	Private oDestino
	Private oTotal
	Private oTransp
	Private oDet
	Private oICM		
	Private oFatura
	Private oBrwXML
	Private oBrwPN
	Private oBrwNF
	Private oBrwSEF                                        
	Private cNF
	Private cChvNfe
	Private cInfNfe // verifica o Tipo da NFE é Devolução RAFAEL ALMEIDA - SIGACORP (22/12/2016) - Devolução XML
	Private dData
	Private cGetHre
	Private cGetHri
	Private cProtoc
	Private cVersao
	Private cMotivo		
	Private cCgc
	Private cSer
	Private cData
	Private cStatus
	Private cNumPedido
	Private cSeqItem
	Private cProdAlub
	Private cNomeAlub
	Private cItemNF
	Private cNomProd
	Private nFretePrd
	Private cCFOXML
	Private cClasFis
	Private nGTQTXML		:= 0.00
	Private nGTVUXML 		:= 0.00
	Private nGTVTXML 		:= 0.00
	Private nGTQTPC		:= 0.00
	Private nGTVUPC		:= 0.00
	Private nGTVTPC		:= 0.00
	Private nFrete			:= 0.00
	Private nDesct			:= 0.00
	Private nTotNF			:= 0.00
	Private nQtdXML		:= 0.00
	Private nVlUnit		:= 0.00
	Private nVlTotal		:= 0.00
	Private nValDesc		:= 0.00
	Private nProdTot		:= 0.00
	Private nIPI 			:= 0.00
	Private cGetNom 		:= Space(060)
	Private cGetEnd 		:= Space(065)
	Private cGetEst 		:= Space(002)
	Private cGetTel 		:= Space(025)
	Private cGetCGC 		:= Space(014)
	Private cGetInsc 		:= Space(018)
	Private cGetChv 		:= Space(044)
	Private cGetPrt 		:= Space(030)
	Private cGetVer 		:= Space(005)
	Private cGetSta 		:= Space(003)
	Private cGetMot 		:= Space(100)
	Private dGetDte 		:= CtoD("  /  /  ")
	Private dGetDti		:= CtoD("  /  /  ")
	Private aPN				:= {}
	Private aNF				:= {}
	Private aRegSEF 		:= {}
	Private aColsEx 		:= {}
	Private aFieldFill	:= {}
	Private aLinha	  		:= {}
	Private aCabec	  		:= {}
	Private aItens	  		:= {}
	Private aXML			:= {}
	Private lMsErroAuto 	:= .F.
	Private lMsHelpAuto 	:= .F.
	Private aFieldEnc 	:= {"NOUSER","XA1_NFISCA","XA1_SERIE","XA1_CLIFOR","XA1_LOJA","XA1_NOMFOR","XA1_UFORI","XA1_TIPO","XA1_DATEMI","XA1_DTRECE","XA1_RECALM","XA1_PC"}
	Private aFields 		:= {"XA2_ITEM","XA2_PROXML","XA2_NOMXML","XA2_QTDXML","XA2_VLUXML","XA2_FRTXML","XA2_VLDXML","XA2_VLTXML","XA2_CFOXML","XA2_CSTXML","XA2_PEDIDO","XA2_ITEPN","XA2_PROPN","XA2_NOMPN","XA2_QTDPN","XA2_UMPN","XA2_VLUPN","XA2_VLDPN","XA2_VLTPN","XA2_VLFPN","XA2_CFOPN","XA2_CSTPN","XA2_LOCPN","XA2_CCPN","XA2_CTPN","XA2_APLIC","XA2_ENTREG","XA2_LOC"}
	Private aAlterFields	:= {"XA2_QTDPN","XA2_VLUPN","XA2_VLDPN","XA2_VLFPN","XA2_CFOPN","XA2_CSTPN","XA2_APLIC","XA2_LOCPN","XA2_CCPN","XA2_CTPN","XA2_ENTREG","XA2_LOC"}  
	Private aTitles   	:= {OemToAnsi("Totais"),"SEFAZ","Fornecedor/Cliente","Nota Fiscal Eletronica"}
	Private _cXA3			:= Space(6)
	Private _lOD			:= .F.
	Private _dDtXa3         := CtoD("  /  /  ")

	SetKey(VK_F12	,{|| })

	If nOpc == 3
		SetKey(VK_F4,{|| U_abrNFE()	})
		aAdd(aButtons,{"NOTE",{|| U_abrNFE()}	,"<F4> Abre XML"	})

		//		If cCPC == "1"
		SetKey(VK_F5,{|| U_pcXML()	})
		SetKey(VK_F6,{|| U_itXML()	})
		aAdd(aButtons,{"NOTE",{|| U_pcXML()}	,"<F5> Pedido"		})
		aAdd(aButtons,{"NOTE",{|| U_itXML()}	,"<F6> Item.Ped"	})
		//		Endif
	Else
		aAdd(aButtons,{"NOTE",{|| U_visNFEx()}	,"Visualizar NF"	})
		aAdd(aButtons,{"NOTE",{|| U_manWFL()}	,"Workflow Entrega"	})
	Endif

	//Dimensoes da tela
	aSize 		:= MsAdvSize(,.F.,400)
	aObjects	:= {}

	aadd(aObjects,{000,057,.T.,.F.})	//Dados da Enchoice
	aadd(aObjects,{100,100,.T.,.T.})	//Dados da getDados
	aadd(aObjects,{000,075,.T.,.F.})	//Dados do Folder

	aInfo 	:= {aSize[01],aSize[02],aSize[03],aSize[04],03,03}
	aPosObj	:= msObjSize(aInfo,aObjects)
	aPosGet	:= MsObjGetPos(aSize[3]-aSize[1],310,{{8,35,78,128,163,200,250,270},{8,35,75,108,150,174,227,260,286},{5,70,160,205,295},{6,34,200,215},{6,34,75,103,148,164,230,253},{6,34,200,218,280},{11,50,150,190},{273,130,190,293,205}})

	//Carga dos dados
	dbSelectArea("XA1") 
	XA1->(dbSetOrder(1))

	//dbSelectArea("SX3")
	//(cAliasTmp)->(dbSetOrder(2))
	cAliasTmp := "IASX3"
	OpenSXs(NIL, NIL, NIL, NIL, cEmpAnt, cAliasTmp, "SX3", NIL, .F.)
	//cFiltro   := "X3_ARQUIVO == 'ZSF'"
	//(cAliasTmp)->(DbSetFilter({|| &(cFiltro)}, cFiltro))
	(cAliasTmp)->(DbGoTop())
	(cAliasTmp)->(DbSetOrder(02))

	For nX := 1 to Len(aFields)
		If (cAliasTmp)->(dbSeek(aFields[nX]))
			aAdd(aHeaderEx,{AllTrim((cAliasTmp)->(X3_TITULO)),(cAliasTmp)->(X3_CAMPO),(cAliasTmp)->(X3_PICTURE),(cAliasTmp)->(X3_TAMANHO),(cAliasTmp)->(X3_DECIMAL),(cAliasTmp)->(X3_VALID),(cAliasTmp)->(X3_USADO),(cAliasTmp)->(X3_TIPO),(cAliasTmp)->(X3_F3),(cAliasTmp)->(X3_CONTEXT),(cAliasTmp)->(X3_CBOX),(cAliasTmp)->(X3_RELACAO)})
		Endif
	Next nX

	For nX := 1 to Len(aFields)
		If (cAliasTmp)->(DbSeek(aFields[nX]))
			aAdd(aFieldFill,CriaVar((cAliasTmp)->(X3_CAMPO)))
		Endif
	Next nX

	aAdd(aFieldFill,.F.)

	If nOpc == 3                         
		RegToMemory("XA1",.T.)
		M->XA1_RECALM 	:= _cRecAlm
		M->XA1_PC		:= _cPC
	Else
		RegToMemory("XA1",.F.)
	Endif                                                                                                          

	//Definicao dos arrays de totais e sefaz
	aAdd(aXML,{"Qtd XML"					,nGTQTXML})
	aAdd(aXML,{"Vlr Unit XML"			,nGTVUXML})
	aAdd(aXML,{"Vlr Total Prod XML"	,nGTVTXMl})

	aAdd(aPN,{"Qtd Pre-nota"				,nGTQTPC})
	aAdd(aPN,{"Vlr Unit Pre-nota"			,nGTVUPC})
	aAdd(aPN,{"Vlr Total Prod Pre-nota"	,nGTVTPC})

	aAdd(aNF,{"Vlr Frete"		,nFrete})
	aAdd(aNF,{"Vlr Desconto"	,nDesct})
	aAdd(aNF,{"Vlr Total NF"	,nTotNF})  

	aAdd(aRegSEF,{"",""})  

	oDlg := MSDIALOG():New(000,000,400,600,"Importacao de XML de Entrada",,,,,,,,,.T.)  
	EnChoice(cAlias,nReg,nOpc,,,,aFieldEnc,aPosObj[01],aFieldEnc,3,,,,,,,,,,,,,,,)

	oMSNewGe1 := MsNewGetDados():New(aPosObj[02,01],aPosObj[02,02],aPosObj[02,03],aPosObj[02,04],iif(nOpc == 3 .Or. nOpc == 4 .Or. nOpc == 5,GD_INSERT+GD_DELETE+GD_UPDATE,0),cLinhaOk,cTudoOk,"+ZK_SEQ",aAlterFields,,999999,cFieldOk,cSuperDel,cDelOk,oDlg,aHeaderEx,aColsEx,,)

	oFolder := TFolder():New(aPosObj[3,1],aPosObj[3,2],aTitles,{"HEADER"},oDlg,,,,.T.,.F.,aPosObj[3,4]-aPosObj[3,2],aPosObj[3,3]-aPosObj[3,1],)

	oBrwXML := TCBrowse():New(006,aPosGet[3,1],140,051,,{"XML","Valores"},,oFolder:aDialogs[1],,,,,{|| },{|| },,,,,,.F.,,.T.,,.F.,,,)
	oBrwXML:AddColumn(TCColumn():New("XML"		,{|| aXML[oBrwXML:nAt,01]},						,,,"LEFT"	,070,.F.,.F.,,,,,))									
	oBrwXML:AddColumn(TCColumn():New("Valores"	,{|| aXML[oBrwXML:nAt,02]},"@E 9999,999,999.9999"	,,,"RIGHT"	,060,.F.,.F.,,,,,))									
	oBrwXML:SetArray(aXML)
	oBrwXML:bLine := {||{aXML[oBrwXML:nAt,01],aXML[oBrwXML:nAt,02]}}  

	oBrwPN := TCBrowse():New(006,aPosGet[3,1] + 150,140,051,,{"Pre-Nota","Valores"},,oFolder:aDialogs[1],,,,,{|| },{|| },,,,,,.F.,,.T.,,.F.,,,)
	oBrwPN:AddColumn(TCColumn():New("Pre-Nota"	,{|| aPN[oBrwPN:nAt,01]},							,,,"LEFT"	,070,.F.,.F.,,,,,))									
	oBrwPN:AddColumn(TCColumn():New("Valores"	,{|| aPN[oBrwPN:nAt,02]},"@E 9999,999,999.9999"	,,,"RIGHT"	,060,.F.,.F.,,,,,))									
	oBrwPN:SetArray(aPN)
	oBrwPN:bLine := {||{aPN[oBrwPN:nAt,01],aPN[oBrwPN:nAt,02]}}  

	oBrwNF := TCBrowse():New(006,aPosGet[3,1] + 300,140,051,,{"Nota Fiscal","Valores"},,oFolder:aDialogs[1],,,,,{|| },{|| },,,,,,.F.,,.T.,,.F.,,,)
	oBrwNF:AddColumn(TCColumn():New("Nota Fiscal"	,{|| aNF[oBrwNF:nAt,01]},							,,,"LEFT"	,070,.F.,.F.,,,,,))									
	oBrwNF:AddColumn(TCColumn():New("Valores"		,{|| aNF[oBrwNF:nAt,02]},"@E 9999,999,999.9999"	,,,"RIGHT"	,060,.F.,.F.,,,,,))									
	oBrwNF:SetArray(aNF)
	oBrwNF:bLine := {||{aNF[oBrwNF:nAt,01],aNF[oBrwNF:nAt,02]}}  

	oBrwSEF := TCBrowse():New(006	,aPosGet[3,1],458,051,,{"Processo","Status"},,oFolder:aDialogs[2],,,,,{|| },{|| },,,,,,.F.,,.T.,,.F.,,,)
	oBrwSEF:AddColumn(TCColumn():New("Processo"	,{|| aRegSEF[oBrwSEF:nAt,01]},,,,"LEFT",200,.F.,.F.,,,,,))									
	oBrwSEF:AddColumn(TCColumn():New("Status"	,{|| aRegSEF[oBrwSEF:nAt,02]},,,,"LEFT",200,.F.,.F.,,,,,))									
	oBrwSEF:SetArray(aRegSEF)
	oBrwSEF:bLine := {||{aRegSEF[oBrwSEF:nAt,01],aRegSEF[oBrwSEF:nAt,02]}}  

	@ 006,aPosGet[03,01] 			SAY RetTitle("A1_NOME")		OF oFolder:aDialogs[3] PIXEL SIZE 055,009
	@ 021,aPosGet[03,01] 			SAY RetTitle("A1_END") 		OF oFolder:aDialogs[3] PIXEL SIZE 049,009
	@ 036,aPosGet[03,01] 			SAY RetTitle("A1_EST") 		OF oFolder:aDialogs[3] PIXEL SIZE 050,009
	@ 006,aPosGet[03,01] + 270 	SAY RetTitle("A1_TEL")  	OF oFolder:aDialogs[3] PIXEL SIZE 055,009
	@ 021,aPosGet[03,01] + 270 	SAY RetTitle("A1_CGC")  	OF oFolder:aDialogs[3] PIXEL SIZE 069,009
	@ 036,aPosGet[03,01] + 270 	SAY RetTitle("A1_INSCR")	OF oFolder:aDialogs[3] PIXEL SIZE 050,009
	@ 006,aPosGet[03,01] 			SAY "Chave NFE"				OF oFolder:aDialogs[4] PIXEL SIZE 055,009
	@ 021,aPosGet[03,01] 			SAY "Protocolo" 				OF oFolder:aDialogs[4] PIXEL SIZE 049,009
	@ 036,aPosGet[03,01] 			SAY "Versao" 					OF oFolder:aDialogs[4] PIXEL SIZE 050,009
	@ 006,aPosGet[03,01] + 210 	SAY "Dt Emissao"				OF oFolder:aDialogs[4] PIXEL SIZE 055,009
	@ 021,aPosGet[03,01] + 210 	SAY "Hr Emissao" 				OF oFolder:aDialogs[4] PIXEL SIZE 049,009
	@ 036,aPosGet[03,01] + 210 	SAY "Dt Import" 				OF oFolder:aDialogs[4] PIXEL SIZE 050,009
	@ 006,aPosGet[03,01] + 320 	SAY "Hr Import"				OF oFolder:aDialogs[4] PIXEL SIZE 055,009
	@ 021,aPosGet[03,01] + 320 	SAY "Status" 					OF oFolder:aDialogs[4] PIXEL SIZE 049,009
	@ 036,aPosGet[03,01] + 320 	SAY "Motivo" 					OF oFolder:aDialogs[4] PIXEL SIZE 050,009

	@ 006,aPosGet[03,01] + 040 MSGET oGetNom 		VAR cGetNom 	SIZE 200,010 OF oFolder:aDialogs[3] WHEN .F. Colors 0,16777215 PIXEL PICTURE "@!"
	@ 021,aPosGet[03,01] + 040 MSGET oGetEnd 		VAR cGetEnd 	SIZE 200,010 OF oFolder:aDialogs[3] WHEN .F. Colors 0,16777215 PIXEL PICTURE "@!"
	@ 036,aPosGet[03,01] + 040 MSGET oGetEst 		VAR cGetEst 	SIZE 010,010 OF oFolder:aDialogs[3] WHEN .F. Colors 0,16777215 PIXEL PICTURE "@!"
	@ 006,aPosGet[03,01] + 320 MSGET oGetTel 		VAR cGetTel		SIZE 080,010 OF oFolder:aDialogs[3] WHEN .F. Colors 0,16777215 PIXEL PICTURE "@!"
	@ 021,aPosGet[03,01] + 320 MSGET oGetCGC 		VAR cGetCGC 	SIZE 080,010 OF oFolder:aDialogs[3] WHEN .F. Colors 0,16777215 PIXEL PICTURE PesqPict("SA2","A2_CGC")
	@ 036,aPosGet[03,01] + 320 MSGET oGetInsc 	VAR cGetInsc 	SIZE 080,010 OF oFolder:aDialogs[3] WHEN .F. Colors 0,16777215 PIXEL PICTURE PesqPict("SA2","A2_INSCR")
	@ 006,aPosGet[03,01] + 040 MSGET oGetChv 		VAR cGetChv		SIZE 160,010 OF oFolder:aDialogs[4] WHEN .F. Colors 0,16777215 PIXEL PICTURE "@!"
	@ 021,aPosGet[03,01] + 040 MSGET oGetPrt 		VAR cGetPrt		SIZE 100,010 OF oFolder:aDialogs[4] WHEN .F. Colors 0,16777215 PIXEL PICTURE "@!"
	@ 036,aPosGet[03,01] + 040 MSGET oGetVer 		VAR cGetVer		SIZE 015,010 OF oFolder:aDialogs[4] WHEN .F. Colors 0,16777215 PIXEL PICTURE "@!"
	@ 006,aPosGet[03,01] + 260 MSGET oGetDte 		VAR dGetDte		SIZE 040,010 OF oFolder:aDialogs[4] WHEN .F. Colors 0,16777215 PIXEL
	@ 021,aPosGet[03,01] + 260 MSGET oGetHre 		VAR cGetHre		SIZE 040,010 OF oFolder:aDialogs[4] WHEN .F. Colors 0,16777215 PIXEL
	@ 036,aPosGet[03,01] + 260 MSGET oGetDti 		VAR dGetDti		SIZE 040,010 OF oFolder:aDialogs[4] WHEN .F. Colors 0,16777215 PIXEL
	@ 006,aPosGet[03,01] + 370 MSGET oGetHri 		VAR cGetHri		SIZE 040,010 OF oFolder:aDialogs[4] WHEN .F. Colors 0,16777215 PIXEL
	@ 021,aPosGet[03,01] + 370 MSGET oGetSta 		VAR cGetSta		SIZE 020,010 OF oFolder:aDialogs[4] WHEN .F. Colors 0,16777215 PIXEL
	@ 036,aPosGet[03,01] + 370 MSGET oGetMot 		VAR cGetMot		SIZE 090,010 OF oFolder:aDialogs[4] WHEN .F. Colors 0,16777215 PIXEL

	If nOpc <> 3
		dbSelectArea("XA2")
		XA2->(dbSetOrder(2))

		If XA2->(dbSeek(xFilial("XA2") + M->XA1_NFISCA + M->XA1_SERIE + M->XA1_CLIFOR + M->XA1_LOJA))
			Do While !XA2->(Eof()) .AND. XA2->XA2_NFISCA == M->XA1_NFISCA .AND. XA2->XA2_SERIE == M->XA1_SERIE .AND. XA2->XA2_CLIFOR == M->XA1_CLIFOR .AND. XA2->XA2_LOJA == M->XA1_LOJA
				If nLinha == 1
					oMSNewGe1:aCols[01,01] := XA2->XA2_ITEM
					oMSNewGe1:aCols[01,02] := XA2->XA2_PROXML
					oMSNewGe1:aCols[01,03] := XA2->XA2_NOMXML
					oMSNewGe1:aCols[01,04] := XA2->XA2_QTDXML
					oMSNewGe1:aCols[01,05] := XA2->XA2_VLUXML
					oMSNewGe1:aCols[01,07] := XA2->XA2_VLDXML
					oMSNewGe1:aCols[01,06] := XA2->XA2_FRTXML
					oMSNewGe1:aCols[01,08] := XA2->XA2_VLTXML
					oMSNewGe1:aCols[01,09] := XA2->XA2_CFOXML
					oMSNewGe1:aCols[01,10] := XA2->XA2_CSTXML
					oMSNewGe1:aCols[01,11] := XA2->XA2_PEDIDO
					oMSNewGe1:aCols[01,12] := XA2->XA2_ITEPN
					oMSNewGe1:aCols[01,13] := XA2->XA2_PROPN
					oMSNewGe1:aCols[01,14] := XA2->XA2_NOMPN
					oMSNewGe1:aCols[01,15] := XA2->XA2_QTDPN
					oMSNewGe1:aCols[01,16] := XA2->XA2_UMPN
					oMSNewGe1:aCols[01,17] := XA2->XA2_VLUPN
					oMSNewGe1:aCols[01,18] := XA2->XA2_VLDPN
					oMSNewGe1:aCols[01,19] := XA2->XA2_VLTPN
					oMSNewGe1:aCols[01,20] := XA2->XA2_VLFPN
					oMSNewGe1:aCols[01,21] := XA2->XA2_CFOPN
					oMSNewGe1:aCols[01,22] := XA2->XA2_CSTPN
					oMSNewGe1:aCols[01,23] := XA2->XA2_LOCPN
					oMSNewGe1:aCols[01,24] := XA2->XA2_CCPN
					oMSNewGe1:aCols[01,25] := XA2->XA2_CTPN
					oMSNewGe1:aCols[01,26] := XA2->XA2_APLIC
					oMSNewGe1:aCols[01,27] := XA2->XA2_ENTREG
					oMSNewGe1:aCols[01,28] := XA2->XA2_LOC
				Else
					aAdd(oMSNewGe1:aCols,{	XA2->XA2_ITEM		,;
					XA2->XA2_PROXML	,;
					XA2->XA2_NOMXML	,;
					XA2->XA2_QTDXML	,;
					XA2->XA2_VLUXML	,;
					XA2->XA2_VLDXML	,;
					XA2->XA2_FRTXML	,;
					XA2->XA2_VLTXML	,;
					XA2->XA2_CFOXML	,;
					XA2->XA2_CSTXML	,;
					XA2->XA2_PEDIDO	,;
					XA2->XA2_ITEPN		,;
					XA2->XA2_PROPN		,;
					XA2->XA2_NOMPN		,;
					XA2->XA2_QTDPN		,;
					XA2->XA2_UMPN		,;
					XA2->XA2_VLUPN		,;
					XA2->XA2_VLDPN		,;
					XA2->XA2_VLTPN		,;
					XA2->XA2_VLFPN		,;
					XA2->XA2_CFOPN		,;
					XA2->XA2_CSTPN		,;
					XA2->XA2_LOCPN		,;
					XA2->XA2_CCPN		,;
					XA2->XA2_CTPN		,;
					XA2->XA2_APLIC		,;
					XA2->XA2_ENTREG	,;
					XA2->XA2_LOC		,;
					.F.})
				Endif

				nLinha++
				nFrete += XA2->XA2_FRTXML
				nDesct += XA2->XA2_VLDXML
				nTotNF += XA2->XA2_VLTXML

				XA2->(dbSkip())
			Enddo      

			u_calcRES()

			cGetNom	:= Posicione("SA2",1,xFilial("SA2") + M->XA1_CLIFOR + M->XA1_LOJA,"A2_NOME")
			cGetEnd	:= Posicione("SA2",1,xFilial("SA2") + M->XA1_CLIFOR + M->XA1_LOJA,"A2_END")
			cGetEst	:= Posicione("SA2",1,xFilial("SA2") + M->XA1_CLIFOR + M->XA1_LOJA,"A2_EST")
			cGetTel	:= Posicione("SA2",1,xFilial("SA2") + M->XA1_CLIFOR + M->XA1_LOJA,"A2_TEL")
			cGetCGC	:= Posicione("SA2",1,xFilial("SA2") + M->XA1_CLIFOR + M->XA1_LOJA,"A2_CGC")
			cGetInsc	:= Posicione("SA2",1,xFilial("SA2") + M->XA1_CLIFOR + M->XA1_LOJA,"A2_INSCR")
			cGetChv	:= M->XA1_CHVNFE
			cGetPrt	:= M->XA1_PROT
			cGetVer	:= M->XA1_VERS
			dGetDte	:= M->XA1_DATEMI
			cGetHre	:= M->XA1_HOREMI
			dGetDti	:= M->XA1_DATIMP
			cGetHri	:= M->XA1_HORIMP
			cGetSta	:= M->XA1_STAT
			cGetMot	:= M->XA1_MOTIVO  
		Endif		
	Endif

	If nOpc <> 3
		aAdd( aButtons, {"NOTE"    , {|| u_ConsPed(oMSNewGe1:acols[oMSNewGe1:nat,11], oMSNewGe1:acols[oMSNewGe1:nat,1], oMSNewGe1:acols[oMSNewGe1:nat,2])}	,"Consultar PC"})
	EndIf

	oDlg:bInit	:= {||EnchoiceBar(oDlg,{||nOpca := 1,If(U_xmlTOK(),oDlg:End(),nOpca := 0)},{||nOpca := 0,oDlg:End()},,aButtons)}
	oDlg:lMaximized := .T.
	oDlg:Activate()    

	If nOpca == 1 .and. nOpc == 3
		//Grava Pre-nota
		aAdd(aCabec,{"F1_TIPO"   	,M->XA1_TIPO	,Nil,Nil})
		aAdd(aCabec,{"F1_FORMUL"	,"N"				,Nil,Nil})
		aAdd(aCabec,{"F1_DOC"    	,M->XA1_NFISCA	,Nil,Nil})
		aAdd(aCabec,{"F1_SERIE"  	,M->XA1_SERIE 	,Nil,Nil})
		aAdd(aCabec,{"F1_EMISSAO"	,M->XA1_DATEMI	,Nil,Nil})
		aAdd(aCabec,{"F1_FORNECE"	,M->XA1_CLIFOR	,Nil,Nil})
		aAdd(aCabec,{"F1_LOJA"   	,M->XA1_LOJA  	,Nil,Nil})
		aAdd(aCabec,{"F1_ESPECIE"	,"SPED"			,Nil,Nil})	
		aAdd(aCabec,{"F1_CHVNFE"	,cGetChv			,Nil,Nil})	
		aAdd(aCabec,{"F1_FRETE"		,nFrete			,Nil,Nil})	

		For nX := 1 To Len(oMSNewGe1:aCols)
			If oMSNewGe1:aCols[nX,11] <> "" .AND. oMSNewGe1:aCols[nX,12] <> "" .AND. oMSNewGe1:aCols[nX,13] <> ""
				aLinha := {}                                                  //(PA56_CTSUP09)
				aAdd(aLinha,{"D1_COD"		,oMSNewGe1:aCols[nX,13]	,Nil,Nil}) // RAFAEL ALMEIDA - SIGACORP (18/08/2016) FOI IDENTIFICADO QUE ESTA GRANVANDO COM INFORMAÇÃO DO PEDIDO E NÃO DO XML
				aAdd(aLinha,{"D1_DESCRI"	,GetAdvFVal("SB1", "B1_DESC",xFilial("SB1")+oMSNewGe1:aCols[nX,13],1)	,Nil,Nil}) // RAFAEL ALMEIDA - SIGACORP (15/03/2017) CONFORME SOLCITAÇÃO DA SRA. LORENA
				aAdd(aLinha,{"D1_UM"	    ,oMSNewGe1:aCols[nX,16]	,Nil,Nil}) // RAFAEL ALMEIDA - SIGACORP (15/03/2017) CONFORME SOLCITAÇÃO DA SRA. LORENA				
				aAdd(aLinha,{"D1_QUANT"		,oMSNewGe1:aCols[nX,15]	,Nil,Nil}) //oMSNewGe1:aCols[nX,15] // oMSNewGe1:aCols[nX,04]
				aAdd(aLinha,{"D1_VUNIT"		,oMSNewGe1:aCols[nX,17]	,Nil,Nil}) //oMSNewGe1:aCols[nX,17] // oMSNewGe1:aCols[nX,05]
				aAdd(aLinha,{"D1_TOTAL"		,oMSNewGe1:aCols[nX,19]	,Nil,Nil}) //oMSNewGe1:aCols[nX,19] // oMSNewGe1:aCols[nX,08]
				aAdd(aLinha,{"D1_VALDESC"	,oMSNewGe1:aCols[nX,18]	,Nil,Nil}) //oMSNewGe1:aCols[nX,18] // oMSNewGe1:aCols[nX,07]
				aAdd(aLinha,{"D1_CLASFIS"	,oMSNewGe1:aCols[nX,22]	,Nil,Nil})
				aAdd(aLinha,{"D1_APLICA"	,oMSNewGe1:aCols[nX,26]	,Nil,Nil})
				aAdd(aLinha,{"D1_VALFRE"	,oMSNewGe1:aCols[nX,20]	,Nil,Nil})
				aAdd(aLinha,{"D1_LOCAL"  	,oMSNewGe1:aCols[nX,23]	,Nil,Nil})

				**********************************************************************************************
				// Antonio Carlos 15/12/2017 - SIGACORP
				// Incluir a classe de valor que consta no Pedido de Compra
				// Modificação para atender o processo de Investimento
				_cPCompra := oMSNewGe1:aCols[nX,11]
				if !Empty(_cPCompra)  //Apenas se houver pedido informado
				    //Busca Classe de Valor
					_cClVl := GetAdvFVal("SC7","C7_CLVL",xFilial("SC7")+_cPCompra,1)
					IF !Empty(_cClVl)  //Caso tenha classe de valor inclui informação no item
						aAdd(aLinha,{"D1_CLVL"  	,_cClVl	,Nil,Nil})
					Endif				
				Endif
				
				**********************************************************************************************

				aAdd(aItens,aLinha)
			Endif
		Next nX

		If Len(aItens) > 0 
			lMsErroAuto := .F.
			lMsHelpAuto := .F.

			MSExecAuto({|x,y,z|Mata140(x,y,z)},aCabec,aItens,3)

			IF lMsErroAuto 
				MostraErro()

				__CopyFile(Alltrim(cCaminho) + Alltrim(cNomArq),Alltrim(cErro) + Alltrim(cNomArq))
				FErase(cArquivo)
			Else

				//descomentado em 06/03/17 - Fabio Yoshioka   - inicio
				dbSelectarea("XA3")
				XA3->(dbSetorder(5))
				XA3->(dbGotop())

				_cXA3	:= Space(6)
				_lOD := .F.

				If XA3->(dbSeek(xFilial("XA3") + M->XA1_NFISCA + M->XA1_SERIE + M->XA1_CLIFOR + M->XA1_LOJA))
					_cXA3	:= XA3->XA3_NUM
					_dDtXa3 := XA3->XA3_EMISSA
					_lOD 	:= .T.    

					RecLock("XA3",.F.)
					//XA3->XA3_CONCLU := dDatabase
					XA3->(MsUnlock())
					XA3->(dbCommitAll())
				Endif    
				//descomentado em 06/03/17 - Fabio Yoshioka   - Fim				

				For nR:= 1 to Len(oMSNewGe1:aCols)
					If oMSNewGe1:aCols[nR,26] == "E"
						_nCountE := _nCountE + 1
					Else
						_nCountD := _nCountD + 1	
					EndIf
				Next nR

				For nY := 1 to Len(oMSNewGe1:aCols)
					If !Empty(oMSNewGe1:aCols[nY,11]) .AND. !Empty(oMSNewGe1:aCols[nY,12]) .AND. !Empty(oMSNewGe1:aCols[nY,13]) //RAFAEL ALMEIDA - SIGACORP (17/03/2017) 
						cUpdate := " "
						cUpdate += "UPDATE " 												   	+ __cCRLF
						cUpdate += "   " + RetSQLName("SD1") + " " 							   	+ __cCRLF
						cUpdate += "SET " 													   	+ __cCRLF

						If M->XA1_PC == "1"
							cUpdate += "   D1_PEDIDO  ='" + oMSNewGe1:aCols[nY,11] + "' " 		+ __cCRLF
							cUpdate += "   ,D1_ITEMPC ='"	+ oMSNewGe1:aCols[nY,12] + "' "    	+ __cCRLF
							cUpdate += "   ,D1_CC     ='"	+ oMSNewGe1:aCols[nY,24] + "' "    	+ __cCRLF
							cUpdate += "   ,D1_CONTA  ='"	+ oMSNewGe1:aCols[nY,25] + "' "    	+ __cCRLF
						Endif

						If M->XA1_PC == "2"
							cUpdate += "   D1_CC     ='"	+ oMSNewGe1:aCols[nY,24] + "' "    	+ __cCRLF
							cUpdate += "   ,D1_CONTA ='"	+ oMSNewGe1:aCols[nY,25] + "' "    	+ __cCRLF
						Endif

						cUpdate += "WHERE "														+ __cCRLF
						cUpdate += "   D_E_L_E_T_ <> '*' "  									+ __cCRLF
						cUpdate += "   AND D1_FILIAL  = '"	+ xFilial("SD1") 					+ "' "	+ __cCRLF
						cUpdate += "   AND D1_DOC     = '" 	+ M->XA1_NFISCA						+ "' "	+ __cCRLF
						cUpdate += "   AND D1_SERIE   = '" 	+ M->XA1_SERIE						+ "' "	+ __cCRLF
						cUpdate += "   AND D1_FORNECE = '" 	+ M->XA1_CLIFOR 					+ "' "	+ __cCRLF
						cUpdate += "   AND D1_LOJA	  = '" 	+ M->XA1_LOJA 						+ "' "	+ __cCRLF
						cUpdate += "   AND D1_COD	  = '"	+ Alltrim(oMSNewGe1:aCols[nY,13])	+ "' "	+ __cCRLF
						cUpdate += "   AND D1_ITEM	  = '"	+ StrZero(nY,4) 				    + "' "	+ __cCRLF  //oMSNewGe1:aCols[nY,01]
						TcSqlExec(cUpdate)
																	

						If M->XA1_PC == "1"
							dbSelectArea("SC7")
							SC7->(dbSetOrder(1))
							SC7->(dbGotop())

							If SC7->(dbSeek(xFilial("SC7") + Substr(oMSNewGe1:aCols[nY,11],1,6) + Substr(oMSNewGe1:aCols[nY,12],1,4)))
								nQtdACla := Round(SC7->C7_QTDACLA + oMSNewGe1:aCols[nY,15],4)

								RecLock("SC7",.F.)
								SC7->C7_QTDACLA := nQtdACla
								SC7->(MsUnlock())
								SC7->(dbCommitAll())                       
							Endif
						Endif
					Endif                 

					dbSelectArea("XA2")
					XA2->(dbSetOrder(1))
					XA2->(dbGotop())

					While !RecLock("XA2",.T.);EndDo 		 
					XA2->XA2_FILIAL 	:= xFilial("XA2") 
					XA2->XA2_ITEM   	:= oMSNewGe1:aCols[nY,01]
					XA2->XA2_PROXML  	:= oMSNewGe1:aCols[nY,02]
					XA2->XA2_NOMXML  	:= oMSNewGe1:aCols[nY,03]
					XA2->XA2_QTDXML  	:= oMSNewGe1:aCols[nY,04]
					XA2->XA2_VLUXML  	:= oMSNewGe1:aCols[nY,05]
					XA2->XA2_VLDXML  	:= oMSNewGe1:aCols[nY,07]
					XA2->XA2_VLTXML  	:= oMSNewGe1:aCols[nY,08]
					XA2->XA2_CFOXML  	:= oMSNewGe1:aCols[nY,09]
					XA2->XA2_CSTXML  	:= oMSNewGe1:aCols[nY,10]
					XA2->XA2_PEDIDO		:= oMSNewGe1:aCols[nY,11]
					XA2->XA2_ITEPN   	:= oMSNewGe1:aCols[nY,12]
					XA2->XA2_PROPN  	:= oMSNewGe1:aCols[nY,13]
					XA2->XA2_NOMPN   	:= oMSNewGe1:aCols[nY,14]
					XA2->XA2_QTDPN   	:= oMSNewGe1:aCols[nY,15]
					XA2->XA2_UMPN    	:= oMSNewGe1:aCols[nY,16]
					XA2->XA2_VLUPN   	:= oMSNewGe1:aCols[nY,17]
					XA2->XA2_VLDPN   	:= oMSNewGe1:aCols[nY,18]
					XA2->XA2_VLTPN   	:= oMSNewGe1:aCols[nY,19]
					XA2->XA2_VLFPN   	:= oMSNewGe1:aCols[nY,20]
					XA2->XA2_CFOPN 		:= oMSNewGe1:aCols[nY,21]
					XA2->XA2_CSTPN  	:= oMSNewGe1:aCols[nY,22]
					XA2->XA2_LOCPN   	:= oMSNewGe1:aCols[nY,23]
					XA2->XA2_CCPN    	:= oMSNewGe1:aCols[nY,24]
					XA2->XA2_CTPN    	:= oMSNewGe1:aCols[nY,25]
					XA2->XA2_APLIC   	:= oMSNewGe1:aCols[nY,26]
					XA2->XA2_ENTREG  	:= oMSNewGe1:aCols[nY,27]
					XA2->XA2_LOC  		:= oMSNewGe1:aCols[nY,28]
					XA2->XA2_NFISCA  	:= M->XA1_NFISCA
					XA2->XA2_SERIE   	:= M->XA1_SERIE
					XA2->XA2_CLIFOR  	:= M->XA1_CLIFOR
					XA2->XA2_LOJA    	:= M->XA1_LOJA
					XA2->XA2_FRTXML  	:= oMSNewGe1:aCols[nY,06]
					XA2->XA2_SEQ_WF		:= " "
					XA2->XA2_NROVIA		:= " "
					XA2->(MsUnlock())
					XA2->(dbCommitAll())
				Next

				dbSelectArea("XA1")
				XA1->(dbSetOrder(1))
				XA1->(dbGotop())

				While !RecLock("XA1",.T.);EndDo 		 
				XA1->XA1_FILIAL 	:= xFilial("XA1") 
				XA1->XA1_NFISCA 	:= M->XA1_NFISCA
				XA1->XA1_SERIE  	:= M->XA1_SERIE
				XA1->XA1_CLIFOR  	:= M->XA1_CLIFOR
				XA1->XA1_LOJA    	:= M->XA1_LOJA 
				XA1->XA1_DATEMI  	:= dGetDte
				XA1->XA1_DTRECE  	:= M->XA1_DTRECE
				XA1->XA1_RECALM  	:= M->XA1_RECALM
				XA1->XA1_HOREMI  	:= cGetHre
				XA1->XA1_DATIMP  	:= dDatabase
				XA1->XA1_HORIMP  	:= Time()
				XA1->XA1_USU     	:= Substr(cUsuario,7,15)
				XA1->XA1_CHVNFE  	:= cGetChv

				If _lOD
					XA1->XA1_OD 		:= _cXA3
					XA1->XA1_DTABOD 	:= _dDtXa3
				Endif

				XA1->XA1_TIPO    	:= M->XA1_TIPO
				XA1->XA1_CLASSE  	:= "1"
				XA1->XA1_ORIGEM  	:= "IMPXML"
				XA1->XA1_MOTIVO  	:= cGetMot
				XA1->XA1_NOMFOR  	:= M->XA1_NOMFOR
				XA1->XA1_UFORI   	:= M->XA1_UFORI
				XA1->XA1_PROT    	:= cGetPrt
				XA1->XA1_VERS    	:= cGetVer
				XA1->XA1_STAT    	:= cGetSta				
				XA1->XA1_PC    	:= M->XA1_PC
				XA1->XA1_DEPTO   	:= Posicione("XA5",1,xFilial("XA5") + __cUSERID,"XA5_COD")
				If (_nCountE > 0 .AND. _nCountD > 0) .OR. (_nCountE > 0 .AND. _nCountD = 0)
					XA1->XA1_STATUS	:= "E"
				Else
					XA1->XA1_STATUS	:= "D"				
				EndIf				
				XA1->(MsUnlock())
				XA1->(dbCommitAll())

				__CopyFile(Alltrim(cCaminho) + Alltrim(cNomArq),Alltrim(cProcess) + Alltrim(cNomArq))
				FErase(cArquivo)
			Endif
		Endif

	Else
		SetKey(VK_F4	,{|| })
		SetKey(VK_F5	,{|| })
		SetKey(VK_F6	,{|| })
		SetKey(VK_F12	,{|| Pergunte("IMPORTNFE",.T.)})
	Endif
Return(nOpca)

User Function xmlTOK()
	Local lRet     := .T.
	Local _nCntS   := 0
	Local _nCntN   := 0  
	Local _nCtPS   := 0
	Local _nCtPN   := 0
	Local _cTpPrd  := GetMv("AL_PA56TP")
	Local _nVPSAco := GetMv("AL_PA56PSA")
	Local _nVPNAco := GetMv("AL_PA56PNA")
	Local _nPerTot := 0
	Local _nFatCnv := 0
	Local _nFtCnv  := 0
	Local _cPedXa2 := ""
	Local _cAplXa2 := ""
	Local _cComSC7 := ""
	Local _cComSY1 := ""
	Local EmailSY1 := "" 
	Local _cNumXA3 := ""
	Local lVldXa3  := .F.
	Local _cProdDv := ""	                                                   
	Local _cUsrLog := &('RETCODUSR()')

	If Alltrim(dtos(M->XA1_DTRECE)) == ""
		lRet := .F.  
		Aviso("Aviso","Data de Recebimento deve ser informado.",{"Ok"})
	Endif

	DBSELECTAREA("XA3")
	DBSETORDER(5)
	If DBSEEK(xFilial("XA3")+ M->XA1_NFISCA + M->XA1_SERIE + M->XA1_CLIFOR + M->XA1_LOJA )
		If Alltrim(dtos(XA3_CONCLU)) = ""
			lVldXa3 := .T.	
			//		Aviso("Aviso","Só será possível realizar a importação do XML se a OD "+ Alltrim(XA3->XA3_NUM) +" estiver concluída. Para conclusão da OD acesse rotina - OCORRÊNCIA DE DIVERGÊNCIA.",{"Ok"})
			If MsgYesNo("Já existe registrado no sistema a seguinte OD "+ Alltrim(XA3->XA3_NUM) +" que ainda não foi concluído. Deseja continuar?")
				lRet := .T.
			Else
				lRet := .F.								
			EndIf
		EndIf
	EndIf

	If lRet
		For i:= 1 To Len(oMSNewGe1:aCols)
			If oMSNewGe1:aCols[i][15] <> oMSNewGe1:aCols[i][4]
				//			_nPerTot := (oMSNewGe1:aCols[i][15]*oMSNewGe1:aCols[i][4])/100			
				If Alltrim(Posicione("SB1",1,xFilial("SB1") + oMSNewGe1:aCols[i][13],"B1_TIPO"))$_cTpPrd

					_nFatCnv := _nVPSAco


					//RAFAEL ALMEIDA - SIGACORP (30/11/2016) NOVO COMANDO
					_nPerTMx := ((_axItXML[i] * (_nFatCnv + 100.01))/100)
					_nPerTMn := (_axItXML[i] - ((_axItXML[i] *  (_nFatCnv-0.01))/100))			

					//RAFAEL ALMEIDA - SIGACORP (30/11/2016) COMENTADO O TRECHO ABAIXO
					//_nPerTMx := ((oMSNewGe1:aCols[i][15] * (_nFatCnv + 100))/100)
					//_nPerTMn := ((oMSNewGe1:aCols[i][15] *  _nFatCnv)/100)			

					If	oMSNewGe1:aCols[i][4] < _nPerTMn .or. oMSNewGe1:aCols[i][4] > _nPerTMx
						_nCntS++
						_cPedXa2 :=	oMSNewGe1:aCols[i][11]
						_cAplXa2 :=	oMSNewGe1:aCols[i][26]
						_cProdDv += Alltrim(oMSNewGe1:aCols[i][13])+" - "+ Alltrim(oMSNewGe1:aCols[i][03])+Chr(13)+Chr(10)					
					EndIf
				Else  
					_nFatCnv := _nVPNAco
					//RAFAEL ALMEIDA - SIGACORP (30/11/2016) NOVO COMANDO
					_nPerTMx := ((_axItXML[i] * (_nFatCnv + 100.01))/100)
					_nPerTMn := (_axItXML[i] - ((_axItXML[i] *  (_nFatCnv-0.01))/100))

					//RAFAEL ALMEIDA - SIGACORP (30/11/2016) COMENTADO O TRECHO ABAIXO
					//_nPerTMx := ((oMSNewGe1:aCols[i][15] * (_nFatCnv + 100))/100)
					//_nPerTMn := ((oMSNewGe1:aCols[i][15] *  _nFatCnv)/100)			

					If	oMSNewGe1:aCols[i][4] < _nPerTMn .or. oMSNewGe1:aCols[i][4] > _nPerTMx			
						_nCntN++
						_cPedXa2 :=	oMSNewGe1:aCols[i][11]
						_cAplXa2 :=	oMSNewGe1:aCols[i][26]
						_cProdDv += Alltrim(oMSNewGe1:aCols[i][13])+" - "+ Alltrim(oMSNewGe1:aCols[i][03])+Chr(13)+Chr(10)					
					EndIf
				EndIf
			EndIf
			_nPerTMx := 0
			_nPerTMn := 0
			_nFatCnv := 0 

			If oMSNewGe1:aCols[i][15] == oMSNewGe1:aCols[i][4]
				_AreaSC7 := GetArea()
				DBSELECTAREA("SC7")
				DBSETORDER(2)    //C7_FILIAL, C7_PRODUTO, C7_FORNECE, C7_LOJA, C7_NUM,
				If DBSEEK(xFilial("SC7")+ oMSNewGe1:aCols[i][13] + M->XA1_CLIFOR + M->XA1_LOJA + oMSNewGe1:aCols[i][11] )
					If SC7->(C7_QUANT - C7_QUJE - C7_QTDACLA) <> oMSNewGe1:aCols[i][15]
						If Alltrim(Posicione("SB1",1,xFilial("SB1") + oMSNewGe1:aCols[i][13],"B1_TIPO"))$_cTpPrd 

							_nFtCnv := _nVPSAco
							_nPTMx := (((SC7->(C7_QUANT - C7_QUJE - C7_QTDACLA)) * (_nFtCnv + 100))/100)
							_nPTMn := ((SC7->(C7_QUANT - C7_QUJE - C7_QTDACLA)) - (((SC7->(C7_QUANT - C7_QUJE - C7_QTDACLA)) *  _nFatCnv)/100))			

							If	oMSNewGe1:aCols[i][15] < _nPTMn .or. oMSNewGe1:aCols[i][15] > _nPTMx
								_nCtPS++
								_cPedXa2 :=	oMSNewGe1:aCols[i][11]
								_cAplXa2 :=	oMSNewGe1:aCols[i][26]
								_cProdDv += Alltrim(oMSNewGe1:aCols[i][13])+" - "+ Alltrim(oMSNewGe1:aCols[i][03])+Chr(13)+Chr(10)					
							EndIf					
						Else   

							_nFatCnv := _nVPNAco
							_nPTMx := (((SC7->(C7_QUANT - C7_QUJE - C7_QTDACLA)) * (_nFatCnv + 100))/100)
							_nPTMn := ((SC7->(C7_QUANT - C7_QUJE - C7_QTDACLA)) - (((SC7->(C7_QUANT - C7_QUJE - C7_QTDACLA)) *  _nFatCnv)/100))			

							If	oMSNewGe1:aCols[i][15] < _nPTMn .or. oMSNewGe1:aCols[i][15] > _nPTMx			
								_nCtPN++
								_cPedXa2 :=	oMSNewGe1:aCols[i][11]
								_cAplXa2 :=	oMSNewGe1:aCols[i][26]
								_cProdDv += Alltrim(oMSNewGe1:aCols[i][13])+" - "+ Alltrim(oMSNewGe1:aCols[i][03])+Chr(13)+Chr(10)					
							EndIf

						EndIf				
					EndIf
				EndIf
				_nFtCnv := 0
				_nPTMx  := 0
				_nPTMn  := 0
				RestArea(_AreaSC7)
			EndIf		


		Next i

		If !Empty(_cPedXa2)
			DBSELECTAREA("SC7")
			DBSETORDER(1)
			If DBSEEK(xFilial("SC7")+Alltrim(_cPedXa2))
				_cComSC7 := Substr(UsrFullName(C7_USER),1,20)
			EndIf		
		EndIf


		// RAFAEL ALMEIDA - SIGACORP (22/12/2016) - Devolução XML	
		If ( _nCntN > 0 .Or. _nCntS > 0)  .And. M->XA1_TIPO#"D"	
			//	If _nCntN > 0 .Or. _nCntS > 0
			If !lVldXa3
				If !MsgYesNo("Foi identificado divergência na quantidade do Pedido de compra (PC) com XML Nota Fiscal. Deseja continuar com a Inclusão."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Itens com divergência: "+Chr(13)+Chr(10)+_cProdDv,"Alerta")
					lRet := .F.
					Begin Transaction
						_cNumXA3 := GetSx8Num("XA3")
						RecLock("XA3",.T.)
						XA3_FILIAL := XFILIAL("XA3")
						XA3_NUM    := _cNumXA3
						XA3_EMISSA := DATE()
						XA3_DTREC  := M->XA1_DTRECE
						XA3_APLIC  := _cAplXa2
						XA3_NOTA   := M->XA1_NFISCA
						XA3_SERIE  := M->XA1_SERIE
						XA3_PC     := M->XA1_PC
						XA3_PEDIDO := _cPedXa2
						XA3_COMPRA := _cComSC7
						XA3_FORNEC := M->XA1_CLIFOR
						XA3_LOJA   := M->XA1_LOJA
						XA3_NOME   := GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+M->XA1_CLIFOR+M->XA1_LOJA,1,"Erro")
						XA3_QTD    := "1"
						XA3_USRINC := _cUsrLog				
						XA3_DESCNC := ""
						XA3_RELATO := ""	
						ConfirmSx8()
						MsUnLock()
						MsgInfo("Foi Gerado OD: "+ Alltrim(_cNumXA3)+" , para Nota Fiscal: "+Alltrim(M->XA1_NFISCA)+"/"+Alltrim(M->XA1_SERIE),"Informação")			
						nOpca := 0
					End Transaction
				EndIf
			EndIf
			//EndIf
		EndIf	    //Fim Devolução de Venda - Rafael Almeida SIGACORP) 22/12/2016  - Devolução XML

		// RAFAEL ALMEIDA - SIGACORP (22/12/2016) - Devolução XML	
		If ( _nCtPN > 0 .Or. _nCtPS > 0) .And. M->XA1_TIPO#"D"  //Inicio de Validação - Rafael Almeida SIGACORP) 22/12/2016
			//	If _nCtPN > 0 .Or. _nCtPS > 0
			If !lVldXa3
				If !MsgYesNo("Foi identificado divergência na quantidade do Pedido de compra (PC) com a quantidade digitada pelo usuário. Deseja continuar com a Inclusão."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Itens com divergência: "+Chr(13)+Chr(10)+_cProdDv,"Alerta")
					lRet := .F.
					Begin Transaction
						_cNumXA3 := GetSx8Num("XA3")
						RecLock("XA3",.T.)
						XA3_FILIAL := XFILIAL("XA3")
						XA3_NUM    := _cNumXA3
						XA3_EMISSA := DATE()
						XA3_DTREC  := M->XA1_DTRECE
						XA3_APLIC  := _cAplXa2
						XA3_NOTA   := M->XA1_NFISCA
						XA3_SERIE  := M->XA1_SERIE
						XA3_PC     := M->XA1_PC
						XA3_PEDIDO := _cPedXa2
						XA3_COMPRA := _cComSC7
						XA3_FORNEC := M->XA1_CLIFOR 
						XA3_LOJA   := M->XA1_LOJA
						XA3_NOME   := GetAdvFVal("SA2","A2_NOME",xFilial("SA2")+M->XA1_CLIFOR+M->XA1_LOJA,1,"Erro")
						XA3_USRINC := _cUsrLog				
						XA3_QTD    := "1"
						//				XA3_DESCNC := ""
						//				XA3_RELATO := ""	
						ConfirmSx8()
						MsUnLock()
						MsgInfo("Foi Gerado OD: "+ Alltrim(_cNumXA3)+" , para Nota Fiscal: "+Alltrim(M->XA1_NFISCA)+"/"+Alltrim(M->XA1_SERIE),"Informação")			
						nOpca := 0
					End Transaction
				EndIf
			EndIf
		EndIf	
		//	EndIf	    //Fim Devolução de Venda - Rafael Almeida SIGACORP) 22/12/2016
	EndIf

Return(lRet)

User Function abrNFE()
	Local nHdl
	Local nTamFile
	Local cBuffer
	Local nBtLidos
	Local cAviso
	Local cErroArq   
	Local oWS
	Local lIsReady
	Local cURL  
	Local cIdEnt   
	Local cRetSEFA      
	Local cPrdCarg 	:= Space(15)
	Local cNomCarg 	:= Space(60)	
	Local cUMCarg		:= Space(2)
	Local cLocCarg		:= Space(2)

	If Alltrim(aRegSEF[1,1]) <> "" .And. Alltrim(aRegSEF[1,2]) <> ""
		Aviso("Aviso","Já ha dados de importação. Complete a tarefa ou reinicie a rotina de inclusão.",{"Ok"})	
		Return()
	Endif

	//Abre arquivo
	cArquivo	:= cGetFile("*.*","Arquivos XML",1,Alltrim(cCaminho),.F.,nOr(GETF_LOCALHARD,GETF_NETWORKDRIVE/*,GETF_NOCHANGEDIR*/),.F.,.T.) 
	cNomArq 	:= Substr(cArquivo,Len(Alltrim(cCaminho)) + 1,Len(Alltrim(cArquivo)) - Len(Alltrim(cCaminho)))

	If !Empty(cArquivo)
		If !File(cArquivo)
			aRegSEF[1,1] := "Indicação do Arquivo"
			aRegSEF[1,2] := "Erro!"
			oBrwSEF:Refresh()
			oFolder:SetOption(02)
			Return()
		Else 
			aRegSEF[1,1] := "Indicação do Arquivo"
			aRegSEF[1,2] := "Ok!"
		Endif

		nHdl := fOpen(cArquivo,0)

		If nHdl == -1
			aAdd(aRegSEF,{"Abertura do Arquivo","Erro!"})
			oBrwSEF:Refresh()
			oFolder:SetOption(02)
			Return()
		Else
			aAdd(aRegSEF,{"Abertura do Arquivo","Ok!"})
		Endif

		nTamFile := fSeek(nHdl,0,2)
		fSeek(nHdl,0,0)
		cBuffer  := Space(nTamFile)						
		nBtLidos := fRead(nHdl,@cBuffer,nTamFile)	
		fClose(nHdl)

		cAviso 	:= ""
		cErroArq	:= ""
		oNFe   	:= XmlParser(cBuffer,"_",@cAviso,@cErroArq)

		//Extracao das informacoes do arquivo XML
		If  U_fVldTyp('Type("oNFe:_NfeProc") <> "U"')
			oNF 		:= oNFe:_NFEPROC:_NFE
			cChvNfe 	:= oNFe:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT
			cProtoc	:= oNFe:_NFEPROC:_PROTNFE:_INFPROT:_NPROT:TEXT
			cVersao	:= oNFe:_NFEPROC:_VERSAO:TEXT
			cStatus	:= oNFe:_NFEPROC:_PROTNFE:_INFPROT:_CSTAT:TEXT
			cMotivo	:=	oNFe:_NFEPROC:_PROTNFE:_INFPROT:_XMOTIVO:TEXT 
			cInfNfe  := oNF:_INFNFE:_IDE:_FINNFE:TEXT  // RAFAEL ALMEIDA - SIGACORP (22/12/2016) - Devolução XML			
		ElseIf  U_fVldTyp('Type("oNFe:_N0_NFEPROC") <> "U"')                       //RAFAEL ALMEIDA - SIGACORP (30/12/2015)
			oNF 		:= oNFe:_N0_NFEPROC:_NFE
			cChvNfe 	:= oNFe:_N0_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT
			cProtoc	:= oNFe:_N0_NFEPROC:_PROTNFE:_INFPROT:_NPROT:TEXT
			cVersao	:= oNFe:_N0_NFEPROC:_NFE:_INFNFE:_VERSAO:TEXT
			cStatus	:= oNFe:_N0_NFEPROC:_PROTNFE:_INFPROT:_CSTAT:TEXT
			cMotivo	:=	oNFe:_N0_NFEPROC:_PROTNFE:_INFPROT:_XMOTIVO:TEXT			
			cInfNfe  := oNF:_INFNFE:_IDE:_FINNFE:TEXT  // RAFAEL ALMEIDA - SIGACORP (22/12/2016) - Devolução XML
		Else
			oNF 		:= oNFe:_NFE  
			cChvNfe 	:= Substr(oNFe:_NFE:_INFNFE:_ID:TEXT,4,44)
		Endif

		// RAFAEL ALMEIDA - SIGACORP (22/12/2016) - Devolução XML

		If cInfNfe=="4" .And. M->XA1_TIPO#"D"
			Aviso("Aviso","O XML importado trata-se de uma Devolução, para isso faz necessário primeiramente informar o tipo de documento como DEVOLUÇÃO antes de importar o XML.",{"Ok"})	
			Return()
		Endif



		If  U_fVldTyp('Type("oNF:_INFNFE:_ICMS") <> "U"')
			oICM := oNF:_INFNFE:_ICMS
			//ElseIf  U_fVldTyp('Type("oNFe:_N0_NFEPROC") <> "U"')                       //RAFAEL ALMEIDA - SIGACORP (30/12/2015)
			//	oICM := oNF:_N0_INFNFE:_ICMS		
		Else
			oICM := nil
		Endif                        

		If  U_fVldTyp('Type("oNFe:_NfeProc") <> "U"')	
			oEmitente	:= oNF:_INFNFE:_EMIT
			oIdent     	:= oNF:_INFNFE:_IDE
			oDestino   	:= oNF:_INFNFE:_DEST
			oTotal     	:= oNF:_INFNFE:_TOTAL
			oTransp    	:= oNF:_INFNFE:_TRANSP
			oDet       	:= oNF:_INFNFE:_DET
			oFatura		:= IIf(U_fVldTyp('Type("oNF:_InfNfe:_Cobr") == "U"'),Nil,oNF:_INFNFE:_COBR)
			oDet 			:= IIf(ValType(oDet)=="O",{oDet},oDet)
			cCgc 			:= AllTrim(IIf(U_fVldTyp('Type("oEmitente:_CPF") == "U"'),oEmitente:_CNPJ:TEXT,OEMITENTE:_CPF:TEXT))
			cNF  			:= Right("000000000" + Alltrim(OIdent:_NNF:TEXT),9)
			cSer 			:= Padr(oIdent:_SERIE:TEXT,3)
		ElseIf  U_fVldTyp('Type("oNFe:_N0_NFEPROC") <> "U"')                       //RAFAEL ALMEIDA - SIGACORP (30/12/2015)
			oEmitente	:= oNFe:_N0_NFEPROC:_NFE:_INFNFE:_EMIT
			oIdent     	:= oNFe:_N0_NFEPROC:_NFE:_INFNFE:_IDE
			oDestino   	:= oNFe:_N0_NFEPROC:_NFE:_INFNFE:_DEST
			oTotal     	:= oNFe:_N0_NFEPROC:_NFE:_INFNFE:_TOTAL
			oTransp    	:= oNFe:_N0_NFEPROC:_NFE:_INFNFE:_TRANSP
			oDet       	:= oNFe:_N0_NFEPROC:_NFE:_INFNFE:_DET
			oFatura		:= IIf(U_fVldTyp('Type("oNF:_InfNfe:_Cobr") == "U"'),Nil,oNFe:_N0_NFEPROC:_NFE:_INFNFE:_COBR)
			oDet 			:= IIf(ValType(oDet)=="O",{oDet},oDet)
			cCgc 			:= AllTrim(IIf(U_fVldTyp('Type("oEmitente:_CPF") == "U"'),oEmitente:_CNPJ:TEXT,OEMITENTE:_CPF:TEXT))
			cNF  			:= Right("000000000" + Alltrim(OIdent:_NNF:TEXT),9)
			cSer 			:= Padr(oIdent:_SERIE:TEXT,3)
		EndIf




		//2.00
		If  U_fVldTyp('Type("OIdent:_dEmi:TEXT") <> "U"')
			cData := Alltrim(OIdent:_dEmi:TEXT)
		Endif

		//3.10
		If  U_fVldTyp('Type("OIdent:_DHEMI:TEXT") <> "U"')
			cData := Alltrim(Substr(OIdent:_DHEMI:TEXT,1,10))
		Endif    

		dData 	:= CTOD(Right(cData,2) + '/' + Substr(cData,6,2) + '/' + Left(cData,4))   

		If  U_fVldTyp('Type("oNF:_INFNFE:_TOTAL:_ICMSTOT:_VFRETE") <> "U"')
			nFrete := Val(oNF:_INFNFE:_TOTAL:_ICMSTOT:_VFRETE:TEXT)
		ElseIf  U_fVldTyp('Type("oNFe:_N0_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VFRETE") <> "U"')
			nFrete := Val(oNFe:_N0_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VFRETE:TEXT)		
		Else
			nFrete := 0.00
		Endif                                                

		If  U_fVldTyp('Type("oNF:_INFNFE:_TOTAL:_ICMSTOT:_VDESC") <> "U"')
			nDesct := Val(oNF:_INFNFE:_TOTAL:_ICMSTOT:_VDESC:TEXT)
		ElseIf  U_fVldTyp('Type("oNFe:_N0_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VDESC") <> "U"')
			nDesct := Val(oNFe:_N0_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VDESC:TEXT)
		Else
			nDesct := 0.00
		Endif                                       

		If  U_fVldTyp('Type("oNF:_INFNFE:_TOTAL:_ICMSTOT:_VPROD") <> "U"')
			nProdTot := Val(oNF:_INFNFE:_TOTAL:_ICMSTOT:_VPROD:TEXT)
		ElseIf  U_fVldTyp('Type("oNFe:_N0_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VPROD") <> "U"')
			nProdTot := Val(oNFe:_N0_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VPROD:TEXT)
		Else
			nProdTot := 0.00
		Endif                                       

		If  U_fVldTyp('Type("oNF:_INFNFE:_TOTAL:_ICMSTOT:_VIPI") <> "U"')
			nIPI := Val(oNF:_INFNFE:_TOTAL:_ICMSTOT:_VIPI:TEXT)
		ElseIf  U_fVldTyp('Type("oNFe:_N0_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VIPI") <> "U"')
			nIPI := Val(oNFe:_N0_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VIPI:TEXT)
		Else
			nIPI := 0.00
		Endif                                       

		nTotNF	:= Val(oNF:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT)



		//Inicio - Verificar se é devolução para amarrar clienrte x produto - Rafael Almeida - SIGACORP	 (22/12/2016) - Devolução XML
		If oNF:_INFNFE:_IDE:_FINNFE:TEXT=="4"

			dbSelectArea("SA1")	
			SA1->(dbSetOrder(3))

			dbSelectArea("SF1")
			SF1->(dbSetOrder(1))

			If !SA1->(dbSeek(xFilial("SA1") + cCgc))
				aAdd(aRegSEF,{"Cliente no XML " + cCgc + "-" + oEmitente:_XNOME:TEXT,"Nao cadastrado!"})
				oBrwSEF:Refresh()
				oFolder:SetOption(02)
				Return()
			Else
				aAdd(aRegSEF,{"Cliente no XML " + cCgc +"-" + oEmitente:_XNOME:TEXT,"Encontrado no Protheus :: Codigo:" + SA1->A1_COD + SA1->A1_LOJA + "-" + SA1->A1_NOME})
			Endif

			If SF1->(dbSeek(XFilial("SF1") + cNF + cSer + SA1->A1_COD + SA1->A1_LOJA))
				If AllTrim(SF1->F1_ESPECIE) $ "SPED|CTE"
					aAdd(aRegSEF,{"Docto Fiscal do XML de Espécie ("+AllTrim(SF1->F1_ESPECIE)+"): " + cNF + "-" + cSer,"Já cadastrada no Protheus :: Codigo:" + SF1->F1_DOC + "-" + SF1->F1_SERIE})
					oBrwSEF:Refresh()
					oFolder:SetOption(02)
					cDtEmis  := DTOC(SF1->F1_EMISSAO)
					cDtDigit := DTOC(SF1->F1_DTDIGIT)
					If MsgYesNo("Docto Fiscal do XML de Espécie ("+AllTrim(SF1->F1_ESPECIE)+"): " + cNF + "-" + cSer + "Já cadastrada no Protheus"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Data Emissão: "+cDtEmis+Chr(13)+Chr(10)+"Data Digitação: "+cDtDigit+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Deseja tentar a importação do docto com a Série: "+Right("000" + Alltrim(cSer),2)+" ?"+Chr(13)+Chr(10),"Alerta")
						cSer := Right("000" + Alltrim(cSer),2)+" "
						SF1->(DbGoTop())
						If SF1->(dbSeek(XFilial("SF1") + cNF + cSer + SA1->A1_COD + SA1->A1_LOJA))
							If AllTrim(SF1->F1_ESPECIE) $ "SPED|CTE"
								aAdd(aRegSEF,{"Docto Fiscal do XML de Espécie ("+AllTrim(SF1->F1_ESPECIE)+"): " + cNF + "-" + cSer,"Já cadastrada no Protheus :: Codigo:" + SF1->F1_DOC + "-" + SF1->F1_SERIE})
								oBrwSEF:Refresh()
								oFolder:SetOption(02)
								cDtEmis  := DTOC(SF1->F1_EMISSAO)
								cDtDigit := DTOC(SF1->F1_DTDIGIT)
								If MsgYesNo("Docto Fiscal do XML de Espécie ("+AllTrim(SF1->F1_ESPECIE)+"): " + cNF + "-" + cSer + "Já cadastrada no Protheus"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Data Emissão: "+cDtEmis+Chr(13)+Chr(10)+"Data Digitação: "+cDtDigit+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Deseja tentar a importação do docto com a Série: "+Right("000" + Alltrim(cSer),3)+" ?"+Chr(13)+Chr(10),"Alerta")
									cSer := Right("000" + Alltrim(cSer),3)
									SF1->(DbGoTop())
									If SF1->(dbSeek(XFilial("SF1") + cNF + cSer + SA1->A1_COD + SA1->A1_LOJA))
										If AllTrim(SF1->F1_ESPECIE) $ "SPED|CTE"
											aAdd(aRegSEF,{"Docto Fiscal do XML de Espécie ("+AllTrim(SF1->F1_ESPECIE)+"): " + cNF + "-" + cSer,"Já cadastrada no Protheus :: Codigo:" + SF1->F1_DOC + "-" + SF1->F1_SERIE})
											oBrwSEF:Refresh()
											oFolder:SetOption(02)
											Return()
										EndIf
									Else
										aAdd(aRegSEF,{"Nota Fiscal no XML " + cNF + "-" + cSer,"Nao cadastrada!"})
									EndIf
								Else
									Return()
								EndIf
							EndIf
						Else
							aAdd(aRegSEF,{"Nota Fiscal no XML " + cNF + "-" + cSer,"Nao cadastrada!"})
						EndIf
					Else
						Return()
					EndIf
				EndIf
			Else
				aAdd(aRegSEF,{"Nota Fiscal no XML " + cNF + "-" + cSer,"Nao cadastrada!"})
			Endif                                                                       


			M->XA1_CLIFOR	:= SA1->A1_COD
			M->XA1_LOJA   	:= SA1->A1_LOJA
			M->XA1_NOMFOR	:= SA1->A1_NOME
			M->XA1_UFORI  	:= SA1->A1_EST
			M->XA1_NFISCA	:= cNF
			M->XA1_SERIE	:= cSer
			M->XA1_DATEMI	:= dData
			cGetNom 		:= SA1->A1_NOME
			cGetEnd 		:= SA1->A1_END
			cGetEst 		:= SA1->A1_EST
			cGetTel 		:= SA1->A1_TEL
			cGetCGC 		:= SA1->A1_CGC
			cGetInsc		:= SA1->A1_INSCR
			cGetChv			:= cChvNfe
			cGetPrt 		:= cProtoc		
			cGetVer 		:= cVersao
			cGetSta 		:= cStatus
			cGetMot 		:= cMotivo         
			dGetDte			:= dData  

		Else

			dbSelectArea("SA2")	
			SA2->(dbSetOrder(3))

			dbSelectArea("SF1")
			SF1->(dbSetOrder(1))

			If !SA2->(dbSeek(xFilial("SA2") + cCgc))
				aAdd(aRegSEF,{"Fornecedor no XML " + cCgc + "-" + oEmitente:_XNOME:TEXT,"Nao cadastrado!"})
				oBrwSEF:Refresh()
				oFolder:SetOption(02)
				Return()
			Else
				aAdd(aRegSEF,{"Fornecedor no XML " + cCgc +"-" + oEmitente:_XNOME:TEXT,"Encontrado no Protheus :: Codigo:" + SA2->A2_COD + SA2->A2_LOJA + "-" + SA2->A2_NOME})
			Endif

			If SF1->(dbSeek(XFilial("SF1") + cNF + cSer + SA2->A2_COD + SA2->A2_LOJA))
				If AllTrim(SF1->F1_ESPECIE) $ "SPED|CTE"
					aAdd(aRegSEF,{"Docto Fiscal do XML de Espécie ("+AllTrim(SF1->F1_ESPECIE)+"): " + cNF + "-" + cSer,"Já cadastrada no Protheus :: Codigo:" + SF1->F1_DOC + "-" + SF1->F1_SERIE})
					oBrwSEF:Refresh()
					oFolder:SetOption(02)
					cDtEmis  := DTOC(SF1->F1_EMISSAO)
					cDtDigit := DTOC(SF1->F1_DTDIGIT)
					If MsgYesNo("Docto Fiscal do XML de Espécie ("+AllTrim(SF1->F1_ESPECIE)+"): " + cNF + "-" + cSer + "Já cadastrada no Protheus"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Data Emissão: "+cDtEmis+Chr(13)+Chr(10)+"Data Digitação: "+cDtDigit+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Deseja tentar a importação do docto com a Série: "+Right("000" + Alltrim(cSer),2)+" ?"+Chr(13)+Chr(10),"Alerta")
						cSer := Right("000" + Alltrim(cSer),2)+" "
						SF1->(DbGoTop())
						If SF1->(dbSeek(XFilial("SF1") + cNF + cSer + SA2->A2_COD + SA2->A2_LOJA))
							If AllTrim(SF1->F1_ESPECIE) $ "SPED|CTE"
								aAdd(aRegSEF,{"Docto Fiscal do XML de Espécie ("+AllTrim(SF1->F1_ESPECIE)+"): " + cNF + "-" + cSer,"Já cadastrada no Protheus :: Codigo:" + SF1->F1_DOC + "-" + SF1->F1_SERIE})
								oBrwSEF:Refresh()
								oFolder:SetOption(02)
								cDtEmis  := DTOC(SF1->F1_EMISSAO)
								cDtDigit := DTOC(SF1->F1_DTDIGIT)
								If MsgYesNo("Docto Fiscal do XML de Espécie ("+AllTrim(SF1->F1_ESPECIE)+"): " + cNF + "-" + cSer + "Já cadastrada no Protheus"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Data Emissão: "+cDtEmis+Chr(13)+Chr(10)+"Data Digitação: "+cDtDigit+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Deseja tentar a importação do docto com a Série: "+Right("000" + Alltrim(cSer),3)+" ?"+Chr(13)+Chr(10),"Alerta")
									cSer := Right("000" + Alltrim(cSer),3)
									SF1->(DbGoTop())
									If SF1->(dbSeek(XFilial("SF1") + cNF + cSer + SA2->A2_COD + SA2->A2_LOJA))
										If AllTrim(SF1->F1_ESPECIE) $ "SPED|CTE"
											aAdd(aRegSEF,{"Docto Fiscal do XML de Espécie ("+AllTrim(SF1->F1_ESPECIE)+"): " + cNF + "-" + cSer,"Já cadastrada no Protheus :: Codigo:" + SF1->F1_DOC + "-" + SF1->F1_SERIE})
											oBrwSEF:Refresh()
											oFolder:SetOption(02)
											Return()
										EndIf
									Else
										aAdd(aRegSEF,{"Nota Fiscal no XML " + cNF + "-" + cSer,"Nao cadastrada!"})
									EndIf
								Else
									Return()
								EndIf
							EndIf
						Else
							aAdd(aRegSEF,{"Nota Fiscal no XML " + cNF + "-" + cSer,"Nao cadastrada!"})
						EndIf
					Else
						Return()
					EndIf
				EndIf
			Else
				aAdd(aRegSEF,{"Nota Fiscal no XML " + cNF + "-" + cSer,"Nao cadastrada!"})
			Endif                                                                       

			M->XA1_CLIFOR	:= SA2->A2_COD
			M->XA1_LOJA   	:= SA2->A2_LOJA
			M->XA1_NOMFOR	:= SA2->A2_NOME
			M->XA1_UFORI  	:= SA2->A2_EST
			M->XA1_NFISCA	:= cNF
			M->XA1_SERIE	:= cSer
			M->XA1_DATEMI	:= dData
			cGetNom 			:= SA2->A2_NOME
			cGetEnd 			:= SA2->A2_END
			cGetEst 			:= SA2->A2_EST
			cGetTel 			:= SA2->A2_TEL
			cGetCGC 			:= SA2->A2_CGC
			cGetInsc			:= SA2->A2_INSCR
			cGetChv			:= cChvNfe
			cGetPrt 			:= cProtoc		
			cGetVer 			:= cVersao
			cGetSta 			:= cStatus
			cGetMot 			:= cMotivo         
			dGetDte			:= dData

		EndIf
		//Fim - Verificar se é devolução para amarrar clienrte x produto - Rafael Almeida - SIGACORP	 (22/12/2016) - Devolução XML

		For i := 1 To Len(oDet)     
			cNumPedido 	:= ""
			cProdAlub 	:= Space(15)
			cNomeAlub 	:= Space(150)
			cItemNF		:=	Right("0000" + Alltrim(oDet[i]:_NITEM:TEXT),4)

			//RAFAEL ALEMIDA - SIGACORP (22/12/2016) Informa o Codigo do produto do cliente  - Devolução XML
			If oNF:_INFNFE:_IDE:_FINNFE:TEXT=="4"
				cProduto		:=	PadR(AllTrim(oDet[i]:_Prod:_cProd:TEXT),TamSx3("A7_CODCLI")[1])			
			Else
				cProduto		:=	PadR(AllTrim(oDet[i]:_Prod:_cProd:TEXT),TamSx3("A5_CODPRF")[1])
			EndIf

			//cProduto		:=	PadR(AllTrim(oDet[i]:_Prod:_cProd:TEXT),TamSx3("A5_CODPRF")[1])  //essa linha deve ser comentada quando o comando acima cliente x produto for ativa
			cNomProd 	:= oDet[i]:_Prod:_xProd:TEXT

			If  U_fVldTyp('Type("oDet[i]:_Prod:_vFrete") <> "U"')
				nFretePrd := Val(oDet[i]:_Prod:_vFrete:TEXT)
			Else
				nFretePrd := 0.00
			Endif

			nQtdXML 	:= 0.00
			nVlUnit	:= 0.00             
			nVlTotal	:= 0.00
			cCFOXML	:= Space(05)	
			nValDesc	:= 0.00    
			cClasFis	:= Space(03)
			nQtdXML 	:= Val(oDet[i]:_PROD:_QCOM:TEXT)          
			nVlUnit 	:= Round(Val(oDet[i]:_PROD:_VUNCOM:TEXT),6)
			nVlTotal	:= Val(oDet[i]:_PROD:_VPROD:TEXT)
			cCFOXML 	:= oDet[i]:_PROD:_CFOP:TEXT

			If  U_fVldTyp('Type("oDet[i]:_Prod:_vDesc") <> "U"')
				nValDesc := Val(oDet[i]:_PROD:_VDESC:TEXT)
			Else 
				nValDesc := 0.00
			Endif   

			Do Case
				Case U_fVldTyp('Type("oDet[i]:_IMPOSTO:_ICMS:_ICMS00") <> "U"')
				oICM := oDet[i]:_IMPOSTO:_ICMS:_ICMS00
				Case U_fVldTyp('Type("oDet[i]:_IMPOSTO:_ICMS:_ICMS10") <> "U"')
				oICM := oDet[i]:_IMPOSTO:_ICMS:_ICMS10
				Case U_fVldTyp('Type("oDet[i]:_IMPOSTO:_ICMS:_ICMS20") <> "U"')  	
				oICM := oDet[i]:_IMPOSTO:_ICMS:_ICMS20
				Case U_fVldTyp('Type("oDet[i]:_IMPOSTO:_ICMS:_ICMS30") <> "U"')
				oICM := oDet[i]:_IMPOSTO:_ICMS:_ICMS30
				Case U_fVldTyp('Type("oDet[i]:_IMPOSTO:_ICMS:_ICMS40") <> "U"')
				oICM := oDet[i]:_IMPOSTO:_ICMS:_ICMS40
				Case U_fVldTyp('Type("oDet[i]:_IMPOSTO:_ICMS:_ICMS51") <> "U"')
				oICM := oDet[i]:_IMPOSTO:_ICMS:_ICMS51
				Case U_fVldTyp('Type("oDet[i]:_IMPOSTO:_ICMS:_ICMS60") <> "U"')
				oICM := oDet[i]:_IMPOSTO:_ICMS:_ICMS60
				Case U_fVldTyp('Type("oDet[i]:_IMPOSTO:_ICMS:_ICMS70") <> "U"')
				oICM := oDet[i]:_IMPOSTO:_ICMS:_ICMS70
				Case U_fVldTyp('Type("oDet[i]:_IMPOSTO:_ICMS:_ICMS90") <> "U"')
				oICM := oDet[i]:_IMPOSTO:_ICMS:_ICMS90
			EndCase       

			If  U_fVldTyp('Type("oICM:_orig:TEXT") <> "U"') .And. U_fVldTyp('Type("oICM:_CST:TEXT") <> "U"')
				cClasFis := Alltrim(oICM:_orig:TEXT) + Alltrim(oICM:_CST:TEXT)
			Endif

			If M->XA1_PC == "2"
				cPrdCarg := Space(15)
				cNomCarg := Space(150)	
				cUMCarg	:= Space(2)
				cLocCarg	:= Space(2)


				//RAFAEL ALMEIDA - SIGACORP (22/12/2016) AMARRAÇÃO DO CLIENTE X PRODUTO  - Devolução XML
				If oNF:_INFNFE:_IDE:_FINNFE:TEXT=="4"
					cPrdCarg := Posicione("SA7",3,xFilial("SA7") + M->XA1_CLIFOR + M->XA1_LOJA + Substr(cProduto,1,15),"A7_PRODUTO")
				Else
					cPrdCarg := Posicione("SA5",14,xFilial("SA5") + M->XA1_CLIFOR + M->XA1_LOJA + Substr(cProduto,1,15),"A5_PRODUTO")
				EndIf



				//				cPrdCarg := Posicione("SA5",14,xFilial("SA5") + M->XA1_CLIFOR + M->XA1_LOJA + Substr(cProduto,1,15),"A5_PRODUTO")//LINHA DEVE SER COMENDA ASSIM QUE IMPLANTAR XML DEVOLUÇÃO
				cNomCarg	:= Posicione("SB1",1,xFilial("SB1") + cPrdCarg,"B1_DESC")
				cUMCarg	:= Posicione("SB1",1,xFilial("SB1") + cPrdCarg,"B1_UM")
				cLocCarg	:= Posicione("SB1",1,xFilial("SB1") + cPrdCarg,"B1_LOCPAD")                                              

				If Alltrim(cPrdCarg) == ""
					Aviso("Aviso","Produto " + cItemNF + " do arquivo XML nao possui amarracao de Produto X Fornecedor. Efetue a amarracao para continuar.",{"Ok"})
					Return()
				Endif
			Endif

			If i == 1
				oMSNewGe1:aCols[1,1] 	:= cItemNF                                	//1-Item
				oMSNewGe1:aCols[1,2] 	:= Substr(cProduto,1,50)                  	//2-Prod XML
				oMSNewGe1:aCols[1,3] 	:= Substr(cNomProd,1,150)                 	//3-Nome XML
				oMSNewGe1:aCols[1,4] 	:= nQtdXML                                	//4-Qtd XML
				oMSNewGe1:aCols[1,5] 	:= nVlUnit                                	//5-Vl Un XML
				oMSNewGe1:aCols[1,6] 	:= nFretePrd                              	//6-Frete XML
				oMSNewGe1:aCols[1,7] 	:= nValDesc                               	//7-Desc XML
				oMSNewGe1:aCols[1,8] 	:= nVlTotal                               	//8-Total XML
				oMSNewGe1:aCols[1,9] 	:= cCFOXML                                	//9-CFOP XML
				oMSNewGe1:aCols[1,10]	:= cClasFis                               	//10-CST XML
				oMSNewGe1:aCols[1,11]	:= Iif(M->XA1_PC=="1",Space(6),"000000")		//11-Pedido
				oMSNewGe1:aCols[1,12]	:= Iif(M->XA1_PC=="1",Space(4),cItemNF) 		//12-Item Prenota
				oMSNewGe1:aCols[1,13]	:= Iif(M->XA1_PC=="1",Space(15),cPrdCarg) 	//13-Prod Prenota
				oMSNewGe1:aCols[1,14]	:= Iif(M->XA1_PC=="1",Space(60),cNomCarg) 	//14-Nome Prenota
				oMSNewGe1:aCols[1,15]	:= Iif(M->XA1_PC=="1",0.00,nQtdXML)	 		//15-Qtd Prenota
				oMSNewGe1:aCols[1,16]	:= Iif(M->XA1_PC=="1",Space(2),cUMCarg)	 	//16-UM Prenota
				oMSNewGe1:aCols[1,17]	:= Iif(M->XA1_PC=="1",0.00,nVlUnit)	 		//17-Vl UN Prenot
				oMSNewGe1:aCols[1,18]	:= Iif(M->XA1_PC=="1",0.00,nValDesc)	 		//18-Desc Prenota
				oMSNewGe1:aCols[1,19]	:= Iif(M->XA1_PC=="1",0.00,nVlTotal)	 		//19-Total Prenot
				oMSNewGe1:aCols[1,20]	:= Iif(M->XA1_PC=="1",0.00,nFretePrd)			//20-Frete Prenot
				oMSNewGe1:aCols[1,21]	:= Iif(M->XA1_PC=="1",Space(5),cCFOXML)		//21-Cfop Prenota
				oMSNewGe1:aCols[1,22]	:= Iif(M->XA1_PC=="1",Space(3),cClasFis)		//22-CST Prenota
				oMSNewGe1:aCols[1,23]	:= Iif(M->XA1_PC=="1",Space(2),cLocCarg)		//23-Local Prenot
				oMSNewGe1:aCols[1,26]	:= "D" 													//26-Aplicacao
				oMSNewGe1:aCols[1,27]	:= Space(06)											//27-Usuario para entrega
				oMSNewGe1:aCols[1,28]	:= Space(30)											//27-Locacao
				//XA2->XA2_ENTREG  	:= oMSNewGe1:aCols[nY,27]
				//XA2->XA2_LOC  		:= oMSNewGe1:aCols[nY,28]
			Else
				aAdd(oMSNewGe1:aCols,{	cItemNF											,; //1-Item
				Substr(cProduto,1,50)							,; //2-Prod XML
				Substr(cNomProd,1,150)							,; //3-Nome XML
				nQtdXML												,; //4-Qtd XML
				nVlUnit												,; //5-Vl Un XML
				nFretePrd											,; //6-Desc XML
				nValDesc												,; //7-Frete XML
				nVlTotal												,; //8-Total XML
				cCFOXML 												,; //9-CFOP XML
				cClasFis												,; //10-CST XML
				Iif(M->XA1_PC=="1",Space(6),"000000")		,; //11-Pedido
				Iif(M->XA1_PC=="1",Space(4),cItemNF)		,; //12-Item Prenota
				Iif(M->XA1_PC=="1",Space(15),cPrdCarg)	,; //13-Prod Prenota
				Iif(M->XA1_PC=="1",Space(150),cNomCarg)	,; //14-Nome Prenota
				Iif(M->XA1_PC=="1",0.00,nQtdXML)			,; //15-Qtd Prenota
				Iif(M->XA1_PC=="1",Space(2),cUMCarg)		,; //16-UM Prenota
				Iif(M->XA1_PC=="1",0.00,nVlUnit)			,; //17-Vl UN Prenot
				Iif(M->XA1_PC=="1",0.00,nValDesc)			,; //18-Desc Prenota
				Iif(M->XA1_PC=="1",0.00,nVlTotal)			,; //19-Total Prenot
				Iif(M->XA1_PC=="1",0.00,nFretePrd)			,; //20-Frete Prenot
				Iif(M->XA1_PC=="1",Space(5),cCFOXML)		,; //21-Cfop Prenota
				Iif(M->XA1_PC=="1",Space(3),cClasFis)		,; //22-CST Prenota
				Iif(M->XA1_PC=="1",Space(2),cLocCarg)		,; //23-Local Prenot
				Space(9)												,; //24-CC Prenota
				Space(20)											,;	//25-Ct Prenota
				"D"													,;	//26-Aplicacao
				Space(06)											,;	//27-Usuario para entrega
				Space(30)											,;	//28-Locacao
				.F.})
			Endif
		Next i

		oBrwSEF:Refresh()
		oMSNewGe1:Refresh()

		u_calcRES()	
	Endif
Return()





User Function pcXML()           
	Local cQry
	Local oDlgPC 
	Local Group
	Local oButton1
	Local lSC7 		:= .F.  
	Local aButtons	:= {}	
	Local aCabPC	:= {" ","Pedido","Item","Produto","Descr","UM","Quant","Qtd Entregue","Saldo","Valor","Total","Data","Almox","OBS","CC","Cod Fornecedor"}
	Local lFechaPC := .F.
	Local nOpcaoPC	:= 0
	Local cVerPC           

	Private _nat
	Private aPC		:= {}
	Private oBrwPC                                                        
	Private oOK		:= LoadBitmap(GetResources(),'BR_VERDE')
	Private oNO	  	:= LoadBitmap(GetResources(),'BR_VERMELHO')
	Private cNumC7	:= Space(6)       
	Private oNumC7    

	If Alltrim(aRegSEF[1,1]) == "" .And. Alltrim(aRegSEF[1,2]) == ""
		Aviso("Aviso","Não ha dados de importação. Importe o arquivo XML para selecionar PC.",{"Ok"})	
		Return()
	Endif     

	If Alltrim(M->XA1_PC) == '2'
		Aviso("Aviso","Foi selecionada a opção '2-Sem pedido de Compras.",{"Ok"})	
		Return()
	Endif

	If u_filPC(1)
		DEFINE MSDIALOG oDlgPC TITLE "Pedidos de Compra" FROM 000,000 TO 400,700 PIXEL  
		EnchoiceBar(oDlgPC, {|| _nat := oMsNewGe1:nat, lFechaPC := .T.,nOpcaoPC := 1,oDlgPC:End()},{|| lFechaPC := .T.,nOpcaoPC := 0,oDlgPC:End()},,aButtons)

		@ 003,005 Say "Ped. Compra:"	Of oDlgPC Pixel Size 055,009
		@ 003,045 msGet oNumC7 Var cNumC7 Size 060,010 Of oDlgPC Colors 0,16777215 Pixel
		@ 003,110 Button oButton1 Prompt "&Filtrar" Size 037,012 Of oDlgPC Action {|| u_filPC(2)} Pixel

		oBrwPC := TCBrowse():New(020,001,351,167,,aCabPC,{15,30,15,30,150,20,30,30,30,30,30,30,20,50,20},oDlgPC,,,,,{|| marcPC()},{|| },,,,,,.F.,,.T.,,.F.,,,)
		oBrwPC:SetArray(aPC) 
		oBrwPC:bLine := {||{If (Alltrim(aPC[oBrwPC:nAt,01])=="X",oOK,oNO),aPC[oBrwPC:nAt,02],aPC[oBrwPC:nAt,03],Substr(aPC[oBrwPC:nAt,04],1,15),Substr(aPC[oBrwPC:nAt,05],1,150),aPC[oBrwPC:nAt,06],Transform(aPC[oBrwPC:nAt,07],"@E 9999,999,999.99"),Transform(aPC[oBrwPC:nAt,08],"@E 9999,999,999.99"),Transform(aPC[oBrwPC:nAt,09],"@E 9999,999,999.99"),Transform(aPC[oBrwPC:nAt,10],"@E 9999,999,999.99"),Transform(aPC[oBrwPC:nAt,11],"@E 9999,999,999.99"),DtoC(StoD(aPC[oBrwPC:nAt,12])),aPC[oBrwPC:nAt,13],Substr(aPC[oBrwPC:nAt,14],1,50),aPC[oBrwPC:nAt,15],Substr(aPC[oBrwPC:nAt,16],1,50)}}  
		ACTIVATE MSDIALOG oDlgPC CENTERED VALID lFechaPC 

		If nOpcaoPC == 1
			U_selPCx()

			For i := 1 to Len(oMSNewGe1:aCols)
				U_trfPC(i)
			Next		   	

			u_calcRES()
		Endif	
	Endif
Return(nil)





User Function itXML()           
	Local cQry
	Local oDlgPC 
	Local Group
	Local oButton1
	Local lSC7 		:= .F.  
	Local aButtons := {}	
	Local aCabPC	:= {" ","Pedido","Item","Produto","Descr","UM","Quant","Qtd Entregue","Saldo","Valor","Total","Data","Almox","OBS","CC","Cod Fornecedor"}
	Local lFechaPC := .F.
	Local nOpcaoPC	:= 0
	Local cVerPC           

	Private _nat
	Private aPC		:= {}
	Private oBrwPC                                                        
	Private oOK		:= LoadBitmap(GetResources(),'BR_VERDE')
	Private oNO	  	:= LoadBitmap(GetResources(),'BR_VERMELHO')
	Private cNumC7	:= Space(6)       
	Private oNumC7    

	If Alltrim(aRegSEF[1,1]) == "" .And. Alltrim(aRegSEF[1,2]) == ""
		Aviso("Aviso","Não ha dados de importação. Importe o arquivo XML para selecionar PC.",{"Ok"})	
		Return()
	Endif

	If Alltrim(M->XA1_PC) == '2'
		Aviso("Aviso","Foi selecionada a opção '2-Sem pedido de Compras.",{"Ok"})	
		Return()
	Endif

	If u_filIT()
		DEFINE MSDIALOG oDlgPC TITLE "Pedidos de Compra" FROM 000,000 TO 400,700 PIXEL  

		Aadd( aButtons, {"HISTORIC", {|| u_ConsPed(aPC[oBrwPC:nAt,02], aPC[oBrwPC:nAt,03],Substr(aPC[oBrwPC:nAt,04],1,15))}, "Consultar PC", "Consultar PC" , {|| .T.}} )

		EnchoiceBar(oDlgPC, {|| _nat := oMsNewGe1:nat, lFechaPC := .T.,nOpcaoPC := 1,oDlgPC:End()},{|| lFechaPC := .T.,nOpcaoPC := 0,oDlgPC:End()},,aButtons)	
		oBrwPC := TCBrowse():New(020,001,351,167,,aCabPC,{15,30,15,30,150,20,30,30,30,30,30,30,20,50,20},oDlgPC,,,,,{|| marcIT()},{|| },,,,,,.F.,,.T.,,.F.,,,)
		oBrwPC:SetArray(aPC) 
		oBrwPC:bLine := {||{If (Alltrim(aPC[oBrwPC:nAt,01])=="X",oOK,oNO),aPC[oBrwPC:nAt,02],aPC[oBrwPC:nAt,03],Substr(aPC[oBrwPC:nAt,04],1,15),Substr(aPC[oBrwPC:nAt,05],1,150),aPC[oBrwPC:nAt,06],Transform(aPC[oBrwPC:nAt,07],"@E 9999,999,999.99"),Transform(aPC[oBrwPC:nAt,08],"@E 9999,999,999.99"),Transform(aPC[oBrwPC:nAt,09],"@E 9999,999,999.99"),Transform(aPC[oBrwPC:nAt,10],"@E 9999,999,999.99"),Transform(aPC[oBrwPC:nAt,11],"@E 9999,999,999.99"),DtoC(StoD(aPC[oBrwPC:nAt,12])),aPC[oBrwPC:nAt,13],Substr(aPC[oBrwPC:nAt,14],1,50),aPC[oBrwPC:nAt,15],Substr(aPC[oBrwPC:nAt,16],1,50)}}  
		oBrwPC:align:= CONTROL_ALIGN_ALLCLIENT
		ACTIVATE MSDIALOG oDlgPC CENTERED VALID lFechaPC 

		If nOpcaoPC == 1
			U_selPCx()
			U_trfPC(_nat)
			U_calcRES()
		Endif	      
	Endif
Return(nil)





User Function selPCx()
	cVerPC := ""

	For i := 1 to Len(aPC) 
		If Alltrim(aPC[i,01]) == "X"
			cVerPC := "'" + aPC[i,02] + "'"
		Endif
	Next                                

	If Alltrim(cVerPC) == ""
		aAdd(aRegSEF,{"Pedido de Compra","Nenhum pedido selecionado!"})
		oBrwSEF:Refresh()
		oFolder:SetOption(02)
		Return()
	Endif
Return(nil)





User Function trfPC(nLinha)
	cProduto	:=	PadR(oMSNewGe1:aCols[nLinha,2],TamSx3("A5_CODPRF")[1])

	For k := 1 to Len(aPC) 
		If Alltrim(aPC[k,01]) == "X" .And. UPPER(Alltrim(aPC[k,16])) == UPPER(Alltrim(cProduto))
			If Alltrim(cNumPedido) == ""
				cNumPedido 	:= "'" + aPC[k,02] + "'"
				cSeqItem		:= aPC[k,03]
				aPC[k,01] 	:= "Y"								
			Endif
		Endif
	Next                                

	If Alltrim(cNumPedido) <> ""
		cProdAlub 	:= Space(15)
		cNomeAlub	:= (150)
		cPedido		:= Space(06)
		cItemAlub	:= Space(04)
		cUmAlub 		:= Space(02)
		cCCusto		:= Space(09)
		cConta		:= Space(20)	
		nQtdAlub		:= 0.00
		nVlrAlub		:= 0.00
		nDesAlub 	:= 0.00			
		nTotAlub		:= 0.00
		cAlmAlub  	:= Space(02)

		//Pesquisa Produtos x Fornecedor X Pedido de Compras
		cQry := ""
		cQry += "SELECT "																+ __cCRLF
		cQry += "   " + RetSQLName("SC7") + ".* "								+ __cCRLF
		cQry += "  ," + RetSQLName("SA5") + ".* "								+ __cCRLF
		cQry += "FROM " 																+ __cCRLF
		cQry += "   " + RetSQLName("SC7") + " " 					  			+ __cCRLF
		cQry += "  ," + RetSQLName("SA5") + " " 								+ __cCRLF
		cQry += "WHERE "											  					+ __cCRLF
		cQry += "   " 	+ RetSQLName("SC7") + ".D_E_L_E_T_<>'*' "	  		+ __cCRLF
		cQry += "   AND "	+ RetSQLName("SA5") + ".D_E_L_E_T_<>'*' "		+ __cCRLF
		cQry += "   AND C7_FILIAL = '"	+ xFilial("SC7") 	+ "' "		+ __cCRLF
		cQry += "   AND A5_FILIAL = '"	+ xFilial("SA5") 	+ "' "		+ __cCRLF
		cQry += "   AND C7_NUM IN  ("  	+ cNumPedido		+ ") "		+ __cCRLF
		cQry += "   AND C7_ITEM    ='" 	+ cSeqItem 			+ "' "		+ __cCRLF
		cQry += "   AND C7_FORNECE ='" 	+ M->XA1_CLIFOR 	+ "' "		+ __cCRLF
		cQry += "   AND C7_LOJA    ='" 	+ M->XA1_LOJA		+ "' "		+ __cCRLF
		cQry += "   AND A5_FORNECE = C7_FORNECE "								+ __cCRLF
		cQry += "   AND A5_LOJA = C7_LOJA "										+ __cCRLF
		cQry += "   AND A5_PRODUTO = C7_PRODUTO "					  			+ __cCRLF
		cQry += "   AND A5_CODPRF = '" + cProduto + "' "			  		+ __cCRLF
		cQry += "ORDER BY "															+ __cCRLF
		cQry += "   C7_NUM "															+ __cCRLF
		cQry += "   ,C7_ITEM"														+ __cCRLF

		cQry := ChangeQuery(cQry)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMPSC72",.T.,.T.)

		TMPSC72->(dbGoTop())

		If !TMPSC72->(EOF())
			cProdAlub 	:= TMPSC72->C7_PRODUTO                           
			cNomeAlub	:= Posicione("SB1",1,xFilial("SB1") + TMPSC72->C7_PRODUTO,"B1_DESC")
			cPedido		:= TMPSC72->C7_NUM                   
			cItemAlub	:= Right("0000" + TMPSC72->C7_ITEM,4)
			cUmAlub 		:= TMPSC72->C7_UM
			cCCusto		:= TMPSC72->C7_CC 
			cConta		:= TMPSC72->C7_CONTA 
			cAlmAlub  	:= TMPSC72->C7_LOCAL 
			nQtdAlub		:= oMSNewGe1:aCols[nLinha,04]
			nVlrAlub		:= oMSNewGe1:aCols[nLinha,05]
			nDesAlub		:= oMSNewGe1:aCols[nLinha,07]
			nTotAlub		:= oMSNewGe1:aCols[nLinha,08]
			nFreteAlu	:= oMSNewGe1:aCols[nLinha,06]	
			cCFOPAlu		:= oMSNewGe1:aCols[nLinha,09]	
			cClasAlu		:= oMSNewGe1:aCols[nLinha,10]

			If Left(Alltrim(cCFOPAlu),1) == "5"
				cCFOPAlu := Stuff(cCFOPAlu,1,1,"1")
			Else
				cCFOPAlu := Stuff(cCFOPAlu,1,1,"2")
			Endif               

			oMSNewGe1:aCols[nLinha,11] 	:= cPedido
			oMSNewGe1:aCols[nLinha,12] 	:= cItemAlub
			oMSNewGe1:aCols[nLinha,13] 	:= cProdAlub          //(PA56_CTSUP09)
			oMSNewGe1:aCols[nLinha,14] 	:= cNomeAlub          //RAFAEL ALMEIDA - SIGACORP (18/08/2016) - FOI AJUSTADO O PROGRAMA ESTA GRAVANDO MESMA INFOMAÇÃO DO XML NOS CAMPOS DE INFOMAÇÕES DO PEDIDOS 
			oMSNewGe1:aCols[nLinha,15] 	:= (TMPSC72->C7_QUANT - TMPSC72->C7_QUJE - TMPSC72->C7_QTDACLA)  //nQtdAlub - AJUSTADO
			oMSNewGe1:aCols[nLinha,16] 	:= cUmAlub
			oMSNewGe1:aCols[nLinha,17] 	:= TMPSC72->C7_PRECO  //nVlrAlub - AJUSTADO
			oMSNewGe1:aCols[nLinha,18] 	:= TMPSC72->C7_VLDESC //nDesAlub - AJUSTADO
			oMSNewGe1:aCols[nLinha,19] 	:= TMPSC72->C7_TOTAL  //nTotAlub - AJUSTADO
			oMSNewGe1:aCols[nLinha,20]	:= nFreteAlu
			oMSNewGe1:aCols[nLinha,21]	:= cCFOPAlu
			oMSNewGe1:aCols[nLinha,22]	:= cClasAlu
			oMSNewGe1:aCols[nLinha,23] 	:= cAlmAlub
			oMSNewGe1:aCols[nLinha,24] 	:= cCCusto
			oMSNewGe1:aCols[nLinha,25] 	:= cConta
			If cCCusto = "999"		                    //RAFAEL ALMEIDA - (SIGACORP)  03/11/2015 PREENCHER O CAMPO DE APLICAÇÃO CO
				oMSNewGe1:aCols[nLinha,26] 	:= "E"
			Else
				oMSNewGe1:aCols[nLinha,26] 	:= "D"			
			EndIf                
			Aadd(_axItXML,(TMPSC72->C7_QUANT - TMPSC72->C7_QUJE - TMPSC72->C7_QTDACLA))     //RAFAEL ALMEIDA - SIGACORP (30/11/2016) MELHORIA
		Endif

		TMPSC72->(dbCloseArea())

		cNumPedido := Space(6)
	Endif
Return(nil)





User Function filPC(nOpcao)
	Local cQry

	cQry := ""    
	cQry += "SELECT "																				+ __cCRLF
	cQry += "   C7_NUM PEDIDO "																+ __cCRLF
	cQry += "   ,C7_ITEM ITEM "																+ __cCRLF
	cQry += "   ,C7_PRODUTO PRODUTO "														+ __cCRLF
	cQry += "   ,B1_DESC DESCR "																+ __cCRLF
	cQry += "   ,B1_UM UM "	  																	+ __cCRLF
	cQry += "   ,C7_QUANT QUANT "																+ __cCRLF
	cQry += "   ,C7_QUJE ENTREGUE "															+ __cCRLF
	cQry += "   ,(C7_QUANT-C7_QUJE-C7_QTDACLA) SALDO "									+ __cCRLF
	cQry += "   ,C7_PRECO PRECO "																+ __cCRLF
	cQry += "   ,C7_TOTAL TOTAL "	 															+ __cCRLF
	cQry += "   ,C7_DATPRF DATPRF "															+ __cCRLF
	cQry += "   ,C7_LOCAL ALMOX "																+ __cCRLF
	cQry += "   ,C7_OBS OBS "																	+ __cCRLF
	cQry += "   ,C7_CC CC "																		+ __cCRLF
	cQry += "   ,C7_TES TES "																	+ __cCRLF
	cQry += "   ,SC7.R_E_C_N_O_ REG "														+ __cCRLF
	cQry += "FROM " 																				+ __cCRLF
	cQry += "   " + RetSqlName("SC7") + " SC7 WITH (NOLOCK) "						+ __cCRLF
	cQry += "   LEFT OUTER JOIN " + RetSqlName("SB1") + " SB1 WITH (NOLOCK) "	+ __cCRLF
	cQry += "   ON (SB1.D_E_L_E_T_ <> '*') "												+ __cCRLF
	cQry += "   AND (SB1.B1_FILIAL = '" + xFilial("SB1") + "') 	"					+ __cCRLF
	cQry += "   AND (C7_PRODUTO = B1_COD) "												+ __cCRLF
	cQry += "WHERE "																				+ __cCRLF
	cQry += "   (C7_FILIAL = '" + xFilial("SC7") + "') "								+ __cCRLF
	cQry += "   AND (SC7.D_E_L_E_T_ <> '*') "												+ __cCRLF
	cQry += "   AND (C7_QUANT   > C7_QUJE)  "												+ __cCRLF
	cQry += "   AND (C7_RESIDUO = '')  "													+ __cCRLF
	cQry += "   AND (C7_ENCER   = '') "														+ __cCRLF
	cQry += "   AND (C7_FORNECE = '" + M->XA1_CLIFOR + "') "							+ __cCRLF
	cQry += "   AND (C7_LOJA    = '" + M->XA1_LOJA + "') "							+ __cCRLF

	If Alltrim(cNumC7) <> ""
		cQry += "   AND (C7_NUM    = '" + cNumC7 + "') "								+ __cCRLF
	Endif

	cQry += "ORDER "																				+ __cCRLF
	cQry += "   BY C7_NUM "																		+ __cCRLF
	cQry += "   ,C7_ITEM "																		+ __cCRLF
	cQry += "   ,C7_PRODUTO "																	+ __cCRLF

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMPSC7",.T.,.T.)
	TcSetField("TMPSC7","C7_DTPRV","D",8,0)

	dbSelectArea("TMPSC7")
	TMPSC7->(dbGotop())

	If !TMPSC7->(EOF())  
		aPC	:= {}

		While !TMPSC7->(EOF())
			aAdd(aPC,{" ",TMPSC7->PEDIDO,TMPSC7->ITEM,Substr(TMPSC7->PRODUTO,1,15),Substr(TMPSC7->DESCR,1,150),TMPSC7->UM,TMPSC7->QUANT,TMPSC7->ENTREGUE,TMPSC7->SALDO,TMPSC7->PRECO,TMPSC7->TOTAL,TMPSC7->DATPRF,TMPSC7->ALMOX,TMPSC7->OBS,TMPSC7->CC,Substr(Posicione("SA5",1,xFilial("SA5")+ M->XA1_CLIFOR + M->XA1_LOJA + Substr(TMPSC7->PRODUTO,1,15),"A5_CODPRF"),1,50)})
			TMPSC7->(dbSkip())
		Enddo

		If nOpcao == 2
			oBrwPC:SetArray(aPC) 
			oBrwPC:bLine := {||{If (Alltrim(aPC[oBrwPC:nAt,01])=="X",oOK,oNO),aPC[oBrwPC:nAt,02],aPC[oBrwPC:nAt,03],Substr(aPC[oBrwPC:nAt,04],1,15),Substr(aPC[oBrwPC:nAt,05],1,150),aPC[oBrwPC:nAt,06],Transform(aPC[oBrwPC:nAt,07],"@E 9999,999,999.99"),Transform(aPC[oBrwPC:nAt,08],"@E 9999,999,999.99"),Transform(aPC[oBrwPC:nAt,09],"@E 9999,999,999.99"),Transform(aPC[oBrwPC:nAt,10],"@E 9999,999,999.99"),Transform(aPC[oBrwPC:nAt,11],"@E 9999,999,999.99"),DtoC(StoD(aPC[oBrwPC:nAt,12])),aPC[oBrwPC:nAt,13],Substr(aPC[oBrwPC:nAt,14],1,50),aPC[oBrwPC:nAt,15],Substr(aPC[oBrwPC:nAt,16],1,50)}}  
		Endif
	Else 
		Aviso("Aviso","Pedido(s) de compra não encontrado(s) ou encerrado(s).",{"Ok"})
		TMPSC7->(dbCloseArea())				
		Return(.F.)
	Endif

	TMPSC7->(dbCloseArea())				
Return(.t.)





User Function filIT()
	Local cQry

	cQry := ""
	cQry += "SELECT "																					+ __cCRLF
	cQry += "	C7_NUM PEDIDO "																	+ __cCRLF
	cQry += "	,C7_ITEM ITEM "																	+ __cCRLF
	cQry += "	,C7_PRODUTO PRODUTO "															+ __cCRLF
	cQry += "	,B1_DESC DESCR "																	+ __cCRLF
	cQry += "	,B1_UM UM "																			+ __cCRLF
	cQry += "	,C7_QUANT QUANT "																	+ __cCRLF
	cQry += "	,C7_QUJE ENTREGUE "																+ __cCRLF
	cQry += "	,(C7_QUANT-C7_QUJE-C7_QTDACLA) SALDO "										+ __cCRLF
	cQry += "	,C7_PRECO PRECO "																	+ __cCRLF
	cQry += "	,C7_TOTAL TOTAL "																	+ __cCRLF
	cQry += "	,C7_DATPRF DATPRF "																+ __cCRLF
	cQry += "	,C7_LOCAL ALMOX "																	+ __cCRLF
	cQry += "	,C7_OBS OBS "																		+ __cCRLF
	cQry += "	,C7_CC CC "																			+ __cCRLF
	cQry += "	,C7_TES TES "																		+ __cCRLF
	cQry += "	,SC7.R_E_C_N_O_ REG "															+ __cCRLF
	cQry += "FROM "																					+ __cCRLF
	cQry += "	" 	+ retSQLName("SC7") + " SC7 "												+ __cCRLF
	cQry += "	,"	+ retSQLName("SB1") + " SB1 "												+ __cCRLF
	cQry += "	," 	+ retSQLName("SA5") + " SA5 "											+ __cCRLF
	cQry += "WHERE "																					+ __cCRLF
	cQry += "	(C7_FILIAL = '" 		+ xFilial("SC7") + "') "							+ __cCRLF
	cQry += "	AND (B1_FILIAL = '"	+ xFilial("SB1") + "') "							+ __cCRLF
	cQry += "	AND (A5_FILIAL = '" 	+ xFilial("SA5") + "') "							+ __cCRLF
	cQry += "	AND (SC7.D_E_L_E_T_ <> '*') "													+ __cCRLF
	cQry += "	AND (SB1.D_E_L_E_T_ <> '*') "													+ __cCRLF
	cQry += "	AND (SA5.D_E_L_E_T_ <> '*') "													+ __cCRLF
	cQry += "	AND (C7_QUANT   > C7_QUJE) "													+ __cCRLF
	cQry += "	AND (C7_RESIDUO = '') "															+ __cCRLF
	cQry += "	AND (C7_ENCER   = '') "															+ __cCRLF
	cQry += "	AND (C7_FORNECE = '" + M->XA1_CLIFOR + "') "								+ __cCRLF
	cQry += "	AND (C7_LOJA    = '" + M->XA1_LOJA + "') "								+ __cCRLF
	cQry += "	AND (C7_PRODUTO = B1_COD) "													+ __cCRLF
	cQry += "	AND (C7_PRODUTO = A5_PRODUTO) "												+ __cCRLF
	cQry += "	AND (C7_FORNECE = A5_FORNECE) "												+ __cCRLF
	cQry += "	AND (C7_LOJA    = A5_LOJA) "													+ __cCRLF
	cQry += "	AND (SA5.A5_CODPRF='" + oMSNewGe1:acols[oMSNewGe1:nat,2] + "') "	+ __cCRLF
	cQry += "ORDER "																					+ __cCRLF
	cQry += "	BY C7_NUM "																			+ __cCRLF
	cQry += "	,C7_ITEM "																			+ __cCRLF
	cQry += "	,C7_PRODUTO "																		+ __cCRLF

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMPSC7",.T.,.T.)
	TcSetField("TMPSC7","C7_DTPRV","D",8,0)

	dbSelectArea("TMPSC7")
	TMPSC7->(dbGotop())

	If !TMPSC7->(EOF())  
		aPC	:= {}

		While !TMPSC7->(EOF())
			aAdd(aPC,{" ",TMPSC7->PEDIDO,TMPSC7->ITEM,Substr(TMPSC7->PRODUTO,1,15),Substr(TMPSC7->DESCR,1,150),TMPSC7->UM,TMPSC7->QUANT,TMPSC7->ENTREGUE,TMPSC7->SALDO,TMPSC7->PRECO,TMPSC7->TOTAL,TMPSC7->DATPRF,TMPSC7->ALMOX,TMPSC7->OBS,TMPSC7->CC,Substr(Posicione("SA5",1,xFilial("SA5")+ M->XA1_CLIFOR + M->XA1_LOJA + Substr(TMPSC7->PRODUTO,1,15),"A5_CODPRF"),1,50)})
			TMPSC7->(dbSkip())
		Enddo
	Else 
		Aviso("Aviso","Pedido(s) de compra não encontrado(s) ou encerrado(s).",{"Ok"})
		TMPSC7->(dbCloseArea())				
		Return(.F.)
	Endif

	TMPSC7->(dbCloseArea())				
Return(.T.)





User Function calcRES()       
	Local cArea := GetArea() 
	Local nGTQTXML := 0.00
	Local nGTVUXML := 0.00
	Local nGTVTXML := 0.00

	Local nGTQTPC	:= 0.00
	Local nGTVUPC	:= 0.00
	Local nGTVTPC	:= 0.00

	Local nTotal := 0.00

	nTotal := Round(oMSNewGe1:acols[oMSNewGe1:nat,19],6)	/*Total Prenota(XA2_VLTPN)*/

	For i:= 1 to Len(oMSNewGe1:aCols)
		nGTQTXML += oMSNewGe1:aCols[i,4]
		nGTVUXML += oMSNewGe1:aCols[i,5]
		nGTVTXML += oMSNewGe1:aCols[i,8]

		nGTQTPC	+= oMSNewGe1:aCols[i,15]
		nGTVUPC	+= oMSNewGe1:aCols[i,17]
		nGTVTPC	+= oMSNewGe1:aCols[i,19]
	Next

	aXML[1,2] 	:= nGTQTXML
	aXML[2,2] 	:= nGTVUXML
	aXML[3,2] 	:= nGTVTXML

	aPN[1,2] 	:= nGTQTPC
	aPN[2,2] 	:= nGTVUPC
	aPN[3,2] 	:= nGTVTPC

	aNF[1,2] 	:= nFrete
	aNF[2,2] 	:= nDesct
	aNF[3,2] 	:= nTotNF

	oBrwXML:Refresh()                                             
	oBrwPN:Refresh()                                             
	oBrwNF:Refresh()                                             

	RestArea(cArea)
Return(nTotal)





Static Function marcPC()                                        
	Local lContinua	:= .F.                             
	Local lPXF			:= .F.                     

	Private lMarcar	:= .F.        

	//Efetua amarracao Produtos X Fornecedor
	If Alltrim(aPC[oBrwPC:nAt,16]) == ""
		If MsgYesNo("Não há amarração Produto X Fornecedor para o Item selecionado. Deseja Efetuar a amarração?")
			lPXF := .T.
		Else
			Return()
		Endif

		If lPXF
			grvPXF()
		Endif  
	Else
		lMarcar := .T. 
	Endif

	If lMarcar
		If aPC[oBrwPC:nAt,1] == "X"
			aPC[oBrwPC:nAt,1] := " "
			Return()
		Endif

		If aPC[oBrwPC:nAt,1] == " "
			aPC[oBrwPC:nAt,1] := "X"
			Return()
		Endif
	Endif
Return()        





Static Function marcIT()                                        
	Local lContinua	:= .F.                             
	Local lPXF			:= .F.                     

	Private lMarcar	:= .F.        

	//Efetua amarracao Produtos X Fornecedor
	If Alltrim(aPC[oBrwPC:nAt,16]) == ""
		If MsgYesNo("Não há amarração Produto X Fornecedor para o Item selecionado. Deseja Efetuar a amarração?")
			lPXF := .T.
		Else
			Return()
		Endif

		If lPXF
			grvPXF()
		Endif  
	Else
		lMarcar := .T. 
	Endif

	If lMarcar
		For i:= 1 to Len(aPC)
			aPC[i,1] := " "
		Next

		aPC[oBrwPC:nAt,1] := "X"
		oBrwPC:Refresh()
	Endif
Return()        





Static Function grvPXF()
	Local oDlgAjPXF
	Local oItem		 
	Local oCodFor   
	Local oLojFor   
	Local oNomFor   
	Local oCodProd  
	Local oNomProd  
	Local oPrdfor   
	Local oSay1		
	Local oSay2	   
	Local oSay3	   
	Local oSay4	   
	Local oSay5			
	Local oSay6			
	Local oSay7			
	Local oButton1	   
	Local oButton2	   
	Local cItem		:= aPC[oBrwPC:nAt,03]
	Local cCodFor    	:= M->XA1_CLIFOR
	Local cLojFor    	:= M->XA1_LOJA
	Local cNomFor		:= M->XA1_NOMFOR
	Local cCodProd	:= aPC[oBrwPC:nAt,04]
	Local cNomProd   	:= aPC[oBrwPC:nAt,05]
	Local cPrdfor 	:= Space(50)
	Local nOpca		:= 0

	DEFINE MSDIALOG oDlgAjPXF TITLE "Produtos X Fornecedor" FROM 000, 000  TO 300, 550 COLORS 0, 16777215 PIXEL
	@ 012, 016 SAY oSay1 PROMPT "Item:" 			SIZE 025, 007 OF oDlgAjPXF	COLORS 0, 16777215 	PIXEL
	@ 028, 016 SAY oSay2 PROMPT "Cód. Fornec:" 	SIZE 030, 007 OF oDlgAjPXF 	COLORS 0, 16777215 	PIXEL
	@ 044, 016 SAY oSay3 PROMPT "Loja:" 			SIZE 033, 007 OF oDlgAjPXF 	COLORS 0, 16777215 	PIXEL
	@ 060, 016 SAY oSay4 PROMPT "Nome Fornec:"	SIZE 033, 007 OF oDlgAjPXF 	COLORS 0, 16777215 	PIXEL
	@ 076, 016 SAY oSay5 PROMPT "Produto:"			SIZE 036, 007 OF oDlgAjPXF 	COLORS 0, 16777215 	PIXEL
	@ 092, 016 SAY oSay6 PROMPT "Descricao:"		SIZE 036, 007 OF oDlgAjPXF 	COLORS 0, 16777215 	PIXEL
	@ 124, 016 SAY oSay7 PROMPT "Prod X For.:"	SIZE 046, 007 OF oDlgAjPXF 	COLORS 0, 16777215	PIXEL

	@ 012, 052 MSGET oItem 		VAR cItem 		SIZE 026, 010 OF oDlgAjPXF		COLORS 0, 16777215	READONLY	PIXEL
	@ 028, 052 MSGET oCodFor	VAR cCodFor		SIZE 026, 010 OF oDlgAjPXF 	COLORS 0, 16777215 	READONLY PIXEL
	@ 044, 052 MSGET oLojFor 	VAR cLojFor		SIZE 015, 010 OF oDlgAjPXF 	COLORS 0, 16777215 	READONLY PIXEL
	@ 060, 052 MSGET oNomFor 	VAR cNomFor 	SIZE 168, 010 OF oDlgAjPXF 	COLORS 0, 16777215 	READONLY PIXEL
	@ 076, 052 MSGET oCodProd 	VAR cCodProd	SIZE 080, 010 OF oDlgAjPXF 	COLORS 0, 16777215 	READONLY PIXEL
	@ 092, 052 MSGET oNomProd 	VAR cNomProd 	SIZE 168, 010 OF oDlgAjPXF 	COLORS 0, 16777215 	READONLY PIXEL
	@ 124, 052 MSGET oPrdfor 	VAR cPrdfor 	SIZE 080, 010 OF oDlgAjPXF 	COLORS 0, 16777215 		  		PIXEL

	@ 012, 228 BUTTON oButton1 PROMPT "&Ok" 			SIZE 037,012 OF oDlgAjPXF ACTION {|| nOpca:= 1,oDlgAjPXF:End()}	PIXEL
	@ 026, 228 BUTTON oButton2 PROMPT "&Cancelar"	SIZE 037,012 OF oDlgAjPXF ACTION {|| nOpca:= 2,oDlgAjPXF:End()}	PIXEL
	ACTIVATE MSDIALOG oDlgAjPXF CENTERED

	lMarcar := .F.

	If nOpca == 1       
		dbSelectArea("SA5")
		SA5->(dbSetOrder(1))
		SA5->(dbGoTop())          

		If Alltrim(cPrdfor) <> ""
			lMarcar := .T.

			If !dbSeek(xFilial("SA5") + cCodFor + cLojFor + cCodProd)
				While !RecLock("SA5",.T.);EndDo 		 
				SA5->A5_FILIAL 	:= xFilial("SA5")
				SA5->A5_FORNECE	:= cCodFor
				SA5->A5_LOJA 		:= cLojFor
				SA5->A5_NOMEFOR 	:= cNomFor
				SA5->A5_PRODUTO 	:= cCodProd
				SA5->A5_NOMPROD 	:= Posicione("SB1",1,xFilial("SB1") + cCodProd,"B1_DESC")
				SA5->A5_CODPRF  	:= cPrdfor
				SA5->(MsUnlock())
				SA5->(dbCommitAll())
			Else
				RecLock("SA5",.F.)
				SA5->A5_CODPRF  	:= cPrdfor
				SA5->(MsUnlock())
				SA5->(dbCommitAll())
			Endif

			aPC[oBrwPC:nAt,16] := cPrdfor
			oBrwPC:Refresh()
		Endif
	Endif	
Return()        





User Function manWFL(_cOrig)
	Local _aAreaR := GetArea()
	Local nTamLin
	Local cLin
	Local cCpo	

	Private cQry    
	Private oDlg
	Private oGeraTxt	
	Private cArqTxt
	Private nHdl                       
	Private cBody           
	Private cBodySTY           
	Private cBodyCAB           
	Private cBodyBOD           
	Private cBodyROD
	Private cEntreg
	Private cPedido
	Private cCCusto
	Private cEOL := "CHR(13)+CHR(10)"  

	//	-- RAFAEL ALMEIDA - SIGACORP (08/10/2015)
	// INICIO -  Variaveis adicionadas para atender workflow direto da rotina MATA140 - Pre Nota
	Private oGet1
	Private cGet1 := "c:\temp                   "
	Private oGroup1
	Private oGroup2
	Private oSay1
	Private oSButton1
	Private oSButton2
	Private lOk:= .f.
	Private oDlg2
	// FIM 

	// RAFAEL ALMEIDA - SIGACORP (08/10/2015)
	//INICIO - Customização que cria MSDIALOG para rotina da PreNota

	If _cOrig == "MATA140"	
		DEFINE MSDIALOG oDlg2 TITLE "Parametros - MATA140" FROM 000, 000  TO 270, 450 COLORS 0, 16777215 PIXEL

		@ 002, 000 GROUP oGroup1 TO 086, 224 OF oDlg2 COLOR 0, 16777215 PIXEL
		@ 087, 004 GROUP oGroup2 TO 128, 147 OF oDlg2 COLOR 0, 16777215 PIXEL
		@ 014, 005 SAY oSay1 PROMPT "Gerar arquivo em?" SIZE 047, 008 OF oDlg2 COLORS 0, 16777215 PIXEL
		@ 012, 070 MSGET oGet1 VAR cGet1 SIZE 115, 012 OF oDlg2 COLORS 0, 16777215 PIXEL
		DEFINE SBUTTON oSButton1 FROM 090, 152 TYPE 01  ENABLE OF oDlg2  ACTION ( lOk := .t.,oDlg2:End())
		DEFINE SBUTTON oSButton2 FROM 090, 190 TYPE 02  ENABLE OF oDlg2  ACTION ( lOk := .f.,oDlg2:End())

		ACTIVATE MSDIALOG oDlg2 CENTERED	
		If !lOk
			Return()
		EndIf	
	Else
		If !Pergunte("MANWFL",.T.)
			Return()
		EndIf
	EndIf
	// FIM - RAFAEL ALMEIDA - SIGACORP (08/10/2015)

	/* - COMENTADO PELO ANALISTA RAFAEL ALMEIDA - SIGACORP (08/10/2015)	
	//	If Pergunte("MANWFL",.T.)
	*/

	//INICIO DA GRAVAÇÃO DO SEQUENCIAL DO WORKFLOW
	_cCC		:= " "
	_cEntreg	:= " "
	_cPedido	:= " "

	cCodEmp := FWCodEmp()

	cTabXA2 := 'XA2'+cCodEmp+'0'

	cQryXA2 := ""
	cQryXA2 += "SELECT R_E_C_N_O_,XA2_PEDIDO,XA2_CCPN,XA2_ENTREG,XA2_SEQ_WF FROM " + cTabXA2 + " XA2 " + __cCRLF
	cQryXA2 += " WHERE XA2_FILIAL='" + xFilial("XA2")  + "' " + __cCRLF
	cQryXA2 += "   AND XA2_NFISCA='" + SF1->F1_DOC     + "' " + __cCRLF
	cQryXA2 += "   AND XA2_SERIE ='" + SF1->F1_SERIE   + "' " + __cCRLF
	cQryXA2 += "   AND XA2_CLIFOR='" + SF1->F1_FORNECE + "' " + __cCRLF
	cQryXA2 += "   AND XA2_LOJA  ='" + SF1->F1_LOJA    + "' " + __cCRLF
	cQryXA2 += "   AND " + RetSQLName("XA2") + ".D_E_L_E_T_<>'*' " + __cCRLF
	cQryXA2 += " ORDER BY 2,3,4 " + __cCRLF

	cQryXA2 := ChangeQuery(cQryXA2)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryXA2),"QRYXA2",.T.,.T.)

	QRYXA2->(dbGoTop())

	While !QRYXA2->(EOF())

		If Empty(QRYXA2->XA2_SEQ_WF)
			If (Alltrim(_cEntreg) <> Alltrim(QRYXA2->XA2_ENTREG)) .Or. (Alltrim(_cPedido) <> Alltrim(QRYXA2->XA2_PEDIDO)) .Or. (Alltrim(_cCC) <> Alltrim(QRYXA2->XA2_CCPN))
				_cEntreg := QRYXA2->XA2_ENTREG
				_cPedido := QRYXA2->XA2_PEDIDO
				_cCC		:= QRYXA2->XA2_CCPN
				// Evandro Lima (21/07/2017-Inovativa) - Captura do controle de sequencial do WorkFlow
				cSeq_WF := GetSXENum("XA2","XA2_SEQ_WF")
				ConfirmSX8() 		// Evandro Lima (25/07/2017-Inovativa) - Confirmação do código sequencial
			EndIf

			dbSelectArea("XA2")
			XA2->(dbGoto(QRYXA2->R_E_C_N_O_))

			RecLock("XA2",.F.) 		 
			XA2->XA2_SEQ_WF	:= cSeq_WF
			XA2->XA2_NROVIA	:= '00'
			XA2->(MsUnlock())
			XA2->(dbCommitAll())
		EndIf
		QRYXA2->(DbSkip())
	EndDo

	QRYXA2->(dbClosearea())

	//FIM DA GRAVAÇÃO DO SEQUENCIAL DO WORKFLOW


	atuQRY(_cOrig)
	cQry := ChangeQuery(cQry)	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMPXA2",.T.,.T.)  

	dbSelectarea("TMPXA2")

	TMPXA2->(dbGotop())

	// RAFAEL ALMEIDA - SIGACORP (08/10/2015)
	//INICIO - Customização que cria ARQUIVO html temporario
	If _cOrig == "MATA140"
		cArqTxt := Alltrim(cGet1) + "\" + __cUSERID + ".html"
		nHdl    := fCreate(cArqTxt)
	Else
		cArqTxt := Alltrim(MV_PAR01) + "\" + __cUSERID + ".html"
		nHdl    := fCreate(cArqTxt)		
	EndIf
	// FIM - RAFAEL ALMEIDA - SIGACORP (08/10/2015)


	/* - COMENTADO PELO ANALISTA RAFAEL ALMEIDA - SIGACORP (08/10/2015)	
	//		cArqTxt := Alltrim(MV_PAR01) + "\" + __cUSERID + ".html"
	//		nHdl    := fCreate(cArqTxt)
	*/


	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif	  

	If nHdl == -1
		MsgAlert("O arquivo de nome " + cArqTxt + " nao pode ser executado!","Atencao!")
		TMPXA2->(dbClosearea())
		Return
	Endif

	If !TMPXA2->(EOF())          
		cEntreg := Space(6)
		cPedido := Space(6)
		cCCusto := Space(9)

		nTamLin := 30000
		cLin    := Space(nTamLin) + cEOL

		cBody := ""
		emlSTY()
		cLin := cBodySTY

		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo!","Atencao!")
				TMPXA2->(dbClosearea())
				Return
			Endif
		Endif

		Do While !TMPXA2->(Eof()) 
			If (Alltrim(cEntreg) <> Alltrim(TMPXA2->XA2_ENTREG)) .Or. (Alltrim(cPedido) <> Alltrim(TMPXA2->XA2_PEDIDO)) .Or. (Alltrim(cCCusto) <> Alltrim(TMPXA2->XA2_CCPN))
				cEntreg := TMPXA2->XA2_ENTREG
				cPedido := TMPXA2->XA2_PEDIDO
				cCCusto := TMPXA2->XA2_CCPN

				emlCAB(_cOrig)
				cLin := cBodyCAB

				If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
					If !MsgAlert("Ocorreu um erro na gravacao do arquivo!","Atencao!")
						TMPXA2->(dbClosearea())
						Return
					Endif
				Endif
			Endif	 

			emlBOD()
			cLin := cBodyBOD

			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo!","Atencao!")
					TMPXA2->(dbClosearea())
					Return
				Endif
			Endif

			TMPXA2->(dbSkip())	

			If (Alltrim(cEntreg) <> Alltrim(TMPXA2->XA2_ENTREG)) .Or. (Alltrim(cPedido) <> Alltrim(TMPXA2->XA2_PEDIDO)) .Or. (Alltrim(cCCusto) <> Alltrim(TMPXA2->XA2_CCPN))
				emlROD()
				cLin := cBodyROD

				If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
					If !MsgAlert("Ocorreu um erro na gravacao do arquivo!","Atencao!")
						TMPXA2->(dbClosearea())
						Return
					Endif
				Endif
			Endif
		Enddo
	Endif

	TMPXA2->(dbClosearea())	 
	fClose(nHdl)            

	DEFINE DIALOG oDlg TITLE "Workflow de Entrega" FROM 000,000 TO 570,800 PIXEL
	oWebEngine := TWebEngine():New(oDlg, 0, 0, 403, 270,cArqTxt, )
	
	//oTIBrowser := TIBrowser():New(0,0,403,270,cArqTxt,oDlg)
	//		  	oTIBrowser := TIBrowser():New(0,0,403,270,C:\temp\000000.html",oDlg)

	TButton():New(272,250,"Enviar"	 ,oDlg,{|| envWFL(_cOrig)}	   ,040,010,,,.F.,.T.,.F.,,.F.,,,.F.)
	TButton():New(272,302,"Imprimir" ,oDlg,{|| oWebEngine:PrintPDF()} ,040,010,,,.F.,.T.,.F.,,.F.,,,.F.)  //Correção de método. Wagno Sousa em 20191205
	TButton():New(272,354,"Fechar"	 ,oDlg,{|| oDlg:End()}		   ,040,010,,,.F.,.T.,.F.,,.F.,,,.F.)
	ACTIVATE DIALOG oDlg CENTERED 	

	//COMENTADO PELO ANALISTA RAFAEL ALMEIDA - SIGACORP (08/10/2015) POIS HOUVE ALTERAÇÃO NA VALIDAÇÃO If Pergunte("MANWFL",.T.)
	//	Endif

	RestArea(_aAreaR)
Return(nil)

Static Function envWFL(_cOrig)
	Local lOk

	Private cMailConta	:= ""
	Private cMailServer	:= ""
	Private cMailSenha	:=	""
	Private cEmailto		:= ""
	Private cTit
	Private cBody           
	Private cBodySTY           
	Private cBodyCAB           
	Private cBodyBOD           
	Private cBodyROD
	Private cEntreg
	Private cPedido
	Private cCCusto

	cMailConta	:= "workflow@alubar.net"
	cMailServer	:= "srv2mail.alubar.net"
	cMailSenha	:= "@lub@r123#siga"
	//	cEmailto		:= "ewerton.carreira@alubar.net"
	cEmailto		:= ""       

	atuQRY(_cOrig)
	cQry := ChangeQuery(cQry)	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMPXA2",.T.,.T.)  

	dbSelectarea("TMPXA2")
	TMPXA2->(dbGotop())			                     

	If !TMPXA2->(EOF())
		cEntreg 	:= Space(6)
		cPedido 	:= Space(6)
		cCCusto 	:= Space(9) 
		cTit 		:= "AVISO DE RECEBIMENTO DE MATERIAIS" 

		cBody := ""

		Do While !TMPXA2->(Eof()) 
			emlSTY()
			cBody := Alltrim(cBody) + Alltrim(cBodySTY)

			If (Alltrim(cEntreg) <> Alltrim(TMPXA2->XA2_ENTREG)) .Or. (Alltrim(cPedido) <> Alltrim(TMPXA2->XA2_PEDIDO)) .Or. (Alltrim(cCCusto) <> Alltrim(TMPXA2->XA2_CCPN))
				cEntreg := TMPXA2->XA2_ENTREG
				cPedido := TMPXA2->XA2_PEDIDO
				cCCusto := TMPXA2->XA2_CCPN

				emlCAB(_cOrig)
				cBody := Alltrim(cBody) + Alltrim(cBodyCAB)
			Endif	 

			emlBOD()
			cBody := Alltrim(cBody) + Alltrim(cBodyBOD)

			cEmailto := Alltrim(Posicione("XA6",1,xFilial("XA6") + TMPXA2->XA2_ENTREG,"XA6_EMAIL"))

			//Evandro Lima(27/07/2017-Inovativa) - Variáveis usadas na atualização do número de vias abaixo
			cXA2_Item   := TMPXA2->XA2_ITEM
			cXA2_NFisca := TMPXA2->XA2_NFISCA
			cXA2_Serie  := TMPXA2->XA2_SERIE
			cXA2_CliFor := TMPXA2->XA2_CLIFOR
			cXA2_Loja   := TMPXA2->XA2_LOJA

			TMPXA2->(dbSkip())	

			If (Alltrim(cEntreg) <> Alltrim(TMPXA2->XA2_ENTREG)) .Or. (Alltrim(cPedido) <> Alltrim(TMPXA2->XA2_PEDIDO)) .Or. (Alltrim(cCCusto) <> Alltrim(TMPXA2->XA2_CCPN))
				emlROD()

				cBody := Alltrim(cBody) + Alltrim(cBodyROD)

				CONNECT SMTP SERVER cMailserver ACCOUNT cMailconta PASSWORD cMailsenha RESULT lOk

				If lOk
					SEND MAIL FROM cMailconta TO cEmailto SUBJECT cTit BODY cBody RESULT lOk

					cBody := ""

					If !lOk
						GET MAIL ERROR CSMTPERROR
						MSGSTOP("Erro de envio" + CSMTPERROR)
					Else
						dbSelectarea("XA2")
						XA2->(dbSetorder(1))
						XA2->(dbGotop())

						If XA2->(dbSeek(xFilial("XA2") + cXA2_Item + cXA2_NFisca + cXA2_Serie + cXA2_CliFor + cXA2_Loja ))
							RecLock("XA2",.F.)
							XA2->XA2_NROVIA := StrZero(Val(XA2->XA2_NROVIA)+1,2,0)
							XA2->(MsUnlock())
							XA2->(dbCommitAll())
						Endif    

						MsgAlert('Email enviado com sucesso !!!')
					Endif   
				Endif
			Endif
		Enddo
	Endif

	TMPXA2->(dbClosearea())	                               
	oDlg:End()		
Return(nil)

Static Function emlSTY()
	cBodySTY := ""
	cBodySTY += "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"
	cBodySTY += "<html xmlns='http://www.w3.org/1999/xhtml'>"
	cBodySTY += "<head>"
	cBodySTY += "<meta content='text/html; charset=utf-8' http-equiv='Content-Type' />"
	cBodySTY += "<title>Sr</title>"
	cBodySTY += "<style type='text/css'>"
	cBodySTY += ".auto-style3 {"
	cBodySTY += "text-align: center;}"
	cBodySTY += ".auto-style4 {"
	cBodySTY += "font-family: Arial, Helvetica, sans-serif;"
	cBodySTY += "font-size: small;}"
	cBodySTY += ".auto-style6 {"
	cBodySTY += "font-size: x-small;"
	cBodySTY += "text-align: center;}"
	cBodySTY += ".auto-style7 {"
	cBodySTY += "font-size: x-small;"
	cBodySTY += "font-family: Arial, Helvetica, sans-serif;"
	cBodySTY += "text-align: center;}"
	cBodySTY += ".auto-style10 {"
	cBodySTY += "font-size: small;"
	cBodySTY += "font-family: Arial, Helvetica, sans-serif;"
	cBodySTY += "text-align: center;}"
	cBodySTY += ".auto-style11 {"
	cBodySTY += "font-size: small;}"
	cBodySTY += ".auto-style12 {"
	cBodySTY += "border: 3px solid #000000;}"
	cBodySTY += ".auto-style13 {"
	cBodySTY += "font-family: Arial, Helvetica, sans-serif;"
	cBodySTY += "font-size: x-small;}"
	cBodySTY += ".auto-style14 {"
	cBodySTY += "margin-left: 40px;}"
	cBodySTY += ".auto-style15 {"
	cBodySTY += "border: 1px solid #000000;"
	cBodySTY += "background-color: #FFFFCC;}"
	cBodySTY += ".auto-style16 {"
	cBodySTY += "font-size: small;"
	cBodySTY += "font-family: Arial, Helvetica, sans-serif;"
	cBodySTY += "text-align: center;"
	cBodySTY += "border: 1px solid #000000;}"
	cBodySTY += "</style>"
	cBodySTY += "</head><body>"
Return(nil)

Static function emlCAB(_cOrig)    
	cBodyCAB := ""
	//	cBodyCAB += "<table cellpadding='0' cellspacing='0' style='width: 700px' align='center'>"
	cBodyCAB += "<table cellpadding='0' cellspacing='0' style='width: 600px' align='center'>"
	cBodyCAB += "<tr>"
	// Evandro Lima (21/07/2017-Inovativa) - Alteração de texto conforme solicitação do setor de almoxarifado (Sr.Flávio)
	//	cBodyCAB += "<td colspan='5' style='height: 25px' class='auto-style3'><span class='auto-style4'><strong>Sr. (a) " + TMPXA2->XA6_NOME + "(" + TMPXA2->XA2_CLIFOR + "-" + TMPXA2->XA2_LOJA + "), informo a chegada do material descrito abaixo, por gentileza, retira-lo.</strong></span></td>"
	cBodyCAB += "<td colspan='5' style='height: 25px' class='auto-style3'><span class='auto-style4'><strong>Sr. (a) " + TMPXA2->XA6_NOME + "(" + TMPXA2->XA2_CLIFOR + "-" + TMPXA2->XA2_LOJA + "), informamos a chegada do material relacionado abaixo, solicitamos seu apoio para VERIFICACAO e RETIRADA do material.</strong></span></td>"
	cBodyCAB += "<td colspan='5' style='height: 25px' class='auto-style3'><span class='auto-style4'><strong>WF:" + TMPXA2->XA2_SEQ_WF + " Via:" + STRZERO(Val(TMPXA2->XA2_NROVIA)+1,2,0) + "</strong></span></td>"
	cBodyCAB += "</tr>"
	cBodyCAB += "</table>"
	cBodyCAB += "<table cellpadding='0' cellspacing='0' style='width: 600px' align='center'>"
	cBodyCAB += "<tr>"
	cBodyCAB += "<td colspan='5' style='height: 25px'>&nbsp;</td>"
	cBodyCAB += "</tr>"
	cBodyCAB += "<tr>"
	cBodyCAB += "<td class='auto-style7' colspan='5' style='height: 25px; border-bottom: 1px #000000 none; border-left: 1px #000000 solid; border-top-style: solid; border-top-color: #000000; border-top-width: 1px; border-right-color: #000000; border-right-style: solid; border-right-width: 1px'><span class='auto-style11'><strong>FORNECEDOR: " + Posicione("SA2",1,xFilial("SA2") + TMPXA2->XA2_CLIFOR + TMPXA2->XA2_LOJA,"A2_NOME") + "</strong></span></td>"
	cBodyCAB += "</tr>"
	cBodyCAB += "<tr>"
	//	cBodyCAB += "<td class='auto-style10' style='border-top: 1px solid #000000; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; width: 140px;'><strong>NOTA FISCAL</strong></td>"
	//	cBodyCAB += "<td class='auto-style10' style='border-top: 1px solid #000000; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; width: 140px;'><strong>PEDIDO DE COMPRA</strong></td>"
	//	cBodyCAB += "<td class='auto-style10' style='border-top: 1px solid #000000; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; width: 140px;'><strong>CENTRO DE CUSTO</strong></td>"
	//	cBodyCAB += "<td class='auto-style10' style='border-top: 1px solid #000000; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; width: 140px;'><strong>APLICACAO</strong></td>"
	//	cBodyCAB += "<td class='auto-style10' style='border-top: 1px solid #000000; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; border-right: 1px #000000 solid;width : 140px;'><strong>LOCACAO</strong></td>"
	cBodyCAB += "<td class='auto-style10' style='border-top: 1px solid #000000; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; width: 150px;'><strong>NOTA FISCAL</strong></td>"
	cBodyCAB += "<td class='auto-style10' style='border-top: 1px solid #000000; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; width: 150px;'><strong>PEDIDO DE COMPRA</strong></td>"
	cBodyCAB += "<td class='auto-style10' style='border-top: 1px solid #000000; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; width: 150px;'><strong>CENTRO DE CUSTO</strong></td>"
	cBodyCAB += "<td class='auto-style10' style='border-top: 1px solid #000000; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; width: 150px;'><strong>APLICACAO</strong></td>"	 // RAFAEL ALMEIDA - SIGACORP (21/10/2015) 
	//	cBodyCAB += "<td class='auto-style10' style='border-top: 1px solid #000000; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; border-right: 1px #000000 solid;width : 150px;'><strong>APLICACAO</strong></td>"   //// RAFAEL ALMEIDA - SIGACORP (21/10/2015)  COMENTADO
	cBodyCAB += "<td class='auto-style10' style='border-top: 1px solid #000000; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; border-right: 1px #000000 solid;width : 150px;'><strong>DT DE ENTRADA NOTA FISCAL</strong></td>"   //// RAFAEL ALMEIDA - SIGACORP (21/10/2015) 
	cBodyCAB += "</tr>"
	cBodyCAB += "<tr>"
	// cBodyCAB += "<td class='auto-style6' style='border-top: 1px #000000 none; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; width: 140px'>" + TMPXA2->XA2_NFISCA 	+ "</td>"
	//	cBodyCAB += "<td class='auto-style6' style='border-top: 1px #000000 none; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; width: 140px'>" + TMPXA2->XA2_PEDIDO 	+ "</td>"
	//	cBodyCAB += "<td class='auto-style6' style='border-top: 1px #000000 none; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; width: 140px'>" + TMPXA2->XA2_CCPN 		+ "</td>"
	//	cBodyCAB += "<td class='auto-style6' style='border-top: 1px #000000 none; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; width: 140px'>" + Iif(Alltrim(TMPXA2->XA2_APLIC)=="D","DIRETA","ESTOQUE") + "</td>"
	//	cBodyCAB += "<td class='auto-style6' style='border-top: 1px #000000 none; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; border-right: 1px #000000 solid;width : 140px;'><strong>" + TMPXA2->XA2_LOC + "</strong></td>"
	cBodyCAB += "<td class='auto-style6' style='border-top: 1px #000000 none; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; width: 150px'>" + TMPXA2->XA2_NFISCA 	+ "-" + TMPXA2->XA2_SERIE + "</td>"
	cBodyCAB += "<td class='auto-style6' style='border-top: 1px #000000 none; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; width: 150px'>" + TMPXA2->XA2_PEDIDO 	+ "</td>"
	cBodyCAB += "<td class='auto-style6' style='border-top: 1px #000000 none; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; width: 150px'>" + TMPXA2->XA2_CCPN 		+ "</td>"
		cBodyCAB += "<td class='auto-style6' style='border-top: 1px #000000 none; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; width: 150px'>"  + Iif(Alltrim(TMPXA2->XA2_APLIC)=="D","DIRETA",iif(Alltrim(TMPXA2->XA2_APLIC) == "E","ESTOQUE","INVESTIMENTO")) +  "</td>" // RAFAEL ALMEIDA - SIGACORP (21/10/2015) || Regra para investimento (Chamado: 29753) - Wagno Sousa em 20191104 
	//	cBodyCAB += "<td class='auto-style6' style='border-top: 1px #000000 none; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; border-right: 1px #000000 solid;width : 140px;'>" + Iif(Alltrim(TMPXA2->XA2_APLIC)=="D","DIRETA","ESTOQUE") + "</td>" // RAFAEL ALMEIDA - SIGACORP (21/10/2015) FOI COMENTADO
	cBodyCAB += "<td class='auto-style6' style='border-top: 1px #000000 none; height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; border-right: 1px #000000 solid;width : 140px;'>" +Iif(_cOrig == "MATA140",DTOC(SF1->F1_RECBMTO),DTOC(XA1->XA1_DATIMP))+ "</td>" // RAFAEL ALMEIDA - SIGACORP (21/10/2015)
	cBodyCAB += "</tr>"
	cBodyCAB += "</table>"

	//	cBodyCAB += "<table cellpadding='0' cellspacing='0' style='width: 700px' align='center'>
	cBodyCAB += "<table cellpadding='0' cellspacing='0' style='width: 600px' align='center'>
	cBodyCAB += "<tr>
	cBodyCAB += "<td style='height: 25px'>&nbsp;</td>"
	cBodyCAB += "</tr>
	cBodyCAB += "</table>

	//	cBodyCAB += "<table cellpadding='0' cellspacing='0' style='width: 700px' align='center' class='auto-style12'>"
	cBodyCAB += "<table cellpadding='0' cellspacing='0' style='width: 600px' align='center' class='auto-style12'>"
	cBodyCAB += "<tr>"                                                                                           
	cBodyCAB += "<td class='auto-style3' colspan='3' style='height: 25px; border-bottom: 1px #000000 solid; border-left: 1px #000000 solid; border-right-color: #000000; border-right-style: solid; border-right-width: 1px; border-top: 1px #000000 solid'><span class='auto-style4'><strong>ENTREGA DE MATERIAL APLICACAO DIRETA</strong></span><span class='auto-style4'><br /><strong>(Nao preencher uso do Almoxarifado)</strong></span></td>"
	cBodyCAB += "</tr>"
	cBodyCAB += "<tr>"
	//	cBodyCAB += "<td class='auto-style10' style='height: 25px; width: 233px; border-left: 1px #000000 solid; border-right-color: #000000; border-right-style: none; border-right-width: 1px; border-bottom: 1px #000000 solid'><strong>RETIRADO POR </strong></td>"
	//	cBodyCAB += "<td class='auto-style10' style='height: 25px; width: 234px; border-left: 1px #000000 solid; border-bottom: 1px #000000 solid'><strong>ENTREGUE POR</strong></td>"
	//	cBodyCAB += "<td class='auto-style10' style='height: 25px; width: 233px; border-left: 1px #000000 solid; border-right-color: #000000; border-right-style: solid; border-right-width: 1px; border-bottom: 1px #000000 solid'><strong>DATA</strong></td>"

	cBodyCAB += "<td class='auto-style10' style='height: 25px; width: 200px; border-left: 1px #000000 solid; border-right-color: #000000; border-right-style: none; border-right-width: 1px; border-bottom: 1px #000000 solid'><strong>RETIRADO POR </strong></td>"
	cBodyCAB += "<td class='auto-style10' style='height: 25px; width: 200px; border-left: 1px #000000 solid; border-bottom: 1px #000000 solid'><strong>ENTREGUE POR</strong></td>"
	cBodyCAB += "<td class='auto-style10' style='height: 25px; width: 200px; border-left: 1px #000000 solid; border-right-color: #000000; border-right-style: solid; border-right-width: 1px; border-bottom: 1px #000000 solid'><strong>DATA</strong></td>"

	cBodyCAB += "</tr>"
	cBodyCAB += "<tr>"
	//	cBodyCAB += "<td class='auto-style10' style='height: 25px; width: 233px; border-left: 1px #000000 solid; border-right-color: #000000; border-right-style: none; border-right-width: 1px; border-bottom: 1px #000000 solid'>&nbsp;</td>"
	//	cBodyCAB += "<td class='auto-style10' style='height: 25px; width: 234px; border-left: 1px #000000 solid; border-bottom: 1px #000000 solid'>&nbsp;</td>"
	//	cBodyCAB += "<td class='auto-style10' style='height: 25px; width: 233px; border-left: 1px #000000 solid; border-right-color: #000000; border-right-style: solid; border-right-width: 1px; border-bottom: 1px #000000 solid'>&nbsp;</td>"
	cBodyCAB += "<td class='auto-style10' style='height: 25px; width: 200px; border-left: 1px #000000 solid; border-right-color: #000000; border-right-style: none; border-right-width: 1px; border-bottom: 1px #000000 solid'>&nbsp;</td>"
	cBodyCAB += "<td class='auto-style10' style='height: 25px; width: 200px; border-left: 1px #000000 solid; border-bottom: 1px #000000 solid'>&nbsp;</td>"
	cBodyCAB += "<td class='auto-style10' style='height: 25px; width: 200px; border-left: 1px #000000 solid; border-right-color: #000000; border-right-style: solid; border-right-width: 1px; border-bottom: 1px #000000 solid'>&nbsp;</td>"
	cBodyCAB += "</tr>"
	cBodyCAB += "</table>"

	//	cBodyCAB += "<table cellpadding='0' cellspacing='0' style='width: 700px' align='center'>"
	cBodyCAB += "<table cellpadding='0' cellspacing='0' style='width: 600px' align='center'>"
	cBodyCAB += "<tr>"
	cBodyCAB += "<td style='height: 25px'>&nbsp;</td>"
	cBodyCAB += "</tr>
	cBodyCAB += "</table>

	cBodyCAB += "<table cellpadding='0' cellspacing='0' style='width: 700px' align='center'>"
	cBodyCAB += "<tr>"
	//	cBodyCAB += "<td class='auto-style3' style='height: 25px; width: 150px; border-left: 1px #000000 solid; border-top: 1px #000000 solid; border-bottom: 1px #000000 solid'><strong><span class='auto-style4'>QUANTIDADE</span> </strong></td>"
	//	cBodyCAB += "<td class='auto-style3' style='height: 25px; width: 100px; border-left: 1px #000000 solid; border-top: 1px #000000 solid; border-bottom: 1px #000000 solid'><span class='auto-style4'><strong>UM</strong></span><strong> </strong></td>"
	//	cBodyCAB += "<td class='auto-style3' style='height: 25px; width: 450px; border-left: 1px #000000 solid; border-right-color: #000000; border-right-style: solid; border-right-width: 1px; border-top: 1px #000000 solid; border: 1px #000000 solid'><strong><span class='auto-style4'>DESCRICAO MATERIAL</span></strong></td>"
	cBodyCAB += "<td class='auto-style3' style='height: 25px; width: 100px; border-left: 1px #000000 solid; border-top: 1px #000000 solid; border-bottom: 1px #000000 solid'><strong><span class='auto-style4'>QUANTIDADE</span> </strong></td>"
	cBodyCAB += "<td class='auto-style3' style='height: 25px; width: 100px; border-left: 1px #000000 solid; border-top: 1px #000000 solid; border-bottom: 1px #000000 solid'><span class='auto-style4'><strong>UM</strong></span><strong> </strong></td>"
	cBodyCAB += "<td class='auto-style3' style='height: 25px; width: 300px; border-left: 1px #000000 solid; border-right-color: #000000; border-right-style: solid; border-right-width: 1px; border-top: 1px #000000 solid; border: 1px #000000 solid'><strong><span class='auto-style4'>DESCRICAO MATERIAL</span></strong></td>"
	cBodyCAB += "<td class='auto-style3' style='height: 25px; width: 100px; border-left: 1px #000000 solid; border-right-color: #000000; border-right-style: solid; border-right-width: 1px; border-top: 1px #000000 solid; border: 1px #000000 solid'><strong><span class='auto-style4'>LOCACAO</span></strong></td>"
	cBodyCAB += "</tr>"
Return(nil)





Static Function emlBOD() 
	cBodyBOD := ""
	cBodyBOD += "<tr>"  
	//	cBodyBOD += "<td class='auto-style3' style='height: 25px; width: 150px; border-left: 1px #000000 solid; border-top: 1px #000000 solid; border-bottom: 1px #000000 solid'>" + Transform(TMPXA2->XA2_QTDPN,"@E 999.99") + "</td>"
	//	cBodyBOD += "<td class='auto-style3' style='height: 25px; width: 100px; border-left: 1px #000000 solid; border-top: 1px #000000 solid; border-bottom: 1px #000000 solid'>" + TMPXA2->XA2_UMPN + "</td>"
	//	cBodyBOD += "<td class='auto-style3' style='height: 25px; width: 450px; border-left: 1px #000000 solid; border-right-color: #000000; border-right-style: solid; border-right-width: 1px; border-top: 1px #000000 solid; border: 1px #000000 solid'>" + Alltrim(TMPXA2->XA2_NOMPN) 	+ "</td>"
	cBodyBOD += "<td class='auto-style3' style='height: 25px; width: 100px; border-left: 1px #000000 solid; border-top: 1px #000000 solid; border-bottom: 1px #000000 solid'>" + Transform(TMPXA2->XA2_QTDPN,"@E 99,999.99") + "</td>"
	cBodyBOD += "<td class='auto-style3' style='height: 25px; width: 100px; border-left: 1px #000000 solid; border-top: 1px #000000 solid; border-bottom: 1px #000000 solid'>" + TMPXA2->XA2_UMPN + "</td>"
	cBodyBOD += "<td class='auto-style3' style='height: 25px; width: 300px; border-left: 1px #000000 solid; border-right-color: #000000; border-right-style: solid; border-right-width: 1px; border-top: 1px #000000 solid; border: 1px #000000 solid'>" + Alltrim(TMPXA2->XA2_PROPN) + "<BR />" + Alltrim(TMPXA2->XA2_NOMPN) 	+ "</td>"
	cBodyBOD += "<td class='auto-style3' style='height: 25px; width: 100px; border-left: 1px #000000 solid; border-right-color: #000000; border-right-style: solid; border-right-width: 1px; border-top: 1px #000000 solid; border: 1px #000000 solid'>" + Alltrim(TMPXA2->XA2_LOC) 	+ "</td>"

	cBodyBOD += "</tr>"
Return(nil)




Static Function emlROD() 
	cBodyROD := ""
	cBodyROD	+= "</table>"
	cBodyROD	+= "<table cellpadding='0' cellspacing='0' style='width: 700px' align='center'>"
	cBodyROD	+= "<tr>"
	cBodyROD	+= "<td style='height: 25px'>&nbsp;</td>"
	cBodyROD	+= "</tr>"
	cBodyROD	+= "</table>"

	cBodyROD	+= "<table cellpadding='0' cellspacing='0' style='width: 700px' align='center'>"
	cBodyROD	+= "<tr>"
	cBodyROD	+= "<td class='auto-style16' colspan='5' style='height: 25px'><strong>ORIENTACOES PARA RETIRADA DO MATERIAL</strong></td>"
	cBodyROD	+= "</tr>"
	cBodyROD	+= "<tr>"
	cBodyROD	+= "<td class='auto-style15' colspan='5' style='height: 25px'>"
	cBodyROD	+= "<p class='auto-style14'><br />"
	cBodyROD	+= "<span class='auto-style13'>1. NECESSARIO A COPIA DESTE E-MAIL PARA RETIRADA DO MATERIAL NO ALMOXARIFADO;<br /></span><br class='auto-style13' />"
	cBodyROD	+= "<span class='auto-style13'>2. DIRIJA-SE AO BALCAO DE ATENDIMENTO NO ALMOXARIFADO;<br /></span><br class='auto-style13' />"
	cBodyROD	+= "<span class='auto-style13'>3. SOLICITE ATENDIMENTO DO ALMOXARIFE DE TURNO.<br /></span><br class='auto-style13' />"
	cBodyROD	+= "<span class='auto-style13'>4. VERIFIQUE SEU MATERIAL DE IMEDIATO AO RECEBIMENTO</span><br /><br />"
	cBodyROD	+= "</p>"
	cBodyROD	+= "</td>"
	cBodyROD	+= "</tr>"
	cBodyROD	+= "<tr>"
	cBodyROD	+= "<td style='height: 25px'>&nbsp;</td>"
	cBodyROD	+= "</tr>"
	cBodyROD	+= "<tr>"
	cBodyROD	+= "<td style='height: 25px'>&nbsp;</td>"
	cBodyROD	+= "</tr>"
	cBodyROD	+= "</table>"

	cBodyROD	+= "<table cellpadding='0' cellspacing='0' style='width: 700px' align='center'>"
	cBodyROD	+= "<tr>"
	cBodyROD	+= "<td style='height: 25px'><span class='auto-style13'>Ats,</span><br class='auto-style13' />"
	cBodyROD	+= "<br class='auto-style13' />"
	cBodyROD	+= "<span class='auto-style13'>ALMOXARIFADO</span><br class='auto-style13' />"
	cBodyROD	+= "<span class='auto-style13'>ALUBAR METAIS E CABOS S.A.</span><br class='auto-style13' />"
	cBodyROD	+= "<span class='auto-style13'>TEL. (091) 3754-7165</span><br class='auto-style13' />"
	cBodyROD	+= "<span class='auto-style13'>CEL. (091) 99166-5400</span><br class='auto-style13' />"
	cBodyROD	+= "<span class='auto-style13'>E-MAIL: almoxarifado-l@alubar.net </span>"
	cBodyROD	+= "<br />"
	cBodyROD	+= "</td>"
	cBodyROD	+= "</tr>"
	cBodyROD	+= "</table>"
	cBodyROD	+= "<br /><br /><br /><br /><br />"

	cBodyROD	+= "</body>"
	cBodyROD	+= "</html>"
Return(nil)





Static Function atuQRY(_cOrig) 


	Local _cNumNF  := ""
	Local _cSeriNF := ""
	Local _cFornec := ""
	Local _cLjForn := ""

	//RAFAEL ALMEIDA - SIGACORP (08/10/2015)
	// INICIO - CUSTOMIZAÇÃO QUE IDENTIFICA DE ONDE ESTA SENDO CHAMADO A ROTINA 

	If _cOrig == "MATA140"
		_cNumNF  := SF1->F1_DOC
		_cSeriNF := SF1->F1_SERIE
		_cFornec := SF1->F1_FORNECE
		_cLjForn := SF1->F1_LOJA
	Else
		_cNumNF  := XA1->XA1_NFISCA
		_cSeriNF := XA1->XA1_SERIE
		_cFornec := XA1->XA1_CLIFOR
		_cLjForn := XA1->XA1_LOJA
	EndIf
	// FIM - 

	cQry  := ""  
	cQry  += "SELECT " 			+ __cCRLF
	cQry  += "	XA2_ENTREG " 	+ __cCRLF
	cQry  += "	,XA6_EMAIL " 	+ __cCRLF
	cQry  += "	,XA6_NOME " 	+ __cCRLF
	cQry  += "	,XA2_PEDIDO " 	+ __cCRLF
	cQry  += "	,XA2_CCPN " 	+ __cCRLF
	cQry  += "	,XA2_QTDPN " 	+ __cCRLF
	cQry  += "	,XA2_UMPN " 	+ __cCRLF
	cQry  += "	,XA2_PROPN " 	+ __cCRLF
	cQry  += "	,XA2_NOMPN " 	+ __cCRLF
	cQry  += "	,XA2_NFISCA " 	+ __cCRLF
	cQry  += "	,XA2_SERIE " 	+ __cCRLF
	cQry  += "	,XA2_CLIFOR " 	+ __cCRLF
	cQry  += "	,XA2_LOJA " 	+ __cCRLF
	cQry  += "	,XA2_APLIC " 	+ __cCRLF
	cQry  += "	,XA2_LOC " 		+ __cCRLF
	cQry  += "	,XA2_SEQ_WF " 	+ __cCRLF
	cQry  += "	,XA2_NROVIA " 	+ __cCRLF
	cQry  += "	,XA2_ITEM " 	+ __cCRLF
	cQry  += "FROM " 			+ __cCRLF
	cQry  += "	XA2" + substr(cNumEmp,1,3) + " XA2 " + __cCRLF
	cQry  += "	,XA6" + substr(cNumEmp,1,3) + " XA6 " + __cCRLF

	//	cQry  += "	" + retSQLName("XA2") + " XA2 " + __cCRLF
	//	cQry  += "	," + retSQLName("XA6") + " XA6 " + __cCRLF
	cQry  += "WHERE " + __cCRLF
	cQry  += "	XA2.D_E_L_E_T_<>'*' " + __cCRLF
	cQry  += "	AND XA6.D_E_L_E_T_<>'*' " + __cCRLF
	cQry  += "	AND XA2_FILIAL='" + xFilial("XA2") + "' " + __cCRLF
	cQry  += "	AND XA6_FILIAL='" + xFilial("XA6") + "' " + __cCRLF
	cQry  += "	AND XA2_ENTREG=XA6_USU " + __cCRLF
	cQry  += "	AND XA2_NFISCA='"	+ _cNumNF 	+ "' "	+ __cCRLF
	cQry  += "	AND XA2_SERIE='" 	+ _cSeriNF 	+ "' "	+ __cCRLF   
	cQry  += "	AND XA2_CLIFOR='"	+ _cFornec 	+ "' "	+ __cCRLF
	cQry  += "	AND XA2_LOJA='" 	+ _cLjForn 	+ "' "	+ __cCRLF
	cQry  += "ORDER BY XA2_ENTREG,XA2_PEDIDO,XA2_CCPN "	+ __cCRLF
	Return(nil) 

	_cNumNF  := SF1->F1_DOC
	_cSeriNF := SF1->F1_SERIE
	_cFornec := SF1->F1_FORNECE
	_cLjForn := SF1->F1_LOJA


User Function calcLIN()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Declaracao de variaveis³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local nTotal

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza total da linha selecionada no msGetDados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTotal := Round((oMSNewGe1:acols[oMSNewGe1:nat,15]/* Qtd Prenota(XA2_QTDPN)*/ * oMSNewGe1:acols[oMSNewGe1:nat,17])/* Vl Un Prenota(XA2_VLUPN)*/ - oMSNewGe1:acols[oMSNewGe1:nat,18]/* Desc Prenota(XA2_VLDPN)*/,6) 
Return(nTotal)                                                   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ConsPed º Autor ³ Rafael Almeida-SIGACORP ºData ³14/10/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de Visualização do Pedidos de Compras               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ itXML() / manXML()                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ConsPed(_cNumPed,_cItemPed,_cProdPed)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aArea        := GetArea() 
	Local aAreaSC7     := SC7->(GetArea()) 
	Local nSavNF       := MaFisSave() 
	Local cSavCadastro := cCadastro
	Private L120AUTO   := .F.
	Private nTipoPed   := 1
	Private cCadastro  := "Consulta ao Pedido de Compra" 


	If Alltrim(M->XA1_PC) == '2'
		Aviso("Aviso","Foi selecionada a opção '2-Sem pedido de Compras.",{"Ok"})	
		Return()
	Endif
	SaveInter() // Salva variaveis publicas 

	dbSelectArea("SC7")  
	dbSetOrder(1)

	//C7_FILIAL, C7_NUM, C7_ITEM
	If SC7->(dbSeek(xFilial("SC7")+Alltrim(_cNumPed)+Alltrim(_cItemPed)))
		A120Pedido(Alias(),RecNo(),2,.F.,.F.,.F.)
	Else
		Aviso("Aviso","Pedido de Compra não localizado",{"Ok"})		
	EndIf 

	RestInter()    
	cCadastro := cSavCadastro 
	MaFisRestore(nSavNF) 
	RestArea(aAreaSC7) 
	RestArea(aArea)

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA120BUT º Autor ³ Rafael Almeida-SIGACORP ºData ³14/10/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Adiciona Botões no Pedido de Compras.                      º±±
±±º          ³                                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA120                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MA120BUT() 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aButtons   := {} // Botoes a adicionar

	//aadd(aButtons,{'BUDGETY',{|| U_ConsSC1(_cSC7NumSC, _cSC7ItemSC,_cSC7Prod ) },'Consultar SC','Consultar SC'}) 
	aadd(aButtons,{'BUDGETY',{|| U_ConsSC1() },'Consultar SC','Consultar SC'})  //23/02/17
	aadd(aButtons,{'BUDGETY',{|| U_DetSC1()},'Detalhe Aplicação','Detalhe Aplicação'}) 

Return (aButtons )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ConsSC1 º Autor ³ Rafael Almeida-SIGACORP ºData ³14/10/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Esta rotina tem como objetivo visualizar as solicitacoes deº±±
±±º          ³ compra utilizando-se uma modelo 2                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MA120BUT                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ConsSC1()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Local aArea      := GetArea() 
	//Local aAreaSC1   := SC1->(GetArea()) 
	Local nSavNF     := MaFisSave() 
	Local _nPosNSc   := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_NUMSC"})               
	Local _nPosPSc   := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRODUTO"})
	Local _nPosISc   := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_ITEMSC"})
	/*Local _cProSC1	  := _cSC7Prod
	Local _cNumSC1   := _cNumSC
	Local _cItmSC1   := _cSC7ItemSC*/
	Local _cSC7Forn	:= SC7->C7_FORNECE   //23/02/17 - FABIO YOSHIOKA
	Local _cSC7Loja	:= SC7->C7_LOJA       //23/02/17 - FABIO YOSHIOKA      
	Local _nPosPed:=n


	SaveInter() // Salva variaveis publicas 

	dbSelectArea("SC1")  
	dbSetOrder(2)

	//C1_FILIAL+C1_PRODUTO+C1_NUM+C1_ITEM+C1_FORNECE+C1_LOJA                                                                                                          
	//If dbSeek(xFilial("SC1")+aCols[n][_nPosPSc]+aCols[n][_nPosNSc]+aCols[n][_nPosISc])
	If dbSeek(xFilial("SC1")+aCols[_nPosPed][_nPosPSc]+aCols[_nPosPed][_nPosNSc]+aCols[_nPosPed][_nPosISc]+_cSC7Forn+_cSC7Loja)  //23/02/17
		//If dbSeek(xFilial("SC1")+_cSC7Prod+_cSC7NumSC+_cSC7ItemSC+_cSC7Forn+_cSC7Loja) //23/02/17 - Fabio Yoshioka
		A110Visual(Alias(),RecNo(),2)
	Else
		Aviso("Aviso","Solicitação de Compra não localizado",{"Ok"})		
	EndIf 



	RestInter() 
	MaFisRestore(nSavNF) 
	//RestArea(aAreaSC1) 
	//RestArea(aArea)

Return()
