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
			uReturn := 'Op��es de Cr�dito'
		Else
			uReturn := 'Limite de cr�dito dispon�vel'
		EndIf
	Else
		DEFINE MSDIALOG oDlgHis TITLE "Op��es" FROM 000, 000  TO 040, 500 COLORS 0, 16777215 PIXEL

		@ 003, 003 BUTTON oButton1 PROMPT "Limite de Cr�dito" SIZE 075, 012 OF oDlgHis Action(U_SCRED050()) PIXEL
		@ 003, 086 BUTTON oButton2 PROMPT "Hist�rico de Limite de Cr�dito" When PermUser('2') SIZE 075, 012 OF oDlgHis Action(U_HISTLIM())PIXEL
		@ 003, 170 BUTTON oButton3 PROMPT "Incluir Limite de Cr�dito" When PermUser('1') SIZE 075, 012 OF oDlgHis Action(U_CCRED010()) PIXEL

		/*
		@ 003, 003 BUTTON oButton1 PROMPT "Limite de Cr�dito" SIZE 075, 012 OF oDlgHis Action(oDlgHis:End(),U_SCRED050()) PIXEL
		@ 003, 086 BUTTON oButton2 PROMPT "Hist�rico de Limite de Cr�dito" When PermUser() SIZE 075, 012 OF oDlgHis Action(oDlgHis:End(),U_HISTLIM())PIXEL
		@ 003, 170 BUTTON oButton3 PROMPT "Incluir Limite de Cr�dito" When PermUser() SIZE 075, 012 OF oDlgHis Action(oDlgHis:End(),U_CCRED010()) PIXEL
		*/

		ACTIVATE MSDIALOG oDlgHis CENTERED

	EndIf

Return(uReturn)


//Recebe o tipo 1=Analista de cr�ditos // 2=Permiss�o de ver os limites concedidos
Static Function PermUser(cTip)
	Local _lUsrAut:=.F.
	Local _cCodUsr:=RetCodUsr()
	Local _cCod:=iif(cTip=='1',ALLTRIM(GetMv("AL_ANALCRE")),ALLTRIM(GetMv("AL_HISTCRE")))  //C�digos de usu�rios que receber�o solicita��o de an�lise de cr�ditos
	if _cCodUsr $ _cCod 
		_lUsrAut:=.T.
	Endif
Return _lUsrAut

