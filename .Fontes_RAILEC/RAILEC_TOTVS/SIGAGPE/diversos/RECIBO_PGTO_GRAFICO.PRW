#INCLUDE "RECIBO.CH"
#INCLUDE "INKEY.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#Include "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"        
#INCLUDE "PARMTYPE.CH"

#IFNDEF CRLF
        #DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF
/*
/////////////////////////////////////////////////////////////////////////////
// Funcão    : RecEftec   | Autor : Fabiano Cara        | Data : 01.03.06  //
// Funcão    : RecAlubar  | Autor : Jose Macedo         | Data : 17.04.13  //
/////////////////////////////////////////////////////////////////////////////
// Descrição : Emissao de Recibos de Pagamento                             //
/////////////////////////////////////////////////////////////////////////////
*/

User Function RecAlubar(lTerminal,cFilTerminal,cMatTerminal,cMesAnoRef,nRecTipo,cSemanaTerminal)

///////////////////////////////////////////////////////////////////////////////
//  Define Variaveis Locais (Basicas)                                        //
/////////////////////////////////////////////////////////////////////////////


Local cString:="SRA"                                       // alias do arquivo principal (Base)
Local aOrd   := {STR0001,STR0002,STR0003,STR0004,STR0005}  //"Matricula"###"C.Custo"###"Nome"###"Chapa"###"C.Custo + Nome"
Local cDesc1 := "Emissao de Recibos de Pagamento."
Local cDesc2 := "Sera impresso de acordo com os parametros solicitados pelo"
Local cDesc3 := "usuário."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local nExtra,cIndCond,cIndRc
Local Baseaux := "S", cDemit := "N"
Local cHtml := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aReturn  := {STR0009, 1,STR0010, 2, 2, 1, "",1 }	//"Zebrado"###"Administra‡„o"
Private nomeprog :="RGPER002"
Private aLinha   := { },nLastKey := 0
//Private cPerg    :="GP030EFTEC"
Private cPerg    :="GPR030"
Private cSem_De  := "  /  /    "
Private cSem_Ate := "  /  /    "
Private nAteLim , nBaseFgts , nFgts , nBaseIr , nBaseIrFe
Private cCompac , cNormal
Private aDriver 

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aLanca := {}
Private aProve := {}
Private aDesco := {}
Private aBases := {}
Private aInfo  := {}
Private aCodFol:= {}
Private li     := _PROW()
Private Titulo := "EMISSO DE RECIBOS DE PAGAMENTOS"
Private lEnvioOk := .T.

Private oFont1:= TFont():New("Courier New",,12,,.f.,,,,,.F.)  		//Tamanhos de fonte
Private oFont2:= TFont():New("Courier New",,10,,.f.,,,,,.F.)  		//Tamanhos de fonte
Private oFont3:= TFont():New("Courier New",,12,,.f.,,,,,.F.)  		//Tamanhos de fonte
Private oFont4:= TFont():New("Courier New",,08,,.f.,,,,,.F.)  		//Tamanhos de fonte

Private oPrn:=TMSPrinter():New()										// Declara o objeto a ser impresso


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="RGPER002"            //Nome Default do relatorio em Disco
IF !lTerminal
	wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)
EndIF	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o programa foi chamado do terminal - TCF         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lTerminal := If( lTerminal == Nil, .F., lTerminal )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a Ordem do Relatorio                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem := IF( !lTerminal, aReturn[8] , 1 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ 
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSemanaTerminal := IF( Empty( cSemanaTerminal ) , Space( Len( SRC->RC_SEMANA ) ) , cSemanaTerminal )
dDataRef   := IF( !lTerminal, mv_par01 , Stod(Substr(cMesAnoRef,-4)+SubStr(cMesAnoRef,1,2)+"01"))//Data de Referencia para a impressao
nTipRel    := 4 //IF( !lTerminal, mv_par02 , 3					)	//Tipo de Recibo (Pre/Zebrado/EMail/Vetnil)
Esc        := IF( !lTerminal, mv_par03 , nRecTipo			)	//Emitir Recibos(Adto/Folha/1¦/2¦/V.Extra)
Semana     := IF( !lTerminal, mv_par04 , cSemanaTerminal	)	//Numero da Semana
cFilDe     := IF( !lTerminal,mv_par05,cFilTerminal			)	//Filial De
cFilAte    := IF( !lTerminal,mv_par06,cFilTerminal			)	//Filial Ate
cCcDe      := IF( !lTerminal,mv_par07,SRA->RA_CC			)	//Centro de Custo De
cCcAte     := IF( !lTerminal,mv_par08,SRA->RA_CC			)	//Centro de Custo Ate
cMatDe     := IF( !lTerminal,mv_par09,cMatTerminal			)	//Matricula Des
cMatAte    := IF( !lTerminal,mv_par10,cMatTerminal			)	//Matricula Ate
cNomDe     := IF( !lTerminal,mv_par11,SRA->RA_NOME			)	//Nome De
cNomAte    := IF( !lTerminal,mv_par12,SRA->RA_NOME			)	//Nome Ate
ChapaDe    := IF( !lTerminal,mv_par13,SRA->RA_CHAPA 		)	//Chapa De
ChapaAte   := IF( !lTerminal,mv_par14,SRA->RA_CHAPA 		)	//Chapa Ate
Mensag1    := mv_par15										 	//Mensagem 1
Mensag2    := mv_par16											//Mensagem 2
Mensag3    := mv_par17											//Mensagem 3
cSituacao  := IF( !lTerminal,mv_par18, fSituacao( NIL , .F. ) )	//Situacoes a Imprimir
cCategoria := IF( !lTErminal,mv_par19, fCategoria( NIL , .F. ))	//Categorias a Imprimir
cBaseAux   := If(mv_par20 == 1,"S","N")							//Imprimir Bases

IF !lTerminal
	cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa Impressao                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ! PROIMPINI(cString,nTipRel)
	    Return
	Endif                                                             

EndIF

RptStatus({|lEnd| PROC001(@lEnd,wnRel,cString,cMesAnoRef)},Titulo)  // Chamada do Relatorio

Return( IF( lTerminal , cHtml , NIL ) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PROC001  ³ Autor ³ Alex Menezes          ³ Data ³ 14.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento Para emissao do Recibo                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PROC001(lEnd,WnRel,cString,cMesAnoRef,lTerminal)			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PROC001(lEnd,WnRel,cString,cMesAnoRef,lTerminal)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lIgual                 //Vari vel de retorno na compara‡ao do SRC
Local cArqNew                //Vari vel de retorno caso SRC # SX3
Local tamanho     := "P"
Local limite      := 80
Local aOrdBag     := {}
Local cMesArqRef  := If(Esc == 4,"13"+Right(cMesAnoRef,4),cMesAnoRef)
Local cArqMov     := ""
Local aCodBenef   := {}
Local cAcessaSR1  := &("{ || " + ChkRH("GPER030","SR1","2") + "}")
Local cAcessaSRA  := &("{ || " + ChkRH("GPER030","SRA","2") + "}")
Local cAcessaSRC  := &("{ || " + ChkRH("GPER030","SRC","2") + "}")
Local cAcessaSRI  := &("{ || " + ChkRH("GPER030","SRI","2") + "}")
Local cNroHoras   := &("{ || If(SRC->RC_QTDSEM > 0, SRC->RC_QTDSEM, SRC->RC_HORAS) }")
Local cHtml		  := ""	
Local nHoras      := 0
Private cAliasMov := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verifica se existe o arquivo de fechamento do mes informado  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !OpenSrc( cMesArqRef, @cAliasMov, @aOrdBag, @cArqMov, @dDataRef , NIL ,lTerminal )
	Return( IF( lTerminal , cHtml , NIL ) )
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando a Ordem de impressao escolhida no parametro.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRA")
IF !lTerminal
	If nOrdem == 1
		dbSetOrder(1)
	ElseIf nOrdem == 2
		dbSetOrder(2)
	ElseIf nOrdem == 3
		dbSetOrder(3)
	Elseif nOrdem == 4
		cArqNtx  := CriaTrab(NIL,.f.)
		cIndCond :="RA_Filial + RA_Chapa + RA_Mat"
		IndRegua("SRA",cArqNtx,cIndCond,,,STR0012)		//"Selecionando Registros..."
	ElseIf nOrdem == 5
		dbSetOrder(8)
	Endif

	dbGoTop()
	
EndIF
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando o Primeiro Registro e montando Filtro.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOrdem == 1 .or. lTerminal
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	IF !lTerminal
		dbSeek(cFilDe + cMatDe,.T.)
		cFim    := cFilAte + cMatAte
	Else
		cFim    := &(cInicio)
	EndIF	
ElseIf nOrdem == 2
	dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 3
	dbSeek(cFilDe + cNomDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim    := cFilAte + cNomAte + cMatAte
ElseIf nOrdem == 4
	dbSeek(cFilDe + ChapaDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_CHAPA + SRA->RA_MAT"
	cFim    := cFilAte + ChapaAte + cMatAte
ElseIf nOrdem == 5
	dbSeek(cFilDe + cCcDe + cNomDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME"
	cFim     := cFilAte + cCcAte + cNomAte
Endif

dbSelectArea("SRA")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua Processamento                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(RecCount())	// Total de elementos da regua

TOTVENC:= TOTDESC:= FLAG:= CHAVE := 0

Desc_Fil := Desc_End := DESC_CC:= DESC_FUNC:= ""
DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
cFilialAnt := "  "
cFuncaoAnt := "    "
cCcAnt     := Space(9)
Vez        := 0
OrdemZ     := 0

While SRA->( !Eof() .And. &cInicio <= cFim )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua Processamento                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !lTerminal
	
		IncRegua()  // Anda a regua
	                  
		If lEnd
			@Prow()+1,0 PSAY cCancel
			Exit
		Endif	 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste Parametrizacao do Intervalo de Impressao            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (SRA->RA_CHAPA < ChapaDe) .Or. (SRA->Ra_CHAPa > ChapaAte) .Or. ;
			(SRA->RA_NOME < cNomDe)    .Or. (SRA->Ra_NOME > cNomAte)    .Or. ;
			(SRA->RA_MAT < cMatDe)     .Or. (SRA->Ra_MAT > cMatAte)     .Or. ;
			(SRA->RA_CC < cCcDe)       .Or. (SRA->Ra_CC > cCcAte)
			SRA->(dbSkip(1))
			Loop
		EndIf
	
	EndIF
	
	aLanca:={}         // Zera Lancamentos
	aProve:={}         // Zera Lancamentos
	aDesco:={}         // Zera Lancamentos
	aBases:={}         // Zera Lancamentos
	nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := 0.00
	
	Ordem_rel := 1     // Ordem dos Recibos

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Data Demissao         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSitFunc := SRA->RA_SITFOLH
	dDtPesqAf:= CTOD("01/" + Left(cMesAnoRef,2) + "/" + Right(cMesAnoRef,4),"DDMMYY")
	If cSitFunc == "D" .And. (!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA) > MesAno(dDtPesqAf))
		cSitFunc := " "
	Endif	

    IF !lTerminal

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
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste controle de acessos e filiais validas				 |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
    	   dbSkip()
	       Loop
    	EndIf
    
    EndIF	
	
	If SRA->RA_CODFUNC # cFuncaoAnt           // Descricao da Funcao
		DescFun(Sra->Ra_Codfunc,Sra->Ra_Filial)
		cFuncaoAnt:= Sra->Ra_CodFunc
	Endif
	
	If SRA->RA_CC # cCcAnt                   // Centro de Custo
		DescCC(Sra->Ra_Cc,Sra->Ra_Filial)
		cCcAnt:=SRA->RA_CC
	Endif
	
	If SRA->RA_Filial # cFilialAnt
		If ! Fp_CodFol(@aCodFol,Sra->Ra_Filial) .Or. ! fInfo(@aInfo,Sra->Ra_Filial)
			Exit
		Endif
		Desc_Fil := aInfo[3]
		Desc_End := aInfo[4]                // Dados da Filial
		Desc_CGC := aInfo[8]
		DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)

		// MENSAGENS
		If MENSAG1 # SPACE(1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG1)
				DESC_MSG1 := Left(SRX->RX_TXT,30)
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG1)
				DESC_MSG1 := Left(SRX->RX_TXT,30)
			Endif
		Endif

		If MENSAG2 # SPACE(1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG2)
				DESC_MSG2 := Left(SRX->RX_TXT,30)
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG2)
				DESC_MSG2 := Left(SRX->RX_TXT,30)
			Endif
		Endif

		If MENSAG3 # SPACE(1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG3)
				DESC_MSG3 := Left(SRX->RX_TXT,30)
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG3)
				DESC_MSG3 := Left(SRX->RX_TXT,30)
			Endif
		Endif
		dbSelectArea("SRA")
		cFilialAnt := SRA->RA_FILIAL
	Endif
	
	Totvenc := Totdesc := 0
	
	If Esc == 1 .OR. Esc == 2
		dbSelectArea("SRC")
		dbSetOrder(1)
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
			While !Eof() .And. SRC->RC_FILIAL+SRC->RC_MAT == SRA->RA_FILIAL+SRA->RA_MAT
				If SRC->RC_SEMANA # Semana
					dbSkip()
					Loop
				Endif
			    If !Eval(cAcessaSRC)
			       dbSkip()
			       Loop
			    EndIf
				If (Esc == 1) .And. (Src->Rc_Pd == aCodFol[7,1])      // Desconto de Adto
					PROIMPSOM("P",aCodFol[6,1],Eval(cNroHoras),SRC->RC_VALOR)
					TOTVENC += Src->Rc_Valor
				Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[12,1])
					PROIMPSOM("D",aCodFol[9,1],Eval(cNroHoras),SRC->RC_VALOR)
					TOTDESC += SRC->RC_VALOR
				Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[8,1])
					PROIMPSOM("P",aCodFol[8,1],Eval(cNroHoras),SRC->RC_VALOR)
					TOTVENC += SRC->RC_VALOR
				Else
					If PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
						If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
							If cPaisLoc == "PAR" .and. Eval(cNroHoras) == 30
						       LocGHabRea(Ctod("01/"+SubStr(DTOC(dDataRef),4)), Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Strzero(Month(dDataRef),2)+"/"+right(str(Year(dDataRef)),2),"ddmmyy"),@nHoras)
							Else
							   nHoras := Eval(cNroHoras)
							Endif
							PROIMPSOM("P",SRC->RC_PD,nHoras,SRC->RC_VALOR)
							TOTVENC += Src->Rc_Valor
						Endif
					Elseif SRV->RV_TIPOCOD == "2"
						If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
							PROIMPSOM("D",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR)
							TOTDESC += Src->Rc_Valor
						Endif
					Elseif SRV->RV_TIPOCOD == "3"
						If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
							PROIMPSOM("B",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR)
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
			    If !Eval(cAcessaSRC)
			       dbSkip()
			       Loop
			    EndIf
				If SRC->RC_PD == aCodFol[22,1]
					PROIMPSOM("P",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR)
					TOTVENC += SRC->RC_VALOR
				Elseif Ascan(aCodBenef, { |x| x[1] == SRC->RC_PD }) > 0
					PROIMPSOM("D",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR)
					TOTDESC += SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[108,1] .Or. SRC->RC_PD == aCodFol[109,1] .Or. SRC->RC_PD == aCodFol[173,1] 
					PROIMPSOM("B",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR)
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
			    If !Eval(cAcessaSRI)
			       dbSkip()
			       Loop
			    EndIf
				If PosSrv( SRI->RI_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					PROIMPSOM("P",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR)
					TOTVENC = TOTVENC + SRI->RI_VALOR
				Elseif SRV->RV_TIPOCOD == "2"
					PROIMPSOM("D",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR)
					TOTDESC = TOTDESC + SRI->RI_VALOR
				Elseif SRV->RV_TIPOCOD == "3"
					PROIMPSOM("B",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR)
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
				If Semana # "99"			
					If SR1->R1_SEMANA # Semana
						dbSkip()
						Loop
					Endif
				Endif					
			    If !Eval(cAcessaSR1)
			       dbSkip()
			       Loop
			    EndIf
				If PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					PROIMPSOM("P",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTVENC = TOTVENC + SR1->R1_VALOR
				Elseif SRV->RV_TIPOCOD == "2"
					PROIMPSOM("D",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTDESC = TOTDESC + SR1->R1_VALOR
				Elseif SRV->RV_TIPOCOD == "3"
					PROIMPSOM("B",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
				Endif
				dbskip()
			Enddo
		Endif
	Endif
	
	dbSelectArea("SRA")
	
	If TOTVENC = 0 .And. TOTDESC = 0
		dbSkip()
		Loop
	Endif
	
	If Vez == 0  .And.  Esc == 2 //--> Verifica se for FOLHA.
		PerSemana() // Carrega Datas referentes a Semana.
	EndIf
	
	OPRIMP004()   // chamada da impressao grafica


	dbSelectArea("SRA")
	SRA->( dbSkip() )
	TOTDESC := TOTVENC := 0

EndDo

oPrn:Preview() // Para visualizar

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona arq. defaut do Siga caso Imp. Mov. Anteriores      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty( cAliasMov )
	fFimArqMov( cAliasMov , aOrdBag , cArqMov )
EndIf

IF !lTerminal

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
	
	Set Device To Screen
	
	If lEnvioOK .and. nTipRel == 3
		APMSGINFO(STR0042)	
	ElseIf nTipRel== 3
		APMSGINFO(STR0043)
	EndIf	                                                              
	If aReturn[5] = 1 .and. nTipRel # 3 
		If nTipRel # 4
			Set Printer To
			Commit
			ourspool(wnrel)
		Endif
	Endif
	MS_FLUSH()

EndIF	

Return( cHtml )


********************
Static Function PerSemana() // Pesquisa datas referentes a semana.
********************

If !Empty(Semana) 
	cChaveSem := StrZero(Year(dDataRef),4)+StrZero(Month(dDataRef),2)+SRA->RA_TNOTRAB
	If !Srx->(dbSeek(If(cFilial=="  ","  ",SRA->RA_FILIAL) + "01" + cChaveSem + Semana , .T. )) .And. ;
		!Srx->(dbSeek(If(cFilial=="  ","  ",SRA->RA_FILIAL) + "01" + Subs(cChaveSem,3,9) + Semana , .T. )) .And. ;
		!Srx->(dbSeek(If(cFilial=="  ","  ",SRA->RA_FILIAL) + "01" + Left(cChaveSem,6)+"999"+ Semana , .T. )) .And. ;
		!Srx->(dbSeek(If(cFilial=="  ","  ",SRA->RA_FILIAL) + "01" + Subs(cChaveSem,3,4)+"999"+ Semana , .T. )) .And. ;
		HELP( " ",1,"SEMNAOCAD" )
		Return Nil
	Endif
	
	If Len(AllTrim(SRX->RX_COD)) == 9
		cSem_De  := Transforma(CtoD(Left(SRX->RX_TXT,8),"DDMMYY"))
		cSem_Ate := Transforma(CtoD(Subs(SRX->RX_TXT,10,8),"DDMMYY"))
	Else
	   cSem_De  := Transforma(If("/" $ SRX->RX_TXT , CtoD(SubStr( SRX->RX_TXT, 1,10),"DDMMYY") , StoD(SubStr( SRX->RX_TXT, 1,8 ))))
	   cSem_Ate := Transforma(If("/" $ SRX->RX_TXT , CtoD(SubStr( SRX->RX_TXT, 12,10),"DDMMYY"), StoD(SubStr( SRX->RX_TXT,12,8 ))))
	EndIf
EndIf	

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PROIMPSOM ³ Autor ³ Alex Menezes          ³ Data ³ 20.03.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Somar as Verbas no Array                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PROIMPSOM(Tipo,Verba,Horas,Valor)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PROIMPSOM(cTipo,cPd,nHoras,nValor)

Local Desc_paga

Desc_paga := DescPd(cPd,Sra->Ra_Filial)  // mostra como pagto

If cTipo # 'B'
    //--Array para Recibo Pre-Impresso
    nPos := Ascan(aLanca,{ |X| X[2] = cPd })
    If nPos == 0
        Aadd(aLanca,{cTipo,cPd,Desc_Paga,nHoras,nValor})
    Else
       aLanca[nPos,4] += nHoras
       aLanca[nPos,5] += nValor
    Endif
Endif

//--Array para o Recibo Pre-Impresso
If cTipo = 'P'
   cArray := "aProve"
Elseif cTipo = 'D'
   cArray := "aDesco"
Elseif cTipo = 'B'
   cArray := "aBases"
Endif

nPos := Ascan(&cArray,{ |X| X[1] = cPd })
If nPos == 0
    Aadd(&cArray,{cPd+" "+Desc_Paga,nHoras,nValor })
Else
    &cArray[nPos,2] += nHoras
    &cArray[nPos,3] += nValor
Endif
Return

*-------------------------------------------------------
Static Function Transforma(dData) //Transforma as datas no formato DD/MM/AAAA
*-------------------------------------------------------
Return(StrZero(Day(dData),2) +"/"+ StrZero(Month(dData),2) +"/"+ Right(Str(Year(dData)),4))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PROIMPEMA | Autor ³ R.H.-Natie            ³ Data ³ 15.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envio de E-mail -Demonstrativo de Pagamento                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico :Envio Demonstrativo de Pagto atraves de eMail  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PROIMPEMA(lTerminal)

Local aFiles  	:= {}
Local cEmail		:= If(SRA->RA_RECMAIL=="S",SRA->RA_EMAIL,"    ")  
Local cHtml		:= ""
Local cSubject	:= STR0044	//" DEMONSTRATIVO DE PAGAMENTO "
Local cAlias  	:= Alias()
Local cMesComp	:= IF( Month(dDataRef) + 1 > 12 , 01 , Month(dDataRef) )
Local cTipo		:= ""
Local nZebrado	:= 0.00
Local nResto	:= 0.00	

Private cMailConta	:= NIL
Private cMailServer	:= NIL
Private cMailSenha	:= NIL

lTerminal := IF( lTerminal == NIL .or. ValType( lTerminal ) != "L" , .F. , lTerminal )

IF Esc == 1
	cTipo := STR0060 // "Adiantamento"
ElseIF Esc == 2
	cTipo := STR0061	//"Folha"
ElseIF Esc == 3 
	cTipo := STR0062 //"1a. Parcela do 13o."
ElseIF Esc == 4
	cTipo := STR0063 //"2a. Parcela do 13o."
ElseIF Esc == 5
	cTipo := STR0064 //"Valores Extras"
EndIF				

IF !lTerminal
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca parametros                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMailConta	:=If(cMailConta == NIL,GETMV("MV_EMCONTA"),cMailConta)             //Conta utilizada p/envio do email
	cMailServer	:=If(cMailServer == NIL,GETMV("MV_RELSERV"),cMailServer)           //Server 
	cMailSenha	:=If(cMailSenha == NIL,GETMV("MV_EMSENHA"),cMailSenha)
	
	If Empty(cEmail)
		Return
	Endif	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe o SMTP Server                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If 	Empty(cMailServer)
		Help(" ",1,"SEMSMTP")//"O Servidor de SMTP nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe a CONTA                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If 	Empty(cMailServer)
		Help(" ",1,"SEMCONTA")//"A Conta do email nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe a Senha                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If 	Empty(cMailServer)
		Help(" ",1,"SEMSENHA")	//"A Senha do email nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf                                              

EndIF

cHtml +=	'<html>'
cHtml +=	'<head>'
IF !lTerminal
	cHtml += 	'<title>DEMONSTRATIVO DE PAGAMENTO</title>'
	cHtml +=	'<style>'
	cHtml +=	'th { text-align:left; background-color:#4B87C2; line-height:01; line-width:400; border-left:0px solid  #FF9B06; border-right:0px solid #FF9B06; border-bottom:0px solid #FF9B06 ; border-top:0px solid #FF9B06 }'
	cHtml +=	'.tdPrinc { text-align:left; line-height:1; line-width:340 ; border-left:0px solid #FF9B06; border-right:0px solid #FF9B06; border-bottom:0px solid #FF9B06 ; border-top:0px solid #FF9B06 > }'
	cHtml +=	'.td18_94_AlignR { text-align:right ; line-height:1; line-width:94 }'
	cHtml +=	'.td18_95_AlignR { text-align:right ; line-height:1; line-width:95 }'
	cHtml +=	'.td26_94_AlignR { text-align:right ; line-height:1; line-width:94 }'
	cHtml +=	'.td26_95_AlignR { text-align:right ; line-height:1; line-width:95 }'
	cHtml += 	'.td26_18_AlignL { lext-align:left ; line-height:1; line:width:18 ; border-left:0px solid #FF9B06; border-right:0px solid #FF9B06; border-bottom:0px solid #FF9B06 ; border-top:0px solid #FF9B06 bgcolor=#6F9ECE" }'
	cHtml +=    '.pStyle1 { line-height:100% ; margin-top:15 ; margin-bottom:0 }'
	cHtml +=	'</style>'
	cHtml +=	'</head>'
	cHtml +=	'<body bgcolor="#FFFFFF"  topmargin="0" leftmargin="0">'
	cHtml +=	'<center>'
	cHtml +=	'<table  border="1" cellpadding="0" cellspacing="0" bordercolor="#FF9B06" bgcolor="#000082" width=598 height="637">'
	cHtml +=    '<td width="598" height="181" bgcolor="FFFFFF">'
	cHtml += 	'<center>'
	cHtml += 	'<font color="#000000">'
	cHtml +=	'<b>'
	cHtml += 	'<h4 size="03">'
	cHtml +=	'<br>'
	cHtml += 	STR0044 // " DEMONSTRATIVO DE PAGAMENTO "
	cHtml += 	'<br>'
Else
	cHtml += '<title>RH Online</title>' + CRLF
	cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">' + CRLF
	cHtml += '<link rel="stylesheet" href="../rhonline/css/rhonline.css" type="text/css">' + CRLF
	cHtml += '</head>' + CRLF
	cHtml += '<body bgcolor="#FFFFFF" text="#000000">' + CRLF
	cHtml += '<table width="515" border="0" cellspacing="0" cellpadding="0">' + CRLF
	cHtml += '<tr>' + CRLF
	cHtml += '<td class="titulo">' + CRLF
	cHtml += '<p><img src="../rhonline/imagens/icone_titulo.gif" width="7" height="9"> <span class="titulo_opcao">' + Capital( STR0044 ) + '</span><br>' + CRLF //DEMONSTRATIVO DE PAGAMENTO 
	cHtml += '<br>'	+ CRLF
	cHtml += '</p>'	+ CRLF
	cHtml += '</td>' + CRLF 
  	cHtml += '</tr>' + CRLF
  	cHtml += '<tr>' + CRLF
   cHtml += '<td>' + CRLF 
   cHtml += '<p><img src="../rhonline/imagens/tabela_conteudo.gif" width="515" height="12"></p>' + CRLF
   cHtml += '</td>' + CRLF
  	cHtml += '</tr>' + CRLF
  	cHtml += '<tr>' + CRLF 
   cHtml += '<td>' + CRLF
	cHtml += '<table width="515" border="0" cellspacing="0" cellpadding="0">' + CRLF
   cHtml += '<tr>' + CRLF
   cHtml += '<td background="../rhonline/imagens/tabela_conteudo_1.gif" width="10">&nbsp;</td>' + CRLF
   cHtml += '<td width="498">' + CRLF
   cHtml += '<table width="498" border="0" cellspacing="0" cellpadding="0">' + CRLF
   cHtml += '<tr>' + CRLF
EndIF    

If !Empty(Semana) .And. Semana # "99" .And.  Upper(SRA->RA_TIPOPGT) == "S" 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Datas Referente a semana                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    PerSemana()
	IF !lTerminal
		cHtml += STR0045 + Semana + " (" + cSem_De + STR0046 +	cSem_Ate + ")" //"Semana  "###" a " 
	Else
		cHtml += '<td><span class="dados">' + STR0045 + Semana + " (" + cSem_De + STR0046 +	cSem_Ate + ")" + '</span></td>' + CRLF
	EndIF	
Else
	IF !lTerminal
		cHtml += MesExtenso(Month(dDataRef))+"/"+STR(YEAR(dDataRef),4) + " - ( " + cTipo + " )"
	Else
		cHtml += '<td><span class="dados">' + MesExtenso(Month(dDataRef))+"/"+STR(YEAR(dDataRef),4) + " - ( " + cTipo + " )" + '</span></td>' + CRLF
	EndIF	
EndIf	                    

IF !lTerminal

	cHtml += '</b></h4></font></center>'
	cHtml += '<hr whidth = 100% align=right color="#FF812D">'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dados do funcionario                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cHtml += '<!Dados do Funcionario>'
	cHtml += '<p align=left  style="margin-top: 0">'
	cHtml +=   '<font color="#000082" face="Courier New"><i><b>'
	cHtml +=  	'&nbsp;&nbsp;&nbsp' + SRA->RA_NOME + "-" + SRA->RA_MAT+'</i><br>'
	cHtml += 	'&nbsp;&nbsp;&nbsp' + STR0048 + SRA->RA_CODFUNC+ "  "+DescFun(SRA->RA_CODFUNC,SRA->RA_FILIAL)	+'<br>' //"Funcao    - "
	cHtml +=  	'&nbsp;&nbsp;&nbsp' + STR0047 + SRA->RA_CC + " - " + DescCc(SRA->RA_CC,SRA->RA_FILIAL) +'<br>' //"C.Custo   - "
	cHtml +=    '&nbsp;&nbsp;&nbsp' + STR0049 + SRA->RA_BCDEPSAL+"-"+DescBco(SRA->RA_BCDEPSAL,SRA->RA_FILIAL)+ '&nbsp;'+  SRA->RA_CTDEPSAL //"Bco/Conta - "
	cHtml += '</b></p></font>'
	cHtml += '<!Proventos e Desconto>'
	cHtml += '<div align="center">'
	cHtml += '<Center>'
	cHtml += '<Table bgcolor="#6F9ECE" border="0" cellpadding ="1" cellspacing="0" width="553" height="296">'
	cHtml += '<TBody><Tr>'
	cHtml +=	'<font face="Courier New" size="02" color="#000082"><b>'
	cHtml += 	'<th>' + STR0050 + '</th>' //"Cod  Descricao "
	cHtml += 	'<th>' + STR0051 + '</th>' //"Referencia"
	cHtml += 	'<th>' + STR0052 + '</th>' //"Valores"
	cHtml += 	'</b></font></tr>'
	cHtml += '<font color=#000082 face="Courier new"  size=2">'

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Espacos Entre os Cabecalho e os Proventos/Descontos          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc"></td>'
	cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml += 	'</tr>'
Else
	cHtml += '</tr>' + CRLF
    cHtml += '<tr>' + CRLF
    cHtml += '<td>&nbsp;</td>' + CRLF
    cHtml += '</tr>' + CRLF
    cHtml += '<tr>' + CRLF
    cHtml += '<td>' + CRLF
    cHtml += '<table width="490" border="0" cellspacing="0" cellpadding="0">' + CRLF
    cHtml += '<tr align="center">' + CRLF
    cHtml += '<td width="45" height="16">' + CRLF
    cHtml += '<div align="Left"><span class="etiquetas">'+ STR0068 + '</span></div>' + CRLF //C&oacute;digo
    cHtml += '</td>' + CRLF
    cHtml += '<td width="219" valign="top">' + CRLF
    cHtml += '<div align="left"><span class="etiquetas">' + STR0069 + '</span></div>' + CRLF //Descri&ccedil;&atilde;o
    cHtml += '</td>' + CRLF
    cHtml += '<td width="127" valign="top">' + CRLF
    cHtml += '<div align="right"><span class="etiquetas">' + STR0070  + '</span></div>' + CRLF //Refer&ecirc;ncia
    cHtml += '</td>' + CRLF
    cHtml += '<td width="107" valign="top">' + CRLF
    cHtml += '<div align="right"><span class="etiquetas">' + STR0052 + '</span></div>' + CRLF //Valores
    cHtml += '<td width="107" valign="top">' + CRLF
    cHtml += '<div align="center"><span class="etiquetas"> (+/-) </span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '</tr>' + CRLF
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Proventos                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nProv:=1 to  LEN(aProve)
	nResto := ( ++nZebrado % 2 )
	IF !lTerminal
		cHtml += '<tr>'
		cHtml += 	'<td class="tdPrinc">' + aProve[nProv,1] + '</td>'
		cHtml += 	'<td class="td18_94_AlignR">' + Transform(aProve[nProv,2],'999.99')+'</td>'
		cHtml += 	'<td class="td18_95_AlignR">' + Transform(aProve[nProv,3],'@E 999,999.99') + '</td>'
		cHtml +=    '<td class="td18_18_AlignL"></td>'
		cHtml += '</tr>'
	Else
		cHtml += '<tr>' + CRLF
        IF nResto > 0.00 
        	cHtml += '<td width="45" align="center" height="19" bgcolor="#FAFBFC">' 
        Else
        	cHtml += '<td width="45" align="center" height="19">' + CRLF
        EndIF	
        cHtml += '<div align="left"><span class="dados">'  + Substr( aProve[nProv,1] , 1 , 3 ) + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
		IF nResto > 0.00         
        	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else	
        	cHtml += '<td valign="top">' + CRLF           
        EndIF	
        cHtml += '<div align="Left"><span class="dados">'  + Capital( AllTrim( Substr( aProve[nProv,1] , 4 ) ) ) + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
		IF nResto > 0.00         
        	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else	
        	cHtml += '<td valign="top">' + CRLF           
        EndIF	
        cHtml += '<div align="right"><span class="dados">' + Transform(aProve[nProv,2],'999.99') + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
		IF nResto > 0.00         
        	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else	
        	cHtml += '<td valign="top">' + CRLF           
        EndIF	
        cHtml += '<div align="right"><span class="dados">' + Transform(aProve[nProv,3],'@E 999,999.99') + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
		IF nResto > 0.00         
        	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else	
        	cHtml += '<td valign="top">' + CRLF           
        EndIF	
        cHtml += '<div align="center"><span class="dados"> (+) </span></div>' + CRLF
        cHtml += '</td>' + CRLF
        cHtml += '</tr>' + CRLF
	EndIF
Next nProv    		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Descontos                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nDesco:=1 to Len(aDesco)
	nResto := ( ++nZebrado % 2 )
	IF !lTerminal
		cHtml += '<tr>'
		cHtml += 	'<td class="tdPrinc">' + aDesco[nDesco,1] + '</td>'
		cHtml += 	'<td class="td18_94_AlignR">' + Transform(aDesco[nDesco,2],'999.99') + '</td>'
		cHtml += 	'<td class="td18_95_AlignR">' + Transform(aDesco[nDesco,3],'@E 999,999.99') + '</td>'
		cHtml += 	'<td class="td18_18_AlignL">-</td>'
		cHtml += '</tr>'
	Else
		cHtml += '<tr>' + CRLF
        IF nResto > 0.00 
        	cHtml += '<td width="45" align="center" height="19" bgcolor="#FAFBFC">' 
        Else
        	cHtml += '<td width="45" align="center" height="19">' + CRLF
        EndIF	
        cHtml += '<div align="left"><span class="dados">'  + Substr( aDesco[nDesco,1] , 1 , 3 ) + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
		IF nResto > 0.00         
        	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else	
        	cHtml += '<td valign="top">' + CRLF           
        EndIF	
        cHtml += '<div align="Left"><span class="dados">'  + Capital( AllTrim( Substr( aDesco[nDesco,1] , 4 ) ) ) + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
   		IF nResto > 0.00         
        	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else	
        	cHtml += '<td valign="top">' + CRLF           
        EndIF	
        cHtml += '<div align="right"><span class="dados">' + Transform(aDesco[nDesco,2],'999.99') + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
		IF nResto > 0.00         
        	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else	
        	cHtml += '<td valign="top">' + CRLF           
        EndIF	
        cHtml += '<div align="right"><span class="dados">' + Transform(aDesco[nDesco,3],'@E 999,999.99') + '</span></div>' + CRLF
        cHtml += '</td>' + CRLF
        IF nResto > 0.00         
        	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
        Else	
        	cHtml += '<td valign="top">' + CRLF           
        EndIF	
        cHtml += '<div align="center"><span class="dados"> (-) </span></div>' + CRLF
        cHtml += '</td>' + CRLF
        cHtml += '</tr>' + CRLF
	EndIF	
Next nDesco	   

IF !lTerminal

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Espacos Entre os Proventos e Descontos e os Totais           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc"></td>'
	cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml += 	'</tr>'
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Totais                                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cHtml += '<!Totais >'
	cHtml +=	'<b><i>'
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc">' + STR0053 + '</td>' //"Total Bruto "
	cHtml += 		'<td class="td18_94_AlignR"></td>'
	cHtml += 		'<td class="td18_95_AlignR">' + Transform(TOTVENC,"@E 999,999.99") + '</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml +=	'</tr>'
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc">' + STR0054 + '</td>' //"Total Descontos "
	cHtml += 		'<td class="td18_94_AlignR"></Td>'
	cHtml += 		'<td class="td18_95_AlignR">' + Transform(TOTDESC,"@E 999,999.99") + '</td>'
	cHtml += 		'<td class="td18_18_AlignL">-</td>'
	cHtml += 	'</tr>'
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc">' + STR0055 + '</td>' //"Liquido a Receber "
	cHtml += 		'<td class="td18_94_AlignR"></td>'
	cHtml += 		'<td align=right height="18" width="95" Style="border-left:0px solid #FF812D; border-right:0px solid #FF9B06; border-bottom:0px solid #FF9B06 ; border-top:1px solid #FF9B06 bgcolor=#4B87C2">'
	cHtml +=        Transform((TOTVENC-TOTDESC),"@E 999,999.99") +'</td>'
	cHtml += 	'</tr>'
	cHtml += '<!Bases>'
	cHtml += 	'<tr>'
Else
	cHtml += '</table><br>' + CRLF
    cHtml += '<table width="490" border="0" cellspacing="0" cellpadding="0">' + CRLF
    cHtml += '<tr align="center">' + CRLF 
    cHtml += '<td width="219" valign="top">' + CRLF 
    cHtml += '<div align="left"><span class="etiquetas"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td width="45" height="16">' + CRLF
    cHtml += '<div align="left"><span class="etiquetas"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td width="127" valign="top">' + CRLF
    cHtml += '<div align="left"><span class="etiquetas"></span></div>' + CRLF
	cHtml += '</td>'
	cHtml += '<td width="107" valign="top">'
	cHtml += '<div align="right"><span class="etiquetas"></span></div>' + CRLF
	cHtml += '</td>'
	cHtml += '<td width="107" valign="top">' 
	cHtml += '<div align="center"><span class="etiquetas"></span></div>' + CRLF
	cHtml += '</td>'
	cHtml += '</tr>'
	cHtml += '<tr>' + CRLF
   	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="left" class="etiquetas"> ' + STR0065 + '</div>' + CRLF //"Total Bruto: "
    cHtml += '</td>' + CRLF
   	cHtml += '<td width="45" align="center" height="19" bgcolor="#FAFBFC">' 
    cHtml += '<div align="left"><span class="dados"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
   	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="right"><span class="dados"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
   	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="right"><span class="dados">' + Transform(TOTVENC,"@E 999,999.99") + '</span></div>' + CRLF
    cHtml += '</td>' + CRLF
   	cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="center"><span class="dados"> (+) </span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '</tr>' + CRLF
	
	cHtml += '<tr>' + CRLF
    cHtml += '<td valign="top">' + CRLF 
    cHtml += '<div align="left" class="etiquetas">' + STR0066 + '</div>' + CRLF //"Total de Descontos: "
    cHtml += '</td>' + CRLF
    cHtml += '<td width="45" align="center" height="19">' 
    cHtml += '<div align="left"><span class="dados"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td valign="top">' + CRLF 
    cHtml += '<div align="right"><span class="dados"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td valign="top">' + CRLF 
    cHtml += '<div align="right"><span class="dados">' + Transform(TOTDESC,"@E 999,999.99") + '</span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td valign="top">' + CRLF
    cHtml += '<div align="center"><span class="dados"> (-) </span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '</tr>' + CRLF
	
	cHtml += '<tr>' + CRLF
    cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="left" class="etiquetas">' + STR0067  + '</div>' + CRLF //"L&iacute;quido a Receber: "
    cHtml += '</td>' + CRLF
    cHtml += '<td width="45" align="center" height="19" bgcolor="#FAFBFC">' 
    cHtml += '<div align="left"><span class="dados"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="right"><span class="dados"></span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="right"><span class="dados">' + Transform((TOTVENC-TOTDESC),"@E 999,999.99") + '</span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td valign="top" bgcolor="#FAFBFC">' + CRLF 
    cHtml += '<div align="center"><span class="dados"> (=) </span></div>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '</tr>' + CRLF
    cHtml += '</table>' + CRLF
    cHtml += '<br>' + CRLF
EndIF	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Espacos Entre os Totais e as Bases                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !lTerminal
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc"></td>'
	cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml += 	'</tr>'
Else
	cHtml += '<table width="498" border="0" cellspacing="0" cellpadding="0">' + CRLF
EndIF	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Base de Adiantamento                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Esc = 1  
	If cBaseAux = "S" .And. nBaseIr # 0
		IF !lTerminal
			cHtml +=	'<tr>'
			cHtml +=		'<td class="tdPrinc"><p class="pStyle1"><font color=#000082 face="Courier new" size=2><i>'+STR0058+'</i></p></td></font>' //"Base IR Adiantamento"
			cHtml +=		'<td class="td26_94_AlignR"><p></td>'
			cHtml +=		'<td class="td26_95_AlignR"><p>'+ Transform(nBaseIr,"@E 999,999,999.99")+'</td>'
			cHtml +=		'<td class="td26_18_AlignL"><p></td>'
			cHtml += 	'</tr>'
		Else
			cHtml += '<tr>'
			cHtml += '<td width="304" class="etiquetas">' + STR0058 + ' + </td>' + CRLF
            cHtml += '<td width="103" class="dados"><div align="center">' + Transform(nBaseIr,"@E 999,999.99") + '</div></td>' + CRLF
            cHtml += '<td width="91"  class="dados"><div align="center">' + Transform(0.00   ,"@E 999,999.99") + '</div></td>' + CRLF
            cHtml += '</tr>'
		EndIF	
    Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Base de Folha e de 13o 20 Parc.                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf Esc = 2 .Or. Esc = 4  
	IF cBaseAux = "S"
		IF !lTerminal
			cHtml += '<tr>'
			cHtml +=	'<td class="tdPrinc">'
   	    	cHtml +=    '<p class="pStyle1">'+ STR0056 +'</p></td>'//"Base FGTS/Valor FGTS"
			cHtml +=	'<td class="td26_94_AlignR">' + Transform(nBaseFgts,"@E 999,999.99")+'</td>'
			cHtml +=	'<td class="td26_95_AlignR">' + Transform(nFgts    ,"@E 999,999.99")+'</td>'
			cHtml += '</tr>'
			cHtml += '<tr>'
			cHtml +=	'<td class="tdPrinc">'
   	    	cHtml +=    '<p class="pStyle1">'+ STR0057 +'</p></td>'//"Base IRRF Folha/Ferias"
			cHtml +=	'<td class="td26_94_AlignR">' + Transform(nBaseIr,"@E 999,999.99")+'</td>'
			cHtml +=	'<td class="td26_95_AlignR">' + Transform(nBaseIrfe,"@E 999,999.99")+'</td>'
			cHtml += '</tr>'
		Else
			cHtml += '<tr>'
			cHtml += '<td width="304" class="etiquetas">' + STR0056 + '</td>' + CRLF //"Base FGTS/Valor FGTS"
       	    cHtml += '<td width="103" class="dados"><div align="center">' + Transform(nBaseFgts,"@E 999,999.99") + '</div></td>' + CRLF
           	cHtml += '<td width="91"  class="dados"><div align="center">' + Transform(nFgts    ,"@E 999,999.99") + '</div></td>' + CRLF
            cHtml += '</tr>'
			cHtml += '<tr>'
			cHtml += '<td width="304" class="etiquetas">' + STR0057 + '</td>' + CRLF //"Base IRRF Folha/Ferias"
       	    cHtml += '<td width="103" class="dados"><div align="center">' + Transform(nBaseIr,"@E 999,999.99") + '</div></td>' + CRLF
           	cHtml += '<td width="91"  class="dados"><div align="center">' + Transform(nBaseIrFe,"@E 999,999.99") + '</div></td>' + CRLF
            cHtml += '</tr>'
		EndIF	
	EndIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Bases de FGTS e FGTS Depositado da 1¦ Parcela                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf Esc = 3  
	If cBaseAux = "S"
		IF !lTerminal
			cHtml += 	'<tr>'
			cHtml += 		'<td class="tdPrinc">' 
			cHtml +=		'<p class="pStyle1">'+ STR0056 +'</td>' //"Base FGTS / Valor FGTS"
			cHtml += 		'<td class="td26_94_AlignL">' + Transform(nBaseFgts,"@E 999,999,999.99") +'</td>'
			cHtml += 		'<td class="td26_95_AlignL">' + Transform(nFgts,"@E 99,999,999.99")+'</td>'
			cHtml +=		'<td align=right height="26" width="95"  style="border-left: 0px solid #FF9B06; border-right:0px solid #FF9B06; border-bottom:1px solid #FF9B06 ; border-top: 0px solid #FF9B06 bgcolor=#6F9ECE"></td>'
			cHtml += 	'</tr>'
		Else
			cHtml += '<tr>'
			cHtml += '<td width="304" class="etiquetas">' + STR0056 + ' + </td>' + CRLF //"Base FGTS/Valor FGTS"
       	    cHtml += '<td width="103" class="dados"><div align="center">' + Transform(nBaseFgts,"@E 999,999.99") + '</div></td>' + CRLF
           	cHtml += '<td width="91"  class="dados"><div align="center">' + Transform(nFgts    ,"@E 999,999.99") + '</div></td>' + CRLF
            cHtml += '</tr>'
		EndIF
	Endif
Endif
	
IF !lTerminal
	cHtml += '</font></i></b>'
	cHtml += '</TBody>'
	cHtml += '</table>'
	cHtml += '</center>'
	cHtml += '</div>'
	cHtml += '<hr whidth = 100% align=right color="#FF812D">'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Espaco para Observacoes/mensagens                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cHtml += '<!Mensagem>'
	cHtml += '<Table bgColor=#6F9ECE border=0 cellPadding=0 cellSpacing=0 height=100 width=598>'
	cHtml += 	'<TBody>'
	cHtml +=	'<tr>'
	cHtml +=	'<td align=left height=18 width=574 style="border-left:1px solid #FF9B06; border-right:1px solid #FF9B06; border-bottom: 0px solid #FF9B06 ; border-top:1px solid #FF9B06 bgcolor=#6F9ECE"><i><font face="Courier New" size="2" color="#000082">'+DESC_MSG1+ '</font></td></tr>'
	cHtml +=	'<tr>'
	cHtml +=	'<td align=left height=18 width=574 style="border-left:1px solid #FF9B06; border-right:1px solid #FF9B06; border-bottom: 0px solid #FF9B06 ; border-top: 0px solid #FF9B06 bgcolor=#6F9ECE"><i><font face="Courier New" size="2" color="#000082">'+DESC_MSG2+ '</font></td></tr>'
	cHtml +=	'<tr>'
	cHtml += 	'<td align=left height=18 width=574 style="border-left:1px solid #FF9B06; border-right:1px solid #FF9B06; border-bottom:1px solid #FF9B06 ; border-top: 0px solid #FF9B06 bgcolor=#6F9ECE"><i><font face="Courier New" size="2" color="#000082">'+DESC_MSG3+ '</font></td></tr>'
	IF cMesComp == Month(SRA->RA_NASC)
		cHtml += '<TD align=left height=18 width=574 bgcolor="#FFFFFF"><EM><B><CODE>      <font face="Courier New" size="4" color="#000082">'
		cHtml += '<MARQUEE align="middle" bgcolor="#FFFFFF">' + STR0059	+ '</marquee><code></b></font></td></tr>' //"F E L I Z &nbsp;&nbsp  A N I V E R S A R I O !!!! "
	EndIF
	cHtml += '</TBody>'
	cHtml += '</Table>'
	cHtml += '</table>'
	cHtml += '</body>'
	cHtml += '</html>'
Else
	cHtml += '</table>' + CRLF
	cHtml += '<p>&nbsp;</p>' + CRLF
	cHtml += '</td>' + CRLF
    cHtml += '</tr>' + CRLF
    cHtml += '</table>' + CRLF
    cHtml += '</td>' + CRLF
    cHtml += '<td background="../rhonline/imagens/tabela_conteudo_2.gif" width="7">&nbsp;</td>' + CRLF
    cHtml += '</tr>' + CRLF
    cHtml += '</table>' + CRLF
    cHtml += '</td>' + CRLF
  	cHtml += '</tr>' + CRLF
  	cHtml += '<tr>' + CRLF  
    cHtml += '<td><img src="../rhonline/imagens/tabela_conteudo_3.gif" width="515" height="14"></td>' + CRLF
  	cHtml += '</tr>' + CRLF  
	cHtml += '</table>' + CRLF
	cHtml += '<p align="right"><a href="javascript:self.print()"><img src="../rhonline/imagens/imprimir.gif" width="90" height="28" hspace="20" border="0"></a></p>' + CRLF
	cHtml += '</body>' + CRLF
	cHtml += '</html>' + CRLF
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia e-mail p/funcionario                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cServer 		:= GetMV("MV_RELSERV")
cFrom 		:= GetMV("MV_RELACNT") // "mailing@vetnil.com.br"
cTo 			:= cEMail //cEMail  // ALLTRIM(QRY->EMAIL)
cUser 		:= GetMV("MV_RELACNT")
ccSenha 		:= GetMV("MV_RELPSW")  // "senha"
lOk 			:= .T.
cTitulo		:= cSubject
cMensagem 	:= cHtml
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PROIMPTES ºAutor  ³Alex Menezes        º Data ³  15/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Testa impressao de Formulario Teste                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function PROIMPTES(cString,nTipoRel)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Descarrega teste de impressao                                ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MS_Flush()
PROIMPINI(cString,nTipoRel)

If nTipoRel == 2
	cCompac := aDriver[1]
    cNormal := aDriver[2]
	@ LI,00 PSAY &cCompac
Endif	

Pergunte("GP030EFTEC",.T.)
Vez := If(mv_par01 = 1,1,0)

Return Vez

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PROIMPINI ºAutor  ³Natie               º Data ³  04/12/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inicializa parametros para impressao                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function  PROIMPINI(cString,nTipoRel)

aDriver := LEDriver()

If LastKey() = 27 .Or. nLastKey = 27
	Return  .F. 
Endif 

If nTipoRel# 3
	SetDefault(aReturn,cString)
Endif

If LastKey() = 27 .OR. nLastKey = 27
	Return .F.
Endif

Return .T. 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³OPRIMP004 ³ Autor ³ Alex                  ³ Data ³ 14.03.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO DO RECIBO EM OPRN			                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ OPRIMP004()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OPRIMP004()

Local nConta  := nContr := nContrT:=0
Local aDriver := LEDriver()

Private nLinhas:=1280 //780              // Numero de Linhas do Miolo do Recibo

Private cCompac := aDriver[1]
Private cNormal := aDriver[2]

IF SRA->RA_RECMAIL=="S"
   RETURN Nil                 // SE RECEBE POR EMAIL, NAO IMPRIME O ZEBRADO...
ENDIF   

Ordem_Rel := 1
oPrn:StartPage()

OPRIMPBOR1() //Imprime com 2 Borda

For _nVia = 1 to 1 //MV_PAR02				// Foi alterado por Avelino Santiago para a impressao de apenas um recibo por funcionario.

	If _nVia == 2
		LI += 135
	    nContr:=0
	Endif

	OPRIMPCAB()

	For nConta = 1 To Len(aLanca)
		fLancaVet(nConta)
		nContr +=50
		nContrT +=50
		If nContr = nLinhas .And. nContrT < (Len(aLanca)*50)
			nContr:=0
			Ordem_Rel ++
			OPRIMPCON()
			OPRIMPCAB()
		Endif
	Next
	Li+=(nLinhas-nContr)

	OPRIMPROD()

Next

oPrn:EndPage()
Li:= 0

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³OPRIMPCAB ³ Autor ³ Alex Menezes          ³ Data ³ 19.03.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO Cabe‡alho OPRN			                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ OPRIMPCAB()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OPRIMPCAB()   // Cabecalho do Recibo

_cBitMap:= "ALUBAR.BMP"

LI+= 055
oPrn:SayBitMap(LI+10,070,_cBitMap,200,100)
oPrn:Say(LI,0350,DESC_Fil,oFont3,100)
LI+= 050
oPrn:Say(LI,0350,DESC_END,oFont3,100)
LI+= 050

oPrn:Say(LI,0350,"CNPJ.: ",oFont3,100)

oPrn:Say(LI,0550,DESC_CGC,oFont3,100)

If !Empty(Semana) .And. Semana # '99' .And.  Upper(SRA->RA_TIPOPGT) == 'S'
	oPrn:Say(LI,1750,STR0013 + Semana + ' (' + cSem_De + STR0014 + cSem_Ate + ')' ,oFont2,100)
Else
	oPrn:Say(LI,1750,MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4),oFont3,100)
EndIf	

LI+= 80
oPrn:Say(LI,0060,"Matricula",oFont2,100)
oPrn:Say(LI,0350,"Nome do Funcionário",oFont2,100)
//oPrn:Say(LI,1000,"CBO",oFont2,100)
//oPrn:Say(LI,1350,"Empresa",oFont2,100)
oPrn:Say(LI,1600,"Centro de Custo",oFont2,100)
//oPrn:Say(LI,1980,"Dt Adm.: ",oFont2,100)
//oPrn:Say(LI,2150,Dtoc(SRA->RA_ADMISSA),oFont2,100)

LI+= 35
oPrn:Say(LI,0060,SRA->RA_Mat,oFont2,100)
oPrn:Say(LI,0350,Left(SRA->RA_NOME,28),oFont2,100)
//oPrn:Say(LI,1000,fCodCBO(SRA->RA_FILIAL,SRA->RA_CODFUNC,dDataRef),oFont2,100)
//oPrn:Say(LI,1350,SRA->RA_Filial,oFont2,100)
oPrn:Say(LI,1600,ALLTRIM(SRA->RA_CC)+"-"+ALLTRIM(Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01")),oFont2,100)

//oPrn:Say(LI,1980,"Dt Nasc: ",oFont2,100)
//oPrn:Say(LI,2150,Dtoc(SRA->RA_NASC),oFont2,100)

LI+= 055
oPrn:Say(LI,0060,"Função: " + SRA->RA_CODFUNC,oFont2,100)
oPrn:Say(LI,0350,DescFun(SRA->RA_CODFUNC,SRA->RA_FILIAL),oFont2,100)
//oPrn:Say(LI,1000,"R.G..: " + SRA->RA_RG,oFont2,100)
//oPrn:Say(LI,1600,"CPF..: " + SRA->RA_CIC,oFont2,100)


LI+= 90
oPrn:Say(LI,0060,"Cod. Descricao                                       Referencia        Vencimentos        Descontos",oFont2,100)
LI+= 55
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fLancaVet ³ Autor ³ Alex Menezes          ³ Data ³ 14.03.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao das Verbas (Lancamentos) OPRN				      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fLancaVet()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fLancaVet(nConta)   // Impressao dos Lancamentos

Local cString := Transform(aLanca[nConta,5],"@E 99,999,999.99")
Local nCol := If(aLanca[nConta,1]="P",1550,If(aLanca[nConta,1]="D",2000,1000))

oPrn:Say(LI,0065,aLanca[nConta,2],oFont2,100)
oPrn:Say(LI,0160,aLanca[nConta,3],oFont2,100)

If aLanca[nConta,1] # "B"        // So Imprime se nao for base
	oPrn:Say(LI,1300,TRANSFORM(aLanca[nConta,4],"999.99"),oFont2,100)
Endif

oPrn:Say(LI,nCol,cString,oFont2,100)

LI+= 50

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³OPRIMPCON ³ Autor ³ Alex Menezes          ³ Data ³ 14.03.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressap da Continuacao do Recibo OPRN                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ OPRIMPCON()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OPRIMPCON()    // Continuacao do Recibo

Li+=50
oPrn:Say(LI,060, STR0037,oFont2,100)
Li+=400

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³OPRIMPBOR1 ³ Autor ³ Alex Menezes         ³ Data ³ 14.03.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO Cabe‡alho OPRN				                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ OPRIMPCAB()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function OPRIMPBOR1()   // Cabecalho do Recibo

//Primeira Via
_ADC:=500
oPrn:Box(0045,0035,1670+_ADC,2350)//Borda externa
oPrn:Box(0060,0050,0230,2335)//Dados da Empresa
oPrn:Box(0230,0050,0380,2335)//Dados do Funcionario
oPrn:Box(0410,0050,0450,2335)//Cabec.Verbas
oPrn:Box(0450,0050,1230+_ADC,2335)//Vebas
oPrn:Box(0450,0050,1230+_ADC,0150)//Cod.das Vebas
oPrn:Box(0450,1150,1230+_ADC,1450)//Desc.das Verbas
oPrn:Box(0450,1870,1450+_ADC,2335)//Descontos

oPrn:Box(1230+_ADC,1450,1450+_ADC,2335)//Total de Vencimento
oPrn:Box(1230+_ADC,1870,1350+_ADC,2335)//Total de Desconto
oPrn:Box(1350+_ADC,1450,1450+_ADC,2335)//Valor Liquido
oPrn:Box(1350+_ADC,1870,1450+_ADC,2335)//Valor Liquido
oPrn:Box(1230+_ADC,0050,1450+_ADC,2335)//OBS
oPrn:Box(1450+_ADC,0050,1550+_ADC,2335)//Bases
oPrn:Box(1550+_ADC,0050,1650+_ADC,2335)//Assinatura


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³OPRIMPROD ³ Autor ³ Alex Menezes          ³ Data ³ 14.03.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Rodape em OPRN                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PROIMPROD()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function OPRIMPROD()    // Rodape do Recibo

Local cMesComp

oPrn:Say(LI,060,DESC_MSG1,oFont2,100)
oPrn:Say(LI,1540,"Vencimentos",oFont2,100)
oPrn:Say(LI,2030,"Descontos",oFont2,100)
LI += 50
oPrn:Say(LI,060,DESC_MSG2,oFont2,100)
oPrn:Say(LI,1550,Transform(TOTVENC,"@E 999,999,999.99"),oFont2,100)
oPrn:Say(LI,2000,Transform(TOTDESC,"@E 999,999,999.99"),oFont2,100)
LI += 50
oPrn:Say(LI,060,DESC_MSG3,oFont2,100)
LI += 50

IF MONTH(dDataRef) = MONTH(SRA->RA_NASC)
	oPrn:Say(LI,060,STR0038,oFont2,100)
ENDIF

oPrn:Say(LI,1540,"Liquido ",oFont2,100)
_nTotal := TOTVENC - TOTDESC
oPrn:Say(LI,2000,Transform(_nTotal,"@E 999,999,999.99"),oFont2,100)
LI +=60
oPrn:Say(LI,060,"Salario Base       Sal.Cont.INSS     Base Cal.FGTS     Fgts do Mes    Base Calc.IRRF   Faixa IRRF",oFont2,100)
LI +=30

If !Empty( cAliasMov )
	nValSal := 0
	fBuscaSlr(@nValSal,MesAno(dDataRef))
	If nValSal ==0
		nValSal := SRA->RA_SALARIO
	EndIf
Else
	nValSal := SRA->RA_SALARIO
EndIf

oPrn:Say(LI,060,Transform(nValSal,"@E 99,999,999.99"),oFont2,100)

If Esc = 1  // Bases de Adiantamento
    If cBaseAux = "S" .And. nBaseIr # 0
    	oPrn:Say(LI,1600,Transform(nBaseIr,"@E 99,999,999.99"),oFont2,100)
    Endif
ElseIf Esc = 2 .Or. Esc = 4  // Bases de Folha e 13o. 2o.Parc.
	If cBaseAux = "S"
		oPrn:Say(LI,460,Transform(nAteLim,"@E 999,999,999.99"),oFont2,100)		
		If nBaseFgts # 0
			oPrn:Say(LI,850,Transform(nBaseFgts,"@E 999,999,999.99"),oFont2,100)		
		Endif
		If nFgts # 0	  
			oPrn:Say(LI,1200,Transform(nFgts,"@E 999,999,999.99"),oFont2,100)					
		Endif
		If nBaseIr # 0
			oPrn:Say(LI,1600,Transform(nBaseIr,"@E 999,999,999.99"),oFont2,100)					
		Endif
		oPrn:Say(LI,2000,Transform(nBaseIrfE,"@E 999,999,999.99"),oFont2,100)					
	Endif
ElseIf Esc = 3 // Bases de FGTS e FGTS Depositado da 1¦ Parcela 
	If cBaseAux = "S"
		If nBaseFgts # 0
			oPrn:Say(LI,850,Transform(nBaseFgts,"@E 999,999,999.99"),oFont2,100)					
		Endif
		If nFgts # 0
			oPrn:Say(LI,1200,Transform(nFgts,"@E 999,999,999.99"),oFont2,100)					
		Endif
	Endif
Endif

LI +=30
IF SRA->RA_BCDEPSAL # SPACE(8)
	Desc_Bco := DescBco(Sra->Ra_BcDepSal,Sra->Ra_Filial)
	LI+=40
	oPrn:Say(LI,060,STR0039,oFont2,100)
	oPrn:Say(LI,200,SRA->RA_BCDEPSAL,oFont2,100)
	oPrn:Say(LI,400,'-',oFont2,100)
	oPrn:Say(LI,430,DESC_BCO,oFont2,100)
	oPrn:Say(LI,1000,STR0040 + SRA->RA_CTDEPSAL,oFont2,100)
	LI+=50
ELSE
	LI+=40
	oPrn:Say(LI,060,"DECLARO TER RECEBIDO A IMPORTANCIA LIQUIDA DISCRIMINADA NESTE RECIBO",oFont2,100)
	LI+=50
	oPrn:Say(LI,0100," _______/_______/_______     _______________________________________________________________________________",oFont2,100)
ENDIF
      
Return Nil


/*
// Geração do arquivo em PDF

Local nItem :=1

Private oPDF
Private n := 0     
Private oFont 			:= TFont():New("arial",9,9,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFOntc 			:= TFont():New("courier new",9,9,.T.,.F.)//,5,.T.,5,.T.,.F.)  
Private oFOntn 			:= TFont():New("arial",9,9,.T.,.T.,5,.T.,5,.T.,.F.)
private nLinha 			:= 1670 
private nLinha2 		:= 1660
Private nColuna 		:= 60 
Private nColuna2 		:= 50
Private nFinalCol 		:= 2250 
Private NfinalAmount	:= 0     
PRIVATE lAdjustToLegacy := .T. 
PRIVATE lDisableSetup  	:= .T.
private cNomePDF:= "rel.pdf"//+MV_PAR01     

//10º parâmetro como .F. gera o PDF como texto, caso contrário como imagem
// 9º parâmetro como .T. gera o PDF em tela

oPDF 	:= FWMSPrinter():New(cNomePDF, 6, lAdjustToLegacy, "C:\", lDisableSetup,,,,.F.,.T.)//, 6, lAdjustToLegacy, , lDisableSetup) 

oPDF:SetResolution(72)
oPDF:SetPortrait()
oPDF:SetPaperSize(DMPAPER_A4) 
oPDF:SetMargin(00,00,00,00)  
//oPDF:cPathPDF := "\teste\"   
oPDF:lserver:=.T.
oPDF:linjob:=.T.



Return			

//Funcao para Criacao e validacao das perguntas
/*
Static Function fAsrPerg()

Local aRegs := {}

aAdd(aRegs,{cPerg,'01','Data de Referencia','','','mv_ch1','C',06,0,0,'G','NaoVazio   ','mv_par01','               ','','','','','          ','','','','','         ','','','','','            ','','','','','           ','','','','   ',''})
aAdd(aRegs,{cPerg,'01','Tipo de Relatorio ','','','mv_ch1','C',06,0,0,'G','NaoVazio   ','mv_par01','               ','','','','','          ','','','','','         ','','','','','            ','','','','','           ','','','','   ',''})
aAdd(aRegs,{cPerg,'01','Processamento     ','','','mv_ch1','C',06,0,0,'G','NaoVazio   ','mv_par01','               ','','','','','          ','','','','','         ','','','','','            ','','','','','           ','','','','   ',''})
aAdd(aRegs,{cPerg,'01','Semana            ','','','mv_ch1','C',06,0,0,'G','NaoVazio   ','mv_par01','               ','','','','','          ','','','','','         ','','','','','            ','','','','','           ','','','','   ',''})
aAdd(aRegs,{cPerg,'01','Filial de           ','','','mv_ch1','C',06,0,0,'G','NaoVazio   ','mv_par01','               ','','','','','          ','','','','','         ','','','','','            ','','','','','           ','','','','   ',''})
aAdd(aRegs,{cPerg,'01','Periodo (MMAAAA)        ?','','','mv_ch1','C',06,0,0,'G','NaoVazio   ','mv_par01','               ','','','','','          ','','','','','         ','','','','','            ','','','','','           ','','','','   ',''})
aAdd(aRegs,{cPerg,'01','Periodo (MMAAAA)        ?','','','mv_ch1','C',06,0,0,'G','NaoVazio   ','mv_par01','               ','','','','','          ','','','','','         ','','','','','            ','','','','','           ','','','','   ',''})
aAdd(aRegs,{cPerg,'01','Periodo (MMAAAA)        ?','','','mv_ch1','C',06,0,0,'G','NaoVazio   ','mv_par01','               ','','','','','          ','','','','','         ','','','','','            ','','','','','           ','','','','   ',''})
aAdd(aRegs,{cPerg,'01','Periodo (MMAAAA)        ?','','','mv_ch1','C',06,0,0,'G','NaoVazio   ','mv_par01','               ','','','','','          ','','','','','         ','','','','','            ','','','','','           ','','','','   ',''})
aAdd(aRegs,{cPerg,'01','Periodo (MMAAAA)        ?','','','mv_ch1','C',06,0,0,'G','NaoVazio   ','mv_par01','               ','','','','','          ','','','','','         ','','','','','            ','','','','','           ','','','','   ',''})


cSemanaTerminal := IF( Empty( cSemanaTerminal ) , Space( Len( SRC->RC_SEMANA ) ) , cSemanaTerminal )
dDataRef   := IF( !lTerminal, mv_par01 , Stod(Substr(cMesAnoRef,-4)+SubStr(cMesAnoRef,1,2)+"01"))//Data de Referencia para a impressao
nTipRel    := IF( !lTerminal, mv_par02 , 3					)	//Tipo de Recibo (Pre/Zebrado/EMail/Vetnil)
Esc        := IF( !lTerminal, mv_par03 , nRecTipo			)	//Emitir Recibos(Adto/Folha/1¦/2¦/V.Extra)
Semana     := IF( !lTerminal, mv_par04 , cSemanaTerminal	)	//Numero da Semana
cFilDe     := IF( !lTerminal,mv_par05,cFilTerminal			)	//Filial De
cFilAte    := IF( !lTerminal,mv_par06,cFilTerminal			)	//Filial Ate
cCcDe      := IF( !lTerminal,mv_par07,SRA->RA_CC			)	//Centro de Custo De
cCcAte     := IF( !lTerminal,mv_par08,SRA->RA_CC			)	//Centro de Custo Ate
cMatDe     := IF( !lTerminal,mv_par09,cMatTerminal			)	//Matricula Des
cMatAte    := IF( !lTerminal,mv_par10,cMatTerminal			)	//Matricula Ate
cNomDe     := IF( !lTerminal,mv_par11,SRA->RA_NOME			)	//Nome De
cNomAte    := IF( !lTerminal,mv_par12,SRA->RA_NOME			)	//Nome Ate
ChapaDe    := IF( !lTerminal,mv_par13,SRA->RA_CHAPA 		)	//Chapa De
ChapaAte   := IF( !lTerminal,mv_par14,SRA->RA_CHAPA 		)	//Chapa Ate
Mensag1    := mv_par15										 	//Mensagem 1
Mensag2    := mv_par16											//Mensagem 2
Mensag3    := mv_par17											//Mensagem 3
cSituacao  := IF( !lTerminal,mv_par18, fSituacao( NIL , .F. ) )	//Situacoes a Imprimir
cCategoria := IF( !lTErminal,mv_par19, fCategoria( NIL , .F. ))	//Categorias a Imprimir
cBaseAux   := If(mv_par20 == 1,"S","N")							//Imprimir Bases



ValidPerg(aRegs,cPerg)

Return
