*****************************************
//Remark: Computadores não cometem erros.
*****************************************
#Include "Protheus.ch"
#INCLUDE "TOPCONN.CH"
#include "ap5mail.ch"  
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH" 
#Include "ctbr360.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA750BRW   ºAutor  ³Denis Haruo        º Data ³  08/29/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclui novas rotinas no menu do Funções do Contas a Pagar   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA750BRW(aRotina) 

	Local aVetor := {}  
	Local aSubVector := {} 
	Local aSubVecWFW  := {} //19/09/16- Opção de Liberação por título via WF
	Local aSubVecBLQ  := {} //10/05/18- 1.01.05.01.16 - Bloqueio de Pagamento de Títulos e de Fornecedores - FABIO YOSHIOKA
	Local aSubVecFPG  := {} //05/07/18- Inclusao de ficha de Pagamento - Reimpressao normal demorada - Chamado 17458
	//Local _lALBlqPgto:= IIF(UPPER(RTRIM(GETMV("AL_UBLQPGT")))=='S',.T.,.F.) 
	Local _lALBlqPgto:= IIF(UPPER(ALLTRIM(GETMV("AL_UBLQPGT")))=='S',.T.,.F.) // CLAUDIO.SIGACORP  26/09/2018


	//Passado como parametro a posicao da opcao dentro da arotina
	aSubVector :=	{{ "Imprime Comprovante", "U_IMPSISPAG"	,0, 1}} //Imprime a autenticação do SISPAG

	aSubVecWFW :=	{{ "Lib Tit WorkFlow"   , "U_LBTPGWF"	,0, 1}} //Liberação de Título via WF - Fabio Yoshioka

	aSubVecBLQ :=	{{ "Blq/Desblq Tit"   , "U_ALBLQPAG"	,0, 1}} //BLOQUEIO/DESBLOQUEIO DE TITULOS - Fabio Yoshioka

	aSubVecFPG :=	{{ "Imprime Ficha Pgto."   , "U_FIN301R"	,0, 1}} //Imprime Ficha de Pagamento - Fabio Yoshioka

	aAdd( aVetor,	{ "Rot SISPAG",aSubVector, 0 , 6}) //"Rot SISPAG"
	aAdd( aVetor,	{ "WORKFLOW",aSubVecWFW, 0 , 6}) //"Rot SISPAG"

	IF _lALBlqPgto
		aAdd( aVetor,	{ "Manut.Bloq",aSubVecBLQ, 0 , 6}) //"Rot SISPAG"
	ENDIF

	aAdd( aVetor,	{ "FICHA PGTO",aSubVecFPG, 0 , 6}) //"Rot SISPAG"

	Return(aVetor)      

	************************
User Function LBTPGWF() //19/09/16 - Fabio Yoshioka
	************************  
	Local dData := Date()
	Local oGroup1
	Local oGroup2
	Local oPanel1
	Local oSay1
	Local lOk := .F.
	Local cUserSol := RetCodUsr()

	//IF SE2->E2_STATWF = 'BL'
	IF SE2->E2_STATWF = 'BL' .or. (SE2->E2_PREFIXO =='PA1' .AND. RTRIM(SE2->E2_TIPO) =='PR' ) //04/04/18 - Fabio Yoshioka - POssibilitar Reenvio de PA ainda não gerada 
		MsgRun("Iniciando WorkFlow de Liberação. Aguarde...",,{|| U_Se2Start(dData,cUserSol,SE2->(RECNO())) })
		MSGInfo("E-mail enviado para liberação do título "+SE2->E2_NUM + SE2->E2_PREFIXO) 
	ELSE
		MSGInfo("Título "+SE2->E2_NUM + SE2->E2_PREFIXO +" não está bloqueado!") 	
	ENDIF

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PE_FA750BRWºAutor  ³Microsiga           º Data ³  08/29/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ImpSISPAG()                      

	Local cIDCNAB := SE2->E2_IDCNAB      
	Local cPathSIS := GetMV("AL_PATHSPG") 
	Local cArquivo := "file:///"+Alltrim(cPathSIS)+cIDCNAB+".htm"
	Local cFornece := SE2->E2_FORNECE+SE2->E2_LOJA    
	Local cDestinat := ""    
	Local cArqBrowser := ""
	Local cAnexo := ""    
	Local cMsgBody := ""

	Private nPgVist := 1 
	Private aSize := MsAdvSize() 
	Private oDlg1, oTIBrw 
	Private cNavegado := Space(400)                                    
	Private lcont := .F. 

	//Testo se existe o controle de autenticaçao
	If Alltrim(SE2->E2_IDSISPG) == ''
		MSGSTOP("Não existe comprovante de pagamento SISPAG para este título.")
		Return()
	EndIf

	//Pagina de abertura no navegador
	cPage := cArquivo             
	cAnexo := Alltrim(cPathSIS)+cIDCNAB+".htm"

	DEFINE MSDIALOG oDlg1 TITLE "SISPAG COMPROVANTE" From 0,0 to 570,1250 of oMainWnd PIXEL 

	cNavegado := cPage 
	oNav:= TGet():New(10,10,{|u| if(PCount()>0,cNavegado:=u,cNavegado)}, oDlg1,340,5,,,,,,,,.T.,,,,,,,,,,)    
	@ 010, 350 Button oBtnEnvia 	PROMPT "Enviar" Size 40,10 Action (oDlg1:End(),lCont := .T.) Of oDlg1 Pixel 
	@ 010, 390 Button oBtnImprime PROMPT "Imprimir" Size 40,10 Action (oTIBrw:PrintPDF(),oDlg1:End()) Of oDlg1 Pixel
	@ 010, 430 Button oBtnSair 	PROMPT "Sair" Size 40,10 Action oDlg1:End() Of oDlg1 Pixel    
	oTIBrw := TWebEngine():New(oDlg, 025, 010, 610, 250,cPage, )                                 
	//oTIBrw:= TIBrowser():New( 025,010,610, 250, cPage, oDlg1 )     
	Activate MsDialog oDlg1 Centered 

	If lCont  
		cDestinat := Alltrim(Posicione("SA2",1,cFornece,"A2_EMAIL"))
		If cDestinat == ''
			If MSGYesNo("Não existe e-mail cadastrado para este fornecedor. Deseja informar um?")
				Do While Alltrim(cDestinat) == ''
					cDestinat := U_GetAddress()
					If Alltrim(cDestinat) == ''
						MSGInfo("Informe um e-mail válido")
					EndIf
				EndDo
				cDestinat += ";"+Alltrim(GetMV("AL_MAILADM"))
				cMsgBody := U_GetMotAlt()
				WFEnviaJa(cDestinat,cAnexo, cMsgBody)
			EndIf
		Else          
			cMsgBody := U_GetMotAlt()
			WFEnviaJa(cDestinat,cAnexo, cMsgBody)
		EndIf	
	EndIf

Return       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PE_FA750BRWºAutor  ³Microsiga           º Data ³  09/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function EnvAutentic(cDestinat,cArqAnexo,cMsgBody)

	Local lResult   := .f.
	Local cTitulo1
	Local cEmailBcc	:= ""
	Local cError   	:= ""
	Local lRelauth 	:= GetNewPar("MV_RELAUTH",.F.)		// Parametro que indica se existe autenticacao no e-mail
	Local lRet	   	:= .F.
	Local cFrom	   	:= GetMV("MV_RELACNT")
	Local cConta   	:= GetMV("MV_RELACNT")
	Local cSenhaX  	:= GetMV("MV_RELPSW")
	Local cEmailTo 	:= Alltrim(GetMV("AL_MAILADM"))//+";"+cDestinat
	Local lFirst   	:= .T.
	Local cAnexo	:= ""//cArqAnexo
	cTitulo1 := "ALUBAR Comprovante de Pagamento SISPAG"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tenta conexao com o servidor de E-Mail ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CONNECT SMTP                         ;
	SERVER 	 GetMV("MV_RELSERV"); 	// Nome do servidor de e-mail
	ACCOUNT  GetMV("MV_RELACNT"); 	// Nome da conta a ser usada no e-mail
	PASSWORD GetMV("MV_RELPSW") ; 	// Senha
	RESULT   lResult             	// Resultado da tentativa de conexão

	Alert(Alltrim(cAnexo))

	// Se a conexao com o SMPT esta ok
	If lResult

		// Se existe autenticacao para envio valida pela funcao MAILAUTH
		If lRelauth
			lRet := Mailauth(cConta,cSenhaX)
		Else
			lRet := .T.
		Endif

		If lRet
			SEND MAIL FROM 	cFrom ;
			TO 					cEmailTo;
			BCC     				cEmailBcc;
			SUBJECT 				cTitulo1;
			BODY 					cMSGBody;
			ATTACHMENT  		cAnexo  ;                                                                                                                 
			RESULT lResult	

			If !lResult
				//Erro no envio do email
				GET MAIL ERROR cError
				MsgStop("Erro no envio de e-mail","erro de envio")
			ELSE  
				DISCONNECT SMTP SERVER
				MSGInfo("Comprovante enviado por e-mail para: "+cEmailTo,"ManCTBRMES - Email Enviado")
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

Return()    



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PE_FA750BRWºAutor  ³Microsiga           º Data ³  09/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GetAddress()

	Local oButton1
	Local oButton2
	Local oGetMail
	Local cAddress := Space(150)
	Local oPanel1
	Local oSay1
	Local lCont := .F.
	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "Informe E-Mail" FROM 000, 000  TO 095, 625 COLORS 0, 16777215 PIXEL

	@ 000, 000 MSPANEL oPanel1 SIZE 312, 047 OF oDlg COLORS 0, 16777215 RAISED
	@ 013, 005 SAY oSay1 PROMPT "E-Mail:" SIZE 025, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
	@ 011, 025 MSGET oGetMail VAR cAddress SIZE 280, 012 OF oPanel1 COLORS 0, 16777215 PIXEL
	@ 027, 225 BUTTON oButton1 PROMPT "OK" SIZE 037, 012 OF oPanel1 PIXEL Action oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED


Return(cAddress)                              


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFlowEnvia ºAutor  ³Denis Haruo        º Data ³  09/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Wflow envia um email com o html criado                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function WFEnviaJa(cDestinat,cArqAnexo, cMsgBody)

	//Variaveis do Processo oHTML
	Local cCodProcesso, cCodStatus, cHtmlModelo, oHtml, oProcess
	Local cUsuarioProtheus, cCodProduto, cTexto, cAssunto
	//Local lServProd := IIF(GetServerIP() == '172.28.1.24', .T., .F.)
	Local cEnviron := Upper(GetEnvServer())

	******************************** 
	conout("Iniciando a WFlowEnvia")                       
	******************************** 

	cCodProcesso := "WF_106" 																// Código extraído do cadastro de processos.
	cHtmlModelo := cArqAnexo											 					// Arquivo html template utilizado para montagem da aprovação
	cAssunto := "SISPAG Alubar: Notificação de Pagamento de Contas"			// Assunto da mensagem
	oProcess:= TWFProcess():New(cCodProcesso, cAssunto) 							// Criando o processo
	cTitulo :=  "WF_106" 																	
	oProcess:NewTask(cTitulo, cHtmlModelo) 											// Inicio da criação da tarefa   
	oHtml	:= oProcess:oHTML																	// Montagem do HTML!! 
	oProcess:cSubject 	:= "NOTIFICACAO DE SISPAG "								


	//Revisao do Workflow
	_cIpTest:=SuperGetMV("AL_IPSRVTS",.f.,"172.28.1.12")
	lServTeste := IIf(GetServerIP() == RTRIM(_cIpTest), .T.,.F.)
	If !lServTeste .and. Alltrim(cEnviron) == 'ENVIRONMENT' 
		//If lServProd .and. Alltrim(cEnviron) == 'ENVIRONMENT'  
		//oProcess:cTo 		:= Alltrim(GetMV("AL_MAILADM"))+";"+"joao.santos@alubar.net"+";"+cDestinat
		oProcess:cTo 		:= Alltrim(GetMV("AL_MAILADM"))+";"+cDestinat //12/12/17 - Fabio Yoshioka - Joao Santos Solititou retirada do envio em cópia
	ELse
		oProcess:cTo 		:= Alltrim(GetMV("AL_MAILADM"))
	EndIf

	oProcess:Start() 	//Inicia o processo... 
	oProcess:Finish()  //...e em seguida finaliza    

	Return(.T.)


	************************
User Function ALBLQPAG() //10/05/18 - Fabio Yoshioka
	************************  
	Local cUserBlq := RetCodUsr()
	Local _nTpBloq:=0
	//Local _lALBlqPgto:= IIF(UPPER(RTRIM(GETMV("AL_UBLQPGT")))=='S',.T.,.F.)
	Local _lALBlqPgto:= IIF(UPPER(ALLTRIM(GETMV("AL_UBLQPGT")))=='S',.T.,.F.) // CLAUDIO.SIGACORP  26/09/2018
	Local _cInfHist:=space(200)
	Local _cTxtMail:=""
	Local _cTit:=""
	Local _cEmail:=""
	Local _cmailCC:=""
	Local _cMailBlqFin:=RTRIM(GETMV("AL_MBLQPGT")) //24/05/18 - Enviar Notificação a outros usuarios


	if SE2->E2_SALDO>0 .and. _lALBlqPgto
		IF EMPTY(ALLTRIM(SE2->E2_ALUSRBL))
			IF MsgYesNo("Confirma BLOQUEIO do titulo "+SE2->E2_NUM+SE2->E2_PREFIXO+" do Fornecedor "+RTRIM(SE2->E2_NOMFOR)+" ?")

				while empty(alltrim(_cInfHist))
					//Informar motivo para histórico   
					DEFINE MSDIALOG _oDlgExc TITLE "Informe Motivo do Bloqueio" FROM 000, 000  TO 120, 470 COLORS 0, 16777215 PIXEL
					@ 001, 002 MSGET _oGetHist VAR _cInfHist SIZE 200, 012 
					@ 003, 020 BUTTON oButton2 PROMPT "OK" SIZE 050, 012 Action _oDlgExc:End()
					ACTIVATE MSDIALOG _oDlgExc Centered
				enddo

				While !RecLock("SE2",.F.); EndDo
				_nTpBloq:=1
				SE2->E2_ALUDTBL:=Dtos(DATE())+Substr(Time(),1,2)+Substr(Time(),4,2)
				SE2->E2_ALUSRBL:=cUserBlq
				SE2->E2_ALHISBL:=_cInfHist
				SE2->(MSUnlock())

				_cTxtMail:=" BLOQUEIO DE PAGAMENTOS DE TITULO "+SE2->E2_PREFIXO+"-"+SE2->E2_NUM+ CHR(13) + CHR(10)+ CHR(13) + CHR(10)
				_cTxtMail+=" FORNECEDOR: "+SE2->E2_FORNECE+"-"+SE2->E2_NOMFOR + CHR(13) + CHR(10) //24/05/18
				_cTxtMail+=" MOTIVO:"+ CHR(13) + CHR(10) 
				_cTxtMail+=_cInfHist+ CHR(13) + CHR(10)
				_cTxtMail+=" Valor Do Titulo:"+Transform(SE2->E2_SALDO,"@E 999,999,999.99")+ CHR(13) + CHR(10)  
				_cTxtMail+=Dtoc(DATE())+" "+Substr(Time(),1,2)+":"+Substr(Time(),4,2)

				_cTit:="BLQTIT - BLOQUEIO PAGAMENTO - TITULO:"+SE2->E2_PREFIXO+"-"+SE2->E2_NUM
				_cEmail:=UsrRetMail(cUserBlq)

				if !empty(alltrim(_cMailBlqFin)) //24/05/18
					_cEmail+=";"+_cMailBlqFin
				endif

				_cmailCC:=""

				U_AL_Mail(_cTxtMail, _cEmail, _cTit, _cmailCC)

			ENDIF
		ELSE
			IF MsgYesNo("Confirma DESBLOQUEIO do titulo "+SE2->E2_NUM+SE2->E2_PREFIXO+" do Fornecedor "+RTRIM(SE2->E2_NOMFOR)+" ?")

				//_cTxtMail:=" DESBLOQUEIO DE PAGAMENTOS DE TITULO "+SE2->E2_PREFIXO+"-"+SE2->E2_NUM + CHR(13) + CHR(10)+ CHR(13) + CHR(10)
				_cTxtMail:=" DESBLOQUEIO DE PAGAMENTOS DE TITULO "+SE2->E2_PREFIXO+"-"+SE2->E2_NUM + CHR(13) + CHR(10)+ CHR(13) + CHR(10)
				_cTxtMail+=" FORNECEDOR: "+SE2->E2_FORNECE+"-"+SE2->E2_NOMFOR + CHR(13) + CHR(10) //24/05/18
				_cTxtMail+=" Usuario: "+UsrFullName(cUserBlq)+ CHR(13) + CHR(10)
				_cTxtMail+=Dtoc(DATE())+" "+Substr(Time(),1,2)+":"+Substr(Time(),4,2)

				_cTit:="BLQTIT - DESBLOQUEIO PAGAMENTO - TITULO: "+SE2->E2_PREFIXO+"-"+SE2->E2_NUM
				_cEmail:=UsrRetMail(SE2->E2_ALUSRBL)//ENVIO PARA QUEM BLOQUEOU

				if !empty(alltrim(_cMailBlqFin)) //24/05/18
					_cEmail+=";"+_cMailBlqFin
				endif

				_cmailCC:=""


				While !RecLock("SE2",.F.); EndDo
				_nTpBloq:=2
				SE2->E2_ALUDTBL:=Dtos(DATE())+Substr(Time(),1,2)+Substr(Time(),4,2)
				SE2->E2_ALUSRBL:=SPACE(6)
				SE2->E2_ALHISBL:=""
				SE2->(MSUnlock())

				U_AL_Mail(_cTxtMail, _cEmail, _cTit, _cmailCC)
			ENDIF
		ENDIF
	ELSE
		MSGInfo( "Titulo sem saldo para Baixa!")
	ENDIF

	if _nTpBloq>0	
		MSGInfo( iif(_nTpBloq==1,"BLOQUEIO","DESBLOQUEIO")+ " do título "+SE2->E2_NUM + SE2->E2_PREFIXO+" foi realizado com sucesso!")
	endif

Return
