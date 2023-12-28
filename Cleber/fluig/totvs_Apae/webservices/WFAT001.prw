#include "protheus.ch"
#Include "restful.ch"
#Include 'parmtype.ch'
#include "topconn.ch"
#Include "TbiConn.ch"
#INCLUDE 'totvs.ch'
#include 'Rwmake.ch'
#include "TbiCode.ch"        
#include 'FWMVCDEF.CH' 

/*-------------------------------------------------------------------
Programa: WFAT001
Autor: Andr? A. Alves
Data: 01/04/2021
Descrição: API Consultas FAT
------------------------------------------------------------------*/

/***********************/
User Function UGPEE032()
	/***********************/
Return()

WSRESTFUL dadoscli DESCRIPTION "Servico REST para consultas e inclusao de dados de cliente no ambiente TOTVS PROTHEUS" Format APPLICATION_JSON

	WSDATA desccli         AS STRING OPTIONAL
	WSDATA cnpj            AS STRING OPTIONAL
	WSDATA estado          AS STRING OPTIONAL
	WSDATA muninicipo      AS STRING OPTIONAL
	WSDATA codigo          AS STRING OPTIONAL
	WSDATA email           AS STRING OPTIONAL
	WSDATA regiao          AS STRING OPTIONAL
	WSDATA tipocli         AS STRING OPTIONAL	
	
	// WSDATA pagesize        AS INTEGER OPTIONAL

	WSMETHOD GET changedemployee;
		DESCRIPTION "Consulta Clientes";
		WSSYNTAX "/changedemployee";
		PATH "/changedemployee"

	WSMETHOD POST includesemploycliente;
		DESCRIPTION "Inclusao e alteração de clientes";
		WSSYNTAX "/includesemploycliente";
		PATH "/includesemploycliente"

END WSRESTFUL

WSMETHOD GET changedemployee WSRECEIVE desccli, cnpj, estado, muninicipo, codigo, email, regiao , tipocli WSSERVICE dadoscli

	Local lRet
	Local nCodErr
	Local cMsgErr       := ""
	Local cJson         := ""
	Local lPrim         := .T.
	Local nTotCpo
	Local nX
	Local aTabelas      := {"SM0","SX2","SX3","SX5","SA1","SX1","SX6","SX7","SXG"}

	RPCSetType(3)
	RpcSetEnv("01", "01", nil, nil, "FAT", NIL, aTabelas)

	cDescCli 	:= ::desccli
	cCnpj 		:= ::cnpj
	cEstado    	:= ::estado
	cMunicipio 	:= ::muninicipo
	cCodigo 	:= ::codigo
	cStatus 	:= "1"
	cEmail		:= ::email
	cRegiao 	:= ::regiao
	cTipoCli 	:= ::tipocli

	// Define o tipo de retorno
	::SetContentType("application/json")


	IF Select("CLIENTE") <> 0
		DbSelectArea("CLIENTE")
		DbCloseArea()
	ENDIF
	_cquer:=" SELECT A1_FILIAL AS FILIAL,"
	_cquer+="  A1_COD AS CODIGO,"
	_cquer+="  A1_LOJA AS LOJA,"
	_cquer+="  A1_TIPO AS TIPO_CLIENTE,"
	_cquer+="  A1_NOME AS RAZAO_SOCIAL,"
	_cquer+="  A1_NREDUZ AS NOME_FANTASIA,"
	_cquer+="  A1_END AS ENDERECO,"
	_cquer+="  A1_BAIRRO AS BAIRRO,"
	_cquer+="  A1_EST AS ESTADO,"
	_cquer+="  A1_CEP AS CEP,"
	_cquer+="  A1_MUN AS MUNICIPIO,"
	_cquer+="  A1_MSBLQL AS STATUS,"
	_cquer+="  A1_EMAIL AS EMAIL_COPIA_PEDIDO,"
	_cquer+="  A1_EMAIL AS EMAIL_XML_NFE,"
	_cquer+="  A1_CGC AS CGC,"
	_cquer+="  A1_MCOMPRA AS MAIOR_COMPRA,"
	_cquer+="  A1_MSALDO AS MAIOR_SALDO,"
	_cquer+="  A1_NROCOM AS NUMERO_COMPRAS,"
	_cquer+="  A1_SALDUP AS SALDO_ABERTO,"
	_cquer+="  A1_NROPAG AS NUMERO_PAGAMENTOS,"
	_cquer+="  A1_MAIDUPL AS MAIOR_DUPLICATA,"
	_cquer+="  A1_METR AS MEDIA_ATRASO,"
	_cquer+="  A1_MATR AS MAIOR_ATRASO,"
	_cquer+="  A1_DTCAD AS DATA_CADASTRO,"
	_cquer+="  A1_INSCR AS IE,"
	_cquer+="  A1_METR AS MEDIA_ATRASO,"
	_cquer+="  A1_SALDUPM AS SALDO_TITULOS,"
	_cquer+="  A1_ULTCOM AS ULTIMA_COMPRA,"
	_cquer+="  A1_CGC AS CNPJ,"
	_cquer+="  A1_ULTVIS AS ULTIMA_VISITA,"
	_cquer+="  A1_LC AS LIMITE_CREDITO,"
	_cquer+="  A1_HPAGE AS SITE,"
	_cquer+="  A1_DDD AS DDD,"
	_cquer+="  A1_TEL AS TELEFONE,"
	_cquer+="  A1_OBSERV AS OBSERVACAO,"
	_cquer+="  A1_COD_MUN AS COD_IBGE,"
	_cquer+="  A1_FACE AS FACEBOOK,"
	_cquer+="  A1_INSTA AS INSTAGRAM,"
	_cquer+="  A1_YOUT AS YOUTUBE,"
	_cquer+="  A1_TWITTER AS TWITTER,"
	_cquer+="  A1_XREG AS REGIAO,"
	_cquer+="  A1_DTULTIT AS ULTIMO_PROTESTO,"
	_cquer+="  A1_PESSOA  AS PESSOA,"	
	_cquer+="  A1_XTIPOCL AS XTIPOCL,"	
	_cquer+="  A1_XSITUAC AS XSITUAC,"	
	_cquer+="  A1_XDTFUND AS XDTFUND,"	
	_cquer+="  A1_XDTFILI AS XDTFILI,"			
	_cquer+="  A1_XCODFIL AS XCODFIL,"			
	_cquer+="  A1_XNOMPRE AS XNOMPRE"			
	_cquer+="  FROM "+ retsqlname("SA1")+" A1"
	_cquer+="  WHERE A1.D_E_L_E_T_ = ' '"
	_cquer+="  AND A1.A1_MSBLQL <> '1'"
	if valtype(cDescCli) <> "U"
		_cquer+="  AND A1_NREDUZ LIKE '"+cDescCli+"%'"
	Endif
	If valtype(cCnpj) <> "U"
		_cquer+="  AND A1_CGC LIKE '%"+cCnpj+"%'"
	Endif
	If valtype(cEstado) <> "U"
		_cquer+="  AND A1_EST LIKE '%"+cEstado+"%'"
	Endif
	If valtype(cMunicipio) <> "U"
		_cquer+="  AND A1_MUN LIKE '%"+cMunicipio+"%'"
	Endif
	If valtype(cCodigo) <> "U"
		_cquer+="  AND A1_COD = '"+cCodigo+"'"
	Endif
	If valtype(cEmail) <> "U"
		_cquer+="  AND A1_EMAIL = '"+cEmail+"'"
	Endif
	If valtype(cRegiao) <> "U"
		_cquer+="  AND A1_XREG = '"+cRegiao+"'"
	Endif
	If valtype(cTipoCli) <> "U"
		if !Empty(cTipoCli)
		_cquer+="  AND A1_XTIPOCL = '"+cTipoCli+"'"
		EndIf
	Endif	
	
	_cquer:=changequery(_cquer)

	tcquery _cquer new alias "CLI"
	CLI->(DbGoTop())

	cJson := '{' + CRLF

	While !CLI->(EOF())

		If lPrim
			cJson   += Space(2) + '"ITENS": [' + CRLF
			cJson   += Space(4) + '{' + CRLF
			nTotCpo := 48 //CLI->(FieldCount())
			lPrim   := .F.
		Else
			cJson   += Space(4) + ',{' + CRLF
		EndIf

		For nX := 1 to nTotCpo

			cJson += Space(6)

			If nX > 1
				cJson += ','
			EndIf

				// EncodeUTF8( cValToChar(AllTrim(FORNECEDOR->(FieldGet(nX)))) ) 
			
			If ValType(CLI->(FieldGet(nX))) == "C"
				IF CLI->(FieldName(nX)) $ 'RAZAO_SOCIAL'
					cJson += '"' + CLI->(FieldName(nX)) + '": "' +  EncodeUTF8( FWNoAccent(cValToChar( AllTrim(CLI->(FieldGet(nX))))) ) + '"' + CRLF
				Elseif CLI->(FieldName(nX)) $ 'ENDERECO'
					cJson += '"' + CLI->(FieldName(nX)) + '": "' +  EncodeUTF8( FWNoAccent(cValToChar( Alltrim(CLI->(FieldGet(nX))))) ) + '"' + CRLF
				//Elseif CLI->(FieldName(nX)) $ 'XNOMPRE'
				//	cJson += '"' + CLI->(FieldName(nX)) + '": "' +  EncodeUTF8( cValToChar( Alltrim(CLI->(FieldGet(nX)))) ) + '"' + CRLF - Erro
				Elseif CLI->(FieldName(nX)) $ 'MUNICIPIO'
					cJson += '"' + CLI->(FieldName(nX)) + '": "' +  EncodeUTF8( FWNoAccent(cValToChar( Alltrim(CLI->(FieldGet(nX))))) ) + '"' + CRLF
				Elseif CLI->(FieldName(nX)) $ 'BAIRRO'
					cJson += '"' + CLI->(FieldName(nX)) + '": "' +  EncodeUTF8( FWNoAccent(cValToChar( Alltrim(CLI->(FieldGet(nX))))) ) + '"' + CRLF
				Elseif CLI->(FieldName(nX)) $ 'NOME_FANTASIA'
					cJson += '"' + CLI->(FieldName(nX)) + '": "' +  EncodeUTF8( FWNoAccent(cValToChar( Alltrim(CLI->(FieldGet(nX))))) ) + '"' + CRLF
				Elseif CLI->(FieldName(nX)) $ 'XNOMPRE'
					cJson += '"' + CLI->(FieldName(nX)) + '": "' +  ( FWNoAccent(cValToChar( Alltrim(CLI->(FieldGet(nX))))) ) + '"' + CRLF
				Else 
					cJson += '"' + CLI->(FieldName(nX)) + '": "' +  cValToChar( Alltrim(CLI->(FieldGet(nX))))  + '"' + CRLF
				EndIf
			Else
				cJson += '"' + CLI->(FieldName(nX)) + '": ' +  cValToChar( CLI->(FieldGet(nX)) )  + CRLF
			EndIf

		Next nX

		cJson += Space(4) + '}' + CRLF

		CLI->(DbSkip())
	EndDo

	CLI->(DbCloseArea())

	If lPrim
		nCodErr := 400
		cMsgErr := EncodeUTF8("Dados não encontrados")
		Break
	Else
		cJson += Space(2) + ']' + CRLF
	EndIf

	cJson += '}' + CRLF

	::SetResponse(cJson)
	lRet := .T.

	// EndIf
	RpcClearEnv()
Return(lRet)

WSMETHOD POST includesemploycliente WSSERVICE dadoscli

	Local cBody             := ''
	Local oJson             as Object
	Local cJSon             as Character
	Local cRet              as Character
	Local aDados            as Array
	Local nTot              as Numeric
	Local nX                as Numeric
	Local lPost             as Logical
	Local _cStrArray		:= ""
	Local aTabelas          := {"SM0","SX2","SX3","SX5","SA1","SX1","SX6","SX7","SXG"}

	Private lMsErroAuto := .F.	

	RPCSetType(3)
	RpcSetEnv("01", "01", NIL, NIL, "FAT", NIL, aTabelas)
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1)) // A1_FILIAL+A1_COD+A1_LOJA

	Begin Sequence
		
		// Define o tipo de retorno do método
		Self:SetContentType("application/json; charset=utf-8") 
		//::SetContentType("application/json")

		// Recupera o body da requisicao
		cBody := ::GetContent()
		ConOut( cBody )
		// Cria objeto json
		oJson := JsonObject():New()

		// Processa retorno
		cRet := oJson:FromJson(cBody)

		If cRet <> NIL
			SetRestFault(406,"JSON com formato inadequado")
			Break
		EndIf

		// Carrega array com os dados
		aDados := oJson["data"]

		cJSon := '{'
		cJSon += '"code": "200",'
		cJson += '"message": "Sucesso",'
		cJson += '"detailedmessage": "Chamada Inclusao/Ateracao Clientes realizada com sucesso",'
		cJSon += '"data": ['

		nTot := Len(aDados)

		For nX := 1 to nTot

			If nX > 1
				cJSon += ','
			EndIf
			
			CCNPJ   := iif(ValType(aDados[nX]["CGC"]) <> "U", aDados[nX]["CGC"], "") 
			cPessoa := IIF(len(Alltrim(CCNPJ))==11,"F","J")

			//xcCodMun := aDados[i,nPosCodMun]
			cEst     := iif(ValType(aDados[nX]["ESTADO"]) <> "U", aDados[nX]["ESTADO"], "")
			cMun     := iif(ValType(aDados[nX]["MUNICIPIO"]) <> "U", aDados[nX]["MUNICIPIO"], "")
			cCodMun  := ""

			If Select("CODMUN") > 0
				CODMUN->(DbClosearea())
			EndIf
			cQry :=" SELECT CC2_CODMUN FROM " + RetSqlName("CC2")
			cQry +=" WHERE D_E_L_E_T_<>'*' AND CC2_FILIAL='"+xFilial("CC2")+"'"
			cQry +=" AND CC2_EST='"+cEst+"' AND CC2_MUN LIKE '%"+Alltrim(cMun)+"%'"
			Tcquery cQry New Alias 'CODMUN'  

			DbSelectArea("CODMUN")
			CODMUN->(DbGoTop())
				While CODMUN->(!Eof())
				cCodMun := CODMUN->CC2_CODMUN    
				CODMUN->(DbSkip())
			EndDo
			If Select("CODMUN") > 0
				CODMUN->(DbClosearea())
			EndIf

			cinclui := .F.
			caltera := .F.

			dbSelectArea("SA1")
			SA1->(dbGoTop())		
			SA1->(dbSetOrder(3))  
			If SA1->(dbSeek(xFilial("SA1") + CCNPJ ) )

				caltera := .T.
				cinclui := .F.

				aCliente := {{"A1_FILIAL"   , SA1->A1_FILIAL														    				,Nil},; //Codigo     -C-06
							{"A1_COD"   	, SA1->A1_COD     																			,Nil},; //Nome       -C-40
							{"A1_LOJA"   	, SA1->A1_LOJA    																			,Nil},; //Nome       -C-40
							{"A1_NOME"   	, iif(ValType(aDados[nX]["NOME"]) <> "U", aDados[nX]["NOME"], "")   						,Nil},; //Nome       -C-40
							{"A1_NREDUZ" 	, iif(ValType(aDados[nX]["NOME_FANTASIA"]) <> "U", aDados[nX]["NOME_FANTASIA"], "")   		,Nil},; //Nome Reduz.-C-20
							{"A1_END"    	, iif(ValType(aDados[nX]["ENDERECO"]) <> "U", aDados[nX]["ENDERECO"], "")   				,Nil},; //Logradouro -C-40
							{"A1_BAIRRO" 	, iif(ValType(aDados[nX]["BAIRRO"]) <> "U", aDados[nX]["BAIRRO"], "")   					,Nil},; //Bairro     -C-30
							{"A1_EST"  		, iif(ValType(aDados[nX]["ESTADO"]) <> "U", aDados[nX]["ESTADO"], "")   					,Nil},; //Insc.Est.  -C-18
							{"A1_CEP"  		, iif(ValType(aDados[nX]["CEP"]) <> "U", aDados[nX]["CEP"], "74100000")   					,Nil},; //Insc.Est.  -C-18 A1_COD_MUN
							{"A1_COD_MUN"  	, cCodMun   																				,Nil},;
							{"A1_MUN"    	, iif(ValType(aDados[nX]["MUNICIPIO"]) <> "U", aDados[nX]["MUNICIPIO"], "")   				,Nil},; //Cidade     -C-25
							{"A1_DDD"    	, iif(ValType(aDados[nX]["DDD"]) <> "U", aDados[nX]["DDD"], "062")   						,Nil},; //Cidade     -C-25
							{"A1_TEL"  		, iif(ValType(aDados[nX]["TELEFONE"]) <> "U", aDados[nX]["TELEFONE"], " ")   				,Nil},; //Insc.Est.  -C-18
							{"A1_EMAIL"  	, iif(ValType(aDados[nX]["EMAIL"]) <> "U", aDados[nX]["EMAIL"], "")   						,Nil},; //ContaCont. -C-20
							{"A1_XTIPOCL"   , iif(ValType(aDados[nX]["TIPOCLIENTE"]) <> "U", aDados[nX]["TIPOCLIENTE"], "")   			,Nil},; //ContaCont. -C-20 //1 - APAE 2 - GOVERNO - 3 - ANGARIADORES - 4 - FEAPAES - 5 - CO IRMAOS  - 9 OUTROS
							{"A1_XSITUAC"   , iif(ValType(aDados[nX]["SITUACAO"]) <> "U", aDados[nX]["SITUACAO"], "")   				,Nil},; //ContaCont. -C-20 //1-DESFILIADAS - 2 FILIADAS - 3 PROCESSO D FILIACAO 4 - INDEFINIDAS - 5 - COIRMA
							{"A1_XDTFUND"   , iif(ValType(aDados[nX]["XDTFUND"]) <> "U", CTOD(aDados[nX]["XDTFUND"]), CTOD("  /  /  ") ),Nil},; //ContaCont. -C-20 //DATA FUNDACAO
							{"A1_XDTFILI"   , iif(ValType(aDados[nX]["XDTFILI"]) <> "U", CTOD(aDados[nX]["XDTFILI"]), CTOD("  /  /  ") ),Nil},; //ContaCont. -C-20 //DATA FILIAÇÃO
							{"A1_XCODFIL"   , iif(ValType(aDados[nX]["NUM_FILIACAO"]) <> "U", aDados[nX]["NUM_FILIACAO"], 0)   			,Nil},; //ContaCont. -C-20 //NUMERICO	
							{"A1_XGRUPCO"   , iif(ValType(aDados[nX]["GRP_FILIACAO"]) <> "U", aDados[nX]["GRP_FILIACAO"], "")   		,Nil},; //Insc.Est. -C-18  //GRUPO FILIAÇÃO
							{"A1_XNOMPRE"   , iif(ValType(aDados[nX]["NOME_PRESID"])  <> "U", aDados[nX]["NOME_PRESID"], "")   			,Nil},; //ContaCont. -C-20 //NOME PRESIDENTE							 					 						 						 
							{"A1_XAGENC1"   , iif(ValType(aDados[nX]["AGENCIA"]) <> "U", aDados[nX]["AGENCIA"], "")   					,Nil},; //Agencia.   -C-05 	
							{"A1_XCONTA1"   , iif(ValType(aDados[nX]["BANCOCONTA"]) <> "U", aDados[nX]["BANCOCONTA"], "")   			,Nil},; //banco. 	 -C-10  
							{"A1_XSCONT1"   , iif(ValType(aDados[nX]["BANCOSUBCONTA"])  <> "U", aDados[nX]["BANCOSUBCONTA"], "")   		,Nil},; //SubConta.  -C-03 					 					 						 						 
							{"A1_LC"		, iif(ValType(aDados[nX]["LIMITE_CREDITO"]) <> "U", aDados[nX]["LIMITE_CREDITO"], 0)  		,Nil} } //Cod.País   -C-05

			Else

				cinclui := .T.
				caltera := .F.
				
				aCliente := {{"A1_FILIAL"   , iif(ValType(aDados[nX]["FILIAL"]) <> "U", aDados[nX]["FILIAL"], "0101")   				,Nil},; //Codigo     -C-06
							{"A1_TIPO"   	, iif(ValType(aDados[nX]["TIPO_CLIENTE"]) <> "U", aDados[nX]["TIPO_CLIENTE"], "")   		,Nil},; //Tipo = F - Cons.Final	L Produtor Rural		
							{"A1_PESSOA"  	, cPessoa  																				    ,Nil},; //A1_PESSOA. -C-1 - F - FISICA - J - J JURIDICA	 		iif(ValType(aDados[nX]["PESSOA"]) <> "U", aDados[nX]["PESSOA"], "J")	
							{"A1_CGC"    	, iif(ValType(aDados[nX]["CGC"]) <> "U", aDados[nX]["CGC"], "")   							,Nil},; //CPF-CNPJ   -C-14						 				 
							{"A1_NOME"   	, iif(ValType(aDados[nX]["NOME"]) <> "U", aDados[nX]["NOME"], "")   						,Nil},; //Nome       -C-80
							{"A1_NREDUZ" 	, iif(ValType(aDados[nX]["NOME_FANTASIA"]) <> "U", aDados[nX]["NOME_FANTASIA"], "")   		,Nil},; //Nome Reduz.-C-40
							{"A1_END"    	, iif(ValType(aDados[nX]["ENDERECO"]) <> "U", aDados[nX]["ENDERECO"], "")   				,Nil},; //Logradouro -C-80
							{"A1_BAIRRO" 	, iif(ValType(aDados[nX]["BAIRRO"]) <> "U", aDados[nX]["BAIRRO"], "")   					,Nil},; //Bairro     -C-40
							{"A1_EST"  		, iif(ValType(aDados[nX]["ESTADO"]) <> "U", aDados[nX]["ESTADO"], "")   					,Nil},; //Estado.    -C-02 
							{"A1_CEP"  		, iif(ValType(aDados[nX]["CEP"]) <> "U", aDados[nX]["CEP"], "74100000")   					,Nil},; //CEP  		 -C-08 
							{"A1_COD_MUN"  	, cCodMun   																				,Nil},; 
							{"A1_MUN"    	, iif(ValType(aDados[nX]["MUNICIPIO"]) <> "U", aDados[nX]["MUNICIPIO"], "")   				,Nil},; //Municipio  -C-25
							{"A1_DDD"    	, iif(ValType(aDados[nX]["DDD"]) <> "U", aDados[nX]["DDD"], "062")   						,Nil},; //DDD    	 -C-03
							{"A1_TEL"  		, iif(ValType(aDados[nX]["TELEFONE"]) <> "U", aDados[nX]["TELEFONE"], " ")   				,Nil},; //Telefone   -C-15
							{"A1_MSBLQL"	, iif(ValType(aDados[nX]["STATUS"])  <> "U", aDados[nX]["STATUS"], "2")   					,Nil},; //Status 	 -C-01
							{"A1_EMAIL"  	, iif(ValType(aDados[nX]["EMAIL"]) <> "U", aDados[nX]["EMAIL"], "")   						,Nil},; //Email      -C-120
							{"A1_XTIPOCL"   , iif(ValType(aDados[nX]["TIPOCLIENTE"]) <> "U", aDados[nX]["TIPOCLIENTE"], "")   			,Nil},; //Toipo Clie.-C-01 //1 - APAE 2 - GOVERNO - 3 - ANGARIADORES - 4 - FEAPAES - 5 - CO IRMAOS  - 9 OUTROS
							{"A1_XSITUAC"   , iif(ValType(aDados[nX]["SITUACAO"]) <> "U", aDados[nX]["SITUACAO"], "")   				,Nil},; //Situacao.  -C-01 //1-DESFILIADAS - 2 FILIADAS - 3 PROCESSO D FILIACAO 4 - INDEFINIDAS - 5 - COIRMA
							{"A1_XDTATUA"   , ddatabase																			    	,Nil},; //Data inc   -C-08
							{"A1_XDTFUND"   , iif(ValType(aDados[nX]["XDTFUND"]) <> "U", CTOD(aDados[nX]["XDTFUND"]), CTOD("  /  /  ") ),Nil},; //Dt Fundacao-C-08 
							{"A1_XDTFILI"   , iif(ValType(aDados[nX]["XDTFILI"]) <> "U", CTOD(aDados[nX]["XDTFILI"]), CTOD("  /  /  ") ),Nil},; //Data Filiac-C-08 
							{"A1_XCODFIL"   , iif(ValType(aDados[nX]["NUM_FILIACAO"]) <> "U", aDados[nX]["NUM_FILIACAO"], 0)   			,Nil},; //Num Filiaca-N-06 	
							{"A1_XGRUPCO"   , iif(ValType(aDados[nX]["GRP_FILIACAO"]) <> "U", aDados[nX]["GRP_FILIACAO"], "")   		,Nil},; //Grp Filiaca-C-10 
							{"A1_XNOMPRE"   , iif(ValType(aDados[nX]["NOME_PRESID"])  <> "U", aDados[nX]["NOME_PRESID"], "")   			,Nil},; //Nome Presid-C-10 							 					 						 						 
							{"A1_XAGENC1"   , iif(ValType(aDados[nX]["AGENCIA"]) <> "U", aDados[nX]["AGENCIA"], "")   					,Nil},; //Agencia.   -C-05 	
							{"A1_XCONTA1"   , iif(ValType(aDados[nX]["BANCOCONTA"]) <> "U", aDados[nX]["BANCOCONTA"], "")   			,Nil},; //banco. 	 -C-10  
							{"A1_XSCONT1"   , iif(ValType(aDados[nX]["BANCOSUBCONTA"])  <> "U", aDados[nX]["BANCOSUBCONTA"], "")   		,Nil},; //SubConta.  -C-03 							 					 						 						 
							{"A1_LC"		, iif(ValType(aDados[nX]["LIMITE_CREDITO"]) <> "U", aDados[nX]["LIMITE_CREDITO"], 0)  		,Nil} } //Lim Cred   -N-05

			EndIf

				cJSon += '{'

//				cJson += '"CODIGO": "' + aDados[nX]["CGC"] + '",'
//				cJson += '"LOJA"  : "' + aDados[nX]["LOJA"] + '",'
//				cJson += '"NOME"  : "' + aDados[nX]["NOME"] + '"'
//				_cStrArray	:= ARRTOSTR(aCliente)
				
				// Atualiza cadastro de cliente
				If caltera //SA1->(DbSeek(xFilial("SA1")+aDados[nX]["FILIAL"]+aDados[nX]["CODIGO"]+aDados[nX]["LOJA"]))
					MSExecAuto({|x,y| Mata030(x,y)},aCliente,4) //Alteração
				Else
					MSExecAuto({|x,y| Mata030(x,y)},aCliente,3) //Inclusao
					//Break
				EndIf

				If lMsErroAuto

					cJson += '"CGC"   : "' + aDados[nX]["CGC"] + '"'
					_cStrArray	:= ARRTOSTR(aCliente)

					cMsgRet :=  " " + MostraErro("/temp","error.log")  //MostraErro("\SYSTEM\",FUNNAME() + ".LOG")
					cMsgErr := cMsgRet

					If caltera
						SetRestFault(404, "Erro ao Alterar Cliente -> "+_cStrArray+cMsgErr)
					Else
						SetRestFault(404, "Erro ao incluir Cliente -> "+_cStrArray+cMsgErr)
					EndIf

					conout("MostraErro() -> "+_cStrArray)
					conout("MostraErro() 2 -> "+cMsgErr)
					//MostraErro("/temp","error.log")

				Else
				
					cJson += '"CGC": "' + aDados[nX]["CGC"] + '"'
					_cStrArray	:= ARRTOSTR(aCliente)

					If caltera
						SetRestFault(101, "Cliente Alterado com Sucesso -> ")
					Else
						SetRestFault(100, "Cliente Incluido com Sucesso -> ")
					EndIf

					//conout("MostraErro() -> "+_cStrArray)
				EndIf

				cJSon += '}'
		
		Next nX

		cJSon += ']'
		cJSon += '}'

		lPost := .T.

		::SetResponse(cJSon)
		Recover
		lPost := .F.
	End Sequence

	RpcClearEnv()

Return(lPost)

Static Function ARRTOSTR(_aArray)
	Local cRet := ""
	Local nCount := 0
	Local _cSep		:= " | "

	FOR nCount:=1 TO Len(_aArray) Step 1
		Do Case
			Case VALTYPE(_aArray[nCount]) == 'C'
				cRet += If(nCount > 1,_cSep,"") + aArray[nCount]
			Case VALTYPE(_aArray[nCount]) == 'D'
				cRet += If(nCount > 1,_cSep,"") + dtoc(_aArray[nCount])
			Case VALTYPE(_aArray[nCount]) == 'N'
				cRet += If(nCount > 1,_cSep,"") + str(_aArray[nCount],12,2)
			Case VALTYPE(_aArray[nCount]) == 'L'
				cRet += If(nCount > 1,_cSep,"") + If(_aArray[nCount],'T','F')
		EndCase
	Next
Return cRet

/*

			A1_TIPO
			A1_PESSOA
			A1_CGC
			A1_NOME
			A1_NREDUZE
			A1_MUN
			A1_DDD
			A1_TEL
			A1_END
			A1_BAIRRO
			A1_EST
			A1_CEP
			A1_EMAIL
			A1_XTIPOCL
			A1_XSITUAC
			A1_XDTFUND
			A1_XDTFILI
			A1_XCODFIL
			A1_XNOMPRE

			aCliente := {{"A1_FILIAL"   , iif(ValType(aDados[nX]["FILIAL"]) <> "U", aDados[nX]["FILIAL"], "")   				,Nil},; //Codigo     -C-06
						 {"A1_COD"    	, iif(ValType(aDados[nX]["CODIGO"]) <> "U", aDados[nX]["CODIGO"], "")   					,Nil},; //Codigo     -C-06
						 {"A1_LOJA"   	, iif(ValType(aDados[nX]["LOJA"]) <> "U", aDados[nX]["LOJA"], "")							,Nil},; //Loja       -C-02
						 {"A1_NOME"   	, iif(ValType(aDados[nX]["NOME"]) <> "U", aDados[nX]["NOME"], "")   						,Nil},; //Nome       -C-40
						 {"A1_NREDUZ" 	, iif(ValType(aDados[nX]["NOME_FANTASIA"]) <> "U", aDados[nX]["NOME_FANTASIA"], "")   		,Nil},; //Nome Reduz.-C-20
						 {"A1_END"    	, iif(ValType(aDados[nX]["ENDERECO"]) <> "U", aDados[nX]["ENDERECO"], "")   				,Nil},; //Logradouro -C-40
						 {"A1_BAIRRO" 	, iif(ValType(aDados[nX]["BAIRRO"]) <> "U", aDados[nX]["BAIRRO"], "")   					,Nil},; //Bairro     -C-30
						 {"A1_MUN"    	, iif(ValType(aDados[nX]["MUNICIPIO"]) <> "U", aDados[nX]["MUNICIPIO"], "")   				,Nil},; //Cidade     -C-25
						 {"A1_TIPO"   	, iif(ValType(aDados[nX]["TIPO_CLIENTE"]) <> "U", aDados[nX]["TIPO_CLIENTE"], "")   		,Nil},; //Tipo = F - Cons.Final
						 {"A1_MSBLQL"	, iif(ValType(aDados[nX]["STATUS"]) <> "U", aDados[nX]["STATUS"], "")   					,Nil},; //Cod.Munic. -C-05
						 {"A1_EMAIL"  	, iif(ValType(aDados[nX]["EMAIL"]) <> "U", aDados[nX]["EMAIL"], "")   						,Nil},; //ContaCont. -C-20
						 {"A1_CGC"    	, iif(ValType(aDados[nX]["CGC"]) <> "U", aDados[nX]["CGC"], "")   							,Nil},; //CPF-CNPJ   -C-14
						 {"A1_PESSOA"  	, iif(ValType(aDados[nX]["PESSOA"]) <> "U", aDados[nX]["PESSOA"], "J")   					,Nil},; //Insc.Est.  -C-18
						 {"A1_EST"  	, iif(ValType(aDados[nX]["ESTADO"]) <> "U", aDados[nX]["ESTADO"], "")   					,Nil},; //Insc.Est.  -C-18
						 {"A1_CEP"  	, iif(ValType(aDados[nX]["CEP"]) <> "U", aDados[nX]["CEP"], "74100000")   					,Nil},; //Insc.Est.  -C-18
						 {"A1_TEL"  	, iif(ValType(aDados[nX]["TELEFONE"]) <> "U", aDados[nX]["TELEFONE"], "062")   				,Nil},; //Insc.Est.  -C-18
						 {"A1_EMAIL"  	, iif(ValType(aDados[nX]["EMAIL"]) <> "U", aDados[nX]["EMAIL"], "CONTATO@CONTATO.COM.BR")   ,Nil},; //Insc.Est.  -C-18
						 {"A1_LC"		, iif(ValType(aDados[nX]["LIMITE_CREDITO"]) <> "U", aDados[nX]["LIMITE_CREDITO"], "")  		,Nil} } //Cod.País   -C-05

			os campos que o Cleber me passou sao os que passei para o webservice



			aCliente :={{"A1_FILIAL"   	, iif(ValType(aDados[nX]["FILIAL"]) <> "U", aDados[nX]["FILIAL"], "")   		,Nil},; //Codigo     -C-06
						{"A1_COD"    	, iif(ValType(aDados[nX]["CODIGO"]) <> "U", aDados[nX]["CODIGO"], "")   				,Nil},; //Codigo     -C-06
						{"A1_LOJA"   	, iif(ValType(aDados[nX]["LOJA"]) <> "U", aDados[nX]["LOJA"], "")						,Nil},; //Loja       -C-02
						{"A1_NOME"   	, iif(ValType(aDados[nX]["NOME"]) <> "U", aDados[nX]["NOME"], "")   					,Nil},; //Nome       -C-40
						{"A1_NREDUZ" 	, iif(ValType(aDados[nX]["NOME_FANTASIA"]) <> "U", aDados[nX]["NOME_FANTASIA"], "")   	,Nil},; //Nome Reduz.-C-20
						{"A1_END"    	, iif(ValType(aDados[nX]["ENDERECO"]) <> "U", aDados[nX]["ENDERECO"], "")   			,Nil},; //Logradouro -C-40
							{"A1_BAIRRO" 	, iif(ValType(aDados[nX]["BAIRRO"]) <> "U", aDados[nX]["BAIRRO"], "")   				,Nil},; //Bairro     -C-30
							{"A1_MUN"    	, iif(ValType(aDados[nX]["MUNICIPIO"]) <> "U", aDados[nX]["MUNICIPIO"], "")   			,Nil},; //Cidade     -C-25
							{"A1_TIPO"   	, iif(ValType(aDados[nX]["TIPO_CLIENTE"]) <> "U", aDados[nX]["TIPO_CLIENTE"], "")   	,Nil},; //Tipo = F - Cons.Final
							{"A1_MSBLQL"	, iif(ValType(aDados[nX]["STATUS"]) <> "U", aDados[nX]["STATUS"], "")   				,Nil},; //Cod.Munic. -C-05
							{"A1_EMAIL"  	, iif(ValType(aDados[nX]["EMAIL"]) <> "U", aDados[nX]["EMAIL"], "")   					,Nil},; //ContaCont. -C-20
							{"A1_CGC"    	, iif(ValType(aDados[nX]["CGC"]) <> "U", aDados[nX]["CGC"], "")   						,Nil},; //CPF-CNPJ   -C-14
							{"A1_XSITUAC"   , iif(ValType(aDados[nX]["SITUACAO"]) <> "U", aDados[nX]["SITUACAO"], "")   			,Nil},; //Estado     -C-02
							{"A1_XDTATUA"  	, ddatabase																			    ,Nil},; //CEP        -C-08
							{"A1_XTEL"  	, iif(ValType(aDados[nX]["INFO_TEL"]) <> "U", aDados[nX]["INFO_TEL"], "")   			,Nil},; //Tipo       -C-01 //F Final
							{"A1_XCODFIL"  	, iif(ValType(aDados[nX]["NUM_FILIACAO"]) <> "U", aDados[nX]["NUM_FILIACAO"], "")   	,Nil},; //Telefone   -C-15
							{"A1_XGRUPCO"  	, iif(ValType(aDados[nX]["GRP_FILIACAO"]) <> "U", aDados[nX]["GRP_FILIACAO"], "")   	,Nil},; //Insc.Est. -C-18
							{"A1_PESSOA"  	, iif(ValType(aDados[nX]["PESSOA"]) <> "U", aDados[nX]["PESSOA"], "J")   				,Nil},; //Insc.Est. -C-18
							{"A1_EST"  		, iif(ValType(aDados[nX]["ESTADO"]) <> "U", aDados[nX]["ESTADO"], "")   				,Nil},; //Insc.Est. -C-18
							{"A1_CEP"  		, iif(ValType(aDados[nX]["CEP"]) <> "U", aDados[nX]["CEP"], "74100000")   				,Nil},; //Insc.Est. -C-18
							{"A1_TEL"  		, iif(ValType(aDados[nX]["TELEFONE"]) <> "U", aDados[nX]["TELEFONE"], "062")   			,Nil},; //Insc.Est. -C-18
							{"A1_EMAIL"  	, iif(ValType(aDados[nX]["EMAIL"]) <> "U", aDados[nX]["EMAIL"], "CONTATO@CONTATO.COM.BR")   ,Nil},; //Insc.Est. -C-18
							{"A1_XTIPOCL"  	, iif(ValType(aDados[nX]["TIPOCLIENTE"]) <> "U", aDados[nX]["TIPOCLIENTE"], "9")   		,Nil},; //Insc.Est. -C-18
							{"A1_LC"		, iif(ValType(aDados[nX]["LIMITE_CREDITO"]) <> "U", aDados[nX]["LIMITE_CREDITO"], "")   ,Nil} } //Cod.País   -C-05
*/

