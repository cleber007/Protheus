//#Include "PROTHEUS.CH"
//#Include "RWMAKE.CH"
#Include "AP5MAIL.CH"
#Include "Totvs.ch"
/***************************************************************************************************************************************************************\
| Programa  | manutOD				| Autor | Sergio Coelho		                               											 	| Data | 28/04/2021 |
|***********|***************************************************************************************************************************************************|
| Descricao | Cadastro de Ocorrências de Divergências                                                       													|
|           | 																									    											|
|***********|***************************************************************************************************************************************************|
| Uso       | Estoque / Compras				                                               																		|
|***************************************************************************************************************************************************************|
|                                                						A L T E R A Ç Õ E S						             									| 
|***************************************************************************************************************************************************************|
|04/06/2021 | Sergio Coelho: 																																	|
|           | Ao aplicar essa customização nas outras Empresas do Grupo Alubar diferente da 06-AMC, ocorre do sistema trazer informações erradas. Corrigido  as |
|           | consultas onde a tabela XA3060 estava sendo informada diretament no código fonte. Para  as  tabelas  XA1,  XA2,  XA3,  XA4,  XA5 e  XA6 a rotina  |
|           | RetSQLName() não traz o nome completo da tabela, ou seja, não traz o sufixo da filial. O mesmo ocorre com comando BeginSQL...EndSQL.				|
|           | Sendo assim, foram criadas as variáveis cXA2Tab, cXA3Tab para receber o nome da tabela diretamente da tabela SX2.
\***************************************************************************************************************************************************************/
*****************************************************************************************************************************************************************
User Function manutOD()  
*****************************************************************************************************************************************************************
	Local _aArea		:= GetARea()
	//Local _cAlias  := "XA3"  
	//Local _cTitulo := "Ocorrencia de Divergencia"  
	//Local aRotAdic := {}    
	Local aCores := U_odCor()	

	Private cMailConta			:= ""
	Private cMailServer			:= ""
	Private cMailSenha			:=	""
	Private cEmailto				:= ""
	Private cObsREL_1 			:= Space(100)
	Private cObsREL_2 			:= Space(100)
	Private cObsREL_3 			:= Space(100)
	Private cObsREL_4 			:= Space(100)
	Private cObsREL_5 			:= Space(100)
	Private cObsREL_6 			:= Space(100)
	Private cObsREL_7 			:= Space(100)
	Private cObsREL_8 			:= Space(100)
	Private cObsREL_9 			:= Space(100)
	Private cObsREL_10			:= Space(100)
	Private nLongitudLinea   	:= 100
	Private nTamanoTabulador	:= 3
	Private lSaltoLinea      	:= .T.
	Private cLinea
	Private nLineas
	Private nLineaActual
	Private cTit
	Private cBody
	/* 04/06/2021 - Sergio Coelho. Mais DetalhesAo na Área Alterações do Cabeçalho Inicial */
	Private cXA2Tab    := RTrim(Posicione("SX2",1,"XA2","(X2_ARQUIVO)"))
	Private cXA3Tab    := RTrim(Posicione("SX2",1,"XA3","(X2_ARQUIVO)"))

	Private cCadastro	:= "Ocorrencias de Divergencias"
	Private aRotina 	:=	{	{"Pesquisar"   				,"AxPesqui"          				,0	,1	}	,;
   	           				{"Visualizar"					,"AxVisual"          				,0	,2	}	}        

   	           				//{"Visualizar"					,"AxVisual"          				,0	,2	}	,;   	           				
      	        				//{"Incluir"    					,'ExecBlock("XA3i",.F.,.F.)'		,0	,3	}	,;
         	     				//{"Alterar"    					,'ExecBlock("XA3a",.F.,.F.)'		,0	,4	}	,;
            	  				//{"Excluir"  	 	 			,'ExecBlock("XA3e",.F.,.F.)'		,0	,5	}	,;
            	  				//{"Imprimir OD"    			,'ExecBlock("impXA3",.F.,.F.)'	,0	,6	}	,;
            	  				//{"Encerrar OD"    			,'ExecBlock("encXA3",.F.,.F.)'	,0	,6	}	,;
            	  				//{"Estornar Encerramento"	,'ExecBlock("estXA3",.F.,.F.)'	,0	,6	}	,;
            	  				//{"Informar Compras"    		,'ExecBlock("comXA3",.F.,.F.)'	,0	,6	}	,;
	           	  				//{"Informar Almoxarifado"   ,'ExecBlock("almXA3",.F.,.F.)'	,0	,6	}	,;
									//{"Legenda"						,"U_odLEGx"								,0	,6	}	}   
   /*         	  				
	Private _cXA1_OD := iif(ALLTRIM(UPPER(FunName())) == "IMPORTNFE",XA1->XA1_OD,"") //23/02/17 - FABIO YOSHIOKA   
	Private _cXA1_NF := iif(ALLTRIM(UPPER(FunName())) == "IMPORTNFE",XA1->XA1_NFISCA,"") //23/02/17 - FABIO YOSHIOKA   
	Private _cXA1_SER:= iif(ALLTRIM(UPPER(FunName())) == "IMPORTNFE",XA1->XA1_SERIE,"") //23/02/17 - FABIO YOSHIOKA   	
	Private _cXA1_FOR:= iif(ALLTRIM(UPPER(FunName())) == "IMPORTNFE",XA1->XA1_CLIFOR,"") //23/02/17 - FABIO YOSHIOKA   		
	Private _cXA1_LOJ:= iif(ALLTRIM(UPPER(FunName())) == "IMPORTNFE",XA1->XA1_LOJA,"") //23/02/17 - FABIO YOSHIOKA   			
	Private _CXA1_REC:= iif(ALLTRIM(UPPER(FunName())) == "IMPORTNFE",XA1->XA1_DTRECE,STOD(SPACE(8))) //06/03/17 - FABIO YOSHIOKA   
	                                                                                                                                      
	*/

Private _cXA1_OD := iif(ALLTRIM(UPPER(FunName())) == "IMPORTNFE" .OR. ALLTRIM(UPPER(FunName())) == "ENTREGALM",XA1->XA1_OD,"") //23/02/17 - FABIO YOSHIOKA
Private _cXA1_NF := iif(ALLTRIM(UPPER(FunName())) == "IMPORTNFE" .OR. ALLTRIM(UPPER(FunName())) == "ENTREGALM",XA1->XA1_NFISCA,"") //23/02/17 - FABIO YOSHIOKA
Private _cXA1_SER:= iif(ALLTRIM(UPPER(FunName())) == "IMPORTNFE" .OR. ALLTRIM(UPPER(FunName())) == "ENTREGALM",XA1->XA1_SERIE,"") //23/02/17 - FABIO YOSHIOKA
Private _cXA1_FOR:= iif(ALLTRIM(UPPER(FunName())) == "IMPORTNFE" .OR. ALLTRIM(UPPER(FunName())) == "ENTREGALM",XA1->XA1_CLIFOR,"") //23/02/17 - FABIO YOSHIOKA
Private _cXA1_LOJ:= iif(ALLTRIM(UPPER(FunName())) == "IMPORTNFE" .OR. ALLTRIM(UPPER(FunName())) == "ENTREGALM",XA1->XA1_LOJA,"") //23/02/17 - FABIO YOSHIOKA
Private _CXA1_REC:= iif(ALLTRIM(UPPER(FunName())) == "IMPORTNFE" .OR. ALLTRIM(UPPER(FunName())) == "ENTREGALM",XA1->XA1_DTRECE,STOD(SPACE(8))) //06/03/17 - FABIO YOSHIOKA

Private _cCodusr := Posicione("XA5",1,xFilial("XA5") + __cUSERID,"XA5_USU")
Private _cRecAlm := Posicione("XA5",1,xFilial("XA5") + __cUSERID,"XA5_RECALM")
Private _cPC     := Posicione("XA5",1,xFilial("XA5") + __cUSERID,"XA5_PC")
Private _cDept   := Posicione("XA5",1,xFilial("XA5") + __cUSERID,"XA5_COD")

If Alltrim(_cCodusr) <> "" .AND. ( Alltrim(_cDept) == "000001" .OR. Alltrim(_cDept) == "000003")
	aadd(aRotina, {"Incluir"              , 'ExecBlock("XA3i",.F.,.F.)'     , 0, 3})
	aadd(aRotina, {"Alterar"              , 'ExecBlock("XA3a",.F.,.F.)'     , 0, 4})
	aadd(aRotina, {"Excluir"              , 'ExecBlock("XA3e",.F.,.F.)'     , 0, 5})
	aadd(aRotina, {"Imprimir OD"          , 'ExecBlock("impXA3",.F.,.F.)'   , 0, 6})
	aadd(aRotina, {"Encerrar OD"          , 'ExecBlock("encXA3",.F.,.F.)'   , 0, 6})
	aadd(aRotina, {"Informar Compras"     , 'ExecBlock("comXA3",.F.,.F.)'   , 0, 6})
	aadd(aRotina, {"Informar Almoxarifado", 'ExecBlock("almXA3",.F.,.F.)'   , 0, 6})
	aadd(aRotina, {"Retornar Status"      , 'ExecBlock("AdmXA30D",.F.,.F.)' , 0, 6})
	aadd(aRotina, {"Relatorio Excel"      , 'ExecBlock("RelEsrXA3",.F.,.F.)', 0, 6})
	aadd(aRotina, {"Legenda"              , "U_odLEGx"                      , 0, 6})
	aadd(aRotina, {"Conhecimento"         , "MSDOCUMENT"                    , 0, 4}) //conhecimento - 06/02/17 - Fabio Yoshioka

Else
	aadd(aRotina, {"Incluir"              , 'ExecBlock("XA3Negt",.F.,.F.)', 0, 3})
	aadd(aRotina, {"Alterar"              , 'ExecBlock("XA3Negt",.F.,.F.)', 0, 4})
	aadd(aRotina, {"Excluir"              , 'ExecBlock("XA3Negt",.F.,.F.)', 0, 5})
	aadd(aRotina, {"Imprimir OD"          , 'ExecBlock("impXA3",.F.,.F.)' , 0, 6})
	aadd(aRotina, {"Legenda"              , "U_odLEGx"                    , 0, 6})
	aadd(aRotina, {"Conhecimento"         , "MSDOCUMENT"                  , 0, 4}) //conhecimento - 06/02/17 - Fabio Yoshioka
	aadd(aRotina, {"Informar Compras"     , 'ExecBlock("comXA3",.F.,.F.)' , 0, 6})
	aadd(aRotina, {"Informar Almoxarifado", 'ExecBlock("almXA3",.F.,.F.)' , 0, 6})
Endif

//If ALLTRIM(UPPER(FunName())) == "IMPORTNFE" //23/02/17    - FABIO YOSHIOKA
IF ALLTRIM(UPPER(FunName())) == "IMPORTNFE" .OR. ALLTRIM(UPPER(FunName())) == "ENTREGALM"
	_aIndXA3:={}
	//_condXA3    := "XA3->XA3_NUM ='"+_cXA1_OD+"'"
	_condXA3    := "XA3->XA3_NOTA ='"+_cXA1_NF+"' .AND.  XA3->XA3_SERIE ='"+_cXA1_SER+"' .AND. XA3->XA3_FORNEC ='"+_cXA1_FOR+"' .AND. XA3->XA3_LOJA ='"+_cXA1_LOJ+"'"


	bFiltraBrw := {|| FilBrowse("XA3",@_aIndXA3,@_condXA3) }
	Eval(bFiltraBrw)

	mBrowse( 6,1,22,75,"XA3",,,,,,aCores)
	aEval(_aIndXA3,{|x| Ferase(x[1]+OrdBagExt())})
	ENDFILBRW('XA3',_aIndXA3)
ELSE
	dbSelectarea("XA3")
	mBrowse(006,001,022,075,"XA3",,,,,,aCores,,,,,,,,,,,,)

	dbSelectarea("XA3")
	XA3->(dbSetorder(1))

ENDIF

RestArea(_aArea)

/*	dbSelectarea("XA3")
	mBrowse(006,001,022,075,"XA3",,,,,,aCores,,,,,,,,,,,,)

	dbSelectarea("XA3")
	XA3->(dbSetorder(1))
	RestArea(_aArea)*/
	
/*
	aadd(aRotAdic,{"Imprimir OD"					,"U_impXA3"	,0,6})
	aadd(aRotAdic,{"Encerrar OD"					,"U_encXA3"	,0,6})
	aadd(aRotAdic,{"Estornar Encerramento"		,"U_estXA3"	,0,6})
	aadd(aRotAdic,{"Informar Compras"			,"U_comXA3"	,0,6})
	aadd(aRotAdic,{"Informar Almoxarifado"		,"U_almXA3"	,0,6})

	axCadastro(_cAlias,_cTitulo,"U_delXA3()","U_okXA3()",aRotAdic,/*bPre*/ //,/*bOK*/,/*bTTS*/,/*bNoTTS*/,/*aAuto*/,/*nOpcAuto*/,/*aButtons*/,/*aACS*/,/*cTela*///) */

Return(nil)

User Function odCor()
*****************************************************************************************************************************************************************
Local aCores	:=	{	{"Alltrim(DTOS(XA3_CONCLU))=='' .AND. Alltrim(DTOS(XA3_DTCOM)) <> ''"	,"BR_VERDE"			}	,; 
						{"Alltrim(DTOS(XA3_CONCLU))=='' .AND. Alltrim(DTOS(XA3_DTALM)) <> ''"	,"BR_AMARELO"		}	,; 
						{"Alltrim(DTOS(XA3_CONCLU))<>''"	,"BR_VERMELHO"	}	} 
Return(aCores)
*****************************************************************************************************************************************************************
User Function statusOD()
*****************************************************************************************************************************************************************

Local cRet	:=	""
dbSelectarea("XA3")

	Do CASE
		case Alltrim(DTOS(XA3->XA3_CONCLU))== '' .AND. Alltrim(DTOS(XA3->XA3_DTCOM)) <> ''
			cRet := "OD Em Andamento-Compras"
		case Alltrim(DTOS(XA3->XA3_CONCLU))== '' .AND. Alltrim(DTOS(XA3->XA3_DTALM)) <> ''
			cRet := "OD Em Andamento-Almox"
		case Alltrim(DTOS(XA3->XA3_CONCLU))<> ''
			cRet := "OD Encerrada"
	Endcase

Return(cRet)
*****************************************************************************************************************************************************************

*****************************************************************************************************************************************************************
User Function odLEGx(aCores)
*****************************************************************************************************************************************************************
Local aLegenda := {}
	
aAdd(aLegenda	,{"BR_VERDE"	 	,"OD Aberta"					})
aAdd(aLegenda	,{"BR_AMARELO"	 	,"OD Em Andamento-Almox"	})
aAdd(aLegenda	,{"BR_VERMELHO"	,"OD Encerrada"				})
	
BrwLegenda(cCadastro,"Legenda",aLegenda)
Return(nil)
*****************************************************************************************************************************************************************

*****************************************************************************************************************************************************************
User Function XA3i()
*****************************************************************************************************************************************************************
Local _Order  	:= Indexord() 
Local _Recno  	:= Recno()
Local _cAlias 	:= "XA3"  
Local _nOpcInclu:=0  
Local _aAreaxa1 := XA1->(GetArea())  
Local _chvXA3:=""//M->XA3_NOTA+ M->XA3_SERIE+ M->XA3_FORNEC+ M->XA3_LOJA //06/03/17

//AxInclui(_cAlias,_Recno,3,,,,,,,,)     
_nOpcInclu:=AxInclui(_cAlias,_Recno,3,,,,,,,,)     
	
if _nOpcInclu==1  // 23/02/17 - Fabio Yoshioka 
	_chvXA3:=XA3->XA3_NOTA+ XA3->XA3_SERIE+ XA3->XA3_FORNEC+ XA3->XA3_LOJA //06/03/17 

	dbSelectArea("XA1")
	XA1->(dbSetOrder(1))
	If XA1->(dbSeek(xFilial("XA1") + _chvXA3))
		RecLock("XA1",.F.)
		//XA1->XA1_STATUS 	:= "2"
		XA1->XA1_OD 		:= XA3->XA3_NUM
		XA1->XA1_DTABOD 	:= dDatabase
		XA1->(MsUnlock())
		XA1->(dbCommitAll())
	ENDIF
endif

RestArea(_aAreaxa1)
	
XA3->(dbSetOrder(_Order))
Return()
*****************************************************************************************************************************************************************

*****************************************************************************************************************************************************************
User Function XA3a()
*****************************************************************************************************************************************************************
Local _Order  	:= Indexord()
Local _Recno  	:= Recno()
Local _cAlias 	:= "XA3"
Local _cUsrAlt := &('RETCODUSR()')
Local _lAlmox  := .F.
Local _lRetAlt := .T.

If Alltrim(dtos(XA3->XA3_CONCLU)) <> ""                        
	Aviso("Aviso","OD Encerrada. Impossivel altera-la.",{"Ok"})
	Return()
Endif
       
DBSelectArea("XA5")
DBSetOrder(1)
If DBSeek(xFilial("XA5")+_cUsrAlt+"000001")
	_lAlmox := .T.
EndIf
	
If _lAlmox
		_lRetAlt := U_VldTok(_cUsrAlt)
EndIf
	
  If !_lRetAlt
	Return()   
Endif

AxAltera(_cAlias,_Recno,4,,,,,,,,,)

XA3->(dbSetOrder(_Order))
XA3->(Dbgoto(_Recno))

Return() 
*****************************************************************************************************************************************************************

*****************************************************************************************************************************************************************
User Function VldTok(_cUsrAlt)
*****************************************************************************************************************************************************************
Local _lRet   := .T.
Local _CodAlt := _cUsrAlt
Local cUpdate := ""

If XA3->XA3_USRINC#_CodAlt
	If MsgYesNo("O usuário que realizou a inclusão da O.D. foi "+UsrRetName(XA3-> XA3_USRINC)+;
               " diverge com seu o usuário, tem certeza que deseja realizar a alteração?")
		_lRet := .T.
		
		cUpdate := " "
		cUpdate += " UPDATE " + cXA3Tab + " "
		cUpdate += " 	SET   XA3_USRALT = "+_CodAlt+"   "
		cUpdate += " WHERE 	XA3_FILIAL  = '"+ xFilial("XA3")   +"'  "
		cUpdate += " 	AND	XA3_NUM     = '"+XA3->XA3_NUM +"'  "
		cUpdate += " 	AND	D_E_L_E_T_ <> '*'             "
		TcSqlExec(cUpdate)
		
   Else
		_lRet := .F.
	EndIf
EndIf 

Return(_lRet)
*****************************************************************************************************************************************************************

*****************************************************************************************************************************************************************
User Function XA3e()
*****************************************************************************************************************************************************************
Local _Order  	:= Indexord()
Local _Recno  	:= Recno()
Local _cAlias	:= "XA3"
   
If Alltrim(dtos(XA3->XA3_CONCLU)) <> ""                        
	Aviso("Aviso","OD Encerrada. Impossivel exclui-la.",{"Ok"})
	Return()
Endif
	
AxDeleta(_cAlias,_Recno,5,,,,,)

XA3->(dbSetOrder(_Order))
Return()
*****************************************************************************************************************************************************************
/*
*****************************************************************************************************************************************************************
User Function delXA3()  
*****************************************************************************************************************************************************************
Local _lRet := .T.
	
If Alltrim(dtos(XA3->XA3_CONCLU)) <> ""                        
	_lRet := .F.
	Aviso("Aviso","OD Encerrada. Impossivel exclui-la.",{"Ok"})

	dbSelectarea("XA1")
	XA1->(dbSetorder(1))
	XA1->(dbGotop())
Endif
Return(_lRet)
*****************************************************************************************************************************************************************
*/
/*
*****************************************************************************************************************************************************************
User Function okXA3()                                            
*****************************************************************************************************************************************************************
Local _lRet := .T.

If ALTERA
	If Alltrim(dtos(M->XA3_CONCLU)) <> ""                        
		_lRet := .F.
		Aviso("Aviso","OD Encerrada. Impossivel altera-la.",{"Ok"})
	Endif
Endif
Return(_lRet)
*****************************************************************************************************************************************************************
*/
*****************************************************************************************************************************************************************
User Function encXA3()
	*****************************************************************************************************************************************************************
//Local oFont1 := TFont():New("MS Sans Serif",,018,,.T.,,,,,.F.,.F.)
	Local oFont2 := TFont():New("MS Sans Serif",,016,,.F.,,,,,.F.,.F.)
	Local oGet1
	Local cGet1 := XA3->XA3_NUM
	Local oGet2
	Local cGet2 := XA3->XA3_NOTA
	Local oGet3
	Local cGet3 := XA3->XA3_SERIE
	Local oGroup1
	Local oGroup2
	Local oMultiGe1
	Local cMultiGe1 := ""
	Local oSay1
	Local oSay2
	Local oSay3
	Local oSButton1
	Local lOk     := .F.
	Static oDlg

	If Alltrim(dtos(XA3->XA3_CONCLU)) <> ""
		Aviso("Aviso","OD ja encerrada.",{"Ok"})
		Return()
	Endif

	If Alltrim(dtos(XA3->XA3_DTALM)) == ""
		Aviso("Aviso","OD sem status de 'Em andamento'.",{"Ok"})
		Return()
	Endif

	If MsgYesNo("Confirma encerramento da OD?")
		dbSelectarea("XA1")
		XA1->(dbSetorder(1))
		XA1->(dbGotop())

		If XA1->(dbSeek(xFilial("XA1") + XA3->XA3_NOTA + XA3->XA3_SERIE + XA3->XA3_FORNECE + XA3->XA3_LOJA))

			//RAFAEL ALMEIDA - SIGACORP (22/12/2016)
			DEFINE MSDIALOG oDlg TITLE "Tréplica - O.D. " FROM 000, 000  TO 300, 500 COLORS 0, 16777215 PIXEL

			@ 008, 004 GROUP oGroup1 TO 051, 244 PROMPT "  OCORRÊNCIA DIVERGÊNCIA  " OF oDlg COLOR 16711680, 16777215 PIXEL
			@ 018, 010 SAY oSay1 PROMPT "Numero O.D." SIZE 034, 007 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL
			@ 018, 099 SAY oSay2 PROMPT "Nota Fiscal" SIZE 041, 007 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL
			@ 018, 191 SAY oSay3 PROMPT "Serie" SIZE 025, 007 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL
			@ 030, 010 MSGET oGet1 VAR cGet1 SIZE 082, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
			@ 030, 099 MSGET oGet2 VAR cGet2 SIZE 082, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
			@ 030, 191 MSGET oGet3 VAR cGet3 SIZE 029, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
			@ 056, 004 GROUP oGroup2 TO 132, 243 PROMPT "  COMPLEMENTO - O.D.  " OF oDlg COLOR 16711680, 16777215 PIXEL
			@ 069, 009 GET oMultiGe1 VAR cMultiGe1  VALID !Empty(cMultiGe1) OF oDlg MULTILINE SIZE 228, 053 COLORS 0, 16777215 HSCROLL PIXEL
			DEFINE SBUTTON oSButton1 FROM 135, 217 TYPE 01 ACTION ( lOk := .T.,oDlg:End())OF oDlg ENABLE

			ACTIVATE MSDIALOG oDlg CENTERED Valid U_lGetMemo(cMultiGe1)

			If lOk

				RecLock("XA1",.F.)
				XA1->XA1_STATUS 	:= "2"
				XA1->XA1_OD 		:= XA3->XA3_NUM
				XA1->XA1_DTCOOD 	:= dDatabase
				XA1->(MsUnlock())
				XA1->(dbCommitAll())

				RecLock("XA3",.F.)
				XA3->XA3_CONCLU 	:= dDatabase
				XA3->XA3_TREPLI   := cMultiGe1 //RAFAEL ALMEIDA - SIGACORP (22/12/2016)
				XA3->(MsUnlock())
				XA3->(dbCommitAll())

				//		Notificação de encerramento de OD  - RAFAEL ALMEIDA - SIGACORP 16/10/2015
				U_encXA3mail()

			EndIf
		Else
			Aviso("Aviso","Nota Fiscal nao encontrada. Efetue a importacao da Nota",{"Ok"})
		Endif
	Endif

Return(nil)
	*****************************************************************************************************************************************************************
/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  lGetVar   º Autor ³ RAFAEL ALMEIDA-SIGACORPº Data ³ 02/11/16 º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Função de validação caso o usuario TENTE fechar a janela   º±±
	±±º          ³ sem informar o numero da GUIA GNRE.                        º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ INFOGNRE                                                   º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
	*****************************************************************************************************************************************************************
User Function lGetMemo(cMultiGe1)
	*****************************************************************************************************************************************************************
	Local _lRet := .T.
	Local _cMemo := cMultiGe1

	If Empty(_cMemo)
		_lRet := .F.
		MsgInfo("Por Favor, informar a tréplica da ação corretiva.","Informar")
	EndIf

Return(_lRet)
	*****************************************************************************************************************************************************************

	*****************************************************************************************************************************************************************
User Function estXA3()
	*****************************************************************************************************************************************************************
	If Alltrim(dtos(XA3->XA3_CONCLU)) == ""
		Aviso("Aviso","OD nao encerrada.",{"Ok"})
		Return()
	Endif

	If MsgNoYes("Confirma estorno do encerramento da OD?")
		dbSelectarea("XA1")
		XA1->(dbSetorder(1))
		XA1->(dbGotop())

		If XA1->(dbSeek(xFilial("XA1") + XA3->XA3_NOTA + XA3->XA3_SERIE + XA3->XA3_FORNECE + XA3->XA3_LOJA))
			RecLock("XA1",.F.)
			XA1->XA1_STATUS 	:= " "
			XA1->XA1_OD 		:= ""
			XA1->XA1_DTCOOD 	:= ctod("  /  /  ")
			XA1->(MsUnlock())
			XA1->(dbCommitAll())

			RecLock("XA3",.F.)
			XA3->XA3_CONCLU 	:= ctod("  /  /  ")
			XA3->(MsUnlock())
			XA3->(dbCommitAll())
		Else
			Aviso("Aviso","Nota Fiscal nao encontrada. Efetue a importacao da Nota",{"Ok"})
		Endif
	Endif
Return(nil)
	*****************************************************************************************************************************************************************

	*****************************************************************************************************************************************************************
User Function comXA3()
	*****************************************************************************************************************************************************************
	Local lOk
	Local _cPerg := "PARAMXA3"

	If Alltrim(dtos(XA3->XA3_CONCLU)) <> ""
		Aviso("Aviso","OD ja concluida.",{"Ok"})
		Return()
	Endif

	If Pergunte(_cPerg,.T.)
		cEmailto	:= Alltrim(MV_PAR01)

		Processa( {|| geraEML(1) }, "A g u a r d e", "Gerando e-mail...",.F.)

		lOK := U_FSendMail(cEmailto, cTit, cBody, 60, 2)

		If lOk
			RecLock("XA3",.F.)
			XA3->XA3_DTCOM	:= dDatabase
			XA3->XA3_DTALM	:= ctod("  /  /  ")
			XA3->(MsUnlock())
			XA3->(dbCommitAll())

			Aviso("Aviso","E-mail ao compras enviado com sucesso.",{"Ok"})
		Endif
	Endif

Return()
	*****************************************************************************************************************************************************************

	*****************************************************************************************************************************************************************
User Function almXA3()
	*****************************************************************************************************************************************************************
	Local lOk := .f.
	Local _cPerg := "PARAMXA3"
	local lRet		:= .F.

	local cFrom	   	:= GetMV("MV_RELACNT")
	local cConta   	:= GetMV("MV_RELACNT")
	local cSenhaX  	:= GetMV("MV_RELPSW")
	local lRelauth 	:= GetNewPar("MV_RELAUTH",.F.)		// Parametro que indica se existe autenticacao no e-mail

	If Alltrim(dtos(XA3->XA3_CONCLU)) <> ""
		Aviso("Aviso","OD ja concluida.",{"Ok"})
		Return()
	Endif

	If Pergunte(_cPerg,.T.)

		_cEmailto	:= Alltrim(MV_PAR02)
		//³ Tenta conexao com o servidor de E-Mail ³
		CONNECT SMTP SERVER GetMV("MV_RELSERV");					// Nome do servidor de e-mail
		ACCOUNT GetMV("MV_RELACNT") PASSWORD GetMV("MV_RELPSW");	// Nome da conta e senha a ser usada no e-mail
		RESULT lOk             									// Resultado da tentativa de conexão

		If lOk
			geraEML(2)

			// Se existe autenticacao para envio valida pela funcao MAILAUTH
			If lRelauth
				lRet := Mailauth(cConta,cSenhaX)
			Else
				lRet := .T.
			Endif

			If lRet

				SEND MAIL FROM	cFrom ;
					TO _cEmailTo ;
					SUBJECT cTit ;
					BODY cBody ;
					RESULT lOk

				If !lOk
					//Erro no envio do email
					GET MAIL ERROR cError
					MsgStop("Erro no envio de e-mail","erro de envio")
				Else
					DISCONNECT SMTP SERVER

					RecLock("XA3",.F.)
					XA3->XA3_DTALM	:= dDatabase
					XA3->XA3_DTCOM	:= ctod("  /  /  ")
					XA3->(MsUnlock())
					XA3->(dbCommitAll())
					Aviso("Aviso","E-mail ao almoxarifado enviado com sucesso.",{"Ok"})

				Endif
			Else
				GET MAIL ERROR cError
				MsgStop("Erro de autenticação","Verifique a conta e a senha para envio")
			Endif
			DISCONNECT SMTP SERVER
		Else
			//Erro na conexao com o SMTP Server
			GET MAIL ERROR cError
			MsgStop("Erro de CONEXAO COM SMTP","ERRO DE CONEXAO COM SMTP...")
		Endif
	Endif

Return()
	*****************************************************************************************************************************************************************

	*****************************************************************************************************************************************************************
User Function impXA3()
	*****************************************************************************************************************************************************************
	Local nTamLin
	Local cLin
//Local cCpo	

	Private oDlgI
	Private oGeraTxt
	Private cArqTxt
	Private nHdl
	Private cBody
	Private cEOL := "CHR(13)+CHR(10)"

	If Pergunte("MANWFL",.T.)
		geraEML(1)

		cArqTxt := Alltrim(MV_PAR01) + "\" + __cUSERID + "2.html"
		nHdl    := fCreate(cArqTxt)

		If Empty(cEOL)
			cEOL := CHR(13)+CHR(10)
		Else
			cEOL := Trim(cEOL)
			cEOL := &cEOL
		Endif

		If nHdl == -1
			MsgAlert("O arquivo de nome " + cArqTxt + " nao pode ser executado!","Atencao!")
			Return
		Endif

		nTamLin := 50000
		cLin    := Space(nTamLin) + cEOL
		cLin := cBody

		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo!","Atencao!")
				Return
			Endif
		Endif

		fClose(nHdl)

		DEFINE DIALOG oDlgI TITLE "OCORRENCIA DE DIVERGENCIA - " + Alltrim(XA3->XA3_NUM) FROM 000,000 TO 570,800 PIXEL
		
		// Prepara o conector WebSocket
		PRIVATE oWebChannel := TWebChannel():New()
		nPort := oWebChannel:connect()
		
		// Cria componente
		PRIVATE oWebEngine := TWebEngine():New(oDlgI, 0, 0, 480, 270,, nPort)
		oWebEngine:bLoadFinished := {|self,url| conout("Termino da carga do pagina: " + url) }
		oWebEngine:navigate(cArqTxt)
		oWebEngine:Align := CONTROL_ALIGN_ALLCLIENT
		
		TButton():New( 272, 302, "Print", oDlgI, {|| oWebEngine:Print() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
		/*descontinuado https://tdn.totvs.com/display/tec/TIBrowser Jean 09/08/22
		//oTIBrowser := TIBrowser():New(0,0,403,270,cArqTxt,oDlgI)
		//TButton():New(272,302,"Imprimir"	,oDlgI,{|| oTIBrowser:Print()}	,040,010,,,.F.,.T.,.F.,,.F.,,,.F.)
		*/
		TButton():New(272,354,"Fechar"	,oDlgI,{|| oDlgI:End()}				,040,010,,,.F.,.T.,.F.,,.F.,,,.F.)
		ACTIVATE DIALOG oDlgI CENTERED
	Endif

Return(nil)
	*****************************************************************************************************************************************************************

	*****************************************************************************************************************************************************************
Static Function geraEML(nPingPong)
	*****************************************************************************************************************************************************************
	Local _cTxRelato := ""
	Local _cTxAcao   := ""
	Local _cTxTrepli := ""
	Local cDescNC := "" // Jean 08/08/22
	Local cQuery     := ""
	Local nLineaActual
	local cObs:=""

	cQuery := ""
	cQuery += " SELECT 	"
	cQuery += "   REPLACE(REPLACE( RTRIM(LTRIM(ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), XA3_RELATO)),''))), CHAR(13), '<'), CHAR(10), 'br />') collate sql_latin1_general_cp1251_ci_as AS XA3_RELATO "
	cQuery += " , REPLACE(REPLACE( RTRIM(LTRIM(ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), XA3_ACAO)),''))), CHAR(13), '<'), CHAR(10), 'br />') collate sql_latin1_general_cp1251_ci_as AS XA3_ACAO     "
	cQuery += " , REPLACE(REPLACE( RTRIM(LTRIM(ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), XA3_TREPLI)),''))), CHAR(13), '<'), CHAR(10), 'br />') collate sql_latin1_general_cp1251_ci_as AS XA3_TREPLI "
	cQuery += " , REPLACE(REPLACE( RTRIM(LTRIM(ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), XA3_OBS)),''))), CHAR(13), '<'), CHAR(10), 'br />') collate sql_latin1_general_cp1251_ci_as AS XA3_OBS "
	cQuery += " , XA3_DESCNC, XA3_NFDEV, XA3_SENF, XA3_LOCAL, XA3_VLCTE, XA3_VLNF, XA3_VLDIV , XA3_NOTASI"
	cQuery += " FROM " + cXA3Tab + " XA3 "
	cQuery += " WHERE XA3_NUM  = '" + Alltrim(XA3->XA3_NUM)  +"' "
	cQuery += " AND D_E_L_E_T_ = ''	"
	cQuery := ChangeQuery(cQuery )

	dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , "XA3q" , .T. , .F.)

	DBSelectArea("XA3q")
	While !XA3q->(Eof())
		_cTxRelato := XA3q->XA3_RELATO
		_cTxAcao   := XA3q->XA3_ACAO
		_cTxTrepli := XA3q->XA3_TREPLI
		cObs		:= XA3q->XA3_OBS
		cDescNC 	:= XA3_DESCNC
		XA3q->(DbSkip())
	Enddo
	XA3q->(DBCloseArea())

	cLinea 	:= ""
	nLineas 	:= MLCOUNT(XA3->XA3_RELATO ,nLongitudLinea ,nTamanoTabulador ,lSaltoLinea)

	For nLineaActual := 1 to nLineas
		_Linea := MemoLine(XA3->XA3_RELATO ,nLongitudLinea ,nLineaActual ,nTamanoTabulador ,lSaltoLinea)
		cLinea := cLinea + _Linea
	Next

	cObsREL_1 	:= Iif(!empty(Alltrim(Substr(cLinea, 1,100)))	,Substr(cLinea, 1,100)	,space(100))
	cObsREL_2 	:= Iif(!empty(Alltrim(Substr(cLinea,101,100)))	,Substr(cLinea,101,100)	,space(100))
	cObsREL_3 	:= Iif(!empty(Alltrim(Substr(cLinea,201,100)))	,Substr(cLinea,201,100)	,space(100))
	cObsREL_4 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,301,100)	,space(100))
	cObsREL_5 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,401,100)	,space(100))
	cObsREL_6 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,501,100)	,space(100))
	cObsREL_7 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,601,100)	,space(100))
	cObsREL_8 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,701,100)	,space(100))
	cObsREL_9 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,901,100)	,space(100))
	cObsREL_10 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,901,100)	,space(100))

	cLinea 	:= ""
	nLineas := MLCOUNT(XA3->XA3_ACAO ,nLongitudLinea ,nTamanoTabulador ,lSaltoLinea)

	For nLineaActual := 1 to nLineas
		_Linea := MemoLine(XA3->XA3_ACAO ,nLongitudLinea ,nLineaActual ,nTamanoTabulador ,lSaltoLinea)
		cLinea := cLinea + _Linea
	Next

	cObsACA_1 	:= Iif(!empty(Alltrim(Substr(cLinea, 1,100)))	,Substr(cLinea, 1,100)	,space(100))
	cObsACA_2 	:= Iif(!empty(Alltrim(Substr(cLinea,101,100)))	,Substr(cLinea,101,100)	,space(100))
	cObsACA_3 	:= Iif(!empty(Alltrim(Substr(cLinea,201,100)))	,Substr(cLinea,201,100)	,space(100))
	cObsACA_4 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,301,100)	,space(100))
	cObsACA_5 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,401,100)	,space(100))
	cObsACA_6 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,501,100)	,space(100))
	cObsACA_7 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,601,100)	,space(100))
	cObsACA_8 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,701,100)	,space(100))
	cObsACA_9 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,901,100)	,space(100))
	cObsACA_10 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,901,100)	,space(100))

	cLinea 	:= ""
	nLineas 	:= MLCOUNT(XA3->XA3_TREPLI ,nLongitudLinea ,nTamanoTabulador ,lSaltoLinea)

	For nLineaActual := 1 to nLineas
		_Linea := MemoLine(XA3->XA3_TREPLI ,nLongitudLinea ,nLineaActual ,nTamanoTabulador ,lSaltoLinea)
		cLinea := cLinea + _Linea
	Next

	cOTREP_1 	:= Iif(!empty(Alltrim(Substr(cLinea, 1,100)))	,Substr(cLinea, 1,100)	,space(100))
	cOTREP_2 	:= Iif(!empty(Alltrim(Substr(cLinea,101,100)))	,Substr(cLinea,101,100)	,space(100))
	cOTREP_3 	:= Iif(!empty(Alltrim(Substr(cLinea,201,100)))	,Substr(cLinea,201,100)	,space(100))
	cOTREP_4 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,301,100)	,space(100))
	cOTREP_5 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,401,100)	,space(100))
	cOTREP_6 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,501,100)	,space(100))
	cOTREP_7 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,601,100)	,space(100))
	cOTREP_8 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,701,100)	,space(100))
	cOTREP_9 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,901,100)	,space(100))
	cOTREP_10	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,901,100)	,space(100))

	cLinea 	:= ""
	nLineas := MLCOUNT(XA3->XA3_OBS ,nLongitudLinea ,nTamanoTabulador ,lSaltoLinea)

	For nLineaActual := 1 to nLineas
		_Linea := MemoLine(XA3->XA3_OBS ,nLongitudLinea ,nLineaActual ,nTamanoTabulador ,lSaltoLinea)
		cLinea := cLinea + _Linea
	Next

	cObs_1 	:= Iif(!empty(Alltrim(Substr(cLinea, 1,100)))	,Substr(cLinea, 1,100)	,space(100))
	cObs_2 	:= Iif(!empty(Alltrim(Substr(cLinea,101,100)))	,Substr(cLinea,101,100)	,space(100))
	cObs_3 	:= Iif(!empty(Alltrim(Substr(cLinea,201,100)))	,Substr(cLinea,201,100)	,space(100))
	cObs_4 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,301,100)	,space(100))
	cObs_5 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,401,100)	,space(100))
	cObs_6 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,501,100)	,space(100))
	cObs_7 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,601,100)	,space(100))
	cObs_8 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,701,100)	,space(100))
	cObs_9 	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,901,100)	,space(100))
	cObs_10	:= Iif(!empty(Alltrim(Substr(cLinea,301,100)))	,Substr(cLinea,901,100)	,space(100))

	cTit 	:= Iif(nPingPong==2,"RES: ",Iif(nPingPong==3,"RES:RES: ","")) + "OCORRENCIA DE DIVERGENCIA - " + Alltrim(XA3->XA3_NUM) + " " + Iif(nPingPong==3," ( ENCERRADA ) ","")
	cBody	:= "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"
	cBody	+= "<html xmlns='http://www.w3.org/1999/xhtml'>"
	cBody	+= "<head>"
	cBody	+= "<meta content='pt-br' http-equiv='Content-Language' />"
	cBody	+= "<meta charset='utf-8'>"
	cBody	+= "<title>OCORRENCIA DE DIVERGENCIA</title>"
	cBody	+= "<style type='text/css'>"
	cBody	+= ".auto-style5 {"
	cBody	+= "	text-align: center;"
	cBody	+= "	font-family: Arial, Helvetica, sans-serif;"
	cBody	+= "	font-size: medium;"
	cBody	+= "}"
	cBody	+= ".auto-style6 {"
	cBody	+= "	text-align: center;"
	cBody	+= "	font-family: Arial, Helvetica, sans-serif;"
	cBody	+= "	font-size: x-large;"
	cBody	+= "}"
	cBody	+= ".auto-style7 {"
	cBody	+= "	font-family: Arial, Helvetica, sans-serif;"
	cBody	+= "	font-size: x-small;"
	cBody	+= "}"
	cBody	+= ".auto-style8 {"
	cBody	+= "	font-family: Arial, Helvetica, sans-serif;"
	cBody	+= "	font-size: x-small;"
	cBody	+= "	border: 1px solid #000000;"
	cBody	+= "}"
	cBody	+= ".auto-style9 {"
	cBody	+= "	text-align: center;"
	cBody	+= "	font-family: Arial, Helvetica, sans-serif;"
	cBody	+= "	font-size: x-large;"
	cBody	+= "	color: #FFFF00;"
	cBody	+= "	background-color: #ff0000;"
	cBody	+= "	font-weight: bold;"
	cBody	+= "}"
	cBody	+= "</style>"
	cBody	+= "</head>"
	cBody	+= "<body>"
	cBody	+= "<p>"
	cBody	+= "<table cellpadding='0' cellspacing='0' style='width: 100%'>"
	If nPingPong==3
		cBody	+= "	<tr>
		cBody	+= "		<td class='auto-style9' colspan='4' style='width: 100%'>OCORRENCIA DE DIVERGENCIA ENCERRADA PELO ALMOXARIFADO</td>"
		cBody	+= "	</tr>"
	Else
		cBody	+= "	<tr>
		cBody	+= "		<td class='auto-style6' colspan='4' style='width: 100%'>OCORRENCIA DE DIVERGENCIA</td>"
		cBody	+= "	</tr>"
	EndIf
	cBody	+= "	<tr>"
	cBody	+= "		<td style='width: 50%; height: 10px'></td>"
	cBody	+= "		<td style='width: 50%; height: 10px'></td>"
	cBody	+= "	</tr>"
	cBody	+= "	<tr>
	cBody	+= "		<td class='auto-style5' colspan='4' style='width: 100%; height: 20px'>RECEBIMENTO DE MATERIAIS - ALMOXARIFADO</td>
	cBody	+= "	</tr>"
	cBody	+= "	<tr>"
	cBody	+= "		<td style='width: 50%; height: 10px'></td>"
	cBody	+= "		<td style='width: 50%; height: 10px'></td>"
	cBody	+= "	</tr>"
	cBody	+= "</table>"

	cBody	+= "<table cellpadding='0' cellspacing='0' style='width: 100%'>"
	cBody	+= "	<tr>"
	cBody	+= "		<td class='auto-style7' style='width: 25%; height: 20px'>[ " + Iif(Alltrim(XA3->XA3_APLIC) == "E", "X"," ") + " ] ESTOQUE</td>"
	cBody	+= "		<td class='auto-style7' style='width: 25%; height: 20px'>[ " + Iif(Alltrim(XA3->XA3_APLIC) == "D", "X"," ") + " ] DIRETA</td>"//RAFAEL ALMEIDA - SIGACORP (22/12/2016)
	cBody	+= "		<td class='auto-style7' style='width: 25%; height: 20px'>&nbsp;</td>"
	cBody	+= "		<td class='auto-style8' style='width: 25%; height: 20px' align='center'>No OCORRENCIA: " + Alltrim(XA3->XA3_NUM) + "</td>"
	cBody	+= "	</tr>"
	cBody	+= "</table>"

	cBody	+= "<table cellpadding='0' cellspacing='0' width='100%'><tr><td width='100%'>&nbsp;</td></tr></table>"

	cBody	+= "<table cellpadding='0' cellspacing='0' style='width: 100%'>"
	cBody	+= "	<tr>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; border-bottom: 1px #000000 solid; height: 20px;'>DT RECEBIMENTO: " + Alltrim(dtoc(XA3->XA3_DTREC)) + "</td>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; border-bottom: 1px #000000 solid; height: 20px;'>COMPRADOR: " + Alltrim(XA3->XA3_COMPRA) + "</td>"
	cBody	+= "	</tr>"
	cBody	+= "	<tr>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; border-bottom: 1px #000000 solid; height: 20px;'>DT EMISSAO OD: " + Alltrim(dtoc(XA3->XA3_EMISSA)) + "</td>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; border-bottom: 1px #000000 solid; height: 20px;'>DT CONCLUSAO OD: " + Alltrim(dtoc(XA3->XA3_CONCLU)) + "</td>"
	cBody	+= "	</tr>"
	cBody	+= "	<tr>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px; border-bottom: 1px #000000 solid'>NF: "	+ Alltrim(XA3->XA3_NOTA) + "</td>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px; border-bottom: 1px #000000 solid'>PC:" 		+ Alltrim(XA3->XA3_PEDIDO) + "</td>"
	cBody	+= "	</tr>"
	cBody	+= "</table>"
	cBody	+= "<table cellpadding='0' cellspacing='0' style='width: 100%'>"
	cBody	+= "	<tr>"
	If Empty(XA3->XA3_USRINC)
		cBody	+= "		<td class='auto-style7' style='width: 100%; height: 20px; border-bottom: 1px #000000 solid'>FORNECEDOR: " + Alltrim(Posicione("SA2",1,xFilial("SA2") + XA3->XA3_FORNECE + XA3->XA3_LOJA,"A2_NOME")) + "</td>"
	Else
		cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px; border-bottom: 1px #000000 solid'>FORNECEDOR: " + Alltrim(Posicione("SA2",1,xFilial("SA2") + XA3->XA3_FORNECE + XA3->XA3_LOJA,"A2_NOME")) + "</td>"
		cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px; border-bottom: 1px #000000 solid'>ATENDENTE/OD: " + Alltrim(UsrFullName(XA3->XA3_USRINC)) + "</td>"
	EndIf
	cBody	+= "	</tr>"
	cBody	+= "</table>"
//INICIO - RAFAEL ALMEIDA - SIGACORP (02/03/2016)
	If !Empty(XA3->XA3_TRANSP)
		cBody	+= "<table cellpadding='0' cellspacing='0' style='width: 100%'>"
		cBody	+= "	<tr>"
		cBody	+= "		<td class='auto-style7' style='width:  50%; height: 20px; border-bottom: 1px #000000 solid'>TRANSPORTADOR: " + Alltrim(Posicione("SA4",1,xFilial("SA4") + XA3->XA3_TRANSP,"A4_NOME")) + "</td>"
		cBody	+= "		<td class='auto-style7' style='width:  50%; height: 20px; border-bottom: 1px #000000 solid'>CTRC:  " 		+ Alltrim(XA3->XA3_CTRC) + "</td>"
		cBody	+= "	</tr>"
		cBody	+= "</table>"
	EndIf
//FIM - RAFAEL ALMEIDA - SIGACORP (02/03/2016)

	If .t. //!Empty(XA3->XA3_SENF)
		cBody	+= "<table cellpadding='0' cellspacing='0' style='width: 100%'>"
		cBody	+= "	<tr>"
		cBody	+= "		<td class='auto-style7' style='width:  40%; height: 20px; border-bottom: 1px #000000 solid'>LOCAL:  " + Alltrim(XA3->XA3_LOCAL) + "</td>"
		cBody	+= "		<td class='auto-style7' style='width:  30%; height: 20px; border-bottom: 1px #000000 solid'>SENF: " + Alltrim( XA3->XA3_SENF) + "</td>"		
		cBody	+= "		<td class='auto-style7' style='width:  30%; height: 20px; border-bottom: 1px #000000 solid'>NF Devolucao:  " + Alltrim(XA3->XA3_NFDEV) + "</td>"
		cBody	+= "	</tr>"
		cBody	+= "</table>"
	EndIf
		cBody	+= "<table cellpadding='0' cellspacing='0' style='width: 100%'>"
		cBody	+= "	<tr>"
		cBody	+= "		<td class='auto-style7' style='width:  30%; height: 20px; border-bottom: 1px #000000 solid'>Valor DACTE:  " + Alltrim(XA3->XA3_VLCTE) + "</td>"
		cBody	+= "		<td class='auto-style7' style='width:  30%; height: 20px; border-bottom: 1px #000000 solid'>Valor Total NF:  " + Alltrim(XA3->XA3_VLNF) + "</td>"
		cBody	+= "		<td class='auto-style7' style='width:  40%; height: 20px; border-bottom: 1px #000000 solid'>Valor Item Divergente:  " + Alltrim(XA3->XA3_VLDIV) + "</td>"
		cBody	+= "	</tr>"
		cBody	+= "</table>"


	cBody	+= "<table cellpadding='0' cellspacing='0' width='100%'><tr><td width='100%'>&nbsp;</td></tr></table>"
/*
	cBody	+= "<table cellpadding='0' cellspacing='0' style='width: 100%'>"
	cBody	+= "	<tr>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px; border-bottom: 1px #000000 solid'>NAO CONFORMIDADE:</td>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px; border-bottom: 1px #000000 solid'>&nbsp;</td>"
	cBody	+= "	</tr>"
	cBody	+= "	<tr>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px'>[ " + Iif(Alltrim(XA3->XA3_NF)    == "1", "X"," ") + " ] NF</td>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px'>[ " + Iif(Alltrim(XA3->XA3_PC)    == "1", "X"," ") + " ] PC</td>"
	cBody	+= "	</tr>"
	cBody	+= "	<tr>"
	cBody	+= "		<td class='auto-style7' style='width: 25%; height: 20px'>[ " + Iif(Alltrim(XA3->XA3_TRAN)  == "1", "X"," ") + " ] TRANSPORTE</td>"
	cBody	+= "		<td class='auto-style7' style='width: 25%; height: 20px'>[ " + Iif(Alltrim(XA3->XA3_OUTRO) == "1", "X"," ") + " ] OUTROS</td>"
	cBody	+= "	</tr>"
	cBody	+= "</table>"
	cBody	+= "<table cellpadding='0' cellspacing='0' style='width: 100%'>"
	cBody	+= "	<tr>"
	cBody	+= "		<td class='auto-style7' colspan='2' style='width: 100%; height: 20px'>NAO CONFORMIDADE EVIDENCIADA:" + Alltrim(XA3->XA3_DESCNC) + "</td>"
	cBody	+= "	</tr>"
	cBody	+= "</table>"

	cBody	+= "<table cellpadding='0' cellspacing='0' width='100%'><tr><td width='100%'>&nbsp;</td></tr></table>"

	cBody	+= "<table cellpadding='0' cellspacing='0' style='width: 100%'>"
	cBody	+= "	<tr>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px; border-bottom: 1px #000000 solid'>DOCUMENTO FISCAL:</td>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px; border-bottom: 1px #000000 solid'>&nbsp;</td>"
	cBody	+= "	</tr>"
	cBody	+= "	<tr>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px'>[ " + Iif(Alltrim(XA3->XA3_CGCPC) == "1", "X"," ") + " ] CNPJ NAO CONFERE COM PEDIDO DE COMPRA</td>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px'>[ " + Iif(Alltrim(XA3->XA3_XML) == "1", "X"," ") + " ] XML NAO ENCONTRADO</td>"
	cBody	+= "	</tr>"
	cBody	+= "</table>"

	cBody	+= "<table cellpadding='0' cellspacing='0' width='100%'><tr><td width='100%'>&nbsp;</td></tr></table>"

	cBody	+= "<table cellpadding='0' cellspacing='0' style='width: 100%'>"
	cBody	+= "	<tr>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px; border-bottom: 1px #000000 solid'>DOCUMENTO COMPRA:</td>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px; border-bottom: 1px #000000 solid'>&nbsp;</td>"
	cBody	+= "	</tr>"
	cBody	+= "	<tr>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px'>[ " + Iif(Alltrim(XA3->XA3_SPC) == "1", "X"," ") + " ] SEM PEDIDO DE COMPRA</td>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px'>[ " + Iif(Alltrim(XA3->XA3_LIMITE) == "1", "X"," ") + " ] ACIMA DO LIMITE</td>"
	cBody	+= "	</tr>"
	cBody	+= "</table>"

	cBody	+= "<table cellpadding='0' cellspacing='0' width='100%'><tr><td width='100%'>&nbsp;</td></tr></table>"

	cBody	+= "<table cellpadding='0' cellspacing='0' style='width: 100%'>"
	cBody	+= "	<tr>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px; border-bottom: 1px #000000 solid'>MATERIAL:</td>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px; border-bottom: 1px #000000 solid'>&nbsp;</td>"
	cBody	+= "	</tr>"
	cBody	+= "	<tr>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px'>[ " + Iif(Alltrim(XA3->XA3_DESCR) == "1", "X"," ") + " ] DESCRICAO</td>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px'>[ " + Iif(Alltrim(XA3->XA3_PRODUTO) == "1", "X"," ") + " ] PRODUTO</td>"
	cBody	+= "	</tr>"
	cBody	+= "	<tr>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px'>[ " + Iif(Alltrim(XA3->XA3_QTD) == "1", "X"," ") + " ] QUANTIDADE</td>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px'>&nbsp;</td>"
	cBody	+= "	</tr>"
	cBody	+= "</table>"

	cBody	+= "<table cellpadding='0' cellspacing='0' width='100%'><tr><td width='100%'>&nbsp;</td></tr></table>"
*/
	cBody	+= "<table cellpadding='0' cellspacing='0' style='width: 100%'>"
	cBody	+= "	<tr>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px; border-bottom: 1px #000000 solid'>QUALIDADE:</td>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px; border-bottom: 1px #000000 solid'>&nbsp;</td>"
	cBody	+= "	</tr>"
	cBody	+= "	<tr>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px'>[ " + Iif(Alltrim(XA3->XA3_QUALID) == "1", "X"," ") + " ] CERTIF. 	QUALIDADE / ROMANEIO / GF3</td>"
	cBody	+= "		<td class='auto-style7' style='width: 50%; height: 20px'>[ " + Iif(Alltrim(XA3->XA3_ROMANE) == "1", "X"," ") + " ] ROMANEIO</td>"
	cBody	+= "	</tr>"
	cBody	+= "</table>"

	cBody	+= "<table cellpadding='0' cellspacing='0' width='100%'><tr><td width='100%'>&nbsp;</td></tr></table>"

	cBody	+= "<table cellpadding='0' cellspacing='0' style='width: 100%'>"
	cBody	+= "	<tr>"
	cBody	+= "		<td class='auto-style7' style='width: 100%; height: 20px; border-bottom: 1px #000000 solid'>RELATO DA DIVERGENCIA:</td>"
	cBody	+= "	</tr>"
	cBody	+= "	<tr>"
	cBody	+= "		<td style='width: 100%; height: 200px; border-bottom: 1px #000000 solid' valign='top'>" + _cTxRelato + "</td>"
//	cBody	+= "		<td style='width: 100%; height: 200px; border-bottom: 1px #000000 solid' valign='top'>" + alltrim(cObsREL_1) + alltrim(cObsREL_2) + alltrim(cObsREL_3) + alltrim(cObsREL_4) + alltrim(cObsREL_5) + alltrim(cObsREL_6) + alltrim(cObsREL_7) + alltrim(cObsREL_8) + alltrim(cObsREL_9) + alltrim(cObsREL_10) + "</td>"
	cBody	+= "	</tr>"
	cBody	+= "</table>"
	cBody	+= "<table cellpadding='0' cellspacing='0' width='100%'><tr><td width='100%'>&nbsp;</td></tr></table>"
	cBody	+= "<table cellpadding='0' cellspacing='0' width='100%'><tr><td width='100%'>&nbsp;</td></tr></table>"
	cBody	+= "<table cellpadding='0' cellspacing='0' style='width: 100%'>"
	cBody	+= "	<tr>"
	cBody	+= "		<td class='auto-style7' style='width: 100%; height: 20px; border-bottom: 1px #000000 solid'>ACAO CORRETIVA:</td>"
	cBody	+= "	</tr>"
	cBody	+= "	<tr>"
	cBody	+= "		<td style='width: 100%; height: 200px; border-bottom: 1px #000000 solid' valign='top'>" + _cTxAcao + "</td>"
	//cBody	+= "		<td style='width: 100%; height: 200px; border-bottom: 1px #000000 solid' valign='top'>" + alltrim(cObsACA_1) + alltrim(cObsACA_2) + alltrim(cObsACA_3) + alltrim(cObsACA_4) + alltrim(cObsACA_5) + alltrim(cObsACA_6) + alltrim(cObsACA_7) + alltrim(cObsACA_8) + alltrim(cObsACA_9) + alltrim(cObsACA_10) + "</td>"
	cBody	+= "	</tr>"
	cBody	+= "</table>"
	cBody	+= "<table cellpadding='0' cellspacing='0' width='100%'>" //INICIO - RAFAEL ALMEIDA - SIGACORP (26/12/2016)
	cBody	+= "	<tr>"
	cBody	+= "		<td class='auto-style7' style='width: 100%; height: 20px; border-bottom: 1px #000000 solid'>TREPLICA DA ACAO:</td>"
	cBody	+= "	</tr>
	cBody	+= "	<tr>"
	cBody	+= "		<td style='width: 100%; height: 200px; border-bottom: 1px #000000 solid' valign='top'>" + _cTxTrepli + "</td>"
//	cBody	+= "		<td style='width: 100%; height: 200px; border-bottom: 1px #000000 solid' valign='top'>" + alltrim(cOTREP_1) + alltrim(cOTREP_2) + alltrim(cOTREP_3) + alltrim(cOTREP_4) + alltrim(cOTREP_5) + alltrim(cOTREP_6) + alltrim(cOTREP_7) + alltrim(cOTREP_8) + alltrim(cOTREP_9) + alltrim(cOTREP_10) + "</td>"
	cBody	+= "	</tr>" //INICIO - RAFAEL ALMEIDA - SIGACORP (26/12/2016)
	cBody	+= "</table>"
	cBody	+= "<table cellpadding='0' cellspacing='0' width='100%'>" //INICIO - RAFAEL ALMEIDA - SIGACORP (26/12/2016)
	cBody	+= "	<tr>"
	cBody	+= "		<td class='auto-style7' style='width: 100%; height: 20px; border-bottom: 1px #000000 solid'>OBSERVACOES:</td>"
	cBody	+= "	</tr>
	cBody	+= "	<tr>"
	cBody	+= "		<td style='width: 100%; height: 200px; border-bottom: 1px #000000 solid' valign='top'>" + cObs + "</td>"
//	cBody	+= "		<td style='width: 100%; height: 200px; border-bottom: 1px #000000 solid' valign='top'>" + alltrim(cOTREP_1) + alltrim(cOTREP_2) + alltrim(cOTREP_3) + alltrim(cOTREP_4) + alltrim(cOTREP_5) + alltrim(cOTREP_6) + alltrim(cOTREP_7) + alltrim(cOTREP_8) + alltrim(cOTREP_9) + alltrim(cOTREP_10) + "</td>"
	cBody	+= "	</tr>" //INICIO - RAFAEL ALMEIDA - SIGACORP (26/12/2016)
	cBody	+= "</table>"
	cBody	+= "<br />"
	cBody	+= "</p>"
	cBody	+= "<p>&nbsp;</p>"
	cBody	+= "<p>&nbsp;</p>"
	cBody	+= "</body>"
	cBody	+= "</html>"
Return(nil)
	*****************************************************************************************************************************************************************
/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³encXA3mail º Autor ³Rafael Almeida-SIGACORPº Data³ 16/10/15 º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Esse programa tem Objetivo de enviar um e-mail notificando º±±
	±±º          ³ o departamento de compras que a OD já foi encerrado.       º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ encXA3()                                                    º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
	*****************************************************************************************************************************************************************
User Function encXA3mail()
	*****************************************************************************************************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local lOk
	Local _cPerg := "PARAMXA3"

	If Pergunte(_cPerg,.T.)
		cMailServer	:= GetMV("MV_RELSERV") //"srv2mail.alubar.net"
		cMailConta	:= GetMV("MV_RELACNT") //"workflow@alubar.net"
		cMailSenha	:= GetMV("MV_RELPSW")  ///"@lub@r123#siga"

		cEmailto		:= Alltrim(MV_PAR02)+";"+Alltrim(MV_PAR01)

		CONNECT SMTP SERVER cMailserver ACCOUNT cMailconta PASSWORD cMailsenha RESULT lOk

		If lOk
			geraEML(3)

			SEND MAIL FROM cMailconta TO cEmailto SUBJECT cTit BODY cBody RESULT lOk

			If !lOk
				GET MAIL ERROR CSMTPERROR
				MSGSTOP("Erro de envio" + CSMTPERROR)
			Else
				Aviso("Aviso","E-mail ao compras enviado com sucesso.",{"Ok"})
			Endif
		Endif
	Endif
Return()
	*****************************************************************************************************************************************************************

	*****************************************************************************************************************************************************************
User Function XA3Negt(OpcNeg)
	*****************************************************************************************************************************************************************
	Local _cMenAlert := ""

	_cMenAlert+="Usuário sem permissão para realizar a devida INCLUSÃO/ALTERAÇÃO/EXCLUSÃO."+CHR(13)+CHR(10)
	_cMenAlert+="                                          "+CHR(13)+CHR(10)
	_cMenAlert+="Maiores Informações, entre em contato com DEPTO. de TI."+CHR(13)+CHR(10)

	Alert(_cMenAlert)

Return()
	*****************************************************************************************************************************************************************

	*****************************************************************************************************************************************************************
USER FUNCTION FTMSREL()   //23/02/17 - Ponto de entrada para incluir Entidade para a rotina de conhecimento
	*****************************************************************************************************************************************************************
	LOCAL aEntidade := {}

	AADD( aEntidade, { "XA3", { "XA3_NUM" }, { || XA3->XA3_NOME } } )
	AADD( aEntidade, { "XA1", { "XA1_NFISCA","XA1_SERIE","XA1_CLIFOR","XA1_LOJA" }, { || XA1->XA1_NOMFOR } } )
	AADD( aEntidade, { "ZV1", { "ZV1_COD" }, { || ZV1->ZV1_NFUNC } } )  //22/12/17 - Fabio Yoshioka - Incluido rotina de Base de conhecimento na rotina de prestação de contas da AE

Return aEntidade
	*****************************************************************************************************************************************************************

	*****************************************************************************************************************************************************************
User Function AdmXA30D()
	*****************************************************************************************************************************************************************
//Local CAB := TFont():New("Arial Rounded MT Bold",,026,,.F.,,,,,.F.,.F.)
	Local Itens
	Local ntens := 1
//Local oFont1 := TFont():New("MS Sans Serif",,022,,.T.,,,,,.F.,.F.)
	Local oFont2 := TFont():New("MS Sans Serif",,020,,.F.,,,,,.F.,.F.)
	Local oFont3 := TFont():New("MS Sans Serif",,022,,.T.,,,,,.F.,.F.)
	Local oGroup1
	Local oGroup3
	Local oPanel1
	Local oSay1
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay6
	Local oSay7
	Local oSay8
	Local oSay9
	Local oSButton1
	Local oSButton2
//Local ZSF_DANFE
//Local cSF_DANFE := space(9)
//Local ZSF_DTNF
//Local dSF_DTNF := dDatabase
//Local ZSF_SRNF
//Local cSF_SRNF := space(3)
	Local aPrGERAL  := Alltrim(GetNewPar("AL_ODMANU","000000"))
	Local cUsrApro  := Alltrim(&('RETCODUSR()'))

	Static oDlg

	IF cUsrApro =="000000" .OR. cUsrApro $ aPrGERAL

		DEFINE MSDIALOG oDlg TITLE "MANUTENÇÃO - RETORNAR STATUS O.D." FROM 000, 000  TO 325, 800 COLORS 0, 16777215 PIXEL

		@ 013, 016 MSPANEL oPanel1 SIZE 375, 144 OF oDlg COLORS 0, 16777215
		@ 075, 008 GROUP oGroup1 TO 127, 365 PROMPT "INFO. Nº OD" OF oPanel1 COLOR 0, 16777215 PIXEL
		DEFINE SBUTTON oSButton1 FROM 131, 307 TYPE 01  ACTION (GrvMntOD(ntens),oDlg:End()) ENABLE OF oPanel1
		DEFINE SBUTTON oSButton2 FROM 131, 339 TYPE 02  ACTION (oDlg:End()) ENABLE OF oPanel1//OF oPanel1 ENABLE
		@ 007, 008 GROUP oGroup3 TO 064, 366 PROMPT "ATENÇÃO" OF oPanel1 COLOR 255, 16777215 PIXEL
		@ 025, 022 SAY oSay3 PROMPT "Essa rotina tem a função de retornar o Status da OD para nível selecionado no box abaixo, ou seja, o processo terá início a parti do Status selecionado." SIZE 339, 027 OF oPanel1 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 094, 014 SAY oSay6 PROMPT "Nº OD" SIZE 025, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
		@ 111, 014 SAY oSay7 PROMPT "EMISSAO" SIZE 040, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
		@ 091, 056 SAY oSay8 PROMPT Alltrim(XA3->XA3_NUM) SIZE 072, 012 OF oPanel1 FONT oFont3 COLORS 16711680, 16777215 PIXEL
		@ 108, 055 SAY oSay9 PROMPT DTOC(XA3->XA3_EMISSA) SIZE 073, 013 OF oPanel1 FONT oFont3 COLORS 16711680, 16777215 PIXEL
		@ 094, 140 SAY oSay1 PROMPT "SOLICITANTE" SIZE 040, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
		@ 091, 187 SAY oSay2 PROMPT Alltrim( UsrFullName(XA3->XA3_USRINC)) SIZE 072, 012 OF oGroup1 FONT oFont3 COLORS 16711680, 16777215 PIXEL
		@ 111, 139 SAY oSay4 PROMPT "RETORNAR O STATUS OD" SIZE 082, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
		@ 109, 220 MSCOMBOBOX Itens VAR ntens ITEMS {"OD Aberta","OD Em Andamento-Almox"} SIZE 072, 010 OF oPanel1 COLORS 0, 16777215 PIXEL

		ACTIVATE MSDIALOG oDlg CENTERED

	ELSE
		ALERT("Usuário não tem permissão na Rotina! ")
	ENDIF

Return
	*****************************************************************************************************************************************************************

	*****************************************************************************************************************************************************************
Static Function GrvMntOD(ntens)
	*****************************************************************************************************************************************************************
	Local cNF      := cValToChar(ntens)
	Local cDoc     := XA3->XA3_NUM
	Local cNFisca  := XA3->XA3_NOTA
	Local cSerieNF := XA3->XA3_SERIE
	Local cCodfor  := XA3->XA3_FORNEC
	Local cLojFor  := XA3->XA3_LOJA
//Local dDTAlmx  := XA3->XA3_DTALM
//Local dDTCom   := XA3->XA3_DTCOM


	If  ALLTRIM(cNF) == "1" //"Solicitação"
		DBSELECTAREA("XA3")
		DBSETORDER(1)
		IF DBSEEK(xFilial("XA3")+XA3->XA3_NUM)
			WHILE (XA3->XA3_NUM == cDOC) .AND. !EOF()
				RECLOCK("XA3",.F.)
				XA3_DTALM	:= ctod("  /  /  ")
				XA3_DTCOM	:= ddatabase
				XA3_CONCLU	:= ctod("  /  /  ")
				XA3->(MSUNLOCK())
				XA3->(DBSkip())
			ENDDO

			dbSelectarea("XA1")
			XA1->(dbSetorder(1))
			XA1->(dbGotop())

			If XA1->(dbSeek(xFilial("XA1") + cNFisca + cSerieNF + cCodfor + cLojFor))
				If XA1->XA1_OD == cDOC
					RecLock("XA1",.F.)
					XA1->XA1_DTCOOD	:= ctod("  /  /  ")
					XA1->(MsUnlock())
					XA1->(dbCommitAll())
				EndIf
			Endif
			XA1->(DbCloseArea())

		ENDIF
		("XA3")->(dbCloseArea())
		MSGINFO("Alteração Gerada com sucesso !")
		cDoc    := ""
	Else
		DBSELECTAREA("XA3")
		DBSETORDER(1)
		IF DBSEEK(xFilial("XA3")+XA3->XA3_NUM)
			WHILE (XA3->XA3_NUM == cDOC) .AND. !EOF()
				RECLOCK("XA3",.F.)
				XA3_DTCOM	:= ctod("  /  /  ")
				XA3_CONCLU	:= ctod("  /  /  ")
				XA3_DTALM	:= ddatabase
				XA3->(MSUNLOCK())
				XA3->(DBSkip())
			ENDDO

			dbSelectarea("XA1")
			XA1->(dbSetorder(1))
			XA1->(dbGotop())

			If XA1->(dbSeek(xFilial("XA1") + cNFisca + cSerieNF + cCodfor + cLojFor))
				If XA1->XA1_OD == cDOC
					RecLock("XA1",.F.)
					XA1->XA1_DTCOOD	:= ctod("  /  /  ")
					XA1->(MsUnlock())
					XA1->(dbCommitAll())
				EndIf
			Endif
			XA1->(DbCloseArea())
		ENDIF
		("XA3")->(dbCloseArea())
		MSGINFO("Alteração Gerada com sucesso !")
		cDoc    := ""
	EndIf
Return
	*****************************************************************************************************************************************************************

	*****************************************************************************************************************************************************************
User Function RelEsrXA3()
	*****************************************************************************************************************************************************************

	Private  cPerg  := "REXCXA3"
	Private oProcess

	If !Pergunte(cPerg,.T.)
		Return Nil
	endif

	oProcess := MsNewProcess():New( { || ExcXa3() } , "Gerando Excel" , "Aguarde..." , .F. )
	oProcess:Activate()

Return()
	*****************************************************************************************************************************************************************

	*****************************************************************************************************************************************************************
STATIC FUNCTION ExcXa3()
	*****************************************************************************************************************************************************************
//Local nQtdB2  := 0  		
	local DatDe   := Date()
	local DatAte  := Date()
//local DatAux  := Date()
//local DatAx   := Date()
//local cCodPr  := ""
//local cLocPrD := ""
//local cLocPrT := ""
	local oExcel  := FWMSEXCEL():New()
	local cTipo   := "*.xls | *.XLS | *.xlsx | *.XLSX |"
	Local cQuery := ""
//local nt
	Private aDados := {}

	DatDe    := MV_PAR01
	DatAte   := MV_PAR02
	cCodForD := MV_PAR03
	cCodForT := MV_PAR04


	cQuery := " "
	cQuery += " SELECT	"
	cQuery += "  XA3_NUM	"
	cQuery += " ,CASE     	"
	cQuery += " 	WHEN XA3_APLIC = 'E' THEN 'ESTOQUE'	"
	cQuery += " 	WHEN XA3_APLIC = 'D' THEN 'DIRETA'   	"
	cQuery += "  END AS TP_APLI	"
	cQuery += " ,SUBSTRING(XA3_DTREC,7,2)+'/'+SUBSTRING(XA3_DTREC,5,2)+'/'+SUBSTRING(XA3_DTREC,1,4) AS  XA3_DTREC	"
	cQuery += " ,SUBSTRING(XA3_CONCLU,7,2)+'/'+SUBSTRING(XA3_CONCLU,5,2)+'/'+SUBSTRING(XA3_CONCLU,1,4) AS  XA3_CONCLU	"
	cQuery += " ,CASE 	"
	cQuery += " 	WHEN XA3_CONCLU <>'' THEN DATEDIFF(DAY,XA3_DTREC,XA3_CONCLU)	"
	cQuery += " 	ELSE DATEDIFF(DAY,XA3_DTREC,CONVERT(CHAR,GETDATE(),112 ))	"
	cQuery += "  END AS DT_DIFF	"
	cQuery += " ,SUBSTRING(XA3_EMISSA,7,2)+'/'+SUBSTRING(XA3_EMISSA,5,2)+'/'+SUBSTRING(XA3_EMISSA,1,4) AS  XA3_EMISSA	"
	cQuery += " ,XA3_PEDIDO	"
	cQuery += " ,XA3_NOTA	"
	cQuery += " ,XA3_SERIE	"
	cQuery += " ,ISNULL((SELECT SUM(XA2_VLTXML) FROM " + cXA2Tab + " WHERE D_E_L_E_T_ = '' AND XA2_NFISCA = XA3_NOTA AND XA2_SERIE = XA3_SERIE AND XA2_CLIFOR = XA3_FORNEC AND XA2_LOJA  = XA3_LOJA),0) AS VLR_NF	"
	cQuery += " ,XA3_FORNEC	"
	cQuery += " ,XA3_LOJA	"
	cQuery += " ,(SELECT A2_NOME FROM "+RetSqlName('SA2')+" WHERE D_E_L_E_T_ = '' AND A2_COD = XA3_FORNEC AND A2_LOJA = XA3_LOJA) AS XA3_NOME	"
	cQuery += " ,XA3_CTRC	"
	cQuery += " ,XA3_TRANSP   	"
	cQuery += " ,ISNULL((SELECT A4_NOME FROM "+RetSqlName('SA4')+" WHERE D_E_L_E_T_ = '' AND A4_COD = XA3_TRANSP ),'') AS XA3_NTRANS	"
	cQuery += " ,SUBSTRING(XA3_DTALM,7,2)+'/'+SUBSTRING(XA3_DTALM,5,2)+'/'+SUBSTRING(XA3_DTALM,1,4) AS  XA3_DTALM	"
	cQuery += " ,SUBSTRING(XA3_DTCOM,7,2)+'/'+SUBSTRING(XA3_DTCOM,5,2)+'/'+SUBSTRING(XA3_DTCOM,1,4) AS  XA3_DTCOM	"
	cQuery += " ,CASE 	"
	cQuery += " 	WHEN XA3_NF = '1' THEN 'SIM'	"
	cQuery += " 	WHEN XA3_NF = '2' THEN 'NÃO'	"
	cQuery += " 	ELSE ''	"
	cQuery += "  END AS XA3_NF	"
	cQuery += " ,CASE 	"
	cQuery += " 	WHEN XA3_PC = '1' THEN 'SIM'	"
	cQuery += " 	WHEN XA3_PC = '2' THEN 'NÃO'	"
	cQuery += " 	ELSE ''	"
	cQuery += "  END AS XA3_PC	"
	cQuery += " ,CASE 	"
	cQuery += " 	WHEN XA3_TRAN = '1' THEN 'SIM'	"
	cQuery += " 	WHEN XA3_TRAN = '2' THEN 'NÃO'	"
	cQuery += " 	ELSE ''	"
	cQuery += "  END AS XA3_TRAN	"
	cQuery += " ,CASE 	"
	cQuery += " 	WHEN XA3_OUTRO = '1' THEN 'SIM'	"
	cQuery += " 	WHEN XA3_OUTRO = '2' THEN 'NÃO'	"
	cQuery += " 	ELSE ''	"
	cQuery += "  END AS XA3_OUTRO	"
	cQuery += " ,CASE 	"
	cQuery += " 	WHEN XA3_CGCPC = '1' THEN 'SIM'	"
	cQuery += " 	WHEN XA3_CGCPC = '2' THEN 'NÃO'	"
	cQuery += " 	ELSE ''	"
	cQuery += "  END AS XA3_CGCPC	"
	cQuery += " ,CASE 	"
	cQuery += " 	WHEN XA3_XML = '1' THEN 'SIM'	"
	cQuery += " 	WHEN XA3_XML = '2' THEN 'NÃO'	"
	cQuery += " 	ELSE ''	"
	cQuery += "  END AS XA3_XML	"
	cQuery += " ,CASE 	"
	cQuery += " 	WHEN XA3_SPC = '1' THEN 'SIM'	"
	cQuery += " 	WHEN XA3_SPC = '2' THEN 'NÃO' 	"
	cQuery += " 	ELSE ''	"
	cQuery += "  END AS XA3_SPC	"
	cQuery += " ,CASE 	"
	cQuery += " 	WHEN XA3_LIMITE = '1' THEN 'SIM'	"
	cQuery += " 	WHEN XA3_LIMITE = '2' THEN 'NÃO'	"
	cQuery += " 	ELSE ''	"
	cQuery += "  END AS XA3_LIMITE	"
	cQuery += " ,CASE 	"
	cQuery += " 	WHEN XA3_DESCR = '1' THEN 'SIM'	"
	cQuery += " 	WHEN XA3_DESCR = '2' THEN 'NÃO'	"
	cQuery += " 	ELSE ''	"
	cQuery += "  END AS XA3_DESCR	"
	cQuery += " ,CASE 	"
	cQuery += " 	WHEN XA3_PRODUT = '1' THEN 'SIM'	"
	cQuery += " 	WHEN XA3_PRODUT = '2' THEN 'NÃO'	"
	cQuery += " 	ELSE ''	"
	cQuery += "  END AS XA3_PRODUT	"
	cQuery += " ,CASE 	"
	cQuery += " 	WHEN XA3_QTD = '1' THEN 'SIM'	"
	cQuery += " 	WHEN XA3_QTD = '2' THEN 'NÃO'	"
	cQuery += " 	ELSE ''	"
	cQuery += "  END AS XA3_QTD	"
	cQuery += " ,CASE 	"
	cQuery += " 	WHEN XA3_QUALID = '1' THEN 'SIM'	"
	cQuery += " 	WHEN XA3_QUALID = '2' THEN 'NÃO'	"
	cQuery += " 	ELSE ''	"
	cQuery += "  END AS XA3_QUALID 	"
	cQuery += "  ,CASE 	"
	cQuery += "  	WHEN XA3_ROMANE = '1' THEN 'SIM'	"
	cQuery += "  	WHEN XA3_ROMANE = '2' THEN 'NÃO'	"
	cQuery += "  	ELSE ''	"
	cQuery += "  END AS XA3_ROMANE	"
	cQuery += " ,XA3_DESCNC	"
	cQuery += " ,XA3_COMPRA	"
	cQuery += " ,ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), XA3_RELATO)),'') AS XA3_RELATO 	"
	cQuery += " ,ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), XA3_ACAO)),'') AS XA3_ACAO 	"
	cQuery += " ,ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), XA3_TREPLI)),'') AS XA3_TREPLI 	"
	cQuery += " FROM " + cXA3Tab + " "
	cQuery += " WHERE D_E_L_E_T_ = ''	"
	cQuery += " AND XA3_EMISSA BETWEEN '"+DtoS(DatDe)+"' AND '"+DtoS(DatAte)+"' "
	cQuery += " AND XA3_FORNEC BETWEEN '"+Alltrim(cCodForD)+"' AND '"+Alltrim(cCodForT)+"' "
	cQuery += " AND XA3_FILIAL  = 	'" + xFilial("XA3") +"'  "
	cQuery += " ORDER BY 1	"
	cQuery := ChangeQuery(cQuery)
	MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'TMP', .T., .T.)},"Selecionado registros")


	DbSelectArea("TMP")
	DBGoTop()

	cWorkSheet := "Dados"
	cTable := "Relatório OD"

	//Nome da Worksheet
	oExcel:AddworkSheet(cWorkSheet)
	//Nome da Tabela
	oExcel:AddTable (cWorkSheet,cTable)

//Nome das Colunas
	oExcel:AddColumn(cWorkSheet, cTable, "NUM. OD"		     ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "NOTA FISCAL"      ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "SERIE"	           ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "FORNECEDOR"	     ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "LOJA FORNEC"	  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "NOME FORNEC"     ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "VALOR NF"	        ,1,2)
	oExcel:AddColumn(cWorkSheet, cTable, "DESCRIÇÃO NC"	  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "APLICAÇÃO"		  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "DATA RECEBTO"	  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "EMISSÃO OD"       ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "E-MAIL AO COMPRA"      ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "E-MAIL A0 ALMOXARIFADO" ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "DATA CONCLUSÃO"	  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "DIAS ATRASO"      ,1,2)
	oExcel:AddColumn(cWorkSheet, cTable, "PEDIDO"	        ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "COMPRADOR"	        ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "CTRC"   	  		  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "CÓD. TRANSPORT"  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "NOME TRANSPORT"  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.NOTA FISCAL" ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.PEDIDO"     ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.TRANSPORTE" ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.CGC PED"	  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.XML"   	  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.SEM PED"	  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.LIMITE"  	  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.DESCRIÇÃO"  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.PRODUTO"	  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.QUANTIDADE" ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.CERT.QUALID",1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.ROMANEIO"   ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "RELATO"	  		  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "AÇÃO"	  			  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "TREPLICA"	  		  ,1,1)

	Do While !EOF()
		INCPROC("Aguarde... ")

		oExcel:AddRow(cWorkSheet,cTable,{	TMP->XA3_NUM,;
			TMP->XA3_NOTA,;
			TMP->XA3_SERIE,;
			TMP->XA3_FORNEC,;
			TMP->XA3_LOJA,;
			TMP->XA3_NOME,;
			TMP->VLR_NF,;
			TMP->XA3_DESCNC,;
			TMP->TP_APLI,;
			TMP->XA3_DTREC,;
			TMP->XA3_EMISSA,;
			TMP->XA3_DTCOM,;
			TMP->XA3_DTALM,;
			TMP->XA3_CONCLU,;
			TMP->DT_DIFF,;
			TMP->XA3_PEDIDO,;
			TMP->XA3_COMPRA,;
			TMP->XA3_CTRC,;
			TMP->XA3_TRANSP,;
			TMP->XA3_NTRANS,;
			TMP->XA3_NF,;
			TMP->XA3_PC,;
			TMP->XA3_TRAN,;
			TMP->XA3_CGCPC,;
			TMP->XA3_XML,;
			TMP->XA3_SPC,;
			TMP->XA3_LIMITE,;
			TMP->XA3_DESCR,;
			TMP->XA3_PRODUT,;
			TMP->XA3_QTD,;
			TMP->XA3_QUALID,;
			TMP->XA3_ROMANE,;
			TMP->XA3_RELATO,;
			TMP->XA3_ACAO,;
			TMP->XA3_TREPLI})
		DBSkip()
	EndDo
	/*
		oExcel:AddColumn(cWorkSheet, cTable, "NUM. OD"		     ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "NOTA FISCAL"      ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "SERIE"	           ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "FORNECEDOR"	     ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "LOJA FORNEC"	  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "NOME FORNEC"     ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "VALOR NF"	        ,1,2)
	oExcel:AddColumn(cWorkSheet, cTable, "DESCRIÇÃO NC"	  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "APLICAÇÃO"		  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "DATA RECEBTO"	  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "EMISSÃO OD"       ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "E-MAIL AO COMPRA"      ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "E-MAIL A0 ALMOXARIFADO" ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "DATA CONCLUSÃO"	  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "DIAS ATRASO"      ,1,2)
	oExcel:AddColumn(cWorkSheet, cTable, "PEDIDO"	        ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "COMPRADOR"	        ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "CTRC"   	  		  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "CÓD. TRANSPORT"  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "NOME TRANSPORT"  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.NOTA FISCAL" ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.PEDIDO"     ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.TRANSPORTE" ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.OUTROS"	  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.CGC PED"	  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.XML"   	  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.SEM PED"	  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.LIMITE"  	  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.DESCRIÇÃO"  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.PRODUTO"	  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.QUANTIDADE" ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.CERT.QUALID",1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "PROBL.ROMANEIO"   ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "RELATO"	  		  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "AÇÃO"	  			  ,1,1)
	oExcel:AddColumn(cWorkSheet, cTable, "TREPLICA"	  		  ,1,1)

	Do While !EOF()
		INCPROC("Aguarde... ")

		oExcel:AddRow(cWorkSheet,cTable,{	TMP->XA3_NUM,;
			TMP->XA3_NOTA,;
			TMP->XA3_SERIE,;
			TMP->XA3_FORNEC,;
			TMP->XA3_LOJA,;
			TMP->XA3_NOME,;
			TMP->VLR_NF,;
			TMP->XA3_DESCNC,;
			TMP->TP_APLI,;
			TMP->XA3_DTREC,;
			TMP->XA3_EMISSA,;
			TMP->XA3_DTCOM,;
			TMP->XA3_DTALM,;
			TMP->XA3_CONCLU,;
			TMP->DT_DIFF,;
			TMP->XA3_PEDIDO,;
			TMP->XA3_COMPRA,;
			TMP->XA3_CTRC,;
			TMP->XA3_TRANSP,;
			TMP->XA3_NTRANS,;
			TMP->XA3_NF,;
			TMP->XA3_PC,;
			TMP->XA3_TRAN,;
			TMP->XA3_OUTRO,;
			TMP->XA3_CGCPC,;
			TMP->XA3_XML,;
			TMP->XA3_SPC,;
			TMP->XA3_LIMITE,;
			TMP->XA3_DESCR,;
			TMP->XA3_PRODUT,;
			TMP->XA3_QTD,;
			TMP->XA3_QUALID,;
			TMP->XA3_ROMANE,;
			TMP->XA3_RELATO,;
			TMP->XA3_ACAO,;
			TMP->XA3_TREPLI})
		DBSkip()
	EndDo
	*/
	TMP->(DBCloseArea())


	Arquivo := cGetFile(cTipo,OemToAnsi("Selecione o Diretorio do arquivo de atualização"),,'C:\ABCDE',.T.)
	Arquivo := Alltrim(Arquivo)

	If RIGHT(Arquivo,4) <> ".xls" .Or. RIGHT(Arquivo,4) <> ".XLS" .Or. RIGHT(Arquivo,4) <> ".Xls"
		Arquivo := Alltrim(Arquivo)//+".xls")
	EndIf


	oExcel:Activate()
	oExcel:GetXMLFile(Arquivo)
	MSGINFO("Planilha gravada Sucesso: "+Arquivo)

Return()
	*****************************************************************************************************************************************************************

	*****************************************************************************************************************************************************************
User Function FSendMail(cEmailto, cTituloMail, cBodyMail, nTimeout, nSendSec)
	*****************************************************************************************************************************************************************

	local lResult	:= .f. // Resultado da tentativa de comunicacao com servidor de E-Mail
	local lRet		:= .F.

	local cFrom	   	:= GetMV("MV_RELACNT")
	local cConta   	:= GetMV("MV_RELACNT")
	local cSenhaX  	:= GetMV("MV_RELPSW")
	local lRelauth 	:= GetNewPar("MV_RELAUTH",.F.)		// Parametro que indica se existe autenticacao no e-mail

	Local _cTituloMail := cTituloMail
	Local _cEmailTo    := cEmailto
	Local _cBodyMail   := cBodyMail
	local _cEmailBcc   := ""

//³ Tenta conexao com o servidor de E-Mail ³
	CONNECT SMTP SERVER GetMV("MV_RELSERV");					// Nome do servidor de e-mail
	ACCOUNT GetMV("MV_RELACNT") PASSWORD GetMV("MV_RELPSW");	// Nome da conta e senha a ser usada no e-mail
	RESULT lResult             									// Resultado da tentativa de conexão

// Se a conexao com o SMPT esta ok
	If lResult

		// Se existe autenticacao para envio valida pela funcao MAILAUTH
		If lRelauth
			lRet := Mailauth(cConta,cSenhaX)
		Else
			lRet := .T.
		Endif

		If lRet

			SEND MAIL FROM	cFrom ;
				TO _cEmailTo ;
				BCC _cEmailBcc ;
				SUBJECT _cTituloMail ;
				BODY _cBodyMail ;
				RESULT lResult

			If !lResult
				//Erro no envio do email
				GET MAIL ERROR cError
				MsgStop("Erro no envio de e-mail","erro de envio")
			Else
				DISCONNECT SMTP SERVER
//			ALERT("E-Mail enviado a TI !!!")
			Endif
		Else
			GET MAIL ERROR cError
			MsgStop("Erro de autenticação","Verifique a conta e a senha para envio")
		Endif
		DISCONNECT SMTP SERVER

	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		MsgStop("Erro de CONEXAO COM SMTP","ERRO DE CONEXAO COM SMTP...")
	Endif

/*
Local lRet := .T.
Local oServer
Local oMessage
Local cSmtpErroR := ""
Local nErro := 0
Local nSendPort := 0
Local nSleep := 1000
Local cSSLTLS := ""
Local lSMTPOn := .F.

Local cMailServer := GetMV("MV_RELSERV")
Local cMailConta  := GetMV("MV_RELACNT")
Local cMailSenha  := GetMV("MV_RELPSW")
Local lRelauth 	:= GetNewPar("MV_RELAUTH",.F.)		// Parametro que indica se existe autenticacao no e-mail

If nTimeout = nil .Or. nTimeout = 0
	nTimeout := 60
Endif

If nSendSec = nil
	nTimeout := 0
Endif

//Cria a conexão com o server STMP ( Envio de e-mail )
Processa( {|| oServer := TMailManager():New(), sleep(nSleep) }, "A g u a r d e", "Preparando Servidor Smtp...",.F.)

oServer:SetUseSSL(.F.)
oServer:SetUseTLS(.F.)
  		
if nSendSec == 0
	nSendPort := 25 //default port for SMTP protocol
	cSSLTLS := " ..."
elseif nSendSec == 1
	nSendPort := 465 //default port for SMTP protocol with SSL
	oServer:SetUseSSL( .T. )
	cSSLTLS := " com SSL ..."
else
	nSendPort := 587 //default port for SMTPS protocol with TLS
	oServer:SetUseTLS( .T. )
	cSSLTLS := " com TLS ..."
endif
  		
Processa( {|| nErro = oServer:Init( "", cMailServer, cMailConta, cMailSenha, 0, nSendPort ), sleep(nSleep) }, "A g u a r d e", "Inicializando a Conta...",.F.)
		
if nErro > 0
	cSmtpError := " (Init) " + oServer:GetErrorString( nErro )
	lRet := .F.
else
  	//seta um tempo de time out com servidor de 1min
  	Processa( {|| nErro := oServer:SetSmtpTimeOut( nTimeout ), sleep(nSleep) }, "A g u a r d e", "Configurando Timeout...",.F.)
  	If nErro > 0
    	cSmtpError := " (SetSmtpTimeOut) " + oServer:GetErrorString( nErro ) 
		lRet := .F.
  	Else
  		//realiza a conexão SMTP
  		Processa( {|| nErro := oServer:SmtpConnect(), sleep(nSleep)  }, "A g u a r d e", "Conectando ao SMTP" + cSSLTLS,.F.)
  		If nErro > 0
			cSmtpError := " (SmtpConnect) " + oServer:GetErrorString( nErro )  
			lRet := .F.
		Else
			lSMTPOn := .T.
		  	//Apos a conexão, cria o objeto da mensagem
  			oMessage := TMailMessage():New()
   
  			//Limpa o objeto
  			oMessage:Clear()

			//Popula com os dados de envio
  			oMessage:cFrom              := cMailConta
  			oMessage:cTo                := cEmailto
  			oMessage:cCc                := ""
  			oMessage:cBcc               := ""
  			oMessage:cSubject           := cTituloMail
  			oMessage:cBody              := cBodyMail
   
  			//Envia o e-mail
  			Processa( {|| nErro := oMessage:Send( oServer ) }, "A g u a r d e", "Enviando e-mail...",.F.)
  			If nErro > 0
    			cSmtpError := "Erro ao enviar o e-mail. " + oServer:GetErrorString( nErro )   
				lRet := .F.
  			EndIf

  		EndIf
	EndIf
Endif

//Desconecta do servidor
if lSMTPOn 
	Processa( {|| nErro := oServer:SmtpDisconnect()  }, "A g u a r d e", "Enviando e-mail...",.F.)

	If nErro > 0
		cSmtpError := " (SmtpDisconnect) " + oServer:GetErrorString( nErro )
	Endif
EndIf

if !lRet
	Help(" ",1,"A t e n c a o",,;
		"E R R O R !!" + Chr(10) + Chr(15) +;
		cSmtpError + Chr(10) + Chr(15) +;
		" E-Mail não enviado.",;
		4,5)
Endif
*/
Return lRet
	*****************************************************************************************************************************************************************
