#include "rwmake.ch"
#include "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

***********************
USER FUNCTION A140EXC()       //  EXCLUSAO PRE-NOTA FISCAL DE ENTRADA
	***********************
	dbSelectArea("SZ9")
	SZ9->(dbSetOrder(4))
	SZ9->(dbgoTop())

	If SZ9->(dbSeek(xFilial("SZ9") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
		Begin Transaction
			SZ9->(DBRLOCK())
			SZ9->(DBDELETE())
			SZ9->(MSUNLOCK())
		End Transaction
	Endif


	dbSelectarea("XA2")
	XA2->(dbSetorder(2))
	XA2->(dbGotop())

	If XA2->(dbSeek(xFilial("XA2") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
		Do While !XA2->(EOF()) .AND. XA2->XA2_NFISCA == SF1->F1_DOC .AND. XA2->XA2_SERIE == SF1->F1_SERIE .AND. XA2->XA2_CLIFOR == SF1->F1_FORNECE .AND. XA2->XA2_LOJA == SF1->F1_LOJA
			XA2->(dbrLock())
			XA2->(dbDelete())
			XA2->(msUnlock())

			XA2->(dbSkip())
		Enddo

		dbSelectarea("XA1")
		XA1->(dbSetorder(1))
		XA1->(dbGotop())

		If XA1->(dbSeek(xFilial("XA1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
			XA1->(dbrLock())
			XA1->(dbDelete())
			XA1->(msUnlock())
		Endif
	Endif				
Return(.T.)

/*
Local aArea := GetArea()
Local cDoc  := SD1->D1_DOC+SD1->D1_SERIE
Local cForn := SD1->D1_FORNECE+SD1->D1_LOJA
Local cProd := SD1->D1_COD
Local cAlmx := SD1->D1_LOCAL
Local nIndSD1 := SD1->(IndexOrd())
Local nRegSD1 := SD1->(RecNo())
Local lOk    := ALLTRIM(GetMv("MV_PRENF"))

If SD1->D1_TIPO # "N"
Return
EndIf
If !Upper(lOK) $ "SV"   // S = ATUALIZA ESTOQUE REAL / V = ATUALIZA ESTOQUE VIRTUAL (ALMOXARIFADO 99)
Return
EndIf

DbSelectArea("SD1")
DbSetOrder(1)
DbSeek(xFilial("SD1")+cDoc+cForn)

While !Eof() .And. D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA == cDoc+cForn

cProd := SD1->D1_COD
cAlmx := SD1->D1_LOCAL
If Upper(lOK) = "V"   // S = ATUALIZA ESTOQUE REAL / V = ATUALIZA ESTOQUE VIRTUAL (ALMOXARIFADO 99)
cAlmx := "99"
EndIf

DbSelectArea("SB2")
If DbSeek(xFilial("SD2")+cProd+cAlmx)
RecLock("SB2",.F.)
Replace B2_QATU    With B2_QATU - SD1->D1_QUANT
Replace B2_VATU1   With B2_QATU - SD1->D1_TOTAL
Replace B2_QTSEGUM With B2_QTSEGUM - SD1->D1_QTSEGUM
MsUnLock()
EndIf

DbSelectArea("SD1")
DbSkip()

EndDo
DbSetOrder(nIndSD1)
DbGoTo(nRegSD1)
RestArea(aArea)

RETURN
*/


/*
O PONTO DE ENTRADA FA070POS FOI RETIRADO DO ARQUIVO MYFUNC PARA MELHOR CONTROLE DO CALCULO SA MULTA DE TอTULOS VENCIDO
TRANSFERIDO PARA ARQUIVO FA070POS.PRW NA PASTA D:\TOTVS 11\Microsiga\Protheus\RDMAKE\SigaCorp\Financeiro\Altera็ใo de juros
POR WILDNER.PINTO EM 05.02.2015 
*/

/*
//USER FUNCTION FA070POS()   // PONTO DE ENTRADA NA MONTAGEM DA TELA DE BAIXAS A RECEBER

//_cArea   := Alias()
//_nOrd    := IndexOrd()
//nReg     :=RecNo()


//RAFAEL ALMEIDA - SIGACORP 03/12/14
//nMulta   := 0
//nTxMulta := GETMV("AL_E1MULTA")
//dData    := DDataBase
//dVencto  := SE1->E1_VENCREA
//nValorM  := SE1->E1_VALOR

//If SE1->E1_TIPO <> 'RA '
//	If  DTOS(dVencto) < DTOS(dData )
//		nMulta := ((nValorM * nTxMulta)/100)
//		SE1->E1_MULTA := nMulta
//	EndIf
//EndIf


//If SE1->E1_TIPO <> 'RA '
//	If MsgYesNo("Deseja informar Varia็ใo Cโmbial para este tํtulo?","Varia็ใo Cโmbial")
//		U_VarCambial("SE1")
//	EndIf
//EndIf                   

//BEGINDOC
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณComentando a linha ABAIXO,o campo DBAIXA apresentarแ               ณ
//ณa data do vencimento, quando o usuแrio atualizar a data            ณ
//ณpara a data atual, o sistema irแ calcular os juros automaticamente.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ENDDOC
//DBAIXA  :=dDataBase        //COMENTADO PARA A PA FINANCEIRA Q TRATA DE JUROS AUTOMATICOS

//cHist070:="REC TIT:"+SE1->E1_NUM+"/"+ ALLTRIM(SE1->E1_NOMCLI)

//DBSELECTAREA(_cArea)
//DBSETORDER(_nOrd)
//DbGoTo(nReg)

//Return
*/


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CadSDOIN()
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Cadastro DE SALDOS INICIAIS BANCARIOS
	// AUTOR : JOSE NORBERTO MACEDO
	// DATA  : 06/12/2005
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	_cArea := Alias()
	_nOrd  := IndexOrd()
	nReg   := RecNo()

	IF !(PERGUNTE("SDOINI",.T.))
		RETURN Nil
	ENDIF

	DbSelectArea("SA6")
	SA6->(DbSetOrder(1))
	SA6->(DbGotop())
	cCadastro :="SA6 - Cadastro de Saldos Iniciais Bancarios"
	aRotina   := {	{ "Pesquisa ",  'AxPesqui' , 0, 1 },;
	{ "Visualiza",  'AxVisual' , 0, 2 },;
	{ "Manutenc.",  'U_MANUTS' , 0, 3 }}

	MBrowse(16,00,280,350,"SA6",,)
	DbSelectArea(_cArea)
	DbSetOrder(_nOrd)
	DbGoTo(nReg)

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MANUTS()

	DBSELECTAREA("SE8")
	DBSETORDER(1)
	DBSEEK(xFilial("SE8")+SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON+DTOS(MV_PAR01))
	IF FOUND()
		_lACHADO:=.T.
		_SALDO  :=E8_SALATUA
	ELSE
		_lACHADO:=.F.
		_SALDO  :=0
	ENDIF

	@ 1,1 to  200,600 DIALOG oJan2 TITLE "Saldo Bancario"
	@  15,  20 SAY "Data Base : "+DTOC(MV_PAR01)
	@  25,  20 SAY "Banco/Agen: "+SA6->A6_COD+" - "+SA6->A6_AGENCIA+"  Conta "+SA6->A6_NUMCON
	@  35,  20 SAY "------------"+ALLTRIM(SA6->A6_NOME)+" / "+ALLTRIM(SA6->A6_NOMEAGE)
	@  45,  20 SAY ". Saldo  "
	@  45,  75 GET _SALDO PICTURE "@E 999,999.99"

	@ 85, 218 BMPBUTTON TYPE 1 ACTION  Close(oJan2)   // CONFIRMA
	ACTIVATE DIALOG oJan2

	IF _SALDO # E8_SALATUA
		IF _lACHADO
			RECLOCK("SE8",.F.)
			SE8->E8_SALATUA:=_SALDO
			MSUNLOCK()
		ELSE
			RECLOCK("SE8",.T.)
			SE8->E8_FILIAL :=xFilial("SE8")
			SE8->E8_BANCO  :=SA6->A6_COD
			SE8->E8_AGENCIA:=SA6->A6_AGENCIA
			SE8->E8_CONTA  :=SA6->A6_NUMCON
			SE8->E8_DTSALAT:=MV_PAR01
			SE8->E8_SALATUA:=_SALDO
			MSUNLOCK()
		ENDIF

	ENDIF
	DBSELECTAREA("SA6")

RETURN



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION MT100AGR()   // PONTO DE ENTRADA APOS A GRAVAวAO DA NOTA DE ENTRADA

	Local lResult   := .f.				// Resultado da tentativa de comunicacao com servidor de E-Mail
	Local cTitulo1
	Local lRelauth := GetNewPar("MV_RELAUTH",.F.)		// Parametro que indica se existe autenticacao no e-mail
	Local cEmailTo
	Local cEmailBcc:= ""
	Local cError   := ""
	Local lRet	   := .F.
	Local cFrom	   := GetMV("MV_RELACNT")
	Local cConta   := GetMV("MV_RELACNT")
	Local cSenhaX  := GetMV("MV_RELPSW")
	//Local lFirst   := .T.
	//Local cRotina  := "U_"+ProcName(7)
	Local _cEmpNATZ   := SuperGetMv("AL_LNATEMP",.T.,"06") // Empresa que receberแ Tela que solicita natureza caso esta em branco 
	Local _cEmpFIN    := SuperGetMv("AL_LFINEMP",.T.,"06") // Empresa que receberแ notifica็ใo na TELA que titulo foi gerado
	Local _cEmpNfEIC  := SuperGetMv("AL_LEICEMP",.T.,"06") // Empresa que tera processo de NOTA FISCAL DE IMPORTACAO
	Local _cEmpNfMail := SuperGetMv("AL_MAILEMP",.T.,"06") // Empresa que tera e-mail para notificar entrada da nota fiscal
	Local _lAtvFun	  := SuperGetMv("AL_ETQENTR",.T.,.F.)// ativa rotina de etique que esta desenvolvida para sใo paulo
	Local _cEmpSp 	  := SuperGetMv("AL_AMCSP",.T.,"09") // Empresa de Sใo Paulo
	Local _cCodEmp 	  := FWCodEmp()
	Local ni := 1

	//************************* (INICIO) SOLON EM 28/07/2014 ATENDIMENTO PA30_CTALM06
	/*
	If inclui
	dDtReceb := ddatabase
	cF1_NumD := SF1->F1_DOC+"-"+F1_SERIE
	@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("PREENCHER CAMPO")
	@ 02,02 TO 90,190
	@ 10,018 Say " Esta rotina tem como finalidade preencher a data de recebimento "
	@ 18,018 Say " (F1_DTRECEB) para o documento de entrada abaixo citado:    "
	@ 34,018 Say " " + "NUM.DOCUMENTO:    " + cF1_NumD
	@ 50,018 Say " " + "DT.RECEB.: "
	@ 50,058 Get dDtReceb Size 35,15
	@ 70,128 BMPBUTTON TYPE 01 ACTION Rt_dtreceb()
	@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oDlg)
	Activate Dialog oDlg Centered	
	EndIf
	*/
	//************************* (FIM) SOLON EM 28/07/2014 ATENDIMENTO PA30_CTALM06


	nQuant:=0  // ERRO NA NOTA DE IMPORTACAO ... TENTATIVA SOMENTE
	//********************************************************************** HISTORICO FINANCEIRO
	cArea :=Alias()
	nOrd  :=IndexOrd()
	nReg  :=Recno()

	If SM0->M0_CODIGO $ _cEmpNATZ
		DBSELECTAREA("SE2")
		DBSETORDER(6)
		DBSEEK(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC)

		IF FOUND()

			_NATUREZ:=ALLTRIM(SE2->E2_NATUREZ)
			_PAR03  :=SPACE(50)

			@ 1,1 to  200,600 DIALOG oJan2FIN TITLE "Historico :"

			IF EMPTY(_NATUREZ)
				ALERT("A T E N C A O : FAVOR PREENCHER A NATUREZA !!!!!!!")
				@ 50,  20 SAY "Natureza:"
				@ 50,  75 GET _NATUREZ SIZE 20,12 VALID NAOVAZIO() F3 "SED"
			ELSE
				_PAR03  :=ALLTRIM(POSICIONE("SED",1,XFILIAL("SED")+SE2->E2_NATUREZ,"ED_DESCRIC"))
				@ 45,  20 SAY "Referente:"
				@ 60,  20 GET _Par03 SIZE 100,12 VALID NAOVAZIO()
			ENDIF

			@ 85, 218 BMPBUTTON TYPE 1 ACTION  Close(oJan2FIN)   // CONFIRMA
			ACTIVATE DIALOG oJan2FIN

			RECLOCK("SE2",.F.)
			REPLACE E2_HIST    WITH _PAR03         // ATUALIZA HISTORICO DO FINANCEIRO
			REPLACE E2_NATUREZ WITH _NATUREZ       // ATUALIZA NATUREZA  DO FINANCEIRO
			IF DOW(E2_VENCREA)=6                // RETORNAR PRA QUINTA VENCIMENTO REAL DA SEXTA
				_VENCREA:=SE2->E2_VENCREA - 1
				REPLACE E2_VENCREA WITH _VENCREA
			ENDIF
			IF DOW(E2_VENCREA)=4                // RETORNAR PRA TERCA VENCIMENTO REAL DA QUARTA
				_VENCREA:=SE2->E2_VENCREA - 1
				REPLACE E2_VENCREA WITH _VENCREA
			ENDIF
			IF DOW(E2_VENCREA)=2                // RETORNAR PRA QUINTA VENCIMENTO REAL DA SEGUNDA
				_VENCREA:=SE2->E2_VENCREA - 4
				REPLACE E2_VENCREA WITH _VENCREA
			ENDIF

			SE2->(MSUNLOCK())
		ENDIF
	EndIf
	DBSELECTAREA("SE2")
	DBSETORDER(1)


	//******************************************************************* BAIXA QUANTIDADES DO ALMOX 99 (SE PRE-NOTA)
	If ALLTRIM(GetMv("MV_PRENF")) = "V"     // S = ATUALIZA ESTOQUE REAL / V = ATUALIZA ESTOQUE VIRTUAL (ALMOXARIFADO 99)
		DbSelectArea("SB2")
		DBSETORDER(1)
		DbSelectArea("SD1")
		DbSetOrder(1)
		DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

		While !Eof() .And. D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA == SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
			IF SD1->D1_TRANSIT#"S"
				DBSKIP()
				Loop
			ENDIF
			DbSelectArea("SB2")
			If DbSeek(xFilial("SB2")+SD1->D1_COD+"99") .AND. SD1->D1_TRANSIT="S"    // PRE-NOTA JA ADICIONOU ITENS AO ALMOX 99
				RecLock("SB2",.F.)
				Replace B2_QATU    With B2_QATU  - SD1->D1_QUANT
				Replace B2_VATU1   With B2_VATU1 - SD1->D1_TOTAL
				Replace B2_QTSEGUM With B2_QTSEGUM - SD1->D1_QTSEGUM
				MsUnLock()
			ENDIF
			DbSelectArea("SD1")
			DBSKIP()
		ENDDO
	ENDIF

	DBSELECTAREA(cArea)
	DBSETORDER(nOrd)     // VOLTA SIT ORIGINAL
	DBGOTO(nReg)

	cArea:=Alias()
	_PODEMANDAR:=.F.

	DBSELECTAREA("SC7")
	DBSETORDER(1)
	DBSELECTAREA("SC1")
	DBSETORDER(1)
	DBSELECTAREA("SCP")
	DBSETORDER(4)

	DBSELECTAREA("SD1")
	DBSETORDER(1)
	DBSEEK(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)    // POSICIONA NO PRIMEIRO ITEM DA NF
	IF D1_TIPO#"N"
		DBSELECTAREA(cArea)
		RETURN Nil
	ENDIF

	IF ALLTRIM(SD1->D1_CC)$"432/433"                                            // ESPECIFICO gerencia heraldo
		_DESCCC:=ALLTRIM(Posicione("CTT",1,xFilial("CTT")+SD1->D1_CC,"CTT_DESC01"))
		DBSELECTAREA("SE2")
		DBSETORDER(6)
		DBSEEK(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC)
		IF FOUND()
			cEmailTo :="paulino.brito@alubar.net;paulo.resque@alubar.net"
			IF EMPTY(cEmailTo)
				RETURN
			ENDIF
			cTitulo1 := "Inclusao de Tit a Pagar " + SM0->M0_NOMECOM
			cMensagem:= "Incluido titulo a pagar, para fornecedor do seu Centro de Custo, conf abaixo:" + CHR(13) + CHR(10)
			cMensagem:= cMensagem + CHR(13) + CHR(10)

			cMensagem:= cMensagem + "Nota Fiscal: " +SF1->F1_SERIE+"-"+SF1->F1_DOC  + CHR(13) + CHR(10)
			cMensagem:= cMensagem + "CCusto     : " +ALLTRIM(SD1->D1_CC)+"-"+_DESCCC + CHR(13)  + CHR(10)
			cMensagem:= cMensagem + "Fornecedor : " +SF1->F1_FORNECE +"-"+POSICIONE("SA2",1,XFILIAL("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME")       + CHR(13) + CHR(10)
			cMensagem:= cMensagem + "Valor Liq  : " +TRANSFORM(SE2->E2_VALOR,"@EZ 999,999,999.99")          + CHR(13) + CHR(10)
			cMensagem:= cMensagem + "Prev Pagto : " +DTOC(SE2->E2_VENCREA)  + CHR(13) + CHR(10)
			_PODEMANDAR		:=.T.
		ENDIF
	ENDIF

	_CC:=_PC:=_SC:=_RM:= ""
	_EMAIL:=""
	_PRODS:=""

	_cArmazem := _cTESAtEs := _cTESNemail := ""		//--> INCLUIDO: LUIZ SOUSA EM 09/05/2014

	//Incluido por Denis, altera็ใo do layout para HTML
	//29/04/2014
	aCabNF := {}
	aItens := {}
	lPCP := .F.


	DBSELECTAREA("SD1")
	//IF !EMPTY(ALLTRIM(SD1->D1_PEDIDO))                                                            // ESPECIFICO SETOR DE ESTOQUE //ANTERIOR
	//-->IF !EMPTY(ALLTRIM(SD1->D1_PEDIDO))  .AND. !(SF1->F1_ESPECIE $ "NFS/NFS-E")                 // CLAUDIO-SIGACORP 07/01/14 - NAO PERMITIR NF DE SERVIวO.
	IF !EMPTY(ALLTRIM(SD1->D1_PEDIDO))                    											//--> Luiz Sousa-SIGACORP 02/05/14
		cTESNemail := GetMV("AL_TNEMAIL")
		WHILE !EOF() .AND. (D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) = (SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

			_CC:=_CC + SD1->D1_CC+" / "

			//Denis Haruo, 23/10/2014
			If D1_GRUPO == '0202' .or. D1_GRUPO == '0204'
				lPCP := .T.
			EndIf	

			DBSELECTAREA("SC7")
			DBSETORDER(1)
			DBSEEK(xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC)
			IF FOUND()

				_PC:=_PC + SC7->C7_NUM+" / "
				_cArmazem := ALLTRIM(SD1->D1_LOCAL)													//--> INCLUIDO: LUIZ SOUSA EM 23/04/2014
				_cTESAtEs := Alltrim(POSICIONE("SF4",1,XFILIAL("SF4")+SD1->D1_TES,"F4_ESTOQUE"))	//--> INCLUIDO: LUIZ SOUSA EM 02/05/2014
				_cTESNemail := cTESNemail													//--> INCLUIDO: LUIZ SOUSA EM 09/05/2014



				//-->If _cTESAtEs == "S"															//--> INCLUIDO: LUIZ SOUSA EM 02/05/2014
				If !(SD1->D1_TES $ _cTESNemail)														//--> INCLUIDO: LUIZ SOUSA EM 09/05/2014
					********************************************************
					//Adicionando a Matriz de itens (Denis Haruo 29/04/2014)
					********************************************************
					aAdd(aItens, { 	Alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+SC7->C7_PRODUTO,"B1_COD ")),; 		//01-Codigo
					Alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+SC7->C7_PRODUTO,"B1_DESC")),;		//02-Descricใo
					Transform(SC7->C7_QUANT,"@E 999,999,999.99"),; 								//03-Quant PC
					Transform(SD1->D1_QUANT,"@E 999,999,999.99"),;								//04-Quant NF
					SD1->D1_TES,;																//05-TES
					_cTESAtEs,; 																//06-Atualiza Estoque
					Alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+SC7->C7_PRODUTO,"B1_PRATEL")),;	//07-Endere็o
					_cArmazem})																	//08-Local
				EndIf

				DBSELECTAREA("SC1")
				DBSEEK(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC)
				IF FOUND()
					_SC:=_SC + SC1->C1_NUM+" / "
					DBSELECTAREA("SCP")
					DBSEEK(xFilial("SCP")+DTOS(SC1->C1_EMISSAO),.T.)
					WHILE !EOF() .AND. CP_EMISSAO=SC1->C1_EMISSAO
						IF CP_NUMSC+CP_ITSC = SC1->C1_NUM+SC1->C1_ITEM
							_RM:=_RM + SCP->CP_NUM+" / "
							_PODEMANDAR		:=.T.
							_EMAIL:=SCP->CP_EMAIL
						ENDIF
						SCP->(DBSKIP())
					ENDDO
				ENDIF
			ENDIF

			DBSELECTAREA("SD1")
			SD1->(DBSKIP())

		ENDDO

		cEmailTo   :=GetNewPar( "AL_NFEINC","workflow.alubar@alubar.net,jeferson.oliveira@alubar.net,almoxarifado-L@alubar.net," + ALLTRIM(_Email) )  //Alterado por macedo 19/03/14  - exclusao Mauricio

		If lPCP 
			cEmailTo += ";"+"pcp.alubar@alubar.net;laborquali.amc@alubar.net"
		EndIf	

		IF EMPTY(cEmailTo)
			RETURN
		ENDIF

		aAdd(aCabNF, {	SF1->F1_SERIE + "-" + SF1->F1_DOC,;																				//01-Serie/Num
		SF1->F1_FORNECE + "-" + Alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME")),; 	//02-Nome Forn
		_CC,;   																										//03-CCusto
		ALLTRIM(_Email),;																								//04-Solicitante
		_PC,;																											//05-PCs
		_SC,;                                                                                                           //06-SCs
		_RM})																											//07-RCMs
		_PODEMANDAR	:= .T. //sigacorp - CLAUDIO - 08/01/14

	ENDIF

If SM0->M0_CODIGO $ _cEmpNfMail
	IF _PODEMANDAR .and. ( Len(aCabNF) > 0 .and. Len(aItens) > 0 )

		//Inicio da programa็ใo HTML...
		cMensagem := ' '
		cMensagem += ' <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"> '
		cMensagem += '<html>'
		cMensagem += '<head>'
		cMensagem += ' <meta '
		cMensagem += ' content="text/html; charset=ISO-8859-1" '
		cMensagem += ' http-equiv="content-type"> '
		cMensagem += '  <title>Informe de Inc NFE</title> '
		cMensagem += ' </head> '
		cMensagem += ' <body> '
		cMensagem += ' <div style="text-align: center;"><img style="width: 125px; height: 125px;" '
		cMensagem += ' alt="http://www.sigacorp.com.br/alubar/alubar.jpg" '
		cMensagem += ' src="http://www.sigacorp.com.br/alubar/alubar.jpg"><br> '
		cMensagem += ' <br> '
		cMensagem += ' <big style="font-weight: bold; color: rgb(0, 0, 153);"><big>INFORME WORKFLOW<br> '
		cMensagem += ' <small style="color: rgb(0, 0, 0);">Emiss&atilde;o: '+DTOC(dDataBase)+' &agrave;s '+SubStr(Time(),1,5)+'</small><br> '
		cMensagem += ' </big></big></div> '
		cMensagem += ' <br> '
		cMensagem += ' <big>Inclus&atilde;o de Nota Fiscal conforme os dados abaixo:<br> '
		cMensagem += ' <br> '
		cMensagem += ' </big> '

		//Tabela do Cabe็alho
		cMensagem += ' <table style="text-align: left; width: 367px; height: 60px;" border="1" cellpadding="2" cellspacing="2"> '
		cMensagem += ' <tbody> '
		cMensagem += '  <tr> '
		cMensagem += '     	<td style="width: 99px; background-color: rgb(204, 255, 255);">Nota Fiscal:</td> '
		cMensagem += '     	<td style="width: 248px; background-color: rgb(204, 255, 255);">'+aCabNF[1][1]+'</td> '
		cMensagem += '  </tr> '
		cMensagem += '  <tr> '
		cMensagem += '		<td style="width: 99px; background-color: rgb(204, 255, 255);">Fornecedor:</td> '
		cMensagem += '		<td style="width: 248px; background-color: rgb(204, 255, 255);">'+aCabNF[1][2]+'</td> '
		cMensagem += '	</tr> '
		cMensagem += '	<tr> '
		cMensagem += ' 		<td style="width: 99px; background-color: rgb(204, 255, 255);">C. Custo:</td> '
		cMensagem += '      <td style="width: 248px; background-color: rgb(204, 255, 255);">'+aCabNF[1][3]+'</td> '
		cMensagem += ' 	</tr> '
		cMensagem += ' 	<tr> '
		cMensagem += '		<td style="width: 99px; background-color: rgb(204, 255, 255);">Solicitante:</td> '
		cMensagem += ' 		<td style="width: 248px; background-color: rgb(204, 255, 255);">'+aCabNF[1][4]+'</td> '
		cMensagem += '	</tr> '
		cMensagem += '	<tr style="font-weight: bold;" align="center"> '
		cMensagem += '		<td colspan="2" rowspan="1" style="width: 99px; background-color: rgb(51, 204, 255);">RASTREAMENTO</td> '
		cMensagem += '	</tr> '
		cMensagem += '	<tr> '
		cMensagem += '		<td style="width: 99px; background-color: rgb(204, 255, 255);">PC:</td> '
		cMensagem += ' 		<td style="width: 248px; background-color: rgb(204, 255, 255);">'+aCabNF[1][5]+'</td> '
		cMensagem += '	</tr> '
		cMensagem += '	<tr> '
		cMensagem += '  	<td style="width: 99px; background-color: rgb(204, 255, 255);">SC:</td> '
		cMensagem += '		<td style="width: 248px; background-color: rgb(204, 255, 255);">'+aCabNF[1][6]+'</td> '
		cMensagem += ' 	</tr> '
		cMensagem += ' 	<tr> '
		cMensagem += '      <td style="width: 99px; background-color: rgb(204, 255, 255);">RCM:</td> '
		cMensagem += '      <td style="width: 248px; background-color: rgb(204, 255, 255);">'+aCabNF[1][7]+'</td> '
		cMensagem += '	</tr> '
		cMensagem += '  </tbody> '
		cMensagem += ' </table> '

		cMensagem += ' <br> '
		cMensagem += ' <big>Itens:</big><br> '

		//Incํcio da tabela de itens
		cMensagem += ' 	<table style="text-align: left; width: 100%;" border="1" cellpadding="2" cellspacing="2"> '
		cMensagem += '	<tbody> '

		//Header dos Itens
		cMensagem += '	<tr> '
		cMensagem += '		<td style="text-align: center; background-color: rgb(51, 204, 255); font-weight: bold; width: 129px;">C&oacute;digo</td> '
		cMensagem += '		<td style="text-align: center; background-color: rgb(51, 204, 255); font-weight: bold; width: 515px;">Descri&ccedil;&atilde;o</td> '
		cMensagem += '      <td style="text-align: center; background-color: rgb(51, 204, 255); font-weight: bold; width: 101px;">Quant Ped</td> '
		cMensagem += '     	<td style="text-align: center; background-color: rgb(51, 204, 255); font-weight: bold; width: 104px;">Quant NFE</td> '
		cMensagem += '      <td style="text-align: center; background-color: rgb(51, 204, 255); font-weight: bold; width: 59px;">TES</td>  '
		cMensagem += '     	<td style="text-align: center; background-color: rgb(51, 204, 255); font-weight: bold; width: 118px;">Atualiza Est.</td> '
		cMensagem += '      <td style="text-align: center; background-color: rgb(51, 204, 255); font-weight: bold; width: 84px;">Endere&ccedil;o</td> '
		cMensagem += '      <td style="width: 74px; text-align: center; background-color: rgb(51, 204, 255); font-weight: bold;">Armazem</td> '
		cMensagem += '	</tr> '

		//Detalhe dos Itens
		For ni := 1 to Len(aItens)
			cMensagem += ' 	<tr> '
			cMensagem += '		<td style="width: 129px; text-align: center;">'+aItens[ni][1]+'</td> '
			cMensagem += '      <td style="width: 515px; text-align: left;">'+aItens[ni][2]+'</td> '
			cMensagem += '     	<td style="width: 101px; text-align: center;">'+aItens[ni][3]+'</td>  '
			cMensagem += '    	<td style="width: 104px; text-align: center;">'+aItens[ni][4]+'</td>  '
			cMensagem += '      <td style="width: 59px; text-align: center;">'+aItens[ni][5]+'</td> '
			cMensagem += '      <td style="width: 118px; text-align: center;">'+aItens[ni][6]+'</td> '
			cMensagem += '      <td style="width: 84px; text-align: center;">'+aItens[ni][7]+'</td> '
			cMensagem += '      <td style="width: 74px; text-align: center;">'+aItens[ni][8]+'</td> '
			cMensagem += '	</tr> '
		Next

		cMensagem += '  </tbody> '
		cMensagem += ' </table> '
		cMensagem += ' <br> '
		cMensagem += ' <br> '
		cMensagem += ' <span style="color: rgb(204, 0, 0); font-weight: bold;">ATEN&Ccedil;&Atilde;O: N&Atilde;O RESPONDA A ESTE E-MAIL. TRATA-SE DE UMA MENSAGEM '
		cMensagem += ' AUTOM&Aacute;TICA.</span><br style="color: rgb(204, 0, 0); font-weight: bold;"> '
		cMensagem += ' <span style="color: rgb(204, 0, 0); font-weight: bold;">Em caso de d&uacute;vidas contate o departamento de T.I. Alubar pelo '
		cMensagem += ' fone 7193 ou pelo e-mail: ti.alubar@alubar.net.</span><br style="color: rgb(204, 0, 0); font-weight: bold;"> '
		cMensagem += ' <br> '
		cMensagem += ' <br> '
		cMensagem += ' <br> '
		cMensagem += ' </body> '
		cMensagem += ' </html> '

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Tenta conexao com o servidor de E-Mail ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		CONNECT SMTP                         ;
		SERVER 	 GetMV("MV_RELSERV"); 	// Nome do servidor de e-mail
		ACCOUNT  GetMV("MV_RELACNT"); 	// Nome da conta a ser usada no e-mail
		PASSWORD GetMV("MV_RELPSW") ; 	// Senha
		RESULT   lResult             	// Resultado da tentativa de conexใo

		// Se a conexao com o SMPT esta ok
		If lResult

			// Se existe autenticacao para envio valida pela funcao MAILAUTH
			If lRelauth
				lRet := Mailauth(cConta,cSenhaX)
			Else
				lRet := .T.
			Endif

			cTitulo1 := "Workflow Informa: Inclusใo de Nota Fiscal: " + aCabNF[1][1]
			If lRet
				SEND MAIL FROM 	cFrom ;
				TO 				cEmailTo;
				BCC     		cEmailBcc;
				SUBJECT 		cTitulo1;
				BODY 			cMensagem;
				RESULT lResult


				If !lResult
					//Erro no envio do email
					GET MAIL ERROR cError
					MsgStop("Erro no envio de e-mail","erro de envio")
				ELSE
					//-->ALERT("e-mail 2 enviado por " + cEmailTo)
					DISCONNECT SMTP SERVER
				Endif
			Else
				GET MAIL ERROR cError
				MsgStop("Erro de autentica็ใo","Verifique a conta e a senha para envio")
			Endif

			DISCONNECT SMTP SERVER
		Else
			//Erro na conexao com o SMTP Server
			GET MAIL ERROR cError
			MsgStop("Erro de CONEXAO COM SMTP","ERRO DE CONEXAO COM SMTP...")
		Endif
	Else

		//MSGInfo("Nใo serแ enviado e-mail pois a NF nใo possui pedido.") 	//--> Luiz Sousa-SIGACORP 29/05/2014
		MSGInfo("Nใo sera enviado e-mail desta Nota, pois uma das regras abaixo nใo foi atendida:" + CHR(13) + CHR(10) +;
		"   1- A TES deve ser diferente de 198" + CHR(13) + CHR(10) +;
		"   2- A Nota deve possuir Pedido." ,;
		"ATENวรO -> " + UPPER(ALLTRIM(CUSERNAME)) )

	EndIf
EndIf	

	DBSELECTAREA(cArea)

	/*------------------------------------------------------------------------
	|Programa:		MT100AGR															|
	|Autor:		Wildner Pinto - Sigacorp											|
	|Data:			17/10/2013															|
	|Descricao:	Ponto de Entrada Executado nos programas MATA103 e MATA100	|
	|Uso:			Sera utilizado Para:												|
	|				1 ) Chama a fun็ใo para exibi็ใo dos tํtulos gerados no		|
	|				Financeiro E2														|
	------------------------------------------------------------------------*/
	If inclui .And. SM0->M0_CODIGO $ _cEmpFIN
		U_SGCSE2Exibe()
	EndIf


	*************************************************
	//Para incluir a informa็ใo do titulo na
	//tabela controle de Titulo CP (ZE2)
	*************************************************
	//Incluindo a movimenta็ใo no controle de Tํtulos
	*************************************************
	//Rodando somente na base Teste!
	//Alubar Metais.
	If cEmpAnt <> '06'
		Return()
	EndIf

	//If !(GetServerIP() == '172.28.1.24')

	If Inclui

		//Incluindo os todos tํtulos gerados pela NF. Parcela, TX...
		cQuery := ""
		cQuery += " SELECT * FROM "+RetSQLName("SE2")+" "
		cQuery += "	WHERE 	E2_FILIAL = '"+xFilial("SE2")+"' AND "
		cQuery += "			E2_PREFIXO = '"+SE2->E2_PREFIXO+"' AND "
		cQuery += "			E2_NUM = '"+SE2->E2_NUM+"' AND "
		cQuery += "			E2_FORNECE = '"+SE2->E2_FORNECE+"' AND "
		cQuery += "			E2_LOJA = '"+SE2->E2_LOJA+"' AND "
		cQuery += "			D_E_L_E_T_ <> '*' "
		cQuery := ChangeQuery(cQuery)
		DBUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRY", .F., .T.)
		DBSelectArea("QRY")
		cCodusu := RetCodUsr()
		cNome := UsrRetName(RetCodUsr())
		Do While !EOF()

			DBSelectArea("ZE2")
			Reclock("ZE2",.T.)
			ZE2->ZE2_FILIAL := xFilial("ZE2")
			ZE2->ZE2_PREFIX := QRY->E2_PREFIXO
			ZE2->ZE2_NUM 	:= QRY->E2_NUM
			ZE2->ZE2_PARCEL := QRY->E2_PARCELA
			ZE2->ZE2_TIPO 	:= QRY->E2_TIPO
			ZE2->ZE2_FORNEC := QRY->E2_FORNECE
			ZE2->ZE2_LOJA	:= QRY->E2_LOJA
			ZE2->ZE2_NOMFOR := QRY->E2_NOMFOR
			ZE2->ZE2_SEQ 	:= "000"
			ZE2->ZE2_STATUS := "BL"
			ZE2->ZE2_TPAPRO := "I"
			ZE2->ZE2_USER 	:= cCodusu
			ZE2->ZE2_NOMEUS	:= cNome
			ZE2->ZE2_HISTOR	:= "INCLUSAO TITULO CONTAS A PAGAR"
			ZE2->ZE2_DTDIGI	:= STOD(QRY->E2_DIGIREA)
			MSUnlock()

			//Bloqueando titulo no SE2
			DBSelectArea("SE2")
			Reclock("SE2",.F.)
			SE2->E2_STATWF := "BL"
			SE2->E2_NUMSEQ := "000"
			MSUnlock()

			DbSelectArea("QRY")
			DBSkip()

		EndDo
		QRY->(DBCloseArea())

	EndIf

	//EndIf


If SM0->M0_CODIGO $ _cEmpNfEIC   
	/*|----------------------------------------------------------------#/
	|Demanda:       ETIQUETA ZEBRA
	|Programa:		MT100AGR															|
	|Autor:		    Rafael Almeida - Sigacorp											|
	|Data:			10/07/2014
	|Uso:           Serแ usada para redirecionar a rotina para impressใo
	|               de Etiqueta Zebra na entrada da NF exceto a TES 198
	|               que ้ TES de Servi็o.
	/#|----------------------------------------------------------------*/
	If !FunName()$"MATA310"   // RAFAEL ALEMIDA - SIGACORP (08/09/2016)

		If (inclui .And. SF1->F1_EST <> "EX")   //RAFAEL ALMEIDA
			DBSELECTAREA("SD1")
			DBSETORDER(1)
			U_PEetiq(SD1->D1_DOC, SD1->D1_SERIE, SD1->D1_DTDIGIT, SD1->D1_PEDIDO, SD1->D1_FORNECE)
		EndIf


		/*|----------------------------------------------------------------#/
		|Demanda:       Declara็ใo de Importa็ใo - DI
		|Programa:		MT100AGR											|
		|Autor:		    Rafael Almeida - Sigacorp							|
		|Data:			22/07/2014
		|Uso:           Serแ usada para redirecionar a rotina para gerar
		|               os registros da tabela CD5
		/#|----------------------------------------------------------------*/
/* FUNวรO FOI COMENTADO POIS PASSOU PARA MT103FIM
		If inclui
			U_PEImpCD5()
		EndIf
*/

		/*|----------------------------------------------------------------#/
		|Demanda:       Declara็ใo de Importa็ใo - DI
		|Programa:		MT100AGR											|
		|Autor:		    Rafael Almeida - Sigacorp							|
		|Data:			19/08/2014
		|Uso:           Serแ usada para redirecionar a rotina para gerar
		|               os registros da tabela CDT
		/#|----------------------------------------------------------------*/
/* FUNวรO FOI COMENTADO POIS PASSOU PARA MT103FIM		
		If inclui
			U_PENFeCDT()
		EndIf
*/		          
	EndIf	
EndIf



If _lAtvFun 
	If _cCodEmp $ _cEmpSp
		DBSELECTAREA("SD1")
		DBSETORDER(1)
		U_EtqPeMt103(SD1->D1_DOC, SD1->D1_SERIE, SD1->D1_DTDIGIT, SD1->D1_PEDIDO, SD1->D1_FORNECE)
	EndIf
EndIf



	//17/04/17 - Fabio Yoshioka - Cria็ใo de envio de notifica็ใo quando a NFe for dada entrada
	//	If !ALTERA 
	//if !empty(alltrim(SD1->D1_PEDIDO)) .and.  !empty(alltrim(SD1->D1_TES))

	IF !EMPTY(ALLTRIM(_PC))		
		U_NOTFCPNF(_PC)										
		//	DbSelectArea("FIE")
		//	DbSetOrder(1)		
		//	If DbSeek(xFilial("FIE")+'P'+SD1->D1_PEDIDO)    
		//U_NOTFCPNF(SD1->D1_PEDIDO)										
		//	EndIf
	ENDIF
	//	EndIf

RETURN Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CadSE2()

	_cArea := Alias()
	_nOrd  := IndexOrd()
	nReg   := RecNo()

	DbSelectArea("SE2")
	SE2->(DbSetOrder(1))
	SE2->(DbGotop())
	cCadastro :="Acerta Cod Reten็ใo de Impostos"
	aRotina   := {{ "Pesquisa ",  'AxPesqui' , 0, 1 },;
	{ "Visualiza",  'AxVisual' , 0, 2 },;
	{ "Manutenc.",  'U_CODRET_', 0, 3 }}
	MBrowse(16,00,280,350,"SE2",,)
	DbSelectArea(_cArea)
	DbSetOrder(_nOrd)
	DbGoTo(nReg)
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CODRET_()

	_CODRET:=E2_CODRET
	_DIRF  :=E2_DIRF

	@ 1,1 to  200,600 DIALOG oJan2CR TITLE "Acerta Cod Reten็ใo de Impostos"
	@  15,  20 SAY "Vencto    : "+DTOC(E2_VENCREA)+" -  Hist: "+E2_HIST
	@  25,  20 SAY "Valor     : "+ALLTRIM(STR(E2_VALOR,12,2))
	@  45,  20 SAY ". COD RET"
	@  45,  75 GET _CODRET PICTURE "9999" F3 "37"
	@  65,  20 SAY ". DIRF ? 1-Sim 2-Nao"
	@  65,  75 GET _DIRF   PICTURE "9" VALID PERTENCE("12")


	@ 85, 218 BMPBUTTON TYPE 1 ACTION  Close(oJan2CR)   // CONFIRMA
	ACTIVATE DIALOG oJan2CR

	IF E2_CODRET#_CODRET .OR. E2_DIRF#_DIRF
		RECLOCK("SE2",.F.)
		SE2->E2_CODRET:=_CODRET
		SE2->E2_DIRF  :=_DIRF
		MSUNLOCK()
		ALERT("Alterado !!!!")
	ENDIF

RETURN


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ACEDEV_()    // RELACIONA AS DEVOLUวีES (SD1) COM AS NOTAS DE SAIDA (SD2)

	DBSELECTAREA("SD2")
	DBSETORDER(3)  // D2_DOC+D2_SERIE+D2_CLIENTE

	DBSELECTAREA("SD1")
	DBSETORDER(1)
	SET FILTER TO !EMPTY(D1_NFORI)
	DBGOTOP()
	_T:=0
	WHILE !EOF()
		DBSELECTAREA("SD2")
		DBSEEK(xFilial("SD2")+SD1->D1_NFORI)
		WHILE !EOF() .AND. D2_DOC==SD1->D1_NFORI
			IF D2_CLIENTE==SD1->D1_FORNECE .AND. D2_QTDEDEV+D2_VALDEV=0
				RECLOCK("SD2",.F.)
				SD2->D2_QTDEDEV:=SD2->D2_QUANT
				SD2->D2_VALDEV :=SD2->D2_TOTAL
				MSUNLOCK()
				_T++
			ENDIF
			SD2->(DBSKIP())
		ENDDO
		DBSELECTAREA("SD1")
		SD1->(DBSKIP())
	ENDDO

	DBSELECTAREA("SD1")
	SET FILTER TO
	DBSELECTAREA("SD2")
	DBSETORDER(1)
	ALERT(_T)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  FA080POS    บAutor  ณMicrosiga           บ Data ณ  05/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPONTO DE ENTRADA : BAIXA A PAGAR MANUAL                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
// PONTO DE ENTRADA : BAIXA A PAGAR MANUAL
User Function FA080POS()

	//Local cLastStatus := ""

	_cArea := Alias()
	_nOrd  := IndexOrd()

	_a:=cBANCO
	_b:=CAGENCIA
	_c:=CCONTA

	If SE2->E2_TIPO <> 'PA '

		cBenef   := SA2->A2_NOME   // variavel interna

		@ 00,00 TO 250,450 DIALOG oDlgX TITLE "Numera็โo Automแtica de CHEQUES"
		@ 05,05 TO 120,205 TITLE " Parametros "

		@ 65-20,008 Say "C๓digo do Banco"
		@ 80-20,008 SAY "Agencia"
		@ 95-20,008 SAY "Conta Corrente"

		@ 65-20,060 GET cBANCO   F3 "SA6"
		@ 80-20,060 GET CAGENCIA
		@ 95-20,060 GET CCONTA

		@ 100,120 BMPBUTTON TYPE 01 ACTION BoletaOK()
		@ 100,160 BMPBUTTON TYPE 02 ACTION BoletaNO()

		ACTIVATE  DIALOG oDlgX CENTER

	Else
		//Verifico na tabela ZPA os dados bancarios de pagamento.
		/*	DBSelectArea("ZPA")
		DBSetOrder(1)
		IF DBSeek(xFilial("SE2")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
		cBANCO	:= ZPA->ZPA_BANCO
		CAGENCIA:= ZPA->ZPA_AGENC
		CCONTA 	:= ZPA->ZPA_CONTA
		ccheque := ZPA->ZPA_NUMCHQ
		cBenef  := ZPA->ZPA_BENEF
		EndIf 
		DBSelectArea("SE2")   */
	EndIf

	//Por Denis - Informar a varia็ใo cโmbial do titulo
	//30 Jan 2014
	/* INOVATIVA - Evandro Lima (17/08/2016).
	*  Essa rotina foi inibida aqui e passou para o PE F080MENS, devido restri็ใo na variแvel de decrescimo (nDecrescF).
	*  Maiores informa็๕es, verificar chamado Totvs TVUEW5
	*
	aVarCamb := {}
	If SE2->E2_TIPO <> 'PA '
	If MsgYesNo("Deseja informar Varia็ใo Cโmbial para este tํtulo?","Varia็ใo Cโmbial")
	U_VarCambial("SE2")
	EndIf
	EndIf
	*/
	//FIM//

	//Denis Haruo 18/nov/2014
	//Compatibilizando a data de debito do titulo
	//com a database do sistema.
	dBaixa := dDataBase
	dDebito := dDataBase
	nMulta := SE2->E2_MULTA


	DbSelectArea(_cArea)
	DbSetOrder(_nOrd)

Return


/*
Local cLastStatus := ""

_cArea := Alias()
_nOrd  := IndexOrd()

_a:=cBANCO
_b:=CAGENCIA
_c:=CCONTA

cBenef   := SA2->A2_NOME   // variavel interna

@ 00,00 TO 250,450 DIALOG oDlgX TITLE "Numera็โo Automแtica de CHEQUES"
@ 05,05 TO 120,205 TITLE " Parametros "

@ 65-20,008 Say "C๓digo do Banco"
@ 80-20,008 SAY "Agencia"
@ 95-20,008 SAY "Conta Corrente"

@ 65-20,060 GET cBANCO   F3 "SA6"
@ 80-20,060 GET CAGENCIA
@ 95-20,060 GET CCONTA

@ 100,120 BMPBUTTON TYPE 01 ACTION BoletaOK()
@ 100,160 BMPBUTTON TYPE 02 ACTION BoletaNO()

ACTIVATE  DIALOG oDlgX CENTER

//Por Denis - Informar a varia็ใo cโmbial do titulo
//30 Jan 2014
If SE2->E2_TIPO <> 'PA '
If MsgYesNo("Deseja informar Varia็ใo Cโmbial para este tํtulo?","Varia็ใo Cโmbial")
U_VarCambial("SE2")
EndIf
EndIf
//FIM//

//Denis Haruo 18/nov/2014
//Compatibilizando a data de debito do titulo
//com a database do sistema.
dBaixa := dDataBase
dDebito := dDataBase

DbSelectArea(_cArea)
DbSetOrder(_nOrd)

Return
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BoletaOK()
	Close(oDlgX)
	IF !EMPTY(cBANCO)
		ccheque :=STRZERO((VAL(SA6->A6_ULTCHQ)+1),6,0)
		RECLOCK("SA6",.F.)
		SA6->A6_ULTCHQ:=ccheque
		MSUNLOCK()
	ENDIF
RETURN .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BoletaNO()

	Close(oDlgX)
	cBANCO  :=_a
	CAGENCIA:=_b
	CCONTA  :=_c

RETURN .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CadZZU()
	//*********************************************************************************

	_cArea := Alias()
	_nOrd  := IndexOrd()
	nReg   :=RecNo()


	DbSelectArea("ZZU")
	DbGotop()

	cCadastro:="ZZU - DEMONSTRATIVOS DE DESPESAS DE IMPORTAวรO"
	aRotina := { { "Pesquisa ",  'AxPesqui'            , 0, 1 },;
	{ "Visualizar" ,"AxVisual"            , 0, 2},;
	{ "Inclui    " ,"AxInclui"            , 0, 3},;
	{ "Altera    " ,"AxAltera"            , 0, 4},;
	{ "Exclui    " ,"AxDeleta"            , 0, 5},;
	{ "Relatorio " ,"U_IMPZZU"            , 0, 6}}

	mBrowse(16,00,280,350,"ZZU")

	DbSelectArea("ZZU")
	SET FILTER TO

	dbSelectArea(_cArea)
	DbSetOrder(_nOrd)
	DbGoTo(nReg)

Return(nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IMPZZU()

	CbTxt:=""
	CbCont:=""
	nOrdem :=0
	Alfa := 0
	Z:=0
	M:=0
	tamanho:="M"
	limite:=220
	titulo   := PADC("Relatorie de Demonstrativos de Despesas",74)
	cDesc1   := PADC(" ",74)
	cDesc2   := PADC(" ",74)
	cDesc3   := PADC(" ",74)
	aReturn  := { "Especial", 1,"Administracao", 2, 2, 1,"",1 }
	nPag     := 0
	nomeprog := "IMPZZU"
	cPerg    := "IMPZZU"
	wnrel    := "IMPZZU"
	nLastKey := 0
	lContinua:= .T.
	cString:= "ZZU"


	Private oFont, cCode
	Private aOkImp := .f.

	nHeight:=15
	lBold:= .F.
	lUnderLine:= .F.
	lPixel:= .T.
	lPrint:=.F.
	nSedex := 1

	oFont := TFont():New( "Arial",,nHeight,,lBold,,,,,lUnderLine )

	oFont1:= TFont():New( "Times New Romam",,08,,.F.,,,,,.f. )
	oFont2:= TFont():New( "Times New Romam",,10,,.t.,,,,,.f. )
	oFont3:= TFont():New( "MicrogrammaDBolExt",,18,,.T.,,,,,.F. )
	oFont4:= TFont():New( "MicrogrammaDMedExt",,14,,.T.,,,,,.F. )

	oFont5:= TFont():New( "Arial",,11,,.T.,,,,,.F. )

	oFont6:= TFont():New( "Arial",,14,,.T.,,,,,.F. )

	oFont7:=  TFont():New( "Arial",,10,,.F.,,,,,.F. )
	oFont7B:= TFont():New( "Arial",,11,,.T.,,,,,.F. )
	oFont9a:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)


	oPrn := TMSPrinter():New()
	oPrn:Setup()


	//+--------------------------------------------------------------+
	//ฆ Envia controle para a funcao SETPRINT                        ฆ
	//+--------------------------------------------------------------+

	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,"M","",.T.)

	If nLastKey == 27 .or. Lastkey() == 27
		Return
	Endif

	//+--------------------------------------------------------------+
	//ฆ Verifica Posicao do Formulario na Impressora                 ฆ
	//+--------------------------------------------------------------+
	SetDefault(aReturn,cString)

	If nLastKey == 27 .or. Lastkey() == 27
		Return
	Endif

	cabec1 :=ALLTRIM(SM0->M0_NOMECOM)
	cabec2 :="PAGINA:  "
	cBitMap:= "logo.Bmp"
	_nLI:=3000

	_TOTAL:=0
	DBSELECTAREA("ZZU")
	DBGOTOP()
	While !Eof()

		IF _nLI >= 2900
			fImpCab()
		ENDIF

		oPrn:Say( _nLI:=_nLI + 50 , 050,ZZU_NUMDEM, oFont7)
		oPrn:Say( _nLI            , 200,ZZU_FORN+" "+ZZU_LOJA, oFont7)
		oPrn:Say( _nLI            , 400,POSICIONE("SA2",1,XFILIAL("SA2")+ZZU->ZZU_FORN+ZZU->ZZU_LOJA,"A2_NOME"), oFont7)
		oPrn:Say( _nLI            ,1050,DTOC(ZZU_DTCOMP), oFont7)
		oPrn:Say( _nLI            ,1250,ZZU_NFISCA+" "+ZZU_SERIE, oFont7)
		oPrn:Say( _nLI            ,1450,ZZU_HIST, oFont7)

		oPrn:Say( _nLI          ,2200,TRANSFORM(ZZU_VALOR,"@E 999,999,999.99"), oFont9a)
		_TOTAL:=_TOTAL + ZZU_VALOR


		DBSELECTAREA("ZZU")
		ZZU->(DBSKIP())

	EndDO
	oPrn:Say( _nLI:=_nLI + 50 ,2000,TRANSFORM(_Total,"@E 999,999,999.99"), oFont9a)

	//+--------------------------------------------------------------+
	//ฆ                      FIM DA IMPRESSAO                        ฆ
	//+--------------------------------------------------------------+

	oPrn:Preview()
	MS_FLUSH()

	oPrn:EndPage()

	_GeraXls:=1
	@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Gera Planilha Excel ?"
	@ 10, 49 SAY "1 - Nao"
	@ 22, 49 SAY "2 - Sim"
	@ 44, 49 GET _GeraXls PICTURE "99"
	@ 60, 90 BmpButton Type 1 Action Close(oDlg2)
	Activate Dialog oDlg2 Centered
	IF _GeraXls=2
		DBSELECTAREA("ZZU")
		DBGOTOP()

/*		COPY TO IMPZZU.DBF
		_arquivo:="G:\SYSTEM\IMPZZU.DBF"
		If !File(_arquivo)
			_arquivo:="F:\SYSTEM\IMPZZU.DBF"
		EndIf
		If ! ApOleClient( 'MsExcel' )
			MsgStop( 'Excel nใo instalado' )
		ELSE
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( _arquivo )
			oExcelApp:SetVisible(.T.)
		ENDIF
*/
	ENDIF

	DBSELECTAREA("ZZU")           // RETORNA INDICE CONTAS A PAGAR
	DBSETORDER(1)

RETURN

//+--------------------------------------------------------------+
//ฆ Fim do Relatorio                                             ฆ
//+--------------------------------------------------------------+


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION fImpCab()

	oPrn:EndPage()
	_nLI := 0
	nPag  := nPag +1

	oPrn:SayBitmap( _nLI+100,080,cBitMap,350,220 )
	oPrn:Say( _nLI:= _nLI+100 ,980  ,cabec1, oFont3)
	oPrn:Say( _nLI,2760 ,cabec2, oFont2)
	oPrn:Say( _nLI,3000 ,STR(nPag,4), oFont2)
	_nLI:=_nLI+150
	oPrn:line( _nLI:=_nLI+45,50,_nLI,3120)     // Linha horizontal

	oPrn:Say( _nLI:=_nLI + 50 , 050,"Num Dem", oFont7)
	oPrn:Say( _nLI            , 200,"Forneced", oFont7)
	oPrn:Say( _nLI            , 400,"Razao Social", oFont7)
	oPrn:Say( _nLI            ,1050,"Dt Compens", oFont7)
	oPrn:Say( _nLI            ,1250,"Nota Entr", oFont7)
	oPrn:Say( _nLI            ,1450,"Observ", oFont7)
	oPrn:line( _nLI:=_nLI+45,50,_nLI,3120)     // Linha horizontal


RETURN Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function CadZ03()

	_cArea := Alias()
	_nOrd  := IndexOrd()
	nReg   :=RecNo()


	DbSelectArea("Z03")
	DbGotop()

	cCadastro:="Z03 - Telefonia Movel"
	aRotina := { { "Pesquisa ",  'AxPesqui'            , 0, 1 },;
	{ "Visualizar" ,"AxVisual"            , 0, 2},;
	{ "Inclui    " ,"AxInclui"            , 0, 3},;
	{ "Altera    " ,"AxAltera"            , 0, 4},;
	{ "Exclui    " ,"AxDeleta"            , 0, 5},;
	{ "Termo Resp" ,"U_IMPZ03"            , 0, 6}}

	mBrowse(16,00,280,350,"Z03")

	DbSelectArea("Z03")
	SET FILTER TO

	dbSelectArea(_cArea)
	DbSetOrder(_nOrd)
	DbGoTo(nReg)

return(nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IMPZ03()
Local i:=0
	nOrdem :=0
	Z:=0
	M:=0
	tamanho:="M"
	limite:=220
	titulo   := PADC("CONTRATO DE TRABALHO",74)
	cDesc1   := PADC(" ",74)
	cDesc2   := PADC(" ",74)
	cDesc3   := PADC(" ",74)
	cNatureza:=""
	aReturn  := { "Especial", 1,"Administracao", 2, 2, 1,"",1 }
	nPag     := 0
	nomeprog := "CONTRA"
	cPerg    := "CONTRA"
	wnrel    := SUBSTR(CUSUARIO,7,3)+"_CONTRA"
	nLastKey := 0
	lContinua:= .T.
	nLin     := 0

	cString:= ALIAS()

	//+--------------------------------------------------------------+
	//ฆ Inicializa variaveis graficas                                ฆ
	//+--------------------------------------------------------------+

	aOkImp := .f.
	nHeight:=15
	lBold:= .F.
	lUnderLine:= .F.
	lPixel:= .T.
	lPrint:=.F.
	nSedex := 1

	oFont9 :=TFont():New( "Arial"   ,,14-2,,.T.,,,,,.F. )
	oFont9a:=TFont():New( "Arial"   ,,12-2,,.F.,,,,,.F. )
	oFont9b:=TFont():New( "Arial"   ,,12-2,,.T.,,,,,.F. )
	oFont9C:=TFont():New( "Arial"   ,,14-2,,.F.,,,,,.F. )
	oPrn := TMSPrinter():New()
	oPrn:Setup()

	//+--------------------------------------------------------------+
	//ฆ Envia controle para a funcao SETPRINT                        ฆ
	//+--------------------------------------------------------------+

	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,"M","",.T.)

	If nLastKey == 27 .or. Lastkey() == 27
		Return
	Endif

	//+--------------------------------------------------------------+
	//ฆ Verifica Posicao do Formulario na Impressora                 ฆ
	//+--------------------------------------------------------------+
	SetDefault(aReturn,cString)

	If nLastKey == 27 .or. Lastkey() == 27
		Return
	Endif

	LinCab := 0
	cabec1 :=" "
	cabec2 :=" "
	cabec3 :=" "
	cabec4 :=" "
	cBitMap:= "Logo_Alubar_COLOR.PNG" //"ALUBAR.Bmp"

	//+-----------------------------------------------------------+
	//ฆ Inicio do Relatorio                                       ฆ
	//+-----------------------------------------------------------+
	oPrn:EndPage()
	Linha := 70
	nPag  := nPag +1

	oPrn:SayBitmap( Linha+050,080,cBitMap,480,180 )

	oPrn:Say(Linha:=Linha+200,750,"TERMO DE USO E RESPONSABILIDADE SOBRE CELULARES" , oFont9)

	oPrn:line( Linha:=Linha+50   ,  80 ,Linha,2260)     // Linha horizontal

	_SALTO:=60

	oPrn:Say(Linha:=Linha+50,100,"Contrato:" , oFont9)
	oPrn:Say(Linha:=Linha    ,1000,"Operadora:" , oFont9)
	oPrn:Say(Linha:=Linha   ,1300,"Tipo Ap:" , oFont9)
	oPrn:Say(Linha:=Linha   ,1900,"Roaming:" , oFont9)

	oPrn:Say(Linha:=Linha+_salto  ,100,Z03->Z03_CONTRA , oFont9a)
	oPrn:Say(Linha:=Linha         ,1000,Z03->Z03_OPERAD               , oFont9a)
	_XX:=" "
	IF Z03->Z03_TPAPAR="M"
		_XX:="Modem"
	ELSEIF Z03->Z03_TPAPAR="S"
		_XX:="Smartphone"
	ELSEIF Z03->Z03_TPAPAR="C"
		_XX:="Celular"
	ENDIF    
	_XX2:="Nacional"
	IF Z03->Z03_ROAM="I"
		_XX2:="Internacional"
	ENDIF
	oPrn:Say(Linha:=Linha         ,1300,_XX                  , oFont9a)
	oPrn:Say(Linha:=Linha         ,1900,_XX2               , oFont9a)

	oPrn:line( Linha:=Linha+100   ,  80 ,Linha,2260)     // Linha horizontal
	oPrn:Say(Linha:=Linha+50,100,"Responsavel:" , oFont9)
	oPrn:Say(Linha:=Linha    ,1000,"No Celular:" , oFont9)
	oPrn:Say(Linha:=Linha   ,1300,"Chip:" , oFont9)
	oPrn:Say(Linha:=Linha   ,1900,"Imei:" , oFont9)
	oPrn:Say(Linha:=Linha+_salto  ,100,Z03->Z03_RESP , oFont9a)
	oPrn:Say(Linha:=Linha         ,1000,Z03->Z03_NUMERO               , oFont9a)
	oPrn:Say(Linha:=Linha         ,1300,Z03->Z03_CHIP                  , oFont9a)
	oPrn:Say(Linha:=Linha         ,1900,Z03->Z03_IMEI               , oFont9a)

	oPrn:line( Linha:=Linha+100   ,  80 ,Linha,2260)     // Linha horizontal
	oPrn:Say(Linha:=Linha+50,100,"Colaborador:" , oFont9)
	oPrn:Say(Linha:=Linha    ,1000,"Dt Entrega:" , oFont9)
	oPrn:Say(Linha:=Linha   ,1300,"C.Custo:" , oFont9)
	oPrn:Say(Linha:=Linha   ,1900,"Perfil:" , oFont9)
	oPrn:Say(Linha:=Linha+_salto  ,100,Z03->Z03_USUARI+" - "+Z03->Z03_NOME , oFont9a)
	oPrn:Say(Linha:=Linha         ,1000,DTOC(Z03->Z03_DATAEN)               , oFont9a)
	oPrn:Say(Linha:=Linha         ,1300,ALLTRIM(Z03->Z03_CCUSTO)+" - "+Posicione("CTT",1,xFilial("CTT")+Z03->Z03_CCUSTO,"CTT_DESC01")                    , oFont9a)
	oPrn:Say(Linha:=Linha         ,1900,Z03->Z03_PLANO               , oFont9)

	oPrn:line( Linha:=Linha+100   ,  80 ,Linha,2260)     // Linha horizontal
	oPrn:Say(Linha:=Linha+50     ,250,"Responsabilizo-me, perante  a ALUBAR, pelo  aparelho  acima  descrito, entregue  pelo setor de TI, em" , oFont9C)
	oPrn:Say(Linha:=Linha+_salto  ,250,"perfeito estado de conserva็ใo e uso, zelando pela guarda e seguran็a, ciente que em qualquer dano" , oFont9C)
	oPrn:Say(Linha:=Linha+_salto  ,250,"ou extravio verificado no mesmo a partir da data da retirada, poderแ ser descontado de meus salarios a" , oFont9C)
	oPrn:Say(Linha:=Linha+_salto  ,250,"quantia  relativa  ao  pre็o   desse  equipamento, sendo  de  minha  inteira  responsabilidade, cujas" , oFont9C)
	oPrn:Say(Linha:=Linha+_salto  ,250,"implica็๕es estใo descritas no 7o. item do meu contrato de trabalho." , oFont9C)

	oPrn:Say(Linha:=Linha+100,100,"P E R F I L:" , oFont9)

	oPrn:Say(Linha:=Linha+_salto,150,"MASTER:" , oFont9)
	oPrn:Say(Linha:=Linha+_salto ,300,"Terแ acesso ilimitado para liga็๕es sem restri็๕es de servi็os corporativos da opera -" , oFont9C)
	oPrn:Say(Linha:=Linha+_salto  ,300,"dora (sms, ddi,ddd, mms, siga-me), servi็o intra-grupo e com restri็๕es de liga็๕es a" , oFont9C)
	oPrn:Say(Linha:=Linha+_salto  ,300,"cobrar e envio de mms." , oFont9C)

	oPrn:Say(Linha:=Linha+_salto,150,"JฺNIOR A:" , oFont9)
	oPrn:Say(Linha:=Linha+_salto ,300,"Terแ acesso limitado para liga็๕es com valores pre-definidos, servi็o intra-grupo, com" , oFont9C)
	oPrn:Say(Linha:=Linha+_salto  ,300,"restri็๕es de servi็os corporativos da operadora (sms, ddi,ddd, mms, siga-me e recebi-" , oFont9C)
	oPrn:Say(Linha:=Linha+_salto  ,300,"mento de liga็๕es a cobrar." , oFont9C)

	oPrn:Say(Linha:=Linha+_salto,150,"JฺNIOR B:" , oFont9)
	oPrn:Say(Linha:=Linha+_salto ,300,"Terแ acesso para liga็๕es intra-grupo com dias e horแrios determinados, e/ou cr้ditros" , oFont9C)
	oPrn:Say(Linha:=Linha+_salto  ,300,"na forma pre-pago, restri็๕es de servi็os corporativos da operadora (sms, ddi,ddd, mms" , oFont9C)
	oPrn:Say(Linha:=Linha+_salto  ,300,"siga-me) e recebimento de liga็๕es a cobrar." , oFont9C)

	oPrn:Say(Linha:=Linha+100,100,"Acess๓rios:" , oFont9)
	cString:=Z03->Z03_HIST
	lWrap:=.T.
	A=MLCOUNT(cString,100,,lWrap)
	Linha:=Linha+15
	FOR I:=1 TO A
		oPrn:Say(  Linha:=Linha+45 ,150,MEMOLINE(cString,100,I,,lWrap)               , oFont9a)
		IF LINHA>3000
			oPrn:EndPage()
			Linha := 0
			nPag  := nPag +1
		ENDIF
	NEXT I

	IF A<=1
		LINHA:=LINHA + 100
	ENDIF

	oPrn:Say(Linha:=Linha+100 ,400,"Barcarena/PA , "+DTOC(Z03->Z03_DATAEN) , oFont9a)
	oPrn:line( Linha:=Linha         ,1000 ,Linha,1700)     // Linha horizontal
	oPrn:Say(Linha:=Linha+30    ,1000,Z03->Z03_NOME , oFont9B)

	oPrn:Preview()
	MS_FLUSH()

	oPrn:EndPage()

RETURN Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CadZ04()

	_cArea := Alias()
	_nOrd  := IndexOrd()
	nReg   :=RecNo()


	DbSelectArea("Z04")
	DbGotop()

	cCadastro:="Z04 - Complemento NFe"
	aRotina := { { "Pesquisa ",  'AxPesqui'            , 0, 1 },;
	{ "Visualizar" ,"AxVisual"            , 0, 2},;
	{ "Inclui    " ,"AxInclui"            , 0, 3},;
	{ "Altera    " ,"AxAltera"            , 0, 4},;
	{ "Exclui    " ,"AxDeleta"            , 0, 5}}

	mBrowse(16,00,280,350,"Z04")

	DbSelectArea("Z04")
	SET FILTER TO

	dbSelectArea(_cArea)
	DbSetOrder(_nOrd)
	DbGoTo(nReg)

return(nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CadZ05()

	_cArea := Alias()
	_nOrd  := IndexOrd()
	nReg   :=RecNo()


	DbSelectArea("Z05")
	DbGotop()

	cCadastro:="Z05 - Telefonia Movel - Detalhamento"
	aRotina := { { "Pesquisa ",  'AxPesqui'            , 0, 1 },;
	{ "Visualizar" ,"AxVisual"            , 0, 2},;
	{ "Inclui    " ,"AxInclui"            , 0, 3},;
	{ "Altera    " ,"AxAltera"            , 0, 4},;
	{ "Exclui    " ,"AxDeleta"            , 0, 5},;
	{ "Import TXT" ,"U_IMPZ05"            , 0, 6},;
	{ "Relatorio " ,"U_RELZ05"            , 0, 7}}

	mBrowse(16,00,280,350,"Z05")

	DbSelectArea("Z05")
	SET FILTER TO

	dbSelectArea(_cArea)
	DbSetOrder(_nOrd)
	DbGoTo(nReg)

return(nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IMPZ05()    // IMPORTA DETALHAMENTO DE LIGACOES DE CELULARES ...

	IF !PERGUNTE("IMPZ05",.T.)
		RETURN Nil
	ENDIF
	cArq:=ALLTRIM(MV_PAR01)
	_IMPORTA:=.T.
	If !File(cArq)
		ALERT("Arquivo nao existe na pasta System ... "+cArq)
		RETURN Nil
	ENDIF


	aTemp:={}
	aadd(aTemp,{'LINHA', 'C',MV_PAR02+9,0})
	
	/*
	cTemp:=CriaTrab(aTemp,.t.)
	Use &cTemp shared alias CLT  new
	Append from &cArq SDF
*/
	oTable := FWTemporaryTable():New("CLT", aTemp)
	oTable:addIndex("01", {"LINHA"})
	oTable:create()
	CLT:= oTable:GetRealName()

	DBGOTOP()
	do while !CLT->(Eof())
		IF VAL(SUBSTR(LINHA,37,10))=0   // SE NUMERO CHAMADO FOR IGUAL A ZERO , DESCARTA
			DBSKIP()
			Loop
		ENDIF
		_Key :=xFilial("Z05") + MV_PAR01 + DTOS(CTOD(SUBSTR(LINHA,03,10))) + SUBSTR(LINHA,14,05)
		DBSELECTAREA("Z05")
		DBSEEK(xFilial("Z05")+_Key)
		IF FOUND()
			RECLOCK("Z05",.F.)
		ELSE
			RECLOCK("Z05",.T.)
			REPLACE Z05_FILIAL WITH xFilial("Z05")
			REPLACE Z05_NUM    WITH MV_PAR01
			REPLACE Z05_DT     WITH CTOD(SUBSTR(CLT->LINHA,03,10))
			REPLACE Z05_HORA   WITH SUBSTR(CLT->LINHA,14,05)
		ENDIF
		REPLACE Z05_DEST      WITH SUBSTR(CLT->LINHA,22,02)
		REPLACE Z05_UF        WITH SUBSTR(CLT->LINHA,27,02)
		REPLACE Z05_NUMCHA    WITH SUBSTR(CLT->LINHA,37,10)
		REPLACE Z05_DUR       WITH SUBSTR(CLT->LINHA,49,05)
		REPLACE Z05_MIN       WITH SUBSTR(CLT->LINHA,65,05)
		_VALOR:=Val(SUBSTR(CLT->LINHA,57,02)+SUBSTR(CLT->LINHA,60,02))/100
		REPLACE Z05_VALOR     WITH _Valor

		MSUNLOCK()

		DBSELECTAREA("CLT")
		DBSKIP()
	ENDDO



	CLT->(dbCloseArea())
	cArqMov1:= cTemp+'.DBF'
	Delete File &cArqMov1

	DBSELECTAREA("Z05")
	DBGOTOP()
	ALERT("IMPORTACAO OK ")
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ACERTA_SFT()

	IF SM0->M0_CODIGO="01"
		_IDENT:="000015"
	ELSEIF  SM0->M0_CODIGO="02"
		_IDENT:="000016"
	ELSEIF  SM0->M0_CODIGO="03"
		_IDENT:="000017"
	ELSEIF  SM0->M0_CODIGO="06"
		_IDENT:="000019"
	ELSE
		RETURN Nil
	ENDIF

	_TT:=0

	dbUseArea(.t.,"TOPCONN","SPED054","XXX",.t.)      // BUSCA NFE-CHAVE

	DBSELECTAREA("SFT")
	DBSETORDER(1)
	DBSEEK(xFilial("SFT")+"E"+"4  ")    // SOMENTE NOTA DE ENTRADA COM SERIE 4
	WHILE !EOF() .AND. FT_TIPOMOV="E" .AND. FT_SERIE="4  "
		IF EMPTY(ALLTRIM(FT_CHVNFE))
			DBSELECTAREA("XXX")
			LOCATE FOR ID_ENT=_IDENT .AND. ALLTRIM(NFE_ID)=SFT->FT_SERIE+SFT->FT_NFISCAL
			IF FOUND()
				DBSELECTAREA("SFT")
				RECLOCK("SFT",.F.)
				SFT->FT_CHVNFE:=XXX->NFE_CHV
				MSUNLOCK()
				_TT++
			ENDIF
		ENDIF
		DBSELECTAREA("SFT")
		DBSKIP()
	ENDDO

	ALERT(_TT)

RETURN Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CADZ06()
	// EMISSAO DE CHEQUES - SOLICITACOES
	// AUTOR : JOSE NORBERTO MACEDO
	// DATA  : 08/04/2010
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	_cArea := Alias()
	_nOrd  := IndexOrd()
	nReg   := RecNo()

	PRIVATE aCores    := {{ 'SUBSTR(Z06_SIGN,30,1)#"L"'	, 'ENABLE' },;
	{ 'SUBSTR(Z06_SIGN,31,1)="S"'	, 'BR_AZUL'},;
	{ 'SUBSTR(Z06_SIGN,30,1)="L"'	, 'DISABLE'}}

	DbSelectArea("Z06")
	Z06->(DbSetOrder(1))
	Z06->(DbGotop())
	cCadastro :="Z06 - ORDEM DE EMISSAO DE CHEQUES"
	aRotina   := {{ "Pesquisa ",  'AxPesqui' , 0, 1 },;
	{ "Visualiza",  'AxVisual' , 0, 2 },;
	{ "Inclui"   ,  'AxInclui' , 0, 3 },;
	{ "Altera"   ,  'AxAltera' , 0, 4 },;
	{ "Liberacao",  'U_XLIBERA' , 0, 5 },;
	{ "Ext. Lib.",  'U_XEXTORN' , 0, 6 },;
	{ "Gera Fin.",  'U_XGERAFI' , 0, 7 },;
	{ "Relatorio",  'U_XRELATS' , 0, 8 },;
	{ "&Legenda "   ,"U_BRLegZ06"  , 0 ,9 }}

	mBrowse(16,00,280,350,"Z06",,,,,,aCores)

	DbSelectArea(_cArea)
	DbSetOrder(_nOrd)
	DbGoTo(nReg)
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function BRLegZ06()

	Local aLegenda := { {"ENABLE" ,"Aberto"}    ,;
	{"BR_AZUL","Financeiro"},;
	{"DISABLE","Liberado"}}

	BrwLegenda(cCadastro,"Legenda" ,aLegenda)

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function XLIBERA()

	_USUARIO:=ALLTRIM(USRRETMAIL(RETCODUSR()))
	_LIBERA :="N"
	_C1:=Z06_NUM
	_C2:=Z06_HIST
	_C3:=Z06_VALOR
	_C4:=Z06_VENCIM

	@ 1,1 to  150,300 DIALOG oDlg2XX TITLE "Liberar S-N-C ?"
	@ 10, 15 SAY "Num  :"
	@ 20, 15 SAY "Hist :"
	@ 30, 15 SAY "Valor:"
	@ 40, 15 SAY "Venct:"

	@ 60, 25 SAY "Liberar ?"
	@ 10, 50 GET _C1 WHEN .F.                SIZE 37,12
	@ 20, 50 GET _C2 WHEN .F.                SIZE 80,12
	@ 30, 50 GET _C3 PICTURE "@E 999,999.99" SIZE 37,12 WHEN .F.
	@ 40, 50 GET _C4                         SIZE 37,12 WHEN .F.

	@ 60, 60 GET _LIBERA PICTURE "!!" VALID ALLTRIM(_LIBERA) $"SNC"

	@ 60, 90 BmpButton Type 1 Action Close(oDlg2XX)
	Activate Dialog oDlg2XX Centered

	IF _USUARIO # ALLTRIM(Z06->Z06_APROV) .and. !(UPPER(SUBSTR(cUsuario,7,6)) $ "ADMINI/MACEDO") .AND. _LIBERA$"SC"
		ALERT(" SEM PERMISSรO !!!")
		RETURN Nil
	ENDIF

	IF ALLTRIM(_LIBERA)="S"
		_SIGN:=SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2)+DTOS(DDATABASE)+SUBSTR(cUSUARIO,7,15)+"##L"
		IF SUBSTR(Z06_SIGN,30,1)="L"
			ALERT("CHEQUE JA LIBERADO PELO APROVADOR ...")
			RETURN Nil
		ENDIF
	ELSEIF ALLTRIM(_LIBERA)="C"
		_SIGN:="aguardando lib"
	ELSE
		RETURN Nil
	ENDIF

	RECLOCK("Z06",.F.)
	Z06->Z06_SIGN:=_SIGN
	MSUNLOCK()
	ALERT("Atualizado com sucesso ...")

RETURN Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function XGERAFI()

	_USUARIO:=ALLTRIM(USRRETMAIL(RETCODUSR()))
	_LIBERA :="N"
	_C1     :=Z06_NUM
	_C2     :=Z06_HIST
	_C3     :=Z06_VALOR
	_C4     :=Z06_VENCIM

	IF EMPTY(Z06_SIGN)
		ALERT("Falta Liberacao do Aprovador !!!")
		RETURN Nil
	ENDIF
	IF _C4<=dDatabase
		ALERT("Vencimento nao pode ser igual ou menor que a data atual.")
		RETURN Nil
	ENDIF
	IF SUBSTR(Z06_SIGN,31,1)="S"
		ALERT("IMPOSSIVEL:Titulo ja gerado no financeiro !!!")
		RETURN Nil
	ENDIF

	@ 1,1 to  150,300 DIALOG oDlg2XX TITLE "Gera Financeiro S-N ?"
	@ 10, 15 SAY "Num  :"
	@ 20, 15 SAY "Hist :"
	@ 30, 15 SAY "Valor:"
	@ 40, 15 SAY "Venct:"

	@ 60, 25 SAY "Gera Fin ?"
	@ 10, 50 GET _C1 WHEN .F.                SIZE 37,12
	@ 20, 50 GET _C2 WHEN .F.                SIZE 80,12
	@ 30, 50 GET _C3 PICTURE "@E 999,999.99" SIZE 37,12 WHEN .F.
	@ 40, 50 GET _C4                         SIZE 37,12 WHEN .F.

	@ 60, 60 GET _LIBERA PICTURE "!!" VALID ALLTRIM(_LIBERA) $"SN"

	@ 60, 90 BmpButton Type 1 Action Close(oDlg2XX)
	Activate Dialog oDlg2XX Centered


	IF ALLTRIM(_LIBERA)="S"

		RECLOCK("SE2",.T.)
		E2_FILIAL :=xFilial("SE2")
		E2_PREFIXO:="GPE"
		E2_NUM    :=_C1
		E2_TIPO   :="PR"
		E2_VALOR  :=_C3
		E2_VENCTO :=_C4
		E2_VENCREA:=_C4
		E2_EMISSAO:=dDATABASE
		E2_HIST   :=_C2
		E2_EMIS1  :=DDATABASE
		E2_SALDO  :=_C3
		E2_VENCORI:=_C4
		E2_MOEDA  :=1
		E2_FORNECE:="GPE"
		E2_LOJA   :="00"
		E2_VLCRUZ :=_C3
		E2_OCORREN:="01"
		E2_ORIGEM :="GPEPR"
		E2_FLUXO  :="S"
		MSUNLOCK()

		RECLOCK("Z06",.F.)
		Z06->Z06_SIGN:=LEFT(Z06_SIGN,30)+"S"  //POSICAO 31 IGUAL A S = GERADO TITULO NO FINANCEIRO
		MSUNLOCK()

		ALERT("Titulo Gerado com Sucesso ...")
	ENDIF

	DBSELECTAREA("Z06")
	DBSETORDER(1)
	DBSKIP()

RETURN Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function XEXTORN()

	_USUARIO:=ALLTRIM(USRRETMAIL(RETCODUSR()))
	_LIBERA :="N"
	_C1:=Z06_NUM
	_C2:=Z06_HIST
	_C3:=Z06_VALOR
	_C4:=Z06_VENCIM

	@ 1,1 to  150,300 DIALOG oDlg2XX TITLE "EXTORNA S-N ?"
	@ 10, 15 SAY "Num  :"
	@ 20, 15 SAY "Hist :"
	@ 30, 15 SAY "Valor:"
	@ 40, 15 SAY "Venct:"

	@ 60, 25 SAY "Extorna ?"
	@ 10, 50 GET _C1 WHEN .F.                SIZE 37,12
	@ 20, 50 GET _C2 WHEN .F.                SIZE 80,12
	@ 30, 50 GET _C3 PICTURE "@E 999,999.99" SIZE 37,12 WHEN .F.
	@ 40, 50 GET _C4                         SIZE 37,12 WHEN .F.

	@ 60, 60 GET _LIBERA PICTURE "!!" VALID ALLTRIM(_LIBERA) $"SN"

	@ 60, 90 BmpButton Type 1 Action Close(oDlg2XX)
	Activate Dialog oDlg2XX Centered


	IF SUBSTR(Z06_SIGN,31,1)="S"
		DBSELECTAREA("SE2")
		DBSETORDER(1)
		DBSEEK(xFilial("SE2")+"GPE"+_C1+" "+"PR "+"GPE   "+"00")
		IF FOUND()
			RECLOCK("SE2",.F.)
			DELETE
			MSUNLOCK()
			ALERT("Apaguei o titulo provisorio ...")
		ENDIF
	ENDIF

	IF ALLTRIM(_LIBERA)="S"
		RECLOCK("Z06",.F.)
		Z06->Z06_SIGN:=""
		MSUNLOCK()
		ALERT("Liberacao Extornada ...")
	ENDIF


RETURN Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function XRELATS()

	cArea := Alias()
	nInd  := IndexOrd()

	cString := "Z06"
	cDesc1  := OemToAnsi(" ")
	cDesc2  := OemToAnsi(" ")
	cDesc3  := ""
	tamanho := "M"
	aOrd    := {}
	aReturn := { "Zebrado", 1,"Financeiro", 2, 2, 1, "",1 }
	nomeprog:= "Z06REL"
	aLinha  := { }
	nLastKey:= 0

	cCancel := "***** CANCELADO PELO OPERADOR *****"
	cPerg   := "" //"Z06REL"
	m_pag   := 1
	wnrel   := "Z06REL"

	_DATADE :=DDATABASE
	_DATAATE:=DDATABASE
	_ENVIA  :="N"

	@ 1,1 to  150,300 DIALOG oDlg2X TITLE "Deseja Imprimir ?"
	@ 10, 25 SAY "Data DE :"
	@ 20, 25 SAY "Data ATE:"
	@ 30, 25 SAY "Envia Aprov ?"
	@ 10, 60 GET _DATADE  SIZE 37,12
	@ 20, 60 GET _DATAATE SIZE 37,12
	@ 30, 60 GET _ENVIA   PICTURE "!!" VALID ALLTRIM(_ENVIA)$"SN"

	@ 60, 90 BmpButton Type 1 Action Close(oDlg2X)
	Activate Dialog oDlg2X Centered

	Titulo  := "Ordem de Emissao de Cheques"
	wnrel:= SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,tamanho)

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	DBSELECTAREA("Z06")
	SET FILTER TO Z06_DTSOLI>=_DATADE .AND. Z06_DTSOLI<=_DATAATE .AND. Z06_VALOR > 0
	DBSETORDER(1)
	DBGOTOP()

	RptStatus({|| RptDetail() })

	DBSELECTAREA("Z06")
	DBSETORDER(1)
	SET FILTER TO
	DBGOTOP()

	dbSelectArea( cArea )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑณDescrio ณImpressao do corpo do relatorio                             ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
// Substituido pelo assistente de conversao do AP5 IDE em 15/02/01 ==> Function RptDetail
Static Function RptDetail()

	cabec1 :="Data da solicitacao de "+DTOC(_DATADE)+" ate "+DTOC(_DATAATE)
	cabec2 :="  Numero     Solicitante                Favorecido                             Valor  Vencimento  Aprovador              Liberacao"
	//        0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
	//                  1         2         3         4         5         6         7         8         9         0         1         2         3
	nLin   :=60
	_TT    :=0
	_T1:=_T2:=0
	_PROD:=""

	DBSELECTAREA("Z06")
	DBSETORDER(1)
	DBGOTOP()
	SetRegua(LastRec()) //Ajusta numero de elementos da regua de relatorios
	_APROV:=ALLTRIM(Z06_APROV)
	WHILE !EOF()
		INCREGUA()

		IF nLin>48
			ImpCabec()
		ENDIF
		IF ALLTRIM(_ENVIA)="S" .AND. EMPTY(Z06_SIGN)
			_PROD:=_PROD+(Z06_NUM+" - "+Z06_FAVOREC+"-"+Z06_HIST+"  R$:"+TRANSFORM(Z06_VALOR,"@EZ 9,999,999.99") +CHR(13) + CHR(10))
			RECLOCK("Z06",.F.)
			Z06->Z06_SIGN:="aguardando lib"
			MSUNLOCK()
		ENDIF
		IF !(ALLTRIM(Z06_APROV)$_APROV)
			_APROV:=_APROV + "," + ALLTRIM(Z06_APROV)
		ENDIF

		@ nLin,000 PSAY "|"
		@ nLin,002 PSAY Z06_NUM
		@ nLin,012 PSAY "|"
		@ nLin,013 PSAY LEFT(Z06_SOLIC,25)
		@ nLin,039 PSAY "|"
		@ nLin,040 PSAY LEFT(Z06_FAVOREC,30)
		@ nLin,071 PSAY "|"
		@ nLin,072 PSAY Z06_VALOR PICTURE "@E 9,999,999.99"
		@ nLin,085 PSAY "|"
		@ nLIN,086 PSAY Z06_VENCIM
		@ nLin,096 PSAY "|"
		@ nLIN,098 PSAY LEFT(Z06_APROV,20)
		@ nLIN,120 PSAY LEFT(Z06_SIGN,15)
		@ nLIN,135 PSAY "|"
		IF SUBSTR(Z06_SIGN,30,1)="L"
			@ nLIN,137 PSAY "OK"
		ENDIF
		IF SUBSTR(Z06_SIGN,31,1)="S"
			@ nLIN,139 PSAY "-Titulo Gerado no Fin: GPE"+Z06_NUM
		ENDIF

		nLIN++
		@ nLin,000 PSAY "|"
		@ nLin,012 PSAY "|"
		@ nLin,039 PSAY "|"
		@ nLin,040 PSAY "Hist: "+Z06_HIST
		@ nLIN,135 PSAY "|"
		nLIN++
		_TT:=_TT + Z06_VALOR
		Z06->(DBSKIP())
	ENDDO
	@ nLin,000 PSAY "|"
	@ nLin,012 PSAY "|"
	@ nLin,039 PSAY "|"
	@ nLin,071 PSAY "|"
	@ nLin,085 PSAY "|"
	@ nLin,096 PSAY "|"
	@ nLIN,135 PSAY "|"
	nLIN++
	@ nLin,000 PSAY "|"
	@ nLin,012 PSAY "|"
	@ nLin,039 PSAY "|"
	@ nLin,071 PSAY "|"
	@ nLin,072 PSAY _TT PICTURE "@E 9,999,999.99"
	@ nLin,085 PSAY "|"
	@ nLin,096 PSAY "|"
	@ nLIN,135 PSAY "|"

	nLIN++
	@ nLiN,000 PSAY REPLICATE("-",136)

	nLIN++
	@ nLin,000 PSAY "|"
	@ nLin,002 PSAY "Financeiro"
	@ nLin,020 PSAY "|"
	@ nLin,022 PSAY "Gerencia"
	@ nLin,040 PSAY "|"
	@ nLin,042 PSAY "Diretoria"
	@ nLin,060 PSAY "|"
	@ nLin,062 PSAY "Observacoes: APROVADOR-"+_APROV
	@ nLIN,135 PSAY "|"

	nLIN++
	@ nLin,000 PSAY "|"
	@ nLin,020 PSAY "|"
	@ nLin,040 PSAY "|"
	@ nLin,060 PSAY "|"
	@ nLIN,135 PSAY "|"

	nLIN++
	@ nLin,000 PSAY "|"
	@ nLin,020 PSAY "|"
	@ nLin,040 PSAY "|"
	@ nLin,060 PSAY "|"
	@ nLIN,135 PSAY "|"

	nLIN++
	@ nLiN,000 PSAY REPLICATE("-",136)




	dbClearFilter()

	SetPgEject(.F.)
	If aReturn[5] == 1
		Set Printer To
		Commit
		ourspool(wnrel) //Chamada do Spool de Impressao
	Endif
	MS_FLUSH() //Libera fila de relatorios em spool

	IF !EMPTY(_PROD)
		ENVIA_Z06()
	ENDIF

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpCabec()

	@ 00,00  psay repl("*" ,136)
	@ 01,00  psay "* " +ALLTRIM(sm0->m0_nome)+"/"+SM0->M0_FILIAL
	@ 01,117 psay "Folha..:   "+strzero(m_Pag,6)+" *"
	@ 02,00 psay "* SIGA/ "+nomeprog
	@ 02,(136-len(titulo))/2 psay titulo
	@ 02,117 psay "Dt.Ref.: "+ dtoc(dDataBase)+" *"
	@ 03,00 psay "* Hora...: " + time()
	@ 03,117 psay "Emissao: " + dtoc(date())+" *"
	@ 04,00 psay repl("*",136)
	@ 05,00 psay cabec1
	@ 06,00 psay cabec2
	@ 07,00 psay repl("*",136)
	nLin := 8
	m_Pag := m_Pag + 1

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMYFUNC    บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION ENVIA_Z06()

	Local lResult   := .f.				// Resultado da tentativa de comunicacao com servidor de E-Mail
	Local cTitulo1
	Local lRelauth := GetNewPar("MV_RELAUTH",.F.)		// Parametro que indica se existe autenticacao no e-mail
	Local cEmailTo
	Local cEmailBcc:= ""
	Local cError   := ""
	
	Local lRet	   := .F.
	Local cFrom	   := GetMV("MV_RELACNT")
	Local cConta   := GetMV("MV_RELACNT")
	Local cSenhaX  := GetMV("MV_RELPSW")
	//Local lFirst   := .T.
	//Local cRotina  := "U_"+ProcName(7)


	cEmailTo := _APROV
	//cEmailTo := "jose.macedo@alubar.net"
	IF EMPTY(cEmailTo)
		RETURN
	ENDIF

	cTitulo1 := "LIBERACAO DE CHEQUES : "+"  "+SM0->M0_NOMECOM

	cMensagem:= "LIBERACAO DE CHEQUES : "+DTOC(_DATAATE) + CHR(13) + CHR(10)
	cMensagem:= cMensagem + "                             " +CHR(13)  + CHR(10)

	cMensagem:= cMensagem + _PROD

	cMensagem:= cMensagem + "                             "+CHR(13) + CHR(10)


	cAnexo:= ""


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Tenta conexao com o servidor de E-Mail ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	CONNECT SMTP                         ;
	SERVER 	 GetMV("MV_RELSERV"); 	// Nome do servidor de e-mail
	ACCOUNT  GetMV("MV_RELACNT"); 	// Nome da conta a ser usada no e-mail
	PASSWORD GetMV("MV_RELPSW") ; 	// Senha
	RESULT   lResult             	// Resultado da tentativa de conexใo

	// Se a conexao com o SMPT esta ok
	If lResult

		// Se existe autenticacao para envio valida pela funcao MAILAUTH
		If lRelauth
			lRet := Mailauth(cConta,cSenhaX)
		Else
			lRet := .T.
		Endif

		If lRet
			SEND MAIL FROM 	cFrom ;
			TO 				cEmailTo;
			BCC     		cEmailBcc;
			SUBJECT 		cTitulo1;
			BODY 			cMensagem;
			RESULT lResult


			If !lResult
				//Erro no envio do email
				GET MAIL ERROR cError
				MsgStop("Erro no envio de e-mail","erro de envio")
			ELSE
				DISCONNECT SMTP SERVER
			Endif
		Else
			GET MAIL ERROR cError
			MsgStop("Erro de autentica็ใo","Verifique a conta e a senha para envio")
		Endif

		DISCONNECT SMTP SERVER
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		MsgStop("Erro de CONEXAO COM SMTP","ERRO DE CONEXAO COM SMTP...")
	Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT100AGR บAutor: Rafael Almeida - SigaCorp  บData: 18/07/14บ ฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de Entrada para inclusใo de um menu que ira fazer    บฑฑ
ฑฑบ          ณ manuten็ใo de complemento de nota fiscal de importa็ใo     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Compras|Estoque/Custo - MATA103                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MA103OPC()

	Local aRet := {}
	Local aRet2 := {}
	aAdd(aRet2,{'DI de Importa็ใo' , 'U_ImpCD5', 0 ,  5,0,NIL})
	aAdd(aRet2,{'Complemento NF-DI', 'U_NFeCDT', 0 , 5,0,NIL})

	aAdd(aRet,{'NF Importa็ใo' , aRet2, 0 ,  5,0,NIL})

	aAdd(aRet,{'Hist๓rico'    ,  'U_M103HIST(SF1->(RecNo()))' , 0 ,  5,0,NIL})

	/*
	Local aRet := {}
	aAdd(aRet,{'DI de Importa็ใo', 'U_ImpCD5', 0 , 5,0,NIL})
	Return aRet
	*/  
	Return aRet



	*********************************
User Function NOTFCPNF(_CPEDCONF) //NOTIFICAวรO DE COMPENSAวรO DA NF
	*********************************
	Private _aRetCmpNF:={}

	_cQryComp:=" select ZPA_NUM,ZPA_PREFIX,sum(D1_TOTAL) AS TOTAL,E2_VALOR,A2_COD,A2_NOME,ZPA_PEDIDO,D1_DOC,D1_SERIE"
	_cQryComp+="  from "+ RETSQLNAME("SD1")+","+RETSQLNAME("ZPA")+","+RETSQLNAME("SE2")+","+RETSQLNAME("SA2")
	_cQryComp+="  WHERE D1_FILIAL='"+XFILIAL("SD1")+"'" 
	_cQryComp+="   AND ZPA_FILIAL='"+XFILIAL("ZPA")+"'"
	_cQryComp+="   AND E2_FILIAL='"+XFILIAL("SE2")+"'"
	_cQryComp+="   AND A2_FILIAL='"+XFILIAL("SA2")+"'"
	_cQryComp+="   AND D1_PEDIDO<>'"+SPACE(6)+"'"
	_cQryComp += " AND D1_PEDIDO IN "+FormatIn(_CPEDCONF,"/")+"     " //25/04/17
	_cQryComp+="   AND "+RETSQLNAME("SD1")+".D_E_L_E_T_<>'*' 
	_cQryComp+="   AND "+RETSQLNAME("ZPA")+".D_E_L_E_T_<>'*' 
	_cQryComp+="   AND "+RETSQLNAME("SE2")+".D_E_L_E_T_<>'*' 
	_cQryComp+="   AND "+RETSQLNAME("SA2")+".D_E_L_E_T_<>'*' 
	_cQryComp+="   AND E2_NUM=ZPA_NUM "
	_cQryComp+="   AND E2_SALDO>0 " //11/08/17 - somente nใo compensadas - Fabio Yoshioka 
	_cQryComp+="   AND E2_PREFIXO=ZPA_PREFIX "
	_cQryComp+="   AND D1_PEDIDO=ZPA_PEDIDO "
	_cQryComp+="   AND A2_COD=D1_FORNECE "
	_cQryComp+="   AND A2_LOJA=D1_LOJA "
	_cQryComp+="   GROUP BY ZPA_NUM,ZPA_VALOR,ZPA_PREFIX,E2_VALOR,A2_COD,A2_NOME,D1_DOC,D1_SERIE,ZPA_PEDIDO "
	DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQryComp), "TCOMP", .F., .T.) 
	While !TCOMP->(eof())  
		AADD(_aRetCmpNF,{TCOMP->ZPA_NUM,;
		TCOMP->ZPA_PREFIX,;
		TCOMP->TOTAL,;
		TCOMP->E2_VALOR,;
		TCOMP->A2_COD,;
		TCOMP->A2_NOME,;
		TCOMP->ZPA_PEDIDO,;
		TCOMP->D1_DOC,;
		TCOMP->D1_SERIE})
		TCOMP->(DBSKIP())
	EndDo               
	TCOMP->(DBCLOSEAREA()) 


	IF LEN(_aRetCmpNF)>0
		U_WFCOMPNF(_aRetCmpNF)     
	ENDIF                     

	Return

	********************************
User Function WFCOMPNF(_aEnvWF) 
	********************************
	//Local _cIpProd:=GetMV("AL_IPSRVPR")
	//Local _cIpTest:=GetMV("AL_IPSRVTS")
	Local oHTML,oProcess
	//Local lServProd := IIf(GetServerIP() == RTRIM(_cIpProd), .T.,.F.)   
	Local _cDestNotf:=GetMV("AL_MAILNPA") //04/04/17 - Destinos para notifica็ใo de PA
	Local _nIWf:=1
	oProcess:= TWFProcess():New("WFATRPCON","Pagamentos Antecipados - Documentos de entrada em atraso") 										
	oProcess:NewTask("Montagem do HTML", "\workflow\WF_HTMLV2\Adm\Alcada_CP\WFCMPNFE.html") 

	oHtml	:= oProcess:oHTML				

	if len(_aEnvWF)>0
		oProcess:oHtml:ValByName("cData"  		, DTOC(dDatabase))
		oProcess:oHtml:ValByName("cHora"  		, SubStr(Time(),1,5))

		For _nIWf:=1 to len(_aEnvWF)	    

			AAdd( ( oHtml:ValByName( "it.pedido"))	 , _aEnvWF[_nIWf,7] )		
			AAdd( ( oHtml:ValByName( "it.prefixo")) , _aEnvWF[_nIWf,2] )		
			AAdd( ( oHtml:ValByName( "it.numero"))  , _aEnvWF[_nIWf,1] )		
			AAdd( ( oHtml:ValByName( "it.forn"))	 , rtrim(_aEnvWF[_nIWf,5])+"-"+rtrim(_aEnvWF[_nIWf,6]) )		//25/04/17
			AAdd( ( oHtml:ValByName( "it.valor"))	 , Transform(_aEnvWF[_nIWf,4],'@E 999,999,999.99' ) )		
			AAdd( ( oHtml:ValByName( "it.nota"))    , _aEnvWF[_nIWf,8])
			AAdd( ( oHtml:ValByName( "it.serie"))   ,_aEnvWF[_nIWf,9])
			AAdd( ( oHtml:ValByName( "it.TotalNf")) , Transform(_aEnvWF[_nIWf,3],'@E 999,999,999.99' ) )		

		Next _nIWf 

		oProcess:cSubject := "Pagamentos Antecipados - Entrada de NF com PA"
		oProcess:cTo := _cDestNotf
		oProcess:start()
		oProcess:Finish()    

	ENDIF

Return()                                                                          
