#include 'protheus.ch'

//10/05/18- 1.01.05.01.16 - Bloqueio de Pagamento de Títulos e de Fornecedores - FABIO YOSHIOKA
user function F040URET()//10/05/18 - Fabio Yoshioka

Local _aRetProc := {}
Local _lALBlqPgto:= IIF(UPPER(RTRIM(GETMV("AL_UBLQPGT")))=='S',.T.,.F.)

if _lALBlqPgto
	If FunName() $ "FINA050/FINA750"
		aAdd(_aRetProc,{"!(empty(SE2->E2_ALUSRBL))","BR_VIOLETA"})
		aAdd(_aRetProc,{"!(empty(posicione('SA2',1,XFILIAL('SA2')+SE2->E2_FORNECE+SE2->E2_LOJA,'A2_ALUSRBL')))","BR_PINK"})
	Endif
endiF



Return _aRetProc	
