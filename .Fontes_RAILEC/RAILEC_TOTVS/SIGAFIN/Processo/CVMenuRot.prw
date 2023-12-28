#include "ap5mail.ch"
#Include "colors.ch"
#include "rptdef.ch"
#INCLUDE "rwmake.ch"
#include "TbiCode.ch"
#include "tbiconn.ch"
#include "topconn.ch"
#Include "totvs.ch"

#Define CRL Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ZV1CAD     บAutor  Debis Haruo       บ Data ณ  29/07/2015   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณControle de Viagens de Funcionarios                           บฑฑ
ฑฑบ          ณRotinas do Menu                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                      
/*
######### UNIFICADO OS FONTES REFERENTES AO GESTAO DE VIAGENS  ######### 
######### FONTES UNIFICADOS:
	CVMBROWSER.PRW
	VIAGEMXFUNC.PRW
	CVPRESTACONTA.PRW
	COMPVIAGEM.PRW
	CVMODHTML.PRW 
######### FABIO /YOSHIOKA 13/10/16 ######################################/
*/

************************
User Function CADZV1()
	***********************
	#IFNDEF WINDOWS
		ScreenDraw("SMT050", 3, 0, 0, 0)
	#ENDIF

	Local _lOkzv4       := .f. //21/09/16
	Private _cAlias     := "ZV1" //18/01/17
	Private cCadastro   := "Solicita็ใo de Viagem"
	Private aCorZV1     := {}
	Private aRotina     := {}
	Private _cUsuar     := &( 'RETCODUSR()' ) //21/09/16
	Private _lAtManSol  := .f.
	Private _cIpProd    := GetMV("AL_IPSRVPR") //05/08/16 - Fabio Yoshioka
	Private _cIpTest    := GetMV("AL_IPSRVTS") //05/08/16
	Private _cPrcSrvI   := GetMV("AL_PRWFINT") //08/08/16
	Private _cPrcSrvE   := GetMV("AL_PRWFEXT") //08/08/16
	Private _cIdEner    := GetMV("AL_EMFILEN") //18/07/17 - Fabio Yoshioka - Tratamento para RAILEC Energia
	Private _lALEner    := iif(cEmpAnt+cFilAnt $ _cIdEner,.T.,.F.) //18/07/17
	PRIVATE _cRetArqPDF := ""

	aRotina2 := {}
	if !_lALEner //21/07/17 - Fabio Yoshioka

		aadd(aRotina2, {"Visualisar"            , "U_PrestConta(1)"                  , 0, 4})
		aadd(aRotina2, {"Incluir"               , "U_PrestConta(2)"                  , 0, 5})
		aadd(aRotina , {"Pesquisar"             , "AxPesqui"                         , 0, 1})
		aadd(aRotina , {"Visualizar"            , "U_ZV1Valid(1)"                    , 0, 2})
		aadd(aRotina , {"Incluir"               , "U_ZV1Valid(2)"                    , 0, 3})
		aadd(aRotina , {"Excluir"               , "U_AxExcZV1(_cAlias,RecNo(), '1' )", 0, 5}) //13/01/17
		aadd(aRotina , {"Reenviar WorkFlow"     , "U_ZV1Valid(5)"                    , 0, 2})
		aadd(aRotina , {"Prestar Contas"        , aRotina2                           , 0, 4})
		aadd(aRotina , {"Atualizar Solicitantes", "U_ATUMANSL()"                     , 0, 6}) //26/10/16
		aadd(aRotina , {"Legenda"               , "U_ZV1Legend()"                    , 0, 3})

		//MODIFICADO EM 19/10/2016
		AADD(aCorZV1,{"ZV1_STATUS == '1' ","BR_AMARELO"	})	//ENVIADO PARA APROVAวรO DO SETOR (GERENCIA)
		AADD(aCorZV1,{"ZV1_STATUS == '2' ","BR_LARANJA"})	//LIBERADO PELO SETOR (GERENCIA)
		AADD(aCorZV1,{"ZV1_STATUS == 'A' ","BR_AZUL"})		//VISTADO PELO FINANCEIRO
		AADD(aCorZV1,{"ZV1_STATUS == '3' ","BR_VERDE"})		//LIBERADO PELO SETOR (GERENCIA)
		AADD(aCorZV1,{"ZV1_STATUS == 'B' ","BR_BRANCO"})	//PA GERADA
		AADD(aCorZV1,{"ZV1_STATUS == '0' ","BR_PINK"})		//P. Contas Gravada
		AADD(aCorZV1,{"ZV1_STATUS == '4' ","BR_VERMELHO"})	//P. Contas em anแlise nivel 1
		AADD(aCorZV1,{"ZV1_STATUS == '5' ","BR_MARROM"})	//P. Contas em anแlise nivel 2
		AADD(aCorZV1,{"ZV1_STATUS == '6' ","BR_VIOLETA"})	//P. Contas aprovada/Tit gerado
		AADD(aCorZV1,{"ZV1_STATUS == '7' ","LBOK"})		//Viagem Encerrada e Compensada
		AADD(aCorZV1,{"ZV1_STATUS == '8' ","BR_PRETO"})		//Adiantamento Rejeitado/Viagem Cancelada
		AADD(aCorZV1,{"ZV1_STATUS == '9' ","BR_CINZA"})		//P. Contas Rejeitada

	ELSE
		cCadastro := "Presta็ใo de Contas" //24/04/18
		aadd(aRotina2, {"Visualisar"        , "U_PresCALE(2)", 0, 2})
		aadd(aRotina2, {"Incluir"           , "U_PresCALE(3)", 0, 3})
		aadd(aRotina2, {"Alterar"           , "U_PresCALE(4)", 0, 4})
		aadd(aRotina2, {"Excluir"           , "U_PresCALE(5)", 0, 5})
		aadd(aRotina2, {"Baixar"            , "U_PresCALE(6)", 0, 5})
		aadd(aRotina2, {"Relatorio"         , "U_RelPresC() ", 0, 7})
		aadd(aRotina2, {"Gerar PDF"         , "U_RPrestAP() ", 0, 8})
		aadd(aRotina2, {"WF Aprova็ใo"      , "U_EnvWFAPV() ", 0, 9}) //28/12/17
		aadd(aRotina , {"Pesquisar"         , "AxPesqui"     , 0, 1})
		aadd(aRotina , {"Legenda"           , "U_ZV1Legend()", 0, 3})
		aadd(aRotina , {"Prestar Contas"    , aRotina2       , 0, 4})
		aadd(aRotina , {"Conhecimento"      , "MSDOCUMENT"   , 0, 4}) //conhecimento - 22/12/17 - Fabio Yoshioka
		aadd(aCorZV1 , {"EMPTY(ZV1_STATUS)" , "BR_VERDE"}) //P. Contas Gravada
		aadd(aCorZV1 , {"ZV1_STATUS == '0' ", "BR_PINK"}) //P. Contas ENVIADA APROVACAO
		aadd(aCorZV1 , {"ZV1_STATUS == '6' ", "BR_VIOLETA"}) //P. Contas aprovada
		aadd(aCorZV1 , {"ZV1_STATUS == '9' ", "BR_CINZA"}) //P. Contas Rejeitada

	ENDIF

//MsgRun("Atualizando Solicitantes. Aguarde...",,{||_lOkzv4:=U_IniciaZV4(_cUsuar)})   //21/09/16 - Fabio Yoshioka

	_lOkzv4:=.t. //08/12/16

	if _lOkzv4
		dbSelectArea("ZV2")
		DBSetOrder(1)

		dbSelectArea("ZV1")
		DBSetOrder(1)
		mBrowse(6,1,22,75,"ZV1",,,,,,aCorZV1)
	endif

Return()

USER FUNCTION ATUMANSL() //26/10/16

	_lAtManSol:=.t.
	MsgRun("Atual. Manual Solicitantes. Aguarde...",,{||U_IniciaZV4(_cUsuar)})

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณZV1Legend  บAutor  Denis Haruo          บ Data ณ  08/27/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLegendas do controlde de viagens
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ZV1Legend()
/*BrwLegenda(cCadastro,"Status",{	{"BR_AZUL"		,"Em analise de aprova็ใo 1"	},;
											{"BR_AMARELO"	,"Em analise de aprova็ใo 2"},;
											{"ENABLE"		,"Adiantamento concedido"},;
											{"BR_PINK"		,"P. Contas Gravada"},;
											{"BR_LARANJA"	,"P. Contas em anแlise nivel 1"},;
											{"BR_MARROM"	,"P. Contas em anแlise nivel 2"},; 
											{"BR_BRANCO"	,"P. Contas aprovada/Tit gerado"},; 
											{"DISABLE"		,"Viagem Encerrada e compensada"},; 
											{"BR_PRETO"		,"Adiantamento rejeitado"},;
											{"BR_CINZA"		,"P. Contas rejeitada"}})*/
IF !_lALEner
	BrwLegenda(cCadastro,"Status",{	{"BR_AMARELO"	,"Enviado p/ Aprov. do C.Custo"},;  		  	//ENVIADO PARA APROVAวรO DO SETOR (GERENCIA)
											{"BR_LARANJA"	,"Aprovado p/ Resp. do C.Custo"},;    		  //LIBERADO PELO SETOR (GERENCIA)
											{"BR_AZUL"	   ,"Adiantamento Vistado  (Fin.)"},;    		 //VISTADO PELO FINANCEIRO      
											{"BR_VERDE"	   ,"Adiantamento Aprovado (Fin.)"},;    	   //LIBERADO PELO SETOR (GERENCIA)											
											{"BR_BRANCO"	,"Adiantamento concedido(Fin.)"},;    	  //PA GERADA
											{"BR_PINK"		,"P. Contas Gravada"},;
											{"BR_VERMELHO"	,"P. Contas em anแlise nivel 1"},;
											{"BR_MARROM"	,"P. Contas em anแlise nivel 2"},; 
											{"BR_VIOLETA"	,"P. Contas aprovada/Tit gerado"},; //COMPENSAวรO DA PA
											{"LBOK"			,"Viagem Encerrada e compensada"},; 
											{"BR_PRETO"		,"Adiantamento rejeitado"},;
											{"BR_CINZA"		,"P. Contas rejeitada"}})
ELSE
	BrwLegenda(cCadastro,"Status",{	{"BR_PINK"		,"P. Contas Enviada"},;
									{"BR_VIOLETA"	,"P. Contas aprovada/Tit gerado"},;
									{"BR_CINZA"		,"P. Contas rejeitada"},;
									{"BR_VERDE"		,"P. Contas Gravada"}})
ENDIF

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ZV1Valid  บAutor  Denis Haruo            บ Data ณ  07/30/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida็๕es das op็๕es do Controle Viagem                   บฑฑ
ฑฑบ          ณInclusใo, altera็ใo, exclusใo, etc...                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	******************************
User Function ZV1Valid(nOpca)
	******************************
	Local cUsrLoged := &('RETCODUSR()')

	If nOpca == 1 //Visualizar
		U_ZV1DlgMod(nOpca)
	EndIf


	If nOpca == 2 .and. MSGYesNo("Cadastrar uma Viagem?")


		U_ZV1DlgMod(nOpca)

/*
		DBSelectArea("ZV4")
		DBSetOrder(2)
		If DBseek(xFilial("ZV4")+cUsrLoged)
			If ZV4->ZV4_SOLICI == "S"
				U_ZV1DlgMod(nOpca)
			Else
				MSGStop("Somente usuแrios cadastrados como Solicitantes, pode incluir adiantamentos. Opera็ใo nใo permitida","ViagemXFunc")
				//Alert("Concedida permissใo de Admin")
				//U_ZV1DlgMod(nOpca)
			EndIf
		Else
			MSGStop("Usuario nใo cadastrado na Tabela de Colaboradores ZV4. Opera็ใo nใo permitida.","ViagemXFunc")
			//IF RTRIM(cUsrLoged) =='000000'
			//	Alert("Concedida permissใo de Admin")
			//	U_ZV1DlgMod(nOpca)
			//ENDIF
		EndIf
*/
	EndIf

	If nOpca == 7 .and. MSGYesNo("Prorrogar esta viagem "+ZV1_COD+" ?")
		If cUsrLoged <> ZV1->ZV1_CODSOL
			MSGStop("Somente o usuario solicitante desta viagem pode alterar os dados da viagem.","ViagemXFunc")
		ElseIf ZV1_STATUS == "8"
			MSGStop("Esta viagem nใo pode ser prorrogada pois, foi rejeitada. Motivo da rejei็ใo: "+UPPER(Alltrim(ZV1->ZV1_MOTREJ)),"ViagemXFunc")
		Else
			U_ZV1DlgMod(nOpca)
		EndIf
	EndIf

	If nOpca == 8 .and. MSGYesNo("Cancelar esta viagem "+ZV1_COD+"? O PA associado a ela serแ excluํdo do Contas a Pagar.")
		If cUsrLoged <> ZV1->ZV1_CODSOL
			MSGStop("Somente o usuario solicitante desta viagem pode cancela-la.","ViagemXFunc")

		ElseIf ZV1_STATUS == "8" //Rejeitada
			MSGStop("Esta viagem nใo pode ser cancelada pois, foi rejeitada. Motivo da rejei็ใo: "+UPPER(Alltrim(ZV1->ZV1_MOTREJ)),"ViagemXFunc")

		ElseIf ZV1_STATUS == "7" //Finalizada
			MSGStop("Esta viagem nใo pode ser cancelada pois, jแ estแ finalizada","ViagemXFunc")

		ElseIf ZV1_STATUS == "4" .or.;	//Prestando contas
			ZV1_STATUS == "5" .or.;
				ZV1_STATUS == "6" .or.;
				ZV1_STATUS == "8" .or.;
				ZV1_STATUS == "9" .or.;
				ZV1_STATUS == "0"

			MSGStop("Esta viagem nใo pode ser cancelada pois, jแ estแ em presta็ใo de contas.","ViagemXFunc")
		Else
			U_ZV1DlgMod(nOpca)
		EndIf
	EndIf

	If nOpca == 5 .and. MSGYesNo("Reiniciar este processo de autoriza็ใo de adiantamento da viagem "+ZV1_COD+"?")
		//U_StartWFZV1(nOpca)
		if UPPER(RTRIM(ZV1_ADIANT))<>'N'
			U_WFViagem(ZV1_COD,ZV1_SEQ,U_RESPAPV(ZV1_CODSOL,'G'))//26/10/16
		else
			MSGStop("Nใo houve adiantamento para esta viagem!","SemAdiant")//30/11/16
		endif
	EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ValidUser บAutor  Denis Haruo            บ Data ณ  08/27/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida็ใo do usuario para o controlde de viagens              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*******************************************
Static Function ValidUser(cUsrLoged,nOpca)
	*******************************************
	Local lRet := .T.

	Do Case
	Case nOpca == 2 //Inclusใo de Viagem
		DBSelectArea("ZV4")
		DBSetOrder(2)
		If DBseek(xFilial("ZV4")+cUsrLoged)
			If ZV4->ZV4_SOLICI <> "S"
				MSGStop("Somente usuแrios cadastrados como Solicitantes, pode incluir adiantamentos. Opera็ใo nใo permitida","ValidUser()")
				lRet := .F.
			EndIf
		Else
			MSGStop("Usuario nใo cadastrado na Tabela de Colaboradores ZV4. Opera็ใo nใo permitida.","ValidUser()")
			lRet := .F.
		EndIf

	Case nOpca == 3 //Altera็ใo de Viagem
		DBSelectArea("ZV1")
		If uUsrLoged <> ZV1->ZV1_CODSOL
			MSGStop("Somente o usuario solicitante desta viagem pode alterar os dados da viagem.","ValidUser()")
			lRet := .F.
		EndIf

	Case nOpca == 7
		DBSelectArea("ZV1")
		If uUsrLoged <> ZV1->ZV1_CODSOL
			MSGStop("Somente o usuario solicitante desta viagem pode alterar os dados da viagem.","ValidUser()")
			lRet := .F.
		EndIf

	Case nOpca == 6 //Presta็ใo de Contas
		DBSelectArea("ZV4")
		DBSetOrder(1)
		DBSeek(xFilial("ZV4")+ZV1->ZV1_MATRIC)
		If uUsrLoged <> ZV4->ZV4_CODUSR
			MSGStop("Somente o colaborador cadastrado nesta viagem pode prestar contas desta viagem.","ValidUser()")
			lRet := .F.
		EndIf
	End Case


Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidaAlt  บAutor  Denis Haruo        บ Data ณ  08/27/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se a viagem pode ser alterada                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*****************************
Static Function ValidaAlt()
	*****************************
	Local lRet := .T.
	Local cPrefixo := ZV1->ZV1_PREFIX
	Local cNumPA := ZV1->ZV1_NUMPA

	DBSelectArea("SE2")
	DBSetOrder(1)
	If DBseek(xFilial("SE2")+cPrefixo+cNumPA)
		cMsg := ""
		cMsg += "Esta viagem nใo pode ser alterada pois jแ possui um adiantamento no contas a pagar. Exclua o adiantamento para alterar."
		MSGStop(cMsg,"ValidaAlt()")
		lRet := .F.
	EndIf

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCVMBROWSER บAutor  Denis Tsuchiya      บ Data ณ  08/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ	Janela do controle de viagens 
					INCLUSAO, ALTERAวยO E EXCLUSAO       							บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*******************************
User Function ZV1DlgMod(nOpca)
	*******************************
	Local oDlg
	Local oButton1
	Local oButton2
	Local lOk := .F.
	Local oFont1 := TFont():New("MS Sans Serif",,016,,.F.,,,,,.F.,.F.)
	Local oFont2 := TFont():New("MS Sans Serif",,016,,.T.,,,,,.F.,.F.)
	//Local lSai := .F.
	Local lVisual := IIF(nOpca==2,.T.,.F.)
	Local lExclui := IIF(nOpca==8,.T.,.F.)
	Local cSubTitle := ""

	Local oSay1,oSay2,oSay3,oSay4,oSay5,oSay6,oSay7,oSay8,oSay9
	Local oSay10,oSay11,oSay12,oSay13,oSay14,oSay15,oSay17
	Local oGroup1,oGroup2,oGroup3,oGroup4

	Private oPanel1,oCodTrip,oCodSol,oNomeSol,oCbTipo,oCCusto,oCidDest,oCidOrig,oUFDest,oUFOrig
	Private oDtFim,oDtIni,oDtSol,oGetObs,oMatFunc,oMotVia,oMunDest,oMunOrig,oNomeCC,oNomeFunc,oTotDesp
//Private dDtSol 	:= IIF(nOpca==2,Date()		,ZV1->ZV1_EMISSA)
	Private cCodTrip  := IIF(nOpca==2,GetSXENum("ZV1","ZV1_COD"),ZV1->ZV1_COD)
	Private cSeq      := IIF(nOpca==2, '001' ,IIF(nOpca==7,Soma1(ZV1->ZV1_SEQ),ZV1->ZV1_SEQ))
	Private cCodSol   := &( 'RETCODUSR()' )
	Private cNomeSol  := Alltrim(UsrRetName(cCodSol))
	Private nCbTipo   := 1

	Private dDtSol    := IIF(nOpca==2,Date() ,ZV1->ZV1_DTVENC) //13/10/16 - exibo vencimento
	Private cMatFunc  := IIF(nOpca==2,Space(6) ,ZV1->ZV1_MATRIC)
	Private cNomeFunc := IIF(nOpca==2,Space(60) ,ZV1->ZV1_NFUNC)
	Private cCCusto   := IIF(nOpca==2,Space(3) ,ZV1->ZV1_CC)
	Private cNomeCC   := IIF(nOpca==2,Space(60) ,ZV1->ZV1_DESCCC)
	Private cUFOrig   := IIF(nOpca==2,Space(2) ,ZV1->ZV1_ESTORI)
	Private cMunOrig  := IIF(nOpca==2,Space(5) ,ZV1->ZV1_CIDORI)
	Private cCidOrig  := IIF(nOpca==2,Space(60) ,ZV1->ZV1_NCORIG)
	Private cUFDest   := IIF(nOpca==2,Space(2) ,ZV1->ZV1_ESTDES)
	Private cMunDest  := IIF(nOpca==2,Space(5) ,ZV1->ZV1_CIDDES)
	Private cCidDest  := IIF(nOpca==2,Space(60) ,ZV1->ZV1_NCDEST)
	Private dDtFim    := IIF(nOpca==2 .or. nOpca==7,Date(),ZV1->ZV1_DTFIM)
	Private dDtIni    := IIF(nOpca==2 .or. nOpca==7,Date(),ZV1->ZV1_DTINI)
	Private cMotVia   := IIF(nOpca==2,Space(200) ,ZV1->ZV1_MOTVIA)
	Private cGetObs   := IIF(nOpca==2,Space(200) ,ZV1->ZV1_OBS1)
	Private cTotDesp  := IIF(nOpca==2,"0,00" ,ZV1->ZV1_TOTADI)
	Private nTotDias  := 0
	Private aHeaderEx := {}
	Private aColsEx   := {}
	Private oMSNewGe1
	Private cCodSeq   := cCodTrip+"/"+cSeq

	Do case
	case nOpca == 1
		nTotDesp := 0
		cSubTitle:=" - VISUALIZAR"
		DBSelectArea("ZV2")
		DBSetOrder(2)
		DBseek(xFilial("ZV2")+ZV1->ZV1_COD+ZV1->ZV1_SEQ)
		Do While !EOF() .and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA+ZV2_SEQ == xFilial("ZV2")+ZV1->ZV1_COD+ZV1->ZV1_SEQ
			If ZV2->ZV2_CODIGO == '000'
				DBSkip()
				Loop
			EndIf
			nTotDesp += ZV2->ZV2_VALOR
			DBskip()
		EndDo
		cTotDesp := Transform(nTotDesp,"@E 999,999,999.99")
		nTotDias := dDtFim-dDtIni

	case nOpca == 2
		cSubTitle:=" - INCLUIR"
	case nOpca == 3
		cSubTitle:=" - ALTERAR"
	case nOpca == 7
		cSubTitle:=" - PRORROGAR"
	case nOpca == 8
		//	cSubTitle:=" - CANCELAR"
		cSubTitle:=" - EXCLUIR" //18/01/17
	End case

//Op็๕es da dialog
//1 "Visualizar"
//2 "Incluir" 		
//3 "Alterar" 		
//4 "Excluir" 		
//5 "Reenviar"  		
//6 "Prestar Contas"     

	dDtSol:= dDatabase//U_RetDtVPA() //19/10/16

	DEFINE MSDIALOG oDlg TITLE "Controle de Viagens"+cSubTitle FROM 000, 000  TO 478, 727 COLORS 0, 16777215 PIXEL

	@ 000, 000 MSPANEL oPanel1 SIZE 365, 240 OF oDlg COLORS 0, 15920613 RAISED
	@ 004, 005 GROUP oGroup1 TO 218, 359 PROMPT " Inclusใo de Adiantamento de Viagem " OF oPanel1 COLOR 8388608, 15920613 PIXEL
	@ 017, 009 SAY oSay1 PROMPT "C๓digo/Seq:" SIZE 032, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
	@ 016, 041 MSGET oCodTrip VAR cCodSeq SIZE 039, 010 OF oPanel1 COLORS 0, 16777215 PIXEL WHEN .F.
	@ 017, 085 SAY oSay15 PROMPT "Tipo:" SIZE 016, 006 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
	@ 016, 101 MSCOMBOBOX oCbTipo VAR nCbTipo ITEMS {"Servi็o","Treinamento"} SIZE 047, 010 OF oPanel1 COLORS 0, 16777215 PIXEL
	@ 017, 152 SAY oSay2 PROMPT "Solicitante: " SIZE 028, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
	@ 016, 182 MSGET oCodSol VAR cCodSol SIZE 030, 010 OF oPanel1 COLORS 0, 16777215 PIXEL WHEN .F.
	@ 016, 214 MSGET oNomeSol VAR cNomeSol SIZE 075, 010 OF oPanel1 COLORS 0, 16777215 PIXEL WHEN .F.
//@ 017, 295 SAY oSay3 PROMPT "Emissao: " SIZE 023, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
	@ 017, 295 SAY oSay3 PROMPT "Vencim.: " SIZE 023, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL  //13/10/16
//@ 016, 320 MSGET oDtSol VAR dDtSol SIZE 032, 010 OF oPanel1 COLORS 0, 16777215 PIXEL WHEN .F.
	@ 016, 320 MSGET oDtSol VAR dDtSol SIZE 032, 010 OF oPanel1 COLORS 0, 16777215 PIXEL When lVisual VALID ValidVenc()//19/10/16

	@ 032, 010 GROUP oGroup2 TO 118, 355 PROMPT " Dados da Viagem " OF oPanel1 COLOR 8388608, 15920613 PIXEL
	@ 042, 012 SAY oSay5 PROMPT "Matrํcula:" SIZE 025, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
	@ 041, 039 MSGET oMatFunc VAR cMatFunc SIZE 032, 010 OF oPanel1 COLORS 0, 16777215 PIXEL When lVisual F3 "ZV4" VALID ValidaMat()
	@ 043, 075 SAY oSay4 PROMPT "Nome:" SIZE 017, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
	@ 041, 094 MSGET oNomeFunc VAR cNomeFunc SIZE 100, 010 OF oPanel1 COLORS 0, 16777215 PIXEL WHEN .F.
	@ 042, 198 SAY oSay6 PROMPT "Centro de Custo:" SIZE 043, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
	@ 041, 242 MSGET oCCusto VAR cCCusto SIZE 029, 010 OF oPanel1 COLORS 0, 16777215 PIXEL When .F.
	@ 041, 273 MSGET oNomeCC VAR cNomeCC SIZE 079, 010 OF oPanel1 COLORS 0, 16777215 PIXEL WHEN .F.

	@ 057, 013 GROUP oGroup4 TO 097, 233 PROMPT "Origem/Destino" OF oPanel1 COLOR 8388608, 15920613 PIXEL
	@ 069, 017 SAY oSay13 PROMPT "UF/Cid. Orig: " SIZE 034, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
	@ 067, 053 MSGET oUFOrig VAR cUFOrig SIZE 022, 010 OF oPanel1 COLORS 0, 16777215 PIXEL When lVisual F3 '12' Picture "@!"
	@ 067, 077 MSGET oMunOrig VAR cMunOrig SIZE 030, 010 OF oPanel1 COLORS 0, 16777215 PIXEL When lVisual F3 'CC2ZVO'
	@ 067, 115 MSGET oCidOrig VAR cCidOrig SIZE 115, 010 OF oPanel1 COLORS 0, 16777215 PIXEL WHEN .F.
	@ 083, 017 SAY oSay7 PROMPT "UF/Cid. Dest:" SIZE 035, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
	@ 081, 053 MSGET oUFDest VAR cUFDest SIZE 022, 010 OF oPanel1 COLORS 0, 16777215 PIXEL When lVisual F3 '12' Picture "@!"
	@ 081, 077 MSGET oMunDest VAR cMunDest SIZE 030, 010 OF oPanel1 COLORS 0, 16777215 PIXEL When lVisual F3 'CC2ZVD'
	@ 081, 115 MSGET oCidDest VAR cCidDest SIZE 115, 010 OF oPanel1 COLORS 0, 16777215 PIXEL WHEN .F.

	@ 057, 235 GROUP oGroup3 TO 097, 352 PROMPT " Perํodo da viagem " OF oPanel1 COLOR 8388608, 15920613 PIXEL
	@ 070, 238 SAY oSay8 PROMPT "Data Inํcio: " SIZE 030, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
	@ 068, 276 MSGET oDtIni VAR dDtIni SIZE 032, 010 OF oPanel1 COLORS 0, 16777215 PIXEL When !lExclui
	@ 084, 238 SAY oSay9 PROMPT "Data Retorno:" SIZE 037, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
	@ 082, 276 MSGET oDtFim VAR dDtFim SIZE 032, 010 OF oPanel1 COLORS 0, 16777215 PIXEL When !lExclui Valid DataRet()

	@ 070, 312 SAY oSay17 PROMPT "Quant. Dias" SIZE 036, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
	@ 084, 325 SAY oTotDias VAR nTotDias SIZE 023, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL

	@ 103, 015 SAY oSay14 PROMPT "Motivo da Viagem: " SIZE 057, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
	@ 102, 072 MSGET oMotVia VAR cMotVia SIZE 280, 010 OF oPanel1 COLORS 0, 16777215 PIXEL When !lExclui Picture "@!" Valid MotVia()

	@ 120, 010 SAY oSay10 PROMPT "Despesas da Viagem: " SIZE 064, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
	MyGetDesp(nOpca)

	@ 191, 009 SAY oSay11 PROMPT "Total das Despesas: " SIZE 061, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
	@ 191, 069 SAY oTotDesp VAR cTotDesp SIZE 055, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL

	@ 204, 010 SAY oSay12 PROMPT "Observa็๕es: " SIZE 042, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
	@ 203, 053 MSGET oGetObs VAR cGetObs  SIZE 303, 010 OF oPanel1 COLORS 0, 16777215 PIXEL When !lExclui Picture "@!"

//If nOpca == 2 .or. nOpca == 7 //Inclusใo ou prorroga็ใo
	If nOpca == 2 .or. nOpca == 8 //Inclusใo ou EXCLUSAO - 18/01/17
		@ 223, 279 BUTTON oButton1 PROMPT "Confirmar" SIZE 037, 012 OF oPanel1 PIXEL Action(lOk:=.T.,oDlg:End())
/*ElseIf nOpca == 8 //Exclusao
	@ 223, 279 BUTTON oButton1 PROMPT "Confirmar" SIZE 037, 012 OF oPanel1 PIXEL Action(ExcluiZV1(),oDlg:End())*/
EndIf                

@ 223, 321 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oPanel1 PIXEL Action oDlg:End()
//@ 229, 005 SAY oSay16 PROMPT "Powered by Sigacorp" SIZE 059, 007 OF oPanel1 COLORS 12632256, 15920613 PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

If lOk 
	IF !lExclui
		If GravaDados(nOpca)  
			DBSelectArea("ZV1")
			ConfirmSX8()
		Else
			DBSelectArea("ZV1")
			RollbackSx8()
		EndIf
	ELSE
		RETURN .T.			
	ENDIF
else
	IF !lExclui
		RollbackSx8()
	ELSE
		RETURN .F.	
	ENDIF
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMyGetDesp   บAutor  Denis HAruo          บ Data ณ  08/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGetDados das despesas da viagem                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
		**********************************
Static Function MyGetDesp(nOpca)
	**********************************
	//Local nX
	//Local aFieldFill := {}
	//Local aFields := {}
	Local nUsado := 0
	Local _ni := 0
	Local aAlterFields := {"ZV2_VALOR "}
//Local aAlterFields := {"ZV2_VALOR","ZV2_CODIGO"} //13/10/16

//dbSelectArea("SX3")
//DbSetOrder(1)
//DbSeek("ZV2")

	cAliasTmp := "IASX3"
	OpenSXs(NIL, NIL, NIL, NIL, cEmpAnt, cAliasTmp, "SX3", NIL, .F.)
	cFiltro   := "X3_ARQUIVO == 'ZV2'"
	(cAliasTmp)->(DbSetFilter({|| &(cFiltro)}, cFiltro))
	(cAliasTmp)->(DbGoTop())
	(cAliasTmp)->(DbSetOrder(02))

	aHeaderEx:={}
	While !Eof().And.((cAliasTmp)->(x3_arquivo)=="ZV2")
		//Filtrando os campos do acols
		If alltrim((cAliasTmp)->(X3_CAMPO))=="ZV2_CODIGO" .or.;
				alltrim((cAliasTmp)->(X3_CAMPO))=="ZV2_DESCRI" .or.;
				alltrim((cAliasTmp)->(X3_CAMPO))=="ZV2_QUANT" .or.;
				alltrim((cAliasTmp)->(X3_CAMPO))=="ZV2_VALOR"

			If X3USO((cAliasTmp)->(X3_USADO)).And.cNivel>=(cAliasTmp)->(x3_nivel)
				nUsado:=nUsado+1
				Aadd(aHeaderEx,{ alltrim((cAliasTmp)->(x3_titulo)),(cAliasTmp)->(X3_CAMPO),(cAliasTmp)->(X3_PICTURE),;
					(cAliasTmp)->(X3_TAMANHO), (cAliasTmp)->(X3_DECIMAL),"AllwaysTrue()",;
					(cAliasTmp)->(X3_USADO), (cAliasTmp)->(X3_TIPO),(cAliasTmp)->(X3_F3),(cAliasTmp)->(X3_CONTEXT) } )
			Endif
			dbSkip()
		Else
			dbSkip()
			Loop
		EndIf
	End

	If nOpca==2 .or. nOpca==7 //incluir ou Prorrogar
		aColsEx:={Array(nUsado+1)}
		aColsEx[1,nUsado+1]:=.F.
		For _ni:=1 to nUsado
			aColsEx[1,_ni]:=CriaVar(aHeaderEx[_ni,2])
		Next
		aColsEx[1,1]:= "000"
		aColsEx[1,2]:= Posicione("ZV3",1,xFilial("ZV3")+"000","ZV3_DESCRI")
		aColsEx[1,3]:= 1
	Else
		nTotDesp	:= 0
		cNumAplic := SubStr(cCodSeq,1,6)+SubStr(cCodSeq,8,3)
		aColsEx:={}
		dbSelectArea("ZV2")
		dbSetOrder(2)
		dbSeek(xFilial()+cNumAplic)
		While !eof().and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA+ZV2->ZV2_SEQ == xFilial()+cNumAplic

			If ZV2->ZV2_CODIGO <> '000'
				nTotDesp += ZV2->ZV2_VALOR
			EndIf

			AADD(aColsEx,Array(nUsado+1))
			For _ni:=1 to nUsado
				aColsEx[Len(aColsEx),_ni]:=FieldGet(FieldPos(aHeaderEx[_ni,2]))
			Next
			aColsEx[Len(aColsEx),nUsado+1]:=.F.
			dbSkip()
		End
	Endif

	oMSNewGe1 := MsNewGetDados():New( 130, 010, 187, 355, GD_INSERT+GD_DELETE+GD_UPDATE, "U_GetLinOK()", "AllwaysTrue", , aAlterFields,, 1, "U_FieldDesp()", "", "AllwaysTrue", oPanel1, aHeaderEx, aColsEx)

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFieldDesp  บAutor  Denis Haruo         บ Data ณ  08/25/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida็ใo do campos da GetDados                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FieldDesp()

	Local lRet := .T.
	//Local aAux := aClone(oMSNewGe1:aCols)
	Local cCpo := ReadVar()

	If cCpo == "M->ZV2_VALOR"
		cTotDesp:= Transform(M->ZV2_VALOR,"@E 999,999,999.99")
		oTotDesp:Refresh()
	EndIf

/*If cCpo == "M->ZV2_CODIGO"  //13/10/16
	//M->ZV2_DESCRI:=Posicione("ZV3",1,xFilial("ZV3")+M->ZV2_CODIGO,"ZV3_DESCRI")
	oMSNewGe1:aCols[n,2]:=Posicione("ZV3",1,xFilial("ZV3")+M->ZV2_CODIGO,"ZV3_DESCRI")
endif*/
 
Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCVMBROWSERบAutor  ณMicrosiga           บ Data ณ  09/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GetLinOK()
	Local lRet := .T.

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCVMBROWSERบAutor  ณMicrosiga           บ Data ณ  09/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ZV1TudOK()
	Local lRet := .T.

Return(lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravaDados()  Autor  Denis Tsuchiya     บ Data ณ  08/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo de grava็ใo do Adiantamento                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	************************************
Static Function GravaDados(nOpca)
	************************************

	Local _aArea := GetArea()
	Local lRet := .F.
	Local aAux := aClone(oMSNewGe1:aCols)
	Local cAprovador := ccheque := ""
	Local _lSemAdiant:=.f.
	Local nd:= 0
	If nOpca == 4
		ExcluiZV1()
		Return()
	EndIf

//Pegando o numero do cheque
	DBSelectArea("SA6")
	DBSetOrder(1)
	DBSeek(xFilial("SA6")+"BPA")
	ccheque := STRZERO((VAL(SA6->A6_ULTCHQ)+1),10,0)
	RECLOCK("SA6",.F.)
	SA6->A6_ULTCHQ:=ccheque
	MSUnlock()

	If nOpca == 2 .or. nOpca == 7 //Incluir ou Prorrogar
		cAprovador:=U_RESPAPV(cCodSol,'G') //30/09/16

		if empty(alltrim(cAprovador))	//30/09/16 - valida็ใo do responsavel
			RETURN()
		Endif


		Begin Transaction

			_lSemAdiant:=iif(dDTFIM<=Date(),.T.,.F.) //30/11/16
			IF _lSemAdiant
				_lSemAdiant:=MSGYesNo("A data final da viagem ("+dtoc(dDTFIM)+") indica que a viagem jแ aconteceu. Deseja incluir a viagem sem gerar o adiantamento no financeiro (pagamento)?" )
			ENDIF

			//Gravando despesas de viagem
			nTotDesp := 0
			For nd:=1 to len(aAux)
				DBSelectArea("ZV2")
				Reclock("ZV2",.T.)
				ZV2->ZV2_FILIAL 	:= xFilial("ZV2")
				ZV2->ZV2_CODIGO 	:= aAux[nd][1]
				ZV2->ZV2_DESCRI 	:= aAux[nd][2]
				ZV2->ZV2_QUANT  	:= aAux[nd][3]

				if _lSemAdiant
					ZV2->ZV2_VALOR 	:= 0 //08/12/16
				else
					ZV2->ZV2_VALOR 	:= aAux[nd][4]
				Endif

				ZV2->ZV2_CODVIA 	:= SubStr(cCodSeq,1,6)
				ZV2->ZV2_SEQ  		:= SubStr(cCodSeq,8,3)
				nTotDesp += aAux[nd][4]
				MSUnlock()
			Next

			//Gravando o cabe็alho da viagem
			DBSelectArea("ZV1")
			Reclock("ZV1",.T.)
			ZV1->ZV1_FILIAL := xFilial("ZV1")
			ZV1->ZV1_COD    := SubStr(cCodSeq,1,6)
			ZV1->ZV1_SEQ    := SubStr(cCodSeq,8,3)
			ZV1->ZV1_TIPO   := IIf(nCbTipo==1,"S","T")
			ZV1->ZV1_CODSOL := cCodSol
			ZV1->ZV1_NSOLIC := cNomeSol
			ZV1->ZV1_EMISSA := dDatabase
			ZV1->ZV1_DTVENC := dDtSol // 13/10/16
			ZV1->ZV1_MATRIC := cMatFunc
			ZV1->ZV1_NFUNC  := cNomeFunc
			ZV1->ZV1_CC     := cCCusto
			ZV1->ZV1_DESCCC := cNomeCC
			ZV1->ZV1_MOTVIA := cMotVia
			ZV1->ZV1_DTINI  := dDTINI
			ZV1->ZV1_DTFIM  := dDTFIM
			ZV1->ZV1_OBS1   := cGetObs
			ZV1->ZV1_NIVEL  := Posicione("ZV4",1,xFilial("ZV4")+cMatFunc,"ZV4_NIVEL")
			ZV1->ZV1_ESTORI := cUFOrig
			ZV1->ZV1_CIDORI := cMunOrig
			ZV1->ZV1_NCORIG := cCidOrig
			ZV1->ZV1_ESTDES := cUFDest
			ZV1->ZV1_CIDDES := cMunDest
			ZV1->ZV1_NCDEST := cCidDest
			if _lSemAdiant //08/12/16
				ZV1->ZV1_TOTADI := 0
			ELSE
				ZV1->ZV1_TOTADI := nTotDesp
			ENDIF
			ZV1->ZV1_STATUS := IIF(_lSemAdiant, 'B' , '1' ) //30/11/16 //"1"
			ZV1->ZV1_CODSA2 := Posicione("ZV4",1,xFilial("ZV4")+cMatFunc,"ZV4_CODSA2")
			ZV1->ZV1_BANCO  := "BPA"
			ZV1->ZV1_AGENCI := "00000"
			ZV1->ZV1_CONTA  := "0000000000"
			ZV1->ZV1_CHEQUE := ccheque
			ZV1->ZV1_ADIANT := IIF(_lSemAdiant, 'N' , 'S' ) //30/11/16

			IF _lSemAdiant //30/11/16
				ZV1->ZV1_APROV1:=cAprovador
			ENDIF

			MSUnlock()
		End Transaction
		lRet := .T.
	EndIf

	If lRet
		IF !_lSemAdiant //30/11/16
			cViagem := SubStr(cCodSeq,1,6)
			cSeq := SubStr(cCodSeq,8,3)
			U_WFViagem(cViagem,cSeq,cAprovador)
			MSGInfo("Aprova็ใo do adiantamento enviada. Favor aguardar o retorno")
		ELSE
			MSGInfo("Inclusao da viagem feita com sucesso. Aguardando a presta็ใo de contas")
		ENDIF
	Else
		MSGSTOP("Problemas com a grava็ใo da solicita็ใo. ")
	EndIf

	RestArea(_aArea)
Return(lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExcluiZV1 บAutor  Denis Haruo       บ Data ณ  09/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExclusใo de Viagem                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	*****************************
Static Function ExcluiZV1()
	*****************************
	Local cViagem := ZV1->ZV1_COD
	Local cSeq := ZV1->ZV1_SEQ
	//Local lPA := IIF(!Empty(ZV1->ZV1_NUMPA),.T.,.F.)
	//Local aZV1 := {}
	//Local aZV2 := {}

//IF MSGYesNo("Tem certeza que deseja excluir esta viagem? O PA associado a ela tamb้m serแ excluido.")

	//Excluido o PA
  /*	If lPA
		U_ExcluiPAZV1(cViagem,cSeq)
	EndIf	*/
	
	DBSelectArea("ZV1")
	RecLock("ZV1",.F.)
	ZV1->(DBDelete())
	MSUnlock()
	
	DBSelectArea("ZV2")
	DBSetOrder(2)
	DBSeek(xFilial("ZV2")+cViagem+cSeq)
	Do While !ZV2->(EOF()) .and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA+ZV2->ZV2_SEQ == xFilial("ZV2")+cViagem+cSeq
		Reclock("ZV2",.F.)
		ZV2->(DBDelete())
		MSUnlock()
		DBskip()
	EndDo
	
	DBSelectArea("AC9")
	DBGotop()
	AC9->(DBSetOrder(2))//AC9_FILIAL, AC9_ENTIDA, AC9_FILENT, AC9_CODENT, AC9_CODOBJ
	//AC9->(DBseek(xFilial("AC9")+"ZV1"+XFILIAL("ZV1")+XFILIAL("ZV1")+PADR(_cChvZV1,TamSx3("AC9_CODENT")[1])+"0000000000" ))
	AC9->(DBseek(xFilial("AC9")+"ZV1"+XFILIAL("ZV1")+ALLTRIM(cViagem) ))
	Do While AC9->(EOF()) .AND. AC9->AC9_FILENT+alltrim(AC9->AC9_CODENT) == xFilial("ZV1")+ALLTRIM(cViagem) 
		if rtrim(AC9->AC9_ENTIDA)=='ZV1' 
			Reclock("AC9",.F.)
			AC9->(DBDelete())
			MSUnlock()
		endif
		AC9->(DBskip())
	EndDo


	MSGInfo("Viagem excluida.")

	//Comunicando o financeiro
	//U_WFExcluiZV1(lPA)
	
//Else
  //	Alert("Ufa! Ainda bem...")
//EndIf			

Return()      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDataRet()      บAutor  Denis Haruo      Data ณ  09/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida็ใo da data de retorno da viagem                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
	**************************
Static Function DataRet()
	**************************
	Local nDias := dDtFim - dDtIni
	Local lRet := .T.

	If nDias < 0
		MSGInfo("Data de retorno invalida.","DataRet()")
		lRet := .F.
	Else
		nTotDias := nDias
		oTotDias:Refresh()
	EndIf

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidaMat  บAutor  Denis Haruo          บ Data ณ  09/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida a matricula do funcionario                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/    
	****************************
Static Function ValidaMat()
	****************************
	Local lRet := .T.
	Local _aRetAdto:={} //09/08/17

	IF _lALEner //26/07/17
		//alert(cMatFunc)


		cNomeFunc := Posicione("SA2",1,xFilial("SA2")+cMatFunc,"A2_NREDUZ")

		if empty(alltrim(cNomeFunc))//27/09/17
			alert("Fornecedor "+cMatFunc+" nใo cadastrado! Verifique se o Codigo+Loja foram informados corretamente! ")
			return .f.
		endif

		//alert(cNomeFunc)
		oNomeFunc:Refresh()

		_aRetAdto:=RetAdtPres(cMatFunc)

		//Verifica็ใo de PAs abertas para o fornecedor - 09/08/17
		_cTitADto:=""
		_cVlrAdto:=""
		if len(_aRetAdto)>0
			_cTitADto:=_aRetAdto[1,1]
			_cVlrAdto:=Transform(_aRetAdto[1,2],"@E 999,999,999.99")
		endif
		oTitADto:Refresh()
		oVlrAdto:Refresh()

	ELSE

		DBSelectArea("ZV4")
		DBSetOrder(1)
		If DBSeek(xFilial("ZV4")+cMatFunc,.F.)
			cCCusto := ZV4->ZV4_CC
			IF RTRIM(cCodSol)<>RTRIM(ZV4->ZV4_CODUSR) //Caso o beneficiario nใo seja o proprio solicitante  - Fabio Yoshioka - 29/09/16

				//Verifico se sใo do mesmo centro de custo ou que o solicitante seja do RH
				if !ValSolic(cCodSol,ZV4->ZV4_CC)
					MSGStop("Solicitante sem premissao para incluir adiantamentos para colaborador do centro de custo "+ZV4->ZV4_CC+" !")
					lRet := .F.
				endif
			ENDIF

			If lRet .and. Empty(ZV4->ZV4_CODSA2)
				MSGStop("Colaborador nใo cadastado na tabela de Fornecedores. ","ValidaMat()")
				lRet := .F.
			EndIf

		/*If lRet .and. Empty(ZV4->ZV4_CODSA1) //COMENTADO EM 01/12/16
			MSGStop("Colaborador nใo cadastado na tabela de Clientes. ","ValidaMat()")
			lRet := .F.
		EndIf	 */	  
	
		
		If lRet  .AND. (Empty(ZV4->ZV4_BANCO) .OR. Empty(ZV4->ZV4_AGENCI) .OR. Empty(ZV4->ZV4_NUMCON) ) //13/10/16
			MSGStop("Informa็๕es bancarias do colaborador nใo estใo cadastradas! ","ValidaMat()")
			lRet := .F.
		Endif
		
	Else
		MSGStop("Matricula invแlida.","ValidaMat()")
		lRet := .F.
	EndIf   
	
	If lRet 
		if empty(alltrim(U_RESPAPV(cCodSol,'G')))	//30/09/16 - valida็ใo do responsavel 
	
			lRet := .F.	
		endif
	Endif
	
	If lRet 
		cNomeCC := Posicione("CTT",1,xFilial("CTT")+cCCusto,"CTT_DESC01")
		oCCusto:Refresh()
		oNomeCC:Refresh()
	EndIf
ENDIF

Return(lret) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidCC   บAutor  ณDenis Haruo         บ Data ณ  09/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida o CCusto da viagem                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/    
Static Function ValidCC()

	Local lRet := .T.

	If Alltrim(cCCusto) == ""
		MSGStop("Favor preencher o campo มrea de Lota็ใo")
		lRet := .F.
	Else
		If !ExistCpo("CTT",cCCusto)
			MSGStop("มrea de Lota็ใo invแlida")
			lRet := .F.
		EndIf
	EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMotVia   บAutor  Denis Haruo         บ Data ณ  09/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida o motivo da viagem                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MotVia()
	Local lRet := .T.

	If Len(Alltrim(cMotVia)) < 10
		MSGStop("Favor informar o motivo da viagem (min 10 caractres).","MotVia()")
		lRet := .F.
	EndIf

Return(lRet)


Static Function ValSolic(_cCodSoli,_cCCColab) //VALIDAวรO CASO O SOLICITANTE SEJA DIFERENTE DO COLABORADOR - FABIO YOSHIOKA - 29/09/16

	Local _lRetSol:=.F.
	Local _cCCAll:=GETMV("AL_CCALLB") //Modulo (RH) do sistema que permitira a inclusao de adiantamentos de funcionarios de qualquer outro modulo -29/09/16

	_cQryZV4 := " "
	_cQryZV4 += " SELECT ZV4_CC "
	_cQryZV4 += " FROM "+RetSQLName("ZV4")+" "
	_cQryZV4 += " WHERE	ZV4_FILIAL = '"+xFilial("ZV4")+"'"
	_cQryZV4 += " AND	D_E_L_E_T_ <> '*'"
	_cQryZV4 += " AND ZV4_CODUSR='"+rtrim(_cCodSoli)+"'"
	DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQryZV4), "TZV4", .F., .T.)
	IF !TZV4->(BOF()) .AND. !TZV4->(EOF())
		IF RTRIM(TZV4->ZV4_CC) $ _cCCAll
			_lRetSol:=.T.
		ELSE
			IF RTRIM(TZV4->ZV4_CC)==RTRIM(_cCCColab)//MESMO CENTRO DE CUSTO BENEF E SOLICI
				_lRetSol:=.T.
			ENDIF
		ENDIF
	ENDIF
	TZV4->(DBCLOSEAREA())

Return _lRetSol


User Function RESPAPV(_cUsSolic,_cCargApv) //30/09/16

	Local _cCodApv:=""
	Local _cGrpApv:=""
	Local _lretApv:=.T.

	_cQuery := " "
	_cQuery += "SELECT AI_GRPAPRO FROM "+RetSQLName("SAI")+" "
	_cQuery += "WHERE	AI_FILIAL = '"+xFilial("SAI")+"' AND "
	_cQuery += "			AI_USER = '"+_cUsSolic+"' AND "
	_cQuery += "			D_E_L_E_T_ <> '*' "
	_cQuery := ChangeQuery(_cQuery)
	DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TSAI", .F., .T.)
	IF !TSAI->(EOF()) .AND.  !TSAI->(BOF())
		if !empty(alltrim(TSAI->AI_GRPAPRO))
			_cGrpApv:=TSAI->AI_GRPAPRO
		else
			_lretApv:=.F.
		endif
	ELSE
		_lretApv:=.F.
	ENDIF
	TSAI->(DBCloseArea())

	if !_lretApv
		MSGINFO("Usuแrio nใo cadastrado no Grupo de Compras, ou Grupo nใo encontrado.","RESPAPV")
	EndIf

	If _lretApv
		//...Pesquiso pelo Gerente do setor
		_cQueryG := ""
		_cQueryG += "SELECT AL_USER FROM "+RetSQLName("SAL")+" "
		_cQueryG += "WHERE	AL_FILIAL = '"+xFilial("SAL")+"' AND "
		_cQueryG += "			AL_CARGO = '"+rtrim(_cCargApv)+"' AND " //GERENTE QUE FAZ APROVAวรO
		_cQueryG += "			AL_COD = '"+_cGrpApv+"' AND "
		_cQueryG += "			D_E_L_E_T_ <> '*' AND "
		_cQueryG += "			AL_STATUS<>'D'
		_cQueryG += "			ORDER BY AL_NIVEL "
		_cQueryG := ChangeQuery(_cQueryG)
		DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQueryG), "TSAL", .F., .T.)
		IF !TSAL->(EOF()) .AND. !TSAL->(BOF())
			IF !EMPTY(ALLTRIM(TSAL->AL_USER))
				_cCodApv:=AL_USER
			ELSE
				_lretApv:=.F.
			ENDIF
		ELSE
			_lretApv:=.F.
		ENDIF
		TSAL->(DBCLOSEAREA())

		if !_lretApv
			MSGINFO("Aprovador nใo encontrado no Grupo de aprovacao "+_cGrpApv+".","RESPAPV")
		endif

	Endif

Return _cCodApv

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณStartWFZV1 บAutor  Denis Haruo       บ Data ณ  08/11/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณReenvia o Processo de aprova็ใo de uma viagem               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function StartWFZV1(cViagem,cSeq)

	Local cUpdate := ""
	Local cAprovador:= ""
	Local cViagem := ZV1->ZV1_COD
	Local cSeq := ZV1->ZV1_SEQ

//Limpando os dados de aprova็ใo gravados
	cUpdate := ""
	cUpdate += " 	UPDATE "+RetSQLName("ZV1")+" "
	cUpdate += "	SET 	ZV1_APROV1 = '', "
	cUpdate += "			ZV1_NAPRO1 = '', "
	cUpdate += "			ZV1_DTAPR1 = '', "
	cUpdate += "			ZV1_HRAPR1 = '', "

	cUpdate += "		 	ZV1_APROV2 = '', "
	cUpdate += "			ZV1_NAPRO2 = '', "
	cUpdate += "			ZV1_DTAPR2 = '', "
	cUpdate += "			ZV1_HRAPR2 = '', "

	cUpdate += "		 	ZV1_BANCO = '', "
	cUpdate += "			ZV1_AGENCI = '', "
	cUpdate += "			ZV1_CONTA = '', "
	cUpdate += "			ZV1_CHEQUE = '', "
	cUpdate += "			ZV1_DTCHEQ = '', "
	cUpdate += "			ZV1_STATUS = '1' "

	cUpdate += "	WHERE ZV1_FILIAL = '"+xFilial("ZV1")+"' AND "
	cUpdate += "			ZV1_COD = '"+cViagem+"' AND "
	cUpdate += "			ZV1_SEQ = '"+cSeq+"' AND "
	cUpdate += "			D_E_L_E_T_ <> '*' "
	TcSqlExec(cUpdate)

	cAprovador := Posicione("SAK",1,xFilial("SAK")+(POSICIONE("CTT",1,xFilial("CTT")+ZV1->ZV1_CC,"CTT_RESP")),"AK_USER")
	IF Alltrim(cAprovador) <> ""
		U_WFViagem(cViagem,cSeq,cAprovador)
		MSGInfo("Aprova็ใo do adiantamento enviada. Favor aguardar o retorno")
	Else
		MSGStop("Email do analista financeiro nใo encontrado. Corrija e reenvie a solicita็ใo.")
	EndIf

/*
cQuery := ""
cQuery += "SELECT * FROM "+RetSQLName("ZPB")+" "
cQuery += "WHERE 	ZPB_FILIAL = '"+xFilial("ZPB")+"' AND "
cQuery += "			ZPB_CARGO = 'A' AND "
cQuery += "			D_E_L_E_T_ <> '*' "
TCQuery cQuery NEW ALIAS "APR"
DBSelectArea("APR")
IF !EOF()
	cAprovador := APR->ZPB_CODUSR
	U_WFViagem(cViagem,cSeq,cAprovador)
	MSGInfo("Aprova็ใo do adiantamento enviada. Favor aguardar o retorno")
Else
	MSGStop("Email do analista financeiro nใo encontrado. Corrija e reenvie a solicita็ใo.")
EndIf
DBSelectArea("APR")
APR->(DBCloseArea())
*/
Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraTitPC บAutor  Denis Haruo          บ Data ณ  08/14/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera็ใo do Titulo a Receber no Financeiro                   บฑฑ
ฑฑบ          ณpara compesa็ใo das despesas de viagem                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GeraTitPC(cViagem,cSeq)
	Local _lTitComp     := .f.
	Local _lTemSe2      := .f.
	Local _lSemAdiant   := .f. //iif(RTRIM(UPPER(ZV1_ADIANT))<>'N',.F.,.T.) //30/11/16
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .F.
	Private _cNatuPA    := GetMV("AL_NATURPA") //10/08/16
	Private _cTiPA3     := GetMV("AL_TIPOPA3") //04/11/16
	PRIVATE _cDirErrDoc := GetSrvProfString("Startpath","")
	Private _nTotAdia   := 0
	Private _nTotPres   := 0

	CONOUT("GERATITPC1")

	DBSelectArea("ZV1")
	DBSetOrder(1)
	DBSeek(xFilial("ZV1")+cViagem+cSeq)

	_nTotAdia:=ZV1->ZV1_TOTADI
	_nTotPres:=ZV1->ZV1_TOTRET
	_lSemAdiant:=iif(RTRIM(UPPER(ZV1->ZV1_ADIANT))<>'N',.F.,.T.) //30/11/16

	CONOUT("GERATITPC2")

	IF !_lSemAdiant //CASO TENHA ADIANTAMENTO

		_cQrySE2 := " "
		_cQrySE2 += "SELECT * FROM "+RetSQLName("SE2")+" "
		_cQrySE2 += "WHERE	E2_FILIAL = '"+xFilial("SE2")+"' AND "
//		_cQrySE2 += "			E2_PREFIXO = 'PA2' AND "
		_cQrySE2 += "			E2_PREFIXO = 'GVI' AND " //30/11/16
		_cQrySE2 += "			E2_PARCELA = '2' AND "		//15/11/16
		_cQrySE2 += "			E2_NUM = '"+STRZERO(val(ZV1->ZV1_COD),9)+"' AND "
		_cQrySE2 += "			E2_TIPO = '"+rtrim(_cTiPA3)+"' AND "
		_cQrySE2 += "			E2_FORNECE = '"+SUBSTR(ZV1->ZV1_CODSA2,1,6)+"' AND "
		_cQrySE2 += "			E2_LOJA = '"+SUBSTR(ZV1->ZV1_CODSA2,7,2)+"' AND "
		_cQrySE2 += "			D_E_L_E_T_ <> '*' "
		DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQrySE2), "TSE2", .F., .T.)
		IF !TSE2->(EOF()) .AND. !TSE2->(BOF())
			_lTemSe2:=.T.
			_lTitComp:=.T.
		ENDIF

		IF !_lTemSe2
			aTitulo := {}
			CONOUT("GERATITPC3")

			//INCLUSAO DE TITULO  definifivo - 04/11/16 - COMPENSAR A PA  - VALOR DA PRESTAวรO DE CONTAS - 01/12/16
			aTitulo :={ {"E2_FILIAL" ,xFilial("ZPA") ,Nil},;
				{"E2_PREFIXO"                     , "GVI"                       , Nil},;
				{"E2_NUM"                         , STRZERO(val(ZV1->ZV1_COD),9), Nil},;
				{"E2_PARCELA"                     , "2"                         , Nil},;
				{"E2_TIPO"                        , _cTiPA3                     , Nil},;
				{"E2_NATUREZ"                     , _cNatuPA                    , Nil},;
				{"E2_FORNECE"                     , SUBSTR(ZV1->ZV1_CODSA2,1,6) , Nil},;
				{"E2_LOJA"                        , SUBSTR(ZV1->ZV1_CODSA2,7,2) , Nil},;
				{"E2_EMISSAO"                     , dDataBase                   , NIL},;
				{"E2_VENCTO"                      , dDataBase                   , NIL},;
				{"E2_VENCREA"                     , dDataBase                   , NIL},;
				{"E2_VALOR"                       , ZV1->ZV1_TOTRET             , Nil},;
				{"E2_VLCRUZ"                      , ZV1->ZV1_TOTRET             , Nil},;
				{"E2_STATWF"                      , "LB"                        , Nil},;
				{"E2_CC"                          , ZV1->ZV1_CC                 , Nil}}


			*****************************
			//Inicio a inclusใo do titulo
			*****************************
			lMsErroAuto := .F.
			Conout("Executando EXECAUTO "+STRZERO(val(ZV1->ZV1_COD),9))
			MSExecAuto({|x,y,z| Fina050(x,y,z)},aTitulo,,3) //Inclusao
			///////
			/*
			RECLOCK("SE2",.T.)
			E2_FILIAL  := xFilial("SE2")
			E2_PREFIXO := "GVI"
			E2_NUM     := STRZERO(val(ZV1->ZV1_COD),9)
			E2_PARCELA := "2"
			E2_TIPO    := _cTiPA3
			E2_NATUREZ := _cNatuPA
			E2_FORNECE := SUBSTR(ZV1->ZV1_CODSA2,1,6)
			E2_LOJA    := SUBSTR(ZV1->ZV1_CODSA2,7,2)
			E2_EMISSAO := dDATABASE
			E2_VENCTO  := ctod(_cDatVencto)
			E2_VENCREA := ctod(_cDatVencto)
			E2_VALOR   := ZV1->ZV1_TOTRET
			E2_VLCRUZ  := ZV1->ZV1_TOTRET
			E2_SALDO   := ZV1->ZV1_TOTRET
			E2_HIST    := "Reemb Desp "+rtrim(cNomFavo)
			E2_EMIS1   := DDATABASE
			E2_VENCORI := dDataBase
			E2_MOEDA   := 1
			E2_STATWS := "LB"
			E2_CC := ZV1->ZV1_CC
			MSUNLOCK()
			*/
			If lMsErroAuto
				CONOUT("GERATITPC4")
				//Caso encontre erro, mostre
				//MostraErro()
				Conout("Erro do EXECAUTO "+STRZERO(val(ZV1->ZV1_COD),9))

				_cHorErr := TIME()
				_cLogErr :="LOG_ERR_XML_"+substr(DTOS(DDATABASE),7,2)+"-"+substr(DTOS(DDATABASE),5,2)+"-"+substr(DTOS(DDATABASE),1,4)+"-"+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2)
				FERASE(_cDirErrDoc+"\"+_cLogErr+".TXT")
				MostraErro(_cDirErrDoc,_cLogErr+".TXT")

			Else
				CONOUT("GERATITPC5")
				_lTitComp:=.T.
				Conout("Exito na Grava็ใo da NF P CONTA da Viagem: ")
					/*DBSelectArea("ZV1")
					Reclock("ZV1",.F.)
					ZV1->ZV1_EMISPA := dDatabase
					MSUnlock()    */
				EndIf	
		ELSE                          
			CONOUT("GERATITPC6")
				Conout("Titulo de compensa็ใo de PA ja existente "+STRZERO(val(ZV1->ZV1_COD),9))		
		ENDIF		       
		
		
		IF _lTitComp //CASO TENHA GRAVADO O TITULO DE COMPษNSAวรO - 04/11/16
			CONOUT("GERATITPC7")
			
			IF U_ExecCompCV(cViagem,cSeq)	
				DBSelectArea("ZV1")
				DBSetOrder(1)
				DBSeek(xFilial("ZV1")+cViagem+cSeq)         
				
				//NรO GERO MAIS TITULO A RECEBER - 01/12/16
				//PARA MINIMIZAR PROBLEMAS NO CADASTRO DE CLIENTES (DEIXO A PA COM SALDO)			
				/*IF _nTotAdia>_nTotPres // GERAR CONTAS A RECEBER DO SALDO   
				
					aTitulo :={}				
					aTitulo := { { "E1_PREFIXO"  , "GVI" 			              , NIL },;
									{ "E1_NUM"      , STRZERO(val(ZV1->ZV1_COD),9)            , NIL },;
									{ "E1_TIPO"     , "NF"    							           , NIL },;
									{ "E1_NATUREZ"  , _cNatuPA             						  , NIL },;
									{ "E1_PARCELA"  , '3'		             						  , NIL },;     		       
									{ "E1_CLIENTE"  , SUBSTR(ZV1->ZV1_CODSA1,1,6)      		  , NIL },;
									{ "E1_LOJA"     , SUBSTR(ZV1->ZV1_CODSA1,7,2)				  , NIL },;     		       
									{ "E1_EMISSAO"  , dDatabase										  , NIL },;
									{ "E1_VENCTO"   , dDatabase										  , NIL },;
									{ "E1_VENCREA"  , dDatabase									     , NIL },;
									{ "E1_VALOR"    , _nTotAdia-_nTotPres    		           , NIL } }
					
					*****************************	
					//Inicio a inclusใo do titulo
					*****************************	
					lMsErroAuto := .F.
					Conout("Executando EXECAUTO "+STRZERO(val(ZV1->ZV1_COD),9))
					MSExecAuto({|x,y,z| FINA040(x,y,z)},aTitulo,,3) //Inclusao  

					If lMsErroAuto 

						CONOUT("TITULO_FINAL "+STRZERO(val(ZV1->ZV1_COD),9))                 
						//Caso encontre erro, mostre
						//MostraErro()
						Conout("Erro do EXECAUTO "+STRZERO(val(ZV1->ZV1_COD),9))  

						_cHorErr := TIME()
						_cLogErr :="LOG_ERR_XML_"+substr(DTOS(DDATABASE),7,2)+"-"+substr(DTOS(DDATABASE),5,2)+"-"+substr(DTOS(DDATABASE),1,4)+"-"+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2)
						FERASE(_cDirErrDoc+"\"+_cLogErr+".TXT")
						MostraErro(_cDirErrDoc,_cLogErr+".TXT")
					EndIf	*/

				/*     NรO GERO MAIS TITULO A PAGAR
				IF _nTotAdia<_nTotPres // GERAR CONTAS A PAGAR COM O SALDO 

					aTitulo :={}				
					aTitulo :={	{"E2_FILIAL"	,xFilial("ZPA")			,Nil},;
								{"E2_PREFIXO"		,"GVI" 									,Nil},;
								{"E2_NUM"      	,STRZERO(val(ZV1->ZV1_COD),9)		,Nil},;
								{"E2_PARCELA"  	,"3"										,Nil},;
								{"E2_TIPO"     	,_cTiPA3									,Nil},;               
								{"E2_NATUREZ"  	,_cNatuPA								,Nil},;
								{"E2_FORNECE"  	,SUBSTR(ZV1->ZV1_CODSA2,1,6)   	,Nil},; 
								{"E2_LOJA"     	,SUBSTR(ZV1->ZV1_CODSA2,7,2)		,Nil},;      
								{"E2_EMISSAO"  	,dDataBase								,NIL},;
								{"E2_VENCTO"   	,dDataBase								,NIL},;                          
								{"E2_VENCREA"  	,dDataBase								,NIL},;                                                   
								{"E2_VALOR"    	,_nTotPres-_nTotAdia					,Nil},;
								{"E2_VLCRUZ"		,_nTotPres-_nTotAdia 				,Nil},; 
								{"E2_STATWF" 		,"LB"										,Nil},;
								{"E2_CC"     		,ZV1->ZV1_CC							,Nil}}

							*****************************	
							//Inicio a inclusใo do titulo
							*****************************	                                                          ?
							lMsErroAuto := .F.
							Conout("Executando EXECAUTO "+STRZERO(val(ZV1->ZV1_COD),9))
							MSExecAuto({|x,y,z| Fina050(x,y,z)},aTitulo,,3) //Inclusao  

							If lMsErroAuto 
								CONOUT("TITULO_FINAL "+STRZERO(val(ZV1->ZV1_COD),9))                 
								//Caso encontre erro, mostre
								//MostraErro()
								Conout("Erro do EXECAUTO "+STRZERO(val(ZV1->ZV1_COD),9))  

								_cHorErr := TIME()
								_cLogErr :="LOG_ERR_XML_"+substr(DTOS(DDATABASE),7,2)+"-"+substr(DTOS(DDATABASE),5,2)+"-"+substr(DTOS(DDATABASE),1,4)+"-"+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2)
								FERASE(_cDirErrDoc+"\"+_cLogErr+".TXT")
								MostraErro(_cDirErrDoc,_cLogErr+".TXT")
							EndIf	
				
				ENDIF*/
				
			ENDIF
			
		ENDIF

ELSE //CASOS QUE NรO HOUVE ADIANTAMENTO - GERO O VALOR A PAGAR DA PRESTAวรO DE CONTAS
		contadeb :=  POSICIONE("ZV2",1,xFilial("ZV2") + ZV1->ZV1_COD ,"ZV2_CONTA")
		aTitulo :={}				
		aTitulo :={{"E2_FILIAL" ,xFilial("ZPA") ,Nil},;
					{"E2_PREFIXO"                     , "GVI"                       , Nil},;
					{"E2_NUM"                         , STRZERO(val(ZV1->ZV1_COD),9), Nil},;
					{"E2_PARCELA"                     , "3"                         , Nil},;
					{"E2_TIPO"                        , _cTiPA3                     , Nil},;
					{"E2_NATUREZ"                     , _cNatuPA                    , Nil},;
					{"E2_FORNECE"                     , SUBSTR(ZV1->ZV1_CODSA2,1,6) , Nil},;
					{"E2_LOJA"                        , SUBSTR(ZV1->ZV1_CODSA2,7,2) , Nil},;
					{"E2_EMISSAO"                     , dDataBase                   , NIL},;
					{"E2_VENCTO"                      , dDataBase                   , NIL},;
					{"E2_VENCREA"                     , dDataBase                   , NIL},;
					{"E2_VALOR"                       , _nTotPres                   , Nil},;
					{"E2_VLCRUZ"                      , _nTotPres                   , Nil},;
					{"E2_STATWF"                      , "LB"                        , Nil},;
					{"E2_CC"                          , ZV1->ZV1_CC                 , Nil},;
					{"E2_CTADEBD"                     , contadeb                    , Nil}}

		*****************************	
		//Inicio a inclusใo do titulo
		*****************************	
		lMsErroAuto := .F.
		Conout("Executando EXECAUTO "+STRZERO(val(ZV1->ZV1_COD),9))
		MSExecAuto({|x,y,z| Fina050(x,y,z)},aTitulo,,3) //Inclusao  
		/*
		RECLOCK("SE2",.T.)
		E2_FILIAL  := xFilial("SE2")
		E2_PREFIXO := "GVI"
		E2_NUM     := STRZERO(val(ZV1->ZV1_COD),9)
		E2_PARCELA := "3"
		E2_TIPO    := _cTiPA3
		E2_NATUREZ := _cNatuPA
		E2_FORNECE := SUBSTR(ZV1->ZV1_CODSA2,1,6)
		E2_LOJA    := SUBSTR(ZV1->ZV1_CODSA2,7,2)
		E2_EMISSAO := dDATABASE
		E2_VENCTO  := ctod(_cDatVencto)
		E2_VENCREA := ctod(_cDatVencto)
		E2_VALOR   := _nTotPres
		E2_VLCRUZ  := _nTotPres
		E2_SALDO   := _nTotPres
		//E2_HIST    := "Reemb Desp "+rtrim(cNomFavo)
		E2_EMIS1   := DDATABASE
		E2_VENCORI := dDataBase
		E2_MOEDA   := 1
		E2_STATWS := "LB"
		E2_CC := ZV1->ZV1_CC
		E2_CTADEBD := contadeb
		MSUNLOCK()
		*/

				If lMsErroAuto
					CONOUT("TITULO_FINAL "+STRZERO(val(ZV1->ZV1_COD),9))
					//Caso encontre erro, mostre
					//MostraErro()
					Conout("Erro do EXECAUTO "+STRZERO(val(ZV1->ZV1_COD),9))

					_cHorErr := TIME()
					_cLogErr :="LOG_ERR_XML_"+substr(DTOS(DDATABASE),7,2)+"-"+substr(DTOS(DDATABASE),5,2)+"-"+substr(DTOS(DDATABASE),1,4)+"-"+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2)
					FERASE(_cDirErrDoc+"\"+_cLogErr+".TXT")
					MostraErro(_cDirErrDoc,_cLogErr+".TXT")
				ELSE

					DBSelectArea("ZV1")
					Reclock("ZV1",.F.)
					ZV1->ZV1_STATUS := '7'   //STATUS DE FINALIZADO
					MSUnlock()

				EndIf

			ENDIF

			Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF050TMP1   บAutor  ณDenis Haruo        บ Data ณ  09/23/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRateio das despesas                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*User Function F050TMP1() 
     
//U_GeraTitPC("000057","001")

Local _aArea := GetArea() 
Local _nOrig := ParamIxb[9]  
Local _nTotAdi := 0
Local _cCDebito := ""

DBSelectArea("ZV1")         
_nTotAdi := ZV1->ZV1_TOTADI 
_cCCD := ZV1->ZV1_CC 
_cItemD := ZV1->ZV1_CODSA2

Do Case  
	Case Val(ZV1->ZV1_CC) >= 100 .and. Val(ZV1->ZV1_CC) <= 299
		_cCDebito := '3102141005'
	Case Val(ZV1->ZV1_CC) >= 300 .and. Val(ZV1->ZV1_CC) <= 399
		_cCDebito := '3103141005'
	Case Val(ZV1->ZV1_CC) >= 400
		_cCDebito := '3103241005'
End Case

If _nOrig == 2  
	DBSelectArea("ZV2")
	DBSetOrder(2)
	DBSeek(xFilial("ZV2")+ZV1->ZV1_COD+ZV1->ZV1_SEQ) 
	Do While !EOF() .and. ZV2->ZV2_FILIAL+ZV2_CODVIA+ZV2_SEQ == xFilial("ZV2")+ZV1->ZV1_COD+ZV1->ZV1_SEQ 
		
		//Item 000 - O proprio adiantamento.
		IF ZV2->ZV2_CODIGO == '000'
			DBSkip()
			Loop
		EndIf           

		DbSelectArea("TMP") 
		RecLock("TMP",.T.) 
		CTJ_DEBITO	:= _cCDebito
		CTJ_HIST		:= ZV2->ZV2_DESCRI
		CTJ_VALOR 	:= ZV2->ZV2_VALOR
     	CTJ_PERCEN	:= (ZV2->ZV2_VALOR * 100)/_nTotAdi    
		CTJ_CCD		:= _cCCD
		CTJ_ITEMD	:= _cItemD
		CTJ_FLAG		:= .F. 
		MsUnLock() 
		DBSelectArea("ZV2")
		DBskip()
	EndDo
EndIf 

RestArea(_aArea) 
Return{_nTotAdi,0} */

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidaExc บAutor  Denis Haruo         บ Data ณ  08/27/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida se a Viagem pode ser excluida.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

/*User function ValidaExc()

Local lRet := .T.
Local cPrefixo := ZV1->ZV1_PREFIX
Local cNumPA := ZV1->ZV1_NUMPA

DBSelectArea("SE2")
DBSetOrder(1)
If DBseek(xFilial("SE2")+cPrefixo+cNumPA) 
	cMsg := ""
	cMsg += "Esta viagem nใo pode ser alterada pois jแ possui um adiantamento no contas a pagar. Exclua o adiantamento para alterar."
	MSGStop(cMsg,"ValidaExc()")
	lRet := .F.
EndIf

Return(lRet)*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExcluiPAZV1   Autor  Denis Haruo       บ Data ณ  09/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExclui o PA vinculado a viagem                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RAILEC                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ExcluiPAZV1(cViagem,cSeq)

	//Local _aArea := GetArea()

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .F.
/*
//Desabilitando a visualiza็ใo do Lan็amento Contab.
DBSELECTAREA("SX1")
DBSetOrder(1)
DBSeek("FIN050    "+"01")
RecLock("SX1",.F.)
 (cAliasTmp)->(X1_PRESEL) := 2 //Mostra Lancto = Nใo
MSUnlock()	

DBSeek("FIN050    "+"04")
RecLock("SX1",.F.)
 (cAliasTmp)->(X1_PRESEL) := 2 //Contabiliza on Line = NAO         
MSUnlock()	

DBSeek("FIN050    "+"05")
RecLock("SX1",.F.)
(cAliasTmp)->(X1_PRESEL) := 1 //Gerar Chq.p/Adiant. = SIM                  
MSUnlock()	

DBSeek("FIN050    "+"09")
RecLock("SX1",.F.)
(cAliasTmp)->(X1_PRESEL) := 1 //Mov.Banc.sem Cheque = SIM              
MSUnlock()	
/*/
//Inclusใo do Titulo no SE2 ap๓s a liberado 
Conout("Entrando em ZV1")
DBSelectARea("ZV1") 
IF DBSeek(xFilial("ZV1")+cViagem+cSeq,.F.)

	aTitulo := {}
	aTitulo :={	{"E2_FILIAL"	,xFilial("ZV1"),Nil},;
				{"E2_PREFIXO"	,ZV1->ZV1_PREFIX,Nil},;
				{"E2_NUM"      ,ZV1->ZV1_NUMPA,Nil},;
				{"E2_PARCELA"	,ZV1->ZV1_PARCEL,Nil},;
				{"E2_TIPO"		,ZV1->ZV1_TIPOPA,Nil},;               
				{"E2_FORNECE"  ,SUBSTR(ZV1->ZV1_CODSA2,1,6),Nil},; 
				{"E2_LOJA"     ,SUBSTR(ZV1->ZV1_CODSA2,7,2),Nil}}

	*****************************	
	//Inicio a inclusใo do titulo
	*****************************	
	lMsErroAuto := .F.
	Conout("Executando EXECAUTO EXCLUSAO "+ZV1->ZV1_NUMPA)
	MSExecAuto({|x,y,z| Fina050(x,y,z)},aTitulo,,5) //Exclusใo

	If lMsErroAuto                
		//Caso encontre erro, mostre
	  	//MostraErro()
		Conout("Erro do EXECAUTO "+ZV1->ZV1_NUMPA)
	Else    
		Conout("Exito na Grava็ใo do Adiantamento da Viagem: ")
	EndIf	

EndIf
/*      
//Reabilitando a visualiza็ใo do Lan็amento Contab.
DBSELECTAREA("SX1")
DBSetOrder(1)
DBSeek("FIN050    "+"01")
RecLock("SX1",.F.)
 (cAliasTmp)->(X1_PRESEL) := 1 //Mostra Lancto = SIM
MSUnlock()	
    
DBSeek("FIN050    "+"04")
RecLock("SX1",.F.)
 (cAliasTmp)->(X1_PRESEL) := 1 //Contabiliza on Line = SIM         
MSUnlock()	

DBSeek("FIN050    "+"05")
RecLock("SX1",.F.)
 (cAliasTmp)->(X1_PRESEL) := 1 //Gerar Chq.p/Adiant. = SIM                  
MSUnlock()	

DBSeek("FIN050    "+"09")
RecLock("SX1",.F.)
 (cAliasTmp)->(X1_PRESEL) := 1 //Mov.Banc.sem Cheque = SIM              
MSUnlock()	
/*/
Conout("Fim da Rotina RetAutPA")

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGP010FIMPE() บAutor  Denis Haruo     บ Data ณ  09/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada ap๓s a inclusใo do cadastro de funcionario      บฑฑ
ฑฑบ          ณpara gravar os dados na tabela de colaboradores do
					controlde de viagens                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RAILEC                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GP010FIMPE()


Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  IniciaZV4  บAutor  ณDenis Haruo          บ Data ณ  07/29/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarga inicial de colaboradores para o cadastro de viagens   บฑฑ
ฑฑบ          ณ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//User Function IniciaZV4()     
	**********************************
User Function IniciaZV4(_cCodUsr)//21/09/16
	**********************************

	//Local _lBloqueado := .F.
	Local _lRetZV4    :=.t. //21/09/16
	Local _aAreaZV4	:= GetArea()
	//Local _cModulos	:="" //29/09/16
	Local _cDtHrPZV4	:=GETMV("AL_ULTPZV4")//29/09/16
	Local _nHrsPrZV4	:=GETMV("AL_HRSPZV4") //29/09/16
	Local _cElapsed	:=ELAPTIME(substr(_cDtHrPZV4,9,2)+":"+substr(_cDtHrPZV4,11,2)+":00",Time())
	Local _nTempMin   :=(val(substr(_cElapsed,1,2))*60)+val(substr(_cElapsed,4,2)) //converto o tempo em minutos
	Local _nHrLstZV4	:=((dDatabase - STOD(substr(_cDtHrPZV4,1,8))) * 24) + iif(_nTempMin>0,(_nTempMin/60),0)
	Local _lProcsZV4  :=iif(_nHrLstZV4>=_nHrsPrZV4,.T.,.F.)
	Local aAllUser    :=IIF(_lProcsZV4 .OR. _lAtManSol,&('AllUsers()'),{})
	Local _cCodVet		:=""
	Local _cBco:="" //13/10/16
	Local _cAgenci:=""
	Local _cNumcon:=""
	Local _nPUser := 0


//if empty(alltrim(_cCodUsr)) //21/09/16

	if _lProcsZV4 .or. _lAtManSol//29/09/16

		PUTMV("AL_ULTPZV4",dtos(dDatabase)+substr(Time(),1,2)+substr(Time(),4,2)) //Execu็ใo da atualiza็ใo  definida em intervalo de horas no parametro - 29/09/16

		_cQrySRA := " "
		_cQrySRA += " SELECT RA_CATFUNC,RA_CATEG,RA_MAT,RA_CC,RA_CIC,RA_CC,RA_NOME, "
		_cQrySRA += " (SELECT TOP 1 A1_COD+A1_LOJA FROM "+RETSQLNAME("SA1")+" WHERE D_E_L_E_T_<>'*' AND A1_CGC=RA_CIC AND A1_FILIAL='"+XFILIAL("SA1")+"') AS A1_COD,"
		_cQrySRA += " (SELECT TOP 1 A2_COD+A2_LOJA FROM "+RETSQLNAME("SA2")+" WHERE D_E_L_E_T_<>'*' AND A2_CGC=RA_CIC AND A2_FILIAL='"+XFILIAL("SA2")+"') AS A2_COD"
		_cQrySRA += " FROM "+RetSQLName("SRA")+" "
		_cQrySRA += " WHERE	RA_FILIAL = '"+xFilial("SRA")+"'"
		_cQrySRA += " AND	RA_SITFOLH= ''"
		_cQrySRA += " AND	D_E_L_E_T_ <> '*'"
		_cQrySRA += " AND RA_CATEG='  '"
		_cQrySRA += " AND RA_CATFUNC<>'A'"
		_cQrySRA += " ORDER BY RA_MAT "
		DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQrySRA), "TSRA", .F., .T.)
		WHILE !TSRA->(EOF())
			_cCodVet:=""
			_cBco:="" //13/10/16
			_cAgenci:=""
			_cNumcon:=""


			For _nPUser:=1 to len(aAllUser)
				if rtrim(TSRA->RA_MAT)==SubStr(aAllUser[_nPUser][1][22],5,6)//Caso seja o funcionario usuario do sistema - gravo o cod do usuario

					if aAllUser[_nPUser][1][17] //bloqueado
						exit
					endif

					_cCodVet:=aAllUser[_nPUser][1][1]
					exit
				endif
			Next _nPUser

			if !empty(alltrim(TSRA->A2_COD))
				_cQryBCO:=" SELECT A2_AGENCIA,A2_BANCO,A2_NUMCON FROM "+RETSQLNAME("SA2")+" WHERE D_E_L_E_T_<>'*' AND A2_FILIAL='"+XFILIAL("SA2")+"' AND A2_COD+A2_LOJA='"+TSRA->A2_COD+"'"
				DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQryBCO), "TBCO", .F., .T.)
				if !TBCO->(eof()) .and. !TBCO->(bof())
					_cBco		:=TBCO->A2_BANCO
					_cAgenci :=TBCO->A2_AGENCIA
					_cNumcon	:=TBCO->A2_NUMCON
				endif
				TBCO->(dbclosearea())
			endif

			//Atualizando ZV4
			DBSelectArea("ZV4")
			DBSetOrder(1)
			IF !DBSeek(xFilial("ZV4")+PADR(TSRA->RA_MAT,6),.F.)
				RecLock("ZV4",.T.)
				ZV4->ZV4_FILIAL 	:= xFilial("ZV4")
				ZV4->ZV4_MATRIC 	:= TSRA->RA_MAT
				ZV4->ZV4_NOME 		:= TSRA->RA_NOME
				ZV4->ZV4_CC 		:= TSRA->RA_CC
				ZV4->ZV4_CODUSR 	:= _cCodVet
				ZV4->ZV4_CODSA1 	:= TSRA->A1_COD
				ZV4->ZV4_CODSA2 	:= TSRA->A2_COD
				ZV4->ZV4_SOLICI		:='S'
				ZV4->ZV4_BANCO    :=_cBco
				ZV4->ZV4_AGENCI   :=_cAgenci
				ZV4->ZV4_NUMCON   :=_cNumcon
				MSUnlock()
			ELSE
				RecLock("ZV4",.F.)
				ZV4->ZV4_CODUSR:=_cCodVet //sempre atualizo se o funcionario estแ cadastrado como solicitante (usuario do sistema)
				ZV4->ZV4_SOLICI:=IIF(EMPTY(ALLTRIM(_cCodVet)),"","S")
				ZV4->ZV4_CODSA1 	:= TSRA->A1_COD
				ZV4->ZV4_CODSA2 	:= TSRA->A2_COD
				ZV4->ZV4_BANCO    :=_cBco
				ZV4->ZV4_AGENCI   :=_cAgenci
				ZV4->ZV4_NUMCON   :=_cNumcon

				MSUnlock()
			EndIF

			TSRA->(DBSKIP())
		ENDDO
		TSRA->(DBCLOSEAREA())

	EndIF

	_lAtManSol:=.f.

//Alert("Terminei a importa็ใo.")
	RestArea(_aAreaZV4)

Return _lRetZV4

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณZV3CAD บAutor  Denis Haruo        บ Data ณ  07/29/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCadastro de despesas de viagens                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ZV3CAD()
	Local aRotAdic :={}
	//Local bPre := {||MsgAlert('Chamada antes da fun็ใo',"")}
	//Local bOK  := {||MsgAlert('Chamada ao clicar em OK',), .T.}
	//Local bTTS  := {||MsgAlert('Chamada durante transacao',)}
	//Local bNoTTS  := {||MsgAlert('Chamada ap๓s transacao',)}
	Local aButtons := {}//adiciona bot๕es na tela de inclusใo, altera็ใo, visualiza็ใo e exclusao

	aadd(aButtons,{ "PRODUTO", {|| MsgAlert("Teste",)}, "Teste", "Botใo Teste" }  )//adiciona chamada no aRotina
	aadd(aRotAdic,{ "Adicional","U_AdicZV3", 0 , 6 })

//AxCadastro("ZV3", "Despesas", "U_DelZV3()", "U_ZV3OK()", aRotAdic,bPre,bOK,bTTS,bNoTTS,,,aButtons,,)
	AxCadastro("ZV3", "Despesas", "U_DelZV3()", "U_ZV3OK()", aRotAdic,		,	 ,    ,      ,,,aButtons,,)

Return(.T.)

User Function DelZV3()
//MsgAlert("Chamada antes do delete") 
Return .t.

User Function ZV3OK()
//MsgAlert("Clicou botao OK") 
Return .t.

User Function AdicZV3()
//MsgAlert("Rotina adicional") 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณZV4CAD บAutor  Denis Haruo        บ Data ณ  07/29/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCadastro de despesas de viagens                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ZV4CAD()

	Local aRotAdic :={}
	//Local bPre := {||MsgAlert('Chamada antes da fun็ใo')}
	//Local bOK  := {||MsgAlert('Chamada ao clicar em OK'), .T.}
	//Local bTTS  := {||MsgAlert('Chamada durante transacao')}
	//Local bNoTTS  := {||MsgAlert('Chamada ap๓s transacao')}
	Local aButtons := {}//adiciona bot๕es na tela de inclusใo, altera็ใo, visualiza็ใo e exclusao

	aadd(aButtons,{ "PRODUTO", {|| MsgAlert("Teste",)}, "Teste", "Botใo Teste" }  )//adiciona chamada no aRotina
	aadd(aRotAdic,{ "Adicional","U_AdicZV4", 0 , 6 })

//	AxCadastro("ZV4","Despesas","U_DelZV4()","U_ZV4OK()",aRotAdic,bPre,bOK,bTTS,bNoTTS,,,aButtons,,)  
	AxCadastro("ZV4","Despesas","U_DelZV4()","U_ZV4OK()",aRotAdic,    ,   ,    ,      ,,,aButtons,,)

Return(.T.)

User Function DelZV4()
	MsgAlert("Chamada antes do delete")
Return

User Function ZV4OK()
	MsgAlert("Clicou botao OK")
Return .t.

User Function AdicZV4()
	MsgAlert("Rotina adicional")
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVIAGEMXFUNCบAutor  ณMicrosiga           บ Data ณ  07/29/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GetUsrCode(cMat)

	Local cCod := ""
	Local cUserID
	Local nOrder := 2 // pesquisar pelo nome do usuแrio

	PswOrder(nOrder)
	If PswSeek( cUsuario, .T. )
		cUserId := PswID()
	EndIf

Return(cCod)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  PrestConta  บAutor  Denis Haruo           บ Data ณ  09/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida็ใo da inclusใo de Presta็ใo de contas da Viagem       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PrestConta(nOpca)

	If nOpca == 1 //Visualizar
		U_DlgPContas(nOpca)
	EndIf

	If nOpca == 2 //Incluir
		If MSGYesNo("Incluir uma presta็ใo de contas da viagem "+ZV1->ZV1_COD+"?","PrestConta()")
			If ChkIncZV1()
				U_DlgPContas(nOpca)
			EndIf
		EndIf
	EndIf

	If nOpca == 3 //Alterar
		If MSGYesNo("Atualizar uma presta็ใo de contas da viagem "+ZV1->ZV1_COD+"?","PrestConta()")
			If ChkAltZV1()
				U_DlgPContas(nOpca)
			EndIf
		EndIf
	EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ValidPConta  บAutor  Denis Haruo        บ Data ณ  08/27/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se pode prestar contas a viagem                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkIncZV1()

	Local lRet := .T.
	//Local cPrefixo := ZV1->ZV1_PREFIX
	//Local cNumPA := ZV1->ZV1_NUMPA
	Local cStatus := ZV1->ZV1_STATUS


	Do case
		//Adiantamento em analise
	Case cStatus == '1' .or. cStatus == '2'.or. cStatus == 'A'
		cMsg := "A inclusใo da presta็ใo de contas nใo serแ possํvel pois, esta viagem "+ZV1->ZV1_COD+" estแ em anแlise de aprova็ใo."
		MSGStop(cMsg,"ValidPConta()")
		lRet := .F.

	Case cStatus == '3'
		cMsg := "P.A. ainda nใo gerada no contas a pagar! A presta็ใo de contas nใo ้ permitida."
		MSGStop(cMsg,"ValidPConta()")
		lRet := .F.

	Case cStatus == '4' .or. cStatus == '5' //27/10/16
		cMsg := "A presta็ใo de contas desta viagem "+ZV1->ZV1_COD+" estแ em anแlise. Nova inclusใo nใo permitida."
		MSGStop(cMsg,"ValidPConta()")
		lRet := .F.

	Case cStatus == '6'
		cMsg := "Titulo gerado no Finaceiro."+CRL
		cMsg += "A presta็ใo de contas nใo ้ permitida."
		MSGStop(cMsg,"ValidPConta()")
		lRet := .F.

	Case cStatus == '7'
		cMsg := "Viagem encerrada."+CRL
		cMsg += "A presta็ใo de contas nใo ้ permitida."
		MSGStop(cMsg,"ValidPConta()")
		lRet := .F.

	Case cStatus == '8'
		cMsg := "Esta viagem "+ZV1->ZV1_COD+" foi rejeitada. motivo da Rejei็ใo: "+Upper(Alltrim(ZV1->ZV1_MOTREJ))+CRL
		cMsg += "A presta็ใo de contas nใo ้ permitida."
		MSGStop(cMsg,"ValidPConta()")
		lRet := .F.

	Case cStatus == '0'
		cMsg := "Presta็ใo de contas iniciada, somente altera็ใo ้ permitida."
		MSGStop(cMsg,"ValidPConta()")
		lRet := .F.

	Case cStatus == 'B' //02/11/16
		DBSelectArea("ZV4")
		DBSetOrder(2)
		If DBseek(xFilial("ZV4")+_cUsuar)
			If ZV4->ZV4_SOLICI <> "S"
				MSGStop("Somente usuแrios cadastrados como Solicitantes, podem realizar a presta็ใo de contas. Opera็ใo nใo permitida","ViagemXFunc")
				lRet := .F.
			EndIf
		Else
			MSGStop("Usuario nใo cadastrado na Tabela de Colaboradores ZV4. Opera็ใo nใo permitida.","ViagemXFunc")
			lRet := .F.
		EndIf

	End case

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkAltZV1   บAutor  Denis Haruo        บ Data ณ  09/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณChecando a Atualiza็ใo da Presta็ใo de contas             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkAltZV1()

	Local lRet := .T.
	Do case
		//Adiantamento em analise
	Case ZV1->ZV1_STATUS == '1' .or. ZV1->ZV1_STATUS == '2'
		cMsg := "A atualiza็ใo da presta็ใo de contas nใo serแ possํvel pois, esta viagem estแ em anแlise de aprova็ใo."
		MSGStop(cMsg,"ValidPConta()")
		lRet := .F.

		//Presta็ใo de contas em analise
	Case ZV1->ZV1_STATUS == '4' .or. ZV1->ZV1_STATUS == '5'
		cMsg := "A presta็ใo de contas desta viagem estแ em anแlise. Atualiza็ใo nใo permitida."
		MSGStop(cMsg,"ValidPConta()")
		lRet := .F.

	Case ZV1->ZV1_STATUS == '6'
		cMsg := "Titulo gerado no Finaceiro."+CRL
		cMsg += "A presta็ใo de contas nใo ้ permitida."
		MSGStop(cMsg,"ValidPConta()")
		lRet := .F.

	Case ZV1->ZV1_STATUS == '7'
		cMsg := "Viagem encerrada."+CRL
		cMsg += "Altera็ใo de presta็ใo de contas nใo ้ permitida."
		MSGStop(cMsg,"ValidPConta()")
		lRet := .F.

		//Viagem rejeitada
	Case ZV1->ZV1_STATUS == '8'
		cMsg := "Esta viagem foi rejeitada. motivo da Rejei็ใo: "+Upper(Alltrim(ZV1->ZV1_MOTREJ))+CRL
		cMsg += "A atualiza็ใonใo ้ permitida."
		MSGStop(cMsg,"ValidPConta()")
		lRet := .F.

	End case

Return(lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDlgPContas บAutor  Denis Haruo      บ Data ณ  08/11/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDialog da Presta็ใo de Contas  de uma viagem                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CONTROLE DE VIAGENS                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DlgPContas(nOpca)

//Layouts da Dlg
	Local oButton1
	Local oButton2
	Local oGroup1,oGroup2,oGroup4,oDlg
	Local oFont1 := TFont():New("MS Sans Serif",,016,,.F.,,,,,.F.,.F.)
	Local oFont2 := TFont():New("MS Sans Serif",,016,,.T.,,,,,.F.,.F.)
	Local lOk := .F.

//Campos da dlg
	Local oCC,oCodSeq,oDataIni,oEmissao,oMatricula,oNomeSolic,oOrigDest //oDataFim
	Local oSay1
	Local oSay10
	Local oSay11
	Local oSay12
	Local oSay13
	//Local oSay14
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay5
	Local oSay6
	Local oSay7
	Local oSay8
	Local oSay9
	Local oTipoMot
	//Local _lSemAdiant:=iif(RTRIM(UPPER(ZV1->ZV1_ADIANT))<>'N',.F.,.T.) //30/11/16

//variaveis para contabiliza็ใo - 27/10/16

	Private oTotRet,oTotAdi,oSaldo,oRecPag,oMSNewGe1
	Private nTotAdi:= ZV1->ZV1_TOTADI
	Private nTotRet:= IIF(nOpca==2,0,ZV1->ZV1_TOTRET)
	Private nSaldo	:= IIF(nOpca==2,0,ZV1->ZV1_SALDO)
	Private cRecPag:= IIF(ZV1->ZV1_TPPGTO=="P","A PAGAR","A RECEBER")
	Private cTotAdi:= Transform(nTotAdi,"@E 999,999,999.99")
	Private cTotRet:= Transform(nTotRet,"@E 999,999,999.99")
	Private cSaldo := Transform(nSaldo,"@E 999,999,999.99")
	Private aHeaderEx := {}
	Private aColsEx := {}

	Private oPanel1
	Private cViagem:= ZV1->ZV1_COD
	Private cSeq 	:= ZV1->ZV1_SEQ
	Private cSRAMAT:= ZV1->ZV1_MATRIC
	Private _cCusFun:=ZV1->ZV1_CC  //04/11/16
	Private cCODUSR:= POSICIONE("ZV4",1,xFilial("ZV4")+cSRAMAT,"ZV4_CODUSR")

	Private nTotal:=0
	private nHdlPrv    := 0
	private cLoteEst   :="008850"
	private cArquivo   := ''
	private lCriaHeade := .T.
	Private _dDatabase :=dDatabase
	Private _lContDia  :=.F.
	Private _cLPctb    :='P01'
	PRIVATE _cContaLct :=""
	Private _nTotLcto:=0
	Private _cCCForn:=""
	Private _cCCNome:=""
	Private _cTitVia:="" //15/11/16


	DBSelectArea("ZV1")
	DEFINE MSDIALOG oDlg TITLE "Presta็ใo de Contas" FROM 000, 000  TO 460, 827 COLORS 0, 16777215 PIXEL

	@ 000, 000 MSPANEL oPanel1 SIZE 415, 230 OF oDlg COLORS 0, 15920613 RAISED
	@ 002, 003 GROUP oGroup1 TO 211, 412 PROMPT " Presta็ใo de Contas da Viagem " OF oPanel1 COLOR 8388608, 15920613 PIXEL

	@ 016, 010 SAY oSay1 PROMPT "C๓digo: " SIZE 021, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
	@ 016, 031 SAY oCodSeq PROMPT cViagem+"/"+cSeq SIZE 035, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL

	@ 016, 070 SAY oSay2 PROMPT "Solicitante: " SIZE 028, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
	@ 016, 099 SAY oNomeSolic PROMPT ZV1->ZV1_CODSOL+" - "+Alltrim(ZV1->ZV1_NSOLIC) SIZE 130, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL

/*@ 027, 010 SAY oSay3 PROMPT "Emissใo: " SIZE 023, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
@ 027, 033 SAY oEmissao PROMPT DTOC(ZV1->ZV1_EMISSA) SIZE 032, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL*/

@ 027, 010 SAY oSay3 PROMPT "Vencim.: " SIZE 023, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
@ 027, 033 SAY oEmissao PROMPT DTOC(ZV1->ZV1_DTVENC) SIZE 032, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL //13/10/16

@ 039, 008 GROUP oGroup2 TO 119, 407 PROMPT " Dados do Colaborador " OF oPanel1 COLOR 8388608, 15920613 PIXEL
@ 050, 012 SAY oSay5 PROMPT "Matrํcula:" SIZE 025, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
@ 050, 040 SAY oMatricula PROMPT ZV1->ZV1_MATRIC+" - "+Alltrim(ZV1->ZV1_NFUNC) SIZE 200, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
    
@ 050, 245 SAY oSay6 PROMPT "มrea de Lota็ใo:" SIZE 043, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
@ 050, 289 SAY oCC PROMPT Alltrim(ZV1->ZV1_CC)+" - "+Alltrim(ZV1->ZV1_DESCCC) SIZE 111, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL

@ 064, 012 GROUP oGroup4 TO 110, 402 PROMPT " Dados da Viagem " OF oPanel1 COLOR 8388608, 15920613 PIXEL
@ 075, 017 SAY oSay7 PROMPT "Origem/Destino: " SIZE 042, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
@ 075, 060 SAY oOrigDest PROMPT Alltrim(ZV1->ZV1_NCORIG)+"-"+ZV1->ZV1_ESTORI+"/"+Alltrim(ZV1->ZV1_NCDEST)+"-"+ZV1->ZV1_ESTDES SIZE 182, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL

@ 075, 287 SAY oSay13 PROMPT "Perํodo de: " SIZE 032, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
@ 075, 320 SAY oDataIni PROMPT DTOC(ZV1->ZV1_DTINI)+" at้ "+DTOC(ZV1->ZV1_DTFIM) SIZE 030, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
 
@ 087, 017 SAY oSay4 PROMPT "Motivo: " SIZE 025, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
@ 087, 039 SAY oTipoMot PROMPT Alltrim(ZV1->ZV1_MOTVIA)  SIZE 352, 018 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL

@ 124, 010 SAY oSay10 PROMPT "Despesas da Viagem: " SIZE 064, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
GetDespesa(nOpca)
    
@ 200, 010 SAY oSay11 PROMPT "Total Adiantado: " SIZE 050, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
@ 200, 062 SAY oTotDesp PROMPT cTotAdi SIZE 055, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
@ 200, 146 SAY oSay8 PROMPT "Total da Despesa: " SIZE 056, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
@ 200, 204 SAY oTotRet PROMPT cTotRet SIZE 068, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
@ 200, 283 SAY oSay9 PROMPT "Saldo: " SIZE 023, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
@ 200, 305 SAY oSaldo PROMPT cSaldo SIZE 057, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
@ 200, 360 SAY oRecPag PROMPT cRecPag SIZE 057, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL

If nOpca == 2 .or. nOpca == 3 //Inclusใo ou Atualiza็ใo 
	@ 212, 333 BUTTON oButton1 PROMPT "Confirmar" SIZE 037, 012 OF oPanel1 PIXEL Action(lOk:=.T.,oDlg:End())
EndIf	 

@ 212, 374 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oPanel1 PIXEL Action oDlg:End()
@ 215, 002 SAY oSay12 PROMPT "Powered by Sigacorp" SIZE 059, 007 OF oPanel1 COLORS 8421504, 15920613 PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

If lOk
	//Gravando a Presta็ใo de Contas
	If ZV2GrvOk(cViagem,cSeq)
		//IF MsgYESNO("Deseja enviar esta presta็ใo de contas para analise e aprova็ใo?","ZV2GrvOk")
		  /*	cAprovador := ""
			cQuery := ""
			cQuery += "SELECT * FROM "+RetSQLName("ZPB")+" "
			cQuery += "WHERE 	ZPB_FILIAL = '"+xFilial("ZPB")+"' AND "
			cQuery += "			ZPB_CARGO = 'A' AND "
			cQuery += "			D_E_L_E_T_ <> '*' "
			TCQuery cQuery NEW ALIAS "APR"
			DBSelectArea("APR")
			IF !EOF()
				cAprovador := APR->ZPB_CODUSR
				U_WFPrestCont(cViagem,cSeq,cAprovador)	
				DBSelectArea("ZV1")
				Reclock("ZV1",.F.)
				ZV1->ZV1_STATUS := '4' //anแlise nivel 1 
				MSUnlock()	
				MSGInfo("Sua presta็ใo de contas foi enviada para anแlise e aprova็ใo. Favor aguarde o retorno.")
			Else
				MSGStop("Email do analista financeiro nใo encontrado. Corrija e reenvie a aprova็ใo.")
			EndIf
			DBSelectArea("APR")
			APR->(DBCloseArea())*/

			//ENVIO PRIMEIRO PARA O RESPONSมVEL PELA PRIMEIRA APROVAวรO (GERENTE DO SETOR OU RH)			
			MSGInfo("Sua presta็ใo de contas foi enviada para anแlise e aprova็ใo para "+rtrim(ZV1->ZV1_NAPRO1)+". Favor aguarde o retorno.")			
			U_WFPrestCont(cViagem,cSeq,ZV1->ZV1_APROV1)				                     
			DBSelectArea("ZV1")
			Reclock("ZV1",.F.)
			ZV1->ZV1_STATUS := '4' //anแlise nivel 1 
			MSUnlock()	

			//CONTABILIZO A PRESTAวรO INCLUIDA 
			nTotal    := 0
			_lContDia := .F.
			lDigita   := .T.
			lAglutina := .T.
			_nTotLcto := 0
			_cCCForn  := posicione("SA2",1,XFILIAL("SA2")+ZV1->ZV1_CODSA2,"A2_CONTA") //07/11/16		
			_cCCNome  := posicione("SA2",1,XFILIAL("SA2")+ZV1->ZV1_CODSA2,"A2_NOME") //07/11/16				

			_cQryZV2:=" SELECT ZV2_CODVIA,ZV3_DESCRI,SUM(ZV2_VALOR) AS TOT,ZV3_TIPO,ZV3_CONTA FROM "+RETSQLNAME("ZV2")+","+RETSQLNAME("ZV3")+","+RETSQLNAME("ZV1")
 			_cQryZV2+=" WHERE "+RETSQLNAME("ZV2")+".D_E_L_E_T_<>'*'"
 			_cQryZV2+=" AND "+RETSQLNAME("ZV3")+".D_E_L_E_T_<>'*'"
 			_cQryZV2+=" AND "+RETSQLNAME("ZV1")+".D_E_L_E_T_<>'*'"
  			_cQryZV2+=" AND ZV3_FILIAL=ZV2_FILIAL "
 			_cQryZV2+=" AND ZV1_FILIAL=ZV2_FILIAL "
 			_cQryZV2+=" AND ZV3_COD=ZV2_CODIGO  "
 			_cQryZV2+=" AND ZV2_CODVIA=ZV1_COD  "
  			_cQryZV2+=" AND ZV1_COD='"+cViagem+"'"	
  			_cQryZV2+=" AND ZV1_SEQ='"+strzero(val(cSeq),3)+"'"  			
  			_cQryZV2+=" GROUP BY ZV2_CODVIA,ZV3_DESCRI,ZV3_TIPO,ZV3_CONTA"
  			_cQryZV2+=" ORDER BY ZV3_TIPO DESC"  			
			DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQryZV2), "TZV2", .F., .T.) 
			IF !TZV2->(EOF()) .AND. !TZV2->(BOF())
			
				nHdlPrv := HeadProva(cLoteEst,"CADZV1",Subs(cUsuario,7,6),@cArquivo)
		  		_cTitVia:=strzero(val(cViagem),9)+"GVI" //15/11/16

				WHILE !TZV2->(EOF())
					IF RTRIM(TZV2->ZV3_TIPO)=='D' 
						_nTotLcto+=TZV2->TOT //ACUMULO O TOTAL DAS DESPESAS
					ENDIF
				
					nTotal += DetProva(nHdlPrv,"P01","CADZV1",cLoteEst)  
					TZV2->(DBSKIP())			
				ENDDO                           
				
				RodaProva(nHdlPrv,nTotal)
				cA100Incl(cArquivo,nHdlPrv,3,cLoteEst,lDigita,lAglutina)  
				
			ENDIF
			TZV2->(DBCLOSEAREA())						

		//Else
		//MsgInfo("Presta็ใo de contas gravada com sucesso.","ZV2GrvOk") 
		//EndIf	
	Else
		MSGStop("problemas com a grava็ใo da presta็ใo de contas. ","ZV2GrvOk")
	EndIf
EndIf

Return  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetDespesa บAutor  Denis Haruo       บ Data ณ  08/27/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGetDados da tela de Presta็ใo de Contas                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GetDespesa(nOpca)

	Local aAlterFields := {'ZV2_CODIGO','ZV2_QUANT','ZV2_VALOR '}
	Local nUsado := 0
	//Local lRet := .F.
	Local aSizeAut  := MsAdvSize()
	Local _ni
	aObjects := {}
	AAdd( aObjects, { 315,  50, .T., .T. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects, .T. )


	nUsado:=0
//dbSelectArea("SX3")
//DbSetOrder(1)
//DbSeek("ZV2")
	aHeaderEx:={}

	cAliasTmp := "IASX3"
	OpenSXs(NIL, NIL, NIL, NIL, cEmpAnt, cAliasTmp, "SX3", NIL, .F.)
	//cFiltro   := "X3_ARQUIVO == 'ZV2'"
	(cAliasTmp)->(DbSetFilter({|| X3_ARQUIVO == 'ZV2'}, "X3_ARQUIVO == 'ZV2'"))
	(cAliasTmp)->(DbGoTop())
	(cAliasTmp)->(DbSetOrder(01))

	IF _lALEner //26/07/17  - Fabio Yoshioka

		_aCustGrvSE2:={}

		if nOpca==3 .or. nOpca==4 //inclusao ou altera็ใo
			aAlterFields := {'ZV2_CODIGO','ZV2_COMPLE','ZV2_VALOR','ZV2_DEDZIR','ZV2_DATA','ZV2_CCUSTO'}
		endif

		While !Eof().And.((cAliasTmp)->(x3_arquivo)=="ZV2")


			If X3USO((cAliasTmp)->(X3_USADO)) .And. cNivel >= (cAliasTmp)->(x3_nivel)
				If 	UPPER(rtrim((cAliasTmp)->(X3_CAMPO))) == 'ZV2_CODIGO' .or.;
						UPPER(rtrim((cAliasTmp)->(X3_CAMPO))) == 'ZV2_DESCRI' .or.;
						UPPER(rtrim((cAliasTmp)->(X3_CAMPO))) == 'ZV2_DEDZIR' .or.;
						UPPER(rtrim((cAliasTmp)->(X3_CAMPO))) == 'ZV2_COMPLE' .or.;
						UPPER(rtrim((cAliasTmp)->(X3_CAMPO))) == 'ZV2_VALOR' .OR.;
						UPPER(rtrim((cAliasTmp)->(X3_CAMPO))) == 'ZV2_DATA' .OR.;
						UPPER(rtrim((cAliasTmp)->(X3_CAMPO))) == 'ZV2_CONTA' .OR.;
						UPPER(rtrim((cAliasTmp)->(X3_CAMPO))) == 'ZV2_CCUSTO'

					nUsado:=nUsado+1

					Aadd(aHeaderEx,{ alltrim((cAliasTmp)->(x3_titulo)),(cAliasTmp)->(X3_CAMPO),(cAliasTmp)->(X3_PICTURE),;
						(cAliasTmp)->(X3_TAMANHO), (cAliasTmp)->(X3_DECIMAL),iif(rtrim((cAliasTmp)->(X3_CAMPO))=='ZV2_CCUSTO',"U_VLDCT1CTT()","AllwaysTrue()"),;
						(cAliasTmp)->(X3_USADO), (cAliasTmp)->(X3_TIPO),(cAliasTmp)->(X3_F3),(cAliasTmp)->(X3_CONTEXT) } )	//CRIADO CONSULTA PADRAO COM FILTRO DE TIPO E CENTRO DE CUSTO - 04/11/16 _cCusFun
				EndIf
			Endif
			dbSkip()
		End

		aColsEx:={}

		If nOpca==3 //Incluir
			aColsEx:={Array(nUsado+1)}
			aColsEx[1,nUsado+1]:=.F.
			For _ni:=1 to nUsado
				aColsEx[1,_ni]:=CriaVar(aHeaderEx[_ni,2])
				if upper(rtrim(aHeaderEx[_ni,2]))=="ZV2_DATA" //atribuir data
					aColsEx[1,_ni]:=_dDataZV2
				endif
			Next
		Else
			dbSelectArea("ZV2")
			dbSetOrder(3)
			dbSeek(xFilial("ZV2")+cViagem+cSeq)
			While !eof().and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA+ZV2->ZV2_SEQ == xFilial("ZV2")+cViagem+cSeq

				if !Empty(alltrim(ZV2->ZV2_CCUSTO))
					_nPosGrvCus:=aScan(_aCustGrvSE2,{|x| rtrim(x[1]) == RTRIM(ZV2->ZV2_CCUSTO)})
					if _nPosGrvCus==0
						aadd(_aCustGrvSE2,{ZV2->ZV2_CCUSTO,ZV2->ZV2_VALOR})
					else
						_aCustGrvSE2[_nPosGrvCus,2]+=ZV2->ZV2_VALOR
					endif
				endif


				//Adiantamento concedido
				If ZV2->ZV2_CODIGO == '000'
					DBSkip()
					Loop
				EndIf

				//Populando aCols
				AADD(aColsEx,Array(nUsado+1))
				For _ni:=1 to nUsado
					aColsEx[Len(aColsEx),_ni]:=FieldGet(FieldPos(aHeaderEx[_ni,2]))
				Next
				aColsEx[Len(aColsEx),nUsado+1]:=.F.
				dbSkip()
			End Do
		EndIf

	ELSE
		While !Eof().And.((cAliasTmp)->(x3_arquivo)=="ZV2")
			If X3USO((cAliasTmp)->(X3_USADO)) .And. cNivel >= (cAliasTmp)->(x3_nivel)
				If 	(cAliasTmp)->(X3_CAMPO) == 'ZV2_CODIGO' .or.;
						(cAliasTmp)->(X3_CAMPO) == 'ZV2_DESCRI' .or.;
						(cAliasTmp)->(X3_CAMPO) == 'ZV2_QUANT ' .or.;
						(cAliasTmp)->(X3_CAMPO) == 'ZV2_VALOR '
					nUsado:=nUsado+1
					Aadd(aHeaderEx,{ alltrim((cAliasTmp)->(x3_titulo)),(cAliasTmp)->(X3_CAMPO),(cAliasTmp)->(X3_PICTURE),;
						(cAliasTmp)->(X3_TAMANHO), (cAliasTmp)->(X3_DECIMAL),"AllwaysTrue()",;
						(cAliasTmp)->(X3_USADO), (cAliasTmp)->(X3_TIPO), IIF(((cAliasTmp)->(X3_CAMPO)) == 'ZV2_CODIGO',"ZV3DSP",(cAliasTmp)->(X3_F3)),(cAliasTmp)->(X3_CONTEXT) } )	//CRIADO CONSULTA PADRAO COM FILTRO DE TIPO E CENTRO DE CUSTO - 04/11/16 _cCusFun
				EndIf
			Endif
			dbSkip()
		End


		aColsEx:={}

		If nOpca==2 //Incluir
			aColsEx:={Array(nUsado+1)}
			aColsEx[1,nUsado+1]:=.F.
			For _ni:=1 to nUsado
				aColsEx[1,_ni]:=CriaVar(aHeaderEx[_ni,2])
			Next
		Else
			dbSelectArea("ZV2")
			dbSetOrder(2)
			dbSeek(xFilial("ZV2")+cViagem+cSeq)
			While !eof().and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA+ZV2_SEQ == xFilial("ZV2")+cViagem+cSeq

				//Adiantamento concedido
				If ZV2->ZV2_CODIGO == '000'
					DBSkip()
					Loop
				EndIf

				//Populando aCols
				AADD(aColsEx,Array(nUsado+1))
				For _ni:=1 to nUsado
					aColsEx[Len(aColsEx),_ni]:=FieldGet(FieldPos(aHeaderEx[_ni,2]))
				Next
				aColsEx[Len(aColsEx),nUsado+1]:=.F.
				dbSkip()
			End Do
		EndIf


	ENDIF


	if _lALEner //21/07/17

		//ajuste no tamanho do getdados - 27/09/17 - Fabio Yoshioka
		_aSizeAut  := MsAdvSize()
		_aObjects := {}
		AAdd( _aObjects, { 315,  50, .T., .T. } )
		AAdd( _aObjects, { 100, 100, .T., .T. } )
		_aInfo := { _aSizeAut[ 1 ], _aSizeAut[ 2 ], _aSizeAut[ 3 ], _aSizeAut[ 4 ], 3, 3 }
		_aPosObj := MsObjSize( _aInfo, _aObjects, .T. )


		//oMSNewGe1 := MsNewGetDados():New( 90, 010, 195, 405, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue()","U_ZV2EneTOK", , aAlterFields,, 999, "U_ZV2EneFld()", "", "AllwaysTrue", oPanel1, aHeaderEx, aColsEx)
		//oMSNewGe1 := MsNewGetDados():New( 80,05, 250, 500, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue()","U_ZV2EneTOK", , aAlterFields,, 999, "U_ZV2EneFld()", "", "AllwaysTrue", oPanel1, aHeaderEx, aColsEx)
		oMSNewGe1 := MsNewGetDados():New(80,_aPosObj[02,02],250,_aPosObj[02,04], GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue()","U_ZV2EneTOK", , aAlterFields,, 999, "U_ZV2EneFld()", "", "AllwaysTrue", oPanel1, aHeaderEx, aColsEx)

	else
		oMSNewGe1 := MsNewGetDados():New( 135, 010, 195, 405, GD_INSERT+GD_DELETE+GD_UPDATE , "AllwaysTrue()","U_ZV2TudOK", 	  , aAlterFields,		, 999,"U_ZV2Fld()", ""		 , "AllwaysTrue", oPanel1, aHeaderEx, aColsEx)
		//oGetD:= 	 MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita, nOpc		,cLinOk			 ,cTudoOk	  ,cIniCpos,aAlterGDa   ,nFreeze,nMax,cFieldOk	  , cSuperDel,cDelOk		, oDLG	 , aHeader	, aCols )
	endif

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณZV2Fld บAutor  Denis Haruo            บ Data ณ  08/13/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida campo para Atualiza็ใo das variaveis de rodap้    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ZV2Fld()

	Local lRet := .T.
	Local aAux := aClone(oMSNewGe1:aCols)
	Local cCpo := ReadVar()
	Local ni := 0

	nTotRet := 0
	nSaldo := 0

	If cCpo == 'M->ZV2_CODIGO' .and. M->ZV2_CODIGO == '000'
		MSGInfo("Codigo nใo permitido.")
		Return(.F.)
	EndIf

	If cCpo == 'M->ZV2_CODIGO'
		MSGInfo("Codigo nใo permitido.")
		Return(.F.)
	EndIf
/*
If !ExistChav("CTT", 'M->ZV2_CCUSTO' )

    MsgStop("Centro de custo nใo existe!", "Aten็ใo")
	Return(.F.)

EndIf
*/

	If cCpo == 'M->ZV2_VALOR'

		For ni:=1 to Len(aAux)
			If n = ni
				nTotRet += M->ZV2_VALOR
			Else
				nTotRet += aAux[ni][4]
			EndIf
		Next

		nSaldo := nTotAdi - nTotRet

		If nSaldo < 0
			nSaldo := ABS(nSaldo)
			cRecPag:= "A RECEBER"
		Else
			cRecPag:= "A PAGAR"
		EndIf
		cTotRet := Transform(nTotRet,"@E 999,999,999.99")
		cSaldo 	:= Transform(nSaldo,"@E 999,999,999.99")

		oTotRet:Refresh()
		oSaldo:Refresh()
		oRecPag:Refresh()

	EndIf

Return(lRet)


	**************************
User Function ZV2EneFld() //26/07/17
	**************************

	Local lRet := .T.
	Local aAux := aClone(oMSNewGe1:aCols)
	Local cCpo := ReadVar()
	Local nPosConta := aScan(aHeaderEx,{|x| rtrim(x[2]) == "ZV2_CONTA"})
	//Local nPosData  := aScan(aHeaderEx,{|x| rtrim(x[2]) == "ZV2_DATA"})
	Local nPosValor := aScan(aHeaderEx,{|x| rtrim(x[2]) == "ZV2_VALOR"})
	Local nPosCodigo:= aScan(aHeaderEx,{|x| rtrim(x[2]) == "ZV2_CODIGO"})
	Local nPosComPle:= aScan(aHeaderEx,{|x| rtrim(x[2]) == "ZV2_COMPLE"}) //27/09/17
	Local ni := 0
	Private _cCTBSel:=""
	Private _aCTBSel:={}

	If !Empty( M->ZV2_CCUSTO )
		lRet := CTB105CC(M->ZV2_CCUSTO)
	EndIf

	If cCpo == 'M->ZV2_DATA'
		_dDataZV2:=M->ZV2_DATA
	ENDIF

	If cCpo == 'M->ZV2_CODIGO' //.and. M->ZV2_CODIGO == '000'
		oMSNewGe1:aCols[n,nPosConta]:=CRIAVAR("ZV2_CONTA")
		//tratamento para selecionar as contas cadastradas - 28/07/17
		DBSELECTAREA("ZV3")
		DBSETORDER(1)
		IF DBSEEK(xFilial("ZV3")+M->ZV2_CODIGO,.f.)

			if !empty(alltrim(ZV3->ZV3_CONADM))
				aadd(_aCTBSel,{.f.,ZV3->ZV3_CONADM,posicione("CT1",1,XFILIAL("CT1")+ZV3->ZV3_CONADM,"CT1_DESC01")})
			endif

			if !empty(alltrim(ZV3->ZV3_CONCUS))
				aadd(_aCTBSel,{.f.,ZV3->ZV3_CONCUS,posicione("CT1",1,XFILIAL("CT1")+ZV3->ZV3_CONCUS,"CT1_DESC01")})
			endif

			if !empty(alltrim(ZV3->ZV3_CONNPR))
				aadd(_aCTBSel,{.f.,ZV3->ZV3_CONNPR,posicione("CT1",1,XFILIAL("CT1")+ZV3->ZV3_CONNPR,"CT1_DESC01")})
			endif

		ENDIF

		IF LEN(_aCTBSel)>0
			IF LEN(_aCTBSel)>1
				while empty(alltrim(_cCTBSel))
					LisContas(_aCTBSel)
					if empty(alltrim(_cCTBSel))
						alert("Obrigat๓rio selecionar a conta correspondente!")
					endif
				enddo
				oMSNewGe1:aCols[n,nPosConta]:=_cCTBSel

			ELSEIF LEN(_aCTBSel)==1
				_cCTBSel:=_aCTBSel[1,2]
				oMSNewGe1:aCols[n,nPosConta]:=_cCTBSel
			ENDIF

		/*
		COMENTADO - SOLICITAวรO ANDERSON PIMENTEL POR E-MAIL: 22/12/17
		"Desfazer a implementa็ใo: Trazer no campo complemento o hist๓rico padrใo, desde que haja cadastro na
		contabilidade (amarra็ใo conta contแbil x Hist๓rico padrใo)."
		_cCodHPad:=Posicione("CT1",1,XFILIAL("CT1")+_cCTBSel,"CT1_HP")
		if !empty(alltrim(_cCodHPad))
			oMSNewGe1:aCols[n,nPosComPle]:=RTRIM(Posicione("CT8",1,XFILIAL("CT8")+_cCodHPad,"CT8_DESC")) //27/09/17
		else
			oMSNewGe1:aCols[n,nPosComPle]:=space(TamSx3("ZV2_COMPLE")[1])
		endif*/
		
		//22/12/17 - Fabio Yoshioka
		//3. Criar Gatilho para que o campo complemento seja preenchido com “REEMBOLSO” ap๓s a sele็ใo da
		//despesa. (o campo serแ complementado manualmente com as demais informa็๕es)
		//oMSNewGe1:aCols[n,nPosComPle]:="REEMBOLSO "
		oMSNewGe1:aCols[n,nPosComPle]:="REEMB DESP "+space(TamSx3("ZV2_COMPLE")[1]-11) //22/01/18 - Fabio Yoshioka
		
		
		
		
	ENDIF
EndIf                     

If cCpo == 'M->ZV2_VALOR'
	nTotRet := 0
	nAbatm := 0

	For ni:=1 to Len(aAux)
		IF upper(rtrim(POSICIONE("ZV3",1,XFILIAL("ZV3")+aAux[ni][nPosCodigo],"ZV3_TIPO")))=='A' //ABATIMENTOS
			If n = ni
				nAbatm += M->ZV2_VALOR
			Else
				nAbatm += aAux[ni][nPosValor]
			EndIf
			
		ELSE
			If n = ni
				nTotRet += M->ZV2_VALOR
			Else
				nTotRet += aAux[ni][nPosValor]
			EndIf
		ENDIF
	Next
	     
	/*nSaldo := nTotAdi - nTotRet
	
	If nSaldo < 0
		nSaldo := ABS(nSaldo)
		cRecPag:= "A RECEBER"
	Else
		cRecPag:= "A PAGAR"
	EndIf*/
	
	cTotRet := Transform(nTotRet,"@E 999,999,999.99")
	cAbatm 	:= Transform(nAbatm,"@E 999,999,999.99") 
	
	oTotRet:Refresh()
	oAbatm:Refresh()
	//oRecPag:Refresh()

EndIf

Return(lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณZV2GrvOk  บAutor  Denis Haruo          บ Data ณ  08/17/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava็ใo das despesas                                        บฑฑ
ฑฑบ          ณ                  	                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ZV2GrvOk(cViagem,cSeq)

	Local _aArea := GetArea()
	Local lRet := .T.
	Local aValDesp := aClone(oMSNewGe1:aCols)
	Local ni := 0
	Local _nHCpo := 0

	if !_lALEner //30/07/17

		cSeq:=ZV1->ZV1_SEQ
		nTotRet := 0

		//Validando o acols
		For ni:=1 to Len(aValDesp)
			If aValDesp[ni][4] == 0
				MSGStop("Existe despesas com valores zerados. Grava็ใo nใo permitida.","ZV2GrvOk")
				lRet := .F.
				Exit
			EndIf
		Next

		If lRet
			For ni:=1 to Len(aValDesp)

				DBSelectArea("ZV2")
				DBSetOrder(2)
				If DBSeek(xFilial("ZV2")+cViagem+cSeq+aValDesp[ni][1],.F.)
					RecLock("ZV2",.F.)
					ZV2->ZV2_DTPCONT 	:= dDataBase
					ZV2->ZV2_VALOR 	:= aValDesp[ni][4]
					MSUnlock()
				Else
					RecLock("ZV2",.T.)
					ZV2->ZV2_FILIAL	:= xFilial("ZV2")
					ZV2->ZV2_CODIGO 	:= aValDesp[ni][1]
					ZV2->ZV2_DESCRI 	:= aValDesp[ni][2]
					ZV2->ZV2_QUANT 	:= aValDesp[ni][3]
					ZV2->ZV2_VALOR 	:= aValDesp[ni][4]
					ZV2->ZV2_DTPCON 	:= dDataBase
					ZV2->ZV2_CODVIA 	:= cViagem
					ZV2->ZV2_SEQ	 	:= cSeq
					MSUnlock()
				EndIf
				nTotRet += aValDesp[ni][4]
			Next
		EndIf

		If lRet
			DBSelectArea("ZV1")
			DBSetOrder(1)
			DBSeek(xFilial("ZV1")+cViagem+cSeq)
			RecLock("ZV1",.F.)
			ZV1->ZV1_TOTRET 	:= nTotRet
			ZV1->ZV1_SALDO 	:= ABS(ZV1->ZV1_TOTADI - nTotRet)
			ZV1->ZV1_TPPGTO	:= IIF((ZV1->ZV1_TOTADI - nTotRet) >= 0 ,"R","P") //Se funcionario "A Pagar", eu "Recebo"
			ZV1->ZV1_DTPCON	:= dDatabase
			ZV1->ZV1_STATUS	:= "0" //P. Contas gravada
			MSUnlock()

		EndIf
	else //VALIDAR CAMPOS 30/07/17

		DBSelectArea("ZV2")//02/10/18 - exclui todos os existentes no ZV2
		DBSetOrder(3)
		DBseek(xFilial("ZV2")+cViagem)
		Do While !EOF() .and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA == xFilial("ZV2")+cViagem
			RecLock("ZV2",.F.)
			ZV2->(DBDelete())
			ZV2->(MSUnlock())
			ZV2->(DBskip())
		EndDo

		If lRet
			For ni:=1 to Len(aValDesp)
				_lDelet:=iif(aValDesp[ni,len(aHeaderEx)+1],.T.,.F.)
				_lTemZV2:=.F.

				RecLock("ZV2",.T.) //Gravo sempre - 02/10/18

				IF !_lDelet
					ZV2->ZV2_FILIAL:=XFILIAL("ZV2")
					ZV2->ZV2_CODVIA:=cViagem
					//ZV2->ZV2_SEQ:=cSeq
					For _nHCpo:=1 to len(aHeaderEx)
						_cCpoHead:="ZV2->"+RTRIM(aHeaderEx[_nHCpo,2])
						&_cCpoHead:=aValDesp[ni,_nHCpo]
					Next _nHCpo
				ELSE
					IF _lTemZV2
						ZV2->(DBDELETE())
					ENDIF
				ENDIF
				ZV2->(MSUnlock())
			Next

			DBSelectArea("ZV1")
			DBSetOrder(1)
			IF DBSeek(xFilial("ZV1")+cViagem)
				RecLock("ZV1",.F.)
			ELSE
				RecLock("ZV1",.T.)
				ConfirmSX8()
			ENDIF

			ZV1->ZV1_FILIAL 	:= xFilial("ZV1")
			ZV1->ZV1_COD 		:= cViagem
			//ZV1->ZV1_SEQ 		:= cSeq
			ZV1->ZV1_TIPO		:= IIf(nCbTipo==1,"S","V")
			ZV1->ZV1_CODSOL 	:= cCodSol
			ZV1->ZV1_NSOLIC		:= cNomeSol
			ZV1->ZV1_EMISSA		:= dDatabase
			ZV1->ZV1_MATRIC 	:= cMatFunc
			ZV1->ZV1_NFUNC		:= cNomeFunc
			//ZV1->ZV1_TOTADI		:= 0
			if !_lALEner //23/01/18
				ZV1->ZV1_STATUS 	:= 'B'
			ENDIF
			ZV1->ZV1_CODSA2 	:= cMatFunc
			ZV1->ZV1_BANCO		:= POSICIONE("SA2",1,XFILIAL("SA2")+cMatFunc,"A2_BANCO")
			ZV1->ZV1_AGENCI 	:= POSICIONE("SA2",1,XFILIAL("SA2")+cMatFunc,"A2_AGENCIA")
			ZV1->ZV1_CONTA		:= POSICIONE("SA2",1,XFILIAL("SA2")+cMatFunc,"A2_NUMCON")
			ZV1->ZV1_ADIANT   	:='N'
			ZV1->ZV1_TOTRET   	:=nTotRet
			ZV1->ZV1_ABATM   	:=nAbatm
			ZV1->ZV1_DTVENC		:=_dDatVenc //17/07/18 - Inclusao de Grava็ใo de Campo de Vencimento
			if !_lALEner //23/01/18
				ZV1->ZV1_STATUS   	:='0'
			endif

			DBSelectArea("SE2") //09/08/17
			DBSetOrder(1)
			If DBSeek(xFilial("SE2")+_cTitADto+cMatFunc,.F.)
				ZV1->ZV1_PREFIXO:=SE2->E2_PREFIXO
				ZV1->ZV1_NUMPA	:=SE2->E2_NUM
				ZV1->ZV1_PARCEL	:=SE2->E2_PARCELA
				ZV1->ZV1_TIPOPA	:=SE2->E2_TIPO
				ZV1->ZV1_TOTADI	:=SE2->E2_VALOR
				ZV1->ZV1_EMISPA :=SE2->E2_EMISSAO
				//ZV1->ZV1_ADIANT   	:='S'
			EndIf

			ZV1->(MSUnlock())

		EndIf

	Endif

	RestArea(_aArea)

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  CompViagem()   บAutor  Denis Haruo       บ Data ณ  09/14/15  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDialog da Compensa็ใo da Viagem                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CompViagem(nOpca)

	Local oAgNF,oAgPA,oBcoNF,oBcoPA,oCodSeq
	Local oContaNF,oContaPA,oDataFim,oDataIni,oEmissao
	Local oFont1 := TFont():New("MS Sans Serif",,016,,.F.,,,,,.F.,.F.)
	Local oFont2 := TFont():New("MS Sans Serif",,016,,.T.,,,,,.F.,.F.)
	Local oButton1
	Local oButton2
	Local oGroup1,oGroup2,oGroup3,oPanel1

	Local oTipoNF,oTipoPA,oValNF,oValPA,oDlg
	Local oMatricula,oNomeSolic,oNumNF,oNumPA,oOrigDest,oPrfNF,oPrfPA
	Local oSay1,oSay10,oSay12,oSay13,oSay14,oSay15,oSay16,oSay17,oSay18,oSay4,oSay7
	Local oSay19,oSay2,oSay20,oSay21,oSay22,oSay23,oSay24,oSay25,oSay3,oSay5,oSay6

	Private lOK := .F.

//Filtros...
	If Empty(ZV1->ZV1_TITPC)
		MSGStop("Nใo foi encontrado o titulo para a compensa็ใo desta viagem. Opera็ใo nใo permitida.","CompViagem()")
		Return()
	EndIf

	If ZV1->ZV1_STATUS == '7'
		MSGStop("Esta viagem estแ encerrada. Opera็ใo nใo permitida.","CompViagem()")
		Return()
	EndIf

	DEFINE MSDIALOG oDlg TITLE "Compensa็ใo de Viagem" FROM 000, 000  TO 265, 827 COLORS 0, 16777215 PIXEL

	@ 000, 000 MSPANEL oPanel1 SIZE 377, 132 OF oDlg COLORS 0, 15920613 RAISED

	@ 002, 003 GROUP oGroup1 TO 114, 374 PROMPT " Dados da Viagem " OF oPanel1 COLOR 8388608, 15920613 PIXEL
	@ 016, 010 SAY oSay1 PROMPT "C๓digo: " SIZE 021, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
	@ 016, 031 SAY oCodSeq PROMPT ZV1->ZV1_COD+"/"+ZV1->ZV1_SEQ SIZE 035, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
	@ 016, 070 SAY oSay2 PROMPT "Solicitante: " SIZE 028, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
	@ 016, 099 SAY oNomeSolic PROMPT ZV1->ZV1_NSOLIC SIZE 130, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL

/*    @ 027, 010 SAY oSay3 PROMPT "Emissใo: " SIZE 023, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
    @ 027, 033 SAY oEmissao PROMPT DTOC(ZV1->ZV1_EMISSA) SIZE 032, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL*/

    @ 027, 010 SAY oSay3 PROMPT "Vencim.: " SIZE 023, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
    @ 027, 033 SAY oEmissao PROMPT DTOC(ZV1->ZV1_DTVENC) SIZE 032, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL //13/10/16

    
    @ 027, 070 SAY oSay5 PROMPT "Colaborador:" SIZE 033, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
    @ 027, 103 SAY oMatricula PROMPT ZV1->ZV1_MATRIC+"-"+ZV1->ZV1_NFUNC SIZE 200, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
    @ 038, 010 SAY oSay7 PROMPT "Origem/Destino: " SIZE 042, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
    @ 038, 053 SAY oOrigDest PROMPT Alltrim(ZV1->ZV1_NCORIG)+"-"+ZV1->ZV1_ESTORI+"/"+Alltrim(ZV1->ZV1_NCDEST)+"-"+ZV1->ZV1_ESTDES SIZE 182, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
    @ 038, 220 SAY oSay13 PROMPT "Perํodo de: " SIZE 032, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
    @ 038, 285 SAY oSay14 PROMPT "at้: " SIZE 015, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
    @ 038, 253 SAY oDataIni PROMPT DTOC(ZV1->ZV1_DTINI) SIZE 030, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
    @ 038, 300 SAY oDataFim PROMPT DTOC(ZV1->ZV1_DTFIM) SIZE 030, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
    
    @ 049, 007 GROUP oGroup2 TO 075, 370 PROMPT " Dados do Adiantamento " OF oPanel1 COLOR 8388608, 15920613 PIXEL
    @ 060, 012 SAY oSay4 PROMPT "Prefixo: " SIZE 021, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
    @ 060, 036 SAY oPrfPA PROMPT ZV1->ZV1_PREFIX SIZE 023, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
    @ 060, 060 SAY oSay6 PROMPT "N๚mero: " SIZE 025, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
    @ 060, 085 SAY oNumPA PROMPT ZV1->ZV1_NUMPA SIZE 027, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
    @ 060, 114 SAY oSay10 PROMPT "Tipo: " SIZE 015, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
    @ 060, 130 SAY oTipoPA PROMPT ZV1->ZV1_TIPOPA SIZE 022, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
    @ 060, 156 SAY oSay15 PROMPT "Valor: " SIZE 016, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
    @ 060, 174 SAY oValPA PROMPT Transform(ZV1->ZV1_TOTADI,"@E 999,999,999.99") SIZE 041, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
    @ 060, 220 SAY oSay16 PROMPT "Banco: " SIZE 020, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
    @ 060, 241 SAY oBcoPA PROMPT ZV1->ZV1_BANCO SIZE 023, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
    @ 060, 266 SAY oSay17 PROMPT "Ag๊ncia: " SIZE 025, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
    @ 060, 292 SAY oAgPA PROMPT ZV1->ZV1_AGENCI SIZE 021, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
    @ 060, 314 SAY oSay18 PROMPT "Conta: " SIZE 020, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
    @ 060, 333 SAY oContaPA PROMPT ZV1->ZV1_CONTA SIZE 033, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL

    @ 080, 007 GROUP oGroup3 TO 106, 370 PROMPT " Dados da Presta็ใo " OF oPanel1 COLOR 8388608, 15920613 PIXEL
    @ 090, 012 SAY oSay19 PROMPT "Prefixo: " SIZE 024, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
    @ 090, 035 SAY oPrfNF PROMPT ZV1->ZV1_PREFPC SIZE 017, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
    @ 090, 060 SAY oSay20 PROMPT "N๚mero:" SIZE 025, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
    @ 090, 085 SAY oNumNF PROMPT ZV1->ZV1_TITPC SIZE 024, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
    @ 090, 114 SAY oSay21 PROMPT "Tipo:" SIZE 016, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
    @ 090, 130 SAY oTipoNF PROMPT ZV1->ZV1_TIPOPC SIZE 025, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
    @ 090, 156 SAY oSay22 PROMPT "Valor:" SIZE 018, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
    @ 090, 174 SAY oValNF PROMPT Transform(ZV1->ZV1_TOTRET,"@E 999,999,999.99") SIZE 033, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
    @ 090, 220 SAY oSay23 PROMPT "Banco:" SIZE 025, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
    @ 090, 241 SAY oBcoNF PROMPT ZV1->ZV1_BANCO SIZE 019, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
    @ 090, 266 SAY oSay24 PROMPT "Agencia:" SIZE 025, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
    @ 090, 292 SAY oAgNF PROMPT ZV1->ZV1_AGENCI SIZE 018, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
    @ 090, 314 SAY oSay25 PROMPT "Conta:" SIZE 025, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
    @ 090, 333 SAY oContaNF PROMPT ZV1->ZV1_CONTA SIZE 029, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL

    @ 117, 288 BUTTON oButton1 PROMPT "Compensar" SIZE 037, 012 OF oPanel1 PIXEL Action(lOk:=.T.,oDlg:end())
    @ 117, 331 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oPanel1 PIXEL Action oDlg:End()
    @ 123, 002 SAY oSay12 PROMPT "Powered by Sigacorp" SIZE 059, 007 OF oPanel1 COLORS 8421504, 15920613 PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED  
  
	If lOK
		U_ExecCompCV()
	EndIf

Return      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExecCompCV บAutor  Denis Haruo       บ Data ณ  09/14/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExecuta a compensa็ใo automแtica da viagem                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ExecCompCV(cViagem,cSeq)

	Local cPrefPA := ""
	Local cNumPA := ""
	//Local cParcPA := " "
	Local cTipoPA := ""
	Local cPrefPC := ""
	Local cNumPC := ""
	//Local cParcPC := " "
	Local cTipoPC := ""
	Local aRecPA := {}
	Local aRecPC := {}
	Local lContabiliza:=lAglutina:=lDigita:=.F.
	Local dBaixaCMP := dDataBase
	Local cFornece := ""
	Local lRet := .F.
	Local _cTiPA3:=GetMV("AL_TIPOPA3") //04/11/16

	DBSelectArea("ZV1")
	DBSetOrder(1)
	DBSeek(xFilial("ZV1")+cViagem+cSeq)
	cPrefPA   := ZV1->ZV1_PREFIX
	cNumPA 	 := ZV1->ZV1_NUMPA
	cTipoPA   := ZV1->ZV1_TIPOPA
	cPrefPC   := ZV1->ZV1_PREFPC
	cNumPC    := ZV1->ZV1_TITPC
	cTipoPC   := ZV1->ZV1_TIPOPC
	dBaixaCMP := dDataBase
	cFornece  := ZV1->ZV1_CODSA2

	CONOUT("ExecCompCV1")

//Titulo da PA
	cQuery := ""
	cQuery += "SELECT R_E_C_N_O_ FROM "+RetSQLName("SE2")+" "
	cQuery += "WHERE 	E2_FILIAL = '"+xFilial("SE2")+"' AND "
	cQuery += "			E2_PREFIXO = 'GVI' AND "
	cQuery += "			E2_PARCELA = '1' AND "//01/12/16
	cQuery += "			E2_NUM = '"+STRZERO(val(ZV1->ZV1_COD),9)+"' AND "
	cQuery += "			E2_TIPO = 'PA' AND "
	cQuery += "			E2_FORNECE+E2_LOJA = '"+cFornece+"' AND "
	cQuery += "			D_E_L_E_T_ <> '*' "
	TCQuery cQuery NEW ALIAS "QRY"
	DBSelectArea("QRY")
	IF !EOF()
		aAdd(aRecPA,QRY->R_E_C_N_O_)
	EndIf
	QRY->(DBCloseArea())

//Titulo da NF
	cQuery := ""
	cQuery += "SELECT R_E_C_N_O_ FROM "+RetSQLName("SE2")+" "
	cQuery += "WHERE 	E2_FILIAL = '"+xFilial("SE2")+"' AND "
	cQuery += "			E2_PREFIXO = 'GVI' AND " //01/12/16
	cQuery += "			E2_PARCELA = '2' AND "//01/12/16 //Titulo definitivo
	cQuery += "			E2_NUM = '"+STRZERO(val(ZV1->ZV1_COD),9)+"' AND "
	cQuery += "			E2_TIPO = '"+rtrim(_cTiPA3)+"' AND "
	cQuery += "			E2_FORNECE+E2_LOJA = '"+cFornece+"' AND "
	cQuery += "			D_E_L_E_T_ <> '*' "
	TCQuery cQuery NEW ALIAS "QRY"
	DBSelectArea("QRY")
	IF !EOF()
		Do While !EOF()
			aAdd(aRecPC,QRY->R_E_C_N_O_)
			DBSkip()
		EndDo
	EndIf
	QRY->(DBCloseArea())

	If !MaIntBxCP(2,aRecPC,,aRecPA,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.},,,,dBaixaCMP)
		CONOUT("ExecCompCV2")
		MSGInfo("Problemas com a compensa็ใo automแtica. ","ExecCompCV()")
		lRet := .F.
	Else
		CONOUT("ExecCompCV3")
		DBSelectArea("ZV1")
		DBSetOrder(1)
		If DBSeek(xFilial("ZV1")+cViagem+cSeq,.F.)
			Reclock("ZV1",.F.)
			ZV1->ZV1_STATUS := '7'
			MSUnlock()
		EndIf
		MSGInfo("Viagem compensada e encerrada.","ExecCompCV()")
		lRet := .T.
	EndIf

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  WFViagem  บAutor  Denis Haruo           บ Data ณ  07/31/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvio de Autoriza็ใo de Viagem pelo Wflow                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function WFViagem(cViagem,cSeq,cAprovador)
	Local oHTML,oProcess

	//Local aDataBco := {}
	Private _cIpProd:=GetMV("AL_IPSRVPR")//05/08/16 - Fabio Yoshioka
	Private _cIpTest:=GetMV("AL_IPSRVTS")//05/08/16
	Private _cPrcSrvI:=GetMV("AL_PRWFINT")//08/08/16
	Private _cPrcSrvE:=GetMV("AL_PRWFEXT")//08/08/16
	lServProd := IIf(GetEnvServer() $ 'PROTHEUS12_AE#WORKFLOW', .T.,.F.)

	If cSeq == '001' //Inclusใo de Viagem
		oProcess:= TWFProcess():New("WFVIAGEM","Aprova็ใo de Viagem ao Colaborador: "+cViagem+cSeq)
		oProcess:NewTask("Montagem da Aprovacao ZV1", "\Workflow\CONTROLEVIAGENS\AprovaZV1_page.html")
		oHtml	:= oProcess:oHTML
	Else //Prorroga็ใo da Viagem: 002, 003, 004...
		oProcess:= TWFProcess():New("WFVIAGEM","Aprova็ใo Prorrog de Viagem ao Colaborador: "+cViagem+cSeq)
		oProcess:NewTask("Montagem da Aprovacao ZV1", "\Workflow\CONTROLEVIAGENS\ProrrogaZV1_page.html")
		oHtml	:= oProcess:oHTML
	EndIf

	Conout("MONTANDO PAGINA DO PROCESSO DE CONTROLE DE VIAGEM: "+cViagem+cSeq)
	DBSelectArea("ZV1")
	DBSetOrder(1)
	DBSeek(xFilial("ZV1")+cViagem+cSeq)
//Assinalando novos valores เs macros existentes no html:
//Cabe็alho
	oProcess:oHtml:ValByName("cViagem"		, cViagem )
	oProcess:oHtml:ValByName("cSeq"			, cSeq )
	oProcess:oHtml:ValByName("cData"  		, DTOC(dDatabase) )
	oProcess:oHtml:ValByName("cHora"  		, SubStr(Time(),1,5) )
	oProcess:oHtml:ValByName("cColaborador", ZV1->ZV1_NFUNC )
	oProcess:oHtml:ValByName("cSolicitante", Alltrim(UsrRetName(ZV1->ZV1_CODSOL)))
	oProcess:oHtml:ValByName("cCodSol"		, ZV1->ZV1_CODSOL )
	oProcess:oHtml:ValByName("cAprovador"	, Alltrim(UsrRetName(cAprovador)))
	oProcess:oHtml:ValByName("cCodApr"		, cAprovador )
//oProcess:oHtml:ValByName("cEmissao"		, DTOC(ZV1->ZV1_EMISSA))
	oProcess:oHtml:ValByName("cEmissao"		, DTOC(ZV1->ZV1_EMISSA)) //13/10/16
	oProcess:oHtml:ValByName("cTipo"			, IIF(ZV1->ZV1_TIPO=="S","SERVIวO","TREINAMENTO"))
	oProcess:oHtml:ValByName("cDataIni"		, DTOC(ZV1->ZV1_DTINI))
	oProcess:oHtml:ValByName("cDataFim"		, DTOC(ZV1->ZV1_DTFIM))
	oProcess:oHtml:ValByName("cMotivo"		, ZV1->ZV1_MOTVIA )
	oProcess:oHtml:ValByName("cObs"			, ZV1->ZV1_OBS1)
	oProcess:oHtml:ValByName("cOrigem"		, Alltrim(ZV1->ZV1_NCORIG)+"-"+Alltrim(ZV1->ZV1_ESTORI))
	oProcess:oHtml:ValByName("cDestino"		, Alltrim(ZV1->ZV1_NCDEST)+"-"+Alltrim(ZV1->ZV1_ESTDES))

//Caregando dados bancarios no HTML                
/*aAdd(aDataBco,IIF(Empty(ZV1->ZV1_BANCO) ,"BPA"			,ZV1->ZV1_BANCO))
aAdd(aDataBco,IIF(Empty(ZV1->ZV1_AGENCI),"00000"		,ZV1->ZV1_AGENCI)) 
aAdd(aDataBco,IIF(Empty(ZV1->ZV1_CONTA) ,"0000000000"	,ZV1->ZV1_CONTA))
aAdd(aDataBco,IIF(Empty(ZV1->ZV1_CHEQUE),Space(10)		,ZV1->ZV1_CHEQUE)) 
aAdd(aDataBco,IIF(Empty(ZV1->ZV1_DTCHEQ),DTOC(dDatabase),ZV1->ZV1_DTCHEQ)) */ // pagamento antecipado serแ tratado na rotina de controle de PA - Fabio Yoshioka

//Despesas da Viagem
Conout("CARREGANDO AS DESPESAS DA VIAGEM: "+cViagem+cSeq)                                      
nTotal := 0
DBSelectArea("ZV2")
DBSetOrder(2)
DBSeek(xFilial("ZV2")+cViagem+cSeq)
Do While !EOF() .and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA+ZV2->ZV2_SEQ == xFilial("ZV2")+cViagem+cSeq
	AAdd( ( oHtml:ValByName( "it.cod" 		)), ZV2->ZV2_CODIGO )		
	AAdd( ( oHtml:ValByName( "it.descri" 	)), ZV2->ZV2_DESCRI )		       
	AAdd( ( oHtml:ValByName( "it.quant" 	)), Transform( ZV2->ZV2_QUANT ,'@E 999,999,999.99' ))
	AAdd( ( oHtml:ValByName( "it.valor" 	)), Transform( ZV2->ZV2_VALOR,'@E 999,999,999.99' )) 
	nTotal += ZV2->ZV2_VALOR
	DBSkip()
EndDo		
oProcess:oHtml:ValByName("cTotalAdi", Transform(nTotal,'@E 999,999,999.99'))

//Dados Bancarios
/*oProcess:oHtml:ValByName("cBanco"	,aDataBco[1])
oProcess:oHtml:ValByName("cAgencia"	,aDataBco[2])
oProcess:oHtml:ValByName("cConta"	,aDataBco[3])
oProcess:oHtml:ValByName("cCheque"	,aDataBco[4])
oProcess:oHtml:ValByName("cPagto"	,aDataBco[5])*/

// Fun็ใo de retorno a ser executada quando a mensagem de respostas retornar ao Workflow:
oProcess:bReturn := "U_RetWFZV1()"

//Guardo o ID do Processo para enviar no link
cMailID := oProcess:Start()
oHtml:SaveFile("web\ws\wflow\CONTROLEVIAGENS\"+cMailID+".HTM")     	//Salvo HTML do Processo
cRet := WFLoadFile("web\ws\wflow\CONTROLEVIAGENS\"+cMailID+".HTM")	//Carrego o link do Processo (serแ usado no retorno da Aprova็ใo)

//Preparo a nova terefa... Envio do link
Conout("PREPARANDO O LINK DE CONTROLE DE VIAGEM: "+cViagem+cSeq)                                      

If cSeq == '001'
	oProcess:NewTask("Envio de Link de Aprovacao ZV1","\Workflow\CONTROLEVIAGENS\AprovaZV1_link.html")  
Else
	oProcess:NewTask("Envio de Link de Aprovacao ZV1","\Workflow\CONTROLEVIAGENS\ProrrogaZV1_link.html")  
EndIf	

DBSelectArea("ZV1")
DBSetOrder(1)
DBSeek(xFilial("ZV1")+cViagem+cSeq)
//Assinalando novos valores เs macros existentes no html:
//Cabe็alho
oProcess:oHtml:ValByName("cViagem"		, cViagem)
oProcess:oHtml:ValByName("cSeq"			, cSeq)
oProcess:oHtml:ValByName("cData"  		, DTOC(dDatabase) )
oProcess:oHtml:ValByName("cHora"  		, SubStr(Time(),1,5) )
oProcess:oHtml:ValByName("cColaborador", ZV1->ZV1_NFUNC )
oProcess:oHtml:ValByName("cSolicitante", Alltrim(UsrRetName(ZV1->ZV1_CODSOL)))
oProcess:oHtml:ValByName("cCodSol"		, ZV1->ZV1_CODSOL )
oProcess:oHtml:ValByName("cAprovador"	, Alltrim(UsrRetName(cAprovador)))
oProcess:oHtml:ValByName("cCodApr"		, cAprovador )
oProcess:oHtml:ValByName("cEmissao"		, DTOC(ZV1->ZV1_EMISSA))
oProcess:oHtml:ValByName("cTipo"			, IIF(ZV1->ZV1_TIPO=="S","SERVIวO","TREINAMENTO"))
oProcess:oHtml:ValByName("cDataIni"		, DTOC(ZV1->ZV1_DTINI))
oProcess:oHtml:ValByName("cDataFim"		, DTOC(ZV1->ZV1_DTFIM))
oProcess:oHtml:ValByName("cMotivo"		, ZV1->ZV1_MOTVIA )
oProcess:oHtml:ValByName("cObs"			, ZV1->ZV1_OBS1)
oProcess:oHtml:ValByName("cOrigem"		, Alltrim(ZV1->ZV1_NCORIG)+"-"+Alltrim(ZV1->ZV1_ESTORI))  
oProcess:oHtml:ValByName("cDestino"		, Alltrim(ZV1->ZV1_NCDEST)+"-"+Alltrim(ZV1->ZV1_ESTDES)) 

//Despesas da Viagem
Conout("CARREGANDO AS DESPESAS DA VIAGEM: "+cViagem+cSeq)
nTotal := 0
DBSelectArea("ZV2")
DBSetOrder(2)
DBSeek(xFilial("ZV2")+cViagem+cSeq)
Do While !EOF() .and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA+ZV2->ZV2_SEQ == xFilial("ZV2")+cViagem+cSeq
	AAdd( ( oHtml:ValByName( "it.cod" 		)), ZV2->ZV2_CODIGO )		
	AAdd( ( oHtml:ValByName( "it.descri" 	)), ZV2->ZV2_DESCRI )		       
	AAdd( ( oHtml:ValByName( "it.quant" 	)), Transform( ZV2->ZV2_QUANT ,'@E 999,999,999.99' ))
	AAdd( ( oHtml:ValByName( "it.valor" 	)), Transform( ZV2->ZV2_VALOR ,'@E 999,999,999.99' )) 
	nTotal += ZV2->ZV2_VALOR
	DBSkip()
EndDo		
oProcess:oHtml:ValByName("cTotalAdi", Transform(nTotal,'@E 999,999,999.99'))

//Asinalando o Link para aprova็ใo
If lServProd
/*	oProcess:ohtml:ValByName("proc_localink","http://181.41.169.77:8082/Microsiga/PROTHEUS_DATA/web/ws/wflow/CONTROLEVIAGENS/"+cMailID+".htm") 
	oProcess:ohtml:ValByName("proc_weblink" ,"http://200.241.243.21:8082/Microsiga/PROTHEUS_DATA/web/ws/wflow/CONTROLEVIAGENS/"+cMailID+".htm")	*/
	oProcess:ohtml:ValByName("proc_localink",_cPrcSrvI+"CONTROLEVIAGENS/"+cMailID+".htm") //02/11/16
	oProcess:ohtml:ValByName("proc_weblink" ,_cPrcSrvE+"CONTROLEVIAGENS/"+cMailID+".htm")	
Else
	//oProcess:ohtml:ValByName("proc_localink","http://181.41.169.147:8090/PROTHEUS_DATA_REPLICADO/web/ws/wflow/CONTROLEVIAGENS/"+cMailID+".htm")	
	oProcess:ohtml:ValByName("proc_localink",RTRIM("http://"+_cIpTest+":8800/web/ws/wflow/")+"CONTROLEVIAGENS/"+cMailID+".htm")	 //02/11/16
EndIf	 

If cSeq == '001'
	oProcess:cSubject := "Aprova็ใo adiantamento de viagem: " + cViagem+cSeq
Else
	oProcess:cSubject := "Aprova็ใo de prorroga็ใo de viagem: " + cViagem+cSeq
EndIf
oProcess:cTo := Alltrim(&('GetMv("AL_MAILADM")')) + IIF(lServProd,+";"+Alltrim(UsrRetMail(cAprovador)),"")
oProcess:start()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetWFZV1   บAutor  Denis Haruo      บ Data ณ  08/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorno do Processo de autoriza็ใo                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RetWFZV1(oProcess)

	//Local oHtml := oProcess:oHtml
	Local cCodApr := oProcess:oHtml:RetByName("cCodApr")
	Local lYESNO := IIF(oProcess:oHtml:RetByName("RBAPROVA") = "Sim",.T.,.F.)
	Local cViagem := oProcess:oHtml:RetByName("cViagem")
	Local cSeq 	:= oProcess:oHtml:RetByName("cSeq")
	//Local nTotal := AjustaNum(oProcess:oHtml:RetByName("cTotalAdi"))
	Local cMotRej := oProcess:oHtml:RetByName("lbmotivo")
	Local lAprov1 := .F.
	Local lAprov2 := .F.
	//Local lFimApro := .F.
	//Local aDataBco := {} //Contem os erros bancarios encontrados no retorno
	Private _cNatuPA:=GetMV("AL_NATURPA")//10/08/16

	DBSelectArea("ZV1")
	DBSetOrder(1)
	DBSeek(xFilial("ZV1")+cViagem+cSeq)
	lAprov1 := IIF(Empty(ZV1->ZV1_APROV1),.F.,.T.)
	lAprov2 := IIF(Empty(ZV1->ZV1_APROV2),.F.,.T.)

	If lYesNo

		//Primeira aprova็ใo...
		If !lAprov1 .and. !lAprov2

			DBSelectArea("ZV1")
			Reclock("ZV1",.F.)
			ZV1->ZV1_APROV1 	:= cCodApr
			ZV1->ZV1_NAPRO1 	:= Upper(UsrRetName(cCodApr))
			ZV1->ZV1_DTAPR1 	:= Date()
			ZV1->ZV1_HRAPR1 	:= SubStr(Time(),1,5)
			ZV1->ZV1_STATUS 	:= "2"
			MSUnlock()

			//Encerro o processo aqui...
			oProcess:Finish()
			NotifZV1(cViagem,cSeq,lYesNo)

			//Crio o registro de PA na tabela de controle de PA's - Fabio Yoshioka -30/09/16
			Dbselectarea("ZPA")
			Reclock("ZPA",.T.)
			ZPA->ZPA_FILIAL := XFILIAL("ZPA")
			ZPA->ZPA_TIPOPA := '2'
			ZPA->ZPA_PREFIX := 'GVI'
			ZPA->ZPA_NUM    := STRZERO(val(ZV1->ZV1_COD),9)
			ZPA->ZPA_PARCEL := '1'
			ZPA->ZPA_TIPO   := 'PR'
			ZPA->ZPA_FORNEC := ZV1->ZV1_CODSA2
			ZPA->ZPA_LOJA   := '01'
			ZPA->ZPA_NOMFOR := POSICIONE("SA2",1,XFILIAL("SA2")+ZV1->ZV1_CODSA2, 'A2_NOME' )
			ZPA->ZPA_DTEMIS := dDataBase
			ZPA->ZPA_VALOR  := ZV1->ZV1_TOTADI
			ZPA->ZPA_NATURE := _cNatuPA
			ZPA->ZPA_VENCTO := ZV1->ZV1_DTVENC //dDataBase
			ZPA->ZPA_CC     := ZV1->ZV1_CC
			ZPA->ZPA_SOLICI := ZV1->ZV1_CODSOL
			ZPA->ZPA_NOMESO := ZV1->ZV1_NSOLIC
			ZPA->ZPA_HIST   := ZV1->ZV1_MOTVIA
			ZPA->ZPA_STATUS := 'L'
			ZPA->ZPA_APROV1 := cCodApr
			ZPA->ZPA_NAPRO1 := Upper(UsrRetName(cCodApr))
			ZPA->ZPA_DTAPR1 := Date()
			ZPA->ZPA_HRAPR1 := SubStr(Time(),1,5)
			MSUnlock()

			_nRegZPA:=ZPA->(RECNO())
			//_cChvZPA:=XFILIAL("ZPA")+"PA2"+ZV1->ZV1_COD+'  '+'PR '+ZV1->ZV1_CODSA2+'01'
		/*
		
		CONOUT("RECNO ZPA:"+STR(_nRegZPA))
		//Desabilitando a visualiza็ใo do Lan็amento Contab.
		DBSELECTAREA("SX1")
		DBSetOrder(1)
		DBSeek("FIN050    "+"01")
		RecLock("SX1",.F.)
		 (cAliasTmp)->(X1_PRESEL) := 2 //Mostra Lancto = Nใo
		MSUnlock()	

		DBSeek("FIN050    "+"04")
		RecLock("SX1",.F.)
		 (cAliasTmp)->(X1_PRESEL) := 2 //Contabiliza on Line = NAO         
		MSUnlock()	
		
		DBSeek("FIN050    "+"05")
		RecLock("SX1",.F.)
		 (cAliasTmp)->(X1_PRESEL) := 2 //Gerar Chq.p/Adiant. = NAO                  
		MSUnlock()	

		DBSeek("FIN050    "+"09")
		RecLock("SX1",.F.)
		 (cAliasTmp)->(X1_PRESEL) := 2 //Mov.Banc.sem Cheque = NAO              
		MSUnlock()	
		/*/
		
		DBSelectARea("ZPA")
		DbGoTo(_nRegZPA)

			_lTemSe2:=.F.				
			_cQrySE2 := " "
			_cQrySE2 += "SELECT * FROM "+RetSQLName("SE2")+" "
			_cQrySE2 += "WHERE	E2_FILIAL = '"+xFilial("SE2")+"' AND "
			_cQrySE2 += "			E2_PREFIXO = '"+RTRIM(ZPA->ZPA_PREFIX)+"' AND "
			_cQrySE2 += "			E2_NUM = '"+RTRIM(ZPA->ZPA_NUM)+"' AND "
			_cQrySE2 += "			E2_PARCELA = '"+RTRIM(ZPA->ZPA_PARCEL)+"' AND "		
			_cQrySE2 += "			E2_TIPO = '"+RTRIM(ZPA->ZPA_TIPO)+"' AND "	 // Tํtulo provis๓rio
			_cQrySE2 += "			E2_FORNECE = '"+RTRIM(ZPA->ZPA_FORNEC)+"' AND "		
			_cQrySE2 += "			E2_LOJA = '"+RTRIM(ZPA->ZPA_LOJA)+"' AND "		
			_cQrySE2 += "			D_E_L_E_T_ <> '*' "
			DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQrySE2), "TSE2", .F., .T.) 
			IF !TSE2->(EOF()) .AND. !TSE2->(BOF())
				_lTemSe2:=.T.		
			ENDIF

			IF !_lTemSe2
					
				aTitulo := {}

				//INCLUSAO DE TITULO PROVISORIO - 10/08/16
				aTitulo :={	{"E2_FILIAL"	,xFilial("ZPA")	,Nil},;
							{"E2_PREFIXO", ZPA->ZPA_PREFIX, Nil},;
							{"E2_NUM"    , ZPA->ZPA_NUM   , Nil},;
							{"E2_PARCELA", ZPA->ZPA_PARCEL, Nil},;
							{"E2_TIPO"   , ZPA->ZPA_TIPO  , Nil},;
							{"E2_NATUREZ", ZPA->ZPA_NATURE, Nil},;
							{"E2_FORNECE", ZPA->ZPA_FORNEC, Nil},;
							{"E2_LOJA"   , ZPA->ZPA_LOJA  , Nil},;
							{"E2_EMISSAO", ZPA->ZPA_DTEMIS, NIL},;
							{"E2_VENCTO" , ZPA->ZPA_VENCTO, NIL},;
							{"E2_VENCREA", ZPA->ZPA_VENCTO, NIL},;
							{"E2_VALOR"  , ZPA->ZPA_VALOR , Nil},;
							{"E2_VLCRUZ" , ZPA->ZPA_VALOR , Nil},;
							{"E2_STATWF" , "LB"           , Nil},;
							{"E2_CC"     , ZPA->ZPA_CC    , Nil}}

				*****************************	
				//Inicio a inclusใo do titulo
				*****************************	
				lMsErroAuto := .F.
				Conout("Executando EXECAUTO "+ZPA->ZPA_NUM)
				MSExecAuto({|x,y,z| Fina050(x,y,z)},aTitulo,,3) //Inclusao  
				/*
				RECLOCK("SE2",.T.)
				E2_FILIAL  := xFilial("ZPA")
				E2_PREFIXO := ZPA->ZPA_PREFIX
				E2_NUM     := ZPA->ZPA_NUM
				E2_PARCELA := ZPA->ZPA_PARCEL
				E2_TIPO    := ZPA->ZPA_TIPO
				E2_NATUREZ := ZPA->ZPA_NATURE
				E2_FORNECE := ZPA->ZPA_FORNEC
				E2_LOJA    := ZPA->ZPA_LOJA
				E2_EMISSAO := ZPA->ZPA_DTEMIS
				E2_VENCTO  := ZPA->ZPA_VENCTO
				E2_VENCREA := ZPA->ZPA_VENCTO
				E2_VALOR   := ZPA->ZPA_VALOR
				E2_VLCRUZ  := ZPA->ZPA_VALOR
				E2_SALDO   := ZPA->ZPA_VALOR
				//E2_HIST    := "Reemb Desp "+rtrim(cNomFavo)
				E2_EMIS1   := DDATABASE
				E2_VENCORI := ZPA->ZPA_VENCTO
				E2_MOEDA   := 1
				E2_STATWS  := "LB"
				E2_CC 	:= ZPA->ZPA_CC
				MSUNLOCK()
				*/

			If lMsErroAuto
				//Caso encontre erro, mostre
				Conout("Erro do EXECAUTO "+ZPA->ZPA_NUM)
				//Mostraerro()
			Else
				Conout("Exito na Grava็ใo Atualizando ZPA "+ZPA->ZPA_NUM)
				//DBSelectARea("ZPA")
				//ZPAYESNO(aChave,cDestinat,lYesNo)

			Endif

		ELSE
			Conout("Titulo Provis๓rio existente no SE1 "+ZPA->ZPA_NUM)

//				ZPAYESNO(aChave,cDestinat,lYesNo)	
		EndIf

		//Endif

		//Segunda aprova็ใo, final... - realizado na rotina de controlde de PA
	/*ElseIf lAprov1 .and. !lAprov2
	
		Conout("Aprovando Viagem "+cViagem+cSeq+" Nivel 2 por: "+Upper(UsrRetName(cCodApr))) 
		Reclock("ZV1",.F.)
		ZV1->ZV1_APROV2 := cCodApr
		ZV1->ZV1_NAPRO2 := Upper(UsrRetName(cCodApr))
		ZV1->ZV1_DTAPR2 := Date()
		ZV1->ZV1_HRAPR2 := SubStr(Time(),1,5)
		ZV1->ZV1_STATUS := "3" //Autorizada
		MSUnlock()       
		
		//Encerro o processo aqui...			
		oProcess:Finish()
		
		conout("Preparando o adiantamento")
		U_GeraPAZV1(cViagem,cSeq)           
		NotifZV1(cViagem,cSeq,lYesNo)*/
		
	EndIf			
Else
	If !lAprov1 .and. !lAprov2
		Conout("Rejeitando Viagem "+cViagem+cSeq+" Nivel 1 e Nivel 2 por: "+Upper(UsrRetName(cCodApr))) 
		Reclock("ZV1",.F.)
		ZV1->ZV1_APROV1 := cCodApr
		ZV1->ZV1_NAPRO1 := Upper(UsrRetName(cCodApr))
		ZV1->ZV1_DTAPR1 := Date()
		ZV1->ZV1_HRAPR1 := SubStr(Time(),1,5)
		ZV1->ZV1_APROV2 := cCodApr
		ZV1->ZV1_NAPRO2 := Upper(UsrRetName(cCodApr))
		ZV1->ZV1_DTAPR2 := Date()
		ZV1->ZV1_HRAPR2 := SubStr(Time(),1,5)
		ZV1->ZV1_STATUS := "8" //Rejeitada
		ZV1->ZV1_MOTREJ := cMotrej
		MSUnlock()

		//Encerro o processo aqui...			
		oProcess:Finish()      
	
		//Notificando o usuario
		NotifZV1(cViagem,cSeq,lYesNo)  
		
		

	/*ElseIf lAprov1 .and. !lAprov2
		
		Conout("Rejeitando Viagem "+cViagem+cSeq+" Nivel 2 por: "+Upper(UsrRetName(cCodApr))) 
		Reclock("ZV1",.F.)
		ZV1->ZV1_APROV2 := cCodApr
		ZV1->ZV1_NAPRO2 := Upper(UsrRetName(cCodApr))
		ZV1->ZV1_DTAPR2 := Date()
		ZV1->ZV1_HRAPR2 := SubStr(Time(),1,5) 
		ZV1->ZV1_STATUS := "8" //Rejeitada
		ZV1->ZV1_MOTREJ := cMotrej
		MSUnlock()
		
		//Encerrando o processo
		oProcess:Finish()
	
		//Notificando o usuario
		NotifZV1(cViagem,cSeq,lYesNo)		*/
	
	EndIf
EndIf

Return()  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  EnviaErro   บAutor  Denis Haruo          บ Data ณ  08/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia o Erro de dados bancarios ao 1o aprovador            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EnviaErro(cViagem,cSeq,cCodApr,aDataBco)
	//Local _cIpProd:=GetMV("AL_IPSRVPR")//05/08/16 - Fabio Yoshioka
	//Local _cIpTest:=GetMV("AL_IPSRVTS")//05/08/16
	Local oHTML,oProcess
	Local lServProd := IIf(GetEnvServer() $ 'PROTHEUS12_AE#WORKFLOW', .T.,.F.)

	oProcess:= TWFProcess():New("WFVIAGEM","Erro na Autorizacao de Viagem num: "+cViagem)
	oProcess:NewTask("Montagem do HTML", "\Workflow\CONTROLEVIAGENS\AprovaZV1_erro.html")
	oHtml	:= oProcess:oHTML

	DBSelectArea("ZV1")
	DBSetOrder(1)
	DBSeek(xFilial("ZV1")+cViagem+cSeq)
//Assinalando novos valores เs macros existentes no html:
//Cabe็alho        
	oProcess:oHtml:ValByName("cViagem"		, cViagem)
	oProcess:oHtml:ValByName("cSeq"			, cSeq )
	oProcess:oHtml:ValByName("cData"  		, DTOC(dDatabase))
	oProcess:oHtml:ValByName("cHora"  		, SubStr(Time(),1,5))
	oProcess:oHtml:ValByName("cSolicitante", Alltrim(UsrRetName(ZV1->ZV1_CODSOL)))
	oProcess:oHtml:ValByName("cCodSol"		, ZV1->ZV1_CODSOL)
	oProcess:oHtml:ValByName("cEmissao"		, DTOC(ZV1->ZV1_EMISSA))
	oProcess:oHtml:ValByName("cAprovador"	, Alltrim(UsrRetName(cCodApr)))
	oProcess:oHtml:ValByName("cCodApr"		, cCodApr)
	oProcess:oHtml:ValByName("cTipo"		, IIF(ZV1->ZV1_TIPO=="S","SERVIวO","TREINAMENTO"))
	oProcess:oHtml:ValByName("cDataIni"		, DTOC(ZV1->ZV1_DTINI))
	oProcess:oHtml:ValByName("cDataFim"		, DTOC(ZV1->ZV1_DTFIM))
	oProcess:oHtml:ValByName("cMotivo"		, ZV1->ZV1_MOTVIA )
	oProcess:oHtml:ValByName("cObs"			, ZV1->ZV1_OBS1)
	oProcess:oHtml:ValByName("cOrigem"		, Alltrim(ZV1->ZV1_NCORIG)+"-"+Alltrim(ZV1->ZV1_ESTORI))
	oProcess:oHtml:ValByName("cDestino"		, Alltrim(ZV1->ZV1_NCDEST)+"-"+Alltrim(ZV1->ZV1_ESTDES))

//Despesas da Viagem
	Conout("CARREGANDO AS DESPESAS DA VIAGEM: "+cViagem+cSeq)
	nTotal := 0
	DBSelectArea("ZV2")
	DBSetOrder(2)
	DBSeek(xFilial("ZV2")+cViagem+cSeq)
	Do While !EOF() .and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA+ZV2->ZV2_SEQ == xFilial("ZV2")+cViagem+cSeq
		AAdd( ( oHtml:ValByName( "it.cod" 		)), ZV2->ZV2_CODIGO )
		AAdd( ( oHtml:ValByName( "it.descri" 	)), ZV2->ZV2_DESCRI )
		AAdd( ( oHtml:ValByName( "it.quant" 	)), Transform( ZV2->ZV2_QUANT ,'@E 999,999,999.99' ))
		AAdd( ( oHtml:ValByName( "it.valor" 	)), Transform( ZV2->ZV2_VALOR ,'@E 999,999,999.99' ))
		nTotal += ZV2->ZV2_VALOR
		DBSkip()
	EndDo
	oProcess:oHtml:ValByName("cTotalAdi", Transform(nTotal,'@E 999,999,999.99'))

	oProcess:cSubject := "Erro na Aprova็ใo do Adiantamento de Viagem: "+cViagem+cSeq
	oProcess:cTo := Alltrim(&('GetMv("AL_MAILADM")'))+ IIF(lServProd,+";"+Alltrim(UsrRetMail(cCodApr)),"")
	oProcess:start()
	oProcess:Finish()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNotifZV1  บAutor  Denis Haruo          บ Data ณ  08/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ"Retorno Autorizacao de Viagem                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function NotifZV1(cViagem,cSeq,lYesNo)
	//Local _cIpProd:=GetMV("AL_IPSRVPR")//05/08/16 - Fabio Yoshioka
	//Local _cIpTest:=GetMV("AL_IPSRVTS")//05/08/16
	Local oHTML,oProcess
	Local lServProd := IIf(GetEnvServer() $ 'PROTHEUS12_AE#WORKFLOW', .T.,.F.)

	oProcess:= TWFProcess():New("WFVIAGEM","Retorno Autorizacao de Viagem num: "+cViagem)

	If cSeq == '001'
		If lYesNo
			oProcess:NewTask("Montagem do HTML", "\Workflow\CONTROLEVIAGENS\AprovaZV1_Yes.html")
		Else
			oProcess:NewTask("Montagem do HTML", "\Workflow\CONTROLEVIAGENS\AprovaZV1_No.html")
		EndIf
	Else
		If lYesNo
			oProcess:NewTask("Montagem do HTML", "\Workflow\CONTROLEVIAGENS\ProrrogaZV1_Yes.html")
		Else
			oProcess:NewTask("Montagem do HTML", "\Workflow\CONTROLEVIAGENS\ProrrogaZV1_No.html")
		EndIf
	EndIf
	oHtml	:= oProcess:oHTML

	DBSelectArea("ZV1")
	DBSetOrder(1)
	DBSeek(xFilial("ZV1")+cViagem+cSeq)
//Assinalando novos valores เs macros existentes no html:
//Cabe็alho        
	oProcess:oHtml:ValByName("cViagem"		, cViagem)
	oProcess:oHtml:ValByName("cSeq"			, cSeq)
	oProcess:oHtml:ValByName("cData"  		, DTOC(dDatabase))
	oProcess:oHtml:ValByName("cHora"  		, SubStr(Time(),1,5))
	oProcess:oHtml:ValByName("cSolicitante"	, Alltrim(UsrRetName(ZV1->ZV1_CODSOL)))
	oProcess:oHtml:ValByName("cColaborador"	, ZV1->ZV1_NFUNC)
	oProcess:oHtml:ValByName("cDataApr"		, DTOC(ZV1->ZV1_EMISSA))
	oProcess:oHtml:ValByName("cAprovador"	, Alltrim(UsrRetName(ZV1->ZV1_APROV2)))
	oProcess:oHtml:ValByName("cTipo"		, IIF(ZV1->ZV1_TIPO=="S","SERVIวO","TREINAMENTO"))
	oProcess:oHtml:ValByName("cDataIni"		, DTOC(ZV1->ZV1_DTINI))
	oProcess:oHtml:ValByName("cDataFim"		, DTOC(ZV1->ZV1_DTFIM))
	oProcess:oHtml:ValByName("cMotivo"		, ZV1->ZV1_MOTVIA )
	oProcess:oHtml:ValByName("cObs"			, ZV1->ZV1_OBS1)
	oProcess:oHtml:ValByName("cOrigem"		, Alltrim(ZV1->ZV1_NCORIG)+"-"+Alltrim(ZV1->ZV1_ESTORI))
	oProcess:oHtml:ValByName("cDestino"		, Alltrim(ZV1->ZV1_NCDEST)+"-"+Alltrim(ZV1->ZV1_ESTDES))

	If lYesNo
		//Dados do Adiantamento
		oProcess:oHtml:ValByName("cPrefixo"	, ZV1->ZV1_PREFIX)
		oProcess:oHtml:ValByName("cNumero" 	, ZV1->ZV1_NUMPA)
		oProcess:oHtml:ValByName("cCheque"	, ZV1->ZV1_CHEQUE)
		oProcess:oHtml:ValByName("cConta"	, "Bco: "+ZV1->ZV1_BANCO+" Ag: "+Alltrim(ZV1->ZV1_AGENCI)+" CC: "+Alltrim(ZV1->ZV1_CONTA) )
		oProcess:oHtml:ValByName("cEmisPA"	, ZV1->ZV1_EMISPA)
		oProcess:oHtml:ValByName("cVencto"	, DTOC(ZV1->ZV1_DTCHEQ))
	Else
		//Motivo da rejei็ใo
		oProcess:oHtml:ValByName("cMotRej"		, ZV1->ZV1_MOTREJ )
	EndIf

//Despesas da Viagem
	Conout("CARREGANDO AS DESPESAS DA VIAGEM: "+cViagem+cSeq)
	nTotal := 0
	DBSelectArea("ZV2")
	DBSetOrder(2)
	DBSeek(xFilial("ZV2")+cViagem+cSeq)
	Do While !EOF() .and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA+ZV2->ZV2_SEQ == xFilial("ZV2")+cViagem+cSeq
		AAdd( ( oHtml:ValByName( "it.cod" 		)), ZV2->ZV2_CODIGO )
		AAdd( ( oHtml:ValByName( "it.descri"	)), ZV2->ZV2_DESCRI )
		AAdd( ( oHtml:ValByName( "it.quant" 	)), Transform( ZV2->ZV2_QUANT ,'@E 999,999,999.99' ))
		AAdd( ( oHtml:ValByName( "it.valor" 	)), Transform( ZV2->ZV2_VALOR ,'@E 999,999,999.99' ))
		nTotal += ZV2->ZV2_VALOR
		DBSkip()
	EndDo
	oProcess:oHtml:ValByName("cTotalAdi", Transform(nTotal,'@E 999,999,999.99'))
	If cSeq == '001'
		oProcess:cSubject := "Retorno Adiantamento de Viagem: "+cViagem
	Else
		oProcess:cSubject := "Retorno prorroga็ใo de Viagem: "+cViagem
	EndIf
	oProcess:cTo := Alltrim(&('GetMv("AL_MAILADM")')) + IIF(lServProd,+";"+Alltrim(UsrRetMail(ZV1->ZV1_APROV2)),"")
	oProcess:start()
	oProcess:Finish()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWFPrestCont  บAutor  Denis Haruo       บ Data ณ  08/18/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function WFPrestCont(cViagem,cSeq,cAprovador)
	Local oHTML,oProcess
	//Local aDataBco := {}

	Local cViagem := ZV1->ZV1_COD
	Local cSeq := ZV1->ZV1_SEQ
	Private _cIpProd  := GetMV("AL_IPSRVPR") //05/08/16 - Fabio Yoshioka
	Private _cIpTest  := GetMV("AL_IPSRVTS") //05/08/16
	Private _cPrcSrvI := GetMV("AL_PRWFINT") //08/08/16
	Private _cPrcSrvE := GetMV("AL_PRWFEXT") //08/08/16
	lServProd := IIf(GetEnvServer() $ 'PROTHEUS12_AE#WORKFLOW', .T.,.F.)

	oProcess:= TWFProcess():New("WFVIAGEM","Aprova็ใo de Viagem ao Colaborador: "+cViagem+cSeq)
	oProcess:NewTask("Montagem da Aprovacao ZV1", "\Workflow\CONTROLEVIAGENS\AprovaPConta_page.html")
	oHtml	:= oProcess:oHTML

	Conout("MONTANDO PAGINA DO PROCESSO DE CONTROLE DE VIAGEM: "+cViagem+cSeq)
	DBSelectArea("ZV1")
	DBSetOrder(1)
	DBSeek(xFilial("ZV1")+cViagem+cSeq)
//Assinalando novos valores เs macros existentes no html:
//Cabe็alho
	oProcess:oHtml:ValByName("cViagem"		, cViagem )
	oProcess:oHtml:ValByName("cSeq"			, cSeq )
	oProcess:oHtml:ValByName("cData"  		, DTOC(dDatabase) )
	oProcess:oHtml:ValByName("cHora"  		, SubStr(Time(),1,5) )
	oProcess:oHtml:ValByName("cAprovador"	, Alltrim(UsrRetName(cAprovador)))
	oProcess:oHtml:ValByName("cCodApr"		, cAprovador )
	oProcess:oHtml:ValByName("cColab"		, Alltrim(ZV1->ZV1_NFUNC))
	oProcess:oHtml:ValByName("cMatric"		, ZV1->ZV1_MATRIC )
	oProcess:oHtml:ValByName("cEmissao"		, DTOC(ZV1->ZV1_DTPCON))
	oProcess:oHtml:ValByName("cOrigem"		, Alltrim(ZV1->ZV1_NCORIG)+"-"+Alltrim(ZV1->ZV1_ESTORI))
	oProcess:oHtml:ValByName("cDestino"		, Alltrim(ZV1->ZV1_NCDEST)+"-"+Alltrim(ZV1->ZV1_ESTDES))
	oProcess:oHtml:ValByName("cTipo"		, IIF(ZV1->ZV1_TIPO=="S","SERVIวO","TREINAMENTO"))
	oProcess:oHtml:ValByName("cDataIni"		, DTOC(ZV1->ZV1_DTINI))
	oProcess:oHtml:ValByName("cDataFim"		, DTOC(ZV1->ZV1_DTFIM))

//Rodap้
	oProcess:oHtml:ValByName("cTotalAdi"	, Transform(ZV1->ZV1_TOTADI,'@E 999,999,999.99'))
	oProcess:oHtml:ValByName("cTotalRet"	, Transform(ZV1->ZV1_TOTRET,'@E 999,999,999.99'))
	oProcess:oHtml:ValByName("cSaldo"		, Transform(ZV1->ZV1_SALDO,'@E 999,999,999.99'))
	oProcess:oHtml:ValByName("cRecPag"		, IIF(ZV1->ZV1_TPPGTO=="R","A RECEBER","A PAGAR"))

//Despesas da Viagem
	Conout("CARREGANDO AS DESPESAS DA VIAGEM: "+cViagem+cSeq)
	DBSelectArea("ZV2")
	DBSetOrder(2)
	DBSeek(xFilial("ZV2")+cViagem+cSeq)
	Do While !EOF() .and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA+ZV2->ZV2_SEQ == xFilial("ZV2")+cViagem+cSeq
		//Adiantamento Concedido
		IF ZV2->ZV2_CODIGO == '000'
			DBSkip()
			Loop
		EndIf

		AAdd( ( oHtml:ValByName( "it.cod" 		)), ZV2->ZV2_CODIGO )
		AAdd( ( oHtml:ValByName( "it.descri" 	)), ZV2->ZV2_DESCRI )
		AAdd( ( oHtml:ValByName( "it.quant" 	)), Transform( ZV2->ZV2_QUANT ,'@E 999,999,999.99' ))
		AAdd( ( oHtml:ValByName( "it.vldesp"	)), Transform( ZV2->ZV2_VALOR ,'@E 999,999,999.99' ))
		DBSkip()
	EndDo

// Fun็ใo de retorno a ser executada quando a mensagem de respostas retornar ao Workflow:
	oProcess:bReturn := "U_RetPConta()"

//Guardo o ID do Processo para enviar no link
	cMailID := oProcess:Start()
	oHtml:SaveFile("web\ws\wflow\CONTROLEVIAGENS\"+cMailID+".HTM")     	//Salvo HTML do Processo
	cRet := WFLoadFile("web\ws\wflow\CONTROLEVIAGENS\"+cMailID+".HTM")	//Carrego o link do Processo (serแ usado no retorno da Aprova็ใo)

//Preparo a nova terefa... Envio do link
	Conout("PREPARANDO O LINK DE CONTROLE DE VIAGEM: "+cViagem+cSeq)
	oProcess:NewTask("Envio de Link de Aprovacao ZV1","\Workflow\CONTROLEVIAGENS\AprovaPConta_link.html")

	DBSelectArea("ZV1")
	DBSetOrder(1)
	DBSeek(xFilial("ZV1")+cViagem+cSeq)
//Assinalando novos valores เs macros existentes no html:
//Cabe็alho
	oProcess:oHtml:ValByName("cViagem"		, cViagem )
	oProcess:oHtml:ValByName("cSeq"			, cSeq )
	oProcess:oHtml:ValByName("cData"  		, DTOC(dDatabase) )
	oProcess:oHtml:ValByName("cHora"  		, SubStr(Time(),1,5) )
	oProcess:oHtml:ValByName("cAprovador"	, Alltrim(UsrRetName(cAprovador)))
	oProcess:oHtml:ValByName("cCodApr"		, cAprovador )
	oProcess:oHtml:ValByName("cColab"		, Alltrim(ZV1->ZV1_NFUNC))
	oProcess:oHtml:ValByName("cMatric"		, ZV1->ZV1_MATRIC )
	oProcess:oHtml:ValByName("cEmissao"		, DTOC(ZV1->ZV1_DTPCON))
	oProcess:oHtml:ValByName("cOrigem"		, Alltrim(ZV1->ZV1_NCORIG)+"-"+Alltrim(ZV1->ZV1_ESTORI))
	oProcess:oHtml:ValByName("cDestino"		, Alltrim(ZV1->ZV1_NCDEST)+"-"+Alltrim(ZV1->ZV1_ESTDES))
	oProcess:oHtml:ValByName("cTipo"			, IIF(ZV1->ZV1_TIPO=="S","SERVIวO","TREINAMENTO"))
	oProcess:oHtml:ValByName("cDataIni"		, DTOC(ZV1->ZV1_DTINI))
	oProcess:oHtml:ValByName("cDataFim"		, DTOC(ZV1->ZV1_DTFIM))

//Rodap้
	oProcess:oHtml:ValByName("cTotalAdi"	, Transform(ZV1->ZV1_TOTADI,'@E 999,999,999.99'))
	oProcess:oHtml:ValByName("cTotalRet"	, Transform(ZV1->ZV1_TOTRET,'@E 999,999,999.99'))
	oProcess:oHtml:ValByName("cSaldo"		, Transform(ZV1->ZV1_SALDO,'@E 999,999,999.99'))
	oProcess:oHtml:ValByName("cRecPag"		, IIF(ZV1->ZV1_TPPGTO=="R","A RECEBER","A PAGAR"))

//Despesas da Viagem
	Conout("CARREGANDO AS DESPESAS DA VIAGEM: "+cViagem+cSeq)
	DBSelectArea("ZV2")
	DBSetOrder(2)
	DBSeek(xFilial("ZV2")+cViagem+cSeq)
	Do While !EOF() .and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA+ZV2->ZV2_SEQ == xFilial("ZV2")+cViagem+cSeq

		//Adiantamento Concedido
		IF ZV2->ZV2_CODIGO == '000'
			DBSkip()
			Loop
		EndIf

		AAdd( ( oHtml:ValByName( "it.cod" 		)), ZV2->ZV2_CODIGO )
		AAdd( ( oHtml:ValByName( "it.descri" 	)), ZV2->ZV2_DESCRI )
		AAdd( ( oHtml:ValByName( "it.quant" 	)), Transform( ZV2->ZV2_QUANT ,'@E 999,999,999.99' ))
		AAdd( ( oHtml:ValByName( "it.vldesp"	)), Transform( ZV2->ZV2_VALOR ,'@E 999,999,999.99' ))
		DBSkip()
	EndDo

//Asinalando o Link para aprova็ใo
	If lServProd
		/*oProcess:ohtml:ValByName("localink","http://181.41.169.77:8082/Microsiga/PROTHEUS_DATA/web/ws/wflow/CONTROLEVIAGENS/"+cMailID+".htm") 
		oProcess:ohtml:ValByName("weblink" ,"http://200.241.243.21:8082/Microsiga/PROTHEUS_DATA/web/ws/wflow/CONTROLEVIAGENS/"+cMailID+".htm")	*/
		oProcess:ohtml:ValByName("localink",_cPrcSrvI+"CONTROLEVIAGENS/"+cMailID+".htm") //02/11/16
		oProcess:ohtml:ValByName("weblink" ,_cPrcSrvE+"CONTROLEVIAGENS/"+cMailID+".htm")
	Else
		oProcess:ohtml:ValByName("localink",RTRIM("http://"+_cIpTest+":8800/web/ws/wflow/")+"CONTROLEVIAGENS/"+cMailID+".htm")	
	EndIf	 

oProcess:cSubject := "Aprova็ใo presta็ใo de contas de viagem: "+cViagem+cSeq
oProcess:cTo := Alltrim(&('GetMv("AL_MAILADM")')) + IIF(lServProd,+";"+Alltrim(UsrRetMail(cAprovador)),"")
oProcess:start()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetPConta       บAutor  Denis Haruo    บ Data ณ  08/19/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     Valida็ใo da aprova็ใo da Presta็ใo de Conta                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RetPConta(oProcess)

	//Local oHtml := oProcess:oHtml
	Local cCodApr := oProcess:oHtml:RetByName("cCodApr")
	Local lYesNo  := IIF(oProcess:oHtml:RetByName("RBAPROVA") = "Sim",.T.,.F.)
	Local cViagem := oProcess:oHtml:RetByName("cViagem")
	Local cSeq    := oProcess:oHtml:RetByName("cSeq")
	//Local nTotal := AjustaNum(oProcess:oHtml:RetByName("cTotalAdi"))
	Local cMotRej := oProcess:oHtml:RetByName("lbmotivo")
	//Local lAprov1 := .F.
	//Local lAprov2 := .F.
	Local lSendApro := .F.
	Local lNotifica := .F.

	DBSelectArea("ZV1")
	DBSetOrder(1)
	DBSeek(xFilial("ZV1")+cViagem+cSeq)
	l1Aprovado := IIF(Alltrim(ZV1->ZV1_APR1PC) == '',.F.,.T.)
	l2Aprovado := IIF(Alltrim(ZV1->ZV1_APR2PC) == '',.F.,.T.)

	If lYesNo
		//Para a primeira aprova็ใo
		If !l1Aprovado .and. !l2Aprovado
			Conout("Para a primeira aprova็ใo")
			DBSelectArea("ZV1")
			RecLock("ZV1",.F.)
			ZV1->ZV1_APR1PC := cCodApr
			ZV1->ZV1_APR1DT := dDataBase
			ZV1->ZV1_STATUS := "5"
			MsUnlock()
			lSendApro := .T.

			//Segunda Aprova็ใo
		ElseIf l1Aprovado .and. !l2Aprovado
			Conout("Para a segunda aprova็ใo")
			DBSelectArea("ZV1")
			RecLock("ZV1",.F.)
			ZV1->ZV1_APR2PC := cCodApr
			ZV1->ZV1_APR2DT := dDataBase
			ZV1->ZV1_PCSTAT := "A"
			ZV1->ZV1_PREFPC := "PA3"
			ZV1->ZV1_TITPC  := cViagem+cSeq
			ZV1->ZV1_TIPOPC := "CH "
			ZV1->ZV1_STATUS := "6"
			MsUnlock()

			***************************************
			Conout("Gerando o titulo a receber...")
			U_GeraTitPC(cViagem,cSeq)
			//U_ExecCompCV(cViagem,cSeq)
			***************************************
			lSendApro := .F.
			lNotifica := .T.

		EndIf
	Else
		//Para rejei็ใo
		If !l1Aprovado .and. !l2Aprovado

			Conout("Rejeitando Presta็ใo de Conta...")
			DBSelectArea("ZV1")
			RecLock("ZV1",.F.)
			ZV1->ZV1_APR1PC := cCodApr
			ZV1->Zv1_APR1DT := dDataBase
			ZV1->ZV1_APR2PC := cCodApr
			ZV1->ZV1_APR2DT := dDatabase
			ZV1->ZV1_STATUS := "9"
			ZV1->ZV1_MOTREJ := cMotRej
			MsUnlock()
			lSendApro := .F.

		ElseIf l1Aprovado .and. !l2Aprovado

			Conout("Rejeitando Presta็ใo de Conta...")
			DBSelectArea("ZV1")
			RecLock("ZV1",.F.)
			ZV1->ZV1_APR2PC := cCodApr
			ZV1->ZV1_APR2DT := dDatabase
			ZV1->ZV1_STATUS := "9"
			ZV1->ZV1_MOTREJ := cMotRej
			MsUnlock()
			lSendApro := .F.
		EndIf
		lNotifica := .T.
	EndIf

	If lSendApro
		cAprovador := ""
		//Envio para o segundo aprovador (Coordenador Financeiro)
		Conout("Enviando para segunda aprova็ใo: "+cViagem+cSeq)

		cQuery := ""
		cQuery += "SELECT * FROM "+RetSQLName("ZPB")+" "
		cQuery += "WHERE 	ZPB_FILIAL = '"+xFilial("ZPB")+"' AND "
		cQuery += "			ZPB_CARGO = 'A' AND "
		cQuery += "			D_E_L_E_T_ <> '*' AND "
		cQuery += "       ZPB_COD='FINANC'"
		TCQuery cQuery NEW ALIAS "APR"
		DBSelectArea("APR")
		IF !EOF()
			cAprovador := ZPB_CODUSR
			U_WFPrestCont(cViagem,cSeq,cAprovador)
			Conout("Aprova็ใo do adiantamento enviada. Favor aguardar o retorno")
		Else
			Conout("Email do ANALISTA do financeiro nใo encontrado. Corrija e reenvie a solicita็ใo.")
		EndIf
		DBSelectArea("APR")
		APR->(DBCloseArea())

		//PESSOA ELEITA DO FINANCEIRO - 02/11/16
	/*cAprovador := GETMV("AL_USAPFIN")
	U_WFPrestCont(cViagem,cSeq,cAprovador)			
	Conout("Aprova็ใo do adiantamento enviada. Favor aguardar o retorno")*/
	
EndIf
       
If lNotifica						
	YesNoPCont(cViagem,cSeq,lYESNO)			
EndIf

Return()  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVIAGEMXFUNCบAutor  ณMicrosiga           บ Data ณ  08/19/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function YesNoPCont(cViagem,cSeq,lYESNO)
	//Local _cIpProd:=GetMV("AL_IPSRVPR")//05/08/16 - Fabio Yoshioka
	//Local _cIpTest:=GetMV("AL_IPSRVTS")//05/08/16
	Local oHTML,oProcess
	Local lServProd := IIf(GetEnvServer() $ 'PROTHEUS12_AE#WORKFLOW', .T.,.F.)

	oProcess:= TWFProcess():New("WFVIAGEM","Retorno Autorizacao de Prestacao de Conta num: "+cViagem)
	If lYesNo
		oProcess:NewTask("Montagem do HTML", "\Workflow\CONTROLEVIAGENS\AprovaPConta_Yes.html")
	Else
		oProcess:NewTask("Montagem do HTML", "\Workflow\CONTROLEVIAGENS\AprovaPConta_No.html")
	EndIf
	oHtml	:= oProcess:oHTML

	DBSelectArea("ZV1")
	DBSetOrder(1)
	DBSeek(xFilial("ZV1")+cViagem+cSeq)
//Assinalando novos valores เs macros existentes no html:
//Cabe็alho        
	oProcess:oHtml:ValByName("cViagem"		, cViagem)
	oProcess:oHtml:ValByName("cSeq"			, cSeq)
	oProcess:oHtml:ValByName("cData"  		, DTOC(dDatabase))
	oProcess:oHtml:ValByName("cHora"  		, SubStr(Time(),1,5))
	oProcess:oHtml:ValByName("cColab"		, ZV1->ZV1_NFUNC)
	oProcess:oHtml:ValByName("cAprovador"	, Alltrim(UsrRetName(ZV1->ZV1_APR2PC)))
	oProcess:oHtml:ValByName("cEmissao"		, DTOC(ZV1->ZV1_APR2DT))

	oProcess:oHtml:ValByName("cOrigem"		, Alltrim(ZV1->ZV1_NCORIG)+"-"+Alltrim(ZV1->ZV1_ESTORI))
	oProcess:oHtml:ValByName("cDestino"		, Alltrim(ZV1->ZV1_NCDEST)+"-"+Alltrim(ZV1->ZV1_ESTDES))
	oProcess:oHtml:ValByName("cTipo"		, IIF(ZV1->ZV1_TIPO=="S","SERVIวO","TREINAMENTO"))
	oProcess:oHtml:ValByName("cDataIni"		, DTOC(ZV1->ZV1_DTINI))
	oProcess:oHtml:ValByName("cDataFim"		, DTOC(ZV1->ZV1_DTFIM))

	oProcess:oHtml:ValByName("cTotalAdi"	, Alltrim(Transform(ZV1->ZV1_TOTADI,"@E 999,999,999.99")))
	oProcess:oHtml:ValByName("cTotalRet"	, Alltrim(Transform(ZV1->ZV1_TOTRET,"@E 999,999,999.99")))
	oProcess:oHtml:ValByName("cSaldo"		, Alltrim(Transform(ZV1->ZV1_SALDO,"@E 999,999,999.99")))

	If lYesNo
		//Dados do Adiantamento
		oProcess:oHtml:ValByName("cPrefixo"	, ZV1->ZV1_PREFPC)
		oProcess:oHtml:ValByName("cNumero" 	, ZV1->ZV1_TITPC)
		oProcess:oHtml:ValByName("cTipo"		, ZV1->ZV1_TIPOPC)
		oProcess:oHtml:ValByName("cValor"	, Alltrim(Transform(ZV1->ZV1_TOTRET,"@E 999,999,999.99")))
	Else
		//Motivo da rejei็ใo
		oProcess:oHtml:ValByName("cMotRej"		, Alltrim(ZV1->ZV1_MOTREJ))
	EndIf

//Despesas da Viagem
	Conout("CARREGANDO AS DESPESAS DA VIAGEM: " + cViagem + cSeq)
	DBSelectArea("ZV2")
	DBSetOrder(2)
	DBSeek(xFilial("ZV2") + cViagem + cSeq)
	Do While !EOF() .and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA+ZV2->ZV2_SEQ == xFilial("ZV2")+cViagem+cSeq
		AAdd( ( oHtml:ValByName( "it.cod" 		)), ZV2->ZV2_CODIGO )
		AAdd( ( oHtml:ValByName( "it.descri"	)), ZV2->ZV2_DESCRI )
		AAdd( ( oHtml:ValByName( "it.quant" 	)), Transform( ZV2->ZV2_QUANT ,'@E 999,999,999.99' ))
		AAdd( ( oHtml:ValByName( "it.vldesp"	)), Transform( ZV2->ZV2_VALOR ,'@E 999,999,999.99' ))
		DBSkip()
	EndDo
	oProcess:cSubject := "Retorno Presta็ใo de Contas de Viagem: "+cViagem
	oProcess:cTo := Alltrim(&('GetMv("AL_MAILADM")')) + IIF(lServProd,+";"+Alltrim(UsrRetMail(ZV1->ZV1_APR2PC)),"")
	oProcess:start()
	oProcess:Finish()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaNum บAutor  Denis Haruo         บ Data ณ  08/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjustando numero do HTML de Char -> Num                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaNum(cNum)
	Local  i, j

	i := rat(',',cNum)
	j := rat('.',cNum)

	if i > 0 .and. i > j
		cNum := strtran(cNum,'.','')
		cNum := strtran(cNum,',','.')
	elseif i > 0
		cNum := strtran(cNum,',','')
	endif

Return val(cNum)


	****************************
Static Function ValidVenc() //19/10/16 - valida็ใo de data de vencimento
	****************************
	Local _lRet:=.t.
	Local _dDtVenc:=U_RetDtVPA()

	if dDtSol<_dDtVenc
		MSGStop("Data de vencimento invแlida!","ValidVenc()")
		_lRet:=.F.
	endif

Return _lRet

	*******************************
User Function RetDCCSup(_cCCus) //09/11/16 Verificar centro de custo superiores para filtro na sele็ใo de despesas
	*******************************
	Local _aSupCC:={}
	Local _cDgCCSup:=GetMv("AL_DGCCSUP")   // Dํgito inicial vแlido dos CC superiores
	Local _cStrSup:=""
	Local _cDigSup:=""
	Local _nSup := 0
	local _nD := 0

	For _nSup:=1 to len(_cDgCCSup)
		if substr(_cDgCCSup,_nSup,1) $ '/,;\:'
			aadd(_aSupCC,_cStrSup)
			_cStrSup:=""
		else
			_cStrSup	+=substr(_cDgCCSup,_nSup,1)
		endif
	Next _nSup

	if Len(alltrim(_cStrSup))>0
		aadd(_aSupCC,_cStrSup)
	endif


	if len(_aSupCC)>0
		For _nD:=1 to len(_aSupCC)
			IF SUBSTR(_cCCus,1,1) $ &('GETMV("AL_CCUSUP"+rtrim(_aSupCC[_nD]))')
				_cDigSup:=_aSupCC[_nD]
				EXIT
			ENDIF
		Next _nD
	endif

Return _cDigSup

	***************************************************
User Function AxExcZV1(_cAliasZV1,_nRecZV1,_cIdZV1) //Cria็ใo de op็ใo para exclusใo da VIAGEM pelo solicitante - 13/01/17
	***************************************************
	Local _cInfHist:=space(200)
	Local _aDestExc:={}
	Local _cNotfExc:=""
	Local _lGerWF:=.T.
	Local _nExc := 1
	Local _nDst := 1

	if RTRIM(ZV1->ZV1_STATUS) $ '1/2/A/3/8/9' // STATUS LIBERADOS PARA EXCLUSรO

		/*1 - ENVIADO PARA APROVAวรO DO SETOR (GERENCIA)
		2 - LIBERADO PELO SETOR (GERENCIA)	
		A - VISTADO PELO FINANCEIRO      
		3 - LIBERADO PELO SETOR (GERENCIA)											
		8 - Adiantamento Rejeitado/Viagem Cancelada
		9 - P. Contas Rejeitada */
	
	//Informar motivo para hist๓rico   
	DEFINE MSDIALOG _oDlgExc TITLE "Informe Motivo da Exclusใo" FROM 000, 000  TO 120, 470 COLORS 0, 16777215 PIXEL
	@ 001, 002 MSGET _oGetHist VAR _cInfHist SIZE 200, 012 
	@ 003, 020 BUTTON oButton2 PROMPT "OK" SIZE 050, 012 Action _oDlgExc:End()
	ACTIVATE MSDIALOG _oDlgExc Centered

	if !empty(alltrim(_cInfHist)) 
		
		IF RTRIM(ZV1->ZV1_STATUS) $ '8/9' //REJEITADOS  - NรO ENVIO WF
			_lGerWF:=.F.
		ENDIF

			
		DBSelectARea("ZV1")  //gravo motivo informado
		RecLock("ZPA",.F.)
		ZV1->ZV1_EXHIST := UPPER(_cInfHist)
		ZV1->(MSUnlock())
		
		//_nRetDel:=AxDeleta(_cAlias ,RecNo(),5)	
			
		IF U_ZV1DlgMod(8) //ABRO TELA PARA EXCLUSAO - 18/01/17

			_aChavExc:={}
			_cNotfExc:="" 
				
			_cQryZPA:=" SELECT ZPA_PREFIX,ZPA_NUM,ZPA_PARCEL,ZPA_PARCEL,ZPA_TIPO,ZPA_FORNEC,ZPA_LOJA "
			_cQryZPA+=" FROM "+RETSQLNAME("ZPA")
			_cQryZPA+=" WHERE D_E_L_E_T_<>'*'"
			_cQryZPA+=" AND ZPA_NUM='"+STRZERO(val(ZV1->ZV1_COD),9)+"'"
			_cQryZPA+=" AND ZPA_PREFIX='GVI'"
			_cQryZPA+=" AND ZPA_FILIAL='"+XFILIAL("ZPA")+"'"
			DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQryZPA), "TZPA", .F., .T.) 
			IF !TZPA->(EOF()) .AND. !TZPA->(BOF())
				aAdd(_aChavExc, PADR(TZPA->ZPA_PREFIX,3) )                                   
				aAdd(_aChavExc, PADR(TZPA->ZPA_NUM,9)    )                                   
				aAdd(_aChavExc, PADR(TZPA->ZPA_PARCEL,2) )                                   
				aAdd(_aChavExc, PADR(TZPA->ZPA_TIPO,3)   )
				aAdd(_aChavExc, PADR(TZPA->ZPA_FORNEC,6) )                                   
				aAdd(_aChavExc, PADR(TZPA->ZPA_LOJA,2)   )
			ENDIF
			TZPA->(DBCLOSEAREA())
				
			//CARREGO OS APROVADORES				
			For _nExc:=1 to 3
				_cStrExc:="ZV1->ZV1_APROV"+Alltrim(str(_nExc))
				IF RTRIM(ZV1->ZV1_STATUS)=='1'  // ENVIO PARA APROVADOR DO SEU SETOR (INFORMAวรO NรO GRAVADA NO ZV1)
					if Ascan(_aDestExc, rtrim(U_RESPAPV(ZV1->ZV1_CODSOL,'G')))==0 //PESQUISO APARTIR DO SOLICITANTE
						aadd(_aDestExc,rtrim(U_RESPAPV(ZV1->ZV1_CODSOL,'G')))
					endif
				ELSE
					IF !EMPTY(ALLtrim(&_cStrExc))
						if Ascan(_aDestExc, rtrim(&_cStrExc))==0
							aadd(_aDestExc,rtrim(&_cStrExc))
						endif
					ENDIF
				ENDIF
			Next _nExc        
				
			IF LEN(_aChavExc)>0 //Verifico destinos enviados 
				_cQryZWF:=" SELECT ZWF_CODDES FROM "+Retsqlname("ZE2")+","+Retsqlname("ZWF")
				_cQryZWF+=" WHERE "+RETSQLNAME("ZE2")+".D_E_L_E_T_<>'*'"
				_cQryZWF+=" AND "+RETSQLNAME("ZWF")+".D_E_L_E_T_<>'*'"
				_cQryZWF+=" AND ZE2_NUM='"+_aChavExc[2]+"'"
				_cQryZWF+=" AND ZE2_PREFIX='"+_aChavExc[1]+"'"
				_cQryZWF+=" AND ZE2_TIPO='PR'"
				_cQryZWF+=" AND ZE2_WFID=ZWF_WFID "
				_cQryZWF+=" AND ZWF_FILIAL='"+XFILIAL("ZWF")+"'"
				_cQryZWF+=" AND ZE2_FILIAL='"+XFILIAL("ZE2")+"'"
				DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQryZWF), "TZWF", .F., .T.) 					  
				While !TZWF->(eof())          
					if Ascan(_aDestExc, rtrim(TZWF->ZWF_CODDES))==0
						aadd(_aDestExc,rtrim(TZWF->ZWF_CODDES))
					endif
					TZWF->(dbskip())					
				Enddo
				TZWF->(dbclosearea())										
			ELSE
				aAdd(_aChavExc, SPACE(3))                                   
				aAdd(_aChavExc, SPACE(9))                                   
				aAdd(_aChavExc, SPACE(2))                                   
				aAdd(_aChavExc, SPACE(3))
				aAdd(_aChavExc, SPACE(6))                                   
				aAdd(_aChavExc, SPACE(2))
			ENDIF		      
			
			
			if Ascan(_aDestExc, rtrim(ZV1->ZV1_CODSOL))==0 //ADCIONO SOLICITANTE 
				aadd(_aDestExc,rtrim(ZV1->ZV1_CODSOL))
			endif

			For _nDst:=1 to len(_aDestExc)
				_cNotfExc+=UsrRetMail(_aDestExc[_nDst])+";"			
			Next _nDst


			//Dados para WorkFlow			
			aAdd(_aChavExc, ZV1->ZV1_COD)
			aAdd(_aChavExc, ZV1->ZV1_SEQ)
			aAdd(_aChavExc, DTOC(dDatabase))
			aAdd(_aChavExc, SubStr(Time(),1,5))
			aAdd(_aChavExc, Alltrim(ZV1->ZV1_NFUNC))
			aAdd(_aChavExc, DTOC(ZV1->ZV1_EMISSA))
			aAdd(_aChavExc, IIF(ZV1->ZV1_TIPO=="S","SERVIวO","TREINAMENTO"))
			aAdd(_aChavExc, DTOC(ZV1->ZV1_DTINI))			
			aAdd(_aChavExc, DTOC(ZV1->ZV1_DTFIM))			
			aAdd(_aChavExc, ZV1->ZV1_MOTVIA)			
			aAdd(_aChavExc, ZV1->ZV1_OBS1)				
			aAdd(_aChavExc, Alltrim(ZV1->ZV1_NCORIG)+"-"+Alltrim(ZV1->ZV1_ESTORI))	
			aAdd(_aChavExc, Alltrim(ZV1->ZV1_NCDEST)+"-"+Alltrim(ZV1->ZV1_ESTDES))				
			aAdd(_aChavExc, Alltrim(ZV1->ZV1_EXHIST))			
				//enviar WF de  notifica็ใo   		
			if len(_aChavExc)>0 .and. !empty(alltrim(_cNotfExc)) .AND. _lGerWF
				ZV1NotExc(_aChavExc,_cNotfExc)		
			endif

			//Excluo o tํtulo provis๓rio SE HOUVER 
			IF LEN(_aChavExc)>0
				_cSE2Tit := _aChavExc[1]+_aChavExc[2]+_aChavExc[3]+_aChavExc[4]+_aChavExc[5]+_aChavExc[6]
				DBSelectArea("SE2")
				DBSetOrder(1)
				If DBSeek(xFilial("SE2")+_cSE2Tit)

					aTitulo:={}
					aTitulo := { { "E2_PREFIXO"  , SE2->E2_PREFIXO  , NIL },;
									{"E2_NUM"    , SE2->E2_NUM    , NIL},;
									{"E2_TIPO"   , SE2->E2_TIPO   , NIL},;
									{"E2_NATUREZ", SE2->E2_NATUREZ, NIL},;
									{"E2_FORNECE", SE2->E2_FORNECE, NIL},;
									{"E2_LOJA"   , SE2->E2_LOJA   , NIL},;
									{"E2_EMISSAO", SE2->E2_EMISSAO, NIL},;
									{"E2_VENCTO" , SE2->E2_VENCTO , NIL},;
									{"E2_VENCREA", SE2->E2_VENCREA, NIL},;
									{"E2_VALOR"  , SE2->E2_VALOR  , NIL }}
						lMsErroAuto := .F.
						MSExecAuto({|x,y,z| Fina050(x,y,z)},aTitulo,,5) //EXCLUO TITULO PROVISำRIO
				
					If lMsErroAuto                
						ALERT('Problemas para excluir tํtulo provis๓rio')
						Mostraerro()
					Endif
				ENDIF

				//EXCLUO REGISTRO NO ZPA SE HOUVER
				DBSelectArea("ZPA")
				DBSetOrder(1)
				IF DBSeek(xFilial("ZPA")+_cSE2Tit)
					RecLock("ZPA",.F.)
					ZPA->(DBDelete())
				EndIf 
				
			ENDIF
			
			//EXCLUO REGISTRO NO ZV1 E ZV2
			ExcluiZV1()
			//MsgAlert(_cNotfExc) 	
	ENDIF                     

	else
		MsgAlert("Para concluir a exclusใo ้ obrigat๓rio informar o motivo!") 	
	endif
		
ELSE
	MsgAlert("Nใo ้ permitido a exclusใo desse registro!") 	
ENDIF 

Return                        

*********************************************************
Static Function ZV1NotExc(_aChavExc,_cNotfExc) //18/01/17		
*********************************************************
//Local _cIpProd:=GetMV("AL_IPSRVPR")//05/08/16 - Fabio Yoshioka
//Local _cIpTest:=GetMV("AL_IPSRVTS")//05/08/16            
Local oHTML,oProcess
Local lServProd := IIf(GetEnvServer() $ 'PROTHEUS12_AE#WORKFLOW', .T.,.F.)   
cViagem:=_aChavExc[7]   
cSeq:=_aChavExc[8]   

oProcess:= TWFProcess():New("WFVIAGEM","Exclusao  de Viagem num: "+cViagem) 										
oProcess:NewTask("Montagem do HTML", "\Workflow\CONTROLEVIAGENS\ExcluiZV1_note.html") 														
oHtml	:= oProcess:oHTML				

DBSelectArea("ZV1")
DBSetOrder(1)
DBSeek(xFilial("ZV1")+cViagem+cSeq)
//Assinalando novos valores เs macros existentes no html:
//Cabe็alho        
oProcess:oHtml:ValByName("cViagem"		, _aChavExc[7])
oProcess:oHtml:ValByName("cSeq"			, _aChavExc[8])
oProcess:oHtml:ValByName("cData"  		, _aChavExc[9])
oProcess:oHtml:ValByName("cHora"  		, _aChavExc[10])
oProcess:oHtml:ValByName("cColaborador", _aChavExc[11])
oProcess:oHtml:ValByName("cEmissao"		, _aChavExc[12])
oProcess:oHtml:ValByName("cTipo"			, _aChavExc[13])
oProcess:oHtml:ValByName("cDataIni"		, _aChavExc[14])
oProcess:oHtml:ValByName("cDataFim"		, _aChavExc[15])
oProcess:oHtml:ValByName("cMotivo"		, _aChavExc[16])
oProcess:oHtml:ValByName("cObs"			, _aChavExc[17])  
oProcess:oHtml:ValByName("cOrigem"		, _aChavExc[18])  
oProcess:oHtml:ValByName("cDestino"		, _aChavExc[19]) 

//Despesas da Viagem
Conout("CARREGANDO AS DESPESAS DA VIAGEM: "+cViagem+cSeq)                                      
nTotal := 0
DBSelectArea("ZV2")
DBSetOrder(2)
DBSeek(xFilial("ZV2")+cViagem+cSeq)
Do While !EOF() .and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA+ZV2->ZV2_SEQ == xFilial("ZV2")+cViagem+cSeq
	AAdd( ( oHtml:ValByName( "it.cod" 		)), ZV2->ZV2_CODIGO )		
	AAdd( ( oHtml:ValByName( "it.descri" 	)), ZV2->ZV2_DESCRI )		       
	AAdd( ( oHtml:ValByName( "it.quant" 	)), Transform( ZV2->ZV2_QUANT ,'@E 999,999,999.99' ))
	AAdd( ( oHtml:ValByName( "it.valor" 	)), Transform( ZV2->ZV2_VALOR ,'@E 999,999,999.99' )) 
	nTotal += ZV2->ZV2_VALOR
	DBSkip()
EndDo		
oProcess:oHtml:ValByName("cTotalAdi", Transform(nTotal,'@E 999,999,999.99')) 
oProcess:oHtml:ValByName("cMotExc"		, _aChavExc[20]) 

oProcess:cSubject := "Notificacao de Exclusao de Viagem: "+cViagem+cSeq
oProcess:cTo := Alltrim(&('GetMv("AL_MAILADM")'))+ IIF(lServProd,+";"+Alltrim(_cNotfExc),"")
oProcess:start()
oProcess:Finish()

Return()       

*******************************
User Function PresCALE(nOpca) //Rotinas de presta็ใo de contas para ALuabar Energia  - 21/07/17 - Fabio Yoshioka
*******************************

U_DlgPCALE(nOpca)
	
Return()      

*********************************
User Function DlgPCALE(nOpca) //Nova Tela de presta็ใo de contas para RAILEC Energia - 21/07/17 - Fabio Yoshioka
*********************************

//Layouts da Dlg
Local oButton1
Local oButton2
Local oGroup1,oGroup2,oGroup3,oDlg //,oGroup4
Local oFont1 := TFont():New("MS Sans Serif",,016,,.F.,,,,,.F.,.F.)
Local oFont2 := TFont():New("MS Sans Serif",,016,,.T.,,,,,.F.,.F.)
Local lOk := .F.

//Campos da dlg
//Local oDataFim,oDataIni,oEmissao,oMatricula,oNomeSolic,oOrigDest //oCC,oCodSeq,
Local oSay1
//Local oSay10
//Local oSay11
//Local oSay12
//Local oSay13
//Local oSay14
//Local oSay2
Local oSay3
//Local oSay4
Local oSay5
//Local oSay6
//Local oSay7
Local oSay8
Local oSay9
Local oSayVenc //17/07/18
//Local oTipoMot          
//Local _lSemAdiant:=iif(RTRIM(UPPER(ZV1->ZV1_ADIANT))<>'N',.F.,.T.) //30/11/16
//Local lVisual := IIF(nOpca==3 .or. nOpca==4 ,.F.,.T.) 
//Local lExclui := IIF(nOpca==5,.T.,.F.)  
Local _cGrvCusSe2:=""
//Local _lProcTDOk:=.f. //27/09/17
LOcal oDtVenc
Local aSizeAut  := MsAdvSize()
//Local _lUsaZV1Num:=GetMv("AL_USAZV1N")
aObjects := {}
AAdd( aObjects, { 315,  50, .T., .T. } )
AAdd( aObjects, { 100, 100, .T., .T. } )
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects, .T. )

//variaveis para contabiliza็ใo - 27/10/16
Private _lAbandPCon := .f. //27/09/17
Private oTotRet,oTotAdi,oAbatm,oRecPag,oMSNewGe1
Private nTotAdi     := ZV1->ZV1_TOTADI
Private nTotRet     := IIF(nOpca==3,0,ZV1->ZV1_TOTRET)
Private nAbatm      := IIF(nOpca==3,0,ZV1->ZV1_ABATM)
Private cecPag      := IIF(ZV1->ZV1_TPPGTO=="P","A PAGAR","A RECEBER")
Private cTotAdi     := Transform(nTotAdi,"@E 999,999,999.99")
Private cTotRet     := Transform(nTotRet,"@E 999,999,999.99")
Private cAbatm      := Transform(nAbatm,"@E 999,999,999.99")
Private aHeaderEx   := {}
Private aColsEx     := {}

Private oPanel1
Private cViagem    := ZV1->ZV1_COD
//Private cSeq       := ZV1->ZV1_SEQ
Private cSRAMAT    := ZV1->ZV1_MATRIC
Private _cCusFun   := ZV1->ZV1_CC //04/11/16
Private cCODUSR    := POSICIONE("ZV4",1,xFilial("ZV4")+cSRAMAT,"ZV4_CODUSR")

Private nTotal     := 0
private nHdlPrv    := 0
private cLoteEst   := "008850"
private cArquivo   := ''
private lCriaHeade := .T.
Private _dDatabase := dDatabase
Private _lContDia  := .F.
Private _cLPctb    := 'P01'
PRIVATE _cContaLct := ""
Private _nTotLcto  := 0
Private _cCCForn   := ""
Private _cCCNome   := ""
Private _cTitVia   := "" //15/11/16

//Alterado por Dilson Castro em 02/08/2022
//Solicitado por Marcos Cavalcante
//Alterado controle de numera็ใo
//Private cCodTrip 	:= IIF(nOpca==3,GetNumZV1(),ZV1->ZV1_COD)  
//Private cCodTrip 	:= IIF(nOpca==3,GetSX8Num("ZV1"),ZV1->ZV1_COD) 
Private cCodTrip 	:= IIF(nOpca==3,GETSX8NUM("ZV1","ZV1_COD"),ZV1->ZV1_COD) //////JEAN ROCHA 26/08/2022 
Private cSeq         := IIF(nOpca==3, '001' ,IIF(nOpca==7,Soma1(ZV1->ZV1_SEQ),ZV1->ZV1_SEQ))
Private cCodSol      := &( 'RETCODUSR()' )
Private cNomeSol     := Alltrim(UsrRetName(cCodSol))
Private nCbTipo      := 1
Private dDtSol       := IIF(nOpca==3,Date() ,ZV1->ZV1_EMISSA)
Private cMatFunc     := IIF(nOpca==3,Space(8) ,ZV1->ZV1_MATRIC)
Private cNomeFunc    := IIF(nOpca==3,Space(60) ,ZV1->ZV1_NFUNC)
Private cCCusto      := IIF(nOpca==3,Space(3) ,ZV1->ZV1_CC)
Private cNomeCC      := IIF(nOpca==3,Space(60) ,ZV1->ZV1_DESCCC)
Private dDtFim       := IIF(nOpca==3 .or. nOpca==7,Date(),ZV1->ZV1_DTFIM)
Private dDtIni       := IIF(nOpca==3 .or. nOpca==7,Date(),ZV1->ZV1_DTINI)
Private cMotVia      := IIF(nOpca==3,Space(200) ,ZV1->ZV1_MOTVIA)
Private cGetObs      := IIF(nOpca==3,Space(200) ,ZV1->ZV1_OBS1)
Private cTotDesp     := IIF(nOpca==3,"0,00" ,ZV1->ZV1_TOTADI)
Private nTotDias     := 0

Private cCodSeq      := cCodTrip //+"/"+cSeq  
Private _dDataZV2    := dDatabase
Private _cTitDialog  := ""
Private _aCustGrvSE2 := {} //02/08/17
Private _aDadPA      := {} //IIF(nOpca==3,{},{ZV1->ZV1_PREFIXO,ZV1->ZV1_NUMPA,ZV1->ZV1_PARCEL,ZV1->ZV1_TIPOPA,ZV1->ZV1_EMISPA}) //09/08/17 
Private _nTotPA      := IIF(nOpca==3, 0,ZV1->ZV1_TOTADI)
Private _cTitADto    := IIF(nOpca==3,"",ZV1->ZV1_PREFIXO+ZV1->ZV1_NUMPA+ZV1->ZV1_PARCEL+ZV1->ZV1_TIPOPA) //09/08/17
Private _cVlrAdto    := Transform(_nTotPA,"@E 999,999,999.99") //09/08/17
Private oTitADto
Private oVlrAdto
Private _nDigOpca    := nOpca
Private _dDatVenc    := IIF(nOpca==3,Date() ,ZV1->ZV1_DTVENC) //17/07/18
Private nSaveSx8	 := GetSx8Len()

if nOpca==2
	_cTitDialog:="VISUALIZAR"
elseif nOpca==3
	_cTitDialog:="INCLUIR"
elseif nOpca==4
	_cTitDialog:="ALTERAR"
elseif nOpca==5
	_cTitDialog:="EXCLUIR"
elseif nOpca==6
	_cTitDialog:="BAIXAR"
endif

cViagem 	:= cCodTrip

DBSelectArea("ZV1")

DEFINE MSDIALOG oDlg TITLE _cTitDialog+" - Presta็ใo de Contas" From aSizeAut[7],00 To aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL //02/08/17
@ 000,000 MSPANEL oPanel1 SIZE 000,000 OF oDlg COLORS 0, 15920613 RAISED //27/09/17
oPanel1:Align := CONTROL_ALIGN_ALLCLIENT

@ 002, 003 GROUP oGroup1 TO 66, 412 PROMPT " Presta็ใo de Contas da Viagem " OF oPanel1 COLOR 8388608, 15920613 PIXEL
@ 016, 010 SAY oSay1 PROMPT "C๓digo: " SIZE 021, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
@ 016, 031 MSGET oCodTrip VAR cCodSeq SIZE 039, 010 OF oPanel1 COLORS 0, 16777215 PIXEL WHEN .f.
    
@ 016, 150 SAY oSay3 PROMPT "Emissao: " SIZE 023, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
@ 016, 182 MSGET oDtSol VAR dDtSol SIZE 032, 010 OF oPanel1 COLORS 0, 16777215 PIXEL When .f. 

@ 016, 230 SAY oSayVenc PROMPT "Vencim.: " SIZE 023, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL //17/07/18 - Fabio Yoshioka - Melhorias Presta็ใo de contas
@ 016, 262 MSGET oDtVenc VAR _dDatVenc SIZE 032, 010 OF oPanel1 COLORS 0, 16777215 PIXEL When IIF(nOpca==3 .or. (nOpca==4 .and. ZV1->ZV1_STATUS<> '6' ),.T.,.F.) VALID _dDatVenc>=dDatabase //22/11/18 - Possibilitar altera็ใo da data de Vencimento at้ a aprova็ใo - Fabio Yoshioka

@ 032, 008 GROUP oGroup2 TO 61, 200 PROMPT " Dados do Fornecedor " OF oPanel1 COLOR 8388608, 15920613 PIXEL
@ 043, 012 SAY oSay5 PROMPT "C๓digo:" SIZE 025, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
@ 043, 039 MSGET oMatFunc VAR cMatFunc SIZE 038, 010 OF oPanel1 COLORS 0, 16777215 PIXEL When IIF(nOpca==3,.T.,.F.) F3 "SA2CEL" VALID ValidaMat()
@ 043, 094 MSGET oNomeFunc VAR cNomeFunc SIZE 100, 010 OF oPanel1 COLORS 0, 16777215 PIXEL WHEN .f.

//Adiantamentos - 09/08/17 - Fabio Yoshioka
@ 032, 208 GROUP oGroup3 TO 61, 407 PROMPT " Adiantamento " OF oPanel1 COLOR 8388608, 15920613 PIXEL
@ 043, 217 SAY oSay5 PROMPT "Tํtulo:" SIZE 025, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
@ 043, 240 MSGET oTitADto VAR _cTitADto SIZE 070, 010 OF oPanel1 COLORS 0, 16777215 PIXEL When .f. //F3 "SA2CEL" VALID ValidaMat()
@ 043, 316 SAY oSay5 PROMPT "Valor:" SIZE 025, 007 OF oPanel1 FONT oFont1 COLORS 8388608, 15920613 PIXEL
@ 043, 340 MSGET oVlrAdto VAR _cVlrAdto SIZE 058, 010 OF oPanel1 COLORS 0, 16777215 PIXEL WHEN .f.

GetDespesa(nOpca)
    
@ 260, 010 SAY oSay8 PROMPT "Total da Despesa: " SIZE 056, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
@ 260, 062 SAY oTotRet PROMPT cTotRet SIZE 068, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL

@ 272, 010 SAY oSay9 PROMPT "Abatimentos: " SIZE 056, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL
@ 272, 062 SAY oAbatm PROMPT cAbatm SIZE 057, 007 OF oPanel1 FONT oFont2 COLORS 8388608, 15920613 PIXEL

If nOpca == 4 .or. nOpca == 3  .OR.  nOpca == 6   .OR.  nOpca == 5 //Inclusใo ou Atualiza็ใo OU BAIXA ou excluir 
	@ 272, 333 BUTTON oButton1 PROMPT "Confirmar" SIZE 037, 012 OF oPanel1 PIXEL Action(lOk:=.T.,oDlg:End())
EndIf	 

@ 272, 374 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oPanel1 PIXEL Action(_lAbandPCon:=.T.,oDlg:End())  

oButton2:SetFocus()//27/09/17

If nOpca == 4 .or. nOpca == 3 //Inclusใo ou Atualiza็ใo
	ACTIVATE MSDIALOG oDlg CENTERED VALID iif(_lAbandPCon,.T.,U_ZV2EneTOK())
	//ACTIVATE MSDIALOG oDlg CENTERED VALID iif(_lAbandPCon,.T.,_lProcTDOk)//27/09/17
else
	ACTIVATE MSDIALOG oDlg CENTERED
Endif

If lOk
	IF nOpca == 6
		IF ZV1->ZV1_STATUS='0'
			IF MSGYesNo("Confirma baixa da Presta็ใo ?")
				
				if len(_aCustGrvSE2)>0
					ASORT(_aCustGrvSE2,,,{|x,y| x[2] < y[2] })
					_cGrvCusSe2:=_aCustGrvSE2[1,1]
				endif
			
				BxPresta(cCodSeq,_cGrvCusSe2)//baixar presta็ใo
				Endif
		ELSEIF ZV1->ZV1_STATUS='6'
			ALERT("Presta็ใo jแ baixada!")
		ENDIF
	ELSEIF nOpca == 5
	
		IF MSGYesNo("Confirma exclusใo da Presta็ใo ?")
			ExPresta(cCodSeq)//baixar presta็ใo
		Endif
	
	ELSE
		if !Empty(alltrim(cMatFunc)) //27/09/17
			//Gravando a Presta็ใo de Contas
			If ZV2GrvOk(cCodSeq,"")
				MSGINFO("Presta็ใo incluida com sucesso!")	
				Else
				MSGStop("problemas com a grava็ใo da presta็ใo de contas. ","ZV2GrvOk")
				RollbackSx8()
			EndIf
		endif	
	ENDIF
EndIf

//////JEAN ROCHA 26/08/2022 
If _lAbandPCon .and.  nOpca == 3
	RollBackSX8()

	While ( GetSX8Len() > nSaveSx8 )
		RollBackSX8()
	End While

EndIf

Return  

************************************
Static Function LisContas(_aContas) //28/07/17
************************************
Local oOk, oNo
Local OFONTITE:= TFONT():NEW("COURIER NEW",,-12,,.T.)
Private _OLIST

oOk := LoadBitmap( GetResources(), "LBOK")
oNo := LoadBitmap( GetResources(), "LBNO")

if len(_aContas)>0
            
	@ 000,000 TO 95,338 DIALOG _ODLGFRT TITLE OEMTOANSI("Selecione conta")   
	_ODLGFRT:NCLRPANE := CLR_WHITE - 1    
	//TBUTTON():NEW(002,110,"Confirma",_ODLGFRT,{|| MSGRUN("Aguarde... ",, {|| DelFIE() } )},50,12,,,,.T.,,,,,)
	@ 000,000 LISTBOX _OLIST FIELDS HEADER " ","Conta Contabil","Descri็ใo" FIELDSIZES 5,30,60 SIZE 180,50  
	_OLIST:SETARRAY(_aContas)        

	_OLIST:BLINE      := {|| {IF(_aContas[_OLIST:NAT,1],oOk,oNo),;
										_aContas[_OLIST:NAT,2],;
										_aContas[_OLIST:NAT,3]} }
	
	_OLIST:BLDBLCLICK := {|| SELCONTA(), _OLIST:DRAWSELECT() }
	_OLIST:refresh()
            
	_OLIST:SETFONT(OFONTITE)

	ACTIVATE DIALOG _ODLGFRT CENTERED
else
	alert("Nใo hแ dados!")
endif 

RETURN

****************************
Static Function SELCONTA()
****************************
_cCTBSel:=_aCTBSel[_OLIST:NAT,2]
Close(_ODLGFRT)
Return

************************
User Function ZV2EneTOK()
************************
Local _lRetTok     := .t.
Local _aArea       := GetArea()
Local _aValDesp    := aClone(oMSNewGe1:aCols)
Local _aObrig      := {}
lOCAL _nPVLDConta  := aScan(aHeaderEx,{|x| rtrim(x[2]) == "ZV2_CONTA"}) //27/09/17
Local _nPVLDCCusto := aScan(aHeaderEx,{|x| rtrim(x[2]) == "ZV2_CCUSTO"})
Local _nO          := 1
Local ni           := 1

if !empty(alltrim(cMatFunc))

	aadd(_aObrig, {'ZV2_CODIGO', aScan(aHeaderEx,{|x| rtrim(x[2]) == "ZV2_CODIGO"}), CriaVar( 'ZV2_CODIGO' )})
	aadd(_aObrig, {'ZV2_DESCRI', aScan(aHeaderEx,{|x| rtrim(x[2]) == "ZV2_DESCRI"}), CriaVar( 'ZV2_DESCRI' )})
	aadd(_aObrig, {'ZV2_DEDZIR', aScan(aHeaderEx,{|x| rtrim(x[2]) == "ZV2_DEDZIR"}), SPACE(1)})
	aadd(_aObrig, {'ZV2_VALOR' , aScan(aHeaderEx,{|x| rtrim(x[2]) == "ZV2_VALOR"}) , 0})
	aadd(_aObrig, {'ZV2_DATA'  , aScan(aHeaderEx,{|x| rtrim(x[2]) == "ZV2_DATA"})  , STOD(SPACE(8))})
	aadd(_aObrig, {'ZV2_CCUSTO', aScan(aHeaderEx,{|x| rtrim(x[2]) == "ZV2_CCUSTO"}), CriaVar( 'ZV2_CCUSTO' )})

	For ni:=1 to Len(_aValDesp)
		
		For _nO:=1 to len(_aObrig)
			
			If _aValDesp[ni,_aObrig[_nO,2]] == _aObrig[_nO,3]
				MSGStop("O campo "+aHeaderEx[_aObrig[_nO,2],1]+" deve ser informado!","Obrigatorio")
				_lRetTok := .F.
				Exit
			EndIf

		Next _nO

		if !CtbAmarra(_aValDesp[ni,_nPVLDConta],_aValDesp[ni,_nPVLDCCusto],"" ,"",.T.,.T.,.T.,{})//27/09/17
		
			_lRetTok := .F.
			Exit
		
		ENDIF
				
	Next
else

	MSGStop("O Fornecedor deve ser informado!","Obrigatorio")
	_lRetTok := .F.

endif

RestArea(_aArea)

Return _lRetTok

*****************************
Static Function GetNumZV1() //01/08/17
*****************************
Local _cNumZV1:="000000001"
Local _lTemZv1:=.F.
Local _aArea := GetArea()

DBSelectArea("ZV1")
DBSetOrder(1)
//DBseek(xFilial("ZV2")+ZV1->ZV1_COD+ZV1->ZV1_SEQ)
Do While !EOF() .and. ZV1->ZV1_FILIAL== xFilial("ZV1")
	IF ZV1->ZV1_COD>=_cNumZV1
		_lTemZv1:=.T.
		_cNumZV1:=ZV1->ZV1_COD
	ENDIF
	ZV1->(DBskip())
EndDo

IF _lTemZv1
	_cNumZV1:=SOMA1(_cNumZV1)
ENDIF

RestArea(_aArea)

Return _cNumZV1

**************************************************************
Static Function BxPresta(_cCodPresta,_cCustPresta) //01/08/17
**************************************************************
Local _aArea        := GetArea()
Local _cTipoGrv     := "CH"
Local _cNatuGrv     := GETMV("AL_NATRPRC") // "Z0503"
Local _cPrefGrv     := GETMV("AL_PRFRPRC") //PREFIXO
Local _cNumGrvSE2   := ""

Private lMsErroAuto := .F.
Private lMsHelpAuto := .F.
Private _nTotForn   := 0
Private _cCodForSE2 := ""
Private _cContaForn := ""
Private nTotal      := 0
private nHdlPrv     := 0
private cLoteEst    := "008850"
private cArquivo    := ''
private lCriaHeade  := .T.
Private _cNumPCon   := ""

if nTotRet>0						
	contadeb :=  POSICIONE("ZV2",1,xFilial("ZV2") + _cCodPresta ,"ZV2_CONTA")

	aTitulo :={	{"E2_FILIAL"	,xFilial("SE2")					,Nil},;
				{"E2_PREFIXO"	,_cPrefGrv 						,Nil},;
				{"E2_NUM"      	,_cCodPresta					,Nil},;
				{"E2_PARCELA"  	,"1"							,Nil},;
				{"E2_TIPO"     	,_cTipoGrv						,Nil},;               
				{"E2_NATUREZ"  	,_cNatuGrv						,Nil},;
				{"E2_FORNECE"  	,SUBSTR(cMatFunc,1,6)	   		,Nil},; 
				{"E2_LOJA"     	,SUBSTR(cMatFunc,7,2)			,Nil},;      
				{"E2_EMISSAO"  	,dDataBase						,NIL},;
				{"E2_VENCTO"   	,dDataBase						,NIL},;                          
				{"E2_VENCREA"  	,dDataBase						,NIL},;                                                   
				{"E2_VALOR"    	,nTotRet-nAbatm					,Nil},;
				{"E2_VLCRUZ"	,nTotRet-nAbatm					,Nil},; 
				{"E2_CC"     	,_cCustPresta 					,Nil},;//custo gravado no SE2
				{"E2_CTADEBD"	,contadeb						,Nil} } 
	
	_cNumGrvSE2:="RDP"+_cCodPresta+"1"+_cTipoGrv+cMatFunc
	
	*****************************	
	//Inicio a inclusใo do titulo
	*****************************	
	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| Fina050(x,y,z)},aTitulo,,3) //Inclusao  
	/*
	RECLOCK("SE2",.T.)
	E2_FILIAL  := xFilial("SE2")
	E2_PREFIXO := _cPrefGrv
	E2_NUM     := _cCodPresta
	E2_PARCELA := "1"
	E2_TIPO    := _cTipoGrv
	E2_NATUREZ := _cNatuGrv
	E2_FORNECE := SUBSTR(cMatFunc,1,6)
	E2_LOJA    := SUBSTR(cMatFunc,7,2)
	E2_EMISSAO := dDATABASE
	E2_VENCTO  := dDataBase
	E2_VENCREA := dDataBase
	E2_VALOR   := nTotRet-nAbatm
	E2_VLCRUZ  := nTotRet-nAbatm
	E2_SALDO   := nTotRet-nAbatm
	//E2_HIST    := "Reemb Desp "+rtrim(cNomFavo)
	E2_EMIS1   := DDATABASE
	E2_VENCORI := dDataBase
	E2_MOEDA   := 1
	//E2_STATWS := "LB"
	E2_CC 	   := _cCustPresta
	E2_CTADEBD := contadeb
	MSUNLOCK()
	*/

		If lMsErroAuto
			MostraErro()
		ELSE
			_nTotForn:=0
			DBSelectArea("ZV1")
			DBSetOrder(1)
			if DBseek(xFilial("ZV1")+_cCodPresta)
				RecLock("ZV1",.F.)
				ZV1->ZV1_STATUS:='6'
				_nTotForn:=ZV1->ZV1_TOTRET-ZV1->ZV1_ABATM
				_cCodForSE2:=ZV1->ZV1_MATRIC
				_cNumPCon:=RTRIM(_cPrefGrv)+RTRIM(_cCodPresta) //19/04/18
				ZV1->(MSUnlock())
			endif

			IF _nTotForn>0
				lDigita    := .T.
				lAglutina  := .T.
				nHdlPrv := HeadProva(cLoteEst,"CADZV1",Subs(cUsuario,7,6),@cArquivo)

				DBSelectArea("ZV2") //contabilizo a inclusao - 02/08/17
				DBSetOrder(3)
				DBseek(xFilial("ZV2")+_cCodPresta)
				Do While !EOF() .and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA == xFilial("ZV2")+_cCodPresta
					IF RTRIM(POSICIONE("ZV3",1,XFILIAL("ZV3")+RTRIM(ZV2->ZV2_CODIGO),"ZV3_TIPO"))=='A'
						ZV2->(DBSKIP())
						Loop
					ENDIF

					nTotal += DetProva(nHdlPrv,"P51","CADZV1",cLoteEst)
					ZV2->(DBSKIP())
				EndDo

				RodaProva(nHdlPrv,nTotal)
				cA100Incl(cArquivo,nHdlPrv,3,cLoteEst,lDigita,lAglutina)

			ENDIF

		EndIf
	else
		Alert("valor deve ser maior que zero!")
	endif

	RestArea(_aArea)

Return

	**************************************************
Static Function ExPresta(_cCodPresta) //01/08/17 - Exclusao
	**************************************************
	Local _aArea := GetArea()
	Local lExcfin := .f.
	Local aTitulo as array

	DBSelectArea("ZV1")
	DBSetOrder(1)
	if DBseek(xFilial("ZV1")+_cCodPresta)

		IF ZV1->ZV1_STATUS=='6'
			//ALERT("Presta็ใo jแ baixada. Exclusao nใo permitida!")
			If !(MsgYesNo("Presta็ใo jแ baixada, Confirma exclusใo? " ))
				RestArea(_aArea)
				Return
			ELSE
				lExcfin := .T.
			endif

		ENDIF

		aTitulo :={	{"E2_FILIAL"	,xFilial("ZV1"),Nil},;
			{"E2_PREFIXO"	,"RD ",Nil},;
			{"E2_NUM"      ,_cCodPresta,Nil},;
			{"E2_PARCELA"	," ",Nil},;
			{"E2_TIPO"		,"CH",Nil},;
			{"E2_FORNECE"  ,SUBSTR(ZV1->ZV1_CODSA2,1,6),Nil},;
			{"E2_LOJA"     ,SUBSTR(ZV1->ZV1_CODSA2,7,2),Nil}}

	endif

	IF lExcfin //Exclui tํtulo

		lMsErroAuto := .F.
		cTexto:= "Executando EXECAUTO EXCLUSAO " + ALLTRIM(_cCodPresta)
		FWLogMsg(;
			"INFO",;    //cSeverity      - Informe a severidade da mensagem de log. As op็๕es possํveis sใo: INFO, WARN, ERROR, FATAL, DEBUG
		,;          //cTransactionId - Informe o Id de identifica็ใo da transa็ใo para opera็๕es correlatas. Informe "LAST" para o sistema assumir o mesmo id anterior
		funname(),; //cGroup         - Informe o Id do agrupador de mensagem de Log
		,;          //cCategory      - Informe o Id da categoria da mensagem
		,;          //cStep          - Informe o Id do passo da mensagem
		,;          //cMsgId         - Informe o Id do c๓digo da mensagem
		cTexto,;    //cMessage       - Informe a mensagem de log. Limitada เ 10K
		,;          //nMensure       - Informe a uma unidade de medida da mensagem
		,;          //nElapseTime    - Informe o tempo decorrido da transa็ใo
		;           //aMessage       - Informe a mensagem de log em formato de Array - Ex: { {"Chave" ,"Valor"} }
		)
		MSExecAuto({|x,y,z| Fina050(x,y,z)},aTitulo,,5) //Exclusใo

		If lMsErroAuto
			//Caso encontre erro, mostre
			MostraErro()
			MSGINFO("Erro do EXECAUTO "+_cCodPresta,)
			cTexto:= "Erro EXECAUTO EXCLUSAO " + ALLTRIM(_cCodPresta)

			FWLogMsg(;
				"INFO",;    //cSeverity      - Informe a severidade da mensagem de log. As op็๕es possํveis sใo: INFO, WARN, ERROR, FATAL, DEBUG
			,;          //cTransactionId - Informe o Id de identifica็ใo da transa็ใo para opera็๕es correlatas. Informe "LAST" para o sistema assumir o mesmo id anterior
			funname(),; //cGroup         - Informe o Id do agrupador de mensagem de Log
			,;          //cCategory      - Informe o Id da categoria da mensagem
			,;          //cStep          - Informe o Id do passo da mensagem
			,;          //cMsgId         - Informe o Id do c๓digo da mensagem
			cTexto,;    //cMessage       - Informe a mensagem de log. Limitada เ 10K
			,;          //nMensure       - Informe a uma unidade de medida da mensagem
			,;          //nElapseTime    - Informe o tempo decorrido da transa็ใo
			;           //aMessage       - Informe a mensagem de log em formato de Array - Ex: { {"Chave" ,"Valor"} }
			)
		Endif



//	EndIf	

	ENDIF

	RecLock("ZV1",.F.)
	ZV1->(DBDelete())
	ZV2->(MSUnlock())

	DBSelectArea("ZV2")
	DBSetOrder(3)
	DBseek(xFilial("ZV2")+_cCodPresta)
	Do While !EOF() .and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA == xFilial("ZV2")+_cCodPresta
		RecLock("ZV2",.F.)
		ZV2->(DBDelete())
		ZV2->(MSUnlock())
		ZV2->(DBskip())

	EndDo

	DBSelectArea("AC9")
	DBGotop()
	AC9->(DBSetOrder(2))//AC9_FILIAL + AC9_ENTIDA + AC9_FILENT + AC9_CODENT + AC9_CODOBJ
	//AC9->(DBseek(xFilial("AC9")+"ZV1"+XFILIAL("ZV1")+XFILIAL("ZV1")+PADR(_cChvZV1,TamSx3("AC9_CODENT")[1])+"0000000000" ))
	AC9->(DBseek(xFilial("AC9") + "ZV1" + XFILIAL("ZV1") + ALLTRIM(_cCodPresta) ))
	Do While !AC9->(EOF()) .AND. AC9->AC9_FILENT+alltrim(AC9->AC9_CODENT) == xFilial("ZV1")+ALLTRIM(_cCodPresta)
		if rtrim(AC9->AC9_ENTIDA)=='ZV1'
			Reclock("AC9",.F.)
			AC9->(DBDelete())
			MSUnlock()
		endif
		AC9->(DBskip())
	EndDo

	MSGINFO("Exito na Exclusใo da Viagem: "+ ALLTRIM(_cCodPresta) +" - "+cusername,)
	cTexto:= "Exito na Exclusใo da Viagem: " + ALLTRIM(_cCodPresta) +" - "+cusername

	FWLogMsg(;
		"INFO",;    //cSeverity      - Informe a severidade da mensagem de log. As op็๕es possํveis sใo: INFO, WARN, ERROR, FATAL, DEBUG
	,;          //cTransactionId - Informe o Id de identifica็ใo da transa็ใo para opera็๕es correlatas. Informe "LAST" para o sistema assumir o mesmo id anterior
	funname(),; //cGroup         - Informe o Id do agrupador de mensagem de Log
	,;          //cCategory      - Informe o Id da categoria da mensagem
	,;          //cStep          - Informe o Id do passo da mensagem
	,;          //cMsgId         - Informe o Id do c๓digo da mensagem
	cTexto,;    //cMessage       - Informe a mensagem de log. Limitada เ 10K
	,;          //nMensure       - Informe a uma unidade de medida da mensagem
	,;          //nElapseTime    - Informe o tempo decorrido da transa็ใo
	;           //aMessage       - Informe a mensagem de log em formato de Array - Ex: { {"Chave" ,"Valor"} }
	)
	RestArea(_aArea)
Return

User function RelPresC() //02/08/17 - Relat๓rio de presta็ใo de contas

	Local oExcel:= FWMSEXCEL():New()
	LOCAL cPerg:="RELPRESC"
	Local _aArea := GetArea()

	if !Pergunte(cPerg,.T.)
		Return
	Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros              ณ
//ณ mv_par01            // da data                    ณ
//ณ mv_par02            // ate a data                 ณ
//ณ mv_par03            // deduz IR                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If Lastkey() == 27
		Return
	End

	if MV_PAR04==2 //30/10/18 - Solicita็ใo de gera็ใo em Relat๓rio PDF - Chamado 20677
		U_RelPconRP(MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR05,MV_PAR06)
		RestArea(_aArea)
		Return
	endif

	cWorkSheet :="Relatorio de Presta็ใo de contas - Data: "+dtoc(Date())
	cTable := "Relatorio de Presta็ใo de contas - Data: "+dtoc(Date())+ " - Hora:"+Time()//+" - Usuario:"+ALLTRIM(USRRETNAME(_cIdUSInv))

	_cQry:=" SELECT ZV1_COD,ZV1_SEQ,ZV1_CODSOL,ZV1_NSOLIC,ZV1_EMISSA,ZV1_MATRIC,ZV1_NFUNC,ZV1_DTVENC,"
	_cQry+=" ZV1_STATUS,ZV1_BANCO,ZV1_AGENCI,ZV1_CONTA,ZV1_TOTRET,ZV1_ABATM,ZV2_DATA,ZV3_COD,ZV3_DESCRI,ZV3_TIPO,"
	_cQry+=" ZV2_CONTA,ZV2_VALOR,ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), ZV2_COMPLE)),'') as COMPLEMENTO ,ZV2_DEDZIR "
	_cQry+=" FROM "+ retsqlname("ZV1")+","+retsqlname("ZV2")+","+retsqlname("ZV3")
	_cQry+=" where "+retsqlname("ZV1")+".D_E_L_E_T_=' '"
	_cQry+=" AND "+retsqlname("ZV2")+".D_E_L_E_T_=' '"
	_cQry+=" AND "+retsqlname("ZV3")+".D_E_L_E_T_=' '"
	_cQry+=" AND ZV1_FILIAL='"+xfilial("ZV1")+"'"
	_cQry+=" AND ZV2_FILIAL='"+xfilial("ZV2")+"'"
	_cQry+=" AND ZV3_FILIAL='"+xfilial("ZV3")+"'"
	_cQry+=" AND ZV1_COD=ZV2_CODVIA "
	_cQry+=" AND ZV2_CCUSTO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' " //modifica็ใo em conjunto com arquivo de perguntas. Wagno em 11/07/2019.
//_cQry+=" AND ZV1_SEQ=ZV2_SEQ "
	_cQry+=" AND ZV3_COD=ZV2_CODIGO "
	_cQry+=" AND ZV2_DATA>='"+DTOS(MV_PAR01)+"'"
	_cQry+=" AND ZV2_DATA<='"+DTOS(MV_PAR02)+"'"

	IF MV_PAR03<>3
		_cQry+=" AND ZV2_DEDZIR='"+IIF(MV_PAR03==1,'S','N')+"' " //corrigido por Wagno em 11/07/2019
	ENDIF
	_cQry+=" ORDER BY ZV2_DATA "

	DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQry), "TZV", .F., .T.)
	IF !TZV->(EOF()) .AND. !TZV->(BOF())
		//Nome da Worksheet
		oExcel:AddworkSheet(cWorkSheet)

		//Nome da Tabela
		oExcel:AddTable (cWorkSheet,cTable)
		//adciono campo de periodo de apura็ใo

		oExcel:AddColumn(cWorkSheet, cTable, "Dt Despesa"	,1,1)
		oExcel:AddColumn(cWorkSheet, cTable, "Numero"		,1,1)
		oExcel:AddColumn(cWorkSheet, cTable, "Fornecedor"	,1,1)
		oExcel:AddColumn(cWorkSheet, cTable, "Despesa"  	,1,1)
		oExcel:AddColumn(cWorkSheet, cTable, "Tipo"  		,1,1)
		oExcel:AddColumn(cWorkSheet, cTable, "Valor Total"  ,1,1)
		oExcel:AddColumn(cWorkSheet, cTable, "Abatimentos"	,1,1)
		oExcel:AddColumn(cWorkSheet, cTable, "Complemento"  ,1,1)
		oExcel:AddColumn(cWorkSheet, cTable, "Deduz IR"		,1,1)
		oExcel:AddColumn(cWorkSheet, cTable, "Vencimento"	,1,1)//20/07/18 - Fabio Yoshioka

		WHILE !TZV->(EOF())

/*		oExcel:AddRow(cWorkSheet,cTable,{dtoc(stod(TZV->ZV2_DATA)),;
			TZV->ZV1_COD+TZV->ZV1_SEQ,;
			TZV->ZV1_MATRIC+"-"+TZV->ZV1_NFUNC,;
			TZV->ZV3_COD+"-"+TZV->ZV3_DESCRI,;
			TZV->ZV3_TIPO,;
			IIF(TZV->ZV3_TIPO=='D',TZV->ZV2_VALOR,0),;
			IIF(TZV->ZV3_TIPO=='A',TZV->ZV2_VALOR,0),;
			RTRIM(TZV->COMPLEMENTO),;
			IIF(TZV->ZV2_DEDZIR=='S','SIM','NAO'),;
			 DTOC(STOD(TZV->ZV1_DTVENC))})*/
			 
			 //01/11/18 - exibir data de emissao - Solicita็ใo Eunice
		oExcel:AddRow(cWorkSheet,cTable,{dtoc(stod(TZV->ZV1_EMISSA)),;
			TZV->ZV1_COD+TZV->ZV1_SEQ,;
			TZV->ZV1_MATRIC+"-"+TZV->ZV1_NFUNC,;
			TZV->ZV3_COD+"-"+TZV->ZV3_DESCRI,;
			TZV->ZV3_TIPO,;
			IIF(TZV->ZV3_TIPO=='D',TZV->ZV2_VALOR,0),;
			IIF(TZV->ZV3_TIPO=='A',TZV->ZV2_VALOR,0),;
			RTRIM(TZV->COMPLEMENTO),;
			IIF(TZV->ZV2_DEDZIR=='S','SIM','NAO'),;
			 DTOC(STOD(TZV->ZV1_DTVENC))})

		TZV->(DBSKIP())
	ENDDO

	MAKEDIR("C:\TMP\")
	_cCaminho:="C:\TMP\"+cPerg+"_"+DTOS(DDATABASE)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2)+".xml"
	oExcel:Activate()
	oExcel:GetXMLFile(_cCaminho)
	
	//abre planilha
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(_cCaminho) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	
ENDIF   
TZV->(DBCLOSEAREA())
RestArea(_aArea)
Return

*******************************
User Function RPrestAP(_cIdRel)
*******************************
//Local _nAll
Local _aArea := GetArea()

	MsgRun("Gerando PDF. Aguarde...",,{||AprvPrest(_cIdRel)})
	RestArea(_aArea)   
Return

**********************************
Static Function AprvPrest(_cIdRel) //relat๓rio de presta็ใo de contas para Aprova็ใo - 04/08/17
***********************************
Local _nAll , _nTtDsp , _nDes , _nCol

Local _aDadSZ3        := {}
Local _aDespesas      := {}
lOCAL _cFornLoja      := ZV1->ZV1_MATRIC
Local _cCPF           := posicione("SA2",1,XFILIAL("SA2")+_cFornLoja,"A2_CGC")
Local _cTpGCG         := iif(len(alltrim(_cCPF))==11," CPF: "," CNPJ: ")
Local _cNomeFor       := rtrim(ZV1->ZV1_NFUNC)+ IIF(!EMPTY(ALLTRIM(_cCPF)),_cTpGCG+_cCPF,"")
Local _cCodPrest      := ZV1->ZV1_COD
Local _nTotAdto       := ZV1->ZV1_TOTADI //09/08/17
lOCAL _nTotGer        := ZV1->ZV1_TOTRET //03/10/17
local cPathInServer   := GetMv('AL_DIRPDFS') //02/01/17 "\spool\"//

local _cArqPdf        := ALLTRIM(_cCodPrest)+"_"+ DTOS(DATE()) +"_"+ SUBSTR(TIME(),1,2)+ SUBSTR(TIME(),4,2)+ SUBSTR(TIME(),7,2)
Local _cPathLoc       := rtrim(GetMv( 'AL_DIRPDFL' )) //"C:\TMPPDF\" //10/01/18
Local _cVencZV1       := Dtoc(ZV1->ZV1_DTVENC) //31/07/18 - Fabio Yoshioka
Local lAdjustToLegacy := .F.
Local lDisableSetup   := .T.

Local _nImpPap
Local _nJ
Local _nDesp
Local _nZV3
Local _nRt

Private oPrn   

_cRetArqPDF:=rtrim(_cArqPdf)+".pdf"

//                             Tam  Bold   Under
oFont := TFont():New( "Arial",,20,,.T.,,,,,.F. )
oFont1:= TFont():New( "Verdana",,13,,.T.,,,,,.F. )
oFont6:= TFont():New( "Verdana",,8,,.T.,,,,,.F. )
oFont7:= TFont():New( "Arial",,12,,.T.,,,,,.F. )
oFont2:= TFont():New( "Arial",,7,,.t.,,,,,.f. )
oFont8:= TFont():New( "Arial",,7,,.F.,,,,,.f. )
oFont3:= TFont():New( "MicrogrammaDBolExt",,18,,.t.,,,,,.f. )
oFont4:= TFont():New( "MicrogrammaDMedExt",,14,,.t.,,,,,.f. )
oFont5:= TFont():New( "Baker Signet BT",,10,,.t.,,,,,.f. )

if empty(alltrim(_cIdRel))
	_cCaminhoPdf:= cGetFile('Arquivo *|*.*|Arquivo PDF|*.pdf','Selecione Diretorio',0,'C:\',.T.,GETF_LOCALHARD+GETF_RETDIRECTORY,.F.)//cGetFile('Arquivo *|*.*|Arquivo PDF|*.PDF','Selecione local',0,'C:\Dir\',.F.,,.F.) //"C:\TMPTKT\"
else
	//CRIA DIRETORIOS
	//MakeDir(Trim(Upper(cPathInServer))) 
	MakeDir(Trim(Upper(_cPathLoc))) //10/01/18
	//cIniFile := GetADV97()
	//_cCaminhoPdf := GetPvProfString(GetEnvServer(),"RootPath","ERROR", cIniFile )+cPathInServer
	_cCaminhoPdf := _cPathLoc //10/01/18
	//deleto existentes
	/*_aTmpPdfFiles:= Directory(_cCaminhoPdf+"\*.PDF","D")
	For _ndPDF:=1 to len(_aTmpPdfFiles)
		if file(_cCaminhoPdf+_aTmpPdfFiles[_ndPDF,1])
			FERASE(_cCaminhoPdf+_aTmpPdfFiles[_ndPDF,1])
		endif
	Next _ndPDF*/ //comentado em 18/07/18
	
endif

If oPrn == Nil
	if empty(alltrim(_cIdRel))
		lPreview := .T.
		oPrn := FWMSPrinter():New(_cCodPrest+dtos(dDatabase)+substr(Time(),1,2)+substr(Time(),4,2)+".rel", IMP_PDF, lAdjustToLegacy, cPathInServer, lDisableSetup, , , , , , .F., )// Ordem obrigแtoria de configura็ใo do relat๓rio
		oPrn:SetResolution(72)
		oPrn:SetLandscape()
		oPrn:SetPaperSize(DMPAPER_A4) 
		oPrn:cPathPDF :=_cCaminhoPdf //"c:\directory\" // Caso seja utilizada impressใo em IMP_PDF
	else
		lPreview := .T.
		oPrn := FWMSPrinter():New(_cArqPdf+".rel", IMP_PDF, lAdjustToLegacy, , lDisableSetup, , , , , , .F., )// Ordem obrigแtoria de configura็ใo do relat๓rio
		oPrn:SetResolution(72)
		oPrn:SetLandscape()
		oPrn:SetPaperSize(DMPAPER_A4) 
		oPrn:lServer := .f.
		oPrn:cPathPDF := _cCaminhoPdf
		oPrn:SetViewPDF(.t.)
	endif
EndIf       

nPagina:= 1 //controle do numero de paginas 
//nPagina:=1 //controle do numero de paginas 
_nTotEst:=0
_nTotRea:=0
_nTotSld:=0

_nIniLPd:=148
_nIniCPd:=42

_cDespDig:="A"
_aColData:={}
_nColData:=260
DBSelectArea("ZV2")
DBSetOrder(4)
DBseek(xFilial("ZV2")+_cCodPrest)
Do While !EOF() .and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA == xFilial("ZV2")+_cCodPrest
	_nPosZV2:=aScan(_aDespesas,{|x| x[1] == ZV2->ZV2_DATA .AND. RTRIM(x[3])== RTRIM(ZV2->ZV2_CODIGO) }) 
	IF _nPosZV2==0
		aadd(_aDespesas,{ZV2->ZV2_DATA,;
			ZV2->ZV2_DESCRI,;
			ZV2->ZV2_CODIGO,;
			ZV2->ZV2_COMPLE,;
			ZV2->ZV2_VALOR,;
			"",;
			0,;
			0,;
			.f.,;
			dtos(ZV2->ZV2_DATA),;
			.f.,;
			.T.})
	ELSE
		_aDespesas[_nPosZV2,5]+=ZV2->ZV2_VALOR
	ENDIF
	
	ZV2->(DBskip())
EndDo
nNumDesp := 0  //quantidade distinta de despesas
//filtrar somente o cadastro de despesa que tiver movimento - 29/09/17
DBSelectArea("ZV3")
DBSetorder(1)
DBseek(xFilial("ZV3")+'001')
Do While !EOF() .and. ZV3->ZV3_FILIAL == xFilial("ZV3") 
	If UPPER(rtrim(ZV3->ZV3_TIPO)) <> 'D'
		ZV3->(DBSkip())
		Loop
	EndIf
	
	if aScan(_aDespesas,{|x| RTRIM(x[3])== RTRIM(ZV3->ZV3_COD) })>0 //29/09/17 verifico se houve uso da despesa
		nNumDesp++
		
		AADD(_aDadSZ3,{ZV3->ZV3_COD, ZV3->ZV3_DESCRI, _nIniLPd, _nIniCPd, 0, .T., nPagina})

		if nNumDesp % 10 == 0 
			nPagina++
		Endif

		_nIniLPd+=10
		
	endif
	
	ZV3->(DBskip())
EndDo

_aDatImpOk:={} //armazeno as datas de despesas ja impressas
_cDespDig:="A"

_aPageALL:={} //29/09/17 - montar todos os dados a serem impressos por pแgina 
_aPageCol:={} //29/09/17 - montar todas colunas a serem impressos por pแgina	
_aPageDes:={} //29/09/17 - montar todas descri็๕es a serem impressos por pแgina

_nIniLZV3:=148
_nIniCZV3:=42
_nColPage:=260
_nColLimi:=760
_nLimLZV3:=258 //limite de linhas despesas
	
IF LEN(_aDespesas)>0
	_aDespesas:=ASORT(_aDespesas,,,{|x,y| x[10] < y[10] })//ordena็ใo por data
	
	_aColData:={}
	_cColDig:="A"
	nPaginaCol:=1
	_aDespDif:={}
	_nQtdDesp:=1
	For _nJ:=1 to len(_aDespesas) //Array para identificar a posi็ใo nas colunas
		
		if aScan(_aDespDif,rtrim(_aDespesas[_nJ,3]))==0 //09/10/17
			aadd(_aDespDif,rtrim(_aDespesas[_nJ,3]))
			_nQtdDesp++
		endif
		
		if _nQtdDesp>11 // (linhas de despesas)
			_nQtdDesp:=1
			_nColData:=260
			nPaginaCol++
		endif
		
		if aScan(_aColData,{|x| x[1] == _aDespesas[_nJ,1] .and. x[7]==nPaginaCol})==0 //armazeno posi็ใo de coluna p/ data
			
			aadd(_aColData,{_aDespesas[_nJ,1], _nColData, .f., _cDespDig, _aDespesas[_nJ,5], .f., nPaginaCol})
				
			_nColData+=50

			if len(_aColData)%10==0 
				_nColData:=260
				nPaginaCol++
			endif

			_cDespDig:=SOMA1(_cDespDig)
		else
			_aColData[aScan(_aColData,{|x| x[1] == _aDespesas[_nJ,1]}),5]+=	_aDespesas[_nJ,5] //total por data
		endif
					
	Next _nJ
		
	_nSeqZV3:=1
	_nIniLZV3:=148
	nNewPag:= 1
	
	For _nZV3:=1 to len(_aDadSZ3)

		IF _nIniLZV3 < _nLimLZV3 //_aDadSZ3[_nZV3,6] .and. 
		
			_nColPage:=260 //Inicio da primeira coluna 
			_aPageCol:={}

			if !_aDadSZ3[_nZV3,7]  == nNewPag
				_nIniLZV3:=148
				nNewPag++
			Endif

			//ARRAY DE COLUNAS DAS DEPESAS POR PAGINA
			For _nDesp:=1 to len(_aDespesas)

				IF RTRIM(_aDespesas[_nDesp,3])== RTRIM(_aDadSZ3[_nZV3,1]) 

					_nPCDt:=aScan(_aColData,{|x| x[1] == _aDespesas[_nDesp,1]})
					
					if _aDespesas[_nDesp,12] .and. _aColData[_nPCDt,2]<=_nColLimi 
					//.and. _aColData[_nPCDt,7]==nPagina //posi็ใo conforme a data
						
						aadd(_aPageCol,{_aDespesas[_nDesp,1],;
							_aDespesas[_nDesp,2],;
							_aDespesas[_nDesp,3],;
							_aDespesas[_nDesp,4],;
							_aDespesas[_nDesp,5],;
							_aColData[_nPCDt,2]})

							_aDespesas[_nDesp,12]:=.F. //Marca despesa como informada
							
							//INCLUO COMPLEMENTO - 03/10/17
						aadd(_aPageDes,{_aDespesas[_nDesp,1],;
								Alltrim(str(_nSeqZV3))+RTRIM(_aColData[_nPCDt,4]),;
								_aDespesas[_nDesp,4],;
								_aDadSZ3[_nZV3,7], ; //nPagina,;
								.f.})

					endif
				
				ENDIF

			Next _nDesp
				
			if len(_aPageCol)>0 //06/10/17
				//ARRAY GERAL COM OS DADOS POR PAGINA
				AADD(_aPageALL,{_aDadSZ3[_nZV3,1],;
						_aDadSZ3[_nZV3,2],;
						_nIniLZV3,;
						_nIniCZV3,;
						_aPageCol,;
						_aDadSZ3[_nZV3,7]}) //nPagina})
					
				_nIniLZV3+=10
				
			endif
			
			if aScan(_aDespesas,{|x| rtrim(x[3])== RTRIM(_aDadSZ3[_nZV3,1]) .and. x[12]== .T. })==0 //29/09/17 verifico se AINDA hแ pendentes para proxima pagina		
				_aDadSZ3[_nZV3,6]:=.F.
			endif
				
			_nSeqZV3++	
		ENDIF

	next _nZV3

	_aPageDes:=ASORT(_aPageDes,,,{|x,y| x[1] < y[1] })//ordena็ใo por data
	
	_nPagePDF:=1
	_cColDig:="A"
	_nContaZV3:=1
	For _nImpPap:=1 to nPagina
	
		oPrn:StartPage()  
		cBitMap:= "alub_energia.bmp"
		oPrn:SayBitmap( 030, 030,cBitMap, 80, 70 )
		oPrn:line( 100,40,500,40)     // Linha V 1
		oPrn:line( 140,200,250,200)     // Linha V 2
		oPrn:line( 110,250,250,250)     // Linha V 3
		oPrn:line( 300,200,460,200)     // Linha V 2
		oPrn:line( 300,250,460,250)     // Linha V 3
		oPrn:line( 110,300,250,300)     // Linha V 4
		oPrn:line( 100,350,250,350)     // Linha V 5
		oPrn:line( 100,400,250,400)     // Linha V 6
		oPrn:line( 260,400,290,400)     // Linha V 6
		oPrn:line( 100,450,250,450)     // Linha V 7
		oPrn:line( 100,500,250,500)     // Linha V 8
		oPrn:line( 100,550,460,550)     // Linha V 9
		oPrn:line( 100,600,250,600)     // Linha V 10
		oPrn:line( 100,650,250,650)     // Linha V 11
		oPrn:line( 100,700,460,700)     // Linha V 12
		oPrn:line( 110,750,460,750)     // Linha V 13
		oPrn:line( 100,800,500,800)     // Linha V ultima
		oPrn:line( 100, 040,100, 800)       // Linha H 1
		oPrn:line( 110, 040,110, 800)       // Linha H 2
		oPrn:line( 120, 250,120, 800)       // Linha H 3 
		oPrn:line( 130, 250,130, 800)       // Linha H 4 
		oPrn:line( 140, 040,140, 800)       // Linha H 5 
		oPrn:line( 150, 200,150, 800)       // Linha H 6 
		oPrn:line( 160, 200,160, 800)       // Linha H 7 
		oPrn:line( 170, 200,170, 800)       // Linha H 8 
		oPrn:line( 180, 200,180, 800)       // Linha H 9
		oPrn:line( 190, 200,190, 800)       // Linha H 10	
		oPrn:line( 200, 200,200, 800)       // Linha H 11
		oPrn:line( 210, 200,210, 800)       // Linha H 12
		oPrn:line( 220, 200,220, 800)       // Linha H 13
		oPrn:line( 230, 200,230, 800)       // Linha H 14
		oPrn:line( 240, 200,240, 800)       // Linha H 15
		oPrn:line( 250, 040,250, 800)       // Linha H 16
		oPrn:line( 260, 550,260, 800)       // Linha H 17
		oPrn:line( 270, 550,270, 800)       // Linha H 18
		oPrn:line( 280, 550,280, 800)       // Linha H 19
		oPrn:line( 290, 040,290, 800)       // Linha H 20
		oPrn:line( 300, 550,300, 800)       // Linha H 21
		oPrn:line( 310, 040,310, 800)       // Linha H 22
		oPrn:line( 320, 040,320, 800)       // Linha H 23
		oPrn:line( 330, 040,330, 800)       // Linha H 24
		oPrn:line( 340, 040,340, 800)       // Linha H 25
		oPrn:line( 350, 040,350, 800)       // Linha H 26
		oPrn:line( 360, 040,360, 800)       // Linha H 27
		oPrn:line( 370, 040,370, 800)       // Linha H 28
		oPrn:line( 380, 040,380, 800)       // Linha H 29
		oPrn:line( 390, 040,390, 800)       // Linha H 30
		oPrn:line( 400, 040,400, 800)       // Linha H 31
		oPrn:line( 410, 040,410, 800)       // Linha H 32
		oPrn:line( 420, 040,420, 800)       // Linha H 33
		oPrn:line( 430, 040,430, 800)       // Linha H 34
		oPrn:line( 440, 040,440, 800)       // Linha H 35
		oPrn:line( 450, 040,450, 800)       // Linha H 36
		oPrn:line( 460, 040,460, 800)       // Linha H 37
		oPrn:line( 480, 200,480, 400)       // Linha H 38			
		oPrn:line( 500, 040,500, 800)       // Linha H ultima
		
		oPrn:Say(050, 350, 'RELATORIO DE DESPESAS', oFont)
		oPrn:Say(075, 500, '1)Relat๓rio Depesas Nro '+_cCodPrest, oFont6)
		oPrn:Say(075, 760, Dtoc(dDatabase), oFont6)
		oPrn:Say(108, 750, "Page "+alltrim(str(_nImpPap)) +" of "+alltrim(str(nPagina)), oFont8)//nome
		oPrn:Say(128, 42, "Departamento: RAILEC Energia S/A", oFont8)
		oPrn:Say(108, 42, _cNomeFor, oFont8)
		oPrn:Say(298, 42, "Detalhes por Linha: Incluir nome da pessoa e companhia - Discriminar compra por despesas", oFont8)
		oPrn:Say(308, 62, "Data", oFont8)
		oPrn:Say(308, 205, "Item Nr.", oFont8)
		oPrn:Say(308, 350, "Descri็ใo", oFont8)	
		//oPrn:Say(268, 402, "Taxa de Conversใo", oFont8) //comentado em 29/09/17		
		oPrn:Say(258, 654, "Total:", oFont8)
		oPrn:Say(288, 552, "Transporte valor de despesas da pแgina anterior", oFont8)
		oPrn:Say(328, 552, "Transportar", oFont8)
		
		oPrn:Say(308, 760, Transform(_nTotAdto,"@E 999,999,999.99"), oFont8)//09/08/17 
		oPrn:Say(318, 760, Transform(_nTotAdto,"@E 999,999,999.99"), oFont8) 
		
		oPrn:Say(308, 630, "Adiantamentos", oFont8) 
		oPrn:Say(318, 630, "Total Adto.", oFont8) 
		oPrn:Say(328, 630, " Total Despesas", oFont8)
		oPrn:Say(338, 630, "Valor para RAILEC", oFont8) 
		oPrn:Say(348, 630, "Valor para Empregado", oFont8)
		
		oPrn:Say(378, 552, "DEPำSITO NA CONTA :", oFont8)
		oPrn:Say(388, 552, "Banco: "+posicione("SA2",1,XFILIAL("SA2")+_cFornLoja,"A2_BANCO"), oFont8)
		oPrn:Say(398, 552, "Agencia: "+posicione("SA2",1,XFILIAL("SA2")+_cFornLoja,"A2_AGENCIA"), oFont8)
		oPrn:Say(408, 552, "Conta: "+posicione("SA2",1,XFILIAL("SA2")+_cFornLoja,"A2_NUMCON"), oFont8)
		oPrn:Say(418, 552, "Vencimento: "+_cVencZV1, oFont8) //31/07/18 - Fabio Yoshioka
		oPrn:Say(138, 752, "Totals", oFont8)
			
		oPrn:Say(478, 150, "    Assinatura:", oFont8)
		oPrn:Say(498, 150, "Data Assinatura:", oFont8)
		oPrn:Say(498, 500, "Data:", oFont8)

		_nCountCol:=1
		_nLinDescri:=318 //03/10/17
		_nVTotLin:=0 //03/10/17
		_nVGerLin:=0
		_aVTotCol:={}
		for _nAll :=1 to len(_aPageALL)
			if _aPageALL[_nAll,6]==_nImpPap //somente a pagina corrente
				oPrn:Say(_aPageALL[_nAll,3], _aPageALL[_nAll,4], ALLTRIM(STR(_nAll))+") "+_aPageALL[_nAll,2], oFont8)
				_aRetDesp:=aclone(_aPageALL[_nAll,5])
				
				if len(_aRetDesp)>0
					_nVTotLin:=0
					For _nRt:=1 to len(_aRetDesp)
						oPrn:Say(_aPageALL[_nAll,3], _aRetDesp[_nRt,6], Transform(_aRetDesp[_nRt,5],"@E 999,999,999.99"), oFont8)
						_nVTotLin+=_aRetDesp[_nRt,5]
						_nVGerLin+=_aRetDesp[_nRt,5]
						_nPosTotCol:=aScan(_aVTotCol,{|x| x[1] == _aRetDesp[_nRt,6]})//armazeno posi็ใo da coluna
						if _nPosTotCol==0
							aadd(_aVTotCol,{_aRetDesp[_nRt,6],_aRetDesp[_nRt,5]})
						else
							_aVTotCol[_nPosTotCol,2]+=_aRetDesp[_nRt,5]
						endif
							
					Next
					oPrn:Say(_aPageALL[_nAll,3], 760, Transform(_nVTotLin,"@E 999,999,999.99"), oFont8)
				endif
				
				
			endif
		Next _nAll
		
		oPrn:Say(248,42, "Total Despesas", oFont8)
		
		For _nTtDsp:=1 to len(_aVTotCol) //03/10/17
			oPrn:Say(248, _aVTotCol[_nTtDsp,1], Transform(_aVTotCol[_nTtDsp,2],"@E 999,999,999.99"), oFont8)
		Next _nTtDsp
		
		if _nVGerLin>0 //03/10/17
			oPrn:Say(258, 760, Transform(_nVGerLin,"@E 999,999,999.99"), oFont8)
		endif
		
		_nLinDescri:=318
		For _nDes:=1 to len(_aPageDes)//imprimo descri็ใo
			if !_aPageDes[_nDes,5] .AND. _nImpPap>=_aPageDes[_nDes,4] .AND. _nLinDescri<460// .OR. _nImpPap>_aPageDes[_nDes,4] 
				oPrn:Say(_nLinDescri,60, dtoc(_aPageDes[_nDes,1]), oFont8)//data
				oPrn:Say(_nLinDescri,210 ,_aPageDes[_nDes,2], oFont8)//item Nro
				oPrn:Say(_nLinDescri,260 ,_aPageDes[_nDes,3], oFont8) //Descri็ใo
				_aPageDes[_nDes,5]:=.T.
				_nLinDescri+=10
			endif
		Next _nDes
		
		
		For _nCol:=1 to len(_aColData)
			if _aColData[_nCol,7]==_nImpPap
				oPrn:Say(118, _aColData[_nCol,2], "Ver Abaixo", oFont8)
				oPrn:Say(128, _aColData[_nCol,2]+10, _aColData[_nCol,4], oFont8)
				oPrn:Say(138, _aColData[_nCol,2], dTOC(_aColData[_nCol,1]), oFont8)//03/10/17
			endif
		Next _nCol
		
		//Totais
		oPrn:Say(328, 760, Transform(_nTotGer,"@E 999,999,999.99"), oFont8) //TOTAL DESPESAS
		oPrn:Say(348, 760, Transform(_nTotGer-_nTotAdto,"@E 999,999,999.99"), oFont8) //VALOR PARA EMPREGADO
		
				/*AADD(_aPageALL,{_aDadSZ3[_nZV3,1],;
						_aDadSZ3[_nZV3,2],;
						_nIniLZV3,;
						_nIniCZV3,;
						_aPageCol,;
						nPagina})*/

		/*For _nDp:=1 to len(_aDespesas)//imprimo cadastro de despesas
			if !_aDespesas[_nDp,9]
				
				if _nCountCol>10
					exit
				endif
				
				_nSeekCol:=aScan(_aColData,{|x| x[1] == _aDespesas[_nDp,1]})
				if _nSeekCol>0
					if !_aColData[_nSeekCol,3]
						oPrn:Say(138, _aColData[_nSeekCol,2], DTOC(_aDespesas[_nDp,1]), oFont8) //data
						_aColData[_nSeekCol,3]:=.T.
						_nCountCol++
					endif
				endif
				
					
				//procuro posi็ใo de linha no cadastro de despesas
				_nPosseek:=aScan(_aDadSZ3,{|x| rtrim(x[1]) == RTRIM(_aDespesas[_nDp,3])})
				
				if _nPosseek>0
					oPrn:Say(_aDadSZ3[_nPosseek,3], _aColData[_nSeekCol,2], Transform(_aDespesas[_nDp,5],"@E 999,999,999.99"), oFont8) //valor
					_aDadSZ3[_nPosseek,5]+=_aDespesas[_nDp,5]// total por despesa
				endif
				
				_aDespesas[_nDp,9]:=.T.
				
			endif
		Next _nDp
		
		
		//imprimo total por data
		_nColImp:=1
		For _nTDt:= 1 to len(_aColData)
			IF _nColImp>10 //ATE 10 POR PAGINA
				EXIT
			ENDIF
			
			if !_aColData[_nTDt,6]
				oPrn:Say(248, _aColData[_nTDt,2], Transform(_aColData[_nTDt,5],"@E 999,999,999.99"), oFont8) //valor
				_aColData[_nTDt,6]:=.T.
				_nColImp++
			endif				
		Next _nTDt
		
		_nTotGer:=0
		//imprimo total por despesa
		For _nTDP:= 1 to len(_aDadSZ3)
			oPrn:Say(_aDadSZ3[_nTDP,3], 760, Transform(_aDadSZ3[_nTDP,5],"@E 999,999,999.99"), oFont8) //valor
			_nTotGer+=_aDadSZ3[_nTDP,5]
			//_aDadSZ3[_nTDP,5]:=0	//zero para caso tenha mais de uma pagina		
		Next _nTDt
		
		oPrn:Say(258, 760, Transform(_nTotGer,"@E 999,999,999.99"), oFont8)
		oPrn:Say(328, 760, Transform(_nTotGer,"@E 999,999,999.99"), oFont8)
		oPrn:Say(348, 760, Transform(_nTotGer-_nTotAdto,"@E 999,999,999.99"), oFont8)
								
		
		For _nZ:= 1 to len(_aDadSZ3)
			oPrn:Say(_aDadSZ3[_nZ,3], _aDadSZ3[_nZ,4], ALLTRIM(STR(_nZ))+ ') ' +_aDadSZ3[_nZ,2], oFont8)
		Next _nZ
		
		
		if len(_aDadSZ3)>0
			oPrn:Say(_aDadSZ3[len(_aDadSZ3),3]+10, _aDadSZ3[len(_aDadSZ3),4], "Total Despesas", oFont8)
		endif
		
		_nColPos1:=260
		//_nColPos2:=270
		
		For _nCol:=1 to 10
			oPrn:Say(118, _nColPos1, "Ver Abaixo", oFont8)
			//oPrn:Say(128, _nColPos2, _cColDig, oFont8)
			_nColPos1+=50
			//_nColPos2+=50
			_cColDig:=SOMA1(_cColDig)
		Next
		
		//Imprimo descri็ใo por item/data
		/*_lDetPend:=.f.
		_nPItLin:=318
		For _nItDsc:= 1 to len(_aColData)
			if _nPItLin>460
				_lDetPend:=.T.
				exit
			endif
			
			if _aColData[_nSeekCol,3]
				For _nItDsp:=1 to len(_aDespesas)
					if _aDespesas[_nItDsp,9] .and. !_aDespesas[_nItDsp,11]
						if _aColData[_nItDsc,1]==_aDespesas[_nItDsp,1]
							oPrn:Say(_nPItLin,60, dtoc(_aColData[_nItDsc,1]), oFont8)
							
							_nPSZV3:=aScan(_aDadSZ3,{|x| rtrim(x[1]) == RTRIM(_aDespesas[_nItDsp,3])})
							if _nPSZV3>0
								oPrn:Say(_nPItLin,210 , alltrim(str(_nPSZV3))+_aColData[_nItDsc,4], oFont8)
								_aDespesas[_nItDsp,11]:=.T.
							endif
								
							
							oPrn:Say(_nPItLin,260 , _aDespesas[_nItDsp,4], oFont8)
							_nPItLin+=10
						endif
					endif
				Next _nItDsp
			endif
		Next _nItDsc*/
		
			
		/*if aScan(_aDespesas,{|x| x[9] == .F.})==0 .AND. !_lDetPend
			_lPagePend:=.f.
		endif*/
		
			
		oPrn:EndPage()	
		//_nPagePDF++
		
	Next _nImpPap
		
ENDIF
	
/*	
//metodo anterior de impressao 	
IF LEN(_aDespesas)>0
	_aDespesas:=ASORT(_aDespesas,,,{|x,y| x[10] < y[10] })//ordena็ใo por data
		
	For _nJ:=1 to len(_aDespesas)
		if aScan(_aColData,{|x| x[1] == _aDespesas[_nJ,1]})==0 //armazeno posi็ใo de coluna p/ data
			aadd(_aColData,{_aDespesas[_nJ,1],_nColData,.f.,_cDespDig,_aDespesas[_nJ,5],.f.})
		
			_nColData+=50
		
			if len(_aColData)%10==0 //se ้ multiplo das 10 colunas
				_nColData:=260
			endif
		
			_cDespDig:=SOMA1(_cDespDig)
		else
			_aColData[aScan(_aColData,{|x| x[1] == _aDespesas[_nJ,1]}),5]+=	_aDespesas[_nJ,5] //total por data
		endif
	Next
	
		
	_lPagePend:=.t.
		
	if len(_aColData)<=10
		_nTotPagePDF:=1
	elseif len(_aColData)>10 .and. len(_aColData)<=20 
		_nTotPagePDF:=2
	elseif len(_aColData)>20 .and. len(_aColData)<=30
		_nTotPagePDF:=3
	elseif len(_aColData)>30 .and. len(_aColData)<=40
		_nTotPagePDF:=4
	elseif len(_aColData)>40 .and. len(_aColData)<=50
		_nTotPagePDF:=5
	elseif len(_aColData)>50 .and. len(_aColData)<=60
		_nTotPagePDF:=6		
	endif

	_nPagePDF:=1
	_cColDig:="A"
	While _lPagePend
	
		oPrn:StartPage()  
		cBitMap:= "alub_energia.bmp"
		oPrn:SayBitmap( 030, 030,cBitMap, 80, 70 )
		oPrn:line( 100,40,500,40)     // Linha V 1
		oPrn:line( 140,200,250,200)     // Linha V 2
		oPrn:line( 110,250,250,250)     // Linha V 3
		oPrn:line( 300,200,460,200)     // Linha V 2
		oPrn:line( 300,250,460,250)     // Linha V 3
		oPrn:line( 110,300,250,300)     // Linha V 4
		oPrn:line( 100,350,250,350)     // Linha V 5
		oPrn:line( 100,400,250,400)     // Linha V 6
		oPrn:line( 260,400,290,400)     // Linha V 6
		oPrn:line( 100,450,250,450)     // Linha V 7
		oPrn:line( 100,500,250,500)     // Linha V 8
		oPrn:line( 100,550,460,550)     // Linha V 9
		oPrn:line( 100,600,250,600)     // Linha V 10
		oPrn:line( 100,650,250,650)     // Linha V 11
		oPrn:line( 100,700,460,700)     // Linha V 12
		oPrn:line( 110,750,460,750)     // Linha V 13
		oPrn:line( 100,800,500,800)     // Linha V ultima
		 
		
		oPrn:line( 100, 040,100, 800)       // Linha H 1
		oPrn:line( 110, 040,110, 800)       // Linha H 2
		oPrn:line( 120, 250,120, 800)       // Linha H 3 
		oPrn:line( 130, 250,130, 800)       // Linha H 4 
		oPrn:line( 140, 040,140, 800)       // Linha H 5 
		oPrn:line( 150, 200,150, 800)       // Linha H 6 
		oPrn:line( 160, 200,160, 800)       // Linha H 7 
		oPrn:line( 170, 200,170, 800)       // Linha H 8 
		oPrn:line( 180, 200,180, 800)       // Linha H 9
		oPrn:line( 190, 200,190, 800)       // Linha H 10	
		oPrn:line( 200, 200,200, 800)       // Linha H 11
		oPrn:line( 210, 200,210, 800)       // Linha H 12
		oPrn:line( 220, 200,220, 800)       // Linha H 13
		oPrn:line( 230, 200,230, 800)       // Linha H 14
		oPrn:line( 240, 200,240, 800)       // Linha H 15
		oPrn:line( 250, 040,250, 800)       // Linha H 16
		oPrn:line( 260, 550,260, 800)       // Linha H 17
		oPrn:line( 270, 550,270, 800)       // Linha H 18
		oPrn:line( 280, 550,280, 800)       // Linha H 19
		oPrn:line( 290, 040,290, 800)       // Linha H 20
		oPrn:line( 300, 550,300, 800)       // Linha H 21
		oPrn:line( 310, 040,310, 800)       // Linha H 22
		oPrn:line( 320, 040,320, 800)       // Linha H 23
		oPrn:line( 330, 040,330, 800)       // Linha H 24
		oPrn:line( 340, 040,340, 800)       // Linha H 25
		oPrn:line( 350, 040,350, 800)       // Linha H 26
		oPrn:line( 360, 040,360, 800)       // Linha H 27
		oPrn:line( 370, 040,370, 800)       // Linha H 28
		oPrn:line( 380, 040,380, 800)       // Linha H 29
		oPrn:line( 390, 040,390, 800)       // Linha H 30
		oPrn:line( 400, 040,400, 800)       // Linha H 31
		oPrn:line( 410, 040,410, 800)       // Linha H 32
		oPrn:line( 420, 040,420, 800)       // Linha H 33
		oPrn:line( 430, 040,430, 800)       // Linha H 34
		oPrn:line( 440, 040,440, 800)       // Linha H 35
		oPrn:line( 450, 040,450, 800)       // Linha H 35
		oPrn:line( 460, 040,460, 800)       // Linha H 35
		oPrn:line( 480, 200,480, 400)       // Linha H 35			
		oPrn:line( 500, 040,500, 800)       // Linha H ultima
		
		
		oPrn:Say(050, 350, 'RELATORIO DE DESPESAS', oFont)
		oPrn:Say(075, 500, '1)Relat๓rio Depesas Nro '+_cCodPrest, oFont6)
		oPrn:Say(075, 760, Dtoc(dDatabase), oFont6)
		oPrn:Say(108, 750, "Page "+alltrim(str(_nPagePDF)) +" of "+alltrim(str(_nTotPagePDF)), oFont8)//nome
		
		oPrn:Say(128, 42, "Departamento: RAILEC Energia S/A", oFont8)
		
		oPrn:Say(108, 42, _cNomeFor, oFont8)
		
		oPrn:Say(298, 42, "Detalhes por Linha: Incluir nome da pessoa e companhia - Discriminar compra por despesas", oFont8)
		
		oPrn:Say(308, 62, "Data", oFont8)
		oPrn:Say(308, 205, "Item Nr.", oFont8)
		oPrn:Say(308, 350, "Descri็ใo", oFont8)	
		
		//oPrn:Say(268, 402, "Taxa de Conversใo", oFont8) //comentado em 29/09/17		
		
		oPrn:Say(258, 654, "Total:", oFont8)
		
		oPrn:Say(288, 552, "Transporte valor de despesas da pแgina anterior", oFont8)
		oPrn:Say(328, 552, "Transportar", oFont8)
		
		oPrn:Say(308, 760, Transform(_nTotAdto,"@E 999,999,999.99"), oFont8)//09/08/17 
		oPrn:Say(318, 760, Transform(_nTotAdto,"@E 999,999,999.99"), oFont8) 
		
		oPrn:Say(308, 630, "Adiantamentos", oFont8) 
		oPrn:Say(318, 630, "Total Adto.", oFont8) 
		
		
		oPrn:Say(328, 630, " Total Despesas", oFont8)
		oPrn:Say(338, 630, "Valor para RAILEC", oFont8) 
		oPrn:Say(348, 630, "Valor para Empregado", oFont8)
		
		oPrn:Say(378, 552, "DEPำSITO NA CONTA :", oFont8)
		oPrn:Say(388, 552, "Banco: "+posicione("SA2",1,XFILIAL("SA2")+_cFornLoja,"A2_BANCO"), oFont8)
		oPrn:Say(398, 552, posicione("SA2",1,XFILIAL("SA2")+_cFornLoja,"A2_AGENCIA"), oFont8)
		oPrn:Say(408, 552, posicione("SA2",1,XFILIAL("SA2")+_cFornLoja,"A2_NUMCON"), oFont8)
		
		oPrn:Say(138, 752, "Totals", oFont8)
			
		oPrn:Say(478, 150, "    Assinatura:", oFont8)
		oPrn:Say(498, 150, "Data Assinatura:", oFont8)
		oPrn:Say(498, 500, "Data:", oFont8)

		_nCountCol:=1	
		For _nDp:=1 to len(_aDespesas)//imprimo cadastro de despesas
			if !_aDespesas[_nDp,9]
				
				if _nCountCol>10
					exit
				endif
				
				_nSeekCol:=aScan(_aColData,{|x| x[1] == _aDespesas[_nDp,1]})
				if _nSeekCol>0
					if !_aColData[_nSeekCol,3]
						oPrn:Say(138, _aColData[_nSeekCol,2], DTOC(_aDespesas[_nDp,1]), oFont8) //data
						_aColData[_nSeekCol,3]:=.T.
						_nCountCol++
					endif
				endif
				
					
				//procuro posi็ใo de linha no cadastro de despesas
				_nPosseek:=aScan(_aDadSZ3,{|x| rtrim(x[1]) == RTRIM(_aDespesas[_nDp,3])})
				
				if _nPosseek>0
					oPrn:Say(_aDadSZ3[_nPosseek,3], _aColData[_nSeekCol,2], Transform(_aDespesas[_nDp,5],"@E 999,999,999.99"), oFont8) //valor
					_aDadSZ3[_nPosseek,5]+=_aDespesas[_nDp,5]// total por despesa
				endif
				
				_aDespesas[_nDp,9]:=.T.
				
			endif
		Next _nDp
		
		
		//imprimo total por data
		_nColImp:=1
		For _nTDt:= 1 to len(_aColData)
			IF _nColImp>10 //ATE 10 POR PAGINA
				EXIT
			ENDIF
			
			if !_aColData[_nTDt,6]
				oPrn:Say(248, _aColData[_nTDt,2], Transform(_aColData[_nTDt,5],"@E 999,999,999.99"), oFont8) //valor
				_aColData[_nTDt,6]:=.T.
				_nColImp++
			endif				
		Next _nTDt
		
		_nTotGer:=0
		//imprimo total por despesa
		For _nTDP:= 1 to len(_aDadSZ3)
			oPrn:Say(_aDadSZ3[_nTDP,3], 760, Transform(_aDadSZ3[_nTDP,5],"@E 999,999,999.99"), oFont8) //valor
			_nTotGer+=_aDadSZ3[_nTDP,5]
			//_aDadSZ3[_nTDP,5]:=0	//zero para caso tenha mais de uma pagina		
		Next _nTDt
		
		oPrn:Say(258, 760, Transform(_nTotGer,"@E 999,999,999.99"), oFont8)
		oPrn:Say(328, 760, Transform(_nTotGer,"@E 999,999,999.99"), oFont8)
		oPrn:Say(348, 760, Transform(_nTotGer-_nTotAdto,"@E 999,999,999.99"), oFont8)
								
		
		For _nZ:= 1 to len(_aDadSZ3)
			oPrn:Say(_aDadSZ3[_nZ,3], _aDadSZ3[_nZ,4], ALLTRIM(STR(_nZ))+ ') ' +_aDadSZ3[_nZ,2], oFont8)
		Next _nZ
		
		
		if len(_aDadSZ3)>0
			oPrn:Say(_aDadSZ3[len(_aDadSZ3),3]+10, _aDadSZ3[len(_aDadSZ3),4], "Total Despesas", oFont8)
		endif
		
		_nColPos1:=260
		_nColPos2:=270
		
		For _nCol:=1 to 10
			oPrn:Say(118, _nColPos1, "Ver Abaixo", oFont8)
			oPrn:Say(128, _nColPos2, _cColDig, oFont8)
			_nColPos1+=50
			_nColPos2+=50
			_cColDig:=SOMA1(_cColDig)
		Next
		
		//Imprimo descri็ใo por item/data
		_lDetPend:=.f.
		_nPItLin:=318
		For _nItDsc:= 1 to len(_aColData)
			if _nPItLin>460
				_lDetPend:=.T.
				exit
			endif
			
			if _aColData[_nSeekCol,3]
				For _nItDsp:=1 to len(_aDespesas)
					if _aDespesas[_nItDsp,9] .and. !_aDespesas[_nItDsp,11]
						if _aColData[_nItDsc,1]==_aDespesas[_nItDsp,1]
							oPrn:Say(_nPItLin,60, dtoc(_aColData[_nItDsc,1]), oFont8)
							
							_nPSZV3:=aScan(_aDadSZ3,{|x| rtrim(x[1]) == RTRIM(_aDespesas[_nItDsp,3])})
							if _nPSZV3>0
								oPrn:Say(_nPItLin,210 , alltrim(str(_nPSZV3))+_aColData[_nItDsc,4], oFont8)
								_aDespesas[_nItDsp,11]:=.T.
							endif
								
							
							oPrn:Say(_nPItLin,260 , _aDespesas[_nItDsp,4], oFont8)
							_nPItLin+=10
						endif
					endif
				Next _nItDsp
			endif
		Next _nItDsc
		
			
		if aScan(_aDespesas,{|x| x[9] == .F.})==0 .AND. !_lDetPend
			_lPagePend:=.f.
		endif
		
			
		oPrn:EndPage()	
		_nPagePDF++
	ENDDO
		
ENDIF*/
//oPrn:Setup()	
oPrn:Preview()
//Copio arquivo Para pasta no servidor // 10/01/18 - Fabio Yoshioka
if !empty(alltrim(_cIdRel))
	MsgRun("Copiando PDF... Aguarde...",,{||CpyT2S(_cCaminhoPdf+_cRetArqPDF,cPathInServer,.F.)})

	//gravo o nome do arquivo para envio aos aprovadores - 02/08/18 - Fabio Yoshioka
	DBSelectArea("ZV1")
	DBSetOrder(1)
	if DBseek(xFilial("ZV1")+_cCodPrest)
		RecLock("ZV1",.F.)
		ZV1->ZV1_RELPDF:=_cRetArqPDF
		ZV1->(MSUnlock())
	endif

endif

FreeObj(oPrn)
oPrn := Nil

RETURN Nil

		*************************************
Static Function RetAdtPres(_cA2Forn)//09/08/17
	*************************************
	Local _aArea := GetArea()
	Private _aRetSelPA:={}
	Private _aSelPA:={}

	dbSelectArea("SE2")
	DBSETORDER(6)
	DBSEEK(XFILIAL("SE2")+_cA2Forn,.T.)
	WHILE !SE2->(EOF()) .AND. XFILIAL("SE2")==SE2->E2_FILIAL .AND. SE2->E2_FORNECE+SE2->E2_LOJA=_cA2Forn
		IF SE2->E2_SALDO>0 .AND. SE2->E2_TIPO == "PA "

			//If DBSeek(xFilial("ZV1")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+cMatFunc,.F.)
			conout("Retorno ZV1: "+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+cMatFunc)
			if Empty(ALLTRIM(posicione("ZV1",2,xFilial("ZV1")+SE2->E2_PREFIXO+SE2->E2_NUM+PADR(SE2->E2_PARCELA,2)+SE2->E2_TIPO+cMatFunc,"ZV1_COD")))

				aadd(_aSelPA,{SE2->E2_PREFIXO,;
					SE2->E2_NUM,;
					SE2->E2_PARCELA,;
					SE2->E2_TIPO,;
					SE2->E2_EMISSAO,;
					SE2->E2_VALOR,;
					.F.})
			EndIf

		ELSE
			DBSKIP()
			Loop
		ENDIF
		DBSKIP()
	ENDDO

	if len(_aSelPA)>0 //19/04/18
		//alert("1")
		LisPagAnt() //LisPagAnt(_aSelPA)
	endif

//COMENTADO EM 19/04/18 FABIO YOSHIOKA  RETIRADO OBRIGATORIEDADE
/*if len(_aSelPA)>0 //09/08/17
	_nPPA:=0
	WHILE _nPPA==0
		LisPagAnt(_aSelPA)
		_nPPA:=aScan(_aSelPA,{|x| x[7] == .T.})
		IF _nPPA==0
			ALERT("Obrigat๓rio selecionar ao menos um registro!")
		ELSE
			Exit
		ENDIF
	ENDDO
endif*/

RestArea(_aArea)
Return _aRetSelPA

************************************
Static Function LisPagAnt() //28/07/17
************************************
Local oOk, oNo
Local OFONTITE:= TFONT():NEW("COURIER NEW",,-12,,.T.)
Private _OLISPA

oOk := LoadBitmap( GetResources(), "LBOK")
oNo := LoadBitmap( GetResources(), "LBNO")

if len(_aSelPA)>0
            
	@ 000,000 TO 165,590 DIALOG _ODLGPA TITLE OEMTOANSI("Selecione Pagamento Antecipado")   
	_ODLGPA:NCLRPANE := CLR_WHITE - 1    
	@ 000,000 LISTBOX _OLISPA FIELDS HEADER " ","Prefixo","Numero","Parcela","Tipo","Emissao","Valor" FIELDSIZES 5,30,60 SIZE 297,84  
	_OLISPA:SETARRAY(_aSelPA)        
	_OLISPA:BLINE      := {|| {IF(_aSelPA[_OLISPA:NAT,7],oOk,oNo),;
	_aSelPA[_OLISPA:NAT,1],;	
	_aSelPA[_OLISPA:NAT,2],;
	_aSelPA[_OLISPA:NAT,3],;
	_aSelPA[_OLISPA:NAT,4],;	
	_aSelPA[_OLISPA:NAT,5],;
	_aSelPA[_OLISPA:NAT,6]} }
	
	_OLISPA:BLDBLCLICK := {|| SELECTPA(), _OLISPA:DRAWSELECT() }
	_OLISPA:refresh()
            
	_OLISPA:SETFONT(OFONTITE)
	ACTIVATE DIALOG _ODLGPA CENTERED
else
	alert("Nใo hแ dados!")
endif 

RETURN

****************************
Static Function SELECTPA()
****************************
	_aSelPA[_OLISPA:NAT,7]:=!_aSelPA[_OLISPA:NAT,7]
	aadd(_aRetSelPA,{_aSelPA[_OLISPA:NAT,1]+_aSelPA[_OLISPA:NAT,2]+_aSelPA[_OLISPA:NAT,3]+_aSelPA[_OLISPA:NAT,4],_aSelPA[_OLISPA:NAT,6]})
	Close(_ODLGPA)
Return

**************************
User Function VLDCT1CTT()//27/09/17
**************************
Local _lRetCTT:=.T.
lOCAL _nPVLDConta:=aScan(aHeaderEx,{|x| rtrim(x[2]) == "ZV2_CONTA"})//27/09/17
//Local _nPVLDCCusto:=aScan(aHeaderEx,{|x| rtrim(x[2]) == "ZV2_CCUSTO"})

IF _nDigOpca==3 .or. _nDigOpca==4 
	_lRetCTT:= CtbAmarra(oMSNewGe1:aCols[n,_nPVLDConta],M->ZV2_CCUSTO,"" ,"",.T.,.T.,.T.,{})//27/09/17
ENDIF

Return _lRetCTT                                                                                                                   
***************************
User Function EnvWFAPV() //28/12/17
***************************
Local _nAprov

Local _aDadCab    := {}
Local _aDadDet    := {}
Local _lEnvia     := .F.
Local _AreaZV2    := ZV2->(Getarea())
Local _aAnexosZV1 := {}
Local _cChvZV1    := ZV1->ZV1_COD
Local _oOk        := LoadBitmap( GetResources(), "LBOK")
Local _oNo        := LoadBitmap( GetResources(), "LBNO")
//Local _cAprovZV0:="" //18/07/18
Local _nOpcZV5    := 0
Local _cGrvApv    := ""
Private _cIpProd  := GetMV("AL_IPSRVPR")
Private _cIpTest  := GetMV("AL_IPSRVTS")
Private _cModelPA := GetMV("AL_MODWFPA") //08/08/16   
Private _cPrcSrvI := GetMV("AL_PRWFINT") //08/08/16       
Private _cPrcSrvE := GetMV("AL_PRWFEXT") //08/08/16
Private _aParZV0  := {}
Private oLstZV0
Private _aParZV5  := {} //31/07/18  
Private oLstZV5

IF ZV1->ZV1_STATUS='6'
	ALERT("Presta็ใo de Contas jแ foi aprovada e baixada!")
	Return
ENDIF           

_aParZV0:={}
_CPARZV0:=""
DbSelectArea ("ZV0")
ZV0->(DbSetOrder(1))
ZV0->(DBGOTOP())
Do While !ZV0->(EOF()) .and. ZV0->ZV0_FILIAL== xFilial("ZV0") 
	//aadd(_aParZV0,ZV0->ZV0_CODUSR+" - "+RTRIM(ZV0->ZV0_NOME) )
	aadd(_aParZV0,{ZV0->ZV0_CODUSR,RTRIM(ZV0->ZV0_NOME),.F.} )
	ZV0->(DBskip())
EndDo


Define MsDialog _ODLGZV0 Title "Selecione Aprovadores" From 0,0 To 280, 700 Of oMainWnd Pixel

	@ 5,5 LISTBOX oLstZV0 ;
			VAR lVarMat ;
            Fields HEADER " ","Matricula", "Nome" ;
            SIZE 310,130 On DblClick SelZV0() ;
            OF _ODLGZV0 PIXEL 

    oLstZV0:SetArray(_aParZV0)
    oLstZV0:bLine := { || {IIF(_aParZV0[oLstZV0:nAt,3],_oOk,_oNo), _aParZV0[oLstZV0:nAt,1],_aParZV0[oLstZV0:nAt,2]  } }
    oLstZV0:refresh()	

    @ 010,320 bmpbutton type 01 action(_lEnvia := .T., close(_ODLGZV0))
	@ 030,320 bmpbutton type 02 action close(_ODLGZV0)

Activate MSDialog _ODLGZV0 Centered

//@ 002,000 TO 140,310 DIALOG _ODLGZV0 TITLE OEMTOANSI("Selecione Aprovador")  
//	_ODLGZV0:NCLRPANE := CLR_WHITE - 1
//	_OAPROVA   := TCOMBOBOX():NEW(002,002,{|U| IF(PCOUNT()>0,_cParZV0 := U, _cParZV0)}    ,_aParZV0  ,150,010,_ODLGZV0,,,,,,.T.,,,,,,,,,"_cParZV0")
//	@ 030,005 bmpbutton type 01 action(_lEnvia := .T., close(_ODLGZV0))
//	@ 030,040 bmpbutton type 02 action close(_ODLGZV0)
	//ACTIVATE DIALOG _ODLGZV0 CENTERED 

if _lEnvia .and. Ascan(_aParZV0, {|X| X[3]==.T.})==0
	Alert("Obrigat๓rio a sele็ใo de pelo menos um aprovador! ")
Endif

IF _lEnvia

	//sele็ใo do Vistoriador - 31/07/18  - Fabio Yoshioka - Demanda TFS: 3.01.01.04.05
	_aParZV5:={}
	//DbSelectArea("ZV5")
	//ZV5->(DbSetOrder(1))
	//ZV5->(DBGOTOP())
	
	dbSelectArea("ZV5")
	DBSETORDER(2)
	DBSEEK(XFILIAL("ZV5")+'S',.T.)
	Do While !ZV5->(EOF()) .and. ZV5->ZV5_FILIAL== xFilial("ZV5") 
		IF ZV5->(FieldPos("ZV5_ATIVO")) > 0 
			//alert("ATIVO")
			IF UPPER(RTRIM(ZV5->ZV5_ATIVO))=='S'
				//alert("ATIVO S")
				aadd(_aParZV5,{ZV5->ZV5_CODUSR,RTRIM(ZV5->ZV5_NOME),.T.} ) //06/08/18
				EXIT
			ENDIF
		ELSE
			//alert("SEM ATIVO ")
			aadd(_aParZV5,{ZV5->ZV5_CODUSR,RTRIM(ZV5->ZV5_NOME),.F.} )
		ENDIF
		ZV5->(DBskip())
	EndDo
	
	if len(_aParZV5)>0 
		IF ZV5->(FieldPos("ZV5_ATIVO")) > 0
			if Ascan(_aParZV5, {|X| X[3]==.T.})==0
				Alert("Nenhum vistoriador cadastrado ou ATIVO! ")
			endif			
		ELSE
			Define MsDialog _ODLGZV5 Title "Selecione Vistoriadores" From 0,0 To 280, 700 Of oMainWnd Pixel
			
				@ 5,5 LISTBOX oLstZV5 ;
					VAR lVarMat ;
					Fields HEADER " ","Cod Usr", "Nome" ;
					SIZE 310,130 On DblClick SelZV5() ;
					OF _ODLGZV5 PIXEL 
			
					oLstZV5:SetArray(_aParZV5)
					oLstZV5:bLine := { || {IIF(_aParZV5[oLstZV5:nAt,3],_oOk,_oNo), _aParZV5[oLstZV5:nAt,1],_aParZV5[oLstZV5:nAt,2]  } }
					oLstZV5:refresh()	
					
				@ 010,320 bmpbutton type 01 action(_lEnvia := .T., close(_ODLGZV5))
				@ 030,320 bmpbutton type 02 action close(_ODLGZV5)
			
			Activate MSDialog _ODLGZV5 Centered
		ENDIF
	else
		Alert("Nenhum vistoriador cadastrado! ")
	Endif

	_nOpcZV5:=Ascan(_aParZV5, {|X| X[3]==.T.})
	if _nOpcZV5==0
		Alert("Obrigat๓rio a sele็ใo de pelo menos um vistoriador! ")
	else

		//serแ enviado primeiro para o visto - 01/08/18 - Fabio Yoshioka - 3.01.01.04.05 - Implementa็ใo de Rotina de Vistoria
		_aDadCab     := {}
		_aDadDet     := {}
		_aAnexosZV1  := {}
		_cMailAprova := Alltrim(UsrRetMail(_aParZV5[_nOpcZV5,1]))
		conout("_cMailAprova:" + _cMailAprova)

		IF RETCODUSR() $ "000963" //JEAN
			If MsgYesNo("Envia para:" + UsrRetMail(&('RETCODUSR()')) )
				_cMailAprova:= UsrRetMail(&('RETCODUSR()'))
				conout("_cMailAprova alterado para:" + _cMailAprova)
		
			endif
		EndIf	

		IF ISEMAIL(rtrim(_cMailAprova))//01/08/18 - Melhorias Preata็ใo de contas 3.01.01.04 
		
			MsgRun("Anexando PDF... Aguarde...",,{||U_RPrestAP('1')})
	
			aadd(_aDadCab,ZV1->ZV1_COD)
			aadd(_aDadCab,ZV1->ZV1_CODSOL)
			aadd(_aDadCab,ZV1->ZV1_NSOLIC)
			aadd(_aDadCab,ZV1->ZV1_MATRIC)
			aadd(_aDadCab,ZV1->ZV1_NFUNC)
			aadd(_aDadCab,_aParZV5[_nOpcZV5,1])//18/07/18 - Melhorias Preata็ใo de contas 3.01.01.04 
			aadd(_aDadCab,_aParZV5[_nOpcZV5,2])
			aadd(_aDadCab,Dtoc(ZV1->ZV1_DTVENC))//17/07/18 - Melhorias Preata็ใo de contas 3.01.01.04 
			aadd(_aDadCab,_cMailAprova)//18/07/18 - Melhorias Preata็ใo de contas 3.01.01.04 

			DBSelectArea("ZV2")
			DBSetOrder(3)
			DBseek(xFilial("ZV2")+ZV1->ZV1_COD)
			Do While !ZV2->(EOF()) .and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA+ZV2_SEQ == xFilial("ZV2")+ZV1->ZV1_COD+ZV1->ZV1_SEQ 
				//AADD(_aDadDet,{ZV2->ZV2_DATA,ZV2->ZV2_CODIGO,ZV2->ZV2_DESCRI,ZV2->ZV2_VALOR,ZV2->ZV2_COMPLE})
				AADD(_aDadDet,{ZV2->ZV2_DATA,ZV2->ZV2_CODIGO,ZV2->ZV2_DESCRI,ZV2->ZV2_VALOR,ZV2->ZV2_COMPLE,ZV2->ZV2_CCUSTO,ZV2->ZV2_DEDZIR}) //10/12/18 - Solicita็ao de inclusao de novas COlunas no WF - Fabio Yoshioka
			
				ZV2->(DBskip())
			EndDo

			//adciono anexos (BASE DO CONHECIMENTO)
			DBSelectArea("AC9")
			DBGotop()
			AC9->(DBSetOrder(2))//AC9_FILIAL + AC9_ENTIDA + AC9_FILENT + AC9_CODENT + AC9_CODOBJ                                                                                                          
			//AC9->(DBseek(xFilial("AC9")+"ZV1"+XFILIAL("ZV1")+XFILIAL("ZV1")+PADR(_cChvZV1,TamSx3("AC9_CODENT")[1])+"0000000000" ))
			AC9->(DBseek(xFilial("AC9") + "ZV1" + XFILIAL("ZV1") + ALLTRIM(_cChvZV1) ))
			Do While !AC9->(EOF()) .AND. AC9->AC9_FILENT+alltrim(AC9->AC9_CODENT) == xFilial("ZV1")+ALLTRIM(_cChvZV1) 
				if rtrim(AC9->AC9_ENTIDA)=='ZV1' 
					_cArqZV1:=POSICIONE("ACB",1,XFILIAL("ACB")+AC9->AC9_CODOBJ,"ACB_OBJETO")
					if !empty(alltrim(_cArqZV1))
						AADD(_aAnexosZV1,_cArqZV1) //ACB_FILIAL, ACB_CODOBJ, R_E_C_N_O_, D_E_L_E_T_
					endif
				endif
				AC9->(DBskip())
			EndDo
			
			IF LEN(_aDadCab)>0 .AND. LEN(_aDadDet)>0
				U_WFVisPre(_aDadCab,_aDadDet,_aAnexosZV1)
			ENDIF
			
			//gravo aprovadores selecionados
			For _nAprov:=1 to len(_aParZV0)
				if _aParZV0[_nAprov,3] //Marcados
					_cGrvApv+=_aParZV0[_nAprov,1]+"|"
				endif
			Next _nAprov
			
			if !empty(alltrim(_cGrvApv))
				RecLock("ZV1",.F.)
				ZV1->ZV1_MATAPV:= _cGrvApv
				ZV1->ZV1_VISTO1:=_aParZV5[_nOpcZV5,1]//gravo vistoriador
				ZV1->ZV1_NVIST1:=_aParZV5[_nOpcZV5,2]
				ZV1->(MSUnlock())
			endif
			
		ELSE
			ALERT("E-mail nao cadastrado ou invแlido!")
			conout("E-mail nao cadastrado ou invแlido!")
		ENDIF

/*		For _nAprov:=1 to len(_aParZV0)
			_aDadCab:={}//18/07/18 - Melhorias Preata็ใo de contas 3.01.01.04 
			_aDadDet:={}
			_aAnexosZV1:={}
			_cMailAprova:=POSICIONE("SRA",1,XFILIAL("SRA")+_aParZV0[_nAprov,1],"RA_EMAIL")
			
			if _aParZV0[_nAprov,3] //Marcados
				
				IF ISEMAIL(rtrim(_cMailAprova))//18/07/18 - Melhorias Preata็ใo de contas 3.01.01.04 
				
					MsgRun("Anexando PDF... Aguarde...",,{||U_RPrestAP('1')})
			
					aadd(_aDadCab,ZV1->ZV1_COD)
					aadd(_aDadCab,ZV1->ZV1_CODSOL)
					aadd(_aDadCab,ZV1->ZV1_NSOLIC)
					aadd(_aDadCab,ZV1->ZV1_MATRIC)
					aadd(_aDadCab,ZV1->ZV1_NFUNC)
					aadd(_aDadCab,_aParZV0[_nAprov,1])//18/07/18 - Melhorias Preata็ใo de contas 3.01.01.04 
					aadd(_aDadCab,_aParZV0[_nAprov,2])
					aadd(_aDadCab,Dtoc(ZV1->ZV1_DTVENC))//17/07/18 - Melhorias Preata็ใo de contas 3.01.01.04 
					aadd(_aDadCab,_cMailAprova)//18/07/18 - Melhorias Preata็ใo de contas 3.01.01.04 
					
					
					DBSelectArea("ZV2")
					DBSetOrder(3)
					DBseek(xFilial("ZV2")+ZV1->ZV1_COD)
					Do While !ZV2->(EOF()) .and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA+ZV2_SEQ == xFilial("ZV2")+ZV1->ZV1_COD+ZV1->ZV1_SEQ 
						//AADD(_aDadDet,{ZV2->ZV2_DATA,ZV2->ZV2_CODIGO,ZV2->ZV2_DESCRI,ZV2->ZV2_VALOR,ZV2->ZV2_COMPLE})
                        AADD(_aDadDet,{ZV2->ZV2_DATA,ZV2->ZV2_CODIGO,ZV2->ZV2_DESCRI,ZV2->ZV2_VALOR,ZV2->ZV2_COMPLE,ZV2->ZV2_CCUSTO,ZV2->ZV2_DEDZIR}) //10/12/18 - Solicita็ao de inclusao de novas COlunas no WF - Fabio Yoshioka
						ZV2->(DBskip())
					EndDo
					
					
					//adciono anexos (BASE DO CONHECIMENTO)
					DBSelectArea("AC9")
					AC9->(DBSetOrder(2))//AC9_FILIAL, AC9_ENTIDA, AC9_FILENT, AC9_CODENT, AC9_CODOBJ
					AC9->(DBseek(xFilial("AC9")+"ZV1"+XFILIAL("ZV1")+PADR(_cChvZV1,TamSx3("AC9_CODENT")[1]) ))
					Do While !AC9->(EOF()) .AND. AC9->AC9_FILENT+AC9->AC9_CODENT == xFilial("ZV1")+PADR(_cChvZV1,TamSx3("AC9_CODENT")[1]) 
						if rtrim(AC9->AC9_ENTIDA)=='ZV1' 
							_cArqZV1:=POSICIONE("ACB",1,XFILIAL("ACB")+AC9->AC9_CODOBJ,"ACB_OBJETO")
							if !empty(alltrim(_cArqZV1))
								AADD(_aAnexosZV1,_cArqZV1) //ACB_FILIAL, ACB_CODOBJ, R_E_C_N_O_, D_E_L_E_T_
							endif
						endif
						AC9->(DBskip())
					EndDo
					
					
					IF LEN(_aDadCab)>0 .AND. LEN(_aDadDet)>0
						U_WFAprPre(_aDadCab,_aDadDet,_aAnexosZV1)
					ENDIF
				ELSE
					ALERT("E-mail nao cadastrado ou invแlido!")
				ENDIF
			Endif
		NEXT _nAprov
		*/
		Endif
	ENDIF

	RestArea(_AreaZV2)

Return

	*************************************************
User Function WFAprPre(_aDadZV1,_aDadZV2,_aAtach)//28/12/17 - WF enviado para aprova็ใo da presta็ใo de contas
	*************************************************
	Local _nIWf, _nAtach
	Local cCodProcesso,  cHtmlModelo, oHtml, oProcess //cCodStatus,
	Local  cAssunto //cCodProduto,cUsuarioProtheus, cTexto,
	//Local cDadoTit
	//Local lBaseProd := IIf(GetEnvServer() $ 'PROTHEUS12_AE#WORFLOW_DEV', .T.,.F.)
	//Local lBaseProd := IIf(Alltrim(GetEnvServer()) == 'PROTHEUS12_AE', .T.,.F.)
	Local lOk           := .F.
	Local _nTotPre      := 0
	Local _cDirDocs     := MsDocPath() // Getmv("AL_DIRDOCS")
	local cPathInServer := GetMv( 'AL_DIRPDFS' ) //02/01/17

	_cTitulo:="PRESTACAO DE CONTAS"
	cCodProcesso := "WF_106"
	cHtmlModelo :=rtrim(_cModelPA)+"Aut_Presta_Page.html"
	cAssunto := "Aprova็ใo de Presta็ใo de Contas"

	oProcess:= TWFProcess():New(cCodProcesso, cAssunto)
	cTitulo :=  "WF_106"
	oProcess:NewTask(cTitulo, cHtmlModelo)
	oHtml	:= oProcess:oHTML

//Dados do Cabe็alho
	oProcess:oHtml:ValByName( "cEmissao" 	,DTOC(dDataBase))
	oProcess:oHtml:ValByName( "cHora" 		,SUBSTR(Time(),1,5))
	oProcess:oHtml:ValByName( "cTitPREST" 	,		 _aDadZV1[1]) //14/09/16
	oProcess:oHtml:ValByName( "cCodSol" 	,		 _aDadZV1[2])
	oProcess:oHtml:ValByName( "cSolicit" 	,Alltrim(_aDadZV1[3]))
	oProcess:oHtml:ValByName( "cCodFavor" 	,Alltrim(_aDadZV1[4]))
	oProcess:oHtml:ValByName( "cFavorecido" ,Alltrim(_aDadZV1[5]))
	oProcess:oHtml:ValByName( "cCodAprov" 	,Alltrim(_aDadZV1[6]))
	oProcess:oHtml:ValByName( "cAprovador"  ,Alltrim(_aDadZV1[7]))
	oProcess:oHtml:ValByName( "cDatVencto"  ,Alltrim(_aDadZV1[8])) //17/07/18 - Melhorias Presta็ใo de Contas - 3.01.01.04

	if len(_aDadZV2)>0
		_nTotPre:=0

		For _nIWf:=1 to len(_aDadZV2)
			AAdd( ( oHtml:ValByName( "it.data" 		)), dtoc(_aDadZV2[_nIWf,1]) )
			AAdd( ( oHtml:ValByName( "it.codDesp" 	)), _aDadZV2[_nIWf,2] )
			AAdd( ( oHtml:ValByName( "it.Descri"	)), _aDadZV2[_nIWf,3] )
			AAdd( ( oHtml:ValByName( "it.valor" 	)), Transform( _aDadZV2[_nIWf,4] ,'@E 999,999,999.99' ))
			AAdd( ( oHtml:ValByName( "it.complem" 	)), _aDadZV2[_nIWf,5] )
			//Inclusao de NOvas Colunas no WF - 10/12/18 - Fabio Yoshioka
			AAdd( ( oHtml:ValByName( "it.ccusto" 	)), _aDadZV2[_nIWf,6] )//Novas Colunas CCusto
			AAdd( ( oHtml:ValByName( "it.deduzIR" 	)), IIf( uPPER(RTRIM(_aDadZV2[_nIWf,7]))=='S','SIM','NAO') )//Novas Colunas Deduz IR

			IF upper(rtrim(POSICIONE("ZV3",1,XFILIAL("ZV3")+_aDadZV2[_nIWf,2],"ZV3_TIPO")))=='A' //ABATIMENTOS
				_nTotPre-=_aDadZV2[_nIWf,4]
			ELSE
				_nTotPre+=_aDadZV2[_nIWf,4]
			ENDIF

		Next _nIWf
	ENDIF

	oProcess:oHtml:ValByName( "cTotalVlr"  ,Transform(_nTotPre ,'@E 999,999,999.99' ))

//Fun็ใo de retorno a ser executada quando a mensagem de respostas retornar ao Workflow:
	oProcess:bReturn :=  "U_RetWFPR()"

	*********************************************
//Guardo o ID do Processo para enviar no link
	*********************************************
	cMailID := oProcess:Start()
	******************
//Enviando o Link!
	******************
	oHtml:SaveFile("web\ws\wflow"+"\"+cMailID+".HTM")     		//Salvo HTML do Processo
	cRet := WFLoadFile("web\ws\wflow"+"\"+cMailID+".HTM")		//Carrego o link do Processo (serแ usado no retorno da Aprova็ใo)

	_cTitulo:="PRESTACAO DE CONTAS"

	cAssunto := "Aprova็ใo de PRESTACAO DE CONTAS"
	cHtmlModelo :=rtrim(_cModelPA)+"Aut_Prest_Link.html"

//Inicio nova tarefa do Processo... O Link.
	oProcess:NewTask(cAssunto, cHtmlModelo)

//Dados do Cabe็alho
	oProcess:oHtml:ValByName( "cTitPREST" ,_aDadZV1[1]) //14/09/16
	oProcess:oHtml:ValByName( "cEmissao" ,DTOC(dDataBase))
	oProcess:oHtml:ValByName( "cHora" ,SUBSTR(Time(),1,5))
	oProcess:oHtml:ValByName( "cSolicit" ,Alltrim(_aDadZV1[3]))
	oProcess:oHtml:ValByName( "cCodSol" ,_aDadZV1[2])
	oProcess:oHtml:ValByName( "cAprovador" ,Alltrim(_aDadZV1[7]))
	oProcess:oHtml:ValByName( "cCodAprov" ,_aDadZV1[6] )
	oProcess:oHtml:ValByName( "cNomeFor" ,Alltrim(_aDadZV1[5]))
	oProcess:oHtml:ValByName( "cDtEmiss" ,DTOC(dDataBase))
	oProcess:oHtml:ValByName( "cValor" ,Transform(_nTotPre,"@E 999,999,999.99"))

//Revisao do Workflow
	_cIpTest:=GetNewPar("AL_IPSRVTS","181.41.169.147")
	lServProd := IIf(GetEnvServer() $ 'PROTHEUS12_AE#WORKFLOW', .T.,.F.)

	cServerIni := GetAdv97()
	cSecao := "SRVWFLOW"
	cPadrao := "undefined"
	cIPLan := GetPvProfString(cSecao, "IPWFLAN", cPadrao, cServerIni)
	cPtLan := GetPvProfString(cSecao, "PTWFLAN", cPadrao, cServerIni)
	cIPWeb := GetPvProfString(cSecao, "IPWFWEB", cPadrao, cServerIni)
	cPtWeb := GetPvProfString(cSecao, "PTWFWEB", cPadrao, cServerIni)

	If lServProd //Servidor Produ็ใo

		conout("1 - RAILEC LINK Para Autoriza็ใo de Presta็ใo de contas "+DTOC(dDataBase) +" para " + Alltrim(_aDadZV1[9]) + Alltrim(_aDadZV1[6]))
		oProcess:ohtml:ValByName("proc_localink",RTRIM(_cPrcSrvI)+cMailID+".htm")
		oProcess:ohtml:ValByName("proc_weblink",RTRIM(_cPrcSrvE)+cMailID+".htm")
		oProcess:cSubject := "RAILEC LINK Para Autoriza็ใo de Presta็ใo de contas "+DTOC(dDataBase)
		//oProcess:cTo := Alltrim(UsrRetMail(Alltrim(_aDadZV1[6])))+";"+Alltrim(&('GetMv("AL_MAILADM")'))
		oProcess:cTo := Alltrim(_aDadZV1[9])+";"+Alltrim(&('GetMv("AL_MAILADM")'))
		cEndPage := RTRIM(_cPrcSrvI)+cMailID+".htm"

	Else //Servidor Base_teste
		conout("1 - TESTE RAILEC LINK Para Autoriza็ใo de Presta็ใo de contas "+DTOC(dDataBase) +" para " + Alltrim(_aDadZV1[9]) + Alltrim(_aDadZV1[6]))
		oProcess:ohtml:ValByName("proc_localink",RTRIM("http://"+_cIpTest+":8800/web/ws/wflow/")+cMailID+".htm")
		oProcess:ohtml:ValByName("proc_weblink",RTRIM("http://"+_cIpTest+":8800/web/ws/wflow/")+cMailID+".htm")
		oProcess:cSubject := "TESTE - RAILEC LINK Para Autoriza็ใo de Presta็ใo de contas "+DTOC(dDataBase)
		//oProcess:cTo := Alltrim(UsrRetMail(Alltrim(_aDadZV1[6])))+";"+Alltrim(&('GetMv("AL_MAILADM")'))
		oProcess:cTo := Alltrim(&('GetMv("AL_MAILADM")'))
		cEndPage := RTRIM("http://"+_cIpTest+":8800/web/ws/wflow/")+cMailID+".htm"

	EndIf

//ANEXOS
	if len(_aAtach)>0
		For _nAtach :=1 to  len(_aAtach)
			//If File(rtrim(_cDirDocs)+'\'+ rtrim(_aAtach[_nAtach]))
			_cFileAtach:=rtrim(_cDirDocs)+'\'+ rtrim(_aAtach[_nAtach])
			conout(_cFileAtach)
			oProcess:AttachFile(_cFileAtach)
			//endif
		Next _nAtach
	endif

	_cRetArqPDF:="" //02/08/18
	DBSelectArea("ZV1")
	DBSetOrder(1)
	if DBseek(xFilial("ZV1")+_aDadZV1[1])
		_cRetArqPDF:=ZV1->ZV1_RELPDF
	endif

	if !empty(alltrim(_cRetArqPDF)) //ANEXO O RELATORIO PDF
		oProcess:AttachFile(rtrim(cPathInServer)+alltrim(_cRetArqPDF))
	endif
//oProcess:AttachFile("\RELATO\pcor045.XML")
	oProcess:Start() 	//Inicia o processo...
	oProcess:Finish()  //...e em seguida finaliza
//oProcess:Start()                         
//Se rodou at้ aqui...
	lOk := .T.
//MSGINFO("E-mail enviado para o aprovador da Presta็ใo de contas!","Presta็ใo")
Return(lOk)

	*********************************
User Function RetWFPR(oProcess) //processo de retorno - apos confirma็ใo ou rejei็ใo pelo aprovador da Presta็ใo de contas
	*********************************

	//Local oHtml 		:= oProcess:oHtml
	Local cChave 		:= oProcess:oHtml:RetByName("cTitPREST")
	Local lYESNO		:= IIF(oProcess:oHtml:RetByName("RBAPROVA") = "Sim",.T.,.F.)
	Local cCodAprov		:= oProcess:oHtml:RetByName("cCodAprov")
	Local cCodSolic		:= oProcess:oHtml:RetByName("cCodSol")
	Local cMotivo		:= oProcess:oHtml:RetByName("LBMOTIVO")
	Local cMatFunc		:= oProcess:oHtml:RetByName("cCodFavor")
	Local cNomFavo		:= oProcess:oHtml:RetByName("cFavorecido") //23/01/18
	Local _cDatVencto	:= oProcess:oHtml:RetByName("cDatVencto") //17/07/18 - Fabio Yoshioka -  Melhorias Rotina Presta็ใo de Contas - 3.01.01.04
	//Local aChave := {}
	//Local _lTemSe2:=.F.
	Local _aArea := GetArea()
	//Local _aTitulo := {}
	Local _cTipoGrv     := "CH"
	Local _cNatuGrv     := GETMV("AL_NATRPRC") // "Z0503"
	Local _cPrefGrv     := GETMV("AL_PRFRPRC") //PREFIXO
	lOCAL _nAbatm       := 0
	Local _nTotRet      := 0
	Local _cCustPresta  := ""
	Local _cDestNotf    := "" //23/01/18
	Local _cVistNotf    := "" //E-mail do Vistoriador 06/08/18
	Local _nQtCtbPC     := 0 //30/09/18
	Local _cDestPrb     := _cCabPrb:=_cTextoPrb:=_cCodVistor:="" //22/11/18
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .F.
	Private _nTotForn   := 0
	Private _cCodForSE2 := ""
	Private _cContaForn := ""
	Private nTotal      := 0
	private nHdlPrv     := 0
	private cLoteEst    := "008850"
	private cArquivo    := ''
	private lCriaHeade  := .T.

	Conout("RetWFPR: " +cChave)

	//Posiciono na ZV1
	DBSelectArea("ZV1")
	DBSetOrder(1)
	If DBSeek(xFilial("ZV1")+cChave,.F.)

		//if (ZV1->ZV1_STATUS=='6' .and. !empty(ZV1->ZV1_DTAPR1)) .or. ZV1->ZV1_STATUS=='9'
		conout("Data_RetWFPR: "+cChave+"-"+dtoc(ZV1->ZV1_DTAPR1))
		if !empty(ZV1->ZV1_DTAPR1)
			Conout("RetWFPR: " +cChave+" ja Aprovada/Rejeitada anteriormente")//18/07/18
		else

			_cVistNotf:=Alltrim(UsrRetMail(ZV1->ZV1_VISTO1)) //06/08/18 - email para Usuario que fez o Visto

			DBSelectArea("ZV2")
			DBSetOrder(3)
			DBseek(xFilial("ZV2")+ZV1->ZV1_COD)
			Do While !EOF() .and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA+ZV2_SEQ == xFilial("ZV2")+ZV1->ZV1_COD+ZV1->ZV1_SEQ
				IF EMPTY(ALLTRIM(_cCustPresta))
					_cCustPresta:=ZV2->ZV2_CCUSTO
				ENDIF

				IF upper(rtrim(POSICIONE("ZV3",1,XFILIAL("ZV3")+ZV2->ZV2_CODIGO,"ZV3_TIPO")))=='A' //ABATIMENTOS
					_nAbatm += ZV2->ZV2_VALOR
				ELSE
					_nTotRet += ZV2->ZV2_VALOR
				ENDIF

				ZV2->(DBskip())
			EndDo

			//_cDestNotf:=Alltrim(UsrRetMail(cCodAprov))+";"+Alltrim(UsrRetMail(cCodSolic))
			//_cDestNotf:=Alltrim(posicione("SRA",1,XFILIAL("SRA")+cCodAprov,"RA_EMAIL"))+";"+Alltrim(UsrRetMail(cCodSolic)) //18/07/18
			_cDestNotf:=Alltrim(UsrRetMail(cCodSolic)) //06/08/18 -

			If lYESNO //aprova็ใo via wf

				_cCodVistor:=ZV1->ZV1_VISTO1 //22/11/18

				if _nTotRet>0

					IF dDatabase<=ZV1->ZV1_DTVENC //22/11/18 - Fabio Yoshioka - Melhoria Presta็ใo de contas - Notificar
		/*
				
					//Desabilitando a visualiza็ใo do Lan็amento Contab.
					DBSELECTAREA("SX1")
					DBSetOrder(1)
					DBSeek("FIN050    "+"01")
					RecLock("SX1",.F.)
					 (cAliasTmp)->(X1_PRESEL) := 2 //Mostra Lancto = Nใo
					MSUnlock()	

					DBSeek("FIN050    "+"04")
					RecLock("SX1",.F.)
					 (cAliasTmp)->(X1_PRESEL) := 2 //Contabiliza on Line = NAO         
					MSUnlock()	
					
					DBSeek("FIN050    "+"05")
					RecLock("SX1",.F.)
					 (cAliasTmp)->(X1_PRESEL) := 2 //Gerar Chq.p/Adiant. = NAO                  
					MSUnlock()	

					DBSeek("FIN050    "+"09")
					RecLock("SX1",.F.)
					 (cAliasTmp)->(X1_PRESEL) := 2 //Mov.Banc.sem Cheque = NAO              
					MSUnlock()	
		/*/
					contadeb :=  POSICIONE("ZV2",1,xFilial("ZV2") + ZV1->ZV1_COD ,"ZV2_CONTA")
					aTitulo :={{"E2_FILIAL",xFilial("SE2") ,Nil},;
								{"E2_PREFIXO"                    , _cPrefGrv                    , Nil},;
								{"E2_NUM"                        , cChave                       , Nil},;
								{"E2_PARCELA"                    , "1"                          , Nil},;
								{"E2_TIPO"                       , _cTipoGrv                    , Nil},;
								{"E2_NATUREZ"                    , _cNatuGrv                    , Nil},;
								{"E2_FORNECE"                    , SUBSTR(cMatFunc,1,6)         , Nil},;
								{"E2_LOJA"                       , SUBSTR(cMatFunc,7,2)         , Nil},;
								{"E2_EMISSAO"                    , dDataBase                    , NIL},;
								{"E2_VENCTO"                     , ctod(_cDatVencto)            , NIL},;
								{"E2_VENCREA"                    , ctod(_cDatVencto)            , NIL},;
								{"E2_VALOR"                      , _nTotRet-_nAbatm             , Nil},;
								{"E2_VLCRUZ"                     , _nTotRet-_nAbatm             , Nil},;
								{"E2_CC"                         , _cCustPresta                 , Nil},; //custo gravado no SE2
								{"E2_HIST"                       , "Reemb Desp "+rtrim(cNomFavo), Nil},;
								{"E2_CTADEBD"                    , contadeb                     , Nil}} //historico no Titulo

			        //_cNumGrvSE2:="RDP"+_cCodPresta+"1"+_cTipoGrv+cMatFunc
			
					*****************************	
					//Inicio a inclusใo do titulo
					*****************************	
					lMsErroAuto := .F.
					MSExecAuto({|x,y,z| Fina050(x,y,z)},aTitulo,,3) //Inclusao  
					//////
					/*
					RECLOCK("SE2",.T.)
					E2_FILIAL  := xFilial("SE2")
					E2_PREFIXO := _cPrefGrv
					E2_NUM     := cChave
					E2_TIPO    := _cTipoGrv
					E2_VALOR   := _nTotRet-_nAbatm
					E2_VENCTO  := ctod(_cDatVencto)
					E2_VENCREA := ctod(_cDatVencto)
					E2_EMISSAO := dDATABASE
					E2_HIST    := "Reemb Desp "+rtrim(cNomFavo)
					E2_EMIS1   := DDATABASE
					E2_SALDO   := _nTotRet-_nAbatm
					E2_VENCORI := ctod(_cDatVencto)
					E2_MOEDA   := 1
					E2_FORNECE := SUBSTR(cMatFunc,1,6)
					E2_LOJA    := SUBSTR(cMatFunc,7,2)
					E2_VLCRUZ  := _nTotRet-_nAbatm
					E2_ORIGEM  := "CADZV1"
					E2_CTADEBD := contadeb
					E2_NATUREZ := _cNatuGrv
					E2_CC := _cCustPresta
					MSUNLOCK()
					*/
						///////

						If lMsErroAuto
							//MostraErro()
							_cErro:=NomeAutoLog()
							conout(_cErro)
							ConOut("RetWFPR: CHAVE" +cChave+" Erro na INCLUSAO SE2:" + _cErro)

						ELSE
							_nTotForn:=0
							DBSelectArea("ZV1")
							DBSetOrder(1)
							if DBseek(xFilial("ZV1")+cChave)
								RecLock("ZV1",.F.)
								ZV1->ZV1_APROV1:=cCodAprov
								ZV1->ZV1_NAPRO1:=Alltrim(posicione("SRA",1,XFILIAL("SRA")+cCodAprov,"RA_NOME"))
								ZV1->ZV1_STATUS:='6'
								ZV1->ZV1_DTAPR1:= date()
								ZV1->ZV1_HRAPR1:= Substr(Time(),1,5)
								_nTotForn:=ZV1->ZV1_TOTRET-ZV1->ZV1_ABATM
								_cCodForSE2:=ZV1->ZV1_MATRIC
								ZV1->(MSUnlock())
							endif

							IF _nTotForn>0
								lDigita    := .T.
								lAglutina  := .T.
								nHdlPrv := HeadProva(cLoteEst,"CADZV1",Subs(cUsuario,7,6),@cArquivo)

								DBSelectArea("ZV2") //contabilizo a inclusao - 02/08/17
								DBSetOrder(3)
								DBseek(xFilial("ZV2")+cChave)
								Do While !EOF() .and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA == xFilial("ZV2")+cChave
									IF _nQtCtbPC>0
										conout(dtoc(Date())+"-"+Time()+" Valor Ant: "+alltrim(str(_nTotForn)))
										_nTotForn:=0 //Nใo gerar valor duplicado na contabiliza็ใo - 30/09/18
									ENDIF

									IF RTRIM(POSICIONE("ZV3",1,XFILIAL("ZV3")+RTRIM(ZV2->ZV2_CODIGO),"ZV3_TIPO"))=='A'
										ZV2->(DBSKIP())
										Loop
									ENDIF

									nTotal += DetProva(nHdlPrv,"P51","CADZV1",cLoteEst)
									_nQtCtbPC++
									ZV2->(DBSKIP())
								EndDo

								RodaProva(nHdlPrv,nTotal)
								cA100Incl(cArquivo,nHdlPrv,3,cLoteEst,lDigita,lAglutina)

							ENDIF

						EndIf
		/*
		
					//Reabilitando a visualiza็ใo do Lan็amento Contab.
					DBSELECTAREA("SX1")
					DBSetOrder(1)
					DBSeek("FIN050    "+"01")
					RecLock("SX1",.F.)
					 (cAliasTmp)->(X1_PRESEL) := 1 //Mostra Lancto = SIM
					MSUnlock()	

					DBSeek("FIN050    "+"04")
					RecLock("SX1",.F.)
					 (cAliasTmp)->(X1_PRESEL) := 1 //Contabiliza on Line = SIM         
					MSUnlock()	
					
					DBSeek("FIN050    "+"05")
					RecLock("SX1",.F.)
					 (cAliasTmp)->(X1_PRESEL) := 1 //Gerar Chq.p/Adiant. = SIM                  
					MSUnlock()	

					DBSeek("FIN050    "+"09")
					RecLock("SX1",.F.)
					 (cAliasTmp)->(X1_PRESEL) := 1 //Mov.Banc.sem Cheque = SIM              
					MSUnlock()	
		/*/
				
				ELSE
					//Notifico casos em que nใo foi possivel aprovar - 22/11/18
					_cDestPrb:=Alltrim(UsrRetMail(cCodSolic))+";"+Alltrim(UsrRetMail(_cCodVistor))+";"+Alltrim(U_RetDadSRA(cCodAprov,"RA_EMAIL"))
					
					_cCabPrb  :=" PROBLEMAS NA APROVAวรO DA PRESTAวรO DE CONTAS"
					_cTextoPrb:=" A presta็ใo de contas nใo foi aprovada pelo Motivo: DATA DE VENCIMENTO INVมLIDA("+DTOC(ZV1->ZV1_DTVENC)+")"					  
					NOTFPRB(cChave,_nTotRet,_cDestPrb,_cCabPrb,_cTextoPrb)
					lMsErroAuto:=.T.
					
				ENDIF
			ENDIF
				
		ELSE
			Conout("RetWFPR: CHAVE" +cChave+" REJEITADO PELO APROVADOR")
			DBSelectArea("ZV1")
			DBSetOrder(1)
			if DBseek(xFilial("ZV1")+cChave) //23/01/18 - status reprovado
				RecLock("ZV1",.F.)
				ZV1->ZV1_APROV1:=cCodAprov
				ZV1->ZV1_NAPRO1:=Alltrim(posicione("SRA",1,XFILIAL("SRA")+cCodAprov,"RA_NOME"))
				ZV1->ZV1_STATUS:='9'
				ZV1->ZV1_MOTREJ:=cMotivo
				ZV1->ZV1_DTAPR1:= date()
				ZV1->ZV1_HRAPR1:= Substr(Time(),1,5)
				ZV1->(MSUnlock())
			endif		
		ENDIF
		
		//ZV1YESNO(cChave,_nTotRet,_cDestNotf,lYESNO) //23/01/18 - Envio Notifica็๕es de aprova็ใo da presta็ใo
		IF (!lMsErroAuto .AND. lYESNO)  .OR. !lYESNO
			ZV1YESNO(cChave,_nTotRet,iif(lYESNO,_cDestNotf,_cVistNotf+";"+_cDestNotf),lYESNO,'A') //06/08/18 - Envio tamb้m ao Vistoriador caso negada a aprova็ใo
		ENDIF
		
	Endif
else
	Conout("RetWFPR: CHAVE" +cChave+" NAO ENCONTRAVA NO ZV1")
endif

RestArea(_aArea)

Conout("Fim da Rotina RetWFPR "+cChave)

Return()

**********************
User Function CadZV0() //Cadastro de aprovadores da presta็ใo de contas - 29/12/17 - Fabio Yoshioka
**********************
	dbSelectArea("ZV0")
	dbGoTop()	
	axCadastro("ZV0","Cad.Aprovadores de Ptesta็ใo de contas",".T.",".T.")  
Return


**********************
User Function CadZV5() //Cadastro de Vistoriadores da presta็ใo de contas - 31/07/18 - Fabio Yoshioka - Projeto 3.01.01.04.05
**********************
	dbSelectArea("ZV5")
	dbGoTop()	
	axCadastro("ZV5","Cad.Vistoriadores de Ptesta็ใo de contas",".T.",".T.")  
Return

*************************************************
//Static Function ZV1YESNO(cChaveZV1,_nValZV1,cDestinat,lYesNo) //23/01/18 - Enviar Notifica็๕es ao solicitante e Aprovador
Static Function ZV1YESNO(cChaveZV1,_nValZV1,cDestinat,lYesNo,_cTipo) //06/08/18 - Incluido Notifica็๕es de Visto
*************************************************

Local cCodProcesso,  cHtmlModelo, oHtml, oProcess //cCodStatus,cCodProduto,cUsuarioProtheus,
Local cTexto, cAssunto 
Local cDadoTit 
//Local lBaseProd := IIf(GetServerIP() == '181.41.169.77', .T.,.F.)
//Local lBaseProd := IIf(Alltrim(GetEnvServer()) == 'PROTHEUS12_AE', .T.,.F.)
//Local lOk := .F.
Private _cModelPA:=GetMV("AL_MODWFPA")//08/08/16 \workflow\WFEnergia\Financeiro\                                                                                                                                                                                                                           

If lYesNo 
	if _cTipo=='V'//visto
		cCabec := "VISTORIA DE PRESTAวรO DE CONTAS "
		cTexto := "Informados que a Presta็ใo de Contas conforme os dados abaixo, foi Vistada e enviada para Aprova็ใo."
	else
		cCabec := "APROVAวรO DE PRESTAวรO DE CONTAS "
		cTexto := "Informados que a Presta็ใo de Contas conforme os dados abaixo, foi aprovada e incluํdo no Contas a Pagar."
	endif
Else
	if _cTipo=='V'//visto
		cCabec := "REJEIวรO EM VISTORIA DE PRESTAวรO DE CONTAS"
		cTexto := "Informados que na Vistoria da Presta็ใo de Contas foi REJEITADA, conforme os dados abaixo."
	else
		cCabec := "REJEIวรO DE PRESTAวรO DE CONTAS"
		cTexto := "Informados que a Presta็ใo de Contas conforme os dados abaixo, foi rejeitada."
	Endif		
EndIf

cCodProcesso := "WF_106" 																	

if _cTipo=='V'//visto
	cHtmlModelo :=rtrim(_cModelPA)+"Vis_Presta_YESNO.html"
else
	cHtmlModelo :=rtrim(_cModelPA)+"Aut_Presta_YESNO.html"
endif

cAssunto := "Notifica็ใo de Presta็ใo de Contas"	
oProcess:= TWFProcess():New(cCodProcesso, cAssunto) 										
cTitulo :=  "WF_106" 																		
oProcess:NewTask(cTitulo, cHtmlModelo) 														
oHtml	:= oProcess:oHTML

_cTitulo:="NOTIFICAวรO DE PRESTAวรO DE CONTAS"

cDadoTit := cChaveZV1
DBSelectArea("ZV1")
DBSetOrder(1)
DBSeek(xFilial("ZV1")+cDadoTit)

//Dados do Cabe็alho
//oProcess:oHtml:ValByName( "cTitPA" 	,cDadoTit) //14/09/16
oProcess:oHtml:ValByName( "cCabec" 		,cCabec)
oProcess:oHtml:ValByName( "cEmissao" 	,DTOC(dDataBase))
oProcess:oHtml:ValByName( "cHora" 		,SUBSTR(Time(),1,5))
oProcess:oHtml:ValByName( "cSolicit" 	,Alltrim(ZV1->ZV1_NSOLIC))
oProcess:oHtml:ValByName( "cCodSol" 	,ZV1->ZV1_CODSOL)

if _cTipo=='V'//visto
	oProcess:oHtml:ValByName( "cAprovador" ,RTRIM(ZV1->ZV1_VISTO1))
	oProcess:oHtml:ValByName( "cCodAprov" 	,Alltrim(ZV1->ZV1_NVIST1) )
else
	oProcess:oHtml:ValByName( "cAprovador" ,RTRIM(ZV1->ZV1_NAPRO1))
	oProcess:oHtml:ValByName( "cCodAprov" 	,Alltrim(ZV1->ZV1_APROV1) )
endif

oProcess:oHtml:ValByName( "cTexto" 		,cTexto )
oProcess:oHtml:ValByName( "cDadoTit" 	,cDadoTit )
oProcess:oHtml:ValByName( "cNomeFor" 	,Alltrim(ZV1->ZV1_NFUNC))
oProcess:oHtml:ValByName( "cDtEmiss" 	,DTOC(ZV1->ZV1_EMISSA))
oProcess:oHtml:ValByName( "cValor" 		,Transform(_nValZV1,"@E 999,999,999.99"))
oProcess:oHtml:ValByName( "cMotivo" 	,Alltrim(ZV1->ZV1_MOTREJ))

//Revisao do Workflow
_cIpTest:=GetNewPar("AL_IPSRVTS","181.41.169.147")

lServProd := IIf(GetEnvServer() $ 'PROTHEUS12_AE#WORKFLOW', .T.,.F.)

If lServProd //Servidor Produ็ใo
	conout("2 - RAILEC "+cCabec+" de Presta็ใo de Contas."+DTOC(dDataBase) +" para " + cDestinat)
	oProcess:cSubject := "RAILEC "+cCabec+" de Presta็ใo de Contas."+DTOC(dDataBase)
	oProcess:cTo := cDestinat+";"+Alltrim(&('GetMv("AL_MAILADM")')) 
Else //Servidor Base_teste
	conout("2 - TESTE RAILEC "+cCabec+" de Presta็ใo de Contas."+DTOC(dDataBase) +" para " + cDestinat)
	oProcess:cSubject := "TESTE RAILEC "+cCabec+" de Presta็ใo de Contas."+DTOC(dDataBase)
	oProcess:cTo := Alltrim(&('GetMv("AL_MAILADM")'))
EndIf	
oProcess:Start()                         
oProcess:Finish()

Return()          

*************************
User Function VMailZV0()
*************************
Local _lRetZV0:=.T.
//lOCAL _cMailSRA:= rtrim(POSICIONE("SRA",1,XFILIAL("SRA")+M->ZV0_CODUSR,"RA_EMAIL"))
lOCAL _cMailSRA:=U_RetDadSRA(M->ZV0_CODUSR,"RA_EMAIL") //26/09/18

//IF !IsEmail(_cMailSRA)
if empty(alltrim(_cMailSRA))
	Alert(" E-mail "+_cMailSRA+"  invแlido! ")
	_lRetZV0:=.F.
ENDIF

Return _lRetZV0 

*************************
User Function VAtivZV5()//06/08/18
*************************
Local _lRetZV5:=.T.

IF  upper(rtrim(POSICIONE("ZV5",2,XFILIAL("ZV5")+M->ZV5_ATIVO,"ZV5_ATIVO")))=='S'
	Alert("Vistoriador: "+ rtrim(ZV5->ZV5_NOME) +" estแ ATIVO! Desative o registro para prosseguir na inclusao/Altera็ใo!")
	conout("Vistoriador: "+ rtrim(ZV5->ZV5_NOME) +" estแ ATIVO! Desative o registro para prosseguir na inclusao/Altera็ใo!")
	_lRetZV5:=.F.
ENDIF

Return _lRetZV5 

*************************
Static Function SelZV0()
*************************
Local _nCountSel:=0
Local _nSel := 0

For _nSel:=1 to len(_aParZV0)
	if _aParZV0[_nSel,3]
		_nCountSel++
	endif
Next _nSel

if _nCountSel>=3 .and. !_aParZV0[oLstZV0:nAt,3]
	alert(" Nใo serแ possivel a sele็ใo de mais do que 3 aprovadores!")
else
	If !_aParZV0[oLstZV0:nAt,3]
		IF EMPTY(ALLTRIM(U_RetDadSRA(_aParZV0[oLstZV0:nAt,1],"RA_EMAIL"))) //25/09/18 -Atendimento ao chamado 19837
			alert(" E-mail nใo cadastrado ou invแlido (SRA)!")
			conout(" E-mail nใo cadastrado ou invแlido (SRA)!")
		ELSE
			_aParZV0[oLstZV0:nAt,3]:=!_aParZV0[oLstZV0:nAt,3]	
		ENDIF
	Else
		_aParZV0[oLstZV0:nAt,3]:=!_aParZV0[oLstZV0:nAt,3]
	Endif
endif

oLstZV0:refresh()	

Return

*************************
Static Function SelZV5()
*************************
Local _nCountSel:=0
Local _nSel := 0

For _nSel:=1 to len(_aParZV5)
	if _aParZV5[_nSel,3]
		_nCountSel++
	endif
Next _nSel

if _nCountSel>=1 .and. !_aParZV5[oLstZV5:nAt,3]
	alert(" Nใo ้ possivel a sele็ใo de mais do que 1 vistoriador!")
else
	_aParZV5[oLstZV5:nAt,3]:=!_aParZV5[oLstZV5:nAt,3]
endif

oLstZV5:refresh()	

Return

*************************************************
User Function WFVisPre(_aDadZV1,_aDadZV2,_aAtach)//31/07/18 - WF enviado para Visto da presta็ใo de contas - 31/07/18 - fabio yoshioka - 3.01.01.04.05
*************************************************
local _nAtach       := 0
Local _nIWf         := 0
Local cCodProcesso, cHtmlModelo, oHtml, oProcess //cCodStatus,cCodProduto,cTexto,cUsuarioProtheus,
Local cAssunto
Local lOk           := .F.
Local _nTotPre      := 0
Local _cDirDocs     := MsDocPath() // Getmv("AL_DIRDOCS") 
local cPathInServer := GetMv( 'AL_DIRPDFS' ) //02/01/17 

_cTitulo     := "PRESTACAO DE CONTAS"
cCodProcesso := "WF_106"
cHtmlModelo  := rtrim(_cModelPA)+"Vis_Presta_Page.html"
cAssunto     := "Visto da Presta็ใo de Contas"

oProcess     := TWFProcess():New(cCodProcesso, cAssunto)
cTitulo      := "WF_106"
oProcess:NewTask(cTitulo, cHtmlModelo)
oHtml        := oProcess:oHTML

//Dados do Cabe็alho
oProcess:oHtml:ValByName( "cEmissao" 	,DTOC(dDataBase))
oProcess:oHtml:ValByName( "cHora" 		,SUBSTR(Time(),1,5))
oProcess:oHtml:ValByName( "cTitPREST" 	,		 _aDadZV1[1]) //14/09/16
oProcess:oHtml:ValByName( "cCodSol" 	,		 _aDadZV1[2])
oProcess:oHtml:ValByName( "cSolicit" 	,Alltrim(_aDadZV1[3]))
oProcess:oHtml:ValByName( "cCodFavor" 	,Alltrim(_aDadZV1[4]))
oProcess:oHtml:ValByName( "cFavorecido" ,Alltrim(_aDadZV1[5]))
oProcess:oHtml:ValByName( "cCodAprov" 	,Alltrim(_aDadZV1[6]))
oProcess:oHtml:ValByName( "cAprovador"  ,Alltrim(_aDadZV1[7]))
oProcess:oHtml:ValByName( "cDatVencto"  ,Alltrim(_aDadZV1[8])) //17/07/18 - Melhorias Presta็ใo de Contas - 3.01.01.04 

if len(_aDadZV2)>0
	_nTotPre:=0
	For _nIWf:=1 to len(_aDadZV2)	

		AAdd( ( oHtml:ValByName( "it.data" 		)), dtoc(_aDadZV2[_nIWf,1]) )		
		AAdd( ( oHtml:ValByName( "it.codDesp" 	)), _aDadZV2[_nIWf,2] )		
		AAdd( ( oHtml:ValByName( "it.Descri"	)), _aDadZV2[_nIWf,3] )		
		AAdd( ( oHtml:ValByName( "it.valor" 	)), Transform( _aDadZV2[_nIWf,4] ,'@E 999,999,999.99' ))	
		AAdd( ( oHtml:ValByName( "it.complem" 	)), _aDadZV2[_nIWf,5] )
		//Inclusao de novas Colunas no WF - Fabio Yoshioka
		AAdd( ( oHtml:ValByName( "it.ccusto" 	)), _aDadZV2[_nIWf,6] )//Novas Colunas CCusto 
		AAdd( ( oHtml:ValByName( "it.deduzIR" 	)), IIf( uPPER(RTRIM(_aDadZV2[_nIWf,7]))=='S','SIM','NAO') )//Novas Colunas Deduz IR

		IF upper(rtrim(POSICIONE("ZV3",1,XFILIAL("ZV3")+_aDadZV2[_nIWf,2],"ZV3_TIPO")))=='A' //ABATIMENTOS
			_nTotPre-=_aDadZV2[_nIWf,4]
		ELSE
			_nTotPre+=_aDadZV2[_nIWf,4]
		ENDIF
			
	Next _nIWf 
ENDIF

oProcess:oHtml:ValByName( "cTotalVlr"  ,Transform(_nTotPre ,'@E 999,999,999.99' ))

//Fun็ใo de retorno a ser executada quando a mensagem de respostas retornar ao Workflow:
oProcess:bReturn :=  "U_RetWFVis()" 				

*********************************************	 					 
//Guardo o ID do Processo para enviar no link
*********************************************	 					 	
cMailID := oProcess:Start()

******************
//Enviando o Link!
******************
oHtml:SaveFile("web\ws\wflow"+"\"+cMailID+".HTM")     		//Salvo HTML do Processo
cRet := WFLoadFile("web\ws\wflow"+"\"+cMailID+".HTM")		//Carrego o link do Processo (serแ usado no retorno da Aprova็ใo)

_cTitulo:="PRESTACAO DE CONTAS"
cAssunto := "Aprova็ใo de PRESTACAO DE CONTAS"	
cHtmlModelo :=rtrim(_cModelPA)+"Vis_Prest_Link.html"

//Inicio nova tarefa do Processo... O Link.
oProcess:NewTask(cAssunto, cHtmlModelo)      

//Dados do Cabe็alho
oProcess:oHtml:ValByName( "cTitPREST" 	,_aDadZV1[1]) //14/09/16
oProcess:oHtml:ValByName( "cEmissao" 	,DTOC(dDataBase))
oProcess:oHtml:ValByName( "cHora" 		,SUBSTR(Time(),1,5))
oProcess:oHtml:ValByName( "cSolicit" 	,Alltrim(_aDadZV1[3]))
oProcess:oHtml:ValByName( "cCodSol" 	,_aDadZV1[2])
oProcess:oHtml:ValByName( "cAprovador" ,Alltrim(_aDadZV1[7]))
oProcess:oHtml:ValByName( "cCodAprov" 	,_aDadZV1[6] )

oProcess:oHtml:ValByName( "cNomeFor" 	,Alltrim(_aDadZV1[5]))
oProcess:oHtml:ValByName( "cDtEmiss" 	,DTOC(dDataBase))
oProcess:oHtml:ValByName( "cValor" 		,Transform(_nTotPre,"@E 999,999,999.99"))

//Revisao do Workflow
_cIpTest:=GetNewPar("AL_IPSRVTS","181.41.169.147")
lServProd := IIf(GetEnvServer() $ 'PROTHEUS12_AE#WORKFLOW', .T.,.F.)

cServerIni := GetAdv97()
cSecao := "SRVWFLOW"
cPadrao := "undefined"
cIPLan := GetPvProfString(cSecao, "IPWFLAN", cPadrao, cServerIni)
cPtLan := GetPvProfString(cSecao, "PTWFLAN", cPadrao, cServerIni)
cIPWeb := GetPvProfString(cSecao, "IPWFWEB", cPadrao, cServerIni)
cPtWeb := GetPvProfString(cSecao, "PTWFWEB", cPadrao, cServerIni)

If lServProd //Servidor Produ็ใo
	conout("3 - RAILEC LINK Para Autoriza็ใo de Presta็ใo de contas "+DTOC(dDataBase) +" para " + Alltrim(_aDadZV1[9]) +"-"+Alltrim(_aDadZV1[6]))
	oProcess:ohtml:ValByName("proc_localink",RTRIM(_cPrcSrvI)+cMailID+".htm")
	oProcess:ohtml:ValByName("proc_weblink",RTRIM(_cPrcSrvE)+cMailID+".htm")
	oProcess:cSubject := "RAILEC LINK Para Autoriza็ใo de Presta็ใo de contas "+DTOC(dDataBase)
	//oProcess:cTo := Alltrim(UsrRetMail(Alltrim(_aDadZV1[6])))+";"+Alltrim(&('GetMv("AL_MAILADM")')) 
	oProcess:cTo := Alltrim(_aDadZV1[9])+";"+Alltrim(&('GetMv("AL_MAILADM")'))
	cEndPage := RTRIM(_cPrcSrvI)+cMailID+".htm"
	
Else //Servidor Base_teste   
	conout("3 - TESTE RAILEC LINK Para Autoriza็ใo de Presta็ใo de contas "+DTOC(dDataBase) +" para " + Alltrim(_aDadZV1[9]) +"-"+Alltrim(_aDadZV1[6]))
	oProcess:ohtml:ValByName("proc_localink",RTRIM("http://"+_cIpTest+":8800/web/ws/wflow/")+cMailID+".htm")
	oProcess:ohtml:ValByName("proc_weblink",RTRIM("http://"+_cIpTest+":8800/web/ws/wflow/")+cMailID+".htm")
	oProcess:cSubject := "TESTE - RAILEC LINK Para Autoriza็ใo de Presta็ใo de contas "+DTOC(dDataBase)
	oProcess:cTo := Alltrim(&('GetMv("AL_MAILADM")')) 
	cEndPage := RTRIM("http://"+_cIpTest+":8800/web/ws/wflow/")+cMailID+".htm"    

EndIf	

//ANEXOS
if len(_aAtach)>0
	For _nAtach :=1 to  len(_aAtach)
		//If File(rtrim(_cDirDocs)+'\'+ rtrim(_aAtach[_nAtach]))
		_cFileAtach:=rtrim(_cDirDocs)+'\'+ rtrim(_aAtach[_nAtach])
		conout(_cFileAtach)
		oProcess:AttachFile(_cFileAtach)
		//endif
	Next _nAtach
endif

if !empty(alltrim(_cRetArqPDF)) //ANEXO O RELATORIO PDF
	oProcess:AttachFile(rtrim(cPathInServer)+alltrim(_cRetArqPDF))
endif

//oProcess:AttachFile("\RELATO\pcor045.XML")
oProcess:Start() 	//Inicia o processo... 
oProcess:Finish()  //...e em seguida finaliza    
//oProcess:Start()                         
//Se rodou at้ aqui...
lOk := .T.          
//MSGINFO("E-mail enviado para o aprovador da Presta็ใo de contas!","Presta็ใo")

Return(lOk)          

*********************************
User Function RetWFVis(oProcess) //processo de retorno do visto - 01/08/18 - Fabio Yoshioka
*********************************
Local _nApv :=0
Local _nAprov := 0

//Local oHtml 		:= oProcess:oHtml  
Local cChave 		:= oProcess:oHtml:RetByName("cTitPREST")  
Local lYESNO		:= IIF(oProcess:oHtml:RetByName("RBAPROVA") = "Sim",.T.,.F.)
//Local cCodAprov		:= oProcess:oHtml:RetByName("cCodAprov") 
//Local cCodSolic		:= oProcess:oHtml:RetByName("cCodSol") 
Local cMotivo		:= oProcess:oHtml:RetByName("LBMOTIVO")  
//Local cMatFunc		:= oProcess:oHtml:RetByName("cCodFavor")
//Local cNomFavo		:= oProcess:oHtml:RetByName("cFavorecido") //23/01/18
//Local _cDatVencto	:= oProcess:oHtml:RetByName("cDatVencto") //17/07/18 - Fabio Yoshioka -  Melhorias Rotina Presta็ใo de Contas - 3.01.01.04 
//Local aChave := {}         
//Local _lTemSe2:=.F.
Local _aArea := GetArea()
//Local _aTitulo := {}	
//Local _cTipoGrv:="CH"
//Local _cNatuGrv:=GETMV("AL_NATRPRC")// "Z0503"
//Local _cPrefGrv:=GETMV("AL_PRFRPRC")//PREFIXO
lOCAL _nAbatm:=0
Local _nTotRet:=0
//Local _cCustPresta:=""
Local _cDestNotf    := "" //23/01/18 
Local _aParZV0      := {}
Local _cStrApv      := ""
Local _aDadCab      := {} //18/07/18 - Melhorias Preata็ใo de contas 3.01.01.04 
Local _aDadDet      := {}
Local _aAnexosZV1   := {}
Local _cMailAprova  := ""
Local _cChvZV1      := ""
Private lMsErroAuto := .F.
Private lMsHelpAuto := .F.
Private _nTotForn   := 0
Private _cCodForSE2 := ""
Private _cContaForn := ""
Private nTotal      := 0
private nHdlPrv     := 0
private cLoteEst    := "008850"
private cArquivo    := ''
private lCriaHeade  := .T.
Private _cIpProd    := GetMV("AL_IPSRVPR") //05/08/16 - Fabio Yoshioka
Private _cIpTest    := GetMV("AL_IPSRVTS") //05/08/16            
Private _cPrcSrvI   := GetMV("AL_PRWFINT") //08/08/16       
Private _cPrcSrvE   := GetMV("AL_PRWFEXT") //08/08/16
Private _cIdEner    := GetMV("AL_EMFILEN") //18/07/17 - Fabio Yoshioka - Tratamento para RAILEC Energia
Private _cModelPA   := GetMV("AL_MODWFPA") //08/08/16
PRIVATE _cRetArqPDF := ""

Conout("RetWFVis: " +cChave)

//Posiciono na ZV1	
DBSelectArea("ZV1")
DBSetOrder(1)
If DBSeek(xFilial("ZV1")+cChave,.F.)
	_cChvZV1:=ZV1->ZV1_COD
	_cDestNotf:= Alltrim(UsrRetMail(ZV1->ZV1_CODSOL)) //06/08/18
	
	//Gravo Informa็๕es do Visto - 06/08/18
	Reclock("ZV1",.F.)
	ZV1->ZV1_DTVIS1:= Date()
	ZV1->ZV1_HRVIS1:= Time()
	MSUnlock()
					
	If lYESNO //aprova็ใo via wf
		_cStrApv:=""
		FOR _nApv:=1 to len(rtrim(ZV1->ZV1_MATAPV))

			if substr(ZV1->ZV1_MATAPV,_nApv,1)=='|'
				//aadd(_aParZV0,{_cStrApv,POSICIONE("SRA",1,XFILIAL("SRA")+_cStrApv,"RA_NOME")})
				aadd(_aParZV0,{_cStrApv,U_RetDadSRA(_cStrApv,"RA_NOME")}) //24/09/18 - Fabio Yoshioka - Tratamento de Filial - -Atendimento ao chamado 19837
				conout(_cStrApv)
				_cStrApv:=""
			else
				_cStrApv+=substr(ZV1->ZV1_MATAPV,_nApv,1)
			endif
		Next _nApv

		For _nAprov:=1 to len(_aParZV0)
			_aDadCab:={}//18/07/18 - Melhorias Preata็ใo de contas 3.01.01.04 
			_aDadDet:={}
			_aAnexosZV1:={}
			//_cMailAprova:=POSICIONE("SRA",1,XFILIAL("SRA")+_aParZV0[_nAprov,1],"RA_EMAIL")
			_cMailAprova:=U_RetDadSRA(_aParZV0[_nAprov,1],"RA_EMAIL")//24/09/18 - Fabio Yoshioka - Tratamento de Filial - -Atendimento ao chamado 19837
			conout(alltrim(procname()) + "_cMailAprova: "+ _cMailAprova )

			IF ISEMAIL(rtrim(_cMailAprova))//18/07/18 - Melhorias Preata็ใo de contas 3.01.01.04 

				//U_RPrestAP('1')
				aadd(_aDadCab,ZV1->ZV1_COD)
				aadd(_aDadCab,ZV1->ZV1_CODSOL)
				aadd(_aDadCab,ZV1->ZV1_NSOLIC)
				aadd(_aDadCab,ZV1->ZV1_MATRIC)
				aadd(_aDadCab,ZV1->ZV1_NFUNC)
				aadd(_aDadCab,_aParZV0[_nAprov,1])//18/07/18 - Melhorias Preata็ใo de contas 3.01.01.04 
				aadd(_aDadCab,_aParZV0[_nAprov,2])
				aadd(_aDadCab,Dtoc(ZV1->ZV1_DTVENC))//17/07/18 - Melhorias Preata็ใo de contas 3.01.01.04 
				aadd(_aDadCab,_cMailAprova)//18/07/18 - Melhorias Preata็ใo de contas 3.01.01.04 
				
				DBSelectArea("ZV2")
				DBSetOrder(3)
				DBseek(xFilial("ZV2")+ZV1->ZV1_COD)
				Do While !ZV2->(EOF()) .and. ZV2->ZV2_FILIAL+ZV2->ZV2_CODVIA+ZV2_SEQ == xFilial("ZV2")+ZV1->ZV1_COD+ZV1->ZV1_SEQ 
					//AADD(_aDadDet,{ZV2->ZV2_DATA,ZV2->ZV2_CODIGO,ZV2->ZV2_DESCRI,ZV2->ZV2_VALOR,ZV2->ZV2_COMPLE})
					AADD(_aDadDet,{ZV2->ZV2_DATA,ZV2->ZV2_CODIGO,ZV2->ZV2_DESCRI,ZV2->ZV2_VALOR,ZV2->ZV2_COMPLE,ZV2->ZV2_CCUSTO,ZV2->ZV2_DEDZIR}) //10/12/18 - Solicita็ao de inclusao de novas COlunas no WF - Fabio Yoshioka
					if _nAprov==1 
						IF upper(rtrim(POSICIONE("ZV3",1,XFILIAL("ZV3")+ZV2->ZV2_CODIGO,"ZV3_TIPO")))=='A' //ABATIMENTOS
							_nAbatm += ZV2->ZV2_VALOR
						ELSE
							_nTotRet += ZV2->ZV2_VALOR
						ENDIF
					endif
					ZV2->(DBskip())
				EndDo
				//adciono anexos (BASE DO CONHECIMENTO)
				DBSelectArea("AC9")
				DBGotop()
				AC9->(DBSetOrder(2))//AC9_FILIAL + AC9_ENTIDA + AC9_FILENT + AC9_CODENT + AC9_CODOBJ                                                                                                          
				//AC9->(DBseek(xFilial("AC9")+"ZV1"+XFILIAL("ZV1")+XFILIAL("ZV1")+PADR(_cChvZV1,TamSx3("AC9_CODENT")[1])+"0000000000" ))
				AC9->(DBseek(xFilial("AC9") + "ZV1" + XFILIAL("ZV1") + ALLTRIM(_cChvZV1) ))
				Do While !AC9->(EOF()) .AND. AC9->AC9_FILENT+alltrim(AC9->AC9_CODENT) == xFilial("ZV1")+ALLTRIM(_cChvZV1)
					if rtrim(AC9->AC9_ENTIDA)=='ZV1'
						_cArqZV1:=POSICIONE("ACB",1,XFILIAL("ACB")+AC9->AC9_CODOBJ,"ACB_OBJETO")
						if !empty(alltrim(_cArqZV1))
							AADD(_aAnexosZV1,_cArqZV1) //ACB_FILIAL, ACB_CODOBJ, R_E_C_N_O_, D_E_L_E_T_
						endif
					endif
					AC9->(DBskip())
				EndDo

				IF LEN(_aDadCab)>0 .AND. LEN(_aDadDet)>0
					U_WFAprPre(_aDadCab,_aDadDet,_aAnexosZV1)
				ENDIF
			ELSE
				ALERT("E-mail nao cadastrado ou invแlido!")
			ENDIF
		NEXT _nAprov
	ELSE
	
		Conout("RetWFVis: CHAVE" +cChave+" REJEITADO PELO VISTORIADOR")
		DBSelectArea("ZV1")
		DBSetOrder(1)
		if DBseek(xFilial("ZV1")+cChave) //23/01/18 - status reprovado
			_nTotRet:=ZV1->ZV1_TOTRET
			RecLock("ZV1",.F.)
			ZV1->ZV1_MOTREJ:=cMotivo
			ZV1->(MSUnlock())
		endif
	endif

	 ZV1YESNO(cChave,_nTotRet,_cDestNotf,lYESNO,'V') //Notifico o Inclusor na Presta็ใo
	else
		Conout("RetWFVis: CHAVE" +cChave+" NAO ENCONTRAVA NO ZV1")
	endif

	RestArea(_aArea)
	Conout("Fim da Rotina RetWFVis "+cChave)

Return()

		*******************************************
User Function RetDadSRA(_cCpoSEL,_cCpoRET) //24/09/18 - -Atendimento ao chamado 19837
	*******************************************
	Local _cRetSRA:=""
	Local _cQrySRA := " "
	Local _aAreaWF := GetArea()
	Local _cTmpSRA:='TSRA->'+Rtrim(_cCpoRET)

	_cQrySRA += " SELECT "+_cCpoRET
	_cQrySRA += " FROM "+RetSQLName("SRA")+" "
	_cQrySRA += " WHERE	D_E_L_E_T_ = ' ' "
	_cQrySRA += " AND RA_SITFOLH != 'D' "
	_cQrySRA += " AND RA_MAT = '"+rtrim(_cCpoSEL)+"'"
	_cQrySRA += " ORDER BY RA_FILIAL "

	conout(_cQrySRA)
	DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQrySRA), "TSRA", .F., .T.)
	IF !TSRA->(BOF()) .AND. !TSRA->(EOF())
		_cRetSRA:= &_cTmpSRA
	ENDIF
	TSRA->(DBCLOSEAREA())

	RestArea(_aAreaWF)

	conout(_cRetSRA)

	Return _cRetSRA

*********************************************************************************
Static Function NOTFPRB(cChaveZV1,_nValZV1,cDestinat,_cCabNotf,_cTextoNft) //22/11/18 - Notifica็ใo de Problemas na aprova็ao
*********************************************************************************

	Local cCodProcesso,  cHtmlModelo, oHtml, oProcess //cCodStatus,cCodProduto,cUsuarioProtheus,
	Local cAssunto
	Local cDadoTit
	Local cCabec := _cCabNotf //"VISTORIA DE PRESTAวรO DE CONTAS "
	Local cTexto := _cTextoNft //"Informados que a Presta็ใo de Contas conforme os dados abaixo, foi Vistada e enviada para Aprova็ใo."

	Private _cModelPA:=GetMV("AL_MODWFPA")//08/08/16

	_cIpProd:=GetMV("AL_IPSRVPR")//05/08/16 - Fabio Yoshioka

	cCodProcesso := "WF_106"

	cHtmlModelo :=rtrim(_cModelPA)+"Notif_Presta.html"

	cAssunto := "Notifica็ใo de Presta็ใo de Contas"
	oProcess:= TWFProcess():New(cCodProcesso, cAssunto)
	cTitulo :=  "WF_106"
	oProcess:NewTask(cTitulo, cHtmlModelo)
	oHtml	:= oProcess:oHTML

	_cTitulo:="NOTIFICAวรO DE PRESTAวรO DE CONTAS"

	cDadoTit := cChaveZV1
	DBSelectArea("ZV1")
	DBSetOrder(1)
	DBSeek(xFilial("ZV1")+cDadoTit)

//Dados do Cabe็alho
//oProcess:oHtml:ValByName( "cTitPA" 	,cDadoTit) //14/09/16
	oProcess:oHtml:ValByName( "cCabec" 		,cCabec)
	oProcess:oHtml:ValByName( "cEmissao" 	,DTOC(dDataBase))
	oProcess:oHtml:ValByName( "cHora" 		,SUBSTR(Time(),1,5))
	oProcess:oHtml:ValByName( "cSolicit" 	,Alltrim(ZV1->ZV1_NSOLIC))
	oProcess:oHtml:ValByName( "cCodSol" 	,ZV1->ZV1_CODSOL)

	oProcess:oHtml:ValByName( "cVistoriador" ,RTRIM(ZV1->ZV1_NVIST1))
	oProcess:oHtml:ValByName( "cCodVisto" 	,Alltrim(ZV1->ZV1_VISTO1) )

	oProcess:oHtml:ValByName( "cAprovador" ,RTRIM(ZV1->ZV1_NAPRO1))
	oProcess:oHtml:ValByName( "cCodAprov" 	,Alltrim(ZV1->ZV1_APROV1) )

	oProcess:oHtml:ValByName( "cTexto" 		,cTexto )
	oProcess:oHtml:ValByName( "cDadoTit" 	,cDadoTit )
	oProcess:oHtml:ValByName( "cNomeFor" 	,Alltrim(ZV1->ZV1_NFUNC))
	oProcess:oHtml:ValByName( "cDtEmiss" 	,DTOC(ZV1->ZV1_EMISSA))
	oProcess:oHtml:ValByName( "cValor" 		,Transform(_nValZV1,"@E 999,999,999.99"))
//oProcess:oHtml:ValByName( "cMotivo" 	,Alltrim(ZV1->ZV1_MOTREJ))

//Revisao do Workflow
	_cIpTest:=GetNewPar("AL_IPSRVTS","181.41.169.147")
	lServProd := IIf(GetEnvServer() $ 'PROTHEUS12_AE#WORKFLOW', .T.,.F.)

	If lServProd //Servidor Produ็ใo
		conout("4 - RAILEC LINK Para Autoriza็ใo de Presta็ใo de contas "+DTOC(dDataBase) +" para " + cDestinat )
		oProcess:cSubject := "RAILEC "+cCabec+" de Presta็ใo de Contas."+DTOC(dDataBase)
		oProcess:cTo := cDestinat + ";" + Alltrim(&('GetMv("AL_MAILADM")'))
	Else //Servidor Base_teste
		conout("4 - TESTE RAILEC LINK Para Autoriza็ใo de Presta็ใo de contas "+DTOC(dDataBase) +" para " + cDestinat )
		oProcess:cSubject := "TESTE RAILEC "+cCabec+" de Presta็ใo de Contas."+DTOC(dDataBase)
		oProcess:cTo := Alltrim(&('GetMv("AL_MAILADM")'))
	EndIf
	oProcess:Start()
	oProcess:Finish()

Return()

