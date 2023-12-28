#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MsDocOk º Autor ³ Rafael Almeida(SIGACORP)º Data ³ 15/05/18 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PE para tratamento de informações complementares ao gravar º±±
±±º          ³ um registro no banco de conhecimento                       º±±
±±º          ³ PE receberá como parâmetro (PARAMIXB) um vetor c/ a tabela º±±
±±º          ³ de onde o banco de conhecimt. é chamado e o ID do registro º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATXFUN.PRW - MsDocument()                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MsDocOk()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local _aArea   := GetArea()
	Local AliasAC9 := PARAMIXB[1]//TABELA DO REGISTRO QUE FOI AMARRADO AO CONHECIMENTO 
	Local _cRecno  := PARAMIXB[2]//RECNO  DO REGISTRO QUE FOI AMARRADO AO CONHECIMENTO
	Local _lSalva  := Inclui //CLICOU NA OPÇÃO SALVA
	Local _nDel    := 0 //CONTADOR DE REGISTROS QUE ESTÃO DELETADOS
	Local _nX     // SIMPLES CONTADOR
	Local _lAtvAc9 := SuperGetMV("AL_ATVAC9",.T.,.T.)


	If _lAtvAc9
		If (Alltrim(Upper(FunName())) == "FINA740") .Or. (Alltrim(Upper(FunName())) == "FINA040") //SOMENTE ROTINA DO CONTAS A RECEBER

			If _lSalva

				//SISTEMA IRAR CONTAR QUANTOS REGISTRO ESTÃO DELETADO PARA IDENTIFICAR SE POSSUI SIM OU NÃO ARQUIVO EM ANEXO.
				For _nX := 1 to Len(aCols) 
					If acols[_nX][6] == .T.
						_nDel++
					EndIf
				Next _nX

				DbSelectArea(AliasAC9)
				DbGoTo(_cRecno)

				//ATUALIZA REGISTRO COM A INFORMAÇÃO SE POSSUI ANEXO SIM OU NÃO	
				If Len(aCols) == _nDel
					RecLock(AliasAC9,.F.)
					Replace E1_ANEXO    With " "
					MsUnLock()
				ElseIf Len(aCols) > _nDel
					RecLock(AliasAC9,.F.)
					Replace E1_ANEXO    With "S"
					MsUnLock()
				EndIf
			EndIf  

		ElseIf (Alltrim(Upper(FunName())) == "FINC010") .Or. (Alltrim(Upper(FunName())) == "MATA030") //SOMENTE ROTINA DA POSIÇÃO DO CLIENTE

			If _lSalva

				//SISTEMA IRAR CONTAR QUANTOS REGISTRO ESTÃO DELETADO PARA IDENTIFICAR SE POSSUI SIM OU NÃO ARQUIVO EM ANEXO.
				For _nX := 1 to Len(aCols)
					If acols[_nX][6] == .T.
						_nDel++
					EndIf
				Next _nX

				DbSelectArea(AliasAC9)
				DbGoTo(_cRecno)

				//ATUALIZA REGISTRO COM A INFORMAÇÃO SE POSSUI ANEXO SIM OU NÃO	
				If Len(aCols) == _nDel
					RecLock(AliasAC9,.F.)
					Replace A1_ANEXO    With " "
					MsUnLock()
				ElseIf Len(aCols) > _nDel
					RecLock(AliasAC9,.F.)
					Replace A1_ANEXO    With "S"
					MsUnLock()
				EndIf
			EndIf
			

		ElseIf (Alltrim(Upper(FunName())) == "FINA750") .Or. (Alltrim(Upper(FunName())) == "FINA050") //SOMENTE ROTINA DO CONTAS A PAGAR - Fabio Yoshioka - 08/05/19 - Projeto Financeiro 2019

			If _lSalva

				//SISTEMA IRAR CONTAR QUANTOS REGISTRO ESTÃO DELETADO PARA IDENTIFICAR SE POSSUI SIM OU NÃO ARQUIVO EM ANEXO.
				For _nX := 1 to Len(aCols) 
					If acols[_nX][6] == .T.
						_nDel++
					EndIf
				Next _nX

				DbSelectArea(AliasAC9)
				DbGoTo(_cRecno)

				//ATUALIZA REGISTRO COM A INFORMAÇÃO SE POSSUI ANEXO SIM OU NÃO	
				If Len(aCols) == _nDel
					RecLock(AliasAC9,.F.)
					Replace E2_ANEXO    With " "
					MsUnLock()
				ElseIf Len(aCols) > _nDel
					RecLock(AliasAC9,.F.)
					Replace E2_ANEXO    With "S"
					MsUnLock()
				EndIf
			EndIf  
			
			
		EndIf
	EndIf

	RestArea( _aArea )

Return(Nil)
