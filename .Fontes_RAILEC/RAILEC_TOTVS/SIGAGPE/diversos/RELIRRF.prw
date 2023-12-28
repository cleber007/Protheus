#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 15/02/01

User Function RELIRRF()        // incluido pelo assistente de conversao do AP5 IDE em 15/02/01


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RELIRRF  ³ Autor ³ JOSE NORBERTO MACEDO  ³ Data ³ 23/01/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa para Conferencia IRRF (CTAS A PAGAR)              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³TRADELINK                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Exemplo  ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

cArea := Alias()
nInd  := IndexOrd()

cString := "SE2"
cDesc1  := OemToAnsi("CONFERENCIA DO IRRF DE ACORDO COM AS BASES")
cDesc2  := OemToAnsi("LANCADAS NO CTAS A PAGAR.")
cDesc3  := ""
tamanho := "M"
aOrd    := {}
aReturn := { "Zebrado", 1,"Financeiro", 2, 2, 1, "",1 }
nomeprog:= "RELIRRF"
aLinha  := { }
nLastKey:= 0

cCancel := "***** CANCELADO PELO OPERADOR *****"
cPerg   := "RELIRR"
m_pag   := 1
wnrel   :="RELIRRF"

IF !(Pergunte(cPerg,.T.))
	RETURN Nil
ENDIF

Titulo  := "Retencao de IR Periodo de "+DTOC(MV_PAR01)+" a "+DTOC(MV_PAR02)

wnrel:= SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,tamanho)



SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

_PODEGRAVAR:="N"
_SOINSS    :="N"
_AtuSE2    :=.F.                        // DEFINE SE CODIGO DE RETENCAO SERA ATUALIZADO NO CONTAS A PAGAR TABELA SE2
IF SUBSTR(DTOS(MV_PAR02),1,6) > SUBSTR(DTOS(MV_PAR01),1,6)      // SE FOR DENTRO DO MES NAO GERA INTEGRACAO NA FOLHA
	@ 1,1 to  150,300 DIALOG oDlg2 TITLE "GERA DIRF ?????"
	@ 10, 22 SAY "Gera Dirf ?"
	@ 10, 55 GET _PODEGRAVAR  PICTURE "!"
	@ 22, 22 SAY "Só INSS ?"
	@ 22, 55 GET _SOINSS      PICTURE "!"
ELSE
	@ 1,1 to  150,300 DIALOG oDlg2 TITLE "FILTRA INSS??"
	@ 15, 22 SAY "Só INSS ?"
	@ 15, 55 GET _SOINSS      PICTURE "!"
ENDIF
@ 60, 95 BmpButton Type 1 Action Close(oDlg2)
Activate Dialog oDlg2 Centered

DBSELECTAREA("SRA")
DBSETORDER(1)
DBGOTOP()

DBSELECTAREA("SRL")
DBSETORDER(1)
_cFil:=XFILIAL("SRA")

DBSELECTAREA("SR4")
DBSETORDER(1)
DBGOTOP()
_TT:=0
IF _PODEGRAVAR="S"
    DBSEEK(_cFil)
	WHILE !EOF() .AND. R4_FILIAL=_cFil
		IF SR4->R4_MAT="900000"
			RECLOCK("SR4",.F.)            // ZERA OS VALORES PARA SEREM REGERADOS
			SR4->R4_VALOR:=0
			MSUNLOCK()
            _TT++
		ENDIF
		SR4->(DBSKIP())
	ENDDO
ENDIF
ALERT(STR(_TT,8,0)+" registros zerados pra rebeber a integracao.")

DBSELECTAREA("SA2")
DBSETORDER(1)           // FORNECEDOR


RptStatus({|| RptDetail() })

DBSELECTAREA("SE2")
SET FILTER TO
dbSelectArea( cArea )

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

cabec1 :=" Fornec NomeFor                         ValorTitul       IRRF DTEmissao  DtBaixa    Historico                       INSS      ISS"
IF MV_PAR05=1 .OR. MV_PAR05=4
	cabec2 :=SPACE(102)+"       PIS  + COFINS   +  CSLL =    Total"
ELSE
	CABEC2 :=IIF(MV_PAR05=2,"* Filtro Codigo 0588","* Filtro Codigo 1708")
ENDIF
//        0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//                                                                              7         8         9         0         1         2         3
nLin   :=60

AA:=0
BB:=0
CC:=DD:=EE:=0
_X1:=_X2:=0
AAA:=0
BBB:=0
CCC:=DDD:=EEE:=0
_XX1:=_XX2:=0
_FORNECE:=SPACE(6)

_TT0588:=_TT1708:=_TT5952:=0   // TOTAIS POR CODIGO DE RETENCAO

DBSELECTAREA("SE2")
DBSETORDER(6)
SetRegua(LastRec())       //Ajusta numero de elementos da regua de relatorios

DBSEEK(xFilial("SE2")+MV_PAR03,.T.)
WHILE !EOF() .AND. E2_FORNECE<=MV_PAR04
	
	INCREGUA()
	IF !(E2_EMISSAO>=MV_PAR01 .AND. E2_EMISSAO<=MV_PAR02)
		SE2->(DBSKIP())
		Loop
	ENDIF
	
	DBSELECTAREA("SA2")                            // POSICIONA NO FORNECEDOR
	DBSEEK(xFilial("SA2")+SE2->E2_FORNECE)
	IF FOUND()
		_CGC  :=A2_CGC
		_CONTA:=A2_CONTA
		_TIPO :=IIF(A2_TIPO="F","1","2")
	ELSE
		_CGC:="nao cadastrado"
		_CONTA:=" "
		_TIPO :=" "
	ENDIF
	
	
	DBSELECTAREA("SE2")
	IF E2_IRRF>0 .AND. !EMPTY(E2_BAIXA) .AND. _SOINSS="N"
		// SEGUE O ENTERRO - REGISTRO COM RETENCAO DE I.R.
	ELSEIF E2_IRRF=0 .AND. (E2_PIS+E2_COFINS+E2_CSLL) >0 .AND. !EMPTY(E2_BAIXA) .AND. _SOINSS="N"
		// SEGUE O ENTERRO - REGISTRO COM RETENCAO DE PCC MESMO COM IR ZERADO
	ELSEIF E2_IRRF=0 .AND. !EMPTY(E2_BAIXA) .AND. _TIPO="1" .AND. LEFT(E2_ORIGEM,4)#"FINA" .AND. _SOINSS="N"
		// PESSOA FISICA GERA MESMO SEM TER RETENCAO DO I.R. , SE FOR LANÇADO PELO ESTOQUE/COMPRAS
	ELSEIF !EMPTY(E2_BAIXA) .AND. E2_INSS>0 .AND. _SOINSS="S"
		// SOMENTE INSS .. INDEPENDE SE TEM OU NAO IRRF
	ELSE
		SE2->(DBSKIP())
		Loop
	ENDIF
	
	IF (MV_PAR05=2 .AND. _Tipo#"1") .OR. (MV_PAR05=3 .AND. _Tipo#"2")
		SE2->(DBSKIP())
		Loop
	ENDIF
	
	IF nLin>55
		ImpCabec()
	ENDIF
	IF (E2_FORNECE<>_FORNECE .AND. AA>0) .OR. EOF()
		IF _SOINSS="N"
			@ nLin,008 PSAY REPLICATE("-",124)
			nLin++
			@ nLin,008 PSAY ".SubTotal .........."
			@ nLin,037 PSAY AA PICTURE "@E 99,999,999.99"
			@ nLin,051 PSAY BB  PICTURE "@E 999,999.99"
			@ nLin,113 PSAY _X1 PICTURE "@EZ 99,999.99"
			@ nLin,123 PSAY _X2  PICTURE "@EZ 99,999.99"
			IF MV_PAR05=1 .OR. MV_PAR05=4
				IF _SOINSS="N"
					nLin++
					@ nLin,103 PSAY CC   PICTURE "@E 99,999.99"
					@ nLin,113 PSAY DD   PICTURE "@E 99,999.99"
					@ nLin,123 PSAY EE     PICTURE "@E 99,999.99"
					CCC:=CCC+CC
					DDD:=DDD+DD
					EEE:=EEE+EE
				ENDIF
			ENDIF
			nLin:=nLin+2
		ENDIF
		AAA:=AAA+AA
		BBB:=BBB+BB
		_XX1:=_XX1 + _X1
		_XX2:=_XX2 + _X2
		AA:=0
		BB:=0
		CC:=DD:=EE:=0
		_X1:=_X2:=0
	ENDIF
	
	@ nLin,001 PSAY E2_FORNECE
	@ nLin,008 PSAY LEFT(E2_NOMFOR,30)
	@ nLin,040 PSAY (E2_VALOR+E2_IRRF+E2_ISS+E2_INSS + E2_PIS+E2_COFINS+E2_CSLL) PICTURE "@E 999,999.99"
	@ nLin,051 PSAY E2_IRRF  PICTURE "@E 999,999.99"
	@ nLin,062 PSAY E2_EMISSAO
	@ nLin,073 PSAY E2_BAIXA
	@ nLin,084 PSAY LEFT(E2_HIST,28)
	@ nLin,113 PSAY E2_INSS PICTURE "@EZ 99,999.99"
	@ nLin,123 PSAY E2_ISS  PICTURE "@EZ 99,999.99"
	nLin++
	
	_RegSE2 := RECNO()
	AA:=AA+(E2_VALOR+E2_IRRF+E2_ISS+E2_INSS+E2_PIS+E2_COFINS+E2_CSLL)
	BB:=BB+E2_IRRF
	_X1:=_X1 + E2_INSS
	_X2:=_X2 + E2_ISS
	
	IF _SOINSS="N"
		@ nLin,004 PSAY "("+SA2->A2_TIPO+")"
		@ nLin,008 PSAY "Insc: "+Transform(_CGC,"@R 99.999.999/9999-99")
		@ nLin,084 PSAY "NF: "+SE2->E2_PREFIXO+"-"+SE2->E2_NUM //+ "/" + se2->e2_parcir+se2->e2_parccof+se2->e2_parcpis+se2->e2_parcsll
		IF MV_PAR05=1 .OR. MV_PAR05=4
			@ nLin,103 PSAY E2_PIS      PICTURE "@E 99,999.99"
			@ nLin,113 PSAY E2_COFINS   PICTURE "@E 99,999.99"
			@ nLin,123 PSAY E2_CSLL     PICTURE "@E 99,999.99"
			@ nLin,133 PSAY "="
			@ nLin,135 PSAY E2_PIS+E2_COFINS+E2_CSLL   PICTURE "@E 99,999.99"
			CC:=CC+E2_PIS
			DD:=DD+E2_COFINS
			EE:=EE+E2_CSLL
		ENDIF
		
		IF _TIPO="1"       // PESSOA FISICA
			_TT0588 := _TT0588 + E2_IRRF
			_CODRETIR:=IIF(EMPTY(SE2->E2_CODRET),"0588",SE2->E2_CODRET)
			IF SE2->E2_FORNECE$"442249/450268/434220"    // PRO-LABORES DA FOLHA - DIRETORIA
				_CODRETIR:="0561"
			ENDIF
		ELSEIF _TIPO="2" //  PESSOA JURIDICA
			_TT1708 := _TT1708 + E2_IRRF
			//_CODRETIR:="1708"
			_CODRETIR:=IIF(EMPTY(SE2->E2_CODRET),"1708",SE2->E2_CODRET)
		ENDIF
		IF MV_PAR05=1 .OR. MV_PAR05=4
			_TT5952 := _TT5952 + (E2_PIS+E2_COFINS+E2_CSLL)
		ENDIF
		
		nLin++
		
		_FORNECE:=E2_FORNECE
		_TITPAI :=E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA            // TITULO PAI A SER LINKADO AOS IMPOSTOS (TX)
		
		
		//******************************************************************** POSICIONA TITULOS DOS ENCARGOS
		cparcir := se2->e2_parcir
		cparccof:= se2->e2_parccof
		cparcpis:= se2->e2_parcpis
		cparcsll:= se2->e2_parcsll
		cparcins:= se2->e2_parcins
		
		_RegSE2 := RECNO()
		cPrefix := SE2->E2_PREFIXO
		cNumero := SE2->E2_NUM
		
		_CODRETINS:=SPACE(4)
		_CODRETCOF:="5952"
		_CODRETPIS:="5952"
		_CODRETCSL:="5952"
		_CODRET2  :="5952"  // COF/PIS/CSL Juntos
		_xDesc    :="sem retencao..."
		
		
		DBSELECTAREA("SE2")
		DBSETORDER(1)
		dbseek(xFilial("SE2")+cPrefix+cNumero+cPARCIR+"TX")    // IRRF
		IF FOUND()
			_xDESC:="CodRet: IR-"+_CODRETIR
		ENDIF
		
		IF MV_PAR05=1 .OR. MV_PAR05=4
			dbseek(xFilial("SE2")+cPrefix+cNumero+cPARCCOF+"TX")  // COFINS
			IF FOUND()
				_xDESC:=_xDESC + " * Cofins-"+_CODRETCOF
			ENDIF
			
			dbseek(xFilial("SE2")+cPrefix+cNumero+cPARCPIS+"TX")  // PIS
			IF FOUND()
				_xDESC:=_xDESC +" * Pis-"+_CODRETPIS
			ENDIF
			
			dbseek(xFilial("SE2")+cPrefix+cNumero+cPARCSLL+"TX")  // CSLL
			IF FOUND()
				_xDESC:=_xDESC +" * Csll-"+_CODRETCSL
			ENDIF
			@ nLin,008 PSAY _xDesc
			nLin++
		ENDIF
	ENDIF
	
	//***************************************************************************************************

	DBSELECTAREA("SE2")                                   // GRAVAÇAO NA TABELA SRF - FOLHA DE PAGAMENTO
	DBSETORDER(6)
	DBGOTO(_RegSE2)          // posiciona de volta no tutulo

    IF _TIPO="1" .AND. SM0->M0_CODIGO="03" .AND. SE2->E2_FORNECE$"834709/837454/967592/231536/275372/431534/327572/053391/191587/422504"
       _CODRETIR:="3208"     // FORNECEDORES DE ALUGUEL EMPRESA ENERGIA    
    ENDIF
    IF _TIPO="1" .AND. SM0->M0_CODIGO="03" .AND. SE2->E2_FORNECE$"048873/436591/812553/923487/950525/980482/220087/854515/654568/168536/830853/955587/204500/832300"
       _CODRETIR:="3208"     // FORNECEDORES DE ALUGUEL EMPRESA ENERGIA
 	ENDIF


	IF _PODEGRAVAR="S" .AND. _TIPO$"12" .AND. !EMPTY(_CGC)
		DBSELECTAREA("SRL")
		DBSEEK(xFilial("SRL")+"900000"+_TIPO+_CGC+_CODRETIR)
		IF !FOUND()
			RECLOCK("SRL",.T.)
			SRL->RL_FILIAL :=xFilial("SRL")
			SRL->RL_MAT    :="900000"
			SRL->RL_TIPOFJ :=_TIPO
			SRL->RL_CPFCGC :=_CGC
			SRL->RL_CODRET :=_CODRETIR
		ELSE
			RECLOCK("SRL",.F.)
		ENDIF
		SRL->RL_BENEFIC:=SA2->A2_NOME
		SRL->RL_ENDBENE:=SA2->A2_END
		SRL->RL_UFBENEF:=SA2->A2_EST
		SRL->RL_CGCFONT:=SM0->M0_CGC
		SRL->RL_NOMFONT:=SM0->M0_NOME
		MSUNLOCK()
		
		DBSELECTAREA("SRL")
		DBSEEK(xFilial("SRL")+"900000"+_TIPO+_CGC+_CODRET2)
		IF !FOUND()
			RECLOCK("SRL",.T.)
			SRL->RL_FILIAL :=xFilial("SRL")
			SRL->RL_MAT    :="900000"
			SRL->RL_TIPOFJ :=_TIPO
			SRL->RL_CPFCGC :=_CGC
			SRL->RL_CODRET :=_CODRET2
		ELSE
			RECLOCK("SRL",.F.)
		ENDIF
		SRL->RL_BENEFIC:=SA2->A2_NOME
		SRL->RL_ENDBENE:=SA2->A2_END
		SRL->RL_UFBENEF:=SA2->A2_EST
		SRL->RL_CGCFONT:=SM0->M0_CGC
		SRL->RL_NOMFONT:=SM0->M0_NOME
		MSUNLOCK()
		
		
		
		//******************************************************************
		_MES:=STRZERO(MONTH(SE2->E2_EMISSAO),2,0)
		DBSELECTAREA("SR4")
		DBSEEK(xFilial("SR4")+"900000"+_CGC+_CODRETIR+STRZERO(YEAR(SE2->E2_EMISSAO),4,0)+_MES+"A")
		IF !FOUND()
			RECLOCK("SR4",.T.)
			SR4->R4_FILIAL :=xFilial("SR4")
			SR4->R4_MAT    :="900000"
			SR4->R4_CPFCGC :=_CGC
			SR4->R4_CODRET :=_CODRETIR
			SR4->R4_ANO    :=STRZERO(YEAR(SE2->E2_EMISSAO),4,0)
			SR4->R4_MES    :=_MES
			SR4->R4_TIPOREN:="A"
		ELSE
			RECLOCK("SR4",.F.)
		ENDIF
		SR4->R4_VALOR   :=R4_VALOR + (SE2->E2_VALOR+SE2->E2_IRRF+SE2->E2_ISS+SE2->E2_INSS+SE2->E2_PIS + SE2->E2_COFINS + SE2->E2_CSLL)
		SR4->R4_TIPOREN:="A"
		MSUNLOCK()
		
		DBSEEK(xFilial("SR4")+"900000"+_CGC+_CODRETIR+STRZERO(YEAR(SE2->E2_EMISSAO),4,0)+_MES+"D")
		IF !FOUND()
			RECLOCK("SR4",.T.)
			SR4->R4_FILIAL :=xFilial("SR4")
			SR4->R4_MAT    :="900000"
			SR4->R4_CPFCGC :=_CGC
			SR4->R4_CODRET :=_CODRETIR
			SR4->R4_ANO    :=STRZERO(YEAR(SE2->E2_EMISSAO),4,0)
			SR4->R4_MES    :=_MES
			SR4->R4_TIPOREN:="D"
		ELSE
			RECLOCK("SR4",.F.)
		ENDIF
		SR4->R4_VALOR   :=R4_VALOR + SE2->E2_IRRF
		SR4->R4_TIPOREN:="D"
		MSUNLOCK()
		
		
		IF _TIPO="1" .AND. (SE2->E2_INSS) > 0             // GRAVA RETENÇAO DO INSS SOMENTE PARA P.FISICA
			DBSELECTAREA("SR4")
			DBSEEK(xFilial("SR4")+"900000"+_CGC+_CODRETIR+STRZERO(YEAR(SE2->E2_EMISSAO),4,0)+_MES+"B")
			IF !FOUND()
				RECLOCK("SR4",.T.)
				SR4->R4_FILIAL :=xFilial("SR4")
				SR4->R4_MAT    :="900000"
				SR4->R4_CPFCGC :=_CGC
				SR4->R4_CODRET :=_CODRETIR
				SR4->R4_ANO    :=STRZERO(YEAR(SE2->E2_EMISSAO),4,0)
				SR4->R4_MES    :=_MES
				SR4->R4_TIPOREN:="B" //"A"
			ELSE
				RECLOCK("SR4",.F.)
			ENDIF
			SR4->R4_VALOR   :=R4_VALOR + SE2->E2_INSS
			SR4->R4_TIPOREN:="B"
			MSUNLOCK()
		ENDIF
		
		IF (SE2->E2_PIS + SE2->E2_COFINS + SE2->E2_CSLL) > 0
			DBSELECTAREA("SR4")
			DBSEEK(xFilial("SR4")+"900000"+_CGC+_CODRET2+STRZERO(YEAR(SE2->E2_EMISSAO),4,0)+_MES+"A")
			IF !FOUND()
				RECLOCK("SR4",.T.)
				SR4->R4_FILIAL :=xFilial("SR4")
				SR4->R4_MAT    :="900000"
				SR4->R4_CPFCGC :=_CGC
				SR4->R4_CODRET :=_CODRET2
				SR4->R4_ANO    :=STRZERO(YEAR(SE2->E2_EMISSAO),4,0)
				SR4->R4_MES    :=_MES
				SR4->R4_TIPOREN:="A"
			ELSE
				RECLOCK("SR4",.F.)
			ENDIF
			SR4->R4_VALOR   :=R4_VALOR + (SE2->E2_VALOR+SE2->E2_IRRF+SE2->E2_ISS+SE2->E2_INSS + SE2->E2_PIS + SE2->E2_COFINS + SE2->E2_CSLL)
			SR4->R4_TIPOREN:="A"
			MSUNLOCK()
			
			DBSEEK(xFilial("SR4")+"900000"+_CGC+_CODRET2+STRZERO(YEAR(SE2->E2_EMISSAO),4,0)+_MES+"D")
			IF !FOUND()
				RECLOCK("SR4",.T.)
				SR4->R4_FILIAL :=xFilial("SR4")
				SR4->R4_MAT    :="900000"
				SR4->R4_CPFCGC :=_CGC
				SR4->R4_CODRET :=_CODRET2
				SR4->R4_ANO    :=STRZERO(YEAR(SE2->E2_EMISSAO),4,0)
				SR4->R4_MES    :=_MES
				SR4->R4_TIPOREN:="D"
			ELSE
				RECLOCK("SR4",.F.)
			ENDIF
			SR4->R4_VALOR   :=R4_VALOR + (SE2->E2_PIS + SE2->E2_COFINS + SE2->E2_CSLL)
			SR4->R4_TIPOREN:="D"
			MSUNLOCK()
		ENDIF
		
		DBSELECTAREA("SE2")
	ENDIF
	
	SE2->(DBSKIP())
	
ENDDO
IF  AA>0 .AND. _SOINSS="N"
	@ nLin,008 PSAY REPLICATE("-",124)
	nLin++
	@ nLin,008 PSAY ".SubTotal ............"
	@ nLin,037 PSAY AA PICTURE "@E 99,999,999.99"
	@ nLin,051 PSAY BB  PICTURE "@E 999,999.99"
	
	@ nLin,113 PSAY _X1 PICTURE "@EZ 99,999.99"
	@ nLin,123 PSAY _X2  PICTURE "@EZ 99,999.99"
	IF MV_PAR05=1 .OR. MV_PAR05=4
		nLin++
		@ nLin,103 PSAY CC   PICTURE "@E 99,999.99"
		@ nLin,113 PSAY DD   PICTURE "@E 99,999.99"
		@ nLin,123 PSAY EE     PICTURE "@E 99,999.99"
		CCC:=CCC+CC
		DDD:=DDD+DD
		EEE:=EEE+EE
	ENDIF
	nLin:=nLin+2
ENDIF
AAA:=AAA+AA
BBB:=BBB+BB
_XX1:=_XX1 + _X1
_XX2:=_XX2 + _X2

@ nLIN,000 PSAY REPLICATE("=",132)
nLin++
@ nLin,008 PSAY ".Total GERAL ........."
@ nLin,037 PSAY AAA PICTURE "@E 99,999,999.99"
@ nLin,051 PSAY BBB PICTURE "@E 999,999.99"
@ nLin,113 PSAY _XX1 PICTURE "@EZ 99,999.99"
@ nLin,123 PSAY _XX2  PICTURE "@EZ 99,999.99"
IF MV_PAR05=1 .OR. MV_PAR05=4
	nLin++
	@ nLin,103 PSAY CCC   PICTURE "@E 99,999.99"
	@ nLin,113 PSAY DDD   PICTURE "@E 99,999.99"
	@ nLin,123 PSAY EEE     PICTURE "@E 99,999.99"
ENDIF
nLin++
@ nLIN,000 PSAY REPLICATE("=",132)

//************************************************************** IMPRIME RESUMO POR COD RETENCAO
IF _SOINSS="N"
	nLin++
	@ nLin,008 PSAY ".Retencao por Codigo :"
	_xDesc:=""
	IF _TT0588>0
		_xDesc:=_xDesc + "0588 : "+TRANSFORM(_TT0588,"@E 999,999.99")
	ENDIF
	IF _TT1708>0
		_xDesc:=_xDesc + "    *    1708 : "+TRANSFORM(_TT1708,"@E 999,999.99")
	ENDIF
	IF _TT5952>0
		_xDesc:=_xDesc + "    *    5952 : "+TRANSFORM(_TT5952,"@E 999,999.99")
	ENDIF
	@ nLin,032 PSAY _xDesc
ENDIF




dbClearFilter()

SetPgEject(.F.)
If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool


Return

*****************************************************************************

// Substituido pelo assistente de conversao do AP5 IDE em 15/02/01 ==> Function ImpCabec
Static Function ImpCabec()

@ 00,00  psay repl("*" ,136)
@ 01,00  psay "* " +ALLTRIM(sm0->m0_nome)+"/"+SM0->M0_FILIAL
@ 01,117 psay "Folha..:   "+strzero(m_Pag,6)+" *"
@ 02,00 psay "* SIGA/ "+nomeprog
@ 02,(136-len(titulo))/2 psay titulo
@ 02,117 psay "Dt.Ref.: "+ dtoc(dDataBase)+" *"
@ 03,00 psay "* Hora...: " + time()
@ 03,117 psay "Emissao: " + dtoc(date())+" *"
@ 04,00 psay repl("*",136)
@ 05,00 psay cabec1
IF _SOINSS="N"
	@ 06,00 PSAY cabec2
	@ 07,00 psay repl("*",136)
	nLin := 8
ELSE
	@ 06,00 psay repl("*",136)
	nLin := 7
ENDIF
m_Pag := m_Pag + 1
Return

