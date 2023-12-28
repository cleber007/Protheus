#Include "RWMAKE.CH"
#Include "PROTHEUS.CH"

User Function MA030ROT()   
	Local aRetorno := {}
	AAdd(aRetorno,{"Itens Contabeis","U_itemCTB1",0,9,0})
	AAdd(aRetorno,{"Limite de Crédito","U_SCRED050",0,9,0})
	if PermUser('2')
		AAdd(aRetorno,{"Histórico Limite de Crédito","U_HISTLIM",0,9,0})
	Endif
Return(aRetorno)

User Function itemCTB1()
	Local nTotIC := 0

	If MsgNoYes("Esta rotina ira atualizar todos os clientes que nao tenham cadastro nos Itens Contabeis. Deseja continuar?")
		dbSelectarea("SA1")
		SA1->(dbSetorder(1))
		SA1->(dbGotop())

		While !SA1->(Eof())
			dbSelectarea("CTD")
			CTD->(dbSetorder(1))
			CTD->(dbGotop())

			If !CTD->(dbSeek(xFilial("CTD") + SA1->A1_COD + SA1->A1_LOJA))
				While !RecLock("CTD",.T.);EndDo 		 
				CTD->CTD_FILIAL	:= xFilial("CTD")
				CTD->CTD_ITEM   	:= SA1->A1_COD + SA1->A1_LOJA
				CTD->CTD_DESC01	:= SA1->A1_NOME
				CTD->CTD_DESC02	:= SA1->A1_NREDUZ
				CTD->CTD_CLASSE	:= "2"
				CTD->CTD_BLOQ  	:= "2"
				CTD->(msUnlock())
				CTD->(dbCommitAll())
				nTotIC++
			Endif

			dbSelectarea("SA1")
			SA1->(dbSkip())
		Enddo

		Alert(strZero(nTotIC,6,0)+" CLIENTE(S) incluido(s) no Item Contabil!")
	Endif
Return(nil)

//Recebe o tipo 1=Analista de créditos // 2=Permissão de ver os limites concedidos
Static Function PermUser(cTip)
	Local _lUsrAut:=.F.
	Local _cCodUsr:=RetCodUsr()
	Local _cCod:=iif(cTip=='1',ALLTRIM(GetMv("AL_ANALCRE")),ALLTRIM(GetMv("AL_HISTCRE")))  //Códigos de usuários que receberão solicitação de análise de créditos
	if _cCodUsr $ _cCod 
		_lUsrAut:=.T.
	Endif
Return _lUsrAut

