#include "protheus.ch"
#Include "restful.ch"
#Include 'parmtype.ch'
#include "topconn.ch"
#Include "TbiConn.ch"
#INCLUDE 'totvs.ch'

/*-------------------------------------------------------------------
Programa: UGPEE032
Autor: Andre A. Alves
Data: 01/04/2021
Descri��o: API Consultas FAT
------------------------------------------------------------------*/

/***********************/
User Function WFAT003()
/***********************/
Return()

WSRESTFUL dadoscr DESCRIPTION "Servico REST para consultas e inclusao de dados no ambiente TOTVS PROTHEUS" Format APPLICATION_JSON

	WSDATA numero          AS STRING OPTIONAL
	WSDATA codCli          AS STRING OPTIONAL
	WSDATA cCodFor         AS STRING OPTIONAL
	WSDATA cLojaFor        AS STRING OPTIONAL

	WSMETHOD GET consultacp;
		DESCRIPTION "Consulta Contas a Receber";
		WSSYNTAX "/consultacr";
		PATH "/consultacr"

	WSMETHOD POST incluicr;
		DESCRIPTION "Inclusao e altera��o de contas a Pagar";
		WSSYNTAX "/incluicr";
		PATH "/incluicr"

END WSRESTFUL

WSMETHOD GET consultacr WSRECEIVE numero, codCli WSSERVICE dadoscr

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
	_cquer+="  E2_VALOR  AS VALOR, "
	_cquer+="  E2_CODBAR AS CODBAR "
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
		cMsgErr := EncodeUTF8("Dados n�o encontrados")
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

WSMETHOD POST incluicr WSSERVICE dadoscr

	Local cBody             := ''
	Local oJson             as Object
	Local cJSon             as Character
	Local cRet              as Character
	Local aDados            as Array
	Local nTot              as Numeric
	Local nX                as Numeric
	Local lPost             as Logical
	Local _cStrArray		:= ""
	Local aTabelas      := {"SM0","SX2","SX3","SX5","SE2","SX1","SX6","SX7","SXG","SA2"}
	Private lMsErroAuto		:= .F.

	RPCSetType(3)
	RpcSetEnv("01", "01", NIL, NIL, "FAT", NIL, aTabelas)
	
	DbSelectArea("SA2")
	SA2->(DbSetOrder(1)) // A1_FILIAL+A1_COD+A1_LOJA

	Begin Sequence

		// Define o tipo de retorno do m�todo
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
			_EmissaoTit := iif(ValType(aDados[nX]["E1_EMISSAO"]) <> "U", aDados[nX]["E1_EMISSAO"], "")
			_VencTit	:= iif(ValType(aDados[nX]["E1_VENCTO" ]) <> "U", aDados[nX]["E1_VENCTO" ], "")
			_DtEmissao 	:= stod(substr(_EmissaoTit,7,4)+substr(_EmissaoTit,4,2)+substr(_EmissaoTit,1,2))
			_DtVenci	:= stod(substr(_VencTit,7,4)+substr(_VencTit,4,2)+substr(_VencTit,1,2))
			// _cNum 		:= GetSxeNum("SE1","E1_NUM")
			//Codigo de Barras
			cCodBar     := iif(ValType(aDados[nX]["E1_CODBAR" ]) <> "U", aDados[nX]["E1_CODBAR" ] , "")
			cCodBar     := STRTRAN(cCodBar,".","")
			cCodBar     := STRTRAN(cCodBar," ","")

			aArray := { { "E1_FILIAL"   , xFilial("SE2")  , NIL },;
						{ "E1_PREFIXO"  , Padr(iif(ValType(aDados[nX]["E1_PREFIXO"]) <> "U", aDados[nX]["E1_PREFIXO"], ""),TamSx3("E1_PREFIXO")[1])		  , NIL },;
						{ "E1_NUM"      , Padr(iif(ValType(aDados[nX]["E1_NUM"    ]) <> "U", aDados[nX]["E1_NUM"    ], ""),TamSx3("E1_NUM"    )[1])		  , NIL },;
						{ "E1_TIPO"     , Padr(iif(ValType(aDados[nX]["E1_TIPO"   ]) <> "U", aDados[nX]["E1_TIPO"   ], ""),TamSx3("E1_TIPO"   )[1])		  , NIL },;
						{ "E1_PARCELA"  , Padr(iif(ValType(aDados[nX]["E1_PARCELA"]) <> "U", aDados[nX]["E1_PARCELA"], ""),TamSx3("E1_PARCELA")[1])		  , NIL },;
						{ "E1_NATUREZ"  , Padr(iif(ValType(aDados[nX]["E1_NATUREZ"]) <> "U", aDados[nX]["E1_NATUREZ"], ""),TamSx3("E1_NATUREZ")[1])		  , NIL },;
						{ "E1_CLIENTE"  , Padr(iif(ValType(aDados[nX]["E1_CLIENTE"]) <> "U", aDados[nX]["E1_CLIENTE"], ""),TamSx3("E1_CLIENTE")[1])		  , NIL },;
						{ "E1_LOJA"     , Padr(iif(ValType(aDados[nX]["E1_LOJA"   ]) <> "U", aDados[nX]["E1_LOJA"   ], ""),TamSx3("E1_LOJA"   )[1])		  , NIL },;
						{ "E1_VALOR"    , iif(ValType(aDados[nX]["E1_VALOR"  ]) 	 <> "U", aDados[nX]["E1_VALOR"  ], 0)								  , NIL },;
						{ "E1_EMISSAO"  , _DtEmissao, NIL },;
						{ "E1_VENCTO"   , _DtVenci, NIL },;
						{ "E1_CCUSTO"   , Padr(iif(ValType(aDados[nX]["E1_CCUSTO" ]) <> "U", aDados[nX]["E1_CCUSTO" ], ""),TamSx3("E1_CCUSTO" )[1])		  , NIL },;
						{ "E1_HIST"     , Padr(iif(ValType(aDados[nX]["E1_HIST"   ]) <> "U", U_RmvCEsp(aDados[nX]["E1_HIST"]) , ""),TamSx3("E1_HIST")[1]) , NIL }}
			_cStrArray		:= ARRTOSTR(aArray)

            lMsErroAuto := .F.
            MsExecAuto( { |x,y| FINA040(x,y)} , aArray, 3)

			If lMsErroAuto				
				cMsgRet :=  " " + MostraErro("/temp","error.log")  //MostraErro("\SYSTEM\",FUNNAME() + ".LOG")
				cMsgErr := cMsgRet

				conout("MostraErro() -> "+_cStrArray)
				conout("ERRO Execauto: ")
				conout("MostraErro() 2 -> "+cMsgErr)
				SetRestFault(404, "Erro ao incluir Titulo -> "+aDados[nX]["E1_NUM"]+" - "+_cStrArray+cMsgErr)

			else 
				cJSon := '{'
				cJSon += '"code": "200",'
				cJson += '"message": "Sucesso",'
				cJson += '"detailedmessage": "Contas a receber incluido/alterado com sucesso",'
				cJSon += '"data": ['
					cJSon += '{'
					cJson += '"NUMERO": "' + aDados[nX]["E1_NUM"] + '",'
					cJson += '"PREFIXO": "' + aDados[nX]["E1_PREFIXO"] + '"'
			
				ConOut( "Titulo incluido com sucesso!  -> " + aDados[nX]["E1_NUM"] )
                lMsErroAuto := .F.
                aBaixa  := {{"E1_FILIAL" ,xFilial("SE1")        ,Nil },;
                    {"E1_PREFIXO"   ,Padr(iif(ValType(aDados[nX]["E1_PREFIXO"]) <> "U", aDados[nX]["E1_PREFIXO"], ""),TamSx3("E1_PREFIXO")[1])  ,Nil },;
                    { "E1_NUM"      ,Padr(iif(ValType(aDados[nX]["E1_NUM"    ]) <> "U", aDados[nX]["E1_NUM"    ], ""),TamSx3("E1_NUM"    )[1])  , NIL },;
                    {"E1_PARCELA"   ,Padr(iif(ValType(aDados[nX]["E1_PARCELA"]) <> "U", aDados[nX]["E1_PARCELA"], ""),TamSx3("E1_PARCELA")[1])  ,Nil },;
                    {"E1_TIPO"	    ,Padr(iif(ValType(aDados[nX]["E1_TIPO"   ]) <> "U", aDados[nX]["E1_TIPO"   ], ""),TamSx3("E1_TIPO"   )[1])  ,Nil },;
                    {"AUTMOTBX"	    ,"NOR"                      ,Nil },;
                    {"AUTDTBAIXA"   ,dDataBase                  ,Nil },;
                    {"AUTDTCREDITO" ,dDataBase                  ,Nil },;
                    {"AUTHIST"	    ,"BAIXA"             		,Nil },;
                    {"AUTVALREC"    ,iif(ValType(aDados[nX]["E1_VALOR"  ]) 	 <> "U", aDados[nX]["E1_VALOR"  ], 0)   ,Nil }}

                MSExecAuto({|x| FINA070(x)},aBaixa)
			Endif

			cJSon += '}'
			ConfirmSX8()
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

