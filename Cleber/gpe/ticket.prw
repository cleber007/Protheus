//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
 
//Constantes
#Define STR_PULA    Chr(13)+Chr(10)
 
/*/{Protheus.doc} zTstExc1
FunÁ„o que cria um exemplo de FWMsExcel
@author Atilio
@since 06/08/2016
@version 1.0
    @example
    u_zTstExc1()
/*/
 
User Function ticket()
    Local aArea        := GetArea()
    Local cQuery        := ""
    Local oFWMsExcel
    Local oExcel
    Local cArquivo    := GetTempPath()+'ticket.xml'

	Private cPerg := PadR("ticket",10)

ValidPerg(cPerg)

If Pergunte(cPerg , .T.)

 
    //Pegando os dados
    cQuery := " SELECT "                                                    + STR_PULA
    cQuery += "     SB1.B1_COD, "                                            + STR_PULA
    cQuery += "     SB1.B1_DESC, "                                        + STR_PULA
    cQuery += "     SB1.B1_TIPO, "                                        + STR_PULA
    cQuery += "     SBM.BM_GRUPO, "                                        + STR_PULA
    cQuery += "     SBM.BM_DESC, "                                        + STR_PULA
    cQuery += "     SBM.BM_PROORI "                                        + STR_PULA
    cQuery += " FROM "                                                    + STR_PULA
    cQuery += "     "+RetSQLName('SB1')+" SB1 "                            + STR_PULA
    cQuery += "     INNER JOIN "+RetSQLName('SBM')+" SBM ON ( "        + STR_PULA
    cQuery += "         SBM.BM_FILIAL = '"+FWxFilial('SBM')+"' "        + STR_PULA
    cQuery += "         AND SBM.BM_GRUPO = B1_GRUPO "                    + STR_PULA
    cQuery += "         AND SBM.D_E_L_E_T_='' "                            + STR_PULA
    cQuery += "     ) "                                                        + STR_PULA
    cQuery += " WHERE "                                                    + STR_PULA
    cQuery += "     SB1.B1_FILIAL = '"+FWxFilial('SBM')+"' "            + STR_PULA
    cQuery += "     AND SB1.D_E_L_E_T_ = '' "                            + STR_PULA
    cQuery += " ORDER BY "                                                + STR_PULA
    cQuery += "     SB1.B1_COD "                                            + STR_PULA
    TCQuery cQuery New Alias "QRYPRO"
     
    //Criando o objeto que ir· gerar o conte˙do do Excel
    oFWMsExcel := FWMSExcel():New()
     
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet("Empresa") //N„o utilizar n˙mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Aba 1 Teste","Titulo Tabela")
        //Criando Colunas
        oFWMsExcel:AddColumn("Aba 1 Teste","Titulo Tabela","Col1",1,1) //1 = Modo Texto
        oFWMsExcel:AddColumn("Aba 1 Teste","Titulo Tabela","Col2",2,2) //2 = Valor sem R$
        oFWMsExcel:AddColumn("Aba 1 Teste","Titulo Tabela","Col3",3,3) //3 = Valor com R$
        oFWMsExcel:AddColumn("Aba 1 Teste","Titulo Tabela","Col4",1,1)
        //Criando as Linhas
        oFWMsExcel:AddRow("Aba 1 Teste","Titulo Tabela",{11,12,13,sToD('20140317')})
        oFWMsExcel:AddRow("Aba 1 Teste","Titulo Tabela",{21,22,23,sToD('20140217')})
        oFWMsExcel:AddRow("Aba 1 Teste","Titulo Tabela",{31,32,33,sToD('20140117')})
        oFWMsExcel:AddRow("Aba 1 Teste","Titulo Tabela",{41,42,43,sToD('20131217')})
     
     
    //Aba 02 - Produtos
    oFWMsExcel:AddworkSheet("Aba 2 Produtos")
        //Criando a Tabela
        oFWMsExcel:AddTable("Aba 2 Produtos","Produtos")
        oFWMsExcel:AddColumn("Aba 2 Produtos","Produtos","Codigo",1)
        oFWMsExcel:AddColumn("Aba 2 Produtos","Produtos","Descricao",1)
        oFWMsExcel:AddColumn("Aba 2 Produtos","Produtos","Tipo",1)
        oFWMsExcel:AddColumn("Aba 2 Produtos","Produtos","Grupo",1)
        oFWMsExcel:AddColumn("Aba 2 Produtos","Produtos","Desc.Grupo",1)
        oFWMsExcel:AddColumn("Aba 2 Produtos","Produtos","Procedencia",1)
        //Criando as Linhas... Enquanto n„o for fim da query
        While !(QRYPRO->(EoF()))
            oFWMsExcel:AddRow("Aba 2 Produtos","Produtos",{;
                                                                    QRYPRO->B1_COD,;
                                                                    QRYPRO->B1_DESC,;
                                                                    QRYPRO->B1_TIPO,;
                                                                    QRYPRO->BM_GRUPO,;
                                                                    QRYPRO->BM_DESC,;
                                                                    Iif(QRYPRO->BM_PROORI == '0', 'N„o Original', 'Original');
            })
         
            //Pulando Registro
            QRYPRO->(DbSkip())
        EndDo
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex„o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas
     
    QRYPRO->(DbCloseArea())
    RestArea(aArea)
Return


Static Function ValidPerg(cPerg)

Local aAlias := GetArea()
Local aRegs := {}
Local i,j

cPerg := PadR(cPerg, Len(SX1->X1_GRUPO), " ")

aAdd(aRegs,{cPerg, "01", "Layout                ","","","mv_ch9","C",1,0,0,	    "C","","MV_PAR01","1=Alimentacao","1=Alimentacao","1=Alimentacao","","","2=Multibenefic","2=Multibenefic","2=Multibenefic","","","3=Cesta","3=Cesta","3=Cesta","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg, "02", "Saida :		 	   ","","","mv_ch2","C",40,0,0,	"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","HSSDIR","","",".RHPER.","",""})
aAdd(aRegs,{cPerg, "03", "Periodo :		 	   ","","","mv_ch2","C",6,0,0,	"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","RCH","","",".RHPER.","",""})
aAdd(aRegs,{cPerg, "04", "Numero de Pagamento: ","","","mv_ch3","C",2,0,0,	"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","",".RHNPA.","",""})
aAdd(aRegs,{cPerg, "05", "Filial:   	 	   ","","","mv_ch4","C",4,0,0,	"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","XM0","","",".RHFILDE.","",""})
aAdd(aRegs,{cPerg, "06", "Matricula de:	 	   ","","","mv_ch6","C",9,0,0,	"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","",".RHMATRIC.","",""})
aAdd(aRegs,{cPerg, "07", "Matricula at√©:	   ","","","mv_ch7","C",9,0,0,	"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","",".RHMATRIC.","",""})
aAdd(aRegs,{cPerg, "08", "Centro de Custo de:  ","","","mv_ch8","C",20,0,0,	"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","",".RHCCUSTO.","",""})
aAdd(aRegs,{cPerg, "09", "Centro de Custo at√©: ","","","mv_ch9","C",20,0,0,	"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","",".RHCCUSTO.","",""})
aAdd(aRegs,{cPerg, "10", "Departamento de:      ","","","mv_cha","C",20,0,0,	"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","SQB","","","","",""})
aAdd(aRegs,{cPerg, "11", "Departamento ate:     ","","","mv_chb","C",20,0,0,	"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","SQB","","","","",""})
DbSelectArea("SX1")                  
DbSetOrder(1)
For i := 1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next
RestArea( aAlias )

Return
