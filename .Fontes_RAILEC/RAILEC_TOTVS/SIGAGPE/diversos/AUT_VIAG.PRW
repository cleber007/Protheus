#include "PROTHEUS.CH"
#include "MSGRAPHI.CH"
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99
#include "ap5mail.ch"

#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ AUT_VIAG ¦ Autor ¦ JOSE NORBERTO MACEDO  ¦ Data ¦ AGO 2008 ¦¦¦
¦¦¦          ¦          ¦ P.E   ¦ PATRICIA PAULA        ¦      ¦          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ COMPLEMENTOS INFORMATIVOS ORCAMENTO                        ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ ALUBAR S/A                                                 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function CADZX1()
_cArea := Alias()
_nOrd  := IndexOrd()
nReg   :=RecNo()

DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

PRIVATE aCores    := {{ 'ZX1->ZX1_SIT=" "'	, 'ENABLE' },;
{ 'ZX1->ZX1_SIT="2"'	, 'BR_AZUL' },;
{ 'ZX1->ZX1_SIT="3"'	, 'DISABLE'}}

DbSelectArea("ZX1")
DbGotop()

cCadastro:="Historico Informativos de Orcamentos"

aRotina := { { "Pesquisa",  'AxPesqui', 0, 1 },;
{"Visualizar","AxVisual",0, 2} ,;
{ "Inclui", 'AxInclui' , 0, 3 },;
{ "Altera", 'AxAltera' , 0, 4 },;
{ "Exclui", 'AxDeleta' , 0, 5 },;
{ "Env Aprov", 'ExecBlock("fZZXEnv")' , 0, 6 },;
{ "Lib / Blq", 'ExecBlock("fZZXApr")' , 0, 7 },;
{ "Imprime", 'ExecBlock("fZX1Imp")' , 0, 8 },;
{ "&Legenda ",  "U_BRLegenX1"         , 0 ,9 }}

mBrowse(16,00,280,350,"ZX1",,,,,,aCores)

dbSelectArea(_cArea)
DbSetOrder(_nOrd)
DbGoTo(nReg)

return(nil)

User Function BRLegenX1()
Local aLegenda := { {"ENABLE" ,"Aguardando Lib"}    ,;
{"BR_AZUL"   ,"Rejeitado"}   ,;
{"DISABLE","Autorizado"}}


BrwLegenda(cCadastro,"Legenda" ,aLegenda)

Return .T.


//*******************************************************************************************************************
USER FUNCTION fZZXEnv()
//*******************************************************************************************************************

Local lResult   := .f.				// Resultado da tentativa de comunicacao com servidor de E-Mail
Local cTitulo1
Local lRelauth := GetNewPar("MV_RELAUTH",.F.)		// Parametro que indica se existe autenticacao no e-mail
Local cEmailBcc:= ""
Local cError   := ""

Local lRet	   := .F.
Local cFrom	   := GetMV("MV_RELACNT")
Local cConta   := GetMV("MV_RELACNT")
Local cSenhaX  := GetMV("MV_RELPSW")
//Local lFirst   := .T.
//Local cRotina  := "U_"+ProcName(7)

cEmailTo := ZX1->ZX1_EMAIL2

cTitulo1 := "Solicitacao de Viagem aguardando Aprovaçao - AV: "+ZX1->ZX1_COD

cMensagem:=             "Caro Sr.(a) "+cEmailTo+CHR(13) + CHR(10)
cMensagem:= cMensagem + "                             "+CHR(13) + CHR(10)
cMensagem:= cMensagem + "Foi Aberta AV No..: "+ZX1->ZX1_COD + CHR(13) + CHR(10)
cMensagem:= cMensagem + "Emitido em........: "+DTOC(ZX1->ZX1_DATA) + CHR(13) + CHR(10)
cMensagem:= cMensagem + "Nome do Viajante..: "+ZX1->ZX1_NOME  + CHR(13) + CHR(10)
cMensagem:= cMensagem + "Periodo           : "+DTOC(ZX1->ZX1_DTINI)+" a "+DTOC(ZX1->ZX1_DTFIM)   + CHR(13) + CHR(10)
cMensagem:= cMensagem + "Trecho            : "+ZX1->ZX1_DEST+"."+ CHR(13) + CHR(10)
cMensagem:= cMensagem + "Valor do Adiantam : "+STR(ZX1->ZX1_ADIANT,12,2)+"."+ CHR(13) + CHR(10)
cMensagem:= cMensagem + "                             "+CHR(13) + CHR(10)

cMensagem:= cMensagem + "                             "+CHR(13) + CHR(10)
cMensagem:= cMensagem + "Estamos no aguardo da sua liberação para que seja concluido processo."+CHR(13) + CHR(10)


cAnexo:= ""

cEmailTo := ALLTRIM(cEmailTo) + ","+ZX1->ZX1_EMAIL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tenta conexao com o servidor de E-Mail ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CONNECT SMTP                         ;
SERVER 	 GetMV("MV_RELSERV"); 	// Nome do servidor de e-mail
ACCOUNT  GetMV("MV_RELACNT"); 	// Nome da conta a ser usada no e-mail
PASSWORD GetMV("MV_RELPSW") ; 	// Senha
RESULT   lResult             	// Resultado da tentativa de conexão

// Se a conexao com o SMPT esta ok
If lResult
	
	// Se existe autenticacao para envio valida pela funcao MAILAUTH
	If lRelauth
		lRet := Mailauth(cConta,cSenhaX)
	Else
		lRet := .T.
	Endif
	
	If lRet
		SEND MAIL FROM 	cFrom ;
		TO 				cEmailTo;
		BCC     		cEmailBcc;
		SUBJECT 		cTitulo1;
		BODY 			cMensagem;
		ATTACHMENT  	cAnexo  ;
		RESULT lResult
		
		
		If !lResult
			//Erro no envio do email
			GET MAIL ERROR cError
			MsgStop("Erro no envio de e-mail","erro de envio")
		ELSE
			DISCONNECT SMTP SERVER
			ALERT("E-Mail enviado com sucesso !!!"+cEmailTO)
		Endif
	Else
		GET MAIL ERROR cError
		MsgStop("Erro de autenticação","Verifique a conta e a senha para envio")
	Endif
	
	DISCONNECT SMTP SERVER
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	MsgStop("Erro de CONEXAO COM SMTP","ERRO DE CONEXAO COM SMTP...")
Endif


RETURN 


//*****************************************************************************************************************
USER FUNCTION fZZXApr()
//*****************************************************************************************************************
    ALERT("EM DESENVOLVIMENTO....")
RETURN 


//*****************************************************************************************************************
USER FUNCTION fZX1Imp()
//*****************************************************************************************************************
Local i as numeric
nOrdem :=0
Z:=0
M:=0
tamanho:="M"
limite:=220
titulo   := PADC("AUT VIAGEM",74)
cDesc1   := PADC(" ",74)
cDesc2   := PADC(" ",74)
cDesc3   := PADC(" ",74)
cNatureza:=""
aReturn  := { "Especial", 1,"Administracao", 2, 2, 1,"",1 }
nPag     := 0
nomeprog := "ZX1IMP"
cPerg    := ""
wnrel    := "ZX1IMP"
nLastKey := 0
lContinua:= .T.
nLin     := 0
cString:= ALIAS()


//+--------------------------------------------------------------+
//¦ Inicializa variaveis graficas                                ¦
//+--------------------------------------------------------------+

oFont7 := TFont():New("Courier New",,8,,.F.,,,,.T.,.F.)
oFont8 := TFont():New("Courier New",,15,,.T.,,,,.T.,.F.)

oFont9 := TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)
oFont9a:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
oFont9c:= TFont():New("Courier New",,12,,.T.,,,,.T.,.F.)

oPrn := TMSPrinter():New()
oPrn:Setup()


//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,"M","",.T.)

If nLastKey == 27 .or. Lastkey() == 27
	Return
Endif

//+--------------------------------------------------------------+
//¦ Verifica Posicao do Formulario na Impressora                 ¦
//+--------------------------------------------------------------+
SetDefault(aReturn,cString)

If nLastKey == 27 .or. Lastkey() == 27
	Return
Endif





LinCab := 0
cabec1 :=" "
cabec2 :=" "
cabec3 :=" "
cabec4 :=" "
cBitMap:= "LOGO.Bmp"



DBSELECTAREA("ZX1")
//********************************************************************************* IMPRESSAO


Linha := 9999
nPag  := 0
_COL1:= 050
_COL2:= 200
_COL3:= 480

_COL4:= 650
_COL5:= 850
_COL6:=1050
_COL7:=1250
_COL8:=1450
_COL9:=1650
_COLA:=1850
_COLB:=2050
_COLC:=2250
_COLD:=2450
_COLE:=2650
_COLF:=2850

_COLG:=3000
_COLH:=3150

_TGIT :=0
_TGVL :=0

DBSELECTAREA("ZX1")
			oPrn:EndPage()
			Linha := 0
			nPag  := nPag +1
			oPrn:SayBitmap( Linha:=Linha+050,080,cBitMap,350,220 )


		    _TIPO:=ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"X1"+ZX1->ZX1_TIPO,"X5_DESCRI"))

			oPrn:Say(  Linha:=Linha+50 , 900,"FICHA DE AUTORIZAÇÃO DE VIAGEM" , oFont8)
			oPrn:Say(  Linha:=Linha+50 , 900,  SM0->M0_NOMECOM  , oFont8 )

			oPrn:Say(  Linha:=Linha+180, 050,"Numero : "+ZX1->ZX1_COD , oFont9C)
			oPrn:Say(  Linha:=LinhA    , 450,"Data AV: "+DTOC(ZX1->ZX1_DATA), oFont9C)
			oPrn:Say(  Linha:=Linha+ 60, 050,"Matric : "+ZX1->ZX1_MATR , oFont9C)
			oPrn:Say(  Linha:=LinhA    , 450,"Nome   : "+ZX1->ZX1_NOME, oFont9C)
			oPrn:Say(  Linha:=LinhA    ,1250,"CCusto : "+ALLTRIM(ZX1->ZX1_CCUSTO)+" - "+Posicione("CTT",1,xFilial("CTT")+ZX1->ZX1_CCUSTO,"CTT_DESC01"), oFont9C)

			oPrn:Say(  Linha:=Linha+ 60, 050,"Solicit: "+ZX1->ZX1_EMAIL , oFont9C)
			oPrn:Say(  Linha:=LinhA+ 60, 050,"Aprovad: "+ZX1->ZX1_EMAIL2, oFont9C)
			oPrn:Say(  Linha:=LinhA    ,1250,"Tipo   : "+ZX1->ZX1_TIPO+" - "+_Tipo, oFont9C)

			oPrn:Say(  Linha:=Linha+ 60, 050,"Motivo : " , oFont9C)


		cString:=ZX1->ZX1_OBS
		lWrap:=.T.
		A=MLCOUNT(cString,100,,lWrap)
		FOR I:=1 TO A
			oPrn:Say(  Linha ,240,MEMOLINE(cString,100,I,,lWrap)               , oFont9)
			Linha:=Linha+45
		NEXT I

	    oPrn:Box( Linha:=Linha+50,300,Linha+1600,1900)
	    _RODAPE:=Linha+1600 + 100
	    
		oPrn:Say(  Linha:=Linha+ 40, 350,"Descrição" , oFont9C)
		oPrn:Say(  Linha:=Linha    ,1750,"Valor" , oFont9C)
	    oPrn:line( Linha:=Linha+50   , 310 ,Linha,1900)     // Linha horizontal

        _HOTEL:=POSICIONE("SA2",1,XFILIAL("SA2")+ZX1->ZX1_HOTEL,"A2_NOME")
        
		oPrn:Say(  Linha:=Linha+ 60, 310,"Passagem : "+ZX1->ZX1_DEST , oFont9)
		oPrn:Say(  Linha:=Linha    ,1700,TRANSFORM(ZX1->ZX1_VLRPAS,"@EZ 999,999.99") , oFont9)
		oPrn:Say(  Linha:=Linha+ 50, 350,"Periodo : "+DTOC(ZX1->ZX1_DTINI)+" a "+DTOC(ZX1->ZX1_DTFIM)+" - "+_hotel , oFont9)

		oPrn:Say(  Linha:=Linha+ 60, 310,"Adiantamento para despesas diversas e posterior prestaçãqo de contas" , oFont9)
		oPrn:Say(  Linha:=Linha    ,1700,TRANSFORM(ZX1->ZX1_ADIANT,"@EZ 999,999.99") , oFont9)
		oPrn:Say(  Linha:=Linha+ 50, 350,"Banco / Agencia : "+ZX1->ZX1_BANCO+" / "+ZX1->ZX1_AGENCI+" Conta : "+ZX1->ZX1_CONTA , oFont9)


		oPrn:Say(  Linha:=Linha+ 60, 1300,"Total" , oFont9C)
		oPrn:Say(  Linha:=Linha    ,1700,TRANSFORM(ZX1->ZX1_VLRPAS+ZX1->ZX1_ADIANT,"@EZ 999,999.99") , oFont9)

        LINHA:= _Rodape
		oPrn:Say(  Linha:=Linha+ 60, 310,"Solicitante" , oFont9)
        
		oPrn:Say(  Linha:=Linha    , 1050,"Aprovador" , oFont9)
        
		oPrn:Say(  Linha:=Linha    , 1750,"Data" , oFont9)

//+--------------------------------------------------------------+
//¦                      FIM DA IMPRESSAO                        ¦
//+--------------------------------------------------------------+

oPrn:Preview()
MS_FLUSH()

oPrn:EndPage()



dbSelectArea('ZX1')


RETURN Nil






