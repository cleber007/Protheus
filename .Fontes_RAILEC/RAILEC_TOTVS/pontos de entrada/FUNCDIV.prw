#include 'protheus.ch'
#include "rwmake.ch"                                
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FUNCDIV   ºAutor  ³Microsiga           º Data ³  10/28/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±

±±ºDesc.     ³RETORNA DOLAR DIA ANTERIOR PARA O CAMPO CJ_DOLARO NO ORCAMENTO   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FUNCDIV()

cAlias:=ALIAS()

DBSELECTAREA("SM2")
DBSEEK(DDATABASE-1)

IF !FOUND() .OR. M2_MOEDA2=0 .OR. M2_MOEDA4=0 .OR. M2_MOEDA5=0
	IF !FOUND()
		_MOEDA2:=0 
		_MOEDA4:=0
		_MOEDA6:=0
		_MOEDA7:=0 //Denis Haruo - Projeto Cobre
		_MOEDA8:=0 //Denis Haruo - Projeto Cobre
		_lACHADO:=.F.
	ELSE
		_MOEDA2:=M2_MOEDA2
		_MOEDA4:=M2_MOEDA4
		_MOEDA6:=M2_MOEDA5
		_MOEDA7:=M2_MOEDA7 //Denis Haruo - Projeto Cobre
		_MOEDA8:=M2_MOEDA8 //Denis Haruo - Projeto Cobre
		_lACHADO:=.T.
	ENDIF
	@ 1,1 to  200,300 DIALOG oDlg2 TITLE "Moedas em "+DTOC((DDATABASE-1))
	@ 10, 30 SAY "Dolar   "
	@ 22, 30 SAY "LME dia ALU"
	@ 34, 30 SAY "LME Med3 ALU"     
	@ 46, 30 SAY "LME dia COB" //Denis Haruo - Projeto Cobre
	@ 58, 30 SAY "LME Med3 COB" //Denis Haruo - Projeto Cobre    

	@ 10, 72 GET _MOEDA2 PICTURE "9999999.9999" SIZE 45,12
	@ 22, 72 GET _MOEDA4 PICTURE "9999999.9999" SIZE 45,12
	@ 34, 72 GET _MOEDA6 PICTURE "9999999.9999" SIZE 45,12
	@ 46, 72 GET _MOEDA7 PICTURE "9999999.9999" SIZE 45,12 //Denis Haruo - Projeto Cobre
	@ 58, 72 GET _MOEDA8 PICTURE "9999999.9999" SIZE 45,12 //Denis Haruo - Projeto Cobre
	
	@ 80, 90 BmpButton Type 1 Action Close(oDlg2)
	Activate Dialog oDlg2 Centered
	IF _lAchado
		RECLOCK("SM2",.F.)
	ELSE
		RECLOCK("SM2",.T.)
		REPLACE M2_DATA WITH (DDATABASE-1)
	ENDIF
	REPLACE M2_MOEDA2 WITH _MOEDA2
	REPLACE M2_MOEDA4 WITH _MOEDA4
	REPLACE M2_MOEDA5 WITH _MOEDA6
	REPLACE M2_MOEDA7 WITH _MOEDA7 //Denis Haruo - Projeto Cobre
	REPLACE M2_MOEDA8 WITH _MOEDA8 //Denis Haruo - Projeto Cobre
	SM2->(MSUNLOCK())
ENDIF
DBSELECTAREA(cAlias)

cAlias:=ALIAS()
DBSELECTAREA("SM2")
_MES:=MONTH(DDATABASE)-1
IF _MES=0
	_MES=12
ENDIF
_INI:=CTOD("01/"+STRZERO(_MES,2,0)+"/"+STRZERO(YEAR(DDATABASE-32),4,0))
_NUM:=0
_SOM:=0
DBSEEK(_INI,.T.)
WHILE !EOF() .AND. LEFT(DTOS(M2_DATA),6)=LEFT(DTOS(_INI),6)
	IF M2_MOEDA2>0
		_SOM:=_SOM+M2_MOEDA2
		_NUM++
	ENDIF
	DBSKIP()
ENDDO

_MEDIA:=_SOM/_NUM

DBSELECTAREA(cAlias)

RETURN(_Media)
