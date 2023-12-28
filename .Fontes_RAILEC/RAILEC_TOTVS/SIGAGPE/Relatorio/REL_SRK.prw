#INCLUDE "rwmake.ch"


User Function REL_SRK()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "EXTRATO DE LANC FUTUROS"
Local cPict          := ""
Local titulo       := "EXTRATOS DE LANC FUTUROS"
Local nLin         := 80


Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "REL_SRK" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "REL_SRK" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := ""
Private cString    := "SRA"

_DATA :=dDatabase-DAY(DDATABASE)
_VERBA:="467"
_MATRI:=SPACE(6)
_BUSCA:="N"
_SODIF:="N"


@ 1,1 to  150,300 DIALOG oDlg2A TITLE "Qual Ultima folha calculada ?"
@ 22-12, 05 SAY "Dt Folha ?"
@ 22-12, 55 GET _Data SIZE 12,30
@ 32-12, 05 SAY "Verba"
@ 32-12, 55 GET _VERBA SIZE 12,15 F3 "SRV"
@ 42-12, 05 SAY "Matric"
@ 42-12, 55 GET _MATRI SIZE 12,15 F3 "SRA"
@ 52-12, 05 SAY "Busca Acum?"
@ 52-12, 55 GET _BUSCA PICTURE "!" VALID _BUSCA$"SN"
@ 62-12, 05 SAY "SС com Dif?"
@ 62-12, 55 GET _SODIF PICTURE "!" VALID _SODIF$"SN"

@ 60, 90 BmpButton Type 1 Action Close(oDlg2A)
Activate Dialog oDlg2A Centered

//Pergunte(cPerg,.t.)

IF !EMPTY(ALLTRIM(_Matri))
	_BUSCA:="S"
ENDIF

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)
Cabec1       := _VERBA+"-"+POSICIONE("SRV",1,XFILIAL("SRV")+_VERBA,"RV_DESC")
Cabec2       := ""

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

//******************************
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
//******************************
Local xLin,lOk,cDataSit, cCusto

DbSelectArea("SRC")
DbSetorder(1)
DbSelectArea("SRD")
DbSetorder(1)
DbSelectArea("SRA")
DbSetorder(1)
dbSelectArea("SRK")
dbSetOrder(1)

SetRegua(RecCount())

dbGoTop()
_TOTLIDOS:=0

While !EOF()
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit 
	Endif
	
	_SITFOL:=Posicione("SRA", 1 ,xFilial("SRA")+SRK->RK_MAT,"RA_SITFOLH")
	_NOME  :=SRA->RA_NOMECMP
	IF _SITFOL="D" 	    // NAO CONSIDERAR DEMITIDOS
		SRK->(DBSKIP())
		Loop
	ENDIF
	IF RK_QUITAR="3" .OR. RK_DTVENC<_DATA    // QUITADO OU VENCIMENTO MENOR QUE A DATA BASE (NAO HA DESCONTO MAIS)
		SRK->(DBSKIP())
		Loop
	ENDIF
	IF !EMPTY(ALLTRIM(_Matri)) .AND. _MATRI#SRK->RK_MAT   // FILTRA UMA UNICA MATRICULA
		SRK->(DBSKIP())
		Loop
	ENDIF
	IF RK_PD#_VERBA
		SRK->(DBSKIP())                                   // FILTRA VERBA
		Loop
	ENDIF
    _SALDO := RK_VALORTO-RK_VLRPAGO

	
	//*************************************************************** BUSCA VALORES ACUMULADOS NOS MESES EM QUESTAO
	_DESCRI:=""
	_VALORT   :=0
	_DDSAL    :=0
	IF _BUSCA="S"   // VAI NO ACUMULADO SRD
		_AnoMes   :=LEFT(DTOS(SRK->RK_DTMOVI),6)   // DATA DE INICIO DO DESCONTO NOS LANC FUTUROS
		_AnoMesAte:=LEFT(DTOS(SRK->RK_DTVENC),6)   // DATA DO PROXIMO VENCIMENTO
		DBSELECTAREA("SRD")
		DBSEEK(xFilial("SRD")+SRK->RK_MAT+_AnoMes,.T.)
		WHILE !EOF() .AND. RD_MAT+RD_DATARQ<=SRK->RK_MAT+_AnoMesAte
			IF RD_PD=_VERBA
				_VALORT+=RD_VALOR  // SOMA VALOR
				_DDSAL +=1         // SOMA PARCELAS
				_DESCRI:=_DESCRI + RD_DATARQ+" "+ALLTRIM(STR(RD_VALOR,12,2))+" / "
			ENDIF
			DBSKIP()
		ENDDO
	ENDIF
	
	
	
	DBSELECTAREA("SRK")
	//***********************************************************************
	If nLin > 55
		nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin += 1
		@ nLin,007 PSAY "Nome"    // alteracao feita 18-07-2018 Marinaldo SА 
		@ nLin,054 PSAY "PR/TT"   // nlin = 39
		@ nLin,060 PSAY "Dt Vencim" // nlin 45
		@ nLin,071 PSAY "Dt Inicio"  // nlin 56
		@ nLin,082 PSAY " Valor Par" // nlin 67
		@ nLin,094 PSAY " ValorPago" // nlin 079
		@ nLin,106 PSAY " Valor Tot" // nlin 091
		@ nLin,118 PSAY "     Saldo" // nlin 103
		nLin += 1
	Endif
	
	IF _SODIF="N" .OR. (_SODIF="S" .AND. RK_PARCPAG#_DDSAL)                   // SOMENTE QUEM ESTA COM DIFERENCA
		@ nLiN,000 PSAY RK_MAT
		@ nLiN,007 PSAY SUBSTR(_NOME,1,45)
		@ nLiN,054 PSAY RK_PARCPAG PICTURE "99" // 39
		@ nLiN,057 PSAY RK_PARCELA PICTURE "99" // 42
		@ nLiN,060 PSAY DTOC(RK_DTVENC)         // 45
		@ nLiN,071 PSAY DTOC(RK_DTMOVI)         // 56
		@ nLiN,082 PSAY RK_VALORPA            PICTURE "@E 999,999.99" //67
		@ nLiN,094 PSAY RK_VLRPAGO            PICTURE "@E 999,999.99" //79
		@ nLiN,106 PSAY RK_VALORTO            PICTURE "@E 999,999.99" //91 
		@ nLiN,118 PSAY RK_VALORTO-RK_VLRPAGO PICTURE "@E 999,999.99" //103
		
		_TOTLIDOS++
		
		nLin += 1
		IF !EMPTY(_DESCRI)
			@ nLiN,020 PSAY "Acumulados:"
			@ nLiN,039 PSAY _DDSAL  PICTURE "99"
			@ nLiN,079 PSAY _VALORT PICTURE "@E 999,999.99"
			nLin += 1
			_DES1:=SUBSTR(_DESCRI,001,140)
			_DES2:=SUBSTR(_DESCRI,141,140)
			_DES3:=SUBSTR(_DESCRI,281,140)
			@ nLiN,007 PSAY _DES1
			nLin += 1
			
			IF !EMPTY(ALLTRIM(_DES2))
				@ nLiN,007 PSAY _DES2
				nLin += 1
				IF !EMPTY(ALLTRIM(_DES3))
					@ nLiN,007 PSAY _DES3
					nLin += 1
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	DbSelectArea("SRK")
	dbSkip()
EndDo
nLin += 1
@nLin,0 PSay STR(_TOTLIDOS,6,0)+" total de funcionarios processados."

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Finaliza a execucao do relatorio...                                 Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

SET DEVICE TO SCREEN

DbSelectArea("SRD")
DBSETORDER(1)
DBGOTOP()
DbSelectArea("SRA")
DBSETORDER(1)
DBGOTOP()


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Se impressao em disco, chama o gerenciador de impressao...          Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
