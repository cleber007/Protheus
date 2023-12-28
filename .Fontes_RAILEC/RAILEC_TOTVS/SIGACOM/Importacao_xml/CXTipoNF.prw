#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
#INCLUDE "rwmake.ch"

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  � CXTipoNF � Autor � Cirilo Rocha       � Data �  29/03/2012 ���
//�������������������������������������������������������������������������͹��
//���Desc.     � Funcao para retornar a descricao do tipo da NF             ���
//���          �                                                            ���
//���          � Existem 3 retornos possiveis:                              ���
//���          �  1 = Descricao do tipo (segundo parametro obrigatorio)     ���
//���          �  2 = Array com as descricoes dos tipos para NF             ���
//���          �  3 = Array com os tipos de NF validos                      ���
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
User Function CXTipoNF(nRetorno,cTipoNF)
                  
Local nPos			:= 0
Local xRetorno		:= NIL
Local aDescTipos	:= {	"Normal"					,;
								"Devolu��o"				,;
								"Beneficiamento"		,;
								"Compl. ICMS"			,;
								"Compl. IPI"			,;
								"Compl. Pre�o/Frete"	}
Local aTipos		:= {"N","D","B","I","P","C"}

//Retorna a descricao do tipo passado como parametro
If nRetorno == 1
	nPos	:= aScan(aTipos,{ |X| X == cTipoNF })
	If nPos > 0
		xRetorno	:= aDescTipos[nPos]
	EndIf
//Retorna o array com as descricoes dos tipos
ElseIf nRetorno == 2
	xRetorno	:= aClone(aDescTipos)
//Retorna o array com os tipos validos
ElseIf nRetorno == 3
	xRetorno	:= aClone(aTipos)
EndIf

Return xRetorno