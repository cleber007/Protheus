#Include "RwMake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EFIBA13   �Autor  �Marcio              � Data �  07/10/00   ���
�������������������������������������������������������������������������͹��
���Desc.     � Identificacao do codigo da carteira que e extraido do codi-���
���          � go de barras ou da linha digitavel quando o banco for "237"���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function EFIBA13()

_cRet := ""
_cDigBarr:= SE2->E2_DIGBARR
_cCarteira:=""
IF !EMPTY(SE2->E2_DIGBARR)
If SEA->EA_MODELO =="31" .AND. SA2->A2_BANCO =="237"
	if !Empty(_cDigBarr)
		_cCarteira := Subs(SE2->E2_DIGBARR,24,2) //Subs(SE2->E2_DIGBARR,09,1)+Subs(SE2->E2_DIGBARR,11,1)
	Endif
	_cRet := Strzero(val(_cCarteira),3)
Else
	_cRet :="000"
Endif                     
ELSE
If SEA->EA_MODELO =="31" .AND. SA2->A2_BANCO =="237"
	if !Empty(SE2->E2_LINDIGI)
		_cCarteira := Subs(SE2->E2_LINDIGI,9,1)+ Subs(SE2->E2_LINDIGI,11,1)//Subs(SE2->E2_DIGBARR,09,1)+Subs(SE2->E2_DIGBARR,11,1)
	Endif
	_cRet := Strzero(val(_cCarteira),3)
Else
	_cRet :="000"
Endif                     
ENDIF

Return(_cRet)