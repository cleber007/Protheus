//Remark: Computadores nใo cometem erros.
#include "ap5mail.ch"
#INCLUDE "RWMAKE.CH"
#Include "Totvs.ch"
#include "tbiconn.ch"
#include "TbiCode.ch"    
#INCLUDE "TOPCONN.CH"

STATIC aTamSxg


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  MTR110Graph()  บAutor  Denis Haruo     บ Data ณ  04/15/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressใo do Pedido de Compras em modelo grafico            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MTR110Graph(cAlias,nReg,nOpcx)
                       
LOCAL wnrel		:= "MAT110R"
LOCAL cDesc1	:= "Emissao dos pedidos de compras ou autorizacoes de entrega"
LOCAL cDesc2	:= "cadastradados e que ainda nao foram impressos"
LOCAL cDesc3	:= " "
LOCAL cString	:= "SC7"

Local oButton1
Local oGroup1
Local oPanel1
Local oSay1
Local oSay2
Local oSay3
Static oDlg

PRIVATE lAuto		:= (nReg!=Nil)
PRIVATE Tamanho		:="M"
PRIVATE titulo	 	:= "Emissao dos Pedidos de Compras ou Autorizacoes de Entrega"
PRIVATE aReturn 	:= {"Zebrado", 1,"Administracao", 2, 2, 1, "",0 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog	:="MAT110R"
PRIVATE nLastKey	:= 0
PRIVATE nBegin		:= 0
PRIVATE aLinha		:= {}
PRIVATE aSenhas		:= {}
PRIVATE aUsuarios	:= {}
PRIVATE nPAG	:= 1
Private cMsgPed     := ""
Private AtivaNegrito := "(s3B"
Private DesativaNegrito := "(s0B"

Private oPrint
Private oArial8 := TFont():New("Arial",,8,.T.)  
Private oArial8b:= TFont():New("Arial",,8,,.T.)  
Private oArial10 := TFont():New("Arial",,10,.T.)  
Private oArial10b:= TFont():New("Arial",,10,,.T.)  
Private oArial11 := TFont():New("Arial",,11,.T.)  
Private oArial11b:= TFont():New("Arial",,11,,.T.)  
Private oArial12 := TFont():New("Arial",,12,.T.)  
Private oArial12b:= TFont():New("Arial",,12,,.T.)  
Private oArial18 := TFont():New("Arial",,18,.T.)  
Private oArial18b:= TFont():New("Arial",,18,,.T.)  

Private oCourier8b := TFont():New("Courier New",,8,.T.)  
Private oCourier8 := TFont():New("Courier New",,8,)  
Private nLin := 0

Private nDescProd := 0
Private nDespesa := 0
Private nTotal 	 := 0
Private _nICM	 := 0
Private _nIPI 	 := 0
Private _nFRE 	 := 0
Private _nICMSRET:= 0
Private _PROD := ""

Private oEmailTo
Private cEmailTo := Space(80)
Private oEmailTo2
Private cEmailto2 := Space(80)

aNFCab	:= {}
aNFItem	:= {}
aItemDec:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros                         ณ
//ณ mv_par01               Do Pedido                             ณ
//ณ mv_par02               Ate o Pedido                          ณ
//ณ mv_par03               A partir da data de emissao           ณ
//ณ mv_par04               Ate a data de emissao                 ณ
//ณ mv_par05               Somente os Novos                      ณ
//ณ mv_par06               Campo Descricao do Produto    	     ณ
//ณ mv_par07               Unidade de Medida:Primaria ou Secund. ณ
//ณ mv_par08               Imprime ? Pedido Compra ou Aut. Entregณ
//ณ mv_par09               Numero de vias                        ณ
//ณ mv_par10               Pedidos ? Liberados Bloqueados Ambos  ณ
//ณ mv_par11               Impr. SC's Firmes, Previstas ou Ambas ณ
//ณ mv_par12               Qual a Moeda ?                        ณ
//ณ mv_par13               Projeto COBRE ? (Sim ou Nใo)          ณ		//--> Luiz.SigaCorp em 23/07/2014
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Pergunte("MTR110",.T.)           
       
If lAuto
	mv_par08 := SC7->C7_TIPO
EndIf

NumPed   := Space(6)
If lAuto
	dbSelectArea("SC7")
	dbGoto(nReg)
	SetRegua(1)
	mv_par01 := C7_NUM
	mv_par02 := C7_NUM
	mv_par03 := C7_EMISSAO
	mv_par04 := C7_EMISSAO
	mv_par05 := 2
	mv_par08 := C7_TIPO
	mv_par09 := 1
	mv_par10 := 3
	mv_par11 := 3
EndIf

_IMPRIME:=.T.
dbSelectArea("SC7")
dbSetOrder(1)
dbSeek(xFilial("SC7")+MV_PAR01)

IF !FOUND()
	ALERT("Pedido inicial nao existe !!")
	_IMPRIME:=.F.
ENDIF

// Monta objeto para impressใo  
oPrint:=TMSPrinter():New("Impressao de PCs")  
oPrint:setPaperSize(DMPAPER_A4)
oPrint:SetPortrait()  
oPrint:Setup()     

If mv_par08 == 1 //Impressใo de Pedidos de Compra, Tipo = '1'
    
	cQuery := ""
	cQuery += " SELECT DISTINCT(C7_NUM) AS NUMPC FROM "+RetSQLName("SC7")+" "
	cQuery += "	WHERE 	C7_FILIAL = '"+xFilial("SC7")+"' AND "
	cQuery += " 		C7_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
	cQuery += "			C7_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' AND "    
	cQuery += "			C7_TIPO = '1' AND "
	If MV_PAR05 == 1 //Somente os novos? (Sim)
		cQuery += "		C7_EMITIDO <> 'S' AND "
	EndIf
	IF MV_PAR10 == 1 //Pedidos? Liberados, Bloqueados ou Ambos
		cQuery += "		C7_CONAPRO <> 'L' AND "								
	ElseIf 	MV_PAR10 == 2
		cQuery += "		C7_CONAPRO <> 'B' AND "								
	EndIf
	cQuery += "			D_E_L_E_T_ <> '*' "
	cQuery += "	ORDER BY C7_NUM "
	TCQuery cQuery NEW ALIAS "QRY"
	DBSelectArea("QRY")
	Do While !EOF()
		For nVias:=1 to mv_par09
			ImprimePC(QRY->NUMPC,nVias)
		Next  

		cEmailTo := SPACE(80)
		cEmailTo2:= SPACE(80)
		_Investim:= SPACE(06)
	  	_cAREA:=ALIAS()
		
		DBSELECTAREA("SC1")
		DBSETORDER(1)
		DBSEEK(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC)
		IF FOUND() .AND. LEFT(C1_ORIGEM,7)="MATA106"        // GERADO VIA SA-SOLICITACAO AO ALMOX (RCM)
			DBSELECTAREA("SCP")
			DBSETORDER(1)
			SET FILTER TO CP_NUMSC=SC1->C1_NUM
			DBGOTOP()
			cEmailTo := ALLTRIM(CP_APROVAD)
			cEmailTo2:= ALLTRIM(CP_EMAIL)
			_Investim:= SC1->C1_COMPRAD     // CONTA DE INVESTIMENTO
			SET FILTER TO
		ENDIF

	 	DBSelectArea("SC7")

		DEFINE MSDIALOG oDlg TITLE "Envia E-mail" FROM 000, 000  TO 160, 425 COLORS 0, 16777215 PIXEL
			@ 000, 000 MSPANEL oPanel1 SIZE 215, 080 OF oDlg COLORS 0, 12632256 RAISED
    		@ 006, 004 GROUP oGroup1 TO 059, 211 PROMPT " E-mail ao solicitante " OF oPanel1 COLOR 0, 12632256 PIXEL
    		@ 022, 010 SAY oSay1 PROMPT "Para: " SIZE 020, 007 OF oPanel1 COLORS 0, 12632256 PIXEL
    		@ 020, 036 MSGET oEmailTO VAR cEmailTO SIZE 150, 010 OF oPanel1 COLORS 0, 16777215 PIXEL F3 "SAK2"
    		@ 036, 010 SAY oSay2 PROMPT "C/C.: " SIZE 019, 007 OF oPanel1 COLORS 0, 12632256 PIXEL
    		@ 035, 036 MSGET oEmailTO2 VAR cEmailTO2 SIZE 150, 010 OF oPanel1 COLORS 0, 16777215 PIXEL
    		@ 063, 174 BUTTON oButton1 PROMPT "Enviar" SIZE 037, 012 OF oPanel1 PIXEL Action oDlg:End()
    		//@ 070, 005 SAY oSay3 PROMPT "Powered by Sigacorp" SIZE 064, 007 OF oPanel1 COLORS 8421504, 12632256 PIXEL
		ACTIVATE MSDIALOG oDlg CENTERED

		cEmailTo := ALLTRIM(cEmailTo)
		cEmailTo2:= ALLTRIM(cEmailTo2)
		IF EMPTY(cEmailTo)
			cEmailTo := Iif(Upper(GetEnvServer())=="TOTVS.JEAN","jean.rocha@totvs.com.br","dorcas.xavier@alubar.net")
		else
			cEmailTo := Iif(Upper(GetEnvServer())=="DENIS.SIGACORP","denis.sigacorp@alubar.net",cEmailTo+";dorcas.xavier@alubar.net")
			cEmailTo := Iif(Upper(GetEnvServer())=="TOTVS.JEAN","jean.rocha@totvs.com.br",cEmailTo+";dorcas.xavier@alubar.net")
		ENDIF

		IF !EMPTY(cEmailTo2)
			cEmailTo:=cEmailTo+";"+cEmailTo2
		endif

		IF !EMPTY(cEmailTo)
			ENVIAEMAIL()
		ENDIF

		oPrint:Preview()
		DBSelectArea("QRY")
		DBSkip()
	EndDo
	QRY->(DBCloseArea())
	
Else
	RptStatus({|lEnd| C110AE(@lEnd,wnRel,cString,nReg)},titulo)
EndIf

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTR110GRAPHบAutor  ณMicrosiga           บ Data ณ  04/15/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
    
Static Function ImprimePC(cNumPC,nVias)

ImpCabec(cNumPC,nVias)
ImpDetal(cNumPC) 
ImpRodap(cNumPC)

Return()


/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTR110GRAPHบAutor  ณMicrosiga           บ Data ณ  04/20/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpCabec(cNumPC,nVias)
           
Local nCol := 10
nLin := 50


//Iniciando a pagina
oPrint:StartPage()

//Box do pedido
oPrint:Box(nLin,nCol,nLin+110,nCol+2300)
oPrint:Say(nLin+10,nCol+700, "P E D I D O  D E  C O M P R A  -  REAIS | Num: "+cNumPC,oArial8b)
oPrint:Say(nLin+50,nCol+1000, "2a. Emissใo | "+cValToChar(nVias)+"a Via" ,oArial8)
oPrint:Say(nLin+50,nCol+2200,"Pag: "+cValToChar(nPag),oArial8,,,,1)

//Box INFO Cliente ALUBAR

//aEmpresa: FWArrFilAtu()

nLin:=160
oPrint:Box(nLin,nCol,nLin+170,nCol+900)
nLin+=10
oPrint:Say(nLin,nCol+10,"ALUBAR Metais e Cabos S/A" ,oArial8b)
nLin+=30
oPrint:Say(nLin,nCol+10,"Rodovia PA 481 KM 2,3" ,oArial8)
nLin+=30
oPrint:Say(nLin,nCol+10,"CEP: 68445-000 - Barcarena - PA" ,oArial8)
nLin+=30
oPrint:Say(nLin,nCol+10,"TEL: 55-91-3754 7100 / FAX: 55-91-3754 7124" ,oArial8)
nLin+=30
oPrint:Say(nLin,nCol+10,"CGC: 08.262.121/0001-13 I.E.: 152.554.173" ,oArial8)

//Box INFO Fornecedor   
DBSelectArea("SC7")
DBSetOrder(1)
DBSeek(xFilial("SC7")+cNumPc)
cNomeFor   := Alltrim(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME"))
cInscricao := Alltrim(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_INSCR"))
cEndereco  := Alltrim(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_END"))
cBairro    := Alltrim(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_BAIRRO"))
cMunicipio := Alltrim(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_MUN"))
cEstado    := Alltrim(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_EST"))
cCEP       := Alltrim(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_CEP"))
cCEP       := SUBSTR(cCep,1,5)+"-"+SUBSTR(cCep,6,3)
cCNPJ      := Alltrim(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_CGC"))
cCNPJ := IIF( Len(cCNPJ)==14 ,;
			" - CNPJ: "+Transform(cCNPJ,"@R 99.999.999/9999-99"),;
			" - CPF: "+Transform(cCNPJ,"@R 99.999.999.999"))

cFone := Alltrim(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_TEL"))
cFax := Alltrim(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_FAX"))
cContato := Alltrim(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_CONTATO"))

nLin:=160
oPrint:Box(nLin,nCol+900,nLin+170,nCol+2300)
nLin+=10
oPrint:Say(nLin,nCol+910,cNomeFor,oArial8b)
nLin+=30
oPrint:Say(nLin,nCol+910,cEndereco+" - "+cBairro,oArial8)
nLin+=30
oPrint:Say(nLin,nCol+910,cMunicipio+" - "+cEstado+" - CEP: "+cCep + cCNPJ +" - I.E.: "+ cInscricao ,oArial8)
nLin+=30
oPrint:Say(nLin,nCol+910,"Fone: "+cFone+" - Fax: "+cFax ,oArial8)
nLin+=30
oPrint:Say(nLin,nCol+910,"Contato: "+cContato ,oArial8)                

Return()   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTR110GRAPHบAutor  ณMicrosiga           บ Data ณ  04/23/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpDetal(cNumPC)

Local nCol := 10
Local nValMoeda := 0

nLin := 340

//Box Cabe็alho Detalhes
oPrint:Say(nLin,nCol+0000,"Item",oArial8b)
oPrint:Say(nLin,nCol+0100,"C๓digo",oArial8b)
oPrint:Say(nLin,nCol+0300,"Descri็ใo",oArial8b)
oPrint:Say(nLin,nCol+1250,"UM",oArial8b)
oPrint:Say(nLin,nCol+1450,"Quant",oArial8b,,,,1)
oPrint:Say(nLin,nCol+1650,"Valor Unit",oArial8b,,,,1)
oPrint:Say(nLin,nCol+1750,"IPI%",oArial8b,,,,1)
oPrint:Say(nLin,nCol+1950,"Valor Total",oArial8b,,,,1)
oPrint:Say(nLin,nCol+2000,"Entrega",oArial8b)
oPrint:Say(nLin,nCol+2130,"C.C.",oArial8b)
oPrint:Say(nLin,nCol+2220,"S.C.",oArial8b)
nLin+=50                
oPrint:Line(nLin,nCol,nLin,nCol+2300)
nLin+=30                

//Zerando totaliadores
nTotal:= _nICM:= _nIPI:= _nFRE:= _nICMSRET:= nDESPESA:= 0
_PROD := ""

DBSelectArea("SC7")
DBSetOrder(1)
DBSeek(xFilial("SC7")+cNumPC)
Do While !EOF() .and. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+cNumPC   
    
    If nLin > 2700
    	oPrint:EndPage()
    	oPrint:StartPage()
    	nPag++
	    ImpCabec(cNumPC)
		nLin := 340
		
	    //Box Cabe็alho Detalhes
		oPrint:Say(nLin,nCol+0000,"Item",oArial8b)
		oPrint:Say(nLin,nCol+0100,"C๓digo",oArial8b)
		oPrint:Say(nLin,nCol+0300,"Descri็ใo",oArial8b)
		oPrint:Say(nLin,nCol+1250,"UM",oArial8b)
		oPrint:Say(nLin,nCol+1450,"Quant",oArial8b,,,,1)
		oPrint:Say(nLin,nCol+1650,"Valor Unit",oArial8b,,,,1)
		oPrint:Say(nLin,nCol+1750,"IPI%",oArial8b,,,,1)
		oPrint:Say(nLin,nCol+1950,"Valor Total",oArial8b,,,,1)
		oPrint:Say(nLin,nCol+2000,"Entrega",oArial8b)
		oPrint:Say(nLin,nCol+2130,"C.C.",oArial8b)
		oPrint:Say(nLin,nCol+2220,"S.C.",oArial8b)
		nLin+=50                
		oPrint:Line(nLin,nCol,nLin,nCol+2300)
		nLin+=30                

	EndIf    
    
    nInc := 0 	//Incremento de linhas 
	aDesc := {} //Descri็ใo do produto
	
	_PROD:= _PROD + (ALLTRIM(STR(C7_QUANT,12,0)) +" - "+ ALLTRIM(C7_DESCRI)+CHR(13) + CHR(10))
	
	aAdd(aDesc,SubStr(Alltrim(SC7->C7_DESCRI),1,50))
	aAdd(aDesc,SubStr(Alltrim(SC7->C7_DESCRI),51,100))
	aAdd(aDesc,SubStr(Alltrim(SC7->C7_DESCRI),101,150))

	oPrint:Say(nLin,nCol+0000,SC7->C7_ITEM,oArial8)
	oPrint:Say(nLin,nCol+0100,SC7->C7_PRODUTO,oArial8)
    If Len(aDesc[1]) > 0
    	oPrint:Say(nLin,nCol+0300,aDesc[1],oArial8) 
	EndIf
    If Len(aDesc[2]) > 0
    	nInc+=30
    	oPrint:Say(nLin+nInc,nCol+0300,aDesc[2],oArial8) 
	EndIf
    If Len(aDesc[3]) > 0
    	nInc+=30
    	oPrint:Say(nLin+nInc,nCol+0300,aDesc[3],oArial8) 
	EndIf            
	               
	//Unidade de Medida
	If MV_PAR07 == 2 .And. !Empty(SC7->C7_SEGUM)
		oPrint:Say(nLin,nCol+1250,SC7->C7_SEGUM,oArial8)
	Else
		oPrint:Say(nLin,nCol+1250,SC7->C7_UM,oArial8)
	EndIf
	
	//Quantidade
	If MV_PAR07 == 2 .And. !Empty(SC7->C7_QTSEGUM)
		oPrint:Say(nLin,nCol+1450,Transform(SC7->C7_QTSEGUM,"@R 999,999,999.99"),oArial8,,,,1)
	Else
		oPrint:Say(nLin,nCol+1450,Transform(SC7->C7_QUANT,"@R 999,999,999.99"),oArial8,,,,1)
	EndIf
 
 	//Preco Unitแrio
 	If MV_PAR07 == 2 .And. !Empty(SC7->C7_QTSEGUM)
 		nValMoeda := xMoeda((SC7->C7_TOTAL/SC7->C7_QTSEGUM),SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF)
		oPrint:Say(nLin,nCol+1650,Transform(nValMoeda,"@R 999,999,999.99"),oArial8,,,,1)
	Else
        nValMoeda := xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF)
		oPrint:Say(nLin,nCol+1650,Transform(nValMoeda,"@R 999,999,999.99"),oArial8,,,,1)
	EndIf
 	
    //IPI
	If mv_par08 == 1                        
	    nValMoeda := xMoeda(SC7->C7_IPI,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF)
		oPrint:Say(nLin,nCol+1750,Transform(nValMoeda,"@R 99")              ,oArial8,,,,1)
	    nValMoeda := xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF)
		oPrint:Say(nLin,nCol+1950,Transform(nValMoeda,"@R 999,999,999.99"),oArial8,,,,1)
        If FieldPos("C7_ENTREGA") > 0 
        	oPrint:Say(nLin,nCol+2000,DTOC(SC7->C7_ENTREGA),oArial8)
        EndIf
		oPrint:Say(nLin,nCol+2130,SC7->C7_CC,oArial8)
		oPrint:Say(nLin,nCol+2200,SC7->C7_NUMSC,oArial8)
	Else                               
	    nValMoeda := xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF)
		oPrint:Say(nLin,nCol+1950,Transform(SC7->C7_TOTAL,"@R 999,999,999.99"),oArial8,,,,1)
		oPrint:Say(nLin,nCol+2000,DTOC(SC7->C7_ENTREGA),oArial8)
		oPrint:Say(nLin,nCol+2200,SC7->C7_OP,oArial8)
	EndIf                              
	nLin+=50+nInc  
	
	//Calculo de descontos
	If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
		nDescProd+= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
	Else
		nDescProd+=SC7->C7_VLDESC
	Endif        
	nDESPESA+=SC7->C7_DESPESA
	
	//Totais do rodap้
	nTotal 	 := nTotal + SC7->C7_TOTAL + SC7->C7_ICMSRET
	_nICM	 := _nICM+SC7->C7_VALICM
	_nIPI 	 := _nIPI+SC7->C7_VALIPI
	_nFRE 	 := _nFRE+SC7->C7_VALFRE
	_nICMSRET:= _nICMSRET + SC7->C7_ICMSRET

	DBSelectArea("SC7") 
	RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
	Replace C7_QTDREEM With (C7_QTDREEM+1)
	Replace C7_EMITIDO With "S"
	MsUnLock()
			
	DBSelectArea("SC7") 
	DBSkip()
End Do

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTR110GRAPHบAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpRodaP(cNumPC)

Local nCol := 10
Local cMsgPed := ""
Local cCondPgto := ""
Local cDescPgto := ""  
Local nSubTrib := 0
Local cobs := ""
Local cComprador := ""
Local cDataLib := ""

Local nTotDesc	:= nDescProd
Local nTotalNF	:= nTotal
Local nTotIpi	:= _nIPI
Local nTotIcms	:= _nICM
Local nTotDesp	:= nDESPESA
Local nTotFrete	:= _nFRE 
Local nTotICMRET:= _nICMSRET 
Local nTotSeguro:= 0 //MaFisRet(,'NF_SEGURO')


DBSelectArea("SC7")
DBSetOrder(1)
DBSeek(xFilial("SC7")+cNumPC)               
dDtEmissao := SC7->C7_EMISSAO 
nSubTrib := SC7->C7_ICMCOMP 
cObs1 := SubStr(SC7->C7_OBS,1,100)
cObs2 := SubStr(SC7->C7_OBS,101,200)
cObs := cObs1+cObs2
cValICMRET := IIF(_nICMSRET > 0, " - VALOR DE ICMS SUBST TRIB: R$ " + Alltrim(Transform (_nICMSRET, "@R 99,999,999.99")),"" )
cObs := Alltrim(cObs)+cValICMRET
cComprador := Alltrim(&('UsrFullName(SC7->C7_USER)'))
cGerente := Alltrim(&('UsrFullName(SC7->C7_USER)'))
cDiretor := Alltrim(&('UsrFullName(SC7->C7_USER)'))
cDataLib := DTOC(SC7->C7_DTAPRV3)+" as "+SC7->C7_HRAPRV3

If !Empty(SC7->C7_MSG)
	DbSelectArea("SM4")
	DbSetOrder(1)
	DbSeek(xFilial("SM4")+SC7->C7_MSG,.T.)
	cMsgPed := Trim(M4_FORMULA)
EndIf	
	
dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial()+SC7->C7_COND)
cCondPagto := Alltrim(SE4->E4_COND)
cDescPagto := Alltrim(SE4->E4_DESCRI)		

//Box Endere็o de entrega e cobran็a
nLin+=100
oPrint:Box(nLin,nCol,nLin+110,nCol+2300)
oPrint:Say(nLin+010,nCol+010,"Entrega: ",oArial8b)
oPrint:Say(nLin+010,nCol+170,cMsgPed,oArial8)
oPrint:Say(nLin+060,nCol+10,"Cobran็a: ",oArial8b)
oPrint:Say(nLin+060,nCol+170,ALLTRIM(SM0->M0_ENDCOB)+" - "+Alltrim(SM0->M0_CIDCOB)+" - "+Alltrim(SM0->M0_ESTCOB)+" - CEP: "+Alltrim(SM0->M0_CEPCOB),oArial8)

//Box Cond pag, dt entrega, total merc
nLin+=110                            
oPrint:Box(nLin,nCol,nLin+60,nCol+760)
oPrint:Say(nLin+010,nCol+10,"Condi็ใo de Pagto: ",oArial8b)
oPrint:Say(nLin+010,nCol+300,cCondPagto+" - "+cDescPagto,oArial8,,,,)

oPrint:Box(nLin		,nCol+760,nLin+60,nCol+1520)
oPrint:Say(nLin+010	,nCol+770,"Data Emissใo: ",oArial8b)
oPrint:Say(nLin+010	,nCol+1400,DTOC(dDtEmissao),oArial8,,,,1)

oPrint:Box(nLin		,nCol+1520,nLin+60,nCol+2300)
oPrint:Say(nLin+010	,nCol+1530,"Total das Mercadorias: ",oArial8b)
oPrint:Say(nLin+010	,2200,Transform(nTotalNF,"@E 999,999,999.99"),oArial8,,,,1)

                             
nLin+=60                           
//Box IPI
oPrint:Box(nLin,nCol,nLin+60,nCol+0570)
oPrint:Say(nLin+010	,nCol+10,"IPI:",oArial8b)
oPrint:Say(nLin+010	,0570,Transform(xMoeda(nTotIPI,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 999,999,999.99"),oArial8,,,,1)

//ICMS
oPrint:Box(nLin		,nCol+0570,nLin+60,nCol+1140)
oPrint:Say(nLin+010	,nCol+0580,"ICMS:",oArial8b)
oPrint:Say(nLin+010	,1130,Transform(xMoeda(nTotICMS,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 999,999,999.99"),oArial8,,,,1)

//S.T.
oPrint:Box(nLin,nCol+1140,nLin+60,nCol+1710)
oPrint:Say(nLin+010	,nCol+1150,"S.T.:",oArial8b)
oPrint:Say(nLin+010	,1700,Transform(xMoeda(nSubTrib,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 999,999,999.99"),oArial8,,,,1)

//DESPESAS
oPrint:Box(nLin,nCol+1710,nLin+60,nCol+2300)
oPrint:Say(nLin+010	,nCol+1720,"Despesas:",oArial8b)
oPrint:Say(nLin+010	,2200,Transform(xMoeda(nTotDesp,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 999,999,999.99"),oArial8,,,,1)

nLin+=60                           
//Box FRETE
oPrint:Box(nLin,nCol,nLin+60,nCol+0570)
oPrint:Say(nLin+010	,nCol+10,"FRETE:",oArial8b)
oPrint:Say(nLin+010	,0570,Transform(xMoeda(nTotFRETE,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 999,999,999.99"),oArial8,,,,1)

//DESCONTO
oPrint:Box(nLin		,nCol+0570,nLin+60,nCol+1140)
oPrint:Say(nLin+010	,nCol+0580,"Desconto:",oArial8b)
oPrint:Say(nLin+010	,1130,Transform(xMoeda(nTotDesc,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 999,999,999.99"),oArial8,,,,1)

//SEGURO
oPrint:Box(nLin,nCol+1140,nLin+60,nCol+1710)
oPrint:Say(nLin+010	,nCol+1150,"Seguro:",oArial8b)
oPrint:Say(nLin+010	,1700,Transform(xMoeda(nTotSeguro,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 999,999,999.99"),oArial8,,,,1)  

//TOTAL GERAL
oPrint:Box(nLin,nCol+1710,nLin+60,nCol+2300)
oPrint:Say(nLin+010	,nCol+1720,"Total Geral:",oArial8b)
oPrint:Say(nLin+010	,2200,Transform(xMoeda(nTotalNF+nSubTrib,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),"@E 999,999,999.99"),oArial8,,,,1)

If Len(Alltrim(cObs)) > 0                
	nLin+=100            
	If Len(Alltrim(cObs)) > 100
		oPrint:Say(nLin,nCol,"Observa็๕es: "+SubStr(cObs,1,100),oArial8)
		nLin+=40	
		oPrint:Say(nLin,nCol,SubStr(cObs,101,200),oArial8)
	Else		
		oPrint:Say(nLin,nCol,"Observa็๕es: "+cObs,oArial8)
    EndIf
EndIf	

nLin+=60                           
//Box Comprador
oPrint:Box(nLin,nCol,nLin+100,nCol+460)
oPrint:Say(nLin+010,nCol+10,"Comprador:",oArial8b)
oPrint:Say(nLin+050,nCol+10,cComprador,oArial8)

//Gerencia
oPrint:Box(nLin,nCol+460,nLin+100,nCol+920)
oPrint:Say(nLin+010	,nCol+470,"Gerencia:",oArial8b)
oPrint:Say(nLin+050	,nCol+470,"",oArial8)

//Diretoria
oPrint:Box(nLin,nCol+920,nLin+100,nCol+1380)
oPrint:Say(nLin+010	,nCol+930,"Diretoria:",oArial8b)
oPrint:Say(nLin+050	,nCol+930,"",oArial8)  

//Libera็ใo do Pedido
oPrint:Box(nLin,nCol+1380,nLin+100,nCol+1840)
oPrint:Say(nLin+010	,nCol+1390,"Libera็ใo do Pedido:",oArial8b)
oPrint:Say(nLin+050	,nCol+1390,cDataLib,oArial8)

//Tipo Frete
oPrint:Box(nLin,nCol+1840,nLin+100,nCol+2300)
oPrint:Say(nLin+010	,nCol+1850,"Obs. do Frete",oArial8b)
oPrint:Say(nLin+050	,nCol+1850,IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " )),oArial8)
nLin+=100
nLinIni := nLin
    
nLin+=30
oPrint:Say(nLin,nCol+10,"Cond. Basicas de Fornecimento:",oArial8b)
nLin+=60
oPrint:Say(nLin,nCol+10,"Atrasos: Nใo serใo tolerados atrasos na entrega nใo justificados previamente pelo Fornecedor e aceitos pelo Comprador.",oArial8)
If mv_par15 = 2

	nLin+=30
	oPrint:Say(nLin,nCol+10,"Multa: Vencido o prazo estabelecido para entrega do material/equipamento o preco sofrerแ redu็ใo de 0,33% (trinta e tr๊s por cento) por dia de atraso, contados a partir do vencimento",oArial8)
	nLin+=30
	oPrint:Say(nLin,nCol+10,"do prazo estabelecido sobre o valor correspondente, serแ de deduzida por ocasiใo do pagamento at้ o limite de 10% (dez por cento).",oArial8)
	nLin+=30
	oPrint:Say(nLin,nCol+10,"O atraso no fornecimento ou de parcela deste, em prazo superior a 30 dias, caracteriza a inexecu็ใo do Pedido de Compra, podendo esta Sociedade a seu exclusivo crit้rio, cancelแ-la ",oArial8)
	nLin+=30
	oPrint:Say(nLin,nCol+10,"total ou parcialmente. Pela inexecu็ใo total do  Pedido de Compra ou sobre o saldo remanescente, independentemente de outras penalidades cabํveis.",oArial8)
	nLin+=60

ElseIf mv_par15 = 1		//--> Projeto COBRE                                                                                 

	nLin+=30
	oPrint:Say(nLin,nCol+10,"Multa: Vencido o prazo estabelecido para entrega do material/equipamento o pre็o sofrerแ redu็ใo de 0,165%  por  dia  de atraso, sendo aplicavel tal condicao ap๓s vencimento de carencia",oArial8)
	nLin+=30
	oPrint:Say(nLin,nCol+10,"de 15 dias apos o prazo de entrega  estabelecido, sobre  o valor correspondente, serแ deduzida por o ocasiใo do pagamento ate o limite de 5%(cinco por cento).",oArial8)
	nLin+=30
	oPrint:Say(nLin,nCol+10,"Ap๓s o vencimento da car๊ncia e do prazo de 30 dias onde sera aplicada multa por atraso  diแrio,  as  partes  se  re๚nem  e acertam um novo prazo de entrega dos equipamentos,",oArial8)
	nLin+=30
	oPrint:Say(nLin,nCol+10,"e se esse segundo prazo de entrega nao for respeitado, o pedido do item nใo entregue poderแ ser cancelado.",oArial8)
	nLin+=60
	
EndIf   
oPrint:Box(nLinIni,nCol,nLin,nCol+2300)
oPrint:Box(nLin,nCol,nLin+60,nCol+2300)
oPrint:Say(nLin+20,nCol+10,"NOTA: S๓ aceitaremos a mercadoria se na sua Nota Fiscal constar o n๚mero do nosso Pedido de Compras.",oArial8)

oPrint:EndPage()
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณENVIAEMAIL บAutor  Denis Tsuchiya     บ Data ณ  04/30/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia e-mail atraves do SendMail                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION ENVIAEMAIL()

Local lResult  := .f.							// Resultado da tentativa de comunicacao com servidor de E-Mail
Local cTitulo1
Local lRelauth := GetNewPar("MV_RELAUTH",.F.)	// Parametro que indica se existe autenticacao no e-mail
Local cEmailBcc:= ""
Local cError   := ""
Local lRelauth := GetNewPar("MV_RELAUTH",.F.)	// Parametro que indica se existe autenticacao no e-mail
Local lRet	   := .F.
Local cFrom	   := GetMV("MV_RELACNT")
Local cConta   := GetMV("MV_RELACNT")
Local cSenhaX  := GetMV("MV_RELPSW")
Local lFirst   := .T.
Local cRotina  := "U_"+ProcName(7)

IF EMPTY(_PROD)
	RETURN Nil
ENDIF

IF SUBSTR(CUSUARIO,7,06)="MACEDO"
	cFROM  :=cFROM  +SPACE(50)
	cSenhaX:=cSenhaX+SPACE(50)
	@ 1,1 to  300,300 DIALOG oDlg200 TITLE "REMETENTE"
	@ 30, 18 SAY "FROM :"
	@ 44, 20 GET cFROM   SIZE 100,15
	@ 60, 18 SAY "SENHA:"
	@ 74, 20 GET cSENHAX SIZE 100,15
	
	@ 86, 20 GET cEmailTO SIZE 100,15
	
	@ 99, 90 BmpButton Type 1 Action Close(oDlg200)
	Activate Dialog oDlg200 Centered
	cFROM  :=ALLTRIM(cFROM)
	cSenhaX:=ALLTRIM(cSenhaX)
	cCONTA :=cFROM
	IF EMPTY(cEmailTO)
		RETURN
	ENDIF
ENDIF


cTitulo1 := "Gerado Ped Compra em "+DTOC(SC7->C7_EMISSAO)+" da sua SC : "+SC7->C7_NUMSC
cMensagem:=             "Caro Sr.(a) "+cEmailTo+CHR(13) + CHR(10)
cMensagem:= cMensagem + "                             "+CHR(13) + CHR(10)
cMensagem:= cMensagem + "Foi Aberto PC No..: "+SC7->C7_NUM + CHR(13) + CHR(10)
cMensagem:= cMensagem + "Emitido em........: "+DTOC(SC7->C7_EMISSAO) + CHR(13) + CHR(10)
cMensagem:= cMensagem + "Para o Fornecedor.: "+ALLTRIM(POSICIONE("SA2",1,XFILIAL("SA2")+SC7->C7_FORNECE ,"A2_NOME"))+ CHR(13) + CHR(10)
cMensagem:= cMensagem + "Previsao Embarque.: "+DTOC(SC7->C7_DATPRF) + CHR(13) + CHR(10)
cMensagem:= cMensagem + "                             "+CHR(13) + CHR(10)
IF !EMPTY(_Investim)
	cMensagem:= cMensagem + "Investimento......: "+_Investim +"-"+POSICIONE("ZZE",1,XFILIAL("ZZE")+_Investim,"ZZE_DESC")+ CHR(13) + CHR(10)
	cMensagem:= cMensagem + "                             "+CHR(13) + CHR(10)
ENDIF
cMensagem:= cMensagem + "Qualquer d๚vida sobre o andamento, favor contactar-nos. Emitido por "+ALLTRIM(SUBSTR(cUsuario,7,15))+"."+ CHR(13) + CHR(10)
cMensagem:= cMensagem + "                             "+CHR(13) + CHR(10)
cMensagem:= cMensagem + "DESCRIวรO DO PEDIDO : "+ CHR(13) + CHR(10)
cMensagem:= cMensagem + _PROD

cAnexo:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Tenta conexao com o servidor de E-Mail ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
CONNECT SMTP                         ;
SERVER 	 GetMV("MV_RELSERV"); 	// Nome do servidor de e-mail
ACCOUNT  GetMV("MV_RELACNT"); 	// Nome da conta a ser usada no e-mail
PASSWORD GetMV("MV_RELPSW") ; 	// Senha
RESULT   lResult             	// Resultado da tentativa de conexใo

// Se a conexao com o SMPT esta ok
If lResult
	
	// Se existe autenticacao para envio valida pela funcao MAILAUTH
	If lRelauth
		lRet := Mailauth(cConta,cSenhaX)
	Else
		lRet := .T.
	Endif
	
	//**Desabilitado por Denis em 17 jul 2013 - Marco.berna recebendo e-mails de pedidos da Alubar Energia (deveria ser somente a CABOS)
	If lRet
		SEND MAIL FROM 	cFrom ;
		TO 				cEmailTo; //+";marco.berna@alubar.net"; //RAFAEL ALMEIDA - 05/07/13
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
		MsgStop("Erro de autentica็ใo","Verifique a conta e a senha para envio")
	Endif
	
	DISCONNECT SMTP SERVER
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	MsgStop("Erro de CONEXAO COM SMTP","ERRO DE CONEXAO COM SMTP...")
Endif


Return

