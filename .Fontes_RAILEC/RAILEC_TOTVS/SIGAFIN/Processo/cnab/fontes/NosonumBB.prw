User Function NosoNumBB()

	_cProxNum:= ''
	_cCodEmp := Rtrim(SEE->EE_CODEMP)
	_cNumero := Val(SEE->EE_FAXATU)
	_cFxAtu  := _cNumero +1
	_nTamCod := Len(_cCodEmp)

	If Left(SEE->EE_FAXFIM,_nTamCod)=_cCodEmp
		_nTam    := Len(Alltrim(SEE->EE_FAXATU))
		_cProxNum:= StrZero(_cNumero,_nTam)
	Else
		_nTam    := 17-_nTamCod
		_cProxNum:= _cCodEmp+StrZero(_cNumero,_nTam)
	EndIf

	If Empty(SE1->E1_NUMBCO)

		RecLock("SE1",.f.)
		Replace SE1->E1_NUMBCO With _cProxNum
		SE1->( MsUnlock( ) )
		dbSelectArea("SEE")

		RecLock("SEE",.f.)
		Replace EE_FAXATU With StrZero(_cFxAtu,_nTam)
		SEE->( MsUnlock() )
		dbSelectArea("SE1")

	EndIf

Return(SE1->E1_NUMBCO)
