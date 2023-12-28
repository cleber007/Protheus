#include "ap5mail.ch"
#include "rwmake.ch"


//*******************************************************************************************************************
**************
user Function UASO()    // ROTINA DE IMPRESSAO DO ASO (ENCAMINHAMENTO) ... By JOSE MACEDO
**************
Local i as numeric
Local J as numeric

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
wnrel    := SUBSTR(CUSUARIO,7,3)+"_ASO"
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
_TIPO:=2
_LOCAL:="MEDCOM               "
_DATA :=DDATABASE+15
@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Parametros"
@ 10, 22 SAY "Num Aso:"
@ 10, 49 GET _INI  SIZE 25,12 F3 "TMY"
@ 20, 05 SAY "Tipo: 1-Adm 2-Per 3-Mud.Func 4-Ret.Trb 5-Dem"
@ 30, 49 GET _TIPO  PICTURE "99" VALID _TIPO>=1 .AND. _TIPO<=5


@ 60, 95 BmpButton Type 1 Action Close(oDlg2)
Activate Dialog oDlg2 Centered

IF _TIPO=0 .OR. _TIPO>5
   ALERT("Escolha o tipo !")
   RETURN Nil
ENDIF
IF EMPTY(_INI)
   ALERT("ASO nao pode estar em branco!")
   RETURN Nil
ENDIF


DBSELECTAREA("TMY")     // ASO
DBSETORDER(1)
DBSEEK(XFILIAL("TMY")+_INI)
IF !FOUND()
   ALERT(_INI+" nao encontrado.")
   RETURN Nil
ENDIF

DBSELECTAREA("TM0")                  // FICHA MEDICA
DBSETORDER(1)
DBSEEK(XFILIAL("TM0")+TMY->TMY_NUMFIC)

DBSELECTAREA("SRA")
DBSETORDER(1)
DBSEEK(XFILIAL("SRA")+TM0->TM0_MAT)
IF !FOUND()
   ALERT(TM0->TM0_MAT+" Matric nao encontrada.")
   RETURN Nil
ENDIF

_RISCOS:=""
DBSELECTAREA("TN0")                  // RISCOS POR FUNCAO
DBSETORDER(7)                        // CODFUN
DBSEEK(XFILIAL("TN0")+SRA->RA_CODFUNC)
WHILE !EOF() .AND. TN0_CODFUN==SRA->RA_CODFUNC
      DBSELECTAREA("TMA")
      DBSEEK(xFilial("TMA")+TN0->TN0_AGENTE)
      IF FOUND()
         _RISCOS+=ALLTRIM(TMA_NOMAGE)+" / "
      ENDIF
      DBSELECTAREA("TN0")
      DBSKIP()
ENDDO

         
//*************************************************************************   

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
	IF SUBSTR(TM4_EXAME,1,6)$"NR7   /NR7-15/NR7-14/NR7-21/NR7-07"   // EXAMES FUNCIONARIOS ADMINISTRATIVOS
		_A[I]:=SUBSTR(TM4_NOMEXA,3,38)
		_B[I]:=" "//"[ X ]-"
	   I++
	ENDIF
	DBSKIP()
ENDDO
FOR J:=I TO 42
	_A[J]:=SPACE(10)
   _B[J]:=" " //"[   ]-"
NEXT J


DBSELECTAREA("SRA")
DBSETORDER(1)

	oPrn:EndPage()
	Linha := 70
	nPag  := nPag +1
	
   oPrn:SayBitmap( Linha+050,080,cBitMap,400,180 )
	
	oPrn:Say(Linha+150,850,"ATESTADO DE SAÚDE OCUPACIONAL - ASO" , oFont9C)
	oPrn:Say(Linha+200,785,"Portaria 3214 (08/06/78) - NR7 - Atualizada (29/12/94 a 08/05/96)" , oFont9a)

	oPrn:Box( Linha:=Linha+280  ,080+20,Linha+80, 140+20)   // BOX 
	oPrn:Box( Linha  ,630,Linha+80, 690)   // BOX 
	oPrn:Box( Linha  ,1280,Linha+80,1340)   // BOX 
	oPrn:Box( Linha  ,1820,Linha+80,1880)   // BOX 

	oPrn:Box( Linha+080  ,080+20,Linha+160, 140+20)   // BOX 
   
   IF _TIPO=1
	   oPrn:Say(Linha+10          , 120 ,"**" , oFont9a)
	  ELSEIF _TIPO=2
	   oPrn:Say(Linha+10          , 640 ,"**" , oFont9a)
	  ELSEIF _TIPO=3
	   oPrn:Say(Linha+10          ,1290 ,"**" , oFont9a)
	  ELSEIF _TIPO=4
	   oPrn:Say(Linha+10          ,1830 ,"**" , oFont9a)
	  ELSEIF _TIPO=5
	   oPrn:Say(Linha+90          ,120  ,"**" , oFont9a)
   ENDIF
   
	oPrn:Say(Linha+10          , 160+20 ,"Admissional" , oFont9a)
	oPrn:Say(Linha+10          , 710 ,"Periódico" , oFont9a)
	oPrn:Say(Linha+10          ,1360 ,"Mudança de Função" , oFont9a)
	oPrn:Say(Linha+10          ,1900 ,"Retorno ao Trabalho" , oFont9a)
	oPrn:Say(Linha+80          , 160+20 ,"Demissional" , oFont9a)


	
	_SALTO:=60
   _IDADE:=INT((DDATABASE-SRA->RA_NASC)/365)
	oPrn:Say(Linha:=Linha+180 ,100,"Funcionário : "             , oFont9a)
	oPrn:Say(Linha:=Linha          ,430,SRA->RA_MAT+"-"+SRA->RA_NOME , oFont9a)
	oPrn:Say(Linha:=Linha+_SALTO   ,100,"Função : "                                                 , oFont9a)
	oPrn:Say(Linha:=Linha          ,430,POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_DESC") , oFont9a)
	oPrn:Say(Linha:=Linha          ,1600,"Data de Nascimento : "+DTOC(SRA->RA_NASC) , oFont9a)
	oPrn:Say(Linha:=Linha+_SALTO   ,100,"Centro de Custo : "                                                               , oFont9a)
	oPrn:Say(Linha:=Linha          ,430,ALLTRIM(SRA->RA_CC)+" - "+Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01"), oFont9a)
	oPrn:Say(Linha:=Linha          ,1600,"Idade : "+STRZERO(_IDADE,2,0) , oFont9a)
	oPrn:Say(Linha:=Linha+_SALTO*1.5 ,100,"Riscos Ocupacionais Específicos : "                                                               , oFont9a)
	oPrn:Say(Linha:=Linha          ,710,IIF(!EMPTY(_RISCOS),_RISCOS,"SEM EXPOSIÇÃO A RISCOS"), oFont9a)
	

	//	oPrn:line( Linha:=Linha+50   ,  80 ,Linha,2260)     // Linha horizontal
	
	oPrn:Box( Linha:=Linha+100,80,Linha+100,2290)
	oPrn:Say(  Linha+30 , 660,  "Procedimentos Médicos / Exames complementares realizados"  , oFont9B )

	LINHA   :=LINHA+100
	oPrn:Box( Linha:=Linha+20,80,Linha+2450,2290)   // BOX GRANDE
	LINHAINI:=LINHA

   FOR I:=1 TO 42 STEP 2//3
      IF EMPTY(_A[I])
         EXIT
      ENDIF   
	   oPrn:Say(  Linha+30 , 100,  _B[I]   + _A[I]+SPACE(3)+DTOC(tmy->tmy_dtprog)  , oFont9B2 )
      IF !EMPTY(_A[I+1])
	      oPrn:Say(  Linha+30 ,1200,  _B[I+1] + _A[I+1]+SPACE(3)+DTOC(tmy->tmy_dtprog)  , oFont9B2 )   // 900
      ENDIF
	   LINHA:=LINHA+40
	   oPrn:line( Linha:=Linha+80,80,Linha,2290)     // Linha horizontal
	   LINHA:=LINHA+20
	NEXT I
	oPrn:line( LINHAINI   ,1190 ,Linha-20,1190)      // Linha VERTICAL

   IF LINHA<2000
      LINHA:=2000
   ENDIF   

	DBSELECTAREA("SRA")

   oPrn:Say( linha:=Linha+20 , 100,  "Conclusão:"  , oFont9B )

	oPrn:Box( Linha:=Linha+60  ,080+20,Linha+80, 140+20)   // BOX 
	oPrn:Box( Linha  ,630,Linha+80, 690)   // BOX 
	oPrn:Box( Linha  ,1280+20,Linha+80,1340+20)   // BOX 
	oPrn:Say(Linha+10          , 160+20 ,"Apto" , oFont9a)
	oPrn:Say(Linha+10          , 710    ,"Inapto" , oFont9a)
	oPrn:Say(Linha+10          ,1360+20 ,"Apto com restrição" , oFont9a)
   LINHA:=LINHA+80
   oPrn:line( Linha:=Linha+80,80,Linha,2290)     // Linha horizontal


   oPrn:Say(  Linha+30 , 100,  "Médico Examinador: "  , oFont9B2 )
   oPrn:Say(  Linha+30 , 1300, "Médico Coordenador: "  , oFont9B2 )
   oPrn:Say(  Linha:=Linha+80 , 1300,  "Data: "+DTOC(tmy->tmy_dtGERA)  , oFont9B2 )

   LINHA:=LINHA+80
   oPrn:line( Linha:=Linha+80,80,Linha,2290)     // Linha horizontal
   oPrn:Say(  Linha+30 , 100,  "Data: "+DTOC(tmy->tmy_dtprog)   , oFont9B2 )
   oPrn:Say(  Linha+30 , 800,  "Recebi a segunda via deste atestado e copia de exames complementares."   , oFont9B2 )
   oPrn:Say(  Linha+90 ,1000,  sra->ra_nome  , oFont9B2 )


oPrn:Preview()
MS_FLUSH()

oPrn:EndPage()



Return







