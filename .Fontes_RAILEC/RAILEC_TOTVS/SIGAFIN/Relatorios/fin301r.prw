#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FIN301R  º Autor ³ Sandro Ulisses     º Data ³  31/07/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio da Ficha de Pagamento                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALUBAR METAIS S/A                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FIN301R()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Ficha de pagamento"
Local cPict          := ""
Local titulo         := "Ficha de pagamento"
Local nLin           := 3

Local Cabec1         := ""  //"Este relatorio ira imprimir dos dados de titulos a pagar em aberto."
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "FIN301R" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "FN301R"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FIN301R"+SM0->(M0_CODIGO+M0_CODFIL) // Coloque aqui o nome do arquivo usado para impressao em disco
Private Inicio       := .T.
Private lResp        := .F.
Private cFiltro      := ""
Private cCond        := ""
Private cNumFicha    := ""
Private dUltEmis     := GetMv("MV_DTSLIP")
Private cAnoEmis     := AllTrim(GetMv("MV_ANOSLIP"))
Private nSequen      := GetMv("MV_SEQSLIP")
Private lEof         := ""
Private nInd         := 0
Private nReg         := 0
Private lGravou      :=.F. 
Private _lPrtCtPg		:=.f. //23/03/17      
Private _cChvCtPg:=""
                
       
                                     
//IF UPPER(rtrim(funname()))=='FINA750' .OR. UPPER(rtrim(funname()))=='FINA050' //23/03/17
IF UPPER(rtrim(funname()))=='FINA750' .OR. UPPER(rtrim(funname()))=='FINA050' .OR. UPPER(rtrim(funname()))=='ALU_CADPA' //12/06/18 
	_lPrtCtPg:=.T.    
	_cChvCtPg:=SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
ENDIF

IF !_lPrtCtPg //23/03/17
	If !Pergunte(cPerg,.t.)
		Return
	EndIf
	
	If nLastKey == 27
		Return
	EndIf
	
	If MV_PAR01 == 2
		While .T.
			If !Empty(MV_PAR02) .And. (MV_PAR02 <= MV_PAR03)
				Exit
			EndIf
			If MV_PAR03 == "ZZZZZZZZ" .Or. MV_PAR03 == "99999999"
				Exit
			EndIf
			MsgBox("Informações inválidas, verifique os parametros !!!","Atencao")
			Pergunte(cPerg,.T.)
		EndDo
	EndIf
	
	If MV_PAR01 == 1
		If cAnoEmis <> AllTrim(Str(Year(DDataBase)))
			DbSelectArea("SX6")
			DbSeek("  MV_ANOSLIP",.T.)
			RecLock("SX6",.F.)
			Replace X6_CONTEUD With AllTrim(Str(Year(DDataBase))) // Atualiza o ano de sequencia das fichas de pagamento
			MsUnLock()
			DbSeek("  MV_SEQSLIP",.T.)
			RecLock("SX6",.F.)
			Replace X6_CONTEUD With "000001" // Inicializa sequencia das fichas de pagamento
			nSequen := 1
			MsUnLock()
		EndIf
	EndIf 
ELSE
		If cAnoEmis <> AllTrim(Str(Year(DDataBase)))//NAO É REIMPRESSAO - 23/03/17
			DbSelectArea("SX6")
			DbSeek("  MV_ANOSLIP",.T.)
			RecLock("SX6",.F.)
			Replace X6_CONTEUD With AllTrim(Str(Year(DDataBase))) // Atualiza o ano de sequencia das fichas de pagamento
			MsUnLock()
			DbSeek("  MV_SEQSLIP",.T.)
			RecLock("SX6",.F.)
			Replace X6_CONTEUD With "000001" // Inicializa sequencia das fichas de pagamento
			nSequen := 1
			MsUnLock()
		EndIf
ENDIF
	
Private cString := "SE2"

//ValidPerg()

//pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,wNrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif


IF !_lPrtCtPg //23/03/17
	If MV_PAR01 == 1
		nInd := 14
		cCond := "DtoS(E2_EMIS1) <= '"+DtoS(MV_PAR04)+"'"
		dbSelectArea("SE2")
	
		DBORDERNICKNAME("SE2DTCONT") //DbSetOrder(nInd)
	
		DbSeek(xFilial("SE2")+DtoS(MV_PAR04),.t.)
	Else
		nInd := 16
		cCond := "E2_FICHA <= '"+MV_PAR03+"'"
		DbSelectArea("SE2")
	
	    //Alterado pelo Sólon Silva (SigaCorp) em 13.06.11 as 14hs
	    if SM0->M0_CODIGO$"03"
	       cNumFicha := MV_PAR02
	    endif                                 
	    //até aqui
	                                     
	    //IF SM0->M0_CODIGO$"01/02/06" //ORIGINAL
		IF SM0->M0_CODIGO$"01/02/06/03/07/08"  //CLAUDIO OLIVEIRA 18/11/2013
	       DBORDERNICKNAME("SE2FICHA") //DbSetOrder(nInd)
		   cNumFicha := If(Empty(MV_PAR02),GetMv("MV_PRFICHA"),MV_PAR02)
		   DbSeek(xFilial("SE2")+cNumFicha) 
		ELSE
		   LOCATE FOR SE2->E2_FICHA=cNumFicha
		ENDIF   
		IF FOUND()
		   ALERT("Encontrada ficha : " + cNumFicha)
		  ELSE 
		   ALERT("NAO ACHEI : " + cNumFicha) 
		ENDIF   
	EndIf
ELSE //23/03/17 - PESQUISO DOC INCLUIDO 
	nInd := 14
	cCond := "E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA='"+XFilial("SE2")+_cChvCtPg+"'"
	dbSelectArea("SE2")
	DBSETORDER(1) //DbSetOrder(nInd)
	DbSeek(xFilial("SE2")+_cChvCtPg,.t.)
ENDIF
	
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

cNumFicha := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
RunReport(Cabec1,Cabec2,Titulo,nLin)

IF !_lPrtCtPg //23/03/17
	If MV_PAR01 == 1
		DbSelectArea("SX6")
		DbSeek("  MV_SEQSLIP",.T.)
		RecLock("SX6",.F.)
		Replace X6_CONTEUD With StrZero(nSequen,6) // Atualiza o controle de sequencia das fichas de pagamento
		MsUnLock()
		DbSeek("  MV_DTSLIP ",.T.)
		RecLock("SX6",.F.)
		Replace X6_CONTEUD With DtoC(dDataBase) // Data da ultima emissao das fichas de pagamento
		MsUnLock()
		If !Empty(cNumFicha)
			DbSeek("  MV_PRFICHA",.T.)
			RecLock("SX6",.F.)
			Replace X6_CONTEUD With cNumFicha // Numero da primeira ficha impressa no dia salva durante a impressao
			MsUnLock()
		EndIf
	Endif
	
	DbSelectArea("SE2")
	DbSetOrder(1)  
ELSE
	DbSelectArea("SX6")
	DbSeek("  MV_SEQSLIP",.T.)
	RecLock("SX6",.F.)
	Replace X6_CONTEUD With StrZero(nSequen,6) // Atualiza o controle de sequencia das fichas de pagamento
	MsUnLock()
	DbSeek("  MV_DTSLIP ",.T.)
	RecLock("SX6",.F.)
	Replace X6_CONTEUD With DtoC(dDataBase) // Data da ultima emissao das fichas de pagamento
	MsUnLock()
	If !Empty(cNumFicha)
		DbSeek("  MV_PRFICHA",.T.)
		RecLock("SX6",.F.)
		Replace X6_CONTEUD With cNumFicha // Numero da primeira ficha impressa no dia salva durante a impressao
		MsUnLock()
	EndIf
ENDIF
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  17/06/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local nOrdem,col,cMoeda,nContr,nRep,I,cEmp,cDesc,nValor,cArqFicha,cNumDoc,lFicha,cNomBco,cCodTit
Local aItens := {}
Local lExiste := .F.
Local cBranco := "|"+Space(76)+"|"
Local cTracos := "|"+Repl("-",76)+"|"
Local cSublin := "|"+Repl("_",76)+"|"
cNomBco := ""
col := 1
cEmp := Trim(SM0->M0_NOMECOM)

cArqFicha := "ARQPAG"+SM0->M0_CODIGO
DbSelectArea("SA6")
DbSetOrder(1)
DbSelectArea("SD1")
DbSetOrder(1)
dbSelectArea("SA2")
dbSetOrder(1)
DbSelectArea("SI3")
DbSetOrder(1)
Use &cArqFicha Alias FPG New Via "DBFCDX"

If !File(cArqFicha+".CDX")        
   Index on FichaPg to &cArqFicha
ENDIF

DbSetIndex(cArqFicha+".CDX")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SE2")
//SetRegua(RecCount())
//DbSetOrder(nInd)

//SetPrc(3,0)

While !EOF() .And. &cCond
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	if !_lPrtCtPg //23/03/17
	    IF E2_VENCREA < MV_PAR04   // SOMENTE VENCIMENTOS IGUAL OU SUPERIOR A DATA DA CONTABILIZACAO
			IncProc()
			DbSkip()
			Loop
		EndIf
	    	
		If E2_SALDO == 0 .And. MV_PAR05 == 1
			IncProc()
			DbSkip()
			Loop
		EndIf
		
		If MV_PAR01 == 2
			If E2_FICHA < MV_PAR02
				IncProc()
				DbSkip()
				Loop
			EndIf
		EndIf
		
		If MV_PAR01 == 2
			If E2_FICHA > MV_PAR03
				Exit
			Endif
		EndIf
		
		If MV_PAR01 == 2
			If Empty(E2_FICHA)
				IncProc()
				DbSkip()
				Loop
			EndIf
		EndIf
		
		If MV_PAR01 == 1
			If !Empty(E2_FICHA)
				IncProc()
				DbSkip()
				Loop
			EndIf
		EndIf
	endif
		
	lExiste := .F.
	cNomBco := ""
	
	SA2->(dbSeek(xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA,.F.))
	
	If !Empty(SA2->A2_BANCO) .And. !Empty(SA2->A2_AGENCIA) .And. !Empty(SA2->A2_NUMCON) // Verifica o banco cadastrado para o fornecedor
		If SA6->(DbSeek(xFilial("SA6")+SA2->A2_BANCO))
			cNomBco := SA2->A2_BANCO+"-"+SUBSTR(SA6->A6_NOME,1,15)+" Ag.: "+Trim(SA2->A2_AGENCIA)+"-"+SA2->A2_DIGAGEN+" Cta.: "+Trim(SA2->A2_NUMCON)+"-"+SA2->A2_DIGCONT+SPACE(2)
		EndIf
	EndIf
	
	// Monta array da Nota Fiscal de Entrada
	If SD1->(dbSeek(xFilial("SD1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA))
		While !SD1->(Eof()) .And. SD1->(D1_DOC) == SE2->E2_NUM .And. SD1->(D1_SERIE) == SE2->E2_PREFIXO .And. SD1->(D1_FORNECE) == SE2->E2_FORNECE
			I := aScan(aItens,{|x| x[1]==SD1->D1_CC .And. x[2]==SD1->(D1_CONTA)})
			If I == 0
				AADD(aItens,{SD1->(D1_CC),SD1->(D1_CONTA),SD1->(D1_TOTAL )+(SD1->D1_VALIPI)})
			Else
				aItens[I][3]+=SD1->(D1_TOTAL)+SD1->(D1_VALIPI)
			EndIf
			lExiste := .T.
			SD1->(DbSkip())
		EndDo
	EndIf
	
	DbSelectArea("SE2")
	
	if !_lPrtCtPg //23/03/17
		If MV_PAR01 == 1
			cNumDoc := StrZero(nSequen,6)
		Else
			cNumDoc := SubStr(E2_FICHA,1,6)
		EndIf
	else
		cNumDoc := StrZero(nSequen,6)	
	endif
	
	lFicha := .F.
	DbSelectArea("FPG")
	Locate For SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+Trim(E2_TIPO)+E2_FORNECE+E2_LOJA) == Trim(FPG->RESERVA) //dbSeek(Trim(cNumDoc)+Right(AllTrim(Str(Year(DDataBase))),2)))
	If Found()
		cNumDoc := SubStr(FICHAPG,1,6)
		lFicha := .T.
	EndIf
	
	DbSelectArea("SE2")
	
	cMoeda := AllTrim(GetMv("MV_SIMB"+Str(E2_MOEDA,1)))
	
	
	nDescto:= E2_DESCONT + E2_IRRF + E2_INSS + E2_ISS + E2_VRETPIS + E2_VRETCOF + E2_VRETCSL
	nValor := E2_VALOR + SE2->E2_ACRESC//+ E2_MULTA + E2_JUROS - nDescto
	
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	//nLin := nLin+1
	
	@prow()+1,col   PSAY cTracos //"|"+Repl("-",78)+"|"
	@prow()+1,col   PSAY cBranco //"|"+Space(78)+"|"
	@prow()+1,col   PSAY "|"
	@prow()  ,col+2 PSAY cEmp+Space(Limite-5-Len(cEmp))+"|"
	@prow()+1,col   PSAY "|" + Space(45) +Repl("_",30) + " |"
	@prow()+1,col   PSAY "| FICHA DE PAGAMENTO Nr.  " + cNumDoc+"/" + Right(AllTrim(Str(Year(DDataBase))),2)
	
	if !_lPrtCtPg //23/03/17	
		If MV_PAR01 == 2
			@prow(),Pcol()  PSAY "   Nr Via "+Trans(SE2->E2_NVIA+1,"@E ##")+"a"+ Space(7)
		Else
			@prow(),pcol()  PSay Space(18)
		EndIf
	else
		@prow(),pcol()  PSay Space(18)	
	endif
	
	@Prow(),Pcol()  PSay "assinaturas do cheque" + Space(1) + "|"
	@prow()+1,col   PSAY cBranco //"|"+Space(78)+"|"
	@prow()+1,col   PSAY "| BANCO" + Repl("_",20)+"   NR. DA CONTA" + Repl("_",10) + Space(25)+"|"
	@prow()+1,col   PSAY "|"+Space(53)+"Natureza: "+SE2->E2_NATUREZ
	@PROW()  ,078   PSAY "|"
	If SED->(DBSEEK(xFilial("SED")+SE2->E2_NATUREZ))
		_DESCNAT:=SED->ED_DESCRIC
	ELSE
		_DESCNAT:=Replicate("*",len(SED->ED_DESCRIC))
	EndIf
	DBSELECTAREA("SE2")
	@prow()+1,col   PSAY "| AGENCIA" + Repl("_",18)+"   CHEQUE NR."+Repl("_",12)+"  " +_DESCNAT
	@prow()+1,col   PSAY cSublin //"|"+Repl("_",78)+"|"
	@prow()+1,col   PSAY "|Fornec: " + SE2->E2_FORNECE+"-"+SubStr(ALLTRIM(SA2->A2_NOME)+SPACE(100),1,31) + "      D       |        C      |"
	@prow()+1,col   PSAY "|Banco : " + cNomBco+Space(35-Len(cNomBco)) + "|" + Repl("_",15) + "|" 
	@prow()+1,col   PSAY "|Doc.Nr.:" + SE2->E2_PREFIXO+"-"+SE2->E2_NUM+If(!Empty(SE2->E2_PARCELA),"-"+SE2->E2_PARCELA,"  ")+Space(2)+Trim(cMoeda)+Transform(SE2->E2_VALOR+ SE2->E2_ACRESC+nDescto,"@E 9,999,999,999.99")+"|"+Repl("_",16-Len(Alltrim(SA2->A2_CONTA)))+Alltrim(SA2->A2_CONTA)+"|"+Repl("_",15)+"|"
	@prow()+1,col   PSAY "|Desconto (-)"+Space(13)+cMoeda+If(nDescto<>0,Transform(nDescto,"@E 9,999,999,999.99"),Repl("_",16))+"|" + Repl("_",16)+"|"+Repl("_",15)+"|"
	@prow()+1,col   PSAY "|Acrescimo" + Space(16) + cMoeda + If(SE2->E2_MULTA<>0,Transform(SE2->E2_MULTA,"@E 9,999,999,999.99"),Repl("_",16)) + "|" + Repl("_",16)+"|" + Repl("_",15) + "|"
	@prow()+1,col   PSAY "|" + Space(25) + cMoeda + If(SE2->E2_JUROS<>0,Transform(SE2->E2_JUROS,"@E 9,999,999,999.99"),Repl("_",16)) + "|" + Repl("_",16) + "|" + Repl("_",15) + "|"
	@prow()+1,col   PSAY "|" + Space(43) + "|" + Repl("_",16) + "|" + Repl("_",15) + "|"
	@prow()+1,col   PSAY "|LIQUIDO A PAGAR" + Space(10) + cMoeda + If(nValor<>0,Transform(nValor,"@E 9,999,999,999.99"),Repl("_",16)) + "|" + Repl("_",16) + "|" + Repl("_",15) + "|"
	@prow()+1,col   PSAY "|Data de Vencimt" + SPACE(20) + DTOC(SE2->E2_VENCREA) + SPACE(33)+"|"//cSublin 

	@prow()+1,col   PSAY cSublin //"|"+Repl("_",78)+"|"
	@prow()+1,col   PSAY "|Ocorrencias com este processo:"+Space(46)+"|"
	
	//Criado por Denis Haruo 13/05/2015
	//Para impressao da Instrução da PA
	If SE2->E2_PREFIXO == 'PA1' .or. SE2->E2_PREFIXO == 'PA2'
		cMsg1 := SubStr(E2_INSTRPA,1,75) 
		cMsg2 := SubStr(E2_INSTRPA,76,150)
		cMsg3 := SubStr(E2_INSTRPA,151,200)
		@prow()+1,col   PSAY "|"+cMsg1+Space(76-LEN(cMsg1))+"|"
		@prow()+1,col   PSAY "|"+cMsg2+Space(76-LEN(cMsg2))+"|"
		@prow()+1,col   PSAY "|"+cMsg3+Space(76-LEN(cMsg3))+"|"
	Else
		@prow()+1,col   PSAY "|"+SE2->E2_HIST+Space(76-LEN(SE2->E2_HIST))+"|"
	EndIf
	@prow()+1,col   PSAY cBranco

	If nDescto == 0
		cNat := Trim(SE2->E2_NATUREZ)
		If !cNat$"IRRF/INSS/ISS/IRF/PIS/COFINS/CSLL"
			@prow()+1,col PSAY cBranco
			cCodTit := ""
			If (E2_IRRF+E2_INSS+E2_VRETPIS+E2_VRETCOF+E2_VRETCSL) != 0
				cCodTit := SE2->E2_FILIAL+DTOS(SE2->E2_EMIS1)+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
			EndIf
		Else
			nReg := RecNo()
			nInd := IndexOrd()
			If !Empty(cCodTit)
				DbSeek(xFilial("SE2")+cCodTit)
			Else
				cTit := SE2->E2_NUM
				nVal := SE2->E2_VALOR+ SE2->E2_ACRESC
				cPrefix := SE2->E2_PREFIXO
				// DbSetOrder(1)  // Posiciona no indice principal
				While !BOF() .And. SE2->E2_NUM == cTit .And. SE2->E2_PREFIXO == cPrefix
					If E2_IRRF ==  nVal .And. (cNat == "IRF" .Or. cNat == "IRRF")
						Exit
					EndIf
					If E2_INSS == nVal .And. cNat == "INSS"
						Exit
					EndIf
					If E2_ISS == nVal .And. cNat == "ISS"
						Exit
					EndIF
					If E2_VRETPIS == nVal .And. cNat == "PIS"
						Exit
					EndIf
					If E2_VRETCOF == nVal .And. cNat == "COFINS"
						Exit
					EndIf
					If E2_VRETCSL == nVal .And. cNat == "CSLL"
						Exit
					EndIf
					DbSkip(-1)     // Retorna um registro anterior para selecionar o fornecedor que originou o imposto
				EndDo
			EndIf
			If !Bof()
				@prow()+1,col   PSay "|Fornecedor : "+SE2->E2_NOMFOR+Space(55-(Len(SE2->E2_NOMFOR)+13))+"                     |"
			EndIf
			DbGoTo(nReg)     // Avanca para o registro
			//DbSetOrder(nInd) // Retorna o indice para o relatório
		EndIf
	EndIf
	IF (SE2->E2_IRRF+SE2->E2_INSS+SE2->E2_ISS+SE2->E2_VRETPIS+SE2->E2_VRETCOF+SE2->E2_VRETCSL) # 0
		If SE2->E2_IRRF # 0
			@prow()+1,col  PSay "| IRRF :"+Trans(SE2->E2_IRRF,"@E 999,999.99")
			@prow(),78     PSAY "|"
		EndIf
		If SE2->E2_INSS # 0
			@prow()+1,col  PSay "| INSS :"+Trans(SE2->E2_INSS,"@E 999,999.99")
			@prow(),78     PSay "|"
		EndIf
		If SE2->E2_ISS # 0
			@prow()+1,col  PSay "| ISS  :"+Trans(SE2->E2_ISS,"@E 999,999.99")
			@prow(),78     PSay "|"
		EndIf
		If SE2->E2_VRETPIS # 0
			@prow()+1,col  PSay "| PIS  :"+Trans(SE2->E2_VRETPIS,"@E 999,999.99")
			@prow(),78     PSay "|"
		EndIf
		If SE2->E2_VRETCOF # 0
			@prow()+1,col  PSay "| COFINS"+Trans(SE2->E2_VRETCOF,"@E 999,999.99")
			@prow(),78     PSay "|"
		EndIf
		If SE2->E2_VRETCSL # 0
			@prow()+1,col  PSay "| CSLL :"+Trans(SE2->E2_VRETCSL,"@E 999,999.99")
			@prow(),78     PSay "|"
		EndIf
	EndIf
	
	IF E2_FORNECE="UNIAO " .OR. E2_FORNECE="INPS  "
		nREG :=RECNO()
		_FORN:=""
		cTit    := SE2->E2_NUM
		cPrefix := SE2->E2_PREFIXO
		While !BOF() .And. SE2->E2_NUM == cTit .And. SE2->E2_PREFIXO == cPrefix
			IF LEFT(E2_TIPO,2)="NF"
				_FORN:=POSICIONE("SA2",1,xFilial("SA2") + SE2->E2_FORNECE+SE2->E2_LOJA, "A2_NOME")
				@prow()+1,col   PSay "|Forn Orig : "+SE2->E2_FORNECE+"-"+_FORN+Space(55-(Len(_FORN)+13))+"               |"
			ENDIF
			DbSkip(-1)     // Retorna um registro anterior para selecionar o fornecedor que originou o imposto
		EndDo
		DbGoTo(nReg)     // Avanca para o registro
		IF !EMPTY(_FORN) .AND. !(LEFT(SE2->E2_HIST,3)$"IRR/COF/PIS/CSL/INS")
			RECLOCK("SE2",.F.)
			SE2->E2_HIST:=_FORN
			MSUNLOCK()
		ENDIF
	ENDIF
	
	@prow()+1,col   PSAY cSublin
	@prow()+1,col   PSAY "|Contas a pagar |  Tesouraria   | Aprovacao do pagamento  | Contabilidade    |"
	@prow()+1,col   PSAY "|_______________|_______________|_________________________|__________________|"
	@prow()+1,col   PSAY "|               |               |                         |                  |"
	@prow()+1,col   PSAY "|               |               |                         |                  |"
	@prow()+1,col   PSAY "|               |               |                         |                  |"
	@prow()+1,col   PSAY "|_______________|_______________|_________________________|__________________|"
	//		                              xx/xxxx         xx/xxxx                     xx/xxxx            xx/xxxx
	//                            12345678901234567890123456789012345678901234567890123456789012345678901234567890
	//                                     1         2         3         4         5         6         7         8
	@prow()+1,col   PSAY "|      /"+StrZero(Month(SE2->E2_VENCREA),2)+"/"+Alltrim(Str(Year(SE2->E2_VENCREA)))+" |";
	+ Space(6) + "/" + StrZero(Month(SE2->E2_VENCREA),2) + "/" + Alltrim(Str(Year(SE2->E2_VENCREA))) + " |";
	+ Space(16) + "/" + StrZero(Month(SE2->E2_VENCREA),2) + "/" + Alltrim(Str(Year(SE2->E2_VENCREA))) + " |";
	+ Space(9) + "/" + StrZero(Month(SE2->E2_VENCREA),2) + "/" + Alltrim(Str(Year(SE2->E2_VENCREA))) + " |"
	@prow()+1,col   PSAY "|_______________|_______________|_________________________|__________________|"
	@prow()+1,col   PSAY "|Portador                            |       Valor  "+cMoeda+"    |  Vencimento      |"
	@prow()+1,col   PSAY "|                                    |                    |       " + Subs(DtoC(SE2->E2_VENCREA),1,6) + Alltrim(Str(Year(SE2->E2_VENCREA))) + " |"
	@prow()+1,col   PSAY "|____________________________________|____________________|__________________|"
	If LExiste
		nContr := 1
		@prow()+2,col PSAY cTracos 
		@prow()+1,col PSAY "| C.Custo                      |        Debito |       Credito |    Valor "+cMoeda+" |"
		While nContr <= Len(aItens)
			If aItens[nContr][3] # 0
				SI3->(DbSeek(xFilial("SI3")+aItens[nContr][1],.t.))
				cDesc := Trim(SI3->(I3_DESC))
				If Len(cDesc) > 46
					cDesc := SubStr(cDesc,1,24)
				Else
					cDesc := cDesc+Repl("_",(24-Len(cDesc)))
				EndIf
				If !Empty(aItens[nContr][1])
					@prow()+1,col PSAY "| "+Trim(aItens[nContr][1])+" "+cDesc+" |"
				Else
					@prow()+1,col PSay "| ___ "+Repl("_",24)+" |"
				EndIf
			    _dCONTAD:=POSICIONE("CT1",1,XFILIAL("CT1")+Trim(aItens[nContr][2]),"CT1_DESC01")  
				@prow(),pcol() PSAY Repl("_",14-Len(Trim(aItens[nContr][2])))+Trim(aItens[nContr][2])+" |"
				@prow(),pcol() PSAY Repl("_",14-len(Trim(SA2->A2_CONTA)))+Trim(SA2->A2_CONTA)+" |"
				@prow(),pcol() PSAY Trans(aItens[nContr][3],"@E 9,999,999.99")+" |"
			    @prow()+1,col PSAY "|                               "+_dCONTAD+"     |"
				aItens[nContr][3]:=0
			EndIf
			nContr++
		EndDo
		@prow()+1,col PSAY cSublin 
	Else
		If !Empty(SE2->E2_CC) .And. !Empty(SE2->E2_CTADEBD)
			@prow()+2,col PSAY cTracos 
			@prow()+1,col PSAY cBranco 
			@prow()+1,col PSAY "| C.Custo                      |        Debito |       Credito |       Valor "+cMoeda+"|"
			SI3->(DbSeek(xFilial("SI3")+SE2->(E2_CC),.t.))
			cDesc := Trim(SI3->(I3_DESC))
			If Len(cDesc) > 46
				cDesc := SubStr(cDesc,1,24)
			Else
				cDesc := cDesc+Repl("_",(24-Len(cDesc)))
			EndIf
			@prow()+1,col PSAY "| "+Trim(SE2->(E2_CC))+" "+cDesc+" |"
			_dCONTAD:=POSICIONE("CT1",1,XFILIAL("CT1")+Trim(SE2->E2_CTADEBD),"CT1_DESC01")  
			@prow(),pcol() PSAY Repl("_",14-Len(Trim(SE2->E2_CTADEBD)))+Trim(SE2->E2_CTADEBD)+" |"
			@prow(),pcol() PSAY Repl("_",14-len(Trim(SA2->A2_CONTA)))+Trim(SA2->A2_CONTA)+" | "
			@prow(),pcol() PSAY Trans(SE2->E2_VALOR+ SE2->E2_ACRESC,"@E 999,999,999.99")+"|"
			@prow()+1,col PSAY "|                               "+_dCONTAD+"     |"
			@prow()+1,col PSAY cTracos 
		EndIf
	EndIf

	DbSelectArea("SE2")
	RecLock("SE2",.F.)
	if !_lPrtCtPg //23/03/17	
		If MV_PAR01 == 1
			If lFicha
				Replace E2_FICHA With FPG->FICHAPG
				Replace E2_NVIA With FPG->NUMVIAS + 1
			Else
				Replace E2_FICHA With StrZero(nSequen,6)+Right(AllTrim(Str(Year(DDataBase))),2)
				Replace E2_NVIA With 1
			EndIf
		Else
			Replace E2_NVIA With E2_NVIA + 1
		EndIf
	else
		If lFicha
			Replace E2_FICHA With FPG->FICHAPG
			Replace E2_NVIA With FPG->NUMVIAS + 1
		Else
			Replace E2_FICHA With StrZero(nSequen,6)+Right(AllTrim(Str(Year(DDataBase))),2)
			Replace E2_NVIA With 1
		EndIf
	endif
	
	If !lFicha
		nSequen++
	EndIf
	
	MsUnLock()
	
	DbSelectArea("FPG")
	If lFicha
		RecLock("FPG",.F.)
		Replace NUMVIAS With NUMVIAS + 1
		Replace USUARIO With cUserName
		Replace RESERVA With SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
		MsUnLock()
	Else
		RecLock("FPG",.T.)
		Replace FICHAPG With SE2->E2_FICHA
		Replace DATAEMIS With dDataBase
		Replace VALORORI With SE2->E2_VALOR + SE2->E2_ACRESC
		Replace NUMVIAS With 1
		Replace USUARIO With cUserName
		Replace RESERVA With SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
		MsUnLock()
	EndIf
	
	cNumFicha := If(Empty(cNumFicha),FPG->FICHAPG,cNumFicha) // Guarda a primeira ficha impressa
	
	DbSelectArea("SE2")
	DbSkip()
EndDo

DbSelectArea("FPG")
DbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
