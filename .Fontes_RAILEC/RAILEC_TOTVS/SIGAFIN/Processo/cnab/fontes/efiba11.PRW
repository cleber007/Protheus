#Include "RwMake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EFIBA11   �Autor  �Marcio              � Data �  07/10/00   ���
�������������������������������������������������������������������������͹��
���Desc.     � Identificacao do numero da conta corrente do fornecedor    ���
���          � a ser utilizado no Cnab a Pagar                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function EFIBA11()

_cRet := ""
IF !EMPTY(SE2->E2_DIGBARR)
	If SEA->EA_MODELO == "31" .AND. SUBSTR(SE2->E2_DIGBARR,1,3) == "237"
		IF EMPTY(SE2->E2_DIGBARR)
			_cRet := Strzero(Val(ALLTRIM(SA2->A2_NumCon)),13)
		ELSE
			_cRet := Strzero(Val(ALLTRIM(SUBSTR(SE2->E2_DIGBARR,39,5))),13)
		ENDIF
	ELSEIf SEA->EA_MODELO == "31" .AND. alltrim(SE2->E2_DIGBARR) <> "" .AND. SUBSTR(SE2->E2_DIGBARR,1,3) <> "237"
		//	_cRet := Replicate("0",13)
		_cRet := Strzero(Val(ALLTRIM(SA2->A2_NumCon)),13)
	ELSEIf SEA->EA_MODELO <> "31" .AND. alltrim(SE2->E2_DIGBARR) = "" //.AND. SUBSTR(SE2->E2_DIGBARR,1,3) <> "237"
		//	_cRet := Replicate("0",13)
		_cRet := Strzero(Val(ALLTRIM(SA2->A2_NumCon)),13)
		/*
		ELSEIf SEA->EA_MODELO == "31" .AND. SUBSTR(SE2->E2_DIGBARR,1,3) == "237"
		_cRet := Strzero(Val(ALLTRIM(SA2->A2_NumCon)),13)
		*/
	Endif
ELSE
	If SEA->EA_MODELO == "31" .AND. SUBSTR(SE2->E2_LINDIGI,1,3) == "237"
		IF EMPTY(SE2->E2_LINDIGI)
			_cRet := Strzero(Val(ALLTRIM(SA2->A2_NumCon)),13)
		ELSE
			_cRet := Strzero(Val(ALLTRIM(SUBSTR(SE2->E2_LINDIGI,26,5))),13)
		ENDIF
	ELSEIf SEA->EA_MODELO == "31" .AND. alltrim(SE2->E2_LINDIGI) <> "" .AND. SUBSTR(SE2->E2_LINDIGI,1,3) <> "237"
		//	_cRet := Replicate("0",13)
		_cRet := Strzero(Val(ALLTRIM(SA2->A2_NumCon)),13)
	ELSEIf SEA->EA_MODELO <> "31" .AND. alltrim(SE2->E2_LINDIGI) = "" //.AND. SUBSTR(SE2->E2_LINDIGI,1,3) <> "237"
		//	_cRet := Replicate("0",13)
		_cRet := Strzero(Val(ALLTRIM(SA2->A2_NumCon)),13)
	Endif
	
ENDIF

Return(_cRet)
