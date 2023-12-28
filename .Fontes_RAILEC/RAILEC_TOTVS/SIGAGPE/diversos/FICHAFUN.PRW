#include "rwmake.ch"

**************
user Function FICHAFUN()    // ROTINA DE IMPRESSAO DE CONTRATO DE TRABALHO ... By JOSE MACEDO
**************
Local __i as numeric

nOrdem :=0
Z:=0
M:=0
tamanho:="M"
limite:=220
titulo   := PADC("FICHA DE ATUALIZACAO CADASTRAL",74)
cDesc1   := PADC(" ",74)
cDesc2   := PADC(" ",74)
cDesc3   := PADC(" ",74)
cNatureza:=""
aReturn  := { "Especial", 1,"Administracao", 2, 2, 1,"",1 }
nPag     := 0
nomeprog := "FICHA_"
cPerg    := "CONTRA"
wnrel    := "FICHA_"
nLastKey := 0
lContinua:= .T.
nLin     := 0



//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas                                      ¦
//+-------------------------------------------------------------------------+
_INI:=SPACE(6)
_FIM:="999999"
_UNIMED:="23 "    // APARTAMENTO e ENFERMARIA
_VIAS  :=1

@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Matricula"
@ 10, 22 SAY "De :"
@ 10, 49 GET _INI     SIZE 25,12 F3 "SRA"
@ 22, 22 SAY "Ate:"
@ 22, 49 GET _FIM     SIZE 25,12 F3 "SRA"
@ 34, 22 SAY "Unimed:"
@ 34, 49 GET _UNIMED  PICTURE "!!!"
@ 46, 22 SAY "Vias:"
@ 46, 49 GET _VIAS  PICTURE "99"

@ 60, 95 BmpButton Type 1 Action Close(oDlg2)
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

oFont9 :=TFont():New( "Arial"   ,,14,,.T.,,,,,.F. )
oFont9a:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
oFont9b:=TFont():New( "Arial"   ,,12,,.F.,,,,,.F. )

oFont14n:=TFont():New("Courier New",14,14,,.T.,,,,.T.,.F.)    //Negrito//

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
cBitMap:= "ALUBAR_ISO.Bmp"



IF EMPTY(_FIM)
	_FIM:=_INI
ENDIF
//+-----------------------------------------------------------+
//¦ Inicio do Relatorio                                       ¦
//+-----------------------------------------------------------+
DBSELECTAREA("SRA")
DBSETORDER(1)
DBSEEK(XFILIAL("SRA")+_INI,.T.)
WHILE !EOF() .AND. RA_MAT<=_FIM
	IF SRA->RA_SITFOLH$"DT"
		DBSKIP()
		Loop
	ENDIF
	
	DBSELECTAREA("SRB")
	DBSETORDER(1)
	DBSEEK(xFilial("SRB")+SRA->RA_MAT)       // SOMENTE FUNCIONARIOS COM DEPENDENTES
	IF !FOUND()
		DBSELECTAREA("SRA")
		DBSKIP()
		Loop
	ENDIF
	
	_nDEP:=0
	WHILE !EOF() .AND. RB_MAT==SRA->RA_MAT
		_cUNIM:=RB_UNIMED
		IF EMPTY(_cUNIM)
			_cUNIM:="1"
		ENDIF
		IF !(_cUNIM$_UNIMED)      // FILTRA UNIMED
			DBSKIP()
			Loop
		ENDIF
		_nDEP++
		DBSKIP()
	ENDDO
	IF _nDEP=0
		DBSELECTAREA("SRA")
		DBSKIP()
		Loop
	ENDIF
	
	//***************************************** INICIO DA IMNPRESSAO
	DBSELECTAREA("SRA")
	
	FOR __I:=1 TO _VIAS
		oPrn:EndPage()
		Linha := 70
		nPag  := nPag +1
		
		oPrn:SayBitmap( Linha+050,080,cBitMap,2080,480 )
		
		oPrn:Say(Linha  :=Linha+500 ,  800,"DECLARAÇÃO DE DEPENDENTES" , oFont9)
		oPrn:line( Linha:=Linha+60  ,   80,Linha,2260)     // Linha horizontal
		
		_SALTO:=60
		
		oPrn:Say(Linha:=Linha+_SALTO , 100,"Funcionário : "+SRA->RA_MAT+"-"+SRA->RA_NOME , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO , 100,"Admissao    : "+DTOC(SRA->RA_ADMISSA) , oFont9a)
		oPrn:Say(Linha:=Linha        ,1000,"Nascimento  : "+DTOC(SRA->RA_NASC)+"       Sexo : "+RA_SEXO , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO , 100,"Lotaçâo     : "+SRA->RA_CC+POSICIONE("CTT",1,XFILIAL("CTT")+SRA->RA_CC,"CTT_DESC01") , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,100,"Ctps Num.   : "+SRA->RA_NUMCP+", Série "+SRA->RA_SERCP , oFont9a)
		oPrn:line( Linha:=Linha+50   ,  80 ,Linha,2260)     // Linha horizontal
		
		oPrn:Say(Linha:=Linha+_SALTO            , 100,"Declaro para os devidos fins que tenho sob a minha dependência legal, os" , oFont9B)
		oPrn:Say(Linha:=Linha+_SALTO            , 100,"dependentes relacionados abaixo:" , oFont9B)
		
		oPrn:Say(Linha:=Linha+_SALTO+20    ,200,"COD NOME DO DEPENDENTE" , oFont9a)
		oPrn:Say(Linha:=Linha           ,1300,"NASCIMENTO" , oFont9a)
		oPrn:Say(Linha:=Linha           ,1575,"GRAU"  , oFont9a)
		oPrn:Say(Linha:=Linha           ,1800,"C.P.F" , oFont9a)
		
		I:=1
		DBSELECTAREA("SRB")
		DBSETORDER(1)
		DBSEEK(xFilial("SRB")+SRA->RA_MAT)
		WHILE !EOF() .AND. RB_MAT==SRA->RA_MAT
			_cUNIM:=RB_UNIMED
			IF EMPTY(_cUNIM)
				_cUNIM:="1"
			ENDIF
			IF !(_cUNIM$_UNIMED)      // FILTRA UNIMED
				DBSKIP()
				Loop
			ENDIF
			oPrn:Say(Linha:=Linha+_SALTO , 200,RB_COD+"-"+RB_NOME , oFont9a)
			oPrn:Say(Linha:=Linha        ,1300,DTOC(RB_DTNASC) , oFont9a)
			_graupar:=RB_GRAUPAR
			IF RB_GRAUPAR="F"
				_GRAUPAR:="Filho(a)"
			ELSEIF RB_GRAUPAR="C"
				_GRAUPAR:="Cônjuge "
			ELSEIF RB_GRAUPAR="E"
				_GRAUPAR:="Enteado "
			ELSEIF RB_GRAUPAR="P"
				_GRAUPAR:="Pai/Mãe "
			ELSEIF RB_GRAUPAR="O"
				_GRAUPAR:="Outros  "
			ENDIF
			oPrn:Say(Linha:=Linha        ,1575,_GRAUPAR , oFont9a)
			oPrn:Say(Linha:=Linha        ,1800,Transform( RB_CIC , "@R 999.999.999-99" ) , oFont9a)
			I++
			DBSKIP()
		ENDDO
		
		
		oPrn:Say(Linha:=Linha+_SALTO+40         , 100,'Me comprometo a comunicar à empresa qualquer alteração que vier a ocorrer na lista' , oFont9B)
		oPrn:Say(Linha:=Linha+_SALTO            , 100,'de dependente(s) relacionado(s) acima.' , oFont9B)
		
		
		oPrn:Say(Linha:=Linha+(_SALTO*2)        , 100,"Indivíduos que podem ser considerados dependentes legais: " , oFont9)
		oPrn:Say(Linha:=Linha+_SALTO            , 100,"Cônjuge do (a) colaborador (a);" , oFont9B)
		oPrn:Say(Linha:=Linha+_SALTO            , 100,'Companheiro (a) que conviva em união estável, mediante apresentação' , oFont9B)
		oPrn:Say(Linha:=Linha+_SALTO            , 100,'do documento "declaração de União Estável/Concubinato";' , oFont9B)
		oPrn:Say(Linha:=Linha+_SALTO            , 100,"Filhos (as) até a idade de 24 anos;" , oFont9B)
		oPrn:Say(Linha:=Linha+_SALTO            , 100,"Enteados, quando o colaborador (a) for casado (a) legalmente;" , oFont9B)
		oPrn:Say(Linha:=Linha+_SALTO            , 100,"Menores de até 24 anos, quando o colaborador (a) possuir guarda ou tutela definitiva." , oFont9B)
		
		linha+=(_salto*2)
		oPrn:Say(Linha:=Linha+_SALTO            , 100,"A presente declaração é a expressão de verdade pela qual me responsabilizo para" , oFont9B)
		oPrn:Say(Linha:=Linha+_SALTO            , 100,"todos os efeitos legais, estando ciente que, em caso de prestar quaisquer informações" , oFont9B)
		oPrn:Say(Linha:=Linha+_SALTO            , 100,"falsas, estarei infringindo o Código de Ética da empresa, sendo enquadrado no artigo" , oFont9B)
		oPrn:Say(Linha:=Linha+_SALTO            , 100," 482 alínea 'a' da CLT (improbidade), podendo ser desligado por justa causa." , oFont9B)
		
		
		linha+=(_salto*2)
		oPrn:Say(Linha:=Linha+_SALTO            , 100,"Barcarena- Pa, _____ de ____________ de _________" , oFont9B)
		
		linha+=(_salto*2)
		oPrn:Say(Linha:=Linha+_SALTO            , 100,sra->ra_nomecmp , oFont9B)
	NEXT __I
	
	DBSELECTAREA("SRA")
	DBSKIP()
ENDDO


oPrn:Preview()
MS_FLUSH()

oPrn:EndPage()


RETURN


//*********************************************************************************
User Function CadSRA()
//*********************************************************************************

_cArea := Alias()
_nOrd  := IndexOrd()
nReg   :=RecNo()

PRIVATE aCores    := {{ 'SRA->RA_SITFOLH#"D"'	, 'ENABLE' },;
{ 'SRA->RA_SITFOLH="D"'	, 'DISABLE'}}


DbSelectArea("SAK")
DBSETORDER(2)
DBSEEK(xFilial("SAK")+RETCODUSR())
IF !FOUND()
	ALERT("Gerente nao cadastrado .....")
	RETURN
ELSE
	_USUARIO:=AK_COD
ENDIF

DbSelectArea("CTT")
DbGotop()
_CC:=""
WHILE !EOF()
	IF CTT_RESP=_USUARIO .OR. UPPER(SUBSTR(cUsuario,7,6))$"ADMINI/MACEDO/ANA.CA"
		_CC:=_CC+CTT_CUSTO+"%"
	ENDIF
	DBSKIP()
ENDDO

DbSelectArea("SRA")
SET FILTER TO RA_CC$_CC .AND. RA_SITFOLH#"D"
DbGotop()

cCadastro:="Funcionarios"
aRotina := { { "Pesquisa ",  'AxPesqui'            , 0, 1 },;
{ "Visualizar" ,"TRM100Rot"            , 0, 2},;
{ "Prg Ferias" ,"gp050Visu"            , 0, 2},;
{ "&Legenda  " ,"U_BRLegSRA"          , 0, 8 }}
mBrowse(16,00,280,350,"SRA",,,,,,aCores)

DbSelectArea("SRA")
SET FILTER TO

dbSelectArea(_cArea)
DbSetOrder(_nOrd)
DbGoTo(nReg)

return(nil)

User Function BRLegSRA()
Local aLegenda := { {"ENABLE" ,"Ativo"}    ,;
{"DISABLE"   ,"Demitido"}}


BrwLegenda(cCadastro,"Legenda" ,aLegenda)

Return .T.


//*********************************************************************************
User Function UGPEC010()
//*********************************************************************************

_cArea := Alias()
_nOrd  := IndexOrd()
nReg   :=RecNo()

PRIVATE aCores    := {{ 'SRA->RA_SITFOLH#"D"'	, 'ENABLE' },;
{ 'SRA->RA_SITFOLH="D"'	, 'DISABLE'}}

DbSelectArea("SAK")
DBSETORDER(2)
DBSEEK(xFilial("SAK")+RETCODUSR())
IF !FOUND()
	ALERT("Gerente nao cadastrado .....")
	RETURN
ELSE
	_USUARIO:=AK_COD
ENDIF

DbSelectArea("CTT")
DbGotop()
_CC:=""
WHILE !EOF()
	IF CTT_RESP=_USUARIO .OR. UPPER(SUBSTR(cUsuario,7,6))$"ADMINI/MACEDO/ANA.CA"
		_CC:=_CC+CTT_CUSTO+"%"
	ENDIF
	DBSKIP()
ENDDO
DbSelectArea("SRA")
SET FILTER TO RA_CC$_CC .AND. RA_SITFOLH#"D"

DbGotop()
//*********************************************************************************
GPEC010()

DbSelectArea("SRA")
SET FILTER TO

dbSelectArea(_cArea)
DbSetOrder(_nOrd)
DbGoTo(nReg)

return(nil)




//*********************************************************************************
User Function UGPEA630()
//*********************************************************************************

_cArea := Alias()
_nOrd  := IndexOrd()
nReg   :=RecNo()

PRIVATE aCores    := {{ 'SRA->RA_SITFOLH#"D"'	, 'ENABLE' },;
{ 'SRA->RA_SITFOLH="D"'	, 'DISABLE'}}

DbSelectArea("SAK")
DBSETORDER(2)
DBSEEK(xFilial("SAK")+RETCODUSR())
IF !FOUND()
	ALERT("Gerente nao cadastrado .....")
	RETURN
ELSE
	_USUARIO:=AK_COD
ENDIF

DbSelectArea("CTT")
DbGotop()
_CC:=""
WHILE !EOF()
	IF CTT_RESP=_USUARIO .OR. UPPER(SUBSTR(cUsuario,7,6))$"ADMINI/MACEDO/ANA.CA"
		_CC:=_CC+CTT_CUSTO+"%"
	ENDIF
	DBSKIP()
ENDDO

DbSelectArea("SRA")
SET FILTER TO RA_CC$_CC .AND. RA_SITFOLH#"D"
DbGotop()

GPEA630()

DbSelectArea("SRA")
SET FILTER TO

dbSelectArea(_cArea)
DbSetOrder(_nOrd)
DbGoTo(nReg)

return(nil)





