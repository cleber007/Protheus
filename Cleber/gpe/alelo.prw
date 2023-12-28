#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH"

#define cPV ";"

/*/{Protheus.doc} alelo
Rotina de Exportacao do arquivo CSV do layout referente a 
operadora ALELO. 
/*/
//ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
	User Function alelo()
//ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

	Local aSays 	:= {}
	Local aButtons	:= {}
	Local nOpca 	:= 0	

	Local cPerg 	:= Padr("alelo",10)

	//Incluo/Altero as perguntas na tabela SX1
    ValidPerg(@cPerg)

//gero a pergunta de modo oculto, ficando disponํvel no botใo a็๕es relacionadas
    Pergunte(cPerg,.F.)
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//	Private cPerg			:= "alelo"
	Private cTitulo 		:= OemToAnsi(OemtoAnsi("Geracao do Arquivo ALELO"))
	Private cEmpresa		:= Substr(CNUMEMP,1,2)	
	
	Private aRegCab		:= {}
	Private aRegFil		:= {}
	Private aRegFun		:= {}
	Private aRegEnc		:= {}
	Private cNumCont	:= "00011849516"
	Private nSeqLin		:= 0
	Private cQtdFunc	:= 0
	Private nValTot		:= 0
	Private NQTREG		:= 0

	//GERA_PAR(cPerg)
	//Pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AADD(aSays,OemToAnsi( " Este programa tem o Objetivo de Realizar a exportacao dos dados referente aos" ) )
	AADD(aSays,OemToAnsi( " valores do beneficio da operadora ALELO. " ) )
	AADD(aSays,OemToAnsi( " Os Dados seram exportados conforme a sele็ใo de parametros pelo usuario." ) )


	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
	AADD(aButtons, { 1,.T.,{|| Iif( GDD_AL(),nOpca:= 1, nOpca:=0 ), FechaBatch() }} )
	AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

	FormBatch( cTitulo, aSays, aButtons )

	IF nOpca == 1

		fErase(Alltrim(MV_PAR09)+"\"+ DtOs(dDataBase) +"_alelo.csv")
		
		Processa( {||GTXT_AL()}, cTitulo, "GERANDO ARQUIVO CSV ..." ,.T.) 
		MsgInfo("Arquivo Gerado com Sucesso no Diretorio : " + MV_PAR09,"Atencao" )
				
		TMP1->(DBCLOSEAREA())
	Endif
	
	
Return

/*/{Protheus.doc} GTXT_AL()
Funcao que gera o arquivo txt . 
/*/
//ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
	STATIC FUNCTION GTXT_AL()
//ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
	
	Local w := 0
	Local x := 0
	Local y := 0
	Local z := 0
	Private cArqTxt	:= ""
	Private nHandle	:= ""
	
	If Right(Alltrim(MV_PAR09),1) == "\"
		cArqTxt := Alltrim(MV_PAR09)+ DtOs(dDataBase) +"_alelo.csv"
	Else
		cArqTxt := Alltrim(MV_PAR09)+"\"+ DtOs(dDataBase) +"_alelo.csv"
	EndIf
	
	nHandle := fCreate(cArqTxt,0)

	TMP1->(DBGOTOP())
	
		REGCAB() // Cabecalho - Dados do arquivo (header) e cliente (empresa)
		aEval(aRegCab,{|| fGrava(aRegCab[++w],400)})
		
		REGFIL() // Filial - Dados da Filial
		aEval(aRegFil,{|| fGrava(aRegFil[++x],400)})
		
		REGUSU() // Usuario - Dados do colaborador
		aEval(aRegFun,{|| fGrava(aRegFun[++y],400)})
		
		REGENC() // Encerramento - Dados de fechamento do arquivo
		aEval(aRegEnc,{|| fGrava(aRegEnc[++z],400)})
		
		//PUTMV("MV_XSEQENV",Soma1(cSeqEnvio))	
		
		fClose(nHandle)
	
RETURN

/*/                       REGISTRO HEADER DO ARQUIVO             /*/
//ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
	Static Function REGCAB() 
//ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
	
	Local cLin	:= ""
	cLin := Replicate("",400)

	// 001 001 N S Tipo de registro. Fixo 0 = HEADER
	cLin := Stuff(cLin,01,01,";")
	cLin := Stuff(cLin,03,08,"CONTRATO" + cPV) 
	cLin := Stuff(cLin,12,01,";")
	cLin := Stuff(cLin,13,01,";")
	cLin := Stuff(cLin,14,01,";")
	cLin := Stuff(cLin,15,01,";")
	cLin := Stuff(cLin,16,01,";")
	cLin := Stuff(cLin,17,01,";")
	cLin := Stuff(cLin,18,01,";")
	
	AADD(aRegCab,cLin)
	
Return

/*/           REGISTRO FILIAL OU POSTO DE PESSOA JURอDICA                /*/
//ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
	Static Function REGFIL() 
//ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
	
	Local cLin	:= ""

	cLin := Replicate(" ",400)
	
	// 001 001 N S Tipo de registro. Fixo 1 = Filial
	cLin := Stuff(cLin,01,01,"%" + cPV)
	cLin := Stuff(cLin,02,01,";")
	cLin := Stuff(cLin,03,08,CValToChar(mv_par08) + cPV)
	cLin := Stuff(cLin,09,01,";")
	cLin := Stuff(cLin,10,01,"%"+ cPV)
	cLin := Stuff(cLin,11,01,";")
	cLin := Stuff(cLin,12,01,";")
	cLin := Stuff(cLin,13,01,";")
	cLin := Stuff(cLin,14,01,";")
	cLin := Stuff(cLin,15,01,";")
	cLin := Stuff(cLin,16,01,";")
	cLin := Stuff(cLin,17,01,";")
	
	AADD(aRegFil,cLin)
	
Return

/*/         REGISTRO DE มREA FUNCIONAL DA FILIAL OU POSTO DE TRABALHO       /*/
//ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
	Static Function REGUSU() 
//ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
	
	Local cLin	:= ""
	
	
		cLin := Replicate(" ",400)
		
		
		// 001 001 N S Tipo de registro. Fixo 5 = Usuแrio
		cLin := Stuff(cLin,01,01,"" + cPV)
		cLin := Stuff(cLin,02,15,"NOME DO USUARIO" + cPV)
		cLin := Stuff(cLin,17,01,";")
		cLin := Stuff(cLin,18,03,"CPF" + cPV)
		cLin := Stuff(cLin,21,01,";")
		cLin := Stuff(cLin,22,18,"DATA DE NASCIMENTO" + cPV)
		cLin := Stuff(cLin,40,01,";")
		cLin := Stuff(cLin,41,11,"CODIGO SEXO" + cPV)
		cLin := Stuff(cLin,52,01,";")
		cLin := Stuff(cLin,53,05,"VALOR" + cPV)
		cLin := Stuff(cLin,58,01,";")
		cLin := Stuff(cLin,59,24,"TIPO DE LOCAL DE ENTREGA" + cPV)
		cLin := Stuff(cLin,83,01,";")
		cLin := Stuff(cLin,84,16,"LOCAL DE ENTREGA" + cPV)
		cLin := Stuff(cLin,100,01,";")
		cLin := Stuff(cLin,101,06,"MATRICULA" + cPV)
		cLin := Stuff(cLin,110,01,";")

		
		AADD(aRegFun,cLin)
	
			
	
	
Return

/*/              Trailler          /*/
//ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
	Static Function REGENC() 
//ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
	
	Local cLin	:= ""
	
	ProcRegua(NQTREG)
	
	Do While ! TMP1->(EOF())

	cLin := Replicate(" ",400)

        cLin := Stuff(cLin,01,01,"%" + cPV)
		cLin := Stuff(cLin,02,01,";")
		cLin := Stuff(cLin,03,40,FwNoAccent(TMP1->NOME) + Space(ABS(Len(TMP1->NOME) - 40)) + cPV)
		cLin := Stuff(cLin,43,01,";")
		cLin := Stuff(cLin,44,11,Alltrim(TMP1->CPF)+ cPV)
		cLin := Stuff(cLin,55,01,";")
		cLin := Stuff(cLin,56,10,SUBSTR(TMP1->DTNASC,7,2) + '/' + SUBSTR(TMP1->DTNASC,5,2) + '/' + SUBSTR(TMP1->DTNASC,1,4) + cPV)
		cLin := Stuff(cLin,66,01,";")
		cLin := Stuff(cLin,67,01,Alltrim(TMP1->SEXO) + cPV)
		cLin := Stuff(cLin,68,01,";")
		cLin := Stuff(cLin,69,11,CValToChar(TMP1->VALVA)+ cPV)
		cLin := Stuff(cLin,79,01,";")
		cLin := Stuff(cLin,80,02,"FI" + cPV)
		cLin := Stuff(cLin,82,01,";")
		cLin := Stuff(cLin,83,03,"190" + cPV)
		cLin := Stuff(cLin,86,01,";")
		cLin := Stuff(cLin,87,06,StrZero(Val(TMP1->MAT),6) + cPV)
		cLin := Stuff(cLin,93,01,";")
		cLin := Stuff(cLin,94,01,"%")

		cQtdFunc	+= 1
		
		AADD(aRegEnc,cLin)

		IF(SELECT("QRY") > 0)
          QRY->(dbCLOSEAREA())
        ENDIF           

        cQry := " UPDATE " + RetSqlName("SR0")
        cQry += " SET	R0_PEDIDO 	= '2' "  	
        cQry += " WHERE R0_FILIAL 	= '" + TMP1->FILIAL    + "' "
        cQry += " AND 	R0_MAT 		= '" + TMP1->MAT 	   + "' "
		cQry += " AND 	R0_CODIGO 	= '" + TMP1->R0_CODIGO + "' "
		cQry += " AND 	( R0_TPVALE = '1' OR R0_TPVALE = '2' )  "
        cQry += " AND	D_E_L_E_T_ <> '*' 	"												

        TcSqlExec(cQry)
/*
		Do While ! QRY->(EOF())
		//If SR0->(DbSeek(TMP1->FILIAL + TMP1->MAT + TMP1->R0_CODIGO)) 

			If QRY->R0_TPVALE $ '1;2'

 				DbSelectArea("SR0")
				SR0->(DbSetOrder(1))
				IF SR0->(DbSeek(TMP1->FILIAL + TMP1->MAT + TMP1->R0_CODIGO))
				RecLock('SR0', .F.)
					SR0->R0_PEDIDO := "2"
				SR0->(MsUnLock())
			
			End

		//EndIf
			QRY->(DBSKIP())
		ENDDO


		DbSelectArea("SR0")	 
*/
		TMP1->(DBSKIP())
	
	End Do
Return

/*/                                  fGrava           /*/
//ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
	Static Function fGrava( cRegistro, nbytes )
//ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

	Local cMsg

	cRegistro := Left(cRegistro+Space(nBytes),nBytes)+CHR(13)+CHR(10)

	Fwrite(nHandle,cRegistro,Len(cRegistro))

	If Ferror() # 0
		cMsg := "Erro de gravacao, codigo DOS:" + STR(Ferror(),2) 
		Help(" ",1, , ,cMsg )
		Return (.F.)
	Endif

Return 

/*/            Funcao que faz a busca no banco de dados        /*/

//ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
	STATIC FUNCTION GDD_AL()
//ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

	Local cQuery 	:= ""
	Local QBLINHA	:= chr(13)+chr(10)



	cQuery := "SELECT "+QBLINHA  
	cQuery += "  R0_FILIAL			FILIAL "+QBLINHA 
	cQuery += ", RA_MAT				MAT "+QBLINHA 
	cQuery += ", RA_NOME			NOME "+QBLINHA 
	cQuery += ", REPLACE (R0_VALCAL,'.',',')			VALVA "+QBLINHA 
	cQuery += ", RA_NASC			DTNASC "+QBLINHA 
	cQuery += ", RA_CIC				CPF "+QBLINHA 
	cQuery += ", RA_SEXO			SEXO "+QBLINHA 
	cQuery += ", RA_ADMISSA			ADMISSAO "+QBLINHA 
	cQuery += ", R0_PERIOD      	DATAPGT "+QBLINHA 
	cQuery += ", RA_MAE				MAE "+QBLINHA 
	cQuery += ", R0_TPVALE			TIPO "+QBLINHA 
	cQuery += ", R0_CODIGO "+QBLINHA 
	cQuery += "FROM "
	cQuery +=  RetSqlName("SRA") + " RA " +QBLINHA 
	cQuery +=  "INNER JOIN SR0010  R0 " +QBLINHA
	cQuery += "ON R0_MAT = RA_MAT "+QBLINHA 
	cQuery += "AND R0_FILIAL = RA_filial "+QBLINHA 
	cQuery += "AND R0.D_E_L_E_T_ = ' ' "+QBLINHA  
	cQuery += "WHERE "+QBLINHA  
	cQuery += "RA.D_E_L_E_T_ = ' ' "+QBLINHA  
	cQuery += "AND RA_SITFOLH IN (' ','A','F') "+QBLINHA 
	cQuery += "AND R0_TPVALE = '"+ MV_PAR06 +"' "+QBLINHA
	cQuery += "AND R0_FILIAL BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' "+QBLINHA 
	cQuery += "AND RA_MAT BETWEEN '"+ MV_PAR03 +"' AND '"+ MV_PAR04 +"' "+QBLINHA 
	cQuery += "AND R0_PERIOD  = '"+ SubStr(Dtos(MV_PAR05),1,6) +"' "+QBLINHA 
	cQuery += " ORDER BY R0_FILIAL,RA_MAT, RA_NOME"+QBLINHA 
	*/
	MEMOWRITE("C:/TEMP/alelo.sql",cQuery)			     
	cQuery := CHANGEQUERY(cQuery)
	DBUSEAREA(.T., 'TOPCONN', TCGENQRY(,,cQuery), "TMP1", .F., .T.)

	DBSELECTAREA("TMP1")
	TMP1->(DBGOTOP())
	COUNT TO NQTREG
	TMP1->(DBGOTOP())

	IF NQTREG <= 0 
		TMP1->(DBCLOSEAREA())
		RETURN .F.
	ENDIF

RETURN .T.


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
    AADD(aRegs,{cPerg  ,"05","Data de Pgto. ?         ","","","mv_ch5","D",08,00,00,"G","","","","","mv_par05","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg  ,'06','Tipo de Beneficio?      ','','','mv_ch6','C',01,0,0,'G','','mv_par06','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	AAdd(aRegs,{cPerg  ,'07','Responsแvel             ?','','','mv_ch7','C',20,0,0,'G','','mv_par07','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''}) 
	AADD(aRegs,{cPerg  ,"08","N๚mero do Contrato ?     ","","","mv_ch8","C",11,00,00,"G","","","","","mv_par08","","","","","","","","","","","","","","","","","","",""})
	AAdd(aRegs,{cPerg  ,'09','Local Gera็ใo Arquivo   ?','','','mv_ch9','C',60,0,0,'G','NaoVazio','mv_par09','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})

	  /*  For i:=1 to Len(aRegs)
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
*/
Return

