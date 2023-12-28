//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} xCP
Relatório - Relatorio                     
@author zReport
@since 18/10/2022
@version 1.0
	@example
	u_xCP()
	@obs Função gerada pelo zReport()
/*/
	
User Function xCP()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Cria as definições do relatório
	oReport := fReportDef()
	
	//Será enviado por e-Mail?
	If lEmail
		oReport:nRemoteType := NO_REMOTE
		oReport:cEmail := cPara
		oReport:nDevice := 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
		oReport:SetPreview(.F.)
		oReport:Print(.F., "", .T.)
	//Senão, mostra a tela
	Else
		oReport:PrintDialog()
	EndIf
	
	RestArea(aArea)
Return
	
/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Função que monta a definição do relatório                              |
 *-------------------------------------------------------------------------------*/
	
Static Function fReportDef()
	Local oReport
	Local oSectDad := Nil
	Local oBreak := Nil
	
	//Criação do componente de impressão
	oReport := TReport():New(	"xCP",;		//Nome do Relatório
								"Relatorio",;		//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetPortrait()
	
	//Criando a seção de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Dados",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad, "E2_FILIAL", "QRY_AUX", "E2_FILIAL", /*Picture*/, 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_PREFIXO", "QRY_AUX", "E2_PREFIXO", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_PARCELA", "QRY_AUX", "E2_Parcela", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_TIPO", "QRY_AUX", "E2_TIPO", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_NATUREZ", "QRY_AUX", "E2_NATUREZ", /*Picture*/, 5, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_FORNECE", "QRY_AUX", "E2_FORNECE", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_LOJA", "QRY_AUX", "E2_LOJA", /*Picture*/, 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_EMISSAO", "QRY_AUX", "E2_EMISSAO", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_VENCTO", "QRY_AUX", "E2_VENCTO", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_VENCREA", "QRY_AUX", "E2_VENCREA", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_VALOR", "QRY_AUX", "E2_VALOR", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_HIST", "QRY_AUX", "E2_HIST", /*Picture*/, 114, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_FORMPAG", "QRY_AUX", "E2_FORMPAG", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_CCUSTO", "QRY_AUX", "E2_CCUSTO", /*Picture*/, 5, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_FORBCO", "QRY_AUX", "E2_FORBCO", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_FORAGE", "QRY_AUX", "E2_FORAGE", /*Picture*/, 5, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_FAGEDV", "QRY_AUX", "E2_FAGEDV", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_FORCTA", "QRY_AUX", "E2_FORCTA", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_FCTADV", "QRY_AUX", "E2_FCTADV", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Função que imprime o relatório                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	
	//Pegando as seções do relatório
	oSectDad := oReport:Section(1)
	
	//Montando consulta de dados
	cQryAux += "SELECT"		+ STR_PULA
	cQryAux += "'0101' AS E2_FILIAL"		+ STR_PULA
	cQryAux += ", 'XCP' AS E2_PREFIXO"		+ STR_PULA
	cQryAux += ", '01' AS E2_PARCELA"		+ STR_PULA
	cQryAux += ", 'TB' AS E2_TIPO"		+ STR_PULA
	cQryAux += ", '12003' AS E2_NATUREZ"		+ STR_PULA
	cQryAux += ", A2_COD AS E2_FORNECE"		+ STR_PULA
	cQryAux += ", A2_LOJA AS E2_LOJA"		+ STR_PULA
	cQryAux += ", '' AS E2_EMISSAO"		+ STR_PULA
	cQryAux += ", '' AS E2_VENCTO"		+ STR_PULA
	cQryAux += ", '' AS E2_VENCREA"		+ STR_PULA
	cQryAux += ", '' AS E2_VALOR"		+ STR_PULA
	cQryAux += ", UPPER ( 'REPASSE XCAP DO BEM- REFERENTE AO DEPOSITO DO MES' +'-'+ DATENAME(MONTH, GETDATE())   + ' DE ' +  DATENAME(YEAR, GETDATE()))  AS E2_HIST"		+ STR_PULA
	cQryAux += ", CASE WHEN FIL_BANCO =  '001' THEN '01' WHEN FIL_BANCO <>  '001' THEN '41' END AS E2_FORMPAG"		+ STR_PULA
	cQryAux += ", '03011' AS E2_CCUSTO"		+ STR_PULA
	cQryAux += ", FIL_BANCO AS E2_FORBCO"		+ STR_PULA
	cQryAux += ", FIL_AGENCI AS E2_FORAGE"		+ STR_PULA
	cQryAux += ", FIL_DVAGE AS E2_FAGEDV"		+ STR_PULA
	cQryAux += ", FIL_CONTA AS E2_FORCTA"		+ STR_PULA
	cQryAux += ", FIL_DVCTA AS E2_FCTADV"		+ STR_PULA
	cQryAux += " FROM SA2010 A2 "		+ STR_PULA
	cQryAux += "INNER JOIN FIL010 IL ON IL.FIL_FILIAL = A2_FILIAL AND IL.FIL_FORNEC = A2_COD AND IL.D_E_L_E_T_=''"		+ STR_PULA
	cQryAux += "WHERE A2.D_E_L_E_T_=''"		+ STR_PULA
	cQryAux += "AND FIL_TIPO='3'"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	TCSetField("QRY_AUX", "E2_EMISSAO", "C")
	TCSetField("QRY_AUX", "E2_VENCTO", "C")
	TCSetField("QRY_AUX", "E2_VENCREA", "C")
	
	//Enquanto houver dados
	oSectDad:Init()
	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
		//Incrementando a régua
		nAtual++
		oReport:SetMsgPrint("Imprimindo registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
		oReport:IncMeter()
		
		//Imprimindo a linha atual
		oSectDad:PrintLine()
		
		QRY_AUX->(DbSkip())
	EndDo
	oSectDad:Finish()
	QRY_AUX->(DbCloseArea())
	
	RestArea(aArea)
Return
