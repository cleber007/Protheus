#include "protheus.ch"
#Include "restful.ch"
#Include 'parmtype.ch'
#include "topconn.ch"
#Include "TbiConn.ch"
#INCLUDE 'totvs.ch'

/*-------------------------------------------------------------------
Programa: UGPEE032
Autor: Andr? A. Alves
Data: 01/04/2021
Descrição: API Consultas FAT
------------------------------------------------------------------*/

/***********************/
User Function UGPEE032()
	/***********************/
Return()

WSRESTFUL dadoscli DESCRIPTION "Servico REST para consultas e inclusao de dados no ambiente TOTVS PROTHEUS" Format APPLICATION_JSON

	WSDATA desccli         AS STRING OPTIONAL
	WSDATA cnpj            AS STRING OPTIONAL
	WSDATA estado          AS STRING OPTIONAL
	WSDATA muninicipo      AS STRING OPTIONAL
	WSDATA codigo          AS STRING OPTIONAL
	WSDATA email           AS STRING OPTIONAL
	WSDATA regiao          AS STRING OPTIONAL
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

WSMETHOD GET changedemployee WSRECEIVE desccli, cnpj, estado, muninicipo, codigo, email, regiao WSSERVICE dadoscli

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
	_cquer+="  A1_DTULTIT AS ULTIMO_PROTESTO"
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
	_cquer:=changequery(_cquer)

	tcquery _cquer new alias "CLI"
	CLI->(DbGoTop())

	cJson := '{' + CRLF

	While !CLI->(EOF())

		If lPrim
			cJson   += Space(2) + '"ITENS": [' + CRLF
			cJson   += Space(4) + '{' + CRLF
			nTotCpo := 41 //CLI->(FieldCount())
			lPrim   := .F.
		Else
			cJson   += Space(4) + ',{' + CRLF
		EndIf

		For nX := 1 to nTotCpo

			cJson += Space(6)

			If nX > 1
				cJson += ','
			EndIf

			If ValType(CLI->(FieldGet(nX))) == "C"
				cJson += '"' + CLI->(FieldName(nX)) + '": "' + cValToChar(AllTrim(CLI->(FieldGet(nX)))) + '"' + CRLF
			Else
				cJson += '"' + CLI->(FieldName(nX)) + '": ' + cValToChar(CLI->(FieldGet(nX))) + CRLF
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
	Local lMsErroAuto		:= .F.
	Local _cStrArray		:= ""
	Local aTabelas      := {"SM0","SX2","SX3","SX5","SA1","SX1","SX6","SX7","SXG"}

	RPCSetType(3)
	RpcSetEnv("01", "01", NIL, NIL, "FAT", NIL, aTabelas)
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1)) // A1_FILIAL+A1_COD+A1_LOJA

	Begin Sequence

		// Define o tipo de retorno do método
		::SetContentType("application/json")

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
				{"A1_PESSOA"  	, iif(ValType(aDados[nX]["PESSOA"]) <> "U", aDados[nX]["PESSOA"], "J")   				,Nil},; //Insc.Est. -C-18
				{"A1_EST"  		, iif(ValType(aDados[nX]["ESTADO"]) <> "U", aDados[nX]["ESTADO"], "")   				,Nil},; //Insc.Est. -C-18
				{"A1_CEP"  		, iif(ValType(aDados[nX]["CEP"]) <> "U", aDados[nX]["CEP"], "74100000")   				,Nil},; //Insc.Est. -C-18
				{"A1_TEL"  		, iif(ValType(aDados[nX]["TELEFONE"]) <> "U", aDados[nX]["TELEFONE"], "062")   			,Nil},; //Insc.Est. -C-18
				{"A1_EMAIL"  	, iif(ValType(aDados[nX]["EMAIL"]) <> "U", aDados[nX]["EMAIL"], "CONTATO@CONTATO.COM.BR")   ,Nil},; //Insc.Est. -C-18
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
