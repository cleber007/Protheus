#INCLUDE "RWMAKE.CH"
#include "protheus.ch"
#INCLUDE "TOPCONN.CH"

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  � ConsNFeChave � Autor � Cirilo Rocha   	 � Data � 21/03/12 ���
//�������������������������������������������������������������������������͹��
//���Descricao � Funcao para validar a chave da NFe e' valida junto a sefaz ���
//���          �                                                            ���
//���          �                                                            ���
//�������������������������������������������������������������������������͹��
//���   DATA   � Programador   � Manutencao Efetuada                        ���
//�������������������������������������������������������������������������͹��
//��� 18/04/12 � Cirilo Rocha  � Feito tratamento para o retorno 200, quando���
//���          �               � o WS nao consegue consultar a chave.       ���
//���          �               � Ocorre muito com a Sefaz CE.               ���
//��� 27/04/12 � Cirilo Rocha  � Adicionado codigo 410 para tambem ignorar  ���
//���          �               �                                            ���
//���          �               �                                            ���
//���          �               �                                            ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
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
					ApMsgAlert('CXConsChvNfe-001: Falha ao consultar a chave da NFe, a chave n�o ser� validada junto a Sefaz.'+CRLF+;
						'Erro: '+oWs:oWsConsultaChaveNfeResult:cCodRetNfe+' - '+oWs:oWsConsultaChaveNfeResult:cMsgRetNfe)
				Else
					lRetorno	:= oWs:oWsConsultaChaveNfeResult:cCodRetNfe $ '100'

					//Se retornou algum erro entao mostra o motivo
					If !lRetorno
						If !Empty(oWs:oWsConsultaChaveNfeResult:cVersao)
							cMensagem += "Vers�o: "+oWs:oWsConsultaChaveNfeResult:cVersao+CRLF
						EndIf
						cMensagem += "Ambiente: "+IIf(oWs:oWsConsultaChaveNfeResult:nAmbiente==1,"Produ��o","Homologa��o")+CRLF
						cMensagem += "Codigo: "+oWs:oWsConsultaChaveNfeResult:cCodRetNfe+CRLF
						cMensagem += "Mensagem: "+oWs:oWsConsultaChaveNfeResult:cMsgRetNfe+CRLF
						If !Empty(oWs:oWsConsultaChaveNfeResult:cProtocolo)
							cMensagem += "Protocolo: "+oWs:oWsConsultaChaveNfeResult:cProtocolo+CRLF
						EndIf
						ApMsgStop(cMensagem)
					EndIf
				EndIf
			Else
				ApMsgStop('CXConsChvNfe-002: Erro ao consultar servi�o da NFe (TSS)'+CRLF+;
					IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
			EndIf
		Else
			ApMsgAlert('CXConsChvNfe-003: O servi�o de consulta de NFe (TSS) n�o est� configurado para esta empresa / filial a chave n�o ser� validada.')
		Endif
	//Else
	//	ApMsgAlert('CXConsChvNfe-004: O servi�o de consulta de NFe (TSS) n�o est� configurado para esta empresa / filial a chave n�o ser� validada.'//)
	//EndIf

Return lRetorno
