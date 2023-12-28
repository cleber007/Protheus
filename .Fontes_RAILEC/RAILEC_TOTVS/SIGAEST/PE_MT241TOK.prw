#Include "RwMake.Ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT241TOK �Autor  � Sandro Ulisses     � Data �  08/06/04   ���
�������������������������������������������������������������������������͹��
���Descri��o � Ponto de entrada na validacao da inclus�o do movimento in  ���
���          � terno e atualizando a conta cont�bil dos itens             ���
�������������������������������������������������������������������������͹��
���Uso       � GRUPO ALUBAR S/A.                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT241TOK()
Local _lRet := .T.
Local aArea := GetArea()
/*
Local n
DbSelectArea("SI3")
DbSetOrder(1)
DbSeek(xFilial("SI3")+CCC)
If Empty(I3_GRUPO)
   MsgInfo("Campo Grupo n�o pode ficar em branco. Preencha novamente o codigo do produto e verifique se o campo grupo � preenchido automaticamente. Caso contr�rio, Entre em contato com a Contabilidade" +chr(13)+chr(10)+
     		  "Suporte: Verificar o Ponto de Entrada (PE_MT241TOK.PRW) ,"Atencao")
   //MsgInfo("Grupo Contabil do Centro de Custo em branco. Entre em contato com a Contabilidade","Atencao")
   
   _lRet := .F.
   Return(_lRet)
EndIf
DbSelectArea("SB1")
DbSetorder(1)
For n := 1 to Len(aCols)
    
    SB1->(DbSeek(xFilial("SB1")+aCols[n][1]))
    
    If Empty(SB1->(B1_ITEM))
       aCols[n][5] := SB1->B1_CONTAD
    ElseIf LEFT(SB1->B1_TIPO,2) <> "MC"
       aCols[n][5] := SB1->B1_CONTAD
    Else
       aCols[n][5] := Trim(SI3->I3_GRUPO)+Trim(SB1->B1_ITEM)
    EndIf

Next n
*/    

//Denis Haruo
//17/05/2018
//Ponto de entrada para validar se o CCusto foi preenchido
//no cabe�alho da Movimentacao Interna mod 2
//Atendendo o chamado 16223
If alltrim(CCC) == ''
	msgStop("Por favor informe o Centro de Custo.","PE_MT241TOK")
	_lRet := .f.
endif

RestArea(aArea)

Return(_lRet)     // RETORNA PARA D3_CONTA ... LANCAMENTO PADRAO 666-BAIXA REQ ESTOQUE

//********************
USER FUNCTION CADSI3()
//********************

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SI3"

dbSelectArea(cString)
dbSetOrder(1)

AxCadastro(cString,"SI3 - CENTRO DE CUSTOS SIGACTB",cVldAlt,cVldExc)

Return

