#Include "RwMake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EFIBA06   �Autor  �Marcio	             � Data �  06/10/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �ExecBlock para efetuar o tratamento da data de vencimento no���
���          �formato de aaaammdd a ser utilizado no Cnab a Pagar do      ���
���          �Bradesco.                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function EFIBA06()

_cRet :=""
_dData := SE2->E2_VENCREA

_nDia := Day(_dData)
_nMes := Month(_dData)
_nAno := Year(_dData)
_cDia := Strzero(_nDia,2)
_cMes := Strzero(_nMes,2)
_cAno := Strzero(_nAno,4)

_cRet:=_cAno+_cMes+_cDia

Return(_cRet)

