#Include "RwMake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EFIBA15   �Autor  �Marcio              � Data �  07/10/00   ���
�������������������������������������������������������������������������͹��
���Desc.     � Identificacao do fator de vencimento, extraido do codigo   ���
���          � de barras ou da linha digitavel quando a modalidade for"31"���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function EFIBA15()

_cRet := ""
_cCodBarr:= SE2->E2_DIGBARR //SE2->E2_CBARRA
_cDigBarr:= SE2->E2_DIGBARR
_cFatVenc:=""

//If SEA->EA_MODELO =="31"  .AND. SA2->A2_BANCO !="237"
IF !EMPTY(SE2->E2_DIGBARR)
	If !Empty(_cCodBarr)
		_cFatVenc := Substr(_cDigBarr,6,4)
	Else
		_cFatVenc := strzero(0,4)
    Endif
	_cRet := _cFatVenc
ELSE
	If !Empty(SE2->E2_LINDIGI)
		_cFatVenc := Substr(SE2->E2_LINDIGI,34,4)
	Else
		_cFatVenc := strzero(0,4)
    Endif
	_cRet := _cFatVenc
ENDIF 
Return(_cRet)