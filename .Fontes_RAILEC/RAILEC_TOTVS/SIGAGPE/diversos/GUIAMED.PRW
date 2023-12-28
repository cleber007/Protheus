#include "ap5mail.ch"
#include "rwmake.ch"


//*******************************************************************************************************************
**************
user Function UGUIAMED()    // ROTINA DE IMPRESSAO DA GUIA DE AUTORIZAÇÃO MEDICA ... By JOSE MACEDO
**************

nOrdem :=0
Z:=0
M:=0
tamanho:="M"
limite:=220
titulo   := PADC("CONTRATO DE TRABALHO",74)
cDesc1   := PADC(" ",74)
cDesc2   := PADC(" ",74)
cDesc3   := PADC(" ",74)
cNatureza:=""
aReturn  := { "Especial", 1,"Administracao", 2, 2, 1,"",1 }
nPag     := 0
nomeprog := "GUIAMED"
cPerg    := ""
wnrel    := SUBSTR(CUSUARIO,7,3)+"_GUIAMED"
nLastKey := 0
lContinua:= .T.
nLin     := 0

_TXCORREA:= 0
_TXJURREA:= 0
_QUAL    := ""

//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas                                      ¦
//+-------------------------------------------------------------------------+
_INI:=_FIM:=SPACE(6)
_TIPO:=0
_LOCAL:="MEDCOM               "
_DATA :=DDATABASE+15
@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Matricula"
@ 10, 22 SAY "Matric:"
@ 10, 49 GET _INI  SIZE 25,12 F3 "SRA"
@ 20, 05 SAY "Tipo: 1-Adm 2-Per 3-Mud.Func 4-Ret.Trb 5-Dem"
@ 30, 49 GET _TIPO  PICTURE "99" VALID _TIPO>=1 .AND. _TIPO<=5

@ 40, 22 SAY "Local:"
@ 40, 49 GET _LOCAL  SIZE 45,12 
@ 50, 22 SAY "Data.:"
@ 50, 49 GET _DATA   SIZE 45,12 

@ 60, 95 BmpButton Type 1 Action Close(oDlg2)
Activate Dialog oDlg2 Centered

IF _TIPO=0 .OR. _TIPO>5
   ALERT("Escolha o tipo !")
   RETURN Nil
ENDIF
IF EMPTY(_INI)
   ALERT("Matricula nao pode estar em branco!")
   RETURN Nil
ENDIF

   
IF _TIPO=1
    _cTIPO:="ADMISSIONAL        "
    _VAR:="TM4->TM4_ADMISS"
   ELSEIF _TIPO=2
    _cTIPO:="PERIÓDICO          "
    _VAR:="TM4->TM4_PERIOD"
   ELSEIF _TIPO=3
    _cTIPO:="MUDANÇA DE FUNCÃO  "
    _VAR:="TM4->TM4_MUDFUN"
   ELSEIF _TIPO=4
    _cTIPO:="RETORNO AO TRABALHO"
    _VAR:="TM4->TM4_RETORN"
   ELSEIF _TIPO=5
    _cTIPO:="DEMISSIONAL        "
    _VAR:="TM4->TM4_DEMISS"
ENDIF   

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
oFont9C :=TFont():New( "Arial"   ,,14,,.T.,,,,,.F. )

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
DBSELECTAREA("TM4")
DBSETORDER(2)
DBGOTOP()
_A   :=ARRAY(42)
_B   :=ARRAY(42)
I    :=1
WHILE !EOF() .AND. I<=42
	IF SUBSTR(TM4_NOMEXA,1,2)#"99"     // NAO CONSIDERA NA RELAÇÃO DE EXAMES A SER IMPRESSA SE DESCRICAO INICIAR POR 99
        IF VAL(SUBSTR(TM4_NOMEXA,1,2))>0
		   _A[I]:=SUBSTR(TM4_NOMEXA,3,38)
		   ELSE
		   _A[I]:=SUBSTR(TM4_NOMEXA,1,36)
        ENDIF		   
		IF &_Var="1"
			_B[I]:=" "//"[ X ]-"
		ELSE
			_B[I]:=" "//"[   ]-"
		ENDIF
	   I++
	ENDIF
	DBSKIP()
ENDDO
FOR J:=I TO 42
	_A[J]:=SPACE(10)
   _B[J]:="[   ]"
NEXT J

DBSELECTAREA("SRA")
DBSETORDER(1)
DBSEEK(XFILIAL("SRA")+_INI)
IF FOUND()
	oPrn:EndPage()
	Linha := 70
	nPag  := nPag +1
	
   oPrn:SayBitmap( Linha+050,080,cBitMap,400,180 )
	
	oPrn:Say(Linha+150,700,"GUIA DE AUTORIZAÇÃO MEDICA" , oFont9B)
	oPrn:Say(Linha+150,1600,"Local do Ex: "+_LOCAL , oFont9a)
	oPrn:Say(Linha+200,1600,"Data Limite: "+DTOC(_DATA) , oFont9a)
	

	_SALTO:=60
	oPrn:Say(Linha:=Linha+300 ,100,"Funcionário : "             , oFont9a)
	oPrn:Say(Linha:=Linha          ,430,SRA->RA_MAT+"-"+SRA->RA_NOME , oFont9a)
	oPrn:Say(Linha:=Linha          ,1600,"Dt.Admiss : "+DTOC(SRA->RA_ADMISSA) , oFont9a)
	oPrn:Say(Linha:=Linha+_SALTO   ,100,"Função : "                                                 , oFont9a)
	oPrn:Say(Linha:=Linha          ,430,POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_DESC") , oFont9a)
	oPrn:Say(Linha:=Linha          ,1600,"Dt.Nascim : "+DTOC(SRA->RA_NASC) , oFont9a)

	oPrn:Say(Linha:=Linha+_SALTO   ,100,"CPF : "                                                 , oFont9a)
	oPrn:Say(Linha:=Linha          ,430,Transform( SRA->RA_CIC , "@R 999.999.999-99" ) , oFont9a)
	oPrn:Say(Linha:=Linha          ,1600,"PIS : "+SRA->RA_PIS , oFont9a)

	oPrn:Say(Linha:=Linha+_SALTO   ,100,"Centro de Custo : "                                                               , oFont9a)
	oPrn:Say(Linha:=Linha          ,430,ALLTRIM(SRA->RA_CC)+" - "+Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01"), oFont9a)
	oPrn:Say(Linha:=Linha          ,1600,"Tipo : "+_cTipo , oFont9a)
	
	//	oPrn:line( Linha:=Linha+50   ,  80 ,Linha,2260)     // Linha horizontal
	
	oPrn:Box( Linha:=Linha+75,80,Linha+100,2290)
	oPrn:Say(  Linha+30 , 1000,  "EXAMES AUTORIZADOS"  , oFont9B )

	LINHA   :=LINHA+100
	oPrn:Box( Linha:=Linha+20,80,Linha+2500,2290)   // BOX GRANDE
	LINHAINI:=LINHA

   FOR I:=1 TO 42 STEP 2//3
      IF EMPTY(_A[I])
         EXIT
      ENDIF   
	   oPrn:Say(  Linha+30 , 100,  _B[I]   + _A[I]  , oFont9B2 )
	   oPrn:Say(  Linha+30 ,1200,  _B[I+1] + _A[I+1]  , oFont9B2 )   // 900
//	   oPrn:Say(  Linha+30 ,1680,  _B[I+2] + _A[I+2]  , oFont9B2 )

	   LINHA:=LINHA+40
	   oPrn:line( Linha:=Linha+80,80,Linha,2290)     // Linha horizontal
	   LINHA:=LINHA+20
	NEXT I
	oPrn:line( LINHAINI   ,1190 ,Linha-20,1190)      // Linha VERTICAL
//	oPrn:line( LINHAINI   ,1670 ,Linha-20,1670)      // Linha VERTICAL

   oPrn:Say(  Linha+30 , 100,  "Autorizado por: "+SUBSTR(cUSUARIO,7,15)  , oFont9B2 )
   oPrn:Say(  Linha+30 , 1400, "Funcionario: "  , oFont9B2 )
   oPrn:Say(  Linha:=Linha+80 , 100,  "Data de Emissao: "+DTOC(DDATABASE)  , oFont9B2 )
   oPrn:line( Linha:=Linha+50,80,Linha,2290)     // Linha horizontal



	DBSELECTAREA("SRA")
	LINHA:=LINHA+30
//	oPrn:Box( Linha:=Linha+75,80,Linha+360,2290)
	oPrn:Say( Linha+10 , 700,  "ORIENTAÇÕES PARA REALIZAÇÃO DE EXAMES:"  , oFont9B )      // BOX RODAPE (FINAL)
	LINHA:=LINHA+20

/*
   _OBS01:="REALIZAÇÃO DOS EXAMES LABORATORIAIS (SANGUE): O FUNCIONARIO DEVERÁ ESTAR EM JEJUM DE 12 H, EXCETO QUANDO OCORRER SOMENTE A COLETA"
   _OBS02:="DO EXAME DE HEMOGRAMA."
   _OBS03:="REALIZAÇÃO DO EXAME DE URINA DEVERÁ SER COLETADA A PRIMEIRA DO DIA, DESPREZANDO O PRIMEIRO JATO E CONSIDERANDO OS DEMAIS."
   _OBS04:="REALIZAÇÃO DO EXAME DE AUDIOMETRIA, O COLABORADOR DEVERÁ ESTAR EM REPOUSO AUDITIVO DE 14 Hrs."
   _OBS05:="REALIZAÇÃO DO EXAME DE PSA, EVITAR ANDAR DE BICICLETA, NAO FAZER ATIVID. FISICA E EVITAR RELAÇÃO SEXUAL DOIS DIAS ANTES DO EXAME."
   _OBS06:="REALIZAÇÃO DO ELETROENCEFALOGRAMA (EEG), O COLABORADOR DEVERA IR COM CABELO LAVADO, SECO, SEM GEL OU CREME DE PENTEAR."
   _OBS07:="PARA EXAME ADMISSIONAL, O MESMO DEVERÁ APRESENTAR DOCUMENTO COM FOTO."
   _OBS08:="REALIZAÇÃO DO EXAME DE RX DA COLUNA LOMBO SACRO, O CANDIDATO DEVERÁ FAZER USO DE DOIS LAXANTES 12 Hr ANTES DA REALIZAÇÃO DO MESMO"
   _OBS09:="E JEJUM DE 12 Hr ATE O ATO DO EXAME."
*/


   _OBS01:="EXAMES LABORATORIAIS (SANGUE), DEVERÁ ESTÁ  EM JEJUM DE 8 H, QUANDO FOR SOMENTE HEMOGRAMA NÃO É NECESSÁRIO IR EM JEJUM."
   _OBS02:="EXAME DE URINA ( EAS TIPO 1) DEVERÁ SER COLETADA A PRIMEIRA DO DIA, DESPREZAR O PRIMEIRO JATO E COLETAR EM SEGUIDA."
   _OBS03:="EXAME DE AUDIOMETRIA,  DEVERÁ ESTÁ EM REPOUSO AUDITIVO DE NO MÍNIMO 14 H."
   _OBS04:="EXAME DE PSA (SANGUE), NÃO DEVERÁ ANDAR DE BICICLETA, MOTO, CAVALO, FAZER ATIVIDADE FISICA E ABISTINÊNCIA SEXUAL DOIS DIAS ANTES"
   _OBS05:="DO EXAME."
   _OBS06:="ELETROENCEFALOGRAMA (EEG), O COLABORADOR DEVERÁ IR COM O CABELO LAVADO, SECO, SEM GEL OU CREME DE PENTEAR."
   _OBS07:="PARA REALIZAÇÃO DOS EXAMES, O MESMO DEVERÁ APRESENTAR DOCUMENTO DE IDENTIFICAÇÃO COM FOTO. "
   _OBS08:="EXAME DE RX DA COLUNA LOMBO SACRO,  DEVERÁ FAZER USO DE DOIS LAXANTES (LACTO PURGA) E 01 COMP. OU 40 GTS LUFTAL ANTES DA REALIZAÇÃO"
   _OBS09:="DO EXAME E JEJUM DE 12H."
 

   oPrn:Say( LINHA:=Linha+50 , 100,  _OBS01 , oFont9B3 )
   oPrn:Say( LINHA:=Linha+50 , 100,  _OBS02 , oFont9B3 )
   oPrn:Say( LINHA:=Linha+50 , 100,  _OBS03 , oFont9B3 )
   oPrn:Say( LINHA:=Linha+50 , 100,  _OBS04 , oFont9B3 )
   oPrn:Say( LINHA:=Linha+50 , 100,  _OBS05 , oFont9B3 )
   oPrn:Say( LINHA:=Linha+50 , 100,  _OBS06 , oFont9B3 )
   oPrn:Say( LINHA:=Linha+50 , 100,  _OBS07 , oFont9B3 )
   oPrn:Say( LINHA:=Linha+50 , 100,  _OBS08 , oFont9B3 )
   oPrn:Say( LINHA:=Linha+50 , 100,  _OBS09 , oFont9B3 )


ELSE
	ALERT("Matricula nao encontrada !!!")
ENDIF

oPrn:Preview()
MS_FLUSH()

oPrn:EndPage()



Return







