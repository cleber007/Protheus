#INCLUDE "AERFN150.CH"
#Include "PROTHEUS.Ch"
#INCLUDE "FWCOMMAND.CH"

#DEFINE QUEBR			01
#DEFINE FORNEC			02
#DEFINE TITUL			03
#DEFINE TIPO			04
#DEFINE NATUREZA		05
#DEFINE EMISSAO			06
#DEFINE VENCTO			07
#DEFINE VENCREA			08
#DEFINE VL_ORIG			09
#DEFINE VL_NOMINAL		10
#DEFINE VL_CORRIG		11
#DEFINE VL_VENCIDO		12
#DEFINE PORTADOR		13
#DEFINE VL_JUROS		14
#DEFINE ATRASO			15
#DEFINE HISTORICO		16
#DEFINE VL_SOMA			17
#DEFINE FILIAL			18

Static lFWCodFil 	:= FindFunction("FWCodFil")
Static __oDtBx   	:= NIL
Static __oTBxCanc	:= NIL
Static __cSGBD		:= NIL
Static __lCmpoFK1	:= Nil
Static __lCmpoFK2	:= Nil
Static __lPFIN002	:= Nil
Static __cMVFinFix  := NIL

User Function AERFN150()

	Local oReport As Object

	Private cTitAux 	As Character    // Guarda o titulo do relat�rio para R3 e R4
	Private aSelFil		As Array

	cTitAux := ""    // Guarda o titulo do relat�rio para R3 e R4
	aSelFil	:= {}

	oReport := ReportDef()
	oReport:PrintDialog()

Return

/*/{Protheus.doc} ReportDef
Posi��o dos T�tulos a Pagar
@type user function 
@author Daniel Tadashi Batori
@since 07/08/06
/*/
Static Function ReportDef()
	Local oReport
	Local oSection1
	Local cPictTit
	Local nTamVal, nTamCli, nTamQueb
	Local cHistorico := ""
	Local aOrdem := {STR0008,;	//"Por Numero"
					STR0009,;	//"Por Natureza"
					STR0010,;	//"Por Vencimento"
					STR0011,;	//"Por Banco"
					STR0012,;	//"Fornecedor"
					STR0013,;	//"Por Emissao"
					STR0014}	//"Por Cod.Fornec."

	oReport := TReport():New("FINR150",STR0005,"FIN150",{|oReport| ReportPrint(oReport)},STR0001+STR0002)

	oReport:SetLandScape(.T.)
	oReport:SetTotalInLine(.F.)	//Imprime o total em linha

	/*GESTAO - inicio */
	oReport:SetUseGC(.F.)
	/* GESTAO - fim*/

	VerifProc()	
	
	If !(FwGetRunSchedule())
		Pergunte("FIN150",.F.)
	EndIf

	//  Variaveis utilizadas para par�metros
	//  MV_PAR01	  // do Numero 			  
	//  MV_PAR02	  // at� o Numero 		  
	//  MV_PAR03	  // do Prefixo			  
	//  MV_PAR04	  // at� o Prefixo		  
	//  MV_PAR05	  // da Natureza  	      
	//  MV_PAR06	  // at� a Natureza		  
	//  MV_PAR07	  // do Vencimento		  
	//  MV_PAR08	  // at� o Vencimento	  
	//  MV_PAR09	  // do Banco			  
	//  MV_PAR10	  // at� o Banco		  
	//  MV_PAR11	  // do Fornecedor		  
	//  MV_PAR12	  // at� o Fornecedor	  
	//  MV_PAR13	  // Da Emiss�o			  
	//  MV_PAR14	  // Ate a Emiss�o		  
	//  MV_PAR15	  // qual Moeda			  
	//  MV_PAR16	  // Imprime Provis�rios  
	//  MV_PAR17	  // Reajuste pelo vencto 
	//  MV_PAR18	  // Da data contabil	  
	//  MV_PAR19	  // Ate data contabil	  
	//  MV_PAR20	  // Imprime Rel anal/sint
	//  MV_PAR21	  // Saldo retroativo?    
	//  MV_PAR22	  // Cons filiais abaixo ?
	//  MV_PAR23	  // Filial de            
	//  MV_PAR24	  // Filial ate           
	//  MV_PAR25	  // Loja de              
	//  MV_PAR26	  // Loja ate             
	//  MV_PAR27 	  // Considera Adiantam.? 
	//  MV_PAR28	  // Imprime Nome 		  
	//  MV_PAR29	  // Outras Moedas 		  
	//  MV_PAR30      // Imprimir os Tipos    
	//  MV_PAR31      // Nao Imprimir Tipos	  
	//  MV_PAR32      // Consid. Fluxo Caixa  
	//  MV_PAR33      // DataBase             
	//  MV_PAR34      // Tipo de Data p/Saldo 
	//  MV_PAR35      // Quanto a taxa		  
	//  MV_PAR36      // Tit.Emissao Futura	  
	//  MV_PAR37      // Seleciona filiais    
	//  MV_PAR38      // Considera Tit Exclu  
	//  MV_PAR39      // Considera Abatimento 

	cPictTit := PesqPict("SE2","E2_VALOR")
	If cPaisLoc == "CHI"
		cPictTit := SubStr(cPictTit,1,At(".",cPictTit)-1)
	EndIf

	nTamVal	 := TamSX3("E2_VALOR")[1]
	nTamCli	 := TamSX3("E2_FORNECE")[1] + TamSX3("E2_LOJA")[1] + 25
	nTamTit	 := TamSX3("E2_PREFIXO")[1] + TamSX3("E2_NUM")[1] + TamSX3("E2_PARCELA")[1] + 8
	nTamQueb := nTamCli + nTamTit + TamSX3("E2_TIPO")[1] + TamSX3("E2_NATUREZ")[1] + TamSX3("E2_EMISSAO")[1] +;
				TamSX3("E2_VENCTO")[1] + TamSX3("E2_VENCREA")[1] + 14
	// Secao 1
	oSection1 := TRSection():New(oReport,STR0061,{"SE2","SA2"},aOrdem)

	cHistorico := IIf(cPaisloc == "MEX" , STR0063 , STR0059)

	TRCell():New(oSection1, "FORNECEDOR"	,		, STR0038					, 			, nTamCli						, .F. ,) //"Codigo-Nome do Fornecedor"
	TRCell():New(oSection1, "TITULO"		,		, STR0039 + CRLF + STR0040	, 			, nTamTit						, .F. ,) //"Prf-Numero" + "Parcela"
	TRCell():New(oSection1, "E2_TIPO"		, "SE2"	, STR0041					, 			,								, .F. ,) //"TP"
	TRCell():New(oSection1, "E2_NATUREZ"	, "SE2"	, STR0042					, 			, TamSX3("E2_NATUREZ")[1] + 5	, .F. ,) //"Natureza"
	TRCell():New(oSection1, "E2_EMISSAO"	, "SE2"	, STR0043 + CRLF + STR0044	, 			,								, .F. ,) //"Data de" + "Emissao"
	TRCell():New(oSection1, "E2_VENCTO"		, "SE2"	, STR0043 + CRLF + STR0045	, 			,								, .F. ,) //"Vencto" + "Titulo"
	TRCell():New(oSection1, "E2_VENCREA"	, "SE2"	, STR0045 + CRLF + STR0047	, 			,								, .F. ,) //"Vencto" + "Real"
	TRCell():New(oSection1, "VAL_ORIG"		,		, STR0048					, cPictTit	, nTamVal + 3					, .F. ,) //"Valor Original"
	TRCell():New(oSection1, "VAL_NOMI"		,		, STR0049 + CRLF + STR0050	, cPictTit	, nTamVal + 3					, .F. ,) //"Tit Vencidos" + "Valor Nominal"
	TRCell():New(oSection1, "VAL_CORR"		,		, STR0049 + CRLF + STR0051	, cPictTit	, nTamVal + 3					, .F. ,) //"Tit Vencidos" + "Valor Corrigido"
	TRCell():New(oSection1, "VAL_VENC"		,		, STR0052 + CRLF + STR0050	, cPictTit	, nTamVal + 3					, .F. ,) //"Titulos a Vencer" + "Valor Nominal"
	TRCell():New(oSection1, "E2_PORTADO"	, "SE2"	, STR0053 + CRLF + STR0054	, 			,								, .F. ,) //"Porta-" + "dor"
	TRCell():New(oSection1, "JUROS"			,		, STR0055 + CRLF + STR0056	, cPictTit	, nTamVal + 3					, .F. ,) //"Vlr.juros ou" + "permanencia"
	TRCell():New(oSection1, "DIA_ATR"		, 		, STR0057 + CRLF + STR0058	,			, 4								, .F. ,) //"Dias" + "Atraso"
	TRCell():New(oSection1, "E2_HIST"		, "SE2"	, cHistorico				,			, 35							, .F. ,) //"Historico(Vencidos+Vencer)"
	TRCell():New(oSection1, "VAL_SOMA"		, 		, STR0060					, cPictTit, nTamVal + 7						, .F. ,) //"(Vencidos+Vencer)"

	oSection1:Cell("VAL_ORIG"):SetHeaderAlign("RIGHT")
	oSection1:Cell("VAL_NOMI"):SetHeaderAlign("RIGHT")
	oSection1:Cell("VAL_CORR"):SetHeaderAlign("RIGHT")
	oSection1:Cell("VAL_VENC"):SetHeaderAlign("RIGHT")
	oSection1:Cell("JUROS")   :SetHeaderAlign("RIGHT")
	oSection1:Cell("VAL_SOMA"):SetHeaderAlign("RIGHT")

	oSection1:SetLineBreak(.f.)		//Quebra de linha automatica

	oSection2 := TRSection():New(oReport,STR0062,{"SM0"},aOrdem)

	TRCell():New(oSection2,"FILIAL"		,		, STR0065					,			, 105)					//"Total por Filial:"
	TRCell():New(oSection2,"FILLER1"	, ""	, ""						,			, 10			, .F.,)
	TRCell():New(oSection2,"VALORORIG"	,		, STR0048					, cPictTit	, nTamVal + 03)			//"Valor Original"
	TRCell():New(oSection2,"VALORNOMI"	,		, STR0049 + CRLF + STR0050	, cPictTit	, nTamVal + 03)			//"Tit Vencidos" + "Valor Nominal"
	TRCell():New(oSection2,"VALORCORR"	,		, STR0049 + CRLF + STR0051	, cPictTit	, nTamVal + 03)			//"Tit Vencidos" + "Valor Corrigido"
	TRCell():New(oSection2,"VALORVENC"	,		, STR0052 + CRLF + STR0050	, cPictTit	, nTamVal + 03)			//"Titulos a Vencer" + "Valor Nominal"
	TRCell():New(oSection2,"JUROS"		,		, STR0055 + CRLF + STR0056	, cPictTit	, nTamVal + 05)			//"Vlr.juros ou" + "permanencia"
	TRCell():New(oSection2,"VALORSOMA"	,		, STR0060					, cPictTit	, nTamVal + 20)			//"(Vencidos+Vencer)"

	oSection2:Cell("VALORORIG"):SetHeaderAlign("RIGHT")
	oSection2:Cell("VALORNOMI"):SetHeaderAlign("RIGHT")
	oSection2:Cell("VALORCORR"):SetHeaderAlign("RIGHT")
	oSection2:Cell("VALORVENC"):SetHeaderAlign("RIGHT")
	oSection2:Cell("JUROS")   :SetHeaderAlign("RIGHT")
	oSection2:Cell("VALORSOMA"):SetHeaderAlign("RIGHT")

	oSection2:SetLineBreak(.F.)

Return oReport

/*/{Protheus.doc} ReportPrint
A funcao eStatica ReportDef devera ser criada para todos os
relatorios que poderao ser agendados pelo usuario.
@TYPE USER FINCTION
@author Daniel Tadashi Batori
@since 07/08/06
@param oReport, Object, Objeto Report do Relat�rio
/*/
Static Function ReportPrint(oReport)

	Local oSection1		:= oReport:Section(1)
	Local oSection2		:= oReport:Section(2)
	Local nOrdem 		:= oSection1:GetOrder()
	Local oBreak		:= Nil
	Local oBreak2		:= Nil
	Local oBreak3		:= Nil
	Local aDados		:= {}
	Local nRegEmp 		:= SM0->(RecNo())
	Local nRegSM0 		:= SM0->(Recno())
	Local nAtuSM0		:= SM0->(Recno())
	Local dOldDtBase 	:= dDataBase
	Local dOldData 		:= dDataBase
	Local nJuros  		:=0
	Local nQualIndice 	:= 0
	Local lContinua 	:= .T.
	Local nTit0			:=0,nTit1:=0,nTit2:=0,nTit3:=0,nTit4:=0,nTit5:=0
	Local nTot0			:=0,nTot1:=0,nTot2:=0,nTot3:=0,nTot4:=0,nTotTit:=0,nTotJ:=0,nTotJur:=0
	LOcal nTotFil0		:=0, nTotFil1:=0, nTotFil2:=0, nTotFil3:=0,nTotFil4:=0, nTotFilTit:=0, nTotFilJ:=0
	Local nFil0			:=0,nFil1:=0,nFil2:=0,nFil3:=0,nFil4:=0,nFilTit:=0,nFilJ:=0
	Local cCond1,cCond2,cCarAnt,nSaldo:=0,nAtraso:=0
	Local dDataReaj
	Local dDataAnt 		:= dDataBase , lQuebra
	Local nMestit0		:= nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
	Local cChaveSe2
	Local cFilDe,cFilAte
	Local nTotsRec 		:= SE2->(RecCount())
	Local nDecs 		:= MsDecimais(MV_PAR15)
	Local lFr150Flt 	:= ExistBlock("FR150FLT")
	Local cFr150Flt 	:= IIf(lFr150Flt,ExecBlock("FR150FLT",.F.,.F.),"")
	Local cMoeda 		:= LTrim(Str(MV_PAR15))
	Local cFilterUser 	:= ""
	Local cFilUserSA2 	:= ""

	Local cNomFor	 	:= ""
	Local cNomNat	 	:= ""
	Local cNomFil	 	:= ""
	Local cNumBco	 	:= ""
	Local nTotVenc	 	:= 0
	Local nTotMes	 	:= 0
	Local nTotGeral  	:= 0
	Local nTotTitMes 	:= 0
	Local nTotFil	 	:= 0
	Local dDtVenc	 	:= CToD("  /  /    ")
	Local cFilialSE2 	:= ""
	Local nInc 		 	:= 0
	Local aSM0 		 	:= {}
	Local cPictTit 	 	:= ""
	Local nGerTot 	 	:= 0
	Local nFilTot 		:= 0
	Local nAuxTotFil 	:= 0
	Local nRecnoSE2 	:= 0
	Local nRecFiltro    := 0
	Local aTotFil 		:= {}
	local lQryEmp 		:= .F.
	Local nI 			:= 0
	Local dUltBaixa		:= SToD("")
	Local lExistFJU 	:= FJU->(ColumnPos("FJU_RECPAI")) > 0 .And. FindFunction("FinGrvEx")
	Local cCampos 		:= ""
	Local cQueryP 		:= ""
	Local cQuery		:= ""
	Local cQryBx		:= ""
	Local cInsert		:= ""
	Local cSelect		:= ""
	Local cFrom			:= ""
	Local cWhere		:= ""
	Local cTable		:= ""
	Local cValues		:= ""
	Local aStru 		:= SE2->(DbStruct())
	Local aStruSE2 		:= {}
	Local nFilAtu		:= 0
	Local nLenSelFil	:= 0
	Local nTamUnNeg		:= 0
	Local nTamEmp		:= 0
	Local nTotEmp		:= 0
	Local nTotEmpJ		:= 0
	Local nTotEmp0		:= 0
	Local nTotEmp1		:= 0
	Local nTotEmp2		:= 0
	Local nTotEmp3		:= 0
	Local nTotEmp4		:= 0
	Local nTotTitEmp	:= 0
	Local cNomEmp		:= ""
	Local lTotEmp		:= .F.
	Local oBrkFil		:= Nil
	Local oBrkEmp		:= Nil
	Local oBrkNat		:= Nil
	Local lFValAcess	:= ExistFunc("FValAcess")
	Local nVa			:= 0
	Local lImprimeAb	:= Type("MV_PAR39") == "N" .And. MV_PAR39 == 1
	Local lSemTaxaM2	:= .F.
	Local nTaxaDia		:= 1
	Local lImpXlsTbl	:= oReport:lXlsTable .And. MV_PAR20 == 1
	Local lReposic      := .F.
	Local lMstErro 		:= .F.
	Local nFilial 		:= 0	
	Local aSelFilBkp	:= {}
	Local aSM0Bkp		:= {}
	Local lBuscaFil		:= .T.
	Local nPosFil 		:= 1
	Local lCancPrint	:= .F.
	Local lCmpMulFil    := .F.
	Local nRecSE2Tmp    := 0
	Local lGestaoEmp	:= !(Empty(FwSM0Layout(, 1)))
	Local lGestaoUni	:= !(Empty(FwSM0Layout(, 2)))
	Local lSE2EmpExc	:= FwModeAccess("SE2", 1) == "E"
	Local lSE2UniExc	:= FwModeAccess("SE2", 2) == "E"
	Local lSE2FilExc	:= FwModeAccess("SE2", 3) == "E"
	Local lSelectFil	:= MV_PAR37 == 1
	Local lConFilAbx	:= MV_PAR22 == 1
	Local lQtdFil2		:= .F.
	
	Private dBaixa  	:= dDataBase
	Private cTitulo 	:= ""
	Private cFilBrk 	:= ""
	Private cNatBrk		:= ""
	Private oFINR150    As Object

	If !lGestaoEmp
		lSE2EmpExc := lSE2FilExc
	EndIf

	If !lGestaoUni
		lSE2UniExc := lSE2FilExc
	EndIf

	aDados := Array(18)

	If __cSGBD == NIL
		__cSGBD := AllTrim(Upper(TCGetDB()))
	EndIf

	If __oTBxCanc <> Nil
		__oTBxCanc:Destroy()
		__oTBxCanc := Nil
	EndIf

	__oTBxCanc	:= FwPreparedStatement():New("")

	cPictTit := PesqPict("SE2","E2_VALOR")
	If cPaisLoc == "CHI"
		cPictTit := SubStr(cPictTit,1,At(".",cPictTit)-1)
	EndIf

	//Valida data base (MV_PAR33)
	If Empty(MV_PAR33)
		Help(" ",1,"FINDTBASE",,STR0066,1,0,,,,,,{STR0067}) //"Data Base nao informada na parametrizacao do relatorio."  ###  "Por favor, informe a data base nos par�metros do relatorio (pergunte)."
		lCancPrint := .T.
	ElseIf !lSelectFil .And. lConFilAbx
		If Empty(MV_PAR23) .And. Empty(MV_PAR24)
			Help(" ", 1, "EMPTYFIL",, STR0073, 1,0,,,,,, {STR0074}) //"Filial inicial e filial final n�o informados" "Informe ao menos a filial final para emitir o relat�rio"
			lCancPrint := .T.
		ElseIf MV_PAR24 < MV_PAR23
			Help(" ", 1, "PARAMFIL",, STR0075, 1,0,,,,,, {STR0076}) //"Filial final n�o pode ser maior que a filial final" //"Informe uma filial final maior que a filial inicial para emitir o relat�rio"
			lCancPrint := .T.
		EndIf
	EndIf

	If lCancPrint
		oReport:CancelPrint()
		Return
	EndIf

	If !IsBlind() .And. lSelectFil
		If Empty(aSelFil)
			If  FindFunction("AdmSelecFil")
				AdmSelecFil("FIN150", 37, .F., @aSelFil, "SE2", .F.)
			Else
				aSelFil := AdmGetFil(.F., .F., "SE2")
			EndIf
			If Empty(aSelFil)
				AAdd(aSelFil, {cFilAnt, FwFilialName(cEmpAnt, cFilAnt)})
			EndIf	
			//Ajusta array aSelFil para adicionar o Nome Reduzido
			For nFilial := 1 To Len(aSelFil)
				AAdd(aSelFilBkp, {aSelFil[nFilial], FwFilialName(cEmpAnt, aSelFil[nFilial])})
			Next nFilial
			FwFreeArray(aSelFil)
			aSelFil := AClone(aSelFilBkp)
			FwFreeArray(aSelFilBkp)
		EndIf
	Else
		If Empty(aSelFil)
			//Considera filial abaixo 1=Sim;2=N�o
			If lConFilAbx
				aSM0Bkp := FwLoadSM0()
				//Efetua a separa��o das filiais do grupo de empresa atual e ordena por c�digo de filial
				AEval(aSM0Bkp, {|filial| IIf(filial[SM0_GRPEMP] == cEmpAnt, AAdd(aSM0, AClone(filial)), Nil)})
				FwFreeArray(aSM0Bkp)
				ASort(aSM0,,, {|filial_x, filial_y| filial_x[SM0_CODFIL] < filial_y[SM0_CODFIL]})

				//Se filial diferente de branco e filial existente busca posi��o inicial
				If !(Empty(MV_PAR23))
					If FwFilExist(cEmpAnt, MV_PAR23)
						If MV_PAR23 == MV_PAR24
							lBuscaFil := .F.
							AAdd(aSelFil, {MV_PAR23, FwFilialName(cEmpAnt, MV_PAR23)})
						Else
							nPosFil := AScan(aSM0, {|filial| filial[SM0_CODFIL] == MV_PAR23})
						EndIf
					Else
						// caso informado uma c�digo de filial inexistente, seta onde deve iniciar a itera��o, caso n�o, seta como 1
						If (nPosFil := AScan(aSM0, {|filial| filial[SM0_CODFIL] > MV_PAR23})) == 0
							nPosFil := 1
						EndIf
					EndIf
				EndIf
				If lBuscaFil
					For nFilial := nPosFil To Len(aSM0)
						If aSM0[nFilial][SM0_CODFIL] > MV_PAR24
							Exit
						EndIf
						AAdd(aSelFil, {aSM0[nFilial][SM0_CODFIL], aSM0[nFilial][SM0_NOMRED]})
					Next nFilial
				EndIf
			Else
				AAdd(aSelFil, {cFilAnt, FwFilialName(cEmpAnt, cFilAnt)})
			EndIf
		EndIf
	EndIf

	nLenSelFil 	:= Len(aSelFil)
	lQtdFil2	:= nLenSelFil > 1
	nTamEmp 	:= Len(FwSM0LayOut(, 1))
	nTamUnNeg 	:= Len(FwSM0LayOut(, 2))
	lTotEmp 	:= .F.

	cFilDe 		:= aSelFil[1][1]
	cFilAte		:= aSelFil[nLenSelFil][1]

	If lQtdFil2
		nX := 1
		While nX < nLenSelFil .And. !lTotEmp
			nX++
			lTotEmp := !(SubStr(aSelFil[nX - 1][1], 1, nTamEmp) == SubStr(aSelFil[nX][1], 1, nTamEmp))
		End
	EndIf

	oSection1:Cell("FORNECEDOR"	):SetBlock({ || aDados[FORNEC]		})
	oSection1:Cell("TITULO"		):SetBlock({ || aDados[TITUL]		})
	oSection1:Cell("E2_TIPO"	):SetBlock({ || aDados[TIPO]		})
	oSection1:Cell("E2_NATUREZ"	):SetBlock({ || If(!Empty(aDados[NATUREZA]), MascNat(aDados[NATUREZA]), "")})
	oSection1:Cell("E2_EMISSAO"	):SetBlock({ || aDados[EMISSAO]		})
	oSection1:Cell("E2_VENCTO"	):SetBlock({ || aDados[VENCTO]		})
	oSection1:Cell("E2_VENCREA"	):SetBlock({ || aDados[VENCREA]		})
	oSection1:Cell("VAL_ORIG"	):SetBlock({ || aDados[VL_ORIG]		})
	oSection1:Cell("VAL_NOMI"	):SetBlock({ || aDados[VL_NOMINAL]	})
	oSection1:Cell("VAL_CORR"	):SetBlock({ || aDados[VL_CORRIG]	})
	oSection1:Cell("VAL_VENC"	):SetBlock({ || aDados[VL_VENCIDO]	})
	oSection1:Cell("E2_PORTADO"	):SetBlock({ || aDados[PORTADOR]	})
	oSection1:Cell("JUROS"		):SetBlock({ || aDados[VL_JUROS]	})
	oSection1:Cell("DIA_ATR"	):SetBlock({ || aDados[ATRASO]		})
	oSection1:Cell("E2_HIST"	):SetBlock({ || aDados[HISTORICO]	})
	oSection1:Cell("VAL_SOMA"	):SetBlock({ || aDados[VL_SOMA]		})

	oSection1:Cell("VAL_SOMA"):Disable()

	TRPosition():New(oSection1, "SA2", 1, {|| xFilial("SA2", SE2->E2_FILORIG) + SE2->E2_FORNECE + SE2->E2_LOJA})

	//Define as quebras da se��o, conforme a ordem escolhida.
	If nOrdem == 2	//NaturezaF
		oBreak	:= TRBreak():New(oSection1, {|| IIf(!MV_MULNATP, SE2->(XFILIAL("SE2", E2_FILORIG) + E2_NATUREZ), cFilBrk + cNatBrk)}, {|| cNomNat })
		oBrkNat	:= oBreak
	ElseIf nOrdem == 3 .Or. nOrdem == 6	//Vencimento e por Emissao
		oBreak  := TRBreak():New(oSection1, {|| IIf(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)}, {|| STR0026 + DToC(dDtVenc)})	//"S U B - T O T A L ----> "
		oBreak3 := TRBreak():New(oSection1, {|| IIf(nOrdem == 3, Month(SE2->E2_VENCREA), Month(SE2->E2_EMISSAO))}, {|| STR0030 + "(" + AllTrim(Str(nTotTitMes)) + " " + IIf(nTotTitMes > 1, OemToAnsi(STR0028), OemToAnsi(STR0029)) + ")"})		//"T O T A L   D O  M E S ---> "
		If MV_PAR20 == 1	//1- Analitico  2-Sintetico
			TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak3,,,,.F.,.F.)
			TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak3,,,,.F.,.F.)
			TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak3,,,,.F.,.F.)
			TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak3,,,,.F.,.F.)
			TRFunction():New(oSection1:Cell("JUROS"	  ),"","SUM",oBreak3,,,,.F.,.F.)
			TRFunction():New(oSection1:Cell("E2_HIST"),"","ONPRINT",oBreak3,,IIf(cPaisLoc == "CHI",cPictTit, PesqPict("SE2","E2_VALOR")),{|lSection,lReport| If(lReport, nTotGeral, nTotMes)},.F.,.F.)
		EndIf
	ElseIf nOrdem == 4	//Banco
		oBreak := TRBreak():New(oSection1,{|| SE2->E2_PORTADO },{|| STR0026 + cNumBco })	//"S U B - T O T A L ----> "
	ElseIf nOrdem == 5	//Fornecedor
		oBreak := TRBreak():New(oSection1,{|| SE2->(E2_FORNECE+E2_LOJA) },{|| cNomFor })
	ElseIf nOrdem == 7	//Codigo Fornecedor
		oBreak := TRBreak():New(oSection1,{|| SE2->E2_FORNECE },{|| cNomFor })
	EndIf

	oBreak2 := TRBreak():New(oSection1,{|| SE2->E2_FILIAL },{|| STR0032+" "+cNomFil })	//"T O T A L   F I L I A L ----> "

	//Imprimir TOTAL por filial somente quando houver mais do que uma filial ou a impress�o em excel formato tabela.
	If SM0->(Reccount()) > 1 .And. lQtdFil2 .Or. lImpXlsTbl
		If nOrdem  == 3 .Or. nOrdem == 6 .Or. lImpXlsTbl
			oSection2:Cell("FILIAL"	)	:SetBlock({ || aTotFil[ni,1] + aTotFil[ni,9]})
			oSection2:Cell("VALORORIG")	:SetBlock({ || aTotFil[ni,2]})
			oSection2:Cell("VALORNOMI")	:SetBlock({ || aTotFil[ni,3]})
			oSection2:Cell("VALORCORR")	:SetBlock({ || aTotFil[ni,4]})
			oSection2:Cell("VALORVENC")	:SetBlock({ || aTotFil[ni,5]})
			oSection2:Cell("JUROS")		:SetBlock({ || aTotFil[ni,8]})
			oSection2:Cell("VALORSOMA")	:SetBlock({ || aTotFil[ni,4] + aTotFil[ni,5]})

			TRPosition():New(oSection2,"SM0",1,{|| xFilial("SM0") + SM0->M0_CODIGO + SM0->M0_CODFIL })
		Else
			If MV_PAR20 == 1	//1- Analitico  2-Sintetico
				TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak2,,,,.F.,.F.)
				TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak2,,,,.F.,.F.)
				TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak2,,,,.F.,.F.)
				TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak2,,,,.F.,.F.)
				TRFunction():New(oSection1:Cell("JUROS"	  ),"","SUM",oBreak2,,,,.F.,.F.)
				//nTotGeral nao estava imprimindo corretamente o totalizador por isso foi necessario o ajuste abaixo
				//embora seja estranho mas neste caso foi necessario inicializar a variavel nFilTot:=0 no break
				//por isso salvei o conteudo na variavel nAuxTotFil antes de inicializar e depois imprimo nAuxTotFil
				TRFunction():New(oSection1:Cell("E2_HIST"),"","ONPRINT",oBreak2,,IIf(cPaisLoc == "CHI",cPictTit, PesqPict("SE2","E2_VALOR")),{|lSection,lReport| If(lReport, (nAuxTotFil:=nFilTot,nFilTot:=0,nAuxTotFil )/*nTotGeral*/, nTotFil)},.F.,.F.)
			EndIf
		EndIf
	EndIf

	/*GESTAO - inicio */
	/* quebra por empresa */
	If lTotEmp .And. MV_MULNATP .And. nOrdem == 2
		oBrkEmp := TRBreak():New(oSection1,{|| SubStr(SE2->E2_FILIAL,1,nTamEmp)},{|| STR0064 + " " + cNomEmp })		//"T O T A L  E M P R E S A -->"
		// "Salta pagina por cliente?" igual a "Sim" e a ordem eh por cliente ou codigo do cliente
		If MV_PAR20 == 1	//1- Analitico  2-Sintetico
			TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBrkEmp,,,,.F.,.F.)
			TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBrkEmp,,,,.F.,.F.)
			TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBrkEmp,,,,.F.,.F.)
			TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBrkEmp,,,,.F.,.F.)
			TRFunction():New(oSection1:Cell("JUROS"	  ),"","SUM",oBrkEmp,,,,.F.,.F.)
			TRFunction():New(oSection1:Cell("VAL_SOMA"),"","ONPRINT",oBrkEmp,,PesqPict("SE2","E2_VALOR"),{|lSection,lReport| If(lReport, nTotGeral, nTotEmp)},.F.,.F.)
		EndIf
	EndIf
	/* GESTAO - fim*/

	If MV_PAR20 == 1	//1- Analitico  2-Sintetico
		//Altero o texto do Total Geral
		oReport:SetTotalText({|| STR0027 + "(" + AllTrim(Str(nTotTit)) + " " + If(nTotTit > 1, STR0028, STR0029) + ")"})
		TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak,,,,.F.,.T.)
		TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak,,,,.F.,.T.)
		TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak,,,,.F.,.T.)
		TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak,,,,.F.,.T.)
		TRFunction():New(oSection1:Cell("JUROS"	  ),"","SUM",oBreak,,,,.F.,.T.)
		//nTotGeral nao estava imprimindo corretamente o totalizador por isso foi necessario o ajuste abaixo
		//portanto foi criado a variavel nGerTot que eh o acumulador geral da coluna
		TRFunction():New(oSection1:Cell("E2_HIST"), "", "ONPRINT", oBreak,, IIf(cPaisLoc == "CHI", cPictTit, PesqPict("SE2","E2_VALOR")), {|lSection,lReport| If(lReport,IIf(nOrdem == 2, nTotGeral, nGerTot), nTotVenc)}, .F., .T.)
	EndIf

	DbSelectArea ("SE2" )
	Set Softseek On

	//Acerta a database de acordo com o parametro
	dDataBase := MV_PAR33

	DbSelectArea("SM0")

	nRegSM0 := SM0->(Recno())
	nAtuSM0 := SM0->(Recno())

	//Caso nao preencha o MV_PAR15 um erro ocorre ao procurar o parametro do sistema MV_MOEDA0.
	If Val(cMoeda) == 0
		cMoeda := "1"
	EndIf

	cTitulo := oReport:Title()
	cTitAux := cTitulo

	cTitulo += " " + STR0035 + GetMv("MV_MOEDA" + cMoeda)  //"Posicao dos Titulos a Pagar" + " em "

	oSection1:Init()
	nFilAtu := 1
	lContinua := nFilAtu <= nLenSelFil

	nInc := 1

	// Tratar filtros de usu�rio
	cFilterUser := oSection1:GetSqlExp("SE2")
	cFilUserSA2 := oSection1:GetSqlExp("SA2")

	// Adiciona colunas ao SE2
	aStruSE2 := SE2->(DbStruct())
	AAdd(aStruSE2, {"TEMBXSE5",	"C",	1,	0})
	AAdd(aStruSE2, {"RECSE2",	"N",	8,	0})

	cCampos := ""
	AEval(aStru, {|campo| If(campo[2] <> "M", cCampos += ", " + AllTrim(campo[1]), Nil)})

	While nInc <= nLenSelFil
		If lContinua
			SM0->(MsSeek(cEmpAnt + aSelFil[nInc][1]))
			cFilAnt := aSelFil[nInc][1]

			If lConFilAbx .Or. lSelectFil //E2_FILORIG ser� buscado utilizando o range De/At�
				If cFilialSE2 == FwXFilial("SE2", cFilAnt) //cFilAnt
					nInc++
					Loop
				Else
					cFilialSE2 := FwXFilial("SE2", cFilAnt)//cFilAnt
				EndIf
			EndIf

			// Cria tempor�rio com estrutura da SE2
			oFINR150 := FwTemporaryTable():New("SE2")
			oFINR150:SetFields(aStruSE2)

			If nOrdem == 1
				oFINR150:AddIndex("1", {"E2_FILIAL", "E2_PREFIXO", "E2_NUM", "E2_PARCELA", "E2_TIPO", "E2_FILORIG"})
				SE2->(DbSetOrder(1))
				cOrder := SQLOrder(SE2->(IndexKey()))
				cCond1 := "SE2->E2_PREFIXO <= MV_PAR04"
				cCond2 := "SE2->E2_PREFIXO"
				cTitulo += OemToAnsi(STR0016)  //" - Por Numero"
				nQualIndice := 1
			ElseIf nOrdem == 2
				oFINR150:AddIndex("1", {"E2_FILIAL", "E2_NATUREZ", "E2_NOMFOR", "E2_PREFIXO", "E2_NUM", "E2_PARCELA", "E2_TIPO", "E2_FORNECE", "E2_FILORIG"})
				SE2->(DbSetOrder(2))
				cOrder := SQLOrder(SE2->(IndexKey()))
				cCond1 := "SE2->E2_NATUREZ <= MV_PAR06"
				cCond2 := "SE2->E2_NATUREZ"
				cTitulo += STR0017  //" - Por Natureza"
				nQualIndice := 2
			ElseIf nOrdem == 3
				oFINR150:AddIndex("1", {"E2_FILIAL", "E2_VENCREA", "E2_NOMFOR", "E2_PREFIXO", "E2_NUM", "E2_PARCELA", "E2_TIPO", "E2_FILORIG"})
				SE2->(DbSetOrder(3))
				cOrder := SQLOrder(SE2->(IndexKey()))
				cCond1 := "SE2->E2_VENCREA <= MV_PAR08"
				cCond2 := "SE2->E2_VENCREA"
				cTitulo += STR0018  //" - Por Vencimento"
				nQualIndice := 3
			ElseIf nOrdem == 4
				oFINR150:AddIndex("1", {"E2_FILIAL", "E2_PORTADO", "E2_NOMFOR", "E2_PREFIXO", "E2_NUM", "E2_PARCELA", "E2_TIPO", "E2_FORNECE", "E2_FILORIG"})
				SE2->(DbSetOrder(4))
				cOrder := SQLOrder(SE2->(IndexKey()))
				cCond1 := "SE2->E2_PORTADO <= MV_PAR10"
				cCond2 := "SE2->E2_PORTADO"
				cTitulo += OemToAnsi(STR0031)  //" - Por Banco"
				nQualIndice := 4
			ElseIf nOrdem == 6
				oFINR150:AddIndex("1", {"E2_FILIAL", "E2_EMISSAO", "E2_NOMFOR", "E2_PREFIXO", "E2_NUM", "E2_PARCELA", "E2_TIPO", "E2_FILORIG"})
				SE2->(DbSetOrder(5))
				cOrder := SQLOrder(SE2->(IndexKey()))
				cCond1 := "SE2->E2_EMISSAO <= MV_PAR14"
				cCond2 := "SE2->E2_EMISSAO"
				cTitulo += STR0019 //" - Por Emissao"
				nQualIndice := 5
			ElseIf nOrdem == 7
				oFINR150:AddIndex("1", {"E2_FILIAL", "E2_FORNECE", "E2_LOJA", "E2_PREFIXO", "E2_NUM", "E2_PARCELA", "E2_TIPO", "E2_FILORIG"})
				SE2->(DbSetOrder(6))
				cOrder := SQLOrder(SE2->(IndexKey()))
				cCond1 := "SE2->E2_FORNECE <= MV_PAR12"
				cCond2 := "SE2->E2_FORNECE"
				cTitulo += STR0020 //" - Por Cod.Fornecedor"
				nQualIndice := 6
			Else
				oFINR150:AddIndex("1", {"E2_FILIAL", "E2_NOMFOR", "E2_FORNECE", "E2_LOJA", "E2_PREFIXO", "E2_NUM", "E2_PARCELA", "E2_TIPO", "E2_FILORIG"})
				cChaveSe2 := "E2_FILIAL+E2_NOMFOR+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
				cOrder := SQLOrder(cChaveSe2)
				cCond1 := "SE2->E2_FORNECE <= MV_PAR12"
				cCond2 := "SE2->E2_FORNECE+SE2->E2_LOJA"
				cTitulo += STR0022 //" - Por Fornecedor"
				nQualIndice := SE2->(IndexOrd())
			EndIf

			DbSelectArea("SE2")
			DbCloseArea()
			oFINR150:Create()
			cTable := oFINR150:GetRealName()

			cValues := SubStr(cCampos,2)

			cInsert := " INSERT INTO " + cTable  + " ( " + cValues  + " ,RECSE2, TEMBXSE5   ) "
			cSelect := " SELECT " + cValues + " ,SE2.R_E_C_N_O_ AS RECSE2, 'N' TEMBXSE5"

			cFrom := "  FROM "+	RetSQLName("SE2")+ " SE2"
			cWhere := " WHERE SE2.E2_FILIAL = '" + xFilial("SE2") + "' "
			cWhere += "  AND D_E_L_E_T_ = ' ' "

			If MV_PAR20 == 1	//1- Analitico  2-Sintetico
				cTitulo += STR0023  //" - Analitico"
			Else
				cTitulo += STR0024  // " - Sintetico"
			EndIf

			oReport:SetTitle(cTitulo)
			cTitulo := cTitAux

			DbSelectArea("SE2")

			Set Softseek Off
			cQueryP := ""
			If !Empty(cFilterUser)
				cQueryP += " AND ( " + cFilterUser + " ) "
			EndIf

			If !Empty(cFilUserSA2)
				cQueryP += " AND EXISTS( SELECT A2_COD "
				cQueryP +=  			"FROM "+	RetSQLName("SA2")+ " SA2 "
				cQueryP +=  			"WHERE 		A2_FILIAL = '"+xFilial("SA2")+"' "
				cQueryP +=  				   "AND A2_COD = SE2.E2_FORNECE "
				cQueryP +=  				   "AND A2_LOJA = SE2.E2_LOJA "
				cQueryP +=  				   "AND (" + cFilUserSA2 + ") "
				cQueryP +=  				   "AND SA2.D_E_L_E_T_ = ' ') "
			EndIf

			cQueryP += " AND SE2.E2_NUM     BETWEEN '"+ MV_PAR01+ "' 		AND '"+ MV_PAR02 + "'"
			cQueryP += " AND SE2.E2_PREFIXO BETWEEN '"+ MV_PAR03+ "' 		AND '"+ MV_PAR04 + "'"
			cQueryP += " AND SE2.E2_NATUREZ BETWEEN '"+ MV_PAR05+ "' 		AND '"+ MV_PAR06 + "'"
			cQueryP += " AND SE2.E2_VENCREA BETWEEN '"+ DToS(MV_PAR07)+ "' 	AND '"+ DToS(MV_PAR08) + "'"
			cQueryP += " AND SE2.E2_PORTADO BETWEEN '"+ MV_PAR09+ "' 		AND '"+ MV_PAR10 + "'"
			cQueryP += " AND SE2.E2_FORNECE BETWEEN '"+ MV_PAR11+ "' 		AND '"+ MV_PAR12 + "'"
			cQueryP += " AND SE2.E2_EMISSAO BETWEEN '"+ DToS(MV_PAR13)+ "'  AND '"+ DToS(MV_PAR14) + "'"
			cQueryP += " AND SE2.E2_EMIS1   BETWEEN '"+ DToS(MV_PAR18)+ "'  AND '"+ DToS(MV_PAR19) + "'"
			cQueryP += " AND SE2.E2_LOJA    BETWEEN '"+ MV_PAR25 + "' 		AND '"+ MV_PAR26 + "'"
			//Considerar titulos cuja emissao seja maior que a database do sistema
			If MV_PAR36 == 2
				cQueryP += " AND SE2.E2_EMISSAO <= '" + DToS(dDataBase) +"'"
			EndIf

			If !Empty(MV_PAR30) // Deseja imprimir apenas os tipos do parametro 30
				cQueryP += " AND SE2.E2_TIPO IN "+FormatIn(MV_PAR30,";")
			ElseIf !Empty(MV_PAR31) // Deseja excluir os tipos do parametro 31
				cQueryP += " AND SE2.E2_TIPO NOT IN "+FormatIn(MV_PAR31,";")
			EndIf

			If MV_PAR32 == 1
				cQueryP += " AND SE2.E2_FLUXO != 'N'"
			EndIf

			If !lImprimeAb
				cQueryP += " AND SE2.E2_TIPO NOT IN "+FormatIn(MVABATIM,"|")
			EndIf

			If MV_PAR16 == 2
				cQueryP += " AND SE2.E2_TIPO NOT IN "+FormatIn(MVPROVIS,";")
			EndIf

			If MV_PAR27 == 2
				cQueryP += " AND SE2.E2_TIPO NOT IN "+FormatIn(MVPAGANT,";")
				cQueryP += " AND SE2.E2_TIPO NOT IN "+FormatIn(MV_CPNEG,"|")
			EndIf

			If MV_PAR34 == 2 .And. !Empty(MV_PAR33)
				cQueryP += " AND SE2.E2_EMIS1 <= '" + DToS(MV_PAR33) +"'"
			EndIf

			//verifica moeda do campo=moeda parametro
			If MV_PAR29 == 2 // nao imprime
				cQueryP += " AND SE2.E2_MOEDA = " + AllTrim(Str(MV_PAR15))
			EndIf

			// Metodo de sele��o de Filiais, considerando que o MV_PAR37 (Selecione Filiais) e mais forte que o MV_PAR22 (Considera Filiais a Baixo?)
			If lConFilAbx .Or. lSelectFil// Considerar Filiais a baixo ? = Sim
				cQueryP += " AND SE2.E2_FILORIG BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
			EndIf

			//se considera t�tulos Exlu�dos e Utiliza FJU
			If lExistFJU .And. MV_PAR38 == 1
				cQueryP += " AND SE2.R_E_C_N_O_ NOT IN (SELECT PAI.FJU_RECPAI FROM "+ RetSQLName("FJU")+" PAI "
				cQueryP += 							"	WHERE PAI.D_E_L_E_T_ = ' ' AND "
				cQueryP += 							"	PAI.FJU_CART = 'P' AND "
				cQueryP += 							"	PAI.FJU_DTEXCL >= '" + DToS(dDataBase) + "' "
				cQueryP += 							"	AND PAI.FJU_EMIS1 <= '" + DToS(dDataBase) + "') "
			EndIf
			cQuery := cSelect + cFrom + cWhere + cQueryP
			cQuery += " ORDER BY "+ cOrder
			cQuery := cInsert + ChangeQuery(cQuery)

			// Executa a primeira consulta
			If TCSqlExec(cQuery) < 0
				FR150Log(STR0068 + TCSQLError() , "Query1")//"Ocorreu um problema na execu��o do comando SQL no seu banco de dados, avalie os detalhes:"
				lMstErro := .T.
			Else
				// Marca registros que possuem baixa por compensacao
				cQryBx := "UPDATE " + cTable +" SET TEMBXSE5 = 'S' "
				cQryBx += "WHERE EXISTS ( "
				cQryBx += 		"SELECT E5_NUMERO FROM " + RetSQLName("SE5")
				cQryBx +=			" WHERE E5_FILORIG = E2_FILORIG "
				cQryBx +=			"AND E5_PREFIXO = E2_PREFIXO "
				cQryBx +=			"AND E5_NUMERO = E2_NUM "
				cQryBx +=			"AND E5_PARCELA = E2_PARCELA "
				cQryBx +=			"AND E5_TIPO = E2_TIPO "
				cQryBx +=			"AND E5_CLIFOR = E2_FORNECE "
				cQryBx +=			"AND E5_LOJA = E2_LOJA "
				cQryBx +=			"AND E5_MOTBX IN ( 'CEC','CMP' ) "
				cQryBx +=			"AND E5_TIPODOC IN ( 'CP' , 'BA' ) "
				cQryBx +=			"AND E5_SITUACA = ' ' "
				cQryBx +=			"AND D_E_L_E_T_ = ' ' ) "
				If TCSqlExec(cQryBx) < 0
					FR150Log(STR0068 + TCSQLError() , "QueryBx")//"Ocorreu um problema na execu��o do comando SQL no seu banco de dados, avalie os detalhes:"
					lMstErro := .T.
				EndIf
			EndIf

			//se considera t�tulos Exlu�dos e Utiliza FJU
			If lExistFJU .And. MV_PAR38 == 1
				cQuery := cSelect
				cQuery += " FROM "+ RetSQLName("SE2")+" SE2,"+ RetSQLName("FJU") +" FJU"
				cQuery += " WHERE SE2.E2_FILIAL = '" + xFilial("SE2") + "'"
				cQuery += " AND FJU.FJU_FILIAL	 = '" + xFilial("FJU") + "'"
				cQuery += " AND SE2.E2_PREFIXO 	= FJU.FJU_PREFIX "
				cQuery += " AND SE2.E2_NUM 		= FJU.FJU_NUM "
				cQuery += " AND SE2.E2_PARCELA 	= FJU.FJU_PARCEL "
				cQuery += " AND SE2.E2_TIPO 	= FJU.FJU_TIPO "
				cQuery += " AND SE2.E2_FORNECE	= FJU.FJU_CLIFOR "
				cQuery += " AND SE2.E2_LOJA 	= FJU.FJU_LOJA "
				cQuery += " AND FJU.FJU_EMIS   <= '" + DToS(dDataBase) +"'"
				cQuery += " AND FJU.FJU_DTEXCL >= '" + DToS(dDataBase) +"'"
				cQuery += " AND FJU.FJU_CART = 'P' "
				cQuery += " AND SE2.R_E_C_N_O_ = FJU.FJU_RECORI "
				cQuery += " AND FJU.FJU_RECORI IN ( SELECT MAX(FJU_RECORI) "

				cQuery +=   "FROM "+ RetSQLName("FJU")+" LASTFJU "
				cQuery +=   "WHERE LASTFJU.FJU_FILIAL = FJU.FJU_FILIAL "
				cQuery +=   "AND LASTFJU.FJU_PREFIX = FJU.FJU_PREFIX "
				cQuery +=   "AND LASTFJU.FJU_NUM = FJU.FJU_NUM "
				cQuery +=   "AND LASTFJU.FJU_PARCEL = FJU.FJU_PARCEL "
				cQuery +=   "AND LASTFJU.FJU_TIPO = FJU.FJU_TIPO "
				cQuery +=   "AND LASTFJU.FJU_CLIFOR = FJU.FJU_CLIFOR "
				cQuery +=   "AND LASTFJU.FJU_LOJA = FJU.FJU_LOJA "
				cQuery +=   "AND FJU.FJU_DTEXCL = LASTFJU.FJU_DTEXCL "

				cQuery +=   "GROUP BY FJU_FILIAL "
				cQuery +=   ",FJU_PREFIX "
				cQuery +=   ",FJU_NUM "
				cQuery +=   ",FJU_PARCEL "
				cQuery +=   ",FJU_CLIFOR "
				cQuery +=   ",FJU_LOJA ) "

				cQuery += " AND SE2.D_E_L_E_T_ = '*' "
				cQuery += " AND FJU.D_E_L_E_T_ = ' ' "

				cQuery += " AND "
				cQuery += " (SELECT COUNT(*) "
				cQuery += " FROM "+ RetSQLName("SE2")+" NOTDEL "
				cQuery += " WHERE NOTDEL.E2_FILIAL = FJU.FJU_FILIAL "
				cQuery += " AND NOTDEL.E2_PREFIXO = FJU.FJU_PREFIX     "
				cQuery += " AND NOTDEL.E2_NUM = FJU.FJU_NUM            "
				cQuery += " AND NOTDEL.E2_PARCELA = FJU.FJU_PARCEL      "
				cQuery += " AND NOTDEL.E2_TIPO = FJU.FJU_TIPO "
				cQuery += " AND NOTDEL.E2_FORNECE = FJU.FJU_CLIFOR       "
				cQuery += " AND NOTDEL.E2_LOJA = FJU.FJU_LOJA  	"
				cQuery += " AND FJU.FJU_RECPAI = 0 "
				cQuery += " AND NOTDEL.E2_EMIS1   <= '" + DToS(dDataBase) +"'"
				cQuery += " AND NOTDEL.D_E_L_E_T_ = '') = 0 "

				cQuery += " AND FJU.FJU_RECORI NOT IN (SELECT PAI.FJU_RECPAI FROM "+ RetSQLName("FJU")+" PAI "
				cQuery += " WHERE PAI.D_E_L_E_T_ = ' ' AND "
				cQuery += " PAI.FJU_CART = 'P' AND "
				cQuery += " PAI.FJU_DTEXCL >= '" + DToS(dDataBase) + "' "
				cQuery += " AND PAI.FJU_EMIS1 <= '" + DToS(dDataBase) + "') "

				cQuery += cQueryP

				cQuery += " ORDER BY "+ cOrder

				cQuery := cInsert + ChangeQuery(cQuery)

				// Executa a Segunda consulta com t�tulos excluidos
				If TCSqlExec(cQuery) < 0
					FR150Log(STR0068 + TCSQLError() , "Query2")//"Ocorreu um problema na execu��o do comando SQL no seu banco de dados, avalie os detalhes:"
					lMstErro := .T.
				EndIf
			EndIf

			If lMstErro // Alerta o usu�rio que o
				If !(__cSGBD $ "ORACLE#DB2#INFORMIX#MSSQL#POSTGRES#OPENEDGE#CTREESQL")
					//"Ocorreram inconsist�ncias na utiliza��o de comandos no banco de dados! Banco de dados n�o homologado"
					HELP(" ",1,"SGDBInfo",,STR0070 ,2,0,,,,,, { STR0071 }) //"Ocorreram inconsist�ncias na utiliza��o de comandos no banco de dados! Banco de dados n�o homologado!"#"Avalie o log de incosist�ncias gerado na pasta system."
				EndIf
			EndIf
			nTotsRec := MpSysExecScalar(ChangeQuery("SELECT COUNT(E2_NUM) QTD FROM " + cTable), "QTD")
			If !(IsBlind())
				oReport:SetMsgPrint(STR0072 + cFilAnt) //"Processando Filial: "
			EndIf
			oReport:SetMeter(nTotsRec)

			SE2->(DbGoTop())

			If MV_MULNATP .And. nOrdem == 2
				If dDataBase > SE2->E2_VENCREA 		//vencidos
					dBaixa := dDataBase
				EndIf

				nRecFiltro := SE2->RECSE2
				// Trecho de impress�o normal
				DbSelectArea("SE2")
				SE2->(DbSetOrder(1))
				SE2->(DbGoTop())

				If nLenSelFil == 0
					FinR155(cFr150Flt, .F., @nTot0, @nTot1, @nTot2, @nTot3, @nTotTit, @nTotJ, oReport, aDados, @cNomNat, @nTotVenc, @nTotGeral)
				Else
					cTitBkp := cTitulo
					FinR155(cFr150Flt, .F., @nTotFil0, @nTotFil1, @nTotFil2, @nTotFil3, @nTotFilTit, @nTotFilJ, oReport, aDados, @cNomNat, @nTotVenc, @nTotGeral)
					nTot0 += nTotFil0
					nTot1 += nTotFil1
					nTot2 += nTotFil2
					nTot3 += nTotFil3
					nTot4 += nTotFil4
					nTotJ += nTotFilJ
					nTotTit += nTotFilTit
					cNomFil := cFilAnt + " - " + AllTrim(SM0->M0_FILIAL)
					cNomEmp := SubStr(cFilAnt,1,nTamEmp) + " - " + AllTrim(SM0->M0_NOMECOM)
					cTitulo := cTitBkp
				EndIf

				SE2->(DbCloseArea())
				ChKFile("SE2")
				DbSetOrder(1)

				nFilAtu++
				lContinua := (nFilAtu <= nLenSelFil)
				If lContinua
					If oBrkNat:Execute()
						oBrkNat:PrintTotal()
					EndIf
					If nTotFil0 <> 0
						oBrkFil := oBreak
						If oBrkFil:Execute()
							oBrkFil:PrintTotal()
						EndIf
					EndIf

					Store 0 To nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFilTit,nTotFilJ

					If !(SubStr(aSelFil[nFilAtu-1][1],1,nTamEmp) == SubStr(aSelFil[nFilAtu][1],1,nTamEmp))
						If nTotEmp0 <> 0
							oBrkEmp:PrintTotal()
						EndIf
						nTotEmp0 := 0
						nTotEmp1 := 0
						nTotEmp2 := 0
						nTotEmp3 := 0
						nTotEmp4 := 0
						nTotEmpJ := 0
						nTotTitEmp := 0
					EndIf
				EndIf

				//GESTAO - fim
				If Empty(xFilial("SE2")) .And. !lConFilAbx
					Exit
				EndIf

				nInc ++
				Loop
			EndIf

			lQryEmp := SE2->(EoF())

			SED->(DbSetOrder(1))
			DbSelectArea("SA2")
			SA2->(DbSetOrder(1))

			While &cCond1 .And. SE2->(!EoF()) .And. lContinua .And. SE2->E2_FILIAL == xFilial("SE2")

				oReport:IncMeter()

				Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5

				If nOrdem == 3 .And. Str(Month(SE2->E2_VENCREA)) <> Str(Month(dDataAnt))
					nMesTTit := 0
				ElseIf nOrdem == 6 .And. Str(Month(SE2->E2_EMISSAO)) <> Str(Month(dDataAnt))
					nMesTTit := 0
				EndIf

				//Carrega data do registro para permitir
				//posterior analise de quebra por mes.
				dDataAnt := IIf(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)

				cCarAnt := &cCond2

				While &cCond2 == cCarAnt .And. !EoF() .And. lContinua .And. SE2->E2_FILIAL == xFilial("SE2")

					oReport:IncMeter()

					If SA2->(MsSeek(xFilial("SA2", SE2->E2_FILORIG) + SE2->E2_FORNECE + SE2->E2_LOJA))
						//Considera filtro do usuario no ponto de entrada.
						If lFr150flt
							If SE2->(&cFr150flt)
								SE2->(DbSkip())
								Loop
							EndIf
						EndIf
					Else
						SE2->(DbSkip())
						Loop
					EndIf

					//Verifica se o titulo, apesar do saldo zerado, ira aparecer no relatorio 
					//quando considerar saldo retroat. (MV_PAR21=1) 
					If !Empty(SE2->E2_BAIXA) .And. IIf(MV_PAR21 == 2 ,SE2->E2_SALDO == 0 ,SE2->E2_SALDO == 0 .And. SE2->E2_BAIXA <= dDataBase)
						SE2->(DbSkip())
						Loop
					EndIf

					// Tratamento da correcao monetaria para a Argentina
					If  cPaisLoc=="ARG" .And. MV_PAR15 <> 1  .And.  SE2->E2_CONVERT == "N"
						SE2->(DbSkip())
						Loop
					EndIf
					
					dDataReaj := dDataBase
					
					//Verifica se existe a taxa na data do vencimento do titulo, se nao existir, utiliza a taxa da database
					If SE2->E2_VENCREA < dDataBase .And. MV_PAR17 == 2 .And. RecMoeda(SE2->E2_VENCREA,cMoeda) > 0
						dDataReaj := SE2->E2_VENCREA
					EndIf
					
					lSemTaxaM2 := (nTaxaDia := RecMoeda(dDataReaj,SE2->E2_MOEDA)) == 0

					If MV_PAR21 == 1

                        If __cMVFinFix   == NIL
                            __cMVFinFix := GetNewPar("MV_FINFIX","")
                        Endif

						lCmpMulFil := .F.
						nSaldo := SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,MV_PAR15,dDataReaj,,SE2->E2_LOJA,,If(MV_PAR35==1,SE2->E2_TXMOEDA,If(lSemTaxaM2,1,nTaxaDia)),IIf(MV_PAR34 == 2,3,1),,__oTBxCanc, Nil, @lCmpMulFil) // 1 = DT BAIXA    3 = DT DIGIT
						
						//Verifica se existem compensa��es em outras filiais para descontar do saldo, a SaldoTit
						//somente verifica as movimenta��es da filial corrente, Nao deve processar quando existe somente uma filial.
						If __lPFIN002 .or. (!__lPFIN002 .and. __cMVFinFix < '20' )
							If lCmpMulFil .And. SE2->TEMBXSE5 == "S" .And. !Empty(xFilial("SE2")) .And. !Empty(xFilial("SE5"))
								nSaldo -= FRVlCompFil("P",SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,IIf(MV_PAR34 == 2,3,1),,,,MV_PAR15,SE2->E2_MOEDA,If(MV_PAR35==1,SE2->E2_TXMOEDA,If(lSemTaxaM2,1,nTaxaDia)),dDataReaj,.T.)
							EndIf
						EndIf
					Else
						nSaldo := xMoeda((SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE),SE2->E2_MOEDA,MV_PAR15,dDataReaj,ndecs+1,If(MV_PAR35==1,SE2->E2_TXMOEDA,If(lSemTaxaM2,1,nTaxaDia)))
					EndIf

					If nSaldo == 0 .And. !EMPTY(SE2->E2_MOVIMEN)
						SE2->(DbSkip())
						LOOP
					EndIf

					If !(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG) .And. !(SE2->E2_TIPO $ MVABATIM) .And.;
						(!(SE2->E2_TIPO $ MVPAGANT+"/"+MVPROVIS+"/"+MV_CPNEG) .Or. (cPaisLoc $ "DOM|COS")) .And.;
						!lImprimeAb .And.;
					!(MV_PAR21 == 2 .And. nSaldo == 0) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo

						//Quando considerar Titulos com emissao futura, eh necessario
						//colocar-se a database para o futuro de forma que a Somaabat()
						//considere os titulos de abatimento
						If MV_PAR36 == 1
							dOldData := dDataBase
							dDataBase := CTOD("31/12/40")
						EndIf

						nSaldo -= SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",MV_PAR15,dDataReaj,SE2->E2_FORNECE,SE2->E2_LOJA)

						If MV_PAR36 == 1
							dDataBase := dOldData
						EndIf
					EndIf

					nSaldo := Round(NoRound(nSaldo,3),2)

					aDados[FORNEC]		:= SE2->E2_FORNECE+"-"+SE2->E2_LOJA+"-"+If(MV_PAR28 == 1, GetLGPDValue("SA2","A2_NREDUZ"), GetLGPDValue("SA2","A2_NOME"))
					aDados[TITUL]		:= SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA
					aDados[TIPO]		:= SE2->E2_TIPO
					aDados[NATUREZA]	:= SE2->E2_NATUREZ
					aDados[EMISSAO]		:= SE2->E2_EMISSAO
					aDados[VENCTO]		:= SE2->E2_VENCTO
					aDados[VENCREA]		:= SE2->E2_VENCREA
					aDados[FILIAL]		:= xFilial("SE2",SE2->E2_FILORIG)
					If SE2->E2_TIPO $ MVABATIM .And. nSaldo > 0
						aDados[VL_ORIG]	:= xMoeda(SE2->E2_VALOR * -1,SE2->E2_MOEDA,MV_PAR15,SE2->E2_EMISSAO,ndecs+1,If(MV_PAR35==1,SE2->E2_TXMOEDA,If(lSemTaxaM2,1,nTaxaDia))) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1)
						nSaldo := nSaldo * -1	// Garante que valor de abatimento sera subtraido e nao somado
					Else
						aDados[VL_ORIG]	:= xMoeda(SE2->E2_VALOR , SE2->E2_MOEDA , MV_PAR15 , SE2->E2_EMISSAO , ndecs+1 , If(MV_PAR35 == 1 , SE2->E2_TXMOEDA , If(lSemTaxaM2 , 1 , nTaxaDia)),  If(SE2->E2_TXMOEDA <> 0, SE2->E2_TXMOEDA, RecMoeda(dDataReaj , MV_PAR15))) * If(SE2->E2_TIPO $ MV_CPNEG + "/" + MVPAGANT , -1 , 1)
					EndIf

					If dDataBase > SE2->E2_VENCREA 		//vencidos
						aDados[VL_NOMINAL] := nSaldo * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1)
						nJuros := 0
						dBaixa := dDataBase

						//C�lculo dos Juros retroativo.
						dUltBaixa := SE2->E2_BAIXA
						If MV_PAR21 == 1 // se compoem saldo retroativo verifico se houve baixas
							If !Empty(dUltBaixa) .And. dDataBase < dUltBaixa
								dUltBaixa := FR150DBx() // Ultima baixa at� DataBase
							EndIf
						EndIf

						nJuros := Fa080Juros(MV_PAR15,nSaldo,"SE2",dUltBaixa)

						nVa := If(lFValAcess, FValAcess(SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_TIPO, SE2->E2_FORNECE, SE2->E2_LOJA, SE2->E2_NATUREZ, !Empty(SE2->E2_BAIXA), "", "P",,, SE2->E2_MOEDA, MV_PAR15, SE2->E2_TXMOEDA,, IIf(MV_PAR21 == 1, .T., .F.)), 0)
						If nVa > 0
							nJuros += nVa
						EndIf

						aDados[VL_CORRIG] := (nSaldo+nJuros) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1)
						If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
							nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,MV_PAR15,SE2->E2_EMISSAO,ndecs+1,If(MV_PAR35==1,SE2->E2_TXMOEDA,If(lSemTaxaM2,1,nTaxaDia)))
							nTit1 -= nSaldo
							nTit2 -= nSaldo+nJuros
							nMesTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,MV_PAR15,SE2->E2_EMISSAO,ndecs+1,If(MV_PAR35==1,SE2->E2_TXMOEDA,If(lSemTaxaM2,1,nTaxaDia)))
							nMesTit1 -= nSaldo
							nMesTit2 -= nSaldo+nJuros
						Else
							nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,MV_PAR15,SE2->E2_EMISSAO,ndecs+1,If(MV_PAR35==1,SE2->E2_TXMOEDA,If(lSemTaxaM2,1,nTaxaDia)))
							nTit1 += nSaldo
							nTit2 += nSaldo+nJuros
							nMesTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,MV_PAR15,SE2->E2_EMISSAO,ndecs+1,If(MV_PAR35==1,SE2->E2_TXMOEDA,If(lSemTaxaM2,1,nTaxaDia)))
							nMesTit1 += nSaldo
							nMesTit2 += nSaldo+nJuros
						EndIf
						nTotJur += (nJuros)
						nMesTitJ += (nJuros)
					Else				  //a vencer
						nVa := If(lFValAcess, FValAcess(SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_TIPO, SE2->E2_FORNECE, SE2->E2_LOJA, SE2->E2_NATUREZ, !Empty(SE2->E2_BAIXA), "", "P",,, SE2->E2_MOEDA, MV_PAR15, SE2->E2_TXMOEDA,, IIf(MV_PAR21 == 1, .T., .F.)), 0)
						aDados[VL_VENCIDO] := (nSaldo * If(SE2->E2_TIPO $ MV_CPNEG + "/" + MVPAGANT, -1, 1)) + nVa

						If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
							nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,MV_PAR15,SE2->E2_EMISSAO,ndecs+1,If(MV_PAR35==1,SE2->E2_TXMOEDA,If(lSemTaxaM2,1,nTaxaDia)))
							nTit3 -= nSaldo + nVa
							nTit4 -= nSaldo + nVa
							nMesTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,MV_PAR15,SE2->E2_EMISSAO,ndecs+1,If(MV_PAR35==1,SE2->E2_TXMOEDA,If(lSemTaxaM2,1,nTaxaDia)))
							nMesTit3 -= nSaldo + nVa
							nMesTit4 -= nSaldo + nVa
						Else
							nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,MV_PAR15,SE2->E2_EMISSAO,ndecs+1,If(MV_PAR35==1,SE2->E2_TXMOEDA,If(lSemTaxaM2,1,nTaxaDia)))
							nTit3 += nSaldo
							nTit4 += nSaldo
							nMesTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,MV_PAR15,SE2->E2_EMISSAO,ndecs+1,If(MV_PAR35==1,SE2->E2_TXMOEDA,If(lSemTaxaM2,1,nTaxaDia)))
							nMesTit3 += nSaldo + nVa
							nMesTit4 += nSaldo + nVa
						EndIf
					EndIf

					ADados[PORTADOR] := SE2->E2_PORTADO

					If nJuros > 0
						aDados[VL_JUROS] := nJuros
						nJuros := 0
					EndIf

					If dDataBase > SE2->E2_VENCREA
						nAtraso:=dDataBase-SE2->E2_VENCTO
						If Dow(SE2->E2_VENCTO) == 1 .Or. Dow(SE2->E2_VENCTO) == 7
							If Dow(dBaixa) == 2 .And. nAtraso <= 2
								nAtraso:=0
							EndIf
						EndIf
						nAtraso := If(nAtraso<0,0,nAtraso)
						If nAtraso>0
							aDados[ATRASO] := nAtraso
						EndIf
					EndIf
					If MV_PAR20 == 1  //1- Analitico  2-Sintetico
						If lQtdFil2 .And. nOrdem == 1
							oBreak2:execute(.F.)
						EndIf
						aDados[HISTORICO] := SubStr(SE2->E2_HIST,1,25)+If(SE2->E2_TIPO $ MVPROVIS,"*"," ")
						nRecnoSE2 := SE2->RECSE2

						DbChangeAlias("SE2", "SE2QRY")
						DbChangeAlias("__SE2", "SE2")
						SE2->(DbGoTo(nRecnoSE2))
						oSection1:PrintLine()
						DbChangeAlias("SE2", "__SE2")
						DbChangeAlias("SE2QRY", "SE2")
						AFill(aDados, Nil)
					EndIf

					cNomFil := cFilAnt + " - " + AllTrim(aSelFil[nInc][2])

					//Carrega data do registro para permitir posterior analise de quebra por mes.
					dDataAnt := dDtVenc := SE2->E2_EMISSAO
					
					If nOrdem == 3
						dDataAnt := dDtVenc := SE2->E2_VENCREA
					ElseIf nOrdem == 5 //Fornecedor
							cNomFor := If(MV_PAR28 == 1,AllTrim(GetLGPDValue("SA2","A2_NREDUZ")),AllTrim(GetLGPDValue("SA2","A2_NOME")))+" "+SubStr(GetLGPDValue("SA2","A2_TEL"),1,15)
					ElseIf nOrdem == 7	//Codigo Fornecedor
							cNomFor :=	SA2->A2_COD+" "+SA2->A2_LOJA+" "+AllTrim(GetLGPDValue("SA2","A2_NOME"))+" "+SubStr(GetLGPDValue("SA2","A2_TEL"),1,15)
					ElseIf nOrdem == 2 .And. SED->(DbSeek(xFilial("SED", SE2->E2_FILORIG)+SE2->E2_NATUREZ)) //Natureza
						cNomNat	:= MascNat(SED->ED_CODIGO)+" "+SED->ED_DESCRIC
					EndIf
					
					cNumBco	   := SE2->E2_PORTADO
					nTotVenc   := nTit2+nTit3
					nTotMes    := nMesTit2+nMesTit3
					nRecFiltro := SE2->RECSE2
					
					If MV_PAR20 == 2 .And. (nOrdem == 5 .Or. nOrdem == 7)
						nRecSE2Tmp := SE2->(RECNO())
					EndIf
					
					SE2->(DbSkip())
					nTotTit ++
					nMesTTit ++
					nFiltit++
					nTit5 ++
					nTotTitEmp++
				EndDo
				
				lReposic := .F.
				
				nTotGeral  	:= nTotMes
				nTotTitMes 	:= nMesTTit
				nGerTot  	+= nTit2 + nTit3
				nFilTot  	+= nTit2 + nTit3

				If MV_PAR20 == 2	//1- Analitico  2-Sintetico
					If SE2->(Eof()) .And. !Empty(cFilterUser)
						SE2->(DbGoTop())
						lReposic := .T.
					EndIf
					
					If nTit5 > 0 .And. nOrdem != 1 
						SubT150R(nTit0, nTit1, nTit2, nTit3, nTit4, nOrdem, cCarAnt, nTotJur, oReport, oSection1, nRecSE2Tmp)
					EndIf
					
					If lReposic
						SE2->(DbGoTo(0))
					EndIf

					lQuebra := .F.
					If nOrdem == 3 .And. Month(SE2->E2_VENCREA) # Month(dDataAnt)
						lQuebra := .T.
					ElseIf nOrdem == 6 .And. Month(SE2->E2_EMISSAO) # Month(dDataAnt)
						lQuebra := .T.
					EndIf
					If lQuebra .And. nMesTTit # 0
						lReposic := .F.
						If (SE2->(EoF()) .And. !Empty(cFilterUser))
							SE2->(DbGoTop())
							lReposic := .T.
						EndIf

						oReport:SkipLine()
						IMes150R(nMesTit0,nMesTit1,nMesTit2,nMesTit3,nMesTit4,nMesTTit,nMesTitJ,nTotTitMes,oReport,oSection1)
						oReport:SkipLine()
						nMesTit0 := nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0

						If (lReposic)
							SE2->(DbGoTo(0))
						EndIf
					EndIf
				EndIf

				DbSelectArea("SE2")

				nTot0 += nTit0
				nTot1 += nTit1
				nTot2 += nTit2
				nTot3 += nTit3
				nTot4 += nTit4
				nTotJ += nTotJur

				/*GESTAO - inicio */
				nTotEmp0 += nTit0
				nTotEmp1 += nTit1
				nTotEmp2 += nTit2
				nTotEmp3 += nTit3
				nTotEmp4 += nTit4
				nTotEmpJ += nTotJur
				/* GESTAO - fim*/

				nFil0 += nTit0
				nFil1 += nTit1
				nFil2 += nTit2
				nFil3 += nTit3
				nFil4 += nTit4
				nFilJ += nTotJur
				Store 0 To nTit0,nTit1,nTit2,nTit3,nTit4,nTit5,nTotJur

				nTotMes 	:= nTotVenc
				nTotFil 	:= nFil2 + nFil3
				nTotEmp 	+= nTotFil
			EndDo

			If !lQryEmp .And. (nOrdem == 3 .Or. nOrdem == 6 .Or. lImpXlsTbl)
				AAdd(aTotFil, {aSelFil[nInc][1], nFil0, nFil1, nFil2, nFil3, nFil4, nFilTit, nFilj, aSelFil[nInc][2]})
			EndIf

			If MV_PAR20 == 1 .And. nTotFil <> 0 .And. lQtdFil2 .And. nOrdem == 1
						oBreak2:PrintTotal()
						oReport:Skipline()
					EndIf

			If MV_PAR20 == 2	//1- Analitico  2-Sintetico
					If lConFilAbx .And. Len(aSelFil) > 1
						lReposic := .F.
						If (SE2->(EoF()) .And. !Empty(cFilterUser))
							SE2->(DbGoTop())
							lReposic := .T.
						EndIf

						oReport:SkipLine()
						IFil150R(nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilj,oReport,oSection1,aSelFil[nInc][2])
						Store 0 To nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ
						oReport:SkipLine()

						If (lReposic)
							SE2->(DbGoTo(0))
						EndIf
					EndIf
				EndIf

			Store 0 To nFil0, nFil1, nFil2, nFil3, nFil4, nFilJ, nTotJur
			If nOrdem != 4
				Store 0 To nTotFil
			EndIf

			DbSelectArea("SE2")
			SE2->(DbCloseArea())
			ChKFile("SE2")
			DbSetOrder(1)

			If (MV_PAR20 == 2 .And. !Empty(cFilterUser) .And. nRecFiltro > 0)
				SE2->(DbGoTo(nRecFiltro))
			EndIf
		EndIf

		If oFINR150 <> Nil
			oFINR150:Delete()
			oFINR150 := Nil
		EndIf
		nInc++
	EndDo

	SM0->(DbGoTo(nRegSM0))
	cFilAnt := SM0->M0_CODFIL

	If MV_PAR20 == 2 //1- Analitico  2-Sintetico
		If (!Empty(cFilterUser) .And. nRecFiltro > 0) //Impres�o pelo FINR150
			SE2->(DbGoTo(nRecFiltro))
		EndIf

		If (lQtdFil2) .Or. (lConFilAbx .And. SM0->(Reccount()) > 1)
			oReport:ThinLine()
			ImpT150R(nTot0, nTot1, nTot2, nTot3, nTot4, nTotTit, nTotJ, nTotTit, oReport, oSection1)
			oReport:SkipLine()
		Else
			ImpT150R(nTot0, nTot1, nTot2, nTot3, nTot4, nTotTit, nTotJ, nTotTit, oReport, oSection1)
		EndIf
	EndIf

	If !lQtdFil2
		oSection1:Finish()
	Else
		If oBreak <> NIL
			oBreak:Execute()
			oBreak:PrintTotal() //  I M P R I M E   O   S U B   T O T A L
			If nOrdem > 1
				oBreak2:PrintTotal() //  I M P R I M E   O    T O T A L   D A   F I L I A L   P O S I C I O N A D A
				oReport:Skipline()
			EndIf
			If nOrdem == 3	.Or. nOrdem == 6
				oBreak3:PrintTotal() //  I M P R I M E   O    T O T A L   D O  M E S
				oReport:Skipline()
			EndIf
		EndIf
	EndIf

	If nOrdem == 3 .Or. nOrdem == 6 .Or. lImpXlsTbl
		oSection2:Init()
		For ni := 1 to Len(aTotFil)
			oSection2:printline()
		Next
		oSection2:Finish()
	EndIf

	If __oDtBx != Nil
		__oDtBx:Destroy()
		__oDtBx := Nil
	EndIf

	SE2->(DbCloseArea())
	ChKFile("SE2")
	SE2->(DbSetOrder(1))

	// Restaura empresa / filial original
	SM0->(DbGoTo(nRegEmp))
	cFilAnt := SM0->M0_CODFIL

	//Acerta a database de acordo com a database real do sistema
	dDataBase := dOldDtBase

	__oTBxCanc:Destroy()
	__oTBxCanc := Nil

	If oFINR150 <> Nil
		oFINR150:Delete()
		oFINR150 := Nil
	EndIf

	DelSldTit()

	FwFreeArray(aDados)

Return Nil

/*/{Protheus.doc} SubT150R
IMPRIMIR SUBTOTAL DO RELATORIO

@author Daniel Tadashi Batori
@since 01/06/92
/*/
Static Function SubT150R(nTit0, nTit1, nTit2, nTit3, nTit4, nOrdem, cCarAnt, nTotJur, oReport, oSection1, nRegSE2)
	Local cQuebra := ""
	Local aAreaSE2:= {}
	
	Default nRegSE2 := 0
	
	If nOrdem == 1 .Or. nOrdem == 3 .Or. nOrdem == 6
		cQuebra := STR0026 + DToC(cCarAnt) //"S U B - T O T A L ----> "
	ElseIf nOrdem == 2
		SED->(DbSeek(xFilial("SED")+cCarAnt))
		cQuebra := cCarAnt +" "+SED->ED_DESCRIC
	ElseIf nOrdem == 4
		cQuebra := STR0026 + cCarAnt //"S U B - T O T A L ----> "
	ElseIf (nOrdem == 5 .Or. nOrdem == 7)
		aAreaSE2 := SE2->(GetArea())
		
		If nOrdem == 5 
			cQuebra := Iif(MV_PAR28 == 1, GetLGPDValue("SA2","A2_NREDUZ"), GetLGPDValue("SA2","A2_NOME"))
		Else
			cQuebra := SA2->A2_COD +" "+ SA2->A2_LOJA +" "+ GetLGPDValue("SA2","A2_NOME")
		EndIf		
		
		cQuebra += (+" "+ SubStr(GetLGPDValue("SA2","A2_TEL"), 1, 15))
		SE2->(DbGoto(nRegSE2)) //Reposiciona o titulo para realizar a quebra
	EndIf
	
	//habilita ou desabilita celulas para imprimir totais
	HabiCel(oReport)

	oSection1:Cell("FORNECEDOR"):SetBlock({|| cQuebra })
	oSection1:Cell("VAL_NOMI"  ):SetBlock({|| nTit1   })
	oSection1:Cell("VAL_CORR"  ):SetBlock({|| nTit2   })
	oSection1:Cell("VAL_VENC"  ):SetBlock({|| nTit3   })
	oSection1:Cell("JUROS"     ):SetBlock({|| nTotJur })
	oSection1:Cell("VAL_SOMA"  ):SetBlock({|| nTit2+nTit3 })	
	oSection1:PrintLine()
	
	If (nOrdem == 5 .Or. nOrdem == 7)
		RestArea(aAreaSE2)
	EndIf
Return .T.

/*/{Protheus.doc} ImpT150R
IMPRIMIR TOTAL DO RELATORIO

@author Daniel Tadashi Batori
@since 01/06/92
/*/
Static Function ImpT150R(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nTotTit,oReport,oSection1)
	//habilita ou desabilita celulas para imprimir totais
	HabiCel(oReport)

	oSection1:Cell("FORNECEDOR"):SetBlock({|| STR0027 + "(" + AllTrim(Str(nTotTit))+" "+If(nTotTit > 1,STR0028,STR0029)+")" })
	oSection1:Cell("VAL_NOMI"  ):SetBlock({|| nTot1 })
	oSection1:Cell("VAL_CORR"  ):SetBlock({|| nTot2 })
	oSection1:Cell("VAL_VENC"  ):SetBlock({|| nTot3 })
	oSection1:Cell("JUROS"     ):SetBlock({|| nTotJ })
	oSection1:Cell("VAL_SOMA"  ):SetBlock({|| nTot2+nTot3 })

	oSection1:PrintLine()

Return(.T.)

/*/{Protheus.doc} ImpT150R
IMPRIMIR TOTAL DO RELATORIO - QUEBRA POR MES

@author Vinicius Barreira
@since 12/12/94
/*/
Static Function IMes150R(nMesTit0,nMesTit1,nMesTit2,nMesTit3,nMesTit4,nMesTTit,nMesTitJ,nTotTitMes,oReport,oSection1)
	//habilita ou desabilita celulas para imprimir totais
	HabiCel(oReport)

	oSection1:Cell("FORNECEDOR"):SetBlock({|| STR0030 + "("+AllTrim(Str(nTotTitMes))+" "+IIf(nTotTitMes > 1,OemToAnsi(STR0028),OemToAnsi(STR0029))+")" })
	oSection1:Cell("VAL_NOMI"  ):SetBlock({|| nMesTit1 })
	oSection1:Cell("VAL_CORR"  ):SetBlock({|| nMesTit2 })
	oSection1:Cell("VAL_VENC"  ):SetBlock({|| nMesTit3 })
	oSection1:Cell("JUROS"     ):SetBlock({|| nMesTitJ })
	oSection1:Cell("VAL_SOMA"  ):SetBlock({|| nMesTit2+nMesTit3 })

	oSection1:PrintLine()

Return(.T.)

/*/{Protheus.doc} IFil150R
Imprimir total do relatorio

@author Paulo Boschetti
@since 01.06.92
/*/
Static Function IFil150R(nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ,oReport,oSection1,cFilSM0)
	//habilita ou desabilita celulas para imprimir totais
	HabiCel(oReport)

	oSection1:Cell("FORNECEDOR"):SetBlock({|| STR0032 + " " + cFilAnt + " - " + AllTrim(cFilSM0) })	//"T O T A L   F I L I A L ----> "
	oSection1:Cell("VAL_NOMI"  ):SetBlock({|| nFil1 })
	oSection1:Cell("VAL_CORR"  ):SetBlock({|| nFil2 })
	oSection1:Cell("VAL_VENC"  ):SetBlock({|| nFil3 })
	oSection1:Cell("JUROS"     ):SetBlock({|| nFilJ })
	oSection1:Cell("VAL_SOMA"  ):SetBlock({|| nFil2+nFil3 })

	oSection1:PrintLine()

Return .T.

/*/{Protheus.doc} HabiCel
habilita ou desabilita celulas para imprimir totais

@author Paulo Boschetti
@since 01.06.92
@param oReport, Object, objeto TReport que possui as celulas
/*/
Static Function HabiCel(oReport)

	Local oSection1 := oReport:Section(1)

	oSection1:Cell("FORNECEDOR"):SetSize(50)
	oSection1:Cell("TITULO"    ):Disable()
	oSection1:Cell("E2_TIPO"   ):Hide()
	oSection1:Cell("E2_NATUREZ"):Hide()
	oSection1:Cell("E2_EMISSAO"):Hide()
	oSection1:Cell("E2_VENCTO" ):Hide()
	oSection1:Cell("E2_VENCREA"):Hide()
	oSection1:Cell("VAL_ORIG"  ):Hide()
	oSection1:Cell("E2_PORTADO"):Hide()
	oSection1:Cell("DIA_ATR"   ):Hide()
	oSection1:Cell("E2_HIST"   ):Disable()
	oSection1:Cell("VAL_SOMA"  ):Enable()

	oSection1:Cell("FORNECEDOR"):HideHeader()
	oSection1:Cell("E2_TIPO"   ):HideHeader()
	oSection1:Cell("E2_NATUREZ"):HideHeader()
	oSection1:Cell("E2_EMISSAO"):HideHeader()
	oSection1:Cell("E2_VENCTO" ):HideHeader()
	oSection1:Cell("E2_VENCREA"):HideHeader()
	oSection1:Cell("VAL_ORIG"  ):HideHeader()
	oSection1:Cell("E2_PORTADO"):HideHeader()
	oSection1:Cell("DIA_ATR"   ):HideHeader()

Return(.T.)

/*/{Protheus.doc} FR150DBx
Busca a data da ultima baixa realizada do titulo a pagar at� a
DataBase do sistema.

@author leonardo.casilva

@since 20/05/2016
@version P1180
@return dDataRet
/*/
Static Function FR150DBx() As Date

	Local dDataRet As Date
	Local dDataBx  As Date
	Local cDataBx  As Character
	Local cQuery   As Character

	dDataRet 	:= SE2->E2_VENCREA
	dDataBx 	:= SE2->E2_VENCREA
	cDataBx 	:= ""
	cQuery      := ""

	If __oDtBx == NIL
		cQuery += " SELECT MAX(SE5.E5_DATA) DBAIXA"
		cQuery += " FROM ? SE5 "
		cQuery += " WHERE SE5.E5_FILIAL IN (?) "
		cQuery += " AND SE5.E5_PREFIXO = ?"
		cQuery += " AND SE5.E5_NUMERO = ?"
		cQuery += " AND SE5.E5_PARCELA = ?"
		cQuery += " AND SE5.E5_TIPO = ?"
		cQuery += " AND SE5.E5_CLIFOR = ?"
		cQuery += " AND SE5.E5_LOJA = ?"
		cQuery += " AND SE5.E5_TIPODOC IN('BA','VL')"
		cQuery += " AND SE5.E5_RECPAG  = 'P'"
		cQuery += " AND SE5.E5_SITUACA  <> 'C'"
		cQuery += " AND SE5.E5_DATA <= ?"
		cQuery += " AND SE5.D_E_L_E_T_ = ' '"

		cQuery += " AND NOT EXISTS (SELECT"
		cQuery += "		A.E5_NUMERO"
		cQuery += "	FROM"
		cQuery += "		? A"
		cQuery += "	WHERE"
		cQuery += "		A.E5_FILIAL = SE5.E5_FILIAL AND"
		cQuery += "		A.E5_PREFIXO = SE5.E5_PREFIXO AND"
		cQuery += "		A.E5_NUMERO = SE5.E5_NUMERO AND"
		cQuery += "		A.E5_PARCELA = SE5.E5_PARCELA AND"
		cQuery += "		A.E5_CLIFOR = SE5.E5_CLIFOR AND"
		cQuery += "		A.E5_LOJA = SE5.E5_LOJA AND"
		cQuery += "		A.E5_SEQ = SE5.E5_SEQ AND"
		cQuery += "		A.E5_TIPODOC = 'ES' AND"
		cQuery += "		A.E5_RECPAG = 'R' AND"
		cQuery += "		A.D_E_L_E_T_ = ' ')"

		cQuery 	  := ChangeQuery(cQuery)
		__oDtBx   := FWPreparedStatement():New(cQuery)
	EndIf

	__oDtBx:SetNumeric(1,RetSQLName("SE5"))
	__oDtBx:SetIn(2,{xFilial("SE2")})
	__oDtBx:SetString(3,SE2->E2_PREFIXO)
	__oDtBx:SetString(4,SE2->E2_NUM)
	__oDtBx:SetString(5,SE2->E2_PARCELA)
	__oDtBx:SetString(6,SE2->E2_TIPO)
	__oDtBx:SetString(7,SE2->E2_FORNECE)
	__oDtBx:SetString(8,SE2->E2_LOJA)
	__oDtBx:SetDate(9,dDataBase)
	__oDtBx:SetNumeric(10, RetSQLName("SE5"))

	cQuery  := __oDtBx:GetFixQuery()
	cDataBx := MpSysExecScalar(cQuery, "DBAIXA")

	If !Empty(AllTrim(cDataBx))
		dDataBx := SToD(cDataBx)
		dDataRet := dDataBx
	EndIf

Return dDataRet

/*/{Protheus.doc} FR150Log
Fun��o para logar os erros de execu��o do TcSQLExec.

@author Fernando Navarro (Adaptado do FINR130 por Rafael Sarracini)
@since 27/04/20
/*/
Static Function FR150Log(cLogText As Character, cSQLControl As Character)

	Local cFunction As Character
	Local cLogFile  As Character
	Local cLogHead  As Character
	Local cPath     As Character
	Local cProcLine As Character
	Local cThreadID As Character
	Local lContinua As Logical
	Local nHandle   As Numeric

	lContinua := .T.
	cPath := "\SYSTEM\"
	cLogFile := cPath + "FR150Log"+AllTrim(cEmpAnt+cFilant)+"_"+DToS(Date())+".log"

	If !File(cLogFile)
		nHandle := FCreate(cLogFile)
		If nHandle == -1
			lContinua := .F.
		Else
			cLogHead:= STR0069  + DToC(date()) + CRLF//"Log de incosist�ncias de execu��o dos comandos SQL do FINR150 em "
			FSeek (nHandle, 0, 2)	// Posiciona no final do arquivo.
			FWrite(nHandle, cLogHead, Len(cLogHead))
			FClose(nHandle)
		EndIf
	EndIf

	If lContinua

		cThreadID 	:= AllTrim(Str(ThreadID())) 	//Retorna o ID (n�mero de identifica��o) da thread em que a chamada da fun��o foi realizada
		cProcLine 	:= AllTrim(Str(ProcLine(1))) 	//Retorna o n�mero da linha do c�digo fonte executado que fez a chamada da gera��o do LOG
		cFunction 	:= ProcName(1) 					//Retorna o nome da funcao em execu��o que fez a chamada da gera��o do LOG

		cFunction := " Function " + cFunction

		cLogText := Time() + " " + "["+cThreadID+"]" + cFunction + " Line " + cProcLine + CRLF +;
					Space(5) +  "[" + cSQLControl + "] " + cLogText + CRLF

		// Grava o texto no Arquivo de LOG
		nHandle := FOpen(cLogFile, 2)
		FSeek (nHandle, 0, 2)	// Posiciona no final do arquivo.
		FWrite(nHandle, cLogText, Len(cLogText))
		FClose(nHandle)
	EndIf

Return

/*/{Protheus.doc} VerifProc
Verifica a exist�ncia da procedure e campos necess�rios para execu��o correta do relat�rio FINR150/SaldoTit.
@type 		user function
@author 	Rafael Riego
@since 		02/02/2021
/*/
Static Function VerifProc()

	Local cProcedure	As Character

	//Caso necess�rio, exibe mensagem informando a necessidade de atualiza��o do diferencial de dicion�rio
	If __lPFIN002 == Nil
		cProcedure	:= IIf(FindFunction("GetSPName"), GetSPName("FIN002", "10"), "FIN002")
		__lPFIN002	:= &('ExistProc(cProcedure, StaticCall(FinXFin, VerIdProc))')
	EndIf

	If !(IsBlind())

		//Verifica exist�ncia dos campos na tabela FK1 FK1_DTDISP e FK1_DTDIGI
		If __lCmpoFK1 == Nil .Or. __lCmpoFK2 == Nil 
			__lCmpoFK1 	:= FK1->(FieldPos("FK1_DTDISP")) > 0 .And. FK1->(FieldPos("FK1_DTDIGI")) > 0 
			__lCmpoFK2	:= FK2->(FieldPos("FK2_DTDISP")) > 0 .And. FK2->(FieldPos("FK2_DTDIGI")) > 0 
		EndIf

		//Verifica se a procedure SaldoTit est� em uso 
		If __lPFIN002 .And. (!__lCmpoFK2 .Or. !__lCmpoFK1)
			MsgAlert(STR0077, STR0078) //"Execute o UPDDISTR de acordo com a �ltima expedi��o cont�nua para cria��o dos dicion�rios necess�rios para a execu��o integral de todos os recursos do relat�rio." "Aten��o"
		EndIf
	EndIf

Return Nil
