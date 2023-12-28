#Include "FIVEWIN.CH"
#include "tbiconn.ch"
#include "TbiCode.ch"
#INCLUDE "TOPCONN.CH"
#include "ap5mail.ch"
#INCLUDE "PROTHEUS.CH"
#Include "Totvs.ch"
#Define CRL Chr(13)+Chr(10)

User Function WFACINFO(cNumAn,nOpca,cPasta)
Local oHTML,oProcess
//Local lServProd := IIF(GetServerIP() == '172.28.1.24', .T., .F.)

cServerIni := GetAdv97()
cSecao := "SRVWFLOW"
cPadrao := "undefined"
cIPLan := GetPvProfString(cSecao, "IPWFLAN", cPadrao, cServerIni)
cPtLan := GetPvProfString(cSecao, "PTWFLAN", cPadrao, cServerIni)
cIPWeb := GetPvProfString(cSecao, "IPWFWEB", cPadrao, cServerIni)
cPtWeb := GetPvProfString(cSecao, "PTWFWEB", cPadrao, cServerIni)

oProcess:= TWFProcess():New("WFCAC","Abertura de Proposta Comercial: "+cNumAn) 										
oProcess:NewTask("Montagem da Aprovacao ZV1", "\web\ws\wflow\SIGACORP\WORKFLOWS\analises-criticas\pagina_v1.html") 														
oHtml	:= oProcess:oHTML	 
                                                                          
//Função de retorno a ser executada 
//quando a mensagem de respostas retornar ao Workflow:
oProcess:bReturn := "U_RetCAC()"

//Guardo o ID do Processo para enviar no link
cMailID := oProcess:Start()                                                                   
//Salvo HTML do Processo
oHtml:SaveFile("web\ws\wflow\SIGACORP\WORKFLOWS\analises-criticas\sendbox\PA_"+cMailID+".HTM")
//Carrego o link do Processo (será usado no retorno da Aprovação)
cRet := WFLoadFile("web\ws\wflow\SIGACORP\WORKFLOWS\analises-criticas\sendbox\PA_"+cMailID+".HTM")	
//Criando o link
oProcess:NewTask("Envio Link Analise Critica","web\ws\wflow\SIGACORP\WORKFLOWS\analises-criticas\link_v1.html")  

DBSelectArea("ZV6")
DBSetOrder(1)
DBSeek(xFilial("ZV6")+cNumAn)
//Assinalando novos valores às macros existentes no html:
//Cabeçalho
oProcess:oHtml:ValByName("numero",cNumAn)
oProcess:oHtml:ValByName("data",DTOC(Date()))
oProcess:oHtml:ValByName("hora",SubStr(Time(),1,5))
oProcess:oHtml:ValByName("marca","COPPERTEC")
oProcess:oHtml:ValByName("descprop",ZV6->ZV6_DESCRI)
oProcess:oHtml:ValByName("cliente",ZV6->ZV6_CLIENT + ZV6->ZV6_LOJA )
oProcess:oHtml:ValByName("nomecli",Alltrim(Posicione("SA1",1,xFilial("SA1")+ZV6->ZV6_CLIENT+ZV6->ZV6_LOJA,"A1_NOME")))

oProcess:oHtml:ValByName("consultor","Nome do Consultor")
oProcess:oHtml:ValByName("solicitante","marcelo.victor")
oProcess:oHtml:ValByName("emissao",DTOC(ZV6->ZV6_EMISSA))
oProcess:oHtml:ValByName("validade",DTOC(ZV6->ZV6_VALIDA))
oProcess:oHtml:ValByName("tipo","")
oProcess:oHtml:ValByName("area","")

DBSelectArea("ZV7")
DBSetOrder(1) 
DBSeek(xFilial("ZV7")+cNumAn)     
Do While !EOF() .and. ZV7->ZV7_FILIAL+ZV7->ZV7_NUMERO == xFilial("ZV7")+cNumAn
	aAdd((oProcess:oHtml:ValByName("it.item")),ZV7->ZV7_ITEM)
	aAdd((oProcess:oHtml:ValByName("it.codcli")),Alltrim(ZV7->ZV7_PRODUT))
	aAdd((oProcess:oHtml:ValByName("it.descric")),Alltrim(ZV7->ZV7_DESC01))
	aAdd((oProcess:oHtml:ValByName("it.quant")),Transform(ZV7->ZV7_QUANT,"@E 999,999,999.99"))
	aAdd((oProcess:oHtml:ValByName("it.unimed")),ZV7->ZV7_UM)
	DBSkip()
EndDo

//Revisao do Workflow
_cIpTest:=SuperGetMV("AL_IPSRVTS",.f.,"172.28.1.12")
lServTeste := IIf(GetServerIP() == RTRIM(_cIpTest), .T.,.F.)
If !lServTeste
//If lServProd //Servidor Produção         
	oProcess:cSubject := "LINK abertura de proposta comercial "+cNumAn
	oProcess:ohtml:ValByName("localink","http://"+cIPLan+":"+cPtLan+"/Microsiga/PROTHEUS_DATA/web/ws/wflow/SIGACORP/WORKFLOWS/analises-criticas/sendbox/PA_"+cMailID+".htm")
	oProcess:ohtml:ValByName("weblink","http://"+cIPWeb+":"+cPtWeb+"/Microsiga/PROTHEUS_DATA/web/ws/wflow/SIGACORP/WORKFLOWS/analises-criticas/sendbox/PA_"+cMailID+".htm")
	oProcess:cTo := Alltrim(GetMV("AL_MAILADM"))//+cMailAprov
Else //Servidor Base_teste
	oProcess:cSubject := "TESTE LINK abertura de proposta comercial "+cNumAn
	oProcess:ohtml:ValByName("localink","http://172.28.1.12:8090/PROTHEUS_DATA/web/ws/wflow/SIGACORP/WORKFLOWS/analises-criticas/sendbox/PA_"+cMailID+".htm")
	oProcess:cTo := Alltrim(GetMV("AL_MAILADM"))
EndIf	
oProcess:Start()	


Return()