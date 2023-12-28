#Include "MsOle.ch"
#Include "Report.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"
#Include "Protheus.ch"

#Include "RPTDEF.CH"
#Include "FWPrintSetup.ch"                       

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} CSGPER06

Termo de Assistência Odontológica.

@author Fernando B. Zapponi
@since 31/08/2016
@version 1.0
/*/
//------------------------------------------------------------------------------------------

User Function CSGPER06()

	Private cAlias	:= "SRA"
	Private aRotina := {{'Pesquisar', 'AxPesqui', 0, 1}, {'Assistência Odontológica', 'u_GPER0601', 0, 2}}
	Private cCadastro := "Cadastro de Funcionários" 
	Private _cCodFil := cFilAnt   
	
	dbSelectArea(cAlias)        
	dbSetOrder(1)    
	
	Set Filter To SRA->RA_FILIAL = _cCodFil .and. SRA->RA_CATFUNC = 'M'
	
	mBrowse( 6, 1,22,75,cAlias,, ) 
	
	Set Filter To
	
Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} GPER0601
Impressão do relatório Gráfico
@author Fernando B. Zapponi
@since 16/08/2016
@version 1.0
/*/
//------------------------------------------------------------------------------------------

User Function GPER0601

	Private lAdjustToLegacy 	:= .T.
	Private lDisableSetup  	:= .T.
	Private oPrinter
	Private cLocal          	:= ""
	Private lGeraRel			:= .T.
	Private _cFileLogo 		:= '\logos\logo.bmp'

	oFont08 := TFont():New( "Arial",,10,,.F.,,,,,.f.)
	oFont09 := TFont():New( "Arial",,11,,.F.,,,,,.f.)
	oFont09i:= TFont():New( "Arial",,11,,.F.,,,,.T.,.f.)
	oFont09n:= TFont():New( "Arial",,11,,.T.,,,,,.f.)
	oFont10 := TFont():New( "Arial",,12,,.F.,,,,,.f.)
	oFont10n:= TFont():New( "Arial",,12,,.T.,,,,,.f.)
	oFont12 := TFont():New( "Arial",,14,,.F.,,,,,.f.)
	oFont12n:= TFont():New( "Arial",,14,,.T.,,,,,.f.)
	oFont122:= TFont():New( "Arial",,14,,.T.,,,,,.f.)
	
	oPrinter := FWMSPrinter():New("GPER06.rel", IMP_PDF, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
	oPrinter:cPathPDF := "c:\relato\"
	oPrinter:SetPortrait() 
	
	// Chama a Função de Geração do Relatório
	Processa({|| RunRelat() },"Gerando Relatório Gráfico...")
	/*if lGeraRel
		oPrinter:Setup()
		if oPrinter:nModalResult == PD_OK
			oPrinter:Preview()
		EndIf
	Else 
	 	Return
	Endif
	*/

Return

	
//------------------------------------------------------------------------------------------
/*/{Protheus.doc} RunRelat
Funsção interna para gerar o conteúdo.
@author Fernando B. Zapponi
@since 29/08/2016
@version 1.0
/*/
//------------------------------------------------------------------------------------------	
Static Function RunRelat()

	Local _lPerg
	Local _cEstado 	:= "UF não localizada"
	Local nAjuste		:= 100
	
	Local _nAltI		:= 450	// Posicionamento inicial
	Local _nAltLinha	:= 50  // Altura da linha
	Local _nAltLogo	:= 175 // Altura da logo
	Local _nAltTit	:= 175 // Altura do título
	Local _nAltura	:= _nAltI 	// Altura atual
	
	Local _cMat		:= ""
	Local _cPar		:= ""


	oPrinter:StartPage()

	// Desenha o Box do Cabecalho e Logo
	If SM0->M0_CODIGO != "02"
		oPrinter:SayBitmap(_nAltLogo, 0145, _cFileLogo, 0500, 0150) //Tamanho da Imagem: 134 x 61
	EndIF
    
	
	// Empresa 01
	If SM0->M0_CODIGO == "01"
		If _cCodFil == "01"
			_cEstado := "Brasília - DF, "
		EndIf
		
		If _cCodFil == "02"
			_cEstado := "Goiânia - Go, "
		EndIf
	EndIf
	
	// Empresa 02
	If SM0->M0_CODIGO == "02"
		If _cCodFil == "01"
			_cEstado := "Brasília - DF, "
		EndIf
	EndIF
	
	For i:= 1 To 1
	
		_cMat := SRA->RA_MAT
		
		// TITULO                                                                                                                                     
		oPrinter:Say (_nAltTit, 1000, "Assistência Odontológica", oFont122, 100)   
		
		// EMPRESA
		oPrinter:Say (_nAltura, 0200, 'Empresa:' + SM0->M0_NOMECOM, oFont12, 100) 																													; _nAltura += _nAltLinha  
		oPrinter:Say (_nAltura, 0200, 'CNPJ: ' + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"), oFont12, 100)																					; _nAltura += _nAltLinha * 2
		
		// SAUDACAO
		oPrinter:Say (_nAltura, 0200, iif( alltrim(SRA->RA_SEXO) == "M", "Ao Senhor, ", "A Senhora, "  ), oFont12n, 100)																		; _nAltura += _nAltLinha * 2
		
		// FUNCIONARIO
		oPrinter:Say (_nAltura, 0200, 'Funcionário: '+ allTrim(SRA->RA_NOME), oFont12, 100)																											; _nAltura += _nAltLinha
		oPrinter:Say (_nAltura, 0200, 'Matrícula: '+ allTrim(SRA->RA_MAT), oFont12, 100) 																											; _nAltura += _nAltLinha
		oPrinter:Say (_nAltura, 0200, 'CPF: ' + Transform(SRA->RA_CIC,"@R 999.999.999-99"), oFont12, 100) 																						; _nAltura += _nAltLinha
		oPrinter:Say (_nAltura, 0200, 'Data de Nascimento: ' + Dtoc(SRA->RA_NASC), oFont12, 100)  																									; _nAltura += _nAltLinha * 3
		
		// ASSUNTO
		oPrinter:Say (_nAltura, 0400, "Assunto: ASSISTÊNCIA ODONTOLÓGICA." , oFont12, 100)																											; _nAltura += _nAltLinha
		oPrinter:Say (_nAltura, 0400, "Operadora: AMIL ASSISTÊNCIA MÉDICA INTERNACIONAL S/A " , oFont12n, 100)																								; _nAltura += _nAltLinha * 2
		
		// CONTEUDO
		oPrinter:Say (_nAltura, 0200, "                 A  empresa  disponibiliza  o  benefício  de  Plano de Odontológico  pela  operadora acima mencionada  onde" , oFont12, 100)	; _nAltura += _nAltLinha 														
		oPrinter:Say (_nAltura, 0200, "custeamos uma parte para todos funcionários. Nosso Plano é compulsório, ou seja é necessário que todos funcionários" , oFont12, 100)				; _nAltura += _nAltLinha 
		oPrinter:Say (_nAltura, 0200, "participem, logo contamos com a sua participação. No entanto fica a sua disposição aderir estes benefícios, sendo que," , oFont12, 100)			; _nAltura += _nAltLinha 
		oPrinter:Say (_nAltura, 0200, "feita a adesão,  o  empregado não poderá em  momento algum cancelar  (titular e dependente),  já que a sua  exclusão, " , oFont12, 100)			; _nAltura += _nAltLinha 
		oPrinter:Say (_nAltura, 0200, "bem  como  dos  seus  dependentes, ocasionará  prejuízo a todos do grupo,  da mesma forma,  caso não  adquira estes   " , oFont12, 100)				; _nAltura += _nAltLinha  
		oPrinter:Say (_nAltura, 0200, "benefícios no ato da admissão, o empregado não poderá mais aderir nem no presente e nem no futuro. " , oFont12, 100)								; _nAltura += _nAltLinha 
		oPrinter:Say (_nAltura, 0200, "Estes benefícios terão seus valores reajustados anualmente." , oFont12, 100)																				; _nAltura += _nAltLinha * 2 
		
		oPrinter:Say (_nAltura, 0200, "Estando  ciente  disso  autorizo  de  livre e espontânea vontade,  conforme o enunciado TST nº 342, a descontar em meu " , oFont12, 100)			; _nAltura += _nAltLinha 
		oPrinter:Say (_nAltura, 0200, "contra-cheque mensalmente a minha adesão bem como dos meus dependentes conforme discriminado abaixo:" , oFont12, 100)									; _nAltura += _nAltLinha * 2 

		oPrinter:Say (_nAltura, 0400, "(  ) Aceito este benefício mesmo estando ciente do descrito acima." , oFont12, 100)																		; _nAltura += _nAltLinha 
		oPrinter:Say (_nAltura, 0400, "(  ) Não aceito este benefício mesmo estando ciente do descrito acima." , oFont12, 100)																	; _nAltura += _nAltLinha * 2
		oPrinter:Say (_nAltura, 0400, "Autorizo a colocar os seguintes dependentes:" , oFont12, 100)																								; _nAltura += _nAltLinha 
		
		Dbselectarea("SRB")
		Dbsetorder(1) //FILIAL+MATRICULA
		Dbseek(xFilial("SRA")+_cMat)
		
		Do While !eof() .and. xFilial("SRB")+SRB->RB_MAT == xFilial("SRA")+_cMat
			_cPar :=  GPE0602(SRB->RB_GRAUPAR, SRB->RB_SEXO)
			oPrinter:Say (_nAltura, 0400, "(    ) "+ allTrim(SRB->RB_NOME) + " - " + _cPar , oFont12, 100)   																						; _nAltura += _nAltLinha
			Dbskip()
		Enddo
		
		SRB->(DbCloseArea())

		_nAltura += _nAltLinha * 6 
		 
		
		// LOCAL 
		oPrinter:Say (_nAltura, 0200, "Ciente, ", oFont12, 100)																																			; _nAltura += _nAltLinha 
		oPrinter:Say (_nAltura, 0200, _cEstado + Dtoc(dDataBase), oFont12, 100)																														; _nAltura += _nAltLinha * 2

		// LINHA DE ASSINATURA.
		oPrinter:Say (_nAltura, 0200, Replicate("_",40), oFont12, 100)   																																; _nAltura += _nAltLinha 
		oPrinter:Say (_nAltura, 0200, allTrim(SRA->RA_NOME), oFont12, 100)   																															; _nAltura += _nAltLinha 
		oPrinter:Say (_nAltura, 0200, "Funcionário", oFont09, 100) 																																		; _nAltura += _nAltLinha 
		
		nAjuste += 1600
	
    Next
	
	oPrinter :EndPage()
	oPrinter :Preview()
	
Return  



Static Function GPE0602(cod, sexo)
	
	Local _cPar := "N/I"

	DO CASE
		CASE cod == "C"
			_cPar := "Cônjuge"
		CASE cod == "F"
			_cPar := "Filho"
			if sexo == "F"
				_cPar := "Filha"
			endif
		CASE cod == "E"
			_cPar := "Enteado"
			if sexo == "F"
				_cPar := "Enteada"
			endif
		CASE cod == "P"
			_cPar := "Pai"
			if sexo == "F"
				_cPar := "Mãe"
			endif
	ENDCASE

Return _cPar 
