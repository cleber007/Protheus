#include 'protheus.ch'
#include "rwmake.ch"
#include 'parmtype.ch'
#Include 'Topconn.ch'
#include "ap5mail.ch"

User Function MT410TOK()

	/*----------------------------------------------------------------------+
	|Programa	: MT410TOK													|
	|Autor		: Wildner Pinto												|
	|Empresa	: Sigacorp													|
	|Data		: 12.12.2014												|
	|Fun��o		: Informar ao usu�rio na finaliza��o do or�amento que o 	|
	|			cliente possui titulos em atrazo.							|
	|Processo	: Verifica se as situa��es a seguir para os pedidos 		|
	|			selecionados:												|
	|			cTipoPed 	- deve ser igua a "N"							|
	|			AL_DTSCRED 	- deve ser menor ou igual que a data base		|
	|			dEmissao	- deve ser maior que AL_DTSCRED					|
	+----------------------------------------------------------------------*/
	Local _cEmp			:= FWCodEmp()
	Local _cEmpPar		:= ""
	Local _cFil 		:= FWCodFil()
	Local _cFilPar		:= ""
	Local _lExec		:= .F.
	Local _cEmpFil		:= GETMV("AL_EMPFIL")
	Local lRet			:= .F.				// Conteudo de retornoLoca
	LOcal nOpc			:= PARAMIXB[1]		// Opcao de manutencaoLocal
	//Local aRecTiAdt		:= PARAMIXB[2]		// Array com registros de adiantamento
	Local cNumPed		:= M->C5_NUM		//Numero do Pedido
	Local cNumOrc		:= M->C5_NOMORC	//Numero do Or�amento
	Local cTipoPed		:= M->C5_TIPO		//Tipo do pedido
	Local cCodCli		:= M->C5_CLIENTE	//Cliente do Pedido
	Local cLoja			:= M->C5_LOJACLI	//Loja do Pedido
	Local dEmissao		:= M->C5_EMISSAO	//data de emiss�o do pedido
	Local _cCondPag 	:= M->C5_CONDPAG
	Local _cMVCPag		:= ""//GetMV("AL_CREDCP")
	//Local _nValPed		:= 0
	Local _cFuncao		:= Procname()// FUNNAME()
	//Local cMsg0,CMSg1
	//Local cQry0,cQry1
	Local _cSa1Cli    := GetMv("AL_SA1FIL") // Contem o codigo da Matriz no cadastro do Cliente.
	Local _cNumFIL    := GetMv("AL_CODFIL") // Contem o  N�mero da Empresa + Filial da Alubar Filial.
	Local _lCliFil    := GetMv("AL_CLIFIL") // Parametro que Ativa/Desativa a rotina.
	local i,k,j
	Local _lAnalisa		:= SuperGetMV("AL_BLOQORC",.F.,.F.)  //Verifica a ativa��o do controle de Bloqueio

	//Verifica se a opera��o do pedido � de altera��o. Em caso positivo, o programa verifica se j� existe libera��o deste PV com lotes inseridos, ou seja, se j� existe romaneio emitido
	//Em caso positivo, o sistema impede a altera��o e solicita que o usu�rio acione a expedi��o para efetuar o cancelamento do romaneio antes de qualquer altera��o no
	//pedido de vendas. Autor: Wagno Sousa 20190301
	Local cPedido:= SC5->C5_NUM

	If select('SC9TMP') > 0
		SC9TMP->(dbCloseArea())
	EndIf

	If PARAMIXB[1] == 4 //altera��o
		BeginSql Alias 'SC9TMP'
			SELECT TOP 1 R_E_C_N_O_ REGISTRO FROM SC9060 WHERE C9_PEDIDO = %Exp:cPedido% AND C9_LOTECTL <> '' AND C9_NFISCAL = '' AND %notdel%
		EndSql

		nRegistro:= SC9TMP->REGISTRO
		SC9TMP->(dbCloseArea())

		If nRegistro > 0
			alert("Pedido possui romaneio em andamento. Para alterar, solicite a exclus�o do romaneio.")
			Return .F.
		EndIf

	EndIf	

	While len(_cEmpFil)>0
		_cEmpPar:= SubStr(_cEmpFil,1,2)
		_cFilPar:= SubStr(_cEmpFil,3,2)
		_cEmpFil:= SubStr(_cEmpFil,6,len(_cEmpFil))
		//	alert(_cEmpPar+" | "+_cFilPar+" | "+_cEmpFil)
		IF _cEmp==_cEmpPar .AND. _cFil==_cFilPar
			_lExec:= .T.
		EndIf
	Enddo

	//	MsgAlert("Entrei no MT410TOK","Alerta!!!")

	IF !_lExec
		//INICIO - RAFAEL ALMEIDA - SIGACORP (22/01/2017)
		/*======================================================================================//
		| Objetivo dessa valida��o e para Filial da Alubar  "0602" que � uma Empresa de deposito|
		|  n�o fature para outros cliente que n�o sejam a Alubar Matriz. Conforme solicita��o da|
		|  Controladoria.                                                                       |
		|=======================================================================================*/
		If _lCliFil
			If _cEmp+_cFil == Alltrim(_cNumFIL)
				If Alltrim(cCodCli)+Alltrim(cLoja) <> Alltrim(_cSa1Cli)
					lRet:= .F.
					MsgAlert("Aten��o! Para Empresa que voc� esta conectada "+_cEmp+_cFil+" s� poder�  faturar para o CLIENTE = "+Alltrim(_cSa1Cli)+".","Alerta!!!")
					Return(lRet)
				EndIf
			EndIf//FIM - RAFAEL ALMEIDA - SIGACORP (22/01/2017)
		Else
			If !_lExec
				lRet := .T.
				Return(lRet)
			Else
				_cMVCPag	:= GetMV("AL_CREDCP")
			EndIf
		Endif
	EndIf

	_nMT410Val := TotalPed()

	if !_lAnalisa //Verifica a ativa��o do controle de Bloqueio de Pedido de Venda no Or�amento

		If cTipoPed == "N" .and. !(cCodCli+cLoja $ alltrim(SuperGetMV("AL_NCHKLIM",.F.,"21210201/21211301")))
			//		MsgAlert("Pedido tipo Normal "+cNumPed,"Alerta!!!")
			If DtoC(dDataBase)>=DtoC(GETMV("AL_DTSCRED"));
			.AND. DtoC(dEmissao)>=DtoC(GETMV("AL_DTSCRED"));
			.AND. !_cCondPag$_cMVCPag
				//		(Op��o 2 na aprova��o de venda)
				//    (op��o 1 na Exclus�o do pedido)
				//    (op��o 4 na Altera��o do pedido)
				//			MsgAlert("Conteudo variavel nOpc "+str(nOpc,6),"Alerta!!!")
				if nOpc == 3  //Inclus�o de PV  (Op��o 2 na aprova��o de venda)
					//				MsgAlert("Entrando para Solicita��o de Credito","Alerta!!!")

					lRet:= U_SCred020(cNumPed,cTipoPed,cCodCli,cLoja,_cFuncao,_nMT410Val,cNumOrc) //Chama a fun��o de valida��o da Solicita��o de Credito
				Else
					lRet:=.T.
				EndIf
			Else
				lRet:=.T.
			Endif
		Else
			lRet:=.T.
		EndIf
	Else
		lRet:=.T.
	Endif
	//Deve haver um tratamento aqui.
	//Retira a MSGDialog que faz a valida��o do codigo FCI no pedido
	//Denis Tsuchiya 28/06/2017
	if lRet  //Caso seja validado o pedido executa valid��o de FCI -- Antonio Carlos 05/11/2016	
		lRet := U_VALIDAFCI(cNumPed)	//--> Valida FCI - Luiz Sousa em 11/08/2016.
	Endif

	//Denis Tsuchiya 19/05/2017
	//Manipula��o do pre�o do Pedido de Venda
	//Regra: quando o pre�o de um produto de um cliente do Portal  
	//for alterado, enviar um e-mail ao gestor.  

	//Testando se o cliente � do Portal   
	if Select("CLI")>0
		CLI->(DbCloseArea())
	endIf

	cQry := " SELECT cliente from ALFAT_02 "
	cQry += " where cliente = '"+M->C5_CLIENTE+M->C5_LOJACLI+"' "
	TCQuery cQry NEW ALIAS "CLI" 
	dbSelectArea("CLI")
	if !EOF()

		aOldPrecos := {}
		aNewPrecos := {}
		cQry := " SELECT C6_ITEM, C6_PRCVEN, C6_PRODUTO, C6_CLI, C6_LOJA FROM "+RetSQLName("SC6")+" "
		cQry += " WHERE C6_FILIAL = '"+xFilial("SC6")+"' AND "
		cQry += " C6_NUM = '"+SC5->C5_NUM+"' AND "
		cQry += " D_E_L_E_T_ <> '*' "
		cQry += " ORDER BY C6_ITEM "
		TCQuery cQry NEW ALIAS "QRY" 
		dbSelectArea("QRY")
		dbGoTop()
		if !EOF()
			do while !EOF()
				aAdd(aOldPrecos, {QRY->C6_ITEM, QRY->C6_PRCVEN, QRY->C6_PRODUTO})
				dbSkip()
			endDo	
		endIf
		QRY->(dbCloseArea())

		For i := 1 to len(aCols)
			aAdd( aNewPrecos, {gdFieldGet("C6_ITEM",i,.F.),gdFieldGet("C6_PRCVEN",i,.F.), gdFieldGet("C6_PRODUTO",i,.F.)} )
		Next	

		aItensAlt := {}      
		//varrendo os pre�os anteriores
		for j := 1 to len(aOldPrecos)
			//varrendo o acols de novos pre�os
			for k := 1 to len(aNewPrecos) 
				//verificando se � o mesmo item
				if aOldPrecos[j,1] == aNewPrecos[k,1]
					if aOldPrecos[j,2] <> aNewPrecos[k,2]
						aAdd(aItensAlt,{aOldPrecos[j,1],aOldPrecos[j,3],aOldPrecos[j,2],aNewPrecos[k,2]})
					endif
				endif
			next K
		next j           

		if len(aItensAlt) > 0
			mailToGer(aItensAlt)		
		endif  

	endif
	CLI->(dbCloseArea())

Return lRet

Static Function TotalPed()

	Local nX     		:= 0
	Local nY        	:= 0
	Local nMaxFor		:= Len(aCols)
	Local nDescCab  	:= 0
	Local nUsado    	:= Len(aHeader)
	Local lTestaDel 	:= nUsado <> Len(aCols[1])
	Local nPosTotal 	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
	Local nPosDesc  	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
	Local nPPrUnit  	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
	Local nPQtdVen  	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
	Local nPPrcVen  	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
	Local nTotPed		:=0
	nTotDes			:=0

	/*---------------------------------------------------------------
	Soma as variaveis do aCols
	---------------------------------------------------------------*/

	For nY := 1 To 2
		For nX := 1 To nMaxFor
			If ( (lTestaDel .And. !aCols[nX][nUsado+1]) .Or. !lTestaDel )
				If ( nPosDesc > 0 .And. nPPrUnit > 0 .And. nPPrcVen > 0 .And. nPQtdVen > 0)
					If ( aCols[nX][nPPrUnit]==0 )
						nTotDes	+= aCols[nX][nPosDesc ]
					Else
						nTotDes += A410Arred(aCols[nX][nPPrUnit]*aCols[nX][nPQtdVen],"C6_VALDESC")-;
						A410Arred(aCols[nX][nPPrcVen]*aCols[nX][nPQtdVen],"C6_VALDESC")
					EndIf
				EndIf
				If ( nPosTotal > 0 )
					nTotPed	+=	aCols[nX][nPosTotal]
				EndIf
			EndIf
		Next nX
		nDescCab := M->C5_DESC4
		nTotPed  -= M->C5_DESCONT
		nTotDes  += M->C5_DESCONT
		nTotDes  += A410Arred(nTotPed*M->C5_PDESCAB/100,"C6_VALOR")
		nTotPed  -= A410Arred(nTotPed*M->C5_PDESCAB/100,"C6_VALOR")
		If nY == 1
			If FtRegraDesc(3,nTotPed+nTotDes,@M->C5_DESC4) == nDescCab
				Exit
			Else
				nTotPed	:=	0
				nTotDes	:=	0
			EndIf
		EndIf
	Next nY

	/*-----------------------------------------------------------------------
	Soma as variaveis da Enchoice
	------------------------------------------------------------------------*/
	nTotPed += M->C5_FRETE
	nTotPed += M->C5_SEGURO
	nTotPed += M->C5_DESPESA
	nTotPed += M->C5_FRETAUT

return(nTotPed)
/*---------------------------------<Fim da Fun��o>-----------------------------------------*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  mailToGer  �Autor  Denis Haruo           � Data �  05/30/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Envia um e-mail ao Gerente do Comercial quando um pedido    ���
���          � � alterado diretamente no Protheus                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function mailToGer(aItensAlt)

	local lResult := .f. // Resultado da tentativa de comunicacao com servidor de E-Mail
	local lRet	   := .F.

	local cFrom	   := GetMV("MV_RELACNT")
	local cConta   := GetMV("MV_RELACNT")
	local cSenhaX  := GetMV("MV_RELPSW")

	local cTitulo := "Atualiza��o de Pedido de Venda pelo Protheus"
	local lRelauth := GetNewPar("MV_RELAUTH",.F.)		// Parametro que indica se existe autenticacao no e-mail
	local cEmailTo := "workflow.alubar@alubar.net"
	local cEmailBcc := ""
	local cError := ""
	local cAnexo := ""
	local cHtml := ""
	local ni

	cHtml  := '<!DOCTYPE html>'
	cHtml  += '<html>'
	cHtml  += '    <head>'
	cHtml  += '        <meta charset = "utf-8">'
	cHtml  += '        <meta http-equiv = "X-UA-Compatible" content = "IE=edge">'
	cHtml  += '        <meta name = "viewport" content = "width=device-width, initial-scale=1">'
	cHtml  += '        <meta name = "author" content = "Denis Haruo">'
	cHtml  += '        <title>Portal Alubar</title>'
	cHtml  += '    </head>'
	cHtml  += '    <body style=" font-family: arial, sans-serif;">'
	cHtml  += '        <div class = "conteudo" style = "margin: auto; width: 90%;">'
	cHtml  += '            <header style = "color: rgb(0, 0, 102); text-align: center;">'
	cHtml  += '                <h2 style = "margin-bottom:-20px;">PORTAL ALUBAR INFORMA</h2>'
	cHtml  += '                <h4 style = "margin-bottom:-20px;">ATUALIZA��O DE PRE�O DE VENDA</h4>'
	cHtml  += '                <h4 style = "margin-bottom:-20px;">CLIENTE: '+alltrim(posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_NOME"))+'</h4>'
	cHtml  += '                <h6>Emiss&atilde;o: '+DTOC(Date())+' �s '+substr(time(),1,5)+'</h6>'
	cHtml  += '                <hr style = "margin-top: -20px;">'
	cHtml  += '            </header>'
	cHtml  += '            <div id="corpo">'
	cHtml  += '                <table width = "100%">'
	cHtml  += '                    <tr>'
	cHtml  += '                        <td width = "60%" style = "color: rgb(0, 0, 102); font-size: 12px;">'
	cHtml  += '                            <p>'
	cHtml  += '                                Prezado(a) Senhor(a), <br/>'
	cHtml  += '                                Os seguintes itens do pedido de venda n�mero '+M->C5_NUM+' abaixo tiveram seus pre�os atualizados pelo Protheus.'                                
	cHtml  += '                            </p>'
	cHtml  += '                            <p>'
	cHtml  += '                                Atenciosamente, <br/>'
	cHtml  += '                                Comercial'
	cHtml  += '                            </p>'
	cHtml  += '                        </td>'
	cHtml  += '                        <td width = "40%" style = "color: rgb(0, 0, 102); font-size: 12px;">'
	cHtml  += '                            Atualizado por: '+usrRetName(RetCodUsr()) 
	cHtml  += '                            <hr>'
	cHtml  += '                            Pedido Marca: '+iif(M->C5_TPPROP=='A',"ALTEC","COPPERTEC")
	cHtml  += '                        </td>'
	cHtml  += '                    </tr>'
	cHtml  += '                </table>'
	cHtml  += '                <hr>'
	cHtml  += '                <table width = "100%" style="font-size: 12px;">'
	cHtml  += '                    <thead style = "background-color: rgb(0, 0, 102); color: white;">'
	cHtml  += '                    <th style="text-align: center;">Item</th>'
	cHtml  += '                    <th style="text-align: center;">C�digo</th>'
	cHtml  += '                    <th style="text-align: left;">Produto</th>'
	cHtml  += '                    <th style="text-align: center;">Ult. Pre�o</th>'
	cHtml  += '                    <th style="text-align: center;">Novo Pre�o</th>'
	cHtml  += '                    </thead>'
	cHtml  += '                    <tbody>'

	for ni := 1 to len(aItensAlt)
		cHtml  += '                        <tr style = "background-color: #e6e6e6; color: rgb(0, 0, 102);">'
		cHtml  += '                            <td style="text-align: center;">'+aItensAlt[ni,1]+'</td>'
		cHtml  += '                            <td style="text-align: center;">'+aItensAlt[ni,2]+'</td>'
		cHtml  += '                            <td>'+alltrim(posicione("SB1",1,xFilial("SB1")+aItensAlt[ni,2],"B1_DESC"))+'</td>'
		cHtml  += '                            <td style="text-align: center;">'+transform(aItensAlt[ni,3],"@E 999,999.99")+'</td>'
		cHtml  += '                            <td style="text-align: center;">'+transform(aItensAlt[ni,4],"@E 999,999.99")+'</td>'
		cHtml  += '                        </tr>'
	next    

	cHtml  += '                    </tbody>'
	cHtml  += '                </table>'
	cHtml  += '            </div>'
	cHtml  += '        </div>'
	cHtml  += '    </body>'
	cHtml  += '</html>'


	//����������������������������������������Ŀ
	//� Tenta conexao com o servidor de E-Mail �
	//������������������������������������������
	CONNECT SMTP                         ;
	SERVER 	 GetMV("MV_RELSERV"); 	// Nome do servidor de e-mail
	ACCOUNT  GetMV("MV_RELACNT"); 	// Nome da conta a ser usada no e-mail
	PASSWORD GetMV("MV_RELPSW") ; 	// Senha
	RESULT   lResult             	// Resultado da tentativa de conex�o

	// Se a conexao com o SMPT esta ok
	If lResult

		// Se existe autenticacao para envio valida pela funcao MAILAUTH
		If lRelauth
			lRet := Mailauth(cConta,cSenhaX)
		Else
			lRet := .T.
		Endif

		If lRet
			SEND MAIL FROM	cFrom;
			TO cEmailTo;
			BCC cEmailBcc;
			SUBJECT cTitulo;
			BODY cHTML;
			ATTACHMENT cAnexo;
			RESULT lResult		

			If !lResult
				//Erro no envio do email
				GET MAIL ERROR cError
				MsgStop("Erro no envio de e-mail","erro de envio")
			ELSE
				DISCONNECT SMTP SERVER
				ALERT("E-Mail enviado a TI !!!")
			Endif
		Else
			GET MAIL ERROR cError
			MsgStop("Erro de autentica��o","Verifique a conta e a senha para envio")
		Endif	
		DISCONNECT SMTP SERVER
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		MsgStop("Erro de CONEXAO COM SMTP","ERRO DE CONEXAO COM SMTP...")
	Endif

RETURN
