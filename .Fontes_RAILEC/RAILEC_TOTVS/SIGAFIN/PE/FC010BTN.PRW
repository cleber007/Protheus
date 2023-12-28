#include 'TOTVS.ch'
#include 'rwmake.ch'
#include 'dialog.ch'
User function FC010BTN(x)
	Local xoption := PARAMIXB[1]
	Local uReturn
	Local oObjbrw := GetObjBrow()
	Local oButton1
	Local oButton2
	Local oButton3
	Static oDlgHis


	If ( cValToChar(xOption) $ '1.2' )
		If ( xOption == 1 )
			uReturn := 'Opções de Crédito'
		Else
			uReturn := 'Limite de crédito disponível'
		EndIf
	Else
		DEFINE MSDIALOG oDlgHis TITLE "Opções" FROM 000, 000  TO 040, 500 COLORS 0, 16777215 PIXEL

		@ 003, 003 BUTTON oButton1 PROMPT "Limite de Crédito" SIZE 075, 012 OF oDlgHis Action(U_SCRED050()) PIXEL
		@ 003, 086 BUTTON oButton2 PROMPT "Histórico de Limite de Crédito" When PermUser('2') SIZE 075, 012 OF oDlgHis Action(U_HISTLIM())PIXEL
		@ 003, 170 BUTTON oButton3 PROMPT "Incluir Limite de Crédito" When PermUser('1') SIZE 075, 012 OF oDlgHis Action(U_CCRED010()) PIXEL

		/*
		@ 003, 003 BUTTON oButton1 PROMPT "Limite de Crédito" SIZE 075, 012 OF oDlgHis Action(oDlgHis:End(),U_SCRED050()) PIXEL
		@ 003, 086 BUTTON oButton2 PROMPT "Histórico de Limite de Crédito" When PermUser() SIZE 075, 012 OF oDlgHis Action(oDlgHis:End(),U_HISTLIM())PIXEL
		@ 003, 170 BUTTON oButton3 PROMPT "Incluir Limite de Crédito" When PermUser() SIZE 075, 012 OF oDlgHis Action(oDlgHis:End(),U_CCRED010()) PIXEL
		*/

		ACTIVATE MSDIALOG oDlgHis CENTERED

	EndIf

Return(uReturn)


//Recebe o tipo 1=Analista de créditos // 2=Permissão de ver os limites concedidos
Static Function PermUser(cTip)
	Local _lUsrAut:=.F.
	Local _cCodUsr:=RetCodUsr()
	Local _cCod:=iif(cTip=='1',ALLTRIM(GetMv("AL_ANALCRE")),ALLTRIM(GetMv("AL_HISTCRE")))  //Códigos de usuários que receberão solicitação de análise de créditos
	if _cCodUsr $ _cCod 
		_lUsrAut:=.T.
	Endif
Return _lUsrAut

