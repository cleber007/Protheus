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
Programa: WFAT004
Autor: Andre A. Alves
Data: 01/04/2021
Descrição: API Consultas e inclusão de Fornecedores
------------------------------------------------------------------*/

/***********************/
User Function UGPEE033()
/***********************/
Return()

WSRESTFUL dadosfor DESCRIPTION "Servico REST para consultas e inclusao de dados de fornecedor no ambiente TOTVS PROTHEUS" Format APPLICATION_JSON

	WSDATA datainicio       AS STRING
	WSDATA datafim          AS STRING
	WSDATA page             AS INTEGER OPTIONAL
	WSDATA pagesize         AS INTEGER OPTIONAL

	WSMETHOD GET changedemployef;
		DESCRIPTION "Consulta Fornecedores";
		WSSYNTAX "/changedemployef";
		PATH "/changedemployef"

	WSMETHOD POST includesemployfornece;
		DESCRIPTION "Inclusao e alteração de fornecedores";
		WSSYNTAX "/includesemployfornece";
		PATH "/includesemployfornece"

END WSRESTFUL

WSMETHOD GET changedemployef WSRECEIVE datainicio, datafim, page, pagesize WSSERVICE dadosfor

	Local dDtaIni       := CToD("")
	Local dDtaFim       := CToD("")
	Local nPag
	Local nTamPag
	Local lRet
	Local nCodErr
	Local cMsgErr       := ""
	Local nIni
	Local cJson         := ""
	Local lPrim         := .T.
	Local nTotCpo
	Local nX
	Local aTabelas      := {"SM0","SX2","SX3","SX5","SA2","SX1","SX6","SX7","SXG"}
    
	RPCSetType(3)
	RpcSetEnv("01", "01", nil, nil, "FAT", NIL, aTabelas)

	Default ::page      := 1
	Default ::pagesize  := 100

	// If Empty(::datainicio) .Or. Empty(::datafim)
	// 	SetRestFault(400/*nCode*/,EncodeUTF8("Parametros: datainicio e datafim sao obrigatorios.")/*cMessage*/,.T./*lJson*/,/*nStatus*/,/*cDetailMsg*/,/*cHelpUrl*/,/*aDetails*/)
	// 	lRet := .F.
	// Else
	// Recebe Parametros

	dDtaIni := ::datainicio
	dDtaFim := ::datafim
	nPag    := ::page
	nTamPag := ::pagesize
	cStatus := "1"

	// Define o tipo de retorno
	::SetContentType("application/json")

	Begin Sequence

		// Trata paginação
		If nPag == 0
			nPag := 1
		EndIf

		If nTamPag == 0
			nTamPag := 10
		EndIf

		// Cálcula o número inicial da página
		nIni := (nTamPag * (nPag - 1))

		// Consulta funcionários modificados

		BeginSQL Alias "FORNECEDOR"
			select
				SA2.A2_EST AS ESTADO,
				SA2.A2_NOME AS NOME,
				SA2.A2_CGC AS CNPJ,
				SA2.A2_EMAIL AS EMAIL,
				SA2.A2_DDD AS DDD,
				SA2.A2_TEL AS TELEFONE,
				SA2.A2_CEP AS CEP,
				SA2.A2_END AS ENDERECO,
				SA2.A2_BAIRRO AS BAIRRO,
				SA2.A2_MUN AS MUNICIPIO,
				SA2.A2_NREDUZ AS NOME_FANTASIA
			from
				%Table:SA2% SA2
			where
				SA2.%notDel%
				and SA2.A2_MSBLQL <> %Exp:cStatus% // and SA1.A1_XDTALTE between %Exp:dDtaIni% and %Exp:dDtaFim%
			order by
				SA2.A2_FILIAL,
				SA2.A2_NOME offset %Exp:nIni% rows fetch next %Exp:nTamPag% rows only
		EndSQL

		aLastQry := GetLastQuery()

		cJson := '{' + CRLF

		While !FORNECEDOR->(EOF())

			If lPrim
				cJson   += Space(2) + '"ITENS": [' + CRLF
				cJson   += Space(4) + '{' + CRLF
				nTotCpo := 11 //CLIENTE->(FieldCount())
				lPrim   := .F.
			Else
				cJson   += Space(4) + ',{' + CRLF
			EndIf

			For nX := 1 to nTotCpo

				cJson += Space(6)

				If nX > 1
					cJson += ','
				EndIf

				If ValType(FORNECEDOR->(FieldGet(nX))) == "C"
					cJson += '"' + FORNECEDOR->(FieldName(nX)) + '": "' + EncodeUTF8( cValToChar(AllTrim(FORNECEDOR->(FieldGet(nX)))) ) + '"' + CRLF
				Else
					cJson += '"' + FORNECEDOR->(FieldName(nX)) + '": '  + EncodeUTF8( cValToChar(FORNECEDOR->(FieldGet(nX))) ) + CRLF
				EndIf
			Next nX

			cJson += Space(4) + '}' + CRLF

			FORNECEDOR->(DbSkip())
		EndDo

		FORNECEDOR->(DbCloseArea())

		If lPrim
			nCodErr := 400
			cMsgErr := EncodeUTF8("Dados não encontrados")
			Break
		Else
			cJson += Space(2) + '],' + CRLF
		EndIf

		// verifica se existe proxima pagina
		nIni := nTamPag * nPag

		BeginSQL Alias "FORNECEDOR"
			select
				SA2.A2_EST AS ESTADO,
				SA2.A2_NOME AS NOME,
				SA2.A2_CGC AS CNPJ,
				SA2.A2_EMAIL AS EMAIL,
				SA2.A2_DDD AS DDD,
				SA2.A2_TEL AS TELEFONE,
				SA2.A2_CEP AS CEP,
				SA2.A2_END AS ENDERECO,
				SA2.A2_BAIRRO AS BAIRRO,
				SA2.A2_MUN AS MUNICIPIO,
				SA2.A2_NREDUZ AS NOME_FANTASIA
			from
				%Table:SA2% SA2
			where
				SA2.%notDel%
				and SA2.A2_MSBLQL <> %Exp:cStatus% // and SA2.A2_XDTALTE between %Exp:dDtaIni% and %Exp:dDtaFim%
			order by
				SA2.A2_FILIAL,
				SA2.A2_NOME offset %Exp:nIni% rows fetch next 1 rows only
		EndSQL

		aLastQry := GetLastQuery()

		If FORNECEDOR->(EOF())
			cJSon += Space(2) + '"HASNEXT": false'
		Else
			cJSon += Space(2) + '"HASNEXT": true'
		EndIf

		FORNECEDOR->(dbCloseArea())

		cJson += '}' + CRLF

		::SetResponse(cJson)
		lRet := .T.

		Recover
		SetRestFault(nCodErr, cMsgErr)
		lRet := .F.
	End Sequence
	// EndIf
	RpcClearEnv()
Return(lRet)

WSMETHOD POST includesemployfornece WSSERVICE dadosfor

	Local cBody             := ''
	Local oJson             as Object
	Local cJSon             as Character
	Local cRet              as Character
	Local aDados            as Array
	Local nTot              as Numeric
	Local nX                as Numeric
	Local lPost             as Logical
	Local _cStrArray		:= ""
	Local aTabelas      	:= {"SM0","SX2","SX3","SX5","SA1","SX1","SX6","SX7","SXG"}

	Private lMsErroAuto		:= .F.

	RPCSetType(3)
	RpcSetEnv("01", "01", NIL, NIL, "FAT", NIL, aTabelas)
	
	DbSelectArea("SA2")
	SA2->(DbSetOrder(1)) // A1_FILIAL+A1_COD+A1_LOJA

	Begin Sequence

		// Define o tipo de retorno do método
		Self:SetContentType("application/json; charset=utf-8") 
		//::SetContentType("application/json")
		// Recupera o body da requisicao
		cBody := ::GetContent()
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
		cJson += '"detailedmessage": "Chamada Inclusao/Ateracao Fornecedor realizada com sucesso",'
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

			dbSelectArea("SA2")
			SA2->(dbGoTop())		
			SA2->(dbSetOrder(3))  
			If SA2->(dbSeek(xFilial("SA2") + CCNPJ ) )

				caltera := .T.
				cinclui := .F.

				aFornece := {{"A2_FILIAL"   , SA2->A2_FILIAL														    				,Nil},; //filial     -C-06
							{"A2_COD"   	, SA2->A2_COD     																			,Nil},; //codigo       -C-40
							{"A2_LOJA"   	, SA2->A2_LOJA    																			,Nil},; //loja       -C-40
							{"A2_NOME"   	, iif(ValType(aDados[nX]["NOME"]) <> "U", aDados[nX]["NOME"], "")   						,Nil},; //Nome       -C-40
							{"A2_NREDUZ" 	, iif(ValType(aDados[nX]["NOME_FANTASIA"]) <> "U", aDados[nX]["NOME_FANTASIA"], "")   		,Nil},; //Nome Reduz.-C-20
							{"A2_END"    	, iif(ValType(aDados[nX]["ENDERECO"]) <> "U", aDados[nX]["ENDERECO"], "")   				,Nil},; //ENDERECO 	 -C-40
							{"A2_BAIRRO" 	, iif(ValType(aDados[nX]["BAIRRO"]) <> "U", aDados[nX]["BAIRRO"], "")   					,Nil},; //Bairro     -C-30
							{"A2_EST"  		, iif(ValType(aDados[nX]["ESTADO"]) <> "U", aDados[nX]["ESTADO"], "")   					,Nil},; //ESTADO.    -C-18
							{"A2_COD_MUN"  	, cCodMun   																				,Nil},; //CODMUN.    -C-18
							{"A2_CEP"  		, iif(ValType(aDados[nX]["CEP"]) <> "U", aDados[nX]["CEP"], "74100000")   					,Nil},; //CEP.       -C-18 A1_COD_MUN
							{"A2_MUN"    	, iif(ValType(aDados[nX]["MUNICIPIO"]) <> "U", aDados[nX]["MUNICIPIO"], "")   				,Nil},; //MUNCIPIO   -C-25
							{"A2_COMPLEM"   , iif(ValType(aDados[nX]["COMPLEMENTO"]) <> "U", aDados[nX]["COMPLEMENTO"], "")   			,Nil},; //COMPLEMENTO-C-25
							{"A2_DDD"    	, iif(ValType(aDados[nX]["DDD"]) <> "U", aDados[nX]["DDD"], "062")   						,Nil},; //DDD        -C-25
							{"A2_TEL"  		, iif(ValType(aDados[nX]["TELEFONE"]) <> "U", aDados[nX]["TELEFONE"], " ")   				,Nil},; //Insc.Est.  -C-18
							{"A2_MSBLQL"	, iif(ValType(aDados[nX]["STATUS"])  <> "U", aDados[nX]["STATUS"], "2")   					,Nil},; //Cod.Munic. -C-05
							{"A2_EMAIL"  	, iif(ValType(aDados[nX]["EMAIL"]) <> "U", aDados[nX]["EMAIL"], "")   						,Nil},; //Email. 	 -C-20
							{"A2_XTIPFOR"   , iif(ValType(aDados[nX]["TIPOFORNECEDOR"]) <> "U", aDados[nX]["TIPOFORNECEDOR"], "")   	,Nil},; //Tp Fornec. -C-01 //1 - PROMOBEM 2 - GOVERNO - 3 - ANGARIADORES - 4 - FEAPAES - 5 - CO IRMAOS  - 9 OUTROS
							{"A2_TIPCTA"    , iif(ValType(aDados[nX]["TIPOCONTABANCO"]) <> "U", aDados[nX]["TIPOCONTABANCO"], "1")		,Nil},; //Tp Conta B -C-01 (1-Conta Corrente 2-Conta Poupança)
							{"A2_BANCO"     , iif(ValType(aDados[nX]["BANCO"]) <> "U", aDados[nX]["BANCO"], "")   						,Nil},; //Banco.	 -C-03 //NUMERICO	
							{"A2_AGENCIA"   , iif(ValType(aDados[nX]["AGENCIA"]) <> "U", aDados[nX]["AGENCIA"], "")  			 		,Nil},; //Insc.Est.  -C-18  //GRUPO FILIAÇÃO
							{"A2_DVAGE" 	, iif(ValType(aDados[nX]["DIGAGENCIA"])  <> "U", aDados[nX]["DIGAGENCIA"], "")   			,Nil},; //DV AGENC.  -C-20 //NOME PRESIDENTE							 					 						 						 
							{"A2_NUMCON" 	, iif(ValType(aDados[nX]["NUMEROCONTA"])  <> "U", aDados[nX]["NUMEROCONTA"], "")   			,Nil},; //DV AGENC.  -C-20 //NOME PRESIDENTE							 					 						 						 
							{"A2_DVCTA" 	, iif(ValType(aDados[nX]["DIGCONTA"])  <> "U", aDados[nX]["DIGCONTA"], "")   				,Nil}}  //DIG CONTA. -C-20 //NOME PRESIDENTE							 					 						 						 							


			Else

				cinclui := .T.
				caltera := .F.
				
				aFornece := {{"A2_FILIAL"   , iif(ValType(aDados[nX]["FILIAL"]) <> "U", aDados[nX]["FILIAL"], "0101")   				,Nil},; //Codigo     -C-06
							{"A2_TIPO"   	, cPessoa   																			    ,Nil},; //Tipo = F - Cons.Final			
							{"A2_CGC"    	, iif(ValType(aDados[nX]["CGC"]) <> "U", aDados[nX]["CGC"], "")   							,Nil},; //CPF-CNPJ   -C-14						 				 
							{"A2_NOME"   	, iif(ValType(aDados[nX]["NOME"]) <> "U", aDados[nX]["NOME"], "")   						,Nil},; //Nome       -C-40
							{"A2_NREDUZ" 	, iif(ValType(aDados[nX]["NOME_FANTASIA"]) <> "U", aDados[nX]["NOME_FANTASIA"], "")   		,Nil},; //Nome Reduz.-C-20
							{"A2_END"    	, iif(ValType(aDados[nX]["ENDERECO"]) <> "U", aDados[nX]["ENDERECO"], "")   				,Nil},; //ENDERECO 	 -C-40
							{"A2_BAIRRO" 	, iif(ValType(aDados[nX]["BAIRRO"]) <> "U", aDados[nX]["BAIRRO"], "")   					,Nil},; //Bairro     -C-30
							{"A2_EST"  		, iif(ValType(aDados[nX]["ESTADO"]) <> "U", aDados[nX]["ESTADO"], "")   					,Nil},; //ESTADO.    -C-18
							{"A2_COD_MUN"  	, cCodMun   																				,Nil},; //CODMUN.    -C-18
							{"A2_CEP"  		, iif(ValType(aDados[nX]["CEP"]) <> "U", aDados[nX]["CEP"], "74100000")   					,Nil},; //CEP.       -C-18 A1_COD_MUN
							{"A2_MUN"    	, iif(ValType(aDados[nX]["MUNICIPIO"]) <> "U", aDados[nX]["MUNICIPIO"], "")   				,Nil},; //MUNCIPIO   -C-25
							{"A2_COMPLEM"   , iif(ValType(aDados[nX]["COMPLEMENTO"]) <> "U", aDados[nX]["COMPLEMENTO"], "")   			,Nil},; //COMPLEMENTO-C-25
							{"A2_DDD"    	, iif(ValType(aDados[nX]["DDD"]) <> "U", aDados[nX]["DDD"], "062")   						,Nil},; //DDD        -C-25
							{"A2_TEL"  		, iif(ValType(aDados[nX]["TELEFONE"]) <> "U", aDados[nX]["TELEFONE"], " ")   				,Nil},; //Insc.Est.  -C-18
							{"A2_MSBLQL"	, iif(ValType(aDados[nX]["STATUS"])  <> "U", aDados[nX]["STATUS"], "2")   					,Nil},; //Cod.Munic. -C-05
							{"A2_EMAIL"  	, iif(ValType(aDados[nX]["EMAIL"]) <> "U", aDados[nX]["EMAIL"], "")   						,Nil},; //Email. 	 -C-20
							{"A2_XTIPFOR"   , iif(ValType(aDados[nX]["TIPOFORNECEDOR"]) <> "U", aDados[nX]["TIPOFORNECEDOR"], "")   	,Nil},; //Tp Fornec. -C-01 //1 - PROMOBEM 2 - GOVERNO - 3 - ANGARIADORES - 4 - FEAPAES - 5 - CO IRMAOS  - 9 OUTROS
							{"A2_TIPCTA"    , iif(ValType(aDados[nX]["TIPOCONTABANCO"]) <> "U", aDados[nX]["TIPOCONTABANCO"], "1")		,Nil},; //Tp Conta B -C-01 (1-Conta Corrente 2-Conta Poupança)
							{"A2_BANCO"     , iif(ValType(aDados[nX]["BANCO"]) <> "U", aDados[nX]["BANCO"], "")   						,Nil},; //Banco.	 -C-03 //NUMERICO	
							{"A2_AGENCIA"   , iif(ValType(aDados[nX]["AGENCIA"]) <> "U", aDados[nX]["AGENCIA"], "")  			 		,Nil},; //Insc.Est.  -C-18  //GRUPO FILIAÇÃO
							{"A2_DVAGE" 	, iif(ValType(aDados[nX]["DIGAGENCIA"])  <> "U", aDados[nX]["DIGAGENCIA"], "")   			,Nil},; //DV AGENC.  -C-20 //NOME PRESIDENTE							 					 						 						 
							{"A2_NUMCON" 	, iif(ValType(aDados[nX]["NUMEROCONTA"])  <> "U", aDados[nX]["NUMEROCONTA"], "")   			,Nil},; //DV AGENC.  -C-20 //NOME PRESIDENTE							 					 						 						 
							{"A2_DVCTA" 	, iif(ValType(aDados[nX]["DIGCONTA"])  <> "U", aDados[nX]["DIGCONTA"], "")   				,Nil}}  //DIG CONTA. -C-20 //NOME PRESIDENTE							 					 						 						 							

			EndIf

			cJSon += '{'
			//cJson += '"CODIGO": "' + aDados[nX]["CODIGO"] + '",'
			//cJson += '"LOJA": "' + aDados[nX]["LOJA"] + '",'
			//cJson += '"NOME": "' + aDados[nX]["NOME"] + '"'
			//_cStrArray		:= ARRTOSTR(aFornece)

			// Atualiza cadastro de cliente
			If caltera //If SA1->(DbSeek(xFilial("SA1")+aDados[nX]["FILIAL"]+aDados[nX]["CODIGO"]+aDados[nX]["LOJA"]))
				MSExecAuto({|x,y| Mata020(x,y)},aFornece,4) //Alteração
			Else
				MSExecAuto({|x,y| Mata020(x,y)},aFornece,3) //Inclusao
				//Break
			EndIf

			If lMsErroAuto
				
				//SetRestFault(404, "Erro ao incluir Cliente -> ")
				//conout("MostraErro() -> "+_cStrArray)
				//MostraErro("/temp","error.log")

					cJson += '"CGC"   : "' + aDados[nX]["CGC"] + '"'
					_cStrArray	:= ARRTOSTR(aFornece)

					cMsgRet :=  " " + MostraErro("/temp","error.log")  //MostraErro("\SYSTEM\",FUNNAME() + ".LOG")
					cMsgErr := cMsgRet

					If caltera
						SetRestFault(404, "Erro ao Alterar Fornecedor -> "+_cStrArray+cMsgErr)
					Else
						SetRestFault(404, "Erro ao incluir Fornecedor -> "+_cStrArray+cMsgErr)
					EndIf

					conout("MostraErro() -> "+_cStrArray)
					conout("MostraErro() 2 -> "+cMsgErr)

			Else
				
					cJson += '"CGC": "' + aDados[nX]["CGC"] + '"'
					_cStrArray	:= ARRTOSTR(aFornece)

					If caltera
						SetRestFault(101, "Fornecedor Alterado com Sucesso -> ")
					Else
						SetRestFault(100, "Fornecedor Incluido com Sucesso -> ")
					EndIf

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
