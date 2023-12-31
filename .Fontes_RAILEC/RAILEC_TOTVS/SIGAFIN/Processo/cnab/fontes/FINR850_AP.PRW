#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �Finr850   � Autor � Julio Wittwer         � Data � 06.12.99 ���
���          �          � Autor � Jose Novaes           � Data � 20.12.99 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Relatorio do Arquivo de Retorno SISPAG                      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �Finr850()                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAFIN                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FinR850()
LOCAL wnrel   := "FINR850"          //Nome Default do relatorio em Disco
LOCAL cString := "SE2"
LOCAL cDesc1  := "Este programa tem como objetivo imprimir o arquivo"
LOCAL cDesc2  := "Retorno da Comunica��o Banc�ria SISPAG, conforme"
LOCAL cDesc3  := "layout previamente configurado"

//������������������Ŀ
//� Define Variaveis �
//��������������������

//PRIVATE cabec1  := OemToAnsi("PREF NUMERO PAR TP  CNPJ/CPF                FORNECEDOR                                                      VALOR  TIPO                               OCORRENCIA                       VAL PAGO    DATA")
PRIVATE cabec1  := OemToAnsi("PREF NUMERO PAR TP  CNPJ/CPF                FORNECEDOR                                                      VALOR  TIPO                          OCORRENCIA                 STATUS                    VAL PAGO    DATA")
PRIVATE cabec2  := ""
PRIVATE aReturn := {OemToAnsi("Zebrado") , 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE cPerg   := "FIN850"   , nLastKey := 0
PRIVATE nomeprog:= "FINR850"
PRIVATE nTipo
PRIVATE tamanho := "G"

//������������������������������������Ŀ
//� Verifica as perguntas selecionadas �
//��������������������������������������  

If FUNNAME() == "FINA300"
	_ArqRet := MV_PAR04
Endif

pergunte(cPerg,.F.)

PRIVATE Titulo  := OemToAnsi("Impressao do Retorno do SISPAG")

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01            // Arquivo de Entrada                    �
//� mv_par02            // Arquivo de Configuracao               �
//� mv_par03            // Codigo do Banco                       �
//� mv_par04            // Codigo Agencia                        �
//� mv_par05            // Codigo Conta                          �
//� mv_par06            // Codigo SubConta                       �
//����������������������������������������������������������������

//���������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT �
//�����������������������������������������

wnrel:= SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If FUNNAME() == "FINA300"
	MV_PAR01 := _ArqRet
Endif

nTipo:=Iif(aReturn[4]==1,&('GetMv("MV_COMP")'),GetMv("MV_NORM"))

Titulo  := OemToAnsi("Impressao do Retorno do SISPAG  (Arquivo : "+AllTrim(MV_PAR01)+"  Banco: "+Alltrim(MV_PAR03)+"  Ag: "+AllTrim(MV_PAR04)+"  Conta: "+AllTrim(MV_PAR05)+")")

If nLastKey == 27
	Return
End

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

RptStatus( {| lEnd | Fa850Imp(@lEnd,wnRel,cString) } , Titulo )

Set Device to Screen
If aReturn[5] = 1
   Set Printer To
   dbCommitAll()
   Ourspool(wnrel)
End

MS_FLUSH()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � FA850Imp � Autor � Julio Wittwer         � Data � 06.12.99 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Impressao da Comunicacao Bancaria - Retorno SISPAG         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � FA850Imp()                                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FINR850                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC FUNCTION FA850IMP(lEnd,wnRel,cString)

LOCAL aHeadA  := {}, aHead1 := {}, aHead2   := {}
LOCAL aDetA   := {}, aDetB  := {}, aDetJ    := {}
LOCAL aTraiA  := {}, aTrai1 := {}, aTrai2   := {}
LOCAL nBytes  := 0 , nTamArq  := 0 , nLidos  := 0
LOCAL cArqConf:= "", cArqEnt:= "", nHdlConf := 0
LOCAL xBuffer := "", cTabela:= "", cRegistro:= "", cRetorno:= ""
LOCAL cSegmento:= "",cNumtit:= "", cValpag  := "", nRectit:= 0
Local aDetN  := {}
Local aDetO  := {}
Local nTamParc := TamSx3("E2_PARCELA")[1]
Local lAchouTit := .T.
Local nAscan := 0
Local cTabRej := GetMv("MV_TABREJ",,"")

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
Private cbtxt   := SPACE(10)
Private cbcont  := 0
Private li      := 80
Private m_pag   := 1

//��������������������������������������������������������������Ŀ
//� Posiciona no Banco indicado                                  �
//����������������������������������������������������������������
SA6->(dbSeek(xFilial("SA6")+mv_par03+mv_par04+mv_par05))

//��������������������������������������������������������������Ŀ
//� Verifica configuracao Remota                                 �
//����������������������������������������������������������������
If !SEE->(dbSeek(xFilial("SEE")+mv_par03+mv_par04+mv_par05+mv_par06))
	Help(" ",1,"PAR150")
	Return .F.
Endif

//���������������������������������������Ŀ
//� Verifica se a tabela existe           �
//�����������������������������������������
cTabela := Iif( Empty(SEE->EE_TABELA), "17" , SEE->EE_TABELA )

aGetSX5 := FWGetSX5("17")

//���������������������������������������Ŀ
//� Verifica se a tabela existe           �
//�����������������������������������������
If Ascan(aGetSX5, {|x| x[1] + x[3] == xFilial("SX5") + cTabela}) == 0
//If !SX5->( dbSeek( Xfilial("SX5") + cTabela ) )
	Help(" ",1,"PAR150")
	Return .F.
Endif

//��������������������������������Ŀ
//� Leitura da Configuracao SISPAG �
//����������������������������������
cArqConf := alltrim(mv_par02)
If !FILE(cArqConf)
	Help(" ",1,"NOARQPAR")
	Return .F.
Endif
nHdlConf := FOPEN(cArqConf,0)

If nHdlConf < 0
	Help(" ",1,"NOARQUIVO",,cArqConf,5,1)
	Return .F.
Endif

nTamArq := FSEEK(nHdlConf,0,2)
FSEEK(nHdlConf,0,0)
xBuffer := Space(85)

//���������������������������������������������������Ŀ
//� Preenche os arrays de acordo com o Identificador  �
//�����������������������������������������������������
While nBytes < nTamArq

	FREAD(nHdlConf,@xBuffer,85)
	IF SubStr(xBuffer,1,1) == "A" .or. SubStr(xBuffer,1,1) == Chr(1)
      AADD(aHeadA,{  SubStr(xBuffer,02,15),;
                     SubStr(xBuffer,17,03),;
                     SubStr(xBuffer,20,03),;
                     SubStr(xBuffer,23,01),;
                     SubStr(xBuffer,24,60)})
	ElseIf SubStr(xBuffer,1,1) == "B" .or. SubStr(xBuffer,1,1) == Chr(2)
		AADD(aHead1,{  SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
							SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
							SubStr(xBuffer,24,60 ) } )
	ElseIf SubStr(xBuffer,1,1) == "C" .or. SubStr(xBuffer,1,1) == Chr(3)
		AADD(aHead2,{  SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
							SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
							SubStr(xBuffer,24,60 ) } )
	Elseif SubStr(xBuffer,1,1) == "D" .or. SubStr(xBuffer,1,1) == Chr(4)
		AADD(aTrai1,{  SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
							SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
							SubStr(xBuffer,24,60) } )
	Elseif SubStr(xBuffer,1,1) == "E" .or. SubStr(xBuffer,1,1) == Chr(5)
		AADD(aTrai2,{  SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
							SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
							SubStr(xBuffer,24,60) } )
	Elseif SubStr(xBuffer,1,1) == "F" .or. SubStr(xBuffer,1,1) == Chr(6)
		AADD(aTraiA,{  SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
							SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
							SubStr(xBuffer,24,60) } )
	Elseif SubStr(xBuffer,1,1) == "G" .or. SubStr(xBuffer,1,1) == Chr(7)
		AADD(aDetA,{   SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
							SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
							SubStr(xBuffer,24,60) } )
	Elseif SubStr(xBuffer,1,1) == "H" .or. SubStr(xBuffer,1,1) == Chr(8)
		AADD(aDetB,{   SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
							SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
							SubStr(xBuffer,24,60) } )
	Elseif SubStr(xBuffer,1,1) == "J" .or. SubStr(xBuffer,1,1) == Chr(10)
		AADD(aDetJ,{   SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
							SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
							SubStr(xBuffer,24,60) } )
	Elseif SubStr(xBuffer,1,1) == "N" .or. SubStr(xBuffer,1,1) == Chr(16)
		AADD(aDetN,{   SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
			SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
			SubStr(xBuffer,24,60) } )
	Elseif SubStr(xBuffer,1,1) == "O" .or. SubStr(xBuffer,1,1) == Chr(17)
		AADD(aDetO,{   SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
			SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
			SubStr(xBuffer,24,60) } )
	Endif
	nBytes += 85
Enddo
fclose(nHdlConf)

If Len(aHeadA) == 0  .And. Len(aHead1) == 0 .And. Len(aHead2) == 0 ;
		.And. Len(aTrai1) == 0 .And. Len(aTrai2) == 0 ;
		.And. Len(aDetA)  == 0 .And. Len(aDetB)  == 0 ;
		.And. Len(aDetJ)  == 0 .And. Len(aDetN)  == 0 ;
		.And. Len(aDetO)  == 0
	Help(" ",1,"AX044BCO")
	Return .F.
Endif

//���������������������������������Ŀ
//� Abre arquivo enviado pelo banco �
//�����������������������������������
cArqEnt := mv_par01
IF !FILE(cArqEnt)
	Help(" ",1,"NOARQENT")
	Return .F.
Endif
nHdlBco := FOPEN(cArqEnt,0)
If nHdlBco < 0
	Help(" ",1,"NOARQUIVO",,cArqEnt,5,1)
	Return .F.
Endif

//�������������������������������Ŀ
//� Le arquivo enviado pelo banco �
//���������������������������������

nLidos := 0
nTamArq := FSEEK(nHdlBco,0,2)
FSEEK(nHdlBco,0,0)
xBuffer := Space(242)

SetRegua(nTamArq/242)

While nLidos <= nTamArq .and. !lEnd
	
	IF lEnd
		@ PROW()+1, 001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
		Exit
	End
	
	IF li > 58
		cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	End
	//�����������������������������Ŀ
	//� Le linha do arquivo retorno �
	//�������������������������������

	FREAD(nHdlBco,@xBuffer,242)
	nLidos += 242
	IncRegua()
	
	//��������������������������������������Ŀ
	//� Registro:��0 - Header de Arquivo     �
	//�          ����1 - Header de Lote      �
	//�          ��    3 - Detalhes Variados �
	//�          ����5 - Trailler de Lote    �
	//�          ��9 - Trailler de Arquivo   �
	//����������������������������������������
	cRegistro := Subst( xBuffer , Val(aHeada[3,2]) , ;
							    1+Val(aHeada[3,3])-Val(aHeada[3,2]))

	IF cRegistro == "0"
		Loop
	Endif
	If cRegistro == "1"
		Loop
	Endif
	//�������������������������������������������������������������������������Ŀ
	//� Retornos: 00-Credito efetuado BD-Pagamento Agendado  TA-Lote nao aceito �
	//� Retornos: BE-Pagto Agendado c/Forma Alterada p/ OP   RJ-Pagto Rejeitado �
	//� Header de Lote - verificar se houve rejeicao                            �
	//���������������������������������������������������������������������������

	//�������������������������������������������������������������������������Ŀ
	//� Codigos de Rejeicao - TABELA=60                                         �
	//�                                                                         �
	//� AD - Forma de lancamento invalida (Forma X Segmento)                    �
	//� AH - Numero sequencial do registro no lote invalido                     �
	//� AJ - Tipo de movimento invalido                                         �
	//� AL - Codigo do Banco do favorecido ou depositario invalido              �
	//� AM - Agencia do cedente invalido                                        �
	//� AN - Conta corrente do cedente invalido                                 �
	//� AO - Nome do cedente invalido                                           �
	//� AP - Data de lancamento / pagamento invalida                            �
	//� BC - Nosso numero invalido                                              �
	//� IA - Remetente / Motivo invalido                                        �
	//� IB - Valor do titulo invalido                                           �
	//� IC - Valor do abatimento invalido                                       �
	//� ID - Valor do desconto invalido                                         �
	//� IE - Valor da mora invalido                                             �
	//� IF - Valor da multa invalido                                            �
	//� IG - Valor da deducao invalido                                          �
	//� IH - Valor do acrescimo invalido                                        �
	//� II - Data de vecnto invalida                                            �
	//� IJ - Sequencia invalida de segmento                                     �
	//� IK - Codigo de instrucao invalida                                       �
	//� IL - Uso banco invalido para unibanco                                   �
	//� IM - Tipo X Forma nao compativel                                        �
	//� IN - Banco / Agencia nao pertence as pracas de compensacao ITAU         �
	//� IO - Identificacao Tipo de Cheque invalido                              �
	//� IP - Rejeicao do DAC do codigo de barras                                �
	//�                                                                         �
	//���������������������������������������������������������������������������
	If cRegistro == "9"
		//������������������������������������������Ŀ
		//� Final do lote e arquivo - Sai da leitura �
		//��������������������������������������������
		Exit
	Endif

	If cRegistro != "3"
		LOOP
	Endif	

	//�������������������������������������������������������Ŀ
	//� Segmentos opcionais : B                               �
	//� Obs: Segmentos A e J possuem informacoes sobre o      �
	//� retorno.                                              �
	//���������������������������������������������������������
	cSegmento := Subst( xBuffer , Val(aDeta[5,2]) , 1+Val(aDeta[5,3])-Val(aDeta[5,2]) )

	If cSegmento == "A"
		cRetorno   := Subst( xBuffer, Val(aDeta[Len(aDeta),2]) , 1+Val(aDeta[Len(aDeta),3] )-Val(aDeta[Len(aDeta),2]))
		cNumTit    := Subst( xBuffer, Val(aDeta[11,2])         , 1+Val(aDeta[11,3] )-Val(aDeta[11,2]))
		cValPag    := Subst( xBuffer, Val(aDeta[15,2])         , 1+Val(aDeta[15,3] )-Val(aDeta[15,2]))
	ElseIf cSegmento == "J"
		cRetorno   := Subst( xBuffer, Val(aDetJ[Len(aDetJ),2]) , 1+Val(aDetJ[Len(aDetJ),3])-Val(aDetJ[Len(aDetJ),2]))
		cNumTit    := Subst( xBuffer, Val(aDetJ[20,2])         , 1+Val(aDetJ[20,3] )-Val(aDetJ[20,2]))
		cValPag    := Subst( xBuffer, Val(aDetJ[18,2])         , 1+Val(aDetJ[18,3] )-Val(aDetJ[18,2]))
	ElseIf cSegmento == "N"
		cRetorno   := Subst( xBuffer, Val(aDetN[Len(aDetN),2]) , 1+Val(aDetN[Len(aDetN),3])-Val(aDetN[Len(aDetN),2]))
		// Procura a posicao do numero do titulo
		nAscan := Ascan(aDetN, {|e| AllTrim(Upper(e[1]))=="SEU NUMERO"})
		If nAscan > 0
			cNumTit    := Subst( xBuffer, Val(aDetN[nAscan,2])         , 1+Val(aDetN[nAscan,3] )-Val(aDetN[nAscan,2]))
		Else
			ApMsgAlert("Por favor, indique no registro detalhe do arquivo de configura��o segmento N, no nome do campo, o identificador SEU NUMERO utilizado para localizar, no arquivo retorno,o t�tulo a ser baixado")
		Endif	
		nAscan := Ascan(aDetN, {|e| AllTrim(Upper(e[1]))=="PRINCIPAL"})
		If nAscan > 0
			cValPag    := Subst( xBuffer, Val(aDetN[nAscan,2])         , 1+Val(aDetN[nAscan,3] )-Val(aDetN[nAscan,2]))
		Else
			MsgAlert("Por favor, indique no registro detalhe do arquivo de configura��o segmento N, no nome do campo, o identificador PRINCIPAL utilizado para localizar, no arquivo retorno, o valor principal a ser baixado")
		Endif	
	ElseIf cSegmento == "O"
		cRetorno   := Subst( xBuffer, Val(aDetO[Len(aDetO),2]) , 1+Val(aDetO[Len(aDetO),3])-Val(aDetO[Len(aDetO),2]))
		cNumTit    := Subst( xBuffer, Val(aDetO[16,2])         , 1+Val(aDetO[16,3] )-Val(aDetO[16,2]))
		cValPag    := Subst( xBuffer, Val(aDetO[14,2])         , 1+Val(aDetO[14,3] )-Val(aDetO[14,2]))
	Else
		Loop
	Endif
	nvalpag := val(cvalpag)/100

	//���������������������������������������������������������������Ŀ
	//� Verifica se existe o titulo no SE2.                           �
	//�����������������������������������������������������������������
	dbSelectArea("SE2")
	DBORDERNICKNAME("SE2USU")
	//dbSetOrder(11)  // Filial+IdCnab
	//dbSetOrder(1)  // Filial+IdCnab
	nRecTit := Recno()
	lAchouTit := .T.
	If !DbSeek(xFilial("SE2")+Substr(cNumTit,1,13))
	   dbSetOrder(1)
	   If !dbSeek(xFilial("SE2")+Substr(cNumTit,1,12)+SPACE(nTamParc-1)+Substr(cNumTit,13,9))
		  lAchouTit := .F.	
   	   Endif
	Endif	      

	If lAchouTit 
		DbSelectArea("SA2")
		DbSetOrder(1)
		DbSeek(xFilial("SA2")+SE2->E2_FORNECE)
		
		@ li,00 PSAY SE2->E2_PREFIXO+" "+SE2->E2_NUM+" "+SE2->E2_PARCELA
		@ li,16 PSAY SE2->E2_TIPO+" "+If(Len(AllTrim(SA2->A2_CGC))==14, Trans(SA2->A2_CGC,"@R 99.999.999/9999-99"), Trans(SA2->A2_CGC,"@R 999.999.999-99"))
		@ li,44 PSAY AllTrim(SE2->E2_FORNECE)+" "+AllTrim(SA2->A2_NOME)
	Else
		@ li,00 PSAY cNumTit
	Endif
	@ li,100 PSAY nvalpag PICTURE tm(nvalpag,13)
	
	DbSelectArea("SEA")         
	SEA->(DbSetOrder(1))
	SEA->(DbSeek(xFilial("SEA")+SE2->E2_NUMBOR+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA))
		
	//DbSelectArea("SX5") 
	//SX5->(DbSetOrder(1))
	//SX5->(DbSeek(xFilial("SX5")+"58"+SEA->EA_MODELO))
	aGetSX5 := FWGetSX5("58")
	nPosChv := Ascan(aGetSX5, {|x| Alltrim(x[3]) == SEA->EA_MODELO})
	cDesSX5 := ""
	If !Empty(nPosChv)
		cDesSX5 := aGetSX5[nPosSX5,04]
	EndIf
	@ li,115 PSAY SubStr(AllTrim(cDesSX5),1,25)
	
	If fa850rejei(cRetorno,cTabRej) // Trata rejeicao
		li++
		Loop
	Endif
	
	//���������������������������������������������������������������Ŀ
	//� Verifica se existe o titulo no SE2.                           �
	//�����������������������������������������������������������������
	If !lAchouTit
		@ li,145 PSAY OemToAnsi("titulo nao encontrado")
		li++
		dbGoTo(nRecTit)
		Loop
	Endif

	If SE2->E2_SALDO = 0
		@ li,145 PSAY OemToAnsi("Pagamento Efetuado")                 
		@ li,172 PSAY OemToAnsi("Baixa ja processada")
		@ li,192 PSAY SE2->E2_VALLIQ PICTURE "@E 999,999,999.99"
		@ li,210 PSAY SE2->E2_BAIXA
		
		li++
		dbGoTo(nRecTit)
		Loop
	Endif

	//�������������������������������Ŀ
	//� Verifica c�digo da ocorrencia �
	//���������������������������������
	dbSelectArea("SEB")
	dbSeek(xFilial("SEB")+mv_par03+Padr(Substr(cRetorno,1,3),3)+"P")
	IF ! LEFT(SEB->EB_OCORR,2) $ "01/06/07/08"  //Baixa do Titulo
    	@ li,145 PSAY OemToAnsi("OCORRENCIA NAO ENCONTRADA")
	    li++
		Loop
	Else                
	    @ li,145 PSAY OemToAnsi(LEFT(SEB->EB_OCORR,2)+" "+SEB->EB_DESCRI)
		li++	
		If SE2->E2_SALDO = 0
			@ li,172 PSAY OemToAnsi("Baixa ja processada")
			li++		
		Else 
			@ li,172 PSAY OemToAnsi("Aguardando baixa")
			li++			
		Endif	
	Endif	
Enddo

FCLOSE(nHdlBco)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �fA850Rejei� Autor � Julio Wittwer         � Data � 06/12/99 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Trata titulo rejeitado.                                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �fa850Rejei                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function fa850Rejei(cRetString,cTabela)
Local lRet := .T.
Local cDescr := " "
Local nX := 0

IF "00" $ cRetString
	//���������������������������������������������������Ŀ
	//� 00-Credito efetuado                               �
	//�����������������������������������������������������
	lRet := .F.
	//���������������������������������������������������Ŀ
	//� BD-Pagamento Agendado 										�
	//� BE-Pagto Agendado c/Forma Alterada p/ OP				�
	//�����������������������������������������������������
ElseIf ("BD" $ cRetString) 
	@ li,52 PSAY "PAGAMENTO AGENDADO"
ElseIf ("BE" $ cRetString) 
	@ li,52 PSAY "PGTO AGENDADO ALTER. P/ OP"  
ElseIf ("RJ" $ cRetString)                        
	@ li,52 PSAY "TITULO REJEITADO"
	If !Empty(cTabela)
		FOR nX := 3 to Len(Alltrim(cRetString)) Step 2
			cDescr := Left(Tabela(cTabela,Substr(cRetString,nX,2),.F.),30)
			Li++
			If !Empty(cDescr) 
				@ li,52 PSAY cDescr // Imprime o conteudo da tabela de rejeicoes	
			Else
				@ li,52 PSAY "OCORRENCIA NAO ENCONTRADA"
			Endif
		Next			
	Endif			
Endif

Return lRet
