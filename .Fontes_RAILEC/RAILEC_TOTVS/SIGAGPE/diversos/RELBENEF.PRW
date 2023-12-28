#include "rwmake.ch"

**************
user Function RELBENEF()    // ROTINA DE IMPRESSAO DE beneficios RH ... By JOSE MACEDO
**************

nOrdem :=0
Z:=0
M:=0
tamanho:="G"
limite:=220
titulo   := PADC("Relação de Beneficios",74)
cDesc1   := PADC(" ",74)
cDesc2   := PADC(" ",74)
cDesc3   := PADC(" ",74)
cNatureza:=""
aReturn  := { "Especial", 1,"Administracao", 2, 2, 1,"",1 }
nPag     := 0
nomeprog := "BENEF_"
cPerg    := "CONTRA"
wnrel    := "BENEF_"
nLastKey := 0
lContinua:= .T.
nLin     := 0



//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas                                      ¦
//+-------------------------------------------------------------------------+
_INI:=space(6)
_FIM:="999999"
_ID1:=0
_ID2:=99
_FIL:="N"
_VAL:="S"

@ 1,1 to  200,300 DIALOG oDlg2 TITLE "Matricula"
@ 10, 22 SAY "De :"
@ 10, 49 GET _INI  SIZE 25,12 F3 "SRA"
@ 22, 22 SAY "Ate:"
@ 22, 49 GET _FIM  SIZE 25,12 F3 "SRA"
@ 34, 22 SAY "Idade DE:"
@ 34, 49 GET _ID1  PICTURE "999"
@ 46, 22 SAY "Idade ATE:"
@ 46, 49 GET _ID2  PICTURE "999"
@ 58, 22 SAY "So Filhos?"
@ 58, 49 GET _FIL  PICTURE "!"
@ 70, 18 SAY "Imp Unimed ?"
@ 70, 49 GET _VAL  PICTURE "!"

@ 70, 95 BmpButton Type 1 Action Close(oDlg2)
Activate Dialog oDlg2 Centered

cString:= ALIAS()


//+--------------------------------------------------------------+
//¦ Inicializa variaveis graficas                                ¦
//+--------------------------------------------------------------+

aOkImp := .f.
nHeight:=15
lBold:= .F.
lUnderLine:= .F.
lPixel:= .T.
lPrint:=.F.
nSedex := 1

oFont9  :=TFont():New( "Arial"   ,,14,,.T.,,,,,.F. )
oFont9B :=TFont():New( "Arial"   ,,10,,.T.,,,,,.F. )
oFont9a := TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
oFont9aX:= TFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)

oPrn := TMSPrinter():New()
oPrn:Setup()


//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,Tamanho,"",.T.)

If nLastKey == 27 .or. Lastkey() == 27
	Return
Endif

//+--------------------------------------------------------------+
//¦ Verifica Posicao do Formulario na Impressora                 ¦
//+--------------------------------------------------------------+
SetDefault(aReturn,cString)

If nLastKey == 27 .or. Lastkey() == 27
	Return
Endif


LinCab := 0
cabec1 :=" "
cabec2 :=" "
cabec3 :=" "
cabec4 :=" "
cBitMap:= "ALUBAR.Bmp"

IF EMPTY(_FIM)
	_FIM:=_INI
ENDIF
//+-----------------------------------------------------------+
//¦ Inicio do Relatorio                                       ¦
//+-----------------------------------------------------------+
_SALTO:=50
Linha := 50
_A:=_B:=_C:=0
_IMPFUNC:=.T.


//***************************************************** FILTRO DO GERENTE
_USUARIO:=""
_CC:=""
DbSelectArea("SAK")
DBSETORDER(2)
DBSEEK(xFilial("SAK")+RETCODUSR())
IF FOUND()
	_USUARIO:=AK_COD
	DbSelectArea("CTT")
	DbGotop()
	WHILE !EOF()
		IF CTT_RESP=_USUARIO .OR. UPPER(SUBSTR(cUsuario,7,6))$"ADMINI/MACEDO/ANA.CA"
			_CC:=_CC+CTT_CUSTO+"%"
		ENDIF
		DBSKIP()
	ENDDO
	DbGotop()
ENDIF
//********************************************************************************************************


DBSELECTAREA("SRB")
DBSETORDER(1)
DBSELECTAREA("SRA")
SET FILTER TO RA_MAT>=_INI .AND. RA_MAT<=_FIM
DBSETORDER(1)
DBGOTOP()
cUniodon := GETMV("MV_UNIODON")
WHILE !EOF()
	
	INIPAG()
	
	WHILE !EOF() .AND. RA_MAT<=_FIM .AND. LINHA<2200
		IF !EMPTY(_CC) .AND. !ALLTRIM(RA_CC)$_CC
			SRA->(DBSKIP())
			Loop
		ENDIF
		IF RA_SITFOLH="D"
			SRA->(DBSKIP())
			Loop
		ENDIF
		
		_EMPREG := 0
		_EMPRES := 0
		DBSELECTAREA("SRC")
		DBSEEK(xFilial("SRC")+SRA->RA_MAT+"471")    // UNIMED
		IF FOUND()
			nTIT    := RC_VALOR
			nDEP    := 0
			WHILE !EOF() .AND. RC_MAT=SRA->RA_MAT
				nDEP    := nDEP    + IIF(RC_PD$"476/477/478/479/480/481/482/483",RC_VALOR,0)
				_EMPRES := _EMPRES + IIF(RC_PD$"850/852/853",RC_VALOR,0)
				DBSKIP()
			ENDDO
			_EMPREG := nTIT + nDep
		ENDIF
		
		IF _FIL="S"
			_IMPFUNC:=.F.
			DBSELECTAREA("SRB")
			DBSEEK(xFilial("SRB")+SRA->RA_MAT)
			WHILE !EOF() .AND. RB_MAT==SRA->RA_MAT
				_IDADE:=INT((DDATABASE-RB_DTNASC)/360)
				IF !(_IDADE>=_ID1 .AND. _IDADE<=_ID2)
					SRB->(DBSKIP())
					Loop
				ENDIF
				IF _FIL="S" .AND. RB_GRAUPAR#"F"
					SRB->(DBSKIP())
					Loop
				ENDIF
				_IMPFUNC:=.T.
				DBSKIP()
			ENDDO
		ENDIF
		
		dbSelectArea( "SRA" )
		_xEnd:=""
		IF _IMPFUNC
			oPrn:Say(Linha:=Linha+_SALTO , 025,DTOC(SRA->RA_ADMISSA) , oFont9a)
			oPrn:Say(Linha:=Linha        , 190,SRA->RA_NOME , oFont9aX)
			IF _VAL#"N"
				oPrn:Say(Linha:=Linha        , 750,STRZERO((VAL(SRA->RA_DPASSME)+1),2,0) , oFont9a)
				oPrn:Say(Linha:=Linha        , 820,DTOC(RA_NASC) , oFont9a)
				oPrn:Say(Linha:=Linha        ,1000,TRANSFORM(_EMPRES,"@E 99,999.99" ) , oFont9a)
				oPrn:Say(Linha:=Linha        ,1200,TRANSFORM(_EMPREG,"@E 99,999.99" ) , oFont9a)
				oPrn:Say(Linha:=Linha        ,1500,SRA->RA_DPUNIOD , oFont9a)
				oPrn:Say(Linha:=Linha        ,1570,TRANSFORM(VAL(SRA->RA_DPUNIOD)*VAL(cUniodon),"@EZ 99,999.99" ) , oFont9a)
			ELSE
				oPrn:Say(Linha:=Linha        , 820,DTOC(RA_NASC) , oFont9a)
				oPrn:Say(Linha:=Linha        ,1200,RA_TELEFON , oFont9a)
			ENDIF
			oPrn:Say(Linha:=Linha        ,1750,SRA->RA_MAT , oFont9a)
			oPrn:Say(Linha:=Linha        ,1850,Transform( SRA->RA_CIC , "@R 999.999.999-99" ) , oFont9a)
			oPrn:Say(Linha:=Linha        ,2100,SRA->RA_PIS  , oFont9a)
			oPrn:Say(Linha:=Linha        ,2300,"Mãe: "+SRA->RA_MAE  , oFont9a)
			_A:=_A + _EMPRES
			_B:=_B + _EMPREG
			_C:=_C + VAL(SRA->RA_DPUNIOD)*VAL(cUniodon)
			_xEnd:="Ender: "+ALLTRIM(RA_ENDEREC)+" "+ALLTRIM(RA_COMPLEM)+","+ALLTRIM(RA_BAIRRO)+" - "+ALLTRIM(RA_MUNICIP)+"/"+RA_ESTADO
			DBSELECTAREA("SRB")
			DBSEEK(xFilial("SRB")+SRA->RA_MAT)
			WHILE !EOF() .AND. RB_MAT==SRA->RA_MAT
				_IDADE:=INT((DDATABASE-RB_DTNASC)/360)
				IF !(_IDADE>=_ID1 .AND. _IDADE<=_ID2)
					SRB->(DBSKIP())
					Loop
				ENDIF
				IF _FIL="S" .AND. RB_GRAUPAR#"F"
					SRB->(DBSKIP())
					Loop
				ENDIF
				
				_UNIMED:=" "
				IF RB_UNIMED="2"
					_UNIMED:="Enf"
				ELSEIF RB_UNIMED="3"
					_UNIMED:="Apt"
				ENDIF
				_UNIODON:=IIF(RB_UNIODON="2","Sim","Nao")
				oPrn:Say(Linha:=Linha+_SALTO-10 , 120,RB_GRAUPAR , oFont9a)
				oPrn:Say(Linha:=Linha        , 200,RB_NOME , oFont9a)
				IF _VAL#"N"
					oPrn:Say(Linha:=Linha        , 750,_UNIMED , oFont9a)
				ENDIF
				oPrn:Say(Linha:=Linha        , 820,DTOC(RB_DTNASC) , oFont9a)
				IF RB_GRAUPAR="F" .OR. _VAL="N"
					oPrn:Say(Linha:=Linha    , 1000,STRZERO(_IDADE,2,0)+" anos" , oFont9a)
				ENDIF
				IF _VAL#"N"
					oPrn:Say(Linha:=Linha        ,1500,_UNIODON , oFont9a)
				ENDIF
				IF !EMPTY(_xEnd)
					oPrn:Say(Linha , 1750,_xEnd , oFont9a)
					_xEND:=" "
				ENDIF
				DBSKIP()
				IF LINHA+_SALTO >=2200
					INIPAG()
				ENDIF
			ENDDO
			IF !EMPTY(_xEnd)
				oPrn:Say(Linha:=Linha+_SALTO-10 , 1750,_xEnd , oFont9a)
			ENDIF
			oPrn:line( Linha:=Linha+50   ,  25 ,Linha,2960)     // Linha horizontal
			Linha:=Linha-20
		ENDIF
		DBSELECTAREA("SRA")
		DBSKIP()
	ENDDO
ENDDO
SET FILTER TO

oPrn:Say(Linha:=Linha+75     , 120,".Total Geral " , oFont9a)
oPrn:Say(Linha:=Linha        ,1000,TRANSFORM(_A,"@E 99,999.99" ) , oFont9a)
oPrn:Say(Linha:=Linha        ,1200,TRANSFORM(_B,"@E 99,999.99" ) , oFont9a)
oPrn:Say(Linha:=Linha        ,1570,TRANSFORM(_C,"@E 99,999.99" ) , oFont9a)

oPrn:Preview()
MS_FLUSH()

oPrn:EndPage()

DBSELECTAREA("SRA")
SET FILTER TO
DBGOTOP()

RETURN

//********************
STATIC FUNCTION INIPAG()
//********************
oPrn:EndPage()
Linha := 50
nPag  := nPag +1

oPrn:Say(Linha:=Linha   ,50  ,SM0->M0_NOMECOM , oFont9)
oPrn:Say(Linha:=Linha   ,1250,Titulo , oFont9)
oPrn:Say(Linha:=Linha   ,2400,"Pag : "+STRZERO(nPAG,3,0) , oFont9)
oPrn:line( Linha:=Linha+60   ,  25 ,Linha,2960)     // Linha horizontal

oPrn:Say(Linha:=Linha+60,  25,"Dt Adm" , oFont9b)
oPrn:Say(Linha:=Linha   , 200,"Nome" , oFont9b)

IF _VAL#"N"
	oPrn:Say(Linha:=Linha   , 700,"Unimed" , oFont9b)
	oPrn:Say(Linha:=Linha   , 820,"Dt Nascim" , oFont9a)
	oPrn:Say(Linha:=Linha   ,1000,"  Empresa" , oFont9b)
	oPrn:Say(Linha:=Linha   ,1200,"Empregado" , oFont9b)
	oPrn:Say(Linha:=Linha   ,1450," Uniodont" , oFont9b)
	oPrn:Say(Linha:=Linha   ,1650,"R$" , oFont9b)
ELSE
	oPrn:Say(Linha:=Linha   , 820,"Dt Nascim" , oFont9B)
	oPrn:Say(Linha:=Linha   ,1000,"Idade" , oFont9B)
	oPrn:Say(Linha:=Linha   ,1200,"Telefone" , oFont9B)
ENDIF
oPrn:Say(Linha:=Linha   ,1750,"Matr" , oFont9B)
oPrn:Say(Linha:=Linha   ,1850,"C.P.F" , oFont9B)
oPrn:Say(Linha:=Linha   ,2100,"PIS" , oFont9B)

RETURN








//***********************
USER FUNCTION REL_PLANO()
//**********************
//+--------------------------------------------------------------+
//¦ Define Variaveis Ambientais                                  ¦
//+--------------------------------------------------------------+

CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
tamanho:="M"
limite:=220
titulo   := PADC("RELACAO DE PLANOS DE SAUDE",74)
cDesc1   := PADC(" ",74)
cDesc2   := PADC(" ",74)
cDesc3   := PADC(" ",74)
cNatureza:=""
aReturn  := { "Especial", 1,"Administracao", 2, 2, 1,"",1 }
nPag     := 0
nomeprog := "REL_PLANO"
cPerg    := ""
wnrel    := "REL_PLANO"
nLastKey := 0
lContinua:= .T.
nLin     := 0


//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas                                      ¦
//+-------------------------------------------------------------------------+

cString:= "SRA"

_AnaSin:="A"
_QUAL  :="E"
_QUAL2 :="2"

@ 1,1 to  150,300 DIALOG oDlg2X TITLE "Parametros"
@ 10, 49 SAY "A - Analitico"
@ 20, 49 SAY "S - Sintetico"
@ 30, 49 GET _AnaSin PICTURE "!" VALID _AnaSin$"AS"
@ 40, 05 SAY "E=Unimed;F=Brad"
@ 40, 49 GET _QUAL PICTURE "!" VALID _QUAL$"EF"
@ 50, 05 SAY "1=Odonto;2=Saude"
@ 50, 49 GET _QUAL2 PICTURE "9" VALID _QUAL2$"12"

@ 60, 90 BmpButton Type 1 Action Close(oDlg2X)
Activate Dialog oDlg2X Centered

//+--------------------------------------------------------------+
//¦ Inicializa variaveis graficas                                ¦
//+--------------------------------------------------------------+

Private oFont, cCode
Private aOkImp := .f.

nHeight:=15
lBold:= .F.
lUnderLine:= .F.
lPixel:= .T.
lPrint:=.F.
nSedex := 1

oFont := TFont():New( "Arial",,nHeight,,lBold,,,,,lUnderLine )
oFont1:= TFont():New( "Times New Romam",,08,,.F.,,,,,.f. )
oFont2:= TFont():New( "Times New Romam",,10,,.t.,,,,,.f. )
oFont3:= TFont():New( "MicrogrammaDBolExt",,18,,.T.,,,,,.F. )
oFont4:= TFont():New( "MicrogrammaDMedExt",,14,,.T.,,,,,.F. )
oFont5:= TFont():New( "Baker Signet BT",,8,,.T.,,,,,.F. )
oFont6:= TFont():New( "Baker Signet BT",,12,,.T.,,,,,.F. )

oFont7 := TFont():New( "Arial",,07,,.F.,,,,,.F. )
oFont7N:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)   // VARIAVEIS NUMERICAS


oPrn := TMSPrinter():New()
oPrn:Setup()


//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,"M","",.T.)

If nLastKey == 27 .or. Lastkey() == 27
	Return
Endif

//+--------------------------------------------------------------+
//¦ Verifica Posicao do Formulario na Impressora                 ¦
//+--------------------------------------------------------------+
SetDefault(aReturn,cString)

If nLastKey == 27 .or. Lastkey() == 27
	Return
Endif


LinCab := 0
cabec1 :="RELATORIO DE PLANOS DE SAUDE"
cabec2 :="PAGINA:  "
cabec3 :=" "
cabec4 :="EMISSAO: " + DTOC(dDataBase)
cBitMap:= "LGRL01.Bmp"


//+-----------------------------------------------------------+
//¦ CRIA ARQUIVO TEMPORARIO                                   ¦
//+-----------------------------------------------------------+
// Estrutura do Arquivo Temporario

aStru := {}
aadd(aStru , {'TMP_CCU' ,'C', 09,0} )
aadd(aStru , {'TMP_DCC' ,'C', 25,0} )
aadd(aStru , {'TMP_MAT' ,'C', 06,0} )
aadd(aStru , {'TMP_NOM' ,'C', 30,2} )
aadd(aStru , {'TMP_PLA' ,'C', 02,0} )
aadd(aStru , {'TMP_VER' ,'C', 03,0} )    // VERBA
aadd(aStru , {'TMP_ENFFUN' ,'N', 12,2} )
aadd(aStru , {'TMP_ENFEMP' ,'N', 12,2} )
aadd(aStru , {'TMP_APTFUN' ,'N', 12,2} )
aadd(aStru , {'TMP_APTEMP' ,'N', 12,2} )
/*
cArqTemp := CriaTrab(aStru , .t.)
dbUseArea(.T.,,cArqTemp,'TMP',.f.)
INDEX ON TMP_CCU+TMP_MAT+TMP_PLA+TMP_VER  TO &cArqTemp
*/
oTable := FWTemporaryTable():New("TMP", aStru)
oTable:addIndex("01", {"TMP_CCU","TMP_MAT","TMP_PLA","TMP_VER"})
oTable:create()
TMP:= oTable:GetRealName()

DBSELECTAREA("TMP")
//+--------------------------------------------------------------+
//¦ Inicio do Processamento do Relatorio                         ¦
//+--------------------------------------------------------------+

Processa({|| AtualizaTMP()},"Montando Arq Temporario")



//+-----------------------------------------------------------+
//¦ Inicio do Relatorio                                       ¦
//+-----------------------------------------------------------+
Linha:=0
fImpCab()

_A1:=_B1:=_C1:=_D1:=0
_A:=_B:=_C:=_D:=0

DBSELECTAREA("TMP")
DBGOTOP()
WHILE !EOF()
	
	oPrn:Say( Linha:=Linha+35, 010 ,TMP_CCU+"-"+TMP_DCC, oFont7)
	LINHA:=LINHA + IIF(_AnaSin="A",40,00)
	_CCU:=TMP_CCU
	WHILE !EOF() .AND. TMP_CCU=_CCU
		IF _AnaSin="A"
			oPrn:Say( Linha:=Linha   , 050 ,TMP_MAT, oFont7)
			oPrn:Say( Linha:=Linha   , 200 ,TMP_NOM, oFont7)
			oPrn:Say( Linha:=Linha   , 850 ,TMP_PLA, oFont7)
			oPrn:Say( Linha:=Linha   ,1000 ,TMP_VER, oFont7)
			
			oPrn:Say( Linha:=Linha   ,1000+200 ,TRANSFORM(TMP_ENFFUN ,"@E 999,999,999.99"), oFont7n)
			oPrn:Say( Linha:=Linha   ,1300+200 ,TRANSFORM(TMP_ENFEMP ,"@E 999,999,999.99"), oFont7n)
			oPrn:Say( Linha:=Linha   ,1600+200 ,TRANSFORM(TMP_APTFUN ,"@E 999,999,999.99"), oFont7n)
			oPrn:Say( Linha:=Linha   ,1900+200 ,TRANSFORM(TMP_APTEMP ,"@E 999,999,999.99"), oFont7n)
			LINHA:=LINHA + 40
		ENDIF
		_A1:=_A1 + TMP_ENFFUN
		_B1:=_B1 + TMP_ENFEMP
		_C1:=_C1 + TMP_APTFUN
		_D1:=_D1 + TMP_APTEMP
		
		IF Linha >= 2100
			oPrn:Say( Linha+30,080 ," continua ...", oFont7)
			fImpCab()
		ENDIF
		DBSELECTAREA("TMP")
		DBSKIP()
	ENDDO
	oPrn:Say( Linha:=Linha+IIF(_AnaSin="A",50,00),1000+200 ,TRANSFORM(_A1 ,"@E 999,999,999.99"), oFont7n)   // TOTAL DO CENTRO DE CUSTO
	oPrn:Say( Linha:=Linha   ,1300+200 ,TRANSFORM(_B1 ,"@E 999,999,999.99"), oFont7n)
	oPrn:Say( Linha:=Linha   ,1600+200 ,TRANSFORM(_C1 ,"@E 999,999,999.99"), oFont7n)
	oPrn:Say( Linha:=Linha   ,1900+200 ,TRANSFORM(_D1 ,"@E 999,999,999.99"), oFont7n)
	IF _AnaSin#"A"
		oPrn:Say( Linha:=Linha+50,1150+200 ,TRANSFORM(_A1+_B1 ,"@E 999,999,999.99"), oFont7n)
		oPrn:Say( Linha:=Linha   ,1750+200 ,TRANSFORM(_C1+_D1 ,"@E 999,999,999.99"), oFont7n)
		oPrn:Say( Linha:=Linha   ,2050+200 ,TRANSFORM(_A1+_B1+_C1+_D1 ,"@E 999,999,999.99"), oFont7n)
	ELSE
		oPrn:Say( Linha:=Linha+50,1900+200 ,TRANSFORM(_A1+_B1+_C1+_D1 ,"@E 999,999,999.99"), oFont7n)
	ENDIF
	oPrn:line( Linha:=Linha+35,80,Linha,3120)     // Linha horizontal
	_A:=_A + _A1
	_B:=_B + _B1
	_C:=_C + _C1
	_D:=_D + _D1
	_A1:=_B1:=_C1:=_D1:=0
	
ENDDO
IF _A1+_B1>0   // TOTAL DO CENTRO DE CUSTO
	oPrn:Say( Linha:=Linha+50,1000+200 ,TRANSFORM(_A1 ,"@E 999,999,999.99"), oFont7n)
	oPrn:Say( Linha:=Linha   ,1300+200 ,TRANSFORM(_B1 ,"@E 999,999,999.99"), oFont7n)
	oPrn:Say( Linha:=Linha   ,1600+200 ,TRANSFORM(_C1 ,"@E 999,999,999.99"), oFont7n)
	oPrn:Say( Linha:=Linha   ,1900+200 ,TRANSFORM(_D1 ,"@E 999,999,999.99"), oFont7n)
	oPrn:Say( Linha:=Linha+50,1900+200 ,TRANSFORM(_A1+_B1+_C1+_D1 ,"@E 999,999,999.99"), oFont7n)
	oPrn:line( Linha:=Linha+25,80,Linha,3120)     // Linha horizontal
ENDIF

oPrn:Say( Linha:=Linha+50,1000+200 ,TRANSFORM(_A ,"@E 999,999,999.99"), oFont7n)
oPrn:Say( Linha:=Linha   ,1300+200 ,TRANSFORM(_B ,"@E 999,999,999.99"), oFont7n)
oPrn:Say( Linha:=Linha   ,1600+200 ,TRANSFORM(_C ,"@E 999,999,999.99"), oFont7n)
oPrn:Say( Linha:=Linha   ,1900+200 ,TRANSFORM(_D ,"@E 999,999,999.99"), oFont7n)
oPrn:Say( Linha:=Linha+50,1900+200 ,TRANSFORM(_A+_B+_C+_D ,"@E 999,999,999.99"), oFont7n)

//+--------------------------------------------------------------+
//¦                      FIM DA IMPRESSAO                        ¦
//+--------------------------------------------------------------+

oPrn:Preview()
MS_FLUSH()

oPrn:EndPage()




_GeraXls:=1
@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Gera Planilha Excel ?"
@ 10, 49 SAY "1 - Nao"
@ 22, 49 SAY "2 - Sim"
@ 44, 49 GET _GeraXls PICTURE "99"
@ 60, 90 BmpButton Type 1 Action Close(oDlg2)
Activate Dialog oDlg2 Centered

IF _GeraXls=2
	DBSELECTAREA("TMP")
	DBGOTOP()
		oFWMsExcel := FWMSExcel():New()
		oFWMsExcel:AddworkSheet("PLA")
		oFWMsExcel:AddTable("PLA",cTabela)
		oFWMsExcel:AddColumn("PLA",cTabela,"TMP_CCU",1,1)
		oFWMsExcel:AddColumn("PLA",cTabela,"TMP_DCC",1,1)
		oFWMsExcel:AddColumn("PLA",cTabela,"TMP_MAT",1,1)
		oFWMsExcel:AddColumn("PLA",cTabela,"TMP_NOM",1,1)
		oFWMsExcel:AddColumn("PLA",cTabela,"TMP_PLA",1,1)
		oFWMsExcel:AddColumn("PLA",cTabela,"TMP_VER",1,1)
		oFWMsExcel:AddColumn("PLA",cTabela,"TMP_ENFFUN",1,1)
		oFWMsExcel:AddColumn("PLA",cTabela,"TMP_ENFEMP",1,1)
		oFWMsExcel:AddColumn("PLA",cTabela,"TMP_APTFUN",1,1)
		oFWMsExcel:AddColumn("PLA",cTabela,"TMP_APTEMP",1,1)

		While TMP->(!EOF())
			oFWMsExcel:AddRow("PLA",cTabela,{TMP->TMP_CCU,TMP->TMP_DCC,TMP->TMP_MAT,TMP->TMP_NOM,;
			TMP->TMP_PLA,TMP->TMP_VER,TMP->TMP_ENFFUN,TMP->TMP_ENFEMP,TMP->TMP_APTFUN,TMP->TMP_APTEMP})
			TMP->(dbSkip())
		EndDo
		oFWMsExcel:Activate()
		oFWMsExcel:GetXMLFile(cArquivo)

		//Abrindo o excel e abrindo o arquivo xml
		oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
		oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
		oExcel:SetVisible(.T.)                 //Visualiza a planilha
		oExcel:Destroy()

//	COPY TO IMPORTA.DBF
/*	_cArqRen:="\SYSTEM\TEMPDBF\IMPORTA.DBF"
	Copy to &_cArqRen VIA "DBFCDXADS" 
	_arquivo:="G:\SYSTEM\TEMPDBF\IMPORTA.DBF"
	If !File(_arquivo)
		_arquivo:="F:\SYSTEM\TEMPDBF\IMPORTA.DBF"
	EndIf
	
	If ! ApOleClient( 'MsExcel' )
		MsgStop( 'Excel não instalado' )
	ELSE
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( _arquivo )
		oExcelApp:SetVisible(.T.)
	ENDIF
*/	
ENDIF

dbSelectArea('TMP')
dbCloseArea()
/*
cArqTemp2 := cArqTemp + '.DTC'
Delete File &cArqTemp2
cArqTemp3 := cArqTemp + '.CDX'
Delete File &cArqTemp3
*/
DBSELECTAREA("XZZ")
DBSETORDER(1)
DBCLEARFILTER()
DBGOTOP()


RETURN Nil


//*************************
Static Function AtualizaTMP()
//*************************

_ANOMES:=STRZERO(YEAR(DDATABASE),4,0)+STRZERO(MONTH(DDATABASE),2,0)
DBSELECTAREA("RHR")
DBSETORDER(1)
SET FILTER TO RHR_COMPPG=_AnoMes     // FILTRO NA TABELA RHR
DBGOTOP()

ProcRegua(RECCOUNT())

WHILE !EOF()
	
	INCPROC("Lendo : "+RHR->RHR_MAT)
    IF LEFT(RHR->RHR_PLANO,1)#_QUAL
       DBSKIP()
       Loop
    ENDIF
    IF LEFT(RHR->RHR_TPPLAN,1)#_QUAL2
       DBSKIP()
       Loop
    ENDIF

	_CCUS  :=POSICIONE("SRA",1,XFILIAL("SRA")+RHR->RHR_MAT,"RA_CC")
	
	DBSELECTAREA("TMP")
	DBSEEK(_CCUS+RHR->RHR_MAT+RHR->RHR_PLANO+RHR->RHR_PD)
	IF !FOUND()
		RECLOCK("TMP",.T.)
		TMP->TMP_CCU:=_CCUS
		TMP->TMP_DCC:=Posicione("CTT",1,xFilial("CTT")+_CCUS,"CTT_DESC01")
		TMP->TMP_MAT:=RHR->RHR_MAT
		TMP->TMP_NOM:=SRA->RA_NOME
		TMP->TMP_PLA:=RHR->RHR_PLANO
		TMP->TMP_VER:=RHR->RHR_PD
	ELSE
		RECLOCK("TMP",.F.)
	ENDIF
	IF RHR->RHR_PLANO="E1"  // ENFERMARIA
		TMP->TMP_ENFFUN:=TMP->TMP_ENFFUN+RHR->RHR_VLRFUN
		TMP->TMP_ENFEMP:=TMP->TMP_ENFEMP+RHR->RHR_VLREMP
	ELSE
		TMP->TMP_APTFUN:=TMP->TMP_APTFUN+RHR->RHR_VLRFUN
		TMP->TMP_APTEMP:=TMP->TMP_APTEMP+RHR->RHR_VLREMP
	ENDIF
	MSUNLOCK()
	
	DBSELECTAREA("RHR")
	DBSKIP()
ENDDO
DBSELECTAREA("RHR")
DBSETORDER(1)
SET FILTER TO
DBGOTOP()

RETURN

***************
STATIC FUNCTION fImpCab()
***************

oPrn:EndPage()
Linha := 0
nPag  := nPag +1

oPrn:SayBitmap( Linha+100,080,cBitMap,420,080 )
oPrn:Say( Linha:= Linha+75 ,1252  ,cabec1, oFont3)
oPrn:Say( Linha,2760 ,cabec2, oFont2)
oPrn:Say( Linha,3000 ,STR(nPag,4), oFont2)
oPrn:Say( Linha:= Linha+70, 980 ,cabec3, oFont2)
oPrn:Say( Linha           ,2760 ,cabec4, oFont2)
oPrn:Say( Linha:= Linha+25,080, "SIGA / "+nomeprog, oFont7 )

IF _AnaSin="A"
	oPrn:Say( Linha:= Linha+40,  50 ,"Matric", oFont2)
	oPrn:Say( Linha, 200 ,"Nome do Colaborador", oFont2)
	oPrn:Say( Linha, 850 ,"Plano", oFont2)
	oPrn:Say( Linha,1000 ,"Verba", oFont2)
ENDIF

oPrn:Say( Linha,1000+200 ,"Enfer.Func", oFont2)
oPrn:Say( Linha,1300+200 ,"Enfer.Alub", oFont2)
oPrn:Say( Linha,1600+200 ,"Apto.Funci", oFont2)
oPrn:Say( Linha,1900+200 ,"Apto.Aluba", oFont2)

oPrn:line( Linha:=Linha+70,80,Linha,3120)

RETURN Nil

//+--------------------------------------------------------------+
//¦ Fim da Rotina Impressao Cabecalho                            ¦
//+--------------------------------------------------------------+



