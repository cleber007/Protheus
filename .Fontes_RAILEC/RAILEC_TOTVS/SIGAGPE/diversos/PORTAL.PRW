#include "rwmake.ch"

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    Ё GPER020  Ё Autor Ё R.H. - Ze Maria       Ё Data Ё 03.03.95 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Relacao de Liquidos                                        Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё GPER020(void)                                              Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁParametrosЁ                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё Generico                                                   Ё╠╠
╠╠цддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё         ATUALIZACOES SOFRIDAS DESDE A CONSTRU─AO INICIAL.             Ё╠╠
╠╠цддддддддддддбддддддддбддддддбдддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁProgramador Ё Data   Ё BOPS Ё  Motivo da Alteracao                     Ё╠╠
╠╠цддддддддддддеддддддддеддддддедддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Aldo       Ё30/03/99Ё------Ё Passagem de nTamanho para SetPrint().    Ё╠╠
╠╠Ё Kleber     Ё26/05/99Ё------Ё Tirar de uso a fun┤фo REPORTINI.         Ё╠╠
╠╠Ё Marinaldo  Ё06/06/00Ё------Ё Tipo de Impressao: Analitica/Sintetica   Ё╠╠
╠╠Ё Emerson    Ё23/07/00Ё------Ё Testar acesso de usuario/Tirar parte DOS Ё╠╠ 
╠╠Ё Mauro      Ё25/09/00Ё------Ё Acerto quebra total da Filial.			  Ё╠╠
╠╠юддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
User Function GPER020E()
Local cSavCur1,cSavRow1,cSavCol1,cSavCor1,cSavScr1,cSavScr2//,CbTxt // Ambiente
Local cString:="SRA"        // alias do arquivo principal (Base)

Local	aOrd	:=	{	"Filial+Matricula",;
						"Filial+Bco+Cc+Mat",;
						"Filial+Nome",;
						"Filial+Bco+Cta",;
						"Filial+Bco+Cc+Nome",;
						"Bco+Matric",;
						"Bco+Cc+Mat",;
						"Bco+Nome",;	
						"Bco+Cta",;
						"Bco+Cc+Nome"}
Local	cDesc1	:=	"Relacao de Liquidos."
Local	cDesc2	:=	"Sera impresso de acordo com os parametros solicitados pelo"
Local	cDesc3	:=	"usuario."

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define Variaveis Locais (Programa)                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//Local aCodigosAdt:={}
//Local aCodFol:={}

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define Variaveis Private(Basicas)                            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Private aReturn := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
Private nomeprog:="GPER020E"
Private aLinha  := { },nLastKey := 0
Private cPerg   :="" //"GPE020"
Private nExtra, AgeAnt
PRIVATE aMeses:= {"JANEIRO","FEVEREIRO","MARCO","ABRIL","MAIO","JUNHO","JULHO","AGOSTO","SETEMBRO","OUTUBRO","NOVEMBRO","DEZEMBRO"}
Private _nTotFun := _nTotVlr := 0
Private _nAno    := _nMes    := 0
Private _cAno    := _cMes    := _cMesAno := ""

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define Variaveis Private(Programa)                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
private Quebloc := Quebloc1 := .T.
Private cIndCond
Private cFor
Private nOrdem
Private aInfo:={}

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis Utilizadas na funcao IMPR                          Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Private Titulo
Private AT_PRG  := "GPER020E"
Private cCabec
Private wCabec0 := 3
//Private wCabec1:="                                                                                                                    "
//Private wCabec2:="                            |-------------  F U N C I O N A R I O  -------------|                                   "
//Private wCabec3:="FIL. BANCO      CCUSTO      MATRIC. NOME                             C O N T A            V A L O R                 "
Private wCabec1:="-------------------------------------------------------------------------------------------------------------------------------------"
Private wCabec2:="FAVORECIDO                                 CPF                BCO   AGENCIA   C O N T A        V A L O R                             "
Private wCabec3:="-------------------------------------------------------------------------------------------------------------------------------------"

Private CONTFL:=1
Private LI:=0
Private nTamanho:="M"

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica as perguntas selecionadas                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//pergunte("GPE020",.F.)
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis utilizadas para parametros                         Ё
 _par01 :="N"       //  Adiantamento                             Ё
 _par02 :="N"       //  Folha                                    Ё
 _par03 :="N"       //  1╕Parc. 13╖ Sal═rio                      Ё
 _par04 :="N"       //  2╕Parc. 13╖ Sal═rio                      Ё
 _par05 :="N"       //  F┌rias                                   Ё
 _par06 :="N"       //  Extras                                   Ё
 _par07 :="01"       //  Numero da Semana                         Ё
 _par08 :="A"        //  Qto. a Conta Corrente                    Ё
 _par09 :="00"       //  Filial  De                               Ё
 _par10 :="ZZ"       //  Filial  Ate                              Ё
 _par11 :="000000000"       //  Centro de Custo De                       Ё
 _par12 :="ZZZZZZZZZ"       //  Centro de Custo Ate                      Ё
 _par13 :="        "       //  Banco /Agencia De                        Ё
 _par14 :="ZZZZZZZZ"       //  Banco /Agencia Ate                       Ё
 _par15 :="000000"       //  Matricula De                             Ё
 _par16 :="999999"       //  Matricula Ate                            Ё
 _par17 :="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"       //  Nome De                                  Ё
 _par18 :="ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"       //  Nome Ate                                 Ё
 _par19 :="            "       //  Conta Corrente De                        Ё
 _par20 :="ZZZZZZZZZZZZ"       //  Conta Corrente Ate                       Ё
 _par21 :=" A*F*"       //  Situacao                                 Ё
 _par22 :="N"       //  Tarefeiros Mensalistas                   Ё
 _par23 :="S"       //  Totalizar por Filial                     Ё
 _par24 :="S"       //  Imprime Filial em Outra Pagina           Ё
 _par25 :="S"       //  Mostrar Nomes dos Funcionarios           Ё
 _par26 :=DDATABASE-DAY(DDATABASE)+1       //  Data Inicio De                           Ё
 _par27 :=DDATABASE       //  Data Inicio Ate                          Ё
 _par28 :="N"       //  Quebra Pagina p/Agencia   Sim,Nao        Ё
 _par29 :="MHE"       //  Categorias                               Ё
 _par30 :="A"       //  Tipo de Relacao:1-Analitica, 2-Sintetica Ё
 _par35 :="BANCO"       //  Numero da Carta Controle Envio ao Banco  Ё

//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

@ 1,1 to  600,900 DIALOG oDlg2 TITLE "Parametros"
@ 10, 05 SAY "Adto ?"
@ 10, 55 GET _PAR01 VALID _PAR01$"SN"
@ 20, 05 SAY "Folha ?"
@ 20, 55 GET _PAR02 VALID _PAR02$"SN"
@ 30, 05 SAY "1a PARC ?"
@ 30, 55 GET _PAR03 VALID _PAR03$"SN"
@ 40, 05 SAY "2a PARC ?"
@ 40, 55 GET _PAR04 VALID _PAR04$"SN"
@ 50, 05 SAY "Ferias ?"
@ 50, 55 GET _PAR05 VALID _PAR05$"SN"
@ 60, 05 SAY "Extras ?"
@ 60, 55 GET _PAR06 VALID _PAR06$"SN"
@ 80, 05 SAY "Cta Com Sem Ambas ?"
@ 80, 55 GET _PAR08 VALID _PAR08$"CSA" 
@ 90, 05 SAY "Data"
@ 90, 55 GET _PAR26 SIZE 35,15 
@ 90, 115 GET _PAR27 SIZE 35,15
@100, 05 SAY "Bco/Age:"
@100, 55 GET _PAR13 SIZE 35,15 
@100, 115 GET _PAR14 SIZE 35,15
@110, 05 SAY "Conta:"
@110, 55 GET _PAR19 SIZE 35,15 
@110, 115 GET _PAR20 SIZE 35,15


@ 60, 115 BmpButton Type 1 Action Close(oDlg2)
Activate Dialog oDlg2 Centered


//********************************

cTit := "RELACAO DE LIQUIDOS"

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Envia controle para a funcao SETPRINT                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
wnrel:="GPER020E"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Carregando variaveis mv_par?? para Variaveis do Sistema.     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
nOrdem		:= aReturn[8]

lAdianta	:= If(_par01 == "S",.T.,.F.)
lFolha		:= If(_par02 == "S",.T.,.F.)
lPrimeira	:= If(_par03 == "S",.T.,.F.)
lSegunda	:= If(_par04 == "S",.T.,.F.)
lFerias		:= If(_par05 == "S",.T.,.F.)
lExtras		:= If(_par06 == "S",.T.,.F.)
Semana		:= _par07
ComConta	:= _par08 //If(_par08 == 1,"C",(If(_par08 == 2,"S","A")))
FilialDe	:= _par09
FilialAte	:= _par10
CcDe		:= _par11
CcAte		:= _par12
BcoDe		:= _par13
BcoAte		:= _par14
MatDe		:= _par15
MatAte		:= _par16
NomDe		:= _par17
NomAte		:= _par18
CtaDe		:= _par19
CtaAte		:= _par20
cSituacao	:= _par21
TarSem		:= _par22
Quebloc		:= If(_par23 == "S",.T.,.F.) //_par23
cSalta		:= _par24
LstNome		:= _par25
dDataDe		:= _par26
dDataAte	:= _par27
cSaltaAg	:= _par28
cCategoria	:= _par29
cTipoRel	:= _par30
cCarta   	:= _PAR35
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё  Pega descricao da semana                                    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cCabec := " "

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Nao imprime Quando Relacao Sintetica.                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
IF cTipoRel == "S"
	wCabec2 := ""
EndIF	

Titulo      := "AUTORIZACAO PARA LIBERACAO DE CREDITO"
If lAdianta
	Titulo2 := SPACE(35)  + "REFERENTE A ADIANTAMENTO QUINZENAL"
Elseif lFolha       
	Titulo2 := SPACE(38)  + "REFERENTE A SALDO DE SALARIO"
Elseif lPrimeira     
	Titulo2 := SPACE(33)  + "REFERENTE A 1a. PARCELA DO 13o SALARIO"
Elseif lSegunda      
	Titulo2 := SPACE(33)  + "REFERENTE A 2a. PARCELA DO 13o SALARIO"
Elseif lFerias      
	Titulo2 := SPACE(41)  + "REFERENTE A FERIAS"
Elseif lExtras            
	Titulo2 := SPACE(37)  + "REFERENTE A VALORES EXTRAS"
Else 
   Titulo2 := ""
Endif
//Titulo += " ("+StrZero( aReturn[8] , 2 )+")"+If(!Empty(cCabec)," - "+cCabec,"") + IF(cTipoRel="A",Analitica,Sintetica) 

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Trata variavel MES/ANO                                       Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды


_nAno    := Year(DDATABASE)
_cAno    := StrZero(_nAno,4)
_nMes    := MONTH(DDATABASE)
_cMes    := StrZero(_nMes,2)
_cMesano := aMeses[_nMes]+"/"+Substr(Str(_nAno,4),3,2)


If LastKey() = 27 .Or. nLastKey = 27
	Return
Endif

SetDefault(aReturn,cString)

If LastKey() = 27 .OR. nLastKey = 27
	Return
Endif

RptStatus({|lEnd| R020Imp(@lEnd,wnRel,cString)},cTit)  // Chamada do Relatorio

Return

*------------------------------------------*
Static Function R020Imp(lEnd,WnRel,cString)
*------------------------------------------*
Local nTotregs,nMult,nPosAnt,nPosAtu,nPosCnt,cSav20,cSav7 //Regua
//Local tamanho:="P"
//Local limite := 80
Local cAcessaSRA := &("{ || " + ChkRH("GPER020","SRA","2") + "}")
Local cAcessaSRC := &("{ || " + ChkRH("GPER020","SRC","2") + "}")
Local cAcessaSRI := &("{ || " + ChkRH("GPER020","SRI","2") + "}")
Local cAcessaSR1 := &("{ || " + ChkRH("GPER020","SR1","2") + "}")

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define Variaveis Locais (Programa)                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//Local aCodigosAdt:={}
//Local nExtra
Local aCodFol:={}


aStru := {}
aadd(aStru , {'TMP_MATR' ,'C', 06,0} )
aadd(aStru , {'TMP_NOME' ,'C', 50,0} )
aadd(aStru , {'TMP_BANCO' ,'C', 03,0} )
aadd(aStru , {'TMP_AGENC' ,'C', 05,0} )
aadd(aStru , {'TMP_CONTA' ,'C', 12,0} ) 
aadd(aStru , {'TMP_VALOR' ,'N', 12,2} )
aadd(aStru , {'TMP_TIPO'  ,'C', 06,0} )
aadd(aStru , {'TMP_CPF'   ,'C', 11,0} )
/*
cArqTemp := CriaTrab(aStru , .t.)
dbUseArea(.T.,,cArqTemp,'TMP',.f.)
*/

If Select(cArqTemp) >0
	If oTempTable:lCreated
		oTempTable:delete()
	EndIf
EndIf

oTempTable := FWTemporaryTable():New( cArqTemp )
oTempTable:SetFields( aCampos )
oTempTable:AddIndex("01", {"TMP_MATR"} )
oTempTable:Create()

DBSELECTAREA("TMP")
//INDEX ON TMP_CCUS+TMP_CURS+TMP_MATR+TMP_DREA1  TO &cArqTemp



dbSelectArea("SRA")

	If nOrdem == 1
		cIndCond:= "RA_FILIAL + RA_MAT"
		cFor:= '(RA_FILIAL+RA_BCDEPSA+RA_MAT >= "'+FilialDe+BcoDe+MatDe+'")'
		cFor+= '.And. (RA_FILIAL+RA_BCDEPSA+RA_MAT <= "'+FilialAte+BcoAte+MatAte+'")'
	ElseIf nOrdem == 2
		cIndCond:= "RA_FILIAL + RA_BCDEPSA + RA_CC + RA_MAT"
		cFor:='(RA_FILIAL+RA_BCDEPSA+RA_CC+RA_MAT >= "'+FilialDe+BcoDE+CcDe+MatDe+'")'
		cFor+=' .And. (RA_FILIAL+RA_BCDEPSA+RA_CC+RA_MAT <= "'+FilialAte+BcoAte+CcAte+MatAte+'")'
	ElseIf nOrdem == 3
		cIndCond:= "RA_FILIAL + RA_NOME"
		cFor:='(RA_FILIAL+RA_BCDEPSA+RA_NOME >= "'+FilialDe+BcoDe+NomDe+'")'
		cFor+=' .And. (RA_FILIAL+RA_BCDEPSA+RA_NOME <= "'+FilialAte+BcoAte+NomAte+'")'
	Elseif nOrdem == 4
		cIndCond:= "RA_FILIAl + RA_BCDEPSA + RA_CTDEPSA"
		cFor:='(RA_FILIAL+RA_BCDEPSA+RA_CTDEPSA >= "'+FilialDe+BcoDe+CtaDe+'")'
		cFor+=' .And. (RA_FILIAL+RA_BCDEPSA+RA_CTDEPSA <= "'+FilialAte+BcoAte+CtaAte+'")'
	ElseIf nOrdem == 5
		cIndCond:= "RA_FILIAL + RA_BCDEPSA + RA_CC + RA_NOME"
		cFor:='(RA_FILIAL+RA_BCDEPSA+RA_CC+RA_NOME >= "'+FilialDe+BcoDE+CcDe+NomDe+'")'
		cFor+=' .And. (RA_FILIAL+RA_BCDEPSA+RA_CC+RA_NOME <= "'+FilialAte+BcoAte+CcAte+NomAte+'")'
	ElseIf nOrdem == 6
		cIndCond:= "RA_BCDEPSA + RA_MAT"
		cFor:='(RA_BCDEPSA+RA_MAT >= "'+BcoDe+MatDe+'")'
		cFor+=' .And. (RA_BCDEPSA+RA_MAT <= "'+BcoAte+MatAte+'")'
	ElseIf nOrdem == 7
		cIndCond:= "RA_BCDEPSA + RA_CC + RA_Mat"
		cFor:='(RA_BCDEPSA+RA_CC+RA_Mat >= "'+BcoDe+CcDe+MatDe+'")'
		cFor+=' .And. (RA_BCDEPSA+RA_CC+RA_Mat <= "'+BcoAte+CcAte+MatAte+'")'
	Elseif nOrdem == 8
		cIndCond:= "RA_BCDEPSA + RA_NOME"
		cFor:='(RA_BCDEPSA+RA_NOME >= "'+BcoDe+NomDe+'")'
		cFor+=' .And. (RA_BCDEPSA+RA_NOME <= "'+BcoAte+NomAte+'")'
	ElseIf nOrdem == 9
		cIndCond:= "RA_BCDEPSA + RA_CTDEPSA"
		cFor :='(RA_BCDEPSA+RA_CTDEPSA >= "'+BcoDe+CtaDe+'")'
		cFor +=' .And. (RA_BCDEPSA+RA_CTDEPSA <= "'+BcoAte+CtaAte+'")'
	ElseIf nOrdem == 10
		cIndCond:= "RA_BCDEPSA + RA_CC + RA_NOME"
		cFor:='(RA_BCDEPSA+RA_CC+RA_NOME >= "'+BcoDE+CcDe+NomDe+'")'
		cFor+=' .And. (RA_BCDEPSA+RA_CC+RA_NOME <= "'+BcoAte+CcAte+NomAte+'")'
	Endif

cArqNtx  := CriaTrab(NIL,.F.)
IndRegua("SRA",cArqNtx,cIndCond,,cFor,"Selecionando Registros...")
DbGoTop()

SetRegua(RecCount())   // Total de elementos da regua

FilAnt := Space(02)
AgeAnt := Space(08)
BcoAnt := Space(03)
CcAnt  := Space(09)
CtaAnt := Space(12)
NomAnt := Space(30)

tEmpresa := tPAGINA  := tFilial := tBanco  := tAgencia := tCc := 0
tFunEmp  := tFunPag  := tFunFil := TFunAge := tFunBan  := tFunTcc := 0
nTransval:= nTransFun:= nFlag := 0
cPula=" "

dbSelectArea( "SRA" )
While !EOF()
	
	IncRegua()  // Anda a regua

	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	Endif

	VALOR := 0
	
	If SRA->RA_FILIAL # FilAnt
		If !Fp_CodFol(@aCodFol,SRA->RA_FILIAL) .Or. !fInfo(@aInfo,SRA->RA_FILIAL)
			Exit
		Endif
	Endif
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Consiste Parametrizacao do Intervalo de Impressao            Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If (SRA->RA_BCDEPSA < BcoDe) .Or. (SRA->RA_BCDEPSA > BcoAte) .Or. ;
		(SRA->RA_CTDEPSA < CtaDe) .Or. (SRA->RA_CTDEPSA > CtaAte) .Or. ;
	   (SRA->RA_NOME    < NomDe) .Or. (SRA->RA_NOME    > NomAte) .Or. ;
 		(SRA->RA_MAT     < MatDe) .Or. (SRA->RA_MAT     > MatAte) .Or. ;
	   (SRA->RA_FILIAL  < FilialDe) .Or. (SRA->RA_FILIAL> FilialAte) .Or. ;
	   (SRA->RA_CC      < CcDe ) .Or. (SRA->RA_CC      > CcAte )
       TestaTotal()
	   Loop
	EndIf

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Consiste controle de acessos e filiais validas               Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
		TestaTotal()
		Loop
	EndIf

	If lAdianta 
		dbSelectArea( "SRC" )
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[7,1]) .And. Eval(cAcessaSRC)
			While !Eof() .And. (SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[7,1] = ;
					SRC->RC_FILIAL + SRC->RC_MAT + SRC->RC_PD) 
					VALOR += SRC->RC_VALOR
				dbSkip()
			EndDo
		Endif
		Somacod(aCodFol,@Valor,Semana)
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[8,1]) .And. Eval(cAcessaSRC)
			While !Eof() .And. (SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[8,1] = ;
					SRC->RC_FILIAL + SRC->RC_MAT + SRC->RC_PD)
					VALOR += SRC->RC_VALOR
				dbSkip()
			EndDo
		Endif
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[12,1]) .And. Eval(cAcessaSRC)
			While !Eof() .And. (SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[12,1] = ;
					SRC->RC_FILIAL + SRC->RC_MAT + SRC->RC_PD)
					VALOR -= SRC->RC_VALOR
				dbSkip()
			EndDo
		Endif
   EndIf
   If lFolha 
        _VERBA:=POSICIONE("SRV",2,XFILIAL("SRV")+"0047","RV_COD")
		dbSelectArea( "SRC" )
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + _VERBA) 
			While !Eof() .And. (SRA->RA_FILIAL + SRA->RA_MAT + _VERBA = ;
				SRC->RC_FILIAL + SRC->RC_MAT + SRC->RC_PD) 
				VALOR += SRC->RC_VALOR
				dbSkip()
			EndDo
		Endif
   Endif
	If lPrimeira
		dbSelectArea( "SRC" )
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[22,1]) .And. Eval(cAcessaSRC)
			While !Eof() .And. (SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[22,1] = ;
				SRC->RC_FILIAL + SRC->RC_MAT + SRC->RC_PD) 
				VALOR += SRC->RC_VALOR
				dbSkip()
			EndDo
		Endif
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[172,1]) .And. Eval(cAcessaSRC)
			While !Eof() .And. (SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[172,1] = ;
 					SRC->RC_FILIAL + SRC->RC_MAT + SRC->RC_PD)
				If PosSrv(SRC->RC_PD,SRC->RC_FILIAL,"RV_TIPOCOD") == "2" 
					VALOR -= SRC->RC_VALOR
				Endif
				dbSkip()
			EndDo
		Endif
	EndIf
	If lSegunda
	  	dbSelectArea( "SRI" )
		dbSetOrder(2)
		If dbSeek(SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT + aCodFol[21,1]) .And. Eval(cAcessaSRI)
			VALOR += SRI->RI_VALOR
		Endif
    Endif
	If lFerias .And. SRA->RA_SITFOLH = "F"
		dbSelectArea( "SRH" )
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT = SRH->RH_FILIAL + SRH->RH_MAT
				If (SRH->RH_DATAINI >= dDataDe .And. SRH->RH_DATAINI <= dDataAte )
					dbSelectArea( "SRR" )
					If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + "F" + DTOS(SRH->RH_DTRECIB) + aCodfol[102,1] )
						VALOR += SRR->RR_VALOR
						Exit
					Endif
				Endif
				dbSelectArea("SRH")
            dbSkip()
			Enddo
		Endif
	Endif

	// Soma Valores Extras Caso Opcao = 6
	If lExtras
		dbSelectArea("SR1")
		dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + Semana)
		While ! Eof() .And. ( SRA->RA_FILIAL + SRA->RA_MAT = SR1->R1_FILIAL + SR1->R1_MAT) 
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Consiste controle de acessos								 Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If Eval(cAcessaSR1)
				If SR1->R1_SEMANA = Semana
	                // Codigos de provento
					If PosSrv(SR1->R1_PD,SR1->R1_FILIAL,"RV_TIPOCOD") == "1"
						VALOR += SR1->R1_VALOR
					// Codigos de desconto
					ElseIf PosSrv(SR1->R1_PD,SR1->R1_FILIAL,"RV_TIPOCOD") == "2"
						VALOR -= SR1->R1_VALOR
					Endif
				EndIf	
			EndIf
			dbSkip()
		Enddo
	Endif
	
	// 1- Testa Situacao do Funcionario na Folha
    // 2- Testa Categoria do Funcionario na Folha
	// 2- Testa Com Conta
	// 3- Testa Sem Conta
	// 4- Testa se Valor == 0
	
	If !( SRA->RA_SITFOLH $ cSituacao ) .Or. !(SRA->RA_CATFUNC $ cCategoria) .Or.;
		( COMCONTA = "C" .And. SRA->RA_CTDEPSA = SPACE(LEN(SRA->RA_CTDEPSA))) .Or.;
		( COMCONTA = "S" .And. SRA->RA_CTDEPSA # SPACE(LEN(SRA->RA_CTDEPSA))) .Or.;
		( VALOR == 0 )
		TestaTotal()
		Loop
	Endif
    IF VALOR== 0.10   // ESPECIFICO ALUBAR
		TestaTotal()
		Loop
	Endif

    _TPCTA:="C.Corr"
    IF SRA->RA_TPCTSAL="2"
       _TPCTA:="C.Poup"
      ELSEIF SRA->RA_TPCTSAL="3"
       _TPCTA:="C.Sala"
    ENDIF        
	Det := SRA->RA_MAT+"  " + Iif(lstnome="S",SRA->RA_NOME,"***  N o m e   Oculto   ***   ") +"     "
	Det += Transform(SRA->RA_CIC,"@R 999.999.999-99") + "     "  + LEFT(SRA->RA_BCDEPSA,3) + "    " 
	Det += SUBSTR(SRA->RA_BCDEPSA,4,5) + "    " + SRA->RA_CTDEPSA +"  " + Transform(VALOR,"@E 9,999,999.99")+" "+SRA->RA_SITFOLH+" "+_TPCTA

    //************************************ GRAVA NO ARQ TEMPORARIO
    _AREA:=ALIAS()
    DBSELECTAREA("TMP")
    RECLOCK("TMP",.T.)
    TMP_MATR :=SRA->RA_MAT
    TMP_NOME :=SRA->RA_NOME
    TMP_BANCO:=LEFT(SRA->RA_BCDEPSA,3)
    TMP_AGENC:=SUBSTR(SRA->RA_BCDEPSA,4,5)
    TMP_CONTA:=SRA->RA_CTDEPSA
    TMP_VALOR:=VALOR
    TMP_TIPO :=_TPCTA
    TMP_CPF  :=SRA->RA_CIC
    MSUNLOCK()    
    DBSELECTAREA(_AREA)
    //************************************ END: GRAVA NO ARQ TEMPORARIO

	If cPula == "S"		// Imprime quebra de Pagina quando
		Impr(" ","P")	// existe mais um funcionario a ser
		cPula = " "		// impresso.
	ElseIf cPula == "N"	// Imprime uma linha em branco apos  os totais.
        If nOrdem <> 1 .and. nOrdem <> 3 // Especifico Exmam. Original sem o If/Endif
			IMPR("","C")    
			cPula = " "      
		Endif	
	Endif               

	IF cTipoRel == "A"	//So Imprime Dados dos Funcionarios quando Relacao For Analitica. 
		IMPR(DET,"C")
	EndIF
	
	TfunPag   ++                           // Adicionando Funcionarios
	TfunFil   ++                           // Aos Contadores
	TfunAge   ++	
	TfunBan   ++
	TfunTcc   ++
	TfunEmp   ++
	
	Tpagina   += VALOR                    // Adicionando Valor aos
	Tfilial   += VALOR                    // Acumuladores
	TAgencia  += VALOR	
	Tbanco    += VALOR
	Tcc       += VALOR
	Tempresa  += VALOR
	
	If Li >= 55
		TotalPag()     // Quebra Pagina quando excede numero de linhas
		nFlag:=1
	Endif
	TestaTotal()
Enddo

If tFunEmp > 0
	TotalEmp()
	IMPR(" ","F")
	IMPR("","P")
	ImpAutor()
Endif

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Termino do relatorio                                         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
dbSelectArea( "SRI" )
dbSetOrder(1)
dbSelectArea("SRA")
Set Filter to
RetIndex("SRA")
dbSetOrder(1)	
fErase( cArqNtx + OrdBagExt() )
Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

_GeraXls:=1
@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Gera Planilha Excel ?"
@ 10, 49 SAY "1 - Nao"
@ 22, 49 SAY "2 - Sim"
@ 44, 49 GET _GeraXls PICTURE "99"
@ 60, 90 BmpButton Type 1 Action Close(oDlg2)
Activate Dialog oDlg2 Centered

DbSelectArea("TMP")
DBGOTOP()
If _GeraXls=2 .AND. File(cArqTemp+".DTC")
	//COPY TO LIQUIDO.CSV VIA "DBFCDXADS"
	//Copiando Arquivo criado .DBF para o diretorio especМfico no Cliente
	IF CPYS2T("\SYSTEM\LIQUIDO.CSV","C:\Relato\",.F.)
		MSGINFO("Arquivo gerado com sucesso! C:\Relato\LIQUIDO.CSV",)
	ELSE
		ALERT("ERRO NA COPIA")
	ENDIF
EndIf
DbCloseArea()
/*
cArqTemp2 := cArqTemp + '.DTC'
Delete File &cArqTemp2
cArqTemp3 := cArqTemp + '.CDX'
Delete File &cArqTemp3
*/
RETURN 

*-------------------------*
Static Function TestaTotal  // Teste para totalizacao
*-------------------------*
dbSelectArea ( "SRA" )
FilAnt := SRA->RA_FILIAL    // Iguala Variaveis
AgeAnt := SRA->RA_BCDEPSA
BcoAnt := SubStr(SRA->RA_BCDEPSA,1,3)
CcAnt  := SRA->RA_CC
CtaAnt := SRA->RA_CTDEPSA
NomAnt := SRA->RA_NOME

dbSkip()

If (SRA->RA_FILIAL # FilAnt .Or. Eof()) .And. (nOrdem <= 5)
	TotalPag()
	TotalCc()
	TotalAge()
	TotalBan()	
	If Quebloc	
		TotalFil()
	Endif	
	cPula="S"
Elseif (SRA->RA_CC # CcAnt .Or. Eof()) .And. (nOrdem == 2 .Or. nOrdem == 5 .Or. nOrdem == 7 .Or. nOrdem == 10 )
	TotalPag()
	TotalCc()
	TotalAge()		
	If SubStr(SRA->RA_BCDEPSA,1,3) # BcoAnt
		TotalBan()	
	Endif		
	cPula="S"
Elseif (SubStr(SRA->RA_BCDEPSA,4,5) # SubStr(AgeAnt,4,5) .Or. Eof())
   If nOrdem <> 1 .and. nOrdem <> 3  // Incluido para quebrar p/ ordem = 6 ou 8
		TotalPag()
		TotalCc()
		TotalAge()
	Endif	
	If SubStr(SRA->RA_BCDEPSA,1,3) # BcoAnt
		TotalBan()	
	Endif		
	cPula = cSaltaAg  // -- "S" OU "N" 
Endif

If nFlag == 0
	nTransFun:=nTransVal:=0      // Zera total a transportar
Endif                           // apenas quando houver uma quebra
Return

*-----------------------*
Static Function TotalPag		// Totalizador por Pagina
*-----------------------*
If tFunPag == 0
	Return Nil
Endif

IF cTipoRel == "S"				//Nao Imprime Total da Pagina Quando a Relacao for Sintetica.
	Return NIL
EndIF

IF nOrdem == 1 .or. nOrdem == 3 // Nao Imprime Total da Pagina Quando ordem Matr/Nome
    cPula := "N"                // Especifico Exmam
	Return NIL                  // 
EndIF
	
DET = REPLICATE("-",132)
IMPR(DET,"C")
DET := SPACE(5)+"TOTAL DA PAGINA"+SPACE(44)+"QTDE. FUNC.:"+TRANSFORM(TFUNPAG,"99999")
DET += SPACE(02)+TRANSFORM(TPAGINA,"@E 999,999,999,999.99")
IMPR(DET,"C")
If nFlag == 1
	IF nTRANSVAL # 0
		DET = REPLICATE("-",132)
		IMPR(DET,"C")
		DET := SPACE(5)+"TRANSPORTADO PAGINA ANTERIOR"+SPACE(31)+"QTDE. FUNC.:"+TRANSFORM(nTRANSFUN,"99999")	
		DET += SPACE(02)+TRANSFORM(nTRANSVAL,"@E 999,999,999,999.99")
		IMPR(DET,"C")
		nFlag:=0
	ENDIF
Endif
nTransfun += tFunPag
nTransVal += tPagina
tFunPag := tPagina := 0
cPula="S"
	
*----------------------*
Static Function TotalCc  // Totalizador Por Centro de Custo
*----------------------*
Local Desc_Cc:=Space(40)

If (nOrdem # 2 .And. nOrdem # 5 .And. nOrdem # 7 .And. nOrdem # 10) .Or. tFunTcc == 0
	Return Nil                                     // Consistencia de Opcoes
Endif
		
If SI3->(dbSeek(cFilial+CcAnt))
	Desc_Cc :=Si3->i3_Desc + Space(15)   // Procura Descricao do Centro de Custo
Endif
		
DET = REPLICATE("-",132)
IMPR(DET,"C")
DET := SPACE(5)+"TOTAL DO C.CUSTO  "+DESC_CC+" QTDE. FUNC.:"+TRANSFORM(TFUNTCC,"99999")	
DET += SPACE(02)+TRANSFORM(TCC,"@E 999,999,999,999.99")
IMPR(DET,"C")
tFunTCC := Tcc := 0

*-----------------------*
Static Function TotalAge  // Totalizador por Banco
*-----------------------*
Local DESC_AGE := Space(40)

If tFunAge == 0 
	Return Nil
Endif

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Funcao Para Buscar Nome do Banco ( SA6 )                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Desc_Age := AgeAnt+"-"+DescBco(AgeAnt,SRA->RA_FILIAL,40,.T.)

DET = REPLICATE("-",132)
IMPR(DET,"C")
DET := SPACE(5)+"TOT AGENCIA "+DESC_AGE+"   QTDE. FUNC.:"+TRANSFORM(TFUNAGE,"99999")	
DET += SPACE(02)+TRANSFORM(TAGENCIA,"@E 999,999,999,999.99")
IMPR(DET,"C")
tFunAge := tAgencia := 0
		
*-----------------------*
Static Function TotalBan  // Totalizador por Banco
*-----------------------*
Local DESC_BCO := Space(40)

If tFunBan == 0
	Return Nil
Endif

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Funcao Para Buscar Nome do Banco ( SA6 )                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Desc_Bco := BcoAnt+"-"+DescBco(BcoAnt,SRA->RA_FILIAL)

DET = REPLICATE("-",132)
IMPR(DET,"C")
DET := SPACE(5)+"TOTAL  DO BANCO  "+DESC_BCO+"   QTDE. FUNC.:"+TRANSFORM(TFUNBAN,"99999")	
DET += SPACE(02)+TRANSFORM(TBANCO,"@E 999,999,999,999.99")
IMPR(DET,"C")
tFunBan := tBanco := 0
		
*-----------------------*
Static Function TotalFil  // Totalizador por Empresa
*-----------------------*
If tFunFil == 0 .Or. (nOrdem >= 6)
	Return Nil
Endif
		
cDesc_Fil := aInfo[1] + Space(25)
	
DET = REPLICATE("-",132)
IMPR(DET,"C")


DET := SPACE(5)+"TOTAL DA FILIAL "+cDesc_Fil+"   QTDE. FUNC.:"+TRANSFORM(tFunFil,"99999")
DET += SPACE(02)+TRANSFORM(TFilial ,"@E 999,999,999,999.99")
IMPR(DET,"C")
tFunFil := TFilial := 0
DET = REPLICATE("-",132)
IMPR(DET,"C")

IF cSALTA = "S"
	IMPR("","P")
ENDIF
		
*-----------------------*
Static Function TotalEmp  // Totalizador Geral
*-----------------------*
If tEmpresa == 0
	Return Nil
Endif

cDesc_Emp := aInfo[3]
		
DET = REPLICATE("-",132)
IMPR(DET,"C")
IF cSALTA = "S"
	IMPR("","P")
ENDIF
DET := SPACE(5)+"TOTAL DA EMPRESA "+cDesc_Emp+"  QTDE. FUNC.:"+TRANSFORM(tFunEmp,"99999")	
DET += SPACE(02)+TRANSFORM(tEmpresa ,"@E 999,999,999,999.99")
_nTotFun := tFunEmp
_nTotVlr := tEmpresa
IMPR(DET,"C")
tFunEmp := tEmpresa:= 0


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Funcao para impressao da Autorizacao de Credito              Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function ImpAutor()
wCabec1:=" "
wCabec2:=SPACE(15)  + Titulo2
wCabec3:="CARTA No. " + _PAR35 + "/" + _cAno + SPACE(100) + "MES: " + _cMesAno

DET := ""
IMPR(DET,"C")
IMPR(DET,"C")
IMPR(DET,"C")

DET := SPACE(25) + "Qtde. de Funcionarios no arquivo:" + TRANSFORM(_nTotFun,"99999")	
IMPR(DET,"C")
DET := SPACE(25) + "Valor Total R$:" + TRANSFORM(_nTotVlr ,"@E 99,999,999.99")
IMPR(DET,"C")


DET := ""
IMPR(DET,"C")



Return
