#INCLUDE "RWMAKE.CH"
#include "protheus.ch"
#INCLUDE "TOPCONN.CH"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออออออหอออออออัอออออออออออออออออออหออออออัออออออออออปฑฑ
//ฑฑบPrograma  ณ ConsNFeChave บ Autor ณ Cirilo Rocha   	 บ Data ณ 21/03/12 บฑฑ
//ฑฑฬออออออออออุออออออออออออออสอออออออฯอออออออออออออออออออสออออออฯออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao para validar a chave da NFe e' valida junto a sefaz บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุอออออออออออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบ   DATA   ณ Programador   ณ Manutencao Efetuada                        บฑฑ
//ฑฑฬออออออออออุอออออออออออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบ 18/04/12 ณ Cirilo Rocha  ณ Feito tratamento para o retorno 200, quandoบฑฑ
//ฑฑบ          ณ               ณ o WS nao consegue consultar a chave.       บฑฑ
//ฑฑบ          ณ               ณ Ocorre muito com a Sefaz CE.               บฑฑ
//ฑฑบ 27/04/12 ณ Cirilo Rocha  ณ Adicionado codigo 410 para tambem ignorar  บฑฑ
//ฑฑบ          ณ               ณ                                            บฑฑ
//ฑฑบ          ณ               ณ                                            บฑฑ
//ฑฑบ          ณ               ณ                                            บฑฑ
//ฑฑศออออออออออฯอออออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function CXConsChvNfe(cChvNfe)

	Local lRetorno	:= NIL

	MsgRun("Consultando Chave do Documento na Sefaz. Aguarde...","Consultando Chave do Documento",{|| lRetorno	:= ConsChvNfe(cChvNfe) })

Return lRetorno

//----------------------------------------------------------------------------
Static Function ConsChvNfe(cChvNfe)

	Local oWS
	Local cURL     := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cMensagem:= ""
	Local cIdEnt	:= ""
	Local lRetorno	:= Nil
	Local cCodIgn	:= AllTrim(GetNewPar('MS_CDERTSS','200/410'))

//Se o servico do TSS esta configurado para consultar
	//If StaticCall(SPEDNFE,IsReady)
		cIdEnt := RetIdEnti() //StaticCall(SPEDNFE,GetIdEnt)
		If !Empty(cIdEnt)
			oWs				:= WsNFeSBra():New()
			oWs:cUserToken := "TOTVS"
			oWs:cID_ENT    := cIdEnt
			ows:cCHVNFE		:= cChvNfe
			oWs:_URL       := AllTrim(cURL)+"/NFeSBRA.apw"

			If oWs:ConsultaChaveNFE()
				If oWs:oWsConsultaChaveNfeResult:cCodRetNfe $ cCodIgn //Falha ao acessar o webservice
					ApMsgAlert('CXConsChvNfe-001: Falha ao consultar a chave da NFe, a chave nใo serแ validada junto a Sefaz.'+CRLF+;
						'Erro: '+oWs:oWsConsultaChaveNfeResult:cCodRetNfe+' - '+oWs:oWsConsultaChaveNfeResult:cMsgRetNfe)
				Else
					lRetorno	:= oWs:oWsConsultaChaveNfeResult:cCodRetNfe $ '100'

					//Se retornou algum erro entao mostra o motivo
					If !lRetorno
						If !Empty(oWs:oWsConsultaChaveNfeResult:cVersao)
							cMensagem += "Versใo: "+oWs:oWsConsultaChaveNfeResult:cVersao+CRLF
						EndIf
						cMensagem += "Ambiente: "+IIf(oWs:oWsConsultaChaveNfeResult:nAmbiente==1,"Produ็ใo","Homologa็ใo")+CRLF
						cMensagem += "Codigo: "+oWs:oWsConsultaChaveNfeResult:cCodRetNfe+CRLF
						cMensagem += "Mensagem: "+oWs:oWsConsultaChaveNfeResult:cMsgRetNfe+CRLF
						If !Empty(oWs:oWsConsultaChaveNfeResult:cProtocolo)
							cMensagem += "Protocolo: "+oWs:oWsConsultaChaveNfeResult:cProtocolo+CRLF
						EndIf
						ApMsgStop(cMensagem)
					EndIf
				EndIf
			Else
				ApMsgStop('CXConsChvNfe-002: Erro ao consultar servi็o da NFe (TSS)'+CRLF+;
					IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
			EndIf
		Else
			ApMsgAlert('CXConsChvNfe-003: O servi็o de consulta de NFe (TSS) nใo estแ configurado para esta empresa / filial a chave nใo serแ validada.')
		Endif
	//Else
	//	ApMsgAlert('CXConsChvNfe-004: O servi็o de consulta de NFe (TSS) nใo estแ configurado para esta empresa / filial a chave nใo serแ validada.'//)
	//EndIf

Return lRetorno
