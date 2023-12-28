#INCLUDE "PROTHEUS.CH"
#Include "RWMAKE.CH"
#INCLUDE "TBICONN.CH"     
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWADAPTEREAI.CH"

User Function M103HIST(nRecSF1)

Local aHistor	:= {}
Local aRet		:= {}
Local aArea		:= GetArea()
Local aAreaSF1	:= SF1->(GetArea())
//Local cPrefixo	:= IIf(Empty(SF1->F1_PREFIXO),&(SuperGetMV("MV_2DUPREF")),SF1->F1_PREFIXO)

DbSelectArea('SF1')
MsGoto(nRecSF1)
//MsGoto(38443)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui no historico a data de Recebimento da Mercadoria      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(SF1->F1_RECBMTO)
	aAdd(aHistor,{SF1->F1_RECBMTO,"A","  Recebimento do Documento de Entrada."}) //"  Recebimento do Documento de Entrada."
Else
	aAdd(aHistor,{SF1->F1_RECBMTO,"A","  Este Documento de Entrada foi incluido em versões anteriores do sistema."}) //"  Este Documento de Entrada foi incluido em versões anteriores do sistema."
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui no historico a data de Confirmação do Documento       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(SF1->F1_DTCONF)
	aAdd(aHistor,{SF1->F1_DTCONF,"B","  Confirmação do Documento de Entrada."}) //"  Confirmação do Documento de Entrada."
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui no historico a data de Classificacao da NF            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(SF1->F1_STATUS)
	aAdd(aHistor,{SF1->F1_DTDIGIT,"C","  Classificacao do Documento de Entrada."}) //"  Classificacao do Documento de Entrada."
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui no historico a data de Contabilizacao da NF           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(SF1->F1_DTLANC)
	aAdd(aHistor,{SF1->F1_DTLANC,"D","  Contabilizacao do Documento de Entrada."}) //"  Contabilizacao do Documento de Entrada."
EndIf

DbSelectArea("SD1")
DbSetOrder(1)
MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
While !Eof() .And. SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA ==;
		xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inclui no historico a data de Contabilizacao da NF           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do Case
	Case SF1->F1_TIPO == 'N'
		If SD1->D1_QTDEDEV <> 0
			DbSelectArea("SD2")
			DbSetOrder(8)
			MsSeek(xFilial("SD2")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_DOC+SD1->D1_SERIE)
			While !Eof() .And. xFilial("SD2")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_DOC+SD1->D1_SERIE==;
					SD2->D2_FILIAL+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_NFORI+SD2->D2_SERIORI
				If aScan(aHistor,{|x| x[3]=="  Devolucao efetuada : "+SD2->D2_DOC+"/"+SD2->D2_SERIE}) == 0 //"  Devolucao efetuada : "
					aAdd(aHistor,{SD2->D2_EMISSAO,"E","  Devolucao efetuada : "+SD2->D2_DOC+"/"+SD2->D2_SERIE}) //"  Devolucao efetuada : "
				EndIf
				dbSkip()
			End
		EndIf
	EndCase
	DbSelectArea("SD1")
	dbSkip()
EndDo

aSort(aHistor,,,{|x,y| x[2]+DTOC(x[1]) < y[2]+DTOC(y[1])})
aEval(aHistor,{|x| aAdd(aRet,DTOC(x[1])+x[3]) })

RestArea(aAreaSF1)
RestArea(aARea)


DEFINE MSDIALOG oDlg TITLE "Histórico do Documento" FROM 000, 000  TO 200, 500 COLORS 0, 16777215 PIXEL

If Len(aHistor)>0
	@ 010, 010 SAY oSay1 PROMPT DTOC(aHistor[1][1])+"   "+aHistor[1][3] SIZE 235, 008 OF oDlg COLORS 0, 16777215 PIXEL
EndIf
If Len(aHistor)>1
	@ 022, 010 SAY oSay2 PROMPT DTOC(aHistor[2][1])+"   "+aHistor[2][3] SIZE 235, 008 OF oDlg COLORS 0, 16777215 PIXEL
EndIf
If Len(aHistor)>2
	@ 034, 010 SAY oSay3 PROMPT DTOC(aHistor[3][1])+"   "+aHistor[3][3] SIZE 235, 008 OF oDlg COLORS 0, 16777215 PIXEL
EndIf
If Len(aHistor)>3
	@ 046, 010 SAY oSay4 PROMPT DTOC(aHistor[4][1])+"   "+aHistor[4][3] SIZE 235, 008 OF oDlg COLORS 0, 16777215 PIXEL
EndIf
If Len(aHistor)>4
	@ 058, 010 SAY oSay5 PROMPT DTOC(aHistor[5][1])+"   "+aHistor[5][3] SIZE 235, 008 OF oDlg COLORS 0, 16777215 PIXEL
EndIf)
@ 083, 110 BUTTON oButton1 PROMPT "Sair" ACTION oDlg:End() SIZE 037, 012 OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return (.T.)
