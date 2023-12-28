#Include "Protheus.CH"
#INCLUDE "rwmake.ch"
#include "TOTVS.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} nNFeCDT
Description

@param xParam Parameter Description
@return xRet Return Description
@author  -
@since 11/08/2014
/*/
//--------------------------------------------------------------
User Function MsgPreDnf(cNota, cAliasCF, cCliFor, cMsgM1,cMsgM2,cMsgM3,cMsgM4,cMsgM5)

Local aAreaOld       := GetArea()
Local But_Canc
Local But_OK
Local Font_Group     := TFont():New("Arial Rounded MT Bold",,018,,.F.,,,,,.F.,.F.)
Local Font_label     := TFont():New("Arial Rounded MT Bold",,016,,.F.,,,,,.F.,.F.)
Local oGet_CDFORN    := Substr(cCliFor,1,6)
Local oGet_LJ        := Substr(cCliFor,7,2)
Local oGet_Emiss     := DAte()//SF1->F1_EMISSAO
Local oGet_NF        := cNota
Local oGet_NMFORN    := ""//POSICIONE("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"SA2->A2_NOME")
Local oGet_Ser       := ""//SF1->F1_SERIE
Local Group_01
Local Group_02
Local MSG_01         := Space(120)
Local MSG_02         := Space(120)
Local MSG_03         := Space(120)
Local MSG_04         := Space(120)
Local MSG_05         := Space(120)
Local MSG_06         := Space(120)
Local oSay_CDFOR
Local oSay_Emiss
Local oSay_LJFORN
Local oSay_NF
Local oSay_NMFORN
Local oSay_Ser
Local _lExec		 := .F.
Local _cMsgTot := ""
Static oDlg

If cAliasCF == "SA1"
	oGet_NMFORN    := POSICIONE("SA1",1,xFilial("SA1")+ oGet_CDFORN + oGet_LJ,"SA1->A1_NOME")
Else
	oGet_NMFORN    := POSICIONE("SA2",1,xFilial("SA2")+ oGet_CDFORN + oGet_LJ,"SA2->A2_NOME")
EndIf

If !Empty(cMsgM1)
	MSG_01         := Alltrim(cMsgM1)
EndIf

If !Empty(cMsgM2)
	MSG_02         := Alltrim(cMsgM2)
EndIf

If !Empty(cMsgM3)
	MSG_03         := Alltrim(cMsgM3)
EndIf

If !Empty(cMsgM4)
	MSG_04         := Alltrim(cMsgM4)
EndIf

If !Empty(cMsgM5)
	MSG_05         := Alltrim(cMsgM5)
EndIf

DEFINE MSDIALOG oDlg TITLE "Mensagem DANFE" FROM 000, 000  TO 500, 800 COLORS 0, 16777215 PIXEL

@ 011, 006 GROUP Group_01 TO 218, 394 PROMPT "   INFORMAÇÃO COMPLEMENTAR   " OF oDlg COLOR 255, 16777215 PIXEL
@ 100, 016 GROUP Group_02 TO 207, 384 PROMPT "   MENSAGEM   " OF oDlg COLOR 255, 16777215 PIXEL

@ 120, 020 MSGET MSG_01       SIZE 360, 010 Picture X3Picture("C5_MENSA2") OF oDlg COLORS 0, 16777215 PIXEL
@ 132, 020 MSGET MSG_02       SIZE 360, 010 Picture X3Picture("C5_MENSA2") OF oDlg COLORS 0, 16777215 PIXEL
@ 145, 020 MSGET MSG_03       SIZE 360, 010 Picture X3Picture("C5_MENSA2") OF oDlg COLORS 0, 16777215 PIXEL
@ 157, 019 MSGET MSG_04       SIZE 360, 010 Picture X3Picture("C5_MENSA2") OF oDlg COLORS 0, 16777215 PIXEL
@ 170, 020 MSGET MSG_05       SIZE 360, 010 Picture X3Picture("C5_MENSA2") OF oDlg COLORS 0, 16777215 PIXEL
@ 182, 020 MSGET MSG_06       SIZE 360, 010 Picture X3Picture("C5_MENSA2") OF oDlg COLORS 0, 16777215 PIXEL
@ 040, 020 MSGET oGet_NF      SIZE 060, 010 WHEN .F. OF oDlg COLORS 0, 16777215 PIXEL
@ 040, 180 MSGET oGet_Ser     SIZE 030, 010 WHEN .F. OF oDlg COLORS 0, 16777215 PIXEL
@ 040, 320 MSGET oGet_Emiss   SIZE 060, 010 WHEN .F. OF oDlg COLORS 0, 16777215 PIXEL
@ 070, 019 MSGET oGet_CDFORN  SIZE 060, 010 WHEN .F. OF oDlg COLORS 0, 16777215 PIXEL
@ 070, 093 MSGET oGet_LJ      SIZE 027, 010 WHEN .F. OF oDlg COLORS 0, 16777215 PIXEL
@ 070, 133 MSGET oGet_NMFORN  SIZE 247, 010 WHEN .F. OF oDlg COLORS 0, 16777215 PIXEL

@ 033, 031 SAY oSay_NF      PROMPT "NOTA FISCAL"       SIZE 045, 007 OF oDlg FONT Font_label COLORS 16711680, 16777215 PIXEL
@ 033, 182 SAY oSay_Ser     PROMPT "SERIE NF"          SIZE 025, 007 OF oDlg FONT Font_label COLORS 16711680, 16777215 PIXEL
@ 033, 332 SAY oSay_Emiss   PROMPT "EMISSAO NF"        SIZE 038, 007 OF oDlg FONT Font_label COLORS 16711680, 16777215 PIXEL
@ 061, 019 SAY oSay_CDFOR   PROMPT "CÓDIGO FORNECEDOR" SIZE 064, 007 OF oDlg FONT Font_label COLORS 16711680, 16777215 PIXEL
@ 061, 097 SAY oSay_LJFORN  PROMPT "LOJA"              SIZE 025, 007 OF oDlg FONT Font_label COLORS 16711680, 16777215 PIXEL
@ 061, 133 SAY oSay_NMFORN  PROMPT "RAZÃO SOCIAL"      SIZE 051, 007 OF oDlg FONT Font_label COLORS 16711680, 16777215 PIXEL

DEFINE SBUTTON But_OK   FROM 225, 329 TYPE 01 ACTION (_lExec:=.T.,oDlg:End())OF oDlg ENABLE
DEFINE SBUTTON But_Canc FROM 225, 366 TYPE 02 ACTION (oDlg:End()) OF oDlg ENABLE


ACTIVATE MSDIALOG oDlg CENTERED

If _lExec
	If !Empty(MSG_01)
		_cMsgTot := Alltrim(MSG_01) + Chr(13) + Chr(10)
	EndIf
	If !Empty(MSG_02)
		_cMsgTot += Alltrim(MSG_02) + Chr(13) + Chr(10)
	EndIf
	If !Empty(MSG_03)
		_cMsgTot += Alltrim(MSG_03) + Chr(13) + Chr(10)
	EndIf
	If !Empty(MSG_04)
		_cMsgTot += Alltrim(MSG_04) + Chr(13) + Chr(10)
	EndIf
	If !Empty(MSG_05)
		_cMsgTot += Alltrim(MSG_05) + Chr(13) + Chr(10)
	EndIf
	If !Empty(MSG_06)
		_cMsgTot += Alltrim(MSG_06) + Chr(13) + Chr(10)
	EndIf
EndIf

Return(_cMsgTot)
