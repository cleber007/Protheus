#include "PROTHEUS.CH"
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 08/06/00
#include "topconn.CH"

User Function GFOLEXCEL()
	Local cQuery 		:= ""
	Private	_aFunc 		:= {}
	Private _aCab  		:= {}
	Private _aDados 	:= {}
	Private _cPeri		:= ''
	Private _cPeriodo 	:= ''
	Private _cPer 		:= ''

	cQuery := " SELECT RCH_PER FROM " + RetSqlName("RCH")
	cQuery += " WHERE RCH_ROTEIR = 'FOL' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	cQuery += " AND RCH_STATUS = '0' "
	cQuery += " AND RCH_PERSEL = '1' "
	TCQUERY cQuery NEW ALIAS "QRCH"
	dbSelectArea("QRCH")
	dbGotop()
	If !eof()
		_cPeri := substr(QRCH->RCH_PER,5,2)+"/"+substr(QRCH->RCH_PER,1,4)
		_cPeriodo := QRCH->RCH_PER
	Endif
	QRCH->(DbCloseArea())

	If MsgYesNo("Rotina irá exportar o Movimento Mensal para Planilha Excel - "+_cPeri+" ?")
		Processa({|| GeraDados() },"Gerando informações!!!")
		Processa({|| GeraExc()   },"Criando a Planilha Excel!!!")
	Endif
Return

Static Function GeraDados()
	_cQuery := " Select * from "+RetSqlName("SRC")
	_cQuery += " Where D_E_L_E_T_ !='*'"
	if !empty(_cPeriodo)
		_cQuery += " and RC_PERIODO!=''"
	Endif  
	_cQuery += " Order By RC_FILIAL, RC_MAT, RC_PD"
	If Select("TQry")>0
		DbSelectArea("TQry")
		DbCloseArea("TQry")
	EndIf

	_aVB := GeraVerba()

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TQry",.T.,.F.)
	DbSelectArea("TQry")
	ProcRegua(RecCount()) // Numero de registros a processar
	dbGoTop()

	_cPeriodo := TQry->RC_PERIODO
	_cPer := substr(TQry->RC_PERIODO,5,2)+"/"+substr(TQry->RC_PERIODO,1,4)

	aadd(_aCab,{"Matrícula",2,1,.F.})
	aadd(_aCab,{"Nome",1,1,.F.})
	aadd(_aCab,{"Admissão",2,4,.F.})
	aadd(_aCab,{"Situação",2,1,.F.})
	aadd(_aCab,{"Salário",3,2,.F.})
	aadd(_aCab,{"Custo",2,1,.F.})
	aadd(_aCab,{"Descrição",1,1,.F.})
	aadd(_aCab,{"Função",2,1,.F.})
	aadd(_aCab,{"Descrição",1,1,.F.})
	aadd(_aCab,{"Cargo",2,1,.F.})
	aadd(_aCab,{"Descrição",1,1,.F.})
	aadd(_aCab,{"Período",2,1,.F.})
	aadd(_aCab,{"Processo",2,1,.F.})

	for i:=1 to Len(_aVB)
		aadd(_aCab,{"Referência",3,2,.F.})
		aadd(_aCab,{_aVB[i,2]+" - "+alltrim(_aVB[i,4]),3,2,.F.})
	Next i

	// Levantando os dados
	While !eof()
		_cMat 		:= TQry->RC_MAT
		_aDadFun	:= GetAdvFVal("SRA",{"RA_NOME","RA_ADMISSA","RA_SITFOLH","RA_CC","RA_CODFUNC","RA_SALARIO","RA_CARGO"},xFilial("SRA")+_cMat,1)
		_cDescCC	:= GetAdvFVal("CTT","CTT_DESC01",xFilial("CTT")+_aDadFun[4],1)
		_cDescFunc	:= GetAdvFVal("SRJ","RJ_DESC",xFilial("SRJ")+_aDadFun[5],1)
		_cDescCarg	:= GetAdvFVal("SQ3","Q3_DESCSUM",xFilial("SQ3")+_aDadFun[7],1)

		IncProc("Matrícula: "+TQry->RC_MAT+"-"+_aDadFun[1])

		_aVBFunc 	:= aclone(_aVB)

		aadd(_aFunc,{TQry->RC_MAT,;
		_aDadFun[1],;
		_aDadFun[2],;
		_aDadFun[3],;
		_aDadFun[6],;
		_aDadFun[4],;
		_cDescCC,;
		_aDadFun[5],;
		_cDescFunc,;
		_aDadFun[7],;
		_cDescFunc,;
		_cPer,;
		TQry->RC_PROCES,;
		_aVBFunc})

		//		aadd(_aFunc,{RC_MAT,; 	/* 01 - Matricula */
		//		_aDadFun[1],; 			/* 02 - Nome */
		//		_aDadFun[2],;			/* 03 - Admissão */
		//		_aDadFun[3],;			/* 04 - Situação */
		//		_aDadFun[6],;			/* 05 - Salário */
		//		_aDadFun[4],;			/* 06 - Custo */
		//		_cDescCC,;				/* 07 - Descrição Custo */
		//		_aDadFun[5],;			/* 08 - Função */
		//		_cDescFunc,;			/* 09 - Descrição Função */
		//		_aDadFun[7],;			/* 10 - Cargo */
		//		_cDescFunc,;			/* 11 - Descrição Cargo */
		//		_cPer,;					/* 12 - Período */
		//		RC_PROCES,;				/* 13 - Processo */
		//		_aVBFunc})				/* 14 - Verbas */

		While !eof() .and. TQry->RC_MAT==_cMat
			nPos 	:= Ascan(_aVBFunc, { |x| x[2] == RC_PD} )
			_aVBFunc[nPos,3] 	:= _aVBFunc[nPos,3] + TQry->RC_VALOR
			_aVBFunc[nPos,5] 	:= _aVBFunc[nPos,5] + TQry->RC_HORAS
			Skip
			Loop  
		End  
		_aFunc[len(_aFunc),14] 	:= _aVBFunc
	End
Return

Static Function GeraExc()
	// Inicio do processo de excell
	// Montagem da Matriz a ser gerada
	ProcRegua(Len(_aFunc)) // Numero de registros a processar
	for i:=1 to Len(_aFunc)
		IncProc()
		_aReg 	:= {}

		_aItem	:= _aFunc[i,14]

		aadd(_aReg,_aFunc[i,01])
		aadd(_aReg,_aFunc[i,02])
		aadd(_aReg,_aFunc[i,03])
		aadd(_aReg,_aFunc[i,04])
		aadd(_aReg,_aFunc[i,05])
		aadd(_aReg,_aFunc[i,06])
		aadd(_aReg,_aFunc[i,07])
		aadd(_aReg,_aFunc[i,08])
		aadd(_aReg,_aFunc[i,09])
		aadd(_aReg,_aFunc[i,10])
		aadd(_aReg,_aFunc[i,11])
		aadd(_aReg,_aFunc[i,12])
		aadd(_aReg,_aFunc[i,13])

		for x:=1 to len(_aItem)
			aadd(_aReg,_aItem[x,5])
			aadd(_aReg,_aItem[x,3])
		Next x 
		aadd(_aDados,_aReg)
	Next i
	_cTitulo:='Movimento Folha '+_cPeriodo
	gExcell(_cTitulo,_cTitulo,_aCab,_aDados)
Return


Static Function GeraVerba()
	Local _aRet 	:= {}
	Local _aGetArea	:= GetArea()
	Local _cQuery	:= ''
	_cQuery := " Select RC_PD from "+RetSqlName("SRC")
	_cQuery += " Where D_E_L_E_T_ !='*'" 
	_cQuery += " Group By RC_PD"
	_cQuery += " Order By RC_PD"
	If Select("TQry1") > 0
		DbSelectArea("TQry1")
		DbCloseArea("TQry1")
	EndIf
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TQry1",.T.,.F.)
	DbSelectArea("TQry1")
	dbGoTop()
	_nSeq	:= 0
	While !eof()
		_cDescVerba	:= GetAdvFVal("SRV","RV_DESC",xFilial("SRV")+TQry1->RC_PD,1)
		aadd(_aRet,{++_nSeq, TQry1->RC_PD,0,_cDescVerba,0})   
		Skip
		Loop
	Enddo
	RestArea(_aGetArea)
	Return(_aRet)

	// Função para gerar a planilha em excel - ALUBAR
	********************************************************************************************************************************
Static Function gExcell(_cVar1,_cVar2,_aCab,_aDados)
	********************************************************************************************************************************
	oExcel 	:= FWMSEXCEL():New()
	_cFile	:=GetTempPath()+alltrim(_cVar2)+"_"+(Dtos(dDataBase)+SubStr(Time(),1,2)+SubStr(Time(),4,2)+SubStr(Time(),7,2))+".xls"
	//Definição de Fonte e Tamanho
	oExcel:SetFontSize(8)			//Fonte da Tabela
	oExcel:SetTitleSizeFont(10) 	//Tamanho da Fonte de Titulo de Cabecalho
	oExcel:SetFont('Calibri')		//Fonte da planilha

	//Geração de Abas
	oExcel:AddworkSheet(alltrim(_cVar1))  				//Nome da Aba
	oExcel:AddTable(alltrim(_cVar1),alltrim(_cVar2))			// Titulo da tabela contendo o nome completo do usuário

	//Criação dos titulos das Colunas
	for i:=1 to Len(_aCab)
		oExcel:AddColumn(alltrim(_cVar1),alltrim(_cVar2),_aCab[i,1],_aCab[i,2],_aCab[i,3],_aCab[i,4])
	Next i
	//Gerando as Linhas
	for i:=1 to Len(_aDados)
		_aColLin:={}
		if len(_aCab) > 1
			for x:=1 to len(_aCab)
				aadd(_aColLin,_aDados[i,x])
			Next x
			_cConta:=_aDados[i,1]
		Else
			aadd(_aColLin,_aDados[i])
		Endif
		oExcel:AddRow(alltrim(_cVar1),alltrim(_cVar2),_aColLin)
	Next i

	oExcel:Activate()
	oExcel:GetXMLFile(_cFile)
	ShellExecute("Open",_cFile,"",GetTempPath(),1)
Return(.T.)

