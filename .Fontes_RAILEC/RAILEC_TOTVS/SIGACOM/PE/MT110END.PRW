User Function MT110END()

//Local nNumSC := PARAMIXB[1]       // Numero da SolicitaÃ§Ã£o de compras 
Local nOpca  := PARAMIXB[2]       // 1 = Aprovar; 2 = Rejeitar; 3 = Bloquear 
Local cOpca  := Iif(nOpca==1,'L',Iif(nOpca==2,'R',Iif(nOpca==3,'B','')))

//INOVATIVA SOLUÇÕES - Evandro Lima (10/08/2018) - A atualização abaixo serve pra manter a integridade entre a aprovação via Link e a aprovação via Protheus.

If RecLock("SC1")
	If SC1->C1_APROV $ " ,B,R,L" .And. SC1->C1_QUJE == 0 .And. Empty(SC1->C1_COTACAO) .And. Empty(SC1->C1_RESIDUO)
		SC1->C1_SIGN := SubStr(SC1->C1_SIGN,1,29)+AllTrim(cOpca)
	EndIf
EndIf

Return 
