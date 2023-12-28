#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FPG014R º Autor ³ Iaci Gomes           º Data ³ 12/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ RELACAO DE ALTERAÇÃO SALARIAL                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GESTAO DE PESSOAL                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FPG014R()
	cDesc1   := "Este programa tem como objetivo imprimir relatorio "
	cDesc2   := "de acordo com os parametros informados pelo usuario."
	cDesc3   := "RELACAO DE ALTERAÇÃO SALARIAL"

	cTitulo  := "RELAÇÃO DE ALTERAÇÃO SALARIAL"

	M_Pag    := 1
	cTamanho := "G"           // P/M/G
	nCaracter:= 15            // 15/18
	Limite   := 80           // 80/132/220
	aOrdem   := {}            // Ordem do Relatorio
	nLastKey := 0
	aReturn  := { "Zebrado", 1,"Administracao",2, 2, 1, "", 1}
	cNomProg := "FPG014R"
	cNomeRel := "FPG014R"
	nLin     := 80
	cPerg    := "FPG014"
	cAlias   := "SRA"
	cUsers   := GetMv("MV_RESPRH")+"/jose.macedo/"
	nSizeSRE  := If(TAMSX3("RE_FILIALD")[1] > 0, TAMSX3("RE_FILIALD")[1], Len(SRE->RE_FILIALD))

	_lSALARIO:=.T.
	If !("/"+Trim(cUserName)+"/" $ cUsers)
		_lSALARIO:=.F.
	EndIf

	cTitulo :=Trim(cTitulo)+" - Usuario : "+Trim(cUserName)

	if !Pergunte(cPerg,.t.)
		Return(Nil)
	Endif

	cNomeRel := SetPrint(cAlias,cNomeRel,cperg,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,cTamanho,,.F.)

	If nLastKey == 27
		Return(nil)
	Endif

	SetDefault(aReturn,cAlias)

	If nLastKey == 27
		Return
	Endif

	Processa({|| RptProc() } )  //Gera e imprime o relatorio

Return(nil)
//***********************************************************
//   Funcao.:   RptProc
//   Objetivo.: Enviar o Relatorio para Tela ou Impressora
//***********************************************************
Static Function RptProc()

	Local nCt := 0, cMat:="", cCC:=""
	Local lAteUrg := .F., nFUConv := 0, cValAnt := 0, cFUNANT:=""
	Private cAux, cString

	//Set Printer to &cNomeRel
	//Set Printer On
	//Set Device  to Printer

	///////////////////////////////////////////////////////

	aVetorFunc := {} // Vetor das Alterações Salariais
	//  1o Elemento - Matricula do Funcinario
	//  2o Elemento - Data da Alteração Salarial
	//  3o Elemento - Nome do Funcionario
	//  4o Elemento - Valor Anterior.
	//  5o Elemento - Valor Alterado.
	//  6o Elemento - Cod. da Função
	//  7o Elemento - Cod. do Motivo
	//  8o Elemento - Cod. Centro de Custo



	cFile := CriaTrab(nil,.f.)
	aStru := {}
	AADD(aStru,{"TB_MAT","C",6,0})
	AADD(aStru,{"TB_CCU","C",9,0})
	AADD(aStru,{"TB_DAT","D",8,0})
	AADD(aStru,{"TB_NOM","C",40,0})
	AADD(aStru,{"TB_FUNCAO","C",05,0})    // COD DA FUNCAO
	AADD(aStru,{"TB_CAR","C",30,0})
	AADD(aStru,{"TB_MOT","C",30,0})
	AADD(aStru,{"TB_ANT","N",14,2})
	AADD(aStru,{"TB_ATU","N",14,2})
	AADD(aStru,{"TB_FUNANT","C",30,0})   // FUNCAO ANTERIOR

	DbCreate(cFile,aStru)
	Use &cFile Alias TRB New
	Index On TB_MAT to &cFile


	DbSelectArea("CTT") //Centros de Custos
	DbSetOrder(1)

	DbSelectArea("SRA") //Cadatro de Funcionarios
	DbSetOrder(1)

	Dbseek(xFilial("SRA")+Mv_Par01,.T.)
	DbGoTop()

	ProcRegua(RecCount())

	While !Eof() .AND. SRA->RA_MAT <= Mv_Par02

		IncProc("Processando Matricula No.: " + SRA->RA_MAT)

		IF SRA->RA_SITFOLH="D" .AND. MV_PAR01#MV_PAR02
			DBSKIP()
			Loop
		ENDIF

		IF Empty(RA_CC)
			DbSkip()
			Loop
		EndIf
		If RA_CC < MV_PAR06 .Or. RA_CC > MV_PAR07
			DbSkip()
			Loop
		EndIf
		If RA_MAT < MV_PAR01 .Or. RA_MAT > MV_PAR02
			DbSkip()
			Loop
		EndIf

		DbSelectArea("SR3") //Historicos Valores
		DbSetOrder(1)
		DbSeek(xFilial("SR3") + SRA->RA_MAT) //+DTOS(MV_PAR04))

		cValAnt := 0 //SR3->R3_VALOR
		CFUNANT := ""
		While !Eof() .and. xFilial("SR3") == SRA->RA_FILIAL .AND. SRA->RA_MAT == SR3->R3_MAT
			IF !(R3_PD$"000/001") // SOMENTE CONSIDERAR SALARIO BASE
				DbSkip()
				Loop
			Endif
			If !(SR3->R3_TIPO >= MV_PAR08 .AND. SR3->R3_TIPO <= MV_PAR09)
				cValAnt := SR3->R3_VALOR
				SR7->(DbSeek(xFilial("SR3") + SR3->R3_MAT+DTOS(SR3->R3_DATA)+SR3->R3_TIPO))
				CFUNANT := SR7->R7_DESCFUN

				SR3->(DbSkip())
				Loop
			Endif
			If !(SR3->R3_DATA>=MV_PAR04 .AND. SR3->R3_DATA<=MV_PAR05)
				cValAnt := SR3->R3_VALOR
				SR7->(DbSeek(xFilial("SR3") + SR3->R3_MAT+DTOS(SR3->R3_DATA)+SR3->R3_TIPO))
				CFUNANT := SR7->R7_DESCFUN

				SR3->(DbSkip())
				Loop
			Endif
			cValAnt := If(cValAnt==0,SR3->R3_VALOR,cValAnt)
			SR7->(DbSelectArea("SR7")) //Historico Alterações
			SR7->(DbSeek(xFilial("SR3") + SR3->R3_MAT+DTOS(SR3->R3_DATA)+SR3->R3_TIPO))
			IF (MV_PAR10="S" .AND. SR7->R7_DESCFUN=CFUNANT) .OR. (MV_PAR10="S" .AND. EMPTY(ALLTRIM(CFUNANT)))   // SOMENTE REGISTROS QUE ALTERARAM FUNCAO
				SR3->(DbSkip())
				Loop
			ENDIF

			aAdd(aVetorFunc, {SR3->R3_MAT,DTOS(SR3->R3_DATA),SRA->RA_NOME,cValAnt,SR3->R3_VALOR,SR7->R7_DESCFUN,SR3->R3_TIPO,SRA->RA_CC,cFunAnt,SR7->R7_FUNCAO})
			cValAnt := SR3->R3_VALOR
			SR3->(DbSkip())
		Enddo
		DbSelectArea("SRA")
		DbSkip()
	Enddo

	If Len(aVetorFunc) == 0
		IMP_TRANSF()
		dbSelectArea('TRB')
		dbCloseArea()
		cArqTemp2 := cFile + '.DBF'
		Delete File &cArqTemp2
		cArqTemp3 := cFile + '.CDX'
		Delete File &cArqTemp3
		Return
	EndIf

	// Classificação : Centro de Custo + Nome + Data Alteração
	aSort(aVetorFunc,,, {| X, Y | X[8]+X[3]+X[2] < Y[8]+Y[3]+Y[2]})

	IF _lSALARIO
		cTitulo  := "RELACAO DE ALTERAÇÃO SALARIAL" + "   - "+ dtoc(mv_par04)+" a "+dtoc(mv_par05)+" ("+cUserName+")"
		cCabec1  := SPACE(31)+" CodFunc  Data      DescFuncao          Sal.Anterior  Sal.Atual %Aumento Motivo      Funcao Anterior                   CBO"
	ELSE
		cTitulo  := "RELACAO DE ALTERAÇÃO DE FUNÇÃO" + "   - "+ dtoc(mv_par04)+" a "+dtoc(mv_par05)+" ("+cUserName+")"
		cCabec1  := SPACE(31)+" CodFunc  Data      DescFuncao                                           Motivo      Funcao Anterior                   CBO"
	ENDIF   
	cCabec2  := ""
	cLinha   := Repl("-",Limite)
	cMat     := aVetorFunc[1,1]
	cCC      := aVetorFunc[1,8]

	ProcRegua(Len(aVetorFunc))
	_TT:=0
	For nCt := 1 to Len(aVetorFunc)

		IncProc("Imprimindo Matricula : "+aVetorFunc[nCt,1])
		_PERCENT:=((aVetorFunc[nCt,5]-aVetorFunc[nCt,4])/aVetorFunc[nCt,4])*100

		if nLin > 52
			nLin := Cabec(cTitulo,cCabec1,cCabec2,"FPG014R",cTamanho,nCaracter)
			nLin += 1
			CTT->(DbSeek(xFilial("CTT")+aVetorFunc[nCt,8]))
			@nLin, 00 psay "Centro de Custo :"+aVetorFunc[nCt,8]+" - "+CTT->CTT_DESC01
			cCC := aVetorFunc[nCt,8]
			cMat:= aVetorFunc[nCt,1]
			nLin += 1
			@nLin, 00 psay LEFT(aVetorFunc[nCt,3],33)
		endif

		If cCC <> aVetorFunc[nCt,8] .And. nCt>1
			@nLin, 00 PSay cLinha
			nLin += 1
			CTT->(DbSeek(xFilial("CTT")+aVetorFunc[nCt,8]))
			@nLin, 00 psay "Centro de Custo :"+aVetorFunc[nCt,8]+" - "+CTT->CTT_DESC01
			cCC := aVetorFunc[nCt,8]
			cMat:= aVetorFunc[nCt,1]
			nLin += 2
			@nLin, 00 psay aVetorFunc[nCt,1]+" "+LEFT(aVetorFunc[nCt,3],30)
		endif

		If cMat <> aVetorFunc[nCt,1] .and. nCt>1
			cMat := aVetorFunc[nCt,1]
			nLin += 1
			@nLin, 00 psay LEFT(aVetorFunc[nCt,3],33)
		EndIf
		@ nLin, 34 PSAY aVetorFunc[nCt,10]
		@ nLin, 40 PSAY STOD(aVetorFunc[nCt,2])
		@ nLin, 51 PSAY SUBSTR(aVetorFunc[nCt,6],1,20)
		IF _lSALARIO
			@ nLin, 73 PSAY Transform(aVetorFunc[nCt,4],"@E 999,999.99") // SAL ANTER
			@ nLin, 84 PSAY Transform(aVetorFunc[nCt,5],"@E 999,999.99") // SAL NOVO
			@ nLin, 95 PSAY Transform(_Percent,"@E 999.999")
		ENDIF   
		@ nLin,103 PSAY SUBSTR(Tabela("41",aVetorFunc[nCt,7]),1,12)
		@ nLin,116 PSAY SUBSTR(aVetorFunc[nCt,9],1,30)                  // FUNCAO ANTERIOR
		_CBO:=POSICIONE("SRJ",1,XFILIAL("SRJ")+aVetorFunc[nCt,10],"RJ_CODCBO")	
		@ nLin,150 PSAY ALLTRIM(_CBO)


		cKeyEmp   := SM0->M0_CODIGO               // Empresa origem
		cKeyFil   := Padr(SRA->RA_FILIAL,nSizeSRE)// Filial origem
		cKeyMat   := aVetorFunc[nCt,1]            // MATRICULA
		cCondALL  := cKeyEmp+cKeyFil+cKeyMat + LEFT(aVetorFunc[nCt,2],6)
		Dbselectarea("SRE")
		Dbsetorder(1)
		Dbseek(cCondALL,.T.)
		IF cKeyMat=RE_MATD
			_DESCD:= Posicione("CTT",1,xFilial("CTT")+SRE->RE_CCD,"CTT_DESC01")
			@ nLIN,160 PSAY LEFT(ALLTRIM(SRE->RE_CCD)+"-"+_DESCD,32)
		ELSEIF !BOF()
			//@ nLIN,160 PSAY cCondALL
			DBSKIP(-1)
			IF cKeyMat=RE_MATD
				_DESCP:= Posicione("CTT",1,xFilial("CTT")+SRE->RE_CCP,"CTT_DESC01")
				@ nLIN,160 PSAY LEFT(ALLTRIM(SRE->RE_CCP)+"-"+_DESCP,32)
			ELSE    // NAO ACHOU NADA NO SRE .. CONSIDERA O CCUSTO ATUAL (SEM MOVIMENTACAO)
				_DESCATU:= Posicione("CTT",1,xFilial("CTT")+aVetorFunc[nCt,8],"CTT_DESC01")
				@ nLIN,160 PSAY ALLTRIM(aVetorFunc[nCt,8])+"-"+_DESCATU
			ENDIF
		ENDIF 

		_TT++	
		nLin += 1
		DBSELECTAREA("TRB")
		RECLOCK("TRB",.T.)
		TB_MAT:=aVetorFunc[nCt,1]
		TB_CCU:=aVetorFunc[nCt,8]
		TB_DAT:=STOD(aVetorFunc[nCt,2])
		TB_NOM:=aVetorFunc[nCt,3]
		TB_CAR:=aVetorFunc[nCt,6]
		TB_MOT:=Tabela("41",aVetorFunc[nCt,7])
		TB_FUNANT:=aVetorFunc[nCt,9]
		TB_FUNCAO:=aVetorFunc[nCt,10]
		IF _lSALARIO
			TB_ANT:=aVetorFunc[nCt,4]
			TB_ATU:=aVetorFunc[nCt,5]
		ENDIF
		MSUNLOCK()

	Next
	nLin++
	@ nLIN,001 PSAY "Total Impressos : "
	@ nLIN,020 PSAY _TT PICTURE "999999"
	nLin++
	@ nLIN,001 PSAY REPLICATE("-",132)
	nLin++

	IMP_TRANSF()


	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(cNomeRel)
	Endif

	Eject
	Ms_Flush()

	IF _lSALARIO       // SO EXPORTA AO EXCEL O RELATORIO COMPLETO
		_GeraXls:=1
		@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Gera Planilha Excel ?"
		@ 10, 49 SAY "1 - Nao"
		@ 22, 49 SAY "2 - Sim"
		@ 44, 49 GET _GeraXls PICTURE "99"
		@ 60, 90 BmpButton Type 1 Action Close(oDlg2)
		Activate Dialog oDlg2 Centered
		IF _GeraXls=2
	       DbSelectArea("TRB")
	       DBGOTOP()
	       COPY TO AUMENTOS.CSV VIA "DBFCDXADS"
	       //Copiando Arquivo criado .DBF para o diretorio específico no Cliente
	       IF CPYS2T("\SYSTEM\AUMENTOS.CSV","C:\Relato\",.F.)
		       MSGINFO("Arquivo gerado com sucesso! C:\Relato\AUMENTOS.CSV")
	        ELSE
		       ALERT("ERRO NA COPIA")
	       ENDIF
			ShellExecute('open', 'excel.exe', 'C:\Relato\AUMENTOS.CSV', '' , 1) //Abre planilha em excel.
        ENDIF
	ENDIF

	dbSelectArea('TRB')
	dbCloseArea()
	cArqTemp2 := cFile + '.DTC'
	Delete File &cArqTemp2
	cArqTemp3 := cFile + '.CDX'
	Delete File &cArqTemp3

Return(nil)

//*************************
STATIC FUNCTION IMP_TRANSF()
	//********************************************************************* IMPRIME HISTORICO DE TRANSFERENCIAS
	IF MV_PAR01==MV_PAR02
		if nLin <= 52
			@ nLIN,001 PSAY "Matric CCusto Origem"
			@ nLIN,041 PSAY "Matric CCusto Destin"
			@ nLIN,081 PSAY "Dat.Transf Empresa"
			nLin++
			@ nLIN,001 PSAY REPLICATE("-",132)
			nLin++
		ENDIF
		cKeyEmp   := SM0->M0_CODIGO // Empresa origem
		cKeyFil   := Padr(SRA->RA_FILIAL,nSizeSRE)// Filial origem
		cKeyMat   :=MV_PAR01
		//cCondALL  := cKeyEmp+cKeyFil+cKeyMat
		cCondALL  := SPACE(2)+cKeyMat
		Dbselectarea("SRE")
		Dbsetorder(7)
		Dbseek(cCondALL)
		While !eof() .and. cCondALL == SRE->RE_FILIAL+SRE->RE_MATD
			if nLin > 52
				nLin := Cabec("TRANSFERENCIAS"," "," ","FPG014R",cTamanho,nCaracter)
				nLin += 1
				@ nLIN,001 PSAY "Matric CCusto Origem"
				@ nLIN,041 PSAY "Matric CCusto Destin"
				@ nLIN,081 PSAY "Dat.Transf Empresa"
				nLin++
				@ nLIN,001 PSAY REPLICATE("-",132)
				nLin++
			endif
			_DESCD:= Posicione("CTT",1,xFilial("CTT")+SRE->RE_CCD,"CTT_DESC01")
			_DESCP:= Posicione("CTT",1,xFilial("CTT")+SRE->RE_CCP,"CTT_DESC01")
			@ nLIN,001 PSAY SRE->RE_MATD
			@ nLIN,008 PSAY LEFT(ALLTRIM(SRE->RE_CCD)+"-"+_DESCD,32)
			@ nLIN,041 PSAY SRE->RE_MATP
			@ nLIN,048 PSAY LEFT(ALLTRIM(SRE->RE_CCP)+"-"+_DESCP,32)
			@ nLIN,081 PSAY DTOC(SRE->RE_DATA)
			@ nLIN,092 PSAY SRE->RE_EMPD+"-"+SRE->RE_EMPP

			nLin += 1

			DBSKIP()
		ENDDO
	ENDIF

	RETURN 



