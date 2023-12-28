#include "rwmake.ch"
//#INCLUDE "TOPCONN.CH"
//#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPER030  ³ Autor ³ R.H. - Ze Maria       ³ Data ³ 14.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao de Recibos de Pagamento                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GPER030(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function GPER030L()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cString:="SRA"        // alias do arquivo principal (Base)
Local aOrd   := {"Matricula","C.Custo","Nome","C.Custo + Nome"}
Local cDesc1 := "Emiss„o de Recibos de Pagamento."
Local cDesc2 := "Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3 := "usuario."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nExtra,cIndCond,cIndRc
Local Baseaux := "S", cDemit := "N"
Public _oPrint

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o numero da linha de impressão como 0                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//SetPrc(0,0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }	//"Zebrado"###"Administra‡„o"
Private nomeprog :="GPER030"
Private aLinha   := { },nLastKey := 0
Private cPerg    :="RELLAS"
Private cSem_De  := "  /  /    "
Private cSem_Ate := "  /  /    "
Private nAteLim , nBaseFgts , nFgts , nBaseIr , nBaseIrFe
Private cCompac , cNormal
Private aDriver

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aFunc := {}
Private aProve := {}
Private aDesco := {}
Private aBases := {}
Private aInfo  := {}
Private aCodFol:= {}
Private li     := _PROW()
Private Titulo := "EMISSAO DE RECIBOS DE PAGAMENTOS"
Private nTamanho	:= "M"
Private limite		:= 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="RELLAS"            //Nome Default do relatorio em Disco

CriaPerg(cPerg)

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a Ordem do Relatorio                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem :=  aReturn[8]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If Pergunte("RELLAS",.T.)

//Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dDataRef   := mv_par01
nTipRel    := 1
Esc        := mv_par02
cFilDe     := mv_par03		   					   									//Filial De
cFilAte    := mv_par04		   														//Filial Ate
cCcDe      := mv_par05		   														//Centro de Custo De
cCcAte     := mv_par06		   														//Centro de Custo Ate
cMatDe     := mv_par07		   														//Matricula Des
cMatAte    := mv_par08		   					   									//Matricula Ate
cNomDe     := mv_par09		   														//Nome De
cNomAte    := mv_par10		   					   									//Nome Ate
Mensag11   := substr(mv_par11,1,1)									 		//Mensagem 1
Mensag12   := substr(mv_par11,2,1)										 	//Mensagem 1
Mensag21   := substr(mv_par12,1,1)											//Mensagem 2
Mensag22   := substr(mv_par12,2,1)										 	//Mensagem 1
Mensag31   := substr(mv_par13,1,1)											//Mensagem 3
Mensag32   := substr(mv_par13,2,1)										 	//Mensagem 1
Mensag4   := mv_par14										   						//Mensagem 3
Mensag5   := mv_par15										  						//Mensagem 3

cSituacao  := mv_par16	//Situacoes a Imprimir
cCategoria := mv_par17	//Categorias a Imprimir
cBaseAux   := IF(mv_par18 == 1,"S","N")	
 
If aReturn[5] == 1 .and. nTipRel == 1
	li	:=  0
EndIf

cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa Impressao                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !fInicia(cString,nTipRel)
	Return
Endif


//MsgRun("Gerando relatório, aguarde...", "", {|| CursorWait(), R030IMPL(@lEnd,wnRel,cString,cMesAnoRef), CursorArrow()})

RptStatus({|lEnd| R030ImpL(@lEnd,wnRel,cString,cMesAnoRef)},Titulo)  // Chamada do Relatorio

Return(  NIL )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R030IMP  ³ Autor ³ R.H. - Ze Maria       ³ Data ³ 14.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento Para emissao do Recibo                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R030Imp(lEnd,WnRel,cString,cMesAnoRef,lTerminal)			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function R030ImpL(lEnd,WnRel,cString,cMesAnoRef)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lIgual                 //Vari vel de retorno na compara‡ao do SRC
Local cArqNew                //Vari vel de retorno caso SRC # SX3
Local aOrdBag     := {}
Local cMesArqRef  := If(Esc == 4,"13"+Right(cMesAnoRef,4),cMesAnoRef)
Local cArqMov     := ""
Local aCodBenef   := {}
Local cNroHoras   := &("{ || If(SRC->RC_QTDSEM > 0, SRC->RC_QTDSEM, SRC->RC_HORAS) }")
Local nHoras      := 0
Local nMes, nAno
Public cCodFunc	  := ""		//-- codigo da Funcao do funcionario
Public cDescFunc  := ""		//-- Descricao da Funcao do Funcionario
Public _n         := 1

Private cAliasMov := ""
Private cDtPago
Private cPict1	:=	"@E 999,999,999.99"
Private cPict2 := "@E 99,999,999.99"
Private cPict3 :=	"@E 999,999.99"
If MsDecimais(1) == 0
	cPict1	:=	"@E 99,999,999,999"
	cPict2 	:=	"@E 9,999,999,999"
	cPict3 	:=	"@E 99,999,999"
Endif

If Esc == 4
	cMesArqRef := "13" + Right(cMesAnoRef,4)
Else
	cMesArqRef := cMesAnoRef
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verifica se existe o arquivo de fechamento do mes informado  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !OpenSrc( cMesArqRef, @cAliasMov, @aOrdBag, @cArqMov, @dDataRef , NIL  )
	Return(  NIL  )
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando a Ordem de impressao escolhida no parametro.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRA")
If nOrdem == 1
	dbSetOrder(1)
ElseIf nOrdem == 2
	dbSetOrder(2)
ElseIf nOrdem == 3
	dbSetOrder(3)
ElseIf nOrdem == 4
	dbSetOrder(8)
Endif

dbGoTop()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando o Primeiro Registro e montando Filtro.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOrdem == 1
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	dbSeek(cFilDe + cMatDe,.T.)
	cFim    := cFilAte + cMatAte
ElseIf nOrdem == 2
	dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 3 
    cInicio := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	dbSeek(cFilDe + cNomDe + cMatDe,.T.)//alterei a ordem este era igual a opcao 2
	cFim    := cFilAte + cNomAte + cMatAte
ElseIf nOrdem == 4
	dbSeek(cFilDe + cCcDe + cNomDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME"
	cFim     := cFilAte + cCcAte + cNomAte
Endif

dbSelectArea("SRA")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua Processamento                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 SetRegua(RecCount())	// Total de elementos da regua

aFunc  :={}         // Zera Lancamentos
aProve :={}          // Zera Lancamentos
aDesco :={}         // Zera Lancamentos
aBases :={}         // Zera Lancamentos
aImpos :={}         // Zera Lancamentos
DESC_MSG:={}
FLAG:= CHAVE := 0

Desc_Fil   := Desc_End := DESC_CC:= DESC_FUNC:= ""
DESC_MSG1  := DESC_MSG2:= DESC_MSG3:= Space(01)
DESC_MSG4  := DESC_MSG5:= Space(62)
cFilialAnt := "  "
Vez        := 0
OrdemZ     := 0

While SRA->( !Eof() .And. &cInicio <= cFim )

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua Processamento                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	IncRegua()  // Anda a regua
	
	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste Parametrizacao do Intervalo de Impressao            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (SRA->RA_NOME < cNomDe)    .Or. (SRA->Ra_NOME > cNomAte)    .Or. ;
		(SRA->RA_MAT < cMatDe)     .Or. (SRA->Ra_MAT > cMatAte)     .Or. ;
		(SRA->RA_CC < cCcDe)       .Or. (SRA->Ra_CC > cCcAte)
		SRA->(dbSkip(1))
		Loop
	EndIf
	
	nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := 0.00
	
	Ordem_rel := 3     // Ordem dos Recibos
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Data Demissao         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSitFunc := SRA->RA_SITFOLH
	dDtPesqAf:= CTOD("01/" + Left(cMesAnoRef,2) + "/" + Right(cMesAnoRef,4))
	If cSitFunc == "D" .And. (!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA) > MesAno(dDtPesqAf))
		cSitFunc := " "
	Endif
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste situacao e categoria dos funcionarios			     |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !( cSitFunc $ cSituacao ) .OR.  ! ( SRA->RA_CATFUNC $ cCategoria )
		dbSkip()
		Loop
	Endif
	If cSitFunc $ "D" .And. Mesano(SRA->RA_DEMISSA) # Mesano(dDataRef)
		dbSkip()
		Loop
	Endif
	
	fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )
	 
	aAdd(aFunc,{SRA->RA_MAT,;
	Left(SRA->RA_NOME,28),;
	fCodCBO(SRA->RA_FILIAL,cCodFunc ,dDataRef),;
	SRA->RA_CC,;
 	Posicione("CTT",1,SRA->RA_FILIAL+SRA->RA_CC,"CTT_DESC01"),;
	SRA->RA_Filial ,;
	TRANSFORM(strzero(ORDEM_REL,3),"9999"),;
	cCodFunc,;
	cDescFunc,;
	SRA->RA_SALARIO,;
	MONTH(SRA->RA_NASC),;
	Substr(Sra->Ra_BcDepSal,1,3),;
	SRA->RA_BCDEPSAL,;
	SRA->RA_CTDEPSAL,;                                  
		}) 

	
	If SRA->RA_Filial # cFilialAnt
		If ! Fp_CodFol(@aCodFol,Sra->Ra_Filial) .Or. ! fInfo(@aInfo,Sra->Ra_Filial)
			Exit
		Endif
		Desc_Fil := aInfo[3]
		Desc_End := aInfo[4]                // Dados da Filial
		Desc_CGC := aInfo[8]
		DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
		DESC_MSG4:=DESC_MSG5:=Space(62)
		
		// MENSAGENS
		If MENSAG11 # SPACE(1) .or. MENSAG12 # SPACE(1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG11)
				DESC_MSG1 := Left(SRX->RX_TXT,30)
				If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG12)
					DESC_MSG1 := DESC_MSG1 + Left(SRX->RX_TXT,30)
				ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG12)
					DESC_MSG1 := DESC_MSG1 + Left(SRX->RX_TXT,30)
				Endif
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG11)
				DESC_MSG1 := Left(SRX->RX_TXT,30)
				If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG12)
					DESC_MSG1 := DESC_MSG1 + Left(SRX->RX_TXT,30)
				ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG12)
					DESC_MSG1 := DESC_MSG1 + Left(SRX->RX_TXT,30)
				Endif
			Endif
		Endif
		If MENSAG21 # SPACE(1) .or. MENSAG22 # SPACE(1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG21)
				DESC_MSG2 := Left(SRX->RX_TXT,30)
				If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG22)
					DESC_MSG2 := DESC_MSG2 + Left(SRX->RX_TXT,30)
				ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG22)
					DESC_MSG2 := DESC_MSG2 + Left(SRX->RX_TXT,30)
				Endif
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG21)
				DESC_MSG2 := Left(SRX->RX_TXT,30)
				If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG22)
					DESC_MSG2 := DESC_MSG2 + Left(SRX->RX_TXT,30)
				ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG22)
					DESC_MSG2 := DESC_MSG2 + Left(SRX->RX_TXT,30)
				Endif
			Endif
		Endif
		
		If MENSAG31 # SPACE(1) .or. MENSAG32 # SPACE(1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG31)
				DESC_MSG3 := Left(SRX->RX_TXT,30)
				If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG32)
					DESC_MSG3 := DESC_MSG3 + Left(SRX->RX_TXT,30)
				ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG32)
					DESC_MSG3 := DESC_MSG3 + Left(SRX->RX_TXT,30)
				Endif
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG31)
				DESC_MSG3 := Left(SRX->RX_TXT,30)
				If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG32)
					DESC_MSG3 := DESC_MSG3 + Left(SRX->RX_TXT,30)
				ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG32)
					DESC_MSG3 := DESC_MSG3 + Left(SRX->RX_TXT,30)
				Endif
			Endif
		Endif
		DESC_MSG4 := Mensag4
		DESC_MSG5 := Mensag5
		
		dbSelectArea("SRA")
		cFilialAnt := SRA->RA_FILIAL
	Endif
	aAdd(DESC_MSG,{DESC_MSG1,DESC_MSG2,DESC_MSG3,DESC_MSG4,DESC_MSG5})

/*---> Teste*/	
	_TOTVENC := 0
	_TOTDESC := 0
	
	If Esc == 1 .OR. Esc == 2  // adto ou folha
		dbSelectArea("SRC")
		dbSetOrder(1)
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
			While !Eof() .And. SRC->RC_FILIAL+SRC->RC_MAT == SRA->RA_FILIAL+SRA->RA_MAT
				If (Esc == 1) .And. (Src->Rc_Pd == aCodFol[7,1])      // Desconto de Adto
					//fSomaPd("P",aCodFol[6,1],Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
					_TOTVENC+=Src->Rc_Valor
				Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[12,1])
					//fSomaPd("D",aCodFol[9,1],Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
					_TOTDESC+=SRC->RC_VALOR
				Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[8,1])
					//fSomaPd("P",aCodFol[8,1],Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
					_TOTVENC+=Src->Rc_Valor
				Else
					If PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
						If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
							If cPaisLoc == "PAR" .and. Eval(cNroHoras) == 30
								LocGHabRea(Ctod("01/"+SubStr(DTOC(dDataRef),4)), Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Strzero(Month(dDataRef),2)+"/"+right(str(Year(dDataRef)),2)),@nHoras)
							Else
								nHoras := Eval(cNroHoras)
							Endif
							//fSomaPd("P",SRC->RC_PD,nHoras,SRC->RC_VALOR,SRC->RC_MAT)
							_TOTVENC+=Src->Rc_Valor
						Endif
					Elseif SRV->RV_TIPOCOD == "2"
						If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
							//fSomaPd("D",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
							_TOTDESC+=Src->Rc_Valor
						Endif
					Elseif SRV->RV_TIPOCOD == "3"
						If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
							//fSomaPd("B",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
						Endif
					Endif
				Endif
				If ESC = 1
					If SRC->RC_PD == aCodFol[10,1]
						nBaseIr := SRC->RC_VALOR
					Endif
				ElseIf SRC->RC_PD == aCodFol[13,1]
					nAteLim += SRC->RC_VALOR
				Elseif SRC->RC_PD$ aCodFol[108,1]+'*'+aCodFol[17,1]
					nBaseFgts += SRC->RC_VALOR
				Elseif SRC->RC_PD$ aCodFol[109,1]+'*'+aCodFol[18,1]
					nFgts += SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[15,1]
					nBaseIr += SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[16,1]
					nBaseIrFe += SRC->RC_VALOR
				Endif
				dbSelectArea("SRC")
				dbSkip()
			Enddo
		Endif
	Elseif Esc == 3
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Busca os codigos de pensao definidos no cadastro beneficiario³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		fBusCadBenef(@aCodBenef, "131",{aCodfol[172,1]})
		dbSelectArea("SRC")
		dbSetOrder(1)
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT == SRC->RC_FILIAL + SRC->RC_MAT
				If SRC->RC_PD == aCodFol[22,1]
					//fSomaPd("P",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
					_TOTVENC+=Src->Rc_Valor
				Elseif Ascan(aCodBenef, { |x| x[1] == SRC->RC_PD }) > 0
					//fSomaPd("D",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
					_TOTDESC+=SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[108,1] .Or. SRC->RC_PD == aCodFol[109,1] .Or. SRC->RC_PD == aCodFol[173,1]
					//fSomaPd("B",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
				Endif
				
				If SRC->RC_PD == aCodFol[108,1]
					nBaseFgts := SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[109,1]
					nFgts     := SRC->RC_VALOR
				Endif
				dbSelectArea("SRC")
				dbSkip()
			Enddo
		Endif
	Elseif Esc == 4
		dbSelectArea("SRI")
		dbSetOrder(2)
		If dbSeek(SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT)
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT == SRI->RI_FILIAL + SRI->RI_CC + SRI->RI_MAT
				If PosSrv( SRI->RI_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					//fSomaPd("P",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR,SRI->RI_MAT)
					_TOTVENC = _TOTVENC + SRI->RI_VALOR
				Elseif SRV->RV_TIPOCOD == "2"
					//fSomaPd("D",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR,SRI->RI_MAT)
					_TOTDESC = _TOTDESC + SRI->RI_VALOR
				Elseif SRV->RV_TIPOCOD == "3"
					//fSomaPd("B",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR,SRI->RI_MAT)
				Endif
				
				If SRI->RI_PD == aCodFol[19,1]
					nAteLim += SRI->RI_VALOR
				Elseif SRI->RI_PD$ aCodFol[108,1]
					nBaseFgts += SRI->RI_VALOR
				Elseif SRI->RI_PD$ aCodFol[109,1]
					nFgts += SRI->RI_VALOR
				Elseif SRI->RI_PD == aCodFol[27,1]
					nBaseIr += SRI->RI_VALOR
				Endif
				dbSkip()
			Enddo
		Endif
	Elseif Esc == 5
		dbSelectArea("SR1")
		dbSetOrder(1)
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT ==	SR1->R1_FILIAL + SR1->R1_MAT
				If PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					//fSomaPd("P",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR,SR1->R1_MAT)
					_TOTVENC = _TOTVENC + SR1->R1_VALOR
				Elseif SRV->RV_TIPOCOD == "2"
					//fSomaPd("D",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR,SR1->R1_MAT)
					_TOTDESC = _TOTDESC + SR1->R1_VALOR
				Elseif SRV->RV_TIPOCOD == "3"
					//fSomaPd("B",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR,SR1->R1_MAT)
				Endif
				dbskip()
			Enddo
		Endif
	Endif
	/*--------*/
	dbSelectArea("SRA")
	
	
	If nTipRel == 1
		If Vez = 0  .and. nTipRel # 3  .and. aReturn[5] # 1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Descarrega teste de impressao                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//_TOTDESC := 0
			//_TOTVENC := 0
			If mv_par01 = 2
				Loop
			Endif
		ENDIF
	Endif
	dbSelectArea("SRA")
	SRA->( dbSkip() )
	_TOTDESC := 0
	_TOTVENC := 0
	_n++
EndDo

fImpressaoL()   // Impressao do Recibo de Pagamento


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona arq. defaut do Siga caso Imp. Mov. Anteriores      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty( cAliasMov )
	fFimArqMov( cAliasMov , aOrdBag , cArqMov )
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SRC")
dbSetOrder(1)          // Retorno a ordem 1
dbSelectArea("SRI")
dbSetOrder(1)          // Retorno a ordem 1
dbSelectArea("SRA")
SET FILTER TO
RetIndex("SRA")

If !(Type("cArqNtx") == "U")
	fErase(cArqNtx + OrdBagExt())
Endif


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fImpressao³ Autor ³ R.H. - Ze Maria       ³ Data ³ 14.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO DO RECIBO FORMULARIO CONTINUO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fImpressao()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImpressaoL()

Local nConta  := nContr := nContrT:=0
Local aDriver := LEDriver()
Local _i            := 0
Local _aPos1        := {2000, 1900, 2100, 2300}
Local _aPos2        := {2270, 1900, 2340, 2300}
Local _aBmp := {}
Local _aEmp := {}
Local _oFont8   := Nil
Local _oFont10  := Nil
Local _oFont12  := Nil
Local _oFont16  := Nil
Local _oFont16n := Nil
Local _oFont24  := Nil
Local _oBrush   := Nil
Local cString   := ""
Local nCol := 0
Local _lmesmo := .F.
Local _cont:= 0
Local _pag := 0
Local Desc_Bco := ""
Private TOTVENC := {}
Private TOTDESC := {}
Private aLanca  := {}      
Private aImpos  := {}
Private aCodBenef   := {}//acrescentei essa variavel em 21/11/2008 cleo      
Private nLinhas:=19              // Numero de Linhas do Miolo do Recibo
Private cCompac := aDriver[1]
Private cNormal := aDriver[2]

//if M0_CODIGO 
IF SM0->M0_CODFIL = "01"     
   aAdd(_aBmp, "\sigaadv\lgrl01.bmp")	//Logo da empresa
ENDIF

IF SM0->M0_CODFIL = "02"     
   aAdd(_aBmp, "\sigaadv\lgrl02.bmp")	//Logo da empresa
ENDIF

aAdd(_aEmp, SM0->M0_NOMECOM)	//Nome da Empresa
aAdd(_aEmp, SM0->M0_ENDCOB + ", " +AllTrim(SM0->M0_BAIRCOB) )	//Endereço
aAdd(_aEmp, AllTrim(SM0->M0_CIDCOB) + ", " + SM0->M0_ESTCOB+ " , "+"CEP: " + Transform(SM0->M0_CEPCOB, "@R 99999-999")) //CEP
aAdd(_aEmp, "PABX/FAX: 55 " + SUBSTR(SM0->M0_TEL,3,2)+" "+SUBSTR(SM0->M0_TEL,5,4)+" "+SUBSTR(SM0->M0_TEL,9,4)+" / 55 "+ SUBSTR(SM0->M0_FAX,3,2)+" "+SUBSTR(SM0->M0_FAX,5,4)+" "+SUBSTR(SM0->M0_FAX,9,4)) //Telefones
aAdd(_aEmp, "CNPJ : " + Transform(SM0->M0_CGC, "@R 99.999.999/9999-99")) //CGC
aAdd(_aEmp, "I.E.: " + Transform(SM0->M0_INSC, "@R 999.999.999.9999")) // IE

Ordem_Rel := 1

_oPrint := TMSPrinter():New( "Recibo Laser" )
_oPrint:SetPortrait() // ou SetLandscape()

//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)

_oFont8   := TFont():New("Arial", 09, 08,   ,.F.,  ,   ,  ,    , .F.)
_oFont10  := TFont():New("Arial", 09, 10,.T.,.F., 5,.T., 5, .T., .F.)
_oFont12  := TFont():New("Arial", 09, 12,.T.,.F., 5,.T., 5, .T., .F.)
_oFont16  := TFont():New("Arial", 09, 16,.T.,.F., 5,.T., 5, .T., .F.)
_oFont16n := TFont():New("Arial", 09, 16,.T.,.T., 5,.T., 5, .T., .F.)
_oFont24  := TFont():New("Arial", 09, 24,.T.,.T., 5,.T., 5, .T., .F.)

_oBrush := TBrush():New("",4)


For _I := 1 TO Len(aFunc)
	 
    aLanca   := {}         // Zera Lancamentos	
    TOTVENC  := {}
    TOTDESC  := {}
    aImpos   := {}
    
	llanca(aFunc[_I][1],aFunc[_I][4])
	
	_cont:= 0
	_pag := IIf(Abs(Len(aLanca)/19)<=1,1,2)
	z    :=0
	_nctaz := 1
	
	For y:=1 to _pag
		
		_oPrint:StartPage()   // Inicia uma nova página
		
		For z:= 1 to 2
			
			/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Carrega Funcao do Funcion. de acordo com a Dt Referencia     ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			
			fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )
			
		 	_oPrint:Say(_cont+010, 0850,"*** O SEU SALÁRIO É CONFIDENCIAL, NÃO O DIVULGUE A QUEM QUER QUE SEJA!!! ***" , _oFont10) 
			
			
			_oPrint:Say(_cont+045, 0850, _aEmp[2], _oFont10)
			_oPrint:Say(_cont+080, 0850, _aEmp[3], _oFont10)
			//_oPrint:Say(080, 1000, _aEmp[4], _oFont10)
			_oPrint:Say(_cont+115, 0850, _aEmp[5], _oFont10)
			_oPrint:Say(_cont+115, 1350, _aEmp[6], _oFont10)
			_oPrint:Say(_cont+120, 0100, _aEmp[1], _oFont10)
			
			_oPrint:SayBitmap(_cont+010, 0100, _aBmp[1], 650, 115)
			//oPrint:Box(1770, 0100, 1870, 2300)
			_oPrint:Box(_cont+0180, 0100, _cont+0280, 2300)
			_reltipo := iif(z==1," Recibo de Pagamento de Salário"," Demonstrativo de Pagamento de Salário")
			_oPrint:Say(_cont+0200, 0600,_reltipo, _oFont16)
			
			_oPrint:Say(_cont+0200, 1900,MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4), _oFont16)
			
			_oPrint:Box(_cont+0280, 0100, _cont+0380, 2300)
			
			_oPrint:Say(_cont+0290, 0115, "Código", _oFont8)
			_oPrint:Say(_cont+0290, 0215, "Nome do Funcionário", _oFont8)
			_oPrint:Say(_cont+0290, 0815, "CBO", _oFont8)
			_oPrint:Say(_cont+0290, 0965, "Cto. Custo", _oFont8)
			_oPrint:Say(_cont+0290, 1165, "Descrição do Cto. Custo", _oFont8)
			_oPrint:Say(_cont+0290, 1965, "Emp.", _oFont8)
			_oPrint:Say(_cont+0290, 2240, "Fl.", _oFont8)
			
			_oPrint:Say(_cont+0320, 0115, aFunc[_I][1], _oFont8)//codigo
			_oPrint:Say(_cont+0320, 0215, aFunc[_I][2], _oFont8)//nome do funcionario
			_oPrint:Say(_cont+0320, 0815, aFunc[_I][3], _oFont8)//cbo
			_oPrint:Say(_cont+0320, 0965, aFunc[_I][4], _oFont8)//cto custo
			_oPrint:Say(_cont+0320, 1165, aFunc[_I][5], _oFont8)//descricao do cto custo
			_oPrint:Say(_cont+0320, 1975, aFunc[_I][6], _oFont8)//empresa
			_oPrint:Say(_cont+0320, 2240, strzero(y,3) , _oFont8)//folha
			
			_oPrint:Say(_cont+0350, 0115, "Função", _oFont8)
			_oPrint:Say(_cont+0350, 0235, aFunc[_I][8], _oFont8)
			_oPrint:Say(_cont+0350, 0335, "Descrição da Função", _oFont8)
			_oPrint:Say(_cont+0350, 0775, aFunc[_I][9], _oFont8)
			_oPrint:Say(_cont+0350, 1150, "Data de Admissão", _oFont8)
		   // _oPrint:Say(_cont+0350, 1975,  aFunc[_I][10], _oFont8)
			
			_oPrint:Box(_cont+0390, 0100, _cont+1380, 2300)
			_oPrint:Line(_cont+0450, 0100, _cont+0450, 2300)
			_oPrint:Say(_cont+0400, 0115, "Cód."            , _oFont8)
			_oPrint:Line(_cont+0390, 0250, _cont+1080, 0250)
			_oPrint:Say(_cont+0400, 0655, "Descrição"    , _oFont8)
			_oPrint:Line(_cont+0390, 1150, _cont+1080, 1150)
			_oPrint:Say(_cont+0400, 1165, "Referência"    , _oFont8)
			_oPrint:Line(_cont+0390, 1300, _cont+1380, 1300)
			_oPrint:Say(_cont+0400, 1450, "Vencimentos", _oFont8)
			_oPrint:Line(_cont+0390, 1800, _cont+1380, 1800)
			_oPrint:Say(_cont+0400, 1950, "Descontos"   , _oFont8)
			
			_w := 0
			For nConta := _nctaz To Len(aLanca)
				If nConta <= iif(y >= 2,(nlinhas+_nctaz),nlinhas)  //.and. _pag > 2
                  //If aLanca[nConta,7] == y
					_w := _w + 30
					cString := Transform(aLanca[nConta,5],cPict2)
					nCol    := If(aLanca[nConta,1]="P",1630,If(aLanca[nConta,1]="D",2130,0255))
					_oPrint:Say(_cont+0440+_w, 0155, aLanca[nConta,2] , _oFont8)
					_oPrint:Say(_cont+0440+_w, 0255, aLanca[nConta,3] , _oFont8)
					
					If aLanca[nConta,1] # "B"        // So Imprime se nao for base
						If aLanca[nConta,4] <= 9.99
							_oPrint:Say(_cont+0440+_w, 1185, TRANSFORM(aLanca[nConta,4],"999.99"), _oFont8)
						Endif
						If aLanca[nConta,4] <= 99.99 .and. aLanca[nConta,4] > 9.99
							_oPrint:Say(_cont+0440+_w, 1175, TRANSFORM(aLanca[nConta,4],"999.99"), _oFont8)
						Endif
						If aLanca[nConta,4] <= 999.99 .and. aLanca[nConta,4] > 99.99
							_oPrint:Say(_cont+0440+_w, 1165, TRANSFORM(aLanca[nConta,4],"999.99"), _oFont8)
						Endif
						If aLanca[nConta,4] <= 9999.99 .and. aLanca[nConta,4] > 999.99
							_oPrint:Say(_cont+0440+_w, 1155, TRANSFORM(aLanca[nConta,4],"999.99"), _oFont8)
						Endif
					Endif
					If aLanca[nConta,5] <= 9.99
						_oPrint:Say(_cont+0440+_w, nCol+30, cString            , _oFont8)
					Endif
					If aLanca[nConta,5] <= 99.99 .and. aLanca[nConta,5] > 9.99
						_oPrint:Say(_cont+0440+_w, nCol+20, cString            , _oFont8)
					Endif
					If aLanca[nConta,5] <= 999.99 .and. aLanca[nConta,5] > 99.99
						_oPrint:Say(_cont+0440+_w, nCol+10, cString            , _oFont8)
					Endif
					If aLanca[nConta,5] <= 9999.99 .and. aLanca[nConta,5] > 999.99
						_oPrint:Say(_cont+0440+_w, nCol, cString            , _oFont8)
					Endif
					If aLanca[nConta,5] <= 99999.99 .and. aLanca[nConta,5] > 9999.99
						_oPrint:Say(_cont+0440+_w, nCol, cString            , _oFont8)
					Endif
					nContr ++
					nContrT ++

					If nContr = nLinhas //.And. nContrT < Len(aLanca)
						nContr:=0
						Ordem_Rel ++
						//afunc[1][7] := Ordem_Rel
						_w := _w + 30
						_oPrint:Say(_cont+1205, nCol-20, "CONTINUA !!!" , _oFont8)
//					_oPrint:Say(_cont+1205, 2130,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
						
						//Mensagens
						
						_oPrint:Line(_cont+1080, 0100, _cont+1080, 2300)
						
						_oPrint:Say(_cont+1090, 1450, "Total de Vencimentos", _oFont8)
						_oPrint:Say(_cont+1090, 1950, "Total de Descontos"   , _oFont8)
						_oPrint:Line(_cont+1180,1300, _cont+1180, 2300)
						_oPrint:Say(_cont+1205, 1315, "Valor Liquido      ==>"   , _oFont10)
						
						_oPrint:Box(_cont+1280, 0100, _cont+1380, 2300)
						_oPrint:Say(_cont+1295, 0150, "Salário-Base"   , _oFont8)
						_oPrint:Say(_cont+1295, 0500, "Sal. Contr. INSS"   , _oFont8)
						_oPrint:Say(_cont+1295, 1000, "Base Cálc. FGTS"   , _oFont8)
						_oPrint:Say(_cont+1295, 1300, "F.G.T.S. do Mês"   , _oFont8)
						_oPrint:Say(_cont+1295, 1600, "Base Cálc. IRRF"   , _oFont8)
						_oPrint:Say(_cont+1295, 2000, "Faixa IRRF"   , _oFont8)
						
						_oPrint:Box(_cont+1390, 0100, _cont+1500, 2300)
						_oPrint:Say(_cont+1395, 0150, "DECLARO TER RECEBIDO A IMPORTÂNCIA LIQUIDA DISCRIMINADA NESTE RECIBO."   , _oFont8)
						_oPrint:Say(_cont+1420, 0150, " ________/________/________  ", _oFont10)
						_oPrint:Say(_cont+1420, 0950, " ____________________________________________________________"   , _oFont10)
						_oPrint:Say(_cont+1460, 0150, "                  DATA                     "  , _oFont10)
						_oPrint:Say(_cont+1460, 1100, " ASSINATURA DO FUNCIONÁRIO                              "   , _oFont10)
						//If nContrT > Len(aLanca) .and. z==2
						_lmesmo := .T.
						//Else
						//  If nContrT < Len(aLanca) .and. z==1
						//    _lmesmo := .T.
						//  Endif
						//Endif
					Endif
				  //Endif	
				Endif
			Next nConta
			
			If !_lmesmo .or. (y >= 2 .and. _lmesmo)
				//Mensagens
				
				_oPrint:Say(_cont+1080, 0115, DESC_MSG[_I][1], _oFont8)
				_oPrint:Say(_cont+1110, 0115, DESC_MSG[_I][2], _oFont8)
				_oPrint:Say(_cont+1140, 0115, DESC_MSG[_I][3], _oFont8)
				IF MONTH(dDataRef) = aFunc[_I][11]
					_oPrint:Say(_cont+1170, 0115, "F E L I Z   A N I V E R S A R I O  ! !", _oFont8)
					_oPrint:Say(_cont+1200, 0115, DESC_MSG[_I][5], _oFont8)
					
				ELSE
					_oPrint:Say(_cont+1170, 0115, DESC_MSG[_I][4], _oFont8)
					_oPrint:Say(_cont+1200, 0115, DESC_MSG[_I][5], _oFont8)
				ENDIF
				
				//Mensagens da conta corrente
				
				IF SRA->RA_BCDEPSAL # SPACE(8)
					If aFunc[_I][12] = "237"
						Desc_Bco := "Banco Bradesco  "
					Else
						If aFunc[_I][12] = "341"
							Desc_Bco := "Banco Itaú  "
						Endif
					Endif
					//Desc_Bco := DescBco(Sra->Ra_BcDepSal,Sra->Ra_Filial)
					_oPrint:Say(_cont+1230, 0115, "CRED: "+aFunc[_I][13]+" - " + Desc_Bco + "CONTA:" + aFunc[_I][14], _oFont8)
				ENDIF
				
				_oPrint:Line(_cont+1080, 0100, _cont+1080, 2300)
				
				_oPrint:Say(_cont+1090, 1450, "Total de Vencimentos", _oFont8)
				_oPrint:Say(_cont+1090, 1950, "Total de Descontos"   , _oFont8)
				_oPrint:Line(_cont+1180, 1300, _cont+1180, 2300)
				_oPrint:Say(_cont+1205, 1315, "Valor Liquido      ==>"   , _oFont10)
				
				If TOTVENC[1][2] <= 9.99
					_oPrint:Say(_cont+1130, 1660,TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
				Endif
				If TOTVENC[1][2] <= 99.99 .and. TOTVENC[1][2] > 9.99
					_oPrint:Say(_cont+1130, 1650,TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
				Endif
				If TOTVENC[1][2] <= 999.99 .and. TOTVENC[1][2] > 99.99
					_oPrint:Say(_cont+1130, 1640,TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
				Endif
				If TOTVENC[1][2] <= 9999.99 .and. TOTVENC[1][2] > 999.99
					_oPrint:Say(_cont+1130, 1630,TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
				Endif
				If TOTVENC[1][2] <= 99999.99 .and. TOTVENC[1][2] > 9999.99
					_oPrint:Say(_cont+1130, 1650,TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
				Endif
				If TOTDESC[1][2] <= 9.99
					_oPrint:Say(_cont+1130, 2160,TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
				Endif
				If TOTDESC[1][2] <= 99.99 .and. TOTDESC[1][2] > 9.99
					_oPrint:Say(_cont+1130, 2150,TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
				Endif
				If TOTDESC[1][2] <= 999.99 .and. TOTDESC[1][2] > 99.99
					_oPrint:Say(_cont+1130, 2140,TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
				Endif
				If TOTDESC[1][2] <= 9999.99 .and. TOTDESC[1][2] > 999.99
					_oPrint:Say(_cont+1130, 2130,TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
				Endif
				
				If (TOTVENC[1][2]-TOTDESC[1][2]) <= 9.99
					_oPrint:Say(_cont+1205, 2160,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
				Endif
				If (TOTVENC[1][2]-TOTDESC[1][2]) <= 99.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 9.99
					_oPrint:Say(_cont+1205, 2150,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
				Endif
				If (TOTVENC[1][2]-TOTDESC[1][2]) <= 999.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 99.99
					_oPrint:Say(_cont+1205, 2140,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
				Endif
				If (TOTVENC[1][2]-TOTDESC[1][2]) <= 9999.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 999.99
					_oPrint:Say(_cont+1205, 2130,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
				Endif
				If (TOTVENC[1][2]-TOTDESC[1][2]) <= 99999.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 9999.99
					_oPrint:Say(_cont+1205, 2120,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
				Endif
				
				_oPrint:Box(_cont+1280, 0100, _cont+1380, 2300)
				_oPrint:Say(_cont+1295, 0150, "Salário-Base"   , _oFont8)
				_oPrint:Say(_cont+1295, 0500, "Sal. Contr. INSS"   , _oFont8)
				_oPrint:Say(_cont+1295, 0800, "Base Cálc. FGTS"   , _oFont8)
				_oPrint:Say(_cont+1295, 1300, "F.G.T.S. do Mês"   , _oFont8)
				_oPrint:Say(_cont+1295, 1600, "Base Cálc. IRRF"   , _oFont8)
				_oPrint:Say(_cont+1295, 2000, "Faixa IRRF"   , _oFont8)
				
				If !Empty( cAliasMov )
					nValSal := 0
					nValSal := fBuscaSal(dDataRef)
					If nValSal ==0
						nValSal := aFunc[_I][10]
					EndIf
				Else
					nValSal := aFunc[_I][10]
				EndIf
				_oPrint:Say(_cont+1325, 0150, Transform(nValSal,cPict2) , _oFont8)
				
				If Esc = 1  // Bases de Adiantamento
					If cBaseAux = "S" .And. aImpos[1][1] # 0
						_oPrint:Say(_cont+1325, 1600, TRANSFORM(aImpos[1][1],cPict1) , _oFont8)
					Endif
				ElseIf Esc = 2 .Or. Esc = 4  // Bases de Folha e 13o. 2o.Parc.
					If cBaseAux = "S"
						_oPrint:Say(_cont+1325, 0500,Transform(aImpos[1][2],cPict1) , _oFont8)
						If aImpos[1][3] # 0
							_oPrint:Say(_cont+1325, 0800, TRANSFORM(aImpos[1][3],cPict1) , _oFont8)
						Endif
						If aImpos[1][4] # 0
							_oPrint:Say(_cont+1325, 1300,TRANSFORM(aImpos[1][4],cPict2) , _oFont8)
						Endif
						If aImpos[1][1] # 0
							_oPrint:Say(_cont+1325, 1600,TRANSFORM(aImpos[1][1],cPict1) , _oFont8)
						Endif
						_oPrint:Say(_cont+1325, 2000, Transform(aImpos[1][5],cPict1) , _oFont8)
					Endif
				ElseIf Esc = 3 // Bases de FGTS e FGTS Depositado da 1¦ Parcela
					If cBaseAux = "S"
						If aImpos[1][3] # 0
							_oPrint:Say(_cont+1325, 0800,TRANSFORM(aImpos[1][3],cPict1), _oFont8)
						Endif
						If aImpos[1][4] # 0
							_oPrint:Say(_cont+1325, 1300, TRANSFORM(aImpos[1][4],cPict2) , _oFont8)
						Endif
					Endif
				Endif
				
				_oPrint:Box(_cont+1390, 0100, _cont+1500, 2300)
				_oPrint:Say(_cont+1395, 0150, "DECLARO TER RECEBIDO A IMPORTÂNCIA LIQUIDA DISCRIMINADA NESTE RECIBO."   , _oFont8)
				_oPrint:Say(_cont+1420, 0150, " ________/________/________  ", _oFont10)
				_oPrint:Say(_cont+1420, 0950, " ____________________________________________________________"   , _oFont10)
				_oPrint:Say(_cont+1460, 0150, "                  DATA                     "  , _oFont10)
				_oPrint:Say(_cont+1460, 1100, " ASSINATURA DO FUNCIONÁRIO                              "   , _oFont10)
				
			Endif
		    _lmesmo	:= .F.
			
			If z==1
				For i := 100 to 2300 step 50
					_oPrint:Line(1540, i, 1540, i + 30)
				Next i
				_cont  := 1590
			Endif
    		nContr := 0

		Next

		_cont  := 0
		
		_oPrint:EndPage()     // Finaliza a página
		_nctaz := 20
		
	Next
Next
_oPrint:Preview()     // Visualiza antes de imprimir

Return Nil

Static Function llanca(_codmat,_codcc)

Local cNroHoras   := &("{ || If(SRC->RC_QTDSEM > 0, SRC->RC_QTDSEM, SRC->RC_HORAS) }")

nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := 0.00
_TOTVENC := 0
_TOTDESC := 0
Esc      := mv_par02

dbSelectArea("SRA")                            
dbgotop()
dbSeek(xFilial("SRA")+_codmat)

If Esc == 1 .OR. Esc == 2  // adto ou folha
	dbSelectArea("SRC")
	dbSetOrder(1)
	If dbSeek(xFilial("SRA")+_codmat)
		While !Eof() .And. SRC->RC_FILIAL+SRC->RC_MAT == SRA->RA_FILIAL+SRA->RA_MAT
			If (Esc == 1) .And. (Src->Rc_Pd == aCodFol[7,1])      // Desconto de Adto
				fSomaPd("P",aCodFol[6,1],Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
				_TOTVENC+=Src->Rc_Valor
			Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[12,1])
				fSomaPd("D",aCodFol[9,1],Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
				_TOTDESC+=SRC->RC_VALOR
			Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[8,1])
				fSomaPd("P",aCodFol[8,1],Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
				_TOTVENC+=Src->Rc_Valor
			Else
				If PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
						If cPaisLoc == "PAR" .and. Eval(cNroHoras) == 30
							LocGHabRea(Ctod("01/"+SubStr(DTOC(dDataRef),4)), Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Strzero(Month(dDataRef),2)+"/"+right(str(Year(dDataRef)),2)),@nHoras)
						Else
							nHoras := Eval(cNroHoras)
						Endif
						fSomaPd("P",SRC->RC_PD,nHoras,SRC->RC_VALOR,SRC->RC_MAT)
						_TOTVENC+=Src->Rc_Valor
					Endif
				Elseif SRV->RV_TIPOCOD == "2"
					If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
						fSomaPd("D",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
						_TOTDESC+=Src->Rc_Valor
					Endif
				Elseif SRV->RV_TIPOCOD == "3"
					If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
						fSomaPd("B",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
					Endif
				Endif
			Endif
			If ESC = 1
				If SRC->RC_PD == aCodFol[10,1]
					nBaseIr := SRC->RC_VALOR
				Endif
			ElseIf SRC->RC_PD == aCodFol[13,1]
				nAteLim += SRC->RC_VALOR
			Elseif SRC->RC_PD$ aCodFol[108,1]+'*'+aCodFol[17,1]
				nBaseFgts += SRC->RC_VALOR
			Elseif SRC->RC_PD$ aCodFol[109,1]+'*'+aCodFol[18,1]
				nFgts += SRC->RC_VALOR
			Elseif SRC->RC_PD == aCodFol[15,1]
				nBaseIr += SRC->RC_VALOR
			Elseif SRC->RC_PD == aCodFol[16,1]
				nBaseIrFe += SRC->RC_VALOR
			Endif
			dbSelectArea("SRC")
			dbSkip()
		Enddo
	Endif
Elseif Esc == 3
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca os codigos de pensao definidos no cadastro beneficiario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fBusCadBenef(@aCodBenef, "131",{aCodfol[172,1]})
	dbSelectArea("SRC")
	dbSetOrder(1)
	If dbSeek(xFilial("SRA")+_codmat)
		While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT == SRC->RC_FILIAL + SRC->RC_MAT
			If SRC->RC_PD == aCodFol[22,1]
				fSomaPd("P",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
				_TOTVENC+=Src->Rc_Valor
			Elseif Ascan(aCodBenef, { |x| x[1] == SRC->RC_PD }) > 0
				fSomaPd("D",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
				_TOTDESC+=SRC->RC_VALOR
			Elseif SRC->RC_PD == aCodFol[108,1] .Or. SRC->RC_PD == aCodFol[109,1] .Or. SRC->RC_PD == aCodFol[173,1]
				fSomaPd("B",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
			Endif
			
			If SRC->RC_PD == aCodFol[108,1]
				nBaseFgts := SRC->RC_VALOR
			Elseif SRC->RC_PD == aCodFol[109,1]
				nFgts     := SRC->RC_VALOR
			Endif
			dbSelectArea("SRC")
			dbSkip()
		Enddo
	Endif
Elseif Esc == 4
	dbSelectArea("SRI")
	dbSetOrder(2)
	If dbSeek(xFilial("SRA")+_codcc+_codmat)
		While !Eof() .And. SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT == SRI->RI_FILIAL + SRI->RI_CC + SRI->RI_MAT
			If PosSrv( SRI->RI_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
				fSomaPd("P",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR,SRI->RI_MAT)
				_TOTVENC = _TOTVENC + SRI->RI_VALOR
			Elseif SRV->RV_TIPOCOD == "2"
				fSomaPd("D",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR,SRI->RI_MAT)
				_TOTDESC = _TOTDESC + SRI->RI_VALOR
			Elseif SRV->RV_TIPOCOD == "3"
				fSomaPd("B",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR,SRI->RI_MAT)
			Endif
			
			If SRI->RI_PD == aCodFol[19,1]
				nAteLim += SRI->RI_VALOR
			Elseif SRI->RI_PD$ aCodFol[108,1]
				nBaseFgts += SRI->RI_VALOR
			Elseif SRI->RI_PD$ aCodFol[109,1]
				nFgts += SRI->RI_VALOR
			Elseif SRI->RI_PD == aCodFol[27,1]
				nBaseIr += SRI->RI_VALOR
			Endif
			dbSkip()
		Enddo
	Endif
Elseif Esc == 5
	dbSelectArea("SR1")
	dbSetOrder(1)
	If dbSeek(xFilial("SRA")+_codmat)
		While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT ==	SR1->R1_FILIAL + SR1->R1_MAT
			If PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
				fSomaPd("P",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR,SR1->R1_MAT)
				_TOTVENC = _TOTVENC + SR1->R1_VALOR
			Elseif SRV->RV_TIPOCOD == "2"
				fSomaPd("D",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR,SR1->R1_MAT)
				_TOTDESC = _TOTDESC + SR1->R1_VALOR
			Elseif SRV->RV_TIPOCOD == "3"
				fSomaPd("B",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR,SR1->R1_MAT)
			Endif
			dbskip()
		Enddo
	Endif
Endif
	
dbSelectArea("SRA")  

//If _TOTVENC = 0 .And. _TOTDESC = 0
//		dbSkip()
//		Loop
//Endif
	
aAdd(TOTVENC,{_n, _TOTVENC})
aAdd(TOTDESC,{_n, _TOTDESC})
	
aAdd(aImpos,{nBaseIr,;
            nAteLim,;
      	  	nBaseFgts,;
		  		nFgts,;
        		nBaseIrFe})


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fSomaPd   ³ Autor ³ R.H. - Mauro          ³ Data ³ 24.09.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Somar as Verbas no Array                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fSomaPd(Tipo,Verba,Horas,Valor)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fSomaPd(cTipo,cPd,nHoras,nValor,cMat)

Local Desc_paga

Desc_paga := DescPd(cPd,Sra->Ra_Filial)  // mostra como pagto

If cTipo # 'B'
	//--Array para Recibo Pre-Impresso
	nPos := Ascan(aLanca,{ |X| X[2] = cPd })
	If nPos == 0
		Aadd(aLanca,{cTipo,cPd,Desc_Paga,nHoras,nValor,cMat,_n})
	Else
		aLanca[nPos,4] += nHoras
		aLanca[nPos,5] += nValor
	Endif
Endif

/*//--Array para o Recibo Pre-Impresso
If cTipo = 'P'
	cArray := "aProve"
Elseif cTipo = 'D'
	cArray := "aDesco"
Elseif cTipo = 'B'
	cArray := "aBases"
Endif

nPos := Ascan(&cArray,{ |X| X[1] = cPd })
If nPos == 0
	Aadd(&cArray,_n,{cPd+" "+Desc_Paga,nHoras,nValor })
Else
	&cArray[_n,nPos,2] += nHoras
	&cArray[_n,nPos,3] += nValor
Endif  
  */
Return

*-------------------------------------------------------
Static Function Transforma(dData) //Transforma as datas no formato DD/MM/AAAA
*-------------------------------------------------------
Return(StrZero(Day(dData),2) +"/"+ StrZero(Month(dData),2) +"/"+ Right(Str(Year(dData)),4))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fInicia   ºAutor  ³Natie               º Data ³  04/12/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inicializa parametros para impressao                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function  fInicia(cString,nTipoRel)

aDriver := LEDriver()

If LastKey() = 27 .Or. nLastKey = 27
	Return  .F.
Endif

SetDefault(aReturn,cString)

If LastKey() = 27 .OR. nLastKey = 27
	Return .F.
Endif

Return .T.

Static Function CriaPerg(cPerg)
//mv_par01 	C3Da Matricula
//mv_par02   C3  Ate a Matricula
dbselectarea("SX1")
If dbseek("RELLAS")
   return
Endif
    
PutSx1("RELLAS", "01", "Data de Referencia      ?", "", "",;
"mv_ch1", "D", 8, 0, 0, "G", "naovazio", "", "", "",;
"mv_par01", "","", "", "",;
"" ,"", "","",;
"","", "", "",;
"","", "", "",;
"","", "", "",;
"","")
PutSx1(cPerg, "02", "Imprimir Recibos         ?", "", "",;
"mv_ch2", "N", 1, 0, 0, "C", "", "", "", "",;
"mv_par02", "Adto."     ,"", "", "",;
"Folha"   ,"", "", "",;
"1¦Parc." ,"", "", "",;
"2¦Parc." ,"", "", "",;
"Val.Extras","", "", "",;
"","")
PutSx1(cPerg, "03", "De Filial      ?", "", "",;
"mv_ch3", "C", 2, 0, 0, "G", "naovazio", "", "", "",;
"mv_par03", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "XM0", "",;
"","")
PutSx1(cPerg, "04", "Ate Filial     ?", "", "",;
"mv_ch4", "C", 2, 0, 0, "G", "naovazio", "", "", "",;
"mv_par04", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "XM0", "",;
"","")
PutSx1(cPerg, "05", "De Centro de Custo     ?", "", "",;
"mv_ch5", "C", 9, 0, 0, "G", "naovazio", "", "", "",;
"mv_par05", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "CTT", "",;
"","")
PutSx1(cPerg, "06", "Ate Centro de Custo      ?", "", "",;
"mv_ch6", "C", 9, 0, 0, "G", "naovazio", "", "", "",;
"mv_par06", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "CTT", "",;
"","")
PutSx1(cPerg, "07", "De Matricula      ?", "", "",;
"mv_ch7", "C", 6, 0, 0, "G", "naovazio", "", "", "",;
"mv_par07", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "SRA", "",;
"","")
PutSx1(cPerg, "08", "Ate Matricula     ?", "", "",;
"mv_ch8", "C", 6, 0, 0, "G", "naovazio", "", "", "",;
"mv_par08", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "SRA", "",;
"","")
PutSx1(cPerg, "09", "De Nome      ?", "", "",;
"mv_ch9", "C", 30, 0, 0, "G", "naovazio", "", "", "",;
"mv_par09", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "", "",;
"","")
PutSx1(cPerg, "10", "Ate Nome      ?", "", "",;
"mv_chA", "C", 30, 0, 0, "G", "naovazio", "", "", "",;
"mv_par10", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "", "",;
"","")
PutSx1(cPerg, "11", "Mensagem 1      ?", "", "",;
"mv_chB", "C", 2, 0, 0, "G", "", "", "", "",;
"mv_par11", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "", "",;
"","")
PutSx1(cPerg, "12", "Mensagem 2      ?", "", "",;
"mv_chC", "C", 2, 0, 0, "G", "", "", "", "",;
"mv_par12", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "", "",;
"","")
PutSx1(cPerg, "13", "Mensagem 3     ?", "", "",;
"mv_chD", "C", 2, 0, 0, "G", "", "", "", "",;
"mv_par13", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "", "",;
"","")
PutSx1(cPerg, "14", "Mensagem 4      ?", "", "",;
"mv_chE", "C", 62, 0, 0, "G", "", "", "", "",;
"mv_par14", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "", "",;
"","")
PutSx1(cPerg, "15", "Mensagem 5      ?", "", "",;
"mv_chF", "C", 62, 0, 0, "G", "", "", "", "",;
"mv_par15", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "", "",;
"","")
PutSx1(cPerg, "16", "Situacoes a Imp.      ?", "", "",;
"mv_chG", "C", 5, 0, 0, "G", "fSituacao", "", "", "",;
"mv_par16", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "", "",;
"","")
PutSx1(cPerg, "17", "Categorias a Imp.  ?", "", "",;
"mv_chH", "C", 15, 0, 0, "G", "fCategoria", "", "", "",;
"mv_par17", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "", "",;
"","")
PutSx1(cPerg, "18", "imprime Bases ?", "", "",;
"mv_chI", "C", 1, 0, 0, "C", "", "", "", "",;
"mv_par18", "Sim","", "","",;
"Nao","", "","",;
"","", "","",;
"","", "","",;
"","", "", "",;
"","")
Return
