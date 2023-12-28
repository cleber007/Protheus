#include 'protheus.ch'

user Function DemPagSal()                          

Local cString := "SRA"        // alias do arquivo principal (Base)
Local aOrd    := {"Matricula","C.Custo + Matr.","Nome","C.Custo + Nome"} 
Local cDesc1  := cValtochar("Emissão de Recibos de Pagamento.")
Local cDesc2  := "Ser impresso de acordo com os parametros solicitados pelo"
Local cDesc3  := "usuario."
Local nExtra, cIndCond, cIndRc
Local Baseaux := "S"
Local cDemit  := "N"
Public _oPrint

Private aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }	//"Zebrado"###"Administração"
Private nomeprog := "RGPER01"
Private aLinha   := { },nLastKey := 2
Private cPerg    := "DEMPAG"
Private cSem_De  := "  /  /    "
Private cSem_Ate := "  /  /    "
Private nAteLim , nBaseFgts , nFgts , nBaseIr , nBaseIrFe
Private cCompac , cNormal
Private aDriver

Private aFunc    := {}
Private aProve   := {}
Private aDesco   := {}
Private aBases   := {}
Private aInfo    := {}
Private aCodFol  := {}
Private li       := _PROW()
Private Titulo   := "EMISSAO DE RECIBOS DE PAGAMENTOS"
Private nTamanho := "M"
Private limite	 := 132
    
fValidSX1(cPerg)

Pergunte("DEMPAG",.T.)
wnrel  := "RGPER01"            //Nome Default do relatorio em Disco
wnrel  := SetPrint(cString,wnrel   ,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,   ,nTamanho )
nOrdem :=  aReturn[8]


//Carregando variaveis mv_par?? para Variaveis do Sistema.  

dDataRef   := mv_par01                     	// Data Referencia
nTipRel    := 1                            	// Tipo de Impressão
Esc        := mv_par02
cFilDe     := mv_par03						//Filial De
cFilAte    := mv_par04						//Filial Ate
cCcDe      := mv_par05						//Centro de Custo De
cCcAte     := mv_par06						//Centro de Custo Ate
cMatDe     := mv_par07						//Matricula Des
cMatAte    := mv_par08						//Matricula Ate
cNomDe     := mv_par09						//Nome De
cNomAte    := mv_par10						//Nome Ate
Mensag11   := substr(mv_par11,1,1)			//Mensagem 1
Mensag12   := substr(mv_par11,2,1)			//Mensagem 1
Mensag21   := substr(mv_par12,1,1)			//Mensagem 2
Mensag22   := substr(mv_par12,2,1)			//Mensagem 1
Mensag31   := substr(mv_par13,1,1)			//Mensagem 3
Mensag32   := substr(mv_par13,2,1)			//Mensagem 1
Mensag4    := mv_par14						//Mensagem 3
Mensag5    := mv_par15						//Mensagem 3
cSituacao  := mv_par16						//Situacoes a Imprimir
cCategoria := mv_par17						//Categorias a Imprimir
cBaseAux   := If(mv_par18 == 1,"S","N")	//Imprimir Bases
cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
cAnoMesRef := StrZero(Year(dDataRef),4) + StrZero(Month(dDataRef),2)  
cAnoRef13  := StrZero(Year(dDataRef),4)

If aReturn[5] == 1 .and. nTipRel == 1
	li	:=  0
EndIf


//Inicializa Impressao
If !fInicia(cString,nTipRel)
	Return
Endif

RptStatus({|lEnd| R030ImpL(@lEnd,wnRel,cString,cMesAnoRef)},Titulo)  // Chamada do Relatorio

Return(  NIL )


//Processamento Para emissao do Recibo 
//R030Imp(lEnd,WnRel,cString,cMesAnoRef,lTerminal)

Static Function R030ImpL(lEnd,WnRel,cString,cMesAnoRef)


Local lIgual                 //Variavel de retorno na comparaão do SRC
Local cArqNew                //Variavel de retorno caso SRC # SX3
Local aOrdBag     := {}
Local cMesArqRef  := If(Esc == 4,"13"+Right(cMesAnoRef,4),cMesAnoRef)
Local cArqMov     := ""

Local cNroHoras   := &("{ || If(SRC->RC_QTDSEM > 0, SRC->RC_QTDSEM, SRC->RC_HORAS) }")
Local nHoras      := 0
Local nMes, nAno

Public cCodFunc	  := ""		//-- codigo da Funcao do funcionario
Public cDescFunc  := ""		//-- Descricao da Funcao do Funcionario
Public _n         := 1

Private aCodBenef   := {}
Private cDtPago
Private cAliasMov := ""
Private cPict1	  := "@E 999,999,999.99"
Private cPict2    := "@E 99,999,999.99"
Private cPict3    := "@E 999,999.99"

If MsDecimais(1) == 0
   cPict1	:=	"@E 99,999,999,999"
   cPict2 	:=	"@E 9,999,999,999"
   cPict3 	:=	"@E 99,999,999"
Endif

If Esc == 4
	cMesArqRef := "12" + Right(cMesAnoRef,4)
Else
	cMesArqRef := cMesAnoRef
Endif


//Verifica se existe o arquivo de fechamento do mes informado
/*
If !OpenSrc( cMesArqRef, @cAliasMov, @aOrdBag, @cArqMov, @dDataRef , NIL  )
	Return(  NIL  )
Endif
*/

//Selecionando a Ordem de impressao escolhida no parametro.    ³

dbSelectArea( "SRA")
If nOrdem == 1      // RA_FILIAL+RA_MAT
	dbSetOrder(1)
ElseIf nOrdem == 2  // RA_FILIAL+RA_CC+RA_MAT
	dbSetOrder(2)
ElseIf nOrdem == 3  // RA_FILIAL+RA_NOME+RA_MAT
	dbSetOrder(3)
ElseIf nOrdem == 4  // RA_FILIAL+RA_CC + RA_NOME
	dbSetOrder(8)
Endif
dbGoTop()

//Selecionando o Primeiro Registro e montando Filtro
If nOrdem == 1
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	dbSeek(cFilDe + cMatDe,.T.)
	cFim    := cFilAte + cMatAte
ElseIf nOrdem == 2
	dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 3
	dbSeek(cFilDe + cNomDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim    := cFilAte + cNomAte + cMatAte
ElseIf nOrdem == 4
	dbSeek(cFilDe + cCcDe + cNomDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME"
	cFim     := cFilAte + cCcAte + cNomAte
Endif

//Carrega Regua Processamento

dbSelectArea("SRA")
SetRegua(RecCount())	// Total de elementos da regua

aFunc      :={}         // Zera Lancamentos
aProve     :={}         // Zera Lancamentos
aDesco     :={}         // Zera Lancamentos
aBases     :={}         // Zera Lancamentos
aImpos     :={}         // Zera Lancamentos
DESC_MSG   :={}
FLAG       := 0
CHAVE      := 0
Desc_Fil   := Desc_End := DESC_CC:= DESC_FUNC:= ""
DESC_MSG1  := DESC_MSG2:= DESC_MSG3:= Space(01)
DESC_MSG4  := DESC_MSG5:= Space(62)
cFilialAnt := "  "
Vez        := 0
OrdemZ     := 0

Do While SRA->( !Eof() .And. &cInicio <= cFim )
	

    //Movimenta Regua Processamento                                
    IncRegua()  // Anda a regua
	
    If lEnd
 	   @Prow()+1,0 PSAY cCancel
	   Exit
    Endif
   
	
	//Consiste Parametrizacao do Intervalo de Impressao
	If (SRA->RA_NOME < cNomDe) .Or. (SRA->Ra_NOME > cNomAte) .Or. (SRA->RA_MAT < cMatDe) .Or. (SRA->Ra_MAT > cMatAte) .Or. ;
	   (SRA->RA_CC < cCcDe)    .Or. (SRA->Ra_CC > cCcAte)
	    SRA->(dbSkip(1))
	    Loop
	EndIf
	
	nAteLim   := 0.00 
	nBaseFgts := 0.00
	nFgts     := 0.00
	nBaseIr   := 0.00
	nBaseIrFe := 0.00
	Ordem_rel := 1     // Ordem dos Recibos
	

	//Verifica Data Demissao

	cSitFunc  := SRA->RA_SITFOLH
	dDtPesqAf := CTOD("01/" + Left(cMesAnoRef,2) + "/" + Right(cMesAnoRef,4))
	If cSitFunc == "D" .And. (!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA) > MesAno(dDtPesqAf))
		cSitFunc := " "
	Endif
	
	//Consiste situacao e categoria dos funcionarios
	If !( cSitFunc $ cSituacao ) .OR. !( SRA->RA_CATFUNC $ cCategoria )
		dbSkip()
		Loop
	Endif
	If cSitFunc $ "D" .And. Mesano(SRA->RA_DEMISSA) # Mesano(dDataRef)
		dbSkip()
		Loop
	Endif
	
	aArea	:= SRA->(GetArea())
	fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )
	cCodCBO	:= fCodCBO(xFilial("SRJ"),cCodFunc ,dDataRef)
	cDescCC	:= Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01")
	RestArea( aArea ) 
	
	
	//Adiciona dados do Funcionario
	aAdd(aFunc,{SRA->RA_MAT, Left(SRA->RA_NOME,28), cCodCBO, SRA->RA_CC, cDescCC,	SRA->RA_Filial, TRANSFORM(strzero(ORDEM_REL,3),"9999"),;
	cCodFunc, cDescFunc, SRA->RA_SALARIO, MONTH(SRA->RA_NASC),	Substr(Sra->Ra_BcDepSal,1,3), SRA->RA_BCDEPSAL, SRA->RA_CTDEPSAL})
 
	If SRA->RA_Filial # cFilialAnt
		If ! Fp_CodFol(@aCodFol,Sra->Ra_Filial) .Or. ! fInfo(@aInfo,Sra->Ra_Filial)
			Exit
		Endif
		Desc_Fil  := aInfo[3]
		Desc_End  := aInfo[4]         // Dados da Filial
		Desc_CGC  := aInfo[8]
		DESC_MSG1 := DESC_MSG2 := DESC_MSG3 := Space(01)
		DESC_MSG4 := DESC_MSG5 := Space(62)
		
		// MENSAGENS
		dbSelectArea("SRA")
		cFilialAnt := SRA->RA_FILIAL
	Endif
	
	//Adiciona Mensagens
	aAdd(DESC_MSG,{DESC_MSG1,DESC_MSG2,DESC_MSG3,DESC_MSG4,DESC_MSG5})
	dbSelectArea("SRA")	
	
	If nTipRel == 1
	   If Vez = 0  .and. nTipRel # 3  .and. aReturn[5] # 1
			//Descarrega teste de impressao
	   Endif
	Endif
	
	dbSelectArea("SRA")
	SRA->( dbSkip() )
	_TOTDESC := 0
	_TOTVENC := 0
	_n++
	
EndDo

// Impressao do Recibo de Pagamento
fImpressaoL()   


//Seleciona arq. defaut do Siga caso Imp. Mov. Anteriores      

If !Empty( cAliasMov )
	fFimArqMov( cAliasMov , aOrdBag , cArqMov )
EndIf


// Termino do relatorio                                         

dbSelectArea("SRC")
dbSetOrder(1)          // Retorno a ordem 1
dbSelectArea("SRI")
dbSetOrder(1)          // Retorno a ordem 1
dbSelectArea("SRA")
SET FILTER TO
RetIndex("SRA")

If !(Type("cArqNtx") == "U")
	fErase(cArqNtx + OrdBagExt())
Endif


Return

//IMRESSAO DO RECIBO
Static Function fImpressaoL()

Local nConta  	:= nContr := nContrT:=0
Local aDriver 	:= LEDriver()
Local _i        := 0
Local _aPos1    := {2000, 1900, 2100, 2300}
Local _aPos2    := {2270, 1900, 2340, 2300}
Local _aBmp 	:= {}
Local _aEmp 	:= {}
Local _oFont8   := Nil
Local _oFont10  := Nil
Local _oFont12  := Nil
Local _oFont16  := Nil
Local _oFont16n := Nil
Local _oFont24  := Nil
Local _oBrush   := Nil
Local cString   := ""
Local nCol 		:= 0
Local _lmesmo 	:= .F.
Local _cont		:= 0
Local _pag 		:= 0
Local y,z		:= 0

Private TOTVENC  := {}
Private TOTDESC  := {}
Private aLanca   := {}
Private aImpos   := {}
Private nLinhas	 := 30              // Numero de Linhas do Miolo do Recibo
Private cCompac  := aDriver[1]
Private cNormal  := aDriver[2]
Private _tipofol := ""
                              

Ordem_Rel := 1
_oPrint   := TMSPrinter():New( "Recibo Laser" )
_oPrint:SetPortrait() // ou SetLandscape()

// Fontes da Impressão   
_oFont6   := TFont():New("Courier", 09, 06,   ,.T.,  ,   ,  ,    , .F.)
_oFont8   := TFont():New("Courier", 09, 08,   ,.T.,  ,   ,  ,    , .F.)
_oFont9   := TFont():New("Courier", 09, 09,.T.,.F., 5,.T., 5, .T., .F.)
_oFont10  := TFont():New("Courier", 09, 10,.T.,.F., 5,.T., 5, .T., .F.)
_oFont12  := TFont():New("Courier", 09, 12,.T.,.F., 5,.T., 5, .T., .F.)
_oFont12n := TFont():New("Courier", 09, 12,.T.,.T., 5,.T., 5, .T., .F.)
_oFont16  := TFont():New("Courier", 09, 10,.T.,.F., 5,.T., 5, .T., .F.)
_oFont16n := TFont():New("Courier", 09, 10,.T.,.T., 5,.T., 5, .T., .F.)
_oFont24  := TFont():New("Courier", 09, 10,.T.,.T., 5,.T., 5, .T., .F.)
_oFontCP  := TFont():New("Arial", 09, 09,.T.,.T., 5,.T., 5, .T., .F.)
_oBrush   := TBrush():New("",rgb(224,224,244))

DEFINE PEN oPenCP WIDTH 3 COLOR CLR_GRAY

For _I := 1 TO Len(aFunc)
	
	aLanca    := {}  // Zera Lancamentos
	TOTVENC   := {}  // Zera Vencimentos
	TOTDESC   := {}  // Zera Descontos
	aImpos    := {}  // Zera Impostos
	
	llanca(aFunc[_I][1],aFunc[_I][4],aFunc[_I][6])//(matricula,centro de custo, filial)	
	Z         := 0
	_nctaz    := 1
	_MaxLin   := 20  // Maximo de Linhas nos Lancamentos //padrao 15 - david
	nDivisao  := ((Len(aLanca)) / _MaxLin) //retorna a qtd de pagina necessarias 
	_StopLanc := 0
	
	If Int(nDivisao) <> nDivisao // Calculo de numeros paginas necessarios para mostrar TODOS os lançamentos
		_pag := Int(nDivisao) + 1
	Else
		_pag := nDivisao
	Endif
	
	For y:= 1 to _pag  //- david limita a 1 pagina
		
		_cont := 0//-50  //MUDAR ESSA LINHA
		_oPrint:StartPage()   // Inicia uma nova página
		z:= 0
		//Imprime duas vezes na mesma página
		For z:= 1 to 2

			//Adiciona dados da Empresa e Filial do Funcionario
			dbSelectArea("SM0")
			dbSetOrder(1)
			dbSeek(cEmpAnt+aFunc[_I][6],.T.)
			
			//Carrega Funcao do Funcion. de acordo com a Dt Referencia
            
			fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )
			
			Do Case
			   Case MV_PAR02 = 1
				    _tipoFol:= "ADI"
			   Case MV_PAR02 = 2
			        _tipoFol:= "FOLHA"
			   Case MV_PAR02 = 3
			        _tipoFol:= "13 SAL. PARC. 1"
			   Case MV_PAR02 = 4
			        _tipoFol:= "13 SAL. PARC. 2"
			   Case MV_PAR02 = 5
			        _tipoFol:= "VALORES EXTRAS"
			EndCase  
			
			_oPrint:Box(_cont+0100,0130, _cont+0230, 2250) //ALTERADO DAVID _oPrint:Box(_cont+0100,0130, _cont+0230, 2250)  																// Primeiro Box 
			//_oPrint:fillRect( { _cont+0102,0132, _cont+0229.8, 2249.8}, _oBrush )
			_oPrint:Say(_cont+100, 0145, Alltrim(SM0->M0_NOMECOM)+"  -  "+"Demonstrativo de Pagamento de " + _tipoFol, _oFont8)															// Nome da Empresa
			//_oPrint:Say(_cont+100, 0950, "Demonstrativo de Pagamento de " + _tipoFol, _oFont8) 							// Titulo -  tirei 1625 - 625
			_oPrint:Say(_cont+140, 0145, Alltrim(SM0->M0_ENDCOB)+", "+AllTrim(SM0->M0_BAIRCOB)+ "- "+AllTrim(SM0->M0_CIDCOB)+"-"+SM0->M0_ESTCOB, _oFont8)						// Endereco da Empresa
			_oPrint:Say(_cont+140, 1850, "MÊS : " + MesExtenso(MONTH(dDataRef)) + " de "+ STR(YEAR(dDataRef),4), _oFont8)	// Mes da Folha
			_oPrint:Say(_cont+180, 0145, Transform(SM0->M0_CGC, "@R 99.999.999/9999-99"), _oFont8) 																// CNPJ
			
			If Z == 1
 			   _oPrint:Say(_cont+180, 1850, "2 - Via do Funcionário ", _oFont8) 	   											// Via 1
			Else            
 			   _oPrint:Say(_cont+180, 1850, "1 - Via da Empresa ", _oFont8)     											// Via 2
			Endif
			
		   	_oPrint:Box(_cont+0230, 0130, _cont+0400, 2250)																	// Segundo Box
		   	_oPrint:fillRect( { _cont+0232,0132, _cont+0399.8, 2249.8}, _oBrush )
			_oPrint:Say(_cont+0250, 0145, "Código", _oFont8)   																// Codigo
			_oPrint:Say(_cont+0250, 0290, "Nome do Funcionário", _oFont8)  													// Nome do Funcionario
			_oPrint:Say(_cont+0250, 0845, "CBO", _oFont8)      																// CBO
			_oPrint:Say(_cont+0250, 0995, "C.Custo", _oFont8)  																// C.Custo
			_oPrint:Say(_cont+0250, 1206, "Descrição C.Custo", _oFont8)  													// Descricao C.Custo
			_oPrint:Say(_cont+0250, 1995, "Emp.", _oFont8)               													// Empresa
			_oPrint:Say(_cont+0250, 2190, "Fl.", _oFont8)                													// Folha
			//----------------------------
			_oPrint:Say(_cont+0300, 0145, aFunc[_I][1], _oFont8)															// Codigo
			_oPrint:Say(_cont+0300, 0290, aFunc[_I][2], _oFont8)															// Nome do Funcionario
			_oPrint:Say(_cont+0300, 0845, aFunc[_I][3], _oFont8)															// CBO
			_oPrint:Say(_cont+0300, 0995, aFunc[_I][4], _oFont8)															// C.Custo
			_oPrint:Say(_cont+0300, 1206, alltrim(aFunc[_I][5]), _oFont8)													// Descricao C. Custo
			_oPrint:Say(_cont+0300, 2005, aFunc[_I][6], _oFont8)															// Empresa
			//_oPrint:Say(_cont+0300, 2190, strzero(y,3) , _oFont8)															// Folha
			_oPrint:Say(_cont+0300, 2190, (CVALTOCHAR(y)+"/"+CVALTOCHAR(_pag)) , _oFont8)															// Folha
			
			_oPrint:Say(_cont+0350, 0145, "Função : ", _oFont8)  															// Funcao
			_oPrint:Say(_cont+0350, 0290, aFunc[_I][8]+" - "+aFunc[_I][9], _oFont8)									    	// Codigo e Descricao
			
		   	_oPrint:Box(_cont+0400, 0130, _cont+1685, 2250)         														// Box dos lançamentos
			_oPrint:Line(_cont+0440, 0130, _cont+0440, 2250)        														// Horizontal do cabecalho dos lançamentos
		  //_oPrint:fillRect( { _cont+0403, 0132, _cont+0449.8, 2249.8}, _oBrush )
			_oPrint:Say(_cont+0405, 0145, "Cód.", _oFont8) 																	// Codigo
			_oPrint:Line(_cont+0440, 0250, _cont+1180, 0250)        														// Linha Vertical 1
			_oPrint:Say(_cont+0405, 0655, "Descrição", _oFont8)   															// Descricao
			_oPrint:Line(_cont+0440, 1155, _cont+1180, 1155)        														// Linha Vertical 2
			_oPrint:Say(_cont+0405, 1200, "Ref.", _oFont8)        															// Ref.
			_oPrint:Line(_cont+0440, 1300, _cont+1240, 1300)        														// Linha Vertical 3
			_oPrint:Say(_cont+0405, 1450, "Vencimentos", _oFont8)      														// Vencimentos
			_oPrint:Line(_cont+0440, 1800, _cont+1180, 1800)        														// Linha Vertical 4
			_oPrint:Say(_cont+0405, 1950, "Descontos", _oFont8)    														 	// Descontos
			
			//_W := 15
			_W 		:= 20
			_ncont	:= 0
			
			If Z == 1
			   If _StopLanc == 0
				  _nctaz  := 1   // Comeca imprimindo desde o PRIMEIRO lançamento
			   Else
			  	  _nCtaz  := _StopLanc
			   Endif
			Endif
			
			For nConta := _nctaz To Len(aLanca)
				If nConta <= iif(Y >= 2,(nlinhas + _nctaz), nlinhas)
				
				   _W      := (_W + 32) //DEFINE O ESPAÇO ENTRE AS LINHAS DAS VERBAS 
				   
				   cString := Transform(aLanca[nConta,5],cPict2)
				   nCol    := If(aLanca[nConta,1] = "P", 1430, If(aLanca[nConta,1] = "D", 1900, 0255))
					
				   _oPrint:Say((_cont+0415+_W), 0155, aLanca[nConta,2] , _oFont10)  											// Codigo da Verba
				   _oPrint:Say((_cont+0415+_W), 0255, aLanca[nConta,3] , _oFont10)  											// Nome da Verba
					
					If aLanca[nConta,1] # "B"        																		// So Imprime se nao for base
						If aLanca[nConta,4] <= 9.99
						//	_oPrint:Say(_cont+0415+_w, 1200, TRANSFORM(aLanca[nConta,4],"999.99"), _oFont9)
							_oPrint:Say((_cont+0415+_W), 1155, TRANSFORM(aLanca[nConta,4],"999.99"), _oFont10)  				// Referencia Horas
						Endif
						If aLanca[nConta,4] <= 99.99 .and. aLanca[nConta,4] > 9.99
							_oPrint:Say((_cont+0415+_W), 1155, TRANSFORM(aLanca[nConta,4],"999.99"), _oFont10)  				// Referencia Horas
						Endif
						If aLanca[nConta,4] <= 999.99 .and. aLanca[nConta,4] > 99.99
							_oPrint:Say((_cont+0415+_W), 1155, TRANSFORM(aLanca[nConta,4],"999.99"), _oFont10)  				// Referencia Horas
						Endif
					Endif
					
					If aLanca[nConta,5] <= 9.99
					   _oPrint:Say((_cont+0415+_W), (nCol-15), "R$ " + cString, _oFont10)
					Endif
					If aLanca[nConta,5] <= 99.99 .and. aLanca[nConta,5] > 9.99   											// Referencia Valor
						_oPrint:Say((_cont+0415+_W), (nCol-15), "R$ " + cString, _oFont10)
					Endif
					If aLanca[nConta,5] <= 999.99 .and. aLanca[nConta,5] > 99.99                                          // Referencia Valor
						_oPrint:Say((_cont+0415+_W), (nCol-15), "R$ " + cString, _oFont10)
					Endif
					If aLanca[nConta,5] <= 9999.99 .and. aLanca[nConta,5] > 999.99                                        // Referencia Valor
						_oPrint:Say((_cont+0415+_W), (nCol-15), "R$ " + cString, _oFont10)
					Endif
					If aLanca[nConta,5] <= 99999.99 .and. aLanca[nConta,5] > 9999.99                                      // Referencia Valor
						_oPrint:Say((_cont+0415+_W), (nCol-15),"R$ " +  cString, _oFont10)
					Endif
					
					nContr++
					nContrT++
					_nCont++
					
					//Tratamento da QUEBRA de PÁGINA
					//=======================================================================================================
	                //conout('_nCont: '+cvaltochar(_nCont))  
	                //conout('_MaxLin: '+cvaltochar(_MaxLin))
	                
				   	If _nCont == _MaxLin
						If Len(aLanca) > _nCont
							_W 		  := _W + 45
							_StopLanc := nConta + 1
							//_oPrint:Say(_cont+0400+_W, 0255, "CONTINUA !!!", _oFont6) 
							_oPrint:Say(_cont+400+_W, 0255, "CONTINUA !!!", _oFont6)
						Endif
						Exit
					Endif
					
				Endif
				
			Next nConta
			
			_cont += 80   //DAVID - ADICIONA MAIS NUMERAÇÃO NA LINHA PARA BAIXA
			
			If !_lmesmo .or. (Y >= 2 .and. _lmesmo)
				// Imprime Mensagens
				_oPrint:Say(_cont+1290, 0145, DESC_MSG[_I][1], _oFont8)
				_oPrint:Say(_cont+1310, 0145, DESC_MSG[_I][2], _oFont8)
				_oPrint:Say(_cont+1320, 0145, DESC_MSG[_I][3], _oFont8)
				IF MONTH(dDataRef) = aFunc[_I][11]
					//_oPrint:Say(_cont+1640, 0215, "F E L I Z   A N I V E R S A R I O  ! !", _oFont12)
					_oPrint:Say(_cont+1470, 0145, DESC_MSG[_I][4], _oFont8)
					_oPrint:Say(_cont+1495, 0145, DESC_MSG[_I][5], _oFont8)
					
				ELSE
					_oPrint:Say(_cont+1470, 0145, DESC_MSG[_I][4], _oFont8)
					_oPrint:Say(_cont+1495, 0145, DESC_MSG[_I][5], _oFont8)
				ENDIF
				
				//Mensagens da conta corrente
				If SRA->RA_BCDEPSAL # SPACE(8)
				
					If AllTrim(SubStr(aFunc[_I][12],1,3)) = "237"
					  Desc_Bco := "Banco Bradesco  "
					  
				 	Elseif AllTrim(SubStr(aFunc[_I][12],1,3)) = "341"
					   
						 Desc_Bco := "Banco Itau      "
						 
				    Elseif AllTrim(SubStr(aFunc[_I][12],1,3)) = "001"
					   
						Desc_Bco := "Banco do Brasil" 
					Else
					Desc_Bco := ALLTRIM(DescBco(Sra->Ra_BcDepSal,Sra->Ra_Filial))
					Endif  
					
					//CONOUT("BANCO: "+CVALTOCHAR(aFunc[_I][12]))
				
					_oPrint:Say(_cont+1200, 0145, "CRED: "+aFunc[_I][13]+" - "+Desc_Bco+"   CONTA: " + aFunc[_I][14], _oFont8) 
										
				Endif
				
				_oPrint:Line(_cont+1100, 0130, _cont+1100, 2250)  // linha horizontal no final dos lançamentos
				_oPrint:Line(_cont+1160, 1300, _cont+1160, 2250)  // linha horizontal antes do Valor liquido
				_oPrint:Say(_cont+1200, 1315, "Valor Liquido         "   , _oFont12)
				
				//*_*_*_PROVENTOS*_*_*_
				lMostraTot := .T.
				If Y < _Pag
					lMostraTot := .F.
				Endif  
				
				If TOTVENC[1][2] <= 9.99 .and. lMostraTot//lMosMSILVtraTot
					_oPrint:Say(_cont+1110, 1350,"R$ " + TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
				Endif
				If TOTVENC[1][2] <= 99.99 .and. TOTVENC[1][2] > 9.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1350,"R$ " + TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
				Endif
				If TOTVENC[1][2] <= 999.99 .and. TOTVENC[1][2] > 99.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1350,"R$ " + TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
				Endif
				If TOTVENC[1][2] <= 9999.99 .and. TOTVENC[1][2] > 999.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1350,"R$ " + TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
				Endif
				If TOTVENC[1][2] <= 99999.99 .and. TOTVENC[1][2] > 9999.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1350,"R$ " + TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
				Endif  
				
				//*_*_*_DESCONTOS*_*_*_
				If TOTDESC[1][2] <= 9.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1800,"R$ " + TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
				Endif
				If TOTDESC[1][2] <= 99.99 .and. TOTDESC[1][2] > 9.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1800,"R$ " + TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
				Endif
				If TOTDESC[1][2] <= 999.99 .and. TOTDESC[1][2] > 99.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1800,"R$ " + TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
				Endif
				If TOTDESC[1][2] <= 9999.99 .and. TOTDESC[1][2] > 999.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1800,"R$ " + TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
				Endif
				If TOTDESC[1][2] <= 99999.99 .and. TOTDESC[1][2] > 9999.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1800,"R$ " + TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
				Endif
				
				//*_*_*_LIQUIDO*_*_*_
				If (TOTVENC[1][2]-TOTDESC[1][2]) >=0
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= 9.99  .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,"R$ " + TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont12n)
					Endif
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= 99.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 9.99 .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,"R$ " + TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont12n)
					Endif
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= 999.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 99.99  .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,"R$ " + TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont12n)
					Endif
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= 9999.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 999.99 .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,"R$ " + TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont12n)
					Endif
				Else
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= -9.99 .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,"R$ " + TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
					Endif
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= -99.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 9.99 .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,"R$ " + TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
					Endif
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= -999.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 99.99 .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,"R$ " + TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
					Endif
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= -9999.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 999.99 .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,"R$ " + TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
					Endif
				Endif
				 
				_oPrint:Box(_cont+1250, 0130, iif(z==1,_cont+1345,_cont+1340), 2250)  // Box de demonstração do  Salário Base, FGTs, etc.
				_oPrint:Say(_cont+1260, 0210, "Salário-Base"		, _oFont8)
				_oPrint:Say(_cont+1260, 0500, "Sal. Contr. INSS"	, _oFont8)
				_oPrint:Say(_cont+1260, 0900, "Base Cálc. FGTS"		, _oFont8)
				_oPrint:Say(_cont+1260, 1300, "FGTS do Mês"			, _oFont8)
				_oPrint:Say(_cont+1260, 1600, "Base Cálc. IRRF"		, _oFont8)
				_oPrint:Say(_cont+1260, 2000, "Faixa IRRF"			, _oFont8)
				
				If !Empty( cAliasMov )
					nValSal := 0
					nValSal := fBuscaSal(dDataRef)
					If nValSal == 0
						nValSal := aFunc[_I][10]
					EndIf
				Else
					nValSal := aFunc[_I][10]
				EndIf
				
				_oPrint:Say(_cont+1300, 0150, "R$ " +Transform(nValSal,cPict2) , _oFont8)
				
				If Esc = 1  // Bases de Adiantamento
					If cBaseAux = "S" .And. aImpos[1][1] # 0
					   _oPrint:Say(_cont+1300, 1600, "R$ " + TRANSFORM(aImpos[1][1],cPict1) , _oFont8)
					Endif
				ElseIf Esc = 2 .Or. Esc = 4  // Bases de Folha e 13o. 2o.Parc.
					If cBaseAux = "S"
					   _oPrint:Say(_cont+1300, 0500,"R$ " + Transform(aImpos[1][2],cPict1) , _oFont8)
					   If aImpos[1][3] # 0
					      _oPrint:Say(_cont+1300, 0800, "R$ " + TRANSFORM(aImpos[1][3],cPict1) , _oFont8)
					   Endif
					   If aImpos[1][4] # 0
					      _oPrint:Say(_cont+1300, 1200,"R$ " + TRANSFORM(aImpos[1][4],cPict2) , _oFont8)
					   Endif
					   If aImpos[1][1] # 0
						  _oPrint:Say(_cont+1300, 1600,"R$ " + TRANSFORM(aImpos[1][1],cPict1) , _oFont8)
					   Endif
					   _oPrint:Say(_cont+1300, 1900, "R$ " + Transform(aImpos[1][5],cPict1) , _oFont8)
					Endif
				ElseIf Esc = 3 // Bases de FGTS e FGTS Depositado da 1¦ Parcela
					If cBaseAux = "S"
					   If aImpos[1][3] # 0
						  _oPrint:Say(_cont+1300, 0860,"R$ " + TRANSFORM(aImpos[1][3],cPict1), _oFont8) //BASE DE CALCULO DO FGTS
					   Endif
					   If aImpos[1][4] # 0
					      _oPrint:Say(_cont+1300, 1260, "R$ " + TRANSFORM(aImpos[1][4],cPict2) , _oFont8)//FGTS DO MES
					   Endif
					Endif
				Endif
				
				_oPrint:Say(_cont+1400, 0200, "DECLARO TER RECEBIDO A IMPORTANCIA LIQUIDA DISCRIMINADA NESTE RECIBO "  , _oFont8) 
				_cont := _cont - 40
				_oPrint:Say(_cont+1525, 1320, "_____________________________________"   , _oFont10)
				_oPrint:Say(_cont+1575, 0520, "                     DATA                     "  , _oFont8)
				_oPrint:Say(_cont+1525, 0620, " ________/________/________  ", _oFont10)
				_oPrint:Say(_cont+1575, 1470, aFunc[_I][2]   , _oFont8)
				
			Endif

			_lmesmo	:= .F.
			
			_cont  := 1610  
			If Z == 1
			   _oPrint:Say(_cont+60, 0000, "...>>>..........................................................................................................................................<<<..."   , _oFont10)
            Endif
		Next Z
		
	   	_oPrint:EndPage()     // Finaliza a página
	Next      
	
Next

_oPrint:Preview()     // Visualiza antes de imprimir

Return Nil


// Lancamentos

Static Function llanca(_codmat,_codcc,_cFilial)

Local cNroHoras   := &("{ || If(SRC->RC_QTDSEM > 0, SRC->RC_QTDSEM, SRC->RC_HORAS) }")     // Horas no Mes
Local cNroHorad   := &("{ || If(SRD->RD_QTDSEM > 0, SRD->RD_QTDSEM, SRD->RD_HORAS) }")     // Horas no Acumulado
Private cPeriodo  := SUBSTR(DTOS(DDATABASE),1,4)+SUBSTR(DTOS(DDATABASE),5,2)   

nAteLim   := 0.00
nBaseFgts := 0.00
nFgts     := 0.00
nBaseIr   := 0.00
nBaseIrFe := 0.00
_TOTVENC  := 0
_TOTDESC  := 0
Esc       := mv_par02

	dbSelectArea("SRA")
	dbSetOrder(1)
	dbgotop()
	dbSeek(_cFilial+_codmat)
	
	If Esc == 1 .OR. Esc == 2  // Adto(1) ou Folha(2)
	   
	  If cAnoMesRef == cPeriodo  // Dentro do Periodo em Aberto Folha do Mes
	   
	     dbSelectArea("SRC")
	     dbSetOrder(1)
	     dbgotop()  //adiionado por David J G Paiva 11/05/2018
	     
		

	     If dbSeek(_cFilial+_codmat)
	        
	        Do While !Eof() .And. SRC->RC_FILIAL+SRC->RC_MAT == SRA->RA_FILIAL+SRA->RA_MAT .AND. SRC->RC_PERIODO = cPeriodo   //Do While !Eof() .And. SRC->RC_FILIAL+SRC->RC_MAT == SRA->RA_FILIAL+SRA->RA_MAT
	            //IGNORA A VERBA 019 - DAVID J G PAIVA 07/08/2018
	             
	            IF SRC->RC_ROTEIR <> "FOL"
	        		dbSkip()
		           	Loop
	           	ENDIF
	           
	            cIdCalc  := POSICIONE("SRV",1,XFILIAL("SRV")+SRC->RC_PD,"RV_CODFOL")
	            
	            //EXCLUI OS ID DE CALCULO DO FOL
	            /*
	            * 0022- 1 PARCELA LIQUIDO DE 13
	            * 0006- ADIANTAMENTO ANTIGO
	            */
	             
	        	IF ( cIdCalc = '0022' .OR. cIdCalc = '0006' ) 
	        		//CONOUT("IGNORANDO VERBA")
					//dbSelectArea("SRC")
			   	    dbSkip()
		           	Loop
		       	Endif 
		       	
		       
	           IF SRC->RC_PD = "019" .OR. SRC->RC_PD = "025" //019 - VERBA ADI// 025 VERBA 1 PARC 13
	        		//CONOUT("IGNORANDO VERBA" + CVALTOCHAR(SRC->RC_PD))
					//dbSelectArea("SRC")
			   	    dbSkip()
		           	Loop
		       Endif
	             
		       //CONOUT("aCodFol[7,1]: "+aCodFol[7,1])
			   If (Esc == 1) .And. (Src->Rc_Pd == aCodFol[7,1])      // Desconto de Adto
			       fSomaPd("P",aCodFol[6,1],Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
				   _TOTVENC+=Src->Rc_Valor
	           Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[12,1])
					   fSomaPd("D",aCodFol[9,1],Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
					   _TOTDESC+=SRC->RC_VALOR
	           Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[8,1])
					   fSomaPd("P",aCodFol[8,1],Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
					   _TOTVENC+=Src->Rc_Valor
	           Else
				   If PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1" //VERIFICA SE É PROVENTO
					  	If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
						  If cPaisLoc == "PAR" .and. Eval(cNroHoras) == 30
						     LocGHabRea(Ctod("01/"+SubStr(DTOC(dDataRef),4)), Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Strzero(Month(dDataRef),2)+"/"+right(str(Year(dDataRef)),2)),@nHoras)
						  Else
						     nHoras := Eval(cNroHoras)
						  Endif
						     fSomaPd("P",SRC->RC_PD,nHoras,SRC->RC_VALOR,SRC->RC_MAT)
						     _TOTVENC+=Src->Rc_Valor
						Endif
				   Elseif SRV->RV_TIPOCOD == "2"
						  If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
							  fSomaPd("D",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
							  _TOTDESC+=Src->Rc_Valor
						  Endif
				   Elseif SRV->RV_TIPOCOD == "3"
						  If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
							  fSomaPd("B",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
						  Endif
				   Endif
			   Endif
	           If ESC == 1
				  If SRC->RC_PD == aCodFol[10,1]
				     nBaseIr := SRC->RC_VALOR
				  Endif
	           ElseIf SRC->RC_PD == aCodFol[13,1]
					  nAteLim += SRC->RC_VALOR
			   Elseif SRC->RC_PD$ aCodFol[108,1]+'*'+aCodFol[17,1]
					  nBaseFgts += SRC->RC_VALOR
			   Elseif SRC->RC_PD$ aCodFol[109,1]+'*'+aCodFol[18,1]
					  nFgts += SRC->RC_VALOR
			   Elseif SRC->RC_PD == aCodFol[15,1]
					  nBaseIr += SRC->RC_VALOR
			   Elseif SRC->RC_PD == aCodFol[16,1]
					  nBaseIrFe += SRC->RC_VALOR
			   Endif
			 
			   dbSelectArea("SRC")
			   dbSkip()
		  
		    Enddo
		
		  Endif
	  
	  Else  // Dados das Folhas dos Meses Anteriores Folha Fechado.
	
		 dbSelectArea("SRD")  
	     If dbSeek(_cFilial+_codmat+cAnoMesRef)
	        //Do While !Eof() .And. SRD->RD_FILIAL+SRD->RD_MAT == SRA->RA_FILIAL+SRA->RA_MAT //ORIGINAL
	        Do While !Eof() .And. SRD->RD_FILIAL+SRD->RD_MAT == SRA->RA_FILIAL+SRA->RA_MAT .AND. SRD->RD_PERIODO = cAnoMesRef //MODIFICADO POR DAVID 30/07/2018
		  		
		  		//CONOUT("cAnoMesRef: "+cAnoMesRef)
		  		//CONOUT("cAnoMesRef: "+cAnoMesRef)
		  		  
		  		cIdCalc  := POSICIONE("SRV",1,XFILIAL("SRV")+SRD->RD_PD,"RV_CODFOL")
	            
	            //NAO IMPRIME NO HOLERITE AS VERBAS DE IDS ABAIXO
	            /*
	            * 0022- 1 PARCELA LIQUIDO DE 13
	            * 0006- ADIANTAMENTO ANTIGO
	            */
	             
	        	IF ( cIdCalc = '0022' .OR. cIdCalc = '0006' ) 
	        		//CONOUT("IGNORANDO VERBA")
					//dbSelectArea("SRC")
			   	    dbSkip()
		           	Loop
		       	Endif 
		       	
		  		/*
		  		IF (SRD->RD_PD == "019") 
			  		CONOUT("PASSAGEM SRD VERBA 019")
					//dbSelectArea("SRD")
			   		dbSkip()
		           	Loop
		       	Endif
		        */
		        
			   If (Esc == 1) .And. (Srd->Rd_Pd == aCodFol[7,1])      // Desconto de Adto
			       fSomaPd("P",aCodFol[6,1],Eval(cNroHorad),SRD->RD_VALOR,SRD->RD_MAT)
				   _TOTVENC+=Srd->Rd_Valor
	           Elseif (Esc == 1) .And. (Srd->Rd_Pd == aCodFol[12,1])
					   fSomaPd("D",aCodFol[9,1],Eval(cNroHorad),SRD->RD_VALOR,SRD->RD_MAT)
					   _TOTDESC+=SRD->RD_VALOR
	           Elseif (Esc == 1) .And. (Srd->Rd_Pd == aCodFol[8,1])
					   fSomaPd("P",aCodFol[8,1],Eval(cNroHorad),SRD->RD_VALOR,SRD->RD_MAT)
					   _TOTVENC+=Srd->Rd_Valor
	           Else
				   If PosSrv( Srd->Rd_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					  If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
						  If cPaisLoc == "PAR" .and. Eval(cNroHorad) == 30
						     LocGHabRea(Ctod("01/"+SubStr(DTOC(dDataRef),4)), Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Strzero(Month(dDataRef),2)+"/"+right(str(Year(dDataRef)),2)),@nHoras)
						  Else
						     nHoras := Eval(cNroHorad)
						  Endif
						     fSomaPd("P",SRD->RD_PD,nHoras,SRD->RD_VALOR,SRD->RD_MAT)
						     _TOTVENC+=Srd->Rd_Valor
						  Endif
				   Elseif SRV->RV_TIPOCOD == "2"
						  If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
							  fSomaPd("D",SRD->RD_PD,Eval(cNroHorad),SRD->RD_VALOR,SRD->RD_MAT)
							  _TOTDESC+=Srd->Rd_Valor
						  Endif
				   Elseif SRV->RV_TIPOCOD == "3"
						  If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
							  fSomaPd("B",SRD->RD_PD,Eval(cNroHorad),SRD->RD_VALOR,SRD->RD_MAT)
						  Endif
				   Endif
			   Endif
	           If ESC == 1
				  If SRD->RD_PD == aCodFol[10,1]
				     nBaseIr := SRD->RD_VALOR
				  Endif
	           ElseIf SRD->RD_PD == aCodFol[13,1]
					  nAteLim += SRD->RD_VALOR
			   Elseif SRD->RD_PD$ aCodFol[108,1]+'*'+aCodFol[17,1]
					  nBaseFgts += SRD->RD_VALOR
			   Elseif SRD->RD_PD$ aCodFol[109,1]+'*'+aCodFol[18,1]
					  nFgts += SRD->RD_VALOR
			   Elseif SRD->RD_PD == aCodFol[15,1]
					  nBaseIr += SRD->RD_VALOR
			   Elseif SRD->RD_PD == aCodFol[16,1]
					  nBaseIrFe += SRD->RD_VALOR
			   Endif
			 
			   dbSelectArea("SRD")
			   dbSkip()
		  
		    Enddo
		
		  Endif  
	  
	  Endif
	
	Elseif Esc == 3 //decimo terceiro 1 parcela

		/* Adicionado por David
		Verifica se o perido esta aberto ou fechado. Assim busca os dados da SRC(aberto) ou SRD(fechado)
		
		*/
		DbSelectArea('RCH')
		RCH->(DbGoTop())
		RCH->(DbSetOrder(6)) //RCH_FILIAL+RCH_PROCES+RCH_ROTEIR+RCH_ANO+RCH_MES     

		RCH->(dbSeek(_cFilial+'00001'+'131'+cAnoMesRef))

		aRCH := GetArea()

		CONOUT(CVALTOCHAR(TRIM(RCH->RCH_ROTEIR)))
		CONOUT(CVALTOCHAR(TRIM(RCH->RCH_PERSEL)))
		CONOUT(CVALTOCHAR(TRIM(RCH->RCH_STATUS)))
		/*
		 If MsgYesNo("SIM - Periodo aberto | NÂO - Fechado", "Confirma?")
			cPerAbFec := .T.
		else
			cPerAbFec := .F.
		Endif
		*/
		//cPerAbFec := .T.
		/*1 - ATIVO | 2 - FECHADO*/ 
		//If TRIM(RCH->RCH_ROTEIR) == '131' .AND. TRIM(RCH->RCH_PERSEL) == '1' .AND. RCH->RCH_STATUS <> '5'
		If cPerAbFec == .T.
			CONOUT(' RCH - PERIDO ABERTO DECIMO TERCEIRO PRIMEIRA')

			CONOUT(CVALTOCHAR(TRIM(RCH->RCH_ROTEIR)))
			CONOUT(CVALTOCHAR(TRIM(RCH->RCH_PERSEL)))
			CONOUT(CVALTOCHAR(TRIM(RCH->RCH_STATUS)))

			//Busca os codigos de pensao definidos no cadastro beneficiario
		 	dbSelectArea("SRC")
			dbSetOrder(1)

			

			fBusCadBenef(@aCodBenef, "131",{aCodfol[172,1]})
			dbSelectArea("SRC")
			dbSetOrder(1)
			
			If dbSeek(_cFilial+_codmat)

				CONOUT('GERANDO 131 PARA :'+_codmat)

				While (SRC->(!EOF())) .And. (SRA->RA_FILIAL + SRA->RA_MAT) == (SRC->RC_FILIAL + SRC->RC_MAT) .AND. TRIM(SRC->RC_PERIODO) = TRIM(cAnoMesRef)
					//If SRC->RC_PD == aCodFol[22,1]
					CONOUT('WHILE DO 131')
					If SRC->RC_PD == aCodFol[22,1]/*decimo*/ .OR. SRC->RC_PD == aCodFol[1434,1]/*salario maternidade*/ .OR. SRC->RC_PD == aCodFol[1634,1]/**/.OR. SRC->RC_PD == aCodFol[1632,1]/**/.OR. SRC->RC_PD == aCodFol[1636,1]/**/
						
						fSomaPd("P",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
						_TOTVENC+=Src->Rc_Valor
						CONOUT('1-RC_PD: ' + TRIM(aCodFol[22,1]))
						CONOUT('1-RC_PD: ' + TRIM(aCodFol[1434,1]))
						CONOUT('1-131 - SOMANDO PROVENTO')

					Elseif Ascan(aCodBenef, { |x| x[1] == SRC->RC_PD }) > 0
						fSomaPd("D",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
						_TOTDESC+=SRC->RC_VALOR
					
						CONOUT('X-131 - SOMANDO DESCONTO')

					Elseif SRC->RC_PD == aCodFol[108,1] .Or. SRC->RC_PD == aCodFol[109,1] .Or. SRC->RC_PD == aCodFol[173,1]
						fSomaPd("B",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)

						CONOUT('2-RC_PD: ' + TRIM(aCodFol[108,1]))
						CONOUT('2-RC_PD: ' + TRIM(aCodFol[109,1]))
						CONOUT('2-RC_PD: ' + TRIM(aCodFol[173,1]))
						CONOUT('2-131 - SOMANDO BASE')

					Endif
					
					If SRC->RC_PD == aCodFol[108,1]
						nBaseFgts := SRC->RC_VALOR
					Elseif SRC->RC_PD == aCodFol[109,1]
						nFgts     := SRC->RC_VALOR
					Endif
					dbSelectArea("SRC")
					dbSkip()
				Enddo
			Else
				conout('nao encontrou funcionario para 131')
			Endif 
		Else
			CONOUT('SRD - PERIDO FECHADO DECIMO TERCEIRO PRIMEIRA')
			
				dbSelectArea("SRD")
				dbSetOrder(1)
				If dbSeek(_cFilial+_codmat+cAnoMesRef)
					While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT == SRD->RD_FILIAL + SRD->RD_MAT .AND. SRD->RD_PERIODO = cAnoMesRef
						//If SRD->RD_PD == aCodFol[22,1]
						If SRD->RD_PD == aCodFol[22,1]/*decimo*/ .OR. SRD->RD_PD == aCodFol[1434,1]/*salario maternidade*/
							fSomaPd("P",SRD->RD_PD,Eval(cNroHoras),SRD->RD_VALOR,SRD->RD_MAT)
							//CONOUT("VERBA:"+CVALTOCHAR(SRD->RD_PD) + " VALOR: "+ CVALTOCHAR(SRD->RD_VALOR))
							_TOTVENC+=SRD->RD_VALOR   
							//CONOUT("_TOTVENC:"+CVALTOCHAR(_TOTVENC))
						/*Elseif Ascan(aCodBenef, { |x| x[1] == SRD->RD_PD }) > 0
							fSomaPd("D",SRD->RD_PD,Eval(cNroHoras),SRD->RD_VALOR,SRD->RD_MAT)
							_TOTDESC+=SRD->RD_VALOR */
						Elseif SRD->RD_PD == aCodFol[108,1] .Or. SRD->RD_PD == aCodFol[109,1] .Or. SRD->RD_PD == aCodFol[173,1]
							fSomaPd("B",SRD->RD_PD,Eval(cNroHoras),SRD->RD_VALOR,SRD->RD_MAT)
						Endif
						
						If SRD->RD_PD == aCodFol[108,1]
							nBaseFgts := SRD->RD_VALOR
						Elseif SRD->RD_PD == aCodFol[109,1]
							nFgts     := SRD->RD_VALOR
						Endif
						dbSelectArea("SRD")
						dbSkip()
					Enddo
				Endif	
		    Endif 
	   
	Elseif Esc == 4   //2° PARCELA DO 13° 
	     
	//CONOUT("IMPRESSAO DE 2 PARCECLA DO 13")
	  // CONOUT("cPeriodo: "+CVALTOCHAR(cPeriodo)) //201812
	  // CONOUT("cAnoRef13: "+CVALTOCHAR(cAnoRef13)) //2018
	  If AllTrim(cPeriodo) = AllTrim(cAnoRef13+'12')      // 2 Parcela 13 Salario do Ano em Vigor.  
	        
	  	cAnoMesRef := cAnoRef13+"12"  
	  	//CONOUT("cAnoMesRef: "+CVALTOCHAR(cAnoMesRef))  
	  	
	  	 dbSelectArea("SRC")
	  	 dbSetOrder(4)  //FILIAL+MATRICULA+PERIODO+ROTEIRO
	  	 
	  	 //CONOUT(CVALTOCHAR(_cFilial)+CVALTOCHAR(_codmat)+CVALTOCHAR(cAnoMesRef)+"132")
	  	 
	     If dbSeek(_cFilial+_codmat+cAnoMesRef+"132") 
	     
	        //CONOUT("MAT ENCONTRADA: "+CVALTOCHAR(_codmat)) 
	           
         
	        	
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT == SRC->RC_FILIAL + SRC->RC_MAT
				//CONOUT("INICIO WHILE: "+CVALTOCHAR(SRC->RC_MAT))
				  
			 	//NAO IMPRIME NO HOLERITE AS VERBAS DE IDS ABAIXO
	            /*
	            * 0022- 1 PARCELA LIQUIDO DE 13
	            * 0006- ADIANTAMENTO ANTIGO
	            */
		        cIdCalc  := POSICIONE("SRV",1,XFILIAL("SRV")+SRC->RC_PD,"RV_CODFOL")
	        
				IF ( cIdCalc = '0022' .OR. cIdCalc = '0006' ) 
	        		//CONOUT("IGNORANDO VERBA")
					//dbSelectArea("SRC")
			   	    dbSkip()
		           	Loop
		       	Endif 
		       	
				If POSSRV( SRC->RC_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPd("P",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR,SRC->RC_MAT)
					_TOTVENC = _TOTVENC + SRC->RC_VALOR
				Elseif SRV->RV_TIPOCOD == "2"
					fSomaPd("D",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR,SRC->RC_MAT)
					_TOTDESC = _TOTDESC + SRC->RC_VALOR
				Elseif SRV->RV_TIPOCOD == "3"
					fSomaPd("B",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR,SRC->RC_MAT)
				Endif
				
				If SRC->RC_PD == aCodFol[19,1]
					nAteLim += SRC->RC_VALOR
				Elseif SRC->RC_PD $ aCodFol[108,1]
					nBaseFgts += SRC->RC_VALOR
				Elseif SRC->RC_PD$ aCodFol[109,1]
					nFgts += SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[27,1]
					nBaseIr += SRC->RC_VALOR
				Endif 
				dbSelectArea("SRC")
				dbSkip()
			Enddo
		Endif
	    /*
		dbSelectArea("SRI")
		dbSetOrder(2)
		If dbSeek(_cFilial+_codcc+_codmat)
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT == SRI->RI_FILIAL + SRI->RI_CC + SRI->RI_MAT
				If PosSrv( SRI->RI_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPd("P",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR,SRI->RI_MAT)
					_TOTVENC = _TOTVENC + SRI->RI_VALOR
				Elseif SRV->RV_TIPOCOD == "2"
					fSomaPd("D",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR,SRI->RI_MAT)
					_TOTDESC = _TOTDESC + SRI->RI_VALOR
				Elseif SRV->RV_TIPOCOD == "3"
					fSomaPd("B",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR,SRI->RI_MAT)
				Endif
				
				If SRI->RI_PD == aCodFol[19,1]
					nAteLim += SRI->RI_VALOR
				Elseif SRI->RI_PD$ aCodFol[108,1]
					nBaseFgts += SRI->RI_VALOR
				Elseif SRI->RI_PD$ aCodFol[109,1]
					nFgts += SRI->RI_VALOR
				Elseif SRI->RI_PD == aCodFol[27,1]
					nBaseIr += SRI->RI_VALOR
				Endif
				dbSkip()
			Enddo
		Endif
	    */
	  Else  // 2 Parcela do 13 Salario nos Acumulados da Folha.
	  
	     cAnoMesRef := cAnoRef13+"13"
	  	 dbSelectArea("SRD")
	     If dbSeek(_cFilial+_codmat+cAnoMesRef)
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT == SRD->RD_FILIAL + SRD->RD_MAT
				If PosSrv( SRD->RD_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPd("P",SRD->RD_PD,SRD->RD_HORAS,SRD->RD_VALOR,SRD->RD_MAT)
					_TOTVENC = _TOTVENC + SRD->RD_VALOR
				Elseif SRV->RV_TIPOCOD == "2"
					fSomaPd("D",SRD->RD_PD,SRD->RD_HORAS,SRD->RD_VALOR,SRD->RD_MAT)
					_TOTDESC = _TOTDESC + SRD->RD_VALOR
				Elseif SRV->RV_TIPOCOD == "3"
					fSomaPd("B",SRD->RD_PD,SRD->RD_HORAS,SRD->RD_VALOR,SRD->RD_MAT)
				Endif
				
				If SRD->RD_PD == aCodFol[19,1]
					nAteLim += SRD->RD_VALOR
				Elseif SRD->RD_PD$ aCodFol[108,1]
					nBaseFgts += SRD->RD_VALOR
				Elseif SRD->RD_PD$ aCodFol[109,1]
					nFgts += SRD->RD_VALOR
				Elseif SRD->RD_PD == aCodFol[27,1]
					nBaseIr += SRD->RD_VALOR
				Endif
				dbSkip()
			Enddo
		Endif
	  
	  Endif
	
	Elseif Esc == 5
	
		dbSelectArea("SR1")
		dbSetOrder(1)
		If dbSeek(_cFilial+_codmat)
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT ==	SR1->R1_FILIAL + SR1->R1_MAT
				If PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPd("P",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR,SR1->R1_MAT)
					_TOTVENC = _TOTVENC + SR1->R1_VALOR
				Elseif SRV->RV_TIPOCOD == "2"
					fSomaPd("D",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR,SR1->R1_MAT)
					_TOTDESC = _TOTDESC + SR1->R1_VALOR
				Elseif SRV->RV_TIPOCOD == "3"
					fSomaPd("B",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR,SR1->R1_MAT)
				Endif
				dbskip()
			Enddo
		Endif
	
	Endif
	
	dbSelectArea("SRA")
	
	aAdd(TOTVENC,{_n, _TOTVENC})
	aAdd(TOTDESC,{_n, _TOTDESC})
	aAdd(aImpos,{nBaseIr, nAteLim, nBaseFgts, nFgts, nBaseIrFe})
	
Return

//Somar as Verbas no Array
//fSomaPd(Tipo,Verba,Horas,Valor)

Static Function fSomaPd(cTipo,cPd,nHoras,nValor,cMat)

Local Desc_paga

	Desc_paga := DescPd(cPd,Sra->Ra_Filial)  // mostra como pagto
	
	If cTipo # 'B'
		nPos := Ascan(aLanca,{ |X| X[2] = cPd })//Array para Recibo Pre-Impresso
		If nPos == 0
			Aadd(aLanca,{cTipo,cPd,Desc_Paga,nHoras,nValor,cMat,_n})
		Else
			aLanca[nPos,4] += nHoras
			aLanca[nPos,5] += nValor
		Endif
	Endif

Return
    

//Função Transformada Data
/*
Static Function Transforma(dData) //Transforma as datas no formato DD/MM/AAAA

Return(StrZero(Day(dData),2) +"/"+ StrZero(Month(dData),2) +"/"+ Right(Str(Year(dData)),4))
*/
//Inicializa parametros para impressao

Static Function  fInicia(cString,nTipoRel)

aDriver := LEDriver()

	If LastKey() = 27 .Or. nLastKey = 27
		Return  .F.
	Endif
	
	SetDefault(aReturn,cString)
	
	If LastKey() = 27 .OR. nLastKey = 27
		Return .F.
	Endif
	
Return .T.
  

//Funcão Valida SX1
*__________________________________________________________________________________________________________________________________________________________________________________________________________________________________

Static Function fValidSX1(cPerg)

Private aPergs := {}
Private aHelp := {}
     
	AADD( aHelp,{'01',{" "} }) 
	AADD( aHelp,{'02',{" "} })
	AADD( aHelp,{'03',{" "} })
	AADD( aHelp,{'04',{" "} })
	AADD( aHelp,{'05',{" "} })
	AADD( aHelp,{'06',{" "} })
	AADD( aHelp,{'07',{" "} })
	AADD( aHelp,{'08',{" "} })
	AADD( aHelp,{'09',{" "} })
	AADD( aHelp,{'10',{" "} })
	AADD( aHelp,{'11',{" "} })
	AADD( aHelp,{'12',{" "} })
	AADD( aHelp,{'13',{" "} })
	AADD( aHelp,{'14',{" "} })
	AADD( aHelp,{'15',{" "} })
	AADD( aHelp,{'16',{" "} })
	AADD( aHelp,{'17',{" "} })
	AADD( aHelp,{'18',{" "} })

	Aadd(aPergs,{"01","Data de Referencia     ?", "", "","mv_ch1", "D", 8, 0, 0, "G", "naovazio","mv_par01", ""			,"", "", "","" ,"", "","","","", "", "","","", "", "","","", "", "","",""})
	Aadd(aPergs,{"02","Imprimir Recibos      ?", "", "","mv_ch2", "N", 1, 0, 0, "C", ""        ,"mv_par02","Adto.","","","","","Folha","","","","","1a.Parc.","","","","","2a.Parc.","","","","","Val.Extras","","","","",""})
	Aadd(aPergs,{"03", "De Filial             ?", "", "","mv_ch3", "C", 4, 0, 0, "G", "","mv_par03", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","XM0"})
	Aadd(aPergs,{"04", "Ate Filial            ?", "", "","mv_ch4", "C", 4, 0, 0, "G", "","mv_par04", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","XM0"})
	Aadd(aPergs,{"05", "De Centro de Custo    ?", "", "","mv_ch5", "C", 9, 0, 0, "G", "","mv_par05", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","CTT"})
	Aadd(aPergs,{"06", "Ate Centro de Custo   ?", "", "","mv_ch6", "C", 9, 0, 0, "G", "","mv_par06", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","CTT"})
	Aadd(aPergs,{"07", "De Matricula          ?", "", "","mv_ch7", "C", 6, 0, 0, "G", "","mv_par07", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","SRA"})
	Aadd(aPergs,{"08", "Ate Matricula         ?", "", "","mv_ch8", "C", 6, 0, 0, "G", "","mv_par08", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","SRA"})
	Aadd(aPergs,{"09", "De Nome               ?", "", "","mv_ch9", "C", 30, 0, 0, "G", "","mv_par09", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
	Aadd(aPergs,{"10", "Ate Nome              ?", "", "","mv_chA", "C", 30, 0, 0, "G", "","mv_par10", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
	Aadd(aPergs,{"11", "Mensagem 1            ?", "", "","mv_chB", "C", 2, 0, 0, "G", ""         ,"mv_par11", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
	Aadd(aPergs,{"12", "Mensagem 2            ?", "", "","mv_chC", "C", 2, 0, 0, "G", ""         ,"mv_par12", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
	Aadd(aPergs,{"13", "Mensagem 3            ?", "", "","mv_chD", "C", 2, 0, 0, "G", ""         ,"mv_par13", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
	Aadd(aPergs,{"14", "Mensagem 4            ?", "", "","mv_chE", "C", 62, 0, 0, "G", ""        ,"mv_par14", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
	Aadd(aPergs,{"15", "Mensagem 5            ?", "", "","mv_chF", "C", 62, 0, 0, "G", ""        ,"mv_par15", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
	Aadd(aPergs,{"16", "Situacoes a Imp.      ?", "", "","mv_chG", "C", 5, 0, 0, "G", "fSituacao","mv_par16", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
	Aadd(aPergs,{"17", "Categorias a Imp.     ?", "", "","mv_chH", "C", 15, 0, 0, "G", "fCategoria","mv_par17", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
	Aadd(aPergs,{"18", "Imprime Bases         ?", "", "","mv_chI", "C", 1, 0, 0, "C", ""         , "mv_par18", "Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","",""})
	
	
	
	
	AjustaSx1(cPerg ,aPergs , aHelp )
	
Return   

Static Function AjustaSX1( cPerg, aPerg, aHelp )

Local aArea := GetArea()
Local aCpoPerg := {}
Local nX := 0
Local nY := 0 

// DEFINE ESTRUTUA DO ARRAY DAS PERGUNTAS COM AS PRINCIPAIS INFORMACOES
AADD( aCpoPerg, 'X1_ORDEM' )
AADD( aCpoPerg, 'X1_PERGUNT' )
AADD( aCpoPerg, 'X1_PERSPA' )
AADD( aCpoPerg, 'X1_PERENG' )
AADD( aCpoPerg, 'X1_VARIAVL' )
AADD( aCpoPerg, 'X1_TIPO' )
AADD( aCpoPerg, 'X1_TAMANHO' )
AADD( aCpoPerg, 'X1_DECIMAL' )
AADD( aCpoPerg, 'X1_PRESEL' )
AADD( aCpoPerg, 'X1_GSC' )
AADD( aCpoPerg, 'X1_VALID' )
AADD( aCpoPerg, 'X1_VAR01' )
AADD( aCpoPerg, 'X1_DEF01' )
AADD( aCpoPerg, 'X1_DEFSPA1' )
AADD( aCpoPerg, 'X1_DEFENG1' )
AADD( aCpoPerg, 'X1_CNT01' )
AADD( aCpoPerg, 'X1_VAR02' )
AADD( aCpoPerg, 'X1_DEF02' )
AADD( aCpoPerg, 'X1_DEFSPA2' )
AADD( aCpoPerg, 'X1_DEFENG2' )
AADD( aCpoPerg, 'X1_CNT02' )
AADD( aCpoPerg, 'X1_VAR03' )
AADD( aCpoPerg, 'X1_DEF03' )
AADD( aCpoPerg, 'X1_DEFSPA3' )
AADD( aCpoPerg, 'X1_DEFENG3' )
AADD( aCpoPerg, 'X1_CNT03' )
AADD( aCpoPerg, 'X1_VAR04' )
AADD( aCpoPerg, 'X1_DEF04' )
AADD( aCpoPerg, 'X1_DEFSPA4' )
AADD( aCpoPerg, 'X1_DEFENG4' )
AADD( aCpoPerg, 'X1_CNT04' )
AADD( aCpoPerg, 'X1_VAR05' )
AADD( aCpoPerg, 'X1_DEF05' )
AADD( aCpoPerg, 'X1_DEFSPA5' )
AADD( aCpoPerg, 'X1_DEFENG5' )
AADD( aCpoPerg, 'X1_CNT05' )
AADD( aCpoPerg, 'X1_F3' )
AADD( aCpoPerg, 'X1_PYME' )
AADD( aCpoPerg, 'X1_GRPSXG' )
AADD( aCpoPerg, 'X1_HELP' )
AADD( aCpoPerg, 'X1_PICTURE' )
AADD( aCpoPerg, 'X1_IDFIL' )

DBSelectArea( "SX1" )
DBSetOrder( 1 )

For nX := 1 To Len( aPerg )
	IF !DBSeek( PADR(cPerg,10) + aPerg[nX][1] )
   		RecLock( "SX1", .T. ) // Inclui
	Else
   		RecLock( "SX1", .F. ) // Altera
	Endif
	
	// Grava informacoes dos campos da SX1
	For nY := 1 To Len( aPerg[nX] )
		If aPerg[nX][nY] <> NIL
		SX1->( &( aCpoPerg[nY] ) ) := aPerg[nX][nY]
		EndIf
	Next
	
	//OpenSxs(,,,,cEmp,"SX1T","SX1",,.F.)
	//COMENTADO DEVIDO CODEANALYSIS
	//DbSelectArea('SX1T')
	//SX1T->X1_GRUPO := PADR(cPerg,10)//codeanalysis
	
	MsUnlock() // Libera Registro
	// Verifica se campo possui Help
	_nPosHelp := aScan(aHelp,{|x| x[1] == aPerg[nX][1]})
	IF (_nPosHelp > 0)
	cNome := "P."+TRIM(cPerg)+ aHelp[_nPosHelp][1]+"."
	PutSX1Help(cNome,aHelp[_nPosHelp][2],{},{},.T.)
	Else
	// Apaga help ja existente.
	cNome := "P."+TRIM(cPerg)+ aPerg[nX][1]+"."
	PutSX1Help(cNome,{" "},{},{},.T.)
	Endif
Next

// Apaga perguntas nao definidas no array
DBSEEK(cPerg,.T.)  
/*
DO WHILE SX1->(!Eof()) .And. SX1T->X1_GRUPO == cPerg
	IF ASCAN(aPerg,{|Y| Y[1] == SX1T->X1_ORDEM}) == 0
		Reclock("SX1T", .F.)
		SX1T->(DBDELETE())
		Msunlock()
	ENDIF  
	
	SX1T->(DBSKIP())
ENDDO
*/
RestArea( aArea )  

Return
