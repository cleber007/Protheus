#INCLUDE "rwmake.ch" 
#INCLUDE 'PROTHEUS.CH'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWTABLEATTACH.CH"
#INCLUDE "FWCALENDARWIDGET.CH"
#INCLUDE "TOPCONN.CH"

//P.E. para inclusão de novos botões na rotina Gestão Funcionário
//Fabricio Amaro - 05/10/2012

//Folha de Pagto
User Function GPE11ROT()
	
	Local aArea 		:= GetArea()
	Local aRotinas 		:= {}

	aFolOutros :={	{ "Word"							, "U_XGPEXWORD()"  		, 0 , 6 },;
					{ "Arquivo Liquidos"				, "U_XGPEM080()"   		, 0 , 6 },;
					{ "Conta Corrente Valores Futuros"	, "U_XGPEA415()"   		, 0 , 6 },;
					{ "Acumulados (Manutenção)"			, "U_XGPEAT('GPEA120')"	, 0 , 6 },;
					{ "Ficha Registro"					, "U_XGPEA260()"   		, 0 , 6 }}


	//Calculos
	aCalcFol :={{ "Por Roteiros"		, "U_XGPEM020()"   	, 0 , 6 },;
				{ "Roteiros Multiplos"	, "U_XGPM020A()"  	, 0 , 6 },;
				{ "Cancelamento Calc."	, "U_XGPEM160()"   	, 0 , 6 },;
				{ "Geração Verbas"		, "U_XGPEM170()"   	, 0 , 6 },;
				{ "Import. Variaveis"	, "U_XGPEA210()"    , 0 , 6 },;
				{ "Integração Folha"	, "U_XGPEM019()"   	, 0 , 6 }}


	//Relatórios Folha
	aFolRel  :={{ "Recibo de Pagamento"					, "GPER030()"  	, 0 , 6 },;
				{ "Folha de Pagamento" 					, "GPER040()"  	, 0 , 6 },;
				{ "Lanç. Mensais Vertical - RGB"		, "GPER104()"   , 0 , 6 },;
				{ "Lanç. Mensais Horizontal - RGB"		, "GPER105()"   , 0 , 6 },;
				{ "Por Periodo Vertical"				, "GPER102()"  	, 0 , 6 },;
				{ "Por Periodo Horizontal"				, "GPER103()" 	, 0 , 6 },;
				{ "Liquidos"        					, "GPER020()" 	, 0 , 6 },;
				{ "Demonstrativo de Médias"				, "GPER080()" 	, 0 , 6 },;
				{ "Demonstrativo de Horas"				, "GPER330()" 	, 0 , 6 },;
				{ "Valores Futuros"						, "GPER570()" 	, 0 , 6 },;
				{ "Ficha Financeira"					, "GPER270()" 	, 0 , 6 },;
				{ "Vencimento Experiencia/Exame Médico"	, "GPER190()"  	, 0 , 6 },;
				{ "Turnover"							, "GPER500()"   , 0 , 6 },;
				{ "Admitidos / Demitidos"				, "GPER490()"   , 0 , 6 },;
				{ "Aniversariantes"						, "GPER260()"   , 0 , 6 };
				}

	//Relatórios Férias
	aFerRel  :={{ "Recibo/Aviso de Férias"		, "GPER130()"   	, 0 , 6 },;
				{ "Memória Cálculo"				, "GPER091()"   	, 0 , 6 },;
				{ "Férias Vencidas Mes"			, "GPER390()"   	, 0 , 6 },;
				{ "Programação Férias"			, "GPER400()"   	, 0 , 6 },;
				{ "Férias Calculadas"			, "GPER550()"   	, 0 , 6 },;
				{ "Conciliação de Férias"		, "GPER135()"   	, 0 , 6 };
				}

	//Relatórios Rescisão
	aResRel  :={{ "Termo de Rescisão"			, "GPER140()"   	, 0 , 6 },;
				{ "Valores Rescisão"			, "GPER630()"   	, 0 , 6 },;
				{ "Memória Cálculo"				, "GPER091()"   	, 0 , 6 };
				}
	
	//BENEFICIOS
	aPLA   := {	{"Plano de Saude Ativo"		, "U_XGPEAT('PLA')" 	  , 0, 6},;
				{"Co-Participação/Reembolso", "U_XGPEAT('PLACOPART')" , 0, 6},;
				{"Manut. Cálc. Plano Saude"	, "U_XGPEAT('PLAMANUT')"  , 0, 6},;
				{"Relatório Calculo Mes"	, "U_XGPEAT('PLAREL')" 	  , 0, 6}}


	aVAVRVT:= {	{"VT / VR / VA"     		, "U_XGPEAT('VAVRVT')" 	, 0, 6},;
				{"Impressão Mapa"			, "U_XGPEAT('VAREL')"	, 0, 6}}

	aOutBen:= {	{"Manutenção"     		, "U_XGPEAT('OUTMANUT')" , 0, 6},;
				{"Relatório Calculo"	, "U_XGPEAT('OUTREL')" 	 , 0, 6}}


	aBenef := {	{"Plano de Saude"		, aPLA 	 	 , 0, 6},;
				{"VT / VR / VA"     	, aVAVRVT 	 , 0, 6},;
				{"Outros Beneficios"   	, aOutBen 	 , 0, 6}}

	aDiscip := {{"Incluir"		, "U_XGPEAT('DISCIP')" 	, 0, 6},;
				{"Consultar"    , "U_XGPEAT('DISCIPV')" , 0, 6}}

	aRateio := {{ "* Programação de Rateios", "U_XGPEAT('RATEIO')"	, 0 , 6 },;
				{ "* Rateio em Lote"		, "U_XGPEAT('RATEIOA')"	, 0 , 6 }}


	aEsocial := {{"Painel do Trabalhador", "U_XGPEAT('TAFPNFUNC')" 	, 0, 6},;
				{"Eventos Periódicos"    , "U_XGPEM034()" 	 		, 0, 6},;
				{"Painel e-Social"   	 , "U_XTAFA552A()" 	 		, 0, 6}}


	//Cria botao semelhante aos demais, com submenus
	aAdd( aRotinas, { "* Convocações"					, "U_XGPEAT('CONVOC')"	, 0 , 6 , , .F. } )
	aAdd( aRotinas, { "* Programação de Rateios"		, aRateio   			, 0 , 6 , , .F. } )
	aAdd( aRotinas, { "* Calculos..."					, aCalcFol				, 0 , 6 , , .F. } )
	aAdd( aRotinas, { "* Relatórios Folha"				, aFolRel				, 0 , 6 , , .F. } )
	aAdd( aRotinas, { "* Relatórios Férias"				, aFerRel				, 0 , 6 , , .F. } )
	aAdd( aRotinas, { "* Relatórios Rescisão"			, aResRel				, 0 , 6 , , .F. } )
	aAdd( aRotinas, { "* Outros"						, aFolOutros			, 0 , 6 , , .F. } )
	aAdd( aRotinas, { "* Beneficios"					, aBenef				, 0 , 6 , , .F. } )
	aAdd( aRotinas, { "* Gestão Disciplinar"			, aDiscip				, 0 , 6 , , .F. } )
	aAdd( aRotinas, { "* TAF - e-Social"				, aESocial  			, 0 , 6 , , .F. } )
	aAdd( aRotinas, { "* Cad. Participante"				, "U_XAPDA020()"		, 0 , 6 , , .F. } )
	aAdd( aRotinas, { "* Provisões Férias/13º"			, "U_XGPEA070()"		, 0 , 6 , , .F. } )
	aAdd( aRotinas, { "* Solicitações APP MEU RH"		, "U_X2TCFA040()"		, 0 , 6 , , .F. } )
	aAdd( aRotinas, { "* Ponto Eletrônico - Integrados"	, "U_XPONA280()" 		, 0 , 6 , , .F. } )
	aAdd( aRotinas, { "* MDT - Prontuário Médico"		, "U_XMDTA410()" 		, 0 , 6 , , .F. } )
	RestArea( aArea )
	
Return( aRotinas )

/////////////////////////////////////////////////////////////////
////////////// FOLHA
/////////////////////////////////////////////////////////////////

	//CALCULO POR ROTEIROS
	User Function XGPEM020
		SETFUNNAME("GPEM020")
		GPEM020()
		SETFUNNAME("GPEA011")
	Return

	//CALCULO POR ROTEIROS MULTIPLOS
	User Function XGPM020A()
		SETFUNNAME("GPEM020A")
		GPEM020A()
		SETFUNNAME("GPEA011")
	Return
	//CANCELAMENTO DE CALCULO
	User Function XGPEM160
		SETFUNNAME("GPEM160")
		GPEM160()
		SETFUNNAME("GPEA011")
	Return
	//GERACAO DE VERBAS
	User Function XGPEM170
		SETFUNNAME("GPEM170")
		GPEM170()
		SETFUNNAME("GPEA011")
	Return

	//INTEGRACOES
	User Function XGPEM019()
		SETFUNNAME("GPEM019")
		GPEM019()
		SETFUNNAME("GPEA011")
	Return

	//Solicitações APP MEU RH
	User Function XTCFA040(cOrig)
		Local aArea       := GetArea()
		Default cOrig     := ""
		U_XGPEAT("TCFA040")
		RestArea(aArea)
	Return

	//Solicitações APP MEU RH
	User Function X2TCFA040()
		Local aArea       := GetArea()
		Local cTabela     := "RH3"
		Local cFiltra 	  := ""
		
		nRet := Aviso("Solic. APP MEU RH","Deseja apresentar as solicitações: ",{ "Desse Func. Pendentes", "Desse Func. Todas", "Todos Func. Pendentes" })

		If nRet = 1
			cFiltra 	  := "RH3_FILIAL = '" + SRA->RA_FILIAL + "' .AND. RH3_MAT = '" + SRA->RA_MAT + "' .AND. RH3_STATUS $ '1/4/5' "
		ElseIf nRet = 2
			cFiltra 	  := "RH3_FILIAL = '" + SRA->RA_FILIAL + "' .AND. RH3_MAT = '" + SRA->RA_MAT + "' "
		Else
			cFiltra 	  := "RH3_STATUS $ '1/4/5' "
		EndIf

		//variaveis da rotina padrao
		Private aLogMdt 	:= {}
		Private oReturn
		Private cAliasQry
		Private cOBS    	:= space(250)
		Private cFilUsr 	:= ""
		Private cMatUsr 	:= ""
		Private cTpUser 	:= "" // Tipos de solicitação customizados
		Private nPer13S 	:= SuperGetMv("MV_PERC13S", NIL, 0) //Percentual padrao de 13º Salario
		Private cVerGSP 	:= SuperGetMv("MV_GSPUBL",,"1")
		Private cConCTT		:= .F.
		Private cConDept	:= .F.
		Private cConProc	:= .F.
		Private cConPosto	:= .F.

		Private aCores    := {}
		Private cCadastro := "Solicitações APP MEU RH"
		Private aRotina   := {}
		Private aIndexRH3 := {}
		Private bFiltraBrw:= { || FilBrowse(cTabela,@aIndexRH3,@cFiltra) }

		SETFUNNAME("TCFA040")

		//Montando o Array aRotina, com funções que serão mostradas no menu
		aAdd(aRotina,{"Pesquisar"       , "AxPesqui"     	, 0, 1})
		aAdd(aRotina,{"Atender"         , "U_XTCFA040('1')" , 0, 8})
		aAdd(aRotina,{"Atender em Lote" , "AtendeLote" 		, 0, 8})
		aAdd(aRotina,{"Legenda"         , "U_XLEGTCF()" 	, 0, 6})
	
		//Montando as cores da legenda
		aAdd(aCores,{"RH3_STATUS == '1' ", "BR_AMARELO" })
		aAdd(aCores,{"RH3_STATUS == '2' ", "BR_VERDE" 	})
		aAdd(aCores,{"RH3_STATUS == '3' ", "BR_VERMELHO"})
		aAdd(aCores,{"RH3_STATUS == '4' ", "BR_AZUL" 	})
		aAdd(aCores,{"RH3_STATUS == '5' ", "BR_LARANJA" })
		
		//Selecionando a tabela e ordenando
		Eval(bFiltraBrw) //FILTRO
		DbSelectArea(cTabela)
		(cTabela)->(DbSetOrder(1))
		dbGoTop()

		//Montando o Browse
		mBrowse(6, 1, 22, 75, cTabela, , , , , , aCores )
		
		EndFilBrw(cTabela,aIndexRH3)

		//Encerrando a rotina
		(cTabela)->(DbCloseArea())

		SETFUNNAME("GPEA011")
		RestArea(aArea)
	Return

	User Function XLEGTCF()
		Local aLegenda := {}
		aLegenda := {{ "BR_AMARELO" , OemToAnsi( "Solicitado - Aguardando Aprovação Gestor" )},; 
					 { "BR_VERDE"   , OemToAnsi( "Atendido" 								)},; 
					 { "BR_VERMELHO", OemToAnsi( "Rejeitado"								)},; 
					 { "BR_AZUL"    , OemToAnsi( "Aguardando Aprovação RH" 				    )}}
		BrwLegenda("SOLIC APP MEU RH", "Legenda", aLegenda)
	return       




	//PRONTUÁRIO MÉDICO - MDT
	User Function XMDTA410()
		Local aArea       := GetArea()
		Private cFilSra   := SRA->RA_FILIAL
		Private cMatSra   := SRA->RA_MAT
		
		dbselectarea("TM0")
		dbSetOrder(3)
		set filter to TM0_FILFUN = cFilSRA .and. TM0_MAT = cMatSra
		dbSeek( cFilSRA + cMatSra)
		If !Eof()
			cModulo := "MDT"
			nModulo := 35
			SETFUNNAME("MDTA410")
			MDTA410()
			SETFUNNAME("GPEA011")
			cModulo := "GPE"
			nModulo := 7
		Else
			MsgBox("Funcionário não possui ficha médica","Ficha Médica","STOP")
		EndIf
		Set Filter to
		RestArea(aArea)
	Return

	//FICHA DO FUNCIONARIO
	User Function XGPEA260()
		Local aArea       := GetArea()
		Private cFilSra   := SRA->RA_FILIAL
		Private cMatSra   := SRA->RA_MAT
		
		dbselectarea("SRA")
		dbSetOrder(1)
		set filter to RA_FILIAL = cFilSRA .and. RA_MAT = cMatSra
		SETFUNNAME("GPEA260")
		GPEA260()
		SETFUNNAME("GPEA011")
		Set Filter to
		RestArea(aArea)
	Return

	//PROVISOES FERIAS / 13
	User Function XGPEA070()
		Local aArea       := GetArea()
		Private cFilSra   := SRA->RA_FILIAL
		Private cMatSra   := SRA->RA_MAT
		
		dbselectarea("SRA")
		dbSetOrder(1)
		set filter to RA_FILIAL = cFilSRA .and. RA_MAT = cMatSra
		SETFUNNAME("GPEA070")
		GPEA070()
		SETFUNNAME("GPEA011")
		Set Filter to
		RestArea(aArea)
	Return

	//INTEGRAÇÃO COM WORD
	User Function XGPEXWORD()
		SETFUNNAME("GPEXWORD")
		GPEXWORD()
		SETFUNNAME("GPEA011")
	Return

	//ARQUIVO DE LIQUIDOS
	User Function XGPEM080()
		SETFUNNAME("GPEM080")
		GPEM080()
		SETFUNNAME("GPEA011")
	Return

	//IMPORTACAO DE VARIAVEIS
	User Function XGPEA210()
		SETFUNNAME("GPEA210")
		GPEA210()
		SETFUNNAME("GPEA011")
	Return

	//PLANO DE SAUDE
	User Function XGPEAT(cTipo)
		Local aArea      := GetArea()
		Local bkpaRotina := aRotina
		Default oObj	:= Nil

		If cTipo == "PLA"
			SETFUNNAME("GPEA001")
			FWExecView( "PLANOS ATIVOS", "VIEWDEF.GPEA001", MODEL_OPERATION_UPDATE, , { || .T. } )
		ElseIf cTipo == "PLACOPART"
			SETFUNNAME("GPEA003")
			Private cFilOld	:= cFilAnt
			FWExecView( "CO-PARTICIPACAO/REEMBOLSO", "VIEWDEF.GPEA003", MODEL_OPERATION_UPDATE, , { || .T. } )
		ElseIf cTipo == "PLACALC"
			SETFUNNAME("GPEM016")
			GPEM016()
		ElseIf cTipo == "PLAREL"
			SETFUNNAME("GPER008")
			GPER008()
		ElseIf cTipo == "PLAMANUT"
			SETFUNNAME("GPEA001")
			fManutCalc()
		ElseIf cTipo == "VAVRVT"
			SETFUNNAME("GPEA001")
			FWExecView( "VA / VR / VT", "VIEWDEF.GPEA133", MODEL_OPERATION_UPDATE, , { || .T. } )
		ElseIf cTipo == "VAREL"
			SETFUNNAME("GPER009")
			GPER009()
		ElseIf cTipo == "OUTMANUT"
			SETFUNNAME("GPEA065")
			FWExecView( "OUTROS BENEFICIOS", "VIEWDEF.GPEA065", MODEL_OPERATION_UPDATE, , { || .T. } )
		ElseIf cTipo == "OUTREL"
			SETFUNNAME("GPER065")
			GPER065()
		ElseIf cTipo == "CONVOC"
			If SRA->RA_TPCONTR == '3'
				SETFUNNAME("GPEA018")
				FWExecView(OemToAnsi("Convocacoes"), "GPEA018", MODEL_OPERATION_UPDATE ,,{||.T.})
			Else
				MsgBox("Funcionário não é contrato 3-Intermitente","Intermitente","STOP")
			EndIf
		ElseIf cTipo == "RATEIO"
			SETFUNNAME("GPEA056")
			FWExecView(OemToAnsi("Programação de Rateios"), "GPEA056", MODEL_OPERATION_UPDATE ,,{||.T.})
		ElseIf cTipo == "RATEIOA"
			SETFUNNAME("GPEA056A")
			FWExecView(OemToAnsi("Rateio em lote"), "GPEA056A", MODEL_OPERATION_UPDATE ,,{||.T.})
		ElseIf cTipo == "GPEA120"
			Private lItemClVl 	:= SuperGetMv( "MV_ITMCLVL", .F., "2" ) $ "1*3"
			SETFUNNAME("GPEA120M")
			FWExecView(OemToAnsi("Manutenção Acumulados"), "GPEA120", MODEL_OPERATION_UPDATE ,,{||.T.})
		ElseIf cTipo == "DISCIP"
			SETFUNNAME("GPEA643")
			FWExecView(OemToAnsi("Gestão Disciplinar"), "GPEA643", MODEL_OPERATION_INSERT ,,{||.T.})
		ElseIf cTipo == "DISCIPV"
			SETFUNNAME("GPEA644")
			FWExecView(OemToAnsi("Gestão Disciplinar - Visualizar"), "GPEA644", MODEL_OPERATION_VIEW ,,{||.T.})
		ElseIf cTipo == "TCFA040"
			SETFUNNAME("TCFA040")
			FWExecView(OemToAnsi("Atender Solicitação do APP MEU RH"), "TCFA040", MODEL_OPERATION_UPDATE ,,{||.T.})
		ElseIf cTipo == "TAFPNFUNC"
			SETFUNNAME("TAFPNFUNC")
			dbSelectArea("C9V")
			dbSetOrder(10)
			dbSeek( SRA->RA_FILIAL + SRA->RA_CIC + SRA->RA_CODUNIC)
			If !Eof()
				Private oPanelBrw	:= Nil
				Private oBrowse 	:= Nil
				Private oTree		:= Nil
				FWExecView(OemToAnsi("Painel do Trabalhador"), "TAFAPNFUNC", MODEL_OPERATION_UPDATE ,,{||.T.})
			Else
				MsgBox("Funcionário não encontrado no TAF","Não encontrado","STOP")
			EndIf
		EndIF
		SETFUNNAME("GPEA011")
		RestArea(aArea)
		aRotina := bkpaRotina
	Return

	//EVENTOS PERIODICOS
	User Function XGPEM034()
		Local aArea := GetArea()
		SETFUNNAME("GPEM034")
		GPEM034()
		RestArea(aArea)
		SETFUNNAME("GPEA011")
	Return

	//PAINEL ESOCIAL TAFA552A
	User Function XTAFA552A()
		Local aArea := GetArea()
		SETFUNNAME("TAFA552A")
		TAFA552A()
		RestArea(aArea)
		SETFUNNAME("GPEA011")
	Return

	//Conta Corrente Valores Futuros
	User Function XGPEA415()
		Local aArea       := GetArea()
		Private cFilSra   := SRA->RA_FILIAL
		Private cMatSra   := SRA->RA_MAT
		
		dbselectarea("SRA")
		dbSetOrder(1)
		set filter to RA_FILIAL = cFilSRA .and. RA_MAT = cMatSra
		SETFUNNAME("GPEA415")
		GPEA415()
		SETFUNNAME("GPEA011")
		Set Filter to
		RestArea(aArea)
	Return

	//CAD DE PARTICIPANTE - VALIDAR RDZ
	User Function XAPDA020()
		Local aArea       := GetArea()
		Private cFilSra   := SRA->RA_FILIAL
		Private cMatSra   := SRA->RA_MAT
		Private cCPF  	  := SRA->RA_CIC
		
		dbselectarea("RD0")
		dbSetOrder(6)
		set filter to RD0_FILIAL = ' ' .and. RD0_CIC = cCPF
		SETFUNNAME("APDA020")
		APDA020()
		SETFUNNAME("GPEA011")
		Set Filter to
		RestArea(aArea)
	Return


/////////////////////////////////////////////////////////////////
////////////// P.E novos botoes Integrados
/////////////////////////////////////////////////////////////////
User Function PNA280ROT(cOrig)
	Local aArea := GetArea()
	Local aRotina := ParamixB[1]

	//Relatórios
	aRotRel := {{ "Espelho Ponto"		 , "PONR010()"	 , 0 , 6 },;
				{ "Espelho Portaria 1510", "PONR140()"	 , 0 , 6 },;
				{ "Eventos Apontados"	 , "PONR020()"   , 0 , 6 },;
				{ "Resultados"      	 , "PONR090()"   , 0 , 6 },;
				{ "Abono Horas"			 , "PONR050()"   , 0 , 6 },;
				{ "Autorização Extra"	 , "PONR060()"   , 0 , 6 },;
				{ "Autorizações"		 , "PONR110()"   , 0 , 6 },;
				{ "Divergencias"    	 , "PONR040()"   , 0 , 6 },;
				{ "Pres/Ausentes"   	 , "PONR030()"   , 0 , 6 },;
				{ "Apuração Percentual"	 , "PONR080()"   , 0 , 6 },;
				{ "Absenteísmo"   		 , "ABSENT()"    , 0 , 6 },;
				{ "Quadro de Horário" 	 , "PONQDHR()"   , 0 , 6 },;
				{ "Relatório de Horas"	 , "PONR100()"   , 0 , 6 },;
				{ "Extrato Banco Horas"	 , "EXTRABH()"   , 0 , 6 };
			   	}

	//Calculos	
	aRotCalc :={{ "Integração ClockIN"	, "PONAPI01()"     , 0 , 6 },;
				{ "Leitura/Apontamento"	, "U_XPONM010()"   , 0 , 6 },;
				{ "Calculo Mensal"		, "U_XPONM070()"   , 0 , 6 },;
				{ "Abono Coletivo" 		, "U_XPONM060()"   , 0 , 6 },;
				{ "Elimina Marcações"	, "U_XPONM050()"   , 0 , 6 };
				}

	//Acumulados
	aAcumPon :={{ "Marcações"    , "U_PMPNA180()"   , 0 , 6 },;
				{ "Apontamentos" , "U_PMPNA190()"   , 0 , 6 },;
				{ "Refeições"    , "U_PMPNA270()"   , 0 , 6 },;
				{ "Resultados"   , "U_PMPNA220()"   , 0 , 6 };
				}

	aOper := {}

	aAdd( aOper,{"Afastamentos"  	, "U_XGPEA240()" , 0, 6})
	aAdd( aOper,{"Marcações"     	, "U_PMPNA040()" , 0, 6})
	aAdd( aOper,{"Apontamentos"  	, "U_PMPNA130()" , 0, 6})
	aAdd( aOper,{"Resultados"    	, "U_PMPNA170()" , 0, 6})
	aAdd( aOper,{"Banco Horas"   	, "U_PMPNA200()" , 0, 6})
	aAdd( aOper,{"Exceções Per." 	, "U_PMPNA090()" , 0, 6})
	aAdd( aOper,{"Trocas Turno"  	, "U_PMPNA160()" , 0, 6})
	//aAdd( aPonto,{"Cracha Provis.", "U_PMPNA120()" , 0, 6})
	aAdd( aOper,{"Refeições"     	, "U_PMPNA150()" , 0, 6})


	aAdd( aRotina,{"* Operações..."		, aOper			 ,0, 6,,.F. } )
	aAdd( aRotina,{"* Cálculos..."  	, aRotCalc       ,0, 6,,.F. } )
	aAdd( aRotina,{"* Relatórios..."	, aRotRel        ,0, 6,,.F. } )
	aAdd( aRotina,{"* Acumulados..."	, aAcumPon       ,0, 6,,.F. } )

	RestArea(aArea)
Return (aRotina)


/////////////////////////////////////////////////////////////////
////////////// PONTO ELETRONICO
/////////////////////////////////////////////////////////////////

	//AFASTAMENTOS
	User Function XGPEA240()
		Local aArea       := GetArea()
		Private cFilSra   := SRA->RA_FILIAL
		Private cMatSra   := SRA->RA_MAT
		
		dbselectarea("SRA")
		dbSetOrder(1)
		set filter to RA_FILIAL = cFilSRA .and. RA_MAT = cMatSra
		SETFUNNAME("GPEA240")
		GPEA240()
		SETFUNNAME("PONA280")
		Set Filter to
		RestArea(aArea)
	Return
	

	//Integrados (quando chamado pela Folha)
	User Function XPONA280()
		Local aArea       := GetArea()
		Private cFilSra   := SRA->RA_FILIAL
		Private cMatSra   := SRA->RA_MAT

		cModulo := "PON"
		nModulo := 16
		dbselectarea("SRA")
		dbSetOrder(1)
		set filter to RA_FILIAL = cFilSRA .and. RA_MAT = cMatSra
		SETFUNNAME("PONA280")
		PONA280()
		SETFUNNAME("GPEA011")
		cModulo := "GPE"
		nModulo := 7
		Set Filter to
		RestArea(aArea)
	Return

	//Marcacoes
	User Function PMPNA040()
		Local aArea       := GetArea()
		Private cFilSra   := SRA->RA_FILIAL
		Private cMatSra   := SRA->RA_MAT
		
		dbselectarea("SRA")
		dbSetOrder(1)
		set filter to RA_FILIAL = cFilSRA .and. RA_MAT = cMatSra
		SETFUNNAME("PONA040")
		Pona040()
		SETFUNNAME("PONA280")
		Set Filter to
		RestArea(aArea)
	Return

	//Apontamentos
	User Function PMPNA130()
		Local aArea       := GetArea()
		Private cFilSra   := SRA->RA_FILIAL
		Private cMatSra   := SRA->RA_MAT
		Private lMemoria  := .T.
		
		dbselectarea("SRA")
		dbSetOrder(1)
		set filter to RA_FILIAL = cFilSRA .and. RA_MAT = cMatSra
		SETFUNNAME("PONA130")
		Pona130()
		SETFUNNAME("PONA280")
		Set Filter to
		RestArea(aArea)
	Return
	
	//Resultados
	User Function PMPNA170()
		Local aArea       := GetArea()
		Private cFilSra   := SRA->RA_FILIAL
		Private cMatSra   := SRA->RA_MAT
		
		dbselectarea("SRA")
		dbSetOrder(1)
		set filter to RA_FILIAL = cFilSRA .and. RA_MAT = cMatSra
		SETFUNNAME("PONA170")
		PONA170()
		SETFUNNAME("PONA280")
		Set Filter to
		RestArea(aArea)
	Return
	
	//Refeicoes
	User Function PMPNA150()
		Local aArea       := GetArea()
		Private cFilSra   := SRA->RA_FILIAL
		Private cMatSra   := SRA->RA_MAT
		
		dbselectarea("SRA")
		dbSetOrder(1)
		set filter to RA_FILIAL = cFilSRA .and. RA_MAT = cMatSra
		SETFUNNAME("PONA150")
		PONA150()
		SETFUNNAME("PONA280")
		Set Filter to
		RestArea(aArea)
	Return
	
	//Banco de horas
	User Function PMPNA200()
		Local aArea       := GetArea()
		Private cFilSra   := SRA->RA_FILIAL
		Private cMatSra   := SRA->RA_MAT
		
		dbselectarea("SRA")
		dbSetOrder(1)
		set filter to RA_FILIAL = cFilSRA .and. RA_MAT = cMatSra
		SETFUNNAME("PONA200")
		PONA200()
		SETFUNNAME("PONA280")
		Set Filter to
		RestArea(aArea)
	Return
	
	//Trocas de Turno
	User Function PMPNA160()
		Local aArea       := GetArea()
		Private cFilSra   := SRA->RA_FILIAL
		Private cMatSra   := SRA->RA_MAT
		
		dbselectarea("SRA")
		dbSetOrder(1)
		set filter to RA_FILIAL = cFilSRA .and. RA_MAT = cMatSra
		SETFUNNAME("PONA160")
		PONA160()
		SETFUNNAME("PONA280")
		Set Filter to
		RestArea(aArea)
	Return
	
	//CRACHA PROVISÓRIO
	User Function PMPNA120()
		Local aArea       := GetArea()
		Private cFilSra   := SRA->RA_FILIAL
		Private cMatSra   := SRA->RA_MAT
		
		dbselectarea("SRA")
		dbSetOrder(1)
		set filter to RA_FILIAL = cFilSRA .and. RA_MAT = cMatSra
		SETFUNNAME("PONA120")
		PONA120()
		SETFUNNAME("PONA280")
		Set Filter to
		RestArea(aArea)
	Return

	//Acumulados Marcacoes
	User Function PMPNA180()
		Local aArea       := GetArea()
		Private cFilSra   := SRA->RA_FILIAL
		Private cMatSra   := SRA->RA_MAT
		
		dbselectarea("SRA")
		dbSetOrder(1)
		set filter to RA_FILIAL = cFilSRA .and. RA_MAT = cMatSra
		SETFUNNAME("PONA180")
		PONA180()
		SETFUNNAME("PONA280")
		Set Filter to
		RestArea(aArea)
	Return

	//Acumulados Apontamentos
	User Function PMPNA190()
		Local aArea       := GetArea()
		Private cFilSra   := SRA->RA_FILIAL
		Private cMatSra   := SRA->RA_MAT
		
		dbselectarea("SRA")
		dbSetOrder(1)
		set filter to RA_FILIAL = cFilSRA .and. RA_MAT = cMatSra
		SETFUNNAME("PONA190")
		PONA190()
		SETFUNNAME("PONA280")
		Set Filter to
		RestArea(aArea)
	Return

	//Acumulados Refeições
	User Function PMPNA270()
		Local aArea       := GetArea()
		Private cFilSra   := SRA->RA_FILIAL
		Private cMatSra   := SRA->RA_MAT
		
		dbselectarea("SRA")
		dbSetOrder(1)
		set filter to RA_FILIAL = cFilSRA .and. RA_MAT = cMatSra
		SETFUNNAME("PONA270")
		PONA270()
		SETFUNNAME("PONA280")
		Set Filter to
		RestArea(aArea)
	Return

	//Acumulados Resultados
	User Function PMPNA220()
		Local aArea       := GetArea()
		Private cFilSra   := SRA->RA_FILIAL
		Private cMatSra   := SRA->RA_MAT
		
		dbselectarea("SRA")
		dbSetOrder(1)
		set filter to RA_FILIAL = cFilSRA .and. RA_MAT = cMatSra
		SETFUNNAME("PONA220")
		PONA220()
		SETFUNNAME("PONA280")
		Set Filter to
		RestArea(aArea)
	Return

	//Exceções por Período
	User Function PMPNA090()
		Local aArea       := GetArea()
		Private cFilSra   := SRA->RA_FILIAL
		Private cMatSra   := SRA->RA_MAT
		
		dbselectarea("SP2")
		dbSetOrder(1)
		set filter to P2_FILIAL = cFilSRA .and. P2_MAT = cMatSra
		SETFUNNAME("PONA090")
		PONA090()
		SETFUNNAME("PONA280")
		Set Filter to
		RestArea(aArea)
	Return

	//LEITURA/APONTAMENTO
	User Function XPONM010()
		SETFUNNAME("PONM010")
		PONM010()
		SETFUNNAME("PONA280")
	Return

	//CALCULO MENSAL
	User Function XPONM070()
		SETFUNNAME("PONM070")
		PONM070()
		SETFUNNAME("PONA280")
	Return

	//ABONO COLETIVO
	User Function XPONM060()
		SETFUNNAME("PONM060")
		PONM060()
		SETFUNNAME("PONA280")
	Return

	//ELIMINAR MARCAÇÕES
	User Function XPONM050()
		SETFUNNAME("PONM050")
		PONM050()
		SETFUNNAME("PONA280")
	Return
