User Function F240TBOR()

_cBanco := Paramixb[2]

If _cBanco == "001"
	If !EMPTY(SE2->E2_DIGBARR)
		If left(SE2->E2_DIGBARR,3) == "001"
			DbSelectARea("SEA")
			While !Reclock("SEA");Enddo
			SEA->EA_MODELO := "30"
			MsUnLock()
		Else
			DbSelectARea("SEA")
			While !Reclock("SEA");Enddo
			SEA->EA_MODELO := "31"
			MsUnLock()			
		Endif
	ELSEIf !EMPTY(SE2->E2_LINDIGI)
		If left(SE2->E2_LINDIGI,3) == "001"
			DbSelectARea("SEA")
			While !Reclock("SEA");Enddo
			SEA->EA_MODELO := "30"
			MsUnLock()
		Else
			DbSelectARea("SEA")
			While !Reclock("SEA");Enddo
			SEA->EA_MODELO := "31"
			MsUnLock()		
		Endif
	Else
		SA2->(DbSetOrder(1))
		SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))
		If SA2->A2_BANCO == "001"
			DbSelectARea("SEA")
			While !Reclock("SEA");Enddo
			SEA->EA_MODELO := "01"
			MsUnLock()
		Else
			DbSelectARea("SEA")
			While !Reclock("SEA");Enddo
			SEA->EA_MODELO := "03"
			MsUnLock()
		Endif
	Endif
Else
	If !EMPTY(SE2->E2_DIGBARR) .OR. !EMPTY(SE2->E2_LINDIGI)
		If left(SE2->E2_DIGBARR,3) == "001" .or. left(SE2->E2_LINDIGI,3) == "001"
			DbSelectARea("SEA")
			While !Reclock("SEA");Enddo
			SEA->EA_MODELO := "30"
			MsUnLock()
		Else
			DbSelectARea("SEA")
			While !Reclock("SEA");Enddo
			SEA->EA_MODELO := "31"
			MsUnLock()			
		Endif	
	Else
		SA2->(DbSetOrder(1))
		SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))
		If SA2->A2_BANCO == "237"
			DbSelectARea("SEA")
			While !Reclock("SEA");Enddo
			SEA->EA_MODELO := "01"
			MsUnLock()
		Else
			DbSelectARea("SEA")
			While !Reclock("SEA");Enddo
			SEA->EA_MODELO := "03"
			MsUnLock()
		Endif
	Endif
Endif

Return()