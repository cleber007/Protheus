#Include "RwMake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EFIBA04   �Autor  �Marcio              � Data �  05/10/00   ���
�������������������������������������������������������������������������͹��
���Desc.     � ExecBlock para separacao do CGC / CPF de acordo com o lay -���
���          � out Pag-For (Bradesco)                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function EFIBA04()
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
IF EMPTY(SA2->A2_CGCCNAB) // Caso o campo customizado esteja vazio, faz o tratamento no A2_CGC
	
	IF Len(ALLTRIM(SA2->A2_CGC))== 11
		
		_cRet:=Substr(SA2->A2_CGC,1,9)+"0000"+Substr(SA2->A2_CGC,10,2)
		
	ELSEIF Len(ALLTRIM(SA2->A2_CGC))== 14
		
		_cRet:= Strzero(Val(SA2->A2_CGC),15)
	Endif
ELSE
	_cRet:= Strzero(Val(SA2->A2_CGCCNAB),15) // ...se estiver preenchido, envia as informa��es cadastradas neste campo.
ENDIF

   
Return(_cRet)        
