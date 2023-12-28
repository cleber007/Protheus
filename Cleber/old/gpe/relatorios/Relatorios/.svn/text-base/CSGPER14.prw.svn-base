#Include "MsOle.ch"
#Include "Report.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"
#Include "Protheus.ch"

#Include "RPTDEF.CH"
#Include "FWPrintSetup.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} CSGPER14

Termo de Ciência - Plano de Saúde

@author Fernando B. Zapponi	
@since 04/11/2016
@version 1.0
/*/
//------------------------------------------------------------------------------------------

User Function CSGPER14()

	Private cAlias	:= "SRA"
	Private aRotina := {{'Pesquisar', 'AxPesqui', 0, 1}, {'Imprimir Termo', 'u_GPER1401', 0, 2}}
	Private cCadastro := "Cadastro de Funcionários"
	Private _cCodFil := cFilAnt
	
	dbSelectArea(cAlias)
	dbSetOrder(1)
	
	Set Filter To SRA->RA_FILIAL = _cCodFil .and. SRA->RA_CATFUNC = 'M'
	mBrowse( 6, 1,22,75,cAlias,, )
	
	Set Filter To
	
Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} GPER1401
Impressão do relatório Gráfico
@author Fernando B. Zapponi
@since 04/11/2016
@version 1.0
/*/
//------------------------------------------------------------------------------------------

User Function GPER1401

	Private lAdjustToLegacy 	:= .T.
	Private lDisableSetup  	:= .T.
	Private oPrint
	Private cLocal          	:= ""
	Private lGeraRel			:= .T.
	Private _cFileLogo 		:= '\logos\logo.bmp'

	oArial06	:= TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
	oArial06n	:= TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)
	oCourier07	:= TFont():New("Courier",07,07,,.F.,,,,.T.,.F.)
	oArial07	:= TFont():New("Arial",07,07,,.F.,,,,.T.,.F.)
	oArial07n	:= TFont():New("Arial",07,07,,.T.,,,,.T.,.F.)
	oCourier08	:= TFont():New("Courier",08,08,,.F.,,,,.T.,.F.)
	oArial08	:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
	oArial08n	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
	oCourier09	:= TFont():New("Courier",09,09,,.F.,,,,.T.,.F.)
	oCourier09n	:= TFont():New("Courier",09,09,,.T.,,,,.T.,.F.)
	oArial09	:= TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)
	oArial09n	:= TFont():New("Arial",09,09,,.T.,,,,.T.,.F.)
	oArial10	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
	oArial10n	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
	oCourier10	:= TFont():New("Courier",10,10,,.F.,,,,.T.,.F.)
	oCourier10n	:= TFont():New("Courier",10,10,,.T.,,,,.T.,.F.)
	oArial11	:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
	oArial11n	:= TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)
	oArial12	:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
	oArial12n	:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)
	oCourier12	:= TFont():New("Courier",12,12,,.F.,,,,.T.,.F.)
	oArial13	:= TFont():New("Arial",13,13,,.F.,,,,.T.,.F.)
	oArial13n	:= TFont():New("Arial",13,13,,.T.,,,,.T.,.F.)
	oArial14	:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
	oArial14n	:= TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
	oArial15	:= TFont():New("Arial",15,15,,.F.,,,,.T.,.F.)
	oArial15n	:= TFont():New("Arial",15,15,,.T.,,,,.T.,.F.)
	oArial16	:= TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
	oArial16n	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)

	//oArial08 := TFont():New( "Arial",,10,,.F.,,,,,.f.)
	//oArial09 := TFont():New( "Arial",,11,,.F.,,,,,.f.)
	//oArial09i:= TFont():New( "Arial",,11,,.F.,,,,.T.,.f.)
	//oArial09n:= TFont():New( "Arial",,11,,.T.,,,,,.f.)
	//oArial10 := TFont():New( "Arial",,12,,.F.,,,,,.f.)
	//oArial10n:= TFont():New( "Arial",,12,,.T.,,,,,.f.)
	//oArial12 := TFont():New( "Arial",,14,,.F.,,,,,.f.)
	//oArial12n:= TFont():New( "Arial",,14,,.T.,,,,,.f.)
	//oArial122:= TFont():New( "Arial",,14,,.T.,,,,,.f.)
	
	oPrint := FWMSPrinter():New("CSGPER14.rel", IMP_PDF, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
	oPrint:cPathPDF := "c:\relato\"
	//oPrint:SetPortrait() 
	
	// Chama a Função de Geração do Relatório
	Processa({|| RunRelat() },"Gerando Relatório Gráfico...")
/*	if lGeraRel
		oPrint:Setup()
		if oPrint:nModalResult == PD_OK
			oPrint:Preview()
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
@since 04/11/2016
@version 1.0
/*/
//------------------------------------------------------------------------------------------	

Static Function RunRelat()

	Local _lPerg
	Local _cEstado 	:= "UF não localizada"
	Local nAjuste		:= 100
	Local _nAltI		:= 450			// Posicionamento inicial
	Local _nAltLinha	:= 35  		// Altura da linha
	Local _nAltLogo	:= 175 		// Altura da logo
	Local _nAltTit	:= 175 		// Altura do título
	Local _nAltura	:= _nAltI 		// Altura atual
	Local _cMat		:= ""
	Local _cPar		:= ""
	Local _nLimite  	:= 138
	
	Local _cFuncao	:= ""
	Local _cCodCBO	:= ""
	
	Local oFonteTermo := oCourier10
	
	oPrint:StartPage()

	// Desenha o Box do Cabecalho e Logo
	If SM0->M0_CODIGO != "02"
		oPrint:SayBitmap(_nAltLogo, 0145, _cFileLogo, 0500, 0150) //Tamanho da Imagem: 134 x 61
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
	
	
	IF  _cCodFil == "01"
		
		For i:= 1 To 1
	
			//oPrint:SayBitmap( 080+nAjuste, 100,_cFileLogo,300,100 ) 
	
			_cMat := SRA->RA_MAT
			_cFuncao := posicione("SRJ", 1, xFilial("SRJ") + SRA->RA_CODFUNC, "RJ_DESC")
			_cCodCBO := posicione("SRJ", 1, xFilial("SRJ") + SRA->RA_CODFUNC, "RJ_CODCBO")
		
			// TITULO                                                                                                                                     
			oPrint:Say (_nAltTit, 1000, "TERMO DE CIÊNCIA ASSISTÊNCIA MÉDICA", oArial14N, 100) ; _nAltTit += _nAltLinha
			//oPrint:Say (_nAltTit, 1000, "", oArial14N, 100)   ; _nAltTit += _nAltLinha
			//oPrint:Say (_nAltTit, 1000, "", oArial14N, 100)   ; _nAltTit += _nAltLinha
			
			oPrint:Say ( 350+nAjuste,0170, 'Empregadora:' + SM0->M0_NOMECOM, oFonteTermo,100)
			//oPrint:Say ( 350+nAjuste,0310, SM0->M0_NOMECOM, oFonteTermon,100)   
			//oPrint:Say ( 400+nAjuste,0310, Trim(SM0->M0_ENDCOB)+" "+Trim(SM0->M0_BAIRCOB)+" "+Trim(SM0->M0_COMPCOB)+" "+Trim(SM0->M0_CIDCOB)+"-"+Trim(SM0->M0_ESTCOB), oFonteTermon,100)   
			oPrint:Say ( 400+nAjuste,0170, 'CNPJ: ' + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"), oFonteTermo,100)
			//oPrint:Say ( 400+nAjuste,0310, SM0->M0_CGC, oFonteTermon,100)   
		
			oPrint:Say ( 500+nAjuste,0170, 'Funcionário: '+ alltrim(SRA->RA_NOME), oFonteTermo,100)
			//oPrint:Say ( 500+nAjuste,0310, SRA->RA_NOME, oFonteTermon,100)   
			oPrint:Say ( 550+nAjuste,0170, 'Matrícula: '+ SRA->RA_MAT, oFonteTermo,100)
			oPrint:Say ( 600+nAjuste,0170, 'CPF: '+ Transform(SRA->RA_CIC,"@R 999.999.999-99"), oFonteTermo,100)
			//oPrint:Say ( 550+nAjuste,0280, SRA->RA_MAT, oFonteTermon,100)   
			//oPrint:Say ( 550+nAjuste,0170, 'C.T.P.S.: ' + alltrim(SRA->RA_NUMCP) + '/' + allTrim(SRA->RA_SERCP) + ' - ' + allTrim(SRA->RA_UFCP), oFonteTermo,100)
			//oPrint:Say ( 550+nAjuste,0630, SRA->RA_NUMCP+"-"+SRA->RA_UFCP, oFonteTermon,100)   
			//oPrint:Say ( 600+nAjuste,0170, 'Admissão: ' + Dtoc(SRA->RA_ADMISSA), oFonteTermo,100)
			oPrint:Say ( 650+nAjuste,0170, 'Data de Nascimento: '+ Dtoc(SRA->RA_NASC), oFonteTermon,100)
			//oPrint:Say ( 550+nAjuste,1700, "PIS:", oFonteTermo,100)   
			//oPrint:Say ( 550+nAjuste,1780, SRA->RA_PIS, oFonteTermon,100) 
			
		
		
			// _cTexto1 := "Pelo presente instrumento, o funcionário "+allTrim(SRA->RA_NOME)+", devidamente inscrito no CPF sob o nº "+Transform(SRA->RA_CIC,"@R 999.999.999-99")+", portador do RG nº "+Alltrim(SRA->RA_RG)+"-"+AllTrim(SRA->RA_RGORG)+"/"+SRA->RA_RGUF+ " doravante denominado USUÁRIO, declara que recebe, em regime de detenção, aparelho celular e seus acessórios, para uso exclusivamente corporativo, de propriedade da empresa "+AllTrim(SM0->M0_NOMECOM)+", pessoa jurídica de direito privado, devidamente inscrita no CNPJ sob o nº "+ Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+", com endereço na QS 09, Rua 100, Lote nº 04, Águas Claras-DF, CEP 71.976-370, doravante denominada PROPRIETÁRIA, mediante os seguintes termos e condições."
		
			_nAltI := 750 + nAjuste
		
			_cTexto1 := "        A empresa disponibiliza o benefício de Assistência Médica pela AMIL ASSISTÊNCIA MÉDICA INTERNACIONAL SA, onde custeará em parte do valor do seguro para todos os funcionários e seus dependentes (cônjuge e filhos) que aderirem ao plano."
		
			_nMemCount := MlCount( _cTexto1 ,_nLimite )
			_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
			For _nx:=1 to Len(_aTexto)
				oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
				_nAltI+=_nAltLinha
			Next _nx
			_nAltI+=_nAltLinha
		
		
			_cTexto1 := "        O Plano de Saúde ofertado pela Companhia de Seguros é compulsório, ou seja é necessário que todos os funcionários participem, logo contamos com a sua participação. No entanto, fica à sua disposição e critério aderir a este benefício ou não, sendo que, uma vez optado pela adesão do plano, o empregado e seus dependentes, por exigência contratual do plano de sáude em referência, não poderão em momento algum cancelá-lo, já que a sua exclusão, bem como dos seus dependentes, ocasionará prejuízo a todos do grupo. De igual modo, caso não adquira estes benefícios no ato da admissão, o empregado e seus dependentes não poderão aderi-lo nem no presente e nem no futuro."
		
			_nMemCount := MlCount( _cTexto1 ,_nLimite )
			_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
			For _nx:=1 to Len(_aTexto)
				oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
				_nAltI+=_nAltLinha
			Next _nx
			_nAltI+=_nAltLinha
		
		
			_cTexto1 := "        Estes benefícios terão seus valores reajustados anualmente de acordo com índice de variação e reajuste apresentado pela AMIL ASSISTÊNCIA MÉDICA INTERNACIONAL SA."

			_nMemCount := MlCount( _cTexto1 ,_nLimite )
			_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
			For _nx:=1 to Len(_aTexto)
				oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
				_nAltI+=_nAltLinha
			Next _nx
			_nAltI+= _nAltLinha
			

			_cTexto1 := "        Estando ciente disso, autorizo de livre e espontânea vontade, conforme o enunciado TST nº 342, a descontar em meu contra-cheque mensalmente a minha adesão bem como dos meus dependentes conforme discriminado abaixo:"

			_nMemCount := MlCount( _cTexto1 ,_nLimite )
			_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
			For _nx:=1 to Len(_aTexto)
				oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
				_nAltI+=_nAltLinha
			Next _nx
			_nAltI+= _nAltLinha
	

			_cTexto1 := "Plano Medial 400"
			oPrint:Say ( _nAltI,0170, _cTexto1 , oCourier10n,100)
			_nAltI+= _nAltLinha
			
			_cTexto1 := "(     ) Aceito este benefício mesmo estando ciente do descrito acima."
			oPrint:Say ( _nAltI,0170, _cTexto1 , oCourier10,100)
			_nAltI+= _nAltLinha
		
			_cTexto1 := "(     ) Não aceito este benefício."
			oPrint:Say ( _nAltI,0170, _cTexto1 , oCourier10,100)
			_nAltI+= _nAltLinha * 2
		
			_cTexto1 := "Autorizo a colocar os seguintes dependentes:"
			oPrint:Say ( _nAltI,0170, _cTexto1 , oCourier10n,100)
			_nAltI+= _nAltLinha
		
			Dbselectarea("SRB")
			Dbsetorder(1) //FILIAL+MATRICULA
			Dbseek(xFilial("SRA")+_cMat)
		
			Do While !eof() .and. xFilial("SRB")+SRB->RB_MAT == xFilial("SRA")+_cMat
				_cPar :=  GPE1402(SRB->RB_GRAUPAR, SRB->RB_SEXO)
				oPrint:Say (_nAltI, 0170, "(    ) "+ allTrim(SRB->RB_NOME) + " - " + _cPar , oFonteTermo, 100)   																						; _nAltura += _nAltLinha
				Dbskip()
				_nAltI+= _nAltLinha
			Enddo
		
			SRB->(DbCloseArea())

			_nAltI += _nAltLinha * 2
		 
	
			_cTexto1 := "Não ocorrendo o repasse do valor na forma prevista, ou seja, ocorrendo a falta de pagamento do empregado e seus dependentes da parcela que lhes cabem, por qualquer razão, resultará na perda do direito dos mesmos de usufruírem do Plano de Assistência Médica da AMIL ASSISTÊNCIA MÉDICA INTERNACIONAL SA. Neste caso, a empresa Café do Sítio Indústria e Comércio Ltda tomará as providências legais cabíveis para a solução do impasse."

			_nMemCount := MlCount( _cTexto1 ,_nLimite )
			_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
			For _nx:=1 to Len(_aTexto)
				oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
				_nAltI+=_nAltLinha
			Next _nx
			_nAltI+= _nAltLinha * 3
		

			// LOCAL 
			oPrint:Say (_nAltI, 0200, _cEstado + Dtoc(dDataBase), oArial12n, 100)
			_nAltI+=_nAltLinha * 2

			// LINHA DE ASSINATURA.
			oPrint:Say (_nAltI, 0200, Replicate("_",40), oFonteTermo, 100)
			oPrint:Say (_nAltI, 1200, Replicate("_",40), oFonteTermo, 100)
		
			_nAltI+=_nAltLinha
		
			oPrint:Say (_nAltI, 0200, allTrim(SRA->RA_NOME), oFonteTermo, 100)
			oPrint:Say (_nAltI, 1200, AllTrim(SM0->M0_NOMECOM), oFonteTermo, 100)
		
			_nAltI+=_nAltLinha * 2
			
			//oPrint:Say (_nAltI, 0200, Replicate("_",40), oFonteTermo, 100)
			//oPrint:Say (_nAltI, 1200, Replicate("_",40), oFonteTermo, 100)
		
			_nAltI+=_nAltLinha
		
			//oPrint:Say (_nAltI, 0200, "Testemunha", oCourier10n, 100)
			//oPrint:Say (_nAltI, 1200, "Testemunha", oCourier10n, 100)
			
			
			Next
	
				oPrint :EndPage()
				oPrint :Preview()
				
			Return
		
		Else
			
			For i:= 1 To 1
	
			//oPrint:SayBitmap( 080+nAjuste, 100,_cFileLogo,300,100 ) 
	
				_cMat := SRA->RA_MAT
				_cFuncao := posicione("SRJ", 1, xFilial("SRJ") + SRA->RA_CODFUNC, "RJ_DESC")
				_cCodCBO := posicione("SRJ", 1, xFilial("SRJ") + SRA->RA_CODFUNC, "RJ_CODCBO")
		
			// TITULO                                                                                                                                     
				oPrint:Say (_nAltTit, 1000, "TERMO DE CIÊNCIA ASSISTÊNCIA MÉDICA", oArial14N, 100) ; _nAltTit += _nAltLinha
			//oPrint:Say (_nAltTit, 1000, "", oArial14N, 100)   ; _nAltTit += _nAltLinha
			//oPrint:Say (_nAltTit, 1000, "", oArial14N, 100)   ; _nAltTit += _nAltLinha
			
				oPrint:Say ( 350+nAjuste,0170, 'Empregadora:' + SM0->M0_NOMECOM, oFonteTermo,100)
			//oPrint:Say ( 350+nAjuste,0310, SM0->M0_NOMECOM, oFonteTermon,100)   
			//oPrint:Say ( 400+nAjuste,0310, Trim(SM0->M0_ENDCOB)+" "+Trim(SM0->M0_BAIRCOB)+" "+Trim(SM0->M0_COMPCOB)+" "+Trim(SM0->M0_CIDCOB)+"-"+Trim(SM0->M0_ESTCOB), oFonteTermon,100)   
				oPrint:Say ( 400+nAjuste,0170, 'CNPJ: ' + "11.238.582/0001-65", oFonteTermo,100)
			//oPrint:Say ( 400+nAjuste,0310, SM0->M0_CGC, oFonteTermon,100)   
		
				oPrint:Say ( 500+nAjuste,0170, 'Funcionário: '+ alltrim(SRA->RA_NOME), oFonteTermo,100)
			//oPrint:Say ( 500+nAjuste,0310, SRA->RA_NOME, oFonteTermon,100)   
				oPrint:Say ( 550+nAjuste,0170, 'Matrícula: '+ SRA->RA_MAT, oFonteTermo,100)
				oPrint:Say ( 600+nAjuste,0170, 'CPF: '+ Transform(SRA->RA_CIC,"@R 999.999.999-99"), oFonteTermo,100)
			//oPrint:Say ( 550+nAjuste,0280, SRA->RA_MAT, oFonteTermon,100)   
			//oPrint:Say ( 550+nAjuste,0170, 'C.T.P.S.: ' + alltrim(SRA->RA_NUMCP) + '/' + allTrim(SRA->RA_SERCP) + ' - ' + allTrim(SRA->RA_UFCP), oFonteTermo,100)
			//oPrint:Say ( 550+nAjuste,0630, SRA->RA_NUMCP+"-"+SRA->RA_UFCP, oFonteTermon,100)   
			//oPrint:Say ( 600+nAjuste,0170, 'Admissão: ' + Dtoc(SRA->RA_ADMISSA), oFonteTermo,100)
				oPrint:Say ( 650+nAjuste,0170, 'Data de Nascimento: '+ Dtoc(SRA->RA_NASC), oFonteTermon,100)
			//oPrint:Say ( 550+nAjuste,1700, "PIS:", oFonteTermo,100)   
			//oPrint:Say ( 550+nAjuste,1780, SRA->RA_PIS, oFonteTermon,100) 
			
		
		
			// _cTexto1 := "Pelo presente instrumento, o funcionário "+allTrim(SRA->RA_NOME)+", devidamente inscrito no CPF sob o nº "+Transform(SRA->RA_CIC,"@R 999.999.999-99")+", portador do RG nº "+Alltrim(SRA->RA_RG)+"-"+AllTrim(SRA->RA_RGORG)+"/"+SRA->RA_RGUF+ " doravante denominado USUÁRIO, declara que recebe, em regime de detenção, aparelho celular e seus acessórios, para uso exclusivamente corporativo, de propriedade da empresa "+AllTrim(SM0->M0_NOMECOM)+", pessoa jurídica de direito privado, devidamente inscrita no CNPJ sob o nº "+ Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+", com endereço na QS 09, Rua 100, Lote nº 04, Águas Claras-DF, CEP 71.976-370, doravante denominada PROPRIETÁRIA, mediante os seguintes termos e condições."
		
				_nAltI := 750 + nAjuste
		
				_cTexto1 := "        A empresa disponibiliza o benefício de Assistência Médica pela BRADESCO SAÚDE S/A, onde custeará em parte do valor do seguro para todos os funcionários e seus dependentes (cônjuge e filhos) que aderirem ao plano."
		
				_nMemCount := MlCount( _cTexto1 ,_nLimite )
				_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
				For _nx:=1 to Len(_aTexto)
					oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
					_nAltI+=_nAltLinha
				Next _nx
				_nAltI+=_nAltLinha
		
		
				_cTexto1 := "        O Plano de Saúde ofertado pela Companhia de Seguros é compulsório, ou seja é necessário que todos os funcionários participem, logo contamos com a sua participação. No entanto, fica à sua disposição e critério aderir a este benefício ou não, sendo que, uma vez optado pela adesão do plano, o empregado e seus dependentes, por exigência contratual do plano de sáude em referência, não poderão em momento algum cancelá-lo, já que a sua exclusão, bem como dos seus dependentes, ocasionará prejuízo a todos do grupo. De igual modo, caso não adquira estes benefícios no ato da admissão, o empregado e seus dependentes não poderão aderi-lo nem no presente e nem no futuro."
		
				_nMemCount := MlCount( _cTexto1 ,_nLimite )
				_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
				For _nx:=1 to Len(_aTexto)
					oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
					_nAltI+=_nAltLinha
				Next _nx
				_nAltI+=_nAltLinha
		
		
				_cTexto1 := "        Estes benefícios terão seus valores reajustados anualmente de acordo com índice de variação e reajuste apresentado pela BRADESCO SAÚDE S/A."

				_nMemCount := MlCount( _cTexto1 ,_nLimite )
				_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
				For _nx:=1 to Len(_aTexto)
					oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
					_nAltI+=_nAltLinha
				Next _nx
				_nAltI+= _nAltLinha
			

				_cTexto1 := "        Estando ciente disso, autorizo de livre e espontânea vontade, conforme o enunciado TST nº 342, a descontar em meu contra-cheque mensalmente a minha adesão bem como dos meus dependentes conforme discriminado abaixo:"

				_nMemCount := MlCount( _cTexto1 ,_nLimite )
				_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
				For _nx:=1 to Len(_aTexto)
					oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
					_nAltI+=_nAltLinha
				Next _nx
				_nAltI+= _nAltLinha
	

				_cTexto1 := "PLANO TNE"
				oPrint:Say ( _nAltI,0170, _cTexto1 , oCourier10n,100)
				_nAltI+= _nAltLinha
			
				_cTexto1 := "(     ) Aceito este benefício mesmo estando ciente do descrito acima."
				oPrint:Say ( _nAltI,0170, _cTexto1 , oCourier10,100)
				_nAltI+= _nAltLinha
		
				_cTexto1 := "(     ) Não aceito este benefício."
				oPrint:Say ( _nAltI,0170, _cTexto1 , oCourier10,100)
				_nAltI+= _nAltLinha * 2
		
				_cTexto1 := "Autorizo a colocar os seguintes dependentes:"
				oPrint:Say ( _nAltI,0170, _cTexto1 , oCourier10n,100)
				_nAltI+= _nAltLinha
		
				Dbselectarea("SRB")
				Dbsetorder(1) //FILIAL+MATRICULA
				Dbseek(xFilial("SRA")+_cMat)
		
				Do While !eof() .and. xFilial("SRB")+SRB->RB_MAT == xFilial("SRA")+_cMat
					_cPar :=  GPE1402(SRB->RB_GRAUPAR, SRB->RB_SEXO)
					oPrint:Say (_nAltI, 0170, "(    ) "+ allTrim(SRB->RB_NOME) + " - " + _cPar , oFonteTermo, 100)   																						; _nAltura += _nAltLinha
					Dbskip()
					_nAltI+= _nAltLinha
				Enddo
		
				SRB->(DbCloseArea())

				_nAltI += _nAltLinha * 2
		 
	
				_cTexto1 := "Não ocorrendo o repasse do valor na forma prevista, ou seja, ocorrendo a falta de pagamento do empregado e seus dependentes da parcela que lhes cabem, por qualquer razão, resultará na perda do direito dos mesmos de usufruírem do Plano de Assistência Médica da BRADESCO SAÚDE S/A. Neste caso, a empresa Café do Sítio Indústria e Comércio Ltda tomará as providências legais cabíveis para a solução do impasse."

				_nMemCount := MlCount( _cTexto1 ,_nLimite )
				_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
				For _nx:=1 to Len(_aTexto)
					oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
					_nAltI+=_nAltLinha
				Next _nx
				_nAltI+= _nAltLinha * 3
		

			// LOCAL 
				oPrint:Say (_nAltI, 0200, _cEstado + Dtoc(dDataBase), oArial12n, 100)
				_nAltI+=_nAltLinha * 2

			// LINHA DE ASSINATURA.
				oPrint:Say (_nAltI, 0200, Replicate("_",40), oFonteTermo, 100)
				oPrint:Say (_nAltI, 1200, Replicate("_",40), oFonteTermo, 100)
		
				_nAltI+=_nAltLinha
		
				oPrint:Say (_nAltI, 0200, allTrim(SRA->RA_NOME), oFonteTermo, 100)
				oPrint:Say (_nAltI, 1200, AllTrim(SM0->M0_NOMECOM), oFonteTermo, 100)
		
				_nAltI+=_nAltLinha * 2
			
			//oPrint:Say (_nAltI, 0200, Replicate("_",40), oFonteTermo, 100)
			//oPrint:Say (_nAltI, 1200, Replicate("_",40), oFonteTermo, 100)
		
				_nAltI+=_nAltLinha
		
			//oPrint:Say (_nAltI, 0200, "Testemunha", oCourier10n, 100)
			//oPrint:Say (_nAltI, 1200, "Testemunha", oCourier10n, 100)
			
			
			Next
	
				oPrint :EndPage()
				oPrint :Preview()
		
		ENDIF
			
	
	
	
	Return

	Static Function GPE1402(cod, sexo)
	
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