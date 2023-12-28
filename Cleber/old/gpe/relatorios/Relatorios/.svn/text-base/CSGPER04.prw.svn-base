#Include "MsOle.ch"
#Include "Report.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"
#Include "Protheus.ch"

#Include "RPTDEF.CH"
#Include "FWPrintSetup.ch"                       

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} CSGPER04

Termo de Seguro de Vida.

@author Fernando B. Zapponi
@since 29/08/2016
@version 1.0
/*/
//------------------------------------------------------------------------------------------

User Function CSGPER04()

	Private cAlias	:= "SRA"
	Private aRotina := {{'Pesquisar', 'AxPesqui', 0, 1}, {'Seguro de Vida', 'u_GPER0401', 0, 2}}
	Private cCadastro := "Cadastro de Funcionários" 
	Private _cCodFil := cFilAnt   
	
	dbSelectArea(cAlias)        
	dbSetOrder(1)    
	
	Set Filter To SRA->RA_FILIAL = _cCodFil .and. SRA->RA_CATFUNC = 'M'
	
	mBrowse( 6, 1,22,75,cAlias,, ) 
	
	Set Filter To
	
Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} GPER0401
Impressão do relatório Gráfico
@author Fernando B. Zapponi
@since 16/08/2016
@version 1.0
/*/
//------------------------------------------------------------------------------------------

User Function GPER0401

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
	
	oPrinter := FWMSPrinter():New("GPER004.rel", IMP_PDF, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
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
	

	oPrinter:StartPage()

	// Desenha o Box do Cabecalho e Logo
	If SM0->M0_CODIGO != "02"
		oPrinter:SayBitmap(075+nAjuste, 0145, _cFileLogo, 0500, 0150) //Tamanho da Imagem: 134 x 61
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
		
		// TITULO                                                                                                                                     
		oPrinter:Say ( 110+nAjuste, 1000, "SEGURO DE VIDA", oFont122, 100)   
		
		// EMPRESA
		oPrinter:Say ( 450+nAjuste, 0200, 'Empresa:' + SM0->M0_NOMECOM, oFont12, 100)   
		oPrinter:Say ( 500+nAjuste, 0200, 'CNPJ: ' + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"), oFont12, 100)
		
		// SAUDACAO
		oPrinter:Say ( 600+nAjuste, 0200, iif( alltrim(SRA->RA_SEXO) == "M", "Ao Senhor, ", "A Senhora, "  ), oFont12n, 100)
		
		// FUNCIONARIO
		oPrinter:Say ( 700+nAjuste, 0200, 'Funcionário: '+ allTrim(SRA->RA_NOME), oFont12, 100)   
		oPrinter:Say ( 750+nAjuste, 0200, 'Matrícula: '+ allTrim(SRA->RA_MAT), oFont12, 100) 
		oPrinter:Say ( 800+nAjuste, 0200, 'CPF: ' + Transform(SRA->RA_CIC,"@R 999.999.999-99"), oFont12, 100) 
		oPrinter:Say ( 850+nAjuste, 0200, 'Data de Nascimento: ' + Dtoc(SRA->RA_NASC), oFont12, 100)  
		
		// ASSUNTO
		oPrinter:Say (1050+nAjuste, 0400, "Assunto: SEGURO DE VIDA." , oFont12, 100)
		
		// CONTEUDO
		oPrinter:Say (1150+nAjuste, 0400, "A empresa disponibiliza o benefício de Seguro de Vida pela " , oFont12, 100)
		oPrinter:Say (1150+nAjuste, 1350, "Metlife Grupo Vg " , oFont12n, 100)
		oPrinter:Say (1200+nAjuste, 0200, "que anualmente terá o seu valor reajustado.  Informamos que fica a sua disposição aderir este benefício, " , oFont12, 100)
		oPrinter:Say (1250+nAjuste, 0200, "sendo que, uma vez aderindo não poderá cancelar nem no presente e nem no futuro." , oFont12, 100)
		oPrinter:Say (1300+nAjuste, 0400, "Estando ciente disso autorizo de livre e espontânea vontade, conforme o enunciado TST  nº " , oFont12, 100)
		oPrinter:Say (1350+nAjuste, 0200, "342, a descontar em meu contra-cheque mensalmente a minha adesão conforme opção escolhida abaixo:" , oFont12, 100)
		
		oPrinter:Say (1450+nAjuste, 0400, "(  ) Aceito este benefício." , oFont12, 100)
		oPrinter:Say (1500+nAjuste, 0400, "(  ) Não aceito este benefício." , oFont12, 100)
		
		// LOCAL 
		oPrinter:Say (1700+nAjuste, 0200, "Ciente, ", oFont12, 100)
		oPrinter:Say (1900+nAjuste, 0200, _cEstado + Dtoc(dDataBase), oFont12, 100)
		
		// LINHA DE ASSINATURA.
		oPrinter:Say (2000+nAjuste, 0200, Replicate("_",40), oFont12, 100)   
		oPrinter:Say (2050+nAjuste, 0200, allTrim(SRA->RA_NOME), oFont12, 100)   
		oPrinter:Say (2100+nAjuste, 0200, "Funcionário", oFont09, 100) 
		
		nAjuste += 1600
	
    Next
	
	oPrinter :EndPage()
	oPrinter :Preview()
	
Return  
