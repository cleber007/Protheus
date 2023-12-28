#Include 'Protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFA070CHK  บ Autor ณ Rafael Almeida     บ Data ณ  21/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricaoณ O ponto de entrada FA070CHK sera executado na entrada da    บฑฑ
ฑฑบ         ณfuncao antes de carregar a tela de baixa do contas a receber บฑฑ
ฑฑบ         ณObsjetivo ้ Solicitar a Aprova็ใo da Baixa.                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ATFA030                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function FA070CHK()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea       := GetArea()
Local aParam      := PARAMIXB	   // Vetor com os parโmetros recebidos pelos pontos de entrada da rotina de baixa de ativo em lote.
Local lRet        := .T.    	   // Variแvel de retorno dos pontos de entrada da rotina de baixa de ativos em lote.
Local _cEmp	      := FWCodEmp()
Local _cEmpPar	   := ""
Local _cFil 	   := FWCodFil()
Local _cFilPar	   := ""
Local _cEmpFil	   := GETMV("AL_PA33EMP")
Local _lPA33FIN   := .F.
Local _lExec	   := .F.
Local cUser       := RetCodUsr()
Local lRetSAI     := .F.
Local _dDatATU    := DATE()


While len(_cEmpFil)>0
	
	_cEmpPar:= SubStr(_cEmpFil,1,2)
	_cFilPar:= SubStr(_cEmpFil,3,2)
	_cEmpFil:= SubStr(_cEmpFil,6,len(_cEmpFil))
	
	IF _cEmp==_cEmpPar .AND. _cFil==_cFilPar
		_lExec:= .T.
	EndIf
Enddo


If _lExec == .F.
	RestArea(aArea)
	Return (.T.)
EndIf

_lPA33FIN	:= GetMv("AL_PA33ATC")

// Valida se customiza็ใo esta ativa
If _lPA33FIN == .F. 
	RestArea(aArea)
	Return (.T.)
EndIf  


	dbSelectArea("SAI") //abre tabela
	dbSetOrder(2)// Index
	If DBSEEK(xFilial("SAI")+cUser)
		lRetSAI := .T.
	EndIf
	
	If !lRetSAI
		_cMenAlert:="Seu usuแrio nใo poderแ realizar a baixa do titulo "+CHR(13)+CHR(10)
		_cMenAlert+="contas a receber, certifique-se que  "+CHR(13)+CHR(10)		
		_cMenAlert+="voc๊ estแ cadastro no sistema como solicitante."+CHR(13)+CHR(10)
		_cMenAlert+="  "+CHR(13)+CHR(10)
		_cMenAlert+="Maiores informa็๕es contatar o departamento. T.I"+CHR(13)+CHR(10)
		_cMenAlert+="ti.alubar@alubar.net"+CHR(13)+CHR(10)
		Aviso("Aviso",_cMenAlert,{"Ok"},2)
		RestArea(aArea)                                          
		Return(.F.)
	EndIf
	dbCloseArea("SAI")  

				If ApMsgNoYes("Voc๊ possui perํodo de Aprova็ใo em aberto?","Aten็ใo")
					lRet := IIF(U_LIBFIN070(cUser,_dDatATU),.T.,U_MSGFIN07())
				Else 
    				U_SOLFIN070(cUser)
					lRet := .F.				
				EndIf	

RestArea(aArea)
Return(lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO4     บ Autor ณ AP6 IDE            บ Data ณ  23/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/  
User Function SOLFIN070(cUser)
                                 
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local oButton1
Local oButton2
Local oGet1
Local cGet11    :=Space(100)
Local oGroup1
Local oGroup2
Local oGroup3
Local oGroup4
Local oSay1  
Local oSay2
Local oSay3
Local oSay4  
Local oGet2
Local oGet3
Local oGet4
Local cGet22    := Space(9)
Local cGet33    := DATE()
Local cGet44    := DATE()
Local dDtAtu    := DATE()




//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Iniciando Processo                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		DEFINE MSDIALOG oDlg TITLE "Solicita็ใo - Baixa de Tํtulos - Contas a Receber" FROM 000, 000  TO 320, 500 COLORS 0, 16777215 PIXEL
			@ 015, 010 GROUP oGroup2 TO 045, 240 PROMPT "Aviso" OF oDlg COLOR 0, 16777215 PIXEL
			@ 027, 017 SAY oSay1 PROMPT "Nใo ้ permitido a Baixa Tํtulos do Contas a Receber.";
			+CRLF+"ษ necessแrio informar o motivo e solicitar autoriza็ใo superior." SIZE 215, 032 OF oDlg COLORS 0, 16777215 PIXEL
			@ 048, 010 GROUP oGroup4 TO 090, 240 PROMPT "Informacoes o Periodo"   OF oDlg COLOR 0, 16777215 PIXEL
			@ 060, 017 SAY oSay3 PROMPT "Perํodo aberto De:"  SIZE 100, 060 OF oDlg COLORS 0, 16777215 PIXEL
		  	@ 060, 100 SAY oSay4 PROMPT "Perํodo aberto Ate:" SIZE 215, 062 OF oDlg COLORS 0, 16777215 PIXEL	  
			@ 067, 017 MSGET oGet3 VAR cGet33 SIZE 055, 010 OF oDlg VALID NAOVAZIO(cGet33) COLORS 0, 16777215  PIXEL WHEN .F.
			@ 067, 100 MSGET oGet4 VAR cGet44 SIZE 055, 010 OF oDlg VALID NAOVAZIO(cGet44) .AND. U_VldDtATE(cGet33,cGet44) COLORS 0, 16777215    PIXEL 		  		  							
		  			
			@ 092, 010 GROUP oGroup3 TO 136, 240 PROMPT "Informe o Motivo" OF oDlg COLOR 0, 16777215 PIXEL
			@ 102, 016 MSGET oGet1 VAR cGet11 SIZE 217, 025 OF oDlg VALID NAOVAZIO(cGet11) COLORS 0, 16777215 PIXEL
			@ 140, 150 BUTTON oButton2 PROMPT "Enviar" SIZE 037, 012 OF oDlg PIXEL ACTION(IIF(U_ValdApro(cUser,cGet33,cGet44),(U_MLFIN070(cUser,cGet11,cGet33,cGet44),oDlg:End()),(U_DatLIB(cUser,cGet33),oDlg:End())))
			@ 140, 200 BUTTON oButton1 PROMPT "Cancelar" SIZE 037, 012 OF oDlg PIXEL Action oDlg:End()
		ACTIVATE MSDIALOG oDlg CENTERED



	
Return ()   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  AlcaFinaStart บAutor  ณDenis Tsuchiya   บ Data ณ  01/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInicia o processo de Al็acada Financeiro Alubar             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//Objetivo: De acordo com o cadastro de Grupos de Aprova็ใo do Financeiro
//elaborar um fonte capaz de controlar as aprova็๕es de acordo com as
//a็oes que cada usuario possui.
User Function MLFIN070(cUser,cMotivo,dDtDe,dDtAte)

Local lOk       := .T.
Local lMonitora := .F.
Local lVisto    := .F.
Local lAprova   := .T.
Local cTipoTit, cAprovador, cVistor, cMonitor, cNomeApro, cNomeUser
Local cStatWF
Local aMonitores   	:= {}
Local aAprovadores	:= {}
Local cMSG
Local cQry 
Local _cAprovador


cQry := ""
cQry += "SELECT "
cQry += "	  AL_COD   "
cQry += "	, AL_DESC  "
cQry += "	, AL_USER  "
cQry += "	, AL_NIVEL "
cQry += "	, AL_CARGO "
cQry += "FROM "       + RetSqlName("SAK") + " AK "
cQry += "INNER JOIN " + RetSqlName("SAL") + " AL "
cQry += "ON AK_USER = AL_USER       "
cQry += "INNER JOIN " + RetSqlName("SAI") + " AI "
cQry += "ON AL_COD = AI_GRPAPRO     "
cQry += "WHERE AK.D_E_L_E_T_ <> '*' "
cQry += "AND   AL.D_E_L_E_T_ <> '*' "
cQry += "AND   AI.D_E_L_E_T_ <> '*' "
cQry += "AND   AL_STATUS = 'A'      "
cQry += "AND   AL_FILIAL='"+xFilial('SAL')+"'  "
cQry += "AND   AI_USER = '" + cUser + "' "
cQry := ChangeQuery(cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMPSAI",.T.,.T.)

dbSelectArea("TMPSAI")
TMPSAI->(dbGotop())
While !TMPSAI->(EOF())

	If TMPSAI->AL_CARGO  == "C"
		aAdd(aAprovadores, {TMPSAI->AL_USER,TMPSAI->AL_CARGO})
	ElseIf TMPSAI->AL_CARGO == "G"
		aAdd(aMonitores,   {TMPSAI->AL_USER,TMPSAI->AL_CARGO})	
	EndIf
	TMPSAI->(dbSkip())
Enddo
TMPSAI->(dbCloseArea())

	_cAprovador := aAprovadores[1][1]

//Envio a solicita็ใo por e-mail ao aprovador
U_NFFIN070(cUser, dDtDe, dDtAte, _cAprovador)
U_UPFIN070( cUser, cMotivo, dDtDe,dDtAte, aAprovadores, aMonitores)
//RAFAEL ALMEIDA NOTIFICAR RELAวรO DE BAIXA 
MSGINFO("E-mail enviado com sucesso para: ("+UsrRetMail(_cAprovador)+"). Favor aguardar o retorno ."+CHR(13)+CHR(10)+;
"Obs.: Caso necessite de altera็ใo de Aprovador, verificar em : Compras / Grupo de Aprovadores .","E-mail OK")


Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  AlcaFinaStart บAutor  ณDenis Tsuchiya   บ Data ณ  01/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInicia o processo de Al็acada Financeiro Alubar             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VldDtATE(cGet33,cGet44)
Local _lRet := .T.
Local _sDtDE  :=  cGet33
Local _sDtATE :=  cGet44

		_cMenAlert:="A data informada no campo DATE ATE nใo pode ser "+CHR(13)+CHR(10)
		_cMenAlert+="menor que a data informada no campo DATA DE"+CHR(13)+CHR(10)		
		_cMenAlert+="Certifique-se."+CHR(13)+CHR(10)
		_cMenAlert+="  "+CHR(13)+CHR(10)
       
			If _sDtATE < _sDtDE
				_lRet := .F.
				Aviso("Alerta",_cMenAlert,{"Ok"},1)
	
			EndIf

Return(_lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  AlcaFinaStart บAutor  ณDenis Tsuchiya   บ Data ณ  01/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInicia o processo de Al็acada Financeiro Alubar             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ValdApro(cUser,cGet33,cGet44)
Local _Ret := .T. 
Local cQry 
            
cQry := ""
cQry += "SELECT"
cQry += " TOP 1 COUNT(*) AS ZTB_PERM"
cQry += "FROM " + RetSqlName("ZTB") + " "
cQry += "WHERE D_E_L_E_T_ <> '*' "
cQry += "AND ZTB_ORIGEM = 'PA38_CTFIN33' "
cQry += "AND ZTB_SEQ = '002' "
cQry += "AND ZTB_CCAMP5 = '" + cUser + "' "
cQry += "AND ZTB_DCAMP2 >= '" + DTOS(cGet33) + "' "
cQry += "AND ZTB_STATUS = 'L'"
cQry += "GROUP BY ZTB_DCAMP2      "
cQry += "ORDER BY ZTB_DCAMP2 DESC "
cQry := ChangeQuery(cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMPZTB",.T.,.T.)

dbSelectArea("TMPZTB")
TMPZTB->(dbGotop())
While !TMPZTB->(EOF())
	If TMPZTB->ZTB_PERM > 0 
		_Ret := .F. 
	EndIf
	TMPZTB->(dbSkip())
Enddo
TMPZTB->(dbCloseArea())


Return(_Ret)   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  AlcaFinaStart บAutor  ณDenis Tsuchiya   บ Data ณ  01/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInicia o processo de Al็acada Financeiro Alubar             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DatLIB(cUser,cGet33)
Local _cMenAlert := ""
Local cQry
Local dDateDE := ""
Local dDateAT := "" 
            
cQry := ""
cQry += "SELECT"
cQry += " TOP 1 ZTB_DCAMP1, ZTB_DCAMP2"
cQry += "FROM " + RetSqlName("ZTB") + " "
cQry += "WHERE D_E_L_E_T_ <> '*' "
cQry += "AND ZTB_ORIGEM = 'PA38_CTFIN33' "
cQry += "AND ZTB_SEQ = '002' "
cQry += "AND ZTB_CCAMP5 = '" + cUser + "' "
cQry += "AND ZTB_DCAMP2 >= '" + DTOS(cGet33) + "' "
cQry += "AND ZTB_STATUS = 'L'"
cQry += "ORDER BY ZTB_DCAMP2 DESC "
cQry := ChangeQuery(cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMPZTB",.T.,.T.)

dbSelectArea("TMPZTB")
TMPZTB->(dbGotop())
While !TMPZTB->(EOF())

	dDateDE := TMPZTB->ZTB_DCAMP1
	dDateAT := TMPZTB->ZTB_DCAMP2

	TMPZTB->(dbSkip())
Enddo
TMPZTB->(dbCloseArea())


		_cMenAlert:="O Us๚ario ainda possui o seguinte perํodo em aberto!"+CHR(13)+CHR(10)
		_cMenAlert+="At้: "+DTOC(STOD(dDateAT))+CHR(13)+CHR(10) 
		_cMenAlert+=" "+CHR(13)+CHR(10)
		_cMenAlert+="Retorne a rotina de BAIXA do Contas a Receber e selecione a Op็ใo 'SIM' "+CHR(13)+CHR(10) 
		_cMenAlert+="para pergunta: ' Voc๊ possui perํodo de Aprova็ใo em aberto? ' "+CHR(13)+CHR(10) 				 		
		
      Aviso("Aviso",_cMenAlert,{"Ok"},3)

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  AlcaFinaStart บAutor  ณDenis Tsuchiya   บ Data ณ  01/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInicia o processo de Al็acada Financeiro Alubar             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LIBFIN070(cUser,_dDatATU)
Local _Ret := .F. 
Local cQry 

cQry := ""
cQry += "SELECT"
cQry += " TOP 1 COUNT(*) AS ZTB_PERM"
cQry += "FROM " + RetSqlName("ZTB") + " "
cQry += "WHERE D_E_L_E_T_ <> '*' "
cQry += "AND ZTB_ORIGEM = 'PA38_CTFIN33' "
cQry += "AND ZTB_SEQ = '002' "
cQry += "AND ZTB_CCAMP5 = '" + cUser + "' "
cQry += "AND ZTB_DCAMP2 >= '" + DTOS(_dDatATU) + "' "
cQry += "AND ZTB_STATUS = 'L'"
cQry += "GROUP BY ZTB_DCAMP2      "
cQry += "ORDER BY ZTB_DCAMP2 DESC "
cQry := ChangeQuery(cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMPZTB",.T.,.T.)


dbSelectArea("TMPZTB")
TMPZTB->(dbGotop())
While !TMPZTB->(EOF())
	If TMPZTB->ZTB_PERM > 0 
		_Ret := .T. 
	EndIf
	TMPZTB->(dbSkip())
Enddo
TMPZTB->(dbCloseArea())

Return(_Ret)   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  AlcaFinaStart บAutor  ณDenis Tsuchiya   บ Data ณ  01/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInicia o processo de Al็acada Financeiro Alubar             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  

User Function MSGFIN07(cUser,_dDatATU) 
Local _Ret := .F.                      

		_cMenAlert:="O seu Us๚ario nใo possui periodo em aberto!"+CHR(13)+CHR(10)		
		_cMenAlert+=" "+CHR(13)+CHR(10) 
		_cMenAlert+="Retorne a rotina de BAIXA do Contas a Receber e selecione a Op็ใo 'NรO' "+CHR(13)+CHR(10) 
		_cMenAlert+="para pergunta: ' Voc๊ possui perํodo de Aprova็ใo em aberto? ' "+CHR(13)+CHR(10) 	
		
      Aviso("Aviso",_cMenAlert,{"Ok"},3)

Return(_Ret)  
