#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MsDocOk � Autor � Rafael Almeida(SIGACORP)� Data � 15/05/18 ���
�������������������������������������������������������������������������͹��
���Descricao � PE para tratamento de informa��es complementares ao gravar ���
���          � um registro no banco de conhecimento                       ���
���          � PE receber� como par�metro (PARAMIXB) um vetor c/ a tabela ���
���          � de onde o banco de conhecimt. � chamado e o ID do registro ���
�������������������������������������������������������������������������͹��
���Uso       � MATXFUN.PRW - MsDocument()                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MsDocOk()

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	Local _aArea   := GetArea()
	Local AliasAC9 := PARAMIXB[1]//TABELA DO REGISTRO QUE FOI AMARRADO AO CONHECIMENTO 
	Local _cRecno  := PARAMIXB[2]//RECNO  DO REGISTRO QUE FOI AMARRADO AO CONHECIMENTO
	Local _lSalva  := Inclui //CLICOU NA OP��O SALVA
	Local _nDel    := 0 //CONTADOR DE REGISTROS QUE EST�O DELETADOS
	Local _nX     // SIMPLES CONTADOR
	Local _lAtvAc9 := SuperGetMV("AL_ATVAC9",.T.,.T.)


	If _lAtvAc9
		If (Alltrim(Upper(FunName())) == "FINA740") .Or. (Alltrim(Upper(FunName())) == "FINA040") //SOMENTE ROTINA DO CONTAS A RECEBER

			If _lSalva

				//SISTEMA IRAR CONTAR QUANTOS REGISTRO EST�O DELETADO PARA IDENTIFICAR SE POSSUI SIM OU N�O ARQUIVO EM ANEXO.
				For _nX := 1 to Len(aCols) 
					If acols[_nX][6] == .T.
						_nDel++
					EndIf
				Next _nX

				DbSelectArea(AliasAC9)
				DbGoTo(_cRecno)

				//ATUALIZA REGISTRO COM A INFORMA��O SE POSSUI ANEXO SIM OU N�O	
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

		ElseIf (Alltrim(Upper(FunName())) == "FINC010") .Or. (Alltrim(Upper(FunName())) == "MATA030") //SOMENTE ROTINA DA POSI��O DO CLIENTE

			If _lSalva

				//SISTEMA IRAR CONTAR QUANTOS REGISTRO EST�O DELETADO PARA IDENTIFICAR SE POSSUI SIM OU N�O ARQUIVO EM ANEXO.
				For _nX := 1 to Len(aCols)
					If acols[_nX][6] == .T.
						_nDel++
					EndIf
				Next _nX

				DbSelectArea(AliasAC9)
				DbGoTo(_cRecno)

				//ATUALIZA REGISTRO COM A INFORMA��O SE POSSUI ANEXO SIM OU N�O	
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

				//SISTEMA IRAR CONTAR QUANTOS REGISTRO EST�O DELETADO PARA IDENTIFICAR SE POSSUI SIM OU N�O ARQUIVO EM ANEXO.
				For _nX := 1 to Len(aCols) 
					If acols[_nX][6] == .T.
						_nDel++
					EndIf
				Next _nX

				DbSelectArea(AliasAC9)
				DbGoTo(_cRecno)

				//ATUALIZA REGISTRO COM A INFORMA��O SE POSSUI ANEXO SIM OU N�O	
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
