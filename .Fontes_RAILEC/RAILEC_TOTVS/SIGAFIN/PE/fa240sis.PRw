#include "rwmake2.ch"
//#include "FINA240.ch"

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
?????????????????????????????????????????????????????????????????????????????
??зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд???
???Fun??o    ? Fa240Sis ? Autor ? Vinicius S.Barreira   ? Data ? 15.05.95 ???
??цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд???
???Descri??o ? Gera??o do Arquivo de Envio de Titulos a Pagar SisPag      ???
??цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд???
???Sintaxe   ? Fa240Sis()                                                 ???
??цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд???
??? Uso      ? Generico                                                   ???
??юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды??
?????????????????????????????????????????????????????????????????????????????
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
User Function Fa240Sis()

LOCAL aSays:={}
LOCAL aButtons:={}
LOCAL nOpca 	:= 0
LOCAL lF240Ger 	:= ExistBlock("F240Ger")

Private xConteudo

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
//? Verifica se data do movimento n?o ? menor que data limite de ?
//? movimentacao no financeiro    										  ?
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If !DtMovFin()
	Return
Endif	
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
//? Desenho da tela WINDOWS         			 						  ?
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Pergunte("FIN241",.F.)
nOpca := 0
AADD (aSays, "   Esta opГЦo gera o Arquivo de  ComunicaГЦo BancАria  SisPag" )		// 
AADD (aSays, "para o  BorderТ de Pagamentos. DeverА ser  informado o  N╟ do" )		// 
AADD (aSays, "BorderТ que se quer enviar, o Nome do Arquivo de ConfiguraГЦo" )		// 
AADD (aSays, "(CNAB SisPag) e o Nome do Arquivo a ser Gerado.")		//  

AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
AADD(aButtons, { 5,.T.,{|| Pergunte("FIN241",.T. ) } } )
FormBatch( "stR0038", aSays, aButtons )

If nOpca == 1
	If lF240Ger 
		If !execBlock("F240Ger",.F.,.F.)
	      Return(Nil)
	 	Endif
	Endif
	Processa({||SisPagG("SE2")})
Endif

Return

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
?????????????????????????????????????????????????????????????????????????????
??зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд???
???Fun??o    ? SisPagGer? Autor ? Vinicius S.Barreira   ? Data ? 16.05.95 ???
??цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд???
???Descri??o ? Gera Arquivo Remessa SisPag                                ???
??цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд???
???Sintaxe   ? SisPagGer()                                                ???
??цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд???
??? Uso      ? FinA240                                                    ???
??юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды??
?????????????????????????????????????????????????????????????????????????????
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function SisPagG(cAlias)
LOCAL lResp:=.t.
LOCAL nUltDisco:=0
Local lErro := .F.
Local cHeadLote := ""
Local cDeta     := ""
Local cDetb     := ""
Local cDetc     := ""
Local cTraiLote := ""
Local cLOCABCO  := "" // Banco da Localiza
Local cLOCAPRO  := ""
Local lF240Grv  :=  ExistBlock("F240GRV")
Local lFirst    := .T.
Local aAreaSea  := SEA->(GetArea())
Local aAreaSe2  := SEA->(GetArea())
Local aArea		 := GetArea()
Local lAchou	 := .F.
Local lF240Bco		:= ExistBlock("F240BCO")
Local lIsItau		:= .F.  
Local lF240Sum := ExistBlock("F240SUM")
Local aOrdSE2	:= {}
Local cChave
Local lF240SumA := ExistBlock("F240SUMA")
Local lF240SumD := ExistBlock("F240SUMD")


Private nHdlBco := 0,nHdlSaida := 0,nSeq := 0,nSeq1 := 0,cBanco,cAgencia,cConta,cSubConta
Private nTotLinha := 0 //Total de linhas do arquivo Inicio com uma linha para o Header e uma para o lote
private _nLote := 0

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Ponto de Entrada F240ARQ													Ё
//Ё Utilizado na verifica┤фo da existencia de arquivo com mesmo   Ё
//Ё nome contido em mv_par04 (nome do arquivo a ser gerado).		Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If ExistBlock("F240ARQ")
	ExecBlock("F240ARQ",.F.,.F.)
Endif

dbSelectArea("SEA")
dbOrdernickname("SEA3")
dbSeek(xFilial("SEA")+mv_par01,.T.)
While !Eof() .And. SEA->EA_NUMBOR <= mv_par02 .and. SEA->EA_FILIAL == xFilial()
	If SEA->EA_CART == "P"
		cBanco  := EA_PORTADO
		cAgencia:= EA_AGEDEP
		cConta  := EA_NUMCON
		lAchou  := .T. 
		lErro	  := .F.
		Exit
	Endif
	dbSkip()
Enddo
If !lAchou	
	Help(" ",1,"BANC240")
	lErro := .T.
EndIf

If ! lErro
	dbSelectArea("SEE")
	If ! dbSeek(xFilial("SEE")+cBanco+cAgencia+cConta)
		Help(" ",1,"PAR240")
		lErro := .T.
	Else
		cSubConta := EE_SUBCTA
	Endif
EndIf

If ! lErro
	lIsItau := IIF(SEA->EA_PORTADO == "341",.T.,.F.)

	//Ponto de entrada F240BCO
	//Tem como funcao validar se o portador, cadastrado no SA6 com um outro 
	//numero que nao seja "341" eh o banco Itau de forma a nao gerar Segmento B
	//Explo: Cliente cadastra os bancos em sequencia (001...007) e o 007 representa o Itau
	//Retornar .T. se o portador for o Itau ou .F. caso contrario	
	If lF240Bco
		lIsItau := ExecBlock("F240BCO",.F.,.F.,SEA->EA_PORTADO)
	Endif	

   lResp := AbrePar()  //Abertura Arquivo ASC II
	If !lResp
		lErro := .T.
	Endif
EndIf

If lErro
	SEA->(RestArea(aAreaSea))
	SE2->(RestArea(aAreaSe2))
	RestArea(aArea)
   Return .F.
EndIf

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Analisa o tipo de bordero e define quais headers, traillers e detalhes  Ё
//Ё de lote que ser└o utilizados.                                           Ё
//юбдддддддддддддддддддддддбдддддддддддддддддддддддддддддддддддддддддддддддды
/* ЁIdentificadores        Ё
   Ё A - Header Arquivo    цдддддддддддддддддддддддддддддддддддддддддддддддд©
   Ё B - Header Lote 1   дд╢ Header Lote Cheque/OP/DOC/Cred.CC              Ё
   Ё C - Header Lote 2   дд╢ Header Lote Cob Itaё/Outros Bancos             Ё
   Ё D - Trailer Lote 1  дд╢ Trailler Lote Cheque/OP/DOC/Cred.CC            Ё
   Ё E - Trailer Lote 2  дд╢ Trailler Lote Cob Itaё/Outros Bancos           Ё
   Ё F - Trailer Arquivo   Ё                                                Ё
   Ё G - Segmento A  дддддд╢ Cheque/OP/DOC/Cred.CC                          Ё
   Ё H - Segmento B        Ё  ""          ""                                Ё
   Ё I - Segmento L  дддддд╢ Cob Itaё/Outros Bancos                         Ё
   юдддддддддддддддддддддддадддддддддддддддддддддддддддддддддддддддддддддддды */
cHeadLote := ""
cDeta     := ""
cDetb     := ""
cDetc     := ""
cTraiLote := ""
nSeq1 := 0
lFirst := .T.
nLote	 := 0
dbSelectArea("SEA")
ProcRegua(SEA->(LastRec()))
While SEA->(!Eof()) .And. SEA->EA_NUMBOR <= mv_par02 .and. SEA->EA_FILIAL == xFilial("SEA")
	
	cModelo	:= SEA->EA_MODELO
	cNumBor	:= SEA->EA_NUMBOR
	cHeadLote := ""
	cDeta     := ""
	cDetb     := ""
	cDetc     := ""
	cTraiLote := ""
	_cConta := strtran(EA_NUMCON,"-","")
	_cConta1 := strtran(cconta,"-","")
	
	If SEA->(EA_PORTADO + EA_AGEDEP + _cConta )!= cBanco+cAgencia+_cConta1
		// Despreza borderos de outros bancos
		SEA->(DbSkip())
		Loop
	Endif
	
	If SEA->EA_CART != "P"
		// Despreza borderos de outras carteiras
		SEA->(DbSkip())
		Loop
	Endif

	If (Empty( SEA->EA_MODELO ) .or. Empty( SEA->EA_TIPOPAG ))
		Help(" ",1,"FA240SIS")
		Exit
	Endif
	
	Do Case
	Case SEA->EA_MODELO == "01"  // Credito em conta corrente
	  cHeadLote := "B"
      cDeta     := "G"
      cTraiLote := "D"
   Case SEA->EA_MODELO == "02"  // Cheque pagamento / administrativo
      cHeadLote := "B"
      cDeta     := "G"
      cTraiLote := "D"
   Case SEA->EA_MODELO $ "03#07"  // Doc C # Doc D
      cHeadLote := "B"
      cDeta     := "G"
	  //Para o Itau o Segmento B e opcional no envio de DOC e TED
	  If SEA->EA_PORTADO != "341" .and. !lIsItau
	      cDetb     := "H"
	  Endif
      cTraiLote := "D"
   Case SEA->EA_MODELO == "04"  // Op a disposicao Com aviso
	  cHeadLote := "B"
      cDeta     := "G"
      cDetb     := "H" 
      cTraiLote := "D"
   Case SEA->EA_MODELO == "05"  // Credito em conta poupanca
      cHeadLote := "B"
      cDeta     := "G"
      cTraiLote := "D"
   Case SEA->EA_MODELO == "10"  // Op a disposicao Sem aviso
      cHeadLote := "B"
      cDeta     := "G"
      cTraiLote := "D"
	Case SEA->EA_MODELO == "13"  // Pagamento a Concessionarias
   	  cHeadLote := "C"
      cDeta     := "O"
      cTraiLote := "K"	
	Case SEA->EA_MODELO == "16"  // Pagamento de Tributos DARF
   	  cHeadLote := "C"
      cDeta     := "N"
      cTraiLote := "I"	
	Case SEA->EA_MODELO == "17"  // Pagamento de Tributos GPS
   	  cHeadLote := "C"
      cDeta     := "N"
      cTraiLote := "I"	
	Case SEA->EA_MODELO == "18"  // Pagamento de Tributos DARF SIMPLES
   	  cHeadLote := "C"
      cDeta     := "N"
      cTraiLote := "I"	
	Case SEA->EA_MODELO == "19"  // Pagamento de IPTU
   	  cHeadLote := "C"
      cDeta     := "O"
      cTraiLote := "K"	
	Case SEA->EA_MODELO == "21"  // Pagamento de Tributos DARJ
   	  cHeadLote := "C"
      cDeta     := "N"
      cTraiLote := "I"	
	Case SEA->EA_MODELO == "22"  // Pagamento de Tributos GARE ICMS SP
   	  cHeadLote := "C"
      cDeta     := "N"
      cTraiLote := "I"	
   Case SEA->EA_MODELO == "30"  // Liquidacao de titulos em cobranca no Itaё
      cHeadLote := "C"
      cDeta     := "J"
      cTraiLote := "E"
   Case SEA->EA_MODELO == "31"  // Pagamento de titulos em outros bancos
      cHeadLote := "C"
      cDeta     := "J"
      cTraiLote := "E"
	Case SEA->EA_MODELO == "41"  // TED - Outro Titular
   	  cHeadLote := "B"
      cDeta     := "G"
	  //Para o Itau o Segmento B e opcional no envio de DOC e TED
	  If SEA->EA_PORTADO != "341"  .and. !lIsItau
	      cDetb     := "H"
	  Endif
      cTraiLote := "D"
	Case SEA->EA_MODELO == "43"  // TED - Mesmo Titular
   	  cHeadLote := "B"
      cDeta     := "G"
	  //Para o Itau o Segmento B e opcional no envio de DOC e TED
	  If SEA->EA_PORTADO != "341"  .and. !lIsItau
	      cDetb     := "H"
	  Endif
      cTraiLote := "D"
	Endcase
	
	//зддддддддддддддддддддддддддд©
	//Ё Grava o Header do Arquivo Ё
	//юддддддддддддддддддддддддддды
	If lFirst
		Fa240Linh("A")
		lFirst := .F.
	Endif
	
	_nLote += 1
	nLote++ // Usada dentro do arquivo de configuracao para identificar o num. do lote
	Fa240Linh(cHeadLote)
	nSeq  	  := 0
	nSomaValor := 0
	nSomaVal1  := 0
	nSomaAbat  := 0
	nSomaAcres := 0
	nSomaDecre := 0	        
	_cModelo := SEA->EA_MODELO
	// Processa um bordero
	While SEA->(!Eof()) .And. SEA->EA_NUMBOR == cNumBor .And. SEA->EA_FILIAL == xFilial("SEA") .AND. SEA->EA_MODELO == _cModelo
	
		If SEA->EA_CART != "P"
			// Despreza borderos de outras carteiras
			SEA->(DbSkip())
			Loop
		Endif

		// Borderos gerados em versao anterior
		IF Empty(SEA->EA_FILORIG) .AND. !Empty(xFilial("SE2"))
			cChave := xFilial("SE2")+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+SEA->EA_LOJA
		Else //Borderos gerados a partir da versao 7.10
			cChave := SEA->EA_FILORIG+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+SEA->EA_LOJA
		Endif

		SE2->(MsSeek(cChave))
		
		IncProc("Bord. num: " + SEA->EA_NUMBOR + " Mod: " + SEA->EA_MODELO + " Tit: " + SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO))

		If SE2->(Eof())
			Help(" ",1,"BORD240")
			SEA->(MsSeek(IncLast(xFilial("SEA")+cNumBor),.T.))
			Exit
		Endif
		
		IF SE2->E2_SALDO == 0 .Or. SE2->E2_TIPO $ MVABATIM
			SEA->(dbSkip())
			Loop
		EndIF
		IF SE2->E2_TIPO $MVRECANT+"/"+MVPROVIS
	  		SEA->(dbSkip())
			Loop
		EndIF

	  	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	  	//Ё Posiciona no fornecedor                                      Ё
	  	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	  	SA2->( dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA) )
	
		If lF240Sum
			nSomaValor += ExecBlock("F240SUM",.F.,.F.)
		Else
		  	nSomaValor += SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE
		Endif
		nSomaAbat  += SumAbatPag(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,;
						  SE2->E2_FORNECE,1,"S",dDataBase,SE2->E2_LOJA)
	
		If lF240SumA
			nSomaAcres += ExecBlock("F240SUMA",.F.,.F.)
		Else
		  	nSomaAcres += SE2->E2_SDACRES
		Endif

		If lF240SumD
			nSomaDecre += ExecBlock("F240SUMD",.F.,.F.)
		Else
		  	nSomaDecre += SE2->E2_SDDECRE
		Endif

		//If Empty(SE2->E2_IDCNAB) // So gera outro identificador, caso o titulo ainda nao o tenha
		If Empty(SE2->E2_UCNAB) // So gera outro identificador, caso o titulo ainda nao o tenha
			// Gera identificador do registro CNAB no titulo enviado
			//cIdCnab := GetSxENum("SE2", "E2_IDCNAB","E2_IDCNAB"+cEmpAnt)
			cIdCnab := GetSxENum("SE2", "E2_UCNAB","E2_UCNAB"+cEmpAnt)
			dbSelectArea("SE2")
			aOrdSE2 := SE2->(GetArea())
			dbSetOrder(11)
			While SE2->(dbSeek(xFilial("SE2")+cIdCnab))
				If ( __lSx8 )
					ConfirmSX8()
				EndIf
				//cIdCnab := GetSxENum("SE2", "E2_IDCNAB","E2_IDCNAB"+cEmpAnt)
				cIdCnab := GetSxENum("SE2", "E2_UCNAB","E2_UCNAB"+cEmpAnt)
			EndDo
			SE2->(RestArea(aOrdSE2))
			Reclock("SE2")
			//SE2->E2_IDCNAB := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA
			SE2->E2_UCNAB := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA
			MsUnlock()
			ConfirmSx8()
		Endif
		   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё Grava as linhas de detalhe de acordo com o tipo do bordero Ё
	   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	   Fa240Linh( cDeta ,@cLocaBco,@cLocaPro,@cDetb,lIsItau)
	   Fa240Linh( cDetb ,@cLocaBco,@cLocaPro)
	   Fa240Linh( cDetc ,@cLocaBco,@cLocaPro)
	
	   If lF240Grv
	     	ExecBlock("F240Grv",.F.,.F.)
	   End   
		dbSelectArea("SEA")
		dbSkip( )
	EndDo

	//здддддддддддддддддддддддддд©
	//Ё Grava o trailler de lote Ё
	//юдддддддддддддддддддддддддды
	fa240linh(cTraiLote)
EndDO

//здддддддддддддддддддддддддддддд©
//Ё Grava o trailler de arquivo  Ё
//юдддддддддддддддддддддддддддддды
fa240linh("F")

//зддддддддддддддддддддддддд©
//Ё Fecha os arquivos Ascii Ё
//юддддддддддддддддддддддддды
FCLOSE( nHdlSaida )
FCLOSE( nHdlBco )
		
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Atualiza Nёmero do ultimo Disco                              Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
dbSelectArea("SEE")
IF !Eof()
	Reclock("SEE")
   nUltDisco := VAL(EE_ULTDSK)+1
   Replace EE_ULTDSK With StrZero(nUltDisco,TamSx3("EE_ULTDSK")[1])
	MsUnlock( )
EndIF

SEA->(RestArea(aAreaSea))
SE2->(RestArea(aAreaSe2))
RestArea(aArea)

Return(.T.)

    /*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤└o    ЁFa240LinhaЁ Autor Ё Vinicius S.Barreira   Ё Data Ё 17.05.95 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤└o Ё Grava linha do Arquivo Remessa SisPag                      Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё Fa240Linha( Parametro )                                    Ё╠╠
╠╠Ё          Ё Parametro: letra correspondente  └ linha do arquivo de     Ё╠╠
╠╠Ё          Ё configura┤└o SisPag.                                       Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё FinA240                                                    Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function Fa240Linh( cParametro ,cLocaBco,cLocaPro, cDetB, lIsItau)

Local cDetB := ""
Local lIsItau := .F.

Local nLidos := 0
Local nTamArq := 0
Local nTam := 0
Local nDec := 0
Local cConteudo := ""

cLocaBco := If(Empty(cLocaBco),"",cLocaBco)
cLocaPro := If(Empty(cLocaPro),"",cLocaPro)
If ValType( cParametro ) # "C" .or. Empty( cParametro )
   Return .T.
Endif
nSeq += 1
nSeq1  += 1

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
//? L? Arquivo de Parametriza??o                                 ?
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
nLidos := 0    
FSEEK(nHdlBco,0,0)
nTamArq := FSEEK(nHdlBco,0,2)
FSEEK(nHdlBco,0,0)
nTotLinha++ // Incremento o total de linhas do arquivo
While nLidos <= nTamArq

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
	//? Verifica o tipo qual registro foi lido                       ?
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   xBuffer := Space(85)
   FREAD(nHdlBco,@xBuffer,85)

   If SubStr( xBuffer,1,1) == cParametro
      nTam := 1+(Val(SubStr(xBuffer,20,3))-Val(SubStr(xBuffer,17,3)))
      nDec := Val(SubStr(xBuffer,23,1))
      cConteudo := SubStr(xBuffer,24,60)
      
		//Necessito verificar quando for Itau, se vai ser emitido aviso ao
		//favorecido, para gerar o segmento B
		If lIsItau .and. cParametro == "G"  // Segmento A
  	   	   If SubStr(xBuffer,17,3) == "230"  //Posicao onde se informa se envia aviso
				If &(Alltrim(cConteudo)) $ "3/5/9"  //Envia aviso
					cDetB := "H"
				Endif
			Endif 
		Else                              
			If cParametro == "G" //Marco Paiva - 11.08.2009
				cDetB := "H" //Marco Paiva - 26.03.2009
			Endif	
		Endif		
				      
		If ( "Codigo Banco   "==SubStr(xBuffer,2,15) .Or.;
			  "Num. Agencia   "==SubStr(xBuffer,2,15) .Or.;
			  "Num. C/C.      "==SubStr(xBuffer,2,15) )
			If (!SubStr(xBuffer,2,15)$cLOCAPRO )
				cLOCABCO += &(ALLTRIM(cConteudo))
				cLOCAPRO += SubStr(xBuffer,2,15)
			EndIf	
		EndIf
		If ( ("CGC"$Upper(SubStr(xBuffer,2,15)) .And.;
			 AllTrim(cConteudo)=='"16670085000155"' ) .Or.; 
			 cLOCABCO=="34101403000000034594" )
			Alert("CONFIGURACAO INVALIDA")
			lGrava := .F.
		Else		
	      lGrava := fA240Grav(nTam,nDec,cConteudo)
		EndIf
      IF !lGrava
         Exit
      Endif
   Endif

   nLidos += 85
EndDO

FWRITE(nHdlSaida,CHR(13)+CHR(10))

Return
/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
?????????????????????????????????????????????????????????????????????????????
??зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд???
???Fun??o    ?NumTitulo ? Autor ? Vinicius S.Barreira   ? Data ? 27.07.95 ???
??цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд???
???Descri??o ? Retorna a chave de localiza??o do t?tulo                   ???
??цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд???
???Sintaxe   ? NumTitulo ()                                               ???
??цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд???
??? Uso      ? FinA240                                                    ???
??юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды??
?????????????????????????????????????????????????????????????????????????????
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function NumTitul()
Local cRetorno := ""
cRetorno := SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + ;
            SE2->E2_FORNECE
Return cRetorno

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
?????????????????????????????????????????????????????????????????????????????
??зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд???
???Fun??o    ?NumTitLoja? Autor ? Pilar S. Albaladejo   ? Data ? 05.04.99 ???
??цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд???
???Descri??o ? Retorna a chave de localiza??o do t?tulo + Forn + Loja     ???
??цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд???
???Sintaxe   ? NumTitLoja()                                               ???
??юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды??
?????????????????????????????????????????????????????????????????????????????
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function NumTitLoj()
Local cRetorno := ""
cRetorno := SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + ;
            SE2->E2_FORNECE + SE2->E2_LOJA
Return cRetorno

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
?????????????????????????????????????????????????????????????????????????????
??зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд???
???Fun??o    ?AbrePar   ? Autor ? Wagner Xavier         ? Data ? 26/05/92 ???
??цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд???
???Descri??o ?Abre arquivo de Parametros                                  ???
??цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд???
???Sintaxe   ?AbrePar()                                                   ???
??цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд???
??? Uso      ?FinA150                                                     ???
??юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды??
?????????????????????????????????????????????????????????????????????????????
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function AbrePar()
LOCAL cArqEnt:=mv_par03,cArqSaida

IF AT(".",mv_par04)>0
	cArqSaida:=SubStr(TRIM(mv_par04),1,AT(".",mv_par04)-1)+"."+TRIM(SEE->EE_EXTEN)
Else
	cArqSaida:=TRIM(mv_par04)+"."+TRIM(SEE->EE_EXTEN)
EndIF

IF !FILE(cArqEnt)
	Help(" ",1,"NOARQPAR")
	Return .F.
Else
	nHdlBco:=FOPEN(cArqEnt,0+64)
EndIF

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
//? Cria Arquivo Saida                                       ?
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
nHdlSaida:=MSFCREATE(cArqSaida,0)
                                               
//Marco Paiva - 03/09/2008  
//nHdlSaida:=MSFCREATE("Y:\BBTransf\Remessa\"+cArqSaida,0) 
//nHdlSaida:=MSFCREATE("C:\REMESSA\"+cArqSaida,0) 
//nHdlSaida:=MSFCREATE("\\ap5alubar\Financeiro\Remessa_Eletronica\BancoBrasil\"+cArqSaida,0) 


Return .T.

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
?????????????????????????????????????????????????????????????????????????????
??зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд???
???Fun??o    ?fA240Grava? Autor ? Pilar S. Albaladejo   ? Data ? 14.09.94 ???
??цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд???
???Descri??o ?Rotina de Gera??o do Arquivo de Remessa de Comunica??o      ???
???          ?Banc?ria p/ Contas a Receber                                ???
??цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд???
???Sintaxe   ?ExpL1 := fa240Grava(ExpN1,ExpN2,ExpC1)                      ???
??цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд???
??? Uso      ? FinA240                                                    ???
??юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды??
?????????????????????????????????????????????????????????????????????????????
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function fA240Grav( nTam,nDec,cConteudo )
Local lConteudo := .T., cCampo
   
While .T.
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
   //? Analisa conte?do                                         ?
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	IF Empty(cConteudo)
		cCampo := Space(nTam)
	Else
		lConteudo := fa150Orig( cConteudo )
		IF !lConteudo
			Exit
		Else
			IF ValType(xConteudo)="D"
				cCampo := GravaData(xConteudo,.F.)
			Elseif ValType(xConteudo)="N"
            cCampo := Substr(Strzero(xConteudo,nTam,nDec),1,nTam)
			Else
            cCampo := Substr(xConteudo,1,nTam)
			Endif
		Endif
	Endif
	IF Len(cCampo) < nTam  //Preenche campo a ser gravado, caso menor
      cCampo := cCampo+Space(nTam-Len(cCampo))
	Endif
	Fwrite( nHdlSaida,cCampo,nTam )
	Exit
Enddo
Return lConteudo


/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
?????????????????????????????????????????????????????????????????????????????
??зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд???
???Fun??o    ? SomaVal1 ? Autor ? Pilar S. Albaladejo   ? Data ? 03/03/97 ???
??цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд???
???Descri??o ? Retorna o valor total dos titulos remetidos exceto abatimen???
??цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд???
???Sintaxe   ? SomaValor()                                                ???
??цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд???
??? Uso      ? Generico                                                   ???
??юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды??
?????????????????????????????????????????????????????????????????????????????
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function SomaVal1()

If Type("nSomaVal1") == "U"
	nSomaVal1 := (nSomaValor - nSomaAbat)
Else
	nSomaVal1 += (nSomaValor - nSomaAbat)
Endif                                   

Return nSomaVal1 * 100


/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
?????????????????????????????????????????????????????????????????????????????
??зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд???
???Fun??o    ? fa240Perg? Autor ? Mauricio Pequim Jr    ? Data ? 14/05/98 ???
??цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд???
???Descri??o ? Chama Pergunta Principal                                   ???
??цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд???
???Sintaxe   ? CHAMAPER()                                                 ???
??цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд???
??? Uso      ? SIGAFIN                                                    ???
??юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды??
?????????????????????????????????????????????????????????????????????????????
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function fa240Per()
SetKey (VK_F12,{|a,b| AcessaPerg("F240BR",.T.)})
pergunte("F240BR",.F.)
Return

/*/
?????????????????????????????????????????????????????????????????????????????
??зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд???
???Fun??o	 ?Fa240Lote	? Autor ? Claudio Donizete Souza? Data ?08.02.01  ???
??цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд???
???Descri??o ? Retorna o numero do lote de serviГo    						  ???
???          ? Usado na configuracao do SISPAG        						  ???
??цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд???
??? Uso		 ? Configurador do SISPAG												  ???
??юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды??
?????????????????????????????????????????????????????????????????????????????
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function Fa240Lote()
Return nLote			// esta variavel armazena o sequencial do lote por segmento do arquivo SISPAG

/*/
?????????????????????????????????????????????????????????????????????????????
??зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд???
???Fun??o	 ?Fa240Lin 	? Autor ?Mauricio Pequim Jr     ? Data ?15.01.03  ???
??цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд???
???Descri??o ? Retorna o total de linhas do arquivo    						  ???
???          ? Usado na configuracao do SISPAG        						  ???
??цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд???
??? Uso		 ? Configurador do SISPAG												  ???
??юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды??
?????????????????????????????????????????????????????????????????????????????
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function Fa240Lin()
Return nTotLinha		// esta variavel armazena o numero de linhas do arquivo


/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
?????????????????????????????????????????????????????????????????????????????
??зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд???
???Fun??o    ? SomaAcres? Autor ?Mauricio Pequim Jr     ? Data ? 27/10/04 ???
??цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд???
???Descri??o ? Retorna o valor total dos acrescimos dos titulos remetidos ???
??цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд???
???Sintaxe   ? SomaAcres()                                                ???
??цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд???
??? Uso      ? Generico                                                   ???
??юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды??
?????????????????????????????????????????????????????????????????????????????
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function SomaAcres()
Return nSomaAcres * 100

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
?????????????????????????????????????????????????????????????????????????????
??зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд???
???Fun??o    ? SomaDecre? Autor ? Mauricio Pequim Jr    ? Data ? 27/10/04 ???
??цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд???
???Descri??o ? Retorna o valor total dos decrescimos dos titulos remetidos???
??цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд???
???Sintaxe   ? SomaDecre()                                                ???
??цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд???
??? Uso      ? Generico                                                   ???
??юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды??
?????????????????????????????????????????????????????????????????????????????
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function SomaDecre()
Return nSomaDecre * 100
   

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
?????????????????????????????????????????????????????????????????????????????
??иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм???
??╨Programa  ?AjustaSX1 ╨Autor  ?Mauricio Pequim Jr  ╨ Data ?12.01.2005   ╨??
??лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм???
??╨Desc.     ?Insere novas perguntas ao sx1                               ╨??
??╨          ?                                                            ╨??
??лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм???
??╨Uso       ? FINA240                                                    ╨??
??хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм???
?????????????????????????????????????????????????????????????????????????????
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function AjustaSX1()

PutSx1( "F240BR", "05","Marcar TМtulos Aut.?","+Traer marcado aut ?","Display Automatic Marks ?","mv_ch5","N",1,0,1,"C","","","","",;
	"mv_par05","Sim","Si ","Yes","","Nao","No","No","","","","","","","","","",,,,".FIN58011.")

Return .t.
