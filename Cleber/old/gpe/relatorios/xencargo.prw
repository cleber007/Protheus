//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} xENCARGO
Relatório - FEDERAÇÃO NACIONAL DAS APAES  
@author zReport
@since 28/06/2022
@version 1.0
	@example
	u_xENCARGO()
	@obs Função gerada pelo zReport()
/*/
	
User Function xENCARGO()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "XCUSTO    "
	
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
	oReport := TReport():New(	"xENCARGO",;		//Nome do Relatório
								"FEDERAÇÃO NACIONAL DAS APAES",;		//Título
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
	TRCell():New(oSectDad, "PROCESSO", "QRY_AUX", "Processo", /*Picture*/, 100, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "BASE_INSS", "QRY_AUX", "Base_inss", /*Picture*/, 100, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALOR_EMPRESA", "QRY_AUX", "Valor_empresa", /*Picture*/, 100, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALOR_RAT", "QRY_AUX", "Valor_rat", /*Picture*/, 100, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALOR_TERCEIROS", "QRY_AUX", "Valor_terceiros", /*Picture*/, 100, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALOR_COLABORADOR", "QRY_AUX", "Valor_colaborador", /*Picture*/, 100, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "LICENCA_MATERNIDADE", "QRY_AUX", "Licenca_maternidade", /*Picture*/, 100, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "SALARIO_FAMILIA", "QRY_AUX", "Salario_familia", /*Picture*/, 100, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TOTAL", "QRY_AUX", "Total", /*Picture*/, 100, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "BASE_PIS", "QRY_AUX", "Base_pis", /*Picture*/, 100, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALOR_PIS", "QRY_AUX", "Valor_pis", /*Picture*/, 100, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux += "SELECT "		+ STR_PULA
	cQryAux += " PIVOT_TABLE1.PROCESSO"		+ STR_PULA
	cQryAux += ", FORMAT (ISNULL(PIVOT_TABLE1.[0013],0)+ISNULL(PIVOT_TABLE1.[0014],0)+ISNULL(PIVOT_TABLE1.[0019],0)+ISNULL(PIVOT_TABLE1.[0020],0)+ISNULL(PIVOT_TABLE1.[0221],0)+ISNULL(PIVOT_TABLE1.[0225],0), 'C','PT-BR') AS [BASE_INSS]"		+ STR_PULA
	cQryAux += ", FORMAT(((ISNULL(PIVOT_TABLE1.[0013],0)+ISNULL(PIVOT_TABLE1.[0014],0)+ISNULL(PIVOT_TABLE1.[0019],0)+ISNULL(PIVOT_TABLE1.[0020],0)+ISNULL(PIVOT_TABLE1.[0221],0)+ISNULL(PIVOT_TABLE1.[0225],0)) *0.20), 'C','PT-BR') AS [VALOR_EMPRESA]"		+ STR_PULA
	cQryAux += ", FORMAT(((ISNULL(PIVOT_TABLE1.[0013],0)+ISNULL(PIVOT_TABLE1.[0014],0)+ISNULL(PIVOT_TABLE1.[0019],0)+ISNULL(PIVOT_TABLE1.[0020],0)+ISNULL(PIVOT_TABLE1.[0221],0)+ISNULL(PIVOT_TABLE1.[0225],0))*0.01), 'C','PT-BR') AS [VALOR_RAT]"		+ STR_PULA
	cQryAux += ", FORMAT(((ISNULL(PIVOT_TABLE1.[0013],0)+ISNULL(PIVOT_TABLE1.[0014],0)+ISNULL(PIVOT_TABLE1.[0019],0)+ISNULL(PIVOT_TABLE1.[0020],0)+ISNULL(PIVOT_TABLE1.[0221],0)+ISNULL(PIVOT_TABLE1.[0225],0)) *0.045), 'C','PT-BR')  AS [VALOR_TERCEIROS]"		+ STR_PULA
	cQryAux += ", FORMAT(((ISNULL(PIVOT_TABLE1.[0064],0)+ISNULL(PIVOT_TABLE1.[0065],0)+ISNULL(PIVOT_TABLE1.[0070],0)+ISNULL(PIVOT_TABLE1.[0209],0)+ISNULL(PIVOT_TABLE1.[0222],0))), 'C','PT-BR') AS [VALOR_COLABORADOR]"		+ STR_PULA
	cQryAux += ", FORMAT(((ISNULL(PIVOT_TABLE1.[1732],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1338],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[0040],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[0668],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[0669],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[0407],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[0927],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[0928],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1339],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1340],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1647],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1446],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1447],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1434],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1436],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1437],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1438],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1439],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1440],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1442],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1444],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1639],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1640],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1641],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1642],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1643],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1644],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1645],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1646],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1648],0))), 'C','PT-BR') AS [LICENCA_MATERNIDADE]"		+ STR_PULA
	cQryAux += ",   FORMAT (ISNULL(PIVOT_TABLE1.[0034],0), 'C','PT-BR')   AS [SALARIO_FAMILIA]"		+ STR_PULA
	cQryAux += ",FORMAT(((ISNULL(PIVOT_TABLE1.[0013],0)+ISNULL(PIVOT_TABLE1.[0014],0)+ISNULL(PIVOT_TABLE1.[0019],0)+ISNULL(PIVOT_TABLE1.[0020],0)+ISNULL(PIVOT_TABLE1.[0221],0)+ISNULL(PIVOT_TABLE1.[0225],0)) *0.20)+((ISNULL(PIVOT_TABLE1.[0013],0)+ISNULL(PIVOT_TABLE1.[0014],0)+ISNULL(PIVOT_TABLE1.[0019],0)+ISNULL(PIVOT_TABLE1.[0020],0)+ISNULL(PIVOT_TABLE1.[0221],0)+ISNULL(PIVOT_TABLE1.[0225],0))*0.01)+ ((ISNULL(PIVOT_TABLE1.[0013],0)+ISNULL(PIVOT_TABLE1.[0014],0)+ISNULL(PIVOT_TABLE1.[0019],0)+ISNULL(PIVOT_TABLE1.[0020],0)+ISNULL(PIVOT_TABLE1.[0221],0)+ISNULL(PIVOT_TABLE1.[0225],0)) *0.045)+ ((ISNULL(PIVOT_TABLE1.[0064],0)+ISNULL(PIVOT_TABLE1.[0065],0)+ISNULL(PIVOT_TABLE1.[0070],0)+ISNULL(PIVOT_TABLE1.[0209],0)+ISNULL(PIVOT_TABLE1.[0222],0)))-((	ISNULL(PIVOT_TABLE1.[1732],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1338],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[0040],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[0668],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[0669],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[0407],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[0927],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[0928],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1339],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1340],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1647],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1446],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1447],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1434],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1436],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1437],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1438],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1439],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1440],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1442],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1444],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1639],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1640],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1641],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1642],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1643],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1644],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1645],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1646],0)+"		+ STR_PULA
	cQryAux += "	ISNULL(PIVOT_TABLE1.[1648],0)))"		+ STR_PULA
	cQryAux += "-  (ISNULL(PIVOT_TABLE1.[0034],0)), 'C','PT-BR') AS [TOTAL]"		+ STR_PULA
	cQryAux += ", FORMAT (ISNULL(PIVOT_TABLE1.[0013],0)+ISNULL(PIVOT_TABLE1.[0014],0)+ISNULL(PIVOT_TABLE1.[0019],0)+ISNULL(PIVOT_TABLE1.[0020],0)+ISNULL(PIVOT_TABLE1.[0221],0)+ISNULL(PIVOT_TABLE1.[0225],0), 'C','PT-BR') AS [BASE_PIS]"		+ STR_PULA
	cQryAux += ", FORMAT(((ISNULL(PIVOT_TABLE1.[0013],0)+ISNULL(PIVOT_TABLE1.[0014],0)+ISNULL(PIVOT_TABLE1.[0019],0)+ISNULL(PIVOT_TABLE1.[0020],0)+ISNULL(PIVOT_TABLE1.[0221],0)+ISNULL(PIVOT_TABLE1.[0225],0)) *0.01), 'C','PT-BR') AS [VALOR_PIS]"		+ STR_PULA
	cQryAux += "FROM"		+ STR_PULA
	cQryAux += "(SELECT "		+ STR_PULA
	cQryAux += "RD_FILIAL AS FILIAL"		+ STR_PULA
	cQryAux += ", CASE WHEN RD.RD_PROCES =  '00001' THEN 'BASE FOLHA' WHEN RD.RD_PROCES =  '00003' THEN 'AUTONOMOS' END AS PROCESSO"		+ STR_PULA
	cQryAux += ", RD_VALOR "		+ STR_PULA
	cQryAux += ", ISNULL(RV_CODFOL,0) AS CODFOL"		+ STR_PULA
	cQryAux += "FROM SRD010 RD"		+ STR_PULA
	cQryAux += "INNER JOIN SRA010 RA ON RA_FILIAL = RD_FILIAL AND RA_MAT = RD_MAT"		+ STR_PULA
	cQryAux += "INNER JOIN SRV010 RV ON RV_COD = RD_PD AND SUBSTRING(RD_FILIAL,1,0)= RV.RV_FILIAL"		+ STR_PULA
	cQryAux += "WHERE  RD_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND RD_PERIODO = '"+MV_PAR03+"'"		+ STR_PULA
	cQryAux += "AND RV_CODFOL <> '' "		+ STR_PULA
	cQryAux += "AND RD.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "AND RA.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "AND RV.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += ")EM_LINHA"		+ STR_PULA
	cQryAux += "  PIVOT("		+ STR_PULA
	cQryAux += "   SUM(RD_VALOR)"		+ STR_PULA
	cQryAux += "    FOR CODFOL IN ("		+ STR_PULA
	cQryAux += "        [0013],"		+ STR_PULA
	cQryAux += "        [0014],"		+ STR_PULA
	cQryAux += "        [0019],"		+ STR_PULA
	cQryAux += "        [0020],"		+ STR_PULA
	cQryAux += "        [0221],"		+ STR_PULA
	cQryAux += "        [0225],"		+ STR_PULA
	cQryAux += "        [0064],"		+ STR_PULA
	cQryAux += "		[0065],"		+ STR_PULA
	cQryAux += "		[0070],"		+ STR_PULA
	cQryAux += "		[0209],"		+ STR_PULA
	cQryAux += "        [0222],"		+ STR_PULA
	cQryAux += "		[0034],"		+ STR_PULA
	cQryAux += "        [1732],"		+ STR_PULA
	cQryAux += "        [1338],"		+ STR_PULA
	cQryAux += "        [0040],"		+ STR_PULA
	cQryAux += "        [0668],"		+ STR_PULA
	cQryAux += "        [0669],"		+ STR_PULA
	cQryAux += "        [0407],"		+ STR_PULA
	cQryAux += "        [0927],"		+ STR_PULA
	cQryAux += "        [0928],"		+ STR_PULA
	cQryAux += "        [1339],"		+ STR_PULA
	cQryAux += "        [1340],"		+ STR_PULA
	cQryAux += "        [1647],"		+ STR_PULA
	cQryAux += "        [1446],"		+ STR_PULA
	cQryAux += "        [1447],"		+ STR_PULA
	cQryAux += "        [1434],"		+ STR_PULA
	cQryAux += "        [1436],"		+ STR_PULA
	cQryAux += "        [1437],"		+ STR_PULA
	cQryAux += "        [1438],"		+ STR_PULA
	cQryAux += "        [1439],"		+ STR_PULA
	cQryAux += "        [1440],"		+ STR_PULA
	cQryAux += "        [1442],"		+ STR_PULA
	cQryAux += "        [1444],"		+ STR_PULA
	cQryAux += "        [1639],"		+ STR_PULA
	cQryAux += "        [1640],"		+ STR_PULA
	cQryAux += "        [1641],"		+ STR_PULA
	cQryAux += "        [1642],"		+ STR_PULA
	cQryAux += "        [1643],"		+ STR_PULA
	cQryAux += "        [1644],"		+ STR_PULA
	cQryAux += "        [1645],"		+ STR_PULA
	cQryAux += "        [1646],"		+ STR_PULA
	cQryAux += "        [1648]"		+ STR_PULA
	cQryAux += "	    	)"		+ STR_PULA
	cQryAux += ") AS PIVOT_TABLE1"		+ STR_PULA
	cQryAux += "ORDER BY 5"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	
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
