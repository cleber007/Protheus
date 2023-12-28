#Include "MsOle.ch"
#Include "Report.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"
#Include "Protheus.ch"

#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"                       

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} CSGPER02

Relatório de Aviso Prévio Trabalhado - Modelo 1 (+ de 1 ano)

@author Fernando B. Zapponi
@since 16/08/2016
@version 1.0
/*/
//------------------------------------------------------------------------------------------

User Function CSGPER02()

	Private cAlias	:= "SRA"
	Private aRotina := {{'Pesquisar', 'AxPesqui', 0, 1}, {'Aviso Prévio Trabalhado', 'u_GPER0201', 0, 2}}
	Private cCadastro := 'Aviso Prévio Trabalhado' 
	Private _cCodFil := cFilAnt   
	                                       
	dbSelectArea(cAlias)        
	dbSetOrder(1)    
	
	Set Filter To SRA->RA_FILIAL = _cCodFil .and. SRA->RA_CATFUNC = 'M'
	
	mBrowse( 6, 1,22,75,cAlias,, ) 
	
	Set Filter To
	
Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} GPER0201
Impressão do relatório Gráfico
@author Fernando B. Zapponi
@since 16/08/2016
@version 1.0
/*/
//------------------------------------------------------------------------------------------

User Function GPER0201

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
	
	oPrinter := FWMSPrinter():New("CSGPER02.rel", IMP_PDF, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
	oPrinter:cPathPDF := "c:\relato\"
	oPrinter:SetPortrait() 
	
	// Chama a Função de Geração do Relatório
	Processa({|| RunRelat() },"Gerando "+cCadastro)
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
@since 16/08/2016
@version 1.0
/*/
//------------------------------------------------------------------------------------------	
Static Function RunRelat()

	Local _lPerg
	Local _cLocal 	:= "Local não localizado"
	Local _cEndSind 	:= "Endereço não localizado"
	Local _cEstado 	:= "UF não localizada"
	Local nAjuste		:= 100

	oPrinter:StartPage()

	// Desenha o Box do Cabecalho e Logo
	If SM0->M0_CODIGO != "02"
		oPrinter:SayBitmap(075+nAjuste,0145,_cFileLogo,0500,0150) //Tamanho da Imagem: 134 x 61
	EndIF
    
	
	// Empresa 01
	If SM0->M0_CODIGO == "01"
	
		If _cCodFil == "01"
			_lPerg := MsgYesNo("Deseja imprimir o endereço do sindicato?")
			_cEstado := "Brasília - DF, "
			if _lPerg
				_cLocal := "Solicitamos o seu comparecimento no Sindicato dos Trabalhadores nas Indústrias de Alimentos do DF no "
				_cEndSind := "QND 13 lt 07 sala 205 Av Comercial Norte, Taguatinga-DF."
			else
				_cLocal := "Comparecer a "+ alltrim(SM0->M0_NOMECOM) +" no "
				_cEndSind := "QS 09 Rua 100, Lote 4, Águas Claras - DF"
			EndIf
		EndIf
		
		If _cCodFil == "02"
			_lPerg := MsgYesNo("Deseja imprimir o endereço do sindicato?")
			_cEstado := "Goiânia - Go, "
			if _lPerg
				_cLocal := "Solicitamos o seu comparecimento no Sindicato dos Trabalhadores nas Indústrias de Alimentos do GO no "
				_cEndSind := "Rua 12A N.235, Setor Aeroporto, Goiânia - GO."
			else
				_cLocal := "Solicitamos o seu comparecimento na Empresa "+ alltrim(SM0->M0_NOMECOM) +" no "
				_cEndSind := "Rodovia BR. 153 Área Complementar, Km. 1/5 - Fazenda Botafogo - Goiânia - GO."
			EndIf
		EndIf
	
	EndIf
	
	// Empresa 02
	If SM0->M0_CODIGO == "02"
	 
		If _cCodFil == "01"
			_lPerg := MsgYesNo("Deseja imprimir o endereço do sindicato?")
			_cEstado := "Brasília - DF, "
			if _lPerg
				_cLocal := "Comparecer ao Sindicato dos Vendedores Viajantes do DF"
				_cEndSind := "SIA Trecho 03, Lote 625/695, Sala 201, Prédio SENAC - Brasília - DF "
			else
				_cLocal := "Comparecer a "+ alltrim(SM0->M0_NOMECOM) +" no "
				_cEndSind := "QS 09 Rua 100, Lote 4, Águas Claras - DF"
			EndIf
		EndIf
	
	EndIF
	
	For i:= 1 To 1
	    
		//oPrinter:SayBitmap( 080+nAjuste, 100,"C:\TEMP\CDS.BMP",300,100 ) 
		                                                                                                                                     
		oPrinter:Say ( 110+nAjuste,0800, "AVISO PRÉVIO TRABALHADO", oFont122,100)   
		
		oPrinter:Say ( 350+nAjuste,0200, 'Empresa:' + SM0->M0_NOMECOM, oFont12,100)   
		//oPrinter:Say ( 350+nAjuste,0310, SM0->M0_NOMECOM, oFont12n,100)   
		//oPrinter:Say ( 400+nAjuste,0310, Trim(SM0->M0_ENDCOB)+" "+Trim(SM0->M0_BAIRCOB)+" "+Trim(SM0->M0_COMPCOB)+" "+Trim(SM0->M0_CIDCOB)+"-"+Trim(SM0->M0_ESTCOB), oFont12n,100)   
		oPrinter:Say ( 400+nAjuste,0200, 'CNPJ: ' + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"), oFont12,100)
		//oPrinter:Say ( 400+nAjuste,0310, SM0->M0_CGC, oFont12n,100)   
		
		oPrinter:Say ( 550+nAjuste,0200, 'Funcionário: '+ allTrim(SRA->RA_NOME), oFont12,100)   
		//oPrinter:Say ( 500+nAjuste,0310, SRA->RA_NOME, oFont12n,100)   
		//oPrinter:Say ( 600+nAjuste,0200, 'Matrícula: '+ SRA->RA_MAT, oFont12,100)   
		//oPrinter:Say ( 550+nAjuste,0280, SRA->RA_MAT, oFont12n,100)   
		oPrinter:Say ( 600+nAjuste,0200, 'C.T.P.S.: ' + allTrim(SRA->RA_NUMCP) + '/' + allTrim(SRA->RA_SERCP) + ' - ' + allTrim(SRA->RA_UFCP), oFont12,100)   
		//oPrinter:Say ( 550+nAjuste,0630, SRA->RA_NUMCP+"-"+SRA->RA_UFCP, oFont12n,100)   
		oPrinter:Say ( 650+nAjuste,0200, 'Admitido: ' + Dtoc(SRA->RA_ADMISSA), oFont12,100)   
		//oPrinter:Say ( 550+nAjuste,1230, Dtoc(SRA->RA_ADMISSA), oFont12n,100)   
		//oPrinter:Say ( 550+nAjuste,1700, "PIS:", oFont12,100)   
		//oPrinter:Say ( 550+nAjuste,1780, SRA->RA_PIS, oFont12n,100)   
		
		oPrinter:Say ( 0850+nAjuste,0200, "Vimos por meio desta comunicar que a 30 (Trinta) dias a contar do dia seguinte a essa comunicação, será" , oFont12,100)
		oPrinter:Say ( 0900+nAjuste,0200, "rescindido seu contrato de trabalho, servindo a presente como aviso prévio estabelecido na Legislação", oFont12,100)   
		oPrinter:Say ( 0950+nAjuste,0200, "Trabalhista em vigor.", oFont12,100)   
		
		// LOCAL 
		oPrinter:Say ( 1050+nAjuste,0200, _cLocal, oFont12,100)
		oPrinter:Say ( 1100+nAjuste,0200, "No endereço "+ _cEndSind, oFont12,100)
		oPrinter:Say ( 1150+nAjuste,0200, "dia  _____ / _____ / _____ às _____ horas, para dar cumprimento às", oFont12,100)
		oPrinter:Say ( 1200+nAjuste,0200, "formalidades exigidas para a Rescisão do Contrato de Trabalho.",oFont12,100) 
		
		oPrinter:Say ( 1350+nAjuste,0200, "Sem mais, solicitando seu ciente abaixo, firmamo-nos, ", oFont12,100)
		
		// ESTADO
		oPrinter:Say ( 1500+nAjuste,0200, _cEstado + Dtoc(dDataBase), oFont12,100)   
		
		oPrinter:Say ( 1700+nAjuste,0200, Replicate("_",40), oFont12,100)   
		oPrinter:Say ( 1750+nAjuste,0200, allTrim(SM0->M0_NOMECOM), oFont12,100)   
		oPrinter:Say ( 1790+nAjuste,0200, "Empregador", oFont09i,100)   
		
		oPrinter:Say ( 2000+nAjuste,0200, "Ciente, ", oFont12,100)
		
		oPrinter:Say ( 2250+nAjuste,0200, Replicate("_",40), oFont12,100)   
		oPrinter:Say ( 2300+nAjuste,0200, allTrim(SRA->RA_NOME), oFont12,100)   
		oPrinter:Say ( 2340+nAjuste,0200, "Funcionário", oFont09,100) 
		
		oPrinter:Say ( 2450+nAjuste,0200, "OPÇÃO DE CUMPRIMENTO DE AVISO PRÉVIO", oFont12n,100)
		oPrinter:Say ( 2550+nAjuste,0200, "[   ] Desejo Trabalhar durante todo o prazo do aviso, com redução de 02 horas", oFont12,100)
		oPrinter:Say ( 2600+nAjuste,0200, "      diárias na minha jornada de trabalho.", oFont12,100)
		
		oPrinter:Say ( 2700+nAjuste,0200, "[   ] Desejo Trabalhar durante 23 dias em horário normal e ter os últimos 07", oFont12,100)
		oPrinter:Say ( 2750+nAjuste,0200, "      dias do prazo de aviso prévio indenizado.", oFont12,100)
		  
		  
		/*
		oPrinter:Say ( 1350+nAjuste,1400, Replicate("_",40), oFont12,100)   
		oPrinter:Say ( 1390+nAjuste,1400, "Responsável em caso de Menor", oFont12,100)   
		
		If nAjuste = 0 
			oPrinter:Say ( 1500+nAjuste,100, Replicate("_ ",100), oFont12,100)   
		Endif
		*/
		/*
		oPrinter:Say ( 1500+nAjuste,0200, Replicate(" - ",100), oFont12,100)
		
		oPrinter:Say ( 1700+nAjuste,0650, "DECLARAÇÃO", oFont122,100)
		
		oPrinter:Say ( 1900+nAjuste,0200, "Vimos comunicar-lhe que decidimos rescindir, a partir desta data, seu Contrato de Trabalho em vigor desde: ", oFont12,100)
		oPrinter:Say ( 1950+nAjuste,1780, Dtoc(SRA->RA_ADMISSA) + '.', oFont12,100)   
		oPrinter:Say ( 2000+nAjuste,0200, "Solicitamos seu comparecimento, de posse da C.T.P.S. e do exame médico demissional (previsto na OS/SFT/SST/DF No. 01/96), NO SINDICATO DA CLASSE ", oFont12,100)   
		oPrinter:Say ( 2050+nAjuste,0200, "DIA ____/_____/2014 para dar cumprimento as formalidades exigidas para a Rescisão do Contrato de Trabalho.", oFont12,100)   
		*/
		
		
		nAjuste += 1600
	
    Next
	
	oPrinter :EndPage()
	oPrinter :Preview()
	
Return  
