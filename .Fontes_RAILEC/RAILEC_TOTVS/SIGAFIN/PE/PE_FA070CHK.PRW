#Include 'Protheus.ch'

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA070CHK  � Autor � Rafael Almeida     � Data �  21/07/15   ���
�������������������������������������������������������������������������͹��
���Descricao� O ponto de entrada FA070CHK sera executado na entrada da    ���
���         �funcao antes de carregar a tela de baixa do contas a receber ���
���         �Obsjetivo � Solicitar a Aprova��o da Baixa.                  ���
�������������������������������������������������������������������������͹��
���Uso       � ATFA030                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FA070CHK()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local aArea       := GetArea()
Local aParam      := PARAMIXB	   // Vetor com os par�metros recebidos pelos pontos de entrada da rotina de baixa de ativo em lote.
Local lRet        := .T.    	   // Vari�vel de retorno dos pontos de entrada da rotina de baixa de ativos em lote.
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

// Valida se customiza��o esta ativa
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
		_cMenAlert:="Seu usu�rio n�o poder� realizar a baixa do titulo "+CHR(13)+CHR(10)
		_cMenAlert+="contas a receber, certifique-se que  "+CHR(13)+CHR(10)		
		_cMenAlert+="voc� est� cadastro no sistema como solicitante."+CHR(13)+CHR(10)
		_cMenAlert+="  "+CHR(13)+CHR(10)
		_cMenAlert+="Maiores informa��es contatar o departamento. T.I"+CHR(13)+CHR(10)
		_cMenAlert+="ti.alubar@alubar.net"+CHR(13)+CHR(10)
		Aviso("Aviso",_cMenAlert,{"Ok"},2)
		RestArea(aArea)                                          
		Return(.F.)
	EndIf
	dbCloseArea("SAI")  

				If ApMsgNoYes("Voc� possui per�odo de Aprova��o em aberto?","Aten��o")
					lRet := IIF(U_LIBFIN070(cUser,_dDatATU),.T.,U_MSGFIN07())
				Else 
    				U_SOLFIN070(cUser)
					lRet := .F.				
				EndIf	

RestArea(aArea)
Return(lRet)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO4     � Autor � AP6 IDE            � Data �  23/04/15   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/  
User Function SOLFIN070(cUser)
                                 
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

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




//���������������������������������������������������������������������Ŀ
//� Iniciando Processo                                                  �
//�����������������������������������������������������������������������

		DEFINE MSDIALOG oDlg TITLE "Solicita��o - Baixa de T�tulos - Contas a Receber" FROM 000, 000  TO 320, 500 COLORS 0, 16777215 PIXEL
			@ 015, 010 GROUP oGroup2 TO 045, 240 PROMPT "Aviso" OF oDlg COLOR 0, 16777215 PIXEL
			@ 027, 017 SAY oSay1 PROMPT "N�o � permitido a Baixa T�tulos do Contas a Receber.";
			+CRLF+"� necess�rio informar o motivo e solicitar autoriza��o superior." SIZE 215, 032 OF oDlg COLORS 0, 16777215 PIXEL
			@ 048, 010 GROUP oGroup4 TO 090, 240 PROMPT "Informacoes o Periodo"   OF oDlg COLOR 0, 16777215 PIXEL
			@ 060, 017 SAY oSay3 PROMPT "Per�odo aberto De:"  SIZE 100, 060 OF oDlg COLORS 0, 16777215 PIXEL
		  	@ 060, 100 SAY oSay4 PROMPT "Per�odo aberto Ate:" SIZE 215, 062 OF oDlg COLORS 0, 16777215 PIXEL	  
			@ 067, 017 MSGET oGet3 VAR cGet33 SIZE 055, 010 OF oDlg VALID NAOVAZIO(cGet33) COLORS 0, 16777215  PIXEL WHEN .F.
			@ 067, 100 MSGET oGet4 VAR cGet44 SIZE 055, 010 OF oDlg VALID NAOVAZIO(cGet44) .AND. U_VldDtATE(cGet33,cGet44) COLORS 0, 16777215    PIXEL 		  		  							
		  			
			@ 092, 010 GROUP oGroup3 TO 136, 240 PROMPT "Informe o Motivo" OF oDlg COLOR 0, 16777215 PIXEL
			@ 102, 016 MSGET oGet1 VAR cGet11 SIZE 217, 025 OF oDlg VALID NAOVAZIO(cGet11) COLORS 0, 16777215 PIXEL
			@ 140, 150 BUTTON oButton2 PROMPT "Enviar" SIZE 037, 012 OF oDlg PIXEL ACTION(IIF(U_ValdApro(cUser,cGet33,cGet44),(U_MLFIN070(cUser,cGet11,cGet33,cGet44),oDlg:End()),(U_DatLIB(cUser,cGet33),oDlg:End())))
			@ 140, 200 BUTTON oButton1 PROMPT "Cancelar" SIZE 037, 012 OF oDlg PIXEL Action oDlg:End()
		ACTIVATE MSDIALOG oDlg CENTERED



	
Return ()   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  AlcaFinaStart �Autor  �Denis Tsuchiya   � Data �  01/18/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inicia o processo de Al�acada Financeiro Alubar             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//Objetivo: De acordo com o cadastro de Grupos de Aprova��o do Financeiro
//elaborar um fonte capaz de controlar as aprova��es de acordo com as
//a�oes que cada usuario possui.
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

//Envio a solicita��o por e-mail ao aprovador
U_NFFIN070(cUser, dDtDe, dDtAte, _cAprovador)
U_UPFIN070( cUser, cMotivo, dDtDe,dDtAte, aAprovadores, aMonitores)
//RAFAEL ALMEIDA NOTIFICAR RELA��O DE BAIXA 
MSGINFO("E-mail enviado com sucesso para: ("+UsrRetMail(_cAprovador)+"). Favor aguardar o retorno ."+CHR(13)+CHR(10)+;
"Obs.: Caso necessite de altera��o de Aprovador, verificar em : Compras / Grupo de Aprovadores .","E-mail OK")


Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  AlcaFinaStart �Autor  �Denis Tsuchiya   � Data �  01/18/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inicia o processo de Al�acada Financeiro Alubar             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VldDtATE(cGet33,cGet44)
Local _lRet := .T.
Local _sDtDE  :=  cGet33
Local _sDtATE :=  cGet44

		_cMenAlert:="A data informada no campo DATE ATE n�o pode ser "+CHR(13)+CHR(10)
		_cMenAlert+="menor que a data informada no campo DATA DE"+CHR(13)+CHR(10)		
		_cMenAlert+="Certifique-se."+CHR(13)+CHR(10)
		_cMenAlert+="  "+CHR(13)+CHR(10)
       
			If _sDtATE < _sDtDE
				_lRet := .F.
				Aviso("Alerta",_cMenAlert,{"Ok"},1)
	
			EndIf

Return(_lRet)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  AlcaFinaStart �Autor  �Denis Tsuchiya   � Data �  01/18/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inicia o processo de Al�acada Financeiro Alubar             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  AlcaFinaStart �Autor  �Denis Tsuchiya   � Data �  01/18/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inicia o processo de Al�acada Financeiro Alubar             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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


		_cMenAlert:="O Us�ario ainda possui o seguinte per�odo em aberto!"+CHR(13)+CHR(10)
		_cMenAlert+="At�: "+DTOC(STOD(dDateAT))+CHR(13)+CHR(10) 
		_cMenAlert+=" "+CHR(13)+CHR(10)
		_cMenAlert+="Retorne a rotina de BAIXA do Contas a Receber e selecione a Op��o 'SIM' "+CHR(13)+CHR(10) 
		_cMenAlert+="para pergunta: ' Voc� possui per�odo de Aprova��o em aberto? ' "+CHR(13)+CHR(10) 				 		
		
      Aviso("Aviso",_cMenAlert,{"Ok"},3)

Return()


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  AlcaFinaStart �Autor  �Denis Tsuchiya   � Data �  01/18/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inicia o processo de Al�acada Financeiro Alubar             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  AlcaFinaStart �Autor  �Denis Tsuchiya   � Data �  01/18/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inicia o processo de Al�acada Financeiro Alubar             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  

User Function MSGFIN07(cUser,_dDatATU) 
Local _Ret := .F.                      

		_cMenAlert:="O seu Us�ario n�o possui periodo em aberto!"+CHR(13)+CHR(10)		
		_cMenAlert+=" "+CHR(13)+CHR(10) 
		_cMenAlert+="Retorne a rotina de BAIXA do Contas a Receber e selecione a Op��o 'N�O' "+CHR(13)+CHR(10) 
		_cMenAlert+="para pergunta: ' Voc� possui per�odo de Aprova��o em aberto? ' "+CHR(13)+CHR(10) 	
		
      Aviso("Aviso",_cMenAlert,{"Ok"},3)

Return(_Ret)  
