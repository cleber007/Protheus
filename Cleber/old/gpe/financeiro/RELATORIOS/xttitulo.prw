//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} xTTITULO
Relatório - Relatorio Titulos em aberto   
@author zReport
@since 15/08/2022
@version 1.0
	@example
	u_xTTITULO()
	@obs Função gerada pelo zReport()
/*/
	
User Function xTTITULO()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "titulos   "
	
	//Se a pergunta não existir, zera a variável
	DbSelectArea("SX1")
	SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	If ! SX1->(DbSeek(cPerg))
		cPerg := Nil
	EndIf
	
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
	oReport := TReport():New(	"xTTITULO",;		//Nome do Relatório
								"Relatorio Titulos em aberto",;		//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetLandscape()
	
	//Criando a seção de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Dados",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad, "FORNECEDOR", "QRY_AUX", "Fornecedor", /*Picture*/, 34, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TITULO", "QRY_AUX", "Titulo", /*Picture*/, 16, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_TIPO", "QRY_AUX", "Tipo", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_NATUREZ", "QRY_AUX", "Natureza", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ED_DESCRIC", "QRY_AUX", "Descricao_Natureza", /*Picture*/, 45, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CONTA_CREDITO", "QRY_AUX", "Conta_Credito", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CREDITO", "QRY_AUX", "Descrição_Credito", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CONTA_DEBITO", "QRY_AUX", "Conta_Debito", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DEBITO2", "QRY_AUX", "Descrição_Debito", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMISSAO", "QRY_AUX", "Emissao", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VENCIAMENTO", "QRY_AUX", "Vencimento", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VENCIMENTO_REAL", "QRY_AUX", "Vencimento_Real", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_VALOR", "QRY_AUX", "Valor_titulo", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_HIST", "QRY_AUX", "Historico", /*Picture*/, 120, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "E2_BAIXA", "QRY_AUX", "Data_Baixa", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux := ""
	cQryAux += "SELECT E2_FORNECE"		+ STR_PULA
	cQryAux += "+'-'+E2_LOJA"		+ STR_PULA
	cQryAux += "+'-'+E2_NOMFOR  AS FORNECEDOR "		+ STR_PULA
	cQryAux += ", E2_PREFIXO"		+ STR_PULA
	cQryAux += "+'-'+E2_NUM"		+ STR_PULA
	cQryAux += "+'-'+ E2_PARCELA  AS TITULO"		+ STR_PULA
	cQryAux += ", E2_TIPO"		+ STR_PULA
	cQryAux += ", E2_NATUREZ"		+ STR_PULA
	cQryAux += ", ED_DESCRIC"		+ STR_PULA
	cQryAux += ", ED_CREDIT AS CONTA_CREDITO"		+ STR_PULA
	cQryAux += ", (SELECT CT1_DESC01 FROM CT1010 CT1 WHERE CT1.CT1_FILIAL = ED.ED_FILIAL AND CT1.CT1_CONTA = ED.ED_CREDIT AND CT1.D_E_L_E_T_ = '') AS CREDITO"		+ STR_PULA
	cQryAux += ", ED_DEBITO	AS CONTA_DEBITO"		+ STR_PULA
	cQryAux += ", (SELECT CT1_DESC01 FROM CT1010 CT1 WHERE CT1.CT1_FILIAL = ED.ED_FILIAL AND CT1.CT1_CONTA = ED.ED_DEBITO AND CT1.D_E_L_E_T_ = '') AS DEBITO2"		+ STR_PULA
	cQryAux += ", SUBSTRING(E2_EMISSAO,7,2) + '/' + SUBSTRING(E2_EMISSAO,5,2) + '/' + SUBSTRING(E2_EMISSAO,1,4)  AS EMISSAO"		+ STR_PULA
	cQryAux += ", SUBSTRING(E2_VENCTO,7,2) + '/' + SUBSTRING(E2_VENCTO,5,2) + '/' + SUBSTRING(E2_VENCTO,1,4)  AS VENCIAMENTO"		+ STR_PULA
	cQryAux += ", SUBSTRING(E2_VENCREA,7,2) + '/' + SUBSTRING(E2_VENCREA,5,2) + '/' + SUBSTRING(E2_VENCREA,1,4)  AS VENCIMENTO_REAL"		+ STR_PULA
	cQryAux += ", E2_VALOR	"		+ STR_PULA
	cQryAux += ", E2_HIST"		+ STR_PULA
	cQryAux += ", E2_BAIXA"		+ STR_PULA
	cQryAux += "FROM SED010 ED"		+ STR_PULA
	cQryAux += "INNER JOIN SE2010 E2"		+ STR_PULA
	cQryAux += "ON E2.E2_NATUREZ = ED.ED_CODIGO AND ED.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "WHERE "		+ STR_PULA
	cQryAux += "E2_VENCTO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"'		"+ STR_PULA
	cQryAux += "AND E2_EMISSAO<='"+Dtos(MV_PAR03)+"'		"+ STR_PULA
	cQryAux += "AND (E2_BAIXA > '"+Dtos(MV_PAR03)+"'OR E2_BAIXA ='')		"+ STR_PULA
	cQryAux += "AND E2.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	
	oReport:SetMeter(nTotal)
	TCSetField("QRY_AUX", "E2_BAIXA", "D")
	
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
