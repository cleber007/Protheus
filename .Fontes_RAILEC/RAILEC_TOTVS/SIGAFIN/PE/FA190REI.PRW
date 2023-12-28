#Include "Protheus.ch"

User Function FA190REI()

Local lRet      := .F.
Local lEndDlg   := .T.
Local aDadosUsr := {}

Local oButton1
Local oButton2
Local oGroup1
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oSay7

Local oGet1
Local oGet2

Local cBanco   := Space(3)
Local cAgencia := Space(5)
Local cConta   := Space(10)
Local cCheque  := Space(15)

Local cGet1 := space(20)
Local cGet2 := space(20)


Static oDlg

DEFINE MSDIALOG oDlg TITLE "Libera Reimpressão de Cheque" FROM 000, 000  TO 230, 360 COLORS 0, 16777215 PIXEL

@ 006, 005 SAY oSay3 PROMPT "Banco"        SIZE 020, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 015, 005 MSGET oGet1 VAR cBanco F3 "SA6" SIZE 012, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 006, 040 SAY oSay4 PROMPT "Agência"      SIZE 021, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 015, 040 MSGET oGet2 VAR cAgencia        SIZE 025, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 006, 080 SAY oSay5 PROMPT "Conta"        SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 015, 080 MSGET oGet3 VAR cConta          SIZE 040, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 006, 130 SAY oSay6 PROMPT "No.Cheque"    SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 015, 130 MSGET oGet4 VAR cCheque         SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL

@ 031, 016 GROUP oGroup1 TO 090, 151 PROMPT " Informe os dados de Usuário e Senha " OF oDlg COLOR 0, 16777215 PIXEL
@ 049, 044 SAY oSay1 PROMPT "Usuário:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 049, 080 MSGET oGet1 VAR cGet1 SIZE 065, 010 OF oGroup1 COLORS 0, 16777215 PIXEL
@ 068, 043 SAY oSay2 PROMPT "Senha:"   SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 068, 080 MSGET oGet2 VAR cGet2 SIZE 065, 010 PASSWORD OF oGroup1 COLORS 0, 16777215 PIXEL

@ 096, 066 BUTTON oButton1 PROMPT "Confirmar" Action(lEndDlg := VldSenha(cGet1,cGet2), lRet := lEndDlg, Iif(lRet,oDlg:End(),.F.)) SIZE 040, 012 OF oDlg PIXEL
@ 096, 114 BUTTON oButton2 PROMPT "Sair"      Action(lEndDlg := .T.,lRet := .F.,oDlg:End()) SIZE 040, 012 OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED VALID lEndDlg

If lRet
	
	DbSelectArea("SEF")
	SEF->(DbSetOrder(1))
	SEF->(DbGoTop())
	
	lOk := .F.
	
	If SEF->(dbSeek(xFilial("SEF")+cBanco+cAgencia+cConta+cCheque))
		
		Do While !SEF->(Eof()) .And. (SEF->EF_FILIAL==xFilial("SEF") .And. SEF->EF_BANCO==cBanco .And. SEF->EF_AGENCIA==cAgencia .And. SEF->EF_CONTA==cConta .And. SEF->EF_NUM==cCheque)
			If SEF->EF_IMPRESS == "S"
				SEF->(RecLock("SEF",.F.))
				SEF->EF_IMPRESS := ""
				SEF->(msUnLock())
				lOk := .T.
			EndIf
			
			SEF->(DbSkip())
			
		EndDo
		
	EndIf
	
	If !lOk
		Aviso("Aviso", "O Cheque informado está com situação diferente de Impresso, verifique se a informação está correta !!!", { "Sair" }, 1)
	EndIf
EndIf

SEF->(DbCloseArea())

Return()


Static Function VldSenha(_cGet1,_cGet2)

Local lRet := .F.

cGet1 := AllTrim(_cGet1)
cGet2 := AllTrim(_cGet2)

PswOrder(2)
If PswSeek(cGet1)
	
	aDadosUsr := PswRet() // Retorna vetor com informações do usuário
	
	If !PswName(cGet2)
		AVISO("Aviso", "Senha de usuário inválida !!!", { "Sair" }, 1)
		lRet := .F.
	Else
		lRet := .T.
	EndIf
Else
	AVISO("Aviso", "Código de usuário não existe !!!", { "Sair" }, 1)
	lRet := .F.
EndIf

If lRet
	DbSelectArea("ZPC")
	ZPC->(DbSetOrder(2))
	ZPC->(DbGoTop())
	
	If ZPC->(!DbSeek(xFilial("ZPC")+aDadosUsr[1][1]))
		AVISO("Aviso", "Usuário sem premissão para Liberação de Reimpressão !!!", { "Sair" }, 1)
		lRet := .F.
	EndIf
	
	ZPC->(DbCloseArea())
EndIf

Return(lRet)
