#Include "RwMake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �   �Autor             � Data �  05/10/00                    ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BBCGC()
***********************

_cRet:="" 
_lVal:= .t.

   
/*BEGINDOC
//�����������������������������������������������������������������������������iais\�
//�O campo  A2_CGCCNAB foi criado para os casos em que o CNPJ                  �
//�a ser enviado para o CNAB � diferente do que est� cadastrado no sistema     �
//�isto ocorre por que algumas empresas concentram o pagamento na MATRIZ       �
//�EM 17/08/2011 - CLAUDIO OLIVEIRA.                                           �
//�����������������������������������������������������������������������������iais\�
ENDDOC*/
IF EMPTY(SA2->A2_CGCCNAB)
			
		_cRet:=STRZERO(VAL(SA2->A2_CGC),14)  // Caso o campo customizado esteja vazio, busca no A2_CGC.
		
	ELSE 
		
		_cRet:=STRZERO(VAL(SA2->A2_CGCCNAB),14) // sen�o, pega a informa��o do proprio campo.
Endif

   
Return(_cRet)        
