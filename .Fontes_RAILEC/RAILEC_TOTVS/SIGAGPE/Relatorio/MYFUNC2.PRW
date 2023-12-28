#include "rwmake.ch"
#include "ap5mail.ch"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function CADXZ3()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FORMULARIOS RH - MOVIMENTACOES SALARIAIS
// AUTOR : JOSE NORBERTO MACEDO
// DATA  : MAIO/2015
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
_cArea := Alias()
_nOrd  := IndexOrd()
nReg   := RecNo()

DbSelectArea("XZ3")
XZ3->(DbSetOrder(1))
XZ3->(DbGotop())
cCadastro :="XZ3 - Movimentaçôes Salariais"
aRotina   := {{ "Pesquisa ",  'AxPesqui' , 0, 1 },;
{ "Visualiza",  'AxVisual' , 0, 2 },;
{ "Inclui"   ,  'AxInclui' , 0, 3 },;
{ "Altera"   ,  'AxAltera' , 0, 4 },;
{ "Exclui"   ,  'AxDeleta' , 0, 5 },;
{ "Imp Form.",  'U_XZ3IMP' , 0, 8 },;
{ "Efetiva  ",  'U_XZ3EFE' , 0, 9 }}

mBrowse(16,00,280,350,"XZ3",,,,,,)

DbSelectArea(_cArea)
DbSetOrder(_nOrd)
DbGoTo(nReg)
Return Nil

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function XZ3EFE()    // ATUALIZA SR3, SR7 E SRA VIA XZ3
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IF !(UPPER(SUBSTR(cUsuario,7,6))$"ADMINI/MACEDO/")
   ALERT("EM DESENVOLVIMENTO")
ENDIF


_TIPO:=XZ3->XZ3_TPAUM
_DATA:=DDATABASE-DAY(DDATABASE)+1

@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Parametros"
@ 12, 05 SAY "Tipo do Aumento"
@ 12, 65 GET _TIPO PICTURE "999" F3 "41" VALID NAOVAZIO() 
@ 22, 05 SAY "Data do Aumento"
@ 22, 65 GET _DATA SIZE 35,15 VALID NAOVAZIO() 

@ 60, 90 BmpButton Type 1 Action Close(oDlg2)
Activate Dialog oDlg2 Centered

IF MsgYesNo("Confirma efetivação do Aumento ? Matr: "+XZ3->XZ3_MAT,"Atenção")
   IF _TIPO#XZ3_TPAUM
	   RECLOCK("XZ3",.F.)
	   XZ3_TPAUM:=_TIPO
	   MSUNLOCK()
   ENDIF
   
	_NOVOSAL:=.F.
	DBSELECTAREA("SRA")
   DBSETORDER(1)
   DBSEEK(xFilial("SRA")+XZ3->XZ3_MAT)
	IF FOUND() .AND. XZ3->XZ3_SAL2>SRA->RA_SALARIO
      IF XZ3->CDEP2#SRA->RA_CC      // ************** ALTERAÇÃO DE CENTRO DE CUSTO NAO PODE SER FEITA NESSA ROTINA
         ALERT("Faça primeiramente a transferencia para o novo ccusto e depois efetive o aumento!")
         RETURN Nil
      ENDIF

      //********************************* ACERTA CADASTRO DE FUNCIONARIO
		RECLOCK("SRA",.F.)
		SRA->RA_ANTEAUM:=RA_SALARIO
		SRA->RA_SALARIO:=XZ3->XZ3_SAL2
      IF XZ3->XZ3_CFUN2#SRA->RA_CODFUNC
		   SRA->RA_CODFUNC:=XZ3->XZ3_CFUN2
		ENDIF   
      IF XZ3->XZ3_CCAR2#SRA->RA_CARGO
		   SRA->RA_CARGO  :=XZ3->XZ3_CCAR2
		ENDIF   
		MSUNLOCK()
		_NOVOSAL:=.T.
      MsgInfo("Cadastro do Funcionario atualizado com suceso !","Atenção")
	ENDIF
	

	IF _NovoSal       // SE HOUVE ALTERAÇÃO DE SALARIO, DEVE-SE AJUSTAR OS TABELAS DE HISTOTICO SALARIAL
		DBSELECTAREA("SR7")
		RECLOCK("SR7",.T.)
      R7_FILIAL:=xFilial("SR7")
      R7_MAT    :=SRA->RA_MAT
      R7_DATA   :=_Data
      R7_TIPO   :=_Tipo
      R7_FUNCAO :=XZ3->XZ3_CFUN2
      R7_TIPOPGT:=SRA->RA_TIPOPGT
      R7_CATFUNC:=SRA->RA_CATFUNC
      R7_USUARIO:=SUBSTR(cUsuario,7,15)
      R7_SEQ    :="1"
      R7_CARGO  :=XZ3->XZ3_CCAR2

      R7_DESCFUN:=POSICIONE("SRJ",1,XFILIAL("SRJ")+XZ3->XZ3_CFUN2,"RJ_DESC")
      R7_DESCCAR:=Substr(fDesc("SQ3",XZ3->XZ3_CCAR2,"SQ3->Q3_DESCSUM"),1,40)
		MSUNLOCK()
		
		DBSELECTAREA("SR3")
		RECLOCK("SR3",.T.)
      R3_FILIAL :=xFilial("SR3")
      R3_DATA   :=_Data
      R3_MAT    :=SRA->RA_MAT
      R3_TIPO   :=_Tipo
      R3_PD     :="000"
      R3_DESCPD :="SALARIO BASE"
      R3_VALOR  :=XZ3->XZ3_SAL2
      R3_SEQ    :="1"
      R3_ANTEAUM:=XZ3->XZ3_SAL2
		MSUNLOCK()
      MsgInfo("Historico Salarial atualizado com suceso !","Atenção")

	ENDIF
ENDIF

RETURN Nil

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function XZ3IMP()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

nOrdem :=0
Z:=0
M:=0
tamanho:="M"
limite:=220
titulo   := PADC("MOVIMENTAÇÃO DE PESSOAL",74)
cDesc1   := PADC(" ",74)
cDesc2   := PADC(" ",74)
cDesc3   := PADC(" ",74)
cNatureza:=""
aReturn  := { "Especial", 1,"Administracao", 2, 2, 1,"",1 }
nPag     := 0
nomeprog := "XZ3IMP"
cPerg    := ""
wnrel    := SUBSTR(CUSUARIO,7,3)+"_XZ3IMP"
nLastKey := 0
lContinua:= .T.
nLin     := 0

_TXCORREA:= 0
_TXJURREA:= 0
_QUAL    := ""



_TIPO:="N"
_DIRET:="1"
_XDIRET:="DIRETORIA EXECUTIVA"

@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Modelo:"
@ 10, 05 SAY "N=Normal ou I-Industria ?"
@ 20, 30 GET _TIPO PICTURE "!" VALID _TIPO$"NI"
@ 30, 05 SAY "Diret: 1-Exec; 2-Ind; 3-Adm; 4-Com; 5-Fin; 6-ConAdm ?"
@ 40, 30 GET _DIRET PICTURE "9" VALID _DIRET$"123456"

@ 60, 90 BmpButton Type 1 Action Close(oDlg2)
Activate Dialog oDlg2 Centered

IF _DIRET="2"
   _XDIRET:="DIRETORIA INDUSTRIAL"
   ELSEIF _DIRET="3"
   _XDIRET:="DIRETORIA ADMINISTRATIVA"
   ELSEIF _DIRET="4"
   _XDIRET:="DIRETORIA COMERCIAL"
   ELSEIF _DIRET="5"
   _XDIRET:="DIRETORIA FINANCEIRA"
   ELSEIF _DIRET="6"
   _XDIRET:="CONSELHO DE ADMINISTRAÇÃO"      
ENDIF   
   
//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas                                      ¦
//+-------------------------------------------------------------------------+
_INI:=_FIM:=XZ3->XZ3_MAT

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
oFont9a :=TFont():New( "Times New Roman"   ,,12,,.F.,,,,,.F. )
oFont9b :=TFont():New( "Arial"   ,,12,,.T.,,,,,.F. )
oFont9b2:=TFont():New( "Arial"   ,,11,,.F.,,,,,.F. )
oFont9b3:=TFont():New( "Arial"   ,,08,,.F.,,,,,.F. )
oFont9C :=TFont():New( "Arial"   ,,18,,.T.,,,,,.F. )

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
cabec1 :=" "
cabec2 :=" "
cabec3 :=" "
cabec4 :=" "
cBitMap:= "ALUBAR.Bmp"


_FIM:=_INI
//+-----------------------------------------------------------+
//¦ Inicio do Relatorio                                       ¦
//+-----------------------------------------------------------+

DBSELECTAREA("SRA")
DBSETORDER(1)
DBSEEK(XFILIAL("SRA")+_INI)
IF FOUND()
	oPrn:EndPage()
	Linha := 70
	nPag  := nPag +1
	
   oPrn:SayBitmap( Linha+050,080,cBitMap,300,180 )
	
	oPrn:Say(Linha+150,700,"MOVIMENTAÇÃO DE PESSOAL" , oFont9C)

	_SALTO:=60
	oPrn:Box( Linha:=Linha+300,80,Linha+220, 810)   // BOX 
	oPrn:Box( Linha          ,820,Linha+220,1580)   // BOX 
	oPrn:Box( Linha         ,1590,Linha+220,2290)   // BOX 
	oPrn:Say(Linha:=Linha+50      ,100 ,"DIVISAO EMITENTE"             , oFont9B)
	oPrn:Say(Linha:=Linha          ,830 ,"LOCAL DE TRABALHO"        , oFont9B)
	oPrn:Say(Linha:=Linha          ,1600,"DATA DE EMISSAO"        , oFont9B)
	oPrn:Say(Linha:=Linha+_SALTO   ,100 ,SM0->M0_NOMECOM , oFont9a)
	oPrn:Say(Linha:=Linha          ,830 ,SM0->M0_CIDCOB , oFont9a)
	oPrn:Say(Linha:=Linha          ,1600,DTOC(XZ3->XZ3_DATA) , oFont9a)

	oPrn:Box( Linha:=Linha+150,80,Linha+250,2290)   // BOX 
	oPrn:Say(Linha:=Linha+50          ,900 ,"TIPO DE MOVIMENTAÇÃO"        , oFont9B)

	oPrn:Box( Linha:=Linha+110  ,080+20,Linha+80, 140+20)   // BOX 
	oPrn:Box( Linha  ,630,Linha+80, 690)   // BOX 
	oPrn:Box( Linha  ,1280+20,Linha+80,1340+20)   // BOX 
	oPrn:Box( Linha  ,1820,Linha+80,1880)   // BOX 
   
   IF XZ3->XZ3_TIPO="01 "
	   oPrn:Say(Linha+10          , 120 ,"**" , oFont9a)
	  ELSEIF XZ3->XZ3_TIPO="02 "
	   oPrn:Say(Linha+10          , 640 ,"**" , oFont9a)
	  ELSEIF XZ3->XZ3_TIPO="03 "
	   oPrn:Say(Linha+10          ,1290+20 ,"**" , oFont9a)
	  ELSEIF XZ3->XZ3_TIPO="04 "
	   oPrn:Say(Linha+10          ,1830 ,"**" , oFont9a)
   ENDIF
   
	oPrn:Say(Linha+10          , 160+20 ,"SALARIAL" , oFont9a)
	oPrn:Say(Linha+10          , 710 ,"SALARIAL E FUNCIONAL" , oFont9a)
	oPrn:Say(Linha+10          ,1360+20 ,"AJUSTE FUNCIONAL" , oFont9a)
	oPrn:Say(Linha+10          ,1900 ,"TRANSFERÊNCIA" , oFont9a)

//	oPrn:Say(Linha:=Linha+_SALTO+30   ,830 ,XZ3->XZ3_TIPO+"-"+SubStr(SX5->X5_DESCRI,1,40) , oFont9a)

	oPrn:Box( Linha:=Linha+110,80,Linha+200,1580)   // BOX 
	oPrn:Box( Linha              ,1590,Linha+200,2290)   // BOX 
	oPrn:Say(Linha:=Linha+_SALTO ,100 ,"NOME"             , oFont9B)
	oPrn:Say(Linha:=Linha          ,1600,"MATRÍCULA"        , oFont9B)
	oPrn:Say(Linha:=Linha+_SALTO   ,100 ,XZ3->XZ3_NOME , oFont9a)
	oPrn:Say(Linha:=Linha          ,1600,XZ3->XZ3_MAT , oFont9a)

	//	oPrn:line( Linha:=Linha+50   ,  80 ,Linha,2260)     // Linha horizontal
	
	LINHA   :=LINHA+100
	oPrn:Box( Linha:=Linha+10,80,Linha+2150,2290)   // BOX GRANDE

	oPrn:Say(  LINHA:=Linha+40 , 1000,  "SITUAÇÃO ATUAL"  , oFont9B )
	oPrn:line( Linha+50   ,  80 ,Linha+50,2290)     // Linha horizontal
	LINHAINI:=LINHA+50

	oPrn:Say(Linha:=Linha+_SALTO*2   ,100 ,"CARGO"        , oFont9B)
	oPrn:Say(Linha:=Linha          ,830 ,"FUNÇÃO"         , oFont9B)
	oPrn:Say(Linha:=Linha+_SALTO   ,100 ,XZ3->XZ3_CAR1, oFont9a)
	oPrn:Say(Linha:=Linha          ,830 ,XZ3->XZ3_FUN1, oFont9a)

	oPrn:line( Linha+50   ,  80 ,Linha+50,2290)     // Linha horizontal

	oPrn:Say(Linha:=Linha+_SALTO*2   ,100 ,"SALÁRIO"        , oFont9B)
	oPrn:Say(Linha:=Linha          ,830 ,"CENTRO DE CUSTO"  , oFont9B)
	oPrn:Say(Linha:=Linha          ,1600,"DATA DE ADMISSÃO"  , oFont9B)
	oPrn:Say(Linha:=Linha+_SALTO   ,100 ,TRANSFORM(XZ3->XZ3_SAL1 ,"@EZ 99,999,999.99"), oFont9a)
	oPrn:Say(Linha:=Linha          ,830 ,ALLTRIM(XZ3->XZ3_CC)+" - "+Posicione("CTT",1,xFilial("CTT")+XZ3->XZ3_CC,"CTT_DESC01"), oFont9a)
	oPrn:Say(Linha:=Linha          ,1600,DTOC(XZ3->XZ3_ADM), oFont9a)

	oPrn:line( Linha+100   ,  80 ,Linha+100,2290)     // Linha horizontal
	oPrn:line( LINHAINI   , 820 ,Linha+100, 820)      // Linha VERTICAL
	oPrn:line( LINHAINI   ,1590 ,Linha+100,1590)      // Linha VERTICAL

//************************************************************************************
	oPrn:Say(Linha:=Linha+120    , 950,  "SITUAÇÃO PROPOSTA"  , oFont9B )
	oPrn:line( Linha+50   ,  80 ,Linha+50,2290)     // Linha horizontal
	LINHAINI:=LINHA+50

	oPrn:Say(Linha:=Linha+_SALTO*2   ,100 ,"CARGO"        , oFont9B)
	oPrn:Say(Linha:=Linha          ,830 ,"FUNÇÃO"       , oFont9B)
//	oPrn:Say(Linha:=Linha          ,1600,"DEPARTAMENTO" , oFont9B)
	
	oPrn:Say(Linha:=Linha+_SALTO   ,100 ,XZ3->XZ3_CAR2, oFont9a)
	oPrn:Say(Linha:=Linha          ,830 ,XZ3->XZ3_FUN2, oFont9a)
//	oPrn:Say(Linha:=Linha          ,1600,XZ3->XZ3_DEP2, oFont9a)

	oPrn:line( Linha+50   ,  80 ,Linha+50,2290)     // Linha horizontal

	oPrn:Say(Linha:=Linha+_SALTO*2   ,100 ,"SALÁRIO"        , oFont9B)
	oPrn:Say(Linha:=Linha          ,830 ,"CENTRO DE CUSTO"       , oFont9B)
	oPrn:Say(Linha:=Linha          ,1600,"% AJUSTE / ENQUADRAMENTO" , oFont9B)
	oPrn:Say(Linha:=Linha+_SALTO   ,100 ,TRANSFORM(XZ3->XZ3_SAL2 ,"@EZ 99,999,999.99"), oFont9a)
	oPrn:Say(Linha:=Linha          ,830 ,XZ3->XZ3_DEP2, oFont9a)
	oPrn:Say(Linha:=Linha          ,1600,TRANSFORM(XZ3->XZ3_PERC ,"@EZ 999,999.99"), oFont9a)

   oPrn:line( Linha:=Linha+60,80,Linha,2290)     // Linha horizontal

	oPrn:line( LINHAINI   , 820 ,Linha, 820)      // Linha VERTICAL
	oPrn:line( LINHAINI   ,1590 ,Linha,1590)      // Linha VERTICAL

	oPrn:Say(Linha:=Linha+30    , 1000,  "APROVAÇÕES"  , oFont9B )
	oPrn:line( LINHA:=Linha+70   ,  80 ,Linha,2290)     // Linha horizontal

   IF _TIPO="N"
   linhaini:=Linha
   oPrn:Say(  LINHA:=Linha+30 , 100,  "GERENTE DA AREA"  , oFont9B2 )
   oPrn:Say(  Linha , 830, "DATA:"  , oFont9B2 )
   oPrn:Say(  Linha ,1350, "GESTÃO DE PESSOAS"  , oFont9B2 )
   oPrn:Say(  Linha ,1980, "DATA:"  , oFont9B2 )
   oPrn:line( Linha:=Linha+180,80,Linha,2290)     // Linha horizontal
	oPrn:line( LINHAINI   ,820 ,Linha,820)      // Linha VERTICAL
	oPrn:line( LINHAINI   ,1340,Linha,1340)      // Linha VERTICAL

   oPrn:Say(  LINHA:=Linha+30 , 100,  _XDIRET  , oFont9B )
   oPrn:Say(  Linha , 1980, "DATA: "  , oFont9B2 )
   oPrn:line( Linha:=Linha+180,80,Linha,2290)     // Linha horizontal
	oPrn:line( LINHAINI   ,1970 ,Linha,1970)      // Linha VERTICAL
   ELSE
   linhaini:=Linha
   oPrn:Say(  LINHA:=Linha+30 , 100,  "GERENTE SOLICITANTE"  , oFont9B2 )
   oPrn:Say(  Linha , 830, "DATA:"  , oFont9B2 )
   oPrn:Say(  Linha ,1300, "GESTÃO DE PESSOAS"  , oFont9B2 )
   oPrn:Say(  Linha ,1930, "DATA:"  , oFont9B2 )
   oPrn:line( Linha:=Linha+180,80,Linha,2290)     // Linha horizontal

	oPrn:line( LINHAINI   ,820 ,Linha,820)      // Linha VERTICAL
	oPrn:line( LINHAINI   ,1290,Linha,1290)      // Linha VERTICAL

   oPrn:Say(  LINHA:=Linha+30 , 100,  _XDIRET  , oFont9B )
   oPrn:Say(  Linha , 1980, "DATA:"  , oFont9B2 )

   oPrn:line( Linha:=Linha+180,80,Linha,2290)     // Linha horizontal
   oPrn:line( LINHAINI   ,1920,Linha,1920)      // Linha VERTICAL
   
   ENDIF

	DBSELECTAREA("SRA")
	LINHA:=LINHA+30
	oPrn:Say( Linha+10 , 1000,  "OBSERVAÇÕES"  , oFont9B )      // BOX RODAPE (FINAL)
   oPrn:line( Linha:=Linha+60,80,Linha,2290)     // Linha horizontal
	LINHA:=LINHA+60

//   oPrn:Say( LINHA:=Linha+50 , 100,  XZ3->XZ3_OBS , oFont9B3 )    // CAMPO NOVO XZ3_OBSERV
//   oPrn:Say( LINHA:=Linha+40 , 100,  XZ3->XZ3_OBS2, oFont9B3 )
//   oPrn:Say( LINHA:=Linha+40 , 100,  XZ3->XZ3_OBS3, oFont9B3 )
   IF !EMPTY(XZ3->XZ3_OBSERV)
		cString:=XZ3->XZ3_OBSERV
		lWrap:=.T.
		A=MLCOUNT(cString,100,,lWrap)
		FOR I:=1 TO A
			oPrn:Say(  Linha:=Linha+45 ,140,MEMOLINE(cString,100,I,,lWrap)               , oFont9a)
			IF LINHA>3000
				oPrn:EndPage()
				Linha := 0
				nPag  := nPag +1
				oPrn:Say( Linha :=Linha+75   ,0600 ,"      pag: "+STRZERO(nPag,2,0), oFont9b3)
				oPrn:line( Linha:=Linha+65   ,  80 ,Linha,2260)     // Linha horizontal
				oPrn:Box( Linha:=Linha+100,  80,Linha+62,2260) // BOX DE FORA
				oPrn:Say(  Linha:=Linha+17,110,"OBSERVAÇÕES    (continuação)"                        , oFont9b2)
			ENDIF
		NEXT I
   ENDIF

ENDIF

oPrn:Preview()
MS_FLUSH()

oPrn:EndPage()



RETURN Nil














//*********************************************************************
user function GP690SAL()   // PONTO DE ENTRADA PARA DISSIDIO RETROATIVO

//ALERT("OI 1")

RETURN 

user function GPM690PERC()   // PONTO DE ENTRADA PARA DISSIDIO RETROATIVO

//ALERT("OI 2")

RETURN 
//*********************************************************************


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
user function Gp010ValPE()   // PONTO DE ENTRADA PARA VALIDAR INCLUSAO E ALTERACAO NO CAD FUNCIONARIOS
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
aVetorFunc := {} // Vetor das Alterações Salariais
//  1o Elemento - Matricula do Funcinario
//  2o Elemento - Data da Alteração Salarial
//  3o Elemento - Nome do Funcionario
//  4o Elemento - Valor Anterior.
//  5o Elemento - Valor Alterado.
//  6o Elemento - Cod. da Função
//  7o Elemento - Cod. do Motivo
//  8o Elemento - Cod. Centro de Custo

_PROD:=""
_PROD2:=""
IF ALTERA .AND. !EMPTY(M->RA_DATAALT)              // ALTEROU SALARIO INFORMANDO A DATA DE ALTERACAO SALARIAL
	cTitulo1 := "Alteracao de Funcao ou Salario - Para Aprovacao."
	_FUNC:=ALLTRIM(POSICIONE("SRJ",1,XFILIAL("SRJ")+M->RA_CODFUNC,"RJ_DESC"))
	
	_PROD:=(M->RA_MAT+"-"+SUBSTR(M->RA_NOME,1,30)+"__ Funcao:_"+_FUNC  +CHR(13) + CHR(10))
	_PROD:=_PROD+("Salario :"+Transform(M->RA_SALARIO,"@E 999,999.99") +CHR(13) + CHR(10))
	_PROD:=_PROD+("Data Mov:"+DTOC(M->RA_DATAALT) +CHR(13) + CHR(10))
	_PROD:=_PROD+("Feito Em:"+DTOC(DDATABASE) +CHR(13) + CHR(10))
	_PROD:=_PROD+("Usuario :"+SUBSTR(CUSUARIO,7,15) +CHR(13) + CHR(10))
	ALERT(_PROD)
	
	
	DbSelectArea("SR3") //Historicos Valores monta _PROD2
	DbSetOrder(1)
	DbSeek(xFilial("SR3") +M->RA_MAT)
	cValAnt := 0
	While !Eof() .and. M->RA_MAT == SR3->R3_MAT
		IF !(R3_PD$"000/001") // SOMENTE CONSIDERAR SALARIO BASE
			DbSkip()
			Loop
		Endif
		IF YEAR(R3_DATA)<2011              // CONSIDERA SOMENTE 2011 EM DIANTE - AMC
			DbSkip()
			Loop
		Endif

		cValAnt := If(cValAnt==0,SR3->R3_VALOR,cValAnt)
		SR7->(DbSelectArea("SR7")) //Historico Alterações
		SR7->(DbSeek(xFilial("SR3") + SR3->R3_MAT+DTOS(SR3->R3_DATA)+SR3->R3_TIPO))
		aAdd(aVetorFunc, {SR3->R3_MAT,DTOS(SR3->R3_DATA),M->RA_NOME,cValAnt,SR3->R3_VALOR,SR7->R7_FUNCAO,SR3->R3_TIPO,M->RA_CC})
		cValAnt := SR3->R3_VALOR
		DbSkip()
	Enddo
	// Classificação : Centro de Custo + Nome + Data Alteração
	aSort(aVetorFunc,,, {| X, Y | X[2] < Y[2]})
	For nCt := 1 to Len(aVetorFunc)
		_PERCENT:=((aVetorFunc[nCt,5]-aVetorFunc[nCt,4])/aVetorFunc[nCt,4])*100
		IF _PERCENT<=0
			nCT++
			Loop
		ENDIF
		_FUNC:="_("+SUBSTR(POSICIONE("SRJ",1,xFilial("SRJ") + aVetorFunc[nCt,6], "RJ_DESC"),1,25)+")"
		_PROD2:=_PROD2+ ("Data : "+ DTOC(STOD(aVetorFunc[nCt,2]))+_FUNC +CHR(13) + CHR(10))
		_PROD2:=_PROD2+ ("R$ Anter : "+ Transform(aVetorFunc[nCt,4],"@E 999,999.99")+"__Novo Sal: "+Transform(aVetorFunc[nCt,5],"@E 999,999.99")+"__ Perc : "+Transform(_Percent,"@E 999.999")+"__"+SUBSTR(Tabela("41",aVetorFunc[nCt,7]),1,12) +CHR(13) + CHR(10))
	Next
	
ENDIF
IF !EMPTY(_Prod)
	ENV_GERRH()    // ENVIA PARA GERENCIA DE REC HUMANOS
ENDIF

RETURN .T.

//*************************
STATIC FUNCTION ENV_GERRH()
//*************************

Local lResult   := .f.				// Resultado da tentativa de comunicacao com servidor de E-Mail
Local lRelauth := GetNewPar("MV_RELAUTH",.F.)		// Parametro que indica se existe autenticacao no e-mail
Local cEmailTo
Local cEmailBcc:= ""
Local cError   := ""
Local lRelauth := GetNewPar("MV_RELAUTH",.F.)		// Parametro que indica se existe autenticacao no e-mail
Local lRet	   := .F.
Local cFrom	   := GetMV("MV_RELACNT")
Local cConta   := GetMV("MV_RELACNT")
Local cSenhaX  := GetMV("MV_RELPSW")
Local lFirst   := .T.
Local cRotina  := "U_"+ProcName(7)


cEmailTo :="ana.carolina@alubar.net,amanda.lacerda@alubar.net"
//cEmailTo := "jose.macedo@alubar.net"
IF EMPTY(cEmailTo)
	RETURN
ENDIF

cMensagem:=           CHR(13) + CHR(10)
cMensagem:= cMensagem + "                             "+CHR(13) + CHR(10)

cMensagem:= cMensagem + cTitulo1   +CHR(13) + CHR(10)
cMensagem:= cMensagem + "                             "+CHR(13) + CHR(10)
cMensagem:= cMensagem + _PROD
cMensagem:= cMensagem + "                             "+CHR(13) + CHR(10)
cMensagem:= cMensagem + "HISTORICO "+CHR(13) + CHR(10)
cMensagem:= cMensagem + _PROD2

cAnexo:= ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tenta conexao com o servidor de E-Mail ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CONNECT SMTP                         ;
SERVER 	 GetMV("MV_RELSERV"); 	// Nome do servidor de e-mail
ACCOUNT  GetMV("MV_RELACNT"); 	// Nome da conta a ser usada no e-mail
PASSWORD GetMV("MV_RELPSW") ; 	// Senha
RESULT   lResult             	// Resultado da tentativa de conexão

// Se a conexao com o SMPT esta ok
If lResult
	
	// Se existe autenticacao para envio valida pela funcao MAILAUTH
	If lRelauth
		lRet := Mailauth(cConta,cSenhaX)
	Else
		lRet := .T.
	Endif
	
	If lRet
		SEND MAIL FROM 	cFrom ;
		TO 				cEmailTo;
		BCC     		cEmailBcc;
		SUBJECT 		cTitulo1;
		BODY 			cMensagem;
		RESULT lResult
		
		
		If !lResult
			GET MAIL ERROR cError
			MsgStop("Erro no envio de e-mail 01","erro de envio 01")
		ELSE
			DISCONNECT SMTP SERVER
		Endif
	Else
		GET MAIL ERROR cError
		MsgStop("Erro de autenticação","Verifique a conta e a senha para envio")
	Endif
	
	DISCONNECT SMTP SERVER
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	MsgStop("Erro de CONEXAO COM SMTP","ERRO DE CONEXAO COM SMTP...")
Endif


Return
//************************************************************ FIM AVISA A GERENCIA DE REC HUMANOS

