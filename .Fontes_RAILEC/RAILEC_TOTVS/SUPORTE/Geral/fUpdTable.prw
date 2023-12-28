#Include "PROTHEUS.CH"
/*
+----------------------------------------------------------------------------+
!                       FICHA TECNICA DO PROGRAMA                            !
+------------------+---------------------------------------------------------+
!Tipo              ! Miscelanea                                              !
+------------------+---------------------------------------------------------+
!Modulo            ! Todos                                                   !
+------------------+---------------------------------------------------------+
!Nome              ! fUpdTable                                               !
+------------------+---------------------------------------------------------+
!Descricao         ! Atualizar uma tabela sem derrubar o sistema 		     !
!                  !                                                         !
+------------------+---------------------------------------------------------+
!Autor             ! Rodrigo Lacerda P Araujo                                !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 08/01/2011                                              !
+------------------+---------------------------------------------------------+
*/
User Function fUpdTable()
	Processa({|| fProcessa()},"Aguarde...")
Return

Static Function fProcessa()
	Local oAlias
	Local oAltSX3
	//Local oAviso
	//Local oButton1
	//Local oButton2
	Local oErro
	//Local oGroup1
	Local oSay1
	Private cAlias := space(3)
	Private lTodas := .F.
	Private lAltSX3 := .F.
	Private lErro := .T.
	Private aSX2Alias := {}
	Private aSX3Field := {}
	Static oDlg

	dbSelectArea("SX2")
	dbSetOrder(1)
	ProcRegua(SX2->(RecCount()))

	DEFINE MSDIALOG oDlg TITLE "Atualizando uma tabela sem derrubar o sistema" FROM 000, 000  TO 200, 530 COLORS 0, 16777215 PIXEL

	@ 079, 000 MSPANEL oPanel1 SIZE 250, 020 OF oDlg COLORS 0, 15263976
	@ 000, 000 MSPANEL oPanel2 SIZE 250, 026 OF oDlg COLORS 0, 16777215

	@ 002, 003 SAY oSay1 PROMPT "O objetivo desta ferramenta é atualizar uma ou mais tabelas sem a necessidade de está com o sistema Protheus fechado. A sua utilização é bem simples, selecione uma tabela e clique no botão 'Atualizar'." SIZE 262, 015 OF oPanel2 COLORS 0, 16777215 PIXEL
	@ 017, 002 SAY oSay2 PROMPT "Lembrando que, só será possível executar tal tarefa se a(s) tabela(s) envolvida(s) estiver(em) fechadas." SIZE 262, 008 OF oPanel2 COLORS 0, 16777215 PIXEL
	@ 032, 005 SAY oSay3 PROMPT "Alias" SIZE 016, 007 OF oDlg COLORS 0, 16777215 PIXEL

	@ 023, 000 GROUP oGroup2 TO 079, 250 OF oDlg COLOR 0, 16777215 PIXEL
	@ 029, 021 MSGET oAlias VAR cAlias Picture "@!" SIZE 027, 010 OF oDlg COLORS 0, 16777215 F3 "SX2" PIXEL
	@ 043, 005 CHECKBOX oAltSX3 VAR lAltSX3 PROMPT "opcional - clique aqui para não alterar o SX3" SIZE 118, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 055, 005 CHECKBOX oErro VAR lErro PROMPT "Mostrar erros se houver?" SIZE 126, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 066, 005 CHECKBOX oTodas VAR lTodas PROMPT "Atualizar todas as tabelas" SIZE 126, 008 OF oDlg COLORS 0, 16777215 PIXEL

	//@ 006, 003 SAY oSay4 PROMPT u_fDETFONTE("fUpdTable.prw") SIZE 225, 007 OF oPanel1 COLORS 0, 15263976 PIXEL
	@ 003, 165 BUTTON oOk 		PROMPT "&Atualizar" SIZE 037, 012 OF oPanel1 PIXEL ACTION Processa({|| fAtualiza() },"Aguarde...")
	@ 003, 207 BUTTON oCancelar PROMPT "&Cancelar"  SIZE 037, 012 OF oPanel1 PIXEL ACTION oDlg:End()

	oPanel1:Align := CONTROL_ALIGN_BOTTOM
	oPanel2:Align := CONTROL_ALIGN_TOP
	oGroup2:Align := CONTROL_ALIGN_ALLCLIENT
	oCancelar:Align := CONTROL_ALIGN_RIGHT
	oOk:Align := CONTROL_ALIGN_RIGHT
	ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function fAtualiza()
	Local cAviso
	Local nCnt:=0
	Local cTabelas := ""
	//Atualizando uma tabela sem derrubar o sistema:
	IncProc("Atualizando a estrutura da tabela: " +cAlias)

	if !lAltSX3
		__SetX31Mode(.F.) //opcional - para não permitir alterar o SX3
	Endif

	if !lTodas
		cAviso := X31UpdTable(cAlias) //Atualiza o cAlias baseado no SX3

		if Empty(cAviso)
			MsgInfo("Alias atualizado com sucesso!","Aviso")
		Endif

		If __GetX31Error() //Verifica se ocorreu erro
			if lErro
				Aviso("Erro!!! [X31UpdTable]",__GetX31Trace(),{"Ok"},3)
			Endif
		Endif
	Else
		Do While SX2->(!EOF())
			IncProc("Lendo Tabela "+SX2->X2_CHAVE+" ...")
			aAdd(aSX2Alias ,SX2->X2_CHAVE)
			SX2->(dbSkip())
		EndDo

		ProcRegua(Len(aSX2Alias))

		For nCnt := 1 To Len(aSX2Alias)
			IncProc("Atualizando a estrutura da tabela: " +aSX2Alias[nCnt])

			If Select(aSX2Alias[nCnt])>0
				dbSelecTArea(aSX2Alias[nCnt])
				dbCloseArea()
			EndIf

			X31UpdTable(aSX2Alias[nCnt])

			If __GetX31Error()
				if lErro
					Aviso("Erro!!! [X31UpdTable]",__GetX31Trace()+chr(13)+chr(10)+"Falha na atualizacao da tabela: " + aSX2Alias[nCnt] + ". ",{"Ok"},3)
				Endif
			EndIf

			cTabelas += "Tabela Atualiza: " + aSX2Alias[nCnt] + CHR(13)+CHR(10)
		Next nX

		If Len(aSX2Alias) >0
			Aviso("Aviso!! [X31UpdTable]","Foram atualizados " + AllTrim(str(Len(aSX2Alias))) + " tabelas."+chr(13)+chr(10)+cTabelas,{"Ok"},3)
		EndIf
	Endif

Return
