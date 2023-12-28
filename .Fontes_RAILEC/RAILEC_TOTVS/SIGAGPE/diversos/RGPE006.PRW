#include "PROTHEUS.CH"
#include "MSGRAPHI.CH"
#Include "Colors.ch"
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99
#include "ap5mail.ch"

User Function Rgpe006()

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
SetPrvt("NREG,NTOT,NLIN,CABEC1,WCC")
SetPrvt("WLO,WFERIAS,TSALARIO,T2,TT2")
SetPrvt("WDSIT,TREG,WT_EXPA,WT_MENS,WT_EST,WT_COOR,wT_MASC,wT_FEM")
SetPrvt("T1,WRR,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ RGPE006  ³ Autor ³ Jose Macedo           ³ Data ³ 04.11.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Resumo de Pessoal                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
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
nomeprog:= "RGPE006"
aLinha  := { }
nLastKey:= 0
Titulo  := "Resumo de Pessoal"

cCancel := "***** CANCELADO PELO OPERADOR *****"
cPerg   := "" //"GPE002"
m_pag   := 1

wnrel   :="RGPE006"

//********************************************* TELA DE PARAMETROS
cCustIni := SPACE(9)
cCustFim := "ZZZZZZZZZ"
_DATABASE:= dDataBase
_ANASIN  :="N"
_YTD     :="N"
@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Periodo de Visualizacao"
@ 10, 15 SAY "Folha Calculada?"
@ 10, 49 GET _DATABASE SIZE 37,12
@ 30, 15 SAY "CCusto?"
@ 30, 49 GET cCustIni SIZE 37,12 F3 "CTT"
@ 40, 49 GET cCustFim SIZE 37,12 F3 "CTT"
@ 50, 15 SAY "Lista Nomes ?"
@ 50, 49 GET _ANASIN PICTURE "!" VALID _ANASIN$"SN"
@ 60, 15 SAY "Y-T-D       ?"
@ 60, 49 GET _YTD    PICTURE "!" VALID _YTD$"SN"

@ 60, 95 BmpButton Type 1 Action Close(oDlg2)
Activate Dialog oDlg2 Centered


IF LEFT(DTOS(_DataBase),6)>=GETMV("MV_FOLMES")
	ALERT("Escolha um mes ja fechado !!")
	RETURN Nil
ENDIF

//*********************************** DATA INICIO PARRA VARRER O SRD
_iniDATABASE:=_DataBase
IF _YTD="S"
	_XX:="01/01/"+STRZERO(YEAR(_DataBase),4,0)     // SE YTD PEGA A DATA INICIAL DE JANEIRO DO ANO CORRENTE
	_iniDATABASE:=CTOD(_xx)
ENDIF
//******************************************************************

Titulo  := "Resumo de Pessoal * Base: "+DTOC(_DataBase)

wnrel:= SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,tamanho)


If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

// INICIALIZA VARIAVEIS DE PARAMETROS (PERGUNTAS)



RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 15/02/01 ==> RptStatus({|| Execute(RptDetail) })


dbSelectArea("SRD")
DBSETORDER(1)
DBGOTOP()

dbSelectArea("SRA")
SET FILTER TO
DBSETORDER(1)
DBGOTOP()
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

nReg   := 1
nTot   := 0
nLin   := 0
m_pag  := 1
_CAMPO:="Lotacao   "


// Estrutura do Arquivo Temporario
aStru := {}
aadd(aStru , {'TMP_SEQ' ,'C', 02,0} )
aadd(aStru , {'TMP_CCU' ,'C', 09,0} )
aadd(aStru , {'TMP_FUN' ,'C', 06,0} )
aadd(aStru , {'TMP_DES' ,'C', 30,0} )
aadd(aStru , {'TMP_NFU' ,'N', 06,0} )

aadd(aStru , {'TMP_SAL' ,'N', 14,2} )    // TOTAL DA REMUNERAÇÃO
aadd(aStru , {'TMP_BAS' ,'N', 14,2} )    // SALARIO BASE

aadd(aStru , {'TMP_CPR' ,'N', 14,2} )    // CURTO PRAZO
aadd(aStru , {'TMP_BEN' ,'N', 14,2} )
aadd(aStru , {'TMP_ASM' ,'N', 14,2} )
aadd(aStru , {'TMP_SVG' ,'N', 14,2} )
aadd(aStru , {'TMP_OUT' ,'N', 14,2} )

aadd(aStru , {'TMP_MAT' ,'C', 06,0} ) // MATRICULA DO FUNCIONARIO
aadd(aStru , {'TMP_SIT' ,'C', 01,0} ) // SITUAÇÃO ATUAL NA FOLHA

/*
cArqTemp := CriaTrab(aStru , .t.)
dbUseArea(.T.,,cArqTemp,'TMP',.f.)

DBSELECTAREA("TMP")
INDEX ON TMP_SEQ+TMP_CCU+TMP_FUN  TO &cArqTemp
*/

oTable := FWTemporaryTable():New("TMP", aStru)
oTable:addIndex("01", {"TMP_SEQ","TMP_CCU","TMP_FUN"})
oTable:create()
TMP:= oTable:GetRealName()

DBSELECTAREA("TMP")

_VERBAS:=""
dbSelectArea("SRV")
DBSETORDER(1)
DBGOTOP()
WHILE !EOF()
	IF RV_TIPOCOD="1"
		_VERBAS:=_VERBAS+RV_COD+"%"
	ENDIF
	DBSKIP()
ENDDO


_CPRAZ:="216"                            // PR CURTO PRAZO
_ASSME:="850/852/861/796"                // ASSISTENCIA MEDICA E ODONTO
_SEGVI:="891/"
_BENEF:=       "848/849/851/"            // ESCOLA
_BENEF:=_BENEF+"889/890/"                // VISAVALE
_BENEF:=_BENEF+"858/859/854/"            // REEMBOLSOS


DBSELECTAREA("SRD")
DBSETORDER(1)   // RD_MAT+RD_DATARQ

DBSELECTAREA("SRA")
DBSETORDER(1)
dbGoTop()


WHILE !EOF()
	IF !(RA_CC >= cCustIni .and. RA_CC <= cCustFim) .OR. RA_SALARIO=0
		DBSKIP()
		Loop
	ENDIF
	IF RA_SITFOLH="D" .AND. LEFT(DTOS(RA_DEMISSA),6)<LEFT(DTOS(_iniDATABASE),6)
		DBSKIP()
		Loop
	ENDIF
	
	_VlRem:=_VlBenef:=_VlMEDIC:=_VlSVG:=_SALBASE:=0
   _VLCPRAZ:=0
	_SEQ:="1 "   // GERAL EMPRESA
	dbSelectArea("SRD")
	DBSEEK(xFILIAL("SRD")+SRA->RA_MAT+LEFT(DTOS(_iniDATABASE),6),.T.)
	WHILE !EOF() .AND. RD_MAT=SRA->RA_MAT .AND. RD_DATARQ<=LEFT(DTOS(_DataBase),6)
		
		IF RD_PD$_VERBAS
			_VLREM   := _VLREM   + SRD->RD_VALOR
		ENDIF
		
		IF RD_PD$_ASSME
			_VlMEDIC := _VlMEDIC + SRD->RD_VALOR
		ENDIF
		IF RD_PD$_SEGVI
			_VlSVG   := _VlSVG + SRD->RD_VALOR
		ENDIF
		IF RD_PD$_BENEF
			_VLBENEF := _VLBENEF + SRD->RD_VALOR
		ENDIF
		IF RD_PD$_CPRAZ
			_VLCPRAZ := _VLCPRAZ + SRD->RD_VALOR
		ENDIF
		
		IF RD_PD="866"    // SALARIO BASE MES GERADO NO MOVIMENTO DA FOLHA
			_SALBASE := _SALBASE + SRD->RD_VALOR
		ENDIF
		DBSKIP()
	ENDDO
	IF _VlRem>0
		DBSELECTAREA("TMP")
		DBSEEK(_SEQ)
		IF !FOUND()
			RECLOCK("TMP",.T.)
			TMP_SEQ:=_SEQ
			TMP_DES:="Total Geral da Empresa"
		ELSE
			RECLOCK("TMP",.F.)
		ENDIF
		TMP_NFU:=TMP_NFU + 1
		TMP_SAL:=TMP_SAL + _VlRem
		TMP_BEN:=TMP_BEN + (_VlMEDIC+ _VlSVG+ _VlBenef)
		TMP_CPR:=TMP_CPR + _VlCPRAZ
		TMP_ASM:=TMP_ASM + _VlMEDIC
		TMP_SVG:=TMP_SVG + _VlSVG
		TMP_OUT:=TMP_OUT + _VlBenef
		TMP_BAS+=_SALBASE
		MSUNLOCK()
		
		DBSEEK("2 "+SPACE(9)+SRA->RA_CODFUNC)
		IF !FOUND()
			RECLOCK("TMP",.T.)
			TMP_SEQ:="2 "
			TMP_CCU:=SPACE(9)
			TMP_FUN:=SRA->RA_CODFUNC
			TMP_DES:=POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")
		ELSE
			RECLOCK("TMP",.F.)
		ENDIF
		TMP_NFU:=TMP_NFU + 1
		TMP_SAL:=TMP_SAL + _VlRem
		TMP_CPR:=TMP_CPR + _VlCPRAZ
		TMP_BEN:=TMP_BEN + (_VlMEDIC+ _VlSVG+ _VlBenef)
		TMP_ASM:=TMP_ASM + _VlMEDIC
		TMP_SVG:=TMP_SVG + _VlSVG
		TMP_OUT:=TMP_OUT + _VlBenef
		TMP_BAS+=_SALBASE
		MSUNLOCK()
		
		IF SM0->M0_CODIGO="06"    // AMC
			_TIPOFUN:=POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_TIPO")
		ELSE
			_TIPOFUN:="01"
		ENDIF
		
		_DESCRIC:=ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"RH"+_TipoFun,"X5_DESCRI"))
		DBSEEK("3 "+SPACE(9)+_TipoFun)
		IF !FOUND()
			RECLOCK("TMP",.T.)
			TMP_SEQ:="3 "
			TMP_CCU:=SPACE(9)
			TMP_FUN:=_TipoFun
			TMP_DES:=_DESCRIC
		ELSE
			RECLOCK("TMP",.F.)
		ENDIF
		TMP_NFU:=TMP_NFU + 1
		TMP_SAL:=TMP_SAL + _VlRem
		TMP_BEN:=TMP_BEN + (_VlMEDIC+ _VlSVG+ _VlBenef)
		TMP_CPR:=TMP_CPR + _VlCPRAZ
		TMP_ASM:=TMP_ASM + _VlMEDIC
		TMP_SVG:=TMP_SVG + _VlSVG
		TMP_OUT:=TMP_OUT + _VlBenef
		TMP_BAS+=_SALBASE
		MSUNLOCK()
		
		
		DBSEEK("4 "+SRA->RA_CC+SPACE(6))
		IF !FOUND()
			RECLOCK("TMP",.T.)
			TMP_SEQ:="4 "
			TMP_CCU:=SRA->RA_CC
			TMP_FUN:=SPACE(6)
			TMP_DES:=POSICIONE("CTT",1,XFILIAL("CTT")+SRA->RA_CC,"CTT_DESC01")
		ELSE
			RECLOCK("TMP",.F.)
		ENDIF
		TMP_NFU:=TMP_NFU + 1
		TMP_SAL:=TMP_SAL + _VlRem
		TMP_BEN:=TMP_BEN + (_VlMEDIC+ _VlSVG+ _VlBenef)
		TMP_CPR:=TMP_CPR + _VlCPRAZ
		TMP_ASM:=TMP_ASM + _VlMEDIC
		TMP_SVG:=TMP_SVG + _VlSVG
		TMP_OUT:=TMP_OUT + _VlBenef
		TMP_BAS+=_SALBASE
		MSUNLOCK()
		
	ENDIF
	DBSELECTAREA("SRA")
	DBSKIP()
ENDDO

DBSELECTAREA("TMP")
DBSEEK("1 ")
_TOT:=TMP_SAL+TMP_CPR+TMP_BEN
_SAL:=TMP_SAL
_CPR:=TMP_CPR
_BEN:=TMP_BEN

_GRAF1:=TMP_SAL    // VARIAVEIS USADAS NA GERACAO DO DEMONSTRATIVO GRAFICO
_GRAF2:=TMP_CPR
_GRAF3:=TMP_BEN
_GRAF4:=0 //TMP_BAS

RECLOCK("TMP",.T.)
TMP_SEQ:="11"   // PERCENTUAL DO GRUPO 1 - TOTAL GERAL DA EMPRESA
TMP_DES:="Percentuais %"
TMP_SAL:=(_SAL/_TOT)*100
TMP_CPR:=(_CPR/_TOT)*100
TMP_BEN:=(_BEN/_TOT)*100
MSUNLOCK()

RECLOCK("TMP",.T.)
TMP_SEQ:="2 "
TMP_DES:="*Totais por Funcao"
MSUNLOCK()

RECLOCK("TMP",.T.)
TMP_SEQ:="3 "
TMP_DES:="*Totais por Tipo de Funcao"
MSUNLOCK()

RECLOCK("TMP",.T.)
TMP_SEQ:="4 "
TMP_DES:="*Totais por Centro de Custo"
MSUNLOCK()

IF _ANASIN="S"
	RECLOCK("TMP",.T.)
	TMP_SEQ:="99"
	TMP_DES:="* Detalha Funcionarios"
	MSUNLOCK()
ENDIF

cCabec1 := "Descricao "+SPACE(24)+"Qtd   Total Geral   Vl.Remuner  Vl.Incent  Vl.Benefi Situaca     Sal.Base  C.Custo"
cCabec2 := ' '


nLinha := 99

SetRegua(LastRec()) //Ajusta numero de elementos da regua de relatorios


DBSELECTAREA("SRA")
DBSETORDER(7)  // RA_CODFUNC
DBGOTOP()

DBSELECTAREA("TMP")
DBGOTOP()
While !Eof()
	IncRegua() //Incrementa a posicao da regua de relatorios
	IF TMP_SEQ="99"     // SAI DO LOOP QUANDO INICIAR OS FUNCIONARIOS
		EXIT
	ENDIF
	_PREFIX:=LEFT(TMP_SEQ,1)
	
	IF NLINHA>55
		nLinha:=cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)+1
	ENDIF
	@ nLINHA,001 PSAY LEFT(TMP_DES,30)
	@ nLINHA,033 PSAY TMP_NFU PICTURE "@Z 9999"
	
	_TOTAL:=TMP_SAL+TMP_BEN
	IF _TOTAL>0
		@ nLinha,039 PSAY _TOTAL PICTURE "@E 9,999,999.99"
		@ nLinha,052 PSAY TMP_SAL PICTURE "@E 9,999,999.99"
		@ nLinha,065 PSAY TMP_CPR PICTURE "@E 999,999.99"
		@ nLinha,076 PSAY TMP_BEN PICTURE "@E 999,999.99"
		@ nLinha,095 PSAY TMP_BAS PICTURE "@E 9,999,999.99"
		IF CCUSTINI=CCUSTFIM .AND. _ANASIN="N"                                    // SE FOR SOMENTE UM CCUSTO, IMPRIME A DESCRIÇÃO DO MESMO
			@ nLINHA,109 PSAY POSICIONE("CTT",1,XFILIAL("CTT")+CCUSTINI,"CTT_DESC01")
		ENDIF
	ENDIF
	IF _PREFIX$"3/4" .AND. _TOTAL>0
		@ nLinha,108 PSAY (_Total/_TOT)*100 PICTURE "@E 99,999.99"
	ENDIF
	
	NLINHA++
	IF !EMPTY(TMP_FUN) .AND. _ANASIN="S"                     // ************* IMPRIME DETALHADO POR FUNCIONARIO
		_REGTMP:=RECNO()
		DBSELECTAREA("SRA")
		DBSEEK(XFILIAL("SRA")+ALLTRIM(TMP->TMP_FUN))
		WHILE !EOF() .AND. ALLTRIM(RA_CODFUNC)=ALLTRIM(TMP->TMP_FUN)
			IF RA_SITFOLH="D" .AND. LEFT(DTOS(RA_DEMISSA),6)<LEFT(DTOS(_iniDATABASE),6)
				DBSKIP()
				Loop
			ENDIF
			
			IF !(RA_CC >= cCustIni .and. RA_CC <= cCustFim) .OR. RA_SALARIO=0
				DBSKIP()
				Loop
			ENDIF
			_SALBASE:=_VLREM:=_VLBENEF:=_VlMEDIC:=_VlSVG:=0
         _VLCPRAZ:=0
			dbSelectArea("SRD")
			DBSEEK(xFILIAL("SRD")+SRA->RA_MAT+LEFT(DTOS(_iniDATABASE),6),.T.)
			WHILE !EOF() .AND. RD_MAT=SRA->RA_MAT .AND. RD_DATARQ<=LEFT(DTOS(_DataBase),6)
				IF RD_PD$_VERBAS
					_VLREM   := _VLREM   + SRD->RD_VALOR
				ENDIF
				
				IF RD_PD$_ASSME
					_VlMEDIC := _VlMEDIC + SRD->RD_VALOR
				ENDIF
				IF RD_PD$_SEGVI
					_VlSVG   := _VlSVG   + SRD->RD_VALOR
				ENDIF
				IF RD_PD$_BENEF
					_VLBENEF := _VLBENEF + SRD->RD_VALOR
				ENDIF
				IF RD_PD$_CPRAZ
					_VLCPRAZ := _VLCPRAZ + SRD->RD_VALOR
				ENDIF
				IF RD_PD="866"    // SALARIO BASE MES GERADO NO MOVIMENTO DA FOLHA
					_SALBASE := _SALBASE + SRD->RD_VALOR
				ENDIF
				
				DBSKIP()
			ENDDO
			dbSelectArea("SRA")
			
			@ nLINHA,002 PSAY LEFT(RA_NOME,35)
			_xTOTAL:=(_VLREM+_VlSVG+_VLBENEF+_VLCPRAZ+_VlMEDIC)
			@ nLinha,039 PSAY _xTOTAL PICTURE "@E 9,999,999.99"
			@ nLinha,052 PSAY _VLREM PICTURE "@E 9,999,999.99"
			@ nLinha,065 PSAY _VLCPRAZ  PICTURE "@E 999,999.99"
			@ nLinha,076 PSAY (_VlSVG+_VLBENEF+_VlMEDIC) PICTURE "@E 999,999.99"
			
			IF RA_SITFOLH="A"
				@ nLinha,087 PSAY "*Afastado"
			ELSEIF RA_SITFOLH="D"
				@ nLINHA,087 PSAY "*Demitido"
			ENDIF
			IF _VLREM>0
				@ nLinha,097 PSAY _SALBASE PICTURE "@E 999,999.99"
			ENDIF
			
			_DESCC:=POSICIONE("CTT",1,XFILIAL("CTT")+SRA->RA_CC,"CTT_DESC01")
			@ nLINHA,109 PSAY ALLTRIM(RA_CC)+"-"+_DESCC
			DBSELECTAREA("TMP")
			IF (_VlRem+_SALBASE)>0
				RECLOCK("TMP",.T.)
				TMP_SEQ:="99"
				TMP_CCU:=SRA->RA_CC
				TMP_FUN:=SRA->RA_CODFUNC
				TMP_DES:=SRA->RA_NOME
				TMP_SAL:=_VlRem
				
				TMP_BEN:=TMP_BEN + (_VlMEDIC+ _VlSVG+ _VlBenef)
				TMP_CPR:=TMP_CPR + _VlCPRAZ
				TMP_ASM:=TMP_ASM + _VlMEDIC
				TMP_SVG:=TMP_SVG + _VlSVG
				TMP_OUT:=TMP_OUT + _VlBenef
				TMP_BAS+=_SALBASE
				
				TMP_MAT:=SRA->RA_MAT
				TMP_SIT:=SRA->RA_SITFOLH
				MSUNLOCK()
			ENDIF
			DBSELECTAREA("SRA")
			DBSKIP()
			nLINHA++
			IF NLINHA>55
				nLinha:=cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,15)+1
			ENDIF
		ENDDO
		DBSELECTAREA("TMP")
		DBGOTO(_RegTmp)         // RETORNA AO REGISTRO CORRENTE DO ARQUIVO TEMPORARIO
	ENDIF
	DBSELECTAREA("TMP")
	DBSKIP()
	IF LEFT(TMP_SEQ,1)#_PREFIX .OR. EOF()
		@ nLinha,000 PSAY __PrtThinLine()
		nLinha:=nLinha+1
		IF LEFT(TMP_SEQ,1)="3"
			cCabec1 :=cCabec1 + "  % s/Total"
			nLinha:=99
		ENDIF
	ENDIF
ENDDO

If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

DBSELECTAREA("SRA")
DBSETORDER(1)  // RA_MAT
DBGOTOP()
//***************************************************************************************************************
_GeraXls:=1
@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Gera Planilha Excel ?"
@ 10, 49 SAY "1 - Nao"
@ 22, 49 SAY "2 - Sim"
@ 44, 49 GET _GeraXls PICTURE "99"
@ 60, 90 BmpButton Type 1 Action Close(oDlg2)
Activate Dialog oDlg2 Centered
If _GeraXls=2 .AND. File(cArqTemp+".DTC")
	DbSelectArea("TMP")
	DBGOTOP()
//	COPY TO QUADRO.CSV
	_cArqRen:="\SYSTEM\TEMPDBF\QUADRO.CSV"
	//Copy to &_cArqRen VIA "DBFCDXADS" 
	//Copiando Arquivo criado .DBF para o diretorio específico no Cliente
	IF CPYS2T("\SYSTEM\TEMPDBF\QUADRO.CSV","C:\Relato\",.F.)
		MSGINFO("Arquivo gerado com sucesso! C:\Relato\QUADRO.CSV")
	ELSE
		ALERT("ERRO NA COPIA")
	ENDIF
EndIf


dbSelectArea('TMP')
dbCloseArea()
cArqTemp2 := cArqTemp + '.DTC'
Delete File &cArqTemp2
cArqTemp3 := cArqTemp + '.CDX'
Delete File &cArqTemp3

GERAGRA()

Return




//******************************************************************************************************
STATIC FUNCTION GERAGRA()
//******************************************************************************************************
nCBX:=10               // 1 LINHA 2 BARRA
nVisual:=1
nMoeda:=1

DEFINE MSDIALOG oDlg FROM 0,0 TO 450,700 PIXEL TITLE "Representação gráfica do Total Geral"
DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

// Layout da janela
@ 000, 000 BITMAP oBmp RESNAME SM0->M0_NOMECOM oF oDlg SIZE 50, 250 NOBORDER WHEN .F. PIXEL
@ 003, 060 SAY "Custo Folha"   FONT oBold PIXEL

@ 014, 050 TO 16 ,400 LABEL '' OF oDlg  PIXEL

@ 014, 050 TO 16 ,400 LABEL '' OF oDlg  PIXEL

@ 020, 055 MSGRAPHIC oGraphic SIZE 285, 158 OF oDlg PIXEL


// AQUI A IMPRESSAO

@ 190, 112 BUTTON "Gera Graf"   SIZE 40,14 OF oDlg WHEN oGraphic:l3D PIXEL ACTION EXECBLOCK("_GGERXX3")
@ 190, 238 BUTTON o3D PROMPT "&2D" SIZE 40,14 OF oDlg PIXEL ACTION (oGraphic:l3D := !oGraphic:l3D, o3d:cCaption := If(oGraphic:l3D, "&2D", "&3D"))
@ 190, 280 BUTTON "&Salva BMP"   SIZE 40,14 OF oDlg PIXEL ACTION MySaveBmp( oGraphic )

@ 207, 050 TO 209 ,400 LABEL '' OF oDlg  PIXEL
@ 213, 280 BUTTON "&Sair" SIZE 40,12 OF oDlg PIXEL ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTER


RETURN

//******************
USER FUNCTION _GGERXX3()
//*****************
_TOTAL:=_GRAF1+_GRAF2+_GRAF3   // TOTAL DO CUSTO DE MAO DE OBRA


@ 020, 055 MSGRAPHIC oGraphic SIZE 285, 158 OF oDlg PIXEL
oGraphic:SetMargins( 2, 6, 6, 6 )
oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRPLASTVAL, .F. )
nSerie  := oGraphic:CreateSerie(nCbx)

If nVisual == 1
	nSerie2 := oGraphic:CreateSerie(nCbx)
	@ 180,100 SAY "REMUNERAÇÃO" OF oDlg COLOR CLR_HRED  FONT oBold PIXEL
	@ 180,200 SAY "INCENTIVOS " OF oDlg COLOR CLR_HBLUE  FONT oBold PIXEL
	@ 180,300 SAY "BENEFICIOS " OF oDlg COLOR CLR_HGREEN  FONT oBold PIXEL
Endif


//CLR_HBLUE, CLR_HRED, CLR_HGREEN, CLR_YELLOW, CLR_BLACK,;
//CLR_WHITE, CLR_GRAY, CLR_HCYAN, CLR_HMAGENTA }, nCorSer := 1

If nSerie != GRP_CREATE_ERR .And. nSerie2 != GRP_CREATE_ERR
	SaidAC:=INT(_GRAF1)
	DATAX :="REM"
	IF SAIDAC>0
		oGraphic:Add(nSerie ,SaidAc,DataX,CLR_HRED)
	ENDIF
	
	SaidAC:=INT(_GRAF2)
	DATAX :="BEN"
	IF SAIDAC>0
		oGraphic:Add(nSerie ,SaidAc,DataX,CLR_HBLUE)
	ENDIF
	
	SaidAC:=INT(_GRAF3)
	DATAX :="ENC"
	IF SAIDAC>0
		oGraphic:Add(nSerie ,SaidAc,DataX,CLR_HGREEN)
	ENDIF
	
	//	SaidAC:=INT(_GRAF4)
	//	DATAX :="SAL"
	//	IF SAIDAC>0
	//		oGraphic:Add(nSerie ,SaidAc,DataX,CLR_YELLOW)
	//	ENDIF
	
	
Else
	MsgStop("Não foi possível criar a série.")
Endif

oGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )
oGraphic:SetTitle( "R$ :"+TRANSFORM(_TOTAL,"@E 999,999,999.99") , "", CLR_HRED , A_LEFTJUST , GRP_TITLE )
//oGraphic:SetTitle( "Datas" , "", CLR_GREEN, A_RIGHTJUS , GRP_FOOT  )

RETURN

//****************
Static Function MySaveBmp( oGraphic )
//****************
Local cBmpName := CriaTrab(,.F.)+".BMP"
Local cWhereToSave := "\" // Somente gravar abaixo do rootpath do servidor

If oGraphic:SaveToBMP( cBmpName , cWhereToSave )
	//MsgInfo("Arquivo: "+cWhereToSave+"\"+cBmpName+" gerado com sucesso!")
	_ARQ:=cWhereToSave+cBmpName
	IF CPYS2T(_ARQ,"C:\Relato\",.F.)
		MSGINFO("Arquivo gerado com sucesso! PASTA C:RELATO"+_ARQ)
	ELSE
		ALERT("ERRO NA COPIA "+_ARQ)
	ENDIF
Else
	MsgStop("Não foi possível gerar o arquivo bitmap do gráfico")
Endif


Return Nil

