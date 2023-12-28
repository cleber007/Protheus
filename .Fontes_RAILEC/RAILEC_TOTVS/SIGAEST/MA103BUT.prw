#Include "rwmake.ch"
#Include "Protheus.ch"

#define CRLF Chr(13)+Chr(10)

User Function MA103BUT()
Local aBotao := {}
If INCLUI .Or. ALTERA
   AADD(aBotao,{"VERNOTA",{|| ExecBlock("SELSD2")},"Selecao de Notas Fiscais"} )
   AADD(aBotao,{"ALTTIPO",{|| ExecBlock("ALTTIPO")},"Altera Tipo da Nota"} )
   Return(aBotao)
EndIf
Return(nil)


User Function ALTTIPO()

Local oButton1
Local oButton2
Local oComboBo1
Local oComboBo2
Local oGroup1
Local oSay1
Local oSay2

Private nComboBo1 := Iif(SF1->F1_TIPO=='N',1,Iif(SF1->F1_TIPO=='I',2,Iif(SF1->F1_TIPO=='P',3,4)))
Private nComboBo2 := Iif(Empty(SF1->F1_TPCOMPL),1,Val(SF1->F1_TPCOMPL)+1)

Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Altera Tipo da Nota" FROM 000, 000  TO 150, 400 COLORS 0, 16777215 PIXEL

    @ 004, 004 GROUP oGroup1 TO 051, 196 PROMPT " Tipo de Complementos de CT-e: " OF oDlg COLOR 0, 16777215 PIXEL
    @ 020, 022 SAY oSay1 PROMPT "Tipo de Nota" SIZE 071, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 020, 108 SAY oSay2 PROMPT "Tipo de Complemento" SIZE 074, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 026, 022 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS {"N=Normal","I-Compl. ICMS","P-Compl. IPI","C-Complemento"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 026, 108 MSCOMBOBOX oComboBo2 VAR nComboBo2 ITEMS {" ","1-Preço","2-Quantidade","3-Frete"} SIZE 076, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 054, 112 BUTTON oButton1 PROMPT "Confirmar" ACTION Processa({||AtuTipo()},"Atualizando Tipo de CT-e. Aguarde...") SIZE 040, 012 OF oDlg PIXEL
    @ 054, 158 BUTTON oButton2 PROMPT "Sair"      ACTION oDlg:End() SIZE 037, 012 OF oDlg PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

Return(nil)

Static Function AtuTipo()

Local _cTipo	:= SF1->F1_TIPO
Local _cTpCompl	:= SF1->F1_TPCOMPL
Local lOk		:= .T.

If ValType(nComboBo1)=="N"
	If     nComboBo1 == 1 
		_cTipo := 'I'
	ElseIf nComboBo1 == 2
		_cTipo := 'P'
	ElseIf nComboBo1 == 3
		_cTipo := 'C'
	Else
		_cTipo := 'X'
	EndIf
ElseIf ValType(nComboBo1)=="C"
	If !Empty(SubStr(nComboBo1,1,1))
		_cTipo := SubStr(nComboBo1,1,1)
	Else
		_cTipo := 'N'
	EndIf
Else
	MsgAlert("Erro na montagem do ComboBox do Tipo de Nota !!!")
	lOk := .F.
EndIf	

If 	   ValType(nComboBo2)=="N"
	_cTpCompl := Str(nComboBo2+1)
ElseIf ValType(nComboBo2)=="C"
	_cTpCompl := SubStr(nComboBo2,1,1)
Else
	MsgAlert("Erro na montagem do ComboBox do Tipo de Complemento !!!")
	lOk := .F.
EndIf

If lOk
	SF1->(RecLock("SF1",.F.))
	SF1->F1_TIPO 	:= _cTipo
	SF1->F1_TPCOMPL	:= _cTpCompl
	SF1->(MsUnLock())	
EndIf

BeginSql Alias "QRY"
	SELECT * FROM %Table:SD1%(NOLOCK) 
	 WHERE D1_FILIAL=%Exp:SF1->F1_FILIAL% AND D1_DOC=%Exp:SF1->F1_DOC% AND D1_SERIE=%Exp:SF1->F1_SERIE% AND D1_FORNECE=%Exp:SF1->F1_FORNECE% AND D1_LOJA=%Exp:SF1->F1_LOJA% AND %Table:SD1%.%NotDel%
EndSql

While !QRY->(EOF())
	DbSelectArea("SD1")
	SD1->(DbGoTo(QRY->R_E_C_N_O_))

	RecLock("SD1",.F.)
	SD1->D1_TIPO 	:= SF1->F1_TIPO
	SD1->(MsUnLock())
	
	QRY->(DbSkip())
EndDo

QRY->(DbCloseArea())

_cDescTp	:= Iif(SF1->F1_TIPO   =='N','N-Normal',Iif(SF1->F1_TIPO=='I','I-Compl. Icms',Iif(SF1->F1_TIPO=='P','P-Compl. IPI','C-Complemento')))
_cDescCompl	:= Iif(SF1->F1_TPCOMPL=='1','1-Preço',Iif(SF1->F1_TPCOMPL=='2','2-Quantidade',Iif(SF1->F1_TPCOMPL=='3','3-Frete','')))

MsgAlert("O Tipo da Nota foi alterado para: "+CRLF+CRLF+_cDescTp+CRLF+_cDescCompl+CRLF+CRLF+"Alteração já confirmada e será vista no próximo acesso ao registro.")

oDlg:End()

Return
