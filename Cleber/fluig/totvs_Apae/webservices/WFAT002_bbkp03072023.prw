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
Descrição: API Consultas FAT
------------------------------------------------------------------*/

/***********************/
User Function WFAT002()
/***********************/
Return()

WSRESTFUL dadoscp DESCRIPTION "Servico REST para consultas e inclusao de dados no ambiente TOTVS PROTHEUS" Format APPLICATION_JSON

	WSDATA numero          AS STRING OPTIONAL
	WSDATA codCli          AS STRING OPTIONAL
	WSDATA cCodFor         AS STRING OPTIONAL
	WSDATA cLojaFor        AS STRING OPTIONAL

	WSMETHOD GET consultacp;
		DESCRIPTION "Consulta Contas a Pagar";
		WSSYNTAX "/consultacp";
		PATH "/consultacp"

	WSMETHOD POST incluicp;
		DESCRIPTION "Inclusao e alteração de contas a Pagar";
		WSSYNTAX "/incluicp";
		PATH "/incluicp"

	WSMETHOD GET retdebitocli;
		DESCRIPTION "Consulta Credito do Cliente";
		WSSYNTAX "/retdebitocli";
		PATH "/retdebitocli"

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
	Local nAnexo            as Numeric
	Local nA                as Numeric	
	Local nX                as Numeric
	Local lPost             as Logical
	Local _cStrArray		:= ""
	Local aTabelas      := {"SM0","SX2","SX3","SX5","SE2","SX1","SX6","SX7","SXG","SA2"}
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

			//Codigo de Barras
			cCodBar     := iif(ValType(aDados[nX]["E2_CODBAR" ]) <> "U", aDados[nX]["E2_CODBAR" ] , "")
			cCodBar     := STRTRAN(cCodBar,".","")
			cCodBar     := STRTRAN(cCodBar," ","")

			aArray := { { "E2_FILIAL"   , xFilial("SE2")  , NIL },;
						{ "E2_PREFIXO"  , Padr(iif(ValType(aDados[nX]["E2_PREFIXO"]) <> "U", aDados[nX]["E2_PREFIXO"], ""),TamSx3("E2_PREFIXO")[1])		  	, NIL },;
						{ "E2_NUM"      , Padr(iif(ValType(aDados[nX]["E2_NUM"    ]) <> "U", aDados[nX]["E2_NUM"    ], ""),TamSx3("E2_NUM"    )[1])		  	, NIL },;
						{ "E2_TIPO"     , Padr(iif(ValType(aDados[nX]["E2_TIPO"   ]) <> "U", aDados[nX]["E2_TIPO"   ], ""),TamSx3("E2_TIPO"   )[1])		  	, NIL },;
						{ "E2_PARCELA"  , Padr(iif(ValType(aDados[nX]["E2_PARCELA"]) <> "U", aDados[nX]["E2_PARCELA"], ""),TamSx3("E2_PARCELA")[1])		  	, NIL },;
						{ "E2_NATUREZ"  , Padr(iif(ValType(aDados[nX]["E2_NATUREZ"]) <> "U", aDados[nX]["E2_NATUREZ"], ""),TamSx3("E2_NATUREZ")[1])		  	, NIL },;
						{ "E2_FORNECE"  , Padr(iif(ValType(aDados[nX]["E2_FORNECE"]) <> "U", aDados[nX]["E2_FORNECE"], ""),TamSx3("E2_FORNECE")[1])		  	, NIL },;
						{ "E2_LOJA"     , Padr(iif(ValType(aDados[nX]["E2_LOJA"   ]) <> "U", aDados[nX]["E2_LOJA"   ], ""),TamSx3("E2_LOJA"   )[1])		  	, NIL },;
						{ "E2_FORMPAG"  , Padr(iif(ValType(aDados[nX]["E2_FORMPAG"]) <> "U", aDados[nX]["E2_FORMPAG"], ""),TamSx3("E2_FORMPAG")[1])		  	, NIL },;
						{ "E2_EMISSAO"  , _DtEmissao, 																																																			NIL },;
						{ "E2_VENCTO"   , _DtVenci, 																																																				NIL },;
						{ "E2_HIST"     , Padr(iif(ValType(aDados[nX]["E2_HIST"   ]) <> "U", U_RmvCEsp(aDados[nX]["E2_HIST"]) , ""),TamSx3("E2_HIST")[1]) , NIL },;
						{ "E2_CCUSTO"   , Padr(iif(ValType(aDados[nX]["E2_CCUSTO" ]) <> "U", aDados[nX]["E2_CCUSTO" ], ""),TamSx3("E2_CCUSTO" )[1])		  	, NIL },;
						{ "E2_FORBCO"   , Padr(iif(ValType(aDados[nX]["E2_FORBCO" ]) <> "U", aDados[nX]["E2_FORBCO" ], ""),TamSx3("E2_FORBCO" )[1])		  	, NIL },;
						{ "E2_FORAGE"   , Padr(iif(ValType(aDados[nX]["E2_FORAGE" ]) <> "U", aDados[nX]["E2_FORAGE" ], ""),TamSx3("E2_FORAGE" )[1])		  	, NIL },;
						{ "E2_FORCTA"   , Padr(iif(ValType(aDados[nX]["E2_FORCTA" ]) <> "U", aDados[nX]["E2_FORCTA" ], ""),TamSx3("E2_FORCTA" )[1])		  	, NIL },;
						{ "E2_FCTADV"   , Padr(iif(ValType(aDados[nX]["E2_FCTADV" ]) <> "U", aDados[nX]["E2_FCTADV" ], ""),TamSx3("E2_FCTADV" )[1])		  	, NIL },;
						{ "E2_FAGEDV"   , Padr(iif(ValType(aDados[nX]["E2_FAGEDV" ]) <> "U", aDados[nX]["E2_FAGEDV" ], ""),TamSx3("E2_FAGEDV" )[1])		  	, NIL },;
						{ "E2_VALOR"    , iif(ValType(aDados[nX]["E2_VALOR"  			]) <> "U", aDados[nX]["E2_VALOR"  ], 0)								  								, NIL },;
						{ "E2_DIRF"   	, iif(ValType(aDados[nX]["E2_DIRF" 				]) <> "U", aDados[nX]["E2_DIRF" 	], "")								  							,	NIL },;
						{ "E2_CODRET"   , iif(ValType(aDados[nX]["E2_CODRET" 			]) <> "U", aDados[nX]["E2_CODRET" ], "")								  							, NIL },;
						{ "E2_PIS"   		, iif(ValType(aDados[nX]["E2_PIS"					]) <> "U", aDados[nX]["E2_PIS"		], 0)			  						  						, NIL },;
						{ "E2_CSLL"     , iif(ValType(aDados[nX]["E2_CSLL"				]) <> "U", aDados[nX]["E2_CSLL"		], 0)			  				      	  				, NIL },;
						{ "E2_COFINS"   , iif(ValType(aDados[nX]["E2_COFINS"			]) <> "U", aDados[nX]["E2_COFINS"	], 0)		  						 								, NIL },;
			 		 	{ "E2_IRRF"   	, iif(ValType(aDados[nX]["E2_IRRF"				]) <> "U", aDados[nX]["E2_IRRF"		], 0)		  					 	  							, NIL },;						
						{ "E2_ISS"			, iif(ValType(aDados[nX]["E2_ISS"					]) <> "U", aDados[nX]["E2_ISS"		], 0) 																,	NIL }}
						//{ "E2_BASEIRF"  , iif(ValType(aDados[nX]["E2_BASEIRF"]) 	 <> "U", aDados[nX]["E2_BASEIRF"], 0)	  							  , NIL },;

			_cStrArray		:= ARRTOSTR(aArray)

			lMsErroAuto := .F.
			//CTESTE := ( aDados[nX]["E2_HIST"] )  DecodeUTF8(CTESTE, "iso8859-1") DecodeUTF8() - Gerando Erros simplesmente não converte
			//If !SE2->(DbSeek(xFilial("SE2")+Padr(aDados[nX]["E2_PREFIXO"],TamSx3("E2_PREFIXO")[1])+Padr(aDados[nX]["E2_NUM"],TamSx3("E2_NUM")[1])+Padr(aDados[nX]["E2_PARCELA"],TamSx3("E2_PARCELA")[1])+Padr(aDados[nX]["E2_TIPO"],TamSx3("E2_TIPO")[1])))
			//MsExecAuto( { |x,y| FINA050(x,y)} , aArray, 3) //Inclusao
			MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)
			//EndIf

			If lMsErroAuto				
				
				//conout("MostraErro() -> "+_cStrArray)
				//MostraErro("/temp","error.log")
				cMsgRet :=  " " + MostraErro("/temp","error.log")  //MostraErro("\SYSTEM\",FUNNAME() + ".LOG")
				cMsgErr := cMsgRet

				conout("MostraErro() -> "+_cStrArray)
				conout("ERRO Execauto: ")
				conout("MostraErro() 2 -> "+cMsgErr)
				SetRestFault(404, "Erro ao incluir Titulo -> "+aDados[nX]["E2_NUM"]+" - "+_cStrArray+cMsgErr)

			else 
				
				//Codigo de Barras
				//if !Empty(cCodBar)
				
					dbSelectArea("SE2")
					SE2->(DbGotop())
					SE2->(dbSetOrder(1))
					If SE2->(DbSeek(xFilial("SE2")+Padr(aDados[nX]["E2_PREFIXO"],TamSx3("E2_PREFIXO")[1])+PadL(aDados[nX]["E2_NUM"],TamSx3("E2_NUM")[1],"0")+Padr(aDados[nX]["E2_PARCELA"],TamSx3("E2_PARCELA")[1])+Padr(aDados[nX]["E2_TIPO"],TamSx3("E2_TIPO")[1])+Padr(aDados[nX]["E2_FORNECE"],TamSx3("E2_FORNECE")[1])+Padr(aDados[nX]["E2_LOJA"],TamSx3("E2_LOJA")[1])))
					//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA                                                                                               						
						
						_xLinDig := ""
						_xCodBar := ""
						
						if !Empty(cCodBar)
							cConteudo := cCodBar //Alltrim(aTitAtual[17])
							Conout(cConteudo)

							//Caso Seja Codigo de Barras
							If len(cConteudo) == 44
								_xLinDig  := FinCbLd(cConteudo)
								_xCodBar  := cConteudo
							Endif 
							//Caso Seja Linha Digitavel
							If len(cConteudo) <> 44
								_xLinDig := cConteudo
								_xCodBar := FinLdCb(cConteudo)
							Endif

							//Conout("titulose2")
							Conout(_xCodBar)

							RecLock("SE2", .F. )      
								SE2->E2_CODBAR  := IIF(!EMPTY(_xCodBar),_xCodBar,cConteudo)
								SE2->E2_LINDIG  := IIF(!EMPTY(_xLinDig),_xLinDig,"")
							SE2->(MsUnLock())			
							
						EndIf

						RecLock("SE2", .F. )      
							SE2->E2_FORBCO  := Padr(iif(ValType(aDados[nX]["E2_FORBCO" ]) <> "U", aDados[nX]["E2_FORBCO" ], ""),TamSx3("E2_FORBCO" )[1])
							SE2->E2_FORAGE  := Padr(iif(ValType(aDados[nX]["E2_FORAGE" ]) <> "U", aDados[nX]["E2_FORAGE" ], ""),TamSx3("E2_FORAGE" )[1])
							SE2->E2_FORCTA  := Padr(iif(ValType(aDados[nX]["E2_FORCTA" ]) <> "U", aDados[nX]["E2_FORCTA" ], ""),TamSx3("E2_FORCTA" )[1])	
							SE2->E2_FCTADV  := Padr(iif(ValType(aDados[nX]["E2_FCTADV" ]) <> "U", aDados[nX]["E2_FCTADV" ], ""),TamSx3("E2_FCTADV" )[1])
							SE2->E2_FAGEDV  := Padr(iif(ValType(aDados[nX]["E2_FAGEDV" ]) <> "U", aDados[nX]["E2_FAGEDV" ], ""),TamSx3("E2_FAGEDV" )[1])	
						SE2->(MsUnLock())	

					EndIf
				//EndIF



				//Verifica se existe anexo
				If aDados[nx]["ANEXO"] != NIL
				nAnexo := Len(aDados[nx]["ANEXO"])
				conout("Debug error nAnexo")
				conout(nAnexo)
					For nA := 1 to nAnexo
						conout("Debug error aDados[nx][ANEXO]")
						conout(aDados[nx]["ANEXO"][nA])
						If aDados[nX]["ANEXO"][nA]["docUrl"] != NIL .AND. aDados[nX]["ANEXO"][nA]["docUrl"] != ""

							DOCURL := SUBSTR(aDados[nX]["ANEXO"][nA]['docUrl'], 150, 15)
							CODOBJ 		:= zUltNum("ACB", "ACB_CODOBJ", .T.)//GetSx8Num("ACB", "ACB_CODOBJ") SUBSTR(aDados[nX]['E2_NUM'], 3, 5) + DOCURL Set Key  AC9 <-> ACB
							CODENT 		:=  aDados[nX]["ANEXO"][nA]['anexoCodEnt']

							conout("CODOBJ: ")
							conout(CODOBJ)
							cUrl := aDados[nX]["ANEXO"][nA]['docUrl']

							//Caminho
							cDiretorio := "dirdoc\co01\shared\" + CODENT + "" + DOCURL + aDados[nX]["ANEXO"][nA]['anexoExt']

							//Se o arquivo não existir, faz o download.
							If !File(cDiretorio)
								MemoWrite(cDiretorio, HttpGet(cUrl))
							EndIf
							//Inclui em ACB
							RecLock("ACB", .T.)
							DbSelectArea("ACB")
							AC9->(DbSetOrder(1))// FILIAL + CODIGO + LOJA
							AC9->(DbGoTop())
							ACB->ACB_FILIAL   := "01"
							ACB->ACB_CODOBJ		:= CODOBJ//Pega próximo código disponível
							ACB->ACB_OBJETO		:= CODENT + UPPER(DOCURL) + "" + aDados[nX]["ANEXO"][nA]['anexoExt']
							ACB->ACB_DESCRI		:= CODENT + UPPER(DOCURL)//aDados[nX]["ANEXO"][nA]['ACB_DESCRI']
							MsUnlock()

							//Inclui em AC9
							//Abre alias AC9
							DbSelectArea("AC9")
							AC9->(DbSetOrder(1))// FILIAL + CODIGO + LOJA
							AC9->(DbGoTop())
							RecLock("AC9", .T.)
							AC9->AC9_FILIAL   := "01"
							AC9->AC9_FILENT   := "0101"
							AC9->AC9_ENTIDA   := "SE2"
							AC9->AC9_CODENT		:= CODENT
							AC9->AC9_CODOBJ		:= CODOBJ //GetSx8Num("AC9", "AC9_CODOBJ")Pega próximo código disponível
							MsUnlock()
						Endif
					Next

				ElseIf !aDados[nx]["ANEXO"]
					CODOBJ := "Nenhum anexo adicionado!"
				EndIf

					cJSon := '{'
					cJSon += '"code": "200",'
					cJson += '"message": "Sucesso",'
					cJson += '"detailedmessage": "Contas a pagar incluido/alterado com sucesso",'
					cJSon += '"data": ['
						cJSon += '{'
						cJson += '"NUMERO": "' + aDados[nX]["E2_NUM"] + '",'
						cJson += '"PREFIXO": "' + aDados[nX]["E2_PREFIXO"] + '",'
						cJson += '"ANEXO":' + '"' + CODOBJ + '"'
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

//Consulta Credito Fornecedor

WSMETHOD GET retdebitocli WSRECEIVE cCodFor,cLojafor WSSERVICE dadoscp
	
	Local oResponse		:= JsonObject():New()
	Local cBodyJson		:= ""
	Local lConnect		:= .F.
	
	Conout("++++++++++++ API Consult supplierdebit ++++++++++++++++")
	
	Self:SetContentType("application/json; charset=utf-8") 
	cBodyJson := AllTrim(Self:GetContent())
	
	RpcSetType(3)
	Reset Environment
	lConnect := RpcSetEnv("01","01") 

	// se conseguiu logar na empresa
	if lConnect

			Conout("Json recebido: " + cBodyJson)
			xcodfor := Alltrim(Self:cCodFor) 
			xlojfor := Alltrim(Self:cLojafor)

			retsaldo(xcodfor,xlojfor,@oResponse)
	else
		Conout(">> Nao conectou na empresa e filial!")
		oResponse["status"] := 500
		oResponse["msg"] := "Nao conectou na empresa e filial"	
	endif
	
	Self:SetResponse(FWJsonSerialize(oResponse, .F., .F., .T.))
	FreeObj(oResponse)

Return(.T.)

Static Function retsaldo(xcodfor,xlojfor,oResponse)

	Local aArea			:= GetArea()
	Local cPulaLinha	:= chr(13)+chr(10)
	Local cQry			:= ""

	If Select("QRYTMP") > 0 ;QRYTMP->(DbCloseArea());EndIf
	
	cQry := " SELECT E1_CLIENTE,E1_LOJA,SUM(E1_SALDO) AS SALDOVENC " + cPulaLinha
	cQry += " FROM " + RetSqlName("SE1") + " SE1 " + cPulaLinha 
	cQry += " WHERE SE1.D_E_L_E_T_ <> '*'  " + cPulaLinha
	cQry += " AND   E1_CLIENTE = '"+xcodfor+"'   		  " + cPulaLinha
	cQry += " AND   E1_LOJA    = '"+xlojfor+"'            " + cPulaLinha
	cQry += " AND   E1_VENCREA < '"+DTOS(ddatabase-5)+"'  " + cPulaLinha	
	cQry += " GROUP BY E1_CLIENTE,E1_LOJA  	 	 		  " + cPulaLinha

	//cQry += " ORDER BY CT1_CONTA "

	cQry := ChangeQuery(cQry)
	TcQuery cQry New Alias "QRYTMP" // Cria uma nova area com o resultado do query   

	if QRYTMP->( !Eof() )

        oResponse["status"] 	    := 100
		oResponse["msgret"] 		:= 'OK'
        oResponse["debitcliente"] 	:= {}

		While QRYTMP->( !Eof() )
			
			    oJson := JsonObject():New()
				
                oJson["codigo"]  := QRYTMP->E1_CLIENTE
                oJson["loja"]	 := QRYTMP->E1_LOJA
                oJson["saldo"]	 := QRYTMP->SALDOVENC

                aadd(oResponse["debitcliente"] , oJson)
                        
                FreeObj(oJson)
			
			QRYTMP->( DbSkip() )
		EndDo
	Else
		oResponse["status"] := 501
		oResponse["msgret"] := 'Nao Existe Debitos para esse cliente!'
	Endif

	RestArea(aArea)

	If Select("QRYTMP") > 0 ;QRYTMP->(DbCloseArea());EndIf

Return()


//Retorna ultimo valor de uma table
static Function zUltNum(cTab, cCampo, lSoma1)
    Local aArea       := GetArea()
    Local cCodFull    := ""
    Local cCodAux     := ""
    Local cQuery      := ""
    Local nTamCampo   := 0
    Default lSoma1    := .T.
      
    //Definindo o código atual
    nTamCampo := TamSX3(cCampo)[01]
    cCodAux   := StrTran(cCodAux, ' ', '0')
      
    //Faço a consulta para pegar as informações
    cQuery := " SELECT "
    cQuery += "   ISNULL(MAX("+cCampo+"), '"+cCodAux+"') AS MAXIMO "
    cQuery += " FROM "
    cQuery += "   "+RetSQLName(cTab)+" TAB "
    cQuery := ChangeQuery(cQuery)
    TCQuery cQuery New Alias "QRY_TAB"
      
    //Se não tiver em branco
    If !Empty(QRY_TAB->MAXIMO)
        cCodAux := QRY_TAB->MAXIMO
    EndIf
      
    //Se for para atualizar, soma 1 na variável
    If lSoma1
        cCodAux := Soma1(cCodAux)
    EndIf
      
    //Definindo o código de retorno
    cCodFull := cCodAux
      
    QRY_TAB->(DbCloseArea())
    RestArea(aArea)
Return cCodFull

