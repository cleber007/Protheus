#INCLUDE "PROTHEUS.ch"
#INCLUDE "rwmake.ch"
#include "ap5mail.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SD1140I  บ Autor ณ SANDRO ULISSES     บ Data ณ  08/12/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ PONTO DE ENTRADA UTILIZADO NA ENTRADA DA PRE-NOTA APOS A   บฑฑ
ฑฑบ          ณ GRAVACAO DO SD1                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GRUPO ALUBAR S/A.                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function SD1140I()
Local aArea := GetArea()
//Local cDoc  := SD1->D1_DOC+SD1->D1_SERIE
//Local cForn := SD1->D1_FORNECE+SD1->D1_LOJA
Local cProd := SD1->D1_COD
Local cAlmx := SD1->D1_LOCAL
Local nIndSD1 := SD1->(IndexOrd())
Local nRegSD1 := SD1->(RecNo())
Local lOk    := ALLTRIM(GetMv("MV_PRENF"))

If SD1->D1_TIPO # "N"
	Return
EndIf
IF SD1->D1_TRANSIT="S"    // PRE-NOTA JA ADICIONOU ITENS AO ALMOX 99 ... PORTANTO NAO PROCESSA ESSE ITEM
   RETURN 
Endif

If !Upper(lOK) $ "SV"     // S = ATUALIZA ESTOQUE REAL / V = ATUALIZA ESTOQUE VIRTUAL (ALMOXARIFADO 99)
	Return
EndIf

DbSelectArea("SB1")
DbSetOrder(1)
If !SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD))
   RETURN 
Endif

cProd := SD1->D1_COD
cAlmx := SD1->D1_LOCAL
If Upper(lOK) = "V"   // S = ATUALIZA ESTOQUE REAL / V = ATUALIZA ESTOQUE VIRTUAL (ALMOXARIFADO 99)
   cAlmx := "99"
EndIf
    
DbSelectArea("SB2")
DBSETORDER(1)
If DbSeek(xFilial("SB2")+cProd+cAlmx)
	RecLock("SB2",.F.)
	Replace B2_QATU  With B2_QATU  + SD1->D1_QUANT
	Replace B2_VATU1 With B2_VATU1 + SD1->D1_TOTAL
	Replace B2_QTSEGUM With B2_QTSEGUM + SD1->D1_QTSEGUM
	MsUnLock()
Else
	RecLock("SB2",.T.)
	Replace B2_FILIAL With xFilial("SD2")
	Replace B2_COD With cProd
	Replace B2_LOCAL With cAlmx
	Replace B2_QATU  With SD1->D1_QUANT
	Replace B2_CM1   With SD1->D1_VUNIT
	Replace B2_VATU1 With SD1->D1_TOTAL
	Replace B2_QTSEGUM With SD1->D1_QTSEGUM
	MsUnLock()
EndIf

DbSelectArea("SD1")
RecLock("SD1",.F.)
SD1->D1_TRANSIT:="S"     // FLAG PARA DEFINIR SE ITEM JA FOI CONSIDERADO NO ALMOX 99
MSUNLOCK()

DbSetOrder(nIndSD1)
DbGoTo(nRegSD1)
RestArea(aArea)
Return


//**************************
User Function SF1140I()
//**************************
/*
Local   aArea   := GetArea()
Local oButton1
Local oGet1
Local cGet1 := "XML NAO ENVIADO PELO FORNECEDOR                                                                     "
Local oGroup1
Private oDlg
*/

/*
Private _Prod   := ""
Private _Pedido := ""

DbSelectArea("SD1")
DbSetOrder(1)
DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

While !Eof() .And. D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA == SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
	If !SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD))
		DbSkip()
		Loop
	Endif

	_PROD:=_PROD+(ALLTRIM(SB1->B1_COD)+"-"+LEFT(SB1->B1_DESC,34) + "________Qtd.PreNot: " + STR(SD1->D1_QUANT,10,0) + "________Est.Minimo: " + STR(SB1->B1_EMIN,10,0)  +CHR(13) + CHR(10))
    IF !(SD1->D1_PEDIDO$_PEDIDO)
       _PEDIDO:=_PEDIDO + SD1->D1_PEDIDO + "/"
    ENDIF   
    DBSKIP()
ENDDO
    
IF !EMPTY(_Prod)
	ENVIA_PRE()
ENDIF
*/              

/*
If  Alltrim(FUNNAME()) == "MATA140"
	Define msDialog oDlg Title "Motivo da entrada manual" From 000, 000 to 160, 375 Colors 0, 16777215 Pixel
		@ 007,008 Group oGroup1 to 057,179 Prompt "               Informe o motivo da entrada Manual da Pre-Nota                " of oDlg Color 0, 16777215 Pixel
		
	 	@ 025,015 msGet oGet1 Var cGet1 Size 156, 010 of oDlg Colors 0, 16777215 Pixel
	  	
	  	@ 060,141 Button oButton1 Prompt "&Ok" Size 037, 012 of oDlg  Action oDlg:end() Pixel
	Activate msDialog oDlg Centered
	
	dbSelectArea("SZ9")
	SZ9->(dbSetOrder(1))
	SZ9->(dbGotop())
					          
	While !RecLock("SZ9",.T.);EndDo
	SZ9->Z9_FILIAL := xFilial("SZ9")
	SZ9->Z9_DATA   := dDatabase
	SZ9->Z9_USUARIO:= Substr(cUsuario,7,15)
	SZ9->Z9_HORA   := Time()
	SZ9->Z9_NOTA   := SF1->F1_DOC
	SZ9->Z9_SERIE  := SF1->F1_SERIE
	SZ9->Z9_FORNECE:= SF1->F1_FORNECE
	SZ9->Z9_LOJA   := SF1->F1_LOJA	
	SZ9->Z9_ROTINA := "NFESXML"
	SZ9->Z9_MOTIVO := cGet1
	SZ9->(MsUnlock())
	SZ9->(dbCommitAll())     
Endif
*/
               

	Local aArea   := getArea()
	Private oDtRece
	Private oMotivo
	Private oRecAlm
	Private oSay1
	Private oSay2
	Private oSay3
	Private oBtnok
	
	Private cMotivo := "XML NAO ENVIADO PELO FORNECEDOR                                                                     "
	Private nRecAlm := "Sim" //nRecAlm := 1
	Private dDtRece := dDatabase
	Private cPedido := Space(06)  
	Private oDlg
	Private _cXA3	:= Space(6)
	Private _dDtXa3 := CtoD("  /  /  ")    
	Private _lOD	:= .F.

	If Alltrim(funName()) == "MATA140"

/*		
		Define msDialog oDlg Title "Motivo da entrada manual" From 000,000 To 160,375 Colors 0,16777215 Pixel
			@ 007,008 Group oGroup To 057,179 Prompt "               Informe o motivo da entrada manual da pre-nota                " Of oDlg Color 0,16777215 Pixel

		 	@ 025,015 msGet oMotivo Var cMotivo Size 156,010 Of oDlg Colors 0,16777215 Pixel
	  	
		  	@ 060,141 Button oBtnok Prompt "&Ok" Size 037,012 Of oDlg Action oDlg:End() Pixel
		Activate msDialog oDlg Centered
*/
	  	Define msDialog oDlg Title "Informa็๕es Adicionais" From 000,000 To 200,390 Colors 0,16777215 Pixel
	    	@ 008,008 Say oSay1 Prompt "Motivo:" 			Size 025,007 Of oDlg Colors 0,16777215 Pixel
	    	@ 024,008 Say oSay2 Prompt "Recbto Almox:" 	Size 043,007 Of oDlg Colors 0,16777215 Pixel
	    	@ 024,103 Say oSay3 Prompt "Dt Recbto" 		Size 025,007 Of oDlg Colors 0,16777215 Pixel

	    	@ 008,048 msGet oMotivo Var cMotivo Size 139,010 Of oDlg Colors 0,16777215 Pixel
	    	@ 024,143 msGet oDtRece Var dDtRece Size 043,010 Of oDlg Colors 0,16777215 Pixel

	    	@ 024,048 msCombobox oRecAlm Var nRecAlm Items {"Sim","Nao"} Size 033,010 Of oDlg Colors 0,16777215 Pixel
	    	
	    	@ 082,149 Button oBtnok Prompt "&Ok" Size 037,012 Of oDlg Action oDlg:End() Pixel
  		Activate msDialog oDlg Centered

		dbSelectArea("SZ9")
		SZ9->(dbSetOrder(1))
		SZ9->(dbGotop())
						          
		While !RecLock("SZ9",.T.);EndDo
		SZ9->Z9_FILIAL := xFilial("SZ9")
		SZ9->Z9_DATA   := dDatabase
		SZ9->Z9_USUARIO:= Substr(cUsuario,7,15)
		SZ9->Z9_HORA   := Time()
		SZ9->Z9_NOTA   := SF1->F1_DOC
		SZ9->Z9_SERIE  := SF1->F1_SERIE
		SZ9->Z9_FORNECE:= SF1->F1_FORNECE
		SZ9->Z9_LOJA   := SF1->F1_LOJA	
		SZ9->Z9_ROTINA := "NFESXML"
		SZ9->Z9_MOTIVO := cMotivo
		SZ9->(MsUnlock())
		SZ9->(dbCommitAll())     

		If SD1->(dbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
			cPedido := Space(06)
			
			Do While !SD1->(EOF()) .AND. SD1->D1_DOC == SF1->F1_DOC .AND. SD1->D1_SERIE == SF1->F1_SERIE .AND. SD1->D1_FORNECE == SF1->F1_FORNECE .AND. SD1->D1_LOJA == SF1->F1_LOJA
				If Alltrim(cPedido) == ""
					cPedido := SD1->D1_PEDIDO
				Endif 

				dbSelectarea("XA2")
				XA2->(dbSetorder(1))
				XA2->(dbGotop())

				If !XA2->(dbSeek(xFilial("XA2")+SD1->D1_ITEM+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA))
					RecLock("XA2",.T.)
					XA2->XA2_FILIAL 	:= xFilial("XA2") 
					XA2->XA2_ITEM   	:= SD1->D1_ITEM
					XA2->XA2_NFISCA  	:= SD1->D1_DOC
					XA2->XA2_SERIE   	:= SD1->D1_SERIE
					XA2->XA2_CLIFOR  	:= SD1->D1_FORNECE
					XA2->XA2_LOJA    	:= SD1->D1_LOJA
				Else
					RecLock("XA2",.F.)
				EndIf
				XA2->XA2_PROXML  	:= SD1->D1_COD
				XA2->XA2_NOMXML  	:= Posicione("SB1",1,xFilial("SB1") + SD1->D1_COD,"B1_DESC")
				XA2->XA2_QTDXML  	:= SD1->D1_QUANT
				XA2->XA2_VLUXML  	:= SD1->D1_VUNIT
				XA2->XA2_VLDXML  	:= SD1->D1_DESC
				XA2->XA2_VLTXML  	:= SD1->D1_TOTAL
				XA2->XA2_CFOXML  	:= SD1->D1_CF
				XA2->XA2_CSTXML  	:= SD1->D1_CLASFIS
				XA2->XA2_PEDIDO  	:= SD1->D1_PEDIDO
				XA2->XA2_ITEPN   	:= SD1->D1_ITEM
				XA2->XA2_PROPN  	:= SD1->D1_COD
				XA2->XA2_NOMPN   	:= Posicione("SB1",1,xFilial("SB1") + SD1->D1_COD,"B1_DESC")
				XA2->XA2_QTDPN   	:= SD1->D1_QUANT
				XA2->XA2_UMPN    	:= SD1->D1_UM
				XA2->XA2_VLUPN   	:= SD1->D1_VUNIT
				XA2->XA2_VLDPN   	:= SD1->D1_DESC
				XA2->XA2_VLTPN   	:= SD1->D1_TOTAL
				XA2->XA2_VLFPN   	:= SD1->D1_VALFRE
				XA2->XA2_CFOPN 	:= SD1->D1_CF
				XA2->XA2_CSTPN  	:= SD1->D1_CLASFIS
				XA2->XA2_LOCPN   	:= SD1->D1_LOCAL
				XA2->XA2_CCPN    	:= SD1->D1_CC
				XA2->XA2_CTPN    	:= SD1->D1_CONTA
				XA2->XA2_APLIC   	:= SD1->D1_APLICA
				XA2->XA2_FRTXML  	:= SD1->D1_VALFRE
				XA2->XA2_ENTREG  	:= SD1->D1_ENTREG
				XA2->XA2_LOC 	 	:= SD1->D1_LOC
				XA2->(msUnlock())
				XA2->(dbCommitall())
/*				
				While !recLock("XA2",.T.);Enddo 		 
				XA2->XA2_FILIAL 	:= xFilial("XA2") 
				XA2->XA2_ITEM   	:= SD1->D1_ITEM
				XA2->XA2_PROXML  	:= SD1->D1_COD
				XA2->XA2_NOMXML  	:= Posicione("SB1",1,xFilial("SB1") + SD1->D1_COD,"B1_DESC")
				XA2->XA2_QTDXML  	:= SD1->D1_QUANT
				XA2->XA2_VLUXML  	:= SD1->D1_VUNIT
				XA2->XA2_VLDXML  	:= SD1->D1_DESC
				XA2->XA2_VLTXML  	:= SD1->D1_TOTAL
				XA2->XA2_CFOXML  	:= SD1->D1_CF
				XA2->XA2_CSTXML  	:= SD1->D1_CLASFIS
				XA2->XA2_PEDIDO  	:= SD1->D1_PEDIDO
				XA2->XA2_ITEPN   	:= SD1->D1_ITEM
				XA2->XA2_PROPN  	:= SD1->D1_COD
				XA2->XA2_NOMPN   	:= Posicione("SB1",1,xFilial("SB1") + SD1->D1_COD,"B1_DESC")
				XA2->XA2_QTDPN   	:= SD1->D1_QUANT
				XA2->XA2_UMPN    	:= SD1->D1_UM
				XA2->XA2_VLUPN   	:= SD1->D1_VUNIT
				XA2->XA2_VLDPN   	:= SD1->D1_DESC
				XA2->XA2_VLTPN   	:= SD1->D1_TOTAL
				XA2->XA2_VLFPN   	:= SD1->D1_VALFRE
				XA2->XA2_CFOPN 	:= SD1->D1_CF
				XA2->XA2_CSTPN  	:= SD1->D1_CLASFIS
				XA2->XA2_LOCPN   	:= SD1->D1_LOCAL
				XA2->XA2_CCPN    	:= SD1->D1_CC
				XA2->XA2_CTPN    	:= SD1->D1_CONTA
				XA2->XA2_APLIC   	:= SD1->D1_APLICA
				XA2->XA2_NFISCA  	:= SD1->D1_DOC
				XA2->XA2_SERIE   	:= SD1->D1_SERIE
				XA2->XA2_CLIFOR  	:= SD1->D1_FORNECE
				XA2->XA2_LOJA    	:= SD1->D1_LOJA
				XA2->XA2_FRTXML  	:= SD1->D1_VALFRE
				XA2->XA2_ENTREG  	:= SD1->D1_ENTREG
				XA2->XA2_LOC 	 	:= SD1->D1_LOC
				XA2->(msUnlock())
				XA2->(dbCommitall())
*/				
				SD1->(dbSkip())
			Enddo
		Endif   
		
		dbSelectarea("XA3")
		XA3->(dbSetorder(5))
		XA3->(dbGotop())

		_cXA3	:= Space(6)
		_lOD := .F.
       // descomentado em 06/03/17 - Fabio Yoshioka
		If XA3->(dbSeek(xFilial("XA3") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
			_cXA3	:= XA3->XA3_NUM
			_dDtXa3 := XA3->XA3_EMISSA
			_lOD 	:= .T.    
					
		  //	RecLock("XA3",.F.)
		  //	XA3->XA3_CONCLU := dDatabase
		  //	XA3->(MsUnlock())
			//XA3->(dbCommitAll())                       
		Endif

		dbSelectarea("XA1")
		XA1->(dbSetorder(1))
		XA1->(dbGotop())

		While !recLock("XA1",.T.);Enddo 		 
		XA1->XA1_FILIAL 	:= xFilial("XA1") 
		XA1->XA1_NFISCA 	:= SF1->F1_DOC
		XA1->XA1_SERIE  	:= SF1->F1_SERIE
		XA1->XA1_CLIFOR  	:= SF1->F1_FORNECE
		XA1->XA1_LOJA    	:= SF1->F1_LOJA
		XA1->XA1_DATEMI  	:= SF1->F1_EMISSAO
		XA1->XA1_DTRECE  	:= dDtRece
		XA1->XA1_RECALM  	:= Iif(nRecAlm == "Sim",'S','N')  //Iif(nRecAlm == 1,'S','N')
		XA1->XA1_DATIMP  	:= dDatabase
		XA1->XA1_HORIMP  	:= Time()
//		XA1->XA1_HOREMI  	:= cGetHre
		XA1->XA1_CHVNFE  	:= SF1->F1_CHVNFE
		XA1->XA1_USU     	:= Substr(cUsuario,7,15)

		If _lOD //06/03/17
			XA1->XA1_OD 		:= _cXA3
			XA1->XA1_DTABOD 	:= _dDtXa3
      Endif

		XA1->XA1_TIPO    	:= SF1->F1_TIPO
		XA1->XA1_CLASSE  	:= "1"
		XA1->XA1_PC  		:= Iif(Alltrim(cPedido) <> "","1","2")
		XA1->XA1_ORIGEM  	:= "PRENOT"
		XA1->XA1_MOTIVO  	:= cMotivo
		XA1->XA1_NOMFOR  	:= Posicione("SA2",1,xFilial("SA2") + SF1->F1_FORNECE + SF1->F1_LOJA,"A2_NOME")
		XA1->XA1_UFORI   	:= Posicione("SA2",1,xFilial("SA2") + SF1->F1_FORNECE + SF1->F1_LOJA,"A2_EST")
		XA1->XA1_DEPTO   	:= Posicione("XA5",1,xFilial("XA5") + __cUSERID,"XA5_COD")
		XA1->(msUnlock())
		XA1->(dbCommitall())  
		
		dbSelectarea("SD1")
		SD1->(dbSetorder(1))
		SD1->(dbGotop())
	Endif              
	
	RestArea(aArea)
RETURN Nil



//*************************
STATIC FUNCTION ENVIA_PRE()
//*************************

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


cEmailTo :="valdoilto.junior@alubar.net,sheila.moda@alubar.net"

cTitulo1 := "Pre-Nota digitada : "+SF1->F1_DOC+" Serie: "+SF1->F1_SERIE

cMensagem:= "Digitada a pre-nota, conforme abaixo: Usuario-"+SUBSTR(cUsuario,7,15)   + CHR(13) + CHR(10)
cMensagem:= cMensagem + "                             " +CHR(13)  + CHR(10)

cMensagem:= cMensagem + "Fornecedor : "+SF1->F1_FORNECE+"-"+POSICIONE("SA2",1,xFilial("SA2") + SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME") +CHR(13)+CHR(10)
cMensagem:= cMensagem + "Data Emiss : "+DTOC(SF1->F1_EMISSAO)    +CHR(13)+CHR(10)
cMensagem:= cMensagem + "Num Pedido : "+_Pedido    +CHR(13)+CHR(10)

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


