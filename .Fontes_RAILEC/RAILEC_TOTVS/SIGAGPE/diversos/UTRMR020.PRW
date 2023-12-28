#INCLUDE "RWMAKE.CH"
#INCLUDE "TRMR020.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TRMR020  ³ Autor ³ Cristina Ogura        ³ Data ³ 08.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Funcionarios para o treinamento               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TRMR020(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			   ³		³	   ³							 			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER Function UTRMR020()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cString := "SRA"        							// Alias do arquivo principal (Base)
Local cDesc1  := STR0001								//"Relatorio de Funcionarios."
Local cDesc2  := STR0002								//"Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3  := STR0003								//"usu rio."
Local aOrd    := {STR0004,STR0005,STR0006,STR0007}		//"Matricula"###"Nome"###"Centro Custo"###"Cargo"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {STR0008,1,STR0009,2,2,1,"",1 }		//"Zebrado"###"Administra‡„o"
Private NomeProg := "TRMR020"
Private aLinha   := {}
Private nLastKey := 0
Private cPerg    := "TRR020"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Titulo   := STR0010						//"Relatorio de Funcionarios"
Private Colunas  := 132 
Private AT_PRG   := "TRR020"
Private wCabec0  := 1
Private wCabec1  := ""
Private Contfl   := 1
Private Li       := 0
Private nTamanho := "M" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("TRR020",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        //  Filial de                                ³
//³ mv_par02        //  Filial ate                               ³
//³ mv_par03        //  Matricula de                             ³
//³ mv_par04        //  Matricula ate                            ³
//³ mv_par05        //  Nome de                                  ³
//³ mv_par06        //  Nome ate                                 ³
//³ mv_par07        //  Centro Custo de                          ³
//³ mv_par08        //  Centro Custo ate                         ³
//³ mv_par09        //  Cargo de                                 ³
//³ mv_par10        //  Cargo ate                                ³
//³ mv_par11        //  Imprime Graduacao S/N                    ³
//³ mv_par12        //  Imprime Historico Carreira S/N           ³
//³ mv_par13        //  Imprime Historico Carreira Empresa S/N   ³
//³ mv_par14        //  Imprime Cursos S/N                       ³
//³ mv_par15        //  Imprime Cursos Extracurriculares S/N     ³
//³ mv_par16        //  Imprime Solicitacao Cursos S/N           ³
//³ mv_par17        //  Impr. um Funcion. por Folha S/N          ³
//³ mv_par18        //  Impr Pontos S/N  		                 ³
//³ mv_par19        //  Impr Somente Totais Ptos S/N             ³
//³ mv_par20        //  Fator Graduacao De                       ³
//³ mv_par21        //  Fator Graduacao Ate                      ³
//³ mv_par22        //  Situacao do Funcionario					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="TRR020"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

If nLastKey = 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
EndIf

RptStatus({|lEnd| Tr020Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Tr020Imp ³ Autor ³ Cristina Ogura        ³ Data ³ 08.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao que imprime os requisitos dos funcionarios          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Tr020Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd        - A‡Æo do Codelock                             ³±±
±±³          ³ wnRel       - T¡tulo do relat¢rio                          ³±±
±±³          ³ cString     - Mensagem			                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TRMR020                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Tr020Imp(lEnd,WnRel,cString )
Local nOrdem 	:= aReturn[8]
Local cDet, cAuxDet
Local cEstCiv	:= "", cCodCargo:="", cDescCargo:="", cGrupo:=""
Local nLinha	:= 0, nBegin
Local cAuxCC	:= ""
Local lControle	:= .F., l1Vez:= .T.
Local cFil
Local cDtNasc 	:= Space(10)
Local cDtAdm  	:= Space(10)
Local lImp	  	:= .F.
Local cAcessaSRA:= &("{ || " + ChkRH(FunName(),"SRA","2") + "}")

Private cInicio, cFim

dbSelectArea("SRA")
If nOrdem == 1			// Matricula
	dbSetOrder(1)
	wcabec0 := 1
	wcabec1 := STR0011	//" MATR. NOME                           DT.NASC.   DT.ADMIS   EST.CIVIL         CARGO                               CENTRO CUSTO             "
						// 123456 123456789012345678901234567890 1234567890 1234567890 1-123456789012345 1234-123456789012345678901234567890 123456789-123456789012345 
ElseIf nOrdem == 2		// Nome + Matricula
	dbSetOrder(3)
	wcabec0 := 1	
	wcabec1 := STR0012	//"NOME                            MATR. DT.NASC.   DT.ADMIS   EST.CIVIL         CARGO                               CENTRO CUSTO             "
						// 123456789012345678901234567890 123456 1234567890 1234567890 1-123456789012345 1234-123456789012345678901234567890 123456789-123456789012345
ElseIf nOrdem == 3		// Centro Custo + Matricula
	dbSetOrder(2)
	wcabec0 := 1
	wcabec1 := STR0013	//" MATR. NOME                           DT.NASC.   DT.ADMIS   EST.CIVIL         CARGO                               "
						// 123456 123456789012345678901234567890 1234567890 1234567890 1-123456789012345 1234-1234567890123456789001234567890		
ElseIf nOrdem == 4		// Cargo
	dbSetOrder(7)
	wcabec0 := 1
	wcabec1 := STR0014	//"NOME                            MATR. DT.NASC.   DT.ADMIS   EST.CIVIL         CENTRO CUSTO                       "
						// 123456789012345678901234567890 123456 1234567890 1234567890 1-123456789012345 123456789-1234567890123456789012345
EndIf	


_Tipo:=3
_ANO :=STRZERO(YEAR(DDATABASE),4,0)
@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Impressao"
@ 10, 30 SAY "1-Internos 2-Externos 3-Ambos"
@ 22, 49 GET _TIPO  PICTURE "99"
@ 36, 30 SAY "Ano Base:"
@ 48, 49 GET _ANO  PICTURE "9999"

@ 60, 95 BmpButton Type 1 Action Close(oDlg2)
Activate Dialog oDlg2 Centered





cFil := If(xFilial("SRA") == "  ",xFilial("SRA"),mv_par01)

If nOrdem = 1						
	dbSeek(cFil+mv_par03,.T.)
	cInicio	:= "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim	:= mv_par02 + mv_par04
ElseIf nOrdem = 2
	dbSeek(cFil+mv_par05,.T.)
	cInicio	:= "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim	:= mv_par02 + mv_par06 + mv_par04
ElseIf nOrdem = 3
	dbSeek(cFil+mv_par07,.T.)
	cInicio	:= "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim	:= mv_par02 + mv_par08 + mv_par04
ElseIf nOrdem = 4	
	dbSeek(cFil,.T.)
	cInicio	:= "SRA->RA_FILIAL"
	cFim	:= mv_par02
EndIf	

SetRegua(RecCount())

While !Eof() .And. &cInicio <= cFim

	IncRegua()
	
	If lEnd
		@Prow()+1,0 PSAY cCancel		
		Exit
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste controle de acessos e filiais validas				 |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
       dbSkip()
       Loop
    EndIf
	
	If (SRA->RA_NOME < mv_par05) .Or. (SRA->RA_NOME > mv_par06) .Or. ;
		(SRA->RA_MAT < mv_par03) .Or. (SRA->RA_MAT > mv_par04)	.Or. ;
		(SRA->RA_CC < mv_par07) .Or. (SRA->RA_CC > mv_par08)
		dbSkip()
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste Situacao de Funcionarios							 |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(SRA->RA_SITFOLH $ mv_par22)
		dbSkip()
		Loop
	EndIf
	
	// Verificar o filtro do cargo
	        
	cCodCargo := " "
		
	dbSelectArea("SRJ")
	dbSetOrder(1)
	cFil := SRA->RA_FILIAL
   If (cFil # Nil .And. cFilial == '  ' ) .Or. cFil == Nil
      cFil := cFilial
   Endif
	
	If dbSeek(cFil+SRA->RA_CODFUNC)
		If SRJ->RJ_CARGO < mv_par09 .Or. SRJ->RJ_CARGO > mv_par10
			
			dbSelectArea("SRA")
			dbSkip()
			Loop
		EndIf	
		cCodCargo := SRJ->RJ_CARGO
	EndIf 
	
	// Centro de Custo
	If nOrdem = 3
		cDet := STR0015 + SRA->RA_CC + "-" +DescCC(SRA->RA_CC)	//"Centro de Custo: "
		If l1Vez 
			l1Vez := .F.
			IMPR(cDet,"C")
			cAuxCC := SRA->RA_CC
		EndIf
		If cAuxCC # SRA->RA_CC
			cDet:=""
			IMPR(cDet,"P")
			cDet   := STR0015 + SRA->RA_CC + "-" + DescCC(SRA->RA_CC)	//"Centro de Custo: "
			cAuxCC := SRA->RA_CC
			IMPR(cDet,"C")
		EndIf
	EndIf
	
	cEstCivil	:= Substr(TrmDesc("SX5","33"+SRA->RA_ESTCIVI,"SX5->X5_DESCRI"),1,15)
	cDescCargo	:= POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")
	cGrupo		:= SQ3->Q3_GRUPO
	
	If nOrdem # 2
		cDet:= SRA->RA_MAT + Space(01) + Substr(SRA->RA_NOME,1,30) 
	Else
		cDet:= Substr(SRA->RA_NOME,1,30) + Space(01)	+ SRA->RA_MAT 
	EndIf
	cDtNasc := 	If(__SetCentury(),Dtoc(SRA->RA_NASC),Dtoc(SRA->RA_NASC)+Space(2))
	cDtAdm 	:= 	If(__SetCentury(),Dtoc(SRA->RA_ADMISSA),Dtoc(SRA->RA_ADMISSA)+Space(2))
	
	cDet+= Space(01) + cDtNasc + Space(01) + cDtAdm + Space(01)
	cDet+= SRA->RA_ESTCIVI + "-" + cEstCivil + Space(01) + LEFT(cDescCargo,27)
	
	If nOrdem # 3
		cDet+= Space(06)+ ALLTRIM(SRA->RA_CC) + "-" + Substr(DescCC(SRA->RA_CC),1,22) 
	EndIf	
	lImp := .T.
	
	IMPR(cDet,"C")
	
	//  Imprime Graduacao S/N
	If mv_par11 == 1
		Tr020Grad(cCodCargo,cGrupo)
		lControle := .T.
	EndIf
	
	//  Imprime Historico Carreira S/N       
	If mv_par12 == 1
		Tr020HC()
		lControle := .T.
	EndIf
	
	//  Imprime Historico Carreira na Empresa S/N   
	If mv_par13 == 1
		Tr020HE()
		lControle := .T.
	EndIf
	
	//  Imprime Cursos S/N                      
	If mv_par14	== 1
		Tr020Curso(cCodCargo)
		lControle := .T.
	EndIf
	
	//  Imprime Cursos ExtraCurriculares  S/N      
	If mv_par15 == 1
		Tr020Extra()
		lControle := .T.
	EndIf
	
	// Imprime Solicitacao Cursos S/N        
	If mv_par16 == 1
		Tr020Sol()
		lControle := .T.
	EndIf
	
	cDet := ""

	dbSelectArea("SRA")
	dbSkip()	
	
	// Imprime um funcionario por Folha
	If mv_par17 == 1 
		If !Eof() .And. &cInicio <= cFim
			IMPR(cDet,"P")
		EndIf
	Else
		If lControle
			IMPR(cDet,"C")
		EndIf
	EndIf	
EndDo

If lImp
	Impr("","F")
EndIf	

dbSelectArea("SRA")
Set Filter to 
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

Return Nil

// Imprime Graduacao dos Funcionarios
*------------------------------------------*
Static Function Tr020Grad(cCargo,cGrupo)
*------------------------------------------*
Local aSaveArea := GetArea()
Local cDet, cGrau, cDescGrau
Local nLinha, nBegin
Local l1Vez 	:= .T.
Local aFator	:= {}
Local nPos		:= 0
Local nCargos	:= 0, nFuncs:=0
Local cFuncFator, cDescFator
Local nFuncPt

cDet := ""
IMPR(cDet,"C")

cDet := Space(05) + STR0017	//"GRADUACAO DO FUNCIONARIO"
IMPR(cDet,"C")

// Carrega os Fatores do Cargo e Funcionario
FMontaFator(,,cCargo,SRA->RA_MAT,cGrupo,,@aFator)
                                     
dbSelectArea("SQ8")
dbSetOrder(1)
dbSeek(xFilial("SRA")+SRA->RA_MAT)
While xFilial("SRA")+SRA->RA_MAT == SQ8->Q8_FILIAL+SQ8->Q8_MAT
	
	dbSelectArea("SQ4")
	dbSetOrder(1)
	If dbSeek(xFilial("SQ4")+cCargo+SQ8->Q8_FATOR)

		dbSelectArea("SQ8")
		dbSetOrder(1)
		
  		dbSkip()
		Loop
	EndIf
	
	cFuncFator:= SQ8->Q8_FATOR           
	cDescFator:= FDesc("SQV",SQ8->Q8_FATOR,"SQV->QV_DESCFAT",30)
	
	cFuncGrau := SQ8->Q8_GRAU
	cFuncDGrau:= FDesc("SQV",SQ8->Q8_FATOR+SQ8->Q8_GRAU,"SQV->QV_DESCGRA",30)
	
	dbSelectArea("SQ2")
	dbSetOrder(1)	 
	If dbSeek(xFilial("SQ2")+cGrupo+SQ8->Q8_FATOR+SQ8->Q8_GRAU)		
		nFuncPt	  := SQ2->Q2_PONTOSI
    EndIf
    
	Aadd(aFator,{cFuncFator,;	// Fator
				  cDescFator,;	// Descricao do Fator
				  "  ",;		// Grau do Cargo
				  Space(30),;	// Descricao do Grau do Cargo
				  0,;			// Pontos do Cargo
				  cFuncGrau,;	// Grau do Funcionario
				  cFuncDGrau,;	// Descricao do Grau do Funcionario
  				  0})			// Pontos do Funcionario(Zerado,pois cargo nao exige este fator)
//				  nFuncPt})		// Pontos do Funcionario

		
	dbSelectArea("SQ8")
	dbSkip()
EndDo

nCargos := 0
nFuncs  := 0

For nx:=1 To Len(aFator)

	// Verifica o Fator de Graduacao De/Ate
	If 	aFator[nx][1] < mv_par20 .Or.;
		aFator[nx][1] > mv_par21
		Loop
	EndIf	

	// Soma os totais de Pontos dos Cargos e Funcionarios
	nCargos := nCargos + aFator[nx][5]
	nFuncs	:= nFuncs  + aFator[nx][8]		                     

	// Imprime os pontos e somente os totais pontos dos fatores
	If mv_par18== 1 .And. mv_par19 == 1  
		l1Vez 	:= .F.    		
		Loop
	EndIf	
               
	If 	l1Vez
		l1Vez := .F.    
		// Imprime os pontos dos Fatores   
		If mv_par18 == 1    // Sim
			cDet := Space(08) + STR0037	//"FATOR NECESSARIO                  GRADUACAO NECESSARIA               PONTOS           GRADUACAO FUNCIONARIO           PONTOS"
											//"12 123456789012345678901234567890 12 123456789012345678901234567890 9999999           12 123456789012345678901234567 9999999		
		Else
			cDet := Space(08) + STR0018	//"FATOR NECESSARIO                  GRADUACAO NECESSARIA              GRADUACAO FUNCIONARIO            "
		EndIf											
											//"12 123456789012345678901234567890 12 123456789012345678901234567890 12 123456789012345678901234567890		
		IMPR(cDet,"C")								 
	EndIf	
                    
	// Imprime os pontos dos fatores
	If mv_par18 == 1		// Sim
		cDet	:= Space(08) + aFator[nx][1] + Space(01) + aFator[nx][2] + Space(01)
		cDet	+= aFator[nx][3] + Space(01) + aFator[nx][4]+ Space(01) 
		cDet    += Transform(aFator[nx][5],"@E 9999.99")+Space(11)
		cDet 	+= aFator[nx][6] + Space(01) + Left(aFator[nx][7],27)+Space(01)
		cDet	+= Transform(aFator[nx][8],"@E 9999.99")
	Else
		cDet	:= Space(08) + aFator[nx][1] + Space(01) + aFator[nx][2] + Space(01)
		cDet	+= aFator[nx][3] + Space(01) + aFator[nx][4]+ Space(01)
		cDet 	+= aFator[nx][6] + Space(01) + aFator[nx][7]
	EndIf
		
	IMPR(cDet,"C")	

Next nx                 

// Imprime os totais dos pontos
If mv_par18 # 2 .And. !l1Vez
	cDet:=""
	IMPR(cDet,"C")                    
	// Imprimir por pontos e apenas os totais
	If 	mv_par18==1 .And. mv_par19 == 1     
		cDet := Space(08) + STR0037	//"FATOR NECESSARIO                  GRADUACAO NECESSARIA               PONTOS           GRADUACAO FUNCIONARIO              PONTOS"
		IMPR(cDet,"C")
	EndIf
	cDet:= Space(50)+ STR0038 + Space(15)+ Transform(nCargos,"@E 9999.99")	// "T O T A L :"
	cDet+= Space(16)+ STR0038 + Space(15)+ Transform(nFuncs,"@E 9999.99")	// "T O T A L :"
	IMPR(cDet,"C")	
EndIf	

If l1Vez
	cDet := Space(08) + STR0019	//" *** Nao existe graduacao para este funcionario *** "
	IMPR(cDet,"C")
EndIf

RestArea(aSaveArea)

Return Nil


// Imprime os curso do cargo x cursos do funcionario
*------------------------------------*
Static Function Tr020Curso(cCargo)
*------------------------------------*
Local aSaveArea := GetArea()
Local aCurCargo	:= {}, aCurFun:={}
Local nPosAchou	:= 0, lNecessario:= .F.
Local cCurso	:= "", cDescCurso:=""
Local cEntid	:= "", cDescEnt:=""
Local i
Local cDet		:= ""
Local cDtIni 	:= cDtFin := cDtVal := Space(10)

cDET:=__PrtThinLine()
IMPR(cDet,"C")								 

cDet :=  Space(05) + STR0020	//"CURSOS DO FUNCIONARIO"
IMPR(cDet,"C")

// aCurCargo : 	1 - Codigo do Curso
//				2 - Necessario para o cargo
// 				3 - Realizado 
//				4 - Entidade
//				5 - Nota
//				6 - %Presenca                                  
//				7 - Data inicial
//				8 - Data final
//			    9 - Duracao
//				10- Unid. duracao
//				11- Validade

dbSelectArea("RA5")		// Cursos do Cargo
dbSetOrder(1)
If dbSeek(xFilial("RA5")+cCargo)
	While !Eof() .And. xFilial("RA5")+cCargo ==;
							 RA5->RA5_FILIAL+RA5->RA5_CARGO
		Aadd(aCurCargo,{RA5->RA5_CURSO,.T.,.F.,Space(04),0,0,Space(10),Space(10),0,Space(1),Space(10)})
		dbSkip()
	EndDo
EndIf

dbSelectArea("RA4")		// Cursos do Funcionario
dbSetOrder(1)
If dbSeek(xFilial("RA4")+SRA->RA_MAT)
	While !Eof() .And. xFilial("RA4")+SRA->RA_MAT ==;
							 RA4->RA4_FILIAL+RA4->RA4_MAT	

		cDtIni := If(__SetCentury(),Dtoc(RA4->RA4_DATAIN),Dtoc(RA4->RA4_DATAIN)+Space(2))	
		cDtFin := If(__SetCentury(),Dtoc(RA4->RA4_DATAFI),Dtoc(RA4->RA4_DATAFI)+Space(2))	
		cDtVal := If(__SetCentury(),Dtoc(RA4->RA4_VALIDA),Dtoc(RA4->RA4_VALIDA)+Space(2))	
        IF YEAR(RA4->RA4_DATAIN) # VAL(_ANO) .AND. VAL(_ANO)>0
           RA4->(DBSKIP())
           Loop
        ENDIF   

		nPosAchou 	:= 0					 
		nPosAchou 	:= Ascan(aCurCargo,{|x| x[1] == RA4->RA4_CURSO})
		If nPosAchou == 0
			Aadd(aCurCargo,{RA4->RA4_CURSO, .F., .T., RA4->RA4_ENTIDA, RA4->RA4_NOTA, RA4->RA4_PRESENC,;
				cDtIni, cDtFin, RA4->RA4_DURACA, RA4->RA4_UNDURA, cDtVal })
		Else
			aCurCargo[nPosAchou][3] := .T.
			aCurCargo[nPosAchou][4] := RA4->RA4_ENTIDA
			aCurCargo[nPosAchou][5] := RA4->RA4_NOTA
			aCurCargo[nPosAchou][6] := RA4->RA4_PRESENC
			aCurCargo[nPosAchou][7] := cDtIni
			aCurCargo[nPosAchou][8] := cDtFin
			aCurCargo[nPosAchou][9] := RA4->RA4_DURACA
			aCurCargo[nPosAchou][10]:= RA4->RA4_UNDURA
			aCurCargo[nPosAchou][11]:= cDtVal
		EndIf
		dbSkip()						 
	EndDo
EndIf							 

If Len(aCurCargo) > 0

    // Ordena Cursos por ordem de Data inicial
	Asort(aCurCargo,,,{|x,y| Dtos(Ctod(x[7])) < Dtos(Ctod(y[7])) })
	
	cDet := Space(08) + STR0021	//"CURSO                                PERIODO       DURACAO  VALIDADE  NECES. ENTIDADE                   NOTA PRESENCA REALIZ"
									// 1234 123456789012345678901234 1234567890 12345678901234567 1234567890 123456 1234567890123456789012345 12345 12345678 123
Else
	cDet := Space(08) + STR0022	//" *** Nao existe Curso para este Funcionario ***"
EndIf	
IMPR(cDet,"C")							 
cDET:=__PrtThinLine()
IMPR(cDet,"C")								 

For i:=1 To Len(aCurCargo)
	cDescEnt := TrmDesc("RA0",aCurCargo[i][4],"RA0->RA0_DESC")
	cDescCur := TrmDesc("RA1",aCurCargo[i][1],"RA1->RA1_DESC")
	
	cDet		:= Space(08) + aCurCargo[i][1] + "-" + ALLTRIM(cDescCur) + " ("+RA1->RA1_TIPO+")"
	IF (_TIPO=1 .AND. RA1->RA1_TIPO="T") .OR. (_TIPO=2 .AND. RA1->RA1_TIPO#"T") .OR. _TIPO=3
		
		IMPR(cDet,"C")
		
		cDet		:= SPACE(38)+aCurCargo[i][7] + Space(01) + aCurCargo[i][8]
		cDet		+= Transform(aCurCargo[i][9],"@E 999.99") + aCurCargo[i][10] + Space(01)
		cDet		+= aCurCargo[i][11] + Space(02)
		cDet		+= IIF(aCurCargo[i][2],"Sim","Nao") + Space(03)
		cDet		+= aCurCargo[i][4] + "-" + Left(cDescEnt,19) + Space(01)
		cDet		+= Transform(aCurCargo[i][5],"@E 999.99") + Space(02)
		cDet		+= Transform(aCurCargo[i][6],"@E 999.99%") + Space(02)
		cDet		+= IIF(aCurCargo[i][3],"Sim","Nao")
		IMPR(cDet,"C")
		
	ENDIF
Next i

RestArea(aSaveArea)

Return Nil


// Imprime o historico de carreira
*------------------------------------*
Static Function Tr020HC()
*------------------------------------*
Local aSaveArea := GetArea()
Local l1Vez		:= .T.
Local cDet		:= ""
Local cDtAdm 	:= Space(10)
Local cDtDem 	:= Space(10)

cDet := ""
IMPR(cDet,"C")

cDet :=  Space(05) + STR0023	//"HISTORICO DE CARREIRA"
IMPR(cDet,"C")

dbSelectArea("SQC")
dbSetOrder(1)
If dbSeek(xFilial("SQC")+SRA->RA_MAT)
	While !Eof() .And. xFilial("SQC")+SRA->RA_MAT ==;
							 SQC->QC_FILIAL+SQC->QC_MAT
							 
		If l1Vez						 
			l1Vez	:= .F.
			cDet 	:= Space(08) + STR0024	//"ADMISSAO   DEMISSAO   EMPRESA                        CARGO                         "    
											// 1234567890 1234567890 123456789012345678901234567890 123456789012345678901234567890"
			IMPR(cDet,"C")								 
		EndIf											 
	
		cDtAdm 	:= 	If(__SetCentury(),Dtoc(SQC->QC_ADMISSA),Dtoc(SQC->QC_ADMISSA)+Space(2))	
		cDtDem	:= 	If(__SetCentury(),Dtoc(SQC->QC_DEMISSA),Dtoc(SQC->QC_DEMISSA)+Space(2))
			
		cDet := Space(08) + cDtAdm + Space(01) + cDtDem
		cDet += Space(01) + SQC->QC_EMPRESA + Space(01) + SQC->QC_CARGO 
		IMPR(cDet,"C")
		
		dbSkip()					 
	EndDo						 
EndIf

If l1Vez
	cDet := Space(08) + STR0025	//" *** Nao existe Historico de Carreira para este Funcionario *** "
	IMPR(cDet,"C")
EndIf

RestArea(aSaveArea)

Return Nil

// Imprime o historico de carreira na empresa
*------------------------------------*
Static Function Tr020HE()
*------------------------------------*
Local aSaveArea := GetArea()
Local l1Vez		:= .T.
Local cDet		:= ""
Local cDescTp	:= ""
Local cDtR7 	:= Space(10)

cDet := ""
IMPR(cDet,"C")

cDet :=  Space(05) + STR0026	//"HISTORICO DE CARREIRA NA EMPRESA"
IMPR(cDet,"C")

dbSelectArea("SR7")
dbSetOrder(1)
If dbSeek(xFilial("SR7")+SRA->RA_MAT)
	While !Eof() .And. xFilial("SR7")+SRA->RA_MAT ==;
							 SR7->R7_FILIAL+SR7->R7_MAT
							 
		If l1Vez						 
			l1Vez 	:= .F.
			cDet 	:= Space(08) + STR0027	//"DT AUMENTO  TP AUMENTO               FUNCAO                   " 
											// 1234567890  123-12345678901234567890 1234-12345678901234567890"
			IMPR(cDet,"C")								 
		EndIf	
		
		cDescTp := Substr(TrmDesc("SX5","41"+SR7->R7_TIPO,"SX5->X5_DESCRI"),1,20)			 
		cDtR7 	:= 	If(__SetCentury(),Dtoc(SR7->R7_DATA),Dtoc(SR7->R7_DATA)+Space(2))	
		
		cDet := Space(08) + cDtR7 + Space(02) 
		cDet += SR7->R7_TIPO + "-" + cDescTp + Space(01) 
		cDet += SR7->R7_FUNCAO + "-" + SR7->R7_DESCFUN
		IMPR(cDet,"C")
		
		dbSkip()					 
	EndDo						 
EndIf

If l1Vez
	cDet := Space(08) + STR0028	//" *** Nao existe Historico de Carreira na Empresa para este Funcionario *** "
	IMPR(cDet,"C")
EndIf

RestArea(aSaveArea)

Return Nil

// Imprime os cursos Extra curriculares 
*------------------------------------*
Static Function Tr020Extra()
*------------------------------------*
Local aSaveArea := GetArea()
Local l1Vez		:= .T.
Local cDet		:= ""
Local nExtra	:= 0                  
Local cDtQ9		:= Space(10)

cDet := ""
IMPR(cDet,"C")

cDet :=  Space(05) + STR0030	//"CURSOS EXTRACURRICULARES"
IMPR(cDet,"C")

nExtra :=0
dbSelectArea("SQ9")                      
dbSetOrder(1)
If dbSeek(xFilial("SQ9")+SRA->RA_MAT)
	While !Eof() .And. xFilial("SQ9")+SRA->RA_MAT ==;
							 SQ9->Q9_FILIAL+SQ9->Q9_MAT
		
		// Totalizar os pontos dos cursos extracurriculares
		nExtra := nExtra + SQ9->Q9_PONTOS                                                 

		// Imprimir por pontos e apenas os totais
		If mv_par18==1 .And. mv_par19==1						
			l1Vez := .F.
			dbSkip()
			Loop
		EndIf	
										 
		If l1Vez						 
			l1Vez 	:= .F.   
			cDet 	:= Space(08) + STR0031		//"DATA       DESCRICAO                                ENTIDADE                       ESCOLARIDADE " 													
												// 1234567890 1234567890123456789012345678901234567890 123456789012345678901234567890     123          9999999"
			// Imprime pontos 
			If mv_par18 == 1 	// Sim
				cDet += Space(08) + STR0039	//"PONTOS" 
			EndIf

			IMPR(cDet,"C")								 
		EndIf	
                            
		cDtQ9 	:= 	If(__SetCentury(),Dtoc(SQ9->Q9_DATA),Dtoc(SQ9->Q9_DATA)+Space(2))	

		cDet := Space(08) + cDtQ9+ Space(01) 
		cDet += SQ9->Q9_DESCRIC + Space(01) + SQ9->Q9_ENTIDAD 
		cDet += Space(01) + IIF(SQ9->Q9_ESCOLAR=="S","Sim","Nao")

		// Imprime pontos 
		If mv_par18 == 1 	// Sim
			cDet += Space(16) + Transform(SQ9->Q9_PONTOS,"@E 9999.99")
		EndIf	
		
		IMPR(cDet,"C")
		
		dbSkip()					 
	EndDo						 
EndIf

If l1Vez
	cDet := Space(08) + STR0032	//	" *** Nao existe Curso ExtraCurricular para este Funcionario *** "
	IMPR(cDet,"C")
EndIf

If 	mv_par18#2 .And. !l1Vez
	cDet:=""
	IMPR(cDet,"C")                  
	// Imprimir por pontos apenas os totais
	If mv_par18==1 .And. mv_par19==1
		cDet := Space(08) + STR0031	//"DATA     DESCRICAO                                ENTIDADE                       ESCOLARIDADE "
		cDet += Space(08) + STR0039	//"PONTOS" 
		IMPR(cDet,"C")
	EndIf
	cDet:= Space(87)+ STR0038 + Space(12)+ Transform(nExtra,"@E 9999.99")	// "T O T A L :"
	IMPR(cDet,"C")	
EndIf

RestArea(aSaveArea)

Return Nil

// Imprime as solicitacoes dos cursos
*------------------------------------*
Static Function Tr020Sol()
*------------------------------------*
Local aSaveArea := GetArea()
Local l1Vez		:= .T.
Local cDet		:= ""
Local cDtSolic 	:= ""

cDet := ""
IMPR(cDet,"C")

cDet :=  Space(05) + STR0033	//"SOLICITACAO DE CURSOS"
IMPR(cDet,"C")

dbSelectArea("RA3")
dbSetOrder(1)
If dbSeek(xFilial("RA3")+SRA->RA_MAT)
	While !Eof() .And. xFilial("RA3")+SRA->RA_MAT ==;
							 RA3->RA3_FILIAL+RA3->RA3_MAT
							 
		If l1Vez						 
			l1Vez 	:= .F.
			cDet 	:= Space(08) + STR0034	//"CURSO                               TURMA CALENDARIO                TP RESERVA             NR VZ ADIADO   Dt.Solic." 
											// 1234-123456789012345678901234567890   123 1234-12345678901234567890 1-12345678901234567890 1234        "  
			IMPR(cDet,"C")								 
		    cDET:=__PrtThinLine()
			IMPR(cDet,"C")								 

		EndIf	
		
		cDescCurso	:= TrmDesc("RA1",RA3->RA3_CURSO,"RA1->RA1_DESC")
		cDescCalend	:= TrmDesc("RA2",RA3->RA3_CALEND,"RA2->RA2_DESC")
		cDescTp		:= Substr(TrmDesc("SX5","R7"+RA3->RA3_RESERV,"SX5->X5_DESCRI"),1,20)
		cDtSolic	:= Dtoc(RA3->RA3_DATA)
		
		cDet := Space(08) + RA3->RA3_CURSO + "-" + LEFT(cDescCurso,32) + SPACE(01)

		cDet += RA3->RA3_TURMA + Space(01) + RA3->RA3_CALEND + "-" 
		cDet += cDescCalend + Space(01) + LEFT(cDescTp,12) + Space(06)
		cDet += Transform(RA3->RA3_NVEZAD,"@E 99999")
		cDet += Space(01) + cDtSolic
		IMPR(cDet,"C")
		
		dbSkip()					 
	EndDo						 
EndIf

If l1Vez
	cDet := Space(08) + STR0035	//"*** Nao existe Solicitacao de Curso feita por este Funcionario ***"
	IMPR(cDet,"C")
EndIf

RestArea(aSaveArea)

Return Nil
