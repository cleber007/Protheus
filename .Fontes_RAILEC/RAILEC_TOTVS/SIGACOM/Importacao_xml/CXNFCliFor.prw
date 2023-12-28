#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
#INCLUDE "rwmake.ch"

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  � CXNFCliFor � Autor � Cirilo Rocha      � Data � 30/03/2012 ���
//�������������������������������������������������������������������������͹��
//���Desc.     � Funcao para determinar se a NF (saida ou entrada) deve ser ���
//���          � relacionada ao cadastro de cliente ou fornecedor           ���
//���          �                                                            ���
//���          �                                                            ���
//�������������������������������������������������������������������������͹��
//���   DATA   � Programador   � Manutencao Efetuada                        ���
//�������������������������������������������������������������������������͹��
//���          �               �                                            ���
//���          �               �                                            ���
//���          �               �                                            ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
User Function CXNFCliFor(lSaida,cTipoNF)

Local lCliente	:= Nil

//NF de Saida
If lSaida
	//Devolucao ou Beneficiamento, usa fornecedor
	If cTipoNF $ 'D*B'
		lCliente	:= .F.
	Else
		lCliente	:= .T.
	EndIf
//NF de Entrada
Else
	//Devolucao ou Beneficiamento, usa cliente
	If cTipoNF $ 'D*B'
		lCliente	:= .T.
	Else
		lCliente	:= .F.
	EndIf
EndIf                  

Return lCliente