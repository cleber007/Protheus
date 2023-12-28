#include 'protheus.ch'

//10/05/18- 1.01.05.01.16 - Bloqueio de Pagamento de Títulos e de Fornecedores - FABIO YOSHIOKA
user function F040ADLE() //Fabio Yoshioka - 10/05/18
Local _aRetAdLE := {}
Local _lALBlqPgto:= IIF(UPPER(RTRIM(GETMV("AL_UBLQPGT")))=='S',.T.,.F.)

IF _lALBlqPgto
	If FunName() $ "FINA050/FINA750"
		aAdd(_aRetAdLE,{"BR_VIOLETA","Título Bloq Fin"})
		aAdd(_aRetAdLE,{"BR_PINK","Fornecedor Bloq Fin"})
	EndIf
ENDIF

Return _aRetAdLE