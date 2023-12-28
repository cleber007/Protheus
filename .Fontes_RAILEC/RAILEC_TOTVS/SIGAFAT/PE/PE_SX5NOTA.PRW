#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SX5NOTA Autor ³Rafael Almeida - SIGACORPº Data ³ 22/01/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ validação das séries das notas fiscais de saída que deseja º±± 
±±º          ³ considerar no momento da geração da NF.                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATXFUNA.PRX                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SX5NOTA()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
Local _cNumMTZ := GetMv("AL_CODMTZ") // Contem o  Número da Empresa + Filial da Alubar Matriz.
Local _cNumFIL := GetMv("AL_CODFIL") // Contem o  Número da Empresa + Filial da Alubar Filial. 
Local _cEmp		:= FWCodEmp()  //Retorna o código da empresa no caso de estar configurada no leaiute do grupo, senão, retorna o grupo de empresas.
Local _cFil 	:= FWCodFil()  //Retorna o código da filial (M0_CODFIL)

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
