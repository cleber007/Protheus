User Function Agencc()

_cAge     := STRZERO(VAL(SA2->A2_AGENCIA),5)
_cDigAge  := SA2->A2_DIGAGEN
_cConta   := STRZERO(VAL(SA2->A2_NUMCON),12)
If len(Alltrim(SA2->A2_DIGcont)) = 1
	_cDigCont := SA2->A2_DIGcont+" "
else                                
	_cDigCont := SA2->A2_DIGcont
Endif	
 

Return(_cAge+_cDigAge+_cConta+_cDigCont)