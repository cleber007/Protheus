#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99

User Function GERA_FUN()

//+-----------------------------------------------------------+
//¦ CRIA ARQUIVO TEMPORARIO                                   ¦
//+-----------------------------------------------------------+
// Estrutura do Arquivo Temporario
aStru := {}
aadd(aStru , {'T_01','C',02,0} )
aadd(aStru , {'T_02','C',04,0} )
aadd(aStru , {'T_03','C',01,0} )
aadd(aStru , {'T_04','C',09,0} )
aadd(aStru , {'T_05','C',40,0} )
aadd(aStru , {'T_06','C',15,0} )
aadd(aStru , {'T_07','C',08,0} )
aadd(aStru , {'T_08','C',03,0} )
aadd(aStru , {'T_09','C',03,0} )
aadd(aStru , {'T_10','C',24,0} )
aadd(aStru , {'T_11','C',04,0} )
aadd(aStru , {'T_12','C',01,0} )
aadd(aStru , {'T_13','C',03,0} )
aadd(aStru , {'T_14','C',04,0} )
aadd(aStru , {'T_15','C',03,0} )
aadd(aStru , {'T_16','C',32,0} )
aadd(aStru , {'T_17','C',09,0} )
aadd(aStru , {'T_18','C',02,0} )
aadd(aStru , {'T_19','C',01,0} )
aadd(aStru , {'T_20','C',01,0} )
aadd(aStru , {'T_21','C',08,0} )
aadd(aStru , {'T_22','C',09,0} )
aadd(aStru , {'T_23','C',05,0} )
aadd(aStru , {'T_24','C',08,0} )
aadd(aStru , {'T_25','C',02,0} )
aadd(aStru , {'T_26','C',01,0} )
aadd(aStru , {'T_27','C',01,0} )
aadd(aStru , {'T_28','C',12,0} )
aadd(aStru , {'T_29','C',15,0} )
aadd(aStru , {'T_30','C',01,0} )
aadd(aStru , {'T_31','C',01,0} )
aadd(aStru , {'T_32','C',01,0} )
aadd(aStru , {'T_33','C',14,0} )
/*
cArqTemp := CriaTrab(aStru , .t.)
dbUseArea(.T.,,cArqTemp,'TRB',.f.)
*/
oTable := FWTemporaryTable():New("TRB", aStru)
oTable:addIndex("01", {"T_01","T_02"})
oTable:create()
TRB:= oTable:GetRealName()

DBSELECTAREA("SRA")
DBSETORDER(1)
DBGOTOP()
While !Eof() 
    _AD:=DTOS(RA_ADMISSA)
    IF RA_SITFOLH=" "
       _AFA:="001"
      ELSEIF RA_SITFOLH="F"
       _AFA:="002"
      ELSEIF RA_SITFOLH="D"
       _AFA:="007"
      ELSEIF RA_SITFOLH="A"
       _AFA:="003"
    ENDIF      
	DBSELECTAREA("TRB")
	RECLOCK("TRB",.T.)
	T_01:="01"                      // CODIGO DO REGISTRO .. 01
	T_02:="00"+SM0->M0_CODIGO
	T_03:="1"
	T_04:="00"+SRA->RA_MAT
	T_05:=SRA->RA_NOME
	T_06:=SRA->RA_APELIDO

	T_07:=SUBSTR(_AD,7,2)+SUBSTR(_AD,5,2)+SUBSTR(_AD,1,4)
	T_08:=_AFA
	T_09:="001"
	T_10:=SRA->RA_CODFUNC
	T_11:=SRA->RA_TNOTRAB
	T_12:=" "
	T_13:=" "
	T_14:="0001"
	T_15:="001"
	T_16:=" "
	T_17:=SRA->RA_CC
	T_18:="01"
	T_19:="1"
	T_20:=SRA->RA_SEXO
	T_21:=" "
	T_22:=SRA->RA_NUMCP
	T_23:=SRA->RA_SERCP
	T_24:=" "
	T_25:=" "
	T_26:="U"
	T_27:="Sim"
	T_28:=SRA->RA_CRACHA
	T_29:=" "
	T_30:="1"
	T_31:="2"
	T_32:="A"
	T_33:=" "

	MSUNLOCK()
	DBSELECTAREA("SRA")
	DBSKIP()
ENDDO


DBSELECTAREA("TRB")
DBGOTOP()
_ARQ:="C:\SENIOR.TXT"
COPY TO &_Arq SDF

dbSelectArea('TRB')
dbCloseArea()
cArqTemp2 := cArqTemp + '.DBF'
Delete File &cArqTemp2


DBSELECTAREA("SRA")           // RETORNA INDICE CONTAS A PAGAR
SET FILTER TO 
DBSETORDER(1)
DBGOTOP()

ALERT("Gerado arquivo "+_ARQ)
 
RETURN

//+--------------------------------------------------------------+
//¦ Fim do Relatorio                                             ¦
//+--------------------------------------------------------------+

***************
STATIC FUNCTION fImpCab()
***************

oPrn:EndPage()
_nLI := 0


//oPrn:line( LI,340,LI+2600,340)
//oPrn:line( LI,570,LI+2600,570)
//oPrn:line( LI,2000,LI+2600,2000)

RETURN Nil

//+--------------------------------------------------------------+
//¦ Fim da Rotina Impressao Cabecalho                            ¦
//+--------------------------------------------------------------+



