#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
//#INCLUDE "ORD.CH"

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������Ŀ��
//���Programa  � CXCtrlArea � Autor � Cirilo Rocha        � Data �19/07/2011���
//�������������������������������������������������������������������������Ĵ��
//���Descricao � Biblioteca para controle de area.                          ���
//���          �                                                            ���
//���          � Existe uma incompatibilidade com bases de dados DBF quando ���
//���          � usados indices temporarios.                                ���
//���          �                                                            ���
//�������������������������������������������������������������������������Ĵ��
//���Uso       � Local aAreas := U_CXGetArea({'SA1','SA2'})                 ���
//���          � U_CXRestArea(aAreas)                                       ���
//�������������������������������������������������������������������������Ĵ��
//���   DATA   � Programador   � Manutencao efetuada                        ���
//�������������������������������������������������������������������������Ĵ��
//��� 27/07/11 � Cirilo Rocha  � Melhorias diversas e performance no fonte  ���
//��� 29/07/11 � Cirilo Rocha  � Tratamento para salvar indices temporarios ���
//��� 08/05/12 � Cirilo Rocha  � Correcao no tratamento do alias corrente   ���
//���          �               � vazio                                      ���
//��� 09/07/12 � Cirilo Rocha  � Feito tratamento para situacoes de:        ���
//���          �               � - Tabela nao estava aberta                 ���
//���          �               � - Alias corrente vazio                     ���
//���          �               �                                            ���
//���          �               �                                            ���
//���          �               �                                            ���
//��������������������������������������������������������������������������ٱ�
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������

Static nAR_ALIAS	:= 01
Static nAR_ORDEM	:= 02
Static nAR_FILTRO	:= 03
Static nAR_RECNO	:= 04
Static nAR_INDICE	:= 05

//---------------------------------------------------------------------------
User Function CXGetArea(aTabelas,lAtual,lLimpaFiltros)

Local aAreas 		:= {}
Local cAliasAtual	:= Alias()
Local cIndiceTmp
Local i

Default lLimpaFiltros	:= .F. //
Default lAtual				:= .T.
Default aTabelas			:= {}

//salva o alias correte, se nao fizer parte do aTabelas
If lAtual .And. ;
	!Empty(cAliasAtual) .And. ;
	aScan(aTabelas,{|x| ValType(x) == 'C' .And. Trim(Upper(x)) == cAliasAtual }) <= 0
	
	aAdd (aTabelas,cAliasAtual)
EndIf

For i := 1 to len(aTabelas)
	If !Empty(aTabelas[i]) .And. ValType(aTabelas[i]) == 'C'
		//A tabela esta aberta entao salva
		If Select(aTabelas[i]) <> 0
			cIndiceTmp	:= AllTrim((aTabelas[i])->(IndexKey()))
			If (aTabelas[i])->(IndexOrd()) <> 0
				cIndiceTmp	:= ''
			EndIf
			aAdd( aAreas , { ;
							    aTabelas[i]               			 	,; //alias
								(aTabelas[i])->(IndexOrd())				,;	//ordem
								AllTrim((aTabelas[i])->(dbFilter()))	,; //expressao de filtro
								(aTabelas[i])->(RECNO())   			   ,; //recno da tabela
								cIndiceTmp						             ; //indice temporario
								} ) 
	
			//Limpa filtros para nao influenciarem no processamento
			If lLimpaFiltros .And. !Empty((aTabelas[i])->(dbFilter()))
				(aTabelas[i])->(dbClearFilter())
			EndIf
		//Tabela nao esta aberta
		Else
			aAdd(aAreas, { ;
								aTabelas[i] 		,; //alias
								-1						,; //ordem para marcar que estava fechada
								NIL					,; //filtro
								NIL					,; //recno
								NIL				 	 ; //indice temporario
							 })
		
		EndIf
	EndIf
Next

//salva o alias correte inclusive vazio
If lAtual// .And. !Empty(cAliasAtual)
	aAdd (aAreas,cAliasAtual)
EndIf

Return aAreas

//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
User Function CXRestArea(aAreas)

Local nTamAreas 	:= len(aAreas)
Local bFiltro
Local i
//Local aAreaSX2

For i := 1 to nTamAreas
	If ValType(aAreas[i]) == 'C' //Salvou o alias correte e precisa restaurar
		If !Empty(aAreas[i])
			dbSelectArea(aAreas[i])
		/*
		Else
			//��������������������������������������������������������������Ŀ
			//� O processo criado para limpar o alias corrente e' o seguinte:�
			//� - Buscar alguma tabela que nao esteja aberta atualmente      �
			//� - Selecionar esta tabela                                     �
			//� - Fechar esta tabela                                         �
			//� Desta forma a area atual nao tera nenhuma tabela setada      �
			//����������������������������������������������������������������
			aAreaSX2		:= U_CXGetArea({'SX2'},.F.,.F.)
			(cAliasTmp)->(dbSetOrder(1))
			(cAliasTmp)->(dbGoTop())
			//Tabela ja esta aberta? pula
			While (cAliasTmp)->(!EOF()) .And. Select((cAliasTmp)->(X2_CHAVE)) <> 0
				(cAliasTmp)->(dbSkip())
			EndDo
			
			//Abre a primeira tabela que nao estiver em uso
			dbSelectArea((cAliasTmp)->(X2_CHAVE))
			dbCloseArea()
			
			U_CXRestArea(aAreaSX2)
			*/
		EndIf
	Else
		//Se a area estava fechada entao fecha antes de sair
		If aAreas[i][nAR_ORDEM] < 0
			If Select(aAreas[i][nAR_ALIAS]) <> 0
				(aAreas[i][nAR_ALIAS])->(DbCloseArea())
			EndIf
			
		//Alias estava aberto entao restaura
		Else
			If aAreas[i][nAR_ORDEM] <> (aAreas[i][nAR_ALIAS])->(IndexOrd()) //Melhoria de performance
				(aAreas[i][nAR_ALIAS])->(dbSetOrder(aAreas[i][nAR_ORDEM]))
			EndIf
	
			//Remonta indice temporario
			If aAreas[i][nAR_ORDEM] == 0    .And. ;	//Indice 0
				!Empty(aAreas[i][nAR_INDICE]) 			//Indice temporario
	
				//Melhoria de performance
				If aAreas[i][nAR_INDICE] <> AllTrim((aAreas[i][nAR_ALIAS])->(IndexKey())) .Or. ;
					aAreas[i][nAR_FILTRO] <> AllTrim((aAreas[i][nAR_ALIAS])->(dbFilter()))
				
					IndRegua(aAreas[i][nAR_ALIAS],,aAreas[i][nAR_INDICE],,aAreas[i][nAR_FILTRO])
				EndIf

			//Remota filtro
			Else
				//Seta filtro se nao for vazio
				If !Empty(aAreas[i][nAR_FILTRO])
					If aAreas[i][nAR_FILTRO] <> AllTrim((aAreas[i][nAR_ALIAS])->(dbFilter()))	 //Melhoria de performance
						bFiltro := &('{|| '+aAreas[i][nAR_FILTRO]+' }')
						&(aAreas[i][nAR_ALIAS])->(dbSetFilter(bFiltro,aAreas[i][nAR_FILTRO]))
					EndIf
				
				//Limpa o filtro apenas se ele existir
				Else
					If !Empty((aAreas[i][nAR_ALIAS])->(dbFilter()))
						(aAreas[i][nAR_ALIAS])->(dbClearFilter())
					EndIf
				EndIf
			EndIf
	
			If aAreas[i][nAR_RECNO] <> (aAreas[i][nAR_ALIAS])->(RECNO()) //Melhoria de performance
				(aAreas[i][nAR_ALIAS])->(dbGoTo(aAreas[i][nAR_RECNO]))
			EndIf
		EndIf
	EndIf
Next

Return
