#include "rwmake.ch"

//********************
User Function Rgpe002()
	//********************
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
	//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
	//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
	//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetPrvt("CAREA,NIND,CSTRING,CDESC1,CDESC2,CDESC3")
	SetPrvt("TAMANHO,AORD,ARETURN,NOMEPROG,ALINHA,NLASTKEY")
	SetPrvt("TITULO,CCANCEL,CPERG,M_PAG,WNREL,CFILDE")
	SetPrvt("CFILATE,CCUSTINI,CCUSTFIM,CSALARIO")
	SetPrvt("CRELATO,NREG,NTOT,NLIN,CABEC1,WCC")
	SetPrvt("WLO,WFERIAS,TSALARIO,T2,TT2")
	SetPrvt("WDSIT,TREG,WT_EXPA,WT_MENS,WT_EST,WT_COOR,wT_MASC,wT_FEM")
	SetPrvt("T1,WRR,")

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Funcao    ³ RGPE002  ³ Autor ³ JOSE MACEDO           ³ Rev. ³ 16.12.09 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descricao ³ Resumo de Pessoal                                          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Adaptado d³ GPEFUNC  ³ Autor ³ JOSE NORBERTO MACEDO  ³ Data ³ 07.12.00 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/

	cArea   := Alias()
	nInd    := IndexOrd()

	cString := "SRA"
	cDesc1  := OemToAnsi("Esta rotina ir  imprimir o Resumo de Pessoal, de")
	cDesc2  := OemToAnsi("acordo com os parametros definidos p/ usuario.  ")
	cDesc3  := ""
	tamanho := "G"
	limite  := 80
	aOrd    := {}
	aReturn := { "Zebrado", 1,"Financeiro", 2, 2, 1, "",1 }
	nomeprog:= "RGPE002"
	aLinha  := { }
	nLastKey:= 0
	Titulo  := "Resumo de Pessoal"

	cCancel := "***** CANCELADO PELO OPERADOR *****"
	cPerg   := "" //"GPE002"
	m_pag   := 1

	wnrel   :="RGPE002"


	//****************************************************************

	DbSelectArea("SAK")
	DBSETORDER(2)
	DBSEEK(xFilial("SAK")+&('RETCODUSR()'))    // SE FOR GERENTE NAO TEM ACESSO , COM EXCESSOES ABAIXO
	IF FOUND()
		IF !(UPPER(SUBSTR(cUsuario,7,6))$"AMANDA/MACEDO/HERALD/ANA.CA/ROSSIC/ADILAN/CRISTIA")
			ALERT("Relatorio nao disponivel para "+SUBSTR(cUsuario,7,6))
			RETURN Nil
		ENDIF
	ENDIF

	wnrel:= SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,tamanho)


	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	// INICIALIZA VARIAVEIS DE PARAMETROS (PERGUNTAS)

	cFilDe  := "01"
	cFilAte := "99"
	cCustIni:= " "
	cCustFim:= "ZZZZZZZZZ"
	cSalario:= 2
	cDocum  := 2

	DBSELECTAREA("SRH") //Eduardo 10.09.02
	DBSETORDER(2)

	DBSELECTAREA("SRD")
	dbOrderNickName("RDDATA")

	DBSELECTAREA("SRC")
	DBSETORDER(2)   // RC_CC+RC_MAT+RC_PD

	dbSelectArea("SRA")
	DBSETORDER(8)
	cRelato := " Por CCusto / Alfabetica"


	RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 15/02/01 ==> RptStatus({|| Execute(RptDetail) })

	dbSelectArea( cArea )

	DBSELECTAREA("SRH") //Eduardo 10.09.02
	DBSETORDER(1)

	DBSELECTAREA("SRC")
	DBSETORDER(1)

	DBSELECTAREA("SRD")
	DBSETORDER(1)

	dbSelectArea("SRA")
	DBSETORDER(1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡„o ³Impressao do corpo do relatorio                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 15/02/01 ==> Function RptDetail
Static Function RptDetail()
Local i as numeric
	// Estrutura do Arquivo Temporario

	aStru2:= {}
	aadd(aStru2 , {'TRB_CCU' ,'C', 09,0} )
	aadd(aStru2 , {'TRB_NOM' ,'C', 35,0} )
	aadd(aStru2 , {'TRB_NFU' ,'N', 06,0} )  // NUMERO DE FUNCIONARIOS COM ESSA VERBA 866
	aadd(aStru2 , {'TRB_PRO' ,'N', 14,2} )
	aadd(aStru2 , {'TRB_DES' ,'N', 14,2} )
	aadd(aStru2 , {'TRB_LIQ' ,'N', 14,2} )
	aadd(aStru2 , {'TRB_105' ,'N', 14,2} )
	aadd(aStru2 , {'TRB_106' ,'N', 14,2} )
	aadd(aStru2 , {'TRB_110' ,'N', 14,2} )
	aadd(aStru2 , {'TRB_112' ,'N', 14,2} )
	aadd(aStru2 , {'TRB_409' ,'N', 14,2} )
	aadd(aStru2 , {'TRB_FGT' ,'N', 14,2} )
	aadd(aStru2 , {'TRB_INS' ,'N', 14,2} )
	aadd(aStru2 , {'TRB_SAL' ,'N', 14,2} )  // SALARIO BASE (VERBA 866)
	aadd(aStru2 , {'TRB_HOR' ,'N', 14,2} )  // HORAS TRABALHADAS NO MES
	aadd(aStru2 , {'TRB_PER' ,'N', 06,2} )  // PERCENTUAL DAS HORAS SO TOTAL

	//cArqTemp2:= CriaTrab(aStru2 , .t.)

	//dbUseArea(.T.,,cArqTemp2,'TRB',.f.)

	//DBSELECTAREA("TRB")
	//INDEX ON TRB_CCU  TO &cArqTemp2

	oGetTab := FWTemporaryTable():New("TRB",)
	oGetTab:SetFields(aStru2)
	oGetTab:AddIndex("01", {"TRB_CCU"} )
	oGetTab:Create()

	dbSelectArea("TRB")

	_Xls   :="N"
	_AnoMes:=SUBSTR(DTOS(dDataBase),1,6) // ANO MES DATABASE
	@ 1,1 to  150,300 DIALOG oDlg2A TITLE "Periodo"
	@ 20, 10 SAY "Ano Mes BASE ?"
	@ 20, 59 GET _AnoMes PICTURE "999999" VALID NAOVAZIO()
	@ 30, 10 SAY "Gera Xls ?"
	@ 30, 59 GET _XLS    PICTURE "!" VALID _XLS$"SN"
	@ 60, 90 BmpButton Type 1 Action Close(oDlg2A)
	Activate Dialog oDlg2A Centered

	_FOLHAATUAL:=.T.
	IF _AnoMes<&('GETMV("MV_FOLMES")')        // SE DATABASE MENOR QUE MES DA FOLHA, BUSCA DADOS DO ACUMULADO
		_FOLHAATUAL:=.F.
		DBSELECTAREA("SRD")
		DBGOTOP()
		DBSEEK(xFilial("SRD")+_AnoMes)
		WHILE !EOF() .AND. RD_DATARQ=_AnoMes
			_PRO:=_DES:=_LIQ:=0
			_105:=_106:=_110:=_112:=_409:=0
			_FGT:=_INS:=0
			_SAL:=_NFU:=0   // SALARIO BASE E NUMERO DE FUNCIONARIOS DE FOLHAS ANTERIORES
			_CC :=RD_CC
			_HOR:=_PER:=0
			WHILE !EOF() .AND. RD_DATARQ=_AnoMes .AND. RD_CC=_CC
				IF POSICIONE("SRV",1,XFILIAL("SRV")+SRD->RD_PD,"RV_TIPOCOD")="1"
					_PRO:=_PRO + RD_VALOR
					IF RD_PD="105"
						_105+=RD_VALOR
						_HOR+=RD_HORAS
					ENDIF
					IF RD_PD="106"
						_106+=RD_VALOR
						_HOR+=RD_HORAS
					ENDIF
					IF RD_PD="110"
						_110+=RD_VALOR
					ENDIF
					IF RD_PD="112"
						_112+=RD_VALOR
					ENDIF
				ELSEIF SRV->RV_TIPOCOD="2"
					_DES:=_DES + RD_VALOR
					IF RD_PD="409"
						_409+=RD_VALOR
					ENDIF
				ELSEIF SRV->RV_TIPOCOD="3"           // VERBAS DE BASE
					IF RD_PD="799"
						_LIQ:=_LIQ + RD_VALOR
					ENDIF
					IF RD_PD$"732/740/742/743/730"   // FGTS A RECOLHER
						_FGT:=_FGT + RD_VALOR
					ENDIF
					IF RD_PD$"721/722/723/724"
						_INS:=_INS + (RD_VALOR*0.288) // INSS PARTE EMPRESA + TERCEIROS + ACD TRAB
					ENDIF
					IF RD_PD="866"                  // SALARIO BASE
						_SAL:=_SAL + RD_VALOR
						_NFU++
						_HOR:=_HOR + POSICIONE("SRA",1,XFILIAL("SRA")+SRD->RD_MAT ,"RA_HRSMES")
					ENDIF
				ENDIF
				DBSELECTAREA("SRD")
				DBSKIP()
			ENDDO
			DBSELECTAREA("TRB")
			RECLOCK("TRB",.T.)
			TRB->TRB_CCU:=_CC
			TRB->TRB_NFU:=_NFU
			TRB->TRB_PRO:=_PRO
			TRB->TRB_DES:=_DES
			TRB->TRB_LIQ:=_LIQ
			TRB->TRB_105:=_105
			TRB->TRB_106:=_106
			TRB->TRB_110:=_110
			TRB->TRB_112:=_112
			TRB->TRB_409:=_409
			TRB->TRB_FGT:=_FGT
			TRB->TRB_INS:=_INS
			TRB->TRB_SAL:=_SAL
			TRB->TRB_HOR:=_HOR // HORAS TRABALHADAS
			MSUNLOCK()
			DBSELECTAREA("SRD")
		ENDDO
	ELSE
		DBSELECTAREA("SRC")    // BUSCA VALORES NO MES ATUAL
		DBSETORDER(2)
		DBGOTOP()
		WHILE !EOF()
			_PRO:=_DES:=_LIQ:=0
			_105:=_106:=_110:=_112:=_409:=0
			_FGT:=_INS:=0
			_HOR:=_PER:=0
			_CC :=RC_CC
			_SAL:=_NFU:=0
			WHILE !EOF() .AND. RC_CC=_CC
				IF POSICIONE("SRV",1,XFILIAL("SRV")+SRC->RC_PD,"RV_TIPOCOD")="1"
					_PRO:=_PRO + RC_VALOR
					IF RC_PD="105"
						_105+=RC_VALOR
						_HOR+=RC_HORAS
					ENDIF
					IF RC_PD="106"
						_106+=RC_VALOR
						_HOR+=RC_HORAS
					ENDIF
					IF RC_PD="110"
						_110+=RC_VALOR
					ENDIF
					IF RC_PD="112"
						_112+=RC_VALOR
					ENDIF
				ELSEIF SRV->RV_TIPOCOD="2"
					_DES:=_DES + RC_VALOR
					IF RC_PD="409"
						_409+=RC_VALOR
					ENDIF
				ELSEIF SRV->RV_TIPOCOD="3"    // VERBAS DE BASE
					IF RC_PD="799"
						_LIQ:=_LIQ + RC_VALOR
					ENDIF
					IF RC_PD$"732/740/742/743/730"   // FGTS A RECOLHER
						_FGT:=_FGT + RC_VALOR
					ENDIF
					IF RC_PD$"721/722/723/724"
						_INS:=_INS + (RC_VALOR*0.288) // INSS PARTE EMPRESA + TERCEIROS + ACD TRAB
					ENDIF
					IF RC_PD="866"                  // SALARIO BASE
						_SAL:=_SAL + RC_VALOR
						_NFU++
						_HOR:=_HOR + POSICIONE("SRA",1,XFILIAL("SRA")+SRC->RC_MAT ,"RA_HRSMES")
					ENDIF
				ENDIF
				DBSELECTAREA("SRC")
				DBSKIP()
			ENDDO
			DBSELECTAREA("TRB")
			RECLOCK("TRB",.T.)
			TRB->TRB_CCU:=_CC
			TRB->TRB_NFU:=_NFU
			TRB->TRB_PRO:=_PRO
			TRB->TRB_DES:=_DES
			TRB->TRB_LIQ:=_LIQ
			TRB->TRB_105:=_105
			TRB->TRB_106:=_106
			TRB->TRB_110:=_110
			TRB->TRB_112:=_112
			TRB->TRB_409:=_409
			TRB->TRB_FGT:=_FGT
			TRB->TRB_INS:=_INS
			TRB->TRB_SAL:=_SAL
			TRB->TRB_HOR:=_HOR
			MSUNLOCK()
			DBSELECTAREA("SRC")
		ENDDO
	ENDIF

	DBSELECTAREA("TRB") // MONTA TOTAL DE HORAS TRABALHADAS
	DBGOTOP()
	_TOTHORAS:=0
	WHILE !EOF()
		_TOTHORAS+=TRB_HOR
		DBSKIP()
	ENDDO
	DBGOTOP()
	//********************************************************************

	//Titulo := Titulo + cRelato
	nReg   := 1
	nTot   := 0
	nLin   := 0
	m_pag  := 1
	_CAMPO:="Lotacao   "


	//***************************************************** CARREGA TABELA ESTADOS
	//cEstCivil	:= Substr(TrmDesc("SX5","33"+SRA->RA_ESTCIVI,"SX5->X5_DESCRI"),1,15)

	_n33REG:=0
	//DBSELECTAREA("SX5")
	//DBSEEK("  "+"33")
	//WHILE !EOF() .AND. LEFT(X5_TABELA,2)="33"
	//	_n33REG++
	//	DBSKIP()
	//ENDDO
	_33CHA:=ARRAY(_n33REG)
	_33DES:=ARRAY(_n33REG)
	_33QTD:=ARRAY(_n33REG)

	I:=1/*
	DBSEEK("  "+"33")
	WHILE !EOF() .AND. LEFT(X5_TABELA,2)="33"
		_33CHA[I]:=X5_CHAVE
		_33DES[I]:=X5_DESCRI
		_33QTD[I]:=0
		I++
		DBSKIP()
	ENDDO
*/
	//***************************************************** CARREGA TABELA ESTADOS
	_n12REG:=0
	//DBSELECTAREA("SX5")
	//DBSEEK("  "+"12")
	//WHILE !EOF() .AND. LEFT(X5_TABELA,2)="12"
	//	_n12REG++
	//	DBSKIP()
	//ENDDO
	_12CHA:=ARRAY(_n12REG)
	_12DES:=ARRAY(_n12REG)
	_12MET:=ARRAY(_n12REG)
	_12CAB:=ARRAY(_n12REG)

	I:=1/*
	DBSEEK("  "+"12")
	WHILE !EOF() .AND. LEFT(X5_TABELA,2)="12"
		_12CHA[I]:=X5_CHAVE
		_12DES[I]:=X5_DESCRI
		_12MET[I]:=0
		_12CAB[I]:=0
		I++
		DBSKIP()
	ENDDO
*/
	//***************************************************** CARREGA TABELA GRAU DE INSTRUÇÃO
	_nREG:=0
	//DBSELECTAREA("SX5")
	//DBSEEK("  "+"26")
	//WHILE !EOF() .AND. LEFT(X5_TABELA,2)="26"
	//	_nREG++
	//	DBSKIP()
	//ENDDO
	_CHAVE:=ARRAY(_nREG)
	_DESCR:=ARRAY(_nREG)
	_QTFUN:=ARRAY(_nREG)
	_HOMEM:=ARRAY(_nREG)
	_MULHE:=ARRAY(_nREG)

	I:=1/*
	DBSEEK("  "+"26")
	WHILE !EOF() .AND. LEFT(X5_TABELA,2)="26"
		_CHAVE[I]:=X5_CHAVE
		_DESCR[I]:=X5_DESCRI
		_QTFUN[I]:=0
		_HOMEM[I]:=0
		_MULHE[I]:=0
		I++
		DBSKIP()
	ENDDO*/

	//***************************************************** CARREGA TABELA TIPO DE FUNCOES
	_n2REG:=0
	//DBSELECTAREA("SX5")
	//DBSEEK("  "+"RH")
	//WHILE !EOF() .AND. LEFT(X5_TABELA,2)="RH"
	//	_n2REG++
	//	DBSKIP()
	//ENDDO
	_2CHAVE:=ARRAY(_n2REG)
	_2DESCR:=ARRAY(_n2REG)
	_2QTFUN:=ARRAY(_n2REG)
	_2HOMEM:=ARRAY(_n2REG)
	_2MULHE:=ARRAY(_n2REG)
	_2SALAR:=ARRAY(_n2REG)

	I:=1/*
	DBSEEK("  "+"RH")
	WHILE !EOF() .AND. LEFT(X5_TABELA,2)="RH"
		_2CHAVE[I]:=X5_CHAVE
		_2DESCR[I]:=X5_DESCRI
		_2QTFUN[I]:=0
		_2HOMEM[I]:=0
		_2MULHE[I]:=0
		_2SALAR[I]:=0
		I++
		DBSKIP()
	ENDDO*/

	//Elmo, em Out-2019: retirada de parâmetros "chumbados" na rotina e uso de Parâmetros (CFG)  - INICIO

	//_FATOR
	cConteudo := "0.0133192"
	aDescr := {"Seguro de Vida: Fator","Usado pela rotina SEGVIDA, no cálculo do Seguro de Vida - Folha","."}
	cParametro := "SEGVIDAFAT"
	CriaPar(cParametro, "N",cConteudo,aDescr)

	_FATOR := GetMV(cParametro)

	//_BASEPRO
	cConteudo := "16000"
	aDescr := {"Seguro de Vida: Base P-Labore","Usado pela rotina SEGVIDA, no cálculo do Seguro de Vida - Folha","."}
	cParametro := "SEGVIDAPRO"
	CriaPar(cParametro, "N",cConteudo,aDescr)

	_BASEPRO:= GetMV(cParametro)

	//_BASEDIR
	cConteudo := "26028"
	aDescr := {"Seguro de Vida: Teto Salarial","Usado pela rotina SEGVIDA, no cálculo do Seguro de Vida - Folha","."}
	cParametro := "SEGVIDATET"
	CriaPar(cParametro, "N",cConteudo,aDescr)

	_BASEDIR:= GetMV(cParametro)

	//Elmo, em Out-2019: retirada de parâmetros "chumbados" na rotina e uso de Parâmetros (CFG)  - FINAL

	DBSELECTAREA("Z0C")  // ACUMULADOS ANUAIS RESUMO
	DBSETORDER(1)

	DBSELECTAREA("SRA")
	SET FILTER TO RA_CC >= cCustIni .and. RA_CC <= cCustFim .AND. RA_SITFOLH$" AF" .AND. RA_SALARIO > 0 //.AND. SRA->RA_CATFUNC=="M"
	dbGoTop()

	_BASESEGVIDA:=0
	//_FATOR      :=0.02245 //0.02749 //0.02950          //0.03389         //0.0144       // EM CASO DE ALTERACAO DESSE FATOR, ALTERAR TAMBEM O FPG303R.PRW
	_PROLAB     := _BASEPRO //16000                      // base do pro-labore para seguro de vida           ****** IDEM ****************
	_BASESEG    := _BASEDIR//26028                      // SEGURO
	_QTDFUNC    :=0
	_DETERM     :=0               // NUMERO DE FUNCIONARIOS COM PRAZO DE TRABALHO OPR TEMPO DETERMINADO
	WHILE !EOF()
		IF SRA->RA_CATFUNC$"M"
			_BASESEGVIDA:=_BASESEGVIDA + iif(SRA->RA_SALARIO <= _BASESEG, SRA->RA_SALARIO, _BASESEG) //Verificar o teto máximo Antonio Carlos 28/06/2017
			_QTDFUNC++
		ENDIF
		IF SRA->RA_TPCONTR="2"
			_DETERM+=1
		ENDIF
		DBSKIP()
	ENDDO
	_VALUNIT    := (_BASESEGVIDA )* _FATOR
	_VALUNIT    := _VALUNIT / _QTDFUNC

	cCabec1 := ' '
	cCabec2 := ' '

	//SetRegua(RecCount()) //-- Total de elementos da regua.

	cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
	nLinha := 6

	SetRegua(LastRec()) //Ajusta numero de elementos da regua de relatorios

	Store 0 to  TVAL,TREG,TSALARIO,T1,S1,T2,wT_EXPA,wT_MENS,wT_EST,wT_COOR,TT2,wT_Masc,wT_Fem,s4
	Store 0 to _Id18M,_Id18F,_Id23M,_Id23F,_Id28M,_Id28F,_Id33M,_Id33F
	Store 0 to _Id38M,_Id38F,_Id43M,_Id43F,_Id48M,_Id48F,_Id53M,_Id53F
	Store 0 to _Id58M,_Id58F,_Id59M,_Id59F

	Store 0 to _XId01M,_XId01F,_XId02M,_XId02F,_XId03M,_XId03F,_XId04M,_XId04F


	_TSVG:=0
	_FX1:=_FX2:=_FX3:=_FX4:=_FX5:=_FX6:=_FX7:=_FX8:=0
	_FX1H:=_FX2H:=_FX3H:=_FX4H:=_FX5H:=_FX6H:=_FX7H:=_FX8H:=0
	_FX1M:=_FX2M:=_FX3M:=_FX4M:=_FX5M:=_FX6M:=_FX7M:=_FX8M:=0

	_T1:=_T2:=_T3:=_T4:=_T5:=_T6:=_T7:=_T8:=0 // TOTAIS VERBAS DA FOLHA
	_TINS:=_TFGT:=0
	_THOR:=0
	_TEMP:=SUBSTR(_ANOMES,5,2)+"/"+SUBSTR(_ANOMES,1,4)
	@ nLinha,007 Psay SPACE(41)+"*--------------------------------------------FOLHA DE PAGAMENTO MES "+_Temp+"------------------------------------------------*    HHT "+_Temp
	nLinha := nLinha + 1
	@ nLinha,007 Psay " Centro de Custo         Qtd Salario Base       Inss       Fgts   Seg.Vida Tot Proventos  Descontos    Liquido    H.E 50%   H.E 100%    Ad.Notu        DSR     Faltas   Hrs.Trab  (%%)"
	nLinha := nLinha + 1

	_TTPCD:=0
	_PROD2:=""

	DBSELECTAREA("SRA")
	DBSETORDER(2)
	DBGOTOP()
	While !Eof()

		IncRegua() //Incrementa a posicao da regua de relatorios
		wCC:=RA_CC
		wLO:=RA_CC
		_VAI:=.T.
		IF _VAI

			IF !(SRA->RA_TPDEFFI$" 06")        // PCD (PORTADOR DEF FISICA)
				_TTPCD++
				_PROD2:=_PROD2+SRA->RA_MAT+"/"
			ENDIF


			wFERIAS:=.F.
			DBSELECTAREA("SRH")
			dBSEEK(xFILIAL()+SRA->RA_MAT)
			DO WHILE !EOF() .AND. SRH->RH_MAT == SRA->RA_MAT
				IF MONTH(SRH->RH_DATAINI)==MONTH(dDATABASE) .AND. YEAR(SRH->RH_DATAINI)==YEAR(dDATABASE)
					wFERIAS:=.T.
				ENDIF
				DBSKIP()
			ENDDO
			DBSELECTAREA("SRA")
			//Fim alteracao


			IF SRA->RA_CATFUNC=="S"
				wT_EXPA:=wT_EXPA + 1
			ELSEIF SRA->RA_CATFUNC=="M"
				wT_MENS:=wT_MENS + 1
			ELSEIF SRA->RA_CATFUNC=="E"
				wT_EST :=wT_EST  + 1
			ELSEIF SRA->RA_CATFUNC$"P/A"
				wT_COOR:=wT_COOR + 1
			ENDIF
			T1   := T1   + 1                // TOTAL DO CENTRO DE CUSTO
			TVAL := TVAL + SRA->RA_SALARIO
			S1   := S1   + SRA->RA_SALARIO
			IF SRA->RA_CATFUNC$"M"                 // SEGURO DE VIDA SOMENTE PARA MENSALISTAS
				s4   := s4   + sra->ra_salario
			ENDIF
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Testa a idade a do Funcionario                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			cDataNas := dtos(SRA->RA_NASC)
			cDataAtu := dtos(DDATABASE)

			cAnoNas  := substr(cDataNas,1,4)
			cAnoAtu  := substr(cDataAtu,1,4)

			cMesNas  := substr(cDataNas,5,4)
			cMesAtu  := substr(cDataAtu,5,4)

			_idade := val(cAnoAtu)-val(cAnoNas)

			If cMesNas > cMesAtu
				_idade := _idade - 1
			Endif

			If _idade <= 30 // 18
				IF SRA->RA_SEXO == "M"
					_id18M := _id18M + 1
				ELSEIF SRA->RA_SEXO == "F"
					_id18F := _id18F + 1
				ENDIF
			Elseif  _idade > 30 .and. _idade <= 50 // _idade > 18 .and. _idade <= 23
				IF SRA->RA_SEXO == "M"
					_id23M := _id23M + 1
				ELSEIF SRA->RA_SEXO == "F"
					_id23F := _id23F + 1
				ENDIF
			Elseif  _idade > 50 //_idade > 23 .and. _idade <= 28
				IF SRA->RA_SEXO == "M"
					_id28M := _id28M + 1
				ELSEIF SRA->RA_SEXO == "F"
					_id28F := _id28F + 1
				ENDIF
			endif



			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Testa TEMPO DE ADMISSAO DO FUNCIONARIO                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			cDataADM := dtos(SRA->RA_ADMISSA)
			cDataAtu := dtos(DDATABASE)

			cAnoADM  := substr(cDataADM,1,4)
			cAnoAtu  := substr(cDataAtu,1,4)

			cMesADM  := substr(cDataADM,5,4)
			cMesAtu  := substr(cDataAtu,5,4)

			_Xidade := val(cAnoAtu)-val(cAnoADM)

			If cMesADM > cMesAtu
				_Xidade := _Xidade - 1
			Endif

			If _Xidade <= 02
				IF SRA->RA_SEXO == "M"
					_Xid01M := _Xid01M + 1
				ELSEIF SRA->RA_SEXO == "F"
					_Xid01F := _Xid01F + 1
				ENDIF
			Elseif  _Xidade > 02 .and. _Xidade <= 05
				IF SRA->RA_SEXO == "M"
					_Xid02M := _Xid02M + 1
				ELSEIF SRA->RA_SEXO == "F"
					_Xid02F := _Xid02F + 1
				ENDIF
			Elseif  _Xidade > 05 .and. _Xidade <= 10
				IF SRA->RA_SEXO == "M"
					_Xid03M := _Xid03M + 1
				ELSEIF SRA->RA_SEXO == "F"
					_Xid03F := _Xid03F + 1
				ENDIF
			Elseif  _Xidade > 10
				IF SRA->RA_SEXO == "M"
					_Xid04M := _Xid04M + 1
				ELSEIF SRA->RA_SEXO == "F"
					_Xid04F := _Xid04F + 1
				ENDIF
			endif



			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Testa NATURALIDADE                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			FOR I:=1 TO _n12REG
				IF RA_NATURAL=ALLTRIM(_12CHA[I])
					_12MET[I]++
				ENDIF
			NEXT I

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Testa EST CIVIL                                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			FOR I:=1 TO _n33REG
				IF RA_ESTCIVI=ALLTRIM(_33CHA[I])
					_33QTD[I]++
				ENDIF
			NEXT I

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Testa o sexo do Funcionario                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			IF SRA->RA_SEXO == "M"
				wT_Masc := wT_Masc + 1
			ELSEIF SRA->RA_SEXO == "F"
				wT_Fem :=  wT_Fem + 1
			ENDIF

			IF SRA->RA_SALARIO<=500
				_FX1++
				IF RA_SEXO="M"
					_FX1H++
				ELSE
					_FX1M++
				ENDIF
			ELSEIF SRA->RA_SALARIO>500 .AND. SRA->RA_SALARIO<=750
				_FX2++
				IF RA_SEXO="M"
					_FX2H++
				ELSE
					_FX2M++
				ENDIF
			ELSEIF SRA->RA_SALARIO>750 .AND. SRA->RA_SALARIO<=1000
				_FX3++
				IF RA_SEXO="M"
					_FX3H++
				ELSE
					_FX3M++
				ENDIF
			ELSEIF SRA->RA_SALARIO>1000 .AND. SRA->RA_SALARIO<=2000
				_FX4++
				IF RA_SEXO="M"
					_FX4H++
				ELSE
					_FX4M++
				ENDIF
			ELSEIF SRA->RA_SALARIO>2000 .AND. SRA->RA_SALARIO<=3000
				_FX5++
				IF RA_SEXO="M"
					_FX5H++
				ELSE
					_FX5M++
				ENDIF
			ELSEIF SRA->RA_SALARIO>3000 .AND. SRA->RA_SALARIO<=4000
				_FX6++
				IF RA_SEXO="M"
					_FX6H++
				ELSE
					_FX6M++
				ENDIF
			ELSEIF SRA->RA_SALARIO>4000 .AND. SRA->RA_SALARIO<=5000
				_FX7++
				IF RA_SEXO="M"
					_FX7H++
				ELSE
					_FX7M++
				ENDIF
			ELSEIF SRA->RA_SALARIO>5000
				_FX8++
				IF RA_SEXO="M"
					_FX8H++
				ELSE
					_FX8M++
				ENDIF
			ENDIF
		ENDIF
		//**************************************************************** GRAU DE INSTRUCAO
		FOR I:=1 TO _nREG
			IF _CHAVE[I]=RA_GRINRAI
				_QTFUN[I]++
				IF RA_SEXO="M"
					_HOMEM[I]++
				ELSE
					_MULHE[I]++
				ENDIF
				EXIT
			ENDIF
		NEXT I

		//**************************************************************** TIPO DE FUNCAO
		_CODFUNC:=RA_CODFUNC
		_RJTIPO	:= POSICIONE("SRJ",1,XFILIAL("SRJ")+_CODFUNC,"RJ_TIPO")
		IF EMPTY(_RJTIPO)
			ALERT("FUNCAO SEM TIPO .. MATRICULA : "+RA_MAT)
		ENDIF
		FOR I:=1 TO _n2REG
			IF _2CHAVE[I]=_RJTIPO
				_2QTFUN[I]++
				_2SALAR[I]:=_2SALAR[I] + RA_SALARIO
				IF RA_SEXO="M"
					_2HOMEM[I]++
				ELSE
					_2MULHE[I]++
				ENDIF
				EXIT
			ENDIF
		NEXT I

		dbSelectArea("SRA")
		dbSkip()


		IF RA_CC<>wCC .AND. T1 > 0                                               // IMPRESSAO DO RELATORIO
			_DESCCC:=ALLTRIM(Posicione("CTT",1,xFilial("CTT")+wCC,"CTT_DESC01"))
			@ nLinha,000 Psay LEFT((ALLTRIM(wCC)+"-"+_DESCCC),30)

			DBSELECTAREA("TRB")   // BUSCA TOTAIS DA FOLHA
			DBSEEK(wCC)
			IF FOUND()
				IF !_FOLHAATUAL   // SE NAO FOR FOLHA ATUAL, MUDA O NUM DE FUNCIONARIOS E O SALARIO BASE (BUSCADO DO SRD)
					T1:=TRB_NFU
					S1:=TRB_SAL
				ENDIF
				@ nLinha,032 PSAY STRZERO(T1,3)                                    // NUM FUNC
				@ nLinha,036 PSAY S1          PICTURE "@EZ 9,999,999.99"           // SALARIO BASE

				@ nLinha,049 PSAY TRB_INS    PICTURE "@EZ 999,999.99"    // INSS
				@ nLinha,060 PSAY TRB_FGT    PICTURE "@EZ 999,999.99"    // FGTS
				@ nLinha,071 PSAY (s4*0.30)*_FATOR  PICTURE "@EZ 999,999.99"    // seguro de vida por centro de custo

				@ nLinha,083 PSAY TRB_PRO  PICTURE "@E 9,999,999.99"
				@ nLinha,096 PSAY TRB_DES  PICTURE "@E 999,999.99"
				@ nLinha,107 PSAY TRB_LIQ  PICTURE "@E 999,999.99"
				@ nLinha,118 PSAY TRB_105  PICTURE "@E 999,999.99"
				@ nLinha,129 PSAY TRB_106  PICTURE "@E 999,999.99"
				@ nLinha,140 PSAY TRB_110  PICTURE "@E 999,999.99"
				@ nLinha,151 PSAY TRB_112  PICTURE "@E 999,999.99"
				@ nLinha,162 PSAY TRB_409  PICTURE "@E 999,999.99"
				@ nLinha,173 PSAY TRB_HOR  PICTURE "@E 999,999.99"
				_PER:=(TRB_HOR/_TOTHORAS)*100
				@ nLinha,184 PSAY _PER  PICTURE "@E 999.99"
				@ nLinha,191 PSAY "%"

				TREG+=T1     // NUM TOTAL DE FUNCIONARIOS
				_T1+=TRB_PRO
				_T2+=TRB_DES
				_T3+=TRB_LIQ
				_T4+=TRB_105
				_T5+=TRB_106
				_T6+=TRB_110
				_T7+=TRB_112
				_T8+=TRB_409
				_TINS+=TRB_INS
				_TFGT+=TRB_FGT
				_THOR+=TRB_HOR

				RECLOCK("TRB",.F.)
				TRB_NOM:=_DESCCC
				TRB_PER:=_PER            // GRAVA O PERCENTUAL DE HORAS DO CENTRO DE CUSTO SOBRE O TOTAL DE HORAS
				MSUNLOCK()

				DBSELECTAREA("Z0C")                                  // GRAVA NA TABELA DE ACUMULADOS ANUAIS (Z0C)
				DBSEEK(xFilial("Z0C")+SUBSTR(wCC,1,9)+_AnoMes)
				IF !FOUND()
					RECLOCK("Z0C",.T.)
					Z0C->Z0C_FILIAL:=xFilial("Z0C")
					Z0C->Z0C_CCUS  :=wCC
					Z0C->Z0C_DATAR :=_AnoMes
					Z0C->Z0C_NOME  :=_DESCCC
				ELSE
					RECLOCK("Z0C",.F.)
				ENDIF
				Z0C->Z0C_PROVEN:=TRB->TRB_PRO
				Z0C->Z0C_DESCON:=TRB->TRB_DES
				Z0C->Z0C_LIQUID:=TRB->TRB_LIQ
				Z0C->Z0C_HEXTRA:=(TRB->TRB_105+TRB->TRB_106+TRB->TRB_110+TRB->TRB_112)
				Z0C->Z0C_FALTAS:=TRB->TRB_409
				Z0C->Z0C_VALO06:=TRB->TRB_HOR    // HORAS TRABALHADAS NO MES
				Z0C->Z0C_VALO07:=S1              // SALARIO BASE
				Z0C->Z0C_VALO08:=TRB->TRB_INS    // INSS
				Z0C->Z0C_VALO09:=TRB->TRB_FGT    // FGTS
				Z0C->Z0C_VALO10:=T1              // TOTAL DE FUNCIONARIOS DO CENTRO DE CUSTO
				MSUNLOCK()
			ENDIF
			DBSELECTAREA("SRA")

			nLinha:=nLinha+1
			_TSVG:=_TSVG + ((s4*0.30)*_FATOR)
			IF NLINHA>55
				cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
				nLinha := 6
			ENDIF
			S1:=0
			S4:=0
			T1:=0
			T2:=0
		ENDIF
	EndDO
	@ nLinha,031 PSAY REPLICATE("-",131)
	nLinha++

	@ nLinha,000 Psay "AMC"
	@ nLinha,007 Psay "* TOTAL DE EMPREGADOS -> " + STRZERO(TREG,3)
	@ nLinha,036 PSAY TVAL          PICTURE "@EZ 9,999,999.99"
	@ nLinha,049 PSAY _TINS         PICTURE "@EZ 999,999.99"
	@ nLinha,060 PSAY _TFGT         PICTURE "@EZ 999,999.99"
	@ nLinha,071 PSAY _TSVG         PICTURE "@EZ 999,999.99"
	@ nLinha,083 PSAY _T1  PICTURE "@EZ 9,999,999.99"
	@ nLinha,096 PSAY _T2  PICTURE "@EZ 999,999.99"
	@ nLinha,107 PSAY _T3  PICTURE "@EZ 999,999.99"
	@ nLinha,118 PSAY _T4  PICTURE "@EZ 999,999.99"
	@ nLinha,129 PSAY _T5  PICTURE "@EZ 999,999.99"
	@ nLinha,140 PSAY _T6  PICTURE "@EZ 999,999.99"
	@ nLinha,151 PSAY _T7  PICTURE "@EZ 999,999.99"
	@ nLinha,162 PSAY _T8  PICTURE "@EZ 999,999.99"
	@ nLinha,173 PSAY _THOR         PICTURE "@E 999,999.99"
	_PER:=100
	@ nLinha,184 PSAY _PER  PICTURE "@E 999.99"
	@ nLinha,191 PSAY "%"

	nLinha++                // IMPRIME OS PERCENTUAIS SOBRE O VALOR TOTAL DE PROVENTOS
	@ nLinha,036+2 PSAY (TVAL/_T1) *100           PICTURE "@EZ 999.99"
	@ nLinha,042+2 PSAY "%"
	@ nLinha,049+2 PSAY (_TINS/_T1) *100   PICTURE "@EZ 999.99"
	@ nLinha,055+2 PSAY "%"
	@ nLinha,060+2 PSAY (_TFGT/_T1) *100   PICTURE "@EZ 999.99"
	@ nLinha,066+2 PSAY "%"
	@ nLinha,071+2 PSAY (_TSVG/_T1)*100           PICTURE "@EZ 999.99"
	@ nLinha,077+2 PSAY "%"
	@ nLinha,096+2 PSAY (_T2/_T1) *100  PICTURE "@E 999.99"
	@ nLinha,102+2 PSAY "%"
	@ nLinha,107+2 PSAY (_T3/_T1) *100  PICTURE "@E 999.99"
	@ nLinha,113+2 PSAY "%"
	@ nLinha,118+2 PSAY (_T4/_T1) *100  PICTURE "@E 999.99"
	@ nLinha,124+2 PSAY "%"
	@ nLinha,129+2 PSAY (_T5/_T1) *100  PICTURE "@E 999.99"
	@ nLinha,135+2 PSAY "%"
	@ nLinha,140+2 PSAY (_T6/_T1) *100  PICTURE "@E 999.99"
	@ nLinha,146+2 PSAY "%"
	@ nLinha,151+2 PSAY (_T7/_T1) *100  PICTURE "@E 999.99"
	@ nLinha,157+2 PSAY "%"
	@ nLinha,162+2 PSAY (_T8/_T1) *100  PICTURE "@E 999.99"
	@ nLinha,168+2 PSAY "%"

	IF _FOLHAATUAL   // SO IMPRIME O RESTANTE SE FOR MES ATUAL
		_AnoMesAnter:=""
		DBSELECTAREA("Z0C")
		DBSETORDER(2)        // DATARQ + CUSTO
		DBSEEK(xFilial("Z0C")+_AnoMes)
		IF FOUND()
			DBSKIP(-1)
			IF !BOF()
				_AnoMesAnter:=Z0C_DATAR
			ENDIF
		ENDIF
		IF !EMPTY(_AnoMesAnter)
			_ANTER00:=_ANTER01:=_ANTER02:=_ANTER03:=_ANTER04:=_ANTER05:=_ANTER06:=_ANTER07:=_ANTER08:=_ANTER09:=_ANTER10:=_ANTER11:=_ANTER12:=0
			DBSEEK(xFilial("Z0C")+_AnoMesAnter)
			WHILE !EOF() .AND. Z0C_DATAR=_AnoMesAnter
				_ANTER00+=Z0C_VALO10   // NUM FUNC
				_ANTER01+=Z0C_VALO07   // SALARIO BASE
				_ANTER02+=Z0C_VALO08   // INSS
				_ANTER03+=Z0C_VALO09   // FGTS

				_ANTER05+=Z0C_PROVEN
				_ANTER06+=Z0C_DESCON
				_ANTER07+=Z0C_LIQUID
				_ANTER12+=Z0C_FALTAS

				DBSKIP()
			ENDDO


			nLinha:=nLinha+1
			@ nLinha,007 Psay "* TOTAL MES ANTERIOR  -> " + STRZERO(_ANTER00,3)
			@ nLinha,036 PSAY _ANTER01  PICTURE "@EZ 9,999,999.99"
			@ nLinha,049 PSAY _ANTER02  PICTURE "@EZ 999,999.99"
			@ nLinha,060 PSAY _ANTER03  PICTURE "@EZ 999,999.99"
			//		@ nLinha,071 PSAY _ANTER04  PICTURE "@EZ 999,999.99"     // SEGURO DE VIDA
			@ nLinha,083 PSAY _ANTER05  PICTURE "@EZ 9,999,999.99"
			@ nLinha,096 PSAY _ANTER06  PICTURE "@EZ 999,999.99"
			@ nLinha,107 PSAY _ANTER07  PICTURE "@EZ 999,999.99"
			//		@ nLinha,118 PSAY _ANTER08  PICTURE "@EZ 999,999.99"
			//		@ nLinha,129 PSAY _ANTER08  PICTURE "@EZ 999,999.99"
			//		@ nLinha,140 PSAY _ANTER10  PICTURE "@EZ 999,999.99"
			//		@ nLinha,151 PSAY _ANTER11  PICTURE "@EZ 999,999.99"
			@ nLinha,162 PSAY _ANTER12  PICTURE "@EZ 999,999.99"
		ENDIF
		nLinha:=nLinha+1
		@ nLinha,031 PSAY REPLICATE("-",131)
		nLinha++

		//*******************************************************************************************
		@ nLinha,007 Psay "* BASE SEGURO DE VIDA ... R$"
		@ nLinha,036 PSAY _BASESEGVIDA  PICTURE "@EZ 9,999,999.99"
		nLinha++
		@ nLinha,007 Psay "* BASE PRO-LABORE     ... R$"
		@ nLinha,036 PSAY _PROLAB  PICTURE "@EZ 9,999,999.99"
		nLinha++
		_BASEREAL:=(_BASESEGVIDA + _PROLAB)*0.30
		@ nLinha,007 Psay "* TOTAL BASE SEG VIDA ... R$"
		@ nLinha,036 PSAY (_BASESEGVIDA + _PROLAB)  PICTURE "@EZ 9,999,999.99"

		_VALUNIT     := ROUND(_BaseReal * _FATOR,2)
		_2VALUNIT    := _VALUNIT / _QTDFUNC

		@ nLinha,049 PSAY "x"
		@ nLinha,051 PSAY _FATOR*10     PICTURE "@EZ 9.99999"
		@ nLinha,058 PSAY "/"
		@ nLinha,059 PSAY _QTDFUNC      PICTURE "@EZ 9999"
		@ nLinha,065 PSAY "="
		@ nLinha,071 PSAY _2ValUnit      PICTURE "@EZ 999,999.99"
		nLinha:=nLinha+1
		@ nLinha,007 Psay "* VALOR A SER RECOLHIDO...R$"
		@ nLinha,036 PSAY _ValUnit      PICTURE "@EZ 9,999,999.99"

		nLinha:=nLinha+1
		@ nLinha,000 PSAY __PrtThinLine()
		nLinha:=nLinha+1

		//******************************************************************************************* LOOP NA OUTRA EMPRESA
		// Estrutura do Arquivo Temporario

		aStru := {}
		aadd(aStru , {'TMP_CCU' ,'C', 09,0} )
		aadd(aStru , {'TMP_DES' ,'C', 40,0} )
		aadd(aStru , {'TMP_SAL' ,'N', 14,2} )
		aadd(aStru , {'TMP_NFU' ,'N', 06,0} )
		aadd(aStru , {'TMP_SEG' ,'N', 14,2} )

		//cArqTemp := CriaTrab(aStru , .t.)

		//dbUseArea(.T.,,cArqTemp,'TMP',.f.)

		//INDEX ON TMP_CCU  TO &cArqTemp

		oGetTab := FWTemporaryTable():New("TMP",)
		oGetTab:SetFields(aStru)
		oGetTab:AddIndex("01", {"TMP_CCU"} )
		oGetTab:Create()

		DBSELECTAREA("TMP")

		//************************************************************
		wT2_EXPA:=wT2_MENS:=wT2_EST:=wT2_COOR:=0
		wT2_MASC:=wT2_FEM:=0
		_TSVG:=0


		dbSelectArea('TMP')
		DBGOTOP()
		WHILE !EOF()

			@ nLinha,000 Psay LEFT((ALLTRIM(TMP_CCU)+"-"+TMP_DES),30)
			@ nLinha,032 PSAY STRZERO(TMP_NFU,3)
			@ nLinha,036 PSAY TMP_SAL          PICTURE "@EZ 9,999,999.99"
			@ nLinha,049 PSAY TMP_SAL*0.288    PICTURE "@EZ 999,999.99"
			@ nLinha,060 PSAY TMP_SAL*0.085    PICTURE "@EZ 999,999.99"
			@ nLinha,071 PSAY TMP_SEG          PICTURE "@EZ 999,999.99"
			nLinha:=nLinha+1
			_TSVG:=_TSVG + TMP_SEG
			IF NLINHA>55
				cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
				nLinha := 6
			ENDIF
			dbSelectArea('TMP')
			DBSKIP()
		ENDDO


		dbSelectArea('TMP')
		dbCloseArea()
		cArqTempX := cArqTemp + '.DTC'
		Delete File &cArqTempX
		cArqTempX := cArqTemp + '.CDX'
		Delete File &cArqTempX

		//********************************************************************************

		DBSELECTAREA("SRA")
		nLinha:=nLinha+1
		IF NLINHA>50
			cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
			nLinha := 6
		ENDIF

		//*******************************************************************************************
		@ nLinha,008 Psay "01 --> RESUMO POR CATEGORIA :    AMC"
		nLinha:=nLinha+1
		@ nLinha,008 PSAY "    MENSALISTAS              -> "     + STRZERO(wT_MENS-_DETERM,3)
		nLinha:=nLinha+1
		if _DETERM>0
			@ nLinha,008 PSAY "    PRZ DETERMINADO/APRENDIZ -> " + STRZERO(_DETERM,3)
			nLinha:=nLinha+1
		endif

		if wT_EXPA>0
			@ nLinha,008 PSAY "    SEMANALISTAS             -> " + STRZERO(wT_EXPA,3)
			nLinha:=nLinha+1
		endif
		if wT_COOR>0
			@ nLinha,008 PSAY "    PRO-LABORE               -> " + STRZERO(wT_COOR,3)
			nLinha:=nLinha+1
		ENDIF
		if wT_EST>0
			@ nLinha,008 PSAY "    ESTAGIARIOS              -> " + STRZERO(wT_EST,3)
			nLinha:=nLinha+1
		endif

		IF _TTPCD>0
			@ nLinha,008 PSAY "    *PCD                     -> " + STRZERO(_TTPCD,3)+"   Matr: "+_Prod2
			nLinha:=nLinha+1
		endif


		_nFUNCIONARIOS:=wT_MENS+wT2_MENS + wT_COOR+wT2_COOR + wT_EST+wT2_EST

		@ nLinha,000 PSAY __PrtThinLine()
		nLinha:=nLinha+1
		IF NLINHA>55
			cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
			nLinha := 6
		ENDIF

		//*******************************************************************************************
		@ nLinha,008 Psay "02 --> RESUMO POR SEXO:         AMC"
		@ nLINHA,71 PSAY "Percentual"

		nLinha:=nLinha+1
		@ nLinha,008 PSAY "    EMPREG.SEXO MASCULINO    -> " + STRZERO(wT_MASC,3) + SPACE(08) + STRZERO(wT2_MASC,3)+ SPACE(08) + STRZERO(wT_MASC+wT2_MASC,3)
		_xPER :=((wT_MASC+wT2_MASC) / _nFUNCIONARIOS) *100
		@ nLINHA,71 PSAY _xPER PICTURE "@E 999.99"
		@ nLinha,78 PSAY "%"

		nLinha:=nLinha+1
		@ nLinha,008 PSAY "    EMPREG.SEXO FEMININO     -> " + STRZERO(wT_FEM,3)  + SPACE(08) + STRZERO(wT2_FEM ,3)+ SPACE(08) + STRZERO(wT_FEM+wT2_FEM,3)
		_xPER :=((wT_FEM+wT2_FEM) / _nFUNCIONARIOS) *100
		@ nLINHA,71 PSAY _xPER PICTURE "@E 999.99"
		@ nLinha,78 PSAY "%"

		nLinha:=nLinha+1
		@ nLinha,000 PSAY __PrtThinLine()
		nLinha:=nLinha+1
		IF NLINHA>45
			cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
			nLinha := 6
		ENDIF

		//*******************************************************************************************
		_03TOT:=0
		@ nLinha,008 Psay "03 --> FAIXA ETARIA E SEXO: "
		@ nLinha,040 PSAY "-MASCULINO-  -FEMININO--"
		nLinha:=nLinha+1
		@ nLinha,040 PSAY "QTD    %      QTD   %"
		@ nLinha,070 PSAY "T O T A I S"
		nLinha:=nLinha+1
		@ nLinha,040 PSAY "-----------  -----------"
		nLinha:=nLinha+1
		@ nLinha,008 PSAY "    ATE  30 ANOS             -> " + STRZERO(_Id18M,3) + SPACE(2) + Str((_Id18M/_nFUNCIONARIOS)*100,5,2) + "%"
		@ nLinha,054 PSAY STRZERO(_Id18F,3) + SPACE(1) + Str((_Id18F/_nFUNCIONARIOS)*100,5,2)  + "%"
		@ nLinha,071 PSAY STRZERO((_Id18F+_Id18M),3) + SPACE(1) + Str(((_Id18F+_Id18M)/_nFUNCIONARIOS)*100,5,2)  + "%"
		_03TOT:=_03TOT + (_Id18F+_Id18M)

		nLinha:=nLinha+1
		@ nLinha,008 PSAY "    31 A 50 ANOS             -> " + STRZERO(_Id23M,3) + SPACE(2) + Str((_Id23M/_nFUNCIONARIOS)*100,5,2) + "%"
		@ nLinha,054 PSAY STRZERO(_Id23F,3) + SPACE(1) + Str((_Id23F/_nFUNCIONARIOS)*100,5,2)  + "%"
		@ nLinha,071 PSAY STRZERO((_Id23F+_Id23M),3) + SPACE(1) + Str(((_Id23F+_Id23M)/_nFUNCIONARIOS)*100,5,2)  + "%"
		_03TOT:=_03TOT + (_Id23F+_Id23M)

		nLinha:=nLinha+1
		@ nLinha,008 PSAY "    ACIM 50 ANOS             -> " + STRZERO(_Id28M,3) + SPACE(2) + Str((_Id28M/_nFUNCIONARIOS)*100,5,2) + "%"
		@ nLinha,054 PSAY STRZERO(_Id28F,3) + SPACE(1) + Str((_Id28F/_nFUNCIONARIOS)*100,5,2)  + "%"
		@ nLinha,071 PSAY STRZERO((_Id28F+_Id28M),3) + SPACE(1) + Str(((_Id28F+_Id28M)/_nFUNCIONARIOS)*100,5,2)  + "%"
		_03TOT:=_03TOT + (_Id28F+_Id28M)


		nLinha:=nLinha+1
		@ nLinha,008 PSAY ". T O T A L   G E R A L "

		@ nLinha,039 PSAY STR(WT_MASC+WT2_MASC,4)
		@ nLinha,054 PSAY STR(WT_FEM+WT2_FEM,3)
		@ nLinha,070 PSAY STR(_03TOT,4)

		nLinha:=nLinha+1
		@ nLinha,000 PSAY __PrtThinLine()
		nLinha:=nLinha+1

		//*******************************************************************************************
		IF NLINHA>50
			cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
			nLinha := 6
		ENDIF
		@ nLinha,008 Psay "04 --> NIVEIS DE ESCOLARIDADE: "
		nLinha:=nLinha+1
		@ nLinha,038 Psay "Qtd"
		@ nLinha,042 Psay "Percent"
		@ nLinha,052 Psay "*--Homem--*  *--Mulher--*"

		nLinha:=nLinha+1
		_04TOT:=0
		_A:=_B:=0
		FOR I:=1 TO _nREG
			IF _QTFUN[I] > 0
				@ nLinha,001 PSAY LEFT(ALLTRIM(_CHAVE[I])+" "+ALLTRIM(_DESCR[I]),35)
				@ nLinha,037 PSAY _QTFUN[I] PICTURE "9999"

				_xPER :=(_QTFUN[I] / _nFUNCIONARIOS) *100
				@ nLINHA,42 PSAY _xPER PICTURE "@E 999.99"
				@ nLinha,49 PSAY "%"

				@ nLinha,051 PSAY _HOMEM[I] PICTURE "9999"
				_xPER :=(_HOMEM[I] / _QTFUN[I]) *100
				@ nLINHA,56 PSAY _xPER PICTURE "@E 999.99"
				@ nLinha,63 PSAY "%"

				@ nLinha,065 PSAY _MULHE[I] PICTURE "9999"
				_xPER :=(_MULHE[I] / _QTFUN[I]) *100
				@ nLINHA,70 PSAY _xPER PICTURE "@E 999.99"
				@ nLinha,77 PSAY "%"

				_A:=_A + _HOMEM[I]
				_B:=_B + _MULHE[I]
				_04TOT:=_04TOT + _QTFUN[I]
				nLinha:=nLinha+1
				IF NLINHA>50
					cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
					nLinha := 6
				ENDIF
			ENDIF
		NEXT I
		@ nLinha,001 PSAY ". TOTAL GERAL ...."
		@ nLinha,037 PSAY STRZERO(_04TOT,4)
		@ nLinha,051 PSAY _A PICTURE "9999"
		@ nLinha,065 PSAY _B PICTURE "9999"

		nLinha:=nLinha+1
		@ nLinha,000 PSAY __PrtThinLine()
		nLinha:=nLinha+1

		//*******************************************************************************************
		IF NLINHA>50
			cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
			nLinha := 6
		ENDIF
		@ nLinha,008 Psay "05 --> RESUMO FAIXA SALARIAL:"
		@ nLinha,041 Psay "Percent"
		@ nLinha,050 Psay "*--Homens--*"
		@ nLinha,063 Psay "*-Mulheres-*"

		nLinha:=nLinha+1
		@ nLinha,008 PSAY "--> ATÉ 500           ->"
		@ nLinha,035 PSAY _FX1 PICTURE "9999"
		@ nLinha,041 PSAY Str((_FX1/wT_MENS)*100,5,2)  + "%"
		@ nLinha,049 PSAY _FX1H PICTURE "9999"
		@ nLinha,055 PSAY Str((_FX1H/_FX1)*100,6,2)  + "%"
		@ nLinha,062 PSAY _FX1M PICTURE "9999"
		@ nLinha,068 PSAY Str((_FX1M/_FX1)*100,6,2)  + "%"

		nLinha:=nLinha+1
		@ nLinha,008 PSAY "--> DE  500 ATE  750  ->"
		@ nLinha,035 PSAY _FX2 PICTURE "9999"
		@ nLinha,041 PSAY Str((_FX2/wT_MENS)*100,5,2)  + "%"
		@ nLinha,049 PSAY _FX2H PICTURE "9999"
		@ nLinha,055 PSAY Str((_FX2H/_FX2)*100,6,2)  + "%"
		@ nLinha,062 PSAY _FX2M PICTURE "9999"
		@ nLinha,068 PSAY Str((_FX2M/_FX2)*100,6,2)  + "%"

		nLinha:=nLinha+1
		@ nLinha,008 PSAY "--> DE  750 ATE 1000  ->"
		@ nLinha,035 PSAY _FX3 PICTURE "9999"
		@ nLinha,041 PSAY Str((_FX3/wT_MENS)*100,5,2)  + "%"
		@ nLinha,049 PSAY _FX3H PICTURE "9999"
		@ nLinha,055 PSAY Str((_FX3H/_FX3)*100,6,2)  + "%"
		@ nLinha,062 PSAY _FX3M PICTURE "9999"
		@ nLinha,068 PSAY Str((_FX3M/_FX3)*100,6,2)  + "%"

		nLinha:=nLinha+1
		@ nLinha,008 PSAY "--> DE 1000 ATE 2000  ->"
		@ nLinha,035 PSAY _FX4 PICTURE "9999"
		@ nLinha,041 PSAY Str((_FX4/wT_MENS)*100,5,2)  + "%"
		@ nLinha,049 PSAY _FX4H PICTURE "9999"
		@ nLinha,055 PSAY Str((_FX4H/_FX4)*100,6,2)  + "%"
		@ nLinha,062 PSAY _FX4M PICTURE "9999"
		@ nLinha,068 PSAY Str((_FX4M/_FX4)*100,6,2)  + "%"

		nLinha:=nLinha+1
		@ nLinha,008 PSAY "--> DE 2000 ATE 3000  ->"
		@ nLinha,035 PSAY _FX5 PICTURE "9999"
		@ nLinha,041 PSAY Str((_FX5/wT_MENS)*100,5,2)  + "%"
		@ nLinha,049 PSAY _FX5H PICTURE "9999"
		@ nLinha,055 PSAY Str((_FX5H/_FX5)*100,6,2)  + "%"
		@ nLinha,062 PSAY _FX5M PICTURE "9999"
		@ nLinha,068 PSAY Str((_FX5M/_FX5)*100,6,2)  + "%"

		nLinha:=nLinha+1
		@ nLinha,008 PSAY "--> DE 3000 ATE 4000  ->"
		@ nLinha,035 PSAY _FX6 PICTURE "9999"
		@ nLinha,041 PSAY Str((_FX6/wT_MENS)*100,5,2)  + "%"
		@ nLinha,049 PSAY _FX6H PICTURE "9999"
		@ nLinha,055 PSAY Str((_FX6H/_FX6)*100,6,2)  + "%"
		@ nLinha,062 PSAY _FX6M PICTURE "9999"
		@ nLinha,068 PSAY Str((_FX6M/_FX6)*100,6,2)  + "%"

		nLinha:=nLinha+1
		@ nLinha,008 PSAY "--> DE 4000 ATE 5000  ->"
		@ nLinha,035 PSAY _FX7 PICTURE "9999"
		@ nLinha,041 PSAY Str((_FX7/wT_MENS)*100,5,2)  + "%"
		@ nLinha,049 PSAY _FX7H PICTURE "9999"
		@ nLinha,055 PSAY Str((_FX7H/_FX7)*100,6,2)  + "%"
		@ nLinha,062 PSAY _FX7M PICTURE "9999"
		@ nLinha,068 PSAY Str((_FX7M/_FX7)*100,6,2)  + "%"

		nLinha:=nLinha+1
		@ nLinha,008 PSAY "--> ACIMA DE 5000     ->"
		@ nLinha,035 PSAY _FX8 PICTURE "9999"
		@ nLinha,041 PSAY Str((_FX8/wT_MENS)*100,5,2)  + "%"
		@ nLinha,049 PSAY _FX8H PICTURE "9999"
		@ nLinha,055 PSAY Str((_FX8H/_FX8)*100,6,2)  + "%"
		@ nLinha,062 PSAY _FX8M PICTURE "9999"
		@ nLinha,068 PSAY Str((_FX8M/_FX8)*100,6,2)  + "%"

		nLinha:=nLinha+1
		@ nLinha,035 PSAY "----"
		@ nLinha,041 PSAY "------"
		@ nLinha,049 PSAY "----"
		@ nLinha,062 PSAY "----"

		nLinha:=nLinha+1
		@ nLinha,008 PSAY "    Total METAIS"
		@ nLinha,035 PSAY (_FX1+_FX2+_FX3+_FX4+_FX5+_FX6+_FX7+_FX8) PICTURE "9999"
		@ nLinha,041 PSAY Str(100,6,2)  + "%"
		@ nLinha,049 PSAY (_FX1H+_FX2H+_FX3H+_FX4H+_FX5H+_FX6H+_FX7H+_FX8H) PICTURE "9999"
		@ nLinha,062 PSAY (_FX1M+_FX2M+_FX3M+_FX4M+_FX5M+_FX6M+_FX7M+_FX8M) PICTURE "9999"


		nLinha:=nLinha+1
		@ nLinha,000 PSAY __PrtThinLine()
		nLinha:=nLinha+1

		//********************************************************************************************** cargos
		IF NLINHA>50
			cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
			nLinha := 6
		ENDIF
		@ nLinha,008 Psay "06 --> CARGOS OCUPADOS:"
		nLinha++

		_nTOTSALARIO:=0
		FOR I:=1 TO _n2REG
			IF _2QTFUN[I] > 0
				_nTOTSALARIO := _nTOTSALARIO + _2SALAR[I]
			ENDIF
		NEXT I

		@ nLinha,022 Psay "Qtd  Percent"
		@ nLinha,037 Psay "*--Homem--*  *--Mulher--*    Salario  Perc"

		nLinha:=nLinha+1
		_06TOT:=0
		_A:=_B:=0
		FOR I:=1 TO _n2REG
			IF _2QTFUN[I] > 0
				@ nLinha,001 PSAY LEFT(_2CHAVE[I],2)
				@ nLinha,004 PSAY LEFT(_2DESCR[I],15)
				@ nLinha,021 PSAY _2QTFUN[I] PICTURE "9999"
				_xPER :=(_2QTFUN[I] / _nFUNCIONARIOS) *100
				@ nLINHA,26 PSAY _xPER PICTURE "@E 999.99"
				@ nLinha,33 PSAY "%"

				@ nLinha,035 PSAY _2HOMEM[I] PICTURE "9999"
				_xPER :=(_2HOMEM[I] / _2QTFUN[I]) *100
				@ nLINHA,40 PSAY _xPER PICTURE "@E 999.99"
				@ nLinha,47 PSAY "%"

				@ nLinha,049 PSAY _2MULHE[I] PICTURE "9999"
				_xPER :=(_2MULHE[I] / _2QTFUN[I]) *100
				@ nLINHA,54 PSAY _xPER PICTURE "@E 999.99"
				@ nLinha,61 PSAY "%"

				@ nLinha,063 PSAY _2SALAR[I] PICTURE "@E 999,999.99"
				@ nLinha,074 PSAY (_2SALAR[I]/_nTOTSALARIO)*100 PICTURE "@E 999.99"
				@ nLinha,80 PSAY "%"

				_A:=_A + _2HOMEM[I]
				_B:=_B + _2MULHE[I]

				_06TOT:=_06TOT + _2QTFUN[I]
				nLinha:=nLinha+1
				IF NLINHA>55
					cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
					nLinha := 6
				ENDIF
			ENDIF
		NEXT I
		@ nLinha,001 PSAY ". TOTAL GERAL ...."
		@ nLinha,021 PSAY STRZERO(_06TOT,4)
		@ nLinha,035 PSAY _A PICTURE "9999"
		@ nLinha,049 PSAY _B PICTURE "9999"
		@ nLinha,063 PSAY _nTotSalario PICTURE "@E 999,999.99"

		nLinha:=nLinha+1
		@ nLinha,000 PSAY __PrtThinLine()
		nLinha:=nLinha+1




		//********************************************************************************************** NATURALIDADE
		IF NLINHA>50
			cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
			nLinha := 6
		ENDIF
		@ nLinha,008 Psay "07 --> QUADRO POR REGIAO (NATURALIDADE):"
		nLinha++

		@ nLinha,001 Psay "UF Descricao"
		@ nLinha,020 Psay "Total"
		@ nLinha,035 Psay "AMC"

		nLinha++
		_A:=_B:=_C:=0
		FOR I:=1 TO _n12REG
			IF _12MET[I]+_12CAB[I] > 0
				@ nLinha,001 PSAY LEFT(_12CHA[I],2)
				@ nLinha,004 PSAY LEFT(_12DES[I],15)

				@ nLinha,021 PSAY (_12MET[I]+_12CAB[I]) PICTURE "9999"

				@ nLinha,035 PSAY _12MET[I] PICTURE "9999"

				nLinha++
				_A:=_A + (_12MET[I]+_12CAB[I])
				_B:=_B + _12MET[I]
			ENDIF
		NEXT I
		@ nLinha,004 PSAY "Total Geral"

		@ nLinha,021 PSAY _A PICTURE "9999"
		@ nLinha,035 PSAY _B PICTURE "9999"

		nLinha:=nLinha+1
		@ nLinha,000 PSAY __PrtThinLine()
		nLinha:=nLinha+1

		//********************************************************************************************** ESTADO CIVIL
		IF NLINHA>50
			cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)
			nLinha := 6
		ENDIF
		@ nLinha,008 Psay "08 --> ESTADO CIVIL:"
		nLinha++

		@ nLinha,033 Psay "AMC"

		nLinha++
		_A:=_B:=_C:=0
		FOR I:=1 TO _n33REG
			IF _33QTD[I] > 0
				@ nLinha,001 PSAY LEFT(_33CHA[I],2)
				@ nLinha,004 PSAY LEFT(_33DES[I],15)

				@ nLinha,035 PSAY _33QTD[I] PICTURE "9999"

				nLinha++
				_B:=_B + _33QTD[I]
			ENDIF
		NEXT I
		@ nLinha,004 PSAY "Total Geral"

		@ nLinha,035 PSAY _B PICTURE "9999"

		nLinha:=nLinha+1
		@ nLinha,000 PSAY __PrtThinLine()
		nLinha:=nLinha+1



		_09TOT:=0
		@ nLinha,008 Psay "09 --> TEMPO NA EMPRESA : "
		@ nLinha,040 PSAY "-MASCULINO-  -FEMININO--"
		nLinha:=nLinha+1
		@ nLinha,040 PSAY "QTD    %      QTD   %"
		@ nLinha,070 PSAY "T O T A I S"
		nLinha:=nLinha+1
		@ nLinha,040 PSAY "-----------  -----------"
		nLinha:=nLinha+1
		@ nLinha,008 PSAY "    ATE  02 ANOS             -> " + STRZERO(_XId01M,3) + SPACE(2) + Str((_XId01M/_nFUNCIONARIOS)*100,5,2) + "%"
		@ nLinha,054 PSAY                                      STRZERO(_XId01F,3) + SPACE(1) + Str((_XId01F/_nFUNCIONARIOS)*100,5,2)  + "%"
		@ nLinha,071 PSAY                                      STRZERO((_XId01F+_XId01M),3) + SPACE(1) + Str(((_XId01F+_XId01M)/_nFUNCIONARIOS)*100,5,2)  + "%"
		_09TOT:=_09TOT + (_XId01F+_XId01M)

		nLinha:=nLinha+1
		@ nLinha,008 PSAY "    DE  02 A 05 ANOS         -> " + STRZERO(_XId02M,3) + SPACE(2) + Str((_XId02M/_nFUNCIONARIOS)*100,5,2) + "%"
		@ nLinha,054 PSAY                                      STRZERO(_XId02F,3) + SPACE(1) + Str((_XId02F/_nFUNCIONARIOS)*100,5,2)  + "%"
		@ nLinha,071 PSAY                                      STRZERO((_XId02F+_XId02M),3) + SPACE(1) + Str(((_XId02F+_XId02M)/_nFUNCIONARIOS)*100,5,2)  + "%"
		_09TOT:=_09TOT + (_XId02F+_XId02M)

		nLinha:=nLinha+1
		@ nLinha,008 PSAY "    DE  05 A 10 ANOS         -> " + STRZERO(_XId03M,3) + SPACE(2) + Str((_XId03M/_nFUNCIONARIOS)*100,5,2) + "%"
		@ nLinha,054 PSAY                                      STRZERO(_XId03F,3) + SPACE(1) + Str((_XId03F/_nFUNCIONARIOS)*100,5,2)  + "%"
		@ nLinha,071 PSAY                                      STRZERO((_XId03F+_XId03M),3) + SPACE(1) + Str(((_XId03F+_XId03M)/_nFUNCIONARIOS)*100,5,2)  + "%"
		_09TOT:=_09TOT + (_XId03F+_XId03M)

		nLinha:=nLinha+1
		@ nLinha,008 PSAY "    MAIS QUE 10 ANOS         -> " + STRZERO(_XId04M,3) + SPACE(2) + Str((_XId04M/_nFUNCIONARIOS)*100,5,2) + "%"
		@ nLinha,054 PSAY                                      STRZERO(_XId04F,3) + SPACE(1) + Str((_XId04F/_nFUNCIONARIOS)*100,5,2)  + "%"
		@ nLinha,071 PSAY                                      STRZERO((_XId04F+_XId04M),3) + SPACE(1) + Str(((_XId04F+_XId04M)/_nFUNCIONARIOS)*100,5,2)  + "%"
		_09TOT:=_09TOT + (_XId04F+_XId04M)

		nLinha:=nLinha+1
		@ nLinha,008 PSAY ". T O T A L   G E R A L "

		@ nLinha,039 PSAY STR(WT_MASC+WT2_MASC,4)
		@ nLinha,054 PSAY STR(WT_FEM+WT2_FEM,3)
		@ nLinha,070 PSAY STR(_09TOT,4)

		nLinha:=nLinha+1
		@ nLinha,000 PSAY __PrtThinLine()
		nLinha:=nLinha+1


	ENDIF
	DBSELECTAREA("SRA")
	dbClearFilter()

	If aReturn[5] == 1
		Set Printer To
		Commit
		ourspool(wnrel) //Chamada do Spool de Impressao
	Endif
	MS_FLUSH() //Libera fila de relatorios em spool

	If !ExistDir("C:\relato")
		nRet := MakeDir("C:\relato")
		If nRet != 0
			Alert("Você precisar criar a pasta RELATO")
		EndIf
	EndIf
	cRand   := cvaltochar(Randomize( 1, 1000 ))
	cArquivo:= "C:\relato\" + cRand + '.xml'
	cTabela:= "Folha " + _AnoMes
	IF _Xls="S" //modificação devido a infraestrutura de serviço 64. Wagno
		DbSelectArea("TRB")
		dbGoTop()
		oFWMsExcel := FWMSExcel():New()
		oFWMsExcel:AddworkSheet("RH")
		oFWMsExcel:AddTable("RH",cTabela)
		oFWMsExcel:AddColumn("RH",cTabela,"TRB_CCU",1,1)
		oFWMsExcel:AddColumn("RH",cTabela,"TRB_NOM",1,1)
		oFWMsExcel:AddColumn("RH",cTabela,"TRB_NFU",1,1)
		oFWMsExcel:AddColumn("RH",cTabela,"TRB_PRO",1,1)
		oFWMsExcel:AddColumn("RH",cTabela,"TRB_DES",1,1)
		oFWMsExcel:AddColumn("RH",cTabela,"TRB_LIQ",1,1)
		oFWMsExcel:AddColumn("RH",cTabela,"TRB_105",1,1)
		oFWMsExcel:AddColumn("RH",cTabela,"TRB_106",1,1)
		oFWMsExcel:AddColumn("RH",cTabela,"TRB_110",1,1)
		oFWMsExcel:AddColumn("RH",cTabela,"TRB_112",1,1)
		oFWMsExcel:AddColumn("RH",cTabela,"TRB_409",1,1)
		oFWMsExcel:AddColumn("RH",cTabela,"TRB_FGT",1,1)
		oFWMsExcel:AddColumn("RH",cTabela,"TRB_INS",1,1)
		oFWMsExcel:AddColumn("RH",cTabela,"TRB_SAL",1,1)
		oFWMsExcel:AddColumn("RH",cTabela,"TRB_HOR",1,1)
		oFWMsExcel:AddColumn("RH",cTabela,"TRB_PER",1,1)

		While TRB->(!EOF())
			oFWMsExcel:AddRow("RH",cTabela,{TRB->TRB_CCU,TRB->TRB_NOM,TRB->TRB_NFU,TRB->TRB_PRO,TRB->TRB_DES,TRB->TRB_LIQ,TRB->TRB_105,TRB->TRB_106,TRB->TRB_110,TRB->TRB_112,TRB->TRB_409,TRB->TRB_FGT,TRB->TRB_INS,TRB->TRB_SAL,TRB->TRB_HOR,TRB->TRB_PER})
			TRB->(dbSkip())
		EndDo
		oFWMsExcel:Activate()
		oFWMsExcel:GetXMLFile(cArquivo)

		//Abrindo o excel e abrindo o arquivo xml
		oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
		oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
		oExcel:SetVisible(.T.)                 //Visualiza a planilha
		oExcel:Destroy()

	ENDIF

	dbSelectArea('TRB')
	dbCloseArea()
	cArqTempX := cArqTemp2+ '.DTC'
	Delete File &cArqTempX
	cArqTempX := cArqTemp2+ '.CDX'
	Delete File &cArqTempX

Return




//***************************************************************************** ACUMULADOS DOS FECHAMENTOS DA FOLHA (RESUMO)
User Function CADZ0C()
	//*****************************************************************************
	_cArea := Alias()
	_nOrd  := IndexOrd()
	nReg   :=RecNo()

	DbSelectArea("Z0C")
	DbGotop()

	cCadastro:="Z0C - FECHAMENTO DA FOLHAS - RESUMO POR CENTRO DE CUSTO"

	aRotina := { { "Pesquisa",  'AxPesqui', 0, 1 },;
		{"Visualizar","AxVisual",0, 2} ,;
		{"Inclui    ","AxInclui",0, 3} ,;
		{"Altera    ","AxAltera",0, 4} ,;
		{"Exclui    ",'AxDeleta',0, 5} ,;
		{"Planilha  ",'ExecBlock("fZ0CXls")' , 0, 6 }}

	mBrowse(16,00,280,350,"Z0C",,,,,,)

	dbSelectArea(_cArea)
	DbSetOrder(_nOrd)
	DbGoTo(nReg)

return(nil)

USER FUNCTION fZ0CXls()

	DBSELECTAREA("Z0C")
	DBGOTOP()
	//	COPY TO RGPEZ0C.CSV
	cArqRen 	:= "\SYSTEM\TEMPDBF\RGPEZ0C.CSV"
	//Copy to &cArqRen VIA "DBFCDXADS"
	_arquivo:="G:\SYSTEM\TEMPDBF\RGPEZ0C.CSV"
	If !File(_arquivo)
		_arquivo:="F:\SYSTEM\TEMPDBF\RGPEZ0C.CSV"
	EndIf
	If ! ApOleClient( 'MsExcel' )
		MsgStop( 'Excel não instalado' )
	ELSE
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( _arquivo )
		oExcelApp:SetVisible(.T.)
	ENDIF

	DbSelectArea("Z0C")
	DbGotop()

RETURN


Static Function CriaPar(cPar, cTipo, cValor, aDescr)

// Cria Parâmetros no SX6     
// O conteúdo de cValor DEVE ser do tipo caracter (ex. "1234,56", ".t.", "31/03/14", "C")
		/*/

	SX6->(dbSetOrder(1))

	if !SX6->(dbSeek(xFilial("SX6") + cPar ))
		RecLock("SX6", .T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR		:= cPar
		SX6->X6_TIPO	:= cTipo
		SX6->X6_DESCRIC	:= aDescr[1]
		SX6->X6_DESC1   := aDescr[2]
		SX6->X6_DESC2   := aDescr[3]
		SX6->X6_CONTEUD := cValor
		SX6->X6_PROPRI 	:= "U"
		SX6->X6_PYME	:= "S"
		MsUnLock()
	Else
		//RecLock("SX6", .F.)
		//SX6->X6_CONTEUD	:= cValor
		//MsUnLock()
EndIf		/*/


		Return
