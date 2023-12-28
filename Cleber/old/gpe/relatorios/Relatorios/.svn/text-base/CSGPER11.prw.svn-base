#Include "MsOle.ch"
#Include "Report.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"
#Include "Protheus.ch"

#Include "RPTDEF.CH"
#Include "FWPrintSetup.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} CSGPER11

Contrato de Experiência

@author Fernando B. Zapponi	
@since 21/09/2016
@version 1.0
/*/
//------------------------------------------------------------------------------------------

User Function CSGPER11()

	Private cAlias	:= "SRA"
	Private aRotina := {{'Pesquisar', 'AxPesqui', 0, 1}, {'Contrato de Experiência', 'u_GPER1101', 0, 2}}
	Private cCadastro := "Cadastro de Funcionários"
	Private _cCodFil := cFilAnt
	
	dbSelectArea(cAlias)
	dbSetOrder(1)
	
	Set Filter To SRA->RA_FILIAL = _cCodFil .and. SRA->RA_CATFUNC = 'M'
	mBrowse( 6, 1,22,75,cAlias,, )
	
	Set Filter To
	
Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} GPER1101
Impressão do relatório Gráfico
@author Fernando B. Zapponi
@since 21/09/2016
@version 1.0
/*/
//------------------------------------------------------------------------------------------

User Function GPER1101

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
	
	oPrint := FWMSPrinter():New("CSGPER11.rel", IMP_PDF, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
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
@since 21/09/2016
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
	
	For i:= 1 To 1
	
		//oPrint:SayBitmap( 080+nAjuste, 100,_cFileLogo,300,100 ) 
	
		_cMat := SRA->RA_MAT
		_cFuncao := posicione("SRJ", 1, xFilial("SRJ") + SRA->RA_CODFUNC, "RJ_DESC")
		_cCodCBO := posicione("SRJ", 1, xFilial("SRJ") + SRA->RA_CODFUNC, "RJ_CODCBO")
		
		// TITULO                                                                                                                                     
		oPrint:Say (_nAltTit, 1000, "CONTRATO DE EXPERIÊNCIA", oArial14N, 100) ; _nAltTit += _nAltLinha
		//oPrint:Say (_nAltTit, 1000, "", oArial14N, 100)   ; _nAltTit += _nAltLinha
		//oPrint:Say (_nAltTit, 1000, "", oArial14N, 100)   ; _nAltTit += _nAltLinha
		
		oPrint:Say ( 350+nAjuste,0170, 'Empregadora:' + SM0->M0_NOMECOM, oFonteTermo,100)
		//oPrint:Say ( 350+nAjuste,0310, SM0->M0_NOMECOM, oFonteTermon,100)   
		//oPrint:Say ( 400+nAjuste,0310, Trim(SM0->M0_ENDCOB)+" "+Trim(SM0->M0_BAIRCOB)+" "+Trim(SM0->M0_COMPCOB)+" "+Trim(SM0->M0_CIDCOB)+"-"+Trim(SM0->M0_ESTCOB), oFonteTermon,100)   
		oPrint:Say ( 400+nAjuste,0170, 'CNPJ: ' + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"), oFonteTermo,100)
		//oPrint:Say ( 400+nAjuste,0310, SM0->M0_CGC, oFonteTermon,100)   
		
		oPrint:Say ( 500+nAjuste,0170, 'Funcionário: '+ alltrim(SRA->RA_NOME), oFonteTermo,100)
		//oPrint:Say ( 500+nAjuste,0310, SRA->RA_NOME, oFonteTermon,100)   
		//oPrint:Say ( 600+nAjuste,0200, 'Matrícula: '+ SRA->RA_MAT, oFonteTermo,100)   
		//oPrint:Say ( 550+nAjuste,0280, SRA->RA_MAT, oFonteTermon,100)   
		oPrint:Say ( 550+nAjuste,0170, 'C.T.P.S.: ' + alltrim(SRA->RA_NUMCP) + '/' + allTrim(SRA->RA_SERCP) + ' - ' + allTrim(SRA->RA_UFCP), oFonteTermo,100)
		//oPrint:Say ( 550+nAjuste,0630, SRA->RA_NUMCP+"-"+SRA->RA_UFCP, oFonteTermon,100)   
		oPrint:Say ( 600+nAjuste,0170, 'Admissão: ' + Dtoc(SRA->RA_ADMISSA), oFonteTermo,100)
		//oPrint:Say ( 550+nAjuste,1230, Dtoc(SRA->RA_ADMISSA), oFonteTermon,100)   
		//oPrint:Say ( 550+nAjuste,1700, "PIS:", oFonteTermo,100)   
		//oPrint:Say ( 550+nAjuste,1780, SRA->RA_PIS, oFonteTermon,100) 
		
		
		
		// _cTexto1 := "Pelo presente instrumento, o funcionário "+allTrim(SRA->RA_NOME)+", devidamente inscrito no CPF sob o nº "+Transform(SRA->RA_CIC,"@R 999.999.999-99")+", portador do RG nº "+Alltrim(SRA->RA_RG)+"-"+AllTrim(SRA->RA_RGORG)+"/"+SRA->RA_RGUF+ " doravante denominado USUÁRIO, declara que recebe, em regime de detenção, aparelho celular e seus acessórios, para uso exclusivamente corporativo, de propriedade da empresa "+AllTrim(SM0->M0_NOMECOM)+", pessoa jurídica de direito privado, devidamente inscrita no CNPJ sob o nº "+ Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+", com endereço na QS 09, Rua 100, Lote nº 04, Águas Claras-DF, CEP 71.976-370, doravante denominada PROPRIETÁRIA, mediante os seguintes termos e condições."
		
		_nAltI := 700 + nAjuste
		
		_cTexto1 := "Pelo presente instrumento particular de Contrato de Experiência, as partes discriminadas acima celebram o presente Contrato Individual de Trabalho para fins de experiência, conforme Legislação Trabalhista em vigor, regido pelas cláusulas abaixo e demais disposições legais vigentes:"
		
		_nMemCount := MlCount( _cTexto1 ,_nLimite )
		_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
		For _nx:=1 to Len(_aTexto)
			oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
			_nAltI+=_nAltLinha
		Next _nx
		_nAltI+=_nAltLinha
		
		
		_cTexto1 := "1 - Fica  o  EMPREGADO  admitido  no quadro de funcionários da EMPREGADORA para exercer as funções de, "+  allTrim(_cFuncao) +" CBO No. "+ allTrim(_cCodCBO) +" mediante a remuneração de R$ "+ allTrim(Transform(SRA->RA_SALARIO,"@E 999,999,999.99")) +" ("+ allTrim(Extenso(SRA->RA_SALARIO)) +") por mês. A circunstância porém, de ser a função especificada não importa na intransferibilidade do EMPREGADO para outro serviço, no qual demonstre melhor capacidade de adaptação desde que compatível com sua condição pessoal."
		
		_nMemCount := MlCount( _cTexto1 ,_nLimite )
		_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
		For _nx:=1 to Len(_aTexto)
			oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
			_nAltI+=_nAltLinha
		Next _nx
		_nAltI+=_nAltLinha
		
		
		_cTexto1 := "2 - O horário de trabalho será anotado na sua ficha de registro e a eventual redução da jornada de trabalho, por determinação da EMPREGADORA, não inovará este ajuste, permanecendo sempre íntegra a obrigação do EMPREGADO em cumprir o horário que lhe for determinado, observando o limite legal."

		_nMemCount := MlCount( _cTexto1 ,_nLimite )
		_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
		For _nx:=1 to Len(_aTexto)
			oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
			_nAltI+=_nAltLinha
		Next _nx
		_nAltI+= _nAltLinha
		

		_cTexto1 := "3 - Obriga-se também o EMPREGADO a prestar serviços em horas extraordinárias, sempre que lhe for determinado pela EMPREGADORA, na forma prevista em Lei. Na hipótese desta faculdade pela EMPREGADORA, o EMPREGADO receberá as horas extraordinárias com o acréscimo legal, salvo a ocorrência de compensação com a conseqüente redução da jornada de trabalho em outro dia."

		_nMemCount := MlCount( _cTexto1 ,_nLimite )
		_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
		For _nx:=1 to Len(_aTexto)
			oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
			_nAltI+=_nAltLinha
		Next _nx
		_nAltI+= _nAltLinha


		_cTexto1 := "4 - Aceita o EMPREGADO expressamente a condição de prestar serviços em qualquer dos turnos de trabalho, isto é, tanto durante o dia, como à noite, desde que sem simultaneidade, observadas as prescrições legais reguladoras do assunto, quanto a remuneração."

		_nMemCount := MlCount( _cTexto1 ,_nLimite )
		_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
		For _nx:=1 to Len(_aTexto)
			oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
			_nAltI+=_nAltLinha
		Next _nx
		_nAltI+= _nAltLinha
		
		
		_cTexto1 := "5 - Fica ajustado nos termos que dispõe o §1 do artigo 469, da Consolidação das Leis do Trabalho, que o EMPREGADO acatará ordem emanada da EMPREGADORA para a prestação de serviços tanto naquela localidade de celebração do Contrato de Trabalho como em qualquer outra cidade, capital ou vila do território nacional, quer essa transferência seja transitória ou definitiva."

		_nMemCount := MlCount( _cTexto1 ,_nLimite )
		_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
		For _nx:=1 to Len(_aTexto)
			oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
			_nAltI+=_nAltLinha
		Next _nx
		_nAltI+= _nAltLinha		
		
		
		_cTexto1 := "6 - No ato da assinatura deste contrato, o EMPREGADO recebe o Regulamento Interno da Empresa cujas cláusulas fazem parte do Contrato de Trabalho, e a violação de qualquer delas implicará em sanção, cuja graduação dependerá da gravidade da mesma, culminando com a rescisão do contrato."

		_nMemCount := MlCount( _cTexto1 ,_nLimite )
		_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
		For _nx:=1 to Len(_aTexto)
			oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
			_nAltI+=_nAltLinha
		Next _nx
		_nAltI+= _nAltLinha		
		
		
		_cTexto1 := "7 - Em caso de dano causado pelo EMPREGADO, fica a EMPREGADORA autorizada a efetivar o desconto da importância correspondente ao prejuízo, o qual fará com fundamento no § único do artigo 462 da Consolidação das Leis do Trabalho, já que essa possibilidade fica expressamente prevista em Contrato."

		_nMemCount := MlCount( _cTexto1 ,_nLimite )
		_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
		For _nx:=1 to Len(_aTexto)
			oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
			_nAltI+=_nAltLinha
		Next _nx
		_nAltI+= _nAltLinha		
		
		
		_cTexto1 := "8 - O presente Contrato, terá vigência durante 45 (QUARENTA E CINCO) dias, sendo celebrado para as partes verificarem reciprocamente a conveniência ou não de se vincularem em caráter definitivo a um Contrato de Trabalho finalizando em "+ Dtoc(SRA->RA_VCTOEXP) +".  A EMPREGADORA passando a conhecer as aptidões do EMPREGADO e  suas qualidades pessoais e morais; o EMPREGADO verificando se o ambiente e os métodos de trabalho atendem a sua conveniência de serviço."

		_nMemCount := MlCount( _cTexto1 ,_nLimite )
		_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
		For _nx:=1 to Len(_aTexto)
			oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
			_nAltI+=_nAltLinha
		Next _nx
		_nAltI+= _nAltLinha		
		
		
		_cTexto1 := "9 - Opera-se a rescisão do presente Contrato pela decorrência do prazo supra ou por vontade de cada uma das partes. Rescindindo-se por vontade do EMPREGADO ou pela EMPREGADORA com justa causa, nenhuma indenização é devida. Rescindindo-se  antes do prazo, pela EMPREGADORA, fica esta obrigada a pagar 50% dos salários devidos até o final (metade do tempo combinado  restante), nos termos  do artigo 479 da Consolidação das Leis do Trabalho sem prejuízo no Regulamento do Fundo de Garantia por Tempo de serviço. Rescindindo-se antes do prazo, pelo EMPREGADO, fica este obrigado a pagar 50% dos salários devidos até o final (metade do tempo combinado restante), nos termos do artigo 480 da Consolidação das Leis do Trabalho, assim como o seu parágrafo primeiro. Nenhum aviso prévio é devido pela rescisão do presente Contrato."

		_nMemCount := MlCount( _cTexto1 ,_nLimite )
		_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
		For _nx:=1 to Len(_aTexto)
			oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
			_nAltI+=_nAltLinha
		Next _nx
		_nAltI+= _nAltLinha		
		
		
		_cTexto1 := "10 - Na hipótese deste ajuste transformar-se em prazo indeterminado, pelo decurso do tempo, continuarão em plena vigência as cláusulas de 1(um) a 7(sete), enquanto durarem as relações do EMPREGADO com a EMPREGADORA."

		_nMemCount := MlCount( _cTexto1 ,_nLimite )
		_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
		For _nx:=1 to Len(_aTexto)
			oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
			_nAltI+=_nAltLinha
		Next _nx
		_nAltI+= _nAltLinha		
		
	
		_cTexto1 := "        E por estarem de pleno acordo, as partes contratantes, assinam o presente Contrato de Experiência em duas vias, ficando a primeira em poder da EMPREGADORA, e a segunda com o EMPREGADO, que dela dará o competente recibo."

		_nMemCount := MlCount( _cTexto1 ,_nLimite )
		_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
		For _nx:=1 to Len(_aTexto)
			oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
			_nAltI+=_nAltLinha
		Next _nx
		_nAltI+= _nAltLinha		
		

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
		
		oPrint:Say (_nAltI, 0200, Replicate("_",40), oFonteTermo, 100)
		oPrint:Say (_nAltI, 1200, Replicate("_",40), oFonteTermo, 100)
		
		_nAltI+=_nAltLinha
		
		oPrint:Say (_nAltI, 0200, "Testemunha", oCourier10n, 100)
		oPrint:Say (_nAltI, 1200, "Testemunha", oCourier10n, 100)
		
		
		
		oPrint:StartPage()
		
		_nAltI := 450
		
		// TITULO                                                                                                                                     
		oPrint:Say (_nAltTit, 1000, "TERMO DE PRORROGAÇÃO", oArial14N, 100) ; _nAltTit += _nAltLinha
		
		
		_cTexto1 := "Por mútuo acordo entre as partes, fica o presente Contrato de Experiência, que deveria vencer na presente data, prorrogado por mais 45 (quarenta e cinco) dias, ficando seu término para "+ Dtoc(SRA->RA_VCTEXP2) +"."

		_nMemCount := MlCount( _cTexto1 ,_nLimite )
		_aTexto    := U_memoFormata( _cTexto1, _nLimite, _nMemCount )
		For _nx:=1 to Len(_aTexto)
			oPrint:Say ( _nAltI,0170, _aTexto[_nx] , oFonteTermo,100)
			_nAltI+=_nAltLinha
		Next _nx
		_nAltI+= _nAltLinha	
		
		
		// LOCAL 
		oPrint:Say (_nAltI, 0200, _cEstado + Dtoc(SRA->RA_VCTOEXP), oArial12n, 100) 
		_nAltI+=_nAltLinha * 2
		
		
		// LINHA DE ASSINATURA.
		oPrint:Say (_nAltI, 0200, Replicate("_",40), oFonteTermo, 100)
		oPrint:Say (_nAltI, 1200, Replicate("_",40), oFonteTermo, 100)
		
		_nAltI+=_nAltLinha 
		
		oPrint:Say (_nAltI, 0200, allTrim(SRA->RA_NOME), oFonteTermo, 100)
		oPrint:Say (_nAltI, 1200, AllTrim(SM0->M0_NOMECOM), oFonteTermo, 100)
		
		_nAltI+=_nAltLinha * 2
		
		oPrint:Say (_nAltI, 0200, Replicate("_",40), oFonteTermo, 100)
		oPrint:Say (_nAltI, 1200, Replicate("_",40), oFonteTermo, 100)
		
		_nAltI+=_nAltLinha
		
		oPrint:Say (_nAltI, 0200, "Testemunha", oCourier10n, 100)
		oPrint:Say (_nAltI, 1200, "Testemunha", oCourier10n, 100)
		
		

	Next
	
	oPrint :EndPage()
	oPrint :Preview()
	
Return