//Remark: Computadores não cometem erros.                      
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  FA070CAN ºAutor  ³Rafael Almeida       º Data ³   11/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada executado quando os dados da tabela SE1   º±±
±±º          ³ já estão gravado no momento do cancelamento da baixa sendo º±±
±±º          ³ assim podemos manipula os campos de usuarios               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA070 - Rotina cancelamento de Baixa                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA070CAN()

	If SE1->E1_DECCAMB > 0  .OR. SE1->E1_ACRCAMB > 0 
		Reclock("SE1",.F.)
		SE1->E1_SDDECRE := IIF(SE1->E1_DECCAMB > 0, SE1->E1_SDDECRE  - SE1->E1_DECCAMB, SE1->E1_SDDECRE)
		SE1->E1_SDACRES := IIF(SE1->E1_ACRCAMB > 0 ,SE1->E1_SDACRES  - SE1->E1_ACRCAMB, SE1->E1_SDACRES)
		SE1->E1_DECRESC := IIF(SE1->E1_DECCAMB > 0, SE1->E1_DECRESC  - SE1->E1_DECCAMB, SE1->E1_DECRESC)
		SE1->E1_ACRESC 	:= IIF(SE1->E1_ACRCAMB > 0 ,SE1->E1_ACRESC   - SE1->E1_ACRCAMB, SE1->E1_ACRESC)
		SE1->E1_SALDO   := SE1->E1_VALOR
		SE1->E1_DECCAMB := 0
		SE1->E1_ACRCAMB := 0
		SE1->E1_VALBOL 	:= 0
		MSUnlock()
	EndIf	                   
Return()