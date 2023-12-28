#Include "MsOle.ch"
#Include "Report.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"
#Include "Protheus.ch"

#Include "RPTDEF.CH"
#Include "FWPrintSetup.ch"                       

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} CSGPER05

Opção de Vale Transporte

@author Fernando B. Zapponi
@since 29/08/2016
@version 1.0
/*/
//------------------------------------------------------------------------------------------

User Function CSGPER05()

	Private cAlias	:= "SRA"
	Private aRotina := {{'Pesquisar', 'AxPesqui', 0, 1}, {'Opção de Vale Transporte', 'u_GPER0501', 0, 2}}
	Private cCadastro := "Cadastro de Funcionários" 
	Private _cCodFil := cFilAnt   
	
	dbSelectArea(cAlias)        
	dbSetOrder(1)    
	
	Set Filter To SRA->RA_FILIAL = _cCodFil .and. (SRA->RA_CATFUNC = 'M' .or. SRA->RA_CATFUNC = 'H')
	
	mBrowse( 6, 1,22,75,cAlias,, ) 
	
	Set Filter To
	
Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} GPER0501
Impressão do relatório Gráfico
@author Fernando B. Zapponi
@since 16/08/2016
@version 1.0
/*/
//------------------------------------------------------------------------------------------

User Function GPER0501

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
	
	oPrinter := FWMSPrinter():New("GPER005.rel", IMP_PDF, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
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
	Local _cTitulo	:= ""
	

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
	
	// REGUA DE TESTE
	/*
	oPrinter:Say ( 0+nAjuste, 0000, "A" , oFont12, 100) 
	oPrinter:Say ( 0+nAjuste, 0100, "B" , oFont12, 100) 
	oPrinter:Say ( 0+nAjuste, 0200, "C" , oFont12, 100) 
	oPrinter:Say ( 0+nAjuste, 0300, "D" , oFont12, 100) 
	oPrinter:Say ( 0+nAjuste, 0400, "E" , oFont12, 100)
	oPrinter:Say ( 0+nAjuste, 0500, "F" , oFont12, 100)
	oPrinter:Say ( 0+nAjuste, 0600, "G" , oFont12, 100)
	oPrinter:Say ( 0+nAjuste, 0700, "H" , oFont12, 100)
	oPrinter:Say ( 0+nAjuste, 0800, "I" , oFont12, 100)
	oPrinter:Say ( 0+nAjuste, 0900, "J" , oFont12, 100)
	oPrinter:Say ( 0+nAjuste, 1000, "K" , oFont12, 100)
	oPrinter:Say ( 0+nAjuste, 1100, "L" , oFont12, 100)
	oPrinter:Say ( 0+nAjuste, 1200, "M" , oFont12, 100) 
	*/
	
	For i:= 1 To 1
		
		// TITULO   
		oPrinter:Say ( 110+nAjuste, 0900, "OPÇÃO PELO VALE-TRANSPORTE" , oFont122, 100)   
		
		// EMPRESA
		oPrinter:Say ( 450+nAjuste, 0200, 'Empresa:' + SM0->M0_NOMECOM, oFont12, 100)   
		oPrinter:Say ( 500+nAjuste, 0200, 'CNPJ: ' + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"), oFont12, 100)
		
		// FUNCIONARIO
		oPrinter:Say ( 600+nAjuste, 0200, 'Funcionário: '+ allTrim(SRA->RA_NOME), oFont12, 100)   
		oPrinter:Say ( 650+nAjuste, 0200, 'Matrícula: '+ allTrim(SRA->RA_MAT), oFont12, 100) 
		oPrinter:Say ( 700+nAjuste, 0200, "CTPS: "+ allTrim(SRA->RA_NUMCP) +" - "+" "+ allTrim(SRA->RA_UFCP) +"", oFont12, 100)
		
		oPrinter:Say ( 850+nAjuste, 0200, "O Vale-Transporte é um direito do trabalhador. Faça sua opção por recebê-lo ou não, assinando uma " , oFont12, 100)
		oPrinter:Say ( 900+nAjuste, 0200, "das opções abaixo:" , oFont12, 100)
		oPrinter:Say ( 950+nAjuste, 0200, "(  ) SIM." , oFont12, 100)
		oPrinter:Say (1000+nAjuste, 0200, "(  ) NÃO." , oFont12, 100)
		
		// DECLARAÇÃO
		oPrinter:Say (1050+nAjuste, 1000, "DECLARAÇÃO", oFont122, 100)  
		
		// CONTEUDO
		oPrinter:Say (1150+nAjuste, 0200, "Para fazer uso do sistema do Vale-Transporte, declaro: " , oFont12, 100)
		oPrinter:Say (1200+nAjuste, 0200, "1 - Residir no endereço: " + allTrim(SRA->RA_ENDEREC) +","+ allTrim(SRA->RA_COMPLEM) +" - "+ allTrim(SRA->RA_BAIRRO) +" - "+ allTrim(SRA->RA_MUNICIP) +" - "+ allTrim(SRA->RA_ESTADO), oFont12, 100)
		oPrinter:Say (1250+nAjuste, 0200, "Utilizando diariamente:  conduções para locomover-me de minha residência ao trabalho e vice-versa  " , oFont12, 100)
		oPrinter:Say (1300+nAjuste, 0200, "com o valor unitário: R$ " + valorVale(SRA->RA_FILIAL, SRA->RA_MAT) , oFont12, 100)
		
		// DECLARAÇÃO
		oPrinter:Say (1550+nAjuste, 0600, "TERMO DE COMPROMISSO / AUTORIZAÇÃO PARA DESCONTO", oFont122, 100)  

		
		// TERMO - CONTEÚDO 
		oPrinter:Say (1700+nAjuste, 0200, "        Comprometo-me a atualizar as informações anualmente ou sempre que ocorram" , oFont12, 100)
		oPrinter:Say (1750+nAjuste, 0200, "alterações,  e utilizar os Vales-Transportes que me forem concedidos exclusivamente no percurso " , oFont12, 100)
		oPrinter:Say (1800+nAjuste, 0200, "residência-trabalho e vice-versa." , oFont12, 100)
		oPrinter:Say (1850+nAjuste, 0200, "        Estou ciente de que, na hipótese de infringir tal compromisso, a empresa poderá dispensar-me " , oFont12, 100)
		oPrinter:Say (1900+nAjuste, 0200, "por justa causa, nos termos do art. 7º parágrafo 3º do decreto nº 95247/87." , oFont12, 100)
		oPrinter:Say (1950+nAjuste, 0200, "        Autorizo a empresa descontar mensalmente de meus vencimentos, até o limite de 6% (seis " , oFont12, 100)
		oPrinter:Say (2000+nAjuste, 0200, "por cento) do meu salário, o valor destinado a cobrir o fornecimento de Vales -Transportes por mim " , oFont12, 100)
		oPrinter:Say (2050+nAjuste, 0200, "utilizados." , oFont12, 100)
		
		// LOCAL 
		oPrinter:Say (2200+nAjuste, 0200, "Ciente, ", oFont12, 100)
		oPrinter:Say (2400+nAjuste, 0200, _cEstado + Dtoc(dDataBase), oFont12, 100)
		
		// LINHA DE ASSINATURA.
		oPrinter:Say (2500+nAjuste, 0200, Replicate("_",40), oFont12, 100)   
		oPrinter:Say (2550+nAjuste, 0200, allTrim(SRA->RA_NOME), oFont12, 100)   
		oPrinter:Say (2600+nAjuste, 0200, "Funcionário", oFont09, 100) 
		
		nAjuste += 1600
	
    Next
	
	oPrinter :EndPage()
	oPrinter :Preview()
	
Return  

Static Function valorVale(filial, matricula)
	
    Local _cQry          := '' 
    Local _cQryObs       := ''
    Local  EOL           := Chr(13)+Chr(10) 
	
	Local _nQtd				:= 0
	Local _nValor			:= 0
	Local _nTotal			:= 0
	Local _cDesc			:= ""
	Local _cTexto			:= ""
	
	_cQry := ""
    
    _cQry += " SELECT                                                        "+EOL
    _cQry += "     R0_QDIAINF, RN_DESC, RN_VUNIATU                           "+EOL
    _cQry += " FROM                                                          "+EOL
    _cQry += "     SR0010 R0 ,                                    				"+EOL
    _cQry += "     SRN010 RN                                     				"+EOL
    _cQry += " WHERE                                                         "+EOL
    _cQry += "         R0_FILIAL = '_filial_' AND R0_MAT = '_matricula_'    	"+EOL
    _cQry += "     AND R0_CODIGO = RN_COD  											"+EOL
    _cQry += "     AND R0.D_E_L_E_T_ = ' ' AND RN.D_E_L_E_T_ = ' '           "+EOL
    
    _cQry := StrTran( _cQry, 'SR0010'        	, Retsqlname("SR0")	)
    _cQry := StrTran( _cQry, 'SRN010'        	, Retsqlname("SRN")	)
    _cQry := StrTran( _cQry, '_filial_'    	, filial            	)
    _cQry := StrTran( _cQry, '_matricula_'	, matricula         	)
    
    // _cQryObs     := EOL + " /* Consulta gerada por " + cUserName + " em " + Dtoc(Date()) +" às "+ Time() + " */                                         " + EOL + EOL

    // MemoWrite("\SQL\CNFAIXA.sql",_cQryObs + _cQry)

    If Select("QRYVALE") > 0
        DbSelectArea("QRYVALE")
        QRYVALE->(DbCloseArea())
    Endif
    
    //Criar alias temporário
    TCQUERY _cQry NEW ALIAS QRYVALE
    
    DbSelectArea("QRYVALE")
    QRYVALE->(DBGotop())   
    _lRet := QRYVALE->(EOF())

    If !_lRet    
         
        While QRYVALE->(!EOF())  

            _nQtd 	:= 			QRYVALE->R0_QDIAINF 
            _nValor :=			QRYVALE->RN_VUNIATU 
            _cDesc 	:= allTrim(QRYVALE->RN_DESC)
            
            _nTotal	:= _nTotal + (_nQtd * _nValor)
            
            if empty(_cTexto)
            	_cTexto := 			"( "+ cvaltochar(_nQtd) +" x "+  _cDesc 
            else 
            	_cTexto := _cTexto + " + "+ cvaltochar(_nQtd) +" x "+  _cDesc 
            endif

            QRYVALE->(dbskip())
        
        EndDo

    EndIf     
    
    QRYVALE->(DbCloseArea()) 
    
    if empty(_cTexto)
    	_cTexto := "(Não informado)"
    else
    	_cTexto := _cTexto + ")" 
    endif
    
    _nTotal	:= cvaltochar(_nTotal)
    _cTexto := _nTotal + " ao dia "+ _cTexto
	
Return _cTexto

