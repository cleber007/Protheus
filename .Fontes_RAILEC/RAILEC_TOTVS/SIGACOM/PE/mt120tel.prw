#INCLUDE "protheus.ch"
#INCLUDE "parmtype.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

User Function MT120TEL( )

	Local aArea := GetArea()
/*
	If !U_ActiveFunction("MT120TEL")
		Return Nil
	EndIf
*/
	AAdd( aTitles, "Cliente Energia" )
	AAdd( aTitles, "Financeiro Energia" )

	RestArea( aArea )

Return Nil
//////////////////////////////////////////////////////////////////////////////////////////

User Function MT120FOL( )

	Local aArea 	:= GetArea()
	Local nOpc      := PARAMIXB[1]
	Local aPosGet   := PARAMIXB[2]
	//Local _oMemo    := ""
	//Local nVPed 	:= AVALORES[6]
	//Local cCPed		:= CCONDICAO
	//Local dEPed		:= DDATABASE
	//Local  cSayParc	:= ""

	Static     _aIbipora   := {}
/*
	If !U_ActiveFunction("MT120TEL")
		Return Nil
	EndIf
*/
	aadd(_aIbipora, If (nOpc == 4 .OR. nOpc == 2, SC7->C7_COTAFOR, Space(30)))
	aadd(_aIbipora, If (nOpc == 4 .OR. nOpc == 2, SC7->C7_CLIFIM, Space(6)))
	aadd(_aIbipora, If (nOpc == 4 .OR. nOpc == 2, SC7->C7_LOJACF, Space(2)))
	aadd(_aIbipora, If (nOpc == 4 .OR. nOpc == 2, SC7->C7_NOMCLI, Space(60)))
	aadd(_aIbipora, If (nOpc == 4 .OR. nOpc == 2, SC7->C7_ENICMS, Space(100)))
	aadd(_aIbipora, If (nOpc == 4 .OR. nOpc == 2, SC7->C7_ENIPI, Space(100)))
	aadd(_aIbipora, If (nOpc == 4 .OR. nOpc == 2, SC7->C7_ENPISCO, Space(100)))
	aadd(_aIbipora, If (nOpc == 4 .OR. nOpc == 2, SC7->C7_ATODEC, Space(100)))
	aadd(_aIbipora, If (nOpc == 4 .OR. nOpc == 2, SC7->C7_ENTREGA, Space(100)))
	aadd(_aIbipora, If (nOpc == 4 .OR. nOpc == 2, SC7->C7_CONDPAG, Space(100)))
	aadd(_aIbipora, If (nOpc == 4 .OR. nOpc == 2, SC7->C7_FATURA, Space(100)))
	aadd(_aIbipora, If (nOpc == 4 .OR. nOpc == 2, SC7->C7_COBRANC, Space(100)))
	aadd(_aIbipora, If (nOpc == 4 .OR. nOpc == 2, SC7->C7_FORPAG, Space(3)))

	If nOpc <> 1
		@ 006,aPosGet[1,3]+20 SAY OemToAnsi('Orçamento') OF oFolder:aDialogs[2] PIXEL SIZE 075,009
		@ 005,aPosGet[1,4] MSGET _aIbipora[1] PICTURE '@!' OF oFolder:aDialogs[2] PIXEL SIZE 100,009 HASBUTTON
		@ 010,aPosGet[1,1]+155 SAY OemToAnsi('Mensg. PC') OF oFolder:aDialogs[6] PIXEL SIZE 70,009
		@ 020,aPosGet[1,2]+80 MSGET _aIbipora[8] PICTURE '@!' OF oFolder:aDialogs[6] PIXEL SIZE 150,009 HASBUTTON

		@ 006,aPosGet[1,1] SAY OemToAnsi('Cod. Cliente') OF oFolder:aDialogs[7]  PIXEL SIZE 050,009
		@ 005,aPosGet[1,2]-15 MSGET _aIbipora[2] PICTURE '@!' F3"SA1EN" OF oFolder:aDialogs[7] PIXEL SIZE 30,009 HASBUTTON
		@ 020,aPosGet[1,1] SAY OemToAnsi('Loja') OF oFolder:aDialogs[7] PIXEL SIZE 60,009
		@ 019,aPosGet[1,2]-15 MSGET _aIbipora[3] PICTURE '@!' OF oFolder:aDialogs[7] PIXEL SIZE 15,009 HASBUTTON
		@ 034,aPosGet[1,1] SAY OemToAnsi('Cliente') OF oFolder:aDialogs[7] PIXEL SIZE 070,009
		@ 033,aPosGet[1,2]-15 MSGET _aIbipora[4] PICTURE '@!' OF oFolder:aDialogs[7] PIXEL SIZE 150,009 HASBUTTON
		@ 006,aPosGet[1,3] SAY OemToAnsi('ICMS') OF oFolder:aDialogs[7] PIXEL SIZE 50,009
		@ 005,aPosGet[1,4]-15 MSGET _aIbipora[5] PICTURE '@!' OF oFolder:aDialogs[7] PIXEL SIZE 150,009 HASBUTTON
		@ 020,aPosGet[1,3] SAY OemToAnsi('IPI') OF oFolder:aDialogs[7] PIXEL SIZE 50,009
		@ 019,aPosGet[1,4]-15 MSGET _aIbipora[6] PICTURE '@!' OF oFolder:aDialogs[7] PIXEL SIZE 150,009 HASBUTTON
		@ 034,aPosGet[1,3] SAY OemToAnsi('PIS/COFINS') OF oFolder:aDialogs[7] PIXEL SIZE 50,009
		@ 033,aPosGet[1,4]-15 MSGET _aIbipora[7] PICTURE '@!' OF oFolder:aDialogs[7] PIXEL SIZE 150,009 HASBUTTON
		@ 006,aPosGet[1,3]+250 SAY OemToAnsi('Entrega') OF oFolder:aDialogs[7] PIXEL SIZE 50,009
		@ 005,aPosGet[1,4]+200 MSGET _aIbipora[9] PICTURE '@!' OF oFolder:aDialogs[7] PIXEL SIZE 150,009 HASBUTTON

		@ 006,aPosGet[1,1] SAY OemToAnsi('Cond. Pagamento') OF oFolder:aDialogs[8] PIXEL SIZE 070,009
		@ 005,aPosGet[1,2] MSGET _aIbipora[10] PICTURE '@!' OF oFolder:aDialogs[8] PIXEL SIZE 150,009 HASBUTTON
		@ 006,aPosGet[1,1]+300 SAY OemToAnsi('Forma de Pagamento') OF oFolder:aDialogs[8] PIXEL SIZE 070,009
		@ 005,aPosGet[1,2]+280 MSGET _aIbipora[13] PICTURE '@!'F3"24" OF oFolder:aDialogs[8] PIXEL SIZE 50,009 HASBUTTON
		@ 020,aPosGet[1,1] SAY OemToAnsi('Faturamento') OF oFolder:aDialogs[8] PIXEL SIZE 070,009
		@ 019,aPosGet[1,2] MSGET _aIbipora[11] PICTURE '@!' OF oFolder:aDialogs[8] PIXEL SIZE 150,009 HASBUTTON
		@ 034,aPosGet[1,1] SAY OemToAnsi('Cobrança') OF oFolder:aDialogs[8] PIXEL SIZE 070,009
		@ 033,aPosGet[1,2] MSGET _aIbipora[12] PICTURE '@!' OF oFolder:aDialogs[8] PIXEL SIZE 150,009 HASBUTTON

		@ 006,aPosGet[1,3]+200 SAY OemToAnsi('Prefixo : PED') OF oFolder:aDialogs[8] PIXEL SIZE 70,009
		@ 020,aPosGet[1,3]+200 SAY OemToAnsi('Título : '+CA120NUM) OF oFolder:aDialogs[8] PIXEL SIZE 70,009
		@ 034,aPosGet[1,3]+200 SAY OemToAnsi('Tipo : PR') OF oFolder:aDialogs[8] PIXEL SIZE 50,009
/*           
    @ 006,aPosGet[1,3]+300 SAY OemToAnsi("PARCELAS") OF oFolder:aDialogs[8] PIXEL SIZE 150,009
    aParVen 	:= Condicao(nVPed,cCPed,,dEPed)
  	nLin	 := 6
    For w:=1 to len(aParVen)
    	dDtParc	 := aParVen[w,1]
    	nValParc := aParVen[w,2]
    	cSayParc := cValToChar(w)+": R$: "+AllTrim(Transform(nValParc,"@E 99,999,999.99"))+"Venc.: "+Dtoc(dDtParc) 	
    	@ nLin,aPosGet[1,3]+350 SAY OemToAnsi("Parcela")+ cSayParc OF oFolder:aDialogs[8] PIXEL SIZE 150,009
    	nLin:= nLin + 12
    Next w
*/
	Endif

	RestArea( aArea )

Return Nil
/////////////////////////////////////////////////////////////////////////////////////////////////////////

User Function MTA120G2()

	Local aArea := GetArea()
/*
	If !U_ActiveFunction("MT120TEL")
		Return Nil
	EndIf
*/
	SC7->C7_COTAFOR	:= _aIbipora[1]
	SC7->C7_CLIFIM 	:= _aIbipora[2]
	SC7->C7_LOJACF 	:= _aIbipora[3]
	SC7->C7_NOMCLI 	:= _aIbipora[4]
	SC7->C7_ENICMS 	:= _aIbipora[5]
	SC7->C7_ENIPI 	:= _aIbipora[6]
	SC7->C7_ENPISCO := _aIbipora[7]
	SC7->C7_ATODEC	:= _aIbipora[8]
	SC7->C7_ENTREGA	:= _aIbipora[9]
	SC7->C7_CONDPAG	:= _aIbipora[10]
	SC7->C7_FATURA	:= _aIbipora[11]
	SC7->C7_COBRANC	:= _aIbipora[12]
	SC7->C7_FORPAG	:= _aIbipora[13]

	RestArea( aArea )

Return

//////////////////////////////////////////////////////////////////////////////////////////////

User Function MT120FIM()

	Local nOpcao := PARAMIXB[1]   //3=incluir,4=alterar,5=excluir
	Local cNumPC := PARAMIXB[2]   // Numero do Pedido de Compras
	Local nOpcA  := PARAMIXB[3]   // Indica se a ação foi Cancelada = 0  ou Confirmada = 1.
	Local _lPA080618:=GETNEWPAR("AL_PA08618", .F.)//17/01/18 - Projeto 1.01.03.01.09 - PA_008_006_2018 - Fabio Yoshioka

////17/01/18 - Projeto 1.01.03.01.09 - PA_008_006_2018 - Fabio Yoshioka
	if _lPA080618
		if nOpcA==1 .and. nOpcao==4 //confirmado a alteração
			If  U_fVldTyp('Type("_cMotAltPC")=="C"')
				if !empty(alltrim(_cMotAltPc))
					U_GRVZ_1(cNumPC,_cMotAltPc)
				endif
			endif
		endif
	endif
/*
	If !U_ActiveFunction("MT120TEL")
		Return Nil
	EndIf
*/
	If select("TMP01")>0
		DBSelectAREA("TMP01")
		DBCLOSEarea()
	ENDIF

	_cQuery:=" Select * From "+RetSqlName("SC7")
	_cQuery+=" Where D_E_L_E_T_<>'*'"
	_cQuery+=" and C7_FILIAL='"+XFILIAL("SC7")+"' "
	_cQuery+=" and C7_NUM = '" + cNumPC + "' "
	_cQuery+="  AND C7_FORNECE = '"+CA120FORN+"'"
	_cQuery+="  AND C7_LOJA = '"+CA120LOJ+"'"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TMP01', .T., .T.)
	dbSelectArea("TMP01")
	dbGoTop()

	cCusto:=TMP01->C7_CC
	If EMPTY(TMP01->C7_CLIFIM)
		If nOpcao==3 .and. nOpcA==1
			U_FIN050INC(cNumPC,cCusto)
		ElseIF nOpcao==4 .and. nOpcA==1
			U_FIN050ALT(cNumPC)
		ElseIF nOpcao==5 .and. nOpcA==1
			U_FIN050EXC(cNumPC)
		EndIF
	EndIF
	If select("TMP01")>0
		DBSelectAREA("TMP01")
		DBCLOSEarea()
	EndIf

Return

	****************************************
User Function GRVZ_1(_cNPAlt,_cMotGrv) //17/01/19 - Gravo Motivos de alteração do pedido
	****************************************
	Local _cUsrAlt:=usrRetName(&('RETCODUSR()'))
	Local _aAreaAlt:= GetArea()

	Dbselectarea("Z_1")
	Z_1->(RECLOCK("Z_1",.T.))
	Z_1->Z_1_FILIAL:=XFILIAL("Z_1")
	Z_1->Z_1_PEDIDO:=_cNPAlt
	Z_1->Z_1_DTHORA:=DTOS(Date())+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2)
	Z_1->Z_1_USUARI:=_cUsrAlt
	Z_1->Z_1_MOTIVO:=_cMotGrv
	Z_1->(MSUNLOCK())

	RestArea( _aAreaAlt )
Return
