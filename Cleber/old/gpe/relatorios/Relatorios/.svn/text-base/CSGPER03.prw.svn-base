#Include "MsOle.ch"
#Include "Report.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"
#Include "Protheus.ch"

#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"                             


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} CSGPER03

Carta de apresentação.

@author Fernando B. Zapponi
@since 18/08/2016
@version 1.0
/*/
//------------------------------------------------------------------------------------------

User Function CSGPER03()

	Private cAlias	:= "SRA"
	Private aRotina := {{'Pesquisar', 'AxPesqui', 0, 1}, {'Carta de Apresentação', 'u_GPER0301', 0, 2}}
	Private cCadastro := "Cadastro de Funcionários" 
	Private _cCodFil := cFilAnt   
	                                       
	dbSelectArea(cAlias)        
	dbSetOrder(1)    
	
	Set Filter To SRA->RA_FILIAL = _cCodFil .and. (SRA->RA_CATFUNC = 'M' .or. SRA->RA_CATFUNC = 'H')
	
	mBrowse( 6, 1,22,75,cAlias,, ) 
	
	Set Filter To
	
Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} GPER0301
Impressão do relatório Gráfico
@author Fernando B. Zapponi
@since 16/08/2016
@version 1.0
/*/
//------------------------------------------------------------------------------------------

User Function GPER0301

	Private lAdjustToLegacy 	:= .T.
	Private lDisableSetup  	:= .T.
	Private oPrinter
	Private cLocal          	:= ""
	Private lGeraRel			:= .T.
	Private _cFileLogo 		:= '\logos\logo.bmp'
		
	oFont08 := TFont():New( "Arial",,08,,.F.,,,,,.f.)
	oFont09 := TFont():New( "Arial",,09,,.F.,,,,,.f.)
	oFont09i:= TFont():New( "Arial",,09,,.F.,,,,.T.,.f.)
	oFont09n:= TFont():New( "Arial",,09,,.T.,,,,,.f.)
	oFont10 := TFont():New( "Arial",,14,,.F.,,,,,.f.)
	oFont10n:= TFont():New( "Arial",,10,,.T.,,,,,.f.)
	oFont12 := TFont():New( "Arial",,12,,.T.,,,,,.f.)
	oFont14 := TFont():New( "Arial",,14,,.F.,,,,,.F.) 
	oFont14n:= TFont():New( "Arial",,14,,.T.,,,,,.F.) 
	oFont162:= TFont():New( "Arial",,20,.T.,.T.,,,,,.T.)  
	oFont262:= TFont():New( "Arial",,26,.T.,.T.,,,,,.T.)  

	
	oPrinter := FWMSPrinter():New("CSGPER03.rel", IMP_PDF, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
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
@since 18/08/2016
@version 1.0
/*/
//------------------------------------------------------------------------------------------	
Static Function RunRelat()

	Local _cEstado 	:= "UF não localizada"
	Local nAjuste		:= 100
		
	cDescFunc := Posicione("SRJ", 1, xFilial("SRJ") + SRA->RA_CODFUNC, "RJ_DESC")
	
	oPrinter:StartPage()
	
	// Desenha o Box do Cabecalho e Logo
	If SM0->M0_CODIGO != "02"
		oPrinter:SayBitmap(075+nAjuste,0145,_cFileLogo,0500,0150) //Tamanho da Imagem: 134 x 61
	EndIF
	
	nAjuste := 0
	
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
	
	For i:= 1 To 2
	    
		//oPrinter:SayBitmap( 080+nAjuste, 100,"C:\TEMP\CABE.BMP",300,100 ) 
		                                                                                                                                     
		oPrinter:Say ( 500+nAjuste,0850, "CARTA DE APRESENTAÇÃO", oFont162,100) 
		
		oPrinter:Say ( 900+nAjuste,0200, "Declaramos para os devidos fins que, "+ allTrim(SRA->RA_NOME) +" portador(a) da CTPS: "+ allTrim(SRA->RA_NUMCP) +"-"+ allTrim(SRA->RA_SERCP) +" - "+" "+ allTrim(SRA->RA_UFCP) +"", oFont14,100)   
		oPrinter:Say ( 980+nAjuste,0200, "foi nosso(a) empregado(a) no período de "+ dtoc(SRA->RA_ADMISSA)+ " a "+ dtoc (SRA->RA_DEMISSA) +" cuja a ultima função exercida foi, "+ allTrim(SRJ->RJ_DESC), oFont14,100)   
		oPrinter:Say ( 1060+nAjuste,0200,"não constando nada em nossos arquivos que possa desaboná-lo(a). ", oFont14,100)   
		//oPrinter:Say ( 1200+nAjuste,0200, "Declaramos outrossim, que o (a) mesmo (a) sempre se pautou pela pontualidade e honestidade em seu setor",oFont14,100)
		//oPrinter:Say ( 1280+nAjuste,0200, "de trabalho e digno de uma grande responsabilidade. ",oFont14,100)
		oPrinter:Say ( 1180+nAjuste,0200, "Sendo assim, não há documento que possa desabonar sua conduta profissional.",oFont14,100)
		oPrinter:Say ( 1280+nAjuste,0200, "Por ser verdade firmo e assino a presente declaração, dando fé e teor ao futuro que possa destinar.",oFont14,100)

		oPrinter:Say ( 1700+nAjuste,1000, _cEstado + Dtoc(dDataBase) +".", oFont14,100)   
			
		oPrinter:Say ( 2150+nAjuste,0180, Replicate("_",40), oFont14,100)   
		oPrinter:Say ( 2210+nAjuste,0180, SM0->M0_NOMECOM, oFont14,100)
		oPrinter:Say ( 2270+nAjuste,0180, "CNPJ: ", oFont14,100) 
		oPrinter:Say ( 2270+nAjuste,0310, Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"), oFont14,100)    
		
    Next
	
	oPrinter :EndPage()
	oPrinter :Preview()
	
Return          
