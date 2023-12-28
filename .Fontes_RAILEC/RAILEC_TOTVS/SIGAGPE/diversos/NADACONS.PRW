#include "ap5mail.ch"
#include "rwmake.ch"


//*******************************************************************************************************************
**************
user Function NADACONS()    // ROTINA DE IMPRESSAO DE CONTRATO DE TRABALHO ... By JOSE MACEDO
**************

nOrdem :=0
Z:=0
M:=0
tamanho:="M"
limite:=220
titulo   := PADC("CONTRATO DE TRABALHO",74)
cDesc1   := PADC(" ",74)
cDesc2   := PADC(" ",74)
cDesc3   := PADC(" ",74)
cNatureza:=""
aReturn  := { "Especial", 1,"Administracao", 2, 2, 1,"",1 }
nPag     := 0
nomeprog := "NADACO"
cPerg    := "NADACO"
wnrel    := SUBSTR(CUSUARIO,7,3)+"_NADACO"
nLastKey := 0
lContinua:= .T.
nLin     := 0

_TXCORREA:= 0
_TXJURREA:= 0
_QUAL    := ""
_A:=ARRAY(10,20)

//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas                                      ¦
//+-------------------------------------------------------------------------+
_INI:=_FIM:=SPACE(6)
@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Matricula"
@ 10, 22 SAY "Matric:"
@ 10, 49 GET _INI  SIZE 25,12 F3 "SRA"
@ 60, 95 BmpButton Type 1 Action Close(oDlg2)
Activate Dialog oDlg2 Centered

cString:= ALIAS()


//+--------------------------------------------------------------+
//¦ Inicializa variaveis graficas                                ¦
//+--------------------------------------------------------------+

aOkImp := .f.
nHeight:=15
lBold:= .F.
lUnderLine:= .F.
lPixel:= .T.
lPrint:=.F.
nSedex := 1

oFont9  :=TFont():New( "Arial"   ,,14,,.T.,,,,,.F. )
oFont9a :=TFont():New( "Times New Roman"   ,,12,,.F.,,,,,.F. )
oFont9b :=TFont():New( "Arial"   ,,12,,.T.,,,,,.F. )
oFont9b2:=TFont():New( "Arial"   ,,11,,.F.,,,,,.F. )
oFont9C :=TFont():New( "Arial"   ,,14,,.T.,,,,,.F. )

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
cBitMap:= "ALUBAR_ISO.Bmp"


_FIM:=_INI
//+-----------------------------------------------------------+
//¦ Inicio do Relatorio                                       ¦
//+-----------------------------------------------------------+
_A:=ARRAY(40)
I:=1
// ********************************** CARREGA TABELA
//DBSELECTAREA("SX5")
//DBSEEK("  "+"ZA")
//WHILE !EOF() .AND. LEFT(X5_TABELA,2)="ZA"
//	_A[I]:=X5_DESCRI
//	DBSKIP()
//	I++
//ENDDO
FOR J=I TO 40
	_A[J]:=" "
NEXT
_A[01]:="Providenciar a carta demissional e enviar a gerência responsável "
_A[02]:="para recolhimento de assinaturas."

_A[03]:="Enviar e-mail às áreas de TI, SESMT, Portaria, Serviços de Infraestrutura"
_A[04]:="e Financeiro informando sobre o desligamento do colaborador, solicitando "
_A[05]:="o cancelamento do acesso do mesmo na Rede, e-mail, Intranet, SIM e Microsiga "
_A[06]:="e solicitando  que as áreas informem  se existem pendências a serem descontadas "
_A[07]:="do colaborador.

_A[08]:="Orientar o colaborador desligado sobre a exclusão dos benefícios "
_A[09]:="(Uniodonto, Unimed e Visa Vale)."

_A[10]:="Encaminhar o colaborador ao SESMT para orientações sobre devolução de EPI’s"
_A[11]:="e uniformes e a Medicina Ocupacional para que os mesmos recebam a autorização"
_A[12]:="para realização de exames demissionais na Medicom."


_131  :="Solicitar ao SESMT o formulário de recebimento de EPI,s devidamente "
_132  :="assinado pelo colaborador. "


_133  :="Consultar extratos de empréstimos consignados das instituições financeiras "
_134  :="Banco do Brasil e Banpará. Descontar o valor do colaborador em até 30% do "
_135  :="valor devido, não podendo ultrapassar a maior remuneração do mesmo, dependendo "
_136  :="do contrato da empresa com a instituição."




_A[13]:="Solicitar ao Banco do Brasil extrato de empréstimo consignado. "
_A[14]:="Descontar o valor do colaborador em até 30% do valor devido, não "
_A[15]:="podendo ultrapassar a maior remuneração do mesmo."

_A[16]:="Excluir colaborador e dependentes da BrasilCard e solicitar saldo devedor para"
_A[17]:="desconto em rescisão."

_A[18]:="Excluir colaborador e dependente da Unimed, Uniodonto e Visa Vale.
_A[19]:="Calcular rescisão.

_A[20]:="Comunicar movimentação do colaborador na Conectividade Social para emissão "
_A[21]:="de extrato com saldo de FGTS.                                              "

_A[22]:="Gerar guia GRRF."
_231  :="Enviar o arquivo TXT, do seguro desemprego para o Portal mais emprego"
_232  :="(Ministério do trabalho e previdência social)."



_A[23]:="Preencher formulários para solicitação de seguro desemprego."

_A[24]:="Solicitar à Medicina o PPP e resultado do exame demissional do colaborador."

_A[25]:="Dar baixa e atualizar a CTPS do colaborador somente após o resultado do "
_A[26]:="exame demissional."



_A[27]:="Homologação: - Documentos para serem entregue ao colaborador:"
_A[28]:="Carteira de Trabalho e Previdência Social (CTPS), com as anotações atualizadas;"
_A[29]:="03(três) vias da rescisão homologada;                                          "
_A[30]:="PPP preenchido pela área de Medicina;                                          "
_A[31]:="01(uma) cópia do exame demissional;                                            "
_A[32]:="Extrato de FGTS;                                                               "
_A[33]:="Chave para saque de FGTS;                                                      "
_A[34]:="Demonstrativo de pagamento da multa dos 40%,                                   "
_A[35]:="Formulário de seguro desemprego.                                               "
                                                                                        "

DBSELECTAREA("SRA")
DBSETORDER(1)
DBSEEK(XFILIAL("SRA")+_INI)
IF FOUND()
	oPrn:EndPage()
	Linha := 70
	nPag  := nPag +1
	
	oPrn:SayBitmap( Linha+050,080,cBitMap,2080,480 )
	
	oPrn:Say(Linha:=Linha+500,800,"CHECK-LIST PROCESSO DEMISSIONAL" , oFont9B)
	
	//	oPrn:line( Linha:=Linha+50   ,  80 ,Linha,2260)     // Linha horizontal
	
	_SALTO:=60
	oPrn:Say(Linha:=Linha+_SALTO*2 ,100,"Funcionário : "             , oFont9a)
	oPrn:Say(Linha:=Linha          ,430,SRA->RA_MAT+"-"+SRA->RA_NOME , oFont9a)
	oPrn:Say(Linha:=Linha+_SALTO   ,100,"Função : "                                                 , oFont9a)
	oPrn:Say(Linha:=Linha          ,430,POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_DESC") , oFont9a)
	oPrn:Say(Linha:=Linha          ,1700,"Admissao : "+DTOC(SRA->RA_ADMISSA) , oFont9a)
	oPrn:Say(Linha:=Linha+_SALTO   ,100,"Centro de Custo : "                                                               , oFont9a)
	oPrn:Say(Linha:=Linha          ,430,ALLTRIM(SRA->RA_CC)+" - "+Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01"), oFont9a)
	oPrn:Say(Linha:=Linha          ,1700,"Demissao : "+DTOC(SRA->RA_DEMISSA) , oFont9a)
	
	//	oPrn:line( Linha:=Linha+50   ,  80 ,Linha,2260)     // Linha horizontal
	
	oPrn:Box( Linha:=Linha+75,80,Linha+100,2290)
	oPrn:Say(  Linha+30 , 100,  "Item"  , oFont9B )
	oPrn:Say(  Linha+30 , 570,  "Descrição do Processo"  , oFont9B )
	oPrn:Say(  Linha+30 ,1710,  "Responsável"  , oFont9B )
	oPrn:Say(  Linha+30 ,2040,  "Status"  , oFont9B )
	LINHAINI:=LINHA

	LINHA   :=LINHA+100
	oPrn:Box( Linha:=Linha+20,80,Linha+2150,2290)   // BOX GRANDE

	oPrn:Say(  Linha+30 , 100,  STRZERO(1,2,0)  , oFont9B )
	oPrn:Say(  Linha+30 , 200,  _A[1]  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _A[2]  , oFont9B2 )
	oPrn:line( Linha:=Linha+80,80,Linha,2290)     // Linha horizontal
	
	LINHA:=LINHA+20
	oPrn:Say(  Linha+30 , 100,  STRZERO(2,2,0)  , oFont9B )
	oPrn:Say(  Linha+30 , 200,  _A[3]  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _A[4]  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _A[5]  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _A[6]  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _A[7]  , oFont9B2 )
	oPrn:line( Linha:=Linha+80,80,Linha,2290)     // Linha horizontal

	LINHA:=LINHA+20
	oPrn:Say(  Linha+30 , 100,  STRZERO(3,2,0)  , oFont9B )
	oPrn:Say(  Linha+30 , 200,  _A[8]  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _A[9]  , oFont9B2 )
	oPrn:line( Linha:=Linha+80,80,Linha,2290)     // Linha horizontal

	LINHA:=LINHA+20
	oPrn:Say(  Linha+30 , 100,  STRZERO(4,2,0)  , oFont9B )
	oPrn:Say(  Linha+30 , 200,  _A[10]  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _A[11]  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _A[12]  , oFont9B2 )
	oPrn:line( Linha:=Linha+80,80,Linha,2290)     // Linha horizontal

	LINHA:=LINHA+20
	oPrn:Say(  Linha+30 , 100,  STRZERO(5,2,0)  , oFont9B )
	oPrn:Say(  Linha+30 , 200,  _131  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _132  , oFont9B2 )
	oPrn:line( Linha:=Linha+80,80,Linha,2290)     // Linha horizontal

	LINHA:=LINHA+20
	oPrn:Say(  Linha+30 , 100,  STRZERO(6,2,0)  , oFont9B )
	oPrn:Say(  Linha+30 , 200,  _133  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _134  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _135  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _136  , oFont9B2 )
	oPrn:line( Linha:=Linha+80,80,Linha,2290)     // Linha horizontal



//	LINHA:=LINHA+20
//	oPrn:Say(  Linha+30 , 100,  STRZERO(7,2,0)  , oFont9B )
//	oPrn:Say(  Linha+30 , 200,  _A[13]  , oFont9B2 )
//	LINHA:=LINHA+50
//	oPrn:Say(  Linha+30 , 200,  _A[14]  , oFont9B2 )
//	LINHA:=LINHA+50
//	oPrn:Say(  Linha+30 , 200,  _A[15]  , oFont9B2 )
//	oPrn:line( Linha:=Linha+80,80,Linha,2290)     // Linha horizontal

	LINHA:=LINHA+20
	oPrn:Say(  Linha+30 , 100,  STRZERO(7,2,0)  , oFont9B )
	oPrn:Say(  Linha+30 , 200,  _A[16]  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _A[17]  , oFont9B2 )
	oPrn:line( Linha:=Linha+80,80,Linha,2290)     // Linha horizontal

	LINHA:=LINHA+20
	oPrn:Say(  Linha+30 , 100,  STRZERO(8,2,0)  , oFont9B )
	oPrn:Say(  Linha+30 , 200,  _A[18]  , oFont9B2 )
	oPrn:line( Linha:=Linha+80,80,Linha,2290)     // Linha horizontal

	LINHA:=LINHA+20
	oPrn:Say(  Linha+30 , 100,  STRZERO(9,2,0)  , oFont9B )
	oPrn:Say(  Linha+30 , 200,  _A[19]  , oFont9B2 )
	oPrn:line( Linha:=Linha+80,80,Linha,2290)     // Linha horizontal

	LINHA:=LINHA+20
	oPrn:Say(  Linha+30 , 100,  STRZERO(10,2,0)  , oFont9B )
	oPrn:Say(  Linha+30 , 200,  _A[20]  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _A[21]  , oFont9B2 )
	oPrn:line( Linha:=Linha+80,80,Linha,2290)     // Linha horizontal
	LINHA:=LINHA+20
	oPrn:Say(  Linha+30 , 100,  STRZERO(11,2,0)  , oFont9B )
	oPrn:Say(  Linha+30 , 200,  _A[22]  , oFont9B2 )
	oPrn:line( Linha:=Linha+80,80,Linha,2290)     // Linha horizontal






	oPrn:line( LINHAINI   , 190 ,Linha, 190)      // Linha VERTICAL
	oPrn:line( LINHAINI   ,1700 ,Linha,1700)      // Linha VERTICAL
	oPrn:line( LINHAINI   ,1980 ,Linha,1980)      // Linha VERTICAL


//********************************************************************
	oPrn:EndPage()          // SALTA PARA SEGUNDA PAGINA DA PARADINHA
	Linha := 70
	nPag  := nPag +1

	_SALTO:=60
	oPrn:Say(Linha:=Linha+_SALTO*2 ,100,"Funcionário : "             , oFont9a)
	oPrn:Say(Linha:=Linha          ,430,SRA->RA_MAT+"-"+SRA->RA_NOME , oFont9a)
	oPrn:Say(Linha:=Linha+_SALTO   ,100,"Função : "                                                 , oFont9a)
	oPrn:Say(Linha:=Linha          ,430,POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_DESC") , oFont9a)
	oPrn:Say(Linha:=Linha          ,1700,"Admissao : "+DTOC(SRA->RA_ADMISSA) , oFont9a)
	oPrn:Say(Linha:=Linha+_SALTO   ,100,"Centro de Custo : "                                                               , oFont9a)
	oPrn:Say(Linha:=Linha          ,430,ALLTRIM(SRA->RA_CC)+" - "+Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01"), oFont9a)
	oPrn:Say(Linha:=Linha          ,1700,"Demissao : "+DTOC(SRA->RA_DEMISSA) , oFont9a)


	oPrn:Box( Linha:=Linha+75,80,Linha+100,2290)
	oPrn:Say(  Linha+30 , 100,  "Item"  , oFont9B )
	oPrn:Say(  Linha+30 , 570,  "Descrição do Processo"  , oFont9B )
	oPrn:Say(  Linha+30 ,1710,  "Responsável"  , oFont9B )
	oPrn:Say(  Linha+30 ,2040,  "Status"  , oFont9B )
   LINHAINI:=LINHA

	LINHA:=LINHA+100
	oPrn:Box( Linha:=Linha+20,80,Linha+2150,2290)   // BOX GRANDE
	LINHA   :=LINHA+50

	LINHA:=LINHA+20
	oPrn:Say(  Linha+30 , 100,  STRZERO(12,2,0)  , oFont9B )
	oPrn:Say(  Linha+30 , 200,  _231  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _232  , oFont9B2 )
	oPrn:line( Linha:=Linha+80,80,Linha,2290)     // Linha horizontal


//	LINHA:=LINHA+20
//	oPrn:Say(  Linha+30 , 100,  STRZERO(14,2,0)  , oFont9B )
//	oPrn:Say(  Linha+30 , 200,  _A[23]  , oFont9B2 )
//	oPrn:line( Linha:=Linha+80,80,Linha,2290)     // Linha horizontal


	LINHA:=LINHA+20
	oPrn:Say(  Linha+30 , 100,  STRZERO(13,2,0)  , oFont9B )
	oPrn:Say(  Linha+30 , 200,  _A[24]  , oFont9B2 )
	oPrn:line( Linha:=Linha+80,80,Linha,2290)     // Linha horizontal

	LINHA:=LINHA+20
	oPrn:Say(  Linha+30 , 100,  STRZERO(14,2,0)  , oFont9B )
	oPrn:Say(  Linha+30 , 200,  _A[25]  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _A[26]  , oFont9B2 )
	oPrn:line( Linha:=Linha+80,80,Linha,2290)     // Linha horizontal


	oPrn:Say(  Linha+30 , 100,  STRZERO(15,2,0)  , oFont9B )
	oPrn:Say(  Linha+30 , 200,  _A[27]  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _A[28]  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _A[29]  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _A[30]  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _A[31]  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _A[32]  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _A[33]  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _A[34]  , oFont9B2 )
	LINHA:=LINHA+50
	oPrn:Say(  Linha+30 , 200,  _A[35]  , oFont9B2 )
	oPrn:line( Linha:=Linha+80,80,Linha,2290)     // Linha horizontal

	oPrn:line( LINHAINI   , 190 ,Linha, 190)      // Linha VERTICAL
	oPrn:line( LINHAINI   ,1700 ,Linha,1700)      // Linha VERTICAL
	oPrn:line( LINHAINI   ,1980 ,Linha,1980)      // Linha VERTICAL


	DBSELECTAREA("SRA")
	LINHA:=LINHA+30
	oPrn:Box( Linha:=Linha+75,80,Linha+360,2290)
	oPrn:Say( Linha+30 , 100,  "Observações:"  , oFont9B )      // BOX RODAPE (FINAL)

ELSE
	ALERT("Matricula nao encontrada !!!")
ENDIF

oPrn:Preview()
MS_FLUSH()

oPrn:EndPage()


//*************************************************************** ENVIA WORKFLOW PARA SETORES (BY MACEDO)
//cEmailTo := GETMV("MV_UNADAC")+SPACE(50)
//@ 1,1 to  300,300 DIALOG oDlg2 TITLE "Envia e-mail ?"
//@ 44, 20 GET cEmailTO SIZE 120,15
//@ 60, 90 BmpButton Type 1 Action Close(oDlg2)
//Activate Dialog oDlg2 Centered
//cEmailTo := ALLTRIM(cEmailTo)
//IF !EMPTY(cEmailTo)
//	ENVIAEMAIL()
//ENDIF
//***********************************************************************************************************

Return



//*************************
STATIC FUNCTION ENVIAEMAIL()
//*************************

Local lResult   := .f.				// Resultado da tentativa de comunicacao com servidor de E-Mail
Local cTitulo1
Local lRelauth := GetNewPar("MV_RELAUTH",.F.)		// Parametro que indica se existe autenticacao no e-mail
Local cEmailBcc:= ""
Local cError   := ""
Local lRelauth := GetNewPar("MV_RELAUTH",.F.)		// Parametro que indica se existe autenticacao no e-mail
Local lRet	   := .F.
Local cFrom	   := GetMV("MV_RELACNT")
Local cConta   := GetMV("MV_RELACNT")
Local cSenhaX  := GetMV("MV_RELPSW")
Local lFirst   := .T.
Local cRotina  := "U_"+ProcName(7)


cTitulo1 := "Nada Consta Demissional"
cMensagem:=             "Caro Sr.(a) " + CHR(10)
cMensagem:= cMensagem + "                             "+CHR(13) + CHR(10)
cMensagem:= cMensagem + "O Colaborador   ..: "+SRA->RA_MAT+"-"+SRA->RA_NOME + CHR(13) + CHR(10)
cMensagem:= cMensagem + "está em processo de demissao, por isso solicitamos o lenvantamento das pendencias " + CHR(13) + CHR(10)
cMensagem:= cMensagem + "que constem em seu setor, para que sejam consideradas na referida rescisao de contrato. " + CHR(13) + CHR(10)
cMensagem:= cMensagem + "O próprio estará levando em mãos o documento de NADA CONSTA, para que sejam apontados os" + CHR(13) + CHR(10)
cMensagem:= cMensagem + "valores em questão.                             "+CHR(13) + CHR(10)
cMensagem:= cMensagem + "                  "+CHR(13) + CHR(10)

cMensagem:= cMensagem + "Favor nao responder esse e-mail, pois trata-se de envio eletronico. " + CHR(13) + CHR(10)
cMensagem:= cMensagem + "Grato, "+SUBSTR(cUSUARIO,7,15)+"." +CHR(13) + CHR(10)

cAnexo:= ""


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


Return






