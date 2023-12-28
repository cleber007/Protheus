#include 'protheus.ch'
#include 'parmtype.ch'
#include "rwmake.ch"                                

User Function FUNCDI1()

cAlias:=ALIAS()

Public cAC := AllTrim(M->CJ_TIPOPRO)

//AxVisual( "SA1", SA1->( Recno() ), 2 )
AxAltera( "SA1", SA1->( Recno() ), 4 )

//aROTAUTO:={}
//A030ALTERA( "SA1", SA1->( Recno() ), 6 )

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
	
	//Alterações para o Projeto Cobre
	//Denis Haruo 30/10/2015
	Do Case
		Case cAC == 'A' .or. Alltrim(cAC) == ''
			IF M2_MOEDA4>0
				_SOM:=_SOM+M2_MOEDA4  //LME dia Aluminio
				_NUM++
			ENDIF
		Case cAC == 'C'
			IF M2_MOEDA7>0
				_SOM:=_SOM+M2_MOEDA7 //LME dia Cobre
				_NUM++
			ENDIF
	End Case
	DBSKIP()
ENDDO
_MEDIA:=_SOM/_NUM

/*
//****************************************** VERIFICA ATRAZOS NO CTAS A RECEBER ***************
_ATRAZADO:=0
_ULTCOM  :=SA1->A1_ULTCOM
_SALDUP  :=SA1->A1_SALDUP
_nDUP    :=0
_nDIAS   :=0
DBSELECTAREA("SE1")
DBSETORDER(2)
DBSEEK(xFILIAL("SE1")+SA1->A1_COD+SA1->A1_LOJA)
WHILE !EOF() .AND. E1_CLIENTE+E1_LOJA==SA1->A1_COD+SA1->A1_LOJA
	IF E1_VENCREA<DDATABASE .AND. E1_SALDO>0
		_ATRAZADO:=_ATRAZADO+E1_SALDO
		_nDUP++
		IF _nDIAS < (DDATABASE-E1_VENCREA)
			_nDIAS := (DDATABASE-E1_VENCREA)
		ENDIF
	ENDIF
	DBSKIP()
ENDDO

@ 1,1 to  150,300 DIALOG oDlg3 TITLE "Situação Financeira"
@ 10, 15 SAY "Tot. Sld em Atraso"
@ 22, 15 SAY "Data Ultima Compra"
@ 34, 15 SAY "Tot. Saldo Devedor"
@ 46, 15 SAY "Num Dupl Atraso   "
@ 58, 15 SAY "Dias Atraso       "
@ 10, 72 GET _ATRAZADO PICTURE "@E 999,999,999.99" SIZE 45,12 WHEN .F.
@ 22, 72 GET _ULTCOM   SIZE 45,12 WHEN .F.
@ 34, 72 GET _SALDUP   PICTURE "@E 999,999,999.99" SIZE 45,12 WHEN .F.
@ 46, 72 GET _nDUP     PICTURE "@E 99999999999999" SIZE 45,12 WHEN .F.
@ 58, 72 GET _nDIAS    PICTURE "@E 999" SIZE 20,12 WHEN .F.

@ 60, 90 BmpButton Type 1 Action Close(oDlg3)
@ 60,120 BMPBUTTON TYPE 5 ACTION uPOS_CLI()

Activate Dialog oDlg3 Centered

//*********************************************************************************************
*/
DBSELECTAREA(cAlias)

RETURN(_MEDIA)
