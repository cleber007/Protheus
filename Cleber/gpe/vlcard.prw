#Include "Protheus.ch"
#Include "TopConn.ch"
 
User Function VLCARD()
    
    Local aArea:= GetArea()
    
    fCriaXML()
     
    RestArea(aArea)

Return

Static Function fCriaXML()

    Local cTime := Time() 
    Local cHour := SubStr( cTime, 1, 2 ) 
    Local cMin  := SubStr( cTime, 4, 2 ) 
    Local cDir    := ""
    Local cArq    := ""
    Local nHdl  := 0
    Local aArea := GetArea()
    Local cQuery  := ""
    Local nLinha  := 0
    Local cCnpj   := SM0->M0_CGC
    Local aBene   := {}
    Local oFWMsExcel
    Local oExcel

    Private cPerg := PadR("ticket",10)

ValidPerg(cPerg)

If Pergunte(cPerg , .T.)

EndIf

    If nHdl == -1
        
        MsgStop("N√o foi poss√≠vel gerar o arquivo!")
     
    Else

IF MV_PAR01 = 1
    cDir    := alltrim(MV_PAR02)
    cArq    := "VAL" + DTOS(DATE())+"_"+cHour+cMin+ ".csv"
    nHdl := FCreate(cDir+cArq)
        
     		cQuery := " SELECT RA_CIC AS CIC,RA_CC AS CUSTO, RA_NASC AS NASCIMENTO, " + CRLF
            cQuery += " right(concat('00000',replace(convert(money,R0_VLRVALE),'.','')),5) AS UNI, RA_NOME AS NOME, '"+ cCnpj + "' AS CNPJ, " + CRLF
            cQuery += " convert(varchar,replace(CONVERT(MONEY,R0_VALCAL),'.',',')) as VALOR, " + CRLF
    		cQuery += " REPLACE(CONVERT(MONEY,R0_VALCAL),'.',',') AS VAL, " + CRLF
			cQuery += " FROM " + retSqlname("SR0") + " AS SR0 " + CRLF

			cQuery += " LEFT JOIN " + retSqlname("SRA") + " AS SRA " + CRLF
			cQuery += " ON RA_FILIAL = R0_FILIAL AND RA_MAT = R0_MAT AND SRA.D_E_L_E_T_ = '' " + CRLF

            cQuery += " WHERE SR0.D_E_L_E_T_ <> '*' AND RA_SITFOLH <> 'D' AND R0_TPBEN = '05' AND R0_TPVALE = '2' AND R0_QDIACAL > 0 " + CRLF
			cQuery += " AND R0_PERIOD = '"+ MV_PAR03 + "' " + CRLF
			cQuery += " AND RA_FILIAL = '"+ MV_PAR05 + "' " + CRLF
			cQuery += " AND RA_MAT BETWEEN '"+ MV_PAR06 + "' AND '"+ MV_PAR07 + "' " + CRLF
			cQuery += " AND RA_CC BETWEEN '"+ MV_PAR08 + "' AND '"+ MV_PAR09 + "' " + CRLF
            cQuery += " AND RA_DEPTO BETWEEN '"+ MV_PAR10 + "' AND '"+ MV_PAR11 + "' " + CRLF

			DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TPSR0',.F.,.F.)

			TPSR0->(Dbgotop())

                //Criando o objeto que ir· gerar o conte˙do do Excel
            oFWMsExcel := FWMSExcel():New()

            //Aba 02 - Produtos
            oFWMsExcel:AddworkSheet("Vale Alimentacao")
            //Criando a Tabela
            oFWMsExcel:AddTable("Vale Alimentacao","Produtos")
            oFWMsExcel:AddColumn("Vale Alimentacao","Produtos","Matricula",1)
            oFWMsExcel:AddColumn("Vale Alimentacao","Produtos","Referencia",1)
            oFWMsExcel:AddColumn("Vale Alimentacao","Produtos","Nome Completo",1)
            oFWMsExcel:AddColumn("Vale Alimentacao","Produtos","Data de Nascimento",1)
            oFWMsExcel:AddColumn("Vale Alimentacao","Produtos","CPF",1)
            oFWMsExcel:AddColumn("Vale Alimentacao","Produtos","Novo Limite",1)
            //Criando as Linhas... Enquanto n„o for fim da query

			While TPSR0->(!EOF()) 

                oFWMsExcel:AddRow("Vale Alimentacao","Produtos",{;
				            TPSR0->CIC,+;  
							TPSR0->CUSTO,+;
                            TPSR0->NOME,+; 
                            TPSR0->NASCIMENTO,+;
                            TPSR0->CIC,+;
                            TPSR0->VALOR})
            
               IF(SELECT("QRY") > 0)
                QRY->(dbCLOSEAREA())
                ENDIF           

                cQry := " UPDATE " + RetSqlName("SR0")
                cQry += " SET	R0_PEDIDO 	= '2' "  	
                cQry += " WHERE R0_FILIAL 	= '" + TPSR0->FILIAL    + "' "
                cQry += " AND 	R0_MAT 		= '" + TPSR0->MAT 	   + "' "
                cQry += " AND 	R0_CODIGO 	= '" + TPSR0->R0_CODIGO + "' "
                cQry += " AND 	( R0_TPVALE = '1' OR R0_TPVALE = '2' )  "
                cQry += " AND	D_E_L_E_T_ <> '*' 	"												

                TcSqlExec(cQry)


				TPSR0->(DBSKIP())
			ENDDO

            //Ativando o arquivo e gerando o xml
            oFWMsExcel:Activate()
            oFWMsExcel:GetXMLFile(cArq)
                 
            //Abrindo o excel e abrindo o arquivo xml
            oExcel := MsExcel():New()             //Abre uma nova conex„o com Excel
            oExcel:WorkBooks:Open(cArq)     //Abre uma planilha
            oExcel:SetVisible(.T.)                 //Visualiza a planilha
            oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

            TPSR0->(dbCloseArea())
            
      

        
 elseif MV_PAR01 = 2
 
    cDir    := alltrim(MV_PAR02)
    cArq    := "MUL" + DTOS(DATE())+"_"+cHour+cMin+ ".csv"
    nHdl := FCreate(cDir+cArq)
        
     		cQuery := " SELECT RA_CIC AS CIC,RA_CC AS CUSTO, RA_NASC AS NASCIMENTO,RA_SEXO AS SEXO, " + CRLF
            cQuery += " RA_NOME AS NOME, '"+ cCnpj + "' AS CNPJ, " + CRLF      
/*             cQuery += " CASE WHEN RA_XMATSEN = '' THEN RIGHT(CONCAT('00000000000000000',RA_FILIAL, RA_MAT),9) ELSE RIGHT(CONCAT('0000000000000000',RA_XMATSEN),9) END AS MATRICULA " + CRLF */
           	cQuery += " FROM " + retSqlname("SRA") + " AS SRA " + CRLF

			cQuery += " WHERE SRA.D_E_L_E_T_ <> '*' AND RA_SITFOLH <> 'D'" + CRLF
			cQuery += " AND RA_FILIAL = '"+ MV_PAR05 + "' " + CRLF
			cQuery += " AND RA_MAT BETWEEN '"+ MV_PAR06 + "' AND '"+ MV_PAR07 + "' " + CRLF
			cQuery += " AND RA_CC BETWEEN '"+ MV_PAR08 + "' AND '"+ MV_PAR09 + "' " + CRLF
            cQuery += " AND RA_DEPTO BETWEEN '"+ MV_PAR10 + "' AND '"+ MV_PAR11 + "' " + CRLF

			DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TPSRA',.F.,.F.)

			TPSRA->(Dbgotop())

			While TPSRA->(!EOF()) 

				aAdd(aBene,{TPSR0->CIC,+;  
							TPSR0->CUSTO,+;
                            TPSR0->NOME,+; 
                            TPSR0->NASCIMENTO,+;
                            TPSR0->CIC,+;
                            TPSR0->VALOR})
				TPSRA->(DBSKIP())
			ENDDO

            TPSRA->(dbCloseArea())
      
/*         FWrite(nHdl, "" +";"+ "CONTRATO" +";"+ "" + CRLF)
        FWrite(nHdl," %"+";"+	"907908"+";"+"%" + CRLF) */

        /* FWrite(nHdl, ""	+";"+ "NOME DO USUARIO" +";"+"CPF"+";"+"DATA DE NASCIMENTO"+";"+"CODIGO DE SEXO"+";"+	"VALOR"+";"+"TIPO DE LOCAL ENTREGA"+";"+"LOCAL DE ENTREGA"+";"+"MATRICULA"+ CRLF) */
		   FWrite(nHdl, + "Matricula" +";"+"Referencia"+";"+"Nome Completo"+";"+"Data de Nascimento"+";"+	"CPF"+";"+"Novo Limite"+ CRLF)
        For nLinha := 1 to len(aBene)
          
            
            FWrite(nHdl,alltrim(aBene[nLinha][1])   +";") 
            FWrite(nHdl,        aBene[nLinha][2]    +";")
			FWrite(nHdl,        aBene[nLinha][3]    +";")
            FWrite(nHdl,        subs(aBene[nLinha][4],7,2)+"/"+subs(aBene[nLinha][4],5,2)+"/"+subs(aBene[nLinha][4],1,4)    +";")
			FWrite(nHdl,        aBene[nLinha][5]    +";")
            FWrite(nHdl,        aBene[nLinha][6]    +";"+ CRLF) 
                 
        Next nLinha
            
            
   
            fClose(nHdl)
         
        ShellExecute("OPEN", cArq, "", cDir, 0 )
        
       

    elseIF MV_PAR01 = 3
    cDir    := alltrim(MV_PAR02)
    cArq    := "CB" + DTOS(DATE())+"_"+cHour+cMin+ ".csv"
    nHdl := FCreate(cDir+cArq)
        
     		cQuery := " SELECT RA_CIC AS CIC,RA_CC AS CUSTO, RA_NASC AS NASCIMENTO,RA_SEXO AS SEXO, " + CRLF
            cQuery += " RA_NOME AS NOME, '"+ cCnpj + "' AS CNPJ, " + CRLF
            cQuery += " convert(varchar,replace(CONVERT(MONEY,RIQ_VALCAL),'.',',')) as VALOR, " + CRLF
           
            cQuery += " CASE WHEN RA_XMATSEN = '' THEN RIGHT(CONCAT('00000000000000000',RA_FILIAL, RA_MAT),9) ELSE RIGHT(CONCAT('0000000000000000',RA_XMATSEN),9) END AS MATRICULA, " + CRLF
			cQuery += " REPLACE(CONVERT(MONEY,RIQ_VALCAL),'.',',') AS VAL " + CRLF
            

			cQuery += " FROM " + retSqlname("RIQ") + " AS RIQ " + CRLF

			cQuery += " LEFT JOIN " + retSqlname("SRA") + " AS SRA " + CRLF
			cQuery += " ON RA_FILIAL = RIQ_FILIAL AND RA_MAT = RIQ_MAT AND SRA.D_E_L_E_T_ = '' " + CRLF

			cQuery += " WHERE RIQ.D_E_L_E_T_ <> '*' AND RA_SITFOLH <> 'D' AND RIQ_TPBENE = '01' AND RIQ_VALCAL > 0 " + CRLF
			cQuery += " AND RIQ_PERIOD = '"+ MV_PAR03 + "' " + CRLF
			cQuery += " AND RA_FILIAL = '"+ MV_PAR05 + "' " + CRLF
			cQuery += " AND RA_MAT BETWEEN '"+ MV_PAR06 + "' AND '"+ MV_PAR07 + "' " + CRLF
			cQuery += " AND RA_CC BETWEEN '"+ MV_PAR08 + "' AND '"+ MV_PAR09 + "' " + CRLF
			cQuery += " AND RA_DEPTO BETWEEN '"+ MV_PAR10 + "' AND '"+ MV_PAR11 + "' " + CRLF
			
            DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TPSR0',.F.,.F.)

			TPSR0->(Dbgotop())

			While TPSR0->(!EOF()) 

				aAdd(aBene,{TPSR0->CIC,+;  
							TPSR0->CUSTO,+;
                            TPSR0->NOME,+; 
                            TPSR0->NASCIMENTO,+;
                            TPSR0->CIC,+;
                            TPSR0->VALOR})
				TPSR0->(DBSKIP())
			ENDDO

            TPSR0->(dbCloseArea())
      
/*         FWrite(nHdl, "" +";"+ "CONTRATO" +";"+ "" + CRLF)
        FWrite(nHdl," %"+";"+	"907908"+";"+"%" + CRLF) */

        FWrite(nHdl, + "Matricula" +";"+"Referencia"+";"+"Nome Completo"+";"+"Data de Nascimento"+";"+	"CPF"+";"+"Novo Limite"+ CRLF)

        For nLinha := 1 to len(aBene)
          
            
            FWrite(nHdl,alltrim(aBene[nLinha][1])   +";") 
            FWrite(nHdl,        aBene[nLinha][2]    +";")
			FWrite(nHdl,        aBene[nLinha][3]    +";")
            FWrite(nHdl,        subs(aBene[nLinha][4],7,2)+"/"+subs(aBene[nLinha][4],5,2)+"/"+subs(aBene[nLinha][4],1,4)    +";")
			FWrite(nHdl,        aBene[nLinha][5]    +";")
            FWrite(nHdl,        aBene[nLinha][6]    +";"+ CRLF) 
                 
        Next nLinha
            
            
   
            fClose(nHdl)
         
        ShellExecute("OPEN", cArq, "", cDir, 0 ) 

    EndIf   


    RestArea(aArea)
Return

ENDIF  

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
