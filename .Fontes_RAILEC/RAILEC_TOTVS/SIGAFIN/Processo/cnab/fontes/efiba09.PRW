#Include "RwMake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EFIBA09   �Autor  �Marcio              � Data �  07/10/00   ���
�������������������������������������������������������������������������͹��
���Desc.     � Identificacao do codigo da agencia para o Cnab a Pagar     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Efiba09()

_cRet:=""
/*
IF SEA->EA_MODELO == "31" .and. SUBSTR(SE2->E2_CBARRA,1,3) == "237"
_cRet := Strzero(Val(ALLTRIM(SA2->A2_AGENCIA)),5)

ELSE
*/
IF !EMPTY(SE2->E2_DIGBARR)
	IF SEA->EA_MODELO == "31" .and. SUBSTR(SE2->E2_DIGBARR,1,3) == "237"
		IF EMPTY(SE2->E2_DIGBARR)
			_cRet := Strzero(Val(ALLTRIM(SA2->A2_AGENCIA)),5)
		ELSE
			_cRet := Strzero(Val(ALLTRIM(SUBSTR(SE2->E2_DIGBARR,20,4))),5)
		ENDIF
	ELSEIF SEA->EA_MODELO == "31" .and. SUBSTR(SE2->E2_DIGBARR,1,3) <> "237"
		//_cRet := "00000"
		_cRet:=Strzero(Val(ALLTRIM(SA2->A2_AGENCIA)),5)
		
		
	ELSEIF SEA->EA_MODELO <> "31" .and. Alltrim(SE2->E2_DIGBARR) = ""
		_cRet:=Strzero(Val(ALLTRIM(SA2->A2_AGENCIA)),5)
		/*
		ELSEIF SEA->EA_MODELO <> "31" .AND. EMPTY(SA2->A2_AGENCIA)
		_cRet:="00000"
		Else
		_cRet:=Strzero(Val(ALLTRIM(SA2->A2_AGENCIA)),5)
		*/
	Endif
ELSE
	IF SEA->EA_MODELO == "31" .and. SUBSTR(SE2->E2_LINDIGI,1,3) == "237"
		IF EMPTY(SE2->E2_LINDIGI)
			_cRet := Strzero(Val(ALLTRIM(SA2->A2_AGENCIA)),5)
		ELSE
			_cRet := Strzero(Val(ALLTRIM(SUBSTR(SE2->E2_LINDIGI,3,4))),5)
		ENDIF
	ELSEIF SEA->EA_MODELO == "31" .and. SUBSTR(SE2->E2_LINDIGI,1,3) <> "237"
		//_cRet := "00000"
		_cRet:=Strzero(Val(ALLTRIM(SA2->A2_AGENCIA)),5)
		
		
	ELSEIF SEA->EA_MODELO <> "31" .and. Alltrim(SE2->E2_LINDIGI) = ""
		_cRet:=Strzero(Val(ALLTRIM(SA2->A2_AGENCIA)),5)
	Endif
	
ENDIF


Return(_cRet)
