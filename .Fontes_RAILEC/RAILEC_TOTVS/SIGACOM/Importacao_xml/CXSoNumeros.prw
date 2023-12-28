#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  � CXSoNumeros � Autor � Cirilo Rocha     � Data � 13/09/2011 ���
//�������������������������������������������������������������������������͹��
//���Descricao � Deixa apenas os caracteres numericos na string passada     ���
//���          �                                                            ���
//�������������������������������������������������������������������������͹��
//���Retorno   �                                                            ���
//���          �                                                            ���
//�������������������������������������������������������������������������͹��
//���   DATA   � Programador   � Manutencao Efetuada                        ���
//�������������������������������������������������������������������������͹��
//��� 18/04/12 � Cirilo Rocha  � Feito tratamento para aceitar tambem o ca- ���
//���          �               � ractere 'X' para os casos de agencia com X ���
//���          �               �                                            ���
//���          �               �                                            ���
//���          �               �                                            ���
//���          �               �                                            ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
User Function CXSoNumeros(cString,lDigitoX)

Local cChar := ""
Local nX    := 0
Local cRet	:= ''

Default lDigitoX	:= .F.

For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If IsDigit(cChar)
		cRet	+= cChar
	ElseIf lDigitoX .And. Upper(cChar) == 'X'
		cRet	+= 'X'
	Endif
Next nX

Return cRet
