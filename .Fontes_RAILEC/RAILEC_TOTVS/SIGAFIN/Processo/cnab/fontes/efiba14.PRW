#Include "RwMake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EFIBA14   �Autor  �Marcio              � Data �  07/10/00   ���
�������������������������������������������������������������������������͹��
���Desc.     � Identificacao do codigo do nosso numero, extraido do codigo���
���          � de barras ou da linha digitavel quando o banco for "237"   ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function EFIBA14()

_cRet := ""
_cDigBarr:= SE2->E2_DIGBARR
_cNossoNum:=""
IF !EMPTY(SE2->E2_DIGBARR)
	If SEA->EA_MODELO =="31" .AND. SA2->A2_BANCO =="237"
		if !Empty(_cDigBarr)
			_cNossoNum := Substr(SE2->E2_DIGBARR,26,11) //Substr(SE2->E2_DIGBARR,12,09)+Substr(SE2->E2_DIGBARR,22,02)
		Endif
		_cRet := Strzero(Val(_cNossoNum),12)
	Else
		_cRet := Replicate("0",12)
		
	Endif
ELSE
	If SEA->EA_MODELO =="31" .AND. SA2->A2_BANCO =="237"
		if !Empty(SE2->E2_LINDIGI)
			_cNossoNum := Substr(SE2->E2_LINDIGI,12,11) //Substr(SE2->E2_DIGBARR,12,09)+Substr(SE2->E2_DIGBARR,22,02)
		Endif
		_cRet := Strzero(Val(_cNossoNum),12)
	Else
		_cRet := Replicate("0",12)
		
	Endif
	
ENDIF

Return(_cRet)
