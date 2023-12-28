#Include "PROTHEUS.CH"
User Function GERATAB()                        
	Private oButton1
	Private oButton2
	Private oButton3
	Private oWBrowse1
	Private aWBrowse1 := {}
	Private oSay1
	Private oDlg
	Private oOk 			:= LoadBitmap( GetResources(), "LBOK")
	Private oNo 			:= LoadBitmap( GetResources(), "LBNO")

	DEFINE MSDIALOG oDlg TITLE "Tabelas para Recriar" FROM 000, 000  TO 500, 800 COLORS 0, 16777215 PIXEL

	fWBrowse1()

	@ 233, 018 BUTTON oButton1 PROMPT "Marca Todos" SIZE 057, 012 Action (uMarkAll(aWBrowse1,1)) OF oDlg PIXEL
	@ 233, 078 BUTTON oButton1 PROMPT "Desmarca Todos" SIZE 057, 012 Action (uMarkAll(aWBrowse1,2)) OF oDlg PIXEL
	@ 233, 138 BUTTON oButton1 PROMPT "Inverter Marcações" SIZE 057, 012 Action (uMarkAll(aWBrowse1,3)) OF oDlg PIXEL

	@ 233, 287 BUTTON oButton1 PROMPT "Processar" SIZE 052, 012 OF oDlg Action(Processa({|| GeraTb(aWBrowse1) },"Processando")) PIXEL
	@ 233, 344 BUTTON oButton2 PROMPT "Fechar" SIZE 052, 012 OF oDlg Action(oDlg:End()) PIXEL



	ACTIVATE MSDIALOG oDlg CENTERED

Return

//------------------------------------------------ 
Static Function fWBrowse1()

	// Insert items here
	dbSelectArea('SX2')
	dbSetOrder(1)
	dbGoTop()
	While !eof() 
		Aadd(aWBrowse1,{.F.,X2_CHAVE,X2_ARQUIVO,X2_NOME})
		skip
		loop
	End
	@ 001, 001 LISTBOX oWBrowse1 Fields HEADER " ","Chave","Arquivo","Descrição" SIZE 396, 227 OF oDlg PIXEL ColSizes 50,50
	oWBrowse1:SetArray(aWBrowse1)
	oWBrowse1:bLine := {|| {;
	Iif(aWBrowse1[oWBrowse1:nAT,1],oOk,oNo),;
	aWBrowse1[oWBrowse1:nAt,2],;
	aWBrowse1[oWBrowse1:nAt,3],;
	aWBrowse1[oWBrowse1:nAt,4];
	}}
	// DoubleClick event
	oWBrowse1:bLDblClick := {|| aWBrowse1[oWBrowse1:nAt,1] := !aWBrowse1[oWBrowse1:nAt,1]}
	oWBrowse1:brClicked := {|| (oWBrowse1:nAT:=fSearchX(aWBrowse1,1,oWBrowse1:nAt),oWBrowse1:Refresh(),oWBrowse1:SetFocus())}

	Return

	// Função para selecionas Centro de Custos na Tela de permitidos - ALUBAR
	********************************************************************************************************************************
Static Function uMarkAll(aWBrowse1,_nTipo)
	********************************************************************************************************************************
	Local y as numeric
	For y:=1 to len(aWBrowse1)
		If _nTipo==1  //Marcar Todos
			aWBrowse1[y,1]:= .T.
		ElseIf _nTipo==2  //Descmarcar Todos
			aWBrowse1[y,1]:= .F.
		ElseIf _nTipo==3  //Inverte marcações
			aWBrowse1[y,1]:= !aWBrowse1[y,1]
		endif
	Next y
	oWBrowse1:SetArray(aWBrowse1)
	oWBrowse1:bLine := {|| {;
	Iif(aWBrowse1[oWBrowse1:nAT,1],oOk,oNo),;
	aWBrowse1[oWBrowse1:nAt,2],;
	aWBrowse1[oWBrowse1:nAt,3],;
	aWBrowse1[oWBrowse1:nAt,4]}}
	oWBrowse1:Refresh()
	Return

	********************************************************************************************************************************
Static Function fSearchX(_aBusca,_nTipo,_nReg)
	********************************************************************************************************************************
	// Função para realizar pesquisa nas telas
	// Recebe:	_aBusca 	(Array contendo os dados onde será pesquisado)
	// 			_nTipo 		(Identifica a ABA que está sendo usado, necessário pela composição das opções de busca)
	//			_nReg		(Registro posicionado antes do busca, para caso de cancelamento da pesquisa)
	********************************************************************************************************************************
	Local oButton1
	Local oButton2
	Local oGetBusca
	Local cGetBusca := Space(50)
	Local oGroupBusca
	Local oGroupInf
	Local oRadBusca
	Local nRadBusca := 1
	Local _lOk:=.F.
	Local __nRet:=_nReg
	Static oDlgBusca

	DEFINE MSDIALOG oDlgBusca TITLE "Pesquisa" FROM 000, 000  TO 90, 505 COLORS 0, 16777215 PIXEL

	@ 000, 001 GROUP oGroupBusca TO 044, 055 PROMPT "(Opção de Busca)" OF oDlgBusca COLOR 0, 16777215 PIXEL
	@ 007, 005 RADIO oRadBusca VAR nRadBusca ITEMS "Chave","Arquivo" SIZE 039, 021 OF oDlgBusca COLOR 0, 16777215 PIXEL
	@ 000, 056 GROUP oGroupInf TO 044, 252 PROMPT "(Informação para Pesquisar)" OF oDlgBusca COLOR 0, 16777215 PIXEL
	@ 008, 058 MSGET oGetBusca VAR cGetBusca SIZE 193, 010 OF oDlgBusca COLORS 0, 16777215 PIXEL
	@ 024, 169 BUTTON oButton1 PROMPT "Confirma" 	Action (_lOk:=.T., oDlgBusca:End()) SIZE 037, 012 OF oDlgBusca PIXEL
	@ 024, 208 BUTTON oButton2 PROMPT "Cancela" 	Action oDlgBusca:End() 				SIZE 037, 012 OF oDlgBusca PIXEL

	ACTIVATE MSDIALOG oDlgBusca CENTERED

	if _lOk
		_nTam:=Len(AllTrim(cGetBusca))
		nPosBusca := Ascan(_aBusca,{|X| UPPER(Substr(X[nRadBusca+1],1,_nTam)) == UPPER(AllTrim(cGetBusca))})
		If nPosBusca > 0
			__nRet:=nPosBusca
		Endif
	Endif
Return(__nRet)

Static Function GeraTb(aWBrowse1)
Local y as numeric
	ProcRegua(len(aWBrowse1))	

	For y:=1 to len(aWBrowse1)
		Incproc("Processando")		
		if aWBrowse1[y,1]
			dbSelectArea(aWBrowse1[y,2])
			dbGoTop()
			dbCloseArea()
			aWBrowse1[y,1] := .F.
		Endif
	Next y
	oWBrowse1:SetArray(aWBrowse1)
	oWBrowse1:bLine := {|| {;
	Iif(aWBrowse1[oWBrowse1:nAT,1],oOk,oNo),;
	aWBrowse1[oWBrowse1:nAt,2],;
	aWBrowse1[oWBrowse1:nAt,3],;
	aWBrowse1[oWBrowse1:nAt,4]}}
	oWBrowse1:Refresh()
Return


