//Remark: Computadores n�o cometem erros.                      
#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  FA070CAN �Autor  �Rafael Almeida       � Data �   11/12/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada executado quando os dados da tabela SE1   ���
���          � j� est�o gravado no momento do cancelamento da baixa sendo ���
���          � assim podemos manipula os campos de usuarios               ���
�������������������������������������������������������������������������͹��
���Uso       � FINA070 - Rotina cancelamento de Baixa                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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