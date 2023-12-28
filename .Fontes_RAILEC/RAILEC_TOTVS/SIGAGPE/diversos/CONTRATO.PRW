#include "RWMAKE.ch"


**************
user Function uTERMO_C()    // ROTINA DE IMPRESSAO DE TERMO DE COMPROMISSO E RESPONSABILIDADE ... By JOSE MACEDO
	**************
	local i

	nOrdem :=0
	Z:=0
	M:=0
	tamanho:="M"
	limite:=220
	titulo   := PADC("AD",74)
	cDesc1   := PADC(" ",74)
	cDesc2   := PADC(" ",74)
	cDesc3   := PADC(" ",74)
	cNatureza:=""
	aReturn  := { "Especial", 1,"Administracao", 2, 2, 1,"",1 }
	nPag     := 0
	nomeprog := "TERMO_C"
	cPerg    := ""
	wnrel    := SUBSTR(CUSUARIO,7,3)+"_TERMO"
	nLastKey := 0
	lContinua:= .T.
	nLin     := 0

	_TXCORREA:= 0
	_TXJURREA:= 0
	_QUAL    := ""
	_A:=ARRAY(10,20)

//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas                                      ¦
//+-------------------------------------------------------------------------+
	_INI:=_FIM:=SPACE(6)
	@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Matricula"
	@ 10, 22 SAY "De :"
	@ 10, 49 GET _INI  SIZE 25,12 F3 "SRA"
	@ 22, 22 SAY "Ate:"
	@ 22, 49 GET _FIM  SIZE 25,12 F3 "SRA"
	@ 60, 95 BmpButton Type 1 Action Close(oDlg2)
	Activate Dialog oDlg2 Centered

	cString:= ALIAS()


//+--------------------------------------------------------------+
//¦ Inicializa variaveis graficas                                ¦
//+--------------------------------------------------------------+

	aOkImp := .f.
	nHeight:=15
	lBold:= .F.
	lUnderLine:= .F.
	lPixel:= .T.
	lPrint:=.F.
	nSedex := 1

	oFont9 :=TFont():New( "Arial"   ,,14,,.T.,,,,,.F. )
//oFont9a:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
	oFont9a:=TFont():New( "Times New Roman"   ,,14,,.F.,,,,,.F. )
	oFont9x:=TFont():New( "Times New Roman"   ,,10,,.F.,,,,,.T. )

	oFont9b:=TFont():New( "Arial"   ,,12,,.T.,,,,,.F. )

	oPrn := TMSPrinter():New()
	oPrn:Setup()


//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+

	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,"M","",.T.)

	If nLastKey == 27 .or. Lastkey() == 27
		Return
	Endif

//+--------------------------------------------------------------+
//¦ Verifica Posicao do Formulario na Impressora                 ¦
//+--------------------------------------------------------------+
	SetDefault(aReturn,cString)

	If nLastKey == 27 .or. Lastkey() == 27
		Return
	Endif


	LinCab := 0
	cabec1 :=" "
	cabec2 :=" "
	cabec3 :=" "
	cabec4 :=" "
	cBitMap:= "ALUBAR_ISO.Bmp"



	IF EMPTY(_FIM)
		_FIM:=_INI
	ENDIF
//+-----------------------------------------------------------+
//¦ Inicio do Relatorio                                       ¦
//+-----------------------------------------------------------+
	DBSELECTAREA("SRA")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SRA")+_INI,.T.)
	WHILE !EOF() .AND. RA_MAT<=_FIM
		for i:=1 to 2
			oPrn:EndPage()
			Linha := 70
			nPag  := nPag +1

			oPrn:SayBitmap( Linha+050,080,cBitMap,2080,480 )

			oPrn:Say(Linha:=Linha+700,550,"Termo de Compromisso e Responsabilidade" , oFont9)


			_SALTO:=60
			oPrn:Say(Linha:=Linha+300     ,300-150,"Eu, "+SRA->RA_NOME+", matrícula "+sra->ra_mat+" e portador(a) da carteira" , oFont9a)
			oPrn:Say(Linha:=Linha+_SALTO  ,300-150,"profissional Nº. "+SRA->RA_NUMCP+", série "+SRA->RA_SERCP+", funcionário da empresa ALUBAR METAIS E CABOS S/A," , oFont9a)
			oPrn:Say(Linha:=Linha+_SALTO  ,300-150,"declaro que a partir desta data assumo a inteira responsabilidade nas compras efetuadas por mim" , oFont9a)
			oPrn:Say(Linha:=Linha+_SALTO  ,300-150,"e por meu dependente, quando houver, com os cartões por mim recebidos do Convênio Farmácia." , oFont9a)


			oPrn:Say(Linha:=Linha+150     ,300-150,"Comprometo-me ainda, que comprarei EXCLUSIVAMENTE os itens informados e autorizados pela " , oFont9a)
			oPrn:Say(Linha:=Linha+_SALTO  ,300-150,"empresa (medicamentos, fraldas descartáveis, preservativos e absorventes), conforme descrito no" , oFont9a)
			oPrn:Say(Linha:=Linha+_SALTO  ,300-150,"manual do colaborador." , oFont9a)

			oPrn:Say(Linha:=Linha+150     ,300-150,"Outrossim, declaro ter ciência de que o descumprimento deste termo resultará em sanções disciplinares." , oFont9a)

			oPrn:Say(Linha:=Linha+200     ,300-150,"Assim, firmo o presente documento para que produza os seus efeitos legais." , oFont9a)


			oPrn:Say(Linha:=Linha+200     ,600,"Barcarena/PA , "+DTOC(DDatabase) , oFont9a)


			oPrn:line( Linha:=Linha+300       ,0600 ,Linha,1700)     // Linha horizontal
			oPrn:Say(Linha:=Linha    ,0600,SRA->RA_NOME , oFont9B)
		next i
		DBSELECTAREA("SRA")
		DBSKIP()
	ENDDO

	oPrn:Preview()
	MS_FLUSH()

	oPrn:EndPage()


RETURN



	**************
user Function uAUTORIZA()    // ROTINA DE IMPRESSAO DE AUTORIZAÇAO DE DESCONTO EM FOLHA ... By JOSE MACEDO
	**************

	nOrdem :=0
	Z:=0
	M:=0
	tamanho:="M"
	limite:=220
	titulo   := PADC("AD",74)
	cDesc1   := PADC(" ",74)
	cDesc2   := PADC(" ",74)
	cDesc3   := PADC(" ",74)
	cNatureza:=""
	aReturn  := { "Especial", 1,"Administracao", 2, 2, 1,"",1 }
	nPag     := 0
	nomeprog := "AUTORIZA"
	cPerg    := "AUTORIZA"
	wnrel    := SUBSTR(CUSUARIO,7,3)+"_AD"
	nLastKey := 0
	lContinua:= .T.
	nLin     := 0

	_TXCORREA:= 0
	_TXJURREA:= 0
	_QUAL    := ""
	_A:=ARRAY(10,20)

//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas                                      ¦
//+-------------------------------------------------------------------------+
	_INI:=_FIM:=SPACE(6)
	@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Matricula"
	@ 10, 22 SAY "De :"
	@ 10, 49 GET _INI  SIZE 25,12 F3 "SRA"
	@ 22, 22 SAY "Ate:"
	@ 22, 49 GET _FIM  SIZE 25,12 F3 "SRA"
	@ 60, 95 BmpButton Type 1 Action Close(oDlg2)
	Activate Dialog oDlg2 Centered

	cString:= ALIAS()


//+--------------------------------------------------------------+
//¦ Inicializa variaveis graficas                                ¦
//+--------------------------------------------------------------+

	aOkImp := .f.
	nHeight:=15
	lBold:= .F.
	lUnderLine:= .F.
	lPixel:= .T.
	lPrint:=.F.
	nSedex := 1

	oFont9 :=TFont():New( "Arial"   ,,14,,.T.,,,,,.F. )
//oFont9a:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
	oFont9a:=TFont():New( "Times New Roman"   ,,12,,.F.,,,,,.F. )
	oFont9x:=TFont():New( "Times New Roman"   ,,10,,.F.,,,,,.T. )

	oFont9b:=TFont():New( "Arial"   ,,12,,.T.,,,,,.F. )

	oPrn := TMSPrinter():New()
	oPrn:Setup()



	LinCab := 0
	cabec1 :=" "
	cabec2 :=" "
	cabec3 :=" "
	cabec4 :=" "
	cBitMap:= "ALUBAR_20anos.Bmp"

	IF EMPTY(_FIM)
		_FIM:=_INI
	ENDIF
//+-----------------------------------------------------------+
//¦ Inicio do Relatorio                                       ¦
//+-----------------------------------------------------------+
	DBSELECTAREA("SRA")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SRA")+_INI,.T.)
	WHILE !EOF() .AND. RA_MAT<=_FIM
		oPrn:EndPage()
		Linha := 70
		nPag  := nPag +1

		//oPrn:SayBitmap( Linha+050,080,cBitMap,2080,480 )
		oPrn:SayBitmap( Linha+050,980,cBitMap,1060,250 )

		oPrn:Say(Linha:=Linha+600,550,"Autorização para Desconto em Folha de Pagamento" , oFont9)


		IF SM0->M0_CODIGO="06"
			_SALTO:=60
			oPrn:Say(Linha:=Linha+300     ,300,"Eu, "+SRA->RA_NOME+", matrícula "+sra->ra_mat+" e portador da carteira" , oFont9a)
			oPrn:Say(Linha:=Linha+_SALTO  ,300,"profissional Num.: "+SRA->RA_NUMCP+", série "+SRA->RA_SERCP+" autorizo a empresa a descontar mensalmente" , oFont9a)
			oPrn:Say(Linha:=Linha+_SALTO  ,300,"dos meus vencimentos as importâncias destinadas a minha adesão e de meus dependentes legais," , oFont9a)
			oPrn:Say(Linha:=Linha+_SALTO  ,300,"quando houver, relativas à Assistência Médica, Assistência Odontológica e Farmácia, bem como" , oFont9a)
			oPrn:Say(Linha:=Linha+_SALTO  ,300,"Cabana Clube, caso eu opte pela associação." , oFont9a)

			oPrn:Say(Linha:=Linha+150     ,300,"Declaro ainda estar ciente de que os descontos praticados nos itens relacionados acima, estão de" , oFont9a)
			oPrn:Say(Linha:=Linha+_SALTO  ,300,"acordo com o que determina o Acordo Coletivo de Trabalho vigente, firmado entre a Alubar Metais" , oFont9a)
			oPrn:Say(Linha:=Linha+_SALTO  ,300,"e Cabos S/A e o Sindicato dos Trabalhadores nas Indústrias Metalúrgicas, Mecânicas e de Material" , oFont9a)
			oPrn:Say(Linha:=Linha+_SALTO  ,300,"Elétrico do Município de Barcarena (SIMEB) - Pará, e baseado no Artigo 462 da CLT*." , oFont9a)
		ELSEIF SM0->M0_CODIGO="09"   // COOPERTEC
			_SALTO:=60
			oPrn:Say(Linha:=Linha+300     ,300,"Eu, "+SRA->RA_NOME+", matrícula "+sra->ra_mat+" e portador da carteira" , oFont9a)
			oPrn:Say(Linha:=Linha+_SALTO  ,300,"profissional Num.: "+SRA->RA_NUMCP+", série "+SRA->RA_SERCP+" autorizo a empresa a descontar mensalmente" , oFont9a)
			oPrn:Say(Linha:=Linha+_SALTO  ,300,"dos meus vencimentos as importâncias destinadas a minha adesão e de meus dependentes legais," , oFont9a)
			oPrn:Say(Linha:=Linha+_SALTO  ,300,"quando houver, relativas à Assistência Médica, Assistência Odontológica e Farmácia." , oFont9a)
		ENDIF

		oPrn:Say(Linha:=Linha+200 ,300,"Assim, firmo o presente documento para que produza os seus efeitos legais." , oFont9a)

		oPrn:Say(Linha:=Linha+200 ,300,"Barcarena/PA , "+DTOC(DDatabase) , oFont9a)

		oPrn:line( Linha:=Linha+300       ,0600 ,Linha,1700)     // Linha horizontal
		oPrn:Say(Linha:=Linha    ,0600,SRA->RA_NOME , oFont9B)

		oPrn:Say(Linha:=Linha+300     ,300,'"*Art. 462 - Ao empregador é vedado efetuar qualquer desconto nos salários do empregado, salvo quando este' , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,'resultar de adiantamentos, de dispositivos de lei ou de contrato coletivo."' , oFont9a)


		DBSELECTAREA("SRA")
		DBSKIP()
	ENDDO

	oPrn:Preview()
	MS_FLUSH()

	oPrn:EndPage()


RETURN







	**************
user Function uCONTRATO()    // ROTINA DE IMPRESSAO DE CONTRATO DE TRABALHO ... By JOSE MACEDO
	**************

	nOrdem :=0
	Z:=0
	M:=0
	tamanho:="M"
	limite:=220
	titulo   := PADC("CONTRATO DE TRABALHO",74)
	cDesc1   := PADC(" ",74)
	cDesc2   := PADC(" ",74)
	cDesc3   := PADC(" ",74)
	cNatureza:=""
	aReturn  := { "Especial", 1,"Administracao", 2, 2, 1,"",1 }
	nPag     := 0
	nomeprog := "CONTRA"
	cPerg    := "CONTRA"
	wnrel    := SUBSTR(CUSUARIO,7,3)+"_CONTRA"
	nLastKey := 0
	lContinua:= .T.
	nLin     := 0

	_TXCORREA:= 0
	_TXJURREA:= 0
	_QUAL    := ""
	_A:=ARRAY(10,20)

//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas                                      ¦
//+-------------------------------------------------------------------------+
	_INI:=_FIM:=SPACE(6)
	_MOD:=1
	@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Matricula"
	@ 10, 22 SAY "De :"
	@ 10, 49 GET _INI  SIZE 25,12 F3 "SRA"
	@ 22, 22 SAY "Ate:"
	@ 22, 49 GET _FIM  SIZE 25,12 F3 "SRA"

	@ 34, 05 SAY "Modelo: 1-Normal 2-HomeOffice 3-Novo"
	@ 44, 55 GET _MOD  PICTURE "99"

	@ 60, 95 BmpButton Type 1 Action Close(oDlg2)
	Activate Dialog oDlg2 Centered

	cString:= ALIAS()


//+--------------------------------------------------------------+
//¦ Inicializa variaveis graficas                                ¦
//+--------------------------------------------------------------+

	aOkImp := .f.
	nHeight:=15
	lBold:= .F.
	lUnderLine:= .F.
	lPixel:= .T.
	lPrint:=.F.
	nSedex := 1

	oFont9 :=TFont():New( "Arial"   ,,14,,.T.,,,,,.F. )
//oFont9a:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
	oFont9a:=TFont():New( "Times New Roman"   ,,12,,.F.,,,,,.F. )
	oFont9b:=TFont():New( "Arial"   ,,12,,.T.,,,,,.F. )

	oPrn := TMSPrinter():New()
	oPrn:Setup()


//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+

	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,"M","",.T.)

	If nLastKey == 27 .or. Lastkey() == 27
		Return
	Endif

//+--------------------------------------------------------------+
//¦ Verifica Posicao do Formulario na Impressora                 ¦
//+--------------------------------------------------------------+
	SetDefault(aReturn,cString)

	If nLastKey == 27 .or. Lastkey() == 27
		Return
	Endif


	LinCab := 0
	cabec1 :=" "
	cabec2 :=" "
	cabec3 :=" "
	cabec4 :=" "
	cBitMap:= "ALUBAR.Bmp"



	IF EMPTY(_FIM)
		_FIM:=_INI
	ENDIF
	IF _MOD=1
		MODELO1()
	ELSEIF _MOD=2
		MODELO2()
	ELSEIF _MOD=3
		MODELO3()
	ENDIF
RETURN


//+-----------------------------------------------------------+
//¦ Inicio do Relatorio                                       ¦
//+-----------------------------------------------------------+

//********************
STATIC FUNCTION MODELO1()
//*********************
	DBSELECTAREA("SRA")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SRA")+_INI,.T.)
	WHILE !EOF() .AND. RA_MAT<=_FIM
		oPrn:EndPage()
		Linha := 70
		nPag  := nPag +1

		oPrn:SayBitmap( Linha+050,080,cBitMap,480,180 )

		oPrn:Say(Linha:=Linha+200,750,"CONTRATO DE TRABALHO A TITULO DE EXPERIENCIA" , oFont9)

		oPrn:line( Linha:=Linha+50   ,  80 ,Linha,2260)     // Linha horizontal

		_SALTO:=60
		oPrn:Say(Linha:=Linha+100 ,300,"Entre a firma  "+SM0->M0_NOMECOM+", domiciliada em "+ALLTRIM(SM0->M0_CIDCOB)+"/"+SM0->M0_ESTCOB , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,ALLTRIM(SM0->M0_ENDCOB)+", Bairro "+SM0->M0_BAIRCOB+" e CEP: "+SM0->M0_CEPCOB , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,"registrada no CNPJ. MF.: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+", designada simplesmente EMPREGADORA, e" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,SRA->RA_NOME+", portador da carteira" , oFont9B)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,"profissional Num.: "+SRA->RA_NUMCP+", serie "+SRA->RA_SERCP+" a seguir chamado apenas EMPREGADO," , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,"é celebrado o presente CONTRATO DE EXPERIÊNCIA, que terá vigencia a partir da data de" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,"inicio da prestação de serviços, de acordo com as condições a seguir especificadas:" , oFont9a)

		oPrn:Say(Linha:=Linha+100 ,300,"         1. Fica o EMPREGADO admitido no quadro de funcionários da EMPREGADORA, para" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"exercer a funcao de "+POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")+", mediante remuneraçâo de R$ "+TRANSFORM(SRA->RA_SALARIO,"@EZ 99,999,999.99") , oFont9a)
		cExtenso := "("+Extenso( SRA->RA_SALARIO, .F., 1 )+") por mes."
		oPrn:Say(Linha:=Linha+_SALTO ,300,Trim(SubStr(cExtenso,1,100)) , oFont9B)
		If Len(Trim(cExtenso)) > 100
			oPrn:Say(Linha:=Linha+_SALTO ,300,SubStr(cExtenso,101,Len(Trim(cExtenso))-100) , oFont9B)
		ENDIF

		oPrn:Say(Linha:=Linha+_SALTO ,300,"A circunstância, porém, de ser função especificada não importa na intransferibilidade" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"do EMPREGADO para outros serviços, no qual demonstre melhor capacidade  de  adaptação" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"desde que compatível com sua condição pessoal." , oFont9a)

		oPrn:Say(Linha:=Linha+100    ,300,"         2. O horário de trabalho será anotado na sua  ficha de  registro e a redução" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"da jornada, por  determinação da empregadora,  não  inovará este ajuste, permanecendo" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"sempre  íntegra   a obrigação  do  EMPREGADO de   cumprir  o  horário   que   lhe for" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"determinado, observando o limite legal." , oFont9a)

		oPrn:Say(Linha:=Linha+100    ,300,"         3. Obriga-se também o empregado a prestar serviços em horas extraordinárias," , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"sempre que for determinado pela EMPREGADORA, na forma prevista em Lei." , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"Na hipótese desta   faculdade  pela    EMPREGADORA, o EMPREGADO  receberá  as   horas" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"extraordinarias  com o  acréscimo  legal, salvo a ocorrência  de  compensação,  com a" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"consequente redução da jornada de trabalho em outro dia." , oFont9a)

		oPrn:Say(Linha:=Linha+100    ,300,"         4.Aceita o   EMPREGADO,  expressamente,   a condição de prestar  serviços em" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"qualquer dos turnos  de trabalho, isto é, tanto durante o dia como a noite, deste que" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"sem simultaneidade,  observadas as  prescrições legais reguladoras do assunto, quanto" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"à remuneração." , oFont9a)

		oPrn:Say(Linha:=Linha+100    ,300,"         5. Fica ajustado nos termos do que dispões o §1º-artigo 469, da Consolidação" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"das Leis do Trabalho,que o empregado para a prestação de serviços tanto na localidade" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"de celebração do Contrato de Trabalho, como em qualquer outra cidade, Capital ou Vila" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"do Território Nacional,quer essa transferência seja transitória,quer seja definitiva." , oFont9a)


//                               ,300,"é celebrado o presente CONTRATO DE EXPERIÊNCIA, que terá vigencia a partir da data de" , oFont9a)
		oPrn:Say(Linha:=Linha+100    ,300,"         6. No ato da assinatura  deste  contrato, o empregado  recebe o  Regulamento" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"Interno da   Empresa cujas  cláusulas fazem  parte  do  Contrato  de  Trabalho,  e  a" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"violação delas implicará em  sanção, cuja graduação  dependerá da gravidade da mesma," , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"culminando com a rescisão do contrato." , oFont9a)

		oPrn:EndPage()
		Linha := 70
		nPag  := nPag +1

		oPrn:Say(Linha:=Linha+100 ,300,"         7. Em caso de dano causado pelo EMPREGADO, fica a " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"EMPREGADORA, autorizada a efetivar o desconto da importância correspondente" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"ao prejuízo, o qual fará, com fundamento no § 1º do artigo 462 da Consolidação das" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"Leis do trabalho, já que essa possibilidade fica expressamente prevista em Contrato." , oFont9a)

		oPrn:Say(Linha:=Linha+100 ,300,"         8. O presente Contrato, vigerá, durante 45 (quarenta e cinco) dias, prorrogáveis" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"por igual periodo celebrado para as partes, que verificarão reciprocamente, a " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"conveniência ou não de se vincularem em caráter definitivo a um Contrato de Trabalho." , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"A Empresa passando a conhecer as aptidões do EMPREGADO e suas qualidades pessoais e " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"morais; o EMPREGADO verificando se o ambiente e os métodos de trabalho atendem à" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"sua conveniência." , oFont9a)

		oPrn:Say(Linha:=Linha+100 ,300,"         9. Opera-se a rescisão do presente Contrato pela decorrência do prazo " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"supra ou por vontade de uma das partes; rescindindo-se por vontade do " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"EMPREGADO ou pela EMPREGADORA com justa causa, nenhuma indenização " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"é devida; rescindindo-se, antes do prazo, pela EMPREGADORA, fica esta " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"obrigada a pagar 50% dos salários devidos até o final (metade do tempo combinado " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"restante), nos termos do artigo 479 da C.L.T., sem prejuízo do disposto no Reg. do " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"F.G.T.S. Nenhum aviso prévio é devido pela rescisão do presente Contrato." , oFont9a)

		oPrn:Say(Linha:=Linha+100 ,300,"        10. Na hipótese deste ajuste transformar-se em Contrato de Prazo " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"Indeterminado, pelo decurso do tempo, continuarão em plena vigência as cláusulas " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"de 1 (um) a 7 (sete), enquanto as relações do EMPREGADO com a EMPREGADORA." , oFont9a)

		oPrn:Say(Linha:=Linha+100 ,300,"E por estarem de pleno acordo, as partes contratantes, assinam o presente Contrato  " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"Experiência em duas vias, ficando a primeira em poder da EMPREGADORA, e a " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"Segunda com o EMPREGADO, que dela dará o competente recibo." , oFont9a)


		oPrn:Say(Linha:=Linha+200 ,700,SM0->M0_CIDENT+","+DTOC(SRA->RA_ADMISSA) , oFont9a)

		oPrn:line( Linha:=Linha+250   ,  80 ,Linha,700)     // Linha horizontal
		oPrn:line( Linha:=Linha       ,1000 ,Linha,1700)     // Linha horizontal
		oPrn:Say(Linha:=Linha+50 ,80,  " Testemunhas" , oFont9a)
		oPrn:Say(Linha:=Linha    ,1000,SM0->M0_NOMECOM , oFont9B)

		oPrn:line( Linha:=Linha+200   ,  80 ,Linha,700)     // Linha horizontal
		oPrn:line( Linha:=Linha       ,1000 ,Linha,1700)     // Linha horizontal
		oPrn:Say(Linha:=Linha+50 ,80,  " Testemunhas" , oFont9a)
		oPrn:Say(Linha:=Linha    ,1000,SRA->RA_NOME , oFont9B)


		//************************************************************************************
		oPrn:EndPage()
		Linha := 70
		nPag  := nPag +1

		_d1:=SRA->RA_ADMISSA+44
		_d2:=_d1 + 45

		oPrn:Say(Linha:=Linha+200,750,"TERMO DE PRORROGAÇÃO" , oFont9)
		oPrn:Say(Linha:=Linha+200 ,300,"Por mútuo acordo entre as partes, fica o presente contrato de experiência firmado" , oFont9a)
//	oPrn:Say(Linha:=Linha+70  ,300,"que deveria terminar em      /       /           , fica prorrogado até       /           /            ." , oFont9a)
		oPrn:Say(Linha:=Linha+70  ,300,"que deveria terminar em "+DtoC(_d1)+", fica prorrogado até "+DtoC(_d2)+"." , oFont9a)


		oPrn:Say(Linha:=Linha+200 ,700,SM0->M0_CIDENT+","+DTOC(SRA->RA_ADMISSA+44) , oFont9a)

		oPrn:line( Linha:=Linha+250   ,  80 ,Linha,700)     // Linha horizontal
		oPrn:line( Linha:=Linha       ,1000 ,Linha,1700)     // Linha horizontal
		oPrn:Say(Linha:=Linha+50 ,80,  " Testemunhas" , oFont9a)
		oPrn:Say(Linha:=Linha    ,1000,SM0->M0_NOMECOM , oFont9B)

		oPrn:line( Linha:=Linha+200   ,  80 ,Linha,700)     // Linha horizontal
		oPrn:line( Linha:=Linha       ,1000 ,Linha,1700)     // Linha horizontal
		oPrn:Say(Linha:=Linha+50 ,80,  " Testemunhas" , oFont9a)
		oPrn:Say(Linha:=Linha    ,1000,SRA->RA_NOME , oFont9B)



		DBSELECTAREA("SRA")
		DBSKIP()
	ENDDO
	oPrn:Preview()
	MS_FLUSH()
	oPrn:EndPage()

RETURN


//********************
STATIC FUNCTION MODELO2()
//*********************


	DBSELECTAREA("SRA")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SRA")+_INI,.T.)
	WHILE !EOF() .AND. RA_MAT<=_FIM
		oPrn:EndPage()
		Linha := 70
		nPag  := nPag +1

		oPrn:SayBitmap( Linha+050,080,cBitMap,480,180 )

		oPrn:Say(Linha:=Linha+200,750,"CONTRATO DE TRABALHO A TITULO DE EXPERIENCIA" , oFont9)

		oPrn:line( Linha:=Linha+50   ,  80 ,Linha,2260)     // Linha horizontal



		_SALTO:=60
		oPrn:Say(Linha:=Linha+100 ,300,"Entre a firma  "+SM0->M0_NOMECOM+", domiciliada em Barcarena/Pa., à Área 4" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,"Zona Portuária Porto de Vila do Conde S/N   em  Barcarena no estado Pará," , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,"registrada no CNPJ. MF.: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+", designada simplesmente EMPREGADORA, e" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,SRA->RA_NOME+", portador da carteira" , oFont9B)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,"profissional Num.: "+SRA->RA_NUMCP+", serie "+SRA->RA_SERCP+" a seguir chamado apenas EMPREGADO," , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,"é celebrado o presente CONTRATO DE EXPERIÊNCIA, que terá vigencia a partir da data de" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,"inicio da prestação de serviços, de acordo com as condições a seguir especificadas:" , oFont9a)

		oPrn:Say(Linha:=Linha+100 ,300,"1. Fica o EMPREGADO admitido no quadro de funcionários da EMPREGADORA, para exercer" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"a funcao de "+POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")+", mediante remuneraçâo de R$ "+TRANSFORM(SRA->RA_SALARIO,"@EZ 99,999,999.99") , oFont9a)
		cExtenso := "("+Extenso( SRA->RA_SALARIO, .F., 1 )+") por mes."
		oPrn:Say(Linha:=Linha+_SALTO ,300,Trim(SubStr(cExtenso,1,100)) , oFont9B)
		If Len(Trim(cExtenso)) > 100
			oPrn:Say(Linha:=Linha+_SALTO ,300,SubStr(cExtenso,101,Len(Trim(cExtenso))-100) , oFont9B)
		ENDIF

		oPrn:Say(Linha:=Linha+_SALTO ,300,"A circunstância, porém, de ser função especificada não importa na intransferibilidade" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"do EMPREGADO para outros serviços, no qual demonstre melhor capacidade  de  adaptação" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"desde que compatível com sua condição pessoal." , oFont9a)

//***************************** INI NOVO MODELO NO LUGAR DE 2, 3 E 4. (1/2)
		oPrn:Say(Linha:=Linha+100    ,300,"2. O EMPREGADO, em razão de prestar os serviços contratados em sua própria residência," , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"exercerá suas atividades sem qualquer vinculação a horário e sem controle de frequência," , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"podendo esquematizá-lo da forma como entender conveniente, nos termos do art. 62, I, da" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"CLT, aplicável ao caso, devendo sua jornada, de qualquer forma, não ultrapassar 8 horas" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"diárias e 44 horas semanais, devendo ainda zelar pelo cumprimento da referida jornada." , oFont9a)
//***************************** FIM NOVO MODELO

		oPrn:Say(Linha:=Linha+100    ,300,"3. Fica ajustado nos termos do que dispões o §1º-artigo 469, da Consolidação das" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"Leis do Trabalho,que o empregado para a prestação de serviços tanto na localidade" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"de celebração do Contrato de Trabalho, como em qualquer outra cidade, Capital ou Vila" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"do Território Nacional,quer essa transferência seja transitória,quer seja definitiva." , oFont9a)


		oPrn:Say(Linha:=Linha+100    ,300,"4. No ato da assinatura  deste  contrato, o empregado  recebe o  Regulamento" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"Interno da   Empresa cujas  cláusulas fazem  parte  do  Contrato  de  Trabalho,  e  a" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"violação delas implicará em  sanção, cuja graduação  dependerá da gravidade da mesma," , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"culminando com a rescisão do contrato." , oFont9a)


		//***************** INICIO NOVO MODELO 2/2
		oPrn:Say(Linha:=Linha+100    ,300,"5. O EMPREGADO é contratado para prestar os serviços objeto do presente contrato na cidade" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"de Catende-PE, em sua própria residência  (teletrabalho), podendo se locomover no estado" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"de Pernambuco e na região nordeste, para atender clientes da empresa, quando necessário." , oFont9a)

		oPrn:Say(Linha:=Linha+100    ,300,"6. A empresa fornecerá os equipamentos a serem usados pelo EMPREGADO na execução de seus serviços." , oFont9a)

		oPrn:Say(Linha:=Linha+100    ,300,"7. A empresa fornecerá  ao EMPREGADO valor mensal, a título de ajuda de custo para gastos com " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"combustível, nos atendimentos aos clientes, de forma antecipada com base em provisão mensal" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"de gastos, devendo o EMPREGADO prestar conta mensalmente dos gastos, perante a empresa." , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"Esta parcela não constitui salário do EMPREGADO." , oFont9a)

		oPrn:EndPage()
		Linha := 70
		nPag  := nPag +1

		oPrn:Say(Linha:=Linha+100    ,300,"8. Todo software ou hardware comprado pela empresa continua sendo propriedade desta e deverá " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"ser devolvido quando solicitado, sendo a empresa responsável pela manutenção dos seus equipamentos." , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"De igual modo, todos os produtos desenvolvidos durante o teletrabalho pelo EMPREGADO serão de" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"propriedade da empresa." , oFont9a)

		oPrn:Say(Linha:=Linha+100    ,300,"9. Os softwares usados pelo EMPREGADO estão sujeitos às mesmas restrições sobre duplicação e uso" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"não autorizado que os usados na empresa." , oFont9a)

		oPrn:Say(Linha:=Linha+100    ,300,"10. A empresa não se responsabiliza pelo conserto, manutenção ou substituição de equipamento de" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"propriedade particular usado pelo EMPREGADO em trabalho remoto." , oFont9a)

		//***************** fim

		oPrn:Say(Linha:=Linha+100 ,300,"11. Em caso de dano causado pelo EMPREGADO, fica a EMPREGADORA," , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"autorizada a efetivar o desconto da importância correspondente ao prejuízo," , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"o qual fará, com fundamento no § 1º do artigo 462 da Consolidação das" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"Leis do trabalho, já que essa possibilidade fica expressamente prevista em Contrato." , oFont9a)

		oPrn:Say(Linha:=Linha+100 ,300,"12. O presente Contrato, vigerá, durante 45 (quarenta e cinco) dias, prorrogáveis" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"por igual periodo celebrado para as partes, que verificarão reciprocamente, a " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"conveniência ou não de se vincularem em caráter definitivo a um Contrato de Trabalho." , oFont9a)

		oPrn:Say(Linha:=Linha+100 ,300,"13. A Empresa passando a conhecer as aptidões do EMPREGADO e suas qualidades pessoais e " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"morais; o EMPREGADO verificando se o ambiente e os métodos de trabalho atendem à" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"sua conveniência." , oFont9a)

		oPrn:Say(Linha:=Linha+100 ,300,"14. Opera-se a rescisão do presente Contrato pela decorrência do prazo " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"supra ou por vontade de uma das partes; rescindindo-se por vontade do " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"EMPREGADO ou pela EMPREGADORA com justa causa, nenhuma indenização " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"é devida; rescindindo-se, antes do prazo, pela EMPREGADORA, fica esta " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"obrigada a pagar 50% dos salários devidos até o final (metade do tempo combinado " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"restante), nos termos do artigo 479 da C.L.T., sem prejuízo do disposto no Reg. do " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"F.G.T.S. Nenhum aviso prévio é devido pela rescisão do presente Contrato." , oFont9a)

		oPrn:Say(Linha:=Linha+100 ,300,"15. Na hipótese deste ajuste transformar-se em Contrato de Prazo " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"Indeterminado, pelo decurso do tempo, continuarão em plena vigência as cláusulas " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"de 1 (um) a 11 (onze), enquanto as relações do EMPREGADO com a EMPREGADORA." , oFont9a)

		oPrn:Say(Linha:=Linha+100 ,300,"E por estarem de pleno acordo, as partes contratantes, assinam o presente Contrato  " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"Experiência em duas vias, ficando a primeira em poder da EMPREGADORA, e a " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"Segunda com o EMPREGADO, que dela dará o competente recibo." , oFont9a)


//	oPrn:Say(Linha:=Linha+200 ,700,"Barcarena/PA , "+DTOC(SRA->RA_ADMISSA) , oFont9a)
		oPrn:Say(Linha:=Linha+200 ,700,SM0->M0_CIDENT+","+DTOC(SRA->RA_ADMISSA) , oFont9a)

		oPrn:line( Linha:=Linha+250   ,  80 ,Linha,700)     // Linha horizontal
		oPrn:line( Linha:=Linha       ,1000 ,Linha,1700)     // Linha horizontal
		oPrn:Say(Linha:=Linha+50 ,80,  " Testemunhas" , oFont9a)
		oPrn:Say(Linha:=Linha    ,1000,SM0->M0_NOMECOM , oFont9B)

		oPrn:line( Linha:=Linha+200   ,  80 ,Linha,700)     // Linha horizontal
		oPrn:line( Linha:=Linha       ,1000 ,Linha,1700)     // Linha horizontal
		oPrn:Say(Linha:=Linha+50 ,80,  " Testemunhas" , oFont9a)
		oPrn:Say(Linha:=Linha    ,1000,SRA->RA_NOME , oFont9B)


		//************************************************************************************
		oPrn:EndPage()
		Linha := 70
		nPag  := nPag +1

		_d1:=SRA->RA_ADMISSA+44
		_d2:=_d1 + 45

		oPrn:Say(Linha:=Linha+200,750,"TERMO DE PRORROGAÇÃO" , oFont9)
		oPrn:Say(Linha:=Linha+200 ,300,"Por mútuo acordo entre as partes, fica o presente contrato de experiência firmado" , oFont9a)
//	oPrn:Say(Linha:=Linha+70  ,300,"que deveria terminar em      /       /           , fica prorrogado até       /           /            ." , oFont9a)
		oPrn:Say(Linha:=Linha+70  ,300,"que deveria terminar em "+DtoC(_d1)+", fica prorrogado até "+DtoC(_d2)+"." , oFont9a)


		oPrn:Say(Linha:=Linha+200 ,700,SM0->M0_CIDENT+","+DTOC(SRA->RA_ADMISSA) , oFont9a)

		oPrn:line( Linha:=Linha+250   ,  80 ,Linha,700)     // Linha horizontal
		oPrn:line( Linha:=Linha       ,1000 ,Linha,1700)     // Linha horizontal
		oPrn:Say(Linha:=Linha+50 ,80,  " Testemunhas" , oFont9a)
		oPrn:Say(Linha:=Linha    ,1000,SM0->M0_NOMECOM , oFont9B)

		oPrn:line( Linha:=Linha+200   ,  80 ,Linha,700)     // Linha horizontal
		oPrn:line( Linha:=Linha       ,1000 ,Linha,1700)     // Linha horizontal
		oPrn:Say(Linha:=Linha+50 ,80,  " Testemunhas" , oFont9a)
		oPrn:Say(Linha:=Linha    ,1000,SRA->RA_NOME , oFont9B)



		DBSELECTAREA("SRA")
		DBSKIP()
	ENDDO

	oPrn:Preview()
	MS_FLUSH()

	oPrn:EndPage()

RETURN

//********************
STATIC FUNCTION MODELO3()
//*********************
	LOCAL _ESTEMP := SM0->M0_ESTCOB
	DBSELECTAREA("SRA")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SRA")+_INI,.T.)
	WHILE !EOF() .AND. RA_MAT<=_FIM
		oPrn:EndPage()
		Linha := 70
		nPag  := nPag +1

		oPrn:SayBitmap( Linha+050,080,cBitMap,480,180 )

		oPrn:Say(Linha:=Linha+200,750,"CONTRATO DE TRABALHO" , oFont9)

		DO CASE
		CASE _ESTEMP=='AC'
			_ESTEMP := 'no estado do Acre'
		CASE _ESTEMP=='AL'
			_ESTEMP := 'no estado de Alagoas'
		CASE _ESTEMP=='AP'
			_ESTEMP := 'no estado do Amapá'
		CASE _ESTEMP=='AM'
			_ESTEMP := 'no estado do Amazonas'
		CASE _ESTEMP=='BA'
			_ESTEMP := 'no estado da Bahia'
		CASE _ESTEMP=='CE'
			_ESTEMP := 'no estado do Ceara'
		CASE _ESTEMP=='DF'
			_ESTEMP := 'no Distrito Federal'
		CASE _ESTEMP=='ES'
			_ESTEMP := 'no estado do Espiríto Santo'
		CASE _ESTEMP=='GO'
			_ESTEMP := 'no estado de Goiás'
		CASE _ESTEMP=='MA'
			_ESTEMP := 'no estado do Maranhão'
		CASE _ESTEMP=='MT'
			_ESTEMP := 'no estado de Mato Grosso'
		CASE _ESTEMP=='MS'
			_ESTEMP := 'no estado de Mato Grosso do Sul'
		CASE _ESTEMP=='MG'
			_ESTEMP := 'no estado de Minas Gerais'
		CASE _ESTEMP=='PA'
			_ESTEMP := 'no estado do Pará'
		CASE _ESTEMP=='PB'
			_ESTEMP := 'no estado da Paraíba'
		CASE _ESTEMP=='PR'
			_ESTEMP := 'no estado do Paraná'
		CASE _ESTEMP=='PE'
			_ESTEMP := 'no estado de Pernambuco'
		CASE _ESTEMP=='PI'
			_ESTEMP := 'no estado do Piauí'
		CASE _ESTEMP=='RJ'
			_ESTEMP := 'no estado do Rio de Janeiro'
		CASE _ESTEMP=='RN'
			_ESTEMP := 'no estado do Rio Grande do Norte'
		CASE _ESTEMP=='RS'
			_ESTEMP := 'no estado do Rio Grande do Sul'
		CASE _ESTEMP=='RO'
			_ESTEMP := 'no estado de Rondônia'
		CASE _ESTEMP=='RR'
			_ESTEMP := 'no estado de Roraima'
		CASE _ESTEMP=='SC'
			_ESTEMP := 'no estado de Santa Catarina'
		CASE _ESTEMP=='SP'
			_ESTEMP := 'no estado de São Paulo'
		CASE _ESTEMP=='SE'
			_ESTEMP := 'no estado de Sergipe'
		CASE _ESTEMP=='TO'
			_ESTEMP := 'no estado de Tocantins'
			OTHERWISE
			_ESTEMP := 'no '+_ESTEMP
		ENDCASE

		_SALTO:=60
		oPrn:Say(Linha:=Linha+100 ,300,"Entre a empresa  "+alltrim(SM0->M0_NOMECOM)+", domiciliada em "+ALLTRIM(SM0->M0_CIDCOB)+","+ALLTRIM(SM0->M0_ENDCOB)+"," , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,", Bairro "+alltrim(SM0->M0_BAIRCOB)+", "+_ESTEMP+", inscrita no CNPJ/MF "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+", doravante " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,", designada simplesmente EMPREGADORA; e"+AllTrim(SRA->RA_NOME)+", "+TABELA("34",SRA->RA_NACIONA)+", ", oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,TABELA("33",SRA->RA_ESTCIVI)+", inscrito no RG sob o nº "+SRA->RA_RG+" e no CPF sob o nº "+SRA->RA_CIC+", com endereço na Rua " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,"" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,"inicio da prestação de serviços, de acordo com as condições a seguir especificadas:" , oFont9a)

		oPrn:Say(Linha:=Linha+100 ,300,"         1. Fica o EMPREGADO admitido no quadro de funcionários da EMPREGADORA, para" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"exercer a funcao de "+POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")+", mediante remuneraçâo de R$ "+TRANSFORM(SRA->RA_SALARIO,"@EZ 99,999,999.99") , oFont9a)
		cExtenso := "("+Extenso( SRA->RA_SALARIO, .F., 1 )+") por mes."
		oPrn:Say(Linha:=Linha+_SALTO ,300,Trim(SubStr(cExtenso,1,100)) , oFont9B)
		If Len(Trim(cExtenso)) > 100
			oPrn:Say(Linha:=Linha+_SALTO ,300,SubStr(cExtenso,101,Len(Trim(cExtenso))-100) , oFont9B)
		ENDIF

		oPrn:Say(Linha:=Linha+_SALTO ,300,"A circunstância, porém, de ser função especificada não importa na intransferibilidade" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"do EMPREGADO para outros serviços, no qual demonstre melhor capacidade  de  adaptação" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"desde que compatível com sua condição pessoal." , oFont9a)

		oPrn:Say(Linha:=Linha+100    ,300,"         2. O horário de trabalho será anotado na sua  ficha de  registro e a redução" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"da jornada, por  determinação da empregadora,  não  inovará este ajuste, permanecendo" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"sempre  íntegra   a obrigação  do  EMPREGADO de   cumprir  o  horário   que   lhe for" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"determinado, observando o limite legal." , oFont9a)

		oPrn:Say(Linha:=Linha+100    ,300,"         3. Obriga-se também o empregado a prestar serviços em horas extraordinárias," , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"sempre que for determinado pela EMPREGADORA, na forma prevista em Lei." , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"Na hipótese desta   faculdade  pela    EMPREGADORA, o EMPREGADO  receberá  as   horas" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"extraordinarias  com o  acréscimo  legal, salvo a ocorrência  de  compensação,  com a" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"consequente redução da jornada de trabalho em outro dia." , oFont9a)

		oPrn:Say(Linha:=Linha+100    ,300,"         4.Aceita o   EMPREGADO,  expressamente,   a condição de prestar  serviços em" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"qualquer dos turnos  de trabalho, isto é, tanto durante o dia como a noite, deste que" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"sem simultaneidade,  observadas as  prescrições legais reguladoras do assunto, quanto" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"à remuneração." , oFont9a)

		oPrn:Say(Linha:=Linha+100    ,300,"         5. Fica ajustado nos termos do que dispões o §1º-artigo 469, da Consolidação" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"das Leis do Trabalho,que o empregado para a prestação de serviços tanto na localidade" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"de celebração do Contrato de Trabalho, como em qualquer outra cidade, Capital ou Vila" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"do Território Nacional,quer essa transferência seja transitória,quer seja definitiva." , oFont9a)


//                               ,300,"é celebrado o presente CONTRATO DE EXPERIÊNCIA, que terá vigencia a partir da data de" , oFont9a)
		oPrn:Say(Linha:=Linha+100    ,300,"         6. No ato da assinatura  deste  contrato, o empregado  recebe o  Regulamento" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"Interno da   Empresa cujas  cláusulas fazem  parte  do  Contrato  de  Trabalho,  e  a" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"violação delas implicará em  sanção, cuja graduação  dependerá da gravidade da mesma," , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"culminando com a rescisão do contrato." , oFont9a)

		oPrn:EndPage()
		Linha := 70
		nPag  := nPag +1

		oPrn:Say(Linha:=Linha+100 ,300,"         7. Em caso de dano causado pelo EMPREGADO, fica a " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"EMPREGADORA, autorizada a efetivar o desconto da importância correspondente" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"ao prejuízo, o qual fará, com fundamento no § 1º do artigo 462 da Consolidação das" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"Leis do trabalho, já que essa possibilidade fica expressamente prevista em Contrato." , oFont9a)

		oPrn:Say(Linha:=Linha+100 ,300,"         8. O presente Contrato, vigerá, durante 45 (quarenta e cinco) dias, prorrogáveis" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"por igual periodo celebrado para as partes, que verificarão reciprocamente, a " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"conveniência ou não de se vincularem em caráter definitivo a um Contrato de Trabalho." , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"A Empresa passando a conhecer as aptidões do EMPREGADO e suas qualidades pessoais e " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"morais; o EMPREGADO verificando se o ambiente e os métodos de trabalho atendem à" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"sua conveniência." , oFont9a)

		oPrn:Say(Linha:=Linha+100 ,300,"         9. Opera-se a rescisão do presente Contrato pela decorrência do prazo " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"supra ou por vontade de uma das partes; rescindindo-se por vontade do " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"EMPREGADO ou pela EMPREGADORA com justa causa, nenhuma indenização " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"é devida; rescindindo-se, antes do prazo, pela EMPREGADORA, fica esta " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"obrigada a pagar 50% dos salários devidos até o final (metade do tempo combinado " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"restante), nos termos do artigo 479 da C.L.T., sem prejuízo do disposto no Reg. do " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"F.G.T.S. Nenhum aviso prévio é devido pela rescisão do presente Contrato." , oFont9a)

		oPrn:Say(Linha:=Linha+100 ,300,"        10. Na hipótese deste ajuste transformar-se em Contrato de Prazo " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"Indeterminado, pelo decurso do tempo, continuarão em plena vigência as cláusulas " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"de 1 (um) a 7 (sete), enquanto as relações do EMPREGADO com a EMPREGADORA." , oFont9a)

		oPrn:Say(Linha:=Linha+100 ,300,"E por estarem de pleno acordo, as partes contratantes, assinam o presente Contrato  " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"Experiência em duas vias, ficando a primeira em poder da EMPREGADORA, e a " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"Segunda com o EMPREGADO, que dela dará o competente recibo." , oFont9a)


		oPrn:Say(Linha:=Linha+200 ,700,SM0->M0_CIDENT+","+DTOC(SRA->RA_ADMISSA) , oFont9a)

		oPrn:line( Linha:=Linha+250   ,  80 ,Linha,700)     // Linha horizontal
		oPrn:line( Linha:=Linha       ,1000 ,Linha,1700)     // Linha horizontal
		oPrn:Say(Linha:=Linha+50 ,80,  " Testemunhas" , oFont9a)
		oPrn:Say(Linha:=Linha    ,1000,SM0->M0_NOMECOM , oFont9B)

		oPrn:line( Linha:=Linha+200   ,  80 ,Linha,700)     // Linha horizontal
		oPrn:line( Linha:=Linha       ,1000 ,Linha,1700)     // Linha horizontal
		oPrn:Say(Linha:=Linha+50 ,80,  " Testemunhas" , oFont9a)
		oPrn:Say(Linha:=Linha    ,1000,SRA->RA_NOME , oFont9B)


		//************************************************************************************
		oPrn:EndPage()
		Linha := 70
		nPag  := nPag +1

		_d1:=SRA->RA_ADMISSA+44
		_d2:=_d1 + 45

		oPrn:Say(Linha:=Linha+200,750,"TERMO DE PRORROGAÇÃO" , oFont9)
		oPrn:Say(Linha:=Linha+200 ,300,"Por mútuo acordo entre as partes, fica o presente contrato de experiência firmado" , oFont9a)
//	oPrn:Say(Linha:=Linha+70  ,300,"que deveria terminar em      /       /           , fica prorrogado até       /           /            ." , oFont9a)
		oPrn:Say(Linha:=Linha+70  ,300,"que deveria terminar em "+DtoC(_d1)+", fica prorrogado até "+DtoC(_d2)+"." , oFont9a)


		oPrn:Say(Linha:=Linha+200 ,700,SM0->M0_CIDENT+","+DTOC(SRA->RA_ADMISSA+44) , oFont9a)

		oPrn:line( Linha:=Linha+250   ,  80 ,Linha,700)     // Linha horizontal
		oPrn:line( Linha:=Linha       ,1000 ,Linha,1700)     // Linha horizontal
		oPrn:Say(Linha:=Linha+50 ,80,  " Testemunhas" , oFont9a)
		oPrn:Say(Linha:=Linha    ,1000,SM0->M0_NOMECOM , oFont9B)

		oPrn:line( Linha:=Linha+200   ,  80 ,Linha,700)     // Linha horizontal
		oPrn:line( Linha:=Linha       ,1000 ,Linha,1700)     // Linha horizontal
		oPrn:Say(Linha:=Linha+50 ,80,  " Testemunhas" , oFont9a)
		oPrn:Say(Linha:=Linha    ,1000,SRA->RA_NOME , oFont9B)



		DBSELECTAREA("SRA")
		DBSKIP()
	ENDDO
	oPrn:Preview()
	MS_FLUSH()
	oPrn:EndPage()

RETURN



//********************************************************************************* ACERTA MAIOR REMUNERACAO MANUAL
User Function CadSRG()
//*****************************************************************************************************************

	_cArea := Alias()
	_nOrd  := IndexOrd()
	nReg   :=RecNo()

	DbSelectArea("SRG")
	DbGotop()
	cCadastro:="Dados Rescisorios"
	aRotina := { { "Pesquisa ",  'AxPesqui'            , 0, 1 },;
		{ "Visualiza",  'AxVisual'            , 0, 2 },;
		{ "Atualiza ",  'ExecBlock("xSRGAtu")', 0, 3 } }

	MBrowse(16,00,280,350,"SRG",,)

	dbSelectArea(_cArea)
	DbSetOrder(_nOrd)
	DbGoTo(nReg)

return(nil)

//********************
User Function xSRGAtu()
//********************

	_MAIORREM:=0
	_AVOS    :=0

	IF _MAIORREM==0
		DBSELECTAREA("SRR")
		DBSETORDER(1)
		DBSEEK(SRG->RG_FILIAL+SRG->RG_MAT)
		WHILE !EOF() .AND. RR_MAT == SRG->RG_MAT
			IF RR_PD $ "141-XXX"                 // AVISO PREVIO + MEDIA AVISO
				_MAIORREM:=_MAIORREM + RR_VALOR
			ENDIF
			DBSKIP()
		ENDDO
	ENDIF


	IF _MAIORREM==0
		DBSELECTAREA("SRR")
		DBSETORDER(1)
		DBSEEK(SRG->RG_FILIAL+SRG->RG_MAT)
		WHILE !EOF() .AND. RR_MAT == SRG->RG_MAT
			IF RR_PD $ "128-XXX"                 // FERIAS VENCIDAS + MEDIA (228)
				_MAIORREM:=_MAIORREM + RR_VALOR
			ENDIF
			DBSKIP()
		ENDDO
	ENDIF


	IF _MAIORREM==0
		DBSELECTAREA("SRR")
		DBSETORDER(1)
		DBSEEK(SRG->RG_FILIAL+SRG->RG_MAT)
		WHILE !EOF() .AND. RR_MAT == SRG->RG_MAT
			IF RR_PD $ "145-XXX"                 // FERIAS PROPORCIONAIS + MEDIA (229)
				IF RR_PD=="145"
					_MAIORREM:=_MAIORREM + RR_VALOR
					_AVOS:=INT(RR_HORAS)
				ENDIF
			ENDIF
			DBSKIP()
		ENDDO
		IF _AVOS>0
			_MAIORREM:=(_MAIORREM/_AVOS)*12
		ENDIF
	ENDIF

	IF _MAIORREM==0
		DBSELECTAREA("SRR")
		DBSETORDER(1)
		DBSEEK(SRG->RG_FILIAL+SRG->RG_MAT)
		WHILE !EOF() .AND. RR_MAT == SRG->RG_MAT
			IF RR_PD $ "180-XXX"                 // 13o PAGO EM RESCISAO + MEDIA 13o SALARIO
				IF RR_PD=="180"
					_MAIORREM:=_MAIORREM + RR_VALOR
					_AVOS:=INT(RR_HORAS)
				ENDIF
			ENDIF
			DBSKIP()
		ENDDO
		IF _AVOS>0
			_MAIORREM:=(_MAIORREM/_AVOS)*12
		ENDIF
	ENDIF



	DBSELECTAREA("SRG")
	IF _MAIORREM > 0 .AND. RG_SALMES<>_MAIORREM .AND. ABS((_MAIORREM-SRG->RG_SALMES))>0.10
		RECLOCK("SRG",.F.)
		RG_SALMES :=_MAIORREM
		RG_SALDIA :=(_MAIORREM/30)
		SRG->(MsUnlock())
		ALERT("Maior remuneracao atualizada .... "+STR(_MAIORREM,12,2))
	ENDIF

RETURN Nil


//********************
User Function RECALC_R()    // RECALCULA PROVENTOS DE RESCISAO CONTRATUAL
//********************

//*************************************** indenizacao por estabilidade no retorno de ferias (30 dias do retorno)
	_cArea := Alias()
	_nOrd  := IndexOrd()
	nReg   :=RecNo()

	DBSELECTAREA("SRH")
	DBSETORDER(1)
	dBSEEK(xFILIAL()+SRA->RA_MAT)
	DO WHILE !EOF() .AND. SRH->RH_MAT == SRA->RA_MAT
		IF fbuscapd("356")=0 .and. (dDataDEM-SRH->RH_DATAFIM)<=30
			//fGeraVerba("356",SRA->RA_SALARIO,,,,,,,,,.T.) // Gera Verba DE INDENIZACAO POR ESTABILIDADE
			_dd:=(dDataDEM-SRH->RH_DATAFIM)
			ALERT("Lançar verba 356-INDENIZACAO POR ESTABILIDADE FERIAS. -->> "+STRZERO(_DD,2,0)+" dias <<--")
			ALERT("-->> "+STRZERO(_DD,2,0)+" dias <<--")
			Exit
		ENDIF
		DBSKIP()
	ENDDO

	dbSelectArea(_cArea)
	DbSetOrder(_nOrd)
	DbGoTo(nReg)

//*************************************** fim
/*
_MAIORREM:=FBUSCAPD("141")     // AVISO PEREVIO
IF _MAIORREM==0
    _MAIORREM:=FBUSCAPD("128")     // FERIAS VENCIDAS
ENDIF
IF _MAIORREM==0
    _MAIORREM:=(FBUSCAPD("145","V")/INT(FBUSCAPD("145","H")))*12     // FERIAS PROP
ENDIF
IF _MAIORREM==0
    _MAIORREM:=(FBUSCAPD("180","V")/INT(FBUSCAPD("180","H")))*12     // 13o SALARIO
ENDIF
IF _MAIORREM==0
    _MAIORREM:=SRA->RA_SALARIO
ENDIF

@ 1,1 to  150,300 DIALOG oDlg2RE TITLE "Maior Remuneraçâo"
@ 10, 22 SAY "R$"
@ 10, 49 GET _MAIORREM SIZE 40,12 PICTURE "@E 999,999.99"
@ 60, 95 BmpButton Type 1 Action Close(oDlg2RE)
Activate Dialog oDlg2RE Centered
IF _MAIORREM==0
   ALERT("Mantido calculos do Sistema")
   RETURN Nil
ENDIF   
_REF145:=_REF175:=_REF238:=0

If fBuscaPD("141")<>0
   _REF:=fBuscaPD("141","H")
   aPD[fLocaliAPD("141"),9] := "D"             // Exclui Anterior
   fGeraVerba("141",_MAIORREM,_REF,,,,,,,,.T.) // Gera Verba AVISO PREVIO INDENIZADO
EndIf
If fBuscaPD("128")<>0
   _REF:=fBuscaPD("128","H")
   aPD[fLocaliAPD("128"),9] := "D"             // Exclui Anterior
   fGeraVerba("128",_MAIORREM,_REF,,,,,,,,.T.) // Gera Verba FERIAS INDENIZADAS
EndIf
If fBuscaPD("145")<>0
   _REF145:=fBuscaPD("145","H")
   aPD[fLocaliAPD("145"),9] := "D"             // Exclui Anterior
   fGeraVerba("145",(_MAIORREM/12)*INT(_REF145),_REF145,,,,,,,,.T.) // Gera Verba FERIAS PROP
EndIf
If fBuscaPD("180")<>0
   _REF:=fBuscaPD("180","H")
   aPD[fLocaliAPD("180"),9] := "D"             // Exclui Anterior
   fGeraVerba("180",(_MAIORREM/12)*INT(_REF),_REF,,,,,,,,.T.) // Gera Verba 13 SALARIO INDENIZADO
EndIf
If fBuscaPD("175")<>0
   _REF175:=fBuscaPD("175","H")
   aPD[fLocaliAPD("175"),9] := "D"             // Exclui Anterior
   fGeraVerba("175",(_MAIORREM/12)*INT(_REF175),_REF175,,,,,,,,.T.) // Gera Verba 13 SALARIO S AVISO PREVIO (1/12)
EndIf
If fBuscaPD("328")<>0
   _REF328:=fBuscaPD("328","H")
   aPD[fLocaliAPD("328"),9] := "D"             // Exclui Anterior
   fGeraVerba("328",(_MAIORREM/12)*INT(_REF328),_REF328,,,,,,,,.T.) // Gera Verba FERIAS S AVISO PREVIO (1/12)
EndIf
*/

RETURN Nil



//********************
User Function uDIF_SAL()    // DIFERENÇA SALARIAL PELA BASE DO FGTS - 731
//********************
	DBSELECTAREA("SRC")
	DBSETORDER(1)

	DBSELECTAREA("SRD")
	DBSETORDER(1)

	_A:=0
	DBSELECTAREA("SRA")
	DBSETORDER(1)
	DBGOTOP()
	_PERIOD :=Getmv("MV_FOLMES")
	WHILE !EOF()
		IF RA_SITFOLH$" F" .AND. RA_HRSMES>=180 .AND. RA_CATFUNC$"M"
			DBSELECTAREA("SRD")
			DBSEEK(xFilial("SRD")+SRA->RA_MAT+"200806"+"731")
			IF FOUND()

				_PROCESSO:="00001"
				_PERIODO :=_PERIOD
				_ROTEIRO :="FOL"
				_VERBA:="192"
				dbSelectArea("RGB")
				DBSETORDER(8)   // Por Verba
				If !DbSeek(xFilial("RGB")+_VERBA+_PROCESSO+_PERIODO+_ROTEIRO+SRA->RA_MAT)
					RecLock("RGB",.T.)
					RGB_FILIAL := xFilial("RGB")
					RGB_PROCESS:=_PROCESSO
					RGB_PERIOD :=_PERIODO
					RGB_ROTEIR :=_ROTEIRO
					RGB_SEMANA :="01"
					RGB_MAT    := SRA->RA_MAT
					RGB_PD     := _VERBA
					RGB_TIPO1  := "V"
					RGB_DTREF  := DDATABASE
					RGB_CC     := SRA->RA_CC
					RGB_TIPO2  := "I"
					RGB_VALOR  := (SRD->RD_VALOR*0.0016)
					//RGB_HORAS  := _Qtd
					MSUnLock()
				ELSE
					RecLock("RGB",.F.)
					RGB_CC     := SRA->RA_CC
					RGB_VALOR  := (SRD->RD_VALOR*0.0016)
				ENDIF

				_A++
			ENDIF
		ENDIF
		DBSELECTAREA("SRA")
		DBSKIP()
	ENDDO

	ALERT(STRZERO(_A,5,0)+" calculos efetuados !")

RETURN





	**************
user Function uACORDO()    // ROTINA DE IMPRESSAO DE ACORDO INDIVIDUAL DE COMPENSAÇÃO DE JORNADA
	**************

	nOrdem :=0
	Z:=0
	M:=0
	tamanho:="M"
	limite:=220
	titulo   := PADC("ACORDO INDIVIDUAL",74)
	cDesc1   := PADC(" ",74)
	cDesc2   := PADC(" ",74)
	cDesc3   := PADC(" ",74)
	cNatureza:=""
	aReturn  := { "Especial", 1,"Administracao", 2, 2, 1,"",1 }
	nPag     := 0
	nomeprog := "ACORDO"
	cPerg    := ""
	wnrel    := SUBSTR(CUSUARIO,7,3)+"_ACORDO"
	nLastKey := 0
	lContinua:= .T.
	nLin     := 0

	_TXCORREA:= 0
	_TXJURREA:= 0
	_QUAL    := ""
	_A:=ARRAY(10,20)

//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas                                      ¦
//+-------------------------------------------------------------------------+
	_INI:=_FIM:=SPACE(6)
	@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Matricula"
	@ 10, 22 SAY "De :"
	@ 10, 49 GET _INI  SIZE 25,12 F3 "SRA"
	@ 22, 22 SAY "Ate:"
	@ 22, 49 GET _FIM  SIZE 25,12 F3 "SRA"
	@ 60, 95 BmpButton Type 1 Action Close(oDlg2)
	Activate Dialog oDlg2 Centered

	cString:= ALIAS()


//+--------------------------------------------------------------+
//¦ Inicializa variaveis graficas                                ¦
//+--------------------------------------------------------------+

	aOkImp := .f.
	nHeight:=15
	lBold:= .F.
	lUnderLine:= .F.
	lPixel:= .T.
	lPrint:=.F.
	nSedex := 1

	oFont9 :=TFont():New( "Arial"   ,,14,,.T.,,,,,.F. )
//oFont9a:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
	oFont9a:=TFont():New( "Times New Roman"   ,,12,,.F.,,,,,.F. )
	oFont9b:=TFont():New( "Arial"   ,,12,,.T.,,,,,.F. )

	oPrn := TMSPrinter():New()
	oPrn:Setup()


//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+

	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,"M","",.T.)

	If nLastKey == 27 .or. Lastkey() == 27
		Return
	Endif

//+--------------------------------------------------------------+
//¦ Verifica Posicao do Formulario na Impressora                 ¦
//+--------------------------------------------------------------+
	SetDefault(aReturn,cString)

	If nLastKey == 27 .or. Lastkey() == 27
		Return
	Endif


	LinCab := 0
	cabec1 :=" "
	cabec2 :=" "
	cabec3 :=" "
	cabec4 :=" "
	cBitMap:= "ALUBAR.Bmp"



	IF EMPTY(_FIM)
		_FIM:=_INI
	ENDIF
//+-----------------------------------------------------------+
//¦ Inicio do Relatorio                                       ¦
//+-----------------------------------------------------------+
	DBSELECTAREA("SRA")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SRA")+_INI,.T.)
	WHILE !EOF() .AND. RA_MAT<=_FIM
		oPrn:EndPage()
		Linha := 70
		nPag  := nPag +1

		oPrn:SayBitmap( Linha+050,080,cBitMap,480,180 )

		oPrn:Say(Linha:=Linha+200,750,"Acordo Individual de Compensação de Jornada de Trabalho do Colaborador" , oFont9b)

		oPrn:line( Linha:=Linha+75   ,  80 ,Linha,2260)     // Linha horizontal

		_SALTO:=60
		oPrn:Say(Linha:=Linha+100 ,250,"DAS PARTES" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,"Entre a firma  "+SM0->M0_NOMECOM+", domiciliada em Barcarena/Pa." , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,"Zona Portuária Porto de Vila do Conde S/N   em  Barcarena no estado Pará, registrada no CNPJ. " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,"MF.: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+", designada simplesmente EMPRESA, e:" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,SRA->RA_NOME+", portador da carteira profissional " , oFont9B)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,"Num.: "+SRA->RA_NUMCP+", serie "+SRA->RA_SERCP+" a seguir chamado apenas COLABORADOR," , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,"resolvem neste ato, celebrar o presente ACORDO INDIVIDUAL DE COMPENSAÇÃO DE JORNADA  " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,"DE TRABALHO DO COLABORADOR, que se regerá pelas seguintes clausulas e condições:   " , oFont9a)
		oPrn:line( Linha:=Linha+50,90,Linha,3100)     // Linha horizontal

		oPrn:Say(Linha:=Linha+100 ,250,"CLÁUSULA PRIMEIRA" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"1. O objeto do presente acordo é a compensação  de horas,  para os  casos de eventual" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"necessidade de realizar a jornada de trabalho em  horas  suplementares, nos termos da" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"Sumula num 85 do Tribunal Superior do Trabalho." , oFont9a)

		oPrn:Say(Linha:=Linha+100 ,250,"CLÁUSULA SEGUNDA" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"2. As partes estipulam que as horas suplementares laboradas em um ou mais dias na se-" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"mana, serão compensadas dentro de um prazo maximo  de 180 (cento e oitenta) dias." , oFont9a)

		oPrn:Say(Linha:=Linha+100 ,250,"CLÁUSULA TERCEIRA" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"3. Nos termos do paragrafo 2o. do artigo 59 da Consolidação das Leis do Trabalho, " , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"fica dispensado o acrescimo de salario, ressaltando-se que o excesso de horas em um" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"dia sera compensado pela correspondente diminuição em outro dia, de maneira que nao" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"exceda, no periodo maximo de cento e  vinte dias, a soma das  jornadas  semanais de" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"trabalho previstas, nem seja ultrapassado o limite maximo de dez horas diarias." , oFont9a)

		oPrn:Say(Linha:=Linha+100 ,250,"CLÁUSULA QUARTA" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"4. O presente acordo tem prazo de vigencia a partir da data respectiva de sua assi-" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"natura, por um prazo indeterminado, vinculado a  duração do  contrato de   trabalho" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"firmado entre o colaborador e a empresa." , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"4.1 Nos termos do paragrafo 3o., do artigo 59 da Consolidação das Leis do Trabalho," , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"fica desde ja  estabelecido  que, na  hipotese de rescisao de  contrato de trabalho" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"sem que tenha havido a compensação integral da jornada extraordinária, fará o cola-" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"borador jus ao pagamento das horas extras nao compensadas, calculadas sobre o valor" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"da remuneração na data da rescisão, com acrescimo de 50% (cinquenta por cento)." , oFont9a)


		oPrn:EndPage()
		Linha := 70
		nPag  := nPag +1


		oPrn:Say(Linha:=Linha+100    ,250,"CLAUSULA QUINTA" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"Fica eleito o Foro da comarca de Barcarena como unico e competente para dirimir" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"quaisquer  pendencias  sobre  este  instrumento, com  a renuncia  de  qualquer" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"outro, por mais privilegiado que possa ser." , oFont9a)

		oPrn:Say(Linha:=Linha+100    ,300,"E  por estarem assim justas e  contratadas, as  partes assinam o  presente" , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO ,300,"instrumento em 2 (duas) vias, na presença de 2 (duas) testemunhas." , oFont9a)


		oPrn:Say(Linha:=Linha+200 ,700,"Barcarena/PA , "+DTOC(SRA->RA_ADMISSA) , oFont9a)

		oPrn:line( Linha:=Linha+250   ,  80 ,Linha,700)     // Linha horizontal
		oPrn:line( Linha:=Linha       ,1000 ,Linha,1700)     // Linha horizontal
		oPrn:Say(Linha:=Linha+50 ,80,  " Testemunhas" , oFont9a)
		oPrn:Say(Linha:=Linha    ,1000,SM0->M0_NOMECOM , oFont9B)

		oPrn:line( Linha:=Linha+200   ,  80 ,Linha,700)     // Linha horizontal
		oPrn:line( Linha:=Linha       ,1000 ,Linha,1700)     // Linha horizontal
		oPrn:Say(Linha:=Linha+50 ,80,  " Testemunhas" , oFont9a)
		oPrn:Say(Linha:=Linha    ,1000,SRA->RA_NOME , oFont9B)


		DBSELECTAREA("SRA")
		DBSKIP()
	ENDDO

	oPrn:Preview()
	MS_FLUSH()

	oPrn:EndPage()


RETURN


	**************
user Function uENCBAN()    // ROTINA DE IMPRESSAO DE ENCAMINHAMENTO AO BANCO ... By JOSE MACEDO
	**************

	nOrdem :=0
	Z:=0
	M:=0
	tamanho:="M"
	limite:=220
	titulo   := PADC("CARTA SANTANDER",74)
	cDesc1   := PADC(" ",74)
	cDesc2   := PADC(" ",74)
	cDesc3   := PADC(" ",74)
	cNatureza:=""
	aReturn  := { "Especial", 1,"Administracao", 2, 2, 1,"",1 }
	nPag     := 0
	nomeprog := "ENCBAN"
	cPerg    := "ENCBAN"
	wnrel    := SUBSTR(CUSUARIO,7,3)+"_ENCBAN"
	nLastKey := 0
	lContinua:= .T.
	nLin     := 0

	_TXCORREA:= 0
	_TXJURREA:= 0
	_QUAL    := ""
	_A:=ARRAY(10,20)

//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas                                      ¦
//+-------------------------------------------------------------------------+
	_INI:=_FIM:=SPACE(6)
	_BANCO:="Banco Santander"
	@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Matricula"
	@ 10, 22 SAY "De :"
	@ 10, 49 GET _INI  SIZE 25,12 F3 "SRA"
	@ 22, 22 SAY "Ate:"
	@ 22, 49 GET _FIM  SIZE 25,12 F3 "SRA"
	@ 34, 22 SAY "Banco"
	@ 34, 49 GET _BANCO  SIZE 50,12

	@ 60, 95 BmpButton Type 1 Action Close(oDlg2)
	Activate Dialog oDlg2 Centered

	cString:= ALIAS()


//+--------------------------------------------------------------+
//¦ Inicializa variaveis graficas                                ¦
//+--------------------------------------------------------------+

	aOkImp := .f.
	nHeight:=15
	lBold:= .F.
	lUnderLine:= .F.
	lPixel:= .T.
	lPrint:=.F.
	nSedex := 1

	oFont9 :=TFont():New( "Arial"   ,,14,,.T.,,,,,.F. )
//oFont9a:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
	oFont9a:=TFont():New( "Arial"   ,,12,,.F.,,,,,.F. )
	oFont9b:=TFont():New( "Arial"   ,,10,,.T.,,,,,.F. )

	oPrn := TMSPrinter():New()
	oPrn:Setup()




	LinCab := 0
	cabec1 :=" "
	cabec2 :=" "
	cabec3 :=" "
	cabec4 :=" "
	cBitMap:= "LOGOAP.Bmp"
	cBitMap:= "ALUBAR.Bmp"



	IF EMPTY(_FIM)
		_FIM:=_INI
	ENDIF
//+-----------------------------------------------------------+
//¦ Inicio do Relatorio                                       ¦
//+-----------------------------------------------------------+
	DBSELECTAREA("SRA")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SRA")+_INI,.T.)
	WHILE !EOF() .AND. RA_MAT<=_FIM

		_REF1:=_REF2:=SPACE(60)
		@ 1,1 to  150,300 DIALOG oDlg2B TITLE "REFERENCIAS"
		@ 10, 22 SAY "Referencias : "+SRA->RA_NOME

		@ 22, 15 SAY "Nome/Fone1"
		@ 22, 49 GET _REF1  SIZE 90,12
		@ 34, 15 SAY "Nome/Fone2"
		@ 34, 49 GET _REF2  SIZE 90,12
		@ 60, 95 BmpButton Type 1 Action Close(oDlg2B)
		Activate Dialog oDlg2B Centered


		oPrn:EndPage()
		Linha := 70
		nPag  := nPag +1

		//                        COL             ALT
		oPrn:SayBitmap( Linha+050,880,cBitMap,400,450 )


		Linha:=Linha + 250
		_SALTO:=65
		oPrn:Say(Linha:=Linha+(_SALTO*2)  ,1550,"CNPJ : 04.973.426/0001-82" , oFont9B)
		oPrn:Say(Linha:=Linha+(_SALTO*1)  ,1550,"Av.Almte Barroso, 4616 - Souza" , oFont9B)
		oPrn:Say(Linha:=Linha+(_SALTO*1)  ,1550,"CEP 66613-710 - Telefone: (91) 3181-9954" , oFont9B)
		oPrn:line( Linha:=Linha+50   ,  80 ,Linha,2260)     // Linha horizontal



		oPrn:Say(Linha:=Linha+(_SALTO*1)  ,300,"Ao "+_BANCO , oFont9a)
		oPrn:Say(Linha:=Linha+_SALTO  ,300,"Sr. Gerente" , oFont9a)
		oPrn:Say(Linha:=Linha+(_SALTO*2)  ,300,"Solicitamos abertura de conta salario, conforme dados:" , oFont9a)

		_LINI:=Linha+100
		oPrn:line( Linha:=Linha+100   ,  290 ,Linha,2000)     // Linha horizontal
		oPrn:Say(Linha:=Linha+(_SALTO-30)  ,300,"Nome : "+SRA->RA_NOME , oFont9a)
		oPrn:Say(Linha:=Linha+(_SALTO*1)  ,300,"Cargo: "+POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_DESC") , oFont9a)
		oPrn:Say(Linha:=Linha+(_SALTO*1)  ,300,"Data de Admissao : "+DTOC(SRA->RA_ADMISSA) , oFont9a)

		oPrn:line( Linha:=Linha+50   ,  290 ,Linha,2000)     // Linha horizontal
		oPrn:Say(Linha:=Linha+(_SALTO-30)  ,300,"Salario : R$"+TRANSFORM(SRA->RA_SALARIO,"@EZ 99,999,999.99") , oFont9a)
		cExtenso := Extenso( SRA->RA_SALARIO, .F., 1 )
		oPrn:Say(Linha:=Linha+(_SALTO*1)  ,300,"("+cExtenso+")" , oFont9B)
		oPrn:line( Linha:=Linha+50   ,  290 ,Linha,2000)     // Linha horizontal


		cEnd       := AllTrim(Left(SRA->RA_Endereco,30)) + ' ' + AllTrim(Left(SRA->RA_Complem,15)) + ' , ' + AllTrim(Left(SRA->RA_Bairro,15))
		cCep       := Transform(Left(SRA->RA_Cep,8),'@R #####-###')
		cUF        := Left(SRA->RA_Estado,2)
		cFone      := SRA->RA_Telefon
		oPrn:Say(Linha:=Linha+(_SALTO-30)  ,300,"Endereco : "+cEnd , oFont9a)
		oPrn:Say(Linha:=Linha+(_SALTO*1)  ,300,"Cep : "+cCep , oFont9a)
		oPrn:Say(Linha:=Linha+(_SALTO*1)  ,300,"Cidade : "+SRA->RA_MUNICIP+SPACE(5)+"Estado : "+cUF , oFont9a)
		oPrn:Say(Linha:=Linha+(_SALTO*1)  ,300,"Telefone : "+cFONE , oFont9a)
		oPrn:Say(Linha:=Linha+(_SALTO*1)  ,300,"Escolaridade : "+Tabela("26",SRA->RA_GRINRAI) , oFont9a)
		oPrn:Say(Linha:=Linha+(_SALTO*1)  ,300,"Estado Civil : "+Tabela("33",SRA->RA_ESTCIVI) , oFont9a)

		_CNOME:=" "
		_CCPF :=" "
		_CNASC:=CTOD("  /  /  ")

		DBSELECTAREA("SRB")
		DBSETORDER(1)
		DBSEEK(xFilial("SRB")+SRA->RA_MAT)
		WHILE !EOF() .AND. RB_MAT==SRA->RA_MAT
			IF RB_GRAUPAR="C"  // CONJUGE
				_CNOME:=RB_NOME
				_CCPF :=RB_CIC
				_CNASC:=RB_DTNASC
				EXIT
			ENDIF
			DBSKIP()
		ENDDO
		DBSELECTAREA("SRA")

		oPrn:line( Linha:=Linha+100   ,  290 ,Linha,2000)     // Linha horizontal
		oPrn:Say(Linha:=Linha+(_SALTO-30)  ,300,"Conjuge        : "+_cNome , oFont9a)
		oPrn:Say(Linha:=Linha+(_SALTO*1)  ,300,"Cpf Conjuge    : "+_cCPF , oFont9a)
		oPrn:Say(Linha:=Linha+(_SALTO*1)  ,300,"Nascim Conjuge : "+DTOC(_cNASC) , oFont9a)

		oPrn:Say(Linha:=Linha+(_SALTO*2)  ,300,"Referencias Pessoais : " , oFont9B)
		oPrn:Say(Linha:=Linha+(_SALTO*1)  ,300,_REF1 , oFont9a)
		oPrn:Say(Linha:=Linha+(_SALTO*1)  ,300,_REF2 , oFont9a)
		oPrn:line( Linha:=Linha+100   ,  290 ,Linha,2000)     // Linha horizontal

		oPrn:line( _lINI   ,  290 ,Linha,290)     // Linha VERTICAL
		oPrn:line( _lINI   , 2000 ,Linha,2000)     // Linha VERTICAL


		oPrn:Say(Linha:=Linha+100 ,300,"Belem/PA , "+DTOC(dDataBase) , oFont9a)

		oPrn:Say(Linha:=Linha+100 ,300,  " Atenciosamente," , oFont9a)


//*****************************************************

		oPrn:Say(Linha:=Linha+200 ,100,  "APRESENTAR DOCUMENTOS:" , oFont9b)

		oPrn:Box( Linha:=Linha+80  ,080+20,Linha+80, 140+20)   // BOX
		oPrn:Box( Linha  ,630,Linha+80, 690)   // BOX
		oPrn:Box( Linha  ,1150,Linha+80,1210)   // BOX
		oPrn:Box( Linha  ,1820,Linha+80,1880)   // BOX



		oPrn:Say(Linha+10          , 160+20 ,"RG" , oFont9a)
		oPrn:Say(Linha+10          , 710 ,"CPF" , oFont9a)
		oPrn:Say(Linha+10          ,1230 ,"Comprovante de Residencia" , oFont9a)
		oPrn:Say(Linha+10          ,1900 ,"RG e CPF do responsavel" , oFont9a)
		oPrn:Say(Linha+110          , 1230 ,"Tipo: ___________________" , oFont9a)
		oPrn:Say(Linha+110          , 1900 ,"(Se menor)" , oFont9a)





//	oPrn:line( Linha:=Linha+150   ,  80 ,Linha,2260)     // Linha horizontal


		DBSELECTAREA("SRA")
		DBSKIP()
	ENDDO

	oPrn:Preview()
	MS_FLUSH()

	oPrn:EndPage()


RETURN




