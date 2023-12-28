#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWEVENTVIEWCONSTS.CH"
#INCLUDE "FWADAPTEREAI.CH"

//Posicoes Array aItensNF
Static nIT_ITEM		:= 01
Static nIT_COD		:= 02
Static nIT_DESCRI 	:= 03
Static nIT_QUANT  	:= 04
Static nIT_PRCUNT 	:= 05
Static nIT_VLRTOT 	:= 06
Static nIT_DESCON 	:= 07
Static nIT_NCM    	:= 08
Static nIT_CST    	:= 09
Static nIT_NUMPC  	:= 10
Static nIT_ITPC   	:= 11
Static nIT_LOCAL  	:= 12
Static nIT_LOTE   	:= 13
Static nIT_VALFRE	:= 14
Static nIT_SEGURO	:= 15
Static nIT_DESPES 	:= 16
Static nIT_PEDIDO 	:= 17
Static nIT_ITEMPED 	:= 18
Static nIT_TAMARR 	:= 18
//Posicoes Array aPedidos
Static nPC_PROD		:= 01
Static nPC_ITENS	:= 02

//Posicoes array aLstPed
Static nIPC_OK		:= 01
Static nIPC_NUM		:= 02
Static nIPC_ITEM	:= 03
Static nIPC_QTPEN	:= 04
Static nIPC_QTSEL	:= 05
Static nIPC_PRECO	:= 06
Static nIPC_LOCAL	:= 07
Static nIPC_LOTE 	:= 08
Static nIPC_TAMARR 	:= 08


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัออออออออออปฑฑ
//ฑฑบPrograma  ณ RCOMF01  บ Autor ณ              			 บ Data ณ   /  /   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯออออออออออนฑฑ
//ฑฑบDescricao ณ Tela de selecao para importacao dos arquivos XML e selecao บฑฑ
//ฑฑบ          ณ do tipo do documento.                               		 บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ Na primeira tela pode ser digitada a chave da NFe ou esco- บฑฑ
//ฑฑบ          ณ lhido via browser                                          บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function RCOMF01()

	Local cTeste

//Variaveis para checkBox
//Rayanne Meneses - Data: 10.08.2016
	Local oRadMenu1
	Local nRadMenu1 := 1
//Fim Rayanne Meneses - Data: 10.08.2016

//Variaveis das telas
	Local oCbTipo		:= NIL
	Local cCbTipo		:= ""
	Local cFile 		:= ""
	Local cCodBar		:= ""
	Local oFonteN		:= TFont():New("Arial",,16,,.T.,,,,.F.,.F.)

	Private lOk			:= .F.

	Private oDlgSelXML
	Private oDlgSelTipo
	Private oGtCodBar

	Private cTipo		:= "N"
	Private aCbTipo   := U_CXTipoNF(2) //Array de descricoes de tipos
	Private aAuxCbTipo:= U_CXTipoNF(3) //Array de tipos
	Private cTamCodBar:= TamSX3('F2_CHVNFE')[1]

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Criado esse parametro customizado, pois, ณ
//ณ existem notas fiscais de servico que nao ณ
//ณ sao vinculadas a pedidos de compra.      ณ
//ณ Entao habilitando o parametro MV_PCNFE   ณ
//ณ todas as Nf's precisam de PC, e usando o ณ
//ณ customizado apenas as que sao importadas.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Private lVldPcNFe	:= NIL //SuperGetMV('MS_PCNFE',.F.,.T.)
	Private cCaminho 	:= GetNewPar('MS_DIRXML',"C:\NFE\"+cEmpAnt+"\aprocessar\")

	Do While .T.
		cCodBar	:= Space(cTamCodBar)
		cFile		:= ""

		//####################################################################################################
		//# Tela para selecao do arquivo ou chave da nfe                                                     #
		//####################################################################################################
		DEFINE MSDIALOG oDlgSelXML FROM  000,000 TO 150,500 TITLE OemToAnsi('Busca de XML de Notas Fiscais de Entrada') PIXEL

	/*
	Descri็ใo: Tela para o usuario informar se a nota ้ NFe ou CTe
	Adicionado por Rayanne Meneses - Data.: 10.08.2016
	*/
	/*@ 004, 019 CHECKBOX oCheckBo1 VAR lCheckBo1 PROMPT "NF-e" SIZE 048, 008 OF oDlgSelXML COLORS 0, 16777215 PIXEL
	@ 016, 019 CHECKBOX oCheckBo2 VAR lCheckBo2 PROMPT "CT-e" SIZE 048, 008 OF oDlgSelXML COLORS 0, 16777215 PIXEL
	*/
//	@ 004, 019 RADIO oRadMenu1 VAR nRadMenu1 ITEMS "NF-e","CT-e" SIZE 043, 019 OF oDlgSelXML COLOR 0, 16777215 PIXEL
		@ 004, 019 RADIO oRadMenu1 VAR nRadMenu1 ITEMS "NF-e" SIZE 043, 019 OF oDlgSelXML COLOR 0, 16777215 PIXEL

		tSay():New(028,010,{|| "C๓digo de Barras da NFE:"	},oDlgSelXML,,oFonteN,,,,.T.,CLR_BLACK,,075,020)
		oGtCodBar	:= TGet():New(026,090,{|u| if(PCount()>0,cCodBar:=u,cCodBar)}, oDlgSelXML, 150,012,,;
			{|| AchaFile(cCodBar,@cFile) },CLR_HBLUE,,oFonteN,,,.T.,,,,,,,,,,'cFile')

		tButton():New(048,010,'Arquivo'		,oDlgSelXML,{|| GetArq(@cFile) },060,020,,,,.T.)
		tButton():New(048,095,'OK'				,oDlgSelXML,{|| VldCodBar(cCodBar) },060,020,,,,.T.)
		tButton():New(048,180,'Sair'			,oDlgSelXML,{|| oDlgSelXML:End() },060,020,,,,.T.)

		Activate Dialog oDlgSelXML CENTERED

		If !lOk
			Return
		EndIf

		//####################################################################################################
		//# Tela de selecao do tipo da NF                                                                    #
		//####################################################################################################
		cCbTipo	:= aCbTipo[1] //Seta no tipo normal
		lOk 		:= .F.
		DEFINE MSDIALOG oDlgSelTipo FROM  000,000 TO 150,450 TITLE OemToAnsi('Selecione o Tipo da NF') PIXEL

		tSay():New(011,020,{|| "Tipo Nota Entrada:"	},oDlgSelXML,,oFonteN,,,,.T.,CLR_BLACK,,070,020)
		oCbTipo	:= tComboBox():New(010,090,{|u|if(PCount()>0,cCbTipo:=u,cCbTipo)},aCbTipo,;
			120,020,oDlgSelTipo,,,{|| SetaTipo(@cTipo,oCbTipo:nAt) },CLR_HBLUE,,.T.,oFonteN,,,,,,,,'cCbTipo')

		tButton():New(040,020,'OK'				,oDlgSelXML,{|| lOk := .T.,oDlgSelTipo:End() },060,020,,,,.T.)
		tButton():New(040,150,'Sair'			,oDlgSelXML,{|| oDlgSelTipo:End() },060,020,,,,.T.)

		Activate Dialog oDlgSelTipo CENTERED

		If !lOk
			Return
		EndIf

		If nRadMenu1 == 1

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Rotina de importacao do XML para a Pre-Nota ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			U_ImpPreNota(cFile)
		Else

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Rotina de importacao do XML para a Ct-e ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			U_ImpPreCTe(cFile)

		EndIf

		lOk := .F.
	EndDo

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออปฑฑ
//ฑฑบPrograma  ณ ImpPreNota บ Autor ณ            		 บ  Data ณ   /  /   บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออนฑฑ
//ฑฑบDescricao ณ Rotina de processamento da importacao do arquivo XML e     บฑฑ
//ฑฑบ          ณ geracao da Pre-Nota de entrada                      		 บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ Pode ser utilizada apenas passando o arquivo via parametro บฑฑ
//ฑฑบ          ณ cFile                                                      บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function ImpPreNota(cFile)

	Local dDataEmis

	Local aPedidos		:= {}

	Local aLinha		:= {}
	Local cProdExt		:= ""
	Local cDscProX		:= ""

	Local lChvNfe		:= NIL
	Local lFornece		:= NIL
	Local cFornece		:= ""
	Local cLoja			:= ""
	Local cNmForn		:= ""
	Local cProds 		:= ''
	Local aItensNF		:=	{}
	Local nTamNCM		:= 0
	Local nTmCdPdX		:= 0
	Local nMed:=0
	Local aAnexos		:= {}
	Local xFile			:= ""
	Local cPathProc	:= ""
	Local cDrive		:= ""
	Local cDir			:= ""
	Local cExten		:= ""

	Local nTamFile		:= 0
	Local nBtLidos		:= 0
	Local cBuffer		:= ""
	Local cAviso 		:= ""
	Local cErro  		:= ""
	Local cCGCEmit		:= ""
	Local cCGCDest		:= ""
	Local cNota			:= ""
	Local cSerie		:= ""
	Local cChvNfe		:= ""
	Local nQuant
	Local nPrcUnt
	Local nVlrTot		:= 0
	Local nDescIt		:= 0
	Local nFretIt		:= 0
	Local nSeguIt		:= 0
	Local nDespIt		:= 0
	Local CST_Aux
	Local _cTipoConv 	:= ""
	Local nXi:=0
	Local	i
	Local	lAchou
	
	Local nRastro:=0
//Arrays para o execauto
	Local aCabec 		:= {}
	Local aItens 		:= {}
	Local aTemp

//Objetos que contem os dados do XML
	Private oNF,oNFe
	Private oEmitente
	Private oIdent
	Private oDestino
	Private oTotal
	Private oTransp
	Private aoDet
	Private oICM
	Private oFatura
	Private aoVol
	Private oInfAdic
	Private nPBruto	:= 0
	Private nPLiqui	:= 0

	Private nHdl

//Public _cNegocio := U_NEGOCIO(.T.)
	Private nX:= 0
	Private nY:= 0

	Private aCstIcms	:= {}
	Private aCstSnIcms	:= {}

	nHdl    := fOpen(cFile,0)
	If nHdl == -1
		If !Empty(cFile)
			ApMsgAlert("O arquivo de nome "+cFile+" nใo pode ser aberto! Verifique os parยmetros.","Aten็ใo!")
		Endif
		Return
	Endif

	nTamFile := fSeek(nHdl,0,2)

	fSeek(nHdl,0,0)

	cBuffer  := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
	nBtLidos := fRead(nHdl,@cBuffer,nTamFile)  // Leitura  do arquivo XML

	fClose(nHdl)

	oNfe	 := XmlParser(cBuffer,"_",@cErro,@cAviso)

//Erro no processamento do XML
	If !Empty(cErro)
		ApMsgStop('RCOMF01-001: Erro na leitura do XML: '+CRLF+;
			cErro)
		Return
	EndIf

	If  U_fVldTyp('Type("oNFe:_NFeProc:_NFe") <> "U"')
		oNF 		:= oNFe:_NFeProc:_NFe
		cChvNfe	:= oNfe:_NFeProc:_NFe:_InfNFe:_Id:Text
		cChvNfe	:= StrTran(cChvNfe,'NFe')
	ElseIf  U_fVldTyp('Type("oNFe:_NFe") <> "U"')
		oNF 		:= oNFe:_NFe
		cChvNfe	:= oNfe:_NFe:_InfNFe:_Id:Text
		cChvNfe	:= StrTran(cChvNfe,'NFe')
	Else
		ApMsgStop('RCOMF01-015: Arquivo XML invแlido. O processo serแ interrompido.')
		Return
	Endif

//Alimenta variaveis com os dados do XML
	oEmitente 	:= oNF:_InfNfe:_Emit
	oIdent    	:= oNF:_InfNfe:_IDE
	oDestino  	:= oNF:_InfNfe:_Dest
	oTotal    	:= oNF:_InfNfe:_Total

	If  U_fVldTyp("Type('oNF:_InfNfe:_Transp') <> 'U'")
		oTransp   	:= oNF:_InfNfe:_Transp
		If  U_fVldTyp("Type('oTransp:_Vol') <> 'U'")
			aoVol		:= oTransp:_Vol
		EndIf
	EndIf
	If  U_fVldTyp("Type('oNF:_InfNfe:_InfAdic') <> 'U'")
		oInfAdic		:= oNF:_InfNfe:_InfAdic
	EndIf

//Se apenas 1 produto entao faz o tratamento para converter em array
	If  U_fVldTyp("Type('aoVol') == 'O'")
		aoVol		:= {aoVol}
	ElseIf  U_fVldTyp("Type('aoVol') == 'U'")
		aoVol		:= {}
	EndIf

	aoDet      	:= oNF:_InfNfe:_Det
//Se apenas 1 produto entao faz o tratamento para converter em array
	If ValType(aoDet)=="O"
		aoDet 	:= {aoDet}
	EndIf
	If  U_fVldTyp('Type("oNF:_InfNfe:_Cobr") <> "U"')
		oFatura  := oNF:_InfNfe:_Cobr
	EndIf

//Guarda o numero da NF
	cNota		:= cValToChar(Val(oIdent:_nNF:TEXT))
	cSerie	:= PadR(oIdent:_serie:TEXT,3)

// CNPJ ou CPF do emitente
	If  U_fVldTyp('Type("oEmitente:_CPF") == "U"')

		cCGCEmit := oEmitente:_CNPJ:TEXT
	Else
		cCGCEmit	:= oEmitente:_CPF:TEXT
	EndIf
	cCGCEmit		:= AllTrim(cCGCEmit)

	lFornece		:= !(U_CXNFCliFor(.F.,cTipo)) //Cliente?

// Nota Normal Fornecedor
	If lFornece
		SA2->(dbSetOrder(3))
		If SA2->(dbSeek(xFilial("SA2")+cCGCEmit))
			cFornece		:= SA2->A2_COD
			cLoja			:= SA2->A2_LOJA
			cNmForn			:= SA2->A2_NOME
		Else
			ApMsgAlert("CNPJ Origem Nใo Localizado (Fornecedor SA2) - Verifique " + u_CXCPFCNPJ(cCGCEmit))
			Return
		Endif
	Else
		SA1->(dbSetOrder(3))
		If SA1->(dbSeek(xFilial("SA1")+cCGCEmit))
			cFornece		:= SA1->A1_COD
			cLoja			:= SA1->A1_LOJA
			cNmForn		:= SA1->A1_NOME
		Else
			ApMsgAlert("CNPJ Origem Nใo Localizado (Clientes SA1) - Verifique " + u_CXCPFCNPJ(cCGCEmit))
			Return
		Endif
	Endif

// CNPJ ou CPF destinatario
	If  U_fVldTyp('Type("oDestino:_CPF") == "U"')
		cCGCDest := oDestino:_CNPJ:TEXT
	Else
		cCGCDest	:= oDestino:_CPF:TEXT
	EndIf
	cCGCDest		:= AllTrim(cCGCDest)

//Valida o cnpj do destinatario
	If SM0->M0_CGC <> cCGCDest
		ApMsgStop('RCOMF01-002: O destinatแrio da NF atual nใo ้ a empresa que voc๊ estแ logado. A Nf nใo pode ser importada. '+u_CXCPFCNPJ(cCGCDest))
		Return
	EndIf

// -- Nota Fiscal jแ existe na base ?
	SF1->(dbSetOrder(1)) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
	If SF1->(DbSeek(XFilial("SF1")+cNota+cSerie+cFornece+cLoja))
		IF lFornece
			ApMsgAlert("Nota No.: "+cNota+"/"+cSerie+" do Fornec. "+SA2->(A2_COD+"/"+A2_LOJA+" - "+A2_NOME)+" Jแ Existe. A Importa็ใo serแ interrompida.")
		Else
			ApMsgAlert("Nota No.: "+cNota+"/"+cSerie+" do Cliente "+SA1->(A1_COD+"/"+A1_LOJA+" - "+A1_NOME)+" Jแ Existe. A Importa็ใo serแ interrompida.")
		Endif
		Return Nil
	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida a chave da NFe ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	lChvNfe	:= U_CXConsChvNfe(cChvNfe)
	If ValType(lChvNfe) == 'U'
		If !ApMsgNoYes('A autencidade da chave nใo pode ser validada junto a Sefaz.'+CRLF+'Processe com a importa็ใo?')
			Return
		EndIf
	ElseIf !lChvNfe
		ApMsgStop('Chave da NFe invแlida, nใo poderแ ser importada.')
		Return
	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Carrega os CST's do ICMS para processamento ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//SX5->(dbSetOrder(1)) //X5_FILIAL+X5_TABELA+X5_CHAVE
//SX5->(dbSeek(xFilial('SX5')+'S2'))
//While SX5->(!EOF()) .And. SX5->X5_TABELA == 'S2'
//	aAdd(aCstIcms,AllTrim(SX5->X5_CHAVE))
//	SX5->(dbSkip())
//EndDo

	aGetSX5 := FWGetSX5("S2")
	For nXi := 01 to Len(aGetSX5)
		aAdd(aCstIcms,AllTrim(aGetSX5[nXi,03]))
	Next nXi

//SX5->(dbSeek(xFilial('SX5')+'SG'))
//While SX5->(!EOF()) .And. SX5->X5_TABELA == 'SG'
//	aAdd(aCstSnIcms,AllTrim(SX5->X5_CHAVE))
//	SX5->(dbSkip())
//EndDo

	aGetSX5 := FWGetSX5("SG")
	For nXi := 01 to Len(aGetSX5)
		aAdd(aCstSnIcms,AllTrim(aGetSX5[nXi,03]))
	Next nXi


// Primeiro Processamento
// Busca de Informa็๕es para Pedidos de Compras
	cProds 	:= ''
	aItensNF	:=	{}

	nTamNCM	:= TamSX3('B1_POSIPI')[1]
	If lFornece
		nTmCdPdX	:= TamSX3('A5_CODPRF' )[1]
		nTmDsPdX	:= TamSX3('A5_NOMPROD')[1]
	Else
		nTmCdPdX	:= TamSX3('A7_CODCLI' )[1]
		nTmDsPdX	:= TamSX3('A7_DESCCLI')[1]
	EndIf

//#############################################################################
//# Monta dados dos itens para o Execauto da Pre-Nota                         #
//#############################################################################
	For nX := 1 To Len(aoDet)
		cProdExt		:= PadR(aoDet[nX]:_Prod:_cProd:TEXT,nTmCdPdX) //Codigo no cliente/fornecedor
		cDscProX		:= PadR(aoDet[nX]:_Prod:_xProd:TEXT,nTmDsPdX) //Descricao no cliente/fornecedor

		//If  U_fVldTyp('Type("aoDet["+cValToChar(nX)+"]:_Prod:_xPed") <> "U" .And. U_fVldTyp('Type("aoDet["+cValToChar(nX)+"]:_Prod:_xPed:TEXT") <> "U" .And. U_fVldTyp('Type("aoDet["+cValToChar(nX)+"]:_Prod:_nItemPed") <> "U" .And. U_fVldTyp('Type("aoDet["+cValToChar(nX)+"]:_Prod:_nItemPed:TEXT") <> "U"
		If  U_fVldTyp('Type("aoDet["+cValToChar(nX)+"]:_Prod:_xPed") <> "U"') .And. U_fVldTyp('Type("aoDet["+cValToChar(nX)+"]:_Prod:_xPed:TEXT") <> "U"') .And. U_fVldTyp('Type("aoDet["+cValToChar(nX)+"]:_Prod:_nItemPed") <> "U"') .And. U_fVldTyp('Type("aoDet["+cValToChar(nX)+"]:_Prod:_nItemPed:TEXT") <> "U"')
			DbSelectArea("SC7")
			DbSetOrder(1)

			cPedido			:= PadR(aoDet[nX]:_Prod:_xPed:TEXT,TamSX3('C7_NUM' )[1])
			cItem       := StrZero(Val(aoDet[nX]:_Prod:_nItemPed:TEXT),TamSX3('C7_ITEM' )[1])
/*		IF cFornece == "000004"
			cItem 		:= StrZero(Val(aoDet[nX]:_Prod:_nItemPed:TEXT) / 10,TamSX3('C7_ITEM' )[1])
		Else
			cItem       := StrZero(Val(aoDet[nX]:_Prod:_nItemPed:TEXT),TamSX3('C7_ITEM' )[1])
		EndIF
		
*/
			DbSeek(xFilial("SC7")+cPedido+cItem)
			IF !SC7->(Found()) .Or. SC7->C7_QUANT - SC7->C7_QUJE < 0
				cPedido := ""
				cItem 	:= ""
			EndIF
		Else
			cPedido := ""
			cItem 	:= ""
		EndIF

		nDescIt		:= 0
		nFretIt		:= 0
		nSeguIt		:= 0
		nDespIt		:= 0

		CST_Aux		:= ""

		If  U_fVldTyp('Type("aoDet["+Ltrim(str(nx))+"]:_Prod:_NCM") == "U"')
			cNCM		:=	Space(nTamNCM)
		Else
			cNCM		:= aoDet[nX]:_Prod:_NCM:TEXT
		EndIf

		//############################################################################
		//# Busca nas tabelas SA5 (Produto x Fornecedor) e SA7 (Produto x Cliente)   #
		//# se nao encontrar mostra tela para que o usuario preencha a informacao.   #
		//############################################################################

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Se nf de fornecedor ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If lFornece
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ  Busca informacao do produto equivalente ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			//SA5->(DbOrderNickName('FORPROD'))   // FILIAL + FORNECEDOR + LOJA + CODIGO PRODUTO NO FORNECEDOR
			SA5->(DbSetOrder(14))   // FILIAL + FORNECEDOR + LOJA + CODIGO PRODUTO NO FORNECEDOR
			If !SA5->(dbSeek(xFilial("SA5")+SA2->A2_COD+SA2->A2_LOJA+cProdExt))
				If !ApMsgYesNo ("O produto "+cProdExt+" - "+cDscProX+" nใo esta vinculado ao fornecedor."+CRLF+"Digita Codigo de Substituicao?")
					Return Nil
				Endif

				cProdSel	:= SelProd(cProdExt,cDscProX,cNCM,cPedido,cItem)

				If Empty(cProdSel)
					ApMsgAlert("Produto "+cProdExt+" - "+cDscProX+" nใo encontrado."+CRLF+"A Importacao sera interrompida.")
					Return Nil
				Else
					SA5->(dbSetOrder(1))
					SA5->(dbSeek(xFilial("SA5")+SA2->A2_COD+SA2->A2_LOJA+cProdSel))

					Reclock("SA5",SA5->(!Found()) )
					SA5->A5_FILIAL		:= xFilial("SA5")
					SA5->A5_FORNECE 	:= SA2->A2_COD
					SA5->A5_LOJA 		:= SA2->A2_LOJA
					SA5->A5_NOMEFOR 	:= SA2->A2_NOME
					SA5->A5_PRODUTO 	:= cProdSel
					SA5->A5_NOMPROD 	:= cDscProX
					SA5->A5_CODPRF  	:= cProdExt
					SA5->(MsUnlock())

					_cTipoConv 	:= SA5->A5_UNID

				EndIf
			Else
				cProdSel	:= SA5->A5_PRODUTO
				_cTipoConv 	:= SA5->A5_UNID
			Endif

			If  U_fVldTyp('Type("aoDet["+Ltrim(str(nx))+"]:_Prod:_NCM") == "U"')
				cNCM		:=	Space(nTamNCM)
			Else
				cNCM		:= aoDet[nX]:_Prod:_NCM:TEXT
			EndIf

			If  U_fVldTyp('Type("aoDet["+Ltrim(str(nx))+"]:_Prod:_CEAN") == "U"')
				cCEAN		:=	Space(nTamcEan)
			Else
				cCEAN		:= aoDet[nX]:_Prod:_CEAN:TEXT
			EndIf
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+UPPER(cProdSel)))
			//_cTipConv := SB1->B1_TIPCONV
			//_nFatConv := SB1->B1_CONV
			RecLock("SB1",.F.)
			SB1->B1_POSIPI	:= cNCM
			SB1->B1_CODBAR	:= cCEAN
			_BIPI := .F.
			If  U_fVldTyp('Type("aoDet["+Ltrim(str(nx))+"]:_IMPOSTO:_IPI:_IPITRIB:_PIPI") == "U"')
				SB1->B1_IPI	:= 0
			Else
				SB1->B1_IPI	:= VAL(aoDet[nX]:_IMPOSTO:_IPI:_IPITRIB:_PIPI:TEXT)
				_BIPI := .T.
			Endif
			_NVLBCN := 0 //BASE CALCULO ICMS NORMAL
			_NVLBCS := 0 //BASE CALCULO ICMS SUBSTITUICAO
			If  U_fVldTyp('Type("aoDet["+Ltrim(str(nx))+"]:_IMPOSTO:_ICMS:_ICMS10:_VBCST") <> "U"')
				_NVLBCN := VAL(aoDet[nX]:_IMPOSTO:_ICMS:_ICMS10:_VBC:TEXT)
				_NVLBCS := VAL(aoDet[nX]:_IMPOSTO:_ICMS:_ICMS10:_VBCST:TEXT)
			ElseIf  U_fVldTyp('Type("aoDet["+Ltrim(str(nx))+"]:_IMPOSTO:_ICMS:_ICMS70:_VBCST") <> "U"')
				_NVLBCN := VAL(aoDet[nX]:_IMPOSTO:_ICMS:_ICMS70:_VBC:TEXT)
				_NVLBCS := VAL(aoDet[nX]:_IMPOSTO:_ICMS:_ICMS70:_VBCST:TEXT)
			Endif
			IF _BIPI .AND. !EMPTY(_NVLBCS)
				SB1->B1_PICMENT	:= ROUND(((_NVLBCS*100)/ (_NVLBCN+ VAL(aoDet[nX]:_IMPOSTO:_IPI:_IPITRIB:_VIPI:TEXT))) - 100,2)
			ELSEIF !EMPTY(_NVLBCS)
				SB1->B1_PICMENT	:= ((_NVLBCS*100)/ _NVLBCN) - 100
			ELSE
				SB1->B1_PICMENT	:= 0
			ENDIF


			SB1->(MSUnLock())
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Se NF de cliente ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		Else
			SA7->(DbOrderNickName("CLIPROD"))   // FILIAL + FORNECEDOR + LOJA + CODIGO PRODUTO NO FORNECEDOR

			If !SA7->(dbSeek(xFilial("SA7")+SA1->A1_COD+SA1->A1_LOJA+cProdExt))
				If !ApMsgYesNo ("O produto "+cProdExt+" - "+cDscProX+" nใo esta vinculado ao cliente."+CRLF+"Digita Codigo de Substituicao?")
					Return Nil
				Endif

				cProdSel	:= SelProd(cProdExt,cDscProX,cNCM)

				If Empty(cProdSel)
					ApMsgAlert("Produto "+cProdExt+" - "+cDscProX+" nใo encontrado."+CRLF+"A Importacao sera interrompida.")
					Return Nil
				Else
					SA7->(dbSetOrder(1))
					SA7->(dbSeek(xFilial("SA7")+SA1->A1_COD+SA1->A1_LOJA+cProdSel))

					RecLock("SA7",SA7->(!Found()))
					SA7->A7_FILIAL 	:= xFilial("SA7")
					SA7->A7_CLIENTE 	:= SA1->A1_COD
					SA7->A7_LOJA 		:= SA1->A1_LOJA
					SA7->A7_DESCCLI 	:= cDscProX
					SA7->A7_PRODUTO 	:= cProdSel
					SA7->A7_CODCLI 	:= cProdExt
					SA7->(MsUnlock())
				EndIf
			Else
				cProdSel	:= SA7->A7_PRODUTO
			Endif


		Endif

		//###########################################################################
		//# Atualiza o NCM do produto se diferente ou vazio                         #
		//###########################################################################
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+UPPER(cProdSel)))

		If !Empty(cNCM) .And. cNCM != Replicate('0',nTamNCM) .And. SB1->B1_POSIPI <> cNCM
			//Se codigo vazio
			If Empty(SB1->B1_POSIPI)
				RecLock("SB1",.F.)
				SB1->B1_POSIPI	:= cNCM
				SB1->(MSUnLock())

				//Se preenchido pergunta ao usuario
			Else
				If cTipo <> 'D' .And. ; //Se nao for devolucao pergunta ao usuario se altera o NCM
					ApMsgYesNo(	'O NCM do produto nesta Nota Fiscal ('+cNCM+') ้ diferente do sistema ('+SB1->B1_POSIPI+').'+CRLF+;
						'Deseja atualizar o cadastro do produto com o NCM da Nota Fiscal?')

					RecLock("SB1",.F.)
					SB1->B1_POSIPI	:= cNCM
					SB1->(MSUnLock())
				EndIF
			EndIf
		Endif

		CST_Aux := ""

		//###########################################################################
		//# Se possui ICMS obtem os dados para o ICMS                               #
		//###########################################################################
		If  U_fVldTyp('Type("aoDet["+Ltrim(str(nx))+"]:_Imposto:_ICMS")<> "U"')
			lAchou	:= .F.
			For nY := 1 to len(aCstIcms)

				If  U_fVldTyp('Type("aoDet["+Ltrim(str(nx))+"]:_Imposto:_ICMS:_ICMS"+aCstIcms[nY]) <> "U"')
					oICM		:=	&("aoDet["+Ltrim(str(nX))+"]:_Imposto:_ICMS:_ICMS"+aCstIcms[nY])
					CST_Aux	:=	Alltrim(oICM:_orig:TEXT)+Alltrim(oICM:_CST:TEXT)
					lAchou	:= .T.
					Exit
				EndIf
			Next
			If !lAchou
				For nY := 1 to len(aCstSnIcms)
					If  U_fVldTyp('Type("aoDet["+Ltrim(str(nX))+"]:_Imposto:_ICMS:_ICMSSN"+aCstSnIcms[nY]) <> "U"')
						oICM		:=	&("aoDet["+Ltrim(str(nX))+"]:_Imposto:_ICMS:_ICMSSN"+aCstSnIcms[nY])
						CST_Aux	:=	Alltrim(oICM:_orig:TEXT)+Alltrim(oICM:_CSOSN:TEXT)
						lAchou	:= .T.
						Exit
					EndIf
				Next
			EndIf
		EndIf

		If  U_fVldTyp('Type("aoDet["+Ltrim(str(nX))+"]:_Prod:_vDesc")<> "U"')
			nDescIt	:= Val(aoDet[nX]:_Prod:_vDesc:TEXT)
		Endif

		If  U_fVldTyp('Type("aoDet["+Ltrim(str(nX))+"]:_Prod:_vFrete")<> "U"')
			nFretIt	:= Val(aoDet[nX]:_Prod:_vFrete:TEXT)
		Endif

		If  U_fVldTyp('Type("aoDet["+Ltrim(str(nX))+"]:_Prod:_vSeg")<> "U"')
			nSeguIt	:= Val(aoDet[nX]:_Prod:_vSeg:TEXT)
		Endif

		If  U_fVldTyp('Type("aoDet["+Ltrim(str(nX))+"]:_Prod:_vOutro")<> "U"')
			nDespIt	:= Val(aoDet[nX]:_Prod:_vOutro:TEXT)
		Endif

		If Val(aoDet[nX]:_Prod:_qCom:TEXT) != 0
			nQuant	:= Val(aoDet[nX]:_Prod:_qCom:TEXT)

			If AllTrim( _cTipoConv ) == "KG"

				nQuant	:= nQuant/1000

			EndIf

			nPrcUnt	:= Round(Val(aoDet[nX]:_Prod:_vProd:TEXT)/Val(aoDet[nX]:_Prod:_qCom:TEXT),TamSX3("D1_VUNIT")[2])
		Else
			nQuant	:= Val(aoDet[nX]:_Prod:_qTrib:TEXT)

			If AllTrim( _cTipoConv ) == "KG"

				nQuant	:= nQuant/1000

			EndIf

			nPrcUnt	:= Round(Val(aoDet[nX]:_Prod:_vProd:TEXT)/Val(aoDet[nX]:_Prod:_qTrib:TEXT),TamSX3("D1_VUNIT")[2])
		Endif

		IF SA5->A5_UMNFE == "2"
			IF SB1->B1_TIPCONV == "D"
				nQuant := nQuant * SB1->B1_CONV
			Else
				nQuant := nQuant / SB1->B1_CONV
			EndIF
			nPrcUnt	:= Val(aoDet[nX]:_Prod:_vProd:TEXT) / nQuant
		EndIF

		nVlrTot	:= Val(aoDet[nX]:_Prod:_vProd:TEXT)

		//Monta array para alimentar
		aTemp				:= array(nIT_TAMARR)
		aTemp[nIT_ITEM  ]	:= StrZero(nX,4)
		aTemp[nIT_COD   ]	:= SB1->B1_COD
		aTemp[nIT_DESCRI]	:= Left(SB1->B1_DESC,60)
		aTemp[nIT_QUANT ]	:= nQuant
		aTemp[nIT_PRCUNT]	:= nPrcUnt
		aTemp[nIT_VLRTOT]	:= nVlrTot
		aTemp[nIT_DESCON]	:= nDescIt
		aTemp[nIT_VALFRE]	:= nFretIt
		aTemp[nIT_SEGURO]	:= nSeguIt
		aTemp[nIT_DESPES] 	:= nDespIt
		aTemp[nIT_NCM   ]	:= SB1->B1_POSIPI
		aTemp[nIT_CST   ]	:= CST_Aux
		aTemp[nIT_NUMPC ]	:= cPedido//Space(TamSX3('C7_NUM'    )[1])
		aTemp[nIT_ITPC  ]	:= cItem//Space(TamSX3('C7_ITEM'   )[1])
		aTemp[nIT_LOCAL ]	:= Space(TamSX3('C7_LOCAL'  )[1])

		DbSelectArea("SC7")
		DbSetOrder(4)
		IF DbSeek(xFilial("SC7")+SB1->B1_COD+cPedido)
			aTemp[nIT_PEDIDO]	:= cPedido
			aTemp[nIT_ITEMPED]	:= SC7->C7_ITEM
		/*
		IF aLstPed[nAtPed][nIPC_PRECO] <> aTemp[nIT_PRCUNT]
		MsgInfo("Preco unitario da NF divergente do pedido de compra  PRODUTO: "+AllStrim(SB1->B1_COD)+"-"+AllTrim(SB1->B1_DESC)+", Pedido: "+SC7->C7_NUM+"-"+SC7->C7_ITEM)
		EndIF
		IF NoRound (aTemp[nIT_QUANT],2) <> NoRound (aLstPed[nAtPed][nIPC_QTPEN],2)
		MsgInfo("Preco unitario da NF divergente do pedido de compra  PRODUTO: "+AllStrim(SB1->B1_COD)+"-"+AllTrim(SB1->B1_DESC)+", Pedido: "+SC7->C7_NUM+"-"+SC7->C7_ITEM)
		EndIF
		*/
		Else
			aTemp[nIT_PEDIDO]	:= ""
			aTemp[nIT_ITEMPED]	:= ""
		EndIF
		//aTemp[nIT_LOTE  ]	:= Space(TamSX3('C7_LOTECLT')[1])

		aAdd(aItensNF,	aClone(aTemp) )

		//Guarda a relacao dos produtos para filtrar os pedidos pendentes
		If !Empty(cProds)
			cProds	+= ','
		EndIf
		cProds += "'"+UPPER(AllTrim(cProdSel))+"'"

	Next nX

//############################################################################
//# Tela de selecao do vinculo entre os itens da NF com Pedidos de Compra    #
//############################################################################
	If lFornece

		//Deve validar entrada com PC?
		lVldPcNFe	:= U_RCOMF01A('SPED',cFornece,cLoja,'N',cTipo)

		//Seleciona pedidos
		If !SelPed(aItensNF,cProds,cFornece,cLoja,cNmForn,cCGCEmit,cNota,cSerie,lVldPcNFe) //Se cancelou a selecao
			ApMsgStop('Importa็ใo da NF interrompido.')
			Return
		EndIf
	EndIf

//#############################################################################
//# Monta dados do cabecalho para o Execauto da Pre-Nota                      #
//#############################################################################

	If  U_fVldTyp('Type("oIdent:_dEmi:TEXT") == "U"')
		dDataEmis	:= StoD(Alltrim(U_CXSoNumeros(oIdent:_dHEmi:TEXT)))
	Else
		dDataEmis	:= StoD(Alltrim(U_CXSoNumeros(oIdent:_dEmi:TEXT)))
	EndIF

	aAdd(aCabec,{"F1_TIPO"   	,cTipo		,Nil,Nil})
//aAdd(aCabec,{"F1_FORMUL" 	,"N"			,Nil,Nil})
//aAdd(aCabec,{"F1_DOC"    	,cValToChar(Val(cNota))		,Nil,Nil}) 
//Alterado por David - Para sempre preencher os 9 digitos, complentando com 0
	aAdd(aCabec,{"F1_DOC"    	,cvaltochar(strzero(val(cnota),9))		,Nil,Nil})
	aAdd(aCabec,{"F1_SERIE"  	,cSerie		,Nil,Nil})
	aAdd(aCabec,{"F1_EMISSAO"	,dDataEmis	,Nil,Nil})
	aAdd(aCabec,{"F1_FORNECE"	,cFornece	,Nil,Nil})
	aAdd(aCabec,{"F1_LOJA"   	,cLoja		,Nil,Nil})
	aAdd(aCabec,{"F1_ESPECIE"	,"SPED"		,Nil,Nil})
	aAdd(aCabec,{"F1_CHVNFE"	,cChvNfe		,Nil,Nil})

//Grava campo dizendo que importou o XML
	If SF1->(FieldPos('F1_YIMPXML')) > 0
		aAdd(aCabec,{"F1_YIMPXML"	,'S'			,Nil,Nil})
	EndIf

//Observacoes da NF
	If  U_fVldTyp("Type('oInfAdic:_InfCpl:Text') == 'C'")
		aAdd(aCabec,{"F1_MENNOTA"	,oInfAdic:_InfCpl:Text	,Nil,Nil})
	EndIf

//Pesos e volumes
	nPBruto	:= 0
	nPLiqui	:= 0
	For nX := 1 to len(aoVol)
		If  U_fVldTyp("Type('aoVol[nX]:_Esp:Text') == 'C'")
			aAdd(aCabec,{"F1_ESPECI"+Str(nX,1)	,aoVol[nX]:_Esp:Text 	,Nil,Nil})
		EndIf
		If  U_fVldTyp("Type('aoVol[nX]:_QVol:Text') == 'C'")
			aAdd(aCabec,{"F1_VOLUME"+Str(nX,1)	,Val(aoVol[nX]:_QVol:Text) 	,Nil,Nil})
		EndIf
		If  U_fVldTyp("Type('aoVol[nX]:_PesoB:Text') == 'C'")
			nPBruto	:= Val(aoVol[nX]:_PesoB:Text)
		EndIf
		If  U_fVldTyp("Type('aoVol[nX]:_PesoL:Text') == 'C'")
			nPLiqui	:= Val(aoVol[nX]:_PesoL:Text)
		EndIf
	Next
	If nPBruto > 0
		aAdd(aCabec,{"F1_PBRUTO",nPBruto	,Nil,Nil})
	EndIf
	If nPLiqui > 0
		aAdd(aCabec,{"F1_PLIQUI",nPLiqui	,Nil,Nil})
	EndIf

//Tipo do frete
	If  U_fVldTyp("Type('oTransp:_ModFrete:Text') == 'C'")
		aAdd(aCabec,{"F1_TPFRETE",oTransp:_ModFrete:Text	,Nil,Nil})
		If AllTrim(oTransp:_ModFrete:Text) <> '9'
			If  U_fVldTyp("Type('oTotal:_IcmsTot:_vFrete:Text') == 'C'") .And. Val(oTotal:_IcmsTot:_vFrete:Text) > 0
				aAdd(aCabec,{"F1_FRETE",Val(oTotal:_IcmsTot:_vFrete:Text)	,Nil,Nil})
			EndIf
		EndIf
	EndIf
//Descontos e despesas acessorias
	If  U_fVldTyp("Type('oTotal:_IcmsTot:_vDesc:Text') == 'C'") .And. Val(oTotal:_IcmsTot:_vDesc:Text) > 0
		aAdd(aCabec,{"F1_DESCONT",Val(oTotal:_IcmsTot:_vDesc:Text)	,Nil,Nil})
	EndIf
	If  U_fVldTyp("Type('oTotal:_IcmsTot:_vSeg:Text') == 'C'") .And. Val(oTotal:_IcmsTot:_vSeg:Text) > 0
		aAdd(aCabec,{"F1_SEGURO",Val(oTotal:_IcmsTot:_vSeg:Text)	,Nil,Nil})
	EndIf
	If  U_fVldTyp("Type('oTotal:_IcmsTot:_vOutro:Text') == 'C'") .And. Val(oTotal:_IcmsTot:_vOutro:Text) > 0
		aAdd(aCabec,{"F1_DESPESA",Val(oTotal:_IcmsTot:_vOutro:Text)	,Nil,Nil})
	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Alimenta informacoes dos Itens da NF ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For nX := 1 To Len(aItensNF)
		//Zera variaveis para inicio do processamento
		aLinha 	:= {}

		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1")+aItensNF[nX][nIT_COD	])

		aAdd(aLinha,{"D1_COD"		,aItensNF[nX][nIT_COD	],Nil,Nil})

		//O pedido tem que ser digitado antes dos valores, senao, o sistema considera os valores do PC e nao da NF-e
		If !Empty(aItensNF[nX][nIT_NUMPC	])
			aAdd(aLinha,{"D1_PEDIDO"	,aItensNF[nX][nIT_NUMPC	],Nil,Nil})
		EndIf
		If !Empty(aItensNF[nX][nIT_ITPC	])
			aAdd(aLinha,{"D1_ITEMPC"	,aItensNF[nX][nIT_ITPC	],Nil,Nil})
		EndIf

		aAdd(aLinha,{"D1_QTSEGUM"	,ConvUm(aItensNF[nX][nIT_COD],aItensNF[nX][nIT_QUANT],0,2),Nil,Nil})
		aAdd(aLinha,{"D1_QUANT"		,aItensNF[nX][nIT_QUANT	],Nil,Nil})
		aAdd(aLinha,{"D1_VUNIT"		,aItensNF[nX][nIT_PRCUNT],Nil,Nil})
		aAdd(aLinha,{"D1_TOTAL"		,aItensNF[nX][nIT_VLRTOT],Nil,Nil})
		aAdd(aLinha,{"D1_VALDESC"	,aItensNF[nX][nIT_DESCON],Nil,Nil})

		aAdd(aLinha,{"D1_VALFRE"	,aItensNF[nX][nIT_VALFRE],Nil,Nil})
		aAdd(aLinha,{"D1_SEGURO"	,aItensNF[nX][nIT_SEGURO],Nil,Nil})
		aAdd(aLinha,{"D1_DESPESA"	,aItensNF[nX][nIT_DESPES],Nil,Nil})

		//		aAdd(aLinha,{"D1_CLASFIS"	,aItens[nX][08],Nil,Nil}) //Essa informacao vira da TES posteriormente
		If !Empty(aItensNF[nX][nIT_LOCAL	])
			CriaSB2(aItensNF[nX][nIT_COD	],aItensNF[nX][nIT_LOCAL	])
			aAdd(aLinha,{"D1_LOCAL" 	,aItensNF[nX][nIT_LOCAL	],Nil,Nil})
		EndIf

		If  U_fVldTyp('Type("aoDet["+cValToChar(nX)+"]:_Prod:_Med")<>"U"') .And. SB1->B1_RASTRO == "L"
			If  U_fVldTyp('Type("aoDet["+cValToChar(nX)+"]:_Prod:_Med") == "A"')
				For nMed := 1 To Len(aoDet[(nX)]:_Prod:_Med)
					aMed := aClone(aLinha)
					aMed[aScan(aMed,{|x| x[1] == "D1_QUANT"}),2] := Val(aoDet[Val(aItensNF[nX][nIT_ITEM	])]:_Prod:_Med[nMed]:_qLote:Text)
					aMed[aScan(aMed,{|x| x[1] == "D1_TOTAL"}),2] := aMed[aScan(aMed,{|x| x[1] == "D1_QUANT"}),2] * aMed[aScan(aMed,{|x| x[1] == "D1_VUNIT"}),2]
					aAdd(aMed,{"D1_LOTECTL"		,aoDet[Val(aItensNF[nX][nIT_ITEM	])]:_Prod:_Med[nMed]:_nLote:Text,Nil,Nil})
					aAdd(aMed,{"D1_DTVALID"		,StoD(Replace(aoDet[Val(aItensNF[nX][nIT_ITEM	])]:_Prod:_Med[nMed]:_dVal:Text,"-","")),Nil,Nil})
					aAdd(aItens,aMed)
				Next
			Else
				aAdd(aLinha,{"D1_LOTECTL"		,aoDet[Val(aItensNF[nX][nIT_ITEM	])]:_Prod:_Med:_nLote:Text,Nil,Nil})
				aAdd(aLinha,{"D1_DTVALID"		,StoD(Replace(aoDet[Val(aItensNF[nX][nIT_ITEM	])]:_Prod:_Med:_dVal:Text,"-","")),Nil,Nil})
				aAdd(aItens,aLinha)
			EndIF
		ElseIf  U_fVldTyp('Type("aoDet["+cValToChar(nX)+"]:_Prod:_Rastro") <> "U"') .And. SB1->B1_RASTRO == "L"
			If  U_fVldTyp('Type("aoDet["+cValToChar(nX)+"]:_Prod:_Rastro") == "A"')
				For nRastro := 1 To Len(aoDet[(nX)]:_Prod:_Rastro)
					aRastro := aClone(aLinha)
					aRastro[aScan(aRastro,{|x| x[1] == "D1_QUANT"}),2] := Val(aoDet[Val(aItensNF[nX][nIT_ITEM	])]:_Prod:_Rastro[nRastro]:_qLote:Text)
					aRastro[aScan(aRastro,{|x| x[1] == "D1_TOTAL"}),2] := aRastro[aScan(aRastro,{|x| x[1] == "D1_QUANT"}),2] * aRastro[aScan(aRastro,{|x| x[1] == "D1_VUNIT"}),2]
					aAdd(aRastro,{"D1_LOTECTL"		,aoDet[Val(aItensNF[nX][nIT_ITEM	])]:_Prod:_Rastro[nRastro]:_nLote:Text,Nil,Nil})
					aAdd(aRastro,{"D1_DTVALID"		,StoD(Replace(aoDet[Val(aItensNF[nX][nIT_ITEM	])]:_Prod:_Rastro[nRastro]:_dVal:Text,"-","")),Nil,Nil})
					aAdd(aItens,aRastro)
				Next
			Else
				aAdd(aLinha,{"D1_LOTECTL"		,aoDet[Val(aItensNF[nX][nIT_ITEM	])]:_Prod:_Rastro:_nLote:Text,Nil,Nil})
				aAdd(aLinha,{"D1_DTVALID"		,StoD(Replace(aoDet[Val(aItensNF[nX][nIT_ITEM	])]:_Prod:_Rastro:_dVal:Text,"-","")),Nil,Nil})
				aAdd(aItens,aLinha)
			EndIF
		Else
			aAdd(aItens,aLinha)
		EndIF


	Next nX

//############################################################################
//# Executa a Inclusao                                                       #
//############################################################################
	If Len(aItens) > 0
		Private lMsErroAuto := .F.
		Private lMsHelpAuto := .T.

		SB1->( dbSetOrder(1) )
		SA2->( dbSetOrder(1) )
		SA1->( dbSetOrder(1) )
		SE4->( dbSetOrder(1) )

		nModulo := 4  //ESTOQUE

		Begin Transaction
			MsgRun("Incluindo Pre-Nota. Aguarde...","Incluindo Pre-Nota...",{|| MSExecAuto({|x,y,z|Mata140(x,y,z)},aCabec,aItens,3) })

			IF lMsErroAuto
				DisarmTransaction()
				MostraErro()
			Else
				ConfirmSX8()

				//#######################################################################
				//# Copia os arquivos para o servidor e vincula com a Nota fiscal (SF1) #
				//#######################################################################
				SplitPath( cFile, @cDrive, @cDir, @xFile, @cExten )
				cPathProc	:= cDrive+cDir+'Processadas\'

				//Busca arquivos para anexar ao cadastro via botao conhecimento
				aAnexos	:= AchaAnexos(cChvNfe,cFile)

				For nX := 1 to len(aAnexos)
					//Vincula os arquivos no servidor via botao conhecimento
					VincArq(aAnexos[nX],cNota,cSerie,cFornece,cLoja,cNmForn)

					//Move os arquivos processados para a pasta Processados
					MoveArq(aAnexos[nX], cPathProc)
				Next

				ApMsgInfo(Alltrim(cNota)+' / '+Alltrim(cSerie)+" - Pr้ Nota Gerada Com Sucesso!")
			EndIf
		End Transaction
	Endif

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออปฑฑ
//ฑฑบPrograma  ณ GetArq     บ Autor ณ            			 บ Data ณ   /  /   บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออนฑฑ
//ฑฑบDescricao ณ Tela para selecionar o arquivo para importacao do XML      บฑฑ
//ฑฑบ          ณ Busca de um diretorio padrao local                         บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function GetArq(cFile)

	cFile	:= cGetFile( "Arquivo NFe (*.xml) | *.xml","Selecione o Arquivo de Nota Fiscal XML",,cCaminho,.T.,GETF_MULTISELECT+GETF_LOCALHARD , .T. )

//Se o usuario selecionou algum arquivo
	If !Empty(cFile)
		//Valida se o arquivo existe
		If !File(cFile)
			ApMsgAlert("RCOMF01-013: Arquivo Nใo Encontrado no Local de Origem Indicado!")
			lOk	:= .F.
		Else
			lOk	:= .T.

			oDlgSelXML:End()
		Endif
	EndIf

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออปฑฑ
//ฑฑบPrograma  ณ AchaFile   บ Autor ณ            			 บ Data ณ   /  /   บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao para buscar o arquivo xml da chave que foi passada. บฑฑ
//ฑฑบ          ณ Busca de um diretorio padrao local                         บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function AchaFile(cCodBar,cFile)

	Local lAchou	:= .F.
	Local nArq		:= 0
	Local aFiles	:= {}

//Se vazio pula as validacoes
	If Empty(cCodBar)
		lOK	:= .F.
		Return .T.
	EndIf

//Valida se o codigo de barras e' valido
	If !VldCodBar(cCodBar)
		lOk	:= .F.
		//Procura o arquivo no diretorio
	Else
		cCodBar	:= AllTrim(cCodBar)
		aFiles 	:= Directory(cCaminho+"\*"+cCodBar+"*.XML")

		For nArq := 1 To Len(aFiles)
			cFile 	:= AllTrim(cCaminho+aFiles[nArq,1])

			//Busca um arquivo com o mesmo nome da chave
			If cCodBar $ cFile
				lAchou	:= .T.
				Exit
			EndIf
		Next

		// Se achar o arquivo fecha a janela
		If lAchou
			lOk	:= .T.
			oDlgSelXML:End()
		Else
			ApMsgAlert("RCOMF01-014: Nenhum arquivo encontrado com a chave digitada:"+CRLF+;
				cCodBar+CRLF+;
				"Por Favor Selecione a Op็ใo Arquivo e Fa็a a Busca na Arvore de Diret๓rios!")
			lOk	:= .F.
			oGtCodBar:SetFocus()
		Endif
	EndIf

Return lOk

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออปฑฑ
//ฑฑบPrograma  ณ VldCodBar  บ Autor ณ            			 บ Data ณ   /  /   บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao para validar o codigo de barras                     บฑฑ
//ฑฑบ          ณ Verifica se esta vazio e o tamanho da chave                บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function VldCodBar(cCodBar)

	Local lRetorno	:= .T.

	cCodBar	:= AllTrim(cCodBar)

	If Empty(cCodBar)
		ApMsgAlert("Nenhum c๓digo de barras digitado.")
		lRetorno	:= .F.
		oGtCodBar:SetFocus()
	Else
		If len(cCodBar) <> cTamCodBar
			ApMsgAlert("O tamanho invแlido do c๓digo de barras. O correto ้ "+Str(cTamCodBar,3,0)+" caracteres.")
			lRetorno	:= .F.
			oGtCodBar:SetFocus()
		EndIf
	EndIf

Return lRetorno

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออปฑฑ
//ฑฑบPrograma  ณ SetaTipo   บ Autor ณ Cirilo Rocha 		 บ Data ณ 21/03/12 บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao para setar o tipo da NF, a ser utilizado dentro do  บฑฑ
//ฑฑบ          ณ ComboBox dos tipos da NF                                   บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function SetaTipo(cTipo,nTipo)

	cTipo	:= aAuxCbTipo[nTipo]

Return .T.

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออปฑฑ
//ฑฑบPrograma  ณ AchaAnexos บ Autor ณ Cirilo Rocha	   	 บ Data ณ 21/03/12 บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออนฑฑ
//ฑฑบDescricao ณ Verifica todos os arquivos no diretorio selecionado, com o บฑฑ
//ฑฑบ          ณ nome do arquivo contem a chave da NFe.                     บฑฑ
//ฑฑบ          ณ Usado para anexar os arquivos (PDF,JPG,etc.) 'a NF (SF1)   บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function AchaAnexos(cChave,cFile)

	Local nArq		:= 0
	Local cArq		:= ""
	Local aFiles	:= {}
	Local aAnexos	:= {}
	Local cDrive	:= ""
	Local cDir		:= ""
	Local cCaminho	:= ""
	Local cTemp		:= ""

	cChave	:= AllTrim(cChave)

//Obtem o caminho do diretorio do arquivo
	SplitPath( cFile, @cDrive, @cDir, @cArq )
	cCaminho	:= cDrive+cDir

//Busca outros arquivos para anexar (usando a chave da NFe)
	aFiles 	:= Directory(cCaminho+"*"+cChave+"*.*")
	For nArq := 1 To Len(aFiles)
		cTemp 	:= AllTrim(cCaminho+aFiles[nArq,1])

		aAdd(aAnexos,cTemp)
	Next

//Busca outros arquivos para anexar (usando o mesmo nome do arquivo)
	aFiles 	:= Directory(cCaminho+"*"+cArq+"*.*")
	For nArq := 1 To Len(aFiles)
		cTemp 	:= AllTrim(cCaminho+aFiles[nArq,1])

		If aScan(aAnexos,{|X| X == cTemp }) == 0
			aAdd(aAnexos,cTemp)
		EndIf
	Next

Return aAnexos

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออปฑฑ
//ฑฑบPrograma  ณ ValProd    บ Autor ณ Cirilo Rocha	   	 บ Data ณ 21/03/12 บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao para validar o codigo do produto digitado na tela   บฑฑ
//ฑฑบ          ณ de vinculo do produto no fornecedor/cliente com o produto  บฑฑ
//ฑฑบ          ณ local (SB1)                                                บฑฑ
//ฑฑบ          ณ Preenche tambem as descricoes da tela e o NCM              บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function ValProd()

	Local lRetorno	:= .T.
	Local cVar		:= ReadVar()

//Se campo vazio
	If Empty(&(cVar))
		cDesProd 	:= Space(TamSX3('B1_DESC'  )[1])
		cNCMProd 	:= Space(TamSX3('B1_POSIPI')[1])
		//Se informado valida o campo
	Else
		lRetorno	:= ExistCpo("SB1")
		If lRetorno
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial('SB1')+cGtProd))

			cDesProd		:= SB1->B1_DESC
			cNCMProd		:= SB1->B1_POSIPI
		EndIf
	EndIf

Return lRetorno

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออปฑฑ
//ฑฑบPrograma  ณ SelProd    บ Autor ณ Cirilo Rocha 		 บ Data ณ 21/03/12 บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออนฑฑ
//ฑฑบDescricao ณ Tela para selecionar o produto (SB1) que sera vinculado ao บฑฑ
//ฑฑบ          ณ produto no cliente/fornecedor                              บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function SelProd(cCodProd,cDesc,cNCM,cPedido,cItem)

	Local lOk	:= .F.

	Local oGrpForn	:= NIL
	Local oGrpSist	:= NIL
	Local oGtProd	:= NIL

	Local oFonteN	:= TFont():New("Arial",,16,,.T.,,,,.F.,.F.)

	Private cGtProd	:= Space(TamSX3('B1_COD')[1])
	Private cDesProd 	:= Space(TamSX3('B1_DESC')[1])
	Private cNCMProd 	:= Space(TamSX3('B1_POSIPI')[1])

	Default cPedido := ""
	Default cItem	:= ""

	IF !Empty(cPedido) .And. !Empty(cItem)
		DbSelectArea("SC7")
		DbSetOrder(1)
		DbSeek(xFilial("SC7")+cPedido+cItem)

		cGtProd := SC7->C7_PRODUTO
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial('SB1')+cGtProd))

		cDesProd		:= SB1->B1_DESC
		cNCMProd		:= SB1->B1_POSIPI
	EndIF

	DEFINE MSDIALOG oDlg TITLE "C๓digo de Substitui็ใo" FROM 000,000 TO 225,498 PIXEL STYLE DS_MODALFRAME
//--------------------------------------------------------------------------------------------
	oGrpForn	:= tGroup():New(003,005,045,245,"Produto no Fornecedor",oDlg,,,.T.)

	tSay():New(012,010,{|| "Codigo:"		},oGrpForn,,oFonteN,,,,.T.,CLR_BLACK,,100,30)
	tSay():New(012,045,{|| cCodProd   	},oGrpForn,,oFonteN,,,,.T.,CLR_HBLUE,,100,30)

	tSay():New(022,010,{|| "NCM:"			},oGrpForn,,oFonteN,,,,.T.,CLR_BLACK,,100,30)
	tSay():New(022,045,{|| cNCM   	 	},oGrpForn,,oFonteN,,,,.T.,CLR_HBLUE,,100,30)

	tSay():New(032,010,{|| "Descri็ใo:" },oGrpForn,,oFonteN,,,,.T.,CLR_BLACK,,100,30)
	tSay():New(032,045,{|| cDesc   	 	},oGrpForn,,oFonteN,,,,.T.,CLR_HBLUE,,200,30)
//-------------------------------------------------------------------------------------------
	oGrpSist := tGroup():New(045,005,085,245,"Produto no Sistema",oDlg,,,.T.)

	tSay():New(055,010,{|| "Codigo:"		},oGrpSist,,oFonteN,,,,.T.,CLR_BLACK,,100,30)
	oGtProd	:= TGet():New(053,045,{|u| if(PCount()>0,cGtProd:=u,cGtProd)}, oDlg, 100,009,,{|| ValProd()},,,,,,.T.,,,,,,,,,'SB1','cGtProd')

	tSay():New(065,010,{|| "NCM:"			},oGrpSist,,oFonteN,,,,.T.,CLR_BLACK,,100,30)
	tSay():New(065,045,{|| cNCMProd 	 	},oGrpSist,,oFonteN,,,,.T.,CLR_HBLUE,,100,30)

	tSay():New(075,010,{|| "Descri็ใo:" },oGrpSist,,oFonteN,,,,.T.,CLR_BLACK,,100,30)
	tSay():New(075,045,{|| cDesProd 	 	},oGrpSist,,oFonteN,,,,.T.,CLR_HBLUE,,200,30)
//------------------------------------------------------------------------------------------
	tButton():New(090,005,'OK'				,oDlg,{|| lOk := .T.,oDlg:End() },060,020,,,,.T.)
	tButton():New(090,180,'Cancelar'		,oDlg,{|| oDlg:End() },060,020,,,,.T.)

	oGtProd:SetFocus()
	oDlg:lEscClose := .F.

	ACTIVATE MSDIALOG oDlg CENTERED

	If !lOk
		cGtProd	:= Space(TamSX3('B1_COD')[1])
	EndIf

Return cGtProd

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออปฑฑ
//ฑฑบPrograma  ณ SelPed     บ Autor ณ Cirilo Rocha  		 บ Data ณ 21/03/12 บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออนฑฑ
//ฑฑบDescricao ณ Tela para vincular os itens da NF com os pedidos de comprasบฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function SelPed(aItensNF,cProds,cFornece,cLoja,cNmForn,cCGC,cNota,cSerie,lVldPcNFe)

	Local i
	Local lAchou	:= .T.
	Local lOK		:= .T.
	Local oFonteN	:= TFont():New("Arial",,16,,.T.,,,,.F.,.F.)
	Local oMGHlp	:= NIL
	Local cMGHlp	:= "Selecione um produto na parte superior da tela e marque o item do pedido que serแ vinculado ao item da NF."+CRLF+;
		"Fa็a isto com todos os itens da NF vinculando com algum pedido de compras."

	Private oLstNF		:= NIL
	Private oDlg		:= NIL
	Private aPedidos	:= {}
	Private oOK 		:= LoadBitmap(GetResources(),'LBTIK')
	Private oNO 		:= LoadBitmap(GetResources(),'LBNO')
	Private cPicQtd	:= X3Picture('D1_QUANT')
	Private oLstPed	:= NIL
	Private aLstPed	:= {}

	aPedidos	:= MontaPed(xFilial('SC7'),cFornece,cLoja,cProds)

	If Len(aPedidos) == 0
		SA2->(dbSetOrder(1))
		SA2->(dbSeek(xFilial('SA2')+cFornece+cLoja))
		ApMsgStop('RCOMF01-003: Nใo existem pedidos liberados com os produtos desta NF para este fornecedor:'+CRLF+;
			cFornece+'-'+cLoja+' - '+cNmForn+'('+U_CXCPFCNPJ(cCGC)+')'+CRLF+"Produtos: "+cProds)

		//Se obriga PC x NF entao sai da rotina
		If lVldPcNFe
			lOK	:= .F.
		Else
			lOK	:= ApMsgNoYes('Prossegue com a importa็ใo sem vincular essa Nota Fiscal a um Pedido de Compras?')
		EndIf
	Else
		lAchou	:= .T.

		//Busca se todos os itens da NF possuem PC para relacionar
		For i	:= 1 to len(aItensNF)

			nPos	:= aScan(aPedidos,{|X| AllTrim(X[nPC_PROD]) == AllTrim( aItensNF[i][nIT_COD] ) })
			IF nPos > 0
				nPosPed	:= aScan(aPedidos[nPos,2],{|X| X[2]+x[3] ==  aItensNF[I,nIT_PEDIDO]+aItensNF[I,nIT_ITEMPED] })
				if nPosPed > 0
					aPedidos[nPos,2,nPosPed,1] := .T.
				EndIF
			EndIF
			If nPos == 0
				lAchou	:= .F.
				Exit
			EndIf
		Next

		//Nao achou pc para todos os itens
		If !lAchou
			ApMsgStop('Nใo foi possํvel localizar nenhum pedido liberado para o item '+StrZero(i,2)+' da NF.'+CRLF+;
				'Fornecedor: '+cFornece+'-'+cLoja+' - '+cNmForn+'('+U_CXCPFCNPJ(cCGC)+')'+CRLF+;
				'Nota Fiscal/Serie: '+cNota+'/'+cSerie+CRLF+;
				'Produto: '+aItensNF[i][nIT_COD]+' - '+aItensNF[i][nIT_DESCRI])

			//Se a selecao de PC e' obrigatoria nao prossegue
			If lVldPcNFe
				lOK		:= .F.
				//Se e' opcional pergunta ao usuario
			ElseIf ApMsgNoYes('Deseja prosseguir sem vincular todos os itens da Nota Fiscal com um Pedido de Compras?')
				lOK		:= .T.
			Else
				lOK		:= .F.
			EndIf
		EndIf

		//Se nao vai sair da rotina entao mostra tela de selecao
		If lOK
			lOk	:= .F.
			DEFINE MSDIALOG oDlg FROM 000,000 TO 550,985 PIXEL TITLE 'Sele็ใo de Pedidos de Compra x NF'
			//----------------------------------------------------------------------------------------------------
			tGroup():New(003,003,035,488,"Dados do Fornecedor: ",oDlg,,,.T.)

			tSay():New(012,010,{|| "Fornecedor:"				},oDlg,,oFonteN,,,,.T.,CLR_BLACK,,100,030)
			tSay():New(012,070,{|| cFornece+'-'+cLoja+' - '+cNmForn+'( '+U_CXCPFCNPJ(cCGC)+' )' },oDlg,,oFonteN,,,,.T.,CLR_HBLUE,,300,030)

			tSay():New(022,010,{|| "Nota Fiscal/Serie:"		},oDlg,,oFonteN,,,,.T.,CLR_BLACK,,100,030)
			tSay():New(022,070,{|| cNota+'/'+cSerie  			},oDlg,,oFonteN,,,,.T.,CLR_HBLUE,,200,030)

			//----------------------------------------------------------------------------------------------------
			tGroup():New(037,003,120,488,"Itens da Nota Fiscal: ",oDlg,,,.T.)

			// Cria Browse dos produtos da NF
		/*
		oLstNF := TCBrowse():New(045,010,370,070,,;
		{'Item','Produto','Descri็ใo','Quantidade','Pedido','Item PC','Local','Lote'},;
		{    20,       50,        100,          40,      40,       30,     30,    30},;
		oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
		*/
			oLstNF := TCBrowse():New(045,010,470,070,,;
				{'Item','Produto','Descri็ใo','Quantidade','Prc Unit','Pedido','Item PC','Local'},;
				{    20,       50,        100,          40,        40,      40,       30,     30},;
				oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
			// Seta o vetor a ser utilizado
			oLstNF:SetArray(aItensNF)
			//Nao permite deletar linhas
			oLstNF:bDelOk	:= {|| .F.}
			oLstNF:bChange := {|| SelNF(aItensNF) }
			// Monta a linha a ser exibina no Browse
			oLstNF:bLine := {||	{ 	aItensNF[oLstNF:nAt][nIT_ITEM		]	,;
				aItensNF[oLstNF:nAt][nIT_COD		]	,;
				aItensNF[oLstNF:nAt][nIT_DESCRI	]	,;
				Transform(aItensNF[oLstNF:nAt][nIT_QUANT],cPicQtd)	,;
				Transform(aItensNF[oLstNF:nAt][nIT_PRCUNT],cPicQtd)	,;
				aItensNF[oLstNF:nAt][nIT_NUMPC	]	,;
				aItensNF[oLstNF:nAt][nIT_ITPC		]	,;
				aItensNF[oLstNF:nAt][nIT_LOCAL	]}}//	,;
				//										aItensNF[oLstNF:nAt][nIT_LOTE		]	}}

			//----------------------------------------------------------------------------------------------------
			tGroup():New(122,003,205,488,"Itens de Pedidos de Compras: ",oDlg,,,.T.)

			// Cria Browse dos pedidos
		/*
		oLstPed := TCBrowse():New(130,010,370,070,,;
		{'#','Pedido','Item PC','Qtd Pend','Qtd Selec.','Local','Lote'},;
		{ 20,      50,       50,        50,          50,     50,    50},;
		oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
		*/
			oLstPed := TCBrowse():New(130,010,470,070,,;
				{'#','Pedido','Item PC','Qtd Pend','Qtd Selec.','Prc Unit','Local'},;
				{ 20,      50,       50,        50,          50,        50,     50},;
				oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
			// Seta o vetor a ser utilizado
			oLstPed:SetArray(aLstPed)
			//Nao permite deletar linhas
			oLstPed:bDelOk	:= {|| .F.}
			// Evento de DuploClick (troca o valor do primeiro elemento do Vetor)
			oLstPed:bLDblClick := {|| MarkPed(aItensNF) }
			//----------------------------------------------------------------------------------------------------
			oMGHlp	:=	tMultiget():New(210,005,{|u|if(Pcount()>0,cMGHlp:=u,cMGHlp)},oDlg,483,030,oFonteN,.T.,,,,.T.,,,,,,.T.,,,,,.T.)
			oMGHlp:lWordWrap := .T.

			tButton():New(248,005,'OK'				,oDlg,{|| lOK := VldSelPed(aItensNF,@oDlg,lVldPcNFe) },060,020,,,,.T.)
			tButton():New(248,430,'Cancelar'		,oDlg,{|| lOK := .F., oDlg:End() },060,020,,,,.T.)

			ACTIVATE MSDIALOG oDlg CENTERED
		EndIf
	EndIf

Return lOK

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออปฑฑ
//ฑฑบPrograma  ณ MontaPed   บ Autor ณ                 	 บ Data ณ   /  /   บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao para obter os pedidos de compra em aberto para o    บฑฑ
//ฑฑบ          ณ fornecedor e com os produtos da NF                         บฑฑ
//ฑฑบ          ณ Retorna um array para a montagem da tela de selecao        บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function MontaPed(cFilPC,cFornece,cLoja,cProds)

	Local aPedidos	:= {}
	Local aTemp		:= {}
	Local cProdAnt	:= ''
	Local nTamPed	:= 0

	cQuery := ""
	cQuery += " SELECT   C7_PRODUTO 						, "+CRLF
	cQuery += "        	C7_NUM 	  						, "+CRLF
	cQuery += "          C7_ITEM 							, "+CRLF
//cQuery += "          C7_QUANT-C7_QUJE C7_QTPEN	, "+CRLF
	cQuery += "          C7_QUANT-C7_QUJE-C7_QTDACLA C7_QTPEN	, "+CRLF
	cQuery += "          C7_PRECO,C7_LOCAL   	  					"+CRLF
//cQuery += "          C7_LOTECLT 	  					  "+CRLF
	cQuery += " FROM " + RetSqlName("SC7") + " SC7 "+CRLF
	cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 "+CRLF
	cQuery += "					ON SB1.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += " 					AND B1_FILIAL 	= '" + xFilial("SB1") + "' "+CRLF
	cQuery += " 					AND B1_COD		= C7_PRODUTO "+CRLF
	cQuery += " WHERE SC7.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "			AND C7_FILENT 	= '" + cFilPC + 	"' "+CRLF //O vinculo e' pelo campo Filial Entrega
	cQuery += " 		AND C7_FORNECE = '" + cFornece + "' "+CRLF
	cQuery += " 		AND C7_LOJA 	= '" + cLoja + 	"' "+CRLF
	cQuery += " 		AND C7_PRODUTO IN ("+cProds+		") "+CRLF
//cQuery += " 		AND C7_QUANT 	> C7_QUJE  "+CRLF
	cQuery += " 		AND (C7_QUANT-C7_QUJE-C7_QTDACLA) > 0 "+CRLF
	cQuery += " 		AND C7_RESIDUO = ' ' "+CRLF
	cQuery += " 		AND C7_CONAPRO = 'L' "+CRLF
	cQuery += " 		AND C7_ENCER 	= ' ' "+CRLF
	cQuery += " 		AND C7_TPOP   <> 'P' "+CRLF
	cQuery += " ORDER BY C7_PRODUTO, C7_NUM, C7_ITEM "

//cQuery := ChangeQuery(cQuery)
//MemoWrite('C:\PreNotaXML.Sql',cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CAD",.T.,.T.)

//Preenche arrays com os produtos para selecao
	While !CAD->(EOF())
		//Armazena por produto o array

		If cProdAnt <> CAD->C7_PRODUTO
			cProdAnt	:= CAD->C7_PRODUTO
			aAdd(aPedidos,{CAD->C7_PRODUTO, {} })
			nTamPed++
		EndIf

		aTemp	:= array(nIPC_TAMARR)
		aTemp[nIPC_OK   ]	:= .F.
		aTemp[nIPC_NUM  ]	:= CAD->C7_NUM
		aTemp[nIPC_ITEM ]	:= CAD->C7_ITEM
		aTemp[nIPC_QTPEN]	:= CAD->C7_QTPEN
		aTemp[nIPC_QTSEL]	:= 0
		aTemp[nIPC_PRECO]	:= CAD->C7_PRECO
		aTemp[nIPC_LOCAL]	:= CAD->C7_LOCAL
		//	aTemp[nIPC_LOTE ]	:= CAD->C7_LOTECLT

		aAdd(aPedidos[nTamPed][nPC_ITENS],aClone(aTemp))

		CAD->(dbSkip())
	EndDo

	CAD->(DbCloseArea())

Return aPedidos

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออปฑฑ
//ฑฑบPrograma  ณ SelNF      บ Autor ณ Cirilo Rocha	    	 บ Data ณ 21/03/12 บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao no click nos itens da NF, para atualizar os itens   บฑฑ
//ฑฑบ          ณ de PC's para selecao.                                      บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function SelNF(aItensNF)

	Local i		:= 0
	Local nAt	:= oLstNF:nAt	//Posicao atual do array
	Local nPos	:= aScan(aPedidos,{|X| AllTrim( X[nPC_PROD] ) == AllTrim( aItensNF[nAt][nIT_COD] ) })

	If nPos > 0
		//Marca ou desmarca os itens dos PC's para esse produto
		For i := 1 to len(aPedidos[nPos][nPC_ITENS])
			//Se o item do PC esta marcado para esse item da NF
			If !Empty(aItensNF[nAt][nIT_NUMPC])								 			.And. ; 	//Se vinculado com PC
				aPedidos[nPos][nPC_ITENS][i][02] == aItensNF[nAt][nIT_NUMPC] 	.And. ; 	//Num  PC
				aPedidos[nPos][nPC_ITENS][i][03] == aItensNF[nAt][nIT_ITPC ]				//Item PC

				aPedidos[nPos][nPC_ITENS][i][nIPC_OK] := .T.
			Else
				aPedidos[nPos][nPC_ITENS][i][nIPC_OK] := .F.
			EndIf
		Next

		//Seta array do Broser
		aLstPed	:= aPedidos[nPos][nPC_ITENS]

		//Precisa setar novamente o array
		oLstPed:SetArray(aLstPed)

		// Monta a linha a ser exibina no Browse, precisa setar novamente essa variavel
		oLstPed:bLine := {||	{ 	If(aLstPed[oLstPed:nAt][nIPC_OK],oOK,oNO)				,;
			aLstPed[oLstPed:nAt][nIPC_NUM]							,;
			aLstPed[oLstPed:nAt][nIPC_ITEM]							,;
			Transform(aLstPed[oLstPed:nAt][nIPC_QTPEN],cPicQtd),;
			Transform(aLstPed[oLstPed:nAt][nIPC_QTSEL],cPicQtd),;
			Transform(aLstPed[oLstPed:nAt][nIPC_PRECO],cPicQtd),;
			aLstPed[oLstPed:nAT][nIPC_LOCAL]}}// 						,;
			//							 		aLstPed[oLstPed:nAT][nIPC_LOTE]							}}

		//Forca a atualizacao do browser
		oLstPed:Refresh()
	Else
		ApMsgStop('RCOMF01-004: Erro ao buscar os Itens de Pedidos do produto da NF: '+StrZero(nAt,2))
	EndIf

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออปฑฑ
//ฑฑบPrograma  ณ MarkPed    บ Autor ณ Cirilo Rocha	    	 บ Data ณ 21/03/12 บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao no dublo click nos itens do pedido, para vincular   บฑฑ
//ฑฑบ          ณ com o item da NF.                                          บฑฑ
//ฑฑบ          ณ Atualiza informacoes dos itens da NF e dos Itens dos PC's  บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function MarkPed(aItensNF)

	Local nAtPed	:= oLstPed:nAt //Posicao atual do array
	Local nAtNF		:= oLstNF:nAt	//Posicao atual do array

	If !aLstPed[nAtPed][nIPC_OK] //Se esta marcando

		IF Round(aLstPed[nAtPed][nIPC_PRECO],2) <> Round(aItensNF[nAtNF][nIT_PRCUNT],2)
			MsgInfo("Preco unitario da NF divergente do pedido de compra")
		EndIF
		IF NoRound (aItensNF[nAtNF][nIT_QUANT],2) <> NoRound (aLstPed[nAtPed][nIPC_QTSEL],2)
			MsgInfo("Quantidade da NF divergente do pedido de compra")
		EndIF
		//If !Empty(aItensNF[nAtNF][nIT_NUMPC]) //Se ja esta vinculado com outro item de pedido
		//	ApMsgStop('Esse item da Nf '+StrZero(nAtNF,2)+' - '+AllTrim(aItensNF[nAtNF][nIT_DESCRI])+' jแ esta vinculado ao pedido '+aItensNF[nAtNF][nIT_NUMPC]+'-'+aItensNF[nAtNF][nIT_ITPC])
		//Else
		//If NoRound (aItensNF[nAtNF][nIT_QUANT],2) > NoRound (aLstPed[nAtPed][nIPC_QTPEN],2) //Valida a quantidade pendente
		//ApMsgStop('A quantidade pendente do item do pedido ้ menor que a quantidade da NF.')
		//Else
		//Marca o item do PC
		aLstPed[nAtPed][nIPC_OK		] 	:= !aLstPed[nAtPed][nIPC_OK]
		aLstPed[nAtPed][nIPC_QTPEN	] 	-= aItensNF[nAtNF][nIT_QUANT]
		aLstPed[nAtPed][nIPC_QTSEL	]	+= aItensNF[nAtNF][nIT_QUANT]

		aItensNF[nAtNF][nIT_NUMPC]	:= aLstPed[nAtPed][nIPC_NUM	] //Num PC
		aItensNF[nAtNF][nIT_ITPC ]	:= aLstPed[nAtPed][nIPC_ITEM	] //Item PC
		aItensNF[nAtNF][nIT_LOCAL]	:= aLstPed[nAtPed][nIPC_LOCAL	] //Local
		//			aItensNF[nAtNF][nIT_LOTE ]	:= aLstPed[nAtPed][nIPC_LOTE	] //Lote

		//Forca a atualizacao do browser de PC's
		oLstPed:Refresh()

		//Forca a atualizacao do browser de NF's
		oLstNF:Refresh()
		//	EndIf
		//EndIf
	Else
		If Empty(aItensNF[nAtNF][nIT_NUMPC]) //Se nao esta vinculado com nenhum pedido
			ApMsgStop('Esse item da Nf '+StrZero(nAtNF,2)+' - '+AllTrim(aItensNF[nAtNF][nIT_DESCRI])+' nใo esta vinculado a nenhum pedido.')
		Else
			//Marca o item do PC
			aLstPed[nAtPed][nIPC_OK		]	:= !aLstPed[nAtPed][nIPC_OK]
			aLstPed[nAtPed][nIPC_QTPEN	] 	+= aItensNF[nAtNF][nIT_QUANT]
			aLstPed[nAtPed][nIPC_QTSEL	]	-= aItensNF[nAtNF][nIT_QUANT]

			aItensNF[nAtNF][nIT_NUMPC]	:= Space(len(aItensNF[nAtNF][nIT_NUMPC]))
			aItensNF[nAtNF][nIT_ITPC ]	:= Space(len(aItensNF[nAtNF][nIT_ITPC ]))
			aItensNF[nAtNF][nIT_LOCAL]	:= Space(len(aItensNF[nAtNF][nIT_LOCAL]))
			//		aItensNF[nAtNF][nIT_LOTE ]	:= Space(len(aItensNF[nAtNF][nIT_LOTE ]))

			//Forca a atualizacao do browser de PC's
			oLstPed:Refresh()

			//Forca a atualizacao do browser de NF's
			oLstNF:Refresh()
		EndIf
	EndIf

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออปฑฑ
//ฑฑบPrograma  ณ VldSelPed  บ Autor ณ Cirilo Rocha	    	 บ Data ณ 21/03/12 บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao para validar se todos os itens da NF estao vincula- บฑฑ
//ฑฑบ          ณ culados com algum pedido de compra                         บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function VldSelPed(aItensNF,oDlg,lVldPcNFe)

	Local i
	Local lOK		:= .T.	//Confirmou o processo?

//Busca se todos os itens da NF estao associados a um PC
	For i := 1 to len(aItensNF)
		If Empty(aItensNF[i][nIT_NUMPC]) //Se nao esta vinculado a nenhum PC
			ApMsgStop('O item '+StrZero(i,2)+' - '+AllTrim(aItensNF[i][nIT_DESCRI])+' da NF nใo estแ vinculado a nenhum pedido de compras.')

			//Se a selecao de PC e' obrigatoria nao prossegue
			If lVldPcNFe
				lOK		:= .F.
				//Se e' opcional pergunta ao usuario
			ElseIf ApMsgNoYes('Deseja prosseguir sem vincular todos os itens da Nota Fiscal com um Pedido de Compras?')
				lOK		:= .T.
			Else
				lOK		:= .F.
			EndIf

			Exit
		EndIf
	Next

	If lOK
		oDlg:End()
	EndIf

Return lOK

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออปฑฑ
//ฑฑบPrograma  ณ VincArq    บ Autor ณ Cirilo Rocha 		 บ Data ณ 21/03/12 บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao para vincular arquivos usando a funcao MsDocument   บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function VincArq(cFile,cNota,cSerie,cFornece,cLoja,cNmForn)

	Local lRetorno		:= .T.
	Local aArea			:= U_CXGetArea({'AC9','ACB','SX2'})
	Local cDescri		:= " da NFe "+cNota+'/'+cSerie+' Forn: '+cFornece+'-'+cLoja+' - '+cNmForn
	Local aChave		:= {}
	Local aEntidade 	:= {}
	Local cEntidade		:= 'SF1'
	Local cCodEnt		:= ''
	Local nScan 		:= 0
	Local cDirDoc		:= MsDocPath()
	Local cExten		:= ""
	Local cObjeto		:= ""
	Local cFileDest	:= ""

	ACB->(dbSetOrder(2)) //ACB_FILIAL+ACB_OBJETO
	AC9->(dbSetOrder(1)) //AC9_FILIAL+AC9_CODOBJ+AC9_ENTIDA+AC9_FILENT+AC9_CODENT

//Divide o caminho em arquivo e extensao
	SplitPath( cFile,,, @cFileDest, @cExten )
	cFileDest	:= Upper('NFE-'+cFilAnt+'-'+cFileDest)
	cFileDest	:= StrTran(cFileDest,' ','_')
	cFileDest	:= NoAcento(cFileDest)
	cExten		:= Upper(cExten)

//Cria o nome do objeto
	cObjeto	:= Left( Upper( cFileDest + cExten ), Len( ACB->ACB_OBJETO ) )

	If lRetorno
		If !__CopyFile( cFile, cDirDoc+'\'+ cFileDest + cExten)
			ApMsgInfo('RCOMF01-008: Falha ao copiar o arquivo da origem: '+CRLF+;
				cFileDest+CRLF+;
				'para o destino:'+CRLF+;
				cFileDest)
			lRetorno	:= .F.
		EndIf
	EndIf

	If lRetorno
		//Grava objeto no banco ACB
		ACB->(dbSeek(xFilial("ACB")+cObjeto))
		RecLock( "ACB", ACB->(!Found()) )
		ACB->ACB_FILIAL  	:= xFilial( "ACB" )
		ACB->ACB_DESCRI	:= StrTran(cExten,'.','')+cDescri
		ACB->ACB_OBJETO	:= cObjeto

		If ACB->(!Found())
			ACB->ACB_CODOBJ  	:= CriaVar('ACB_CODOBJ',.T.)
		EndIf
		ACB->(MsUnlock())

		If ACB->(!Found())
			ConfirmSx8()
		EndIf

		aEntidade	:= MsRelation()
		nScan 		:= AScan( aEntidade, { |x| x[1] == cEntidade } )
		//Se nao achou a chave padrao do sistema
		If nScan == 0
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Localiza a chave unica pelo SX2                                        ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			//(cAliasTmp)->( dbSetOrder( 1 ) )
			//If (cAliasTmp)->( dbSeek( cEntidade ) )
			//	If !Empty( (cAliasTmp)->(X2_UNICO) )
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Macro executa a chave unica                                            ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			//		cCodEnt  := &(cAliasTmp)->(X2_UNICO)
			//	EndIf
			//EndIf

		Else
			aChave   := aEntidade[ nScan, 2 ]
			cCodEnt  := MaBuildKey( cEntidade, aChave )
		EndIf

		//Busca se o relacionamento ja existe
		AC9->(dbSeek(xFilial('AC9')+ACB->ACB_CODOBJ+cEntidade+xFilial(cEntidade)+cCodEnt))
		RecLock('AC9',AC9->(!Found()))
		AC9->AC9_FILIAL	:= xFilial('AC9')
		AC9->AC9_ENTIDA	:= cEntidade
		AC9->AC9_CODOBJ	:= ACB->ACB_CODOBJ
		AC9->AC9_CODENT	:= cCodEnt
		AC9->AC9_FILENT	:= xFilial(cEntidade)
		AC9->(MsUnLock())
	Else
		ApMsgStop('RCOMF01-009: Erro ao copiar o arquivo XML '+CRLF+;
			'('+cFile+')')
		lRetorno	:= .F.
	EndIf

	U_CXRestArea(aArea)

Return lRetorno

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออปฑฑ
//ฑฑบPrograma  ณ MoveArq    บ Autor ณ Cirilo Rocha 		 บ Data ณ 21/03/12 บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออนฑฑ
//ฑฑบDescricao ณ Funcao para mover os arquivos de uma pasta para outra      บฑฑ
//ฑฑบ          ณ Usada para mover os arquivos anexados para a pasta         บฑฑ
//ฑฑบ          ณ PROCESSADOS                                                บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function MoveArq(cOrigem,cPathDest)

	Local lRetorno	:= .T.
	Local cFile		:= ""
	Local cExten	:= ""
	Local lOkDir	:= .T.

//Cria diretorio de processadas se nao existir
	If !ExistDir(cPathDest)
		If MakeDir(cPathDest) <> 0
			ApMsgInfo('RCOMF01-010: Falha ao criar o diretorio de destino: '+CRLF+;
				cPathDest+CRLF+;
				'A grava็ใo serแ concluํda normalmente.')
			lOkDir	:= .F.
		EndIf
	EndIf

//Se criou o diretorio entao move os arquivos
	If lOkDir
		SplitPath( cOrigem, , , @cFile, @cExten )

		If __CopyFile(cOrigem,cPathDest+cFile+cExten)
			If FErase(cOrigem) <> 0
				ApMsgInfo('RCOMF01-011: Falha ao apagar o arquivo da origem: '+CRLF+;
					cOrigem+CRLF+;
					'A grava็ใo serแ concluํda normalmente.')
				lRetorno	:= .F.
			EndIf
		Else
			ApMsgInfo('RCOMF01-012: Falha ao copiar o arquivo da origem: '+CRLF+;
				cOrigem+CRLF+;
				'para o destino:'+CRLF+;
				cPathDest+cFile+cExten+CRLF+;
				'A grava็ใo serแ concluํda normalmente.')
			lRetorno	:= .F.
		EndIf
	EndIf

Return lRetorno


/*
###############################################################################
# MELHORIAS FUTURAS                                                           #
###############################################################################

//-----------------------------------------------------------------------------

- Criar EXECAUTO para inclusao de cliente ou fornecedor e quando terminar abrir
a tela de cadastro para o usario complementar os dados
- Possivel melhoria armazenando os valores das faturas e dos impostos
- Validar assinatura do xml

//-----------------------------------------------------------------------------
//Inicio da analise para validacao da assintura do xml

//A validacao da NFe e' feita entre as Tags <infNFe>
i		:= At('<ide>',cBuffer)
f		:= Rat('</infNFe>',cBuffer)
cNf	:= SubString(cBuffer,i,f-i)

cSha1Calc	:= Upper(Sha1(cNF))
cAssCalc		:= HexToChar(cSha1Calc)
cXMLCalc		:= Encode64(cAssCalc)

cXMLNF		:= oNFe:_NFEPROC:_PROTNFE:_INFPROT:_DIGVAL:TEXT
cAssNF  		:= Decode64(cXMLNF)
cSha1Nf		:= CharToHex(cAssNF)
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
Static Function HexToChar(cString)

Local cRetorno := ""
Local cHex		:= ""
Local i

cString	:= Upper(cString)

While len(cString) > 0
cHex		:= Left(cString,2)
cString	:= Right(cString,len(cString)-2)
cRetorno	+= Char(CtoN(cHex,16))
EndDo

Return cRetorno

//-----------------------------------------------------------------------------
Static Function CharToHex(cString,nTamHex)

Local cRetorno := ""
Local nHex		:= 0
Local i

Default	nTamHex	:= 2

While len(cString) > 0
nHex		:= Asc(Left(cString,1))
cString	:= Right(cString,len(cString)-1)

cRetorno	+= PadL(NtoC(nHex,16),nTamHex,'0')
EndDo

Return cRetorno
//-----------------------------------------------------------------------------
*/

//-----------------------------------------------------------------------------
//Valida entrada com PC?
//-----------------------------------------------------------------------------
User Function RCOMF01A(cEspecie,cFornec,cLoja,cFormul,cTipo)

	Local aArea		:= U_CXGetArea({'SA2'})
	Local cEspNF	:= AllTrim(GetNewPar('MS_ESPNF','CF,NF,NF1,NFF,NFVC,SPED'))
	Local lVldPc	:= GetNewPar('MS_PCNFE',.F.) //Alterdo por David - Para nใo obrigar pedido de compra
	Local lRetorno	:= .F.

	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial('SA2')+cFornec+cLoja))


	If lVldPC 							.And. ; //Parametro customizado MS_PCNFE ativo?
		cFormul <> 'S' 				.And. ; //Nao e' formulario proprio
		cTipo == 'N' 					.And. ; //Apenas NF's Normais (devolucao, retorno, remessa nao sao validadas)
		AllTrim(cEspecie) $ cEspNF .And. ; //Especie de documentos que devem ser validados (MS_ESPNF)
		SA2->A2_YSEMPC <> 'S'				  //Fornecedor aceita entrada sem PC?

		lRetorno	:= .T.
	EndIf
	U_CXRestArea(aArea)


Return lRetorno

/**

** Descri็ใo: Rayanne Meneses
** Data: 10.08.2016
**

**/
User Function ImpPreCTe( cFile )
local ny:=0
local nx:=0
Local nTamFile		:= 0
Local nBtLidos		:= 0
Local cBuffer		:= ""
Local cErro			:= ""
Local cAviso		:= ""
Local cChvCte		:= ""
Local aCstIcms		:= {}
Local aCstSnIcms	:= {}
Local nQuant := 0
Local nVlrTotal := 0
Local nValUnit:= 0
Local nVlrIcms := 0
Local nPctIcms := 0
Local aItensNF := {}
Local aTemp := {}
Local aCabec  := {}
Local aLinha := {}
Local aItens := {}
Local aAnexos		:= {}
Local xFile			:= ""
Local cPathProc	:= ""
Local cDrive		:= ""
Local cDir			:= ""
Local cExten		:= ""
Local cCveNfe 		:= ""
Local cSerNfe 		:= ""
Local _cTipoConv := ""
Local CST_Aux := ""
Private oNCte,oCte
Private nHdl

nHdl    := fOpen(cFile,0)

If nHdl == -1
	If !Empty(cFile)
		ApMsgAlert("O arquivo de nome "+cFile+" nใo pode ser aberto! Verifique os parยmetros.","Aten็ใo!")
	Endif
	Return
Endif

nTamFile := fSeek(nHdl,0,2)

fSeek(nHdl,0,0)

cBuffer  := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
nBtLidos := fRead(nHdl,@cBuffer,nTamFile)  // Leitura  do arquivo XML

fClose(nHdl)

oNCte	 := XmlParser(cBuffer,"_",@cErro,@cAviso)

//Erro no processamento do XML
If !Empty(cErro)
	ApMsgStop('RCOMF01-001: Erro na leitura do XML: '+CRLF+;
	cErro)
	Return
EndIf

//Verifica validade do arquivo
If  U_fVldTyp('Type("oNCte:_CTEPROC:_CTE") <> "U"')
	oCte 		:= oNCte:_CTEPROC:_CTE
	cChvCte	:= oNCte:_CTEPROC:_CTE:_InfCte:_Id:Text
	cChvCte	:= StrTran(cChvCte,'CTe')
ElseIf  U_fVldTyp('Type("oNCte:_CTE") <> "U"')
	oCte 		:= oNCte:_CTE
	cChvCte	:= oNCte:_CTE:_InfCte:_Id:Text
	cChvCte	:= StrTran(cChvCte,'NFe')
Else
	ApMsgStop('RCOMF01-015: Arquivo XML invแlido. O processo serแ interrompido.')
	Return
Endif

//Referente a NF de Compra/Venda
cCveNfe := oNCte:_CTEPROC:_CTE:_InfCte:_infCTeNorm:_infDoc:_infNFe:_chave:Text
cCveNfe := Substr(cCveNfe,26,9)

cSerNfe := oNCte:_CTEPROC:_CTE:_InfCte:_infCTeNorm:_infDoc:_infNFe:_chave:Text
cSerNfe := Substr(cSerNfe,35,1)

//Alimenta variaveis com os dados do XML
oEmitente 	:= oCte:_InfCte:_Emit
oIdent    	:= oCte:_InfCte:_IDE
oDestino  	:= oCte:_InfCte:_Dest
oRemet 		:= oCte:_InfCte:_Rem

aoDet      	:= oCte:_InfCTe

//Se apenas 1 produto entao faz o tratamento para converter em array
If ValType(aoDet)=="O"
	aoDet 	:= {aoDet}
EndIf

If  U_fVldTyp('Type("oCte:_InfCTe:_Cobr") <> "U"')
	oFatura  := oCte:_InfCTe:_Cobr
EndIf

//Guarda o numero da NF
cNota		:= cValToChar(Val(oIdent:_nCT:TEXT))
cSerie		:= PadR(oIdent:_serie:TEXT,3)

// CNPJ ou CPF do emitente
If  U_fVldTyp('Type("oEmitente:_CPF") == "U"')
	cCGCEmit := oEmitente:_CNPJ:TEXT
Else
	cCGCEmit	:= oEmitente:_CPF:TEXT
EndIf
cCGCEmit		:= AllTrim(cCGCEmit)

lFornece		:= !(U_CXNFCliFor(.F.,cTipo)) //Cliente?

// Nota Normal Fornecedor
If lFornece
	SA2->(dbSetOrder(3))
	If SA2->(dbSeek(xFilial("SA2")+cCGCEmit))
		cFornece		:= SA2->A2_COD
		cLoja			:= SA2->A2_LOJA
		cNmForn		:= SA2->A2_NOME
	Else
		ApMsgAlert("CNPJ Origem Nใo Localizado (Fornecedor SA2) - Verifique " + u_CXCPFCNPJ(cCGCEmit))
		Return
	Endif
Else
	SA1->(dbSetOrder(3))
	If SA1->(dbSeek(xFilial("SA1")+cCGCEmit))
		cFornece		:= SA1->A1_COD
		cLoja			:= SA1->A1_LOJA
		cNmForn		:= SA1->A1_NOME
	Else
		ApMsgAlert("CNPJ Origem Nใo Localizado (Clientes SA1) - Verifique " + u_CXCPFCNPJ(cCGCEmit))
		Return
	Endif
Endif

// CNPJ ou CPF destinatario
If  U_fVldTyp('Type("oDestino:_CPF") == "U"')
	cCGCDest := oRemet:_CNPJ:TEXT
Else
	cCGCDest	:= oRemet:_CPF:TEXT
EndIf
cCGCDest		:= AllTrim(cCGCDest)

//Valida o cnpj do destinatario
If SM0->M0_CGC <> cCGCDest
	ApMsgStop('RCOMF01-002: O destinatแrio do CTe atual nใo ้ a empresa que voc๊ estแ logado. A Cte nใo pode ser importada. '+u_CXCPFCNPJ(cCGCDest))
	Return
EndIf

// -- Nota Fiscal jแ existe na base ?
SF1->(dbSetOrder(1)) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
If SF1->(DbSeek(XFilial("SF1")+cNota+cSerie+cFornece+cLoja))
	IF lFornece
		ApMsgAlert("Nota No.: "+cNota+"/"+cSerie+" do Fornec. "+SA2->(A2_COD+"/"+A2_LOJA+" - "+A2_NOME)+" Jแ Existe. A Importa็ใo serแ interrompida.")
	Else
		ApMsgAlert("Nota No.: "+cNota+"/"+cSerie+" do Cliente "+SA1->(A1_COD+"/"+A1_LOJA+" - "+A1_NOME)+" Jแ Existe. A Importa็ใo serแ interrompida.")
	Endif
	Return Nil
EndIf

cProd := "000252" //Como o produto q ้ usado ้ sempre o mesmo para todos os fornecedores, deixei amarrado no fonte


//############################################################################
//# Busca nas tabelas SA5 (Produto x Fornecedor) e SA7 (Produto x Cliente)   #
//# se nao encontrar mostra tela para que o usuario preencha a informacao.   #
//############################################################################

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se nf de fornecedor ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lFornece
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ  Busca informacao do produto equivalente ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//SA5->(DbOrderNickName('FORPROD'))   // FILIAL + FORNECEDOR + LOJA + CODIGO PRODUTO NO FORNECEDOR
	cQuery := " SELECT * FROM "+RetSqlName("SA5")+" WHERE D_E_L_E_T_ = ' ' AND A5_FILIAL = '"+xFilial("SA5")+"' AND "
	cQuery += " A5_PRODUTO = '" + cProd + "' AND A5_FORNECE = '" + cFornece + "' AND A5_LOJA = '" +cLoja+ "'
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"T01",.T.,.T.)
	
	If !T01->(Eof())
		
		_cTipoConv := T01->A5_UNID
		
	Endif
	
	T01->( dbCloseArea() )
	
EndIf

//###########################################################################
//# Se possui ICMS obtem os dados para o ICMS                               #
//###########################################################################

If  U_fVldTyp('Type("aoDet["'+Ltrim(str(LEN(aoDet)))+'"]:_imp:_ICMS")<> "U"')
	lAchou	:= .F.
	For nY := 1 to len(aCstIcms)
		If  U_fVldTyp('Type("aoDet["+Ltrim(str(LEN(aoDet)))+"]:_imp:_ICMS:_ICMS"+aCstIcms[nY]) <> "U"')
			oICM		:=	&("aoDet["+Ltrim(str(LEN(aoDet)))+"]:_imp:_ICMS:_ICMS"+aCstIcms[nY])
			CST_Aux		:=	Alltrim(oICM:_CST:TEXT)
			nVlrIcms 	:= Val( oICM:_vICMS:TEXT )
			nPctIcms	:= Val( oICM:_pICMS:TEXT )
			lAchou	:= .T.
			Exit
		EndIf
	Next
	If !lAchou
		For nY := 1 to len(aCstSnIcms)
			If  U_fVldTyp('Type("aoDet["+Ltrim(str(LEN(aoDet)))+"]:_imp:_ICMS:_ICMSSN"+aCstSnIcms[nY]) <> "U"')
				oICM		:=	&("aoDet["+Ltrim(str(LEN(aoDet)))+"]:_Imposto:_ICMS:_ICMSSN"+aCstSnIcms[nY])
				CST_Aux	:=	Alltrim(oICM:_orig:TEXT)+Alltrim(oICM:_CSOSN:TEXT)
				lAchou	:= .T.
				Exit
			EndIf
		Next
	EndIf
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida a chave da Cte ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//Ver valida็ใo

//Quantidade
If  U_fVldTyp('Type("aoDet["+Ltrim(str(LEN(aoDet)))+"]:_infCtenorm:_infcarga:_infq[1]:_qcarga")<> "U"')
	
	nQuant	:= Val(aoDet[1]:_infCtenorm:_infcarga:_infq[1]:_qcarga:TEXT)
	
	If AllTrim( _cTipoConv ) == "KG"
		
		nQuant	:= nQuant/1000
		
	EndIf
	
ElseIf  U_fVldTyp('Type("aoDet["+Ltrim(str(LEN(aoDet)))+"]:_infCtenorm:_infcarga:_infq:_qcarga")<> "U"')
	
	nQuant	:= Val(aoDet[1]:_infCtenorm:_infcarga:_infq:_qcarga:TEXT)
	
	If AllTrim( _cTipoConv ) == "KG"
		
		nQuant	:= nQuant/1000
		
	EndIf
	
Endif

//Valor Total
If  U_fVldTyp('Type("aoDet["+Ltrim(str(LEN(aoDet)))+"]:_vPrest:_vREC")<> "U"')
	nVlrTotal	:= Val(aoDet[1]:_vPrest:_vREC:TEXT)
Endif

nValUnit := nVlrTotal/nQuant

//Monta array para alimentar

aTemp				:= array(nIT_TAMARR)
aTemp[nIT_ITEM  ]	:= "0001"
aTemp[nIT_COD   ]	:= cProd
aTemp[nIT_DESCRI]	:= Posicione( "SB1",1,xFilial("SB1")+cProd, "B1_DESC" )
aTemp[nIT_QUANT ]	:= nQuant
aTemp[nIT_PRCUNT]	:= nValUnit
aTemp[nIT_VLRTOT]	:= nVlrTotal
aTemp[nIT_DESCON]	:= 0
aTemp[nIT_VALFRE]	:= 0
aTemp[nIT_SEGURO]	:= 0
aTemp[nIT_DESPES] 	:= 0
aTemp[nIT_NCM   ]	:= Posicione( "SB1",1,xFilial("SB1")+cProd, "SB1->B1_POSIPI" )
aTemp[nIT_CST   ]	:= Posicione( "SB1",1,xFilial("SB1")+cProd, "B1_ORIGEM" )+CST_Aux
aTemp[nIT_NUMPC ]	:= Space(TamSX3('C7_NUM'    )[1])
aTemp[nIT_ITPC  ]	:= Space(TamSX3('C7_ITEM'   )[1])
aTemp[nIT_LOCAL ]	:= Space(TamSX3('C7_LOCAL'  )[1])
//aTemp[nIT_LOTE  ]	:= Space(TamSX3('C7_LOTECLT')[1])

aAdd(aItensNF,	aClone(aTemp) )

//############################################################################
//# Tela de selecao do vinculo entre os itens da NF com Pedidos de Compra    #
//############################################################################
If lFornece
	
	//Deve validar entrada com PC?
	lVldPcNFe	:= U_RCOMF01A('CTE',cFornece,cLoja,'N',cTipo)
	//LINHA 2161 ALTERADA POR RAYANNE
	//Seleciona pedidos
	If !SelPed(aItensNF,"'"+cProd+"'",cFornece,cLoja,cNmForn,cCGCEmit,cNota,cSerie,lVldPcNFe) //Se cancelou a selecao
		ApMsgStop('Importa็ใo da NF interrompido.')
		Return
	EndIf
EndIf

//#############################################################################
//# Monta dados do cabecalho para o Execauto da Pre-Nota                      #
//#############################################################################

dDataEmis	:= StoD(Alltrim(U_CXSoNumeros(substr( oIdent:_DHEMI:TEXT,1,10))))
//oIdent:_dEmi
aAdd(aCabec,{"F1_TIPO"   	,cTipo		,Nil,Nil})
//	aAdd(aCabec,{"F1_FORMUL" 	,"N"			,Nil,Nil})
aAdd(aCabec,{"F1_DOC"    	,cNota		,Nil,Nil})
aAdd(aCabec,{"F1_SERIE"  	,cSerie		,Nil,Nil})
aAdd(aCabec,{"F1_EMISSAO"	,dDataEmis	,Nil,Nil})
aAdd(aCabec,{"F1_FORNECE"	,cFornece	,Nil,Nil})
aAdd(aCabec,{"F1_LOJA"   	,cLoja		,Nil,Nil})
aAdd(aCabec,{"F1_ESPECIE"	,"CTE"		,Nil,Nil})
aAdd(aCabec,{"F1_CHVNFE"	,cChvCte	,Nil,Nil})
aAdd(aCabec,{"F1_YNFCIF"	,PadL(Alltrim( cCveNfe ),TamSX3('F1_YNFCIF')[1],'0') ,Nil,Nil})
aAdd(aCabec,{"F1_YNFSER"	,cSerNfe		,Nil,Nil})
aAdd(aCabec,{"F1_MENNOTA"	,"Ref. a frete da NFe de venda: "+PadL(Alltrim( cCveNfe ),TamSX3('F1_YNFCIF')[1],'0')		,Nil,Nil})

//Grava campo dizendo que importou o XML
If SF1->(FieldPos('F1_YIMPXML')) > 0
	aAdd(aCabec,{"F1_YIMPXML"	,'S'			,Nil,Nil})
EndIf

//Observacoes da NF
If  U_fVldTyp("Type('oInfAdic:_InfCpl:Text') == 'C'")
	aAdd(aCabec,{"F1_MENNOTA"	,oInfAdic:_InfCpl:Text	,Nil,Nil})
EndIf

/*//Pesos e volumes
nPBruto	:= 0
nPLiqui	:= 0
For nX := 1 to len(aoVol)
	If  U_fVldTyp("Type('aoVol[nX]:_Esp:Text') == 'C'")
		aAdd(aCabec,{"F1_ESPECI"+Str(nX,1)	,aoVol[nX]:_Esp:Text 	,Nil,Nil})
	EndIf
	If  U_fVldTyp("Type('aoVol[nX]:_QVol:Text') == 'C'")
		aAdd(aCabec,{"F1_VOLUME"+Str(nX,1)	,Val(aoVol[nX]:_QVol:Text) 	,Nil,Nil})
	EndIf
	If  U_fVldTyp("Type('aoVol[nX]:_PesoB:Text') == 'C'")
		nPBruto	:= Val(aoVol[nX]:_PesoB:Text)
	EndIf
	If  U_fVldTyp("Type('aoVol[nX]:_PesoL:Text') == 'C'")
		nPLiqui	:= Val(aoVol[nX]:_PesoL:Text)
	EndIf
Next
If nPBruto > 0
	aAdd(aCabec,{"F1_PBRUTO",nPBruto	,Nil,Nil})
EndIf
If nPLiqui > 0
	aAdd(aCabec,{"F1_PLIQUI",nPLiqui	,Nil,Nil})
EndIf*/

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Alimenta informacoes dos Itens da NF ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nX := 1 To Len(aItensNF)
	//Zera variaveis para inicio do processamento
	aLinha 	:= {}
	
	aAdd(aLinha,{"D1_COD"		,aItensNF[nX][nIT_COD	],Nil,Nil})
	
	//O pedido tem que ser digitado antes dos valores, senao, o sistema considera os valores do PC e nao da NF-e
	If !Empty(aItensNF[nX][nIT_NUMPC	])
		aAdd(aLinha,{"D1_PEDIDO"	,aItensNF[nX][nIT_NUMPC	],Nil,Nil})
	EndIf
	If !Empty(aItensNF[nX][nIT_ITPC	])
		aAdd(aLinha,{"D1_ITEMPC"	,aItensNF[nX][nIT_ITPC	],Nil,Nil})
	EndIf
	
	aAdd(aLinha,{"D1_QUANT"		,aItensNF[nX][nIT_QUANT	],Nil,Nil})
	aAdd(aLinha,{"D1_QTSEGUM"	,ConvUm(aItensNF[nX][nIT_COD],aItensNF[nX][nIT_QUANT],0,2),Nil,Nil})
	
	aAdd(aLinha,{"D1_VUNIT"		,aItensNF[nX][nIT_PRCUNT],Nil,Nil})
	aAdd(aLinha,{"D1_TOTAL"		,aItensNF[nX][nIT_VLRTOT],Nil,Nil})
	aAdd(aLinha,{"D1_VALDESC"	,aItensNF[nX][nIT_DESCON],Nil,Nil})
	
	aAdd(aLinha,{"D1_VALFRE"	,aItensNF[nX][nIT_VALFRE],Nil,Nil})
	aAdd(aLinha,{"D1_SEGURO"	,aItensNF[nX][nIT_SEGURO],Nil,Nil})
	aAdd(aLinha,{"D1_DESPESA"	,aItensNF[nX][nIT_DESPES],Nil,Nil})
	aAdd(aLinha,{"D1_VALICM"	,nVlrIcms,Nil,Nil})
	aAdd(aLinha,{"D1_PICM"		,nPctIcms,Nil,Nil})
	
	//		aAdd(aLinha,{"D1_CLASFIS"	,aItens[nX][08],Nil,Nil}) //Essa informacao vira da TES posteriormente
	If !Empty(aItensNF[nX][nIT_LOCAL	])
		//CriaSB2( aItensNF[nX][nIT_COD	] , aItensNF[nX][nIT_LOCAL] )
		aAdd(aLinha,{"D1_LOCAL" 	,aItensNF[nX][nIT_LOCAL	],Nil,Nil})
	EndIf
	
	//aAdd(aLinha,{"D1_LOTECTL"	,aItensNF[nX][nIT_LOTE],Nil,Nil})
	
	aAdd(aItens,aLinha)
Next nX

//############################################################################
//# Executa a Inclusao                                                       #
//############################################################################
If Len(aItens) > 0
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	
	SB1->( dbSetOrder(1) )
	SA2->( dbSetOrder(1) )
	SA1->( dbSetOrder(1) )
	SE4->( dbSetOrder(1) )
	
	nModulo := 4  //ESTOQUE
	
	Begin Transaction
	MsgRun("Incluindo Pre-Nota. Aguarde...","Incluindo Pre-Nota...",{|| MSExecAuto({|x,y,z|Mata140(x,y,z)},aCabec,aItens,3) })
	
	IF lMsErroAuto
		DisarmTransaction()
		MostraErro()
	Else
		ConfirmSX8()
		
		//#######################################################################
		//# Copia os arquivos para o servidor e vincula com a Nota fiscal (SF1) #
		//#######################################################################
		SplitPath( cFile, @cDrive, @cDir, @xFile, @cExten )
		cPathProc	:= cDrive+cDir+'Processadas\'
		
		//Busca arquivos para anexar ao cadastro via botao conhecimento
		aAnexos	:= AchaAnexos(cChvCte,cFile)
		
		For nX := 1 to len(aAnexos)
			//Vincula os arquivos no servidor via botao conhecimento
			VincArq(aAnexos[nX],cNota,cSerie,cFornece,cLoja,cNmForn)
			
			//Move os arquivos processados para a pasta Processados
			MoveArq(aAnexos[nX], cPathProc)
		Next
		
		ApMsgInfo(Alltrim(cNota)+' / '+Alltrim(cSerie)+" - Pr้ Nota Gerada Com Sucesso!")
	EndIf
	End Transaction
Endif

Return
