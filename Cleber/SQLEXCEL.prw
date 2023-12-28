#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"                                                      

//Protheus-Construindo um relatório ADVPL em 5 minutos
User Function Alelo1()
Local cAlias := GetNextAlias() //Declarei meu ALIAS
Local cPerg 	:= Padr("alelo1",10)

//Incluo/Altero as perguntas na tabela SX1
    ValidPerg(@cPerg)

//gero a pergunta de modo oculto, ficando disponível no botão ações relacionadas
    Pergunte(cPerg,.F.)

Private aCabec := {} //ARRAY DO CABEÇALHO
Private aDados := {} //ARRAY QUE ARMAZENARÁ OS DADOS

//COMEÇO A MINHA CONSULTA SQL
BeginSql Alias cAlias
		
		SELECT 
           CASE WHEN  RA_NOME IS NOT NULL THEN '%' ELSE '' END AS 'BRANCO1'
          , RA_NOME NOME
          , RA_CIC CPF
          , SUBSTRING(RA_NASC, 7, 2) + '/' + SUBSTRING(RA_NASC, 5, 2) + '/' + SUBSTRING(RA_NASC, 1, 4) AS NASCIMENTO
          , RA_SEXO SEXO
          , SUM(R0_VALCAL) VALOR
          , CASE WHEN  RA_NOME IS NOT NULL THEN 'FI' ELSE '' END AS 'TIPO' 
          , CASE WHEN  RA_NOME IS NOT NULL THEN '140' ELSE '' END AS 'LOCAL'
          , RA_MAT MAT
          , CASE WHEN  RA_NOME IS NOT NULL THEN '%' ELSE '' END AS 'BRANCO2'
        FROM
          %table:SRA%  RA
          INNER JOIN  %table:SR0% R0 ON RA_FILIAL = R0_FILIAL AND RA_MAT = R0_MAT  
          AND R0.D_E_L_E_T_ = ' '
       WHERE
          RA.D_E_L_E_T_ = ' '
          AND RA_SITFOLH IN (' ', 'A', 'F')
          AND R0_TPVALE = '"+ MV_PAR06 +"' 
          AND R0_FILIAL BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' 
          AND RA_MAT BETWEEN '"+ MV_PAR03 +"' AND '"+ MV_PAR04 +"' 
          AND R0_PERIOD = '" +MV_PAR05+ "'
          GROUP BY  RA_NOME,  RA_CIC, RA_NASC,   RA_SEXO,   R0_VALCAL,  RA_MAT
          ORDER BY   RA_NOME

EndSql //FINALIZO A MINHA QUERY
	
//CABEÇALHO
aCabec := {"","Nome do Usuario","CPF","Data de Nascimento","Codigo Sexo", "Valor", "Tipo de Local de Entrega", "Local de Entrega","Matricula", ""}

While !(cAlias)->(Eof())

	aAdd(aDados,{BRANCO1, NOME, CPF, NASCIMENTO, SEXO, VALOR, TIPO, LOCAL, MAT, BRANCO2})
	
	(cAlias)->(dbSkip()) //PASSAR PARA O PRÓXIMO REGISTRO                                     
enddo

//JOGO TODO CONTEÚDO DO ARRAY PARA O EXCEL
DlgtoExcel({{"ARRAY","CONTRATO", aCabec, aDados}})
	                                          
(cAlias)->(dbClosearea())	

return .T.

Static Function ValidPerg(cPerg)

    _sAlias := Alias()
    DbSelectArea("SX1")
    DbSetOrder(1)
    cPerg := PADR(cPerg,10)
    aRegs:={}

	
	AADD(aRegs,{cPerg  ,"01","Da Filial?            ","","","mv_ch1","C",TamSx3("RA_FILIAL")[1],0,0	,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
	AADD(aRegs,{cPerg  ,"02","Ate Filial?           ","","","mv_ch2","C",TamSx3("RA_FILIAL")[1],0,0	,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
	AADD(aRegs,{cPerg  ,"03","Da Matricula?         ","","","mv_ch3","C",TamSx3("RA_MAT")[1],0,0	,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	AADD(aRegs,{cPerg  ,"04","Ate Matricula?        ","","","mv_ch4","C",TamSx3("RA_MAT")[1],0,0	,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
    AADD(aRegs,{cPerg  ,"05","Data de Pgto. ?         ","","","mv_ch5","c",08,00,00,"G","","","","","mv_par05","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg  ,'06','Tipo de Beneficio?      ','','','mv_ch6','C',61,0,0,'G','','mv_par06','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	
	    For i:=1 to Len(aRegs)
        If !dbSeek(cPerg+aRegs[i,2])
            RecLock("SX1",.T.)
            For j:=1 to FCount()
                If j <= Len(aRegs[i])
                    FieldPut(j,aRegs[i,j])
                Endif
            Next
            MsUnlock()
        Endif
    Next
    DbSelectArea(_sAlias)

Return



