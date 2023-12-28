#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "Protheus.ch"
#include "totvs.ch"
#INCLUDE "COLORS.CH"

*******************************
User Function ConsSRA() //26/09/18 -
	*******************************
//Local cTexto := RTRIM(M->ZV0_CODUSR)
	Local bRet := .F.

	Private _cCodZV0:=""
	Public _cMatZV0:=""
	Public _cNomeZV0:=""

//DBSelectArea("SRA")    
	bRet := FiltraSRA()

	If !bRet
		_cMatZV0:=""
		_cNomeZV0:=""
	else

	Endif

Return bRet

	**************************
Static Function FiltraSRA()
	**************************

	Private _bRet := .F.
	Private aDadosSRA := {}

	MsgRun("Selecionando Registros, Aguarde...",,{|| ProcQry()})

	Define MsDialog oDlgSB1 Title "Busca de Funcionarios" From 0,0 To 280, 700 Of oMainWnd Pixel


	@ 5,5 LISTBOX oLstSB1 ;
		VAR lVarMat ;
		Fields HEADER "Matricula", "Nome ", "Filial","E-mail" ;
		SIZE 340,130 On DblClick ( ConfSRA(oLstSB1:nAt, @aDadosSRA, @_bRet) ) ;
		OF oDlgSB1 PIXEL

	oLstSB1:SetArray(aDadosSRA)
	oLstSB1:bLine := { || {aDadosSRA[oLstSB1:nAt,1], aDadosSRA[oLstSB1:nAt,2], aDadosSRA[oLstSB1:nAt,3], aDadosSRA[oLstSB1:nAt,4]} }

	Activate MSDialog oDlgSB1 Centered

Return _bRet

	*************************************************
Static Function ConfSRA(_nPos, aDadosSRA, _bRet)
	*************************************************
	//_cCodZV0:=aDadosSRA[_nPos,3]+aDadosSRA[_nPos,1]
	//M->ZV0_CODUSR:=aDadosSRA[_nPos,1]
	//M->ZV0_NOME  :=aDadosSRA[_nPos,2]

	_cMatZV0:=aDadosSRA[_nPos,1]
	_cNomeZV0:=aDadosSRA[_nPos,2]
	_bRet := .T.
	Close(oDlgSB1)
Return


	***************************
Static Function ProcQry()
	***************************
	aDadosSRA:={}
	cQuery := " SELECT  DISTINCT(RA_MAT),RA_NOME,RA_FILIAL,RA_EMAIL FROM "+ RETSQLNAME("SRA")
	cQuery += " WHERE D_E_L_E_T_=' '"
	cQuery += " AND RA_EMAIL LIKE '%railec.com%'
	cQuery += " and RA_DEMISSA='        '"
	cQuery += " ORDER BY RA_NOME "

	cQuery := ChangeQuery(cQuery)
	cAliasTmp := CriaTrab(Nil,.F.)
	dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAliasTmp, .F., .T.)

	DBSelectArea(cAliasTmp)
	DBGoTop()
	If Eof()
		Alert("Nao há dados!")
		Return .F.
	Endif
	Do While !EOF()
		if  Ascan(aDadosSRA, {|x| AllTrim(Upper(x[1]))==(cAliasTmp)->RA_MAT})==0
			AAdd( aDadosSRA, { (cAliasTmp)->RA_MAT,;
				(cAliasTmp)->RA_NOME,;
				(cAliasTmp)->RA_FILIAL,;
				(cAliasTmp)->RA_EMAIL} )
		endif
		DbSkip()
	Enddo
	DBCloseArea()
Return
