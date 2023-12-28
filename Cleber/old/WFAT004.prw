#include "protheus.ch"
#Include "restful.ch"

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

WSRESTFUL dadosfor DESCRIPTION "Servico REST para consultas e inclusao de dados no ambiente TOTVS PROTHEUS" Format APPLICATION_JSON

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
					cJson += '"' + FORNECEDOR->(FieldName(nX)) + '": "' + cValToChar(AllTrim(FORNECEDOR->(FieldGet(nX)))) + '"' + CRLF
				Else
					cJson += '"' + FORNECEDOR->(FieldName(nX)) + '": ' + cValToChar(FORNECEDOR->(FieldGet(nX))) + CRLF
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
	Local lMsErroAuto		:= .F.
	Local _cStrArray		:= ""
	Local aTabelas      := {"SM0","SX2","SX3","SX5","SA1","SX1","SX6","SX7","SXG"}

	RPCSetType(3)
	RpcSetEnv("01", "01", NIL, NIL, "FAT", NIL, aTabelas)
	DbSelectArea("SA2")
	SA1->(DbSetOrder(1)) // A1_FILIAL+A1_COD+A1_LOJA

	Begin Sequence

		// Define o tipo de retorno do método
		::SetContentType("application/json")

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
		cJson += '"detailedmessage": "Cliente alterado com sucesso",'
		cJSon += '"data": ['

		nTot := Len(aDados)

		For nX := 1 to nTot

			If nX > 1
				cJSon += ','
			EndIf

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

			cJSon += '{'
			cJson += '"CODIGO": "' + aDados[nX]["CODIGO"] + '",'
			cJson += '"LOJA": "' + aDados[nX]["LOJA"] + '",'
			cJson += '"NOME": "' + aDados[nX]["NOME"] + '"'
			_cStrArray		:= ARRTOSTR(aCliente)

			// Atualiza cadastro de cliente
			If SA1->(DbSeek(xFilial("SA1")+aDados[nX]["FILIAL"]+aDados[nX]["CODIGO"]+aDados[nX]["LOJA"]))
				MSExecAuto({|x,y| Mata030(x,y)},aCliente,4) //Alteração
			Else
				MSExecAuto({|x,y| Mata030(x,y)},aCliente,3) //Inclusao
				Break
			EndIf

			If !lMsErroAuto
				SetRestFault(404, "Erro ao incluir Cliente -> ")
				conout("MostraErro() -> "+_cStrArray)
				MostraErro("/temp","error.log")
			Endif


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
