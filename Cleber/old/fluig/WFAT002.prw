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
User Function WFAT002()
	/***********************/
Return()

WSRESTFUL dadoscp DESCRIPTION "Servico REST para consultas e inclusao de dados no ambiente TOTVS PROTHEUS" Format APPLICATION_JSON

	WSDATA numero          AS STRING OPTIONAL
	WSDATA codCli          AS STRING OPTIONAL

	WSMETHOD GET consultacp;
		DESCRIPTION "Consulta Contas a Pagar";
		WSSYNTAX "/consultacp";
		PATH "/consultacp"

	WSMETHOD POST incluicp;
		DESCRIPTION "Inclusao e alteração de contas a Pagar";
		WSSYNTAX "/incluicp";
		PATH "/incluicp"

END WSRESTFUL

WSMETHOD GET consultacp WSRECEIVE numero, codCli WSSERVICE dadoscp

	Local lRet
	Local nCodErr
	Local cMsgErr       := ""
	Local cJson         := ""
	Local lPrim         := .T.
	Local nTotCpo
	Local nX
	Local aTabelas      := {"SM0","SX2","SX3","SX5","SE2","SX1","SX6","SX7","SXG"}

	RPCSetType(3)
	RpcSetEnv("01", "01", nil, nil, "FAT", NIL, aTabelas)

	ccodCli    	:= ::codCli
	cnumero 	:= ::numero

	// Define o tipo de retorno
	::SetContentType("application/json")

	IF Select("SE2") <> 0
		DbSelectArea("SE2")
		DbCloseArea()
	ENDIF

	_cquer:=" SELECT E2_FILIAL AS FILIAL,"
	_cquer+="  E2_NUM AS CODIGO,"
	_cquer+="  E2_CLIENTE AS CLIENTE,"
	_cquer+="  E2_LOJA AS LOJA,"
	_cquer+="  E2_NOMCLI AS NOME_CLIENTE,"
	_cquer+="  E2_EMISSAO AS EMISSAO,"
	_cquer+="  E2_VENCTO AS VENCIMENTO,"
	_cquer+="  E2_VENCREA AS VENCIMENTO_REAL,"
	_cquer+="  E2_BAIXA AS DATA_BAIXA,"
	_cquer+="  E2_SALDO AS SALDO,"
	_cquer+="  E2_FORMPAG AS FORMPAG,"
	_cquer+="  E2_CCUSTO AS CCUSTO,"
	_cquer+="  E2_FORBCO AS FORBCO,"
	_cquer+="  E2_FORAGE AS FORAGE,"
	_cquer+="  E2_FORCTA AS FORCTA,"
	_cquer+="  E2_FCTADV AS FCTADV,"
	_cquer+="  E2_FAGEDV AS FAGEDV,"
	_cquer+="  E2_VALOR AS VALOR"
	_cquer+="  FROM "+ retsqlname("SE2")+" SE2"
	_cquer+="  WHERE SE2.D_E_L_E_T_ = ' '"
	if valtype(cnumero) <> "U"
		_cquer+="  AND E2_NUM = '"+cnumero+"'"
	Endif
	If valtype(ccodCli) <> "U"
		_cquer+="  AND E2_CLIENTE = '"+ccodCli+"'"
	Endif

	_cquer:=changequery(_cquer)
	tcquery _cquer new alias "SE2"
	SE2->(DbGoTop())

	cJson := '{' + CRLF

	While !SE2->(EOF())

		If lPrim
			cJson   += Space(2) + '"ITENS": [' + CRLF
			cJson   += Space(4) + '{' + CRLF
			nTotCpo := 41 //SE2->(FieldCount())
			lPrim   := .F.
		Else
			cJson   += Space(4) + ',{' + CRLF
		EndIf

		For nX := 1 to nTotCpo

			cJson += Space(6)

			If nX > 1
				cJson += ','
			EndIf

			If ValType(SE2->(FieldGet(nX))) == "C"
				cJson += '"' + SE2->(FieldName(nX)) + '": "' + cValToChar(AllTrim(SE2->(FieldGet(nX)))) + '"' + CRLF
			Else
				cJson += '"' + SE2->(FieldName(nX)) + '": ' + cValToChar(SE2->(FieldGet(nX))) + CRLF
			EndIf
		Next nX

		cJson += Space(4) + '}' + CRLF

		SE2->(DbSkip())
	EndDo

	SE2->(DbCloseArea())

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

WSMETHOD POST incluicp WSSERVICE dadoscp

	Local cBody             := ''
	Local oJson             as Object
	Local cJSon             as Character
	Local cRet              as Character
	Local aDados            as Array
	Local nTot              as Numeric
	Local nX                as Numeric
	Local lPost             as Logical
	Local _cStrArray		:= ""
	Local aTabelas      := {"SM0","SX2","SX3","SX5","SE2","SX1","SX6","SX7","SXG"}
	Private lMsErroAuto		:= .F.

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
		cJSon := ''
		nTot := Len(aDados)

		For nX := 1 to nTot

			If nX > 1
				cJSon += ','
			EndIf
				// { "E2_VENCREA"  , Padr(iif(ValType(aDados[nX]["E2_VENCREA"]) <> "U", aDados[nX]["E2_VENCREA"], ""),TamSx3("E2_VENCREA")[1]), NIL },;
			_EmissaoTit := iif(ValType(aDados[nX]["E2_EMISSAO"]) <> "U", aDados[nX]["E2_EMISSAO"], "")
			_VencTit	:= iif(ValType(aDados[nX]["E2_VENCTO" ]) <> "U", aDados[nX]["E2_VENCTO" ], "")
			_DtEmissao 	:= stod(substr(_EmissaoTit,7,4)+substr(_EmissaoTit,4,2)+substr(_EmissaoTit,1,2))
			_DtVenci	:= stod(substr(_VencTit,7,4)+substr(_VencTit,4,2)+substr(_VencTit,1,2))

			aArray := { { "E2_FILIAL"   , xFilial("SE2")  , NIL },;
				{ "E2_PREFIXO"  , Padr(iif(ValType(aDados[nX]["E2_PREFIXO"]) <> "U", aDados[nX]["E2_PREFIXO"], ""),TamSx3("E2_PREFIXO")[1]), NIL },;
				{ "E2_NUM"      , Padr(iif(ValType(aDados[nX]["E2_NUM"    ]) <> "U", aDados[nX]["E2_NUM"    ], ""),TamSx3("E2_NUM"    )[1]), NIL },;
				{ "E2_TIPO"     , Padr(iif(ValType(aDados[nX]["E2_TIPO"   ]) <> "U", aDados[nX]["E2_TIPO"   ], ""),TamSx3("E2_TIPO"   )[1]), NIL },;
				{ "E2_PARCELA"  , Padr(iif(ValType(aDados[nX]["E2_PARCELA"]) <> "U", aDados[nX]["E2_PARCELA"], ""),TamSx3("E2_PARCELA")[1]), NIL },;
				{ "E2_NATUREZ"  , Padr(iif(ValType(aDados[nX]["E2_NATUREZ"]) <> "U", aDados[nX]["E2_NATUREZ"], ""),TamSx3("E2_NATUREZ")[1]), NIL },;
				{ "E2_FORNECE"  , Padr(iif(ValType(aDados[nX]["E2_FORNECE"]) <> "U", aDados[nX]["E2_FORNECE"], ""),TamSx3("E2_FORNECE")[1]), NIL },;
				{ "E2_LOJA"     , Padr(iif(ValType(aDados[nX]["E2_LOJA"   ]) <> "U", aDados[nX]["E2_LOJA"   ], ""),TamSx3("E2_LOJA"   )[1]), NIL },;
				{ "E2_FORMPAG"  , Padr(iif(ValType(aDados[nX]["E2_FORMPAG"]) <> "U", aDados[nX]["E2_FORMPAG"], ""),TamSx3("E2_FORMPAG")[1]), NIL },;
				{ "E2_EMISSAO"  , _DtEmissao, NIL },;
				{ "E2_VENCTO"   , _DtVenci, NIL },;
				{ "E2_HIST"     , Padr(iif(ValType(aDados[nX]["E2_HIST"   ]) <> "U", aDados[nX]["E2_HIST"   ], ""),TamSx3("E2_HIST"   )[1]), NIL },;
				{ "E2_CCUSTO"   , Padr(iif(ValType(aDados[nX]["E2_CCUSTO" ]) <> "U", aDados[nX]["E2_CCUSTO" ], ""),TamSx3("E2_CCUSTO" )[1]), NIL },;
				{ "E2_FORBCO"   , Padr(iif(ValType(aDados[nX]["E2_FORBCO" ]) <> "U", aDados[nX]["E2_FORBCO" ], ""),TamSx3("E2_FORBCO" )[1]), NIL },;
				{ "E2_FORAGE"   , Padr(iif(ValType(aDados[nX]["E2_FORAGE" ]) <> "U", aDados[nX]["E2_FORAGE" ], ""),TamSx3("E2_FORAGE" )[1]), NIL },;
				{ "E2_FORCTA"   , Padr(iif(ValType(aDados[nX]["E2_FORCTA" ]) <> "U", aDados[nX]["E2_FORCTA" ], ""),TamSx3("E2_FORCTA" )[1]), NIL },;
				{ "E2_FCTADV"   , Padr(iif(ValType(aDados[nX]["E2_FCTADV" ]) <> "U", aDados[nX]["E2_FCTADV" ], ""),TamSx3("E2_FCTADV" )[1]), NIL },;
				{ "E2_FAGEDV"   , Padr(iif(ValType(aDados[nX]["E2_FAGEDV" ]) <> "U", aDados[nX]["E2_FAGEDV" ], ""),TamSx3("E2_FAGEDV" )[1]), NIL },;
				{ "E2_VALOR"    , iif(ValType(aDados[nX]["E2_VALOR"  ]) <> "U", aDados[nX]["E2_VALOR"  ], 0), NIL }}

			_cStrArray		:= ARRTOSTR(aArray)

			lMsErroAuto := .F.

			If !SE2->(DbSeek(xFilial("SE2")+Padr(aDados[nX]["E2_FILIAL"],TamSx3("E2_FILIAL")[1])+;
											Padr(aDados[nX]["E2_PREFIXO"],TamSx3("E2_PREFIXO")[1])+;
											Padr(aDados[nX]["E2_NUM"],TamSx3("E2_NUM")[1])+;
											Padr(aDados[nX]["E2_PARCELA"],TamSx3("E2_PARCELA")[1])+;
											Padr(aDados[nX]["E2_TIPO"],TamSx3("E2_TIPO")[1])))
				// MsExecAuto( { |x,y| FINA050(x,y)} , aArray, 3) //Inclusao
				MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)
			EndIf

			If lMsErroAuto
				SetRestFault(404, "Erro ao incluir Titulo -> "+aDados[nX]["E2_NUM"])
				conout("MostraErro() -> "+_cStrArray)
				MostraErro("/temp","error.log")
			else 
				cJSon := '{'
				cJSon += '"code": "200",'
				cJson += '"message": "Sucesso",'
				cJson += '"detailedmessage": "Contas a pagar incluido/alterado com sucesso",'
				cJSon += '"data": ['
					cJSon += '{'
					cJson += '"NUMERO": "' + aDados[nX]["E2_NUM"] + '",'
					cJson += '"PREFIXO": "' + aDados[nX]["E2_PREFIXO"] + '"'
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
