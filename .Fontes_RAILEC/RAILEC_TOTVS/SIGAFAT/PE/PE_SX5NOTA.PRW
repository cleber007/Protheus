#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SX5NOTA Autor �Rafael Almeida - SIGACORP� Data � 22/01/17  ���
�������������������������������������������������������������������������͹��
���Descricao � valida��o das s�ries das notas fiscais de sa�da que deseja ��� 
���          � considerar no momento da gera��o da NF.                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MATXFUNA.PRX                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function SX5NOTA()
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local lRet:= .F.
Local _cSerMTZ := GetMv("AL_SERMTZ") // Contem o numero de Serio da Fota Fiscal da Alubar Matriz.
Local _cSerMT1 := GetMv("AL_SERMT01") // Contem o numero de Serio da Fota Fiscal da Alubar Matriz.
Local _cSerMT2 := GetMv("AL_SERMT02") // Contem o numero de Serio da Fota Fiscal da Alubar Matriz.
Local _cSerMT3 := GetMv("AL_SERMT03") // Contem o numero de Serio da Fota Fiscal da Alubar Matriz.
Local _cSerFIL := GetMv("AL_SERFIL") // Contem o numero de Serio da Fota Fiscal da Alubar Filial.
Local _cSerFI1 := GetMv("AL_SERFI01") // Contem o numero de Serio da Fota Fiscal da Alubar Filial.
Local _cSerFI2 := GetMv("AL_SERFI02") // Contem o numero de Serio da Fota Fiscal da Alubar Filial.
Local _cSerFI3 := GetMv("AL_SERFI03") // Contem o numero de Serio da Fota Fiscal da Alubar Filial.
Local _lSerNfs := GetMv("AL_SERNFS") // Parametro que Ativa/Desativa a rotina.
Local _cNumMTZ := GetMv("AL_CODMTZ") // Contem o  N�mero da Empresa + Filial da Alubar Matriz.
Local _cNumFIL := GetMv("AL_CODFIL") // Contem o  N�mero da Empresa + Filial da Alubar Filial. 
Local _cEmp		:= FWCodEmp()  //Retorna o c�digo da empresa no caso de estar configurada no leaiute do grupo, sen�o, retorna o grupo de empresas.
Local _cFil 	:= FWCodFil()  //Retorna o c�digo da filial (M0_CODFIL)

cX5CHAVE := "SX5->X5_CHAVE"

If _lSerNfs
	If _cEmp+_cFil == Alltrim(_cNumMTZ)
		If Alltrim(&(cX5CHAVE)) == Alltrim(_cSerMTZ) .Or. Alltrim(&(cX5CHAVE)) == Alltrim(_cSerMT1) .Or. Alltrim(&(cX5CHAVE)) == Alltrim(_cSerMT2) .Or. Alltrim(&(cX5CHAVE)) == Alltrim(_cSerMT3)
			lRet := .T.
		Endif			
	EndIf	
	If _cEmp+_cFil == Alltrim(_cNumFIL) 
		If Alltrim(&(cX5CHAVE)) == Alltrim(_cSerFIL) .Or. Alltrim(&(cX5CHAVE)) == Alltrim(_cSerFI1) .Or. Alltrim(&(cX5CHAVE)) == Alltrim(_cSerFI2) .Or. Alltrim(&(cX5CHAVE)) == Alltrim(_cSerFI3)
			lRet := .T.
		Endif			
	EndIf	
EndIf


Return lRet  
