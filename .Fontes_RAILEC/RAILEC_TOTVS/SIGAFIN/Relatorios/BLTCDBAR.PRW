#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"            
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ BLTCDBAR ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO BANCO ITAU COM CODIGO DE BARRAS        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function BLTCDBAR()

LOCAL	aPergs := {} 
Local aTitulos 	:= {}
Local oButton1, oButton2, oButton3
Local oFont1 := TFont():New("Verdana",,014,,.F.,,,,,.F.,.F.)
Local oGroup1, oGroup2
Local oPanel1
Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oSay7, oSay8, oSay9 
Local oDlg, oBrowse
Local lOk := .F.
      

Private oOk	:= LoadBitMap(GetResources(), "LBOK")
Private oNo	:= LoadBitMap(GetResources(), "LBNO")
PRIVATE lExec    := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''

Tamanho  := "M"
titulo   := "Impressao de Boleto com Codigo de Barras"
cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "BOLETO"
lEnd     := .F.
cPerg     :="BLTBAR"
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }   
nLastKey := 0

dbSelectArea("SE1")

Aadd(aPergs,{"De Prefixo","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Prefixo","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Numero","","","mv_ch3","C",6,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Numero","","","mv_ch4","C",6,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Parcela","","","mv_ch5","C",1,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Parcela","","","mv_ch6","C",1,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Portador","","","mv_ch7","C",3,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
Aadd(aPergs,{"Ate Portador","","","mv_ch8","C",3,0,0,"G","","MV_PAR08","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
Aadd(aPergs,{"De Cliente","","","mv_ch9","C",6,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","SE1","","","",""})
Aadd(aPergs,{"Ate Cliente","","","mv_cha","C",6,0,0,"G","","MV_PAR10","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SE1","","","",""})
Aadd(aPergs,{"De Loja","","","mv_chb","C",2,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Loja","","","mv_chc","C",2,0,0,"G","","MV_PAR12","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Emissao","","","mv_chd","D",8,0,0,"G","","MV_PAR13","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Emissao","","","mv_che","D",8,0,0,"G","","MV_PAR14","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Vencimento","","","mv_chf","D",8,0,0,"G","","MV_PAR15","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Vencimento","","","mv_chg","D",8,0,0,"G","","MV_PAR16","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Do Bordero","","","mv_chh","C",6,0,0,"G","","MV_PAR17","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Bordero","","","mv_chi","C",6,0,0,"G","","MV_PAR18","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Mensagem Boleto","","","mv_chj","C",3,0,0,"G","","MV_PAR19","","","","   ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Mensagem Boleto","","","mv_chl","C",3,0,0,"G","","MV_PAR20","","","","   ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Mensagem Boleto","","","mv_chm","C",3,0,0,"G","","MV_PAR21","","","","   ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Pergunte (cPerg,.F.)

Wnrel := SetPrint(cString,Wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,)

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif


If Select("TIT") > 0
	TIT->(DBCLoseArea())
EndIf


cQuery := ""
cQuery += " SELECT		"
cQuery += "  '*'  AS E1_BOLETO	"
cQuery += " ,E1_PREFIXO	"
cQuery += " ,E1_NUM		"
cQuery += " ,E1_PARCELA	"
cQuery += " ,E1_TIPO	"
cQuery += " ,E1_PORTADO	"
cQuery += " ,E1_CLIENTE +'/' + E1_LOJA +' - ' +E1_NOMCLI AS E1_CLIENTE1	"
cQuery += " ,E1_EMISSAO	"
cQuery += " ,CASE 	"
cQuery += " WHEN E1_VENCALT <> ''	"
cQuery += " 	THEN	E1_VENCALT	"
cQuery += " 	ELSE    E1_VENCTO	"
cQuery += " END AS E1_VENCTO		"
cQuery += " ,E1_VENCALT	"
cQuery += " ,E1_VALOR	"
cQuery += " ,E1_NUMBOR	"
cQuery += " ,E1_AGEDEP	"
cQuery += " ,E1_CONTA	"
cQuery += " ,E1_SALDO	"
cQuery += " ,E1_CLIENTE	"
cQuery += " ,E1_LOJA	"
cQuery += " ,E1_NUMBCO	"  
cQuery += " ,E1_IDCNAB	"  
cQuery += " FROM  "+RetSQLName("SE1")+" "
cQuery += " WHERE D_E_L_E_T_ = ''  "
cQuery += " AND E1_FILIAL = '"+xFilial("SE1")+"' "
cQuery += " AND E1_PREFIXO 	BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  "
cQuery += " AND E1_NUM 		BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'  "
cQuery += " AND E1_PARCELA 	BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  " 
cQuery += " AND E1_PORTADO 	BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
cQuery += " AND E1_CLIENTE	BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'  "
cQuery += " AND E1_LOJA 	BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'  "
cQuery += " AND E1_EMISSAO 	BETWEEN '"+DTOS(MV_PAR13)+"' AND '"+DTOS(MV_PAR14)+"'  "
cQuery += " AND E1_VENCTO 	BETWEEN '"+DTOS(MV_PAR15)+"' AND '"+DTOS(MV_PAR16)+"'  "
cQuery += " AND E1_NUMBOR 	BETWEEN '"+MV_PAR17+"' AND '"+MV_PAR18+"'  "
cQuery += " AND E1_TIPO NOT IN ('AB','FB','FC','FU','IR','IN','IS','PI','CF','CS','FE','IV', 'RA', 'NCC')	"
cQuery += " AND E1_PORTADO<>''	"
cQuery += " AND E1_SALDO>0		"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TIT",.F.,.T.) 
DBSelectArea("TIT")   
TIT->(DBGoTop())
Do While !TIT->(EOF())

aAdd(aTitulos,	{  			'*',;
							TIT->E1_PREFIXO,;
							TIT->E1_NUM,;
							TIT->E1_PARCELA,;
							TIT->E1_TIPO,;
							TIT->E1_PORTADO,;
							TIT->E1_CLIENTE1,;
							TIT->E1_EMISSAO,;
							TIT->E1_VENCTO,;
							TIT->E1_VALOR,;
							TIT->E1_NUMBOR,;
							TIT->E1_SALDO,;
							TIT->E1_CONTA,;																					
							TIT->E1_AGEDEP,;																					
							TIT->E1_CLIENTE,;																																			
							TIT->E1_LOJA,;
							TIT->E1_NUMBCO,;
							TIT->E1_IDCNAB})
	TIT->(DBSkip())

EndDo
TIT->(DBCLoseArea())					

If Len(aTitulos) <= 0
	MSGInfo("Não há títulos a liberar")
	Return()
EndIf

DEFINE MSDIALOG oDlg TITLE "Boleto Bancario" FROM 000, 000  TO 460, 960 COLORS 0, 16777215 PIXEL

    
oBrowse:= TCBrowse():New( 001 , 007, 465, 146,,{' ',"Prefixo","Titulo","Parcela","Tipo","Banco","Cliente","Emissao","Vencimento","Valor","Bordero"},,oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
oBrowse:SetArray(aTitulos)

// Evento de clique no cabeçalho da browse
oBrowse:bHeaderClick:= {|| MarcaColun(oBrowse,aTitulos),oBrowse:Refresh()}

// Evento de clicar duas vezes na célula
oBrowse:bLDblClick	:= {|| MarcaItem (oBrowse,aTitulos)}
oBrowse:bLine		:= {|| {IIf(aTitulos[oBrowse:nAt,1]==' ',oNo,oOk),;
							aTitulos[oBrowse:nAt,2],;
							aTitulos[oBrowse:nAt,3],;
							aTitulos[oBrowse:nAt,4],;
							aTitulos[oBrowse:nAt,5],;
							aTitulos[oBrowse:nAt,6],;
							aTitulos[oBrowse:nAt,7],;
							aTitulos[oBrowse:nAt,8],;
							aTitulos[oBrowse:nAt,9],;
							aTitulos[oBrowse:nAt,10],;
							aTitulos[oBrowse:nAt,11]}}
  
@ 207, 280 BUTTON oButton1 PROMPT "Imprimir" SIZE 050, 012 OF oPanel1 FONT oFont1 PIXEL Action ( lOk:= .T., oDlg:End() )
@ 207, 336 BUTTON oButton3 PROMPT "SAIR" SIZE 037, 012 OF oPanel1 FONT oFont1 PIXEL Action oDlg:End()

ACTIVATE MSDIALOG oDlg CENTERED

If lOk
	Processa({|lEnd|MontaRel(aTitulos)})
EndIf


Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ<ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel(aTitulos)
LOCAL oPrint
LOCAL nX := 0
Local cNroDoc :=  " "
LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
								SM0->M0_ENDCOB                                     ,; //[2]Endereço
								AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
								"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
								"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
								"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
								Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
								Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
								"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
								Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aDadosQnab
LOCAL aBolText     := {"Após o vencimento cobrar multa de R$ "                ,;
								"Mora Diaria de R$ "                                   ,;
								"Sujeito a Protesto apos 05 (cinco) dias do vencimento"}

Local _cBolText1 := GetAdvFVal("SM4","M4_FORMULA",xFilial("SM4")+alltrim(MV_PAR19),1)
Local _cBolText2 := GetAdvFVal("SM4","M4_FORMULA",xFilial("SM4")+alltrim(MV_PAR20),1)
Local _cBolText3 := GetAdvFVal("SM4","M4_FORMULA",xFilial("SM4")+alltrim(MV_PAR21),1)
LOCAL nI           := 1
LOCAL aCB_RN_NN    := {}
LOCAL nVlrAbat	   := 0
Local nAbatDoc	   := 0
Local nJrBol       := 0
Local nMuBol       := 0
Local nAcreDoc   := 0
oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página

//DBSelectArea("TIT")   
//TIT->(DBGoTop())
//ProcRegua(RecCount())
//Do While !TIT->(EOF())
For _nR := 1 To Len(aTitulos)
	//Posiciona o SA6 (Bancos)
ProcRegua(RecCount())	
	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+aTitulos[_nR][6]+aTitulos[_nR][14]+aTitulos[_nR][13],.T.)
	
	//Posiciona na Arq de Parametros CNAB
	DbSelectArea("SEE")
	DbSetOrder(1)
	DbSeek(xFilial("SEE")+aTitulos[_nR][6]+aTitulos[_nR][14]+aTitulos[_nR][13],.T.)
	
	//Posiciona o SA1 (Cliente)
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial()+aTitulos[_nR][15]+aTitulos[_nR][16],.T.)
	
	DbSelectArea("SE1")
	aDadosBanco  := {SA6->A6_COD                        ,; 							// [1]Numero do Banco
                      SA6->A6_NOME      	            	                  ,; 	// [2]Nome do Banco
	                  ALLTRIM(SUBSTR(SA6->A6_AGENCIA, 1, 5))                        ,; 		// [3]Agência
                      ALLTRIM(SUBSTR(SA6->A6_NUMCON,1,6)),; 	// [4]Conta Corrente
                      SUBSTR(SA6->A6_DVCTA,1,1),; //SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)  ,; 	// [5]Dígito da conta corrente
                      "17"                                              		}		// [6]Codigo da Carteira

	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;      	// [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      	// [2]Código
		AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      	// [3]Endereço
		AllTrim(SA1->A1_MUN )                            ,;  			// [4]Cidade
		SA1->A1_EST                                      ,;     		// [5]Estado
		SA1->A1_CEP                                      ,;      	// [6]CEP
		SA1->A1_CGC										          ,;  			// [7]CGC
		If(Len(AllTrim(SA1->A1_CGC))==14,"J","F")	}       				// [8]PESSOA
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)            	 ,;   	// [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   	// [2]Código
		AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   	// [3]Endereço
		AllTrim(SA1->A1_MUNC)	                             ,;   	// [4]Cidade
		SA1->A1_ESTC	                                     ,;   	// [5]Estado
		SA1->A1_CEPC                                        ,;   	// [6]CEP
		SA1->A1_CGC												 		 ,;		// [7]CGC
		If(Len(AllTrim(SA1->A1_CGC))==14,"J","F")						 }				// [8]PESSOA
	Endif
	
	DbSelectArea("SEE")
		aDadosQnab   := {AllTrim(SEE->EE_CODEMP)            ,;     // [1] Cod. Convenio 
						" "                                   }		// [6]Codigo da Carteira	
	nVlrAbat   :=  SomaAbat(aTitulos[_nR][2],aTitulos[_nR][3],aTitulos[_nR][4],"R",1,,aTitulos[_nR][15],aTitulos[_nR][16])
	If MV_PAR22 > 0
		nAbatDoc   :=  MV_PAR22 + nVlrAbat
	EndIf 
	If Date() > SToD(aTitulos[_nR][9])
		nMuBol := Round(((aTitulos[_nR][10] * 2)/100),2)
	 	nJrBol := (nMuBol * (DateDiffDay(Date(), SToD(aTitulos[_nR][9]))))
		
		nAcreDoc	:= nMuBol + nJrBol
	EndIf
	

	//Aqui defino parte do nosso numero. Sao 8 digitos para identificar o titulo. 
	//Abaixo apenas uma sugestao
    If Alltrim(aDadosBanco[1])=="001"
		cNroDoc	:= StrZero(	Val(Alltrim(aTitulos[_nR][17])),10)
	ElseIf Alltrim(aDadosBanco[1])$"/341/707/422/104/"
		cNroDoc	:= StrZero( Val(Alltrim(aTitulos[_nR][17])),9)  	
	Else
		cNroDoc	:= StrZero(	Val(Alltrim(aTitulos[_nR][3])+Alltrim(aTitulos[_nR][4])),10)
	EndIf
	
	
	//Monta codigo de barras
	aCB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],cNroDoc,(aTitulos[_nR][10]-nAbatDoc + nAcreDoc),StoD(aTitulos[_nR][9]))
	
	aDadosTit	:= {AllTrim(aTitulos[_nR][3])+AllTrim(aTitulos[_nR][4])		,;  // [1] Número do título
						StoD(aTitulos[_nR][8])                              	,;  // [2] Data da emissão do título
						dDataBase                    					,;  // [3] Data da emissão do boleto
						StoD(aTitulos[_nR][9])                          ,;  // [4] Data do vencimento
						(aTitulos[_nR][12] - nVlrAbat)                  ,;  // [5] Valor do título
						aCB_RN_NN[3]                             	    ,;  // [6] Nosso número (Ver fórmula para calculo)
						aTitulos[_nR][2]                               	,;  // [7] Prefixo da NF
						aTitulos[_nR][5]	                           	,;  // [8] Tipo do Titulo
						aTitulos[_nR][17]	                           	,;  // [9] Noss Numero
						aTitulos[_nR][18]	                           	 } //  [10] IDCNAB
	If aTitulos[_nR][1] == "*"
		Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aDadosQnab,aBolText,aCB_RN_NN,_cBolText1,_cBolText2,_cBolText3,nAcreDoc)
	EndIf
	IncProc()
Next _nR

oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir
Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASERDO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aDadosQnab,aBolText,aCB_RN_NN,_cBolText1,_cBolText2,_cBolText3,nAcreDoc)
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0
Local _cDACv := 0

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8  := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()   // Inicia uma nova página

/******************/
/* PRIMEIRA PARTE */
/******************/

nRow1 := 0
 
oPrint:Line (nRow1+0150,500,nRow1+0070, 500)
oPrint:Line (nRow1+0150,710,nRow1+0070, 710)

If     aDadosBanco[1] == "104"
	oPrint:Say  (nRow1+0084,100,"CAIXA ECONOMICA",oFont10 )	// [2]Nome do Banco
	oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-0",oFont20 )		// [1]Numero do Banco
ElseIf aDadosBanco[1] $ "341/707"
	oPrint:Say  (nRow1+0084,100,"BANCO ITAU S.A",oFont10 )	// [2]Nome do Banco
	oPrint:Say  (nRow1+0075,513,"341"+"-7",oFont20 )		// [1]Numero do Banco
ElseIf aDadosBanco[1] == "422"
	oPrint:Say  (nRow1+0084,100,"BANCO SAFRA",oFont10 )	// [2]Nome do Banco
	oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-7",oFont20 )		// [1]Numero do Banco	
ElseIf aDadosBanco[1] == "001"
	oPrint:Say  (nRow1+0084,100,"BANCO DO BRASIL",oFont10 )	// [2]Nome do Banco
	oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-9",oFont20 )		// [1]Numero do Banco
Else
	oPrint:Say  (nRow1+0084,100,aDadosBanco[2],oFont10 )	// [2]Nome do Banco
	oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-9",oFont20 )		// [1]Numero do Banco
EndIf	

oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)
oPrint:Line (nRow1+0150,100,nRow1+0150,2300)

oPrint:Say  (nRow1+0150,100 ,"Cedente",oFont8)
oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont10)				//Nome + CNPJ

If aDadosBanco[1] $ "707"
	oPrint:Say  (nRow1+0150,1060,"Agência/Código Cedente",oFont8)
	oPrint:Say  (nRow1+0200,1060,"1248/01624-6",oFont10)
ElseIf aDadosBanco[1] $ "104"  
	oPrint:Say  (nRow1+0150,1060,"Agência/Código Cedente",oFont8)
	oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"/849249",oFont10)
Else
	oPrint:Say  (nRow1+0150,1060,"Agência/Código Cedente",oFont8)
	oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"/"+aDadosBanco[4]+aDadosBanco[5],oFont10)
EndIf

If aDadosBanco[1] $ "104"
	oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
	oPrint:Say  (nRow1+0200,1510,aDadosTit[10],oFont10) //Prefixo +Numero+Parcela
Else
	oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
	oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela
Endif	


oPrint:Say  (nRow1+0250,100 ,"Sacado",oFont8)
oPrint:Say  (nRow1+0300,100 ,aDatSacado[1],oFont10)				//Nome

oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/título",oFont10)
oPrint:Say  (nRow1+0450,0100,"com as características acima.",oFont10)
oPrint:Say  (nRow1+0350,1060,"Data",oFont8)
oPrint:Say  (nRow1+0350,1410,"Assinatura",oFont8)
oPrint:Say  (nRow1+0450,1060,"Data",oFont8)
oPrint:Say  (nRow1+0450,1410,"Entregador",oFont8)

oPrint:Line (nRow1+0250, 100,nRow1+0250,1900 )
oPrint:Line (nRow1+0350, 100,nRow1+0350,1900 )
oPrint:Line (nRow1+0450,1050,nRow1+0450,1900 ) //---
oPrint:Line (nRow1+0550, 100,nRow1+0550,2300 )

oPrint:Line (nRow1+0550,1050,nRow1+0150,1050 )
oPrint:Line (nRow1+0550,1400,nRow1+0350,1400 )
oPrint:Line (nRow1+0350,1500,nRow1+0150,1500 ) //--
oPrint:Line (nRow1+0550,1900,nRow1+0150,1900 )

oPrint:Say  (nRow1+0165,1910,"(  )Mudou-se"                                	,oFont8)
oPrint:Say  (nRow1+0205,1910,"(  )Ausente"                                    ,oFont8)
oPrint:Say  (nRow1+0245,1910,"(  )Não existe nº indicado"                  	,oFont8)
oPrint:Say  (nRow1+0285,1910,"(  )Recusado"                                	,oFont8)
oPrint:Say  (nRow1+0325,1910,"(  )Não procurado"                              ,oFont8)
oPrint:Say  (nRow1+0365,1910,"(  )Endereço insuficiente"                  	,oFont8)
oPrint:Say  (nRow1+0405,1910,"(  )Desconhecido"                            	,oFont8)
oPrint:Say  (nRow1+0445,1910,"(  )Falecido"                                   ,oFont8)
oPrint:Say  (nRow1+0485,1910,"(  )Outros(anotar no verso)"                  	,oFont8)
           

/*****************/
/* SEGUNDA PARTE */
/*****************/

nRow2 := 0

//Pontilhado separador
For nI := 100 to 2300 step 50
	oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+30)
Next nI

oPrint:Line (nRow2+0710,100,nRow2+0710,2300)
oPrint:Line (nRow2+0710,500,nRow2+0630, 500)
oPrint:Line (nRow2+0710,710,nRow2+0630, 710)

If      aDadosBanco[1] == "104"
	oPrint:Say  (nRow2+0644,100,"CAIXA ECONOMICA",oFont10 )		// [2]Nome do Banco
	oPrint:Say  (nRow2+0635,513,aDadosBanco[1]+"-0",oFont20 )	// [1]Numero do Banco
ElseIf  aDadosBanco[1] $ "341/707"
	oPrint:Say  (nRow2+0644,100,"BANCO ITAU S.A",oFont10 )		// [2]Nome do Banco
	oPrint:Say  (nRow2+0635,513,"341"+"-7",oFont20 )	// [1]Numero do Banco
ElseIf  aDadosBanco[1] == "422"
	oPrint:Say  (nRow2+0644,100,"BANCO SAFRA",oFont10 )		// [2]Nome do Banco
	oPrint:Say  (nRow2+0635,513,aDadosBanco[1]+"-7",oFont20 )	// [1]Numero do Banco
ElseIf  aDadosBanco[1] == "001"
	oPrint:Say  (nRow2+0644,100,"BANCO DO BRASIL",oFont10 )		// [2]Nome do Banco
	oPrint:Say  (nRow2+0635,513,aDadosBanco[1]+"-9",oFont20 )	// [1]Numero do Banco
Else
	oPrint:Say  (nRow2+0644,100,aDadosBanco[2],oFont10 )		// [2]Nome do Banco
	oPrint:Say  (nRow2+0635,513,aDadosBanco[1]+"-9",oFont20 )	// [1]Numero do Banco
EndIf


oPrint:Say  (nRow2+0644,1800,"Recibo do Sacado",oFont10)

oPrint:Line (nRow2+0810,100,nRow2+0810,2300 )
oPrint:Line (nRow2+0910,100,nRow2+0910,2300 )
oPrint:Line (nRow2+0980,100,nRow2+0980,2300 )
oPrint:Line (nRow2+1050,100,nRow2+1050,2300 )

oPrint:Line (nRow2+0910,500,nRow2+1050,500)
oPrint:Line (nRow2+0980,750,nRow2+1050,750)
oPrint:Line (nRow2+0910,1000,nRow2+1050,1000)
oPrint:Line (nRow2+0910,1300,nRow2+0980,1300)
oPrint:Line (nRow2+0910,1480,nRow2+1050,1480)

oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow2+0725,400 ,"PAGAVEL EM QUALQUER BANCO ATE O VENCIMENTO",oFont10)
oPrint:Say  (nRow2+0765,400 ,"APÓS O VENCIMENTO, SOMENTE NO BANCO DO BRASIL",oFont10)

oPrint:Say  (nRow2+0710,1810,"Vencimento"                                     ,oFont8)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0810,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (nRow2+0850,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

If aDadosBanco[1] $ "707"  
	oPrint:Say  (nRow2+0810,1810,"Agência/Código Cedente",oFont8)
	cString := "1248/01624-6"
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0850,nCol,cString,oFont11c)
ElseIf aDadosBanco[1] $ "104"
	oPrint:Say  (nRow2+0810,1810,"Agência/Código Cedente",oFont8)
	cString := Alltrim(aDadosBanco[3]+"/849249")
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0850,nCol,cString,oFont11c)
Else
	oPrint:Say  (nRow2+0810,1810,"Agência/Código Cedente",oFont8)
	cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+'-'+aDadosBanco[5])
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0850,nCol,cString,oFont11c)
EndIf
oPrint:Say  (nRow2+0910,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

If aDadosBanco[1] $ "104" 
	oPrint:Say  (nRow2+0910,505 ,"Nro.Documento"                                  ,oFont8)
	oPrint:Say  (nRow2+0940,605 ,aDadosTit[10]						,oFont10) //Prefixo +Numero+Parcela
Else
	oPrint:Say  (nRow2+0910,505 ,"Nro.Documento"                                  ,oFont8)
	oPrint:Say  (nRow2+0940,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela
EndIf


oPrint:Say  (nRow2+0910,1305,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow2+0940,1400,"N"                                             ,oFont10)

oPrint:Say  (nRow2+0910,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

oPrint:Say  (nRow2+0910,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (nRow2+0980,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (nRow2+0910,1810,"Nosso Número"                                   ,oFont8)
//cString := Alltrim(Substr(aDadosQnab[1],1,7)+Substr(aDadosTit[6],3))
If      aDadosBanco[1] == "001"
	cString := "3058981"+StrZero(Val(Alltrim(aDadosTit[9])),10) 
	oPrint:Say  (nRow2+1010,555 ,"17"                                	,oFont10)		
	oPrint:Say  (nRow2+0940,1050,"DM"									,oFont10) //Tipo do Titulo
ElseIf  aDadosBanco[1] $ "341"
	cString := "157/"+SubStr(Alltrim(aDadosTit[9]),1,8)+'-'+SubStr(Alltrim(aDadosTit[9]),9,1)
	oPrint:Say  (nRow2+1010,555 ,"157"                                	,oFont10)	
	oPrint:Say  (nRow2+0940,1050,"DM"									,oFont10) //Tipo do Titulo
ElseIf  aDadosBanco[1] $ "707"
	cString := "112/"+SubStr(Alltrim(aDadosTit[9]),1,8)+'-'+SubStr(Alltrim(aDadosTit[9]),9,1)
	oPrint:Say  (nRow2+1010,555 ,"112"                                	,oFont10)	
	oPrint:Say  (nRow2+0940,1050,"DM"									,oFont10) //Tipo do T
ElseIf  aDadosBanco[1] == "422"
	cString := Alltrim(aDadosTit[9])
	oPrint:Say  (nRow2+1010,555 ,"070"                                	,oFont10)	
	oPrint:Say  (nRow2+0940,1050,"DM"									,oFont10) //Tipo do T
ElseIf  aDadosBanco[1] == "104"
	cString := "11"+StrZero(Val(Alltrim(aDadosTit[9])),15) 
	_cDACv := modulo11("RG"+cString)
	cString := cString + "-" + AllTrim(Str(_cDACv))	
	oPrint:Say  (nRow2+1010,555 ,"RG"                                	,oFont10)	
	oPrint:Say  (nRow2+0940,1050,"DM"									,oFont10) //Tipo do T	
Else
	oPrint:Say  (nRow2+0940,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
	cString := Alltrim(aDadosTit[9])
	oPrint:Say  (nRow2+1010,555 ,aDadosBanco[6]                                	,oFont10)
EndIf
nCol := 1810+(374-(len(cString)*20))
oPrint:Say  (nRow2+0940,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0980,100 ,"Uso do Banco"                                   ,oFont8)




oPrint:Say  (nRow2+0980,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (nRow2+1010,805 ,"R$"                                             ,oFont10)

oPrint:Say  (nRow2+0980,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow2+0980,1485,"Valor"                                          ,oFont8)

oPrint:Say  (nRow2+0980,1810,"Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)

oPrint:Say  (nRow2+1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
//oPrint:Say  (nRow2+1150,100 ,aBolText[1]+" "+AllTrim(Transform((aDadosTit[5]*0.00),"@E 99,999.99"))       ,oFont10)
//oPrint:Say  (nRow2+1200,100 ,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]*0.05)/30),"@E 99,999.99"))  ,oFont10)
//oPrint:Say  (nRow2+1250,100 ,aBolText[3]                                        ,oFont10)

oPrint:Say  (nRow2+1150,100 , iif(Empty(MV_PAR19),'',StrTran( _cBolText1, '"', '' ))  ,oFont10)
oPrint:Say  (nRow2+1200,100 , iif(Empty(MV_PAR20),'',StrTran( _cBolText2, '"', '' ))  ,oFont10)
oPrint:Say  (nRow2+1250,100 , iif(Empty(MV_PAR21),'',StrTran( _cBolText3, '"', '' ))  ,oFont10)



oPrint:Say  (nRow2+1050,1810,"(-)Desconto/Abatimento"                         ,oFont8)
cString := Alltrim(Transform(MV_PAR22,"@E 99,999,999.99"))         
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+1080,nCol,cString ,oFont11c)
oPrint:Say  (nRow2+1120,1810,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"                                  ,oFont8)
cString := Alltrim(Transform(nAcreDoc,"@E 99,999,999.99"))         
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+1220,nCol,cString ,oFont11c)
oPrint:Say  (nRow2+1260,1810,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (nRow2+1400,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (nRow2+1430,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (nRow2+1483,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow2+1536,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

if aDatSacado[8] = "J"
	oPrint:Say  (nRow2+1589,400 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow2+1589,400 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

oPrint:Say  (nRow2+1589,1850,Substr(aDadosQnab[1],1,7)+Substr(aDadosTit[6],3)  ,oFont10)

oPrint:Say  (nRow2+1605,100 ,"Sacador/Avalista",oFont8)
oPrint:Say  (nRow2+1645,1500,"Autenticação Mecânica",oFont8)

oPrint:Line (nRow2+0710,1800,nRow2+1400,1800 ) 
oPrint:Line (nRow2+1120,1800,nRow2+1120,2300 )
oPrint:Line (nRow2+1190,1800,nRow2+1190,2300 )
oPrint:Line (nRow2+1260,1800,nRow2+1260,2300 )
oPrint:Line (nRow2+1330,1800,nRow2+1330,2300 )
oPrint:Line (nRow2+1400,100 ,nRow2+1400,2300 )
oPrint:Line (nRow2+1640,100 ,nRow2+1640,2300 )


/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := 0

For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+30)
Next nI

oPrint:Line (nRow3+2000,100,nRow3+2000,2300)
oPrint:Line (nRow3+2000,500,nRow3+1920, 500)
oPrint:Line (nRow3+2000,710,nRow3+1920, 710)

If     aDadosBanco[1] == "104"
	oPrint:Say  (nRow3+1934,100,"CAIXA ECONOMICA",oFont10 )		// 	[2]Nome do Banco
	oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-0",oFont20 )	// 	[1]Numero do Banc
ElseIf aDadosBanco[1] $ "707/341"
	oPrint:Say  (nRow3+1934,100,"BANCO ITAU S.A",oFont10 )		// 	[2]Nome do Banco
	oPrint:Say  (nRow3+1925,513,"341"+"-7",oFont20 )	// 	[1]Numero do Banco
ElseIf aDadosBanco[1] == "422"
	oPrint:Say  (nRow3+1934,100,"BANCO SAFRA",oFont10 )		// 	[2]Nome do Banco
	oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-7",oFont20 )	// 	[1]Numero do Banco
ElseIf aDadosBanco[1] == "001"
	oPrint:Say  (nRow3+1934,100,"BANCO DO BRASIL",oFont10 )		// 	[2]Nome do Banco
	oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-9",oFont20 )	// 	[1]Numero do Banco
Else
	oPrint:Say  (nRow3+1934,100,aDadosBanco[2],oFont10 )		// 	[2]Nome do Banco
	oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-9",oFont20 )	// 	[1]Numero do Banco
EndIf	

oPrint:Say  (nRow3+1934,755,aCB_RN_NN[2],oFont15n)			//		Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+2100,100,nRow3+2100,2300 )
oPrint:Line (nRow3+2200,100,nRow3+2200,2300 )
oPrint:Line (nRow3+2270,100,nRow3+2270,2300 )
oPrint:Line (nRow3+2340,100,nRow3+2340,2300 )

oPrint:Line (nRow3+2200,500 ,nRow3+2340,500 )
oPrint:Line (nRow3+2270,750 ,nRow3+2340,750 )
oPrint:Line (nRow3+2200,1000,nRow3+2340,1000)
oPrint:Line (nRow3+2200,1300,nRow3+2270,1300)
oPrint:Line (nRow3+2200,1480,nRow3+2340,1480)

oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow3+2015,400 ,"PAGAVEL EM QUALQUER BANCO ATÉ A DATA DO VENCIMENTO",oFont10)
oPrint:Say  (nRow3+2055,400 ,"APÓS O VENCIMENTO, SOMENTE NO BANCO DO BRASIL",oFont10)
           
oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2100,100 ,"Cedente",oFont8)
oPrint:Say  (nRow3+2140,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

If aDadosBanco[1] $ "707"  
	oPrint:Say  (nRow3+2100,1810,"Agência/Código Cedente",oFont8)
	cString := "1248/01624-6"
	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)
ElseIf aDadosBanco[1] $ "104"  
	oPrint:Say  (nRow3+2100,1810,"Agência/Código Cedente",oFont8)
	cString := Alltrim(aDadosBanco[3])+"/849249"
	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)	
Else	
	oPrint:Say  (nRow3+2100,1810,"Agência/Código Cedente",oFont8)
	cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+'-'+aDadosBanco[5])
	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)
EndIf

oPrint:Say  (nRow3+2200,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say (nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

If     aDadosBanco[1] == "104"
	oPrint:Say  (nRow3+2200,505 ,"Nro.Documento"                                  ,oFont8)
	oPrint:Say  (nRow3+2230,605 ,aDadosTit[10]						,oFont10) //Prefixo +Numero+Parcela
Else 
	oPrint:Say  (nRow3+2200,505 ,"Nro.Documento"                                  ,oFont8)
	oPrint:Say  (nRow3+2230,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela
EndIf		



If     aDadosBanco[1] == "001"
	oPrint:Say  (nRow3+2200,1005,"Espécie Doc."                                    ,oFont8)
	oPrint:Say  (nRow3+2230,1050,"DM"									   ,oFont10) //Tipo do Titulo

	oPrint:Say  (nRow3+2200,1305,"Aceite"                                          ,oFont8)
	oPrint:Say  (nRow3+2230,1400,"N"                                               ,oFont10)

	oPrint:Say  (nRow3+2270,505 ,"Carteira"                                       ,oFont8)
	oPrint:Say  (nRow3+2300,555 ,"17"                                            ,oFont10)	
ElseIf aDadosBanco[1] $ "341"
	oPrint:Say  (nRow3+2200,1005,"Espécie Doc."                                    ,oFont8)
	oPrint:Say  (nRow3+2230,1050,"DM"									   ,oFont10) //Tipo do Titulo

	oPrint:Say  (nRow3+2200,1305,"Aceite"                                          ,oFont8)
	oPrint:Say  (nRow3+2230,1400,"N"                                               ,oFont10)

	oPrint:Say  (nRow3+2270,505 ,"Carteira"                                       ,oFont8)
	oPrint:Say  (nRow3+2300,555 ,"157"                                            ,oFont10)
ElseIf aDadosBanco[1] $ "707"	
	oPrint:Say  (nRow3+2200,1005,"Espécie Doc."                                    ,oFont8)
	oPrint:Say  (nRow3+2230,1050,"DM"									   ,oFont10) //Tipo do Titulo

	oPrint:Say  (nRow3+2200,1305,"Aceite"                                          ,oFont8)
	oPrint:Say  (nRow3+2230,1400,"N"                                               ,oFont10)

	oPrint:Say  (nRow3+2270,505 ,"Carteira"                                       ,oFont8)
	oPrint:Say  (nRow3+2300,555 ,"112"                                            ,oFont10)
ElseIf aDadosBanco[1] == "422"
	oPrint:Say  (nRow3+2200,1005,"Espécie Doc."                                    ,oFont8)
	oPrint:Say  (nRow3+2230,1050,"DM"									   ,oFont10) //Tipo do Titulo

	oPrint:Say  (nRow3+2200,1305,"Aceite"                                          ,oFont8)
	oPrint:Say  (nRow3+2230,1400,"N"                                               ,oFont10)

	oPrint:Say  (nRow3+2270,505 ,"Carteira"                                       ,oFont8)
	oPrint:Say  (nRow3+2300,555 ,"070"                                            ,oFont10)
ElseIf aDadosBanco[1] == "104"
	oPrint:Say  (nRow3+2200,1005,"Espécie Doc."                                    ,oFont8)
	oPrint:Say  (nRow3+2230,1050,"DM"									   ,oFont10) //Tipo do Titulo

	oPrint:Say  (nRow3+2200,1305,"Aceite"                                          ,oFont8)
	oPrint:Say  (nRow3+2230,1400,"N"                                               ,oFont10)

	oPrint:Say  (nRow3+2270,505 ,"Carteira"                                       ,oFont8)
	oPrint:Say  (nRow3+2300,555 ,"RG"                                            ,oFont10)	
Else
	oPrint:Say  (nRow3+2200,1005,"Espécie Doc."                                    ,oFont8)
	oPrint:Say  (nRow3+2230,1050,aDadosTit[8]									   ,oFont10) //Tipo do Titulo

	oPrint:Say  (nRow3+2200,1305,"Aceite"                                          ,oFont8)
	oPrint:Say  (nRow3+2230,1400,"N"                                               ,oFont10)
	    
	oPrint:Say  (nRow3+2270,505 ,"Carteira"                                       ,oFont8)
	oPrint:Say  (nRow3+2300,555 ,aDadosBanco[6]                                  	,oFont10)
EndIf
oPrint:Say  (nRow3+2200,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao


oPrint:Say  (nRow3+2200,1810,"Nosso Número"                                   ,oFont8)
//cString := Alltrim(Substr(aDadosQnab[1],1,7)+Substr(aDadosTit[6],3))

If     aDadosBanco[1] == "001"
	cString := "3058981"+StrZero(Val(Alltrim(aDadosTit[9])),10) 
ElseIf aDadosBanco[1] $ "341"  
	cString := "157/"+SubStr(Alltrim(aDadosTit[9]),1,8)+'-'+SubStr(Alltrim(aDadosTit[9]),9,1)	
ElseIf aDadosBanco[1] $ "707"  
	cString := "112/"+SubStr(Alltrim(aDadosTit[9]),1,8)+'-'+SubStr(Alltrim(aDadosTit[9]),9,1)	
ElseIf aDadosBanco[1] == "422"
	cString := Alltrim(aDadosTit[9])	
ElseIf aDadosBanco[1] == "104"
	cString := "11"+StrZero(Val(Alltrim(aDadosTit[9])),15) 
	_cDACv := modulo11("RG"+cString)
	cString := cString + "-" + AllTrim(Str(_cDACv))
	
EndIf


nCol 	 := 1810+(374-(len(cString)*20))
oPrint:Say  (nRow2+2230,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2270,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (nRow3+2270,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (nRow3+2300,805 ,"R$"                                             ,oFont10)

oPrint:Say  (nRow3+2270,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow3+2270,1485,"Valor"                                          ,oFont8)

oPrint:Say  (nRow3+2270,1810,"Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2340,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
//oPrint:Say  (nRow3+2440,100 ,aBolText[1]+" "+AllTrim(Transform((aDadosTit[5]*0.00),"@E 99,999.99"))      ,oFont10)
//oPrint:Say  (nRow3+2490,100 ,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]*0.05)/30),"@E 99,999.99"))  ,oFont10)
//oPrint:Say  (nRow3+2540,100 ,aBolText[3]                                        ,oFont10)
oPrint:Say  (nRow2+2440,100 , iif(Empty(MV_PAR19),'',StrTran( _cBolText1, '"', '' ))  ,oFont10)
oPrint:Say  (nRow2+2490,100 , iif(Empty(MV_PAR20),'',StrTran( _cBolText2, '"', '' ))  ,oFont10)
oPrint:Say  (nRow2+2540,100 , iif(Empty(MV_PAR21),'',StrTran( _cBolText3, '"', '' ))  ,oFont10)


oPrint:Say  (nRow3+2340,1810,"(-)Desconto/Abatimento"                         ,oFont8)
cString := Alltrim(Transform(MV_PAR22,"@E 99,999,999.99"))
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2370,nCol,cString,oFont11c)
oPrint:Say  (nRow3+2410,1810,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"                                  ,oFont8)
cString := Alltrim(Transform(nAcreDoc,"@E 99,999,999.99"))
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2510,nCol,cString,oFont11c)
oPrint:Say  (nRow3+2550,1810,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (nRow3+2690,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (nRow3+2700,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (nRow3+2753,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow3+2806,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

if aDatSacado[8] = "J"
	oPrint:Say  (nRow3+2859,400,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow3+2859,400,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

//oPrint:Say  (nRow3+2859,1750,Substr(aDadosQnab[1],1,7)+Substr(aDadosTit[6],3)  ,oFont10)

oPrint:Say  (nRow3+2875,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (nRow3+2915,1500,"Autenticação Mecânica - Ficha de Compensação"                        ,oFont8)

oPrint:Line (nRow3+2000,1800,nRow3+2690,1800 )
oPrint:Line (nRow3+2410,1800,nRow3+2410,2300 )
oPrint:Line (nRow3+2480,1800,nRow3+2480,2300 )
oPrint:Line (nRow3+2550,1800,nRow3+2550,2300 )
oPrint:Line (nRow3+2620,1800,nRow3+2620,2300 )
oPrint:Line (nRow3+2690,100 ,nRow3+2690,2300 )

oPrint:Line (nRow3+2910,100,nRow3+2910,2300  )


MSBAR("INT25",25.5,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)

_CodCryp := StrZero(Day(aDadosTit[2]),2) + StrZero(Month(aDadosTit[2]),2) + Right(Str(Year(aDadosTit[2])),4) + "08262121000113"
_vldCryp := MD5(_CodCryp,2)
oPrint:Say      (nRow3+2950,1500,"Gerado pela Alubar AMC - " + _vldCryp  ,oFont8)
cLogoBol := GetSrvProfString("Startpath","") + "LOGOBOL.BMP"


oPrint:SayBitmap(nRow3+3000,1750,cLogoBol,192,192 )

DbSelectArea("SE1")
RecLock("SE1",.f.)
SE1->E1_NUMBCO 	:=	aCB_RN_NN[3]   // Nosso número (Ver fórmula para calculo)
MsUnlock()

oPrint:EndPage() // Finaliza a página

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End                    

D := 10 - (Mod(D,10))

If D = 10
	D := 0
End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MODULO11( cData )
Local cDig, nPos , nAux := 0

    For nPos := 1 To 43
        nAux += Val(SubStr(cData,nPos,1)) * If( nPos<= 3, ( 5-nPos),     ;
                                                If( nPos<=11, (13-nPos),     ;
                                                If( nPos<=19, (21-nPos),     ;
                                                If( nPos<=27, (29-nPos),     ;
                                                If( nPos<=35, (37-nPos),     ;
                                                               (45-nPos) )))))
    Next
    nAux := nAux % 11
    cDig := If( (11-nAux)>9, 1, (11-nAux) )
    
Return ( cDig )



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto,nVlrDoc)

LOCAL cValorFinal := strzero(int(nValor*100),10)
LOCAL nDvnn			:= 0
LOCAL nDvcb			:= 0
LOCAL nDv			:= 0
LOCAL cNN			:= ''
LOCAL cRN			:= ''
LOCAL cCB			:= ''
LOCAL cS			:= ''
LOCAL cFator      := strzero(dVencto - ctod("07/10/97"),4)
LOCAL cCart			:= "17"
LOCAL aDadosQnab    := "1081217" 
Local cDadBB        := "3058981"
Local __cBanc := Substr(cBanco,1,3)  
Local _nDvNum := 0
Local _nDavLv := 0
//-----------------------------
// Definicao do NOSSO NUMERO
// ----------------------------
cS    :=  cAgencia + cConta + cCart + cNroDoc
//cS    := cBanco + '00000' //+ SubStr(cNroDoc,1,2)
nDvnn := modulo10(cS) // digito verifacador Agencia + Conta + Carteira + Nosso Num
cNN   := cCart + cNroDoc //+ AllTrim(Str(nDvnn))

//----------------------------------
//	 Definicao do CODIGO DE BARRAS
//----------------------------------

//cS:= cBanco + cFator + cValorFinal + "000000" + aDadosQnab + cNroDoc + cCart //Subs(cNN,1,11) + Subs(cNN,13,1) + cAgencia + cConta + cDacCC + '000'
//nDvcb := modulo11(cS)
//cCB   := SubStr(cS, 1, 4) + AllTrim(Str(nDvcb)) + SubStr(cS,5,39) // + '000000' + SubStr(cS,19) //+ AllTrim(Str(nDvnn))
//ALERT(cCB)

If   Alltrim(__cBanc) == "001"
	cS:= __cBanc + "9" +cFator + cValorFinal + "000000" + cDadBB + cNroDoc + cCart //Subs(cNN,1,11) + Subs(cNN,13,1) + cAgencia + cConta + cDacCC + '000'
	nDvcb := modulo11(cS)
	cCB   := SubStr(cS, 1, 4) + AllTrim(Str(nDvcb)) + SubStr(cS,5,39) // + '000000' + SubStr(cS,19) //+ AllTrim(Str(nDvnn))
ElseIf  Alltrim(__cBanc) == "341"
	cCart := "157"
	cNN   := cCart + cNroDoc
	cS:= __cBanc + "9" + cFator + cValorFinal + cNN +  cAgencia + cConta + cDacCC + '000' //Subs(cNN,1,11) + Subs(cNN,13,1) + cAgencia + cConta + cDacCC + '000'
	nDvcb := modulo11(cS)
	cCB   := SubStr(cS, 1, 4) + AllTrim(Str(nDvcb)) + SubStr(cS,5,39) // + '000000' + SubStr(cS,19) //+ AllTrim(Str(nDvnn))
ElseIf  Alltrim(__cBanc) == "707"
	cCart := "112"
	cNN   := cCart + cNroDoc
	cS:= "3419" + cFator + cValorFinal + cNN +  "1248" + "01624" + "6" + '000' //Subs(cNN,1,11) + Subs(cNN,13,1) + cAgencia + cConta + cDacCC + '000'
	nDvcb := modulo11(cS)
	cCB   := SubStr(cS, 1, 4) + AllTrim(Str(nDvcb)) + SubStr(cS,5,39) // + '000000' + SubStr(cS,19) //+ AllTrim(Str(nDvnn))	
ElseIf  Alltrim(__cBanc) == "422"
	cS:= __cBanc +"9" + cFator + cValorFinal + "7" +  cAgencia + "00" +cConta + cDacCC +cNroDoc + "2" //Subs(cNN,1,11) + Subs(cNN,13,1) + cAgencia + cConta + cDacCC + '000'
	nDvcb := modulo11(cS)
	cCB   := SubStr(cS, 1, 4) + AllTrim(Str(nDvcb)) + SubStr(cS,5,39) // + '000000' + SubStr(cS,19) //+ AllTrim(Str(nDvnn))	
ElseIf   Alltrim(__cBanc) == "104"
	cS:= __cBanc + "9"  
	_nDvNum := modulo11("RG"+cNroDoc)
	cNroDoc := "11"+StrZero(Val(Alltrim(cNroDoc)),15) 
	cS += AllTrim(Str(_nDvNum)) + cFator + cValorFinal + "8492492" + SubStr(cNroDoc, 3,3) + "1" + SubStr(cNroDoc, 6,3) + "1" + SubStr(cNroDoc, 9,9)
	nDvcb := modulo11(SubStr(cS,20,24))
    cCB   := cS + AllTrim(Str(nDvcb))
Else	
	cS:= __cBanc + "9" +cFator + cValorFinal + "000000" + aDadosQnab + cNroDoc + cCart //Subs(cNN,1,11) + Subs(cNN,13,1) + cAgencia + cConta + cDacCC + '000'
	nDvcb := modulo11(cS)
	cCB   := SubStr(cS, 1, 4) + AllTrim(Str(nDvcb)) + SubStr(cS,5,39) // + '000000' + SubStr(cS,19) //+ AllTrim(Str(nDvnn))
EndIf



//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV

// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao
//	  B = Codigo da moeda, sempre 9
//	CCC = Codigo da Carteira de Cobranca
//	 DD = Dois primeiros digitos no nosso numero
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
If  Alltrim(__cBanc) $ "/341/707/422/"
	cs := Substr(cCB,1,4)+Substr(cCB,20,3)+Substr(cCB,23,2)
	nDv   := modulo10(cS)
	cRN   := SubStr(cS, 1, 5) + '.' + SubStr(cS, 6, 4) + AllTrim(Str(nDv)) + '  '      
ElseIf  Alltrim(__cBanc) $ "/104/"
	cs := Substr(cCB,1,4)+Substr(cCB,20,5)
	nDv   := modulo10(cS)
	cRN   := SubStr(cS, 1, 5) + '.' + SubStr(cS, 6, 4) + AllTrim(Str(nDv)) + '  '      
Else
	cS    := cBanco + '00000' //+ SubStr(cNroDoc,1,2)
	nDv   := modulo10(cS)
	//cRN   := SubStr(cS, 1, 4) + '.' + SubStr(cS, 5, 5) + AllTrim(Str(nDv)) + '  '      
	cRN   := SubStr(cS, 1, 5) + '.' + SubStr(cS, 6, 4) + AllTrim(Str(nDv)) + '  '      
EndIf	

// 	CAMPO 2:
//	DDDDDD = Restante do Nosso Numero
//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
//	   FFF = Tres primeiros numeros que identificam a agencia
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

//AllTrim(Str(nDvcb)) +'.'+ Subs(cCart,2,3) + Subs(cNN,4,2) + SubStr(cRN,11,1)+ ' '+  Subs(cNN,6,5) +'.'+ Subs(cNN,11,1) + Subs(cAgencia,1,4) +Alltrim(Str(nDv)) + ' ' + Alltrim(Str(nDvnn))
If  Alltrim(__cBanc) $  "/341/707/422/001/"
	cS    := Substr(cCB,25,7)+Substr(cCB,32,3)
	nDv   := modulo10(cS)
	cRN := cRN + Substr(cS,1,5)+'.'+Substr(cS,6,5)+Alltrim(Str(nDv)) + ' '
ElseIf  Alltrim(__cBanc) $  "/104/"
	cS    := Substr(cCB,25,10)
	nDv   := modulo10(cS)
	cRN := cRN + Substr(cS,1,5)+'.'+Substr(cS,6,5)+Alltrim(Str(nDv)) + ' '
ElseIf  Alltrim(__cBanc) $  "/104/"

Else 
	cS    := "0"+aDadosQnab + SubStr(cNroDoc,1,2)
	//cS := cBanco// + //+ Alltrim(Str(nDvnn)) //+ Subs(cAgencia,1,4)
	nDv:= modulo10(cS)
	//cRN := cBanco + "9" + '0' + '.' + '00000' + Alltrim(Str(nDvnn)) + ' '
	cRN := cRN + Substr(cS,1,5)+'.'+Substr(cS,6,5)+Alltrim(Str(nDv)) + ' '
EndIf	

//Subs(cCart,1,1)
// 	CAMPO 3:
//	     F = Restante do numero que identifica a agencia
//	GGGGGG = Numero da Conta + DAC da mesma
//	   HHH = Zeros (Nao utilizado)
//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
    
If  Alltrim(__cBanc) $ "/341/707/"
	cS    := Substr(cCB,35,7)+"000"
	nDv:= modulo10(cS)
	cRN := cRN + Substr(cS,1,5) +'.'+ Substr(cS,6,5)+Alltrim(Str(nDv)) + ' '
ElseIf Alltrim(__cBanc) $ "/422/" 
	cS    := Substr(cCB,35,10)
	nDv:= modulo10(cS)
	cRN := cRN + Substr(cS,1,5) +'.'+ Substr(cS,6,5)+Alltrim(Str(nDv)) + ' '		
ElseIf  Alltrim(__cBanc) $ "/104/"
	cS    := Substr(cCB,35,10)
	nDv:= modulo10(cS)
	cRN := cRN + Substr(cS,1,5) +'.'+ Substr(cS,6,5)+Alltrim(Str(nDv)) + ' '
Else
	cS    := SubStr(cNroDoc,3,8)+cCart//cNroDoc //+ Subs(cCB,35,10) + Alltrim(Str(nDvnn)) //Subs(cConta,1,4) +  Subs(cConta,5,1)+Alltrim(cDacCC)+'000'
	nDv   := modulo10(cS)
	//cRN   := cBanco + '0' + '.' + '0000' + Alltrim(Str(nDvnn)) + ' ' + '0' + SubStr(cS, 1, 4) + '.' + SubStr(cS, 5, 5) + Alltrim(Str(nDvnn)) + ' ' + SubStr(cS, 10, 5) + '.' + SubStr(cS, 15, 3) + cCart + Alltrim(Str(nDvnn)) + ' '// aDadosQnab + '00' + Alltrim(Str(nDvnn))// +nD//+ Subs(cAgencia,4,1) + Subs(cConta,1,4) +'.'+ Subs(cConta,5,1)+Alltrim(cDacCC) +'000'+ Alltrim(Str(nDv))
	cRN := cRN + Substr(cS,1,5)+'.'+Substr(cS,6,5)+Alltrim(Str(nDv)) + ' '
EndIf

//	CAMPO 4:
//	     K = DAC do Codigo de Barras      ATE O DIGITO * MACEDO1


If  Alltrim(__cBanc) $ "/341/707/422/"
	cRN   := cRN + ' ' + AllTrim(Str(nDvcb)) + '  '
ElseIf  Alltrim(__cBanc) $ "/104/"	
	cRN   := cRN + ' ' + AllTrim(Str(_nDvNum)) + '  '	
Else
	cRN   := cRN + ' ' + AllTrim(Str(nDvcb)) + '  '
EndIf




// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo      
If  Alltrim(__cBanc) $ "/341/707/422/"
	cRN   := cRN + cFator + StrZero((nValor * 100),14-Len(cFator))
Else
	cRN   := cRN + cFator + StrZero((nValor * 100),14-Len(cFator))
EndIf




Return({cCB,cRN,cNN})


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  MarcaColun  ³Microsiga           º Data ³  10/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MarcaColun (oBrowse,aTitulos)
       
Local nI := 0 

If Len(aTitulos) > 0
	For nI := 1 to Len(aTitulos)
		If aTitulos[nI][1] == " "
			aTitulos[nI][1] := "*"
		Else
			aTitulos[nI][1] := " "
		EndIf	
	Next
EndIf  

Return nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MarcaItem ºAutor  Denis Haruo        º Data ³  10/22/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Marca os itens para serem deletados                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MarcaItem(oBrowse,aTitulos)

If	aTitulos[oBrowse:nAt,1] == ' '
	aTitulos[oBrowse:nAt,1] := "*" 
Else
	aTitulos[oBrowse:nAt,1] := " "
EndIf	

Return nil

