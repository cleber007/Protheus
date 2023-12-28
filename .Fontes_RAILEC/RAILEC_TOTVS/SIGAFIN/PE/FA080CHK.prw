#include 'protheus.ch'

//10/05/18- 1.01.05.01.16 - Bloqueio de Pagamento de Títulos e de Fornecedores - FABIO YOSHIOKA
user function FA080CHK()
Local _lALBlqPgto:= IIF(UPPER(RTRIM(GETMV("AL_UBLQPGT")))=='S',.T.,.F.)
LOCAL _lFA080CHK:=.T.
lOCAL _aAreaSA2 := GetArea("SA2")

IF _lALBlqPgto //11/05/18
	IF !EMPTY(ALLTRIM(SE2->E2_ALUSRBL))
		MSGINFO("Este título foi Bloqueado pelo usuario "+Rtrim(UsrFullName(SE2->E2_ALUSRBL)) +" em "+DTOC(STOD(SUBSTR(E2_ALUDTBL,1,8)))+" "+SUBSTR(E2_ALUDTBL,9,2)+":"+SUBSTR(E2_ALUDTBL,11,2),"TITULO BLOQUEADO")
		_lFA080CHK:=.F.
	ENDIF
	
	if _lFA080CHK //Consulto bloqueio de Fornecedor
		dbSelectArea("SA2")
		SA2->(dbSetorder(1))
		If dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
			IF !EMPTY(ALLTRIM(SA2->A2_ALUSRBL))
				MSGINFO("o Fornecedor "+rtrim(SA2->A2_NOME)+" foi Bloqueado pelo usuario "+Rtrim(UsrFullName(SA2->A2_ALUSRBL)) +" em "+DTOC(STOD(SUBSTR(SA2->A2_ALUDTBL,1,8)))+" "+SUBSTR(SA2->A2_ALUDTBL,9,2)+":"+SUBSTR(SA2->A2_ALUDTBL,11,2),"FORNECEDOR BLOQUEADO")
				_lFA080CHK:=.F.
			ENDIF
		ENDIF
	Endif

ENDIF	
	
RestArea(_aAreaSA2)
	
return _lFA080CHK